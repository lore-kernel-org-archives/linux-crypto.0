Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F55BC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 03:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CECC610CD
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Apr 2021 03:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhDSDCo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 18 Apr 2021 23:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbhDSDCn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 18 Apr 2021 23:02:43 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83648C061761
        for <linux-crypto@vger.kernel.org>; Sun, 18 Apr 2021 20:02:14 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id e89-20020a9d01e20000b0290294134181aeso5504544ote.5
        for <linux-crypto@vger.kernel.org>; Sun, 18 Apr 2021 20:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7wC8QKTZ9xEtfwhjX+LEpEPMChmLBOlIJZB30u0tbsA=;
        b=Uvdz1wJBOBjBaXaPv6ZIzSTvt21UnnYo9XTaOjEIipgENy1+TkdxAELnu9I11RV3xM
         ewyJmzytDcNgT0mul+pu7uItN8CdSU0E/OjJl+I1o6I5xYNGRQoBoeBNB83BaTVFo4L9
         mLIzUbdEVt9YMoHLINVWGKECJeFo0k69soG2KxlBR9CwMULm/A3kbLuWd2+If5kXjRr+
         t/xurUh2hYvGMqSksLyPOOSJaTNb5C3T1u1z/7L9O8d2Dt8DaWMXmPsucKpdiqutgbKo
         MhqqRyVCR9Bs2wQ4VdiUebeSUJiRI5x2zoqDKcfc0YLZlL5YwGJ0eVaiTZ0ZBk5n6L2o
         1wAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7wC8QKTZ9xEtfwhjX+LEpEPMChmLBOlIJZB30u0tbsA=;
        b=mP09Vjl9ofgi8XkpOLFieztezUlBxvVSP4snzAWZrZoIOHIswxcSUminelfwX1YLcf
         5JL3TdMv9qwLhepcvjMK/0WAzLTf7iybjexnPyBbbQLVEckngG/VPDmBP7jSLk+1hsSG
         6BazhYoccDy23Nj3PYTihJBDSvwWOFHqqpUThOFzw4QgT0Fuo/pMAZHg6OPMycVZge9T
         HXEAERE4lmC+3uhdPcmy1OoJ3QhKIB+SUPa75joypEYtq24hR53rNOsQai/Uu2szqdHp
         Aq5sKKG/0fOUtVnK9O+dD8K/A+PfmpQxTHb2AC9MzGNf0pkSZnxkSTCAgt0fCos4mWF1
         qMTg==
X-Gm-Message-State: AOAM531a13i0HYz7WfI4uo2MYcHTviR/HZoQsWTBYpr/iuOgkeHvJ7cg
        yesx33ctuMQqvVzL7G5n+noNuA==
X-Google-Smtp-Source: ABdhPJxVKdpll0qVOlEiXZSl3AiLgR5ik1EzcgMRAExmmeNOHf0qqRZ5lcvvMZI/VPmYGynZ1uHgng==
X-Received: by 2002:a9d:5541:: with SMTP id h1mr12472367oti.246.1618801333755;
        Sun, 18 Apr 2021 20:02:13 -0700 (PDT)
Received: from yoga (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a6sm2863108oiw.44.2021.04.18.20.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 20:02:13 -0700 (PDT)
Date:   Sun, 18 Apr 2021 22:02:11 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [Patch v2 1/7] crypto: qce: common: Add MAC failed error checking
Message-ID: <20210419030211.GI1538589@yoga>
References: <20210417132503.1401128-1-thara.gopinath@linaro.org>
 <20210417132503.1401128-2-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210417132503.1401128-2-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat 17 Apr 08:24 CDT 2021, Thara Gopinath wrote:

> MAC_FAILED gets set in the status register if authenthication fails
> for ccm algorithms(during decryption). Add support to catch and flag
> this error.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
> 
> v1->v2:
> 	- Split the error checking for -ENXIO and -EBADMSG into if-else clause
> 	  so that the code is more readable as per Bjorn's review comment.
> 
>  drivers/crypto/qce/common.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index dceb9579d87a..dd76175d5c62 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -419,6 +419,8 @@ int qce_check_status(struct qce_device *qce, u32 *status)
>  	 */
>  	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
>  		ret = -ENXIO;
> +	else if (*status & BIT(MAC_FAILED_SHIFT))
> +		ret = -EBADMSG;
>  
>  	return ret;
>  }
> -- 
> 2.25.1
> 
