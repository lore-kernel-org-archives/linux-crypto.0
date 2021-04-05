Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4D6C433B4
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 17:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D806139C
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 17:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhDERgK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 13:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbhDERgK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 13:36:10 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98F6C061756
        for <linux-crypto@vger.kernel.org>; Mon,  5 Apr 2021 10:36:03 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id k14-20020a9d7dce0000b02901b866632f29so12098989otn.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Apr 2021 10:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uvBqI5LLvRFtdjvhHMzIwW+X8uV/Zp+Lovztxp6VJ4w=;
        b=fUP3qK17/KaPMsE2LnwkmKTdx7+dSSORtmIVYZCrJOzgTpKiQy+fBhQVrREleOuwUK
         kYOtGm/cn/+mHNRXZB1ftCoHg+6sUjmD3Pd1ZMaVKOxdESu8omPL0HPEXhfMbaogbGLD
         Gs/HTPxWzhnlziLAGGxemZhXTPzgsglK8J8hhj1VF2oWBAdJPUDxM/SreGcQphJVbKs+
         rlwscgf8fcFahwZJhrDeX9nnLPiKhUsB7yJWIobT83jyG29kxNqu3h1mODnWwKn/yalK
         U1+N9rHXDLIgRxMxLCtltFh3VIj9Qm80LKNv2mdZPveYA6m+50v4ErsEgsDia4jLUZNZ
         EnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uvBqI5LLvRFtdjvhHMzIwW+X8uV/Zp+Lovztxp6VJ4w=;
        b=c0RkbK33vG2+ukoMJKchm4mEm5xMcKxAeRU+3URiMPWtCOgAEYRMizXQ9/xIPQ7KLB
         Q4kmIs7nzWzfJIYo+SLle9lpGVuPhs86DXiXzrtMKo1HgNBe7Z3w1vDMvbD4LAuiy+FL
         uTxQl9eoipjgrszhCSgo0DiENcQJuvV2AKAuSoPXjrNUq5XeGaN56JOboodn2dU+rWBY
         BAndytIaaP68N4AO70sGDCyymVg9Gy169Koxg0RRZpd5CWp0+KCBfzunGcx1FD9s+JsY
         918hzOQgOzBTT9V/mrq80OKa9BlF/AxtyC/wv9Nxq0k2A4iI72CglfTtzkV9LqXh4VA7
         CLmg==
X-Gm-Message-State: AOAM533uFARh/FJ1DHyh6UMwTpBOICJD/ILIB6P0/dYUCe+qwFlGs28m
        In2abA7k8fGJ+TnytksFfDiYtw==
X-Google-Smtp-Source: ABdhPJyOjPlUIIsRgTB1kbybdtdLayhuc6MByRfZJcmc55UCubZxqOpYUyINVOx69nj7sRjB4NHO3w==
X-Received: by 2002:a9d:5191:: with SMTP id y17mr22900095otg.332.1617644163058;
        Mon, 05 Apr 2021 10:36:03 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id 7sm3173579ois.20.2021.04.05.10.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 10:36:02 -0700 (PDT)
Date:   Mon, 5 Apr 2021 12:36:00 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] crypto: qce: common: Add MAC failed error checking
Message-ID: <20210405173600.GZ904837@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-2-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225182716.1402449-2-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:

> MAC_FAILED gets set in the status register if authenthication fails
> for ccm algorithms(during decryption). Add support to catch and flag
> this error.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/common.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index dceb9579d87a..7c3cb483749e 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -403,7 +403,8 @@ int qce_start(struct crypto_async_request *async_req, u32 type)
>  }
>  
>  #define STATUS_ERRORS	\
> -		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) | BIT(HSD_ERR_SHIFT))
> +		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) |	\
> +		 BIT(HSD_ERR_SHIFT) | BIT(MAC_FAILED_SHIFT))
>  
>  int qce_check_status(struct qce_device *qce, u32 *status)
>  {
> @@ -417,8 +418,12 @@ int qce_check_status(struct qce_device *qce, u32 *status)
>  	 * use result_status from result dump the result_status needs to be byte
>  	 * swapped, since we set the device to little endian.
>  	 */
> -	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
> -		ret = -ENXIO;
> +	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT))) {
> +		if (*status & BIT(MAC_FAILED_SHIFT))

Afaict MAC_FAILED indicates a different category of errors from the
others. So I would prefer that the conditionals are flattened.

Is OPERATION_DONE set when MAC_FAILED?

If so:

if (errors || !done)
	return -ENXIO;
else if (*status & BIT(MAC_FAILED))
	return -EBADMSG;

Would be cleaner in my opinion.

Regards,
Bjorn

> +			ret = -EBADMSG;
> +		else
> +			ret = -ENXIO;
> +	}
>  
>  	return ret;
>  }
> -- 
> 2.25.1
> 
