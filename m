Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF4DC4361B
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Dec 2020 13:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D142078D
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Dec 2020 13:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgLTNbM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Dec 2020 08:31:12 -0500
Received: from out28-220.mail.aliyun.com ([115.124.28.220]:38377 "EHLO
        out28-220.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbgLTNbM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Dec 2020 08:31:12 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0916407|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0169022-0.00133033-0.981767;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.J9MmYQd_1608471027;
Received: from 192.168.10.152(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.J9MmYQd_1608471027)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 20 Dec 2020 21:30:28 +0800
Subject: Re: [PATCH] hwrng: ingenic - Fix a resource leak in an error handling
 path
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        mpm@selenic.com, herbert@gondor.apana.org.au, aric.pzqi@ingenic.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20201219075207.176279-1-christophe.jaillet@wanadoo.fr>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <c5bb8f9a-c4a7-7ecb-eccb-a31abc7316a2@wanyeetech.com>
Date:   Sun, 20 Dec 2020 21:30:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20201219075207.176279-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christophe,

On 2020/12/19 下午3:52, Christophe JAILLET wrote:
> In case of error, we should call 'clk_disable_unprepare()' to undo a
> previous 'clk_prepare_enable()' call, as already done in the remove
> function.
>
> Fixes: 406346d22278 ("hwrng: ingenic - Add hardware TRNG for Ingenic X1830")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/char/hw_random/ingenic-trng.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)


Thanks for fixing it, and apologize for my carelessness.

Tested-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>


> diff --git a/drivers/char/hw_random/ingenic-trng.c b/drivers/char/hw_random/ingenic-trng.c
> index 954a8411d67d..0eb80f786f4d 100644
> --- a/drivers/char/hw_random/ingenic-trng.c
> +++ b/drivers/char/hw_random/ingenic-trng.c
> @@ -113,13 +113,17 @@ static int ingenic_trng_probe(struct platform_device *pdev)
>   	ret = hwrng_register(&trng->rng);
>   	if (ret) {
>   		dev_err(&pdev->dev, "Failed to register hwrng\n");
> -		return ret;
> +		goto err_unprepare_clk;
>   	}
>   
>   	platform_set_drvdata(pdev, trng);
>   
>   	dev_info(&pdev->dev, "Ingenic DTRNG driver registered\n");
>   	return 0;
> +
> +err_unprepare_clk:
> +	clk_disable_unprepare(trng->clk);
> +	return ret;
>   }
>   
>   static int ingenic_trng_remove(struct platform_device *pdev)
