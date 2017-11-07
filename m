From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/8] staging: ccree: use more readable func names
Date: Tue, 7 Nov 2017 13:30:10 +0300
Message-ID: <20171107103010.pgmgmmsjhxt4fjft@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42156 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751611AbdKGKa0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 05:30:26 -0500
Content-Disposition: inline
In-Reply-To: <1510047606-5589-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 09:39:58AM +0000, Gilad Ben-Yossef wrote:
> @@ -780,11 +766,10 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
>  		unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
>  		unsigned int iv_ofs = GCM_BLOCK_RFC4_IV_OFFSET;
>  		/* Chain to given list */
> -		ssi_buffer_mgr_add_buffer_entry(
> -			dev, sg_data,
> -			areq_ctx->gen_ctx.iv_dma_addr + iv_ofs,
> -			iv_size_to_authenc, is_last,
> -			&areq_ctx->assoc.mlli_nents);
> +		cc_add_buffer_entry(dev, sg_data,
> +				    (areq_ctx->gen_ctx.iv_dma_addr + iv_ofs),
                                    ^                                      ^

No need to resend the patch, but you've added parenthesis here that
weren't in the original code and in other places you fixed up some long
line warnings.  I'd prefer if you didn't do that because I use scripts
to review rename patches automatically and since these are not a rename
so it means I have to review them manually.  Also in that patch that
Tobin complained about you had some extra comment changes and some were
related to the API but some were just reformatted to fit in 80 chars.

In this sample, you've re-indented the code a bit to align correctly.
That would be mandatory especially if the original code had aligned
correctly so that's fine.  But otherwise try to be strict about the one
thing per patch.

> +				    iv_size_to_authenc, is_last,
> +				    &areq_ctx->assoc.mlli_nents);
>  		areq_ctx->assoc_buff_type = SSI_DMA_BUF_MLLI;
>  	}
>  

regards,
dan carpenter
