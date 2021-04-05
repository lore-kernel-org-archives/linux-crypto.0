Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C106FC433ED
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 809E9613D6
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhDEWXY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 18:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbhDEWXY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 18:23:24 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F841C061756
        for <linux-crypto@vger.kernel.org>; Mon,  5 Apr 2021 15:23:17 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id z15so13049268oic.8
        for <linux-crypto@vger.kernel.org>; Mon, 05 Apr 2021 15:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ky3Mb7bPQtqaP2BIFct2mjgskwKoT25u7uZeAyvH+30=;
        b=pNFbmgXu918kaPLZI7ByrZ7NFY23efWQ9FbUs+DKyyNFEQ11dsaJ8B36Fjn1lrW7iF
         kUsVEGZwz+ncH2/scECwQEsP6QXZnzLlONdswe/tiYWz54iUrVzrZ03lHIf8cgmBZfHZ
         uR55PpPOuva7JXoQ/4fa2Vy3YJ33R11ACLdRF++nJ7yS1t+r8B1kstFaxmZdozASr+Oq
         ajuN+gQbNhiUi/np4eh9QdJ9wwRQ8HnNc3apdQnoXBOyX4BNCsW8R7NceTcW4yYBdS1R
         kyKmerRFSmFSxd5aUrIAHPlZ2YxqYMwbN1umm1dkuFJJ243kcjE86AAr7FcDZMpjjMKd
         OF0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ky3Mb7bPQtqaP2BIFct2mjgskwKoT25u7uZeAyvH+30=;
        b=O4NRjls4xzb8MUXJC8Z/Ao8Qw6+t/hC3vMTOYSbC5LEDqnY/lGqKRxvI4yqTNtfpD7
         wG+GfgNWVA0/8EfUMxcqzlDDfZwYdFfd0Tv0H/rrMjFXamcFJr4YPze46EHwTt68QhBK
         9YW5XRvyAXlsPOc7hZOrw0FeZhnLyZ1fFw4sFOa8GvcJ3M1X+L+y646VTPNHuRt/l0UD
         3UJ1s7MoeFDd9R2PT+lnRsW/vpZLaGlOZ7zyDebpQwSEE8sQ8+NnBTD9vjLR9oaxEU7C
         SL7y4xHNMk8zicFZooBU/+WAr7mPl4wOyMl3chLi439ckZukiobmYyPXoDUl/8whmHwk
         IgUA==
X-Gm-Message-State: AOAM531N6MoQJbZEC6myoMvs1Rt3NnRLmUdwAs9fvYjg82g+ApwiZ1WZ
        07/rAsfFwtq5GUlkBb0V0sB5VZnUGp8ZbA==
X-Google-Smtp-Source: ABdhPJwWmJZu+Tz7ftUhVSI3sG478q8f8K40hmLekySf3zqgRbClQ76HEcKl28tf+pzu/0PINkOEHw==
X-Received: by 2002:a05:6808:483:: with SMTP id z3mr953203oid.166.1617661396524;
        Mon, 05 Apr 2021 15:23:16 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id v65sm3351764oib.42.2021.04.05.15.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 15:23:16 -0700 (PDT)
Date:   Mon, 5 Apr 2021 17:23:13 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] crypto: qce: common: Make result dump optional
Message-ID: <20210405222313.GB904837@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-3-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225182716.1402449-3-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:

> Qualcomm crypto engine allows for IV registers and status register
> to be concatenated to the output. This option is enabled by setting the
> RESULTS_DUMP field in GOPROC  register. This is useful for most of the
> algorithms to either retrieve status of operation or in case of
> authentication algorithms to retrieve the mac. But for ccm
> algorithms, the mac is part of the output stream and not retrieved
> from the IV registers, thus needing a separate buffer to retrieve it.
> Make enabling RESULTS_DUMP field optional so that algorithms can choose
> whether or not to enable the option.
> Note that in this patch, the enabled algorithms always choose
> RESULTS_DUMP to be enabled. But later with the introduction of ccm
> algorithms, this changes.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/crypto/qce/common.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index 7c3cb483749e..2485aa371d83 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -88,9 +88,12 @@ static void qce_setup_config(struct qce_device *qce)
>  	qce_write(qce, REG_CONFIG, config);
>  }
>  
> -static inline void qce_crypto_go(struct qce_device *qce)
> +static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
>  {
> -	qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
> +	if (result_dump)
> +		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
> +	else
> +		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
>  }
>  
>  #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
> @@ -219,7 +222,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
>  	config = qce_config_reg(qce, 1);
>  	qce_write(qce, REG_CONFIG, config);
>  
> -	qce_crypto_go(qce);
> +	qce_crypto_go(qce, true);
>  
>  	return 0;
>  }
> @@ -380,7 +383,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
>  	config = qce_config_reg(qce, 1);
>  	qce_write(qce, REG_CONFIG, config);
>  
> -	qce_crypto_go(qce);
> +	qce_crypto_go(qce, true);
>  
>  	return 0;
>  }
> -- 
> 2.25.1
> 
