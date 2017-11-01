From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 2/3] staging: ccree: handle limiting of DMA masks
Date: Wed, 1 Nov 2017 13:59:53 +0300
Message-ID: <20171101105953.qu56hxvuqsmemmjg@mwanda>
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
Received: from userp1040.oracle.com ([156.151.31.81]:42645 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdKALAQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 07:00:16 -0400
Content-Disposition: inline
In-Reply-To: <1509450978-17784-3-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 11:56:16AM +0000, Gilad Ben-Yossef wrote:
> +	dma_mask = (dma_addr_t)(DMA_BIT_MASK(DMA_BIT_MASK_LEN));
> +	while (dma_mask > 0x7fffffffUL) {
> +		if (dma_supported(&plat_dev->dev, dma_mask)) {
> +			rc = dma_set_coherent_mask(&plat_dev->dev, dma_mask);
> +				if (!rc)
> +					break;

The indenting is messed up.

> +		}
> +		dma_mask >>= 1;
> +	}

regards,
dan carpenter
