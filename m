Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336017;
	b=lkhAtSqpNlRWPcrs5IF07fra/KYcF4o0OglYNlK5xg4VLpKayzhTGyjsF3HfGYXvWB6i
	 0sAWcWHwgA6Hgx2uXIyg1HBu/KY/uLN7mbhnq2FB5OmtNdKJHlTnwBW6BDMPgabZtfYhq
	 gne3Cw4KbR+8NgC7pi8MkCrzZG2B84kMVGCeZ/9l7PbIM6IXp9MmEyookgl7Wkd2PpF4Z
	 m9bmBZx+kixE/5FRqlAad4briKSvVYAiE9VjBDwttSL4uM/tO7sqA2nqRIdGe49JheInR
	 cspHwAstcvW/cj17AvcaeCeBKrjsfq83iYhGO1elGq8KAtVlFbmDuorBiGb5ZtRr1+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336017;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FfoEDdnm9ul9WCDkqkHSz1lDzM6UwugTDcW02Kztc7Y=;
	b=YznGDXAXVGTv/u4YUvYnhjLtNAn9KLBfDCucH3YooqeSazB8bvPU7XhIHIwmSqmNz63f
	 OvySqT7sOvYzciMEKoiHoLSkd8cGenOTqj7hj2xnUQ8ID2nnToabXLYQ42yBuAr+YdlWH
	 X4kU97Jag2rEMBCHh7tN0kKjOzQmflS9urpYcKBIofgMJXPi9zqnQnwh/cK5cwtfw2Gzk
	 0/dRg9KGQtJg4wEe/EKRIb7sBJiUOd6yeuKP4mB/ysZWakFxynonFYWmRzcH/xYMSvW+a
	 kSTdNoTBRQVwQzw2uUfywZ/1ypLL1dkOM4/GYz2YCFijvaFHMIYdfnZMMBZdevmEfxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwY1g4ge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ABF606A31D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 04:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwY1g4ge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A7E1F00A02;
	Fri, 30 Oct 2026 04:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336016;
	bh=FfoEDdnm9ul9WCDkqkHSz1lDzM6UwugTDcW02Kztc7Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GwY1g4geGdNyfWPOKtvcmXaUr+Cwp/iZPMLHaDt1WE/SFMQ2tUgpq6qv15HJnbg3d
	 g2IXxvzE8t7LzNGgIYbH84YrnYeeKGWvd24cxMYAX+DLvVtQ0A6msXgzjMXQbWM+xO
	 acMremtqP45szJkpZ+esJCBp99wgjxDGw3FeJ7fT5olpvfPulmZtp+npFh+jP9XInP
	 FARPbEy6mz26tAN4PkqET8eFHMuSKzvdXFrzumle4ecsf59g846qrIxtF6LJZn9q7N
	 VgcTFajKJyqqAWhthLgvTue5zceG/Wo361TA0srHVSO9Ie9OGT4wWKl7CYPW8pClDn
	 6DswC10deht5g==
Message-ID: <sashiko-outbox-190325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 3/5] net/rxrpc: Reimplement DES-PCBC using DES
 library
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: "David Howells" <dhowells@redhat.com>, "Marc Dionne" <marc.dionne@auristor.com>, linux-crypto@vger.kernel.org, "David
 S . Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>
In-Reply-To: <20260428024400.123337-4-ebiggers@kernel.org>
References: <20260428024400.123337-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:53:36 +0000
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
- [Medium] Weak DES keys will now be rejected when loading a server key, wh=
ereas previously they were accepted.
--

commit c24ad4e831d157713b86ce93d80475105c2362d5
Author: Eric Biggers <ebiggers@kernel.org>

net/rxrpc: Reimplement DES-PCBC using DES library

This commit reimplements the obsolete PCBC mode on top of the DES library
specifically for rxrpc, replacing its use of the crypto API "pcbc(des)"
template. This allows removing PCBC support from the generic crypto API.

> diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
> index 3c9e7f636b42..4e04625f40eb 100644
> --- a/net/rxrpc/rxkad.c
> +++ b/net/rxrpc/rxkad.c
[ ... ]
> @@ -52,40 +54,41 @@ static void rxkad_prime_packet_security(struct rxrpc_=
connection *conn,
>   */
>  static int rxkad_preparse_server_key(struct key_preparsed_payload *prep)
>  {
[ ... ]
> -	if (crypto_skcipher_setkey(ci, prep->data, 8) < 0)
> -		BUG();
> +	err =3D des_expand_key(des_key, prep->data, 8);
> +	if (err) {
> +		kfree_sensitive(des_key);
> +		_leave(" =3D %d", err);
> +		return err;
> +	}

Does this introduce an unintended behavior change regarding weak DES keys?

The old code used crypto_skcipher_setkey(), which in the generic DES
implementation suppresses the -ENOKEY error and returns 0 (success) unless
CRYPTO_TFM_REQ_FORBID_WEAK_KEYS is explicitly set. The RxRPC code did not
set this flag, meaning weak DES keys were silently accepted.

By calling des_expand_key() directly, which unconditionally returns -ENOKEY
for weak keys, rxkad_preparse_server_key() will now fail and reject these
keys instead of succeeding.=20

While weak keys shouldn't be used, could this undocumented change break
backward compatibility for existing userspace configurations or test
environments relying on fixed weak keys?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260428024400.1233=
37-1-ebiggers@kernel.org?part=3D3
