From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: jitterentropy - avoid compiler warnings
Date: Thu, 25 Jun 2015 23:37:50 +0800
Message-ID: <20150625153750.GF11592@gondor.apana.org.au>
References: <CAMuHMdXLDeqSU3WcVEh=jcGdS4z2YMejU_nZ2gDObDVjsm7vvw@mail.gmail.com>
 <33380936.3jDOACMRCz@tachyon.chronox.de>
 <CAMuHMdUw9FJE3kWEQf+TNTaLB9gMjdHEGt27bnD--qoGX22H7Q@mail.gmail.com>
 <1446731.BXdYRBoPhr@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
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
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44736 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbFYPiN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 11:38:13 -0400
Content-Disposition: inline
In-Reply-To: <1446731.BXdYRBoPhr@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2015 at 04:18:54PM +0200, Stephan Mueller wrote:
> Hi Geert, Guenter,
> 
> may I ask that you check that the following patch compiles without errors or warnings on your systems?
> 
> Though, when I test that patch with the AVR32 cross compiler, I get a warning about the code being not relaxable.
> 
> Thank you very much.
> 
> ---8<---
> The core of the Jitter RNG is intended to be compiled with -O0. To
> ensure that the Jitter RNG can be compiled on all architectures,
> separate out the RNG core into a stand-alone C file that can be compiled
> with -O0 which does not depend on any kernel include file.
> 
> As no kernel includes can be used in the C file implementing the core
> RNG, any dependencies on kernel code must be extracted.
> 
> A second file provides the link to the kernel and the kernel crypto API
> that can be compiled with the regular compile options of the kernel.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
