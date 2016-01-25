From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] crypto: sahara - avoid needlessly saving and
 restoring sahara_ctx
Date: Mon, 25 Jan 2016 22:07:28 +0800
Message-ID: <20160125140728.GA8414@gondor.apana.org.au>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: marex@denx.de, s.trumtrar@pengutronix.de, thomas.lendacky@amd.com,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59594 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbcAYOHw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:07:52 -0500
Content-Disposition: inline
In-Reply-To: <1452707524-7695-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 03:52:02PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> Based on commit 434b421241f2d0 ("crypto: caam - avoid needlessly saving and
> restoring caam_hash_ctx") from Russell King.
> 
> When exporting and importing the hash state, we will only export and
> import into hashes which share the same struct crypto_ahash pointer.
> (See hash_accept->af_alg_accept->hash_accept_parent.)
>     
> This means that saving the sahara_ctx structure on export, and
> restoring it on import is a waste of resources.  So, remove this code.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Very good.  Not only is it a waste, it's a gaping security hole
because modifying the tfm from import will corrupt it.

But this is not enough, you're still copying things like the mutex
which should not be copied but instead should be reinitialised in
import.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
