Return-Path: <SRS0=VsUo=YP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A87CA9EB7
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A820B2184C
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Oct 2019 06:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AooQH+XR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfJVGwt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 02:52:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44579 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387800AbfJVGws (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 02:52:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so16613406wrl.11
        for <linux-crypto@vger.kernel.org>; Mon, 21 Oct 2019 23:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AISJc1XvrmnIpso64z8g6LZ/bevEJjj83TATYb74pYo=;
        b=AooQH+XRch+bHwmHSd4H6i3xy7cp+tvKXha0NZgaXyVPI3MTu+Tic956lfE2hBFsV2
         Ml/UfQEpMDRTuMw/1QfXHmAUYiNlpO3hqGt/LSYsja4O+XXuWci9+7yVFCB4k4kWz2Od
         ympptz7kZCS/ah+4u+kjTZpuV5Y3ZcEyMXVisvvnksiHYisJ4l68rR9DW3bTOVtp4lQ/
         bAlUlFc+w0tx2JctuK4E/ULOZixVD6O0aMgXh7wefTXyaQq3EPNsbXijE3NBKytDSiI/
         6pYDIVITFothm3GvxRUiwUhdW/3UaELPkICFnyJWH2KBspB+7p+Nf22EkM3KddGLaitq
         IHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AISJc1XvrmnIpso64z8g6LZ/bevEJjj83TATYb74pYo=;
        b=iQNAIIowGsZydFKTHoI6zQrPvW92Fv6PCwF1lTrpD9KaXOoHuzFd+XmwdUOCNGwkwg
         Tq1OA/9KvfK1ZbJQKPKheJISWA8Fyt6TPRIR9C5Ai/zV4QzzwlV4rlO9U43x7FImlYxg
         BV5udrAK4A0utlLXy6uvmpejzx2qFxzwW/Edaq9plsn6UxjxSTywdoaqcbk1DDf8DHIu
         rcEGoTrszObgNLkadw6acVlbhf+z46ESzBs62DEuBvMlw2rq+zqncF5ARdBBU4CRJWc5
         AekMjTQZTaL1cvFrQ3MEddvjuAqXqxiiVbDZqtSdYwam1LR72U40uF3tLqbdDmmhrfsg
         maGQ==
X-Gm-Message-State: APjAAAX1frYPYlU67vKZMj60jDXJStDcPm2RGvVnmSfjLpG6MLZ4D9sl
        tklNusNgMNH8E76jVtjulDxliCm4638l38Vs1Krd/g==
X-Google-Smtp-Source: APXvYqwuHDK286BWgfauPhSidbsCRJAUk7XSDtTyO0Owe3sAhYGiH4QGZzsFBVlFaAPhIpI0H2PadWa8Y4yDD93HyRY=
X-Received: by 2002:adf:f685:: with SMTP id v5mr1981749wrp.246.1571727165046;
 Mon, 21 Oct 2019 23:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <a33932c9-2975-4fcc-ba07-7c54df4eae27@huawei.com>
In-Reply-To: <a33932c9-2975-4fcc-ba07-7c54df4eae27@huawei.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 22 Oct 2019 08:52:40 +0200
Message-ID: <CAKv+Gu-qAy9iLbR97=Kz90+-YLLvz0nmTZtxhByeOXEG3xvaBQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/aes-neonbs - remove redundant code in __xts_crypt()
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Oct 2019 at 08:42, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
>
> A warning is found by the static code analysis tool:
>   "Identical condition 'err', second condition is always false"
>
> Fix this by removing the redundant condition @err.
>
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>

Please don't blindly 'fix' crypto code without reading it carefully
and without cc'ing the author.

The correct fix is to add the missing assignment of 'err', like so

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c
b/arch/arm64/crypto/aes-neonbs-glue.c
index ea873b8904c4..e3e27349a9fe 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_request
*req, bool encrypt,
                        goto xts_tail;

                kernel_neon_end();
-               skcipher_walk_done(&walk, nbytes);
+               err = skcipher_walk_done(&walk, nbytes);
        }

        if (err || likely(!tail))

Does that make the warning go away?


> ---
>  arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
> index ea873b8904c4..7b342db428b0 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -387,7 +387,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
>                 skcipher_walk_done(&walk, nbytes);
>         }
>
> -       if (err || likely(!tail))
> +       if (likely(!tail))
>                 return err;
>
>         /* handle ciphertext stealing */
> --
> 2.7.4.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
