From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: talitos - fix warning: 'alg' may be used
	uninitialized in this function
Date: Thu, 23 Sep 2010 15:57:09 +0800
Message-ID: <20100923075709.GA30262@gondor.apana.org.au>
References: <20100913174533.43d052ab.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41651 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab0IWH5M (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Sep 2010 03:57:12 -0400
Content-Disposition: inline
In-Reply-To: <20100913174533.43d052ab.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 13, 2010 at 10:45:33PM +0000, Kim Phillips wrote:
> drivers/crypto/talitos.c: In function 'talitos_probe':
> drivers/crypto/talitos.c:2363: warning: 'alg' may be used uninitialized in this function
> drivers/crypto/talitos.c:2363: note: 'alg' was declared here
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

All three patches applied.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
