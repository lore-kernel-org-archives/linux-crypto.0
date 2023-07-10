Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2320DEB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 23:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjGJXKm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjGJXKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 19:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424801BF;
        Mon, 10 Jul 2023 16:10:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEFFD61259;
        Mon, 10 Jul 2023 23:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70293C433C7;
        Mon, 10 Jul 2023 23:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689030636;
        bh=8sYs0oJhv8C3D6vbycCvzDy7MRStcTggwjlS91xXHfo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WHrn6dUce/0SK5OppFPh4z+NfBA+J0JIjZ/a2s+It0xqanPkCN8NuiniAGWFsszDJ
         jtp/Q82CXOn1h9afl1tYGna68+t7niowebCXAzXv7MJOw0DJFNgNPoouunw8lgS3rm
         dxM5adaMzmaJAN+sjZjwEdS2Vsrl++UxM5CCHCGelwrJKhKTIDa0Lk8yZgSOhTKZIK
         cCiX/34FaI1ktsRhy3TKVyHjPUtX9vE11DnIZ8TierCkdhmVRraHl6Z9QIDitYnirI
         o837NZHFKr95lwIIdH25p/CPnQWTzqqFyh9wQgRAHQtlkrt6jMKZ0IiB1Uf9RLOQEQ
         8ExLKoTg/AzCA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 11 Jul 2023 02:10:31 +0300
Message-Id: <CTYVE0G0D53P.Y8A7V3C9BW9O@suppilovahvero>
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Dan Carpenter" <dan.carpenter@linaro.org>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Cc:     "David Howells" <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] KEYS: asymmetric: Fix error codes
X-Mailer: aerc 0.14.0
References: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
In-Reply-To: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon Jul 3, 2023 at 5:18 PM EEST, Dan Carpenter wrote:
> These error paths should return the appropriate error codes instead of
> returning success.
>
> Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without =
scatterlists")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  crypto/asymmetric_keys/public_key.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys=
/public_key.c
> index e787598cb3f7..773e159dbbcb 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -185,8 +185,10 @@ static int software_key_query(const struct kernel_pk=
ey_params *params,
> =20
>  	if (issig) {
>  		sig =3D crypto_alloc_sig(alg_name, 0, 0);
> -		if (IS_ERR(sig))
> +		if (IS_ERR(sig)) {
> +			ret =3D PTR_ERR(sig);
>  			goto error_free_key;
> +		}
> =20
>  		if (pkey->key_is_private)
>  			ret =3D crypto_sig_set_privkey(sig, key, pkey->keylen);
> @@ -208,8 +210,10 @@ static int software_key_query(const struct kernel_pk=
ey_params *params,
>  		}
>  	} else {
>  		tfm =3D crypto_alloc_akcipher(alg_name, 0, 0);
> -		if (IS_ERR(tfm))
> +		if (IS_ERR(tfm)) {
> +			ret =3D PTR_ERR(tfm);
>  			goto error_free_key;
> +		}
> =20
>  		if (pkey->key_is_private)
>  			ret =3D crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
> @@ -300,8 +304,10 @@ static int software_key_eds_op(struct kernel_pkey_pa=
rams *params,
> =20
>  	if (issig) {
>  		sig =3D crypto_alloc_sig(alg_name, 0, 0);
> -		if (IS_ERR(sig))
> +		if (IS_ERR(sig)) {
> +			ret =3D PTR_ERR(sig);
>  			goto error_free_key;
> +		}
> =20
>  		if (pkey->key_is_private)
>  			ret =3D crypto_sig_set_privkey(sig, key, pkey->keylen);
> @@ -313,8 +319,10 @@ static int software_key_eds_op(struct kernel_pkey_pa=
rams *params,
>  		ksz =3D crypto_sig_maxsize(sig);
>  	} else {
>  		tfm =3D crypto_alloc_akcipher(alg_name, 0, 0);
> -		if (IS_ERR(tfm))
> +		if (IS_ERR(tfm)) {
> +			ret =3D PTR_ERR(tfm);
>  			goto error_free_key;
> +		}
> =20
>  		if (pkey->key_is_private)
>  			ret =3D crypto_akcipher_set_priv_key(tfm, key, pkey->keylen);
> @@ -411,8 +419,10 @@ int public_key_verify_signature(const struct public_=
key *pkey,
> =20
>  	key =3D kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
>  		      GFP_KERNEL);
> -	if (!key)
> +	if (!key) {
> +		ret =3D -ENOMEM;
>  		goto error_free_tfm;
> +	}
> =20
>  	memcpy(key, pkey->key, pkey->keylen);
>  	ptr =3D key + pkey->keylen;
> --=20
> 2.39.2

I'll pick this as I'm late with 6.5 PR.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
