require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class Question
    attr_accessor :id, :title, :body, :author_id
    def self.all
        db = QuestionsDatabase.instance
        results = db.execute("SELECT * FROM questions") # <<-SQL ... SQL
        results.map {|row| Question.new(row)}
    end

    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
        SELECT *
        FROM questions
        WHERE id = ?
        SQL
        Question.new(result[0])

        # Question.all.each {|question| return question if question.id == id}
    end

    def self.find_by_author_id(author_id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        result.map do |row|
            Question.new(row)
        end
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def followers 
        QuestionFollow.followers_for_question_id(id)
    end
end

class User
    attr_accessor :id, :fname, :lname
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        User.new(result[0])
    end

    def initialize(options) # OPTIONS is a hash
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_name(fname, lname)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        result.map do |row|
            User.new(row)
        end
    end

    def authored_questions
        Question.find_by_author_id(id) #array of q instances
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end
end

class QuestionFollow
    attr_accessor :id, :user_id, :question_id
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        QuestionFollow.new(result[0])
    end

    def self.followers_for_question_id(question_id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, question_id)
            SELECT
                users.*
            FROM
                question_follows
            JOIN
                users ON users.id = question_follows.user_id
            WHERE
                question_id = ?
        SQL
        result.map do |row|
            User.new(row)
        end
    end

    def self.followed_questions_for_user_id(user_id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, user_id)
            SELECT
                questions.*
            FROM
                question_follows
            JOIN
                questions ON questions.id = question_follows.question_id
            WHERE
                user_id = ?
        SQL
        result.map do |row|
            Question.new(row)
        end
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end

class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        Reply.new(result[0])
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end

    def self.find_by_user_id(user_id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                replies
            WHERE author_id = ?
        SQL
        result.map do |row|
            Reply.new(row)
        end
    end

    def self.find_by_question_id(question_id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            replies
        WHERE question_id = ?
        SQL
        result.map do |row|
            Reply.new(row)
        end
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end

    def child_replies
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
            *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        result.map do |row|
            Reply.new(row)
        end
    end
end

class QuestionLike
    attr_accessor :id, :user_id, :question_id
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        QuestionLike.new(result[0])
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end

class Tag
    attr_accessor :id, :name
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                tags
            WHERE
                id = ?
        SQL
        Tag.new(result[0])
    end

    def initialize(options)
        @id = options['id']
        @name = options['name']
    end
end

class QuestionTag
    attr_accessor :id, :question_id, :tag_id
    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_tags
            WHERE
                id = ?
        SQL
        QuestionTag.new(result[0])
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @tag_id = options['tag_id']
    end
end