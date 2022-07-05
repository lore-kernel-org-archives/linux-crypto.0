Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAE06CCA47B
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 21:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiGEV4k (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 17:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGEV4k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 17:56:40 -0400
X-Greylist: delayed 541 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 14:56:39 PDT
Received: from mail.mleia.com (mleia.com [178.79.152.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24DA021D;
        Tue,  5 Jul 2022 14:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
        t=1657057657; bh=Nj8bf5uI6dLEDyt4JsseMDkg3U8ZxrrwBsjjIiK/16Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZNjXxGMHAIHa0LqTe04z3ilZZDpwp06hI6OFAyJKTSr0tHwEdbPBNVHTWF1908XnO
         TUnU1eJjiHb29dTgTlphZBMOfBNKRcvTnNMmGtX6Ij/DJ85//jLmbOgdChUhNGMdur
         WKTcVinigN5d5mKMMcHwkY3W1vajlsUv6URM3s5XCuWBlgOokABQaGRSGtOSegGIA+
         pqU/+ySKFKmnXHCL0Z6du76ih2iUVnY7X2sDLfcq0S2uMS55zZ2E42hgMWufB6qGo8
         7pmcfwoY007znr6ryCzLjjc4v/Ewb62MmhsBICE+lfE/APnQlZYr0FZHQveUJqJn14
         PoRjVhMmSh2bw==
Received: from mail.mleia.com (localhost [127.0.0.1])
        by mail.mleia.com (Postfix) with ESMTP id 62FC93C428C;
        Tue,  5 Jul 2022 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mleia.com; s=mail;
        t=1657057657; bh=Nj8bf5uI6dLEDyt4JsseMDkg3U8ZxrrwBsjjIiK/16Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZNjXxGMHAIHa0LqTe04z3ilZZDpwp06hI6OFAyJKTSr0tHwEdbPBNVHTWF1908XnO
         TUnU1eJjiHb29dTgTlphZBMOfBNKRcvTnNMmGtX6Ij/DJ85//jLmbOgdChUhNGMdur
         WKTcVinigN5d5mKMMcHwkY3W1vajlsUv6URM3s5XCuWBlgOokABQaGRSGtOSegGIA+
         pqU/+ySKFKmnXHCL0Z6du76ih2iUVnY7X2sDLfcq0S2uMS55zZ2E42hgMWufB6qGo8
         7pmcfwoY007znr6ryCzLjjc4v/Ewb62MmhsBICE+lfE/APnQlZYr0FZHQveUJqJn14
         PoRjVhMmSh2bw==
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi [88.112.131.206])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.mleia.com (Postfix) with ESMTPSA id E95463C414C;
        Tue,  5 Jul 2022 21:47:36 +0000 (UTC)
Message-ID: <aa7814a6-be62-efcb-8688-dbdfc6a396f0@mleia.com>
Date:   Wed, 6 Jul 2022 00:47:35 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 7/7] crypto: s5p-sss: Drop if with an always false
 condition
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel@pengutronix.de
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
 <20220705205144.131702-7-u.kleine-koenig@pengutronix.de>
From:   Vladimir Zapolskiy <vz@mleia.com>
In-Reply-To: <20220705205144.131702-7-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CRM114-Version: 20100106-BlameMichelson ( TRE 0.8.0 (BSD) ) MR-49551924 
X-CRM114-CacheID: sfid-20220705_214737_427206_4809590F 
X-CRM114-Status: GOOD (  16.47  )
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/5/22 23:51, Uwe Kleine-König wrote:
> The remove callback is only called after probe completed successfully.
> In this case platform_set_drvdata() was called with a non-NULL argument
> and so pdata is never NULL.
> 
> This is a preparation for making platform remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>   drivers/crypto/s5p-sss.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 7717e9e5977b..b79e49aa724f 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2321,9 +2321,6 @@ static int s5p_aes_remove(struct platform_device *pdev)
>   	struct s5p_aes_dev *pdata = platform_get_drvdata(pdev);
>   	int i;
>   
> -	if (!pdata)
> -		return -ENODEV;
> -
>   	for (i = 0; i < ARRAY_SIZE(algs); i++)
>   		crypto_unregister_skcipher(&algs[i]);
>   

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

--
Best wishes,
Vladimir
