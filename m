Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C898C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B3F22CF4
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 10:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566296664;
	bh=L31s6t7x42v6wJG53Df7WfNP+8oNhH2SFuO8LCDn2co=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=00UroRm+m76oYVio2BgMnQPWMX3j2ZfIfrjz3tYym2SKMLNB9waDtf6C4qOd7GN1R
	 zVm2ZrcDhBsJH1cBNOq4W6eRwvkBZSxiDly7YYrk+eLOZ5O+eUtQD/NWPdqHshHhLg
	 yXSkGpd/uvMj1GKKOXESyL57ozrslqOm5lxF4zsk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbfHTKYX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 06:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729341AbfHTKYW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 06:24:22 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674CB22CF4;
        Tue, 20 Aug 2019 10:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566296661;
        bh=L31s6t7x42v6wJG53Df7WfNP+8oNhH2SFuO8LCDn2co=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=I/CcpstfQYU/vMXJtcm9JPuCFcCCoy+ahKUC8q4SvHvOoPd3Wm1bFxMm6KXVaSEk5
         ySTyKLoMtsJTaNUjjfP1ByYefnb89Lo6U/bAnOBgvU6rz4FALln9u2sUq7zpHSQgID
         ioEl90xpEgkN5q3iw0jzJ5P5cIA49+02bLHShS7A=
Received: by mail-lf1-f50.google.com with SMTP id b29so3713311lfq.1;
        Tue, 20 Aug 2019 03:24:21 -0700 (PDT)
X-Gm-Message-State: APjAAAV1CExCHWSBrLztueNUEYjj6OFfO6p8fa4uqnP5sVb28yMg/U4z
        HqE99o7wfSxH6KDJH2n8lUclOOGw+sbTTmJSPiI=
X-Google-Smtp-Source: APXvYqxjrzH71f5snjBbfDKvg3rJNl8SpUphmyw6AjwWFKECN1FlsmtOVfA1P4SA3lnXbPN/hVAaeZSmFLNyxLUHArs=
X-Received: by 2002:a19:c20b:: with SMTP id l11mr14856295lfc.106.1566296659635;
 Tue, 20 Aug 2019 03:24:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190819142226.1703-1-ard.biesheuvel@linaro.org> <20190819142226.1703-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20190819142226.1703-3-ard.biesheuvel@linaro.org>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 20 Aug 2019 12:24:08 +0200
X-Gmail-Original-Message-ID: <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
Message-ID: <CAJKOXPevJjBuRJjUX=6BfuMZSLUyqP3fpi7_eWDF170RfPvL+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: s5p - use correct block size of 1 for ctr(aes)
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 19 Aug 2019 at 16:24, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Align the s5p ctr(aes) implementation with other implementations
> of the same mode, by setting the block size to 1.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/s5p-sss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index ef90c58edb1f..010f1bb20dad 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -2173,7 +2173,7 @@ static struct crypto_alg algs[] = {
>                 .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
>                                           CRYPTO_ALG_ASYNC |
>                                           CRYPTO_ALG_KERN_DRIVER_ONLY,
> -               .cra_blocksize          = AES_BLOCK_SIZE,
> +               .cra_blocksize          = 1,

This makes sense but I wonder how does it work later with
s5p_aes_crypt() and its check for request length alignment
(AES_BLOCK_SIZE). With block size of 1 byte, I understand that
req->nbytes can be for example 4 bytes which is not AES block
aligned... If my reasoning is correct, then the CTR mode in s5p-sss is
not fully working.

Best regards,
Krzysztof
