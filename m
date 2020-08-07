Return-Path: <SRS0=csk9=BR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FB7C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 15:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2E612075D
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Aug 2020 15:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHGP5f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 11:57:35 -0400
Received: from out28-146.mail.aliyun.com ([115.124.28.146]:56296 "EHLO
        out28-146.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgHGP5f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 11:57:35 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07741829|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0416614-0.0045437-0.953795;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03306;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.IE4F7wY_1596815847;
Received: from 192.168.10.205(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.IE4F7wY_1596815847)
          by smtp.aliyun-inc.com(10.147.41.231);
          Fri, 07 Aug 2020 23:57:28 +0800
Subject: Re: [PATCH] crypto: ingenic - Drop kfree for memory allocated with
 devm_kzalloc
To:     Wei Yongjun <weiyongjun1@huawei.com>, mpm@selenic.com,
        herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, prasannatsmkumar@gmail.com
Cc:     linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>
References: <20200804081153.45342-1-weiyongjun1@huawei.com>
From:   Zhou Yanjie <zhouyanjie@wanyeetech.com>
Message-ID: <dc81addf-28db-72ef-1181-5b6425374e3c@wanyeetech.com>
Date:   Fri, 7 Aug 2020 23:57:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20200804081153.45342-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

在 2020/8/4 下午4:11, Wei Yongjun 写道:
> It's not necessary to free memory allocated with devm_kzalloc
> and using kfree leads to a double free.


Thanks for fix it.

Reviewed-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

>
> Fixes: 190873a0ea45 ("crypto: ingenic - Add hardware RNG for Ingenic JZ4780 and X1000")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/char/hw_random/ingenic-rng.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/char/hw_random/ingenic-rng.c b/drivers/char/hw_random/ingenic-rng.c
> index d704cef64b64..055cfe59f519 100644
> --- a/drivers/char/hw_random/ingenic-rng.c
> +++ b/drivers/char/hw_random/ingenic-rng.c
> @@ -92,8 +92,7 @@ static int ingenic_rng_probe(struct platform_device *pdev)
>   	priv->base = devm_platform_ioremap_resource(pdev, 0);
>   	if (IS_ERR(priv->base)) {
>   		pr_err("%s: Failed to map RNG registers\n", __func__);
> -		ret = PTR_ERR(priv->base);
> -		goto err_free_rng;
> +		return PTR_ERR(priv->base);
>   	}
>   
>   	priv->version = (enum ingenic_rng_version)of_device_get_match_data(&pdev->dev);
> @@ -106,17 +105,13 @@ static int ingenic_rng_probe(struct platform_device *pdev)
>   	ret = hwrng_register(&priv->rng);
>   	if (ret) {
>   		dev_err(&pdev->dev, "Failed to register hwrng\n");
> -		goto err_free_rng;
> +		return ret;
>   	}
>   
>   	platform_set_drvdata(pdev, priv);
>   
>   	dev_info(&pdev->dev, "Ingenic RNG driver registered\n");
>   	return 0;
> -
> -err_free_rng:
> -	kfree(priv);
> -	return ret;
>   }
>   
>   static int ingenic_rng_remove(struct platform_device *pdev)
>
>
