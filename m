From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Mon, 08 Jun 2015 16:51:24 -0700
Message-ID: <55762A7C.5050706@roeck-us.net>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <2802354.BKbRJQHDPP@tauon.atsec.com> <55762581.6070809@roeck-us.net> <1702795.h60qkgijGA@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:36330 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbbFHXv2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 19:51:28 -0400
In-Reply-To: <1702795.h60qkgijGA@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/08/2015 04:33 PM, Stephan Mueller wrote:
> Am Monday 08 June 2015, 16:30:09 schrieb Guenter Roeck:
>
> Hi Guenter,
>
>>
>> get_cycles is implemented as static inline which executes mfspr(SPR_TTCR).
>> SPR_TTCR is a constant. Normally that information seems to be passed on,
>> but not when get_cycles() is compiled through jitterentropy.
>>
>> Any idea what might cause this ?
>
> Then it may be the optimization issue as well that Peter indicated. May I ask
> you for testing purposes (I do not have an OpenRISC) to remove the following
> line from crypto/Makefile:
>
> CFLAGS_jitterentropy.o = -O0
>

Yes, that fixes the problem (after I also removed the associated #error from
jitterentropy.c).

Guenter
