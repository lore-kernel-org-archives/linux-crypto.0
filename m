Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8BDC282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 09:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A42520855
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 09:48:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="S6uns5Nv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfAXJsM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:48:12 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53145 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfAXJsM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 04:48:12 -0500
Received: by mail-wm1-f66.google.com with SMTP id m1so2390250wml.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Jan 2019 01:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lmFP/pb4I5zeZfqkGNoFLNvT1VnfwQ5xiH+1Aqxo9WU=;
        b=S6uns5NvROKjcHrjjPdRTiVOP6Jr3+gYGBi5Nj1xbr8p8a9O83CNFnyO3Y2++RfCN3
         x77XVvgLInsrMuj0hsIhYUxIgTcwzDeZ1dlBVd89sWpLxFEteg9jr8kxmNSFvFPS7fel
         n6Xw5jOwFpOaDD7G8BPcTIbZiWUrpVR0jKjFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lmFP/pb4I5zeZfqkGNoFLNvT1VnfwQ5xiH+1Aqxo9WU=;
        b=gAOGRLMZrgNgdY07GAMPsJHZZTWWjeTSUOK+Xn8CkIHEno8fazHeaheS4BgbN+AMR4
         NhfJG4RFbzvr3upasY6h25pBOAIj1UbZiAQO8mXuN06Wwr4YNedI4ZWG4sa7doqDryAG
         hgekJ+3OlLzTDgZMD/beAHmJVEkRd6NAyMZOLKexNCz73jGnwaHQqjg/eSAY7LsQQXFB
         URCsoKrVu60DYlNPiS2L1EFJ43CroTPCiwk8vacr8KQlJRuDKILBteTngBM3QXu/imjk
         3Rjzx/PCz1F9lr25jjM1dPaAz3FU4yl73VUhfzJP6W5+ClaPX+A7CNGRRgeoVDlpypx6
         +PgQ==
X-Gm-Message-State: AJcUukdSfXe9eaWxt0vgDUBj6mNwr+gYJKdwH+DxbLvv8WndO5caVVJJ
        xYjpV24Za1AlQeezlBd8noJVgA==
X-Google-Smtp-Source: ALg8bN7k5F3d3HmMNZ3l53xd7jox3iJWVd5MnEEHVVb13cUSe52nYcGYBIgsSkTeBh3xzvTChTVIfQ==
X-Received: by 2002:a1c:7eca:: with SMTP id z193mr1808014wmc.5.1548323290424;
        Thu, 24 Jan 2019 01:48:10 -0800 (PST)
Received: from holly.lan (cpc141214-aztw34-2-0-cust773.18-1.cable.virginm.net. [86.9.19.6])
        by smtp.gmail.com with ESMTPSA id e17sm161551887wri.36.2019.01.24.01.48.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 01:48:09 -0800 (PST)
Date:   Thu, 24 Jan 2019 09:48:07 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     jens.wiklander@linaro.org, herbert@gondor.apana.org.au,
        ard.biesheuvel@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        mpm@selenic.com, robh+dt@kernel.org, mark.rutland@arm.com,
        arnd@arndb.de, gregkh@linuxfoundation.org, bhsharma@redhat.com,
        tee-dev@lists.linaro.org
Subject: Re: [PATCH v5 2/4] tee: add supp_nowait flag in tee_context struct
Message-ID: <20190124094807.yg5onsmbx46bi7bm@holly.lan>
References: <1548309279-5281-1-git-send-email-sumit.garg@linaro.org>
 <1548309279-5281-3-git-send-email-sumit.garg@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548309279-5281-3-git-send-email-sumit.garg@linaro.org>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 11:24:37AM +0530, Sumit Garg wrote:
> This flag indicates that requests in this context should not wait for
> tee-supplicant daemon to be started if not present and just return
> with an error code. It is needed for requests which should be
> non-blocking in nature like ones arising from TEE based kernel drivers
> or any in kernel api that uses TEE internal client interface.
> 
> Signed-off-by: Sumit Garg <sumit.garg@linaro.org>

Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>

> ---
>  drivers/tee/optee/supp.c | 10 +++++++++-
>  drivers/tee/tee_core.c   | 13 +++++++++++++
>  include/linux/tee_drv.h  |  6 ++++++
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tee/optee/supp.c b/drivers/tee/optee/supp.c
> index 43626e1..92f56b8 100644
> --- a/drivers/tee/optee/supp.c
> +++ b/drivers/tee/optee/supp.c
> @@ -88,10 +88,18 @@ u32 optee_supp_thrd_req(struct tee_context *ctx, u32 func, size_t num_params,
>  {
>  	struct optee *optee = tee_get_drvdata(ctx->teedev);
>  	struct optee_supp *supp = &optee->supp;
> -	struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	struct optee_supp_req *req;
>  	bool interruptable;
>  	u32 ret;
>  
> +	/*
> +	 * Return in case there is no supplicant available and
> +	 * non-blocking request.
> +	 */
> +	if (!supp->ctx && ctx->supp_nowait)
> +		return TEEC_ERROR_COMMUNICATION;
> +
> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
>  	if (!req)
>  		return TEEC_ERROR_OUT_OF_MEMORY;
>  
> diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> index 9f4c8bc..2612dfa 100644
> --- a/drivers/tee/tee_core.c
> +++ b/drivers/tee/tee_core.c
> @@ -105,6 +105,11 @@ static int tee_open(struct inode *inode, struct file *filp)
>  	if (IS_ERR(ctx))
>  		return PTR_ERR(ctx);
>  
> +	/*
> +	 * Default user-space behaviour is to wait for tee-supplicant
> +	 * if not present for any requests in this context.
> +	 */
> +	ctx->supp_nowait = false;
>  	filp->private_data = ctx;
>  	return 0;
>  }
> @@ -981,6 +986,14 @@ tee_client_open_context(struct tee_context *start,
>  	} while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
>  
>  	put_device(put_dev);
> +	/*
> +	 * Default behaviour for in kernel client is to not wait for
> +	 * tee-supplicant if not present for any requests in this context.
> +	 * Also this flag could be configured again before call to
> +	 * tee_client_open_session() if any in kernel client requires
> +	 * different behaviour.
> +	 */
> +	ctx->supp_nowait = true;
>  	return ctx;
>  }
>  EXPORT_SYMBOL_GPL(tee_client_open_context);
> diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> index ce957ce..56d7f1b 100644
> --- a/include/linux/tee_drv.h
> +++ b/include/linux/tee_drv.h
> @@ -50,6 +50,11 @@ struct tee_shm_pool;
>   * @releasing:  flag that indicates if context is being released right now.
>   *		It is needed to break circular dependency on context during
>   *              shared memory release.
> + * @supp_nowait: flag that indicates that requests in this context should not
> + *              wait for tee-supplicant daemon to be started if not present
> + *              and just return with an error code. It is needed for requests
> + *              that arises from TEE based kernel drivers that should be
> + *              non-blocking in nature.
>   */
>  struct tee_context {
>  	struct tee_device *teedev;
> @@ -57,6 +62,7 @@ struct tee_context {
>  	void *data;
>  	struct kref refcount;
>  	bool releasing;
> +	bool supp_nowait;
>  };
>  
>  struct tee_param_memref {
> -- 
> 2.7.4
> 
