Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9053C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9970622A84
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jan 2021 16:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbhAYQcT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jan 2021 11:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730734AbhAYQb4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jan 2021 11:31:56 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61BC0613D6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:31:15 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id z36so1468811ooi.6
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jan 2021 08:31:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=40kUnDJvOmh5mDDNnYdWwiYEGd/OPR4RTz7rIN8oEbE=;
        b=XZ5hLoU7Gt6LqV97bM4MM0VSQMQ3a5EMjK+QSRvhR84Kb52hEeZWrMsybNPdnWX0Sk
         88Nqt/fDlA8Tc/UOdTVCuKqssUmGUWrlbNExFeI5QRa7MpNFgG+Pi1jZ9jUCDD34BT8M
         eLMTCfGsbyW0dJLWani4JdaOD9o0rdv0zmH57PnM5CmZJSN9Mv02mBYJI+fVGEtNPZCu
         Utd7QwG32ejzUqe0TTuZ0lr5fINVkYBVByLTFVlkm9MvTyIdlWbggyCpLv8bMAB61hKk
         vfBaDUWkAilTTOyTjMvpoUvkXDkpR8sB8gd9jBgI9DFY3ec0WpCzKtAEKidkY2rK4vX7
         rv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=40kUnDJvOmh5mDDNnYdWwiYEGd/OPR4RTz7rIN8oEbE=;
        b=HEtXVAypS+Ad9AjLttiKNy/0ArRzRJ5Slrw+FZsOCJqIY5sZUWvfP99eSXNDUQztEg
         RqkHhnfy5TsiPeth4SUTddPDAMRQwz2TM+LAiOpa+1y1tH9/3smWHKQuFObKs1N1xIJ2
         NfYjrj2fRA2jSfURVbofQKTzWdoEZ4dO2tWrrCpVAB6NrjBVoI/FLWkwULC4KvOXP9vW
         xNrE1rI+lBzGstH/NFfbisH4Bot98+ImC7GM+Kwd3bDTgYlkLoKf4JaBsx6oaI1N64pV
         FNQQzASRx0xna5NKDxmaWHa6HiHotGSJWhJe19tAYSHN7KHV9E5sViPPpnCU59NRbqBw
         8o/g==
X-Gm-Message-State: AOAM532M+5u0FDQFmyk0AzsB0x/HG28Djnv5zvA2T9mRI3wVVqBDZoIZ
        oRUE2BdQWV+CQfcA7KDa4yxsFw==
X-Google-Smtp-Source: ABdhPJx6u0GLpjr7JeuYgLHTAwAsm0aZo1oZtVpfh9nPhjg0TnmSZtnHo8yv6fVIqonJI5LU6elcSQ==
X-Received: by 2002:a4a:e746:: with SMTP id n6mr1024445oov.84.1611592275091;
        Mon, 25 Jan 2021 08:31:15 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id a22sm2869730otp.53.2021.01.25.08.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 08:31:14 -0800 (PST)
Date:   Mon, 25 Jan 2021 10:31:12 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] drivers: crypto: qce: common: Set data unit size
 to message length for AES XTS transformation
Message-ID: <YA7yUD7OqUKBFN83@builder.lan>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
 <20210120184843.3217775-5-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120184843.3217775-5-thara.gopinath@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 20 Jan 12:48 CST 2021, Thara Gopinath wrote:

> Set the register REG_ENCR_XTS_DU_SIZE to cryptlen for AES XTS
> transformation. Anything else causes the engine to return back
> wrong results.
> 
> Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
> ---
>  drivers/crypto/qce/common.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index a73db2a5637f..f7bc701a4aa2 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -295,15 +295,15 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
>  {
>  	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
>  	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
> -	unsigned int xtsdusize;
>  
>  	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
>  			       enckeylen / 2);
>  	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
>  
> -	/* xts du size 512B */
> -	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);

I wonder if this is a hardware limitation that has gone away in the
newer chips. I am however not able to find anything about it, so I'm in
favor of merging this patch and if anyone actually uses the driver on
the older hardware we'd have to go back and quirk it somehow.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> -	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
> +	/* Set data unit size to cryptlen. Anything else causes
> +	 * crypto engine to return back incorrect results.
> +	 */
> +	qce_write(qce, REG_ENCR_XTS_DU_SIZE, cryptlen);
>  }
>  
>  static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
> -- 
> 2.25.1
> 
