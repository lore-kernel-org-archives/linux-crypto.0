Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8607C43217
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 01:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B49E561350
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 01:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351394AbhKPBKK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 20:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245132AbhKOTTc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:32 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C06C0386CA
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:10:48 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso15368923otr.2
        for <linux-crypto@vger.kernel.org>; Mon, 15 Nov 2021 10:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=btXP5JTOTPHN2wBCk/VjqAMkewryvyIZIdcv+nbDmjs=;
        b=KFeET7Jo1zA/GLeNPXLNhLjW4GX0S6rNhH8crHvhvla+DjueTpwSw5iF9onmZhMU9U
         L0TJbxv9B85FBo1rztKCQARvrlLxO1EPlOuS5DNmtX3uwAJezbb+oDBMZuylRANWbUfb
         WL4s4i4FGldWsdq8g8HvmZUDRFg7eJFE8JnQITAd2WSFuuYb6Oasun9CD2yHY7GfUr8C
         HTpFSjPJPCGefDJE8i+K/58Ccq0yEPlwFXXds4//i1UEl3XfUxlo/tHnVfLJyu8maid6
         6hXMppAVCA2WE36IwlazSwxpQfgxWXam5ezKWFxLRXOUYdxJZM7HplXaFG8ZSytzUCXH
         /D+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=btXP5JTOTPHN2wBCk/VjqAMkewryvyIZIdcv+nbDmjs=;
        b=W4RnXMe7CX/kAprzRKnb8GMHD1vR5n0Tyy7lwgAkdwsGwIK0ZamZUHqwwOVtIroUUn
         kgFB7OXjN6pL2n7T/4k7TEgaiNbYvGOmx6Wq+aDUU8U2Kpkzd+wFfMAVm5zHtcpAhg4g
         oSMxON/7Vr8Is+FmoajXQ3V3ed+9G7Mbz9WA1J+bO97tvxTKBLI+cqvwjP+zU4ukUSlf
         oIRW4H4awmfeuizo7UjqlCfvYi21dJmCKdlHx6Qsj9FidwQ2Z8u655rlxBhYWifETvNj
         FCaEaE6y16Ufz6hCj4bMP2Pm7gUF64KdQwlVYE/46F9WjF8fXPpn+24C6TvpxAY59wUk
         TStA==
X-Gm-Message-State: AOAM533gbzDYfzizMmizrQHzRABjp+N65KMuVBSAfEsFm2AYUquUp80I
        tUhcpsojokhmQtzYjvxUGh4MMQ==
X-Google-Smtp-Source: ABdhPJwvZP5w9iunnbVacXS+t5Qx3X/+MhKg+S8e/AkaARLNqNF8AI5kwj0o3zSAz8HdWkU64r1Diw==
X-Received: by 2002:a05:6830:3155:: with SMTP id c21mr764093ots.183.1636999848157;
        Mon, 15 Nov 2021 10:10:48 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id n23sm3309780oic.26.2021.11.15.10.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 10:10:47 -0800 (PST)
Date:   Mon, 15 Nov 2021 12:10:42 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, agross@kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        stephan@gerhold.net, Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v5 17/22] crypto: qce: Print a failure msg in case
 probe() fails
Message-ID: <YZKiovE1D9t17TVe@builder.lan>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
 <20211110105922.217895-18-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110105922.217895-18-bhupesh.sharma@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed 10 Nov 04:59 CST 2021, Bhupesh Sharma wrote:

> Print a failure message (dev_err) in case the qcom qce crypto
> driver probe() fails.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  drivers/crypto/qce/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
> index 98784d63d78c..7c90401a2ef1 100644
> --- a/drivers/crypto/qce/core.c
> +++ b/drivers/crypto/qce/core.c
> @@ -280,6 +280,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
>  err_mem_path_disable:
>  	icc_set_bw(qce->mem_path, 0, 0);
>  err:
> +	dev_err(dev, "%s failed : %d\n", __func__, ret);

There's two possible outcomes of this style of error logging:

1) You came through a code path with a specific error message, so you
will have something that will say:

qce: Some useful error text
qce: qce_crypto_probe failed: -22

2) You came through a code path without a specific error message:

qce: qce_crypto_probe failed: -22


In the first case the second line is just pure spam, in the second case
the bare -22 is typically completely useless - given that there tend to
be just a few commonly used errno values coming from multiple possible
error sources.

As such, no thanks. If you have an error case in qce_crypto_probe() that
doesn't have a good, useful, error message, please fix that.

Regards,
Bjorn

>  	return ret;
>  }
>  
> -- 
> 2.31.1
> 
