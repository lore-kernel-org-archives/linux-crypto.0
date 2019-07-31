Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD076C32751
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 05:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78664206A2
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 05:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aEiIEPSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGaFdG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 01:33:06 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43481 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfGaFdG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 01:33:06 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so68133569wru.10
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2019 22:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=loiK9wXUCOiEY9KsTjnNAjKwl1yaWs5jTqxh2hr1suU=;
        b=aEiIEPSp1AJ2+tVsqc5bS6kU/EOdjHNsSwpNEKGjlrbsV2rNvXmgTJpWFoA7vGEdOU
         9EdsC+YaQVZM6b6VE89HsgoAhA70wVUfvEXl8SZ+x7T1fR1n5vCj+glb7dqPUfUWR0WI
         p1j4JzNul4oGnXuhq8GYssbzgZPjUR7A6oLx0zGEpwpHJSGCwh0E3Y9ycnlIc2C2OqTi
         nEvaZQCVFtpb9dkIJKnCR+AO1wc0i2cYn6j3tIg/bpOflUiTTPBCBx5EHQpWSRLI8+lt
         BiHv8u1U9Q7JweVygK+icmqR3gb2F7cE+XG7JQVyhq0ZiPFgAoR+CjGLU61YpfcHdSBb
         yC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=loiK9wXUCOiEY9KsTjnNAjKwl1yaWs5jTqxh2hr1suU=;
        b=JBB3iQy5OArwz51sHT2UOhnTB1deZagmHCsU6uhB9ubbO80Iq4suXCdA5GI1dJBVkE
         h+a8DfplaIk9/lItU10EawNbP3/fafRLf+/rX2P1HfiR9dAF9ZeMaCXKltyqDOiRGlvV
         yienA7jSQVK10mg02hGB3rEXHVesnu/0UJbWF5K7Wl0zEA+IxaBnRCIwllOqJkma2pSB
         yl9kcT7R/2wYg8TWMcxgv6y7nzZ6bsZWUS1hAVYFgDAnn0ff4hEmWigbwr7bobaReoZp
         5I/P043U0JcYvJGYxNz+CwSq9JL/TLEvEX5mvzhTp69NZCQ85gQV89Cro9THgOPsiq/s
         n8BA==
X-Gm-Message-State: APjAAAX695ACMCMJk+26nh1ewa7OLxCBAQTErvvrQXgvYlRjYDjWO6A+
        pqJMbMcxz7X7MPoOWs5Nrjq8c4nxrD+BB4ifTScFkg==
X-Google-Smtp-Source: APXvYqxhshVQRxJPu9P5SIvWuW4Sa8P4b92k4Xh507OU4+Jac8/nsKvirOJ8JOEIXH82zG39w5tN3qwlUoh6wirKz+w=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr136343841wrs.93.1564551183914;
 Tue, 30 Jul 2019 22:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <1564482824-26581-1-git-send-email-iuliana.prodan@nxp.com> <1564482824-26581-3-git-send-email-iuliana.prodan@nxp.com>
In-Reply-To: <1564482824-26581-3-git-send-email-iuliana.prodan@nxp.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 31 Jul 2019 08:32:53 +0300
Message-ID: <CAKv+Gu_VEEZFPpJfv2JbB02vhmc_1_wpxNDBHf__pv-t7BvN0A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: aes - helper function to validate key
 length for AES algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 30 Jul 2019 at 13:33, Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> Add inline helper function to check key length for AES algorithms.
> The key can be 128, 192 or 256 bits size.
> This function is used in the generic aes implementation.
>
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> ---
>  include/crypto/aes.h | 17 +++++++++++++++++
>  lib/crypto/aes.c     |  8 ++++----
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index 8e0f4cf..8ee07a8 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -31,6 +31,23 @@ struct crypto_aes_ctx {
>  extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
>  extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
>
> +/*
> + * validate key length for AES algorithms
> + */
> +static inline int crypto_aes_check_keylen(unsigned int keylen)

Please rename this to aes_check_keylen()

> +{
> +       switch (keylen) {
> +       case AES_KEYSIZE_128:
> +       case AES_KEYSIZE_192:
> +       case AES_KEYSIZE_256:
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>                 unsigned int key_len);
>
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index 4e100af..3407b01 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -187,11 +187,11 @@ int aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>  {
>         u32 kwords = key_len / sizeof(u32);
>         u32 rc, i, j;
> +       int err;
>
> -       if (key_len != AES_KEYSIZE_128 &&
> -           key_len != AES_KEYSIZE_192 &&
> -           key_len != AES_KEYSIZE_256)
> -               return -EINVAL;
> +       err = crypto_aes_check_keylen(key_len);
> +       if (err)
> +               return err;
>
>         ctx->key_length = key_len;
>
> --
> 2.1.0
>
