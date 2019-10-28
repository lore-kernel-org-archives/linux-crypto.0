Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A77CA9EC1
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B4221726
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:07:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y7NnUOPB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfJ1GHj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 02:07:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33128 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731716AbfJ1GHj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 02:07:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id s1so8522006wro.0
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 23:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KmMt7SzooEEjpQsYvS50r/ksX3U43q8XKV3PLC8gK6s=;
        b=y7NnUOPBxuy3vXFM0z47vdx/79vhlOqKvkhDUQ9AD6c3Z34mK+rVwgOzz9LRw2B7aY
         Tp2oILBUxomYeuKGSIcLwpLwXUxyTtFCs5dunPAjJ0+yyLyWJv+g52g1BpLA+V67Bbky
         MJDvrF6KivuKs9MzVwVu7p+J1EAtDBdPCYUjAYs3QTHJrS9NfsGHPJBv0UM5o9O1pLQt
         FxlQ+KfuQsTNJLtch4Zpgk0r6hqvshQM+CQkhbfG3u6cju0BvT9ZupAjEnEO9XGYB/J0
         LZV8QGj4H2wZ1yUXZsEebU7zVbBQYcmhEDkAyTI1uaWeYgShAGc0qxqIypKACAPocl7C
         lEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KmMt7SzooEEjpQsYvS50r/ksX3U43q8XKV3PLC8gK6s=;
        b=sCnUogCnj/2I8PofxT8flBvs85MZ8sgYXrYEMhkfZSgSE2EEsjQmm6OaStYo5FzUKY
         +f61h4aLKLt4AFMoWNYbzQCRt5YBrya37TIJirinXEuz1QBTqClDJ7cnWOKx+A0u48Kk
         IdrWZBi+IJqiSfaoDax0VAc/EvrAUK0uGgTFjtg/AYquvthceTmwsVtmQdupNZQtQ4VQ
         WtheaYw0Pu/Uz+4Eo6S+sjYWUCwCxgeUGFWaeqjqDCgFe17Y38sOZvURnxyWvLIfsZ1n
         ciCcf4IVP6xOk75JSg5MJDtuqDBrOT1U2vALCvONav1pHB1t2lHQEcDfDejkMtSiVFNc
         0Bxw==
X-Gm-Message-State: APjAAAVaeTCMcP8ljLwMFZs/DlirfZ8wpmDLnCMFnoQYogasLeLJzjdL
        lgtwq6hhfcU+3vfFcED0zgoZjAGR+QPBznTEtJt7JKUh96g=
X-Google-Smtp-Source: APXvYqxlrAi55r1yFFbV6fLiZ25x2ig4t7vUWTLuYGOTfCDbvl4lCx7kr/WiAPIk0c3+mSm4xxP+bkbk07dva9+N9Fk=
X-Received: by 2002:adf:9f08:: with SMTP id l8mr12859938wrf.325.1572242857645;
 Sun, 27 Oct 2019 23:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191027154747.14844-1-chunkeey@gmail.com>
In-Reply-To: <20191027154747.14844-1-chunkeey@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 28 Oct 2019 07:07:35 +0100
Message-ID: <CAKv+Gu_NSSy7Ea9X83ZDW=yqik_pcksGe7T8+vxdeZRKz_midg@mail.gmail.com>
Subject: Re: [PATCH] crypto: amcc - restore CRYPTO_AES dependency
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 27 Oct 2019 at 16:47, Christian Lamparter <chunkeey@gmail.com> wrote:
>
> This patch restores the CRYPTO_AES dependency. This is
> necessary since some of the crypto4xx driver provided
> modes need functioning software fallbacks for
> AES-CTR/CCM and GCM.
>
> Fixes: da3e7a9715ea ("crypto: amcc - switch to AES library for GCM key derivation")
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/crypto/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 23d3fd97f678..06c8e3e1c48a 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -332,6 +332,7 @@ config CRYPTO_DEV_PPC4XX
>         depends on PPC && 4xx
>         select CRYPTO_HASH
>         select CRYPTO_AEAD
> +       select CRYPTO_AES
>         select CRYPTO_LIB_AES
>         select CRYPTO_CCM
>         select CRYPTO_CTR
> --
> 2.24.0.rc1
>
