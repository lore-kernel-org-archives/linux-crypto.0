From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH] crypto: qce: dma_map_sg can handle chained SG
Date: Tue, 3 Nov 2015 12:39:57 +0200
Message-ID: <56388EFD.5080509@mm-sol.com>
References: <20151001140106.GC27726@gondor.apana.org.au>
 <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	cristian.stoica@freescale.com, axboe@fb.com,
	dan.j.williams@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:47704 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbbKCKkE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Nov 2015 05:40:04 -0500
In-Reply-To: <1443765662-21638-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I know that this patch has been queued up, but ...

On 10/02/2015 09:01 AM, LABBE Corentin wrote:
> The qce driver use two dma_map_sg path according to SG are chained
> or not.
> Since dma_map_sg can handle both case, clean the code with all
> references to sg chained.
> 
> Thus removing qce_mapsg, qce_unmapsg and qce_countsg functions.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/crypto/qce/ablkcipher.c | 30 ++++++++----------------
>  drivers/crypto/qce/cipher.h     |  4 ----
>  drivers/crypto/qce/dma.c        | 52 -----------------------------------------
>  drivers/crypto/qce/dma.h        |  5 ----
>  drivers/crypto/qce/sha.c        | 18 ++++++--------
>  drivers/crypto/qce/sha.h        |  2 --
>  6 files changed, 17 insertions(+), 94 deletions(-)
> 

<snip>

> diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
> index be2f504..0c9973e 100644
> --- a/drivers/crypto/qce/sha.c
> +++ b/drivers/crypto/qce/sha.c
> @@ -51,9 +51,8 @@ static void qce_ahash_done(void *data)
>  	if (error)
>  		dev_dbg(qce->dev, "ahash dma termination error (%d)\n", error);
>  
> -	qce_unmapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
> -		    rctx->src_chained);
> -	qce_unmapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
> +	dma_unmap_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
> +	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
>  
>  	memcpy(rctx->digest, result->auth_iv, digestsize);
>  	if (req->result)
> @@ -92,16 +91,14 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
>  		rctx->authklen = AES_KEYSIZE_128;
>  	}
>  
> -	rctx->src_nents = qce_countsg(req->src, req->nbytes,
> -				      &rctx->src_chained);
> -	ret = qce_mapsg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE,
> -			rctx->src_chained);
> +	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);

sg_nents_for_len can return -EINVAL, and this error should be handled.

After added a check for the error I'm observing below:

#insmod tcrypt.ko mode=403 (test_ahash_speed("sha1"))

test 21 ( 8192 byte blocks, 8192 bytes per update,   1 updates):
qcrypto 73a000.crypto: sg_nents_for_len failed (-22) (nbytes:8192,
sg_len:4096)
hashing failed ret=-22

It seems that something is wrong with the test case? Looking further in
test_hash_sg_init() we can see:

#define TVMEMSIZE	4

	sg_init_table(sg, TVMEMSIZE);
	for (i = 0; i < TVMEMSIZE; i++) {
		sg_set_buf(sg + i, tvmem[i], PAGE_SIZE);
		memset(tvmem[i], 0xff, PAGE_SIZE);
	}

so we have 4 SGs with sg->length = 4096, thus sg_nents_for_len() should
return 2 entries with 4096 bytes each.

What is wrong here?

> +	ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
>  	if (ret < 0)
>  		return ret;
>  
>  	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
>  
> -	ret = qce_mapsg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE, 0);
> +	ret = dma_map_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
>  	if (ret < 0)
>  		goto error_unmap_src;
>  

<snip>


-- 
regards,
Stan
