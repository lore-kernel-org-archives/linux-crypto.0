From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 1/7] staging: ccree: fix hash import/export
Date: Thu, 22 Jun 2017 16:58:11 +0300
Message-ID: <20170622135811.4wbh7dqi634j5d2c@mwanda>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
 <1498138623-6126-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33787 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdFVN6e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 09:58:34 -0400
Content-Disposition: inline
In-Reply-To: <1498138623-6126-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 22, 2017 at 04:36:55PM +0300, Gilad Ben-Yossef wrote:
>  static int ssi_ahash_export(struct ahash_request *req, void *out)
>  {
>  	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
>  	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
> +	struct device *dev = &ctx->drvdata->plat_dev->dev;
> +	struct ahash_req_ctx *state = ahash_request_ctx(req);
> +	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
> +	u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
> +				state->buff0_cnt;
> +	const u32 tmp = CC_EXPORT_MAGIC;
> +
> +	CHECK_AND_RETURN_UPON_FIPS_ERROR();
>  
> -	return ssi_hash_export(ctx, out);
> +	memcpy(out, &tmp, sizeof(u32));
> +	out += sizeof(u32);
> +
> +	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
> +				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
> +	memcpy(out, state->digest_buff, ctx->inter_digestsize);
> +	out += ctx->inter_digestsize;
> +
> +	if (state->digest_bytes_len_dma_addr) {
> +		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
> +					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
> +		memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
> +	}
> +	out += HASH_LEN_SIZE;

I'm sorry to ask this question now instead of on my first review.  I was
waiting for my other computer to get ready so I could look up how this
is called.  But now that I've looked at it, I'm still not sure how this
is called.

Anyway, my question is, is out zeroed memory?  Should we have something
like:
	} else {
		memset(out, 0, HASH_LEN_SIZE);
	}
	out += HASH_LEN_SIZE;

The ->import() function has a similar snippet.

regards,
dan carpenter
