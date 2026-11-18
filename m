Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.189.121.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002588;
	b=fv8N0ldjqrXprFjeI5iAOHwhEyEumIkm/ZRUeRZLKB+oyU0vN7AjeSd9cA/+vQrbiqPh
	 HwhuyWc6pmgIJsRkJ6As1blBihOY5xsB/yRtgOST7uR2fJ2+vNkGxudwkj0edEWXgyL9+
	 r7w6qKvDo6h1eCA4G+Ced20xDDIEl9Z7g/fgL92SvnCK/CtZiltl4CziQsxD278iHuZ0R
	 74ilJBbknvqVSKmid2RAoZRY3agln/eT3Vsn+QHAoYroKdTYPlAz6cMmQe7AsW+C8LfI4
	 pU82R2eSYhTm7cXI/5oJg0lbeploes44bX5FWdMkna9IW9T2MSGTm7ZsvYw5eNo8UfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002588;
	h=DMARC-Filter:Message-ID:DKIM-Signature:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:MIME-Version;
	bh=KkcD2wgRhDzHWNTmtyhw/sR/Zau+ag/Z3ParFWO/T78=;
	b=XtRc8saiWWKjwrEXyRaGVKZIKBhaeic3IX0dqKflRfWj4iefS91vSKB8wXI6c/gBK2Xi
	 4bO6vD64kgvOP/yKjss+WDTx7bD4LXi0U2mDcmghhD0AO7xNtADgGaM4EI/gGzmfodleb
	 WUeJwskCzryDMeIgTH2RI+lh2sTML9Mv89kPQv5cFwuQZ3Lihy/ZS3ZXzWkZvc4YVZKOi
	 Yff0RjU9GxrgIlZurvgerkQB7iSytmVMuxIqQaPAvoioT5VtY8kf5wfUTFPVM/sT56hy+
	 pu/0U4lK6yGILBEK2g/Wd7NNvdLG2IoRxHSpTLYXWu5FnOtNbDoLFNXcIZ7cXPnWTCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=itx.no;
	spf=pass smtp.mailfrom=itx.no;
	dkim=pass header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=m9Fc6fIN;
	arc=none smtp.remote-ip=91.189.121.228
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000D9606A31C;
	Wed, 18 Nov 2026 11:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 000D9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.a=rsa-sha256 header.s=mx.itx.no header.b=m9Fc6fIN
Message-ID: <14a61f2afeb1ea212976a16db2f85fa952dc2b26.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1795002579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KkcD2wgRhDzHWNTmtyhw/sR/Zau+ag/Z3ParFWO/T78=;
	b=m9Fc6fIN08iGkul/bPrkKxfIUxOW7SKaM7QnYp1kwNZXys8BT7jzAljRhg1IaDaWzxnOQ0
	fiOsNApu4WiW+XUwTdJfKDUg2sBYMRHh+BLKiOw/AQ3SMWOZyN9N1uz0wprsac1M7XKb6V
	ohNadjFcABKib8svgLz/cL2diZY7Ffg=
Subject: Re: [PATCH 0/4] Migrate SPARC64 accelerated AES modes into library
From: Stian Halseth <stian@itx.no>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld"
 <Jason@zx2c4.com>,  Herbert Xu <herbert@gondor.apana.org.au>,
 sparclinux@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>, "David S
 . Miller" <davem@davemloft.net>, Magnus Lindholm <linmag7@gmail.com>, John
 Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Date: Wed, 18 Nov 2026 12:49:38 +0100
In-Reply-To: <20261118041033.50014-1-ebiggers@kernel.org>
References: <20261118041033.50014-1-ebiggers@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VVpLPpVx+UaJrhr+/7H6"
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


--=-VVpLPpVx+UaJrhr+/7H6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 2026-11-17 at 20:10 -0800, Eric Biggers wrote:
>=20
> This series migrates the SPARC64 crypto opcodes accelerated
> implementations of AES-ECB, AES-CBC, and AES-CTR into lib/crypto/.
>=20

The self-tests (CONFIG_CRYPTO_SELFTESTS_FULL=3Dy) and AES KUnit suites
pass on SPARC T4 and M7. I also compared ecb, cbc and ctr(aes)
through AF_ALG against openssl, with random keys, IVs and lengths.
They all match.

Through the crypto API, the speed is the same as before. On the T4,
tcrypt mode=3D200 gives the same throughput from 1024 bytes up, and is
within a few percent below that. The library ECB, CBC and CTR are now
~10 times faster on 4096 bytes.

Tested-by: Stian Halseth <stian@itx.no>

/Stian

--=-VVpLPpVx+UaJrhr+/7H6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCav2Q0gAKCRDoeAEuJe36
Vv/CAP9pXuHaKqEx+X3d8Eq32qSgxh2ueCeSL/fW5VO2SJG+gQEAs0cXyht3sQqL
bq7671SNe1oVpRj+qqw6YDOzPibhtg0=
=BR+6
-----END PGP SIGNATURE-----

--=-VVpLPpVx+UaJrhr+/7H6--
