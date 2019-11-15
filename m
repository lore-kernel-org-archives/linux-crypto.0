Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35813C43215
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 12:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD5D2082E
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 12:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oaB9WzyC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfKOMpW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 07:45:22 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34310 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbfKOMpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 07:45:22 -0500
Received: by mail-wm1-f66.google.com with SMTP id j18so9996846wmk.1;
        Fri, 15 Nov 2019 04:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IuuUvPE4LPSeug9SWAuaNF/jmrQAGOGNZ9g9Ry7ToRE=;
        b=oaB9WzyCidhcS7WmkncUNaw1+Twilec9DoSikauUrM+ipjGDX+MGw5sngCARMYsyUG
         FDjdg1s6MggFK0o6tG2aIk9AxDRek/q/Xir3pylOrt0ROE2OlWtRjNnKxYPK8GFj38tG
         nJ6RzF5UOJpw29uZJ4Eb6b1ZfWBzDwVOtUtzegOIXrGi0s2xR1VRNBalxOWQM14tIi5a
         fGGJmnJjyzjTKkOCW/+fI88pX4+7i1q4OkAuiptd32uA3cYWut56MJifbsvPduwymGj9
         hjpmVYBSKlQDAdSEs4+CJVMb/0C9m8BQJtFH5E/+r4oIJ4GzJCc9GWEYw+Q35TLypjqj
         UnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IuuUvPE4LPSeug9SWAuaNF/jmrQAGOGNZ9g9Ry7ToRE=;
        b=YkO+A4eZCMp8spfAqMB+8Q9EJcTdUqCM8YCf8IXitn8WJnO9GZxp+0h0Wo3tUUK+NC
         uQZVPFqMNlnxbRPiBIf7ppkAJMhbImQxvzsCpIYieAXbCnTEMzvMACiE6YiPdfGYns0Z
         +7m0VTh/kY/qU0qSWrowMldUFDgyZ5Ne10G6J3icDleAByK6EGoBoGdLy4XiLWmzVKWG
         xEnAswsHaOF7ERPyWzNnJIpsVBzR6OaN0K9O9OsvIbuNyDlJ46F2Ws4T499eGXXKMOZP
         OT3jBEUWoF/yKH2QqgxZYlgR9U+sePVkyqOZWd2XcqbUES2l15kPNG3WVpvF+j/bg0Iq
         3yZQ==
X-Gm-Message-State: APjAAAU1pLC2VKSjQqb8YqifP5NGWMOG/kDgYVdc72cDbqV2tCAfolcx
        m+GaWvRzMHX23RCfGweHiCEWaGmm
X-Google-Smtp-Source: APXvYqwPO6UCR4wROZX9g244JGWsZTNfxtKqaYGdx1ZDLz2uk+hjVaSf3qXxka4ZxCB8+l/WHnMuEQ==
X-Received: by 2002:a7b:c08c:: with SMTP id r12mr14067285wmh.67.1573821919961;
        Fri, 15 Nov 2019 04:45:19 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y6sm11149915wrr.19.2019.11.15.04.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 04:45:19 -0800 (PST)
Date:   Fri, 15 Nov 2019 13:45:17 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Kalyani Akula <kalyani.akula@xilinx.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Harsh Jain <harshj@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Mohan Marutirao Dhanawade <mohan.dhanawade@xilinx.com>
Subject: Re: [PATCH V3 4/4] crypto: Add Xilinx AES driver
Message-ID: <20191115124517.GA31038@Red>
References: <1573040435-6932-1-git-send-email-kalyani.akula@xilinx.com>
 <1573040435-6932-5-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573040435-6932-5-git-send-email-kalyani.akula@xilinx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 06, 2019 at 05:10:35PM +0530, Kalyani Akula wrote:
> This patch adds AES driver support for the Xilinx ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
>  drivers/crypto/Kconfig                 |  11 +
>  drivers/crypto/Makefile                |   2 +
>  drivers/crypto/xilinx/Makefile         |   3 +
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 457 +++++++++++++++++++++++++++++++++
>  4 files changed, 473 insertions(+)
>  create mode 100644 drivers/crypto/xilinx/Makefile
>  create mode 100644 drivers/crypto/xilinx/zynqmp-aes-gcm.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 1fb622f..8e7d3a9 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -696,6 +696,17 @@ config CRYPTO_DEV_ROCKCHIP
>  	help
>  	  This driver interfaces with the hardware crypto accelerator.
>  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
> +config CRYPTO_DEV_ZYNQMP_AES
> +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> +	depends on ARCH_ZYNQMP || COMPILE_TEST
> +	select CRYPTO_AES
> +	select CRYPTO_ENGINE
> +	select CRYPTO_AEAD
> +	help
> +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> +	  encryption and decryption. This driver interfaces with AES hw
> +	  accelerator. Select this if you want to use the ZynqMP module
> +	  for AES algorithms.
>  
>  config CRYPTO_DEV_MEDIATEK
>  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index afc4753..b6124b8 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -47,4 +47,6 @@ obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
>  obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
>  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
>  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
> +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += xilinx/
> +

Hello

you insert a useless newline

[...]
> +static int zynqmp_handle_aes_req(struct crypto_engine *engine,
> +				 void *req)
> +{
> +	struct aead_request *areq =
> +				container_of(req, struct aead_request, base);
> +	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> +	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
> +	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(areq);
> +	struct aead_request *subreq;
> +	int need_fallback;
> +	int err;
> +
> +	need_fallback = zynqmp_fallback_check(tfm_ctx, areq);
> +
> +	if (need_fallback) {
> +		subreq = aead_request_alloc(tfm_ctx->fbk_cipher, GFP_KERNEL);
> +		if (!subreq)
> +			return -ENOMEM;
> +
> +		aead_request_set_callback(subreq, areq->base.flags,
> +					  NULL, NULL);
> +		aead_request_set_crypt(subreq, areq->src, areq->dst,
> +				       areq->cryptlen, areq->iv);
> +		aead_request_set_ad(subreq, areq->assoclen);
> +		if (rq_ctx->op == ZYNQMP_AES_ENCRYPT)
> +			err = crypto_aead_encrypt(subreq);
> +		else
> +			err = crypto_aead_decrypt(subreq);
> +		aead_request_free(subreq);

Every other crypto driver which use async fallback does not use aead_request_free() (and do not allocate a new request).
I am puzzled that you can free an async request without waiting for its completion.
Perhaps I am wrong, but since no other driver do like that...

[...]
> +static int zynqmp_aes_aead_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	int err = -1;
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	aes_drv_ctx.dev = dev;

You should test if dev is not already set.
And add a comment like "this driver support only one instance".

> +	aes_drv_ctx.eemi_ops = zynqmp_pm_get_eemi_ops();
> +	if (IS_ERR(aes_drv_ctx.eemi_ops)) {
> +		dev_err(dev, "Failed to get ZynqMP EEMI interface\n");
> +		return PTR_ERR(aes_drv_ctx.eemi_ops);
> +	}
> +
> +	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(ZYNQMP_DMA_BIT_MASK));
> +	if (err < 0) {
> +		dev_err(dev, "No usable DMA configuration\n");
> +		return err;
> +	}
> +
> +	aes_drv_ctx.engine = crypto_engine_alloc_init(dev, 1);
> +	if (!aes_drv_ctx.engine) {
> +		dev_err(dev, "Cannot alloc AES engine\n");
> +		return err;
> +	}
> +
> +	err = crypto_engine_start(aes_drv_ctx.engine);
> +	if (err) {
> +		dev_err(dev, "Cannot start AES engine\n");
> +		return err;
> +	}
> +
> +	err = crypto_register_aead(&aes_drv_ctx.alg.aead);
> +	if (err < 0)
> +		dev_err(dev, "Failed to register AEAD alg.\n");

In case of error you didnt crypto_engine_exit()

Regards
