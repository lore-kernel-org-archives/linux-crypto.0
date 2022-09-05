Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A22AECAAD5
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Sep 2022 09:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbiIEJPE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Sep 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiIEJPA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2022 05:15:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E39215FC7
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 02:14:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFC2E6118A
        for <linux-crypto@vger.kernel.org>; Mon,  5 Sep 2022 09:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5593C433C1;
        Mon,  5 Sep 2022 09:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662369297;
        bh=b3mKhOIaMNyWH7rYsB9hRh1xqCDTCyuaqTQJXi3+WOU=;
        h=In-Reply-To:References:To:Subject:Cc:From:Date:From;
        b=FHeqU8vi+N06NzVwUF0a8rDEuttc0b4y7hUQlYWG+uBscH0Fx81ETl7NexSmZcwEc
         wBLEsvxdRssuMhFZyXXHPkys/0CzHDNRj2v4JOapyw4FxnRU18J02NRRigBcF9m7fB
         ur1Rl3e/waxYJiWxZhO9J3A4Rq8kZd3T2nTFz0cTacP1WkiFUwrIeFFSFTA0eWiTTe
         qc6RcR1zwuz3GljG47Z2VUvV4ex9adMSYOL+K+Ca+YjZNt6l1ZhzxqwibVEO7jniYq
         8oTx1SiXiBzg8BI0CIBXCmB/bllk41xwADTdMNv3W4Fdb2bNcAdMheZSmrBxAPLtDD
         b7f8s6VwJ6hkQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8e639ef525eab18a0628df948459bbef11553ba1.1661827923.git.pliem@maxlinear.com>
References: <8e639ef525eab18a0628df948459bbef11553ba1.1661827923.git.pliem@maxlinear.com>
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: inside_secure - Change swab to swab32
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <166236929443.3222.6763048576511318677@kwain>
Date:   Mon, 05 Sep 2022 11:14:54 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

Quoting Peter Harliman Liem (2022-08-30 04:58:45)
> The use of swab() is causing failures in 64-bit arch, as it
> translates to __swab64() instead of the intended __swab32().
> It eventually causes wrong results in xcbcmac & cmac algo.
>=20
> Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>

This is a fix, can you add a Fixes: tag?

Thanks!

> ---
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
