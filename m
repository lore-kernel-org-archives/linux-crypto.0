From: Peter Griffin <peter.griffin@linaro.org>
Subject: Re: [STLinux Kernel] [PATCH -next] hwrng: st - Fix missing
 clk_disable_unprepare() on error in st_rng_probe()
Date: Mon, 12 Sep 2016 09:31:25 +0100
Message-ID: <20160912083125.GA20253@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrice Chotard <patrice.chotard@st.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Wei Yongjun <weiyongjun1@huawei.com>, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36205 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbcILIba (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2016 04:31:30 -0400
Received: by mail-wm0-f46.google.com with SMTP id b187so123312890wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Sep 2016 01:31:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Wei,

On Sat, 10 Sep 2016, Wei Yongjun wrote:

> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix the missing clk_disable_unprepare() before return
> from st_rng_probe() in the error handling case.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/char/hw_random/st-rng.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
> index 7e8aa6b..938ec10 100644
> --- a/drivers/char/hw_random/st-rng.c
> +++ b/drivers/char/hw_random/st-rng.c
> @@ -108,6 +108,7 @@ static int st_rng_probe(struct platform_device *pdev)
>  	ret = hwrng_register(&ddata->ops);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to register HW RNG\n");
> +		clk_disable_unprepare(clk);
>  		return ret;
>  	}
>  
> 

Acked-by: Peter Griffin <peter.griffin@linaro.org>
