% Licensed under the Apache License, Version 2.0 (the "License"); you may not
% use this file except in compliance with the License. You may obtain a copy of
% the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
% License for the specific language governing permissions and limitations under
% the License.

%%% @author CA Meijer
%%% @copyright 2012 CA Meijer
%%% @doc Mongrel server. This module interacts with MongoDB. It presents a similar API to the
%%%      mongo module of the MongoDB driver.
%%% @end

-module(mongrel).

%% API
-export([insert/1,
		 find_one/1]).

%% External functions
insert(Record) ->
	Documents = mongrel_mapper:map(Record),
	[mongo:insert(Collection, Document) || {Collection, Document} <- Documents].

find_one(RecordSelector) ->
	[{Collection, Selector}] = mongrel_mapper:map(RecordSelector),
	{Res} = mongo:find_one(Collection, Selector),
	CallbackFunc = fun(Coll, Id) ->
						   {Reference} = mongo:find_one(Coll, Id),
						   Reference
				   end,
	mongrel_mapper:unmap(Collection, Res, CallbackFunc).

%% Internal functions

