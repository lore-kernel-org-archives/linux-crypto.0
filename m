From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sun, 12 Apr 2015 11:23:45 +0200
Message-ID: <CAKv+Gu_cgOTCbz8hh9w5xvYnNeXybEWFmCVxCcmjNor_oSPT_g@mail.gmail.com>
References: <1428759154-16251-1-git-send-email-ard.biesheuvel@linaro.org>
	<2659525.NqojY2z1jk@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38227 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbbDLJXq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Apr 2015 05:23:46 -0400
Received: by igbqf9 with SMTP id qf9so25364134igb.1
        for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2015 02:23:45 -0700 (PDT)
In-Reply-To: <2659525.NqojY2z1jk@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11 April 2015 at 22:54, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 11 April 2015 15:32:34 Ard Biesheuvel wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> How about something like this:
>>
>> A warning will be emitted by make when descending into the arch/arm/crypto
>> directory, but only if any ARMv8 Crypto modules were in fact selected.
>>
>> /home/ard/linux-2.6/arch/arm/crypto/Makefile:22: These ARMv8 Crypto Extensions modules need binutils 2.23 or higher
>> /home/ard/linux-2.6/arch/arm/crypto/Makefile:23: aes-arm-ce.o sha1-arm-ce.o sha2-arm-ce.o ghash-arm-ce.o
>>
>>
>
> Looks good. Do you want me to do more randconfig tests on this, or put it in
> right away to fix the allmodconfig problem?
>

It would be good to have confirmation that it fixes the actual
symptom, so yes, more testing please.
But I think the patch itself needs to go via Herbert's tree
