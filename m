Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CF4C072B1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 13:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A33D20717
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 13:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ibi1V5DB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfE1ND6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 09:03:58 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:47069 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfE1ND6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 09:03:58 -0400
Received: by mail-io1-f65.google.com with SMTP id u25so83870iot.13
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 06:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bh/N/QZBC3xi2c5BZMAnemmNFxYJ1TErCB/6n5Xk+X8=;
        b=ibi1V5DBVgTanDaBzc4vcpKjo+uo+gzCpXxoaw5Whec0p10xNV17ytUzJg/eNgvVD+
         yk1exn2HIfQiZpiTpBj6Sbw+Z3H8Acrybi01M4v2THSkE+mhkqB3Sn2iPaXRqqUDMRQ4
         GMjDH3iCH3Md1pQU7zHViowF+TQrXnOVgsSwmLCBypcxquDdXIVfDKVawDdiiu7MGjLR
         101gfrwONUcqOjIQS8n4lZXZTzL7vrWu5g15Ak5siJtxip71JvvJowxhJ2HNEXBXmNMy
         HBXcxiXAH7OKZqgx9F0fLEg/d7QTc2vl8+upTAqv9XtUb6wgkZE3/uGyEE51RYe1eRPj
         8Y8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bh/N/QZBC3xi2c5BZMAnemmNFxYJ1TErCB/6n5Xk+X8=;
        b=IyfYHeSLazDd2RkYX4mEYALsy1IM6wKkZaY9oE1w+zFrppib2LjIclLZ5Wnzxw75QJ
         usOANgSdok9JDFfLOGb0wapAkiovB0JqCnEaITsw9uaUTeW+Amtuz7xPvQ28q8f0dtJK
         r0VADQqxSSK/2q36OtBkkr8AjJYaagMA7pFeCumqCow+NhEYSo2PJtOlaPCbx8LjYMK9
         bByHuCVoxl4HtuT+V8HKTQXzjqWZ7IdnvYx506JbI/jzKSgh1Hp3i7mZLGGK5Yt5Wy8l
         C+yoPRtSSelkN95GeY3KA2YhWjJ1qwIgPdhpOIQpIxtc1vsj6kkVJnycmOJyDfyUmfmL
         3fLQ==
X-Gm-Message-State: APjAAAXHB4m+wV8TB5RPRuVl+TAzm4ppTfC54LgngP+0fGbbyPAOqidF
        tWl2bObh9V4xohIVlxVk2InWd+XYMQWQ0vlXM+mHgg==
X-Google-Smtp-Source: APXvYqzf4TrvLUejClAo8NVy1VBfMi99WrxFDIKSZqyoOc05Ou/81VFSFQDwd6zFRZwhRu1SUnmsIi8HcbEYv9hknos=
X-Received: by 2002:a05:6602:2109:: with SMTP id x9mr393129iox.128.1559048637409;
 Tue, 28 May 2019 06:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190528124152.191773-1-lenaptr@google.com>
In-Reply-To: <20190528124152.191773-1-lenaptr@google.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 28 May 2019 15:03:44 +0200
Message-ID: <CAKv+Gu-Bzb6bucFXgW+EgU2bh9Kp-rAJWq5TSNrk7n_rMGkx9g@mail.gmail.com>
Subject: Re: [PATCH] arm64 sha1-ce finup: correct digest for empty data
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 May 2019 at 14:42, Elena Petrova <lenaptr@google.com> wrote:
>
> The sha1-ce finup implementation for ARM64 produces wrong digest
> for empty input (len=0). Expected: da39a3ee..., result: 67452301...
> (initial value of SHA internal state). The error is in sha1_ce_finup:
> for empty data `finalize` will be 1, so the code is relying on
> sha1_ce_transform to make the final round. However, in
> sha1_base_do_update, the block function will not be called when
> len == 0.
>
> Fix it by setting finalize to 0 if data is empty.
>
> Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Thanks for the fix

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

It looks like the sha224/256 suffers from the same issue. Would you
mind sending out a fix for that as well? Thanks.

> ---
>  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> index eaa7a8258f1c..0652f5f07ed1 100644
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -55,7 +55,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
>                          unsigned int len, u8 *out)
>  {
>         struct sha1_ce_state *sctx = shash_desc_ctx(desc);
> -       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
> +       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
>
>         if (!crypto_simd_usable())
>                 return crypto_sha1_finup(desc, data, len, out);
> --
> 2.22.0.rc1.257.g3120a18244-goog
>
