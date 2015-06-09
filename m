From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] crypto: drbg - use pragmas for disabling optimization
Date: Mon, 08 Jun 2015 21:31:54 -0700
Message-ID: <55766C3A.3070101@roeck-us.net>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>
To: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:41058 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbFIEcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 00:32:04 -0400
In-Reply-To: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/08/2015 07:08 PM, Stephan Mueller wrote:
> Hi,
>
> I performed measurements of the upper and lower boundary of the minimum and
> Shannon entropy for the RNG before the patch and after the patch. The values
> are very similar which demonstrates that the change does not affect the
> cryptographic characteristics of the RNG.
>
> The tests are available at:
>
> [1] shows the lower boundary of the fully non-optimized RNG
>
> [2] shows the lower boundary of the RNG with the patch below
>
> [3] shows the upper boundary of the fully non-optimized RNG
>
> [4] shows the upper boundary of the RNG with the patch below
>
> The pictures are fully explained in [5], but the key values are the minimum
> and Shannon entropy numbers in the legend of the graphs.
>
> [1] http://www.eperm.de/userspace-foldtime-testO0.data-single-time-dist-delta-3036-hist.pdf
>
> [2] http://www.eperm.de/userspace-foldtime-test-pragmas-O2.data-single-time-dist-delta-2370-hist.pdf
>
> [3] http://www.eperm.de/userspace-foldtime-testO0.data-varying-time-dist-delta-7302-hist.pdf
>
> [4] http://www.eperm.de/userspace-foldtime-test-pragmas-O2.data-varying-time-dist-delta-7055-hist.pdf
>
> [5] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.pdf
>
> ---8<---
> Replace the global -O0 compiler flag from the Makefile with GCC
> pragmas to mark only the functions required to be compiled without
> optimizations.
>
> This patch also adds a comment describing the rationale for the
> functions chosen to be compiled without optimizations.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

With openrisc, I get:

   CC [M]  crypto/jitterentropy.o
crypto/jitterentropy.c:266:9: warning: #pragma GCC target is not supported for this machine

which may not be perfect, but is better than a compile error ;-).

nios2 still fails to build with

ERROR: "get_cycles" [crypto/jitterentropy.ko] undefined!

Guenter
