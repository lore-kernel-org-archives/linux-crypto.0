From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: CRYPTO_DEV_ATMEL_AES should depend on HAS_DMA
Date: Mon, 18 Jan 2016 23:25:38 +0800
Message-ID: <20160118152538.GE717@gondor.apana.org.au>
References: <1452865686-687-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52938 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbcARPZu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:25:50 -0500
Content-Disposition: inline
In-Reply-To: <1452865686-687-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 15, 2016 at 02:48:06PM +0100, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     ERROR: "dma_unmap_sg" [drivers/crypto/atmel-aes.ko] undefined!
>     ERROR: "dma_map_sg" [drivers/crypto/atmel-aes.ko] undefined!
> 
> Add a dependency on HAS_DMA to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
