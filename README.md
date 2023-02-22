# naive-dt-fix
Fix wrong participle endings in Dutch automatically

## Background on 'dt' errors in Dutch

Language users make mistakes. In Dutch, one of the most common mistakes is the spelling of the verbal past participle. According to the normative literature, the last letter of this participle is dependent on the last sound of the stem of a verb.
- If the last sound of the stem is voiced, the past participle receives the *d* ending. For example, in *gebeuren*, the last sound [r] in stem *gebeur* is voiced. The participle is thus *gebeur**d***.
- If the last sound of the stem is unvoiced, the past participle receives the *t* ending. For example, in *passen*, the last sound [s] in stem *pas* is unvoiced. The past participle is thus *gepas**t***.

There are some cases in which it is confusing for language users what the last sound of the stem actually is. For example, in *razen*, the last sound [z] in stem *raaz* is voiced. However, because in the first person singular *raas*, the ending is devoiced, language users come to think that *raas* is actually the stem, with *s* as its devoiced ending. As a result, they will write *geraast* as the past participle (which is wrong).

Dutch written documents are fraught with these kinds of mistakes. This can make it difficult to conduct linguistic research, since some verbs suddenly appear multiple times in different forms. This small library aims to rectify these mistakes in order to make the aggregation of forms easier.

## How the library works

The proposed solution is inherently flawed in that it relies on the relative frequencies of the participles in dataset you supply. It can be powerful, but it can also make mistakes (hence why the library is called *naive*-dt-fix). So, how does it work?

1. The correction function first creates a list of all unique participles in your dataset.
2. Then, it goes over each unique participle individually.
    - If the participle ends in *d*, it constructs that same participle, but ending in *t*. For example, if it comes across *gedansd*, it creates a form *gedanst* in memory.
    - If the participle ends in *t*, it constructs that same participle, but ending in *d*. For example, if it comes across *ontwikkelt*, it creates a form *ontwikkeld* in memory.
    - If the alternative form in memory is more frequent in your dataset than the original participle, the original participle is replaced with the more frequent form. For example, it is likely that most language users will spell *gedanst* correctly, so the incorrect form *gedansd* will be replaceds.

There are a few problems with this approach. I have tried to rectify these:

- Some forms are ambiguous and can appear both with *d* and with *t*. For example, the participle of *planten* is *geplant*, the participle of *plannen* is *gepland*. It depends on the context of the sentence whether either of these forms is actually spelt correctly. Since this is a *naive* approach, we do not actually look at the context. Still, we do not want *geplant* to be replaced by *gepland* when the latter form is by chance more frequent. This is why the library ships with a list of ambiguous cases. Should your dataset contain an ambiguous pair that is not included automatically in the library, you can overwrite the list yourself.
- Some forms most language users simply cannot spell. This means that the blatantly wrong form is the most frequent, which causes the replacement function to replace all correct forms with wrong ones. This is especially frequent for verbs derived from English. To combat this issue, the library ships with a list of *absolutely correct* participles. Should your dataset contain a very frequently misspelt form that is not included automatically in the library, you can overwrite the list yourself.
- If a correct form does not appear *at all*, incorrect spellings will never be fixed. I built in a makeshift solution for this issue by giving precedence to forms in the list of *absolutely correct* participles, but of course I cannot include every single correct participle manually. The whole purpose of this library is to sidestep these kinds of lists by relying on frequency information. It remains important to always check your output for mistakes.

## How to use the library

Place `naive-dt-fix.R` from this repository in the directory of your R project. Then, in your script, import the R file:
```r
source("naive-dt-fix.R")
```

You can now use the `fix_participle_dt` function. It has two arguments:

| parameter | type    | description                                      | example |
| --------- | ------- | ------------------------------------------------ | -------| 
| `df` | data.frame | the dataframe which contains the column you want to correct | / |
| `column` | character | the name of the column you want to correct | `"participle"` |

The function returns the input data frame with the corrections applied.

```r
df <- fix_participle_dt(df, "deelwoord")
```

Each correction will be announced in the R Console:

```plain
[1] "Replacing 'gebeurt' with 'gebeurd'"
[1] "Replacing 'verandert' with 'veranderd'"
[1] "Replacing 'geraced' with 'geracet'"
```

Check this output for mistakes! The library is by NO means perfect!

## Future work

- extend the built-in lists by collecting all verbal past participles in SoNaR.