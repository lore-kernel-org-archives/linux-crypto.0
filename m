Return-Path: <SRS0=HT46=UT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B343C43613
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 19:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F992084A
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jun 2019 19:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aVdWCB4z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFTT5O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:57:14 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:37052 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbfFTT5N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jun 2019 15:57:13 -0400
Received: by mail-io1-f68.google.com with SMTP id e5so494879iok.4
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2019 12:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZBE/7zbNKjrgccPgeQ2NlN2FSVmmv0iIVaVXtWq9Ko=;
        b=aVdWCB4zKkHtxQcwa1IBEAlJ/qAnPpbv8xInqEWHdh8UCgdAKbD1GXEf/V7E7ubYut
         26yciaqH5f6447xzlmO4ffDgUo61qHf5GH81zsUNiZasS3L866rFGKEElrSDuSPKoBDJ
         0cuy7n+YTOGS2WgDXSsGBYdGp4xRbQhiiBcHAnFq1jLe61YTsrr3EAPDPTVqU/Xw2ply
         TlJsc02atIr8Vz4J3kA1JwWSkTbEa43T4/TwEbQcnh8L2CH2rqwcfo6C0+VxzKd7ChcY
         VjWztzDpMTyCI97kX6Xt/tNGwPFsuBdojkvq2wxCPMhdSsid45awdcrkgaWzDAUZuVq/
         XwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZBE/7zbNKjrgccPgeQ2NlN2FSVmmv0iIVaVXtWq9Ko=;
        b=dzXCDW1dURx9J53RlsmvAwYXlvU5kt63PYrKObqZp5GY1tiQPsA29EOjdHUmwqGG3g
         TpbAp4YFXUH4MQ3dNHHxGpywJJB+USR4hLIur93fr4qSN+44HgWMzu02hK6wKDRlvND6
         Br7towWSdxQlLsI+HxhW8lGa/lxVI4LDSBBNXpzeku77RySnfSHYJo9I+urbD7T6CCMw
         Syliy+mFg+gGNnrmofoRZnTMd029io0EiqDfZ4sXS7ZIX5fiOmtfqXRp77Dip8Q3wG/S
         688/fabclDOu/BTpxDP8j5pKTcbHzX6dlVceZllZBsdDJTdcDEDKZi9+WBWD4mIZtxH/
         ipng==
X-Gm-Message-State: APjAAAWwjFaOD6KMFNwESD/zSCKm5quO3uHxIK9jdvgbDblfxBZpzeZc
        8K9CEBOdrDhQTM6BqsQWf9PFvFDVpEINHJrfogXAvw==
X-Google-Smtp-Source: APXvYqxlpJiPVw9qHZ8D7sJwcBAgMvb87RHTzAypaYjWoAXudjuFU7E7FKU4bxoD6D40Ws1SqHWjr4SyOJdorylnnUY=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr32338608ion.128.1561060632050;
 Thu, 20 Jun 2019 12:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190620181505.225232-1-ebiggers@kernel.org>
In-Reply-To: <20190620181505.225232-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 21:56:58 +0200
Message-ID: <CAKv+Gu_D3hO1boyL3sYcZaUTCxw8fb+O6KTAEa2SmWRa-nOkew@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: remove selection of CONFIG_CRYPTO_SHA256
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 20 Jun 2019 at 20:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> fscrypt only uses SHA-256 for AES-128-CBC-ESSIV, which isn't the default
> and is only recommended on platforms that have hardware accelerated
> AES-CBC but not AES-XTS.  There's no link-time dependency, since SHA-256
> is requested via the crypto API on first use.
>
> To reduce bloat, we should limit FS_ENCRYPTION to selecting the default
> algorithms only.  SHA-256 by itself isn't that much bloat, but it's
> being discussed to move ESSIV into a crypto API template, which would
> incidentally bring in other things like "authenc" support, which would
> all end up being built-in since FS_ENCRYPTION is now a bool.
>
> For Adiantum encryption we already just document that users who want to
> use it have to enable CONFIG_CRYPTO_ADIANTUM themselves.  So, let's do
> the same for AES-128-CBC-ESSIV and CONFIG_CRYPTO_SHA256.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  Documentation/filesystems/fscrypt.rst | 4 +++-
>  fs/crypto/Kconfig                     | 1 -
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 08c23b60e01647..87d4e266ffc86d 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -191,7 +191,9 @@ Currently, the following pairs of encryption modes are supported:
>  If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>
>  AES-128-CBC was added only for low-powered embedded devices with
> -crypto accelerators such as CAAM or CESA that do not support XTS.
> +crypto accelerators such as CAAM or CESA that do not support XTS.  To
> +use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
> +implementation) must be enabled so that ESSIV can be used.
>
>  Adiantum is a (primarily) stream cipher-based mode that is fast even
>  on CPUs without dedicated crypto instructions.  It's also a true
> diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
> index 24ed99e2eca0b2..5fdf24877c1785 100644
> --- a/fs/crypto/Kconfig
> +++ b/fs/crypto/Kconfig
> @@ -7,7 +7,6 @@ config FS_ENCRYPTION
>         select CRYPTO_ECB
>         select CRYPTO_XTS
>         select CRYPTO_CTS
> -       select CRYPTO_SHA256
>         select KEYS
>         help
>           Enable encryption of files and directories.  This
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
