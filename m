From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: jitterentropy - avoid compiler warnings
Date: Tue, 23 Jun 2015 19:55:27 +0200
Message-ID: <1763021.bXoJhbvnM9@tauon.atsec.com>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com> <1446731.BXdYRBoPhr@tachyon.chronox.de> <20150623174103.GA11973@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47826 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbbFWRzf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2015 13:55:35 -0400
In-Reply-To: <20150623174103.GA11973@roeck-us.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Juni 2015, 10:41:03 schrieb Guenter Roeck:

Hi Guenter, Geert,

>On Tue, Jun 23, 2015 at 04:18:54PM +0200, Stephan Mueller wrote:
>> Hi Geert, Guenter,
>> 
>> may I ask that you check that the following patch compiles without errors
>> or warnings on your systems?
>No build failures for all architectures.

Thank you very much for your help.

Now, if Geert would be so kind and have a check on his OpenRISC to ensure that 
there are no compiler warnings, I would be happy.

Though, does anybody have any idea what the AVR32 compiler warning about 
crypto/builtin.o not being relaxable mean and whether that is an issue? Note, 
when I was compiling AVR32, I saw some of these warnings for other builtin.o 
too.

Ciao
Stephan
