Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913C5C433E9
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 06:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA8D6529C
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 06:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCIGo6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 01:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCIGo2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 01:44:28 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB20C06174A;
        Mon,  8 Mar 2021 22:44:27 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id w7so875898wmb.5;
        Mon, 08 Mar 2021 22:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2JHRd50/kPLmHMK3WxdvVTSTozSu9PH/WpTXEeChnyE=;
        b=ghr9Qad7J9ZRYAnGAi34lefkzp2nEB/e5LE6P8WH8HiwQPm7/Ut12LxCTvGqL0zWON
         PqOXx8EK0S04QM3vo4f/+gRtinYef7cZ36Be4LPWvPo/9YDfbg5ONNQ8SajbxRcVTTYa
         Q2tdOnrySrojnRiSxFNglImAVDSnYZEuFe+HNnLvkILAQ+x4t13o3oMsJ/S38otaAVYT
         +RxacbGOdgFFQ3NUjwda7ywOnhoLGj+duCzy5Qg8TSB/AjHofdF9lhXWRBZaG6NRN62T
         TiLlNMuznCH1xYii7sIHVN/Q9x2FHbj+ok0oXmEotNGQBgrpR4c463gtYntyPX9GWvpX
         Bovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2JHRd50/kPLmHMK3WxdvVTSTozSu9PH/WpTXEeChnyE=;
        b=nohWcF/Di6EAWxBPTlfpzG45eop/TDwvipfcRTcZnYpi4ue3kXrax7/UIWFIuvu2Xg
         wl5rql4v16ukrsC2hP/+r7VYX1ocqQ3BT9HPAbQLPhxt4fYHPRSc7X1nT6JuVQdpvNPN
         pnabuNB8UhZbiPkmsCeSsSW+et4PeIelR5G9dhZ0Ehl900WkPX7WDaFAMwfrpCR8drRM
         KW3EUUDR9zC8alCqstwYgdieBITJppii8WRbKCVIapxZ+g7tQqDSZdNUxMJFTYtzIgs+
         4ovgo1moB66vqwFt/Xd1QuM/zZTYeyuKtvbz37BtUU3eyKNgbIJeCbYdYda3bKEQmDsG
         MmVA==
X-Gm-Message-State: AOAM530Hw6R5M2VUm5uTo2XrNa2Qps9Jttc8XnFghmIhEv+ibK+56h/1
        tcWsvyV8G5lKSiSXM7Ok2QhTq3/vhjQ=
X-Google-Smtp-Source: ABdhPJySGhQnlkUyi7Q1TduiVYiIOsOiHUSRv+jFG67fcghd4bI4a5ImlczvxAZVW+ThKsvwknXnPw==
X-Received: by 2002:a1c:4e07:: with SMTP id g7mr2290403wmh.29.1615272266576;
        Mon, 08 Mar 2021 22:44:26 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y8sm2368184wmi.46.2021.03.08.22.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 22:44:26 -0800 (PST)
Date:   Tue, 9 Mar 2021 07:44:24 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org, jernej.skrabec@siol.net,
        mchehab+huawei@kernel.org, corbet@lwn.net,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: allwinner: sun8i-ce: fix error return code in
 sun8i_ce_prng_generate()
Message-ID: <YEcZSJ4T/Z0M4VaU@Red>
References: <20210305015717.2908-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305015717.2908-1-baijiaju1990@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Mar 04, 2021 at 05:57:17PM -0800, Jia-Ju Bai a écrit :
> When dma_mapping_error() returns an error, no error return code of 
> sun8i_ce_prng_generate() is assigned.
> To fix this bug, err is assigned with -EFAULT as error return code.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> index cfde9ee4356b..cd1baee424a1 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-prng.c
> @@ -99,6 +99,7 @@ int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
>  	dma_iv = dma_map_single(ce->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
>  	if (dma_mapping_error(ce->dev, dma_iv)) {
>  		dev_err(ce->dev, "Cannot DMA MAP IV\n");
> +		err = -EFAULT;
>  		goto err_iv;
>  	}
>  
> -- 
> 2.17.1
> 

Hello

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
