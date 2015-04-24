From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: CRYPTO_DEV_IMGTEC_HASH should depend on HAS_DMA
Date: Fri, 24 Apr 2015 20:20:37 +0800
Message-ID: <20150424122037.GB31439@gondor.apana.org.au>
References: <1429812238-9306-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58831 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbbDXMUo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Apr 2015 08:20:44 -0400
Content-Disposition: inline
In-Reply-To: <1429812238-9306-1-git-send-email-geert@linux-m68k.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 23, 2015 at 08:03:58PM +0200, Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `img_hash_write_via_dma_stop':
>     img-hash.c:(.text+0xa2b822): undefined reference to `dma_unmap_sg'
>     drivers/built-in.o: In function `img_hash_xmit_dma':
>     img-hash.c:(.text+0xa2b8d8): undefined reference to `dma_map_sg'
>     img-hash.c:(.text+0xa2b948): undefined reference to `dma_unmap_sg'
> 
> Also move the "depends" section below the "tristate" line while we're at
> it.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
