From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: caam - treat SGT address pointer as u64
Date: Thu, 29 Sep 2016 13:58:48 -0300
Message-ID: <CAOMZO5CjWj4-aKXxBGZpUjsOyfHTYD3t9FEfunK-MxF03YxbFQ@mail.gmail.com>
References: <1475158647-16094-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: horia.geanta@nxp.com, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:36052 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933853AbcI2Q6u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Sep 2016 12:58:50 -0400
Received: by mail-ua0-f196.google.com with SMTP id 51so2692799uac.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 Sep 2016 09:58:49 -0700 (PDT)
In-Reply-To: <1475158647-16094-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tudor,

On Thu, Sep 29, 2016 at 11:17 AM, Tudor Ambarus
<tudor-dan.ambarus@nxp.com> wrote:

> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index b3c5016..effbdd8 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -196,6 +196,14 @@ static inline u64 rd_reg64(void __iomem *reg)
>  #define caam_dma_to_cpu(value) caam32_to_cpu(value)
>  #endif /* CONFIG_ARCH_DMA_ADDR_T_64BIT  */
>
> +#ifdef CONFIG_SOC_IMX7D

Why is this restricted to mx7d?
