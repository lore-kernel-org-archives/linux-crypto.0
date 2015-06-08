From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: randconfig build error with next-20150529, in
 crypto/jitterentropy.c
Date: Mon, 8 Jun 2015 12:54:12 -0700
Message-ID: <20150608195412.GA2792@roeck-us.net>
References: <CA+r1ZhhfcfZ5RvAtFEnR0y3Y79dz2Em7JsuqF_XRPBRhL5pROQ@mail.gmail.com>
 <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:36150 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbbFHTyR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 15:54:17 -0400
Content-Disposition: inline
In-Reply-To: <CAHp75VeoCQSUCeswTCzUyKbV_e4RTt5t0yjEJLSzAvtX8jFvNw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2015 at 03:21:09PM +0300, Andy Shevchenko wrote:
> On Fri, May 29, 2015 at 10:14 PM, Jim Davis <jim.epost@gmail.com> wrote:
> > Building with the attached random configuration file,
> 
> Hit the very same error against next-20150605.
> 

There are also several failing default configurations.

Guenter

---

um:defconfig:

include/asm-generic/fixmap.h: In function 'fix_to_virt':
include/asm-generic/fixmap.h:31:2: error: size of unnamed array is negative
---

x86_64:defconfig:
i386:defconfig:

./arch/x86/include/asm/qspinlock.h: In function 'native_queued_spin_unlock':
./arch/x86/include/asm/qspinlock.h:17:2: error:
	call to '__compiletime_assert_17' declared with attribute error:
		Need native word sized stores/loads for atomicity.

---

openrisc:defconfig:

In file included from ./arch/openrisc/include/asm/timex.h:23:0,
	...
	from crypto/jitterentropy.c:52:
./arch/openrisc/include/asm/spr.h: In function 'jent_loop_shuffle':
./arch/openrisc/include/asm/spr.h:30:2: warning: asm operand 1 probably doesn't
match constraints
./arch/openrisc/include/asm/spr.h:30:2: error: impossible constraint in 'asm'

---

nios2:3c120_defconfig:

ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!
