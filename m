Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD10C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Oct 2023 12:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbjJaMll (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 08:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjJaMll (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 08:41:41 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D4D97
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 05:41:38 -0700 (PDT)
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A10E03F129
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 12:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698756095;
        bh=zcGwSBRA6ufPKm+xyJIjCt95bg5XiP7QWvMBR4La2F8=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=cits1b2XH22GGGQUBue4Jim6BzPPeuAhM1oREQY43RC0t+bZpYAWtUuJSpURBmB0g
         EgocXKcgijtnZwHA4o6c86EwFuhVa1BKu2kH8B8OoPhkAVt53lq9huOJHVP+3/h7Mn
         OnXFYFaDlSQ7im3D7PHAPQgOFEoRLbmj3mfBlNyc8wAxmMpCWgjgdGTjfsiLsdpk++
         GTolQ/1Lq1B1fW+o96qyrexY2NqIkGDIVIZVZaqJWRPBTFFJRVHvcBBAdyTYJ2ftoh
         pmBXwW9PlPB4IUAimY94iUQtCO9cN+WzF2JErOGFm8DgJE3fagHj5tAN0GyhOeX1lI
         QEmzVoVnNMpCg==
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30932d15a30so2861992f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 05:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698756095; x=1699360895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zcGwSBRA6ufPKm+xyJIjCt95bg5XiP7QWvMBR4La2F8=;
        b=LsGOLZ/5nc3ke1xAK/KuDx+3/QVrUEjs5iFDctTXIz8XHouj7HHatlhg4+T47xEJJ5
         +DTQOZp2E8hbLAnitbldVHM7atWuTYqEvVjbesJLhP4DC4ZYCxXcgpLCFAWrJOkP1LTn
         IkCqAI5OFqSa5RoHc7sX0I5scO7uwHbFB3QQISYSV9jU8GTFf3A4AJQiyVtQUB9EBCVp
         4dr2y/4Uiz51noPcjWkkIvB72DN/6bxsPdhRAVMcLFb1kZw3cQNXGFB6YBctShRIMvN8
         v/8O9iULXt0KMpFx6Onb6yli8vJSoFme0GJuK1RkOeTgMIN77CcdxeQGcI2/war+uA5f
         XA9w==
X-Gm-Message-State: AOJu0Yx9kuDpWWm9OO3pAS0qdyvxpsSnzPRyUYowbkmYH4pr6CtAXYMo
        QbIaamhNTwcdn7EuG4Z1BINMEX5784H7F0Wg6yA+GoUvNO2+dqlfs7KfJX1Z4VP57i0zwmtxcoJ
        bbCR5RjNARONPJe3poC773OD1OOmDfFjXjs11KN3V7YJeSd/iO9vE+1IbAQ==
X-Received: by 2002:a5d:4f05:0:b0:32d:9b30:9a76 with SMTP id c5-20020a5d4f05000000b0032d9b309a76mr12226050wru.47.1698756095225;
        Tue, 31 Oct 2023 05:41:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQoFQGsD1Ihypw2/jpfhpY7bzRCcEMDnxwA66KZ1VN7MkenpcifOB9eZ5ck56tKF0CIdMs+JEYnxdHwuaMnMo=
X-Received: by 2002:a5d:4f05:0:b0:32d:9b30:9a76 with SMTP id
 c5-20020a5d4f05000000b0032d9b309a76mr12226036wru.47.1698756094789; Tue, 31
 Oct 2023 05:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20231027195206.46643-1-ebiggers@kernel.org>
In-Reply-To: <20231027195206.46643-1-ebiggers@kernel.org>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Tue, 31 Oct 2023 14:40:58 +0200
Message-ID: <CADWks+ZZV4-0Vcnhm+U8OK848TLbKM2z2PuvjBwvcqDHenpq8g@mail.gmail.com>
Subject: Re: [PATCH] crypto: testmgr - move pkcs1pad(rsa,sha3-*) to correct place
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 27 Oct 2023, 22:52 Eric Biggers, <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> alg_test_descs[] needs to be in sorted order, since it is used for
> binary search.  This fixes the following boot-time warning:
>
>     testmgr: alg_test_descs entries in wrong order: 'pkcs1pad(rsa,sha512)' before 'pkcs1pad(rsa,sha3-256)'
>
> Fixes: ee62afb9d02d ("crypto: rsa-pkcs1pad - Add FIPS 202 SHA-3 support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Noted, and will check for this in the future. I didn't know that order matters.

Reviewed-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>

> ---
>  crypto/testmgr.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 1dc93bf608d4..15c7a3011269 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -5450,37 +5450,37 @@ static const struct alg_test_desc alg_test_descs[] = {
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
>                 .alg = "pkcs1pad(rsa,sha256)",
>                 .test = alg_test_akcipher,
>                 .fips_allowed = 1,
>                 .suite = {
>                         .akcipher = __VECS(pkcs1pad_rsa_tv_template)
>                 }
>         }, {
> -               .alg = "pkcs1pad(rsa,sha384)",
> +               .alg = "pkcs1pad(rsa,sha3-256)",
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
> -               .alg = "pkcs1pad(rsa,sha512)",
> +               .alg = "pkcs1pad(rsa,sha3-384)",
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
> -               .alg = "pkcs1pad(rsa,sha3-256)",
> +               .alg = "pkcs1pad(rsa,sha3-512)",
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
> -               .alg = "pkcs1pad(rsa,sha3-384)",
> +               .alg = "pkcs1pad(rsa,sha384)",
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
> -               .alg = "pkcs1pad(rsa,sha3-512)",
> +               .alg = "pkcs1pad(rsa,sha512)",
>                 .test = alg_test_null,
>                 .fips_allowed = 1,
>         }, {
>                 .alg = "poly1305",
>                 .test = alg_test_hash,
>                 .suite = {
>                         .hash = __VECS(poly1305_tv_template)
>                 }
>         }, {
>                 .alg = "polyval",
>
> base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
> --
> 2.42.0
>
