Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1D4C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07BDF2229F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZqJctNLe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393453AbfBNIO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:14:28 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:33104 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388919AbfBNIO0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:14:26 -0500
Received: by mail-it1-f196.google.com with SMTP id g137so3952954ita.0
        for <linux-crypto@vger.kernel.org>; Thu, 14 Feb 2019 00:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnU/nplvs9KtQAwyGNAnufzBfBDfyOyTBB2Sx80Knr4=;
        b=ZqJctNLeZ1hn6sljSLdQM5A8PzlLszGeCAqx3DzesvVx6VfEI2X0TaHslE6q48X6QW
         dS+7TfQKDppDMPl0+TxYMWhBGWdZ45bqm6NCBFZimtztNs3za6EY/XFdEsRcQpaepV7Z
         pxTNA+eLwH3qALbwHJ4QFTBxD93OlxEeDH3Jufp2HxQLLUnME0rBlm62ammwh6XkbrNj
         2pXrA2fCHmyzhxm5jt8b25Exnm75saiRijWi72YxrAORLnX/iFx7wYdxcdj9at3qFwCO
         tzXcyYo5HmJl8A/CssiR8ZSibWu893CTU4s4oXXFrPz5lMD8hqejT1C1+WUJJ0wEBI+v
         fdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnU/nplvs9KtQAwyGNAnufzBfBDfyOyTBB2Sx80Knr4=;
        b=eI4tOw7pLR1b9x/GFCigLExt/7FAoihGtrKoHxrY/fix+eJGs6A89qFsadsnhztQUv
         v5KbIofR78Oc+9uYuXYJnB9FJIel4cAq/k6CFSz+69y+HoBehVe1VvjLdCCz3WrmSemm
         AvF18nMHQF+pCAB6jsBvrimIY7tgvCY0UsugF4hjO5moEjrAIQWg+t4UnE466vgBlff+
         UFyq0HNXTyN0A/WvCMPq7W9CYe5ios7JVDxh1wOibQYpoi8lPxvT/jsmlh3eaRSWjenp
         nbmruRF6QcAzyCbO8qCiMIhqlh+UPT/WP7W/aqNTnTJ4deHhYXDAwg55TBvoQWxwEJFs
         nz2A==
X-Gm-Message-State: AHQUAubvj19YCRoMALRvyCyH40fbLE0Pxok52MV3TlkrFzXVkor7Zt/a
        m3JuShEzPk+to3jP+eBptSmh4fPl17Nk2C/45ACMQg==
X-Google-Smtp-Source: AHgI3IZIWhnVNCrOykRu3YekT8+BD1+KkkIq74dDMn5ddM4SyXF3bJuDobeBSDo6pEyD2WXEG5Mtaw5r5aLsPTSEr2c=
X-Received: by 2002:a5e:d609:: with SMTP id w9mr1335203iom.170.1550132065692;
 Thu, 14 Feb 2019 00:14:25 -0800 (PST)
MIME-Version: 1.0
References: <20190214080355.8112-1-ebiggers@kernel.org> <20190214080355.8112-6-ebiggers@kernel.org>
In-Reply-To: <20190214080355.8112-6-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 14 Feb 2019 09:14:13 +0100
Message-ID: <CAKv+Gu9J_PKP0MfScA+RTV3m7FPyVwD713fBeTjn9cA8sWSVAw@mail.gmail.com>
Subject: Re: [PATCH 5/6] crypto: arm64/aes-blk - update IV after partial final
 CTR block
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Feb 2019 at 09:04, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Make the arm64 ctr-aes-neon and ctr-aes-ce algorithms update the IV
> buffer to contain the next counter after processing a partial final
> block, rather than leave it as the last counter.  This makes these
> algorithms pass the updated AES-CTR tests.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

I take it this means we return an output IV even if the algorithm
could never proceed in a meaningful way, given that we throw away some
keystream bits that would be needed in that case.

That means this change is strictly there to make the test framework
happy, even for cases that can never appear in reality.

Wouldn't it be better not to set out_iv for input buffers whose size
is not a multiple of the block size?


> ---
>  arch/arm64/crypto/aes-modes.S | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index 67700045a0e0..4c7ce231963c 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -320,8 +320,7 @@ AES_ENTRY(aes_ctr_encrypt)
>
>  .Lctrtailblock:
>         st1             {v0.16b}, [x0]
> -       ldp             x29, x30, [sp], #16
> -       ret
> +       b               .Lctrout
>
>  .Lctrcarry:
>         umov            x7, v4.d[0]             /* load upper word of ctr  */
> --
> 2.20.1
>
