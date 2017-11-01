From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/3] staging: ccree: copy IV to DMAable memory
Date: Wed, 1 Nov 2017 13:58:30 +0300
Message-ID: <20171101105830.skfd4pcnibpnmkxr@mwanda>
References: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
 <1509450978-17784-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19039 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752058AbdKAK6r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 06:58:47 -0400
Content-Disposition: inline
In-Reply-To: <1509450978-17784-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 31, 2017 at 11:56:15AM +0000, Gilad Ben-Yossef wrote:
> +
> +	/* The IV we are handed may be allocted from the stack so
> +	 * we must copy it to a DMAable buffer before use.
> +	 */
> +	req_ctx->iv = kmalloc(ivsize, GFP_KERNEL);
> +	memcpy(req_ctx->iv, info, ivsize);

We need to check if kmalloc() fails.

regards,
dan carpenter
