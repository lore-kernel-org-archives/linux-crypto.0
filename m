From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Mon, 08 Jun 2015 16:30:09 -0700
Message-ID: <55762581.6070809@roeck-us.net>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com> <20150608195412.GA2792@roeck-us.net> <2802354.BKbRJQHDPP@tauon.atsec.com>
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
Received: from bh-25.webhostbox.net ([208.91.199.152]:33438 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbbFHXa0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 19:30:26 -0400
In-Reply-To: <2802354.BKbRJQHDPP@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/08/2015 03:36 PM, Stephan Mueller wrote:
> Am Monday 08 June 2015, 12:54:12 schrieb Guenter Roeck:
>
> Hi Guenter,
>
> Thanks for the note.
>
> ...
>>
>> ---
>>
>> openrisc:defconfig:
>>
>> In file included from ./arch/openrisc/include/asm/timex.h:23:0,
>> 	...
>> 	from crypto/jitterentropy.c:52:
>> ./arch/openrisc/include/asm/spr.h: In function 'jent_loop_shuffle':
>> ./arch/openrisc/include/asm/spr.h:30:2: warning: asm operand 1 probably
>> doesn't match constraints
>> ./arch/openrisc/include/asm/spr.h:30:2: error: impossible constraint in 'asm'
>
> I received this one also before. But that seems to be an error on the OpenRISC
> platform as the random_get_entropy() function or the get_cycles function is
> not implemented as defined.
>
> The crypto code uses the following which triggers the issue:
>
>          __u64 tmp = 0;
>
>          tmp = random_get_entropy();
>
> That one seems to be an appropriate use of random_get_entropy() which on
> almost all arches is an alias for get_cycles().

Yes and no. I suspect it may have something to do with the compiler options.
The code compiles with the following patch applied.

---
diff --git a/arch/openrisc/include/asm/spr.h b/arch/openrisc/include/asm/spr.h
index 1cccb42dd477..373532cc41f4 100644
--- a/arch/openrisc/include/asm/spr.h
+++ b/arch/openrisc/include/asm/spr.h
@@ -24,7 +24,7 @@
         "l.mtspr %0,%1,%2"                                      \
         : : "r" (_off), "r" (_val), "K" (_spr))

-static inline unsigned long mfspr(unsigned long add)
+static inline unsigned long mfspr(const unsigned long add)
  {
         unsigned long ret;
         __asm__ __volatile__ ("l.mfspr %0,r0,%1" : "=r" (ret) : "K" (add));

---

get_cycles is implemented as static inline which executes mfspr(SPR_TTCR).
SPR_TTCR is a constant. Normally that information seems to be passed on,
but not when get_cycles() is compiled through jitterentropy.

Any idea what might cause this ?

Thanks,
Guenter
