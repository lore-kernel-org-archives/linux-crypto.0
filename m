Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336015;
	b=EXaU9q3jBE1ic9l6je7gxOJrn5rxLTxskvRCUi56Kff50L0jEC8KZYMmyzXA5t7kOgPN
	 LOj1dIhauwGIwWdBako9PocFWJUqdz/qrrNEFab4t+bNjpW9fnxQCzJ3xNxn8fxNG/ei6
	 re9YMdE0NP0MLIGGyR5mJiass0oeTDXZ2u11rbIt/9HsUx5gPP7zA/ba7OwzAJufLHa1U
	 Cd2ofj9NYmyfvyrmM8VaWdcd9IrzNVGdaOVfbzsvF8NMVbL4x5W26RxSAjoU52w61xPaU
	 TXl8Yn5GB6CMNSYDhbxF6oqvcimA1Zh9/sUnDe7PgQGH+inBJlRsza5kxaQJ80VKcjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336015;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T/SnFkCayGx8K6l/oqZJSnqM0buBvXomcT1JYJ+sR6Y=;
	b=r2X8d4y/eu3ZkR9eXJsnb9tBLYAjo/phEBhDySUuRnTFJ33lqppFn/bJaN7q4/rVwLMj
	 g9ZCmbz1be0f6TN4HNNbGKf8vR/9q2dfkXU64kxH8uGkdvjlzwOip5LNFiNLbGhD6nyNp
	 oRRyyvDqvXGGp5aQAka/4IvEHbv1rTJdshQU++q2l39TWsw+OnFQM+4+nxag8KcNZSfVn
	 DBBYMHhdmEzJne69FsL9h4cox3XibylCmsy7kmzqhBY6GljZSkyB+XyluWhkwaimsdnoi
	 9brMJbozIqFZl5DuB1IK2MMeSkLcTywoHuNL3vzRSzAzIZuLJM5ssuu3vXue1rFcFKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnIwFl43;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E41D606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 04:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnIwFl43
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8640C1F0093A;
	Fri, 30 Oct 2026 04:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336015;
	bh=T/SnFkCayGx8K6l/oqZJSnqM0buBvXomcT1JYJ+sR6Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jnIwFl43/jFf7BSsLrKRZZT8rfa/FIaMHcRsa1h/GaHnIE1H8z4u5iWSg48/ibiMJ
	 ygKJ/GoRVevh6F6vRn0VHJ/XDPb/aHgfsNnd4h8U+mFxPbwfLONG5Wm/DWExNREi4B
	 HHCeI5jZyFxE0dW//BiNLYkbaoSFkENzCU+ExUU4HdiejHx/ivtT3h3klKDWuOS4My
	 DV+dMsGZ/QrTXC1u6B6JaNo0q0VSfG/uiSHNznWpT8q3EpFelqyORA1u2hn9XAd7TY
	 Lpwm5TMfCWKXgxtGzsH8KV3fGD8PjmJXbG9SJXHZuY8lyyqDl74R519z2vngRV4rDx
	 iQqsyr11ERZ0w==
Message-ID: <sashiko-outbox-190323@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/5] net/rxrpc: Add local FCrypt-PCBC
 implementation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: "David Howells" <dhowells@redhat.com>, "Marc Dionne" <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org, "David
 S . Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>
In-Reply-To: <20260428024400.123337-2-ebiggers@kernel.org>
References: <20260428024400.123337-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:34 +0000
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
- [Low] Missing export of `fcrypt_preparekey` causes a module build failure=
 for the KUnit test.
--

commit 987b9c773f38843aea47501d809de294b68d6aa0
Author: Eric Biggers <ebiggers@kernel.org>

net/rxrpc: Add local FCrypt-PCBC implementation

This commit adds a local implementation of FCrypt-PCBC encryption and
decryption to replace the crypto API version. It also introduces a KUnit
test suite for the net/rxrpc/ functions.

> diff --git a/net/rxrpc/fcrypt.c b/net/rxrpc/fcrypt.c
> new file mode 100644
> index 000000000000..46038a02c0c0
> --- /dev/null
> +++ b/net/rxrpc/fcrypt.c

[ ... ]

> +void fcrypt_preparekey(struct fcrypt_key *key, const u8 raw_key[FCRYPT_B=
SIZE])
> +{
> +	u64 k =3D 0;
> +
> +	/* Load the 56 non-parity bits of the key.  Discard the parity bits. */
> +	for (int i =3D 0; i < 8; i++)
> +		k =3D (k << 7) | (raw_key[i] >> 1);
> +
> +	/* Generate the key schedule word for each round. */
> +	for (int i =3D 0; i < FCRYPT_ROUNDS; i++) {
> +		key->sched[i] =3D cpu_to_be32(k);
> +		/* Rotate the low 56 bits of 'k' right by 11 bits. */
> +		k =3D (k >> 11) | ((k & ((1 << 11) - 1)) << (56 - 11));
> +	}
> +}

Since the KUnit test is defined as a tristate in Kconfig and built as a
separate module (rxrpc_kunit.ko) when CONFIG_AF_RXRPC_KUNIT_TEST=3Dm, does
this function also need an EXPORT_SYMBOL_IF_KUNIT() to avoid a modpost
undefined symbol error?

> +
> +/**
> + * fcrypt_pcbc_encrypt - Encrypt data using FCrypt cipher in PCBC mode
> + * @key: The key
> + * @iv: The 8-byte initialization vector
> + * @src: The source data
> + * @dst: The destination data.  Both in-place and out-of-place are suppo=
rted.
> + * @nblocks: The number of 8-byte blocks to encrypt
> + *
> + * WARNING: This cipher is insecure.  Not only is the 56-bit key easily
> + * brute-forced, the cipher itself is cryptographically weak and doesn't=
 even
> + * provide the intended 56-bit security level.  It effectively just acts=
 as an
> + * obfuscation algorithm.  It is supported only for backwards compatibil=
ity.
> + */
> +void fcrypt_pcbc_encrypt(const struct fcrypt_key *key,
> +			 const u8 iv[FCRYPT_BSIZE], const void *src, void *dst,
> +			 size_t nblocks)
> +{

[ ... ]

> +}
> +EXPORT_SYMBOL_IF_KUNIT(fcrypt_pcbc_encrypt);

It looks like EXPORT_SYMBOL_IF_KUNIT() was included for
fcrypt_pcbc_encrypt() and fcrypt_pcbc_decrypt(), but missed for
fcrypt_preparekey(), which is also called by the new test suite.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428024400.1233=
37-1-ebiggers@kernel.org?part=3D1
