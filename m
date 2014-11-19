From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] crypto: prefix module autoloading with "crypto-"
Date: Tue, 18 Nov 2014 16:04:42 -0800
Message-ID: <CAGXu5jKofJCE_UNHTAZZCpc+SL7T-r_Xx6tPFyS8DYYC8G0mAg@mail.gmail.com>
References: <20141117200248.GA15294@www.outflux.net>
	<CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
	<CAGXu5jLGS4cNv_+xLH1fPzg8rUnXL5S+eKmHFn4jckaJkdeRjA@mail.gmail.com>
	<CA+rthh80M=NN710zOFW7Hfid8aV-TuwdhHdoB0UF0Bboshy9zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:65286 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaKSAEn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Nov 2014 19:04:43 -0500
Received: by mail-oi0-f44.google.com with SMTP id e131so5066178oig.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2014 16:04:42 -0800 (PST)
In-Reply-To: <CA+rthh80M=NN710zOFW7Hfid8aV-TuwdhHdoB0UF0Bboshy9zw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 18, 2014 at 3:12 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 18 November 2014 01:45, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Nov 17, 2014 at 3:20 PM, Mathias Krause <minipli@googlemail.com> wrote:
>>> On 17 November 2014 21:02, Kees Cook <keescook@chromium.org> wrote:
>>>> This prefixes all crypto module loading with "crypto-" so we never run
>>>> the risk of exposing module auto-loading to userspace via a crypto API,
>>>> as demonstrated by Mathias Krause:
>>>>
>>>> https://lkml.org/lkml/2013/3/4/70
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>> v2:
>>>>  - added missing #include, thanks to minipli
>>>>  - built with allmodconfig
>>>> [...snip...]
>>>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>>>> index d45e949699ea..d14230f6e977 100644
>>>> --- a/include/linux/crypto.h
>>>> +++ b/include/linux/crypto.h
>>>> @@ -26,6 +26,13 @@
>>>>  #include <linux/uaccess.h>
>>>>
>>>>  /*
>>>> + * Autoloaded crypto modules should only use a prefixed name to avoid allowing
>>>> + * arbitrary modules to be loaded.
>>>> + */
>>>> +#define MODULE_ALIAS_CRYPTO(name)      \
>>>> +               MODULE_ALIAS("crypto-" name)
>>>
>>> This would break userland relying on the old aliases, e.g. 'modprobe
>>> aes' no longer works.
>>>
>>> Why not have both aliases, one with the "crypto-" prefix for on-demand
>>> loading within the crypto API and one without for manual loading from
>>> userland? E.g., something like this:
>>>
>>> #define MODULE_ALIAS_CRYPTO(name)      \
>>>                MODULE_ALIAS(name); \
>>>                MODULE_ALIAS("crypto-" name)
>>>
>>> That would prevent the userland breakage and still achieves the goal
>>> of restricting the request_module() call offered by the means of the
>>> AF_ALG API.
>>
>> That was my intention originally, and I should go back to it. The
>> trouble is with the use of __UNIQUE_ID in the MODULE_ALIAS macro. It
>> uses __LINE__ to produce the id, so the suggested macro expansion
>> (which is what I started with) won't work on non-gcc compilers.
>>
>> I haven't found any solutions for C89 version of gcc's __COUNTER__,
>> and I haven't found any C89 ways to force a macro to be expanded as
>> being multi-line.
>
> Well, clang should support it as well, according to [1]. But still, a
> compiler independent solution would be nice.
> Anyway, the __COUNTER__ support is gcc >= 4.3 only. So, according to
> Documentation/Changes, stating gcc 3.2 is the minimum supported
> version for compiling the kernel, this would be a no-go, too.
>
> [1] http://clang.llvm.org/docs/LanguageExtensions.html#builtin-macros

Yeah, it's the avr32 auto builder that throws the warnings, so I
assume it's using a pre-4.3 gcc.

>> I'd like to avoid having to open-code both MODULE_ALIAS and
>> MODULE_ALIAS_CRYPTO in each module's source.
>>
>> Anyone see some sneaky way to accomplish this?
>
> Unfortunately, I do not ... beside this, maybe:
>
> #define MODULE_ALIAS_CRYPTO(name)      \
>                __MODULE_INFO(alias, alias_userland, name); \
>                __MODULE_INFO(alias, alias_crypto, "crypto-" name)
>
> Looks ugly, but works. ;)

AAh! Yes, that's perfect! I will spin it this way. Thank you thank you!

-Kees

-- 
Kees Cook
Chrome OS Security
