From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: ccree: Fix indentation in ssi_buffer_mgr.c
Date: Fri, 27 Oct 2017 11:32:47 +0300
Message-ID: <20171027083247.sdsdwjiyhyflvjug@mwanda>
References: <20171027015342.6345-1-stephen@brennan.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
To: Stephen Brennan <stephen@brennan.io>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43352 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdJ0IdI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 04:33:08 -0400
Content-Disposition: inline
In-Reply-To: <20171027015342.6345-1-stephen@brennan.io>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 26, 2017 at 06:53:42PM -0700, Stephen Brennan wrote:
> In particular, fixes some over-indented if statement bodies as well as a
> couple lines indented with spaces. checkpatch.pl now reports no warnings
> on this file other than 80 character warnings.
> 
> Signed-off-by: Stephen Brennan <stephen@brennan.io>
> ---
> Hello again, hoping these indentation issues are a bit more actionable than the
> line length errors I was trying to fix in my previous patch. Again, thanks in
> advance for taking the time to look!
> 
>  drivers/staging/ccree/ssi_buffer_mgr.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
> index dca3ce84d043..7c62255128d5 100644
> --- a/drivers/staging/ccree/ssi_buffer_mgr.c
> +++ b/drivers/staging/ccree/ssi_buffer_mgr.c
> @@ -406,8 +406,8 @@ ssi_aead_handle_config_buf(struct device *dev,
>  	sg_init_one(&areq_ctx->ccm_adata_sg, config_data, AES_BLOCK_SIZE + areq_ctx->ccm_hdr_size);
>  	if (unlikely(dma_map_sg(dev, &areq_ctx->ccm_adata_sg, 1,
>  				DMA_TO_DEVICE) != 1)) {
> -			dev_err(dev, "dma_map_sg() config buffer failed\n");
> -			return -ENOMEM;
> +		dev_err(dev, "dma_map_sg() config buffer failed\n");
> +		return -ENOMEM;
>  	}
>  	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
>  		&sg_dma_address(&areq_ctx->ccm_adata_sg),
> @@ -435,8 +435,8 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
>  	sg_init_one(areq_ctx->buff_sg, curr_buff, curr_buff_cnt);
>  	if (unlikely(dma_map_sg(dev, areq_ctx->buff_sg, 1,
>  				DMA_TO_DEVICE) != 1)) {
> -			dev_err(dev, "dma_map_sg() src buffer failed\n");
> -			return -ENOMEM;
> +		dev_err(dev, "dma_map_sg() src buffer failed\n");
> +		return -ENOMEM;

So far so good.

>  	}
>  	dev_dbg(dev, "Mapped curr_buff: dma_address=%pad page=%p addr=%pK offset=%u length=%u\n",
>  		&sg_dma_address(areq_ctx->buff_sg), sg_page(areq_ctx->buff_sg),
> @@ -1029,10 +1029,10 @@ static inline int ssi_buffer_mgr_prepare_aead_data_mlli(
>  			 * verification is made by CPU compare in order to simplify
>  			 * MAC verification upon request completion
>  			 */
> -			  u32 size_to_skip = req->assoclen;
> +			u32 size_to_skip = req->assoclen;
>  
> -			  if (areq_ctx->is_gcm4543)
> -				  size_to_skip += crypto_aead_ivsize(tfm);
> +			if (areq_ctx->is_gcm4543)
> +				size_to_skip += crypto_aead_ivsize(tfm);
>  
>  			  ssi_buffer_mgr_copy_scatterlist_portion(
>  				dev, areq_ctx->backup_mac, req->src,

But then ssi_buffer_mgr_copy_scatterlist_portion() is still not indented
correctly.

regards,
dan carpenter
