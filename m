From: Stephan Mueller <smueller@chronox.de>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Tue, 09 Jun 2015 02:10:42 +0200
Message-ID: <4627147.GYCOgiMQ6L@tauon.atsec.com>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <1702795.h60qkgijGA@tauon.atsec.com> <55762A7C.5050706@roeck-us.net>
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
In-Reply-To: <55762A7C.5050706@roeck-us.net>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Monday 08 June 2015, 16:51:24 schrieb Guenter Roeck:

Hi Guenter,

>
>Yes, that fixes the problem (after I also removed the associated #error from
>jitterentropy.c).

Thank you for the confirmation. The patch will come tonight on this issue as I 
tested the cryptographic impact already.

Thanks a lot for your help.


Ciao
Stephan
