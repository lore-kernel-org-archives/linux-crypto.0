Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7162DBF49
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 07:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760944084; cv=none; b=nvRJZQgnUcRsBx94GCap4siCwqTjJPZJz4D1WijN9zZ7QMd2CZy4xMHR9k/IdClFfdgft+1/Z62kRxq48if309dDGYOUCH0LVV8WCIg5mFiael8R8VD+e8qNvHNy5310YQ6cqcDoh57NLHiFVVaYAd7oUrqpta57rmuI7hQRiaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760944084; c=relaxed/simple;
	bh=XZ0XrFe8i9BOKiZV0xnN18sfKKByLNmWtR6xj1Y69WY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcRB1RNXaDmvIWuZi8zWTL+y8lCgHEXentyP7JWi/Ab5/r8+mJcdAXWAOdyVJ0Y/xj3MJWWxUSCyfZHfQFDb2RBqnLhokhdMaf8/2jfsa626bfmX3m0Aq0IpWkYeU98LzK5phIc9/G+6cUYBkK9Ec/mpfIgsT9hrM/SXWLdNp+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hw8gCN7o; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hw8gCN7o"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-33b9dc8d517so3559009a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 00:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760944082; x=1761548882; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/HOxQeFzZprgS340iSyl+E8y8vVH7kK0gqo8lCK0SDQ=;
        b=Hw8gCN7oSJIanJ7seDeSs7cT6qmeINdD81LFwTET0BnrhqCnTwdyuTHwkSupgmlXzF
         czR+WcTrS2bCbbQey5V+60iOmwQogFHRTaQxrnKnZ9CM0OxZEv7KIo7yEkGFYAN2+A+L
         kjVjGVlj9uaUXZTnZTgdCyERCDYGGXKco6j9aCDAN36GASCpUFrTDapd7b3WBwlr+nsf
         NgzGai106R88mmVazssKKDhkYXPRijbcjfYAEZj+2ZUFFooUuN2tgSPGUKg3ccl3zAWa
         vXCrnY/T1vxXn0k2Bm20BwzwgKIgT3t7snhv3wwtUsePSE/CoQfOG28+tvYHXKKDd7xD
         Sulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760944082; x=1761548882;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HOxQeFzZprgS340iSyl+E8y8vVH7kK0gqo8lCK0SDQ=;
        b=gCPhaDuIpb2+Pko6QmU9CGUEkvhYAIEta8xiEN1z316v6JfVfPv0yQytKffIlGrOTL
         i/dYlml/7jQwFAGqE9UTRRAVgUR6xsvj+muVHmbsLz6R2UP2ieHvhZ06EyuN/uxc8wmE
         aZQveolzZ95gUmLAQIGHDzWfNH/SS0V1weee+/GhAK+G1Z082+XevzDSzrnCwUdtZ/Kw
         bxEEAQrHKKPCcnWJXW9kqFHOJe4MjHPlbZG3DnVT/Zw1XaWusVUz8KhRyHeig550SOdx
         7K7KwHIvh43vAyOFB6YXDqqqGLMBMlbmZM1syukBq7pUiyppC6MjU3Y2VIGujvrEBN8e
         WbWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVa8+IyNM4k1LGK0ANzbNSeuhZviKRfedu24/gtBkLcTTiT3yW6OCT8ZvTENw2itPbCrifhMjgSo31JMxg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQJsFUXVgKUuMfjLT0e/yAwSNTQy6NrrEUBnRoXIjLbzEzDVVI
	WFiMyw8FIBHsuE1VifGYutKuuAWOkqPXKBebm3o+E1qnwYXrp6aEkOml
X-Gm-Gg: ASbGncvGxcbXbChmTD8qnm0cSO2AwYzp3uzQDwn7mb+nWa9gl7h8Hml4mtCkgcVrgmx
	Gv8IVo1nh4xVGvzCNJSlt2slVisaxTed6PgsTNz3nh2cdI4iGBgzwgHZ8BqByKxLEkddMcDeyDD
	odS36PFMSNPFie2DcnMXpRUKN5woAPcrROhjDh1Air4a13qDcJvQbGOWsE1QZpLqwWc3lPk1teG
	p5941oIxoFYVXH8ADc0yc7IZzoWUKGlX/A9tFc0x/NJRlMtsTqhXGm/zlPsxSSbx49noFs8+O89
	o5YSM0d3xlSJ1uEl8W/1TuCGX4AfGWbWHqMy2sXY7Vsit/gn//sc5/mHSm29RY61eq0a5suY8E8
	6Km0qJ9Nw8cKX83OdRLNmz2MikcsGuq5qVkwudHwntpjCV2BqrjSVKHMlS9Zwvr9vRfCEdJEGX5
	o12xo=
X-Google-Smtp-Source: AGHT+IEQ5375x2wAPSKC6RY36q65Xq6o1ABPfooltKbLM5TnVL2vpALRNQnKbvej+kaD3bTB+gwZ+Q==
X-Received: by 2002:a17:90b:4b0f:b0:32e:8c14:5cd2 with SMTP id 98e67ed59e1d1-33bcf8faac8mr15518129a91.28.1760944081925;
        Mon, 20 Oct 2025 00:08:01 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5deae553sm7219872a91.21.2025.10.20.00.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 00:08:00 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 123104241816; Mon, 20 Oct 2025 14:07:57 +0700 (WIB)
Date: Mon, 20 Oct 2025 14:07:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 03/17] lib/crypto: Add SHA3-224, SHA3-256, SHA3-384,
 SHA3-512, SHAKE128, SHAKE256
Message-ID: <aPXfzd0KBNg-MjXi@archie.me>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bwyeZRG0SF5QekIi"
Content-Disposition: inline
In-Reply-To: <20251020005038.661542-4-ebiggers@kernel.org>


--bwyeZRG0SF5QekIi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 19, 2025 at 05:50:24PM -0700, Eric Biggers wrote:
> +The SHA-3 algorithm base, as specified in NIST FIPS-202[1], provides a n=
umber
> +of specific variants all based on the same basic algorithm (the Keccak s=
ponge
> +function and permutation).  The differences between them are: the "rate"=
 (how
> +much of the common state buffer gets updated with new data between invoc=
ations

Use reST footnotes, like:

---- >8 ----
diff --git a/Documentation/crypto/sha3.rst b/Documentation/crypto/sha3.rst
index c27da98c89b7f8..ae1fd3e01e34c2 100644
--- a/Documentation/crypto/sha3.rst
+++ b/Documentation/crypto/sha3.rst
@@ -18,7 +18,7 @@ SHA-3 Algorithm collection
 Overview
 =3D=3D=3D=3D=3D=3D=3D=3D
=20
-The SHA-3 algorithm base, as specified in NIST FIPS-202[1], provides a num=
ber
+The SHA-3 algorithm base, as specified in NIST FIPS-202 [1]_, provides a n=
umber
 of specific variants all based on the same basic algorithm (the Keccak spo=
nge
 function and permutation).  The differences between them are: the "rate" (=
how
 much of the common state buffer gets updated with new data between invocat=
ions
@@ -136,7 +136,7 @@ should use the much more comprehensive KUnit test suite=
 instead.
 References
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-[1] https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
+.. [1] https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
=20
=20
=20
> +If selectable algorithms are required then the crypto_hash API may be us=
ed
> +instead as this binds each algorithm to a specific C type.

What is crypto_hash API then? I can't find any of its documentation beside
being mentioned here.

--=20
An old man doll... just what I always wanted! - Clara

--bwyeZRG0SF5QekIi
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaPXfxAAKCRD2uYlJVVFO
o3A4AP9bdkVnmtIfCagfxHcW5eGHSyGy7zxDqFUTIe8b2dhvVAD+KVzQDxqnujqm
eYhwNKRJG53xvL9m37FLDKGqqZLtLw0=
=VJti
-----END PGP SIGNATURE-----

--bwyeZRG0SF5QekIi--
