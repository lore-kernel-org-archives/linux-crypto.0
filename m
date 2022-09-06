Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD88C6FA83
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 13:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbiIFN25 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 09:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239238AbiIFN2y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 09:28:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ACC74DF3
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 06:28:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09972CE1764
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 13:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA45C433B5;
        Tue,  6 Sep 2022 13:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662470928;
        bh=2KlJGOiHiWfI4/RIwOQWm87W8Nyjs2g6GLGvXfrp0i4=;
        h=In-Reply-To:References:Cc:From:Subject:To:Date:From;
        b=DT3QgVbiznqL4zWTtJDjwDAExV+bSdSkHpgmdouZTSCoxTJ6rq/XdGlQyV6HJlIYI
         one2hDc6+Mj9SqdVoiIBR0noOGq/7+Dj8MT/qjal9TQIWnrOIRnDB8D0au/xCdOF/J
         34dsADSz4m0A2eChkatqtjmRbGK/qxeHvvk+fZWcMdpaOalFVKt3IwcCfajj2j8cEr
         Kp7XwdoFJ9p24WsA4nRoYpk3JTdwZ2z9fhD886wWeAIiHMwnt9EkgVx3FvJcTz90sO
         NEjotAbEkX6vOr6nfJWx17nxwx0tJ5VzhHienZkPbzSxXcxFzWPurdhUP++T7yD607
         i5mRTgAi8votw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e25e423595ead12913c9d6444438d89d85270a37.1662430815.git.pliem@maxlinear.com>
References: <e25e423595ead12913c9d6444438d89d85270a37.1662430815.git.pliem@maxlinear.com>
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2] crypto: inside_secure - Change swab to swab32
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Message-ID: <166247092562.3585.2129014831753921041@kwain>
Date:   Tue, 06 Sep 2022 15:28:45 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-06 04:51:28)
> The use of swab() is causing failures in 64-bit arch, as it
> translates to __swab64() instead of the intended __swab32().
> It eventually causes wrong results in xcbcmac & cmac algo.
>=20
> Fixes: 78cf1c8bfcb8 ("crypto: inside-secure - Move ipad/opad into safexce=
l_context")
> Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
> v2:
>  Add fixes tag
>=20
>  drivers/crypto/inside-secure/safexcel_hash.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypt=
o/inside-secure/safexcel_hash.c
> index bc60b5802256..2124416742f8 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -383,7 +383,7 @@ static int safexcel_ahash_send_req(struct crypto_asyn=
c_request *async, int ring,
>                                         u32 x;
> =20
>                                         x =3D ipad[i] ^ ipad[i + 4];
> -                                       cache[i] ^=3D swab(x);
> +                                       cache[i] ^=3D swab32(x);
>                                 }
>                         }
>                         cache_len =3D AES_BLOCK_SIZE;
> @@ -821,7 +821,7 @@ static int safexcel_ahash_final(struct ahash_request =
*areq)
>                         u32 *result =3D (void *)areq->result;
> =20
>                         /* K3 */
> -                       result[i] =3D swab(ctx->base.ipad.word[i + 4]);
> +                       result[i] =3D swab32(ctx->base.ipad.word[i + 4]);
>                 }
>                 areq->result[0] ^=3D 0x80;                        // 10- =
padding
>                 crypto_cipher_encrypt_one(ctx->kaes, areq->result, areq->=
result);
> @@ -2106,7 +2106,7 @@ static int safexcel_xcbcmac_setkey(struct crypto_ah=
ash *tfm, const u8 *key,
>         crypto_cipher_encrypt_one(ctx->kaes, (u8 *)key_tmp + AES_BLOCK_SI=
ZE,
>                 "\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3\x3");
>         for (i =3D 0; i < 3 * AES_BLOCK_SIZE / sizeof(u32); i++)
> -               ctx->base.ipad.word[i] =3D swab(key_tmp[i]);
> +               ctx->base.ipad.word[i] =3D swab32(key_tmp[i]);
> =20
>         crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
>         crypto_cipher_set_flags(ctx->kaes, crypto_ahash_get_flags(tfm) &
> @@ -2189,7 +2189,7 @@ static int safexcel_cmac_setkey(struct crypto_ahash=
 *tfm, const u8 *key,
>                 return ret;
> =20
>         for (i =3D 0; i < len / sizeof(u32); i++)
> -               ctx->base.ipad.word[i + 8] =3D swab(aes.key_enc[i]);
> +               ctx->base.ipad.word[i + 8] =3D swab32(aes.key_enc[i]);
> =20
>         /* precompute the CMAC key material */
>         crypto_cipher_clear_flags(ctx->kaes, CRYPTO_TFM_REQ_MASK);
> --=20
> 2.17.1
>=20
