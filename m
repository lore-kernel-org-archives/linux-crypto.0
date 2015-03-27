From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Fri, 27 Mar 2015 11:44:45 +0100
Message-ID: <CAKv+Gu9MzR682Zd7NJ0A+HNU8xv=KOEe1vvN1_kgjrWcWzsZsg@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
	<20150323135009.GB820@google.com>
	<20150324122702.GJ14457@ns203013.ovh.net>
	<CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>
	<20150324130511.GK14457@ns203013.ovh.net>
	<CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>
	<CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>
	<5515342F.6010703@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Andy Polyakov <appro@openssl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35610 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbbC0Koq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2015 06:44:46 -0400
Received: by ierf6 with SMTP id f6so370100ier.2
        for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2015 03:44:45 -0700 (PDT)
In-Reply-To: <5515342F.6010703@openssl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 27 March 2015 at 11:42, Andy Polyakov <appro@openssl.org> wrote:
>>> Could you share the error log please?
>>
>> OK, I spotted one issue with this code:
>>
>> arch/arm/crypto/sha256-core.S: Assembler messages:
>> arch/arm/crypto/sha256-core.S:1847: Error: invalid constant (ffffefb0)
>> after fixup
>>
>> This is caused by the fact that, when building the integer-only code
>> for an older architecture, the conditional compilation produces a
>> slightly bigger preceding function, and the symbol K256 is out of
>> range for the adr instruction.
>>
>> @Jean-Christophe: is that the same problem that you hit?
>>
>> @Andy: I propose we do something similar as in the bsaes code:
>>
>> #ifdef __thumb__
>> #define adrl adr
>> #endif
>>
>> and replace the offending line with
>>
>> adrl r14,K256
>
> Sorry about delay. Yes, that would do. I did test all combinations, but
> all "my" combinations, i.e. without __KERNEL__ defined :-( And without
> __KERNEL__ there are few extra instructions in integer-only subroutine
> that "push" instruction in question code toward higher address, so that
> constant was ffffefc0, which can be encoded. Anyway, I've chosen to add
> that #define next to .thumb directive. See attached.
>
> Ard, you have mentioned that you've verified it on big-endian, but I've
> spotted little-endian dependency (see #ifndef __ARMEB__ in attached). I
> guess that it worked for you either because it was NEON that was tested
> (it does work as is) or __LINUX_ARM_ARCH__ was less than 7 (in which
> case it uses endian-neutral byte-by-byte data load). Can you confirm either?
>

I need to double check that, but my suspicion is that it was the latter.
