fix_participle_dt <- function(df,
  column,
  ignore_list=c("geplant", "gepland", "ingeplant", "ingepland",
                "gebaad", "gebaat"),
  correct_list=c("geracet", "gefaket", "opgenoemd")) {
  
  # First, we check what participles are in the dataset
  all_participles <- unique(df[[column]])
  # Then, create a frequency table so we can compare forms against each other
  participle_counts <- table(df[[column]])

  # We go over each participle in the dataset one by one
  for (participle in all_participles) {
    # Some forms are ambiguous, so they have to be ignored
    # Other forms most language users just don't spell right...
    if (participle %in% ignore_list | participle %in% correct_list) {
      next
    }
  
    # Get the last character of this participle
    last_char <- substr(participle, nchar(participle), nchar(participle))
    # Get a veresion of this participle without the last character
    participle_bare <- substr(participle, 1, nchar(participle) - 1)
  
    # If the last character of the participle is 'd', consider a form
    # where the last character is 't'
    if (last_char == "d") {
      alternative_form <- paste0(participle_bare, "t")
    # The inverse for 't' (alternative form with 'd')
    } else if (last_char == "t") {
      alternative_form <- paste0(participle_bare, "d")
    # Not eligible, skip
    } else {
      next
    }
  
    # Get the frequencies of both the original and the alternative
    participle_frequency <- participle_counts[participle]
    participle_alternative_frequency <- participle_counts[alternative_form]
  
    # If the alternative is not found in the dataset, 
    # definitely don't consider it
    if (is.na(participle_alternative_frequency) && 
        !(alternative_form %in% correct_list)) {
      next
    }
  
    # If the alternative form is more popular, assume it is correct
    # We replace all wrong attestations with the correct spelling
    if (participle_alternative_frequency > participle_frequency | 
          alternative_form %in% correct_list) {
      df[[column]] <- gsub(participle, alternative_form, df[[column]])
      print(paste0("Replacing '", participle, "' with '", alternative_form,
                   "'"))
    }
  }
}
