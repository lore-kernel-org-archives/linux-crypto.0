Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B85C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 06:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiGFGeq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 02:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiGFGeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 02:34:46 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1667F658C
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 23:34:45 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id j23so487103lji.13
        for <linux-crypto@vger.kernel.org>; Tue, 05 Jul 2022 23:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i1BMPZ/ewrNPyYNCuyDmgoFFvJ41CYWagfxQdw0+v9Y=;
        b=Lo3trhbMqgjZoPdYYcnbvZhtIDuRabm8nZMnEBZyQLC3yvna+fxEmTnLai4ERTFrjg
         Iku7oKbwE8nsfygrKY5QkTPgJwjCFB+yo8fBRSE/GYqfQHK2X0GaZnUwN1bgPkivjtvY
         Nq7wx99tOa19wMED8G1K+jXoXERDjWhWZyQuyiIdeTkhHlQct6EYgTTR9Oz1brCFcage
         z8GLW5ePAoeK/iD0gCYSAfwHnq9kgSi6YhPWPvJH39exY03QmzaFpimDy7A/6wkojpHD
         a/UEo66WF8Snyuhk+m3P85WkTDNmIahYSH7DrEgoj+wDK0fGWt5HBwVyKIFGtZoSHnwf
         /z8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i1BMPZ/ewrNPyYNCuyDmgoFFvJ41CYWagfxQdw0+v9Y=;
        b=Ia7rI2oa3vCuKrEZuEzLIbGGwqLXOfuFD9sqFeus8gF74wjZDjf7LYGAsU+0GWwI8g
         ZB888aKGq6FQQKnYSkrIhj6Yn/sPLDtCwbfslapL3KLRpj9iMWXRKHya5KA0uGgj5e4N
         C7LmVJza/8Ae4BtVqPLb7WLm4zEiWWqGmGZkjRYXikdFhdzdY6Hm6N8R+lwcXi0v7AWf
         6I4Mr/vFe+2VIkFvdceN+erVZ5BeZ3kiIyMDB9goN0sQgyYSR0t/wt0v0/vyvcAn7gQ0
         Xu3sQf7JVKO14/iXm1s19h4Gr4Mw2oBdEnJvT89x5b7sBftH4PFxenVpMf8M5WRjJa1U
         8fUg==
X-Gm-Message-State: AJIora/153g+WicFPeeMpcsapTMiuK2VQJn43wKCCtJfGxRSnzn1WVOy
        59SZow5WQMMegZ9ptBRkW2Jjsw==
X-Google-Smtp-Source: AGRyM1tngCb/QoxR46x5xt4ID2Ocox7HpE23Iw/rnbB/1UGPcOBz34iXoDNTfziafJKa4Utr8OAANQ==
X-Received: by 2002:a2e:9d84:0:b0:25b:c7f1:c978 with SMTP id c4-20020a2e9d84000000b0025bc7f1c978mr22662876ljj.126.1657089283491;
        Tue, 05 Jul 2022 23:34:43 -0700 (PDT)
Received: from [192.168.1.52] ([84.20.121.239])
        by smtp.gmail.com with ESMTPSA id c4-20020a196544000000b0047f6fe39bb9sm6113165lfj.27.2022.07.05.23.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 23:34:43 -0700 (PDT)
Message-ID: <8c221a4b-8a66-f142-d57c-2d6b9ed047b0@linaro.org>
Date:   Wed, 6 Jul 2022 08:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 7/7] crypto: s5p-sss: Drop if with an always false
 condition
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kernel@pengutronix.de
References: <20220705205144.131702-1-u.kleine-koenig@pengutronix.de>
 <20220705205144.131702-7-u.kleine-koenig@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220705205144.131702-7-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 05/07/2022 22:51, Uwe Kleine-König wrote:
> The remove callback is only called after probe completed successfully.
> In this case platform_set_drvdata() was called with a non-NULL argument
> and so pdata is never NULL.
> 
> This is a preparation for making platform remove callbacks return void.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
