From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 05/11] crypto: caam - Add cache coherency support to
 Freescale CAAM scatterlist implementation
Date: Tue, 16 Jun 2015 14:04:08 +0800
Message-ID: <20150616060408.GA21818@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-6-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37993 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbFPGEM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:04:12 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-6-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:53PM -0700, Victoria Milhoan wrote:
>
> @@ -91,9 +91,14 @@ static int dma_map_sg_chained(struct device *dev, struct scatterlist *sg,
>  {
>  	if (unlikely(chained)) {
>  		int i;
> +	struct scatterlist *tsg = sg;
> +
> +	/* We use a local copy of the sg pointer to avoid moving the
> +	 * head of the list pointed to by sg as we wall the list.
> +	 */
>  		for (i = 0; i < nents; i++) {
> -			dma_map_sg(dev, sg, 1, dir);
> -			sg = sg_next(sg);
> +			dma_map_sg(dev, tsg, 1, dir);
> +			tsg = scatterwalk_sg_next(tsg);

Please do not use scatterwalk_sg_next as it is obsolete and is
otherwise identical to sg_next.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
