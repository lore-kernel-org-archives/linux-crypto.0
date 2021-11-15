Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32144C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C37363237
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 20:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350530AbhKOUYf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 15:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343855AbhKOTWQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411F3C048763
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:25:33 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id w199so3425667oiw.4
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HN1NCx7JIMUsBaK251BKMLk0H2MuiMh68RpU4GH1CmE=;
        b=j1zjZJIRex2oI/rVE3FDpbG8gf/28UiJJikSonSFlO/ubi7n7t1qhmJA9Zk3BkVcZ/
         r2AG7tOj+Y0vTIMJGVv5lNIlFT/Ea/3XdXs5H7doFHzYhpiLaLITKWuxts37XO5k4vW+
         G2SD6hcAuHcizsnUUwkGjZ7jrEt4d3+jQXIZzB75b+FDcUiaWdv52rVJg4Zc/5eCGXiH
         iN3kfUoszXr4zjcMiv3TYgKoD9Ehul81Lc105bri7AY4FwUcwkSp7zakpkRdxERZOFrh
         lgady0BwgMrhT1VML4vY3OtJYE2RiXxFUuBgLOBP1YGs2KVWLHnDn4erSrw2bXg3yeQr
         LnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HN1NCx7JIMUsBaK251BKMLk0H2MuiMh68RpU4GH1CmE=;
        b=imGjtv+hJiAygBveU9eut177H0B8XlbeoB4OsBrV+aUPbTI/bZBcsqwkh2svj+xy0d
         hmvG989UqC46DK4B9CySK6FjOY+yiPZZcq4tvG8u+YoohWGoIWZ1XyLgxgU6DB0DPQsY
         5Zjxy6VwDaYupBaLoedITi8O9cu/pj+n+8vRb3tLXpCVDK4RmKpDHdT4gvlNaEuZwIue
         9zkO+SV4QZjbnmBUrC2ka0izfifd6zbcGHjPRCMGR2Winb6NmN4BotjKxP7GEeHUoKSh
         MD88VkoTNGO+gvIbXR6/qiU3OdNToGxCQleDL3RyGydyGvKmwDlApFlVm7lQLY03nS3y
         CVEw==
X-Gm-Message-State: AOAM533MCHEddd9+uj4KKwcaaZu4n7VOFXKuMbkSESsX7IGTGQ+9HjUh
        NUEW6m4YMuVfFlbdwOXdPirlwA==
X-Google-Smtp-Source: ABdhPJzH0ytwU5FPl3q9BO3pRs6hkdUarp2Wku4ZUD3QY7RBfhFr0NjvEvckp86XBdj5+brPW5lVBA==
X-Received: by 2002:aca:2205:: with SMTP id b5mr624000oic.177.1637000732576;
        Mon, 15 Nov 2021 10:25:32 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 64sm3103622otm.37.2021.11.15.10.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:25:32 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:25:27 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v5 14/22] crypto: qce: core: Add support to initialize
 interconnect path
Message-ID: <YZKmF06Z4JehoQoM@builder.lan>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-15-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110105922.217895-15-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 10 Nov 04:59 CST 2021, Bhupesh Sharma wrote:

> From: Thara Gopinath <thara.gopinath@linaro.org>
> 
> Crypto engine on certain Snapdragon processors like sm8150, sm8250, sm8350
> etc. requires interconnect path between the engine and memory to be
> explicitly enabled and bandwidth set prior to any operations. Add support
> in the qce core to enable the interconnect path appropriately.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> [Make header file inclusion alphabetical and use devm_of_icc_get()]
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/core.c | 34 +++++++++++++++++++++++++++-------
>  drivers/crypto/qce/core.h |  1 +
>  2 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index d3780be44a76..89d9c01ba009 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/interconnect.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/mod_devicetable.h>
> @@ -22,6 +23,8 @@
>  #define QCE_MAJOR_VERSION5	0x05
>  #define QCE_QUEUE_LENGTH	1
>  
> +#define QCE_DEFAULT_MEM_BANDWIDTH	393600
> +
>  static const struct qce_algo_ops *qce_ops[] = {
>  #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
>  	&skcipher_ops,
> @@ -206,21 +209,35 @@ static int qce_crypto_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		return ret;
>  
> +	qce->mem_path = devm_of_icc_get(qce->dev, "memory");
> +	if (IS_ERR(qce->mem_path))
> +		return PTR_ERR(qce->mem_path);
> +
>  	qce->core = devm_clk_get(qce->dev, "core");
> -	if (IS_ERR(qce->core))
> -		return PTR_ERR(qce->core);
> +	if (IS_ERR(qce->core)) {
> +		ret = PTR_ERR(qce->core);
> +		goto err;

I don't see a reason here, or in the following patches to move from
return to goto here.

Regards,
Bjorn

> +	}
>  
>  	qce->iface = devm_clk_get(qce->dev, "iface");
> -	if (IS_ERR(qce->iface))
> -		return PTR_ERR(qce->iface);
> +	if (IS_ERR(qce->iface)) {
> +		ret = PTR_ERR(qce->iface);
> +		goto err;
> +	}
>  
>  	qce->bus = devm_clk_get(qce->dev, "bus");
> -	if (IS_ERR(qce->bus))
> -		return PTR_ERR(qce->bus);
> +	if (IS_ERR(qce->bus)) {
> +		ret = PTR_ERR(qce->bus);
> +		goto err;
> +	}
> +
> +	ret = icc_set_bw(qce->mem_path, QCE_DEFAULT_MEM_BANDWIDTH, QCE_DEFAULT_MEM_BANDWIDTH);
> +	if (ret)
> +		goto err;
>  
>  	ret = clk_prepare_enable(qce->core);
>  	if (ret)
> -		return ret;
> +		goto err_mem_path_disable;
>  
>  	ret = clk_prepare_enable(qce->iface);
>  	if (ret)
> @@ -260,6 +277,9 @@ static int qce_crypto_probe(struct platform_device *pdev)
>  	clk_disable_unprepare(qce->iface);
>  err_clks_core:
>  	clk_disable_unprepare(qce->core);
> +err_mem_path_disable:
> +	icc_set_bw(qce->mem_path, 0, 0);
> +err:
>  	return ret;
>  }
>  
> diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
> index 085774cdf641..228fcd69ec51 100644
> --- a/drivers/crypto/qce/core.h
> +++ b/drivers/crypto/qce/core.h
> @@ -35,6 +35,7 @@ struct qce_device {
>  	void __iomem *base;
>  	struct device *dev;
>  	struct clk *core, *iface, *bus;
> +	struct icc_path *mem_path;
>  	struct qce_dma_data dma;
>  	int burst_size;
>  	unsigned int pipe_pair_id;
> -- 
> 2.31.1
> 
