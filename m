From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: img-hash - use dma_data_direction when
 calling dma_map_sg
Date: Mon, 23 Jan 2017 22:58:09 +0800
Message-ID: <20170123145809.GB20806@gondor.apana.org.au>
References: <20170115123750.3010-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46463 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbdAWO62 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:58:28 -0500
Content-Disposition: inline
In-Reply-To: <20170115123750.3010-1-nicolas.iooss_linux@m4x.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 15, 2017 at 01:37:50PM +0100, Nicolas Iooss wrote:
> The fourth argument of dma_map_sg() and dma_unmap_sg() is an item of
> dma_data_direction enum. Function img_hash_xmit_dma() wrongly used
> DMA_MEM_TO_DEV, which is an item of dma_transfer_direction enum.
> 
> Replace DMA_MEM_TO_DEV (which value is 1) with DMA_TO_DEVICE (which
> value is fortunately also 1) when calling dma_map_sg() and
> dma_unmap_sg().
> 
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
