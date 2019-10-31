Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F35CA9EC3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0572083E
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c14BIyVg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfJaINZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:13:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34281 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaINZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 04:13:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id e6so3307253wrw.1
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 01:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVTpH9x5w5p5t2TLyqv/I4Qxh336u+KvXbCEegt8Uv0=;
        b=c14BIyVgJODeeLH4b+TJ4cZ3xE088RbzxSHE1oTs79eyAHCgcKk3JXB0jSQIKMQBnF
         14T+VdlXD9Yhegoso0KsMVDY8BamFtWhmdyNa8fck76+mXM51IIrNkdguUrXkvA4gtj0
         lb1GzN5v4I9LbC+uEo91w4pMPlRwq5lQlQ1TYYB7KJT1hmZQQCsC96cvUOG6Pwg0ICSm
         P1NMe+P4DWXxpyUfW2mH9OoZ6RS2AylG1gmVsVTuUOrNiQXuC+S1BYcijFNSWxXd2n3D
         4prXedSxCp0ksj6cqn8BrOVUvrR9qh2IlvII0AkqKmYmSBuB3BB7RSvVICzQFd33hlME
         x5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVTpH9x5w5p5t2TLyqv/I4Qxh336u+KvXbCEegt8Uv0=;
        b=l25c5hsbHUgFHhmVfJAFEBGqvp1b4QdCDfx4t+hqTB+2C2TUfZT33lXzy5u6Ks5Qxr
         6zGg+USlaj3gDhRfAOWxEnRgH9FtNDegLW0KAGBH3oifPiILQ/EJGyGy5PGerTtr/XGg
         KsHoEB8YaHzcybUM8Ohu6vqADmbA3aYuT/SDNBGquEwOpk4EvCBVjruBiJwJsy6Vx/Ko
         Mb8TIV4ylDdRRmvYRurx7W4ZgVfRSYHz0z41yleogyjYWtFGH1yZXvwwQBCpEHt5Tiid
         18CnolT5QFupPHeL+l6S21k/Ia4N0Fmwco5GxBZXYbbA5LcQC8KnjQQmhYvhrpMal124
         5zcQ==
X-Gm-Message-State: APjAAAX10owUAMDHafla3Gn8uAkfadzhGayh6Jd00wpDgYZ1H6ljLm42
        ThtcgQOtTT3y1F4ExO2J/kXBWV32Z+4FPVQbDcyeIw==
X-Google-Smtp-Source: APXvYqz6adAsRCPRenCDRosUSP27YreZHLiRCFj8jQzS6Tz09/zC+Fh0l+FEOJ0uIHx4MuiYSdWocUlHuB9/hM3TrEg=
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr3981224wrw.32.1572509602778;
 Thu, 31 Oct 2019 01:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <aaf0f585-3a06-8af1-e2f1-ab301e560d49@huawei.com> <32b39396-d514-524f-a85c-3bc627454ba7@huawei.com>
In-Reply-To: <32b39396-d514-524f-a85c-3bc627454ba7@huawei.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 31 Oct 2019 09:13:10 +0100
Message-ID: <CAKv+Gu8A+kDK0Jtmu6oOO6jhgFkgYQ7=4tw_eMStmYPMkMp6iQ@mail.gmail.com>
Subject: Re: [PATCH v3] crypto: arm64/aes-neonbs - add return value of
 skcipher_walk_done() in __xts_crypt()
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hushiyuan@huawei.com,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 31 Oct 2019 at 08:02, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
>
> A warning is found by the static code analysis tool:
>   "Identical condition 'err', second condition is always false"
>
> Fix this by adding return value of skcipher_walk_done().
>
> Fixes: 67cfa5d3b721 ("crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS")
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Please don't send the exact same patch twice, and when you feel the
need to do so, just ask instead whether your patch was received or
not.

I'm sure Herbert will pick it up shortly.

> ---
> v2 -> v3:
>  - add "Acked-by:"
>
> v1 -> v2:
>  - update the subject and comment
>  - add return value of skcipher_walk_done()
>
>  arch/arm64/crypto/aes-neonbs-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
> index ea873b8904c4..e3e27349a9fe 100644
> --- a/arch/arm64/crypto/aes-neonbs-glue.c
> +++ b/arch/arm64/crypto/aes-neonbs-glue.c
> @@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_request *req, bool encrypt,
>                         goto xts_tail;
>
>                 kernel_neon_end();
> -               skcipher_walk_done(&walk, nbytes);
> +               err = skcipher_walk_done(&walk, nbytes);
>         }
>
>         if (err || likely(!tail))
> --
> 2.7.4.3
>
>
