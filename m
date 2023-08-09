Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1FEEB64DD
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Aug 2023 07:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjHIHpU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Aug 2023 03:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjHIHpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2023 03:45:19 -0400
Received: from mx07-00178001.pphosted.com (mx08-00178001.pphosted.com [91.207.212.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42011172A
        for <linux-crypto@vger.kernel.org>; Wed,  9 Aug 2023 00:45:18 -0700 (PDT)
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3795L1ge008160;
        Wed, 9 Aug 2023 09:44:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=
        message-id:date:mime-version:subject:to:cc:references:from
        :in-reply-to:content-type:content-transfer-encoding; s=
        selector1; bh=nz0H1Z+OBWW1YMb0cFHjQXSIrxZdBeUAIrANTmveQkI=; b=UR
        Rc7iEG20nYN3g8UCo6wRUif/BuGIWfLp8pg1OUPuMJcQQmBFZJCj/Yu7JdomTuvH
        f3FMNMGNaWic1Yxr+NPqKRyyIEHGlBUns+oV8WHCIL3XZu1QC6EbK7yKee7Zr2Dr
        A4CUPdhdsx0UBnDtzwywFuL311Pjh68iQIehTA8gOF0cfSG9D19w3PMPARdNwmeL
        OkoBHa5tVFooPAvxXzsC077iAzSbcC80U85o88WHju9603wBrkZ5R0D0aWMFhD1d
        6XOp1SJtTslWknrSbPy+SO8HZya+DitI/DbptG7Jj93cFXPw7pmnGLDkxRuKH8kU
        Zir/WGSJ+Ikfwd8yzC0w==
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3sbjfn6yx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 09:44:52 +0200 (MEST)
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D1A05100061;
        Wed,  9 Aug 2023 09:44:47 +0200 (CEST)
Received: from Webmail-eu.st.com (eqndag1node6.st.com [10.75.129.135])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 9463E212FAA;
        Wed,  9 Aug 2023 09:44:47 +0200 (CEST)
Received: from [10.201.21.98] (10.201.21.98) by EQNDAG1NODE6.st.com
 (10.75.129.135) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 9 Aug
 2023 09:44:46 +0200
Message-ID: <f9ddac2f-28c0-1804-a1de-b8c8e9972638@foss.st.com>
Date:   Wed, 9 Aug 2023 09:44:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH 1/3] crypto: stm32/hash - Properly handle pm_runtime_get
 failing
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
 <20230731165456.799784-2-u.kleine-koenig@pengutronix.de>
From:   Thomas BOURGOIN <thomas.bourgoin@foss.st.com>
In-Reply-To: <20230731165456.799784-2-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.21.98]
X-ClientProxiedBy: EQNCAS1NODE4.st.com (10.75.129.82) To EQNDAG1NODE6.st.com
 (10.75.129.135)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-09_06,2023-08-08_01,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

Thanks for the modification.
This should be applied for fixes/stable.
Please add Cc: stable@vger.kernel.org in your commit message.

Best regards,

Thomas

On 7/31/23 18:54, Uwe Kleine-König wrote:
> If pm_runtime_get() (disguised as pm_runtime_resume_and_get()) fails, this
> means the clk wasn't prepared and enabled. Returning early in this case
> however is wrong as then the following resource frees are skipped and this
> is never catched up. So do all the cleanups but clk_disable_unprepare().
> 
> Also don't emit a warning, as stm32_hash_runtime_resume() already emitted
> one.
> 
> Note that the return value of stm32_hash_remove() is mostly ignored by
> the device core. The only effect of returning zero instead of an error
> value is to suppress another warning in platform_remove(). So return 0
> even if pm_runtime_resume_and_get() failed.
> 
> Fixes: 8b4d566de6a5 ("crypto: stm32/hash - Add power management support")
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>   drivers/crypto/stm32/stm32-hash.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
> index 88a186c3dd78..75d281edae2a 100644
> --- a/drivers/crypto/stm32/stm32-hash.c
> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -2121,9 +2121,7 @@ static int stm32_hash_remove(struct platform_device *pdev)
>   	if (!hdev)
>   		return -ENODEV;
>   
> -	ret = pm_runtime_resume_and_get(hdev->dev);
> -	if (ret < 0)
> -		return ret;
> +	ret = pm_runtime_get_sync(hdev->dev);
>   
>   	stm32_hash_unregister_algs(hdev);
>   
> @@ -2139,7 +2137,8 @@ static int stm32_hash_remove(struct platform_device *pdev)
>   	pm_runtime_disable(hdev->dev);
>   	pm_runtime_put_noidle(hdev->dev);
>   
> -	clk_disable_unprepare(hdev->clk);
> +	if (ret >= 0)
> +		clk_disable_unprepare(hdev->clk);
>   
>   	return 0;
>   }
