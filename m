From: Stephan Mueller <smueller@chronox.de>
Subject: Re: randconfig build error with next-20150529, in crypto/jitterentropy.c
Date: Tue, 09 Jun 2015 00:36:07 +0200
Message-ID: <2802354.BKbRJQHDPP@tauon.atsec.com>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com> <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com> <20150608195412.GA2792@roeck-us.net>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46142 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbbFHWgv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 18:36:51 -0400
In-Reply-To: <20150608195412.GA2792@roeck-us.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Monday 08 June 2015, 12:54:12 schrieb Guenter Roeck:

Hi Guenter,

Thanks for the note.

...
>
>---
>
>openrisc:defconfig:
>
>In file included from ./arch/openrisc/include/asm/timex.h:23:0,
>	...
>	from crypto/jitterentropy.c:52:
>./arch/openrisc/include/asm/spr.h: In function 'jent_loop_shuffle':
>./arch/openrisc/include/asm/spr.h:30:2: warning: asm operand 1 probably
>doesn't match constraints
>./arch/openrisc/include/asm/spr.h:30:2: error: impossible constraint in 'asm'

I received this one also before. But that seems to be an error on the OpenRISC 
platform as the random_get_entropy() function or the get_cycles function is 
not implemented as defined.

The crypto code uses the following which triggers the issue:

        __u64 tmp = 0;

        tmp = random_get_entropy();

That one seems to be an appropriate use of random_get_entropy() which on 
almost all arches is an alias for get_cycles().
>
>---
>
>nios2:3c120_defconfig:
>
>ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!


Ciao
Stephan
