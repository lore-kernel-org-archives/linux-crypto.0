From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] staging: ccree: handle limiting of DMA masks
Date: Wed, 1 Nov 2017 14:09:18 +0300
Message-ID: <20171101110918.f6ra2otu22jndjcc@mwanda>
References: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
 <1509450978-17784-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22853 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdKALJf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 07:09:35 -0400
Content-Disposition: inline
In-Reply-To: <1509450978-17784-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 11:56:16AM +0000, Gilad Ben-Yossef wrote:
>  
> -	if (!dev->coherent_dma_mask)
> -		dev->coherent_dma_mask = DMA_BIT_MASK(DMA_BIT_MASK_LEN);
> +	if (rc) {
> +		dev_err(dev, "Error: failed in dma_set_mask, mask=%par\n",
> +			&dma_mask);
> +		goto post_drvdata_err;


Also this is not the right goto.  We should be turning the clk off.

I don't really care for the naming scheme, and I know you renamed it for
me already once and I feel bad for not liking it more.  It's still
really a come-from label name and doesn't say what the goto does...
Instead of post_clk_err, I wish it had names like "err_clk_off:".

And in this case what it does is print a duplicative error message and
return.  :/  The goto post_drvdata_err: lines should just print their
own error messages if needed and return directly.  If there is no
cleanup then there is no need for a goto.

Anyway, that's not related to this patch.  Just resend it with
goto post_clk_err: in the v2.

regards,
dan carpenter
