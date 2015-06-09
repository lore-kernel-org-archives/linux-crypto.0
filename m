From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: drbg - use pragmas for disabling optimization
Date: Tue, 9 Jun 2015 22:35:24 +0800
Message-ID: <20150609143523.GB14442@gondor.apana.org.au>
References: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra
	<public-peterz-wegcikhe2lqwvfeawa7xhq@plane.gmane.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Linux-Next <linux-next@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Waiman Long <waiman.long@hp.com>,
	Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43973 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbFIOfi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:35:38 -0400
Content-Disposition: inline
In-Reply-To: <3181127.KGS6GDHCq6@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 09, 2015 at 04:08:49AM +0200, Stephan Mueller wrote:
>
> Replace the global -O0 compiler flag from the Makefile with GCC
> pragmas to mark only the functions required to be compiled without
> optimizations.
> 
> This patch also adds a comment describing the rationale for the
> functions chosen to be compiled without optimizations.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.  Thanks Stephan!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
