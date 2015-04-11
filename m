From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: arm: workaround for building with old binutils
Date: Sat, 11 Apr 2015 12:35:19 +0200
Message-ID: <51652361-AEE7-4C88-920A-5F0ED60EE275@linaro.org>
References: <3461827.FYLMCAIQyv@wuerfel> <CAKv+Gu_n0-sMZZjWOmQ5koEfJRX6jqme5WOOP1zrF_zMnB7=nA@mail.gmail.com> <2148670.W34n3asXfA@wuerfel>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34377 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbDKKfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 06:35:25 -0400
Received: by widjs5 with SMTP id js5so31492498wid.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Apr 2015 03:35:24 -0700 (PDT)
In-Reply-To: <2148670.W34n3asXfA@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> On 11 apr. 2015, at 10:55, Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> On Saturday 11 April 2015 09:41:08 Ard Biesheuvel wrote:
>> Could you perhaps put the rules that build these modules inside a
>> 
>> ifneq ($(armv8-ce-flags),-DARMV8_CE_DISABLED)
>> ...
>> endif
> 
> How about something like this:
> 
> ifeq ($(call as-option,-Wa$(comma)-mfpu=crypto-neon-fp-armv8),)
> $(warning ARMv8 Crypto Extensions need binutils 2.23 or higher)
> else
> ...
> endif
> 
> That would basically be a reimplementation of the missing "as-option-yn"
> macro though, so we could also add that instead and do
> 
> ifeq ($(call as-option-yn,-Wa$(comma)-mfpu=crypto-neon-fp-armv8),y)
> $(warning ARMv8 Crypto Extensions need binutils 2.23 or higher)
> else
> ...
> endif
> 

Yes, that should work. Could we also move the CE objs to ce-obj-$() and put

ifneq ($(ce-obj-y)$(ce-obj-m),)
if <as check>
obj-y += $(ce-obj-y)
obj-m += $(ce-obj-m)
else
$(warning ...)
endif
endif

around it so you only get the warning if you have selected any of these modules?

In any case, I strongly prefer to leave the .S files themselves alone if at all possible

Ard.
