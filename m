From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: [PATCH] crypto: caam - fix inconsistent assoc dma mapping
 direction
Date: Fri, 10 May 2013 13:04:54 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B941E84FC@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1368187719-6865-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Phillips Kim-R1AAHA <R1AAHA@freescale.com>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:7942
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab3EJNEt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 May 2013 09:04:49 -0400
In-Reply-To: <1368187719-6865-1-git-send-email-horia.geanta@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Looks good.


> -----Original Message-----
> From: Geanta Neag Horia Ioan-B05471
> Sent: Friday, May 10, 2013 5:39 PM
> To: linux-crypto@vger.kernel.org
> Cc: Herbert Xu; stable@vger.kernel.org; Phillips Kim-R1AAHA; Garg Vakul-
> B16394
> Subject: [PATCH] crypto: caam - fix inconsistent assoc dma mapping
> direction
> 
> req->assoc is dma mapped BIDIRECTIONAL and unmapped TO_DEVICE.
> Since it is read-only for the device, use TO_DEVICE both for mapping and
> unmapping.
> 
> Cc: <stable@vger.kernel.org> # 3.9, 3.8
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> ---
>  drivers/crypto/caam/caamalg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/caam/caamalg.c
> b/drivers/crypto/caam/caamalg.c index 42420fb..bf7da50 100644
> --- a/drivers/crypto/caam/caamalg.c
> +++ b/drivers/crypto/caam/caamalg.c
> @@ -1154,7 +1154,7 @@ static struct aead_edesc *aead_edesc_alloc(struct
> aead_request *req,
>  		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
> 
>  	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
> -				 DMA_BIDIRECTIONAL, assoc_chained);
> +				 DMA_TO_DEVICE, assoc_chained);
>  	if (likely(req->src == req->dst)) {
>  		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
>  					 DMA_BIDIRECTIONAL, src_chained);
> @@ -1336,7 +1336,7 @@ static struct aead_edesc
> *aead_giv_edesc_alloc(struct aead_givcrypt_request
>  		dst_nents = sg_count(req->dst, req->cryptlen, &dst_chained);
> 
>  	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
> -				 DMA_BIDIRECTIONAL, assoc_chained);
> +				 DMA_TO_DEVICE, assoc_chained);
>  	if (likely(req->src == req->dst)) {
>  		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
>  					 DMA_BIDIRECTIONAL, src_chained);
> --
> 1.7.7.6
