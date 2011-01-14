# encoding: utf-8
#
# Author::    Paweł Wilk (mailto:pw@gnu.org)
# Copyright:: (c) 2011 by Paweł Wilk
# License::   This program is licensed under the terms of {file:LGPL GNU Lesser General Public License} or {file:COPYING Ruby License}.
# 
# This file contains inline documentation data
# that would make the file with code less readable
# if placed there.
# 

module I18n
  # @version 1.2
  # This module contains inflection classes and modules for enabling
  # the inflection support in I18n translations.
  # Its submodule overwrites the Simple backend translate method
  # so that it will interpolate additional inflection tokens present
  # in translations. These tokens may appear in *patterns* which
  # are contained within <tt>@{</tt> and <tt>}</tt> symbols.
  # 
  # == Usage
  #   require 'i18-inflector'
  #   
  #   i18n.translate('welcome', :gender => :f)
  #   # => Dear Madam
  #   
  #   i18n.inflector.kinds
  #   # => [:gender]
  # 
  #   i18n.inflector.true_tokens.keys
  #   # => [:f, :m, :n]
  #
  # == Inflection pattern
  # An example inflection pattern contained in a translation record looks like:
  #   welcome: "Dear @{f:Madam|m:Sir|n:You|All}"
  # 
  # The +f+, +m+ and +n+ are inflection *tokens* and +Madam+, +Sir+, +You+ and
  # +All+ are *values*. Only one value is going to replace the whole
  # pattern. To select which one an additional option is used. That option
  # must be passed to translate method.
  # 
  # == Configuration
  # To recognize tokens present in patterns this module uses keys grouped
  # in the scope called `inflections` for a given locale. For instance
  # (YAML format):
  #   en:
  #     i18n:
  #       inflections:
  #         gender:
  #           f:      "female"
  #           m:      "male"
  #           n:      "neuter"
  #           woman:  @f
  #           man:    @m
  #           default: n
  # 
  # Elements in the example above are:
  # * +en+: language
  # * +i18n+: configuration scope
  # * +inflections+: inflections configuration scope
  # * +gender+: kind scope
  # * +f+, +m+, +n+: inflection tokens
  # * <tt>"male"</tt>, <tt>"female"</tt>, <tt>"neuter"</tt>: tokens' descriptions
  # * +woman+, +man+: inflection aliases
  # * <tt>@f</tt>, <tt>@m</tt>: pointers to real tokens 
  # * +default+: default token for a kind +gender+
  # 
  # === Kind
  # Note the fourth scope selector in the example above (+gender+). It's called
  # the *kind* and contains *tokens*. We have the kind
  # +gender+ to which the inflection tokens +f+, +m+ and +n+ are
  # assigned.
  # 
  # You cannot assign the same token to more than one kind.
  # Trying to do that will raise DuplicatedInflectionToken exception.
  # This is required in order to keep patterns simple and tokens interpolation
  # fast.
  # 
  # Kind is also used to instruct I18n.translate method which
  # token it should pick. This will be explained later.
  # 
  # === Tokens
  # The token is an element of a pattern. A pattern may have many tokens
  # of the same kind separated by vertical bars. Each token name used in a
  # pattern should end with colon sign. After this colon a value should
  # appear (or an empty string).
  #
  # === Aliases
  # Aliases are special tokens that point to other tokens. They cannot
  # be used in inflection patterns but they are fully recognized values
  # of options while evaluating kinds.
  # 
  # Aliases might be helpful in multilingual applications that are using
  # a fixed set of values passed through options to describe some properties
  # of messages, e.g. +masculine+ and +feminine+ for a grammatical gender.
  # Translators may then use their own tokens (like +f+ and +m+ for English)
  # to produce pretty and intuitive patterns.
  # 
  # For example: if some application uses database with gender assigned
  # to a user which may be +male+, +female+ or +none+, then a translator
  # for some language may find it useful to map impersonal token (<tt>none</tt>)
  # to the +neuter+ token, since in translations for his language the
  # neuter gender is in use.
  # 
  # Here is the example of such situation:
  # 
  #   en:
  #     i18n:
  #       inflections:
  #         gender:
  #           male:     "male"
  #           female:   "female"
  #           none:     "impersonal form"
  #           default:  none 
  #   
  #   pl:
  #     i18n:
  #       inflections:
  #         gender:
  #           k:        "female"
  #           m:        "male"
  #           n:        "neuter"
  #           male:     @k
  #           female:   @m
  #           none:     @n
  #           default:  none
  # 
  # In the case above Polish translator decided to use neuter
  # instead of impersonal form when +none+ token will be passed
  # through the option +:gender+ to the translate method. He
  # also decided that he will use +k+, +m+ or +n+ in patterns,
  # because the names are short and correspond to gender names in
  # Polish language.
  # 
  # Aliases may point to other aliases. While loading inflections they
  # will be internally shortened and they will always point to real tokens,
  # not other aliases.
  # 
  # === Default token
  # There is special token called the +default+, which points
  # to a token that should be used if translation routine cannot deduce
  # which one it should use because a proper option was not given.
  # 
  # Default tokens may point to aliases and may use aliases' syntax, e.g.:
  #   default: @man
  # 
  # === Descriptions
  # The values of keys in the example (+female+, +male+ and +neuter+)
  # are *descriptions* which are not used by interpolation routines
  # but might be helpful (e.g. in UI). For obvious reasons you cannot
  # describe aliases.
  # 
  # == Interpolation
  # The value of each token present in a pattern is to be picked by the interpolation
  # routine and will replace the whole pattern, when the token name from that
  # pattern matches the value of an option passed to {I18n.translate} method.
  # This option is called <b>the inflection option</b>. Its name should be
  # the same as a *kind* of tokens used within a pattern. The first token in a pattern
  # determines the kind of all tokens used in that pattern. You can pass
  # many inflection options, each one designated for keeping a token of a
  # different kind.
  # 
  # === Examples:
  # 
  # ===== YAML:
  # Let's assume that the translation data in YAML format listed
  # below is used in any later example, unless other inflections
  # are given.
  #   en:
  #     i18n:
  #       inflections:
  #         gender:
  #           m:       "male"
  #           f:       "female"
  #           n:       "neuter"
  #           default: n
  #   
  #     welcome:  "Dear @{f:Madam|m:Sir|n:You|All}"
  # ===== Code:
  #   I18n.translate('welcome', :gender => :m)
  #   # => "Dear Sir"
  #   
  #   I18n.translate('welcome', :gender => :unknown)
  #   # => "Dear All"
  #   
  #   I18n.translate('welcome')
  #   # => "Dear You"
  # 
  # In the second example the <b>fallback value</b> +All+ was interpolated
  # because the routine had been unable to find the token called +:unknown+.
  # That differs from the latest example, in which there was no option given,
  # so the default token for a kind had been applied (in this case +n+).
  # 
  # === Local fallbacks (free text)
  # The fallback value will be used when any of the given tokens from
  # pattern cannot be interpolated.
  # 
  # Be aware that enabling extended error reporting makes it unable
  # to use fallback values in most cases. Local fallbacks will then be
  # applied only when a given option contains a proper value for some
  # kind but it's just not present in a pattern, for example:
  # 
  # ===== YAML:
  #   en:
  #     i18n:
  #       inflections:
  #         gender:
  #           n:    'neuter'
  #           o:    'other'
  #       
  #     welcome:    "Dear @{n:You|All}"
  # 
  # ===== Code:
  #   I18n.translate('welcome', :gender => :o, :raises => true)
  #   # => "Dear All"
  #   # since the token :o was configured but not used in the pattern
  #
  # === Unknown and empty tokens in options
  # If an option containing token is not present at all then the interpolation
  # routine will try the default token for a processed kind if the default
  # token is present in a pattern. The same thing will happend if the option
  # is present but its value is unknown, empty or +nil+.
  # If the default token is not present in a pattern or is not defined in
  # a configuration data then the processed pattern will result in an empty
  # string or in a local fallback value if there is a free text placed
  # in a pattern.
  # 
  # You can change this default behavior and force inflector
  # not to use a default token when a value of an option for a kind is unknown,
  # empty or +nil+ but only when it's not present.
  # To do that you should set option +:unknown_defaults+ to
  # +false+ and pass it to I18n.translate method. Other way is to set this
  # globally by using the method called unknown_defaults.
  # See #unknown_defaults for examples showing how the
  # translation results are changing when that switch is applied.
  # 
  # === Mixing inflection and standard interpolation patterns
  # The Inflector module allows you to include standard <tt>%{}</tt>
  # patterns inside of inflection patterns. The value of a standard
  # interpolation variable will be evaluated and interpolated *before*
  # processing an inflection pattern. For example:
  # 
  # ===== YAML:
  # Note: <em>Uses inflection configuration given in the first example.</em> 
  #   en:
  #     hi:   "Dear @{f:Lady|m:%{test}}!"
  # ===== Code:
  #   I18n.t('hi', :gender => :m, :locale => :xx, :test => "Dude")
  #   # => Dear Dude!
  # 
  # === Token groups
  # It is possible to join many tokens giving the same value in a group.
  # You can separate them using commas.
  # 
  # ===== YAML:
  # Note: <em>Uses inflection configuration given in the first example.</em> 
  #   en:
  #     welcome:  "Hello @{m,f:Ladies and Gentlemen|n:You}!"
  # ===== Code:
  #   I18n.t('welcome', :gender => :f)
  #   # => Hello Ladies and Gentlemen!
  # 
  # === Inverse matching of tokens
  # You can place exclamation mark before a token that should be
  # matched negatively. It's value will be used for a pattern
  # <b>if the given inflection option contains other token</b>.
  # 
  # ===== YAML:
  # Note: <em>Uses inflection configuration given in the first example.</em> 
  #   en:
  #     welcome:  "Hello @{!m:Ladies|n:You}!"
  # ===== Code:
  #   I18n.t('welcome', :gender => :n)
  #   # => Hello Ladies!
  #   
  #   I18n.t('welcome', :gender => :f)
  #   # => Hello Ladies!
  #   
  #   I18n.t('welcome', :gender => :m)
  #   # => Hello !
  # 
  # === Escaping a pattern
  # If there is a need to translate something that matches an inflection
  # pattern the escape symbols can be used to disable the interpolation. These
  # symbols are <tt>\\</tt> and +@+ and they should be placed just before
  # a pattern that should be left untouched. For instance:
  # 
  # ===== YAML:
  # Note: <em>Uses inflection configuration given in the first example.</em> 
  #   en:
  #     welcome:  "This is the @@{pattern}!"
  # ===== Code:
  #   I18n.t('welcome', :gender => :m, :locale => :xx)
  #   # => This is the @{pattern}!
  # 
  # == Errors
  # By default the module will silently ignore any interpolation errors.
  # You can turn off this default behavior by passing +:raises+ option.
  #
  # === Usage of +:raises+ option
  # 
  # ===== YAML
  # Note: <em>Uses inflection configuration given in the first example.</em> 
  #   en:
  #     welcome:  "Dear @{m:Sir|f:Madam|Fallback}"
  # ===== Code:
  #   I18n.t('welcome', :raises => true)   
  #   # => I18n::InvalidOptionForKind: option :gender required by the pattern
  #   #                                "@{m:Sir|f:Madam|Fallback}" was not found
  # 
  # Here are the exceptions that may be raised when option +:raises+
  # is set to +true+:
  # 
  # * {I18n::InvalidOptionForKind I18n::InvalidOptionForKind}
  # * {I18n::InvalidInflectionToken I18n::InvalidInflectionToken}
  # * {I18n::MisplacedInflectionToken I18n::MisplacedInflectionToken}
  # 
  # There are also exceptions that are raised regardless of :+raises+
  # presence or value.
  # These are usually caused by critical errors encountered during processing
  # inflection data. Here is the list:
  # 
  # * {I18n::InvalidLocale I18n::InvalidLocale}
  # * {I18n::DuplicatedInflectionToken I18n::DuplicatedInflectionToken}
  # * {I18n::BadInflectionToken I18n::BadInflectionToken}
  # * {I18n::BadInflectionAlias I18n::BadInflectionAlias}
  #
  module Inflector

  end

  # @abstract This exception class is defined in package I18n. It is raised when
  #   the given and/or processed locale parameter is invalid.
  class InvalidLocale; end
end
