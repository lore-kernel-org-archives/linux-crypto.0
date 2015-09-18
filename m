From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hw_random: octeon-rng: Use devm_hwrng_register
Date: Fri, 18 Sep 2015 21:57:03 +0800
Message-ID: <20150918135703.GC9249@gondor.apana.org.au>
References: <20150910060226.GA25426@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57145 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbbIRN5I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 09:57:08 -0400
Content-Disposition: inline
In-Reply-To: <20150910060226.GA25426@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 10, 2015 at 11:32:26AM +0530, Vaishali Thakkar wrote:
> Use resource managed function devm_hwrng_register instead of
> hwrng_register to make the error-path simpler. Also, remove
> octeon_rng_remove as it is now redundant.
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
