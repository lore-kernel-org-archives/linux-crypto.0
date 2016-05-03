From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - return raw integer for the ASN.1 parser
Date: Tue, 3 May 2016 15:39:57 +0800
Message-ID: <20160503073957.GA16836@gondor.apana.org.au>
References: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59306 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbcECHkD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 03:40:03 -0400
Content-Disposition: inline
In-Reply-To: <1461934306-29190-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 29, 2016 at 03:51:46PM +0300, Tudor Ambarus wrote:
>
>  struct rsa_key {
> +	u8 *n;
> +	u8 *e;
> +	u8 *d;
> +	dma_addr_t dma_n;
> +	dma_addr_t dma_e;
> +	dma_addr_t dma_d;
> +	size_t n_sz;
> +	size_t e_sz;
> +	bool coherent;
> +	gfp_t flags;

Please don't put the DMA primitives in the generic helper.  They
should stay in the driver for now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
