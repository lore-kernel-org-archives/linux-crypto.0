From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: drbg - fix an error code in
 drbg_init_sym_kernel()
Date: Mon, 20 Jun 2016 19:35:35 +0800
Message-ID: <20160620113535.GE10773@gondor.apana.org.au>
References: <20160617091618.GC25609@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54602 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbcFTMEH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 08:04:07 -0400
Content-Disposition: inline
In-Reply-To: <20160617091618.GC25609@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 17, 2016 at 12:16:19PM +0300, Dan Carpenter wrote:
> We accidentally return PTR_ERR(NULL) which is success but we should
> return -ENOMEM.
> 
> Fixes: 355912852115 ('crypto: drbg - use CTR AES instead of ECB AES')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
