From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] staging: ccree: Replace kzalloc with devm_kzalloc
Date: Mon, 17 Jul 2017 14:33:06 +0200
Message-ID: <20170717123306.GF24503@kroah.com>
References: <1500105116-30290-1-git-send-email-sunil.m@techveda.org>
 <1500105116-30290-2-git-send-email-sunil.m@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, karthik@techveda.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: sunil.m@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45994 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdGQMdL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 08:33:11 -0400
Content-Disposition: inline
In-Reply-To: <1500105116-30290-2-git-send-email-sunil.m@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jul 15, 2017 at 01:21:54PM +0530, sunil.m@techveda.org wrote:
> From: Suniel Mahesh <sunil.m@techveda.org>
> 
> It is recommended to use managed function devm_kzalloc, which
> simplifies driver cleanup paths and driver code.
> This patch does the following:
> (a) replace kzalloc with devm_kzalloc.
> (b) drop kfree(), because memory allocated with devm_kzalloc() is
> automatically freed on driver detach, otherwise it leads to a double
> free.
> (c) remove unnecessary blank lines.
> 
> Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
> ---
> Note:
> - Patch was tested and built(ARCH=arm) on next-20170714.
>   No build issues reported, however it was not tested on
>   real hardware.
> ---
>  drivers/staging/ccree/ssi_driver.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
> index 78709b92..f231ecf 100644
> --- a/drivers/staging/ccree/ssi_driver.c
> +++ b/drivers/staging/ccree/ssi_driver.c
> @@ -224,13 +224,15 @@ static int init_cc_resources(struct platform_device *plat_dev)
>  	struct resource *req_mem_cc_regs = NULL;
>  	void __iomem *cc_base = NULL;
>  	bool irq_registered = false;
> -	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
> +	struct ssi_drvdata *new_drvdata;
>  	struct device *dev = &plat_dev->dev;
>  	struct device_node *np = dev->of_node;
>  	u32 signature_val;
>  	int rc = 0;
>  
> -	if (unlikely(!new_drvdata)) {
> +	new_drvdata = devm_kzalloc(&plat_dev->dev, sizeof(struct ssi_drvdata),

sizeof(*new_drvdata), right?

thanks,

greg k-h
