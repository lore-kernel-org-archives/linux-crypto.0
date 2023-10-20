Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E547BCDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 09:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376663AbjJTJjW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 05:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376786AbjJTJjV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 05:39:21 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890921AE
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 02:39:18 -0700 (PDT)
Received: from kwepemm000009.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SBfbx5qvsz15Ncb;
        Fri, 20 Oct 2023 17:36:29 +0800 (CST)
Received: from [10.67.120.153] (10.67.120.153) by
 kwepemm000009.china.huawei.com (7.193.23.227) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 20 Oct 2023 17:39:14 +0800
Subject: Re: [PATCH 19/42] crypto: hisilicon/trng - Convert to platform remove
 callback returning void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
 <20231020075521.2121571-63-u.kleine-koenig@pengutronix.de>
CC:     <linux-crypto@vger.kernel.org>, <kernel@pengutronix.de>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <ceee0571-922a-e21a-d7a7-e4cfae7e3717@huawei.com>
Date:   Fri, 20 Oct 2023 17:39:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20231020075521.2121571-63-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.120.153]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm000009.china.huawei.com (7.193.23.227)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2023/10/20 15:55, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
> 
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/hisilicon/trng/trng.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
> index 97e500db0a82..451b167bcc73 100644
> --- a/drivers/crypto/hisilicon/trng/trng.c
> +++ b/drivers/crypto/hisilicon/trng/trng.c
> @@ -303,7 +303,7 @@ static int hisi_trng_probe(struct platform_device *pdev)
>  	return ret;
>  }
>  
> -static int hisi_trng_remove(struct platform_device *pdev)
> +static void hisi_trng_remove(struct platform_device *pdev)
>  {
>  	struct hisi_trng *trng = platform_get_drvdata(pdev);
>  
> @@ -314,8 +314,6 @@ static int hisi_trng_remove(struct platform_device *pdev)
>  	if (trng->ver != HISI_TRNG_VER_V1 &&
>  	    atomic_dec_return(&trng_active_devs) == 0)
>  		crypto_unregister_rng(&hisi_trng_alg);
> -
> -	return 0;
>  }
>  
>  static const struct acpi_device_id hisi_trng_acpi_match[] = {
> @@ -326,7 +324,7 @@ MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
>  
>  static struct platform_driver hisi_trng_driver = {
>  	.probe		= hisi_trng_probe,
> -	.remove         = hisi_trng_remove,
> +	.remove_new     = hisi_trng_remove,
>  	.driver		= {
>  		.name	= "hisi-trng-v2",
>  		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
> 

Reviewed-by: Weili Qian <qianweili@huawei.com>

Thanks,
Weili
