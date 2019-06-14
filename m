Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470A0C31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 15:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FD9B2177E
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 15:34:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nxrt4giW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFNPea (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 11:34:30 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37605 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbfFNPe3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 11:34:29 -0400
Received: by mail-yb1-f195.google.com with SMTP id v144so1246471ybb.4
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jun 2019 08:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZvSLdb4tGoj1KerVcujZWEcT0dZuhjXYXXie7nT7mXw=;
        b=nxrt4giWUlhE9biCVR+Nf7l0dQrFKvxLWDlX56RbVNxUEL0bUAFHio4l+uzl0nCxh7
         xXzwrZb2/VMVmB+aSmN56g905HvDn3pCUAGYNxE7lgaqutKZ1nzEtyOuvhGIdaUqZWnO
         iwxssJBIDgARes03cNAnQxvq0Dawjb1fSsJgBu8clFk87sKOVkvglbqQV3ArKpwt6YEY
         U0yhmXm8J5eHwfiEs6Vzf64EyDO/hlefYNr8XiDq9Xwgo4Bt8mHGoKc5wR3Umn5k4VRm
         PysrCqMQJpRReJvso+/R9WYMkI5EyDmBVUwyI4P9kGBArUktyJcbMOmfUlNvfdkoZDtt
         cflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZvSLdb4tGoj1KerVcujZWEcT0dZuhjXYXXie7nT7mXw=;
        b=udOzB9gnnwoEz6VvVGUtYoiOKY/u9fvct6ZWHGSwDqXmfc+PafZg1h3qPmLF1uM7Ut
         6KxPfZDd8cHKf2Ipr3BvOSbroCtjXDnxdQnOtp/i84KuoW8ZfC0N5H1QFgTlHUqXRw2K
         YUBPqY+zKWAyqHRhI2NUaVFedPBjhKiFGxH4hN5XnNmfroxuTewGJCkdy0oRMenXhVol
         /eVJsHFisqECCC14dMmLsmjVu7V4h8xF/aE/7/WG8qI2qqPvmB8TzkMmrXZZ0HFGtugQ
         IKXihsEuR1enaqbcwptWhvDFYs15J0UQlMo7j1EwX5C5JPjI+dxvipY5kg3zaenx50gF
         11YQ==
X-Gm-Message-State: APjAAAVaeJDOGpbVvu5tFjfZaosYPcwh7sg6CeG98PiAfyOq2ujBADDC
        Ywf63tEC9Q4qUj2p2Kh4l+OmTgK4/9r7ZPuQOPjsRkWhWcw=
X-Google-Smtp-Source: APXvYqxJrrGfUL+aUSndZe9HBl/gZBDc+JU5kN+yx29GOggyBQLueAHuwXlwxFosnw1LNNcCP2ngQVFfaoX1rv+mQ8E=
X-Received: by 2002:a25:55d7:: with SMTP id j206mr50996255ybb.234.1560526468360;
 Fri, 14 Jun 2019 08:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190614140122.20934-1-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 14 Jun 2019 08:34:16 -0700
Message-ID: <CANn89iKP2fQ6Tc0jBW_WdLq3kYQx7NsdVDB5S3y453T+6yp86g@mail.gmail.com>
Subject: Re: [PATCH v2] net: ipv4: move tcp_fastopen server side code to
 SipHash library
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, ebiggers@kernel.org,
        David Miller <davem@davemloft.net>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 14, 2019 at 7:01 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Using a bare block cipher in non-crypto code is almost always a bad idea,
> not only for security reasons (and we've seen some examples of this in
> the kernel in the past), but also for performance reasons.
>
> In the TCP fastopen case, we call into the bare AES block cipher one or
> two times (depending on whether the connection is IPv4 or IPv6). On most
> systems, this results in a call chain such as
>
>   crypto_cipher_encrypt_one(ctx, dst, src)
>     crypto_cipher_crt(tfm)->cit_encrypt_one(crypto_cipher_tfm(tfm), ...);
>       aesni_encrypt
>         kernel_fpu_begin();
>         aesni_enc(ctx, dst, src); // asm routine
>         kernel_fpu_end();
>
> It is highly unlikely that the use of special AES instructions has a
> benefit in this case, especially since we are doing the above twice
> for IPv6 connections, instead of using a transform which can process
> the entire input in one go.
>
> We could switch to the cbcmac(aes) shash, which would at least get
> rid of the duplicated overhead in *some* cases (i.e., today, only
> arm64 has an accelerated implementation of cbcmac(aes), while x86 will
> end up using the generic cbcmac template wrapping the AES-NI cipher,
> which basically ends up doing exactly the above). However, in the given
> context, it makes more sense to use a light-weight MAC algorithm that
> is more suitable for the purpose at hand, such as SipHash.
>
> Since the output size of SipHash already matches our chosen value for
> TCP_FASTOPEN_COOKIE_SIZE, and given that it accepts arbitrary input
> sizes, this greatly simplifies the code as well.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

While the patch looks fine (I yet have to run our tests with it), it
might cause some deployment issues
for server farms.

They usually share a common fastopen key, so that clients can reuse
the same token for different sessions.

Changing some servers in the pool will lead to inconsistencies.

Probably not a too big deal, but worth mentioning.
