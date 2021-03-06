class CreateTraineeDistributions < ActiveRecord::Migration[5.1]
  def change
    create_table :trainee_distributions, id: :uuid do |t|
      t.references :training, type: :uuid, foreign_key: true
      t.references :organization_unit, type: :uuid, foreign_key: true
      t.integer :number_of_trainees

      t.timestamps
    end
  end
end
