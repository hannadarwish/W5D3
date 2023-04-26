require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Databse
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class Questions

    def self.find_by_id(id)
        db = QuestionsDatabase.instance
        result = db.execute(<<-SQL, id)
        SELECT *
        FROM questions
        WHERE id = ?
        SQL
        Questions.new(result)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

end