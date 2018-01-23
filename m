From: Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH -next] hwrng: make symbol imx_rngc_pm_ops static
Date: Tue, 23 Jan 2018 10:09:34 +0100
Message-ID: <20180123090934.GA29930@botnar.kaiser.cx>
References: <1516673336-170194-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from botnar.kaiser.cx ([176.28.20.183]:51996 "EHLO botnar.kaiser.cx"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751027AbeAWJJs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Jan 2018 04:09:48 -0500
Content-Disposition: inline
In-Reply-To: <1516673336-170194-1-git-send-email-weiyongjun1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thus wrote Wei Yongjun (weiyongjun1@huawei.com):

> Fixes the following sparse warnings:

> drivers/char/hw_random/imx-rngc.c:303:1: warning:
>  symbol 'imx_rngc_pm_ops' was not declared. Should it be static?

> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index eca8724..250123b 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -300,7 +300,7 @@ static int __maybe_unused imx_rngc_resume(struct device *dev)
>  	return 0;
>  }

> -SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);
> +static SIMPLE_DEV_PM_OPS(imx_rngc_pm_ops, imx_rngc_suspend, imx_rngc_resume);

>  static const struct of_device_id imx_rngc_dt_ids[] = {
>  	{ .compatible = "fsl,imx25-rngb", .data = NULL, },


You're right. The vast majority of other drivers uses a
static SIMPLE_DEV_PM_OPS(), so should we.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
