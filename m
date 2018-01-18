From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH -next] staging: ccree: remove redundant dev_err call in init_cc_resources()
Date: Thu, 18 Jan 2018 10:43:05 +0200
Message-ID: <CAOtvUMdmbWaD3LkCA9gKDmLO1LVh5y8Xc8-2avu3yBsvCrY4nA@mail.gmail.com>
References: <1515669297-125873-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:45772 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754902AbeARInG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 03:43:06 -0500
Received: by mail-ot0-f196.google.com with SMTP id r4so15563547oti.12
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2018 00:43:06 -0800 (PST)
In-Reply-To: <1515669297-125873-1-git-send-email-weiyongjun1@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 1:14 PM, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> There is a error message within devm_ioremap_resource
> already, so remove the dev_err call to avoid redundant
> error message.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/staging/ccree/cc_driver.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/staging/ccree/cc_driver.c b/drivers/staging/ccree/cc_driver.c
> index 6682d9d..c27d5a8 100644
> --- a/drivers/staging/ccree/cc_driver.c
> +++ b/drivers/staging/ccree/cc_driver.c
> @@ -174,10 +174,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
>         req_mem_cc_regs = platform_get_resource(plat_dev, IORESOURCE_MEM, 0);
>         /* Map registers space */
>         new_drvdata->cc_base = devm_ioremap_resource(dev, req_mem_cc_regs);
> -       if (IS_ERR(new_drvdata->cc_base)) {
> -               dev_err(dev, "Failed to ioremap registers");
> +       if (IS_ERR(new_drvdata->cc_base))
>                 return PTR_ERR(new_drvdata->cc_base);
> -       }
>
>         dev_dbg(dev, "Got MEM resource (%s): %pR\n", req_mem_cc_regs->name,
>                 req_mem_cc_regs);
>

Yeah, that makes sense.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
