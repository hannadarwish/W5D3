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

        # Question.all.each {|row| return Question.new(row) if row['id'] == id}
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