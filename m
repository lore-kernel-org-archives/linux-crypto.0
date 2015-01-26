From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: caam: remove dead code
Date: Mon, 26 Jan 2015 13:56:02 +1100
Message-ID: <20150126025601.GE19796@gondor.apana.org.au>
References: <1421834011-29565-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	horia.geanta@freescale.com, tudor.ambarus@freescale.com,
	alexandru.porosanu@freescale.com
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42498 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbbAZC4F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 21:56:05 -0500
Content-Disposition: inline
In-Reply-To: <1421834011-29565-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 21, 2015 at 11:53:30AM +0200, Cristian Stoica wrote:
> - assoc_nents and src_nents are never zero when all_contig is false
> - iv_contig is zero on the else branch
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> Reviewed-by: Richard Schmitt <richard.schmitt@freescale.com>

Both patches applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
