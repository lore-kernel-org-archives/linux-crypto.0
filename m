From: Patrice Chotard <patrice.chotard@st.com>
Subject: Re: [PATCH -next] hwrng: st - Fix missing clk_disable_unprepare() on
 error in st_rng_probe()
Date: Mon, 12 Sep 2016 09:27:14 +0200
Message-ID: <f427e4a6-1807-2f32-4a1b-ad3150a17135@st.com>
References: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
        <linux-crypto@vger.kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:26512 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752088AbcILH2F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2016 03:28:05 -0400
In-Reply-To: <1473509022-3478-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Wey

On 09/10/2016 02:03 PM, Wei Yongjun wrote:
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
> 
> 


Acked-by: Patrice Chotard <patrice.chotard@st.com>

Thanks
