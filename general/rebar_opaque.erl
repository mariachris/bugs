-module(rebar_opaque).
-export([consult/1]).

consult(Str) when is_list(Str) ->
    consult([], Str, []).

consult(Cont, Str, Acc) ->
    case erl_scan:tokens(Cont, Str, 0) of
        {done, Result, Remaining} ->
            case Result of
                {ok, Tokens, _} ->
                    {ok, Term} = erl_parse:parse_term(Tokens),
                    consult([], Remaining, [Term | Acc]);
                {eof, _Other} ->
                    lists:reverse(Acc)
            end;
        {more, Cont1} ->
            consult(Cont1, eof, Acc)
    end.
