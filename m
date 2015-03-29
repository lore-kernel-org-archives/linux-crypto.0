From: Andy Polyakov <appro@openssl.org>
Subject: Re: [PATCHv2] arm: crypto: Add optimized SHA-256/224
Date: Sun, 29 Mar 2015 15:27:24 +0200
Message-ID: <5517FDBC.7030008@openssl.org>
References: <20150316154835.GA31336@google.com>	<20150323135009.GB820@google.com>	<20150324122702.GJ14457@ns203013.ovh.net>	<CAKv+Gu-j8m7NAYHL8swjwJ0as6TzNyjqhk0Tp1QhDhH=E78K3Q@mail.gmail.com>	<20150324130511.GK14457@ns203013.ovh.net>	<CAKv+Gu8Px6dYKdrVFyh_5WN3sEAGYy0fv0qHONJ5x+68YZjCOQ@mail.gmail.com>	<CAKv+Gu_4G69JZJPex_=1xOZ4z5Fxtht4YG4G=TnYrkXPuiXvFg@mail.gmail.com>	<5515342F.6010703@openssl.org>	<CAKv+Gu9MzR682Zd7NJ0A+HNU8xv=KOEe1vvN1_kgjrWcWzsZsg@mail.gmail.com> <CAKv+Gu-_=FfAdyQKD2FFafJ0_OjcuiYRi8AVhxKsRKnTX6NOTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mta.openssl.org ([194.97.150.230]:43618 "EHLO mta.openssl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbbC2N11 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2015 09:27:27 -0400
In-Reply-To: <CAKv+Gu-_=FfAdyQKD2FFafJ0_OjcuiYRi8AVhxKsRKnTX6NOTA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>>>> arch/arm/crypto/sha256-core.S: Assembler messages:
>>>> arch/arm/crypto/sha256-core.S:1847: Error: invalid constant (ffffefb0)
>>>> after fixup
>>>>
>>>> This is caused by the fact that, when building the integer-only code
>>>> for an older architecture, the conditional compilation produces a
>>>> slightly bigger preceding function, and the symbol K256 is out of
>>>> range for the adr instruction.
>>>>
>>>> ... and replace the offending line with
>>>>
>>>> adrl r14,K256
>>>
>>> Ard, you have mentioned that you've verified it on big-endian, but I've
>>> spotted little-endian dependency (see #ifndef __ARMEB__ in attached). I
>>> guess that it worked for you either because it was NEON that was tested
>>> (it does work as is) or __LINUX_ARM_ARCH__ was less than 7 (in which
>>> case it uses endian-neutral byte-by-byte data load). Can you confirm either?
> 
> Indeed, if I build for v7 I get
> 
> [    0.269418] 00000000: 4e a5 c5 08 a6 56 6e 76 24 05 43 f8 fe b0 6f d4
> [    0.275261] 00000010: 57 77 7b e3 95 49 c4 01 64 36 af da 65 d2 33 0e
> [    0.281031] alg: hash: Test 1 failed for sha224-asm
> [    0.285315] 00000000: 9d 6a 5d e9 e1 6c 39 99 c7 14 84 0f 47 77 1f 36
> [    0.290912] 00000010: dc c2 97 a7 bd ef aa c3 6c 95 15 ae
> 
> which is indeed the integer code failing, and your attached patch fixes it.

Committed as
http://git.openssl.org/gitweb/?p=openssl.git;a=commitdiff;h=51f8d095562f36cdaa6893597b5c609e943b0565.
