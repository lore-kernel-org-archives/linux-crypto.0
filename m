Return-Path: <SRS0=c5Ty=T4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC83EC072B1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 14:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 860C62075B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 May 2019 14:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rF95Z0N5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE1Ogi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 May 2019 10:36:38 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:40144 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1Ogi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 May 2019 10:36:38 -0400
Received: by mail-it1-f194.google.com with SMTP id h11so4237277itf.5
        for <linux-crypto@vger.kernel.org>; Tue, 28 May 2019 07:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBDKO8EMJjZWQxMXL1xSwnjCZ+AQSkiGLjl7m48b9A0=;
        b=rF95Z0N5QLTFBHs3BTxtcbdrh8/unoYwP93vjrLBUrBizEAkTMTsd/byG2IAdwa0ig
         czH2P3ZpcIoef72BQ7Fd7b13d+s3a4iosZj/hnOHpmn5sGD3PCtpZVltKDbymGXGgQgj
         vnkyXGqsYeB+XllrC5BheaJ77PMTmgwcso9rrRmq1sPt7e2+RN3I4ERmwZzeFyzIRN4j
         SwpR3D9y2plr5JL3E/+l3n/Slpy4BPVMfgSpZpZatoJuSrBS8Es8vLro8YrjCVw3sGHx
         vT0ipIPcRZB3qXK7Eadp+SMr6A4dDvsbA2A3EioYSjth9hl9SHdaKFE9HrQuWo3ktymj
         OnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBDKO8EMJjZWQxMXL1xSwnjCZ+AQSkiGLjl7m48b9A0=;
        b=iYoUqmXIW7OEvriHxWMikb6nur76W1hAGMXaTYnVByVcTOMzvbaDU6WGttypO8fJ8G
         jaf/WyPkKGaIQD9Sr6zhnuyIfR2HkIrohx+vntFML0FE9nY5F8QkPz5zlYpkP3mynHkn
         hh6AAoj7daN3FTCpaLEJs7SFSQKyAswIsqRcHyavyqYGt/zlBzLzjUFEOz0pHvh2yxnb
         QrU/ff55riP6S5zLynoGab1dKH3EQTSUB9wXd+SAC+PNRMBZFhaV0PgjaGOfvreBexTR
         zE9BLNAOflcMcr2MEfIGyjj41JDmrmqUlfc+GOVxCE0hkarK38sL5r6IcThdfLHSErPQ
         o3dg==
X-Gm-Message-State: APjAAAWLB+kZNgRtabRFPB6JYzbzpBrkRRVLEccpb89skN53Qsl//xnW
        ovZOJhQgHp4VHA8ZUseTGalyL0fX1iRw51mrVg39Wsjk9p8=
X-Google-Smtp-Source: APXvYqzt8rxhLzvnhfn/gd7KNM3Ie6fghJlq+EY+LGmtpGCtOuJ78lbZ/iL1v023Ym80gKxfsMuN/dDr8sX3fcygp8c=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr3191038itg.104.1559054197632;
 Tue, 28 May 2019 07:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190528143506.212198-1-lenaptr@google.com>
In-Reply-To: <20190528143506.212198-1-lenaptr@google.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 28 May 2019 16:36:25 +0200
Message-ID: <CAKv+Gu9+79HV3EvTGpqJS8nCbfZ22xtvUbJ5XyMuuF9bR+Nysw@mail.gmail.com>
Subject: Re: [PATCH] arm64 sha2-ce finup: correct digest for empty data
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 May 2019 at 16:35, Elena Petrova <lenaptr@google.com> wrote:
>
> The sha256-ce finup implementation for ARM64 produces wrong digest
> for empty input (len=0). Expected: the actual digest, result: initial
> value of SHA internal state. The error is in sha256_ce_finup:
> for empty data `finalize` will be 1, so the code is relying on
> sha2_ce_transform to make the final round. However, in
> sha256_base_do_update, the block function will not be called when
> len == 0.
>
> Fix it by setting finalize to 0 if data is empty.
>
> Fixes: 03802f6a80b3a ("crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Thanks again

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index a725997e55f2..6a5ade974a35 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -60,7 +60,7 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
>                            unsigned int len, u8 *out)
>  {
>         struct sha256_ce_state *sctx = shash_desc_ctx(desc);
> -       bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
> +       bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
>
>         if (!crypto_simd_usable()) {
>                 if (len)
> --
> 2.22.0.rc1.257.g3120a18244-goog
>
