From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: s5p-sss - Fix use after free of copied input
 buffer in error path
Date: Wed, 20 Apr 2016 17:59:02 +0800
Message-ID: <20160420095902.GD3003@gondor.apana.org.au>
References: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Vladimir Zapolskiy <vz@mleia.com>, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49895 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbcDTJ73 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 05:59:29 -0400
Content-Disposition: inline
In-Reply-To: <1461073452-10426-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 19, 2016 at 03:44:11PM +0200, Krzysztof Kozlowski wrote:
> The driver makes copies of memory (input or output scatterlists) if they
> are not aligned. In s5p_aes_crypt_start() error path (on unsuccessful
> initialization of output scatterlist), if input scatterlist was not
> aligned, the driver first freed copied input memory and then unmapped it
> from the device, instead of doing otherwise (unmap and then free).
> 
> This was wrong in two ways:
> 1. Freed pages were still mapped to the device.
> 2. The dma_unmap_sg() iterated over freed scatterlist structure.
> 
> The call to s5p_free_sg_cpy() in this error path is not needed because
> the copied scatterlists will be freed by s5p_aes_complete().
> 
> Fixes: 9e4a1100a445 ("crypto: s5p-sss - Handle unaligned buffers")
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Both applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
