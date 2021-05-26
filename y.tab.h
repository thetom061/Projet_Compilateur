/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    t_Main = 258,
    t_Acc_Ouv = 259,
    t_Acc_Ferm = 260,
    t_Const = 261,
    t_Int = 262,
    t_ADD = 263,
    t_String = 264,
    t_SUB = 265,
    t_MUL = 266,
    t_DIV = 267,
    t_AFF = 268,
    t_Par_Ouv = 269,
    t_Par_Ferm = 270,
    t_Virgule = 271,
    t_Fin_Instr = 272,
    t_Print = 273,
    t_Entier = 274,
    t_Var = 275,
    t_If = 276,
    t_Eq = 277,
    t_SupEq = 278,
    t_Sup = 279,
    t_InfEq = 280,
    t_Inf = 281,
    t_Else = 282,
    t_While = 283
  };
#endif
/* Tokens.  */
#define t_Main 258
#define t_Acc_Ouv 259
#define t_Acc_Ferm 260
#define t_Const 261
#define t_Int 262
#define t_ADD 263
#define t_String 264
#define t_SUB 265
#define t_MUL 266
#define t_DIV 267
#define t_AFF 268
#define t_Par_Ouv 269
#define t_Par_Ferm 270
#define t_Virgule 271
#define t_Fin_Instr 272
#define t_Print 273
#define t_Entier 274
#define t_Var 275
#define t_If 276
#define t_Eq 277
#define t_SupEq 278
#define t_Sup 279
#define t_InfEq 280
#define t_Inf 281
#define t_Else 282
#define t_While 283

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 10 "an_gram.y" /* yacc.c:1909  */

       char* variable;
       int valeur;

#line 115 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
