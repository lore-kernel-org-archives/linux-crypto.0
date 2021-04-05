Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1B8C433ED
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F75B613D9
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Apr 2021 22:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhDEWc6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Apr 2021 18:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbhDEWc5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Apr 2021 18:32:57 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C137C061756
        for <linux-crypto@vger.kernel.org>; Mon,  5 Apr 2021 15:32:50 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 68-20020a9d0f4a0000b02901b663e6258dso12736285ott.13
        for <linux-crypto@vger.kernel.org>; Mon, 05 Apr 2021 15:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yjPJwTgEEcZdNSuKzyQlQgPz3fsRy1o33yFNzxrrfac=;
        b=xAXIV4X/g6BfggIfAFOUMGYh4Qis6ID9Rp+nCu/5HpbbtRmk6sgPyzhuH4imjBuSuc
         fkAoiT0P5ZaihDOaUgy8Us/d+uAMpOK4jdAmqB2Z60vp6DcHXNtN5CjXKR6SCbXdUzpB
         wurVZZTQpQRh0/laCKet/OfkyPE/OLoYGkRlq6YYKnckWX8e55KmI6svRADScEezsa6U
         PJOzu214E5nYo4x13XzJfhBaDzFGPm/TwUKxX101NWVuwyCpLaJ+5t475irN19ApFsx3
         usqcx8L95XSar3XRjpLBWl+4Ugbm2eL46ndGRWW4TjTmSevdo5Ow/5+1MBkw5Re60gj0
         hu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yjPJwTgEEcZdNSuKzyQlQgPz3fsRy1o33yFNzxrrfac=;
        b=MDSFEXkhJPoDZq83cTklJBa3Xf/qJclNjHjUpCxhNfgrqKuwnElFrqvYL0sIrOcQZx
         Z1ukj1r/6DqdxLtRZOrQnmaI3ILrQaEQA8WcOVn9sptxtNOVgBI2FENnlPbOGjJV22FX
         VY8gGmHjWH2w1OW8Nwdrsw9RZcZoXaht2lxIS6MMul8RpmYXxBnOzrd6k13Gsp+Hoqtf
         aXBltlZMT96Hu8e0+OaQE22BxITF2w9bUsCkc1ATmqbt34FVGeIJyuUGkoJLdzm6cChd
         R48Lyl3atzovgirUgirVCV7IF25cC75I9MS8eKrcAlpDu+UO1mgQuZYGlSsHh8Y0In03
         95GA==
X-Gm-Message-State: AOAM530CxwYb0gOLqqJaT4UKbBFjOOBQ7wx43pXj4INRgGQgsKPz2sJW
        y/o33ARLCXqZ5MFdT6WW7ikJMXZKmOGZbA==
X-Google-Smtp-Source: ABdhPJw8JfV6bWrAR19dcf37Wd/Jg1+1EQEokY3+VsHwPAew4dvfVPqK2ZNPlzNagWez4h8f76SNNA==
X-Received: by 2002:a05:6830:2248:: with SMTP id t8mr23660323otd.211.1617661970066;
        Mon, 05 Apr 2021 15:32:50 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id z14sm3293523oid.12.2021.04.05.15.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 15:32:49 -0700 (PDT)
Date:   Mon, 5 Apr 2021 17:32:47 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] crypto: qce: Add mode for rfc4309
Message-ID: <20210405223247.GC904837@yoga>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
 <20210225182716.1402449-4-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225182716.1402449-4-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu 25 Feb 12:27 CST 2021, Thara Gopinath wrote:

> rf4309 is the specification that uses aes ccm algorithms with IPsec
> security packets. Add a submode to identify rfc4309 ccm(aes) algorithm
> in the crypto driver.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/common.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
> index 3bc244bcca2d..3ffe719b79e4 100644
> --- a/drivers/crypto/qce/common.h
> +++ b/drivers/crypto/qce/common.h
> @@ -51,9 +51,11 @@
>  #define QCE_MODE_CCM			BIT(12)
>  #define QCE_MODE_MASK			GENMASK(12, 8)
>  
> +#define QCE_MODE_CCM_RFC4309		BIT(13)
> +
>  /* cipher encryption/decryption operations */
> -#define QCE_ENCRYPT			BIT(13)
> -#define QCE_DECRYPT			BIT(14)
> +#define QCE_ENCRYPT			BIT(14)
> +#define QCE_DECRYPT			BIT(15)

Can't we move these further up, so that next time we want to add
something it doesn't require that we also move the ENC/DEC bits?

>  
>  #define IS_DES(flags)			(flags & QCE_ALG_DES)
>  #define IS_3DES(flags)			(flags & QCE_ALG_3DES)
> @@ -73,6 +75,7 @@
>  #define IS_CTR(mode)			(mode & QCE_MODE_CTR)
>  #define IS_XTS(mode)			(mode & QCE_MODE_XTS)
>  #define IS_CCM(mode)			(mode & QCE_MODE_CCM)
> +#define IS_CCM_RFC4309(mode)		((mode) & QCE_MODE_CCM_RFC4309)

While leaving room for the typical macro issues, none of the other
macros wrap the argument in parenthesis. Please follow the style of the
driver, and perhaps follow up with a cleanup patch that just wraps them
all in parenthesis?

Regards,
Bjorn

>  
>  #define IS_ENCRYPT(dir)			(dir & QCE_ENCRYPT)
>  #define IS_DECRYPT(dir)			(dir & QCE_DECRYPT)
> -- 
> 2.25.1
> 
