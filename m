From: Stephan Mueller <smueller@chronox.de>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Tue, 09 Jun 2015 01:33:12 +0200
Message-ID: <1702795.h60qkgijGA@tauon.atsec.com>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <2802354.BKbRJQHDPP@tauon.atsec.com> <55762581.6070809@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <55762581.6070809@roeck-us.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Monday 08 June 2015, 16:30:09 schrieb Guenter Roeck:

Hi Guenter,

>
>get_cycles is implemented as static inline which executes mfspr(SPR_TTCR).
>SPR_TTCR is a constant. Normally that information seems to be passed on,
>but not when get_cycles() is compiled through jitterentropy.
>
>Any idea what might cause this ?

Then it may be the optimization issue as well that Peter indicated. May I ask 
you for testing purposes (I do not have an OpenRISC) to remove the following 
line from crypto/Makefile:

CFLAGS_jitterentropy.o = -O0

Note, that should just serve for testing. I will post a patch later that will 
replace the -O0 statement with a pragma.

Thanks a lot.
>
>Thanks,
>Guenter


Ciao
Stephan
