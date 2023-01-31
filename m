Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440BDC636CC
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Jan 2023 09:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjAaJQ5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Jan 2023 04:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjAaJQl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Jan 2023 04:16:41 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A35B4ABE9
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 01:15:01 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg26so3981172wmb.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Jan 2023 01:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JEFHQqshriSboNUTzEj8MaZcbnH5v2lUUNCC6MiyvzM=;
        b=hxyW93s6gGcalC5yPXT1xea6ohkTqvKMRSppgXn6EFsNRFbdfu9QTvl7C+fOMKDtWl
         4FlNrYcwORW38QHdktehRkY3skw2+vs1QaqUQ7PNLNoUOVXCYCjwb0QCZRdY+9xSKY9Z
         60grinHwHBAcX3tcZwQbSmJNPVO1bLRG3WNHzO4qXX1AWDJFWiNgp2yD0tLOEb+wCLqa
         HPHqFjF6Fwjc+FnYTKconPE4cSMngChOTdH7hCcXCMNtK8aetyLEtfAszJFlvzZIQ/UO
         9/q4SruSp38179AwWI9UEeSEoY5pCH+xNqYmNr6lyjoUrCh/kvjLVup204IWJNOGR7KO
         /L5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEFHQqshriSboNUTzEj8MaZcbnH5v2lUUNCC6MiyvzM=;
        b=pmRCX6e6FbflOQYUmI2m93XttSmc+4A2FU+tyrUXza861DYgcnIDguD0xbSLmKlmrp
         lmI41vvzlN74nDpTWohdjmYYUteL0aF+WQ2b/NGPk6+0wF5NXM7vlxgf0WSne7CJPgbn
         kDAIunWOqPF0eYuAELJlUVCmRI7qr+jaqg6k0PV6Uxy/EpwP3GwupOlOUDY+HtMmL5nW
         A+PwIW63YZHGO7qPR8ZeWXE4otnRtzwPzRbGVKmjm7pd4t6QYbDr+BVKS2dJpYjMLxSc
         9vc4d9tGzfzzL8reSSblTzwtF6j3I6RvZiTOREXglEvwJjxwPdyd1F1fnhctpWV28x0N
         iswA==
X-Gm-Message-State: AO0yUKVgaUty16FDTHOgoUVmTjbePkLpH6Gatc3dlsw3PLSTyYMaaxdP
        /QfMUU0LCTfqhM/jlnUSPk6oMg==
X-Google-Smtp-Source: AK7set/lmawa5SUWcAQYOjPeT4SSesTJTzz82TutJ3zXngILBm3SYVWs6/6biL9L3BzY7kPRrd/ZsQ==
X-Received: by 2002:a05:600c:1714:b0:3dc:5e0d:4ce7 with SMTP id c20-20020a05600c171400b003dc5e0d4ce7mr5137401wmn.11.1675156493137;
        Tue, 31 Jan 2023 01:14:53 -0800 (PST)
Received: from [192.168.2.104] ([79.115.63.122])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c42c600b003dc521f336esm8332341wme.14.2023.01.31.01.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 01:14:52 -0800 (PST)
Message-ID: <f1968fc5-13b4-9d37-86e3-21eb8dd6c2aa@linaro.org>
Date:   Tue, 31 Jan 2023 11:14:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] crypto: atmel-i2c: Drop unused id parameter from
 atmel_i2c_probe()
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
References: <20230131081351.165235-1-u.kleine-koenig@pengutronix.de>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230131081351.165235-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 31.01.2023 10:13, Uwe Kleine-König wrote:
> id is unused in atmel_i2c_probe() and the callers have extra efforts to
> determine the right parameter. So drop the parameter simplifying both
> atmel_i2c_probe() and its callers.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>

thanks!

> ---
> Hello,
> 
> just found a nice optimisation while grepping for something else in the
> tree ...
> 
> Best regards
> Uwe
> 
>   drivers/crypto/atmel-ecc.c     | 3 +--
>   drivers/crypto/atmel-i2c.c     | 2 +-
>   drivers/crypto/atmel-i2c.h     | 2 +-
>   drivers/crypto/atmel-sha204a.c | 3 +--
>   4 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 12205e2b53b4..aac64b555204 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -313,11 +313,10 @@ static struct kpp_alg atmel_ecdh_nist_p256 = {
>   
>   static int atmel_ecc_probe(struct i2c_client *client)
>   {
> -	const struct i2c_device_id *id = i2c_client_get_device_id(client);
>   	struct atmel_i2c_client_priv *i2c_priv;
>   	int ret;
>   
> -	ret = atmel_i2c_probe(client, id);
> +	ret = atmel_i2c_probe(client);
>   	if (ret)
>   		return ret;
>   
> diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
> index 66e27f71e37e..83a9093eff25 100644
> --- a/drivers/crypto/atmel-i2c.c
> +++ b/drivers/crypto/atmel-i2c.c
> @@ -324,7 +324,7 @@ static int device_sanity_check(struct i2c_client *client)
>   	return ret;
>   }
>   
> -int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +int atmel_i2c_probe(struct i2c_client *client)
>   {
>   	struct atmel_i2c_client_priv *i2c_priv;
>   	struct device *dev = &client->dev;
> diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
> index c1fdc04eac07..c0bd429ee2c7 100644
> --- a/drivers/crypto/atmel-i2c.h
> +++ b/drivers/crypto/atmel-i2c.h
> @@ -167,7 +167,7 @@ struct atmel_i2c_work_data {
>   	struct atmel_i2c_cmd cmd;
>   };
>   
> -int atmel_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id);
> +int atmel_i2c_probe(struct i2c_client *client);
>   
>   void atmel_i2c_enqueue(struct atmel_i2c_work_data *work_data,
>   		       void (*cbk)(struct atmel_i2c_work_data *work_data,
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 272a06f0b588..4403dbb0f0b1 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -93,11 +93,10 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
>   
>   static int atmel_sha204a_probe(struct i2c_client *client)
>   {
> -	const struct i2c_device_id *id = i2c_client_get_device_id(client);
>   	struct atmel_i2c_client_priv *i2c_priv;
>   	int ret;
>   
> -	ret = atmel_i2c_probe(client, id);
> +	ret = atmel_i2c_probe(client);
>   	if (ret)
>   		return ret;
>   
> 
> base-commit: f160a0e64f0f80a82f797ea7aa007e41ba8ed441
