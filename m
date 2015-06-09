From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: drbg - initialize in subsys_initcall
Date: Tue, 9 Jun 2015 22:17:43 +0800
Message-ID: <20150609141743.GA14223@gondor.apana.org.au>
References: <7507652.XDRqQzIvs8@tachyon.chronox.de>
 <3033189.WTiU3v3QJk@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53260 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbbFIORs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 10:17:48 -0400
Content-Disposition: inline
In-Reply-To: <3033189.WTiU3v3QJk@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2015 at 02:42:50PM +0200, Stephan Mueller wrote:
> When compiling the DRBG statically into the kernel, the testmgr
> allocation of the DRBG may be done at a time the Jitter RNG is
> not available as it is registered later. The patch changes the
> initialization to be invoked in subsys_initcall.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Actually I think we won't need this patch after all because after
my callback patches we will never allocate jent in the testmgr
path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
