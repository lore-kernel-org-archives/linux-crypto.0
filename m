From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: jitterentropy - remove timekeeping_valid_for_hres
Date: Thu, 28 May 2015 11:31:32 +0800
Message-ID: <20150528033132.GA3849@gondor.apana.org.au>
References: <5175461.r5Ln1vVEmU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43591 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbE1Dbk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 23:31:40 -0400
Content-Disposition: inline
In-Reply-To: <5175461.r5Ln1vVEmU@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 01:50:12PM +0200, Stephan Mueller wrote:
> The patch removes the use of timekeeping_valid_for_hres which is now
> marked as internal for the time keeping subsystem. The jitterentropy
> does not really require this verification as a coarse timer (when
> random_get_entropy is absent) is discovered by the initialization test
> of jent_entropy_init, which would cause the jitter rng to not load in
> that case.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
