function d = translateRawExerciseStudentHistory(rawData)
  d.data = int8(parsing.reformatDataWithSubparts(rawData));
  [d.lengths, d.starts, d.ids] = parsing.getStudentBoundriesWithIds(rawData);
  d.resources = int16(parsing.getResources(rawData));
end
