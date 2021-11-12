Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B11C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2387760EDF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 10:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhKLKpl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 05:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhKLKpl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 05:45:41 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83635C061766
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:42:50 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f3so21175720lfu.12
        for <linux-crypto@vger.kernel.org>; Fri, 12 Nov 2021 02:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7EZ9QdgsdMAEVS3fE4SgINpNgX5xY0FsGu/mWvtIiQI=;
        b=IyfkYPacfZPnzhtulkfztchRIHnAT3Pu34SkkJh/8WnLOSqJHfCuK65VikFPNLJv9R
         /ZzsDa85wBpTIYScMQ7gsFDW126gMmxhPpx+V06SXgrLVOc3sblbJR4N8kyNdNsB5eZi
         GmBTKJoHiGnldBugYnYVEN2lqQUUUDhIGiuLTFEJ4xjIfozdoeeSQ0V0n+8FW7CxH73U
         Qx1HeN0sOO4TeWmADhQdhYqw4iNZnk6JWiycGHU4chYRg8dP2t5kC/xczz+RXs3fKXMu
         e+q8u7dA3vP1d/5Se3np6X69hBPadoeqJWfx9LQpZ9EeEl3ELuHX05w4hGKkDPkoY3x/
         4hgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7EZ9QdgsdMAEVS3fE4SgINpNgX5xY0FsGu/mWvtIiQI=;
        b=lxua8/uGBEVpC86GWo+baupTqkX4Kzi7NXrjwhyF6CcVWHTlxG8vJtbOU7L/ELkj4c
         BjzNfwGS4m4JW6cDuYrn1dt4iCOXZBn9OEJKsIgk4IMTo3MNe++aMCrAIstRQSCN48NS
         BsN6dotWRNXQaXrD2+OarOeyb2QE9yOzN6ofpK5NepvOADfbBm4ywwxEZ84X/fBY0uqK
         bHYkjs1peWexlCZEHROwqbDR282wfFIfQ8hjqdIJLbyyzT76pMICl2w/Syxe7ypn+MnE
         kutSrS4AjPehqqhUuArhxYKW4dejt/m/6j5oS/bYI/1Zn55W4sO8iOeg/G/6kaJe2l4w
         RgxA==
X-Gm-Message-State: AOAM533n+cC/bBRFrFammtYQ1a++QmR2lxP8835d9zwBxZi6kTtimtcw
        x1g97ijMIK7V9jXcxjwn/6aPwFGWclDJUFQA
X-Google-Smtp-Source: ABdhPJxc3CpcqYaTYVf/JJGUSc6lfqaDL4QcpqKBIaKsyDpKTEvakzYd+ikLWV0ZlWpi6tUbRfVkQg==
X-Received: by 2002:ac2:5f0d:: with SMTP id 13mr13334331lfq.334.1636713768917;
        Fri, 12 Nov 2021 02:42:48 -0800 (PST)
Received: from [192.168.1.102] (62-248-207-242.elisa-laajakaista.fi. [62.248.207.242])
        by smtp.gmail.com with ESMTPSA id x27sm529171lfq.192.2021.11.12.02.42.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 02:42:48 -0800 (PST)
Subject: Re: [PATCH v5 17/22] crypto: qce: Print a failure msg in case probe()
 fails
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-18-bhupesh.sharma@linaro.org>
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Message-ID: <5b8d5f23-e766-5b9c-986c-ef70fae9119e@linaro.org>
Date:   Fri, 12 Nov 2021 12:42:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20211110105922.217895-18-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Bhupesh,

On 11/10/21 12:59 PM, Bhupesh Sharma wrote:
> Print a failure message (dev_err) in case the qcom qce crypto
> driver probe() fails.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>   drivers/crypto/qce/core.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 98784d63d78c..7c90401a2ef1 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -280,6 +280,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>   err_mem_path_disable:
>   	icc_set_bw(qce->mem_path, 0, 0);
>   err:
> +	dev_err(dev, "%s failed : %d\n", __func__, ret);
>   	return ret;
>   }
>   
> 

in my opinion expressed earlier this change is not needed, but I'll recede,
if somebody thinks that the change is useful in any way.

--
Best wishes,
Vladimir
