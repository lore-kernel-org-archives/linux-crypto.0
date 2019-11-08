Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DF2FA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC474214DA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 08:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BshbsTJg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfKHI55 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:57:57 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38183 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730005AbfKHI55 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 03:57:57 -0500
Received: by mail-wm1-f67.google.com with SMTP id z19so5343547wmk.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 00:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sXSaqqdb0u9vm+JdykFgKcAJgl2PbqAejS1ttkwBCfg=;
        b=BshbsTJgopykaEGVap+GT8HBWzfBB0mtH7bPwWOAZRL4QqVuiLUzeFH/JzFbAfM0wY
         N88vL74sQPANNSKA+TKLzCiigTPdQS9uzcl+Xg4jXRSsTAucqGgSKiBOTkR4rTLzReLx
         UTzlHVwnKwhNvgSSOZOtd8HVJQRYxb5/J57bnlis3pjFQC0rFv1j/+rIlV1Dcgep3fPU
         JOhwuyFCwCbrGov++QvIFQfpCX5PqQpR54hxjCW1z/yVsxkE7E0s5S6QzaIHjaVmNLUM
         /tuXtxh1eoTBMDAteOuAeiytdMdYYJTaT8JvGe6njLi9VAlX/7NjyOU6SXff1izkMx1A
         6RyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXSaqqdb0u9vm+JdykFgKcAJgl2PbqAejS1ttkwBCfg=;
        b=W7N4Mf6Or57N4oBzv2bwOXCCOi9oRDUXAOESFnv8tRt4S5Ib396a+Yt+LqRU+9mC/D
         /pB+kahXeRFraKhnGGAMgneawyDE9yQU6gfG0OslHJZbVVJ9Url7W7mMWXf72v4kVZ4V
         O8mEwRgEb2H4+uGdbDjrAhjwYXB6mR3iVLqHBF2GsVnnUkBa3KvLoiTX1lFbb1uqvTz2
         GAUggoUpiRH+vzE6Ehi/B/PwO64G2wqGz9qcaklFq51a0wUskSNRHI1jYhipiWT4Bu6r
         fzbBix7JIT9BGvBeVhhBwDSv535A514vM6s/W0L8w2oxOiDBT3Wazb/8gY2cWl74IETm
         jUyQ==
X-Gm-Message-State: APjAAAVmbKX7f/rgDGHsQ4O7P0GYCyXwOfj25DDaWEeiGAdHWfTKlOkl
        sfp9NAWalx918U0J8nfuAJnshPjDEFELgBy+vztO1Q==
X-Google-Smtp-Source: APXvYqw4DN6fKyGnJZrvc/UHTYyOprMks3oyXClhhdqpSglIBuqYs9MDsTPyM3DGxrMhHM+StOSkC8rUI49yzH8bfD8=
X-Received: by 2002:a1c:b1c3:: with SMTP id a186mr7291210wmf.10.1573203474585;
 Fri, 08 Nov 2019 00:57:54 -0800 (PST)
MIME-Version: 1.0
References: <1573203234-8428-1-git-send-email-pvanleeuwen@verimatrix.com>
In-Reply-To: <1573203234-8428-1-git-send-email-pvanleeuwen@verimatrix.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 8 Nov 2019 09:57:43 +0100
Message-ID: <CAKv+Gu9SahVL815i+8_f_fQPM2JP=3rpz3GLFhxLaAUrhz3HWA@mail.gmail.com>
Subject: Re: [PATCHv3] crypto: inside-secure - Fixed authenc w/ (3)DES fails
 on Macchiatobin
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 8 Nov 2019 at 09:57, Pascal van Leeuwen <pascalvanl@gmail.com> wrote:
>
> Fixed 2 copy-paste mistakes in the commit mentioned below that caused
> authenc w/ (3)DES to consistently fail on Macchiatobin (but strangely
> work fine on x86+FPGA??).
> Now fully tested on both platforms.
>
> changes since v1:
> - added Fixes: tag
>
> changes since v2:
> - moved Fixes: tag down near other tags
>

Please put the changelog below the ---
It does not belong in the commit log itself.


> Fixes: 13a1bb93f7b1c9 ("crypto: inside-secure - Fixed warnings on
> inconsistent byte order handling")
>
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index 98f9fc6..c029956 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -405,7 +405,8 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>
>         if (priv->flags & EIP197_TRC_CACHE && ctx->base.ctxr_dma) {
>                 for (i = 0; i < keys.enckeylen / sizeof(u32); i++) {
> -                       if (le32_to_cpu(ctx->key[i]) != aes.key_enc[i]) {
> +                       if (le32_to_cpu(ctx->key[i]) !=
> +                           ((u32 *)keys.enckey)[i]) {
>                                 ctx->base.needs_inv = true;
>                                 break;
>                         }
> @@ -459,7 +460,7 @@ static int safexcel_aead_setkey(struct crypto_aead *ctfm, const u8 *key,
>
>         /* Now copy the keys into the context */
>         for (i = 0; i < keys.enckeylen / sizeof(u32); i++)
> -               ctx->key[i] = cpu_to_le32(aes.key_enc[i]);
> +               ctx->key[i] = cpu_to_le32(((u32 *)keys.enckey)[i]);
>         ctx->key_len = keys.enckeylen;
>
>         memcpy(ctx->ipad, &istate.state, ctx->state_sz);
> --
> 1.8.3.1
>
