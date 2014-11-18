From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] crypto: prefix module autoloading with "crypto-"
Date: Mon, 17 Nov 2014 16:45:27 -0800
Message-ID: <CAGXu5jLGS4cNv_+xLH1fPzg8rUnXL5S+eKmHFn4jckaJkdeRjA@mail.gmail.com>
References: <20141117200248.GA15294@www.outflux.net>
	<CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38670 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKRAp1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 19:45:27 -0500
Received: by mail-ob0-f177.google.com with SMTP id va2so1529910obc.22
        for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2014 16:45:27 -0800 (PST)
In-Reply-To: <CA+rthh-NuaapKLOE_83KoO2ztV1e8LUXPVBefKEX_OTZM=bTMw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 17, 2014 at 3:20 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 17 November 2014 21:02, Kees Cook <keescook@chromium.org> wrote:
>> This prefixes all crypto module loading with "crypto-" so we never run
>> the risk of exposing module auto-loading to userspace via a crypto API,
>> as demonstrated by Mathias Krause:
>>
>> https://lkml.org/lkml/2013/3/4/70
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> v2:
>>  - added missing #include, thanks to minipli
>>  - built with allmodconfig
>> [...snip...]
>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>> index d45e949699ea..d14230f6e977 100644
>> --- a/include/linux/crypto.h
>> +++ b/include/linux/crypto.h
>> @@ -26,6 +26,13 @@
>>  #include <linux/uaccess.h>
>>
>>  /*
>> + * Autoloaded crypto modules should only use a prefixed name to avoid allowing
>> + * arbitrary modules to be loaded.
>> + */
>> +#define MODULE_ALIAS_CRYPTO(name)      \
>> +               MODULE_ALIAS("crypto-" name)
>
> This would break userland relying on the old aliases, e.g. 'modprobe
> aes' no longer works.
>
> Why not have both aliases, one with the "crypto-" prefix for on-demand
> loading within the crypto API and one without for manual loading from
> userland? E.g., something like this:
>
> #define MODULE_ALIAS_CRYPTO(name)      \
>                MODULE_ALIAS(name); \
>                MODULE_ALIAS("crypto-" name)
>
> That would prevent the userland breakage and still achieves the goal
> of restricting the request_module() call offered by the means of the
> AF_ALG API.

That was my intention originally, and I should go back to it. The
trouble is with the use of __UNIQUE_ID in the MODULE_ALIAS macro. It
uses __LINE__ to produce the id, so the suggested macro expansion
(which is what I started with) won't work on non-gcc compilers.

I haven't found any solutions for C89 version of gcc's __COUNTER__,
and I haven't found any C89 ways to force a macro to be expanded as
being multi-line.

I'd like to avoid having to open-code both MODULE_ALIAS and
MODULE_ALIAS_CRYPTO in each module's source.

Anyone see some sneaky way to accomplish this?

-Kees

-- 
Kees Cook
Chrome OS Security
