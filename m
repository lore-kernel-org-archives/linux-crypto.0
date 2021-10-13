Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17902C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 19:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1FEC61208
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 19:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhJMT21 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 15:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhJMT20 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 15:28:26 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E88C06174E
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 12:26:22 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id r19so16074898lfe.10
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 12:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cqg6OlscZqEMvb/ReYXudBaSyipapWX2ho/bKAy2P6s=;
        b=QIG+ixl2Q4prZfyV2wCaaV06GK34fLeJljGPY2tmislnOnnZgid7OA0rtWBo2t1esQ
         afLbkXegUw8WteZuauN8DY9jGP1mQwJQaW3ImwlYDIdxUiDuLqIcY27qyI0RyBSXan/Z
         McxnsDpDOA8ZCTeLKYdTVX4lPhTSWMxeZUVvyNIxDQlqzvLav/ktJErSDZFwdFdV+OXC
         gwVnso03jrqpF7HGBdkBDmGG5QzCb9hOn71y9ANa75N0QrsXa4Wv9Eg/MSg2+nL6JtGX
         jPWdB7AWpsfuPYHmi5FfPW7/vIs8PGanB/plcFVlvijuJGnn+ii7JWR5WkwWhkEFVOlf
         pn1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cqg6OlscZqEMvb/ReYXudBaSyipapWX2ho/bKAy2P6s=;
        b=Z+yOHQ0NjejvCK8D4EALptOWjvwTFtqPQMpoIbeRGAOXNhh+u3ocVw1Dv69J+X5Bcv
         zvT6k7dDyOAB2HgDCTWRJKxUAV51by2XvFVIYl/RENxu6e4A7tg7r0zSmgHQ0XA0t8Hv
         5V5+0cJUmu+86YR8wrApqhct8my3S5jSkippIwz1t8uBOSwwR76jQwgGHGP5YJ+SDwX0
         9r1TKkryUhIPMaT01+z1IK8K0rx2Nh2CvLweDVqpyATgoO27jHFiwYo5pR55I4hCwfIk
         lmO0G8dzbyOOFPRLDENr5DGONqopfZNXzzTJlRawLa1qFlUCyh94bhfiP4F8UAqAVmJU
         q0sA==
X-Gm-Message-State: AOAM530Acd6pQVPGOUehJ/vlUa7JLWhxtEZ+Z1FmvbiJRIdtdhg43hxo
        GfeWME9947hs1TgMjcXRnymyVw==
X-Google-Smtp-Source: ABdhPJznjZnDpqOvqSdheZSC8P42iPnMdQCzy/Tnq4TKbALGTxj9GhVYDaxKh0Q/72NXCoIRKjTuew==
X-Received: by 2002:a05:6512:14b:: with SMTP id m11mr811712lfo.410.1634153181254;
        Wed, 13 Oct 2021 12:26:21 -0700 (PDT)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id g7sm31776lfr.113.2021.10.13.12.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 12:26:21 -0700 (PDT)
Subject: Re: [PATCH v4 17/20] crypto: qce: Print a failure msg in case probe()
 fails
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
 <20211013105541.68045-18-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <2699de22-4943-685f-5700-82137a4326ae@linaro.org>
Date:   Wed, 13 Oct 2021 22:26:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211013105541.68045-18-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 10/13/21 1:55 PM, Bhupesh Sharma wrote:
> Print a failure message (dev_err) in case the qcom qce crypto
> driver probe() fails.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 576c416461f9..cb8c77709e1e 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -281,6 +281,8 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   	icc_set_bw(qce->mem_path, 0, 0);
>   err_mem_path_put:
>   	icc_put(qce->mem_path);
> +
> +	dev_err(dev, "%s failed : %d\n", __func__, ret);
>   	return ret;
>   }
>   

As for me the rationale of this change is quite non-obvious, a user is well
informed, if a driver probe fails. I would rather ask you to consider to
drop this change.

--
Best wishes,
Vladimir
