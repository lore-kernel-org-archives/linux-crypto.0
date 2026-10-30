Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336016;
	b=Sev/voLDdlP06iIsWJ7+taCQpSQygdf7Bh40PEsJUjzpsyMAH58jbGSqQsnzhNPYKmzh
	 2IznkpFe+1hxUqVgp/ovMELLylhLlfuPx+8SKqRt77EJ+FPb5WRL9AeaZ7oAjDzgBk5ZD
	 0Hgx4rgDzjtrDdbSL0zxx38x+evNUrBz2crQJ4SLfaESbssoddxYGTUGqqoX7/Mwm90gR
	 ZUWvNvIfQS0A3SHiLwvLoIn5kej/Ipdho8/niekiFMFo9PJ1/VYRLOcdk2Lq0KWvKuwwu
	 XEr9AFrr7L7WdGg171Wroom2GmJ11LlQj1rxbphUl0jnbdFnA1fUUtta5nmoPCdJ5Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336016;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G2iCRNYUffRl1zO0lOs9+mUZl/nKiKj1K4/YeJJQK+A=;
	b=megrVu3v4rc92OhUlyU3oWw6mi1s0EgktH9c/XPhQAA3YJS8UsVvBJU7E4JStij6t9xd
	 wADu1P/iWtSdhapesf4sxVK8VI9dSHL5ojYkxCD13dWEa/PqvfEECZMdsBNJP6dy2y/1s
	 +0/yZFRCQQXunYmNPokBFhIM7eV2AiZWZ0n8tG+cloTCOx6jD6EcCfL4+e3XRmdy4St++
	 IHMxpaXrpX/0/Sk+Q7VF3IycVTDNEEKC3VHhqY3CXYF0qrb9XNxeofmHuwmVyB5+Oq6CP
	 DNGzTxepu+8GMI4eyO2olME2va2tSYfPJAPZr7esn6ID9GbMmbqMaSMitfIflT6V5bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWEm1cSc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254B4606A31F
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 04:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oWEm1cSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761FA1F000C1;
	Fri, 30 Oct 2026 04:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336015;
	bh=G2iCRNYUffRl1zO0lOs9+mUZl/nKiKj1K4/YeJJQK+A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oWEm1cSciC9FeEKZvunuDp9B1lpd/mJkI9Rdk9sx2V7/FLfVjbhLitkociMlyrr0J
	 gkC49JwwYBlkAtoMlsU/1k4iUq+9KlGD+XZ49IGTtRt9LHLjLUpzmp+TVFBYP9rdNY
	 cjSRWEu2zkrz2VBrvWL23WkSnHz8ToqsqWr6CtKC57dmgRSJPudhN8+acPxpVzES3r
	 PbO/or0D+s5Uz/LwUJ7Lz15fnx+qtQECzhqpRruRoDHUV3bugGoJYe3tYyqCET1Th/
	 lrZ83XpaapVf2G65Q9H5YNLf8qTGGQMXYGiN4Wj/e0S+SivZOUjTV3B2RH4Maev4sU
	 MBVoDAlevcllQ==
Message-ID: <sashiko-outbox-190324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC
 implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: "David Howells" <dhowells@redhat.com>, "Marc Dionne" <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org, "David
 S . Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>
In-Reply-To: <20260428024400.123337-3-ebiggers@kernel.org>
References: <20260428024400.123337-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:35 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Stack-allocated `struct fcrypt_key` is not zeroized before retur=
ning in `rxkad_decrypt_response()`.
--

commit cab871c1c0eecff467a076e259b88fd1f8a50b0a
Author: Eric Biggers <ebiggers@kernel.org>

net/rxrpc: Use local FCrypt-PCBC implementation

This patch replaces the crypto API implementation of FCrypt-PCBC with a
local implementation. This improves performance, allows removing the crypto
API dependency, and simplifies the decryption code by linearizing the skb.

> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index cba7935977f0..3c9e7f636b42 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c

[ ... ]

> @@ -1095,39 +916,22 @@ static int rxkad_decrypt_ticket(struct rxrpc_conne=
ction *conn,
>  /*
>   * decrypt the response packet
>   */
> -static int rxkad_decrypt_response(struct rxrpc_connection *conn,
> -				  struct rxkad_response *resp,
> -				  const struct rxrpc_crypt *session_key)
> +static void rxkad_decrypt_response(struct rxrpc_connection *conn,
> +				   struct rxkad_response *resp,
> +				   const struct rxrpc_crypt *session_key)
>  {
> -	struct skcipher_request *req =3D rxkad_ci_req;
> -	struct scatterlist sg[1];
> -	struct rxrpc_crypt iv;
> -	int ret;
> +	struct fcrypt_key cipher;
> =20
>  	_enter(",,%08x%08x",
>  	       ntohl(session_key->n[0]), ntohl(session_key->n[1]));
> =20
> -	mutex_lock(&rxkad_ci_mutex);
> -	ret =3D crypto_sync_skcipher_setkey(rxkad_ci, session_key->x,
> -					  sizeof(*session_key));
> -	if (ret < 0)
> -		goto unlock;
> -
> -	memcpy(&iv, session_key, sizeof(iv));
> -
> -	sg_init_table(sg, 1);
> -	sg_set_buf(sg, &resp->encrypted, sizeof(resp->encrypted));
> -	skcipher_request_set_sync_tfm(req, rxkad_ci);
> -	skcipher_request_set_callback(req, 0, NULL, NULL);
> -	skcipher_request_set_crypt(req, sg, sg, sizeof(resp->encrypted), iv.x);
> -	ret =3D crypto_skcipher_decrypt(req);
> -	skcipher_request_zero(req);
> -
> -unlock:
> -	mutex_unlock(&rxkad_ci_mutex);
> +	fcrypt_preparekey(&cipher, session_key->x);
> =20
> +	static_assert(sizeof(resp->encrypted) % FCRYPT_BSIZE =3D=3D 0);
> +	fcrypt_pcbc_decrypt(&cipher, session_key->x, &resp->encrypted,
> +			    &resp->encrypted,
> +			    sizeof(resp->encrypted) / FCRYPT_BSIZE);
>  	_leave("");
> -	return ret;
>  }

Does this code leave the cryptographic key material on the stack?

The local struct fcrypt_key cipher is allocated on the stack and initialized
with the session key schedule via fcrypt_preparekey(). After the decryption=
 is
complete, the function returns without securely erasing this key schedule f=
rom
the stack.

Could we call memzero_explicit(&cipher, sizeof(cipher)) before returning to
ensure the key material is cleared?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428024400.1233=
37-1-ebiggers@kernel.org?part=3D2
