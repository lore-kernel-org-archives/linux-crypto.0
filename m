From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] "its" == "something belong to it". "it's" == "it is",
 "it has", "it was", etc. Sorry - just bugged me as I was reading the code.
Date: Mon, 17 Nov 2014 18:47:57 +0100
Message-ID: <546A34CD.1080203@gmail.com>
References: <1416243964-9790-1-git-send-email-terence.eden@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, trivial@kernel.org,
	edent <github.com@shkspr.mobi>
To: Terence Eden <terence.eden@gmail.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:56997 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKQRsB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Nov 2014 12:48:01 -0500
In-Reply-To: <1416243964-9790-1-git-send-email-terence.eden@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Le 17/11/2014 18:06, Terence Eden a =E9crit :
> From: edent <github.com@shkspr.mobi>
>=20
> Signed-off-by: edent <github.com@shkspr.mobi>
> ---
>  crypto/ahash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index f6a36a5..ffbcda3 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -271,7 +271,7 @@ static int ahash_save_req(struct ahash_request *r=
eq, crypto_completion_t cplt)
>  	/*
>  	 * WARNING: We do not backup req->priv here! The req->priv
>  	 *          is for internal use of the Crypto API and the
> -	 *          user must _NOT_ _EVER_ depend on it's content!
> +	 *          user must _NOT_ _EVER_ depend on its content!
>  	 */
> =20
>  	req->result =3D PTR_ALIGN((u8 *)priv->ubuf, alignmask + 1);
>=20

Hello

Please sign off with your real name.
Your subject line is wrong, you need to add the subsystem "crypto:" and=
 the subject must be simplier; but you could keep the actual subject as=
 a commit message

<example>
[PATCH] crypto: Fix a typo in ahash.c

"its" =3D=3D "something belong to it". "it's" =3D=3D "it is", "it has",=
 "it was", etc. Sorry - just bugged me as I was reading the code.
</example>

Regards

LABBE Corentin
