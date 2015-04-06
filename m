From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto/arm: accelerated SHA-512 using ARM generic ASM and NEON
Date: Mon, 6 Apr 2015 09:29:43 +0200
Message-ID: <CAKv+Gu-AOg6Wd1o_1_=ic8rhADKv7CpgSvWLHNy2C=1qm7xwiQ@mail.gmail.com>
References: <1427527726-25022-1-git-send-email-ard.biesheuvel@linaro.org>
	<55180706.9030104@openssl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Andy Polyakov <appro@openssl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35883 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbDFH3o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Apr 2015 03:29:44 -0400
Received: by iebrs15 with SMTP id rs15so15692350ieb.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2015 00:29:44 -0700 (PDT)
In-Reply-To: <55180706.9030104@openssl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 29 March 2015 at 16:07, Andy Polyakov <appro@openssl.org> wrote:
>> This updates the SHA-512 NEON module with the faster and more
>> versatile implementation from the OpenSSL project. It consists
>> of both a NEON and a generic ASM version of the core SHA-512
>> transform, where the NEON version reverts to the ASM version
>> when invoked in non-process context.
>>
>> Performance relative to the generic implementation (measured
>> using tcrypt.ko mode=306 sec=1 running on a Cortex-A57 under
>> KVM):
>>
>>       input size      block size      asm     neon    old neon
>>
>>       8192            8192            1.51    3.51    2.69
>
> One should keep in mind that improvement coefficients vary greatly from
> platform to platform. Normally you *should* observe higher coefficients
> in asm column and *can* observe smaller differences between "neon" and
> "old neon". BTW, 1.51 is unexpectedly low, I wonder which compiler
> version stands for 1.0?

This was Linaro GCC 4.9

> Nor can I replicate difference between "neon"
> and "old neon", I get smaller difference, 17%, on Cortex-A57. Well, I'm
> comparing in user-land, but it shouldn't be that significant at large
> blocks...
>

That is a bit surprising, indeed. The primary difference is that this
executes under a 32-bit kernel, whereas your testing uses 32-bit
OpenSSL under a 64-bit kernel in 32-bit compatibility mode. I can't
really explain how that should make a difference at all, but it's
worth to be noted.


>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>
>> This should get the same treatment as Sami's sha56 version: I would like
>> to wait until the OpenSSL source file hits the upstream repository so that
>> I can refer to its sha1 hash in the commit log.
>
> Update is committed as
> http://git.openssl.org/gitweb/?p=openssl.git;a=commitdiff;h=b1a5d1c652086257930a1f62ae51c9cdee654b2c.
> Note that the file I've initially sent privately was a little bit off.
> Sorry about that. But that little bit is just a commentary update that
> adds performance result for Cortex-A15. So that kernel patch as
> originally posted is 100% functionally equivalent.
>

Thanks.
