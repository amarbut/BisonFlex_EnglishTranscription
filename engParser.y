/***
 Purpose: provides one possible phonetic transcription of the string of
 letters entered according to English spelling and phonetic rules. Some
 combinations of letters are disallowed according to English spelling
 convention or for simplicity's sake.
**/

%{
#include <iostream>
#include <map>
#include <cstring>
#include <string>

extern "C" int yylex();
extern "C" int yyparse();

void yyerror(const char *s){
   fprintf (stderr, "%s\n", s);
 }

// Helper function to compare const char * for map iterator
class StrCompare {
public:
  bool operator ()(const char*a, const char*b) const {
	return strcmp(a,b) < 0;
  }
};

std::map<char*, int, StrCompare> var_to_int;

%}

/*** union of all possible data return types from grammar ***/
%union {
	char* sVal;
}

/*** Define token identifiers for flex regex matches ***/

%token EOL
%token SP
%token PREP
%token MODAL
%token PRON
%token DET
%token NOT
%token THAT
%token THIS
%token TO
%token COMP
%token QUEST
%token CONJ
%token NEG
%token ED
%token VERB
%token ADV
%token ADJ
%token NOUN
%token GER

/*** Define return type for grammar rules ***/

%type<sVal>EOL
%type<sVal>PREP
%type<sVal>MODAL
%type<sVal>PRON
%type<sVal>NOT
%type<sVal>DET
%type<sVal>THAT
%type<sVal>THIS
%type<sVal>TO
%type<sVal>COMP
%type<sVal>QUEST
%type<sVal>CONJ
%type<sVal>NEG
%type<sVal>ED
%type<sVal>VERB
%type<sVal>ADV
%type<sVal>ADJ
%type<sVal>NOUN
%type<sVal>GER

%type<sVal>sentence
%type<sVal>conjquestion
%type<sVal>question
%type<sVal>qp
%type<sVal>conjstatement
%type<sVal>statement
%type<sVal>conjdp
%type<sVal>dp
%type<sVal>det
%type<sVal>conjmp
%type<sVal>mp
%type<sVal>modal
%type<sVal>np
%type<sVal>adjp
%type<sVal>adj
%type<sVal>nomp
%type<sVal>noun
%type<sVal>pronoun
%type<sVal>cp
%type<sVal>comp
%type<sVal>pp
%type<sVal>prep
%type<sVal>advp
%type<sVal>conjvp
%type<sVal>vp
%type<sVal>verb

%%

begin: sentence EOL {
				 printf("%s\n\n", $1); 
			 } begin
	 | /* NULL */
	 ;

sentence: conjquestion{
            char open[] = "[Q ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(open)+strlen($1)+2);
            strcpy($$, open);
            strcat($$, $1);
            strcat($$, close);
      }
        | conjstatement {
            char open[] = "[S ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(open)+strlen($1)+2);
            strcpy($$, open);
            strcat($$, $1);
            strcat($$, close);
      }
        

conjquestion: conjquestion CONJ SP question {
                char space[] = " ";
                $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
                strcpy($$, $1);
                strcat($$, space);
                strcat($$, $2);
                strcat($$, space);
                strcat($$, $4);
            }
            | question
        
question: qp question {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+2);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
        }
        | qp conjstatement {
            char sopen[] = "[S ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(sopen)+strlen($1)+strlen($2)+2);
            strcpy($$, $1);
            strcat($$, sopen);
            strcat($$, $2);
            strcat($$, close);
        }
        | qp dp question {
            char dpopen[] = "[DP ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(dpopen)+strlen($1)+strlen($2)+strlen($3)+2);
            strcpy($$, $1);
            strcat($$, dpopen);
            strcat($$, $2);
            strcat($$, close);
            strcat($$, $3);
        }
        | qp conjmp {
            char mpopen[] = "[MP ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(mpopen)+strlen($1)+strlen($2)+2);
            strcpy($$, $1);
            strcat($$, mpopen);
            strcat($$, $2);
            strcat($$, close);
        }
        | MODAL SP conjstatement {
            char sopen[] = "[S ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(sopen)+strlen($1)+strlen($3)+2);
            strcpy($$, $1);
            strcat($$, sopen);
            strcat($$, $3);
            strcat($$, close);
        }

qp: QUEST SP {
        $$ = $1;
    }
    |COMP SP {
        $$ = $1;
    }
        
conjstatement: conjstatement CONJ SP statement {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
         }
         | statement

statement: conjdp conjmp {
            char dpopen[] = "[DP ";
            char mpopen[] = "[MP ";
            char space[] = " ";
            char close[] = "]";
            $$ = (char*)malloc(strlen(dpopen)+strlen(mpopen)+strlen($1)+strlen($2)+3);
            strcpy($$, dpopen);
            strcat($$, $1);
            strcat($$, close);
            strcat($$, mpopen);
            strcat($$, $2);
            strcat($$, close);
         }
         
conjdp: conjdp CONJ SP dp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcat($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | dp

dp: det np {
        char npopen[] = "[NP ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(npopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, npopen);
        strcat($$, $2);
        strcat($$, close);
  } 
  | np {
        char npopen[] = "[NP ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(npopen)+strlen($1)+2);
        strcpy($$, npopen);
        strcat($$, $1);
        strcat($$, close);
  }

det: DET SP {
        $$ = $1;
    }
    | THAT SP {
        $$ = $1;
    }
    | THIS SP {
        $$ = $1;
    }
  
np: adjp nomp {
        char adjopen[] = "[ADJ ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(adjopen)+strlen($1)+strlen($2)+3);
        strcpy($$, adjopen);
        strcat($$, $1);
        strcat($$, close);
        strcat($$, space);
        strcat($$, $2);
  }
  | nomp

nomp: noun
    | pronoun
    | noun cp {
        char cpopen[] = "[CP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(cpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, cpopen);
        strcat($$, $2);
        strcat($$, close);
    }
    | noun pp {
        char ppopen[] = "[PP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(ppopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, ppopen);
        strcat($$, $2);
        strcat($$, close);
    }
    
noun: NOUN SP {
        $$ = $1;
    }
    | GER SP {
        $$ = $1;
    }
    
pronoun: PRON SP {
        $$ = $1;
    }
    | THIS SP {
        $$ = $1;
    }
    | THAT SP {
        $$ = $1;
    }

cp: comp conjstatement {
        char sopen[] = "[S ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(sopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, sopen);
        strcat($$, $2);
        strcat($$, close);
 }
 | comp conjmp {
        char mpopen[] = "[MP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(mpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, mpopen);
        strcat($$, $2);
        strcat($$, close);
 }

comp: COMP SP {
        $$ = $1;
    }
    | THAT SP {
        $$ = $1;
    }
  
pp: pp CONJ SP prep conjdp {
        char dpopen[] = "[DP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(dpopen)+strlen($1)+strlen($2)+strlen($4)+strlen($5)+4);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
        strcat($$, dpopen);
        strcat($$, $5);
        strcat($$, close);
  }
  | prep conjdp {
        char dpopen[] = "[DP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(dpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, dpopen);
        strcat($$, $2);
        strcat($$, close);
  }

prep: PREP SP {
        $$ = $1;
    }
    | TO SP {
        $$ = $1;
    }

adjp: adjp adj {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | advp adj {
        char advpopen[] = "[ADVP ";
        char close[] = "]";
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+3);
        strcpy($$, advpopen);
        strcat($$, $1);
        strcat($$, close);
        strcat($$, space);
        strcat($$, $2);
    }
    | adjp CONJ SP adj {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
    }
    | adj

adj: ADJ SP {
        $$ = $1;
    }
    | GER SP {
        $$ = $1;
    }
    | ED SP {
        $$ = $1;
    }

conjmp: conjmp CONJ SP mp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | mp
  
mp: modal conjvp {
        char vpopen[] = "[VP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(vpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, vpopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | modal advp conjvp {
        char vpopen[] = "[VP ";
        char advpopen[] = "[ADVP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(vpopen)+strlen(advpopen)+strlen($1)+strlen($2)+strlen($3)+3);
        strcpy($$, $1);
        strcat($$, advpopen);
        strcat($$, $2);
        strcat($$, vpopen);
        strcat($$, $3);
        strcat($$, close);
        strcat($$, close);
  }
  | conjvp {
        char vpopen[] = "[VP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(vpopen)+strlen($1)+1);
        strcpy($$, vpopen);
        strcat($$, $1);
        strcat($$, close);
  }

advp: advp ADV SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
    }
    | advp CONJ SP ADV SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $2);
        strcat($$, space);
        strcat($$, $4);
    }
    | ADV SP {
        $$ = $1;
    }
  
modal: MODAL SP {
        $$ = $1;
    }
    | TO SP {
        $$ = $1;
    }
    | MODAL SP NOT SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
    | NOT SP TO SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
  
conjvp: conjvp CONJ SP vp {
            char space[] = " ";
            $$ = (char*)malloc(strlen($1)+strlen($2)+strlen($4)+3);
            strcpy($$, $1);
            strcat($$, space);
            strcat($$, $2);
            strcat($$, space);
            strcat($$, $4);
      }
      | vp
  
vp: verb pp {
        char ppopen[] = "[PP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(ppopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, ppopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb conjmp {
        char mpopen[] = "[MP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(mpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, mpopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb conjdp {
        char dpopen[] = "[DP ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(dpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, dpopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb cp {
        char cpopen[] = "[CP ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(cpopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, cpopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb adjp {
        char adjopen[] = "[ADJ ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(adjopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, adjopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb advp {
        char adjopen[] = "[ADV ";
        char space[] = " ";
        char close[] = "]";
        $$ = (char*)malloc(strlen(adjopen)+strlen($1)+strlen($2)+2);
        strcpy($$, $1);
        strcat($$, adjopen);
        strcat($$, $2);
        strcat($$, close);
  }
  | verb
    
  
verb: VERB SP {
        $$ = $1;
    }
    | MODAL SP {
        $$ = $1;
    }
    | MODAL SP NOT SP {
        char space[] = " ";
        $$ = (char*)malloc(strlen($1)+strlen($3)+2);
        strcpy($$, $1);
        strcat($$, space);
        strcat($$, $3);
    }
    | GER SP {
        $$ = $1;
    }
    | ED SP {
        $$ = $1;
    }

%%

int main(int argc, char **argv) {
	yyparse();
}

/* Display error messages */
void yyerror(char *s) {
	printf("ERROR: %s\n", s);
}
