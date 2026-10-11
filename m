Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333336F909;
	Sun, 11 Oct 2026 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791699420; cv=none; b=uW/SYuPp9kuGqmUWS5djVsvpGNXTfAYxebI1o+ARN33qT3g2mqw5SpbvBN8aYQvG5/xzG+HlmPS43mLiDuvq46dg1EBWHpvLegfhab6HkAWcmhDdURSihvFDGOl/+JRRCihySI1gF2T8O0rcdKd0FFTkYI6VXM6+mJYvibu4DR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791699420; c=relaxed/simple;
	bh=U0vXqNaJGbWtkPseFYxze2E02Sy984Mv70EgmrfiFmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8cSpUS0e4gpS7u1kiBdVGzlg0Vv1cn9UFkj++baIoC67Gpt2S+gZnWbuOCjQ23tsAYTQFj+NLQfTSnPsVUFSWtgFoB8sitY17WlzGCnFO9kyOAheIiGnnq1F8HaKCYpx75Nly69NCsHJLQnnEBy3feFU0y5r5jSjlD/KubZCII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40] (unknown [IPv6:2400:2410:b120:f200:9e5c:8eff:fec0:ee40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 127903F1E7;
	Sun, 11 Oct 2026 08:10:47 +0200 (CEST)
Message-ID: <454f2204-2c4b-43c0-8fd0-1eaa83186e69@hogyros.de>
Date: Sun, 11 Oct 2026 15:10:44 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: sha1: use put_unaligned_be64() for length
 encoding
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, ebiggers@kernel.org,
 ardb@kernel.org, Jason@zx2c4.com
Cc: skhan@linuxfoundation.org, me@brighamcampbell.com, jkoolstra@xs4all.nl,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------s2Jzyx84e5ayH7wHpFzOBj4y"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------s2Jzyx84e5ayH7wHpFzOBj4y
Content-Type: multipart/mixed; boundary="------------ShjZzvSBtwf2mb8pFg1sC0ba";
 protected-headers="v1"
From: Simon Richter <Simon.Richter@hogyros.de>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>, ebiggers@kernel.org,
 ardb@kernel.org, Jason@zx2c4.com
Cc: skhan@linuxfoundation.org, me@brighamcampbell.com, jkoolstra@xs4all.nl,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <454f2204-2c4b-43c0-8fd0-1eaa83186e69@hogyros.de>
Subject: Re: [PATCH] lib/crypto: sha1: use put_unaligned_be64() for length
 encoding
References: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>
In-Reply-To: <20261011051524.6703-1-raizudeen.kerneldev@gmail.com>

--------------ShjZzvSBtwf2mb8pFg1sC0ba
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGksDQoNCk9uIDEwLzExLzI2IDE0OjE1LCBNb2hhbWFkIFJhaXp1ZGVlbiB3cm90ZToNCg0K
PiBUaGUgcmVzdCBvZiB0aGlzIGZpbGUgYWxyZWFkeSB1c2VzIHRoZSB1bmFsaWduZWQgYWNj
ZXNzIGhlbHBlcnMgbGlrZQ0KPiBnZXRfdW5hbGlnbmVkX2JlMzIoKSBmb3IgcmVhZGluZyBp
bnB1dCBhbmQgcHV0X3VuYWxpZ25lZF9iZTMyKCkgZm9yIHdyaXRpbmcNCj4gdGhlIGRpZ2Vz
dCwgZm9yIGFsbCBzdHJ1Y3R1cmVkIGJ1ZmZlciBhY2Nlc3Nlcy4gUmVwbGFjZSBib3RoIGNh
c3RzIHdpdGgNCj4gcHV0X3VuYWxpZ25lZF9iZTY0KCkgZm9yIGNvbnNpc3RlbmN5Lg0KDQpU
aGVzZSBhcmVuJ3QgdW5hbGlnbmVkIGFjY2Vzc2VzLCB0aG91Z2guDQoNCj4gSW4gaG1hY19z
aGExX2ZpbmFsKCksIHRoaXMgYWxzbyB3cml0ZXMgdGhlIGZ1bGwgNjQtYml0IGxlbmd0aCBm
aWVsZA0KPiBleHBsaWNpdGx5IHJhdGhlciB0aGFuIHdyaXRpbmcgb25seSAzMiBiaXRzIGFu
ZCByZWx5aW5nIG9uIGEgcHJlY2VkaW5nDQo+IG1lbXNldCgpIHRvIHplcm8gdGhlIHVwcGVy
IDMyIGJpdHMuIFRoZSByZXN1bHRpbmcgYnl0ZXMgYXJlIGlkZW50aWNhbCwNCj4gbm90aGlu
ZyBjaGFuZ2VzIGZ1bmN0aW9uYWxseS4NCg0KVGhlc2UgYXJlbid0IHVuYWxpZ25lZCBlaXRo
ZXIsIGFuZCB0aGUgc2l6ZSBoZXJlIGlzIGZpeGVkICh3aGljaCBpcyBhbHNvIA0Kd2h5IHdl
IGRvbid0IG5lZWQgdG8gaGFuZGxlIHRoZSBjYXNlIHdoZXJlIHRoZSBzaXplIGRvZXMgbm90
IGZpdCBpbnRvIA0KdGhlIGN1cnJlbnQgYmxvY2spLg0KDQpUaGUgZ2V0X3VuYWxpZ25lZCBh
bmQgcHV0X3VuYWxpZ25lZCBmdW5jdGlvbnMgYXJlbid0IHVzZWQgYXMgY29udmVuaWVuY2Ug
DQpmdW5jdGlvbnMsIGJ1dCBiZWNhdXNlIHRoZSBkYXRhIG1pZ2h0IGFjdHVhbGx5IGJlIHVu
YWxpZ25lZCwgc28gd2UgbmVlZCANCnRvIGVhdCB0aGUgY29zdCBvZiBkb2luZyBhbiB1bmFs
aWduZWQgYWNjZXNzLg0KDQogICAgU2ltb24NCg==

--------------ShjZzvSBtwf2mb8pFg1sC0ba--

--------------s2Jzyx84e5ayH7wHpFzOBj4y
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEtjuqOJSXmNjSiX3Tfr04e7CZCBEFAmrLKGQACgkQfr04e7CZ
CBHmFQgAlalLU1zTiRYoLuRNzX0hvxVnqMGkx/mLsAxyyLNWunKNvjjWZV69S7lR
GW+Dq9GihnHGyTt+GD2JIa6pLW5ZxarwLzoS08PMMQJtJ7nC4vaVm5Bs/xTPN2wC
hOPWfny0PDdhV2kGR06/JmmG0Jvd62U+Df2G6mnNjuMQxK4iPp3JBCdF9vd6kow8
PYvWwUqi/mzW7eX2+6f0fhgq4Dp6x5vXOxm9zXxiAJYwiFfm5tsI68gB3U0xM8GF
Ge3PjrCTrtB6bxO2LRxtl5k1bKUjPzcMaYtODLfvVrtS68wroWUEL5uxN904fJI+
NoAKytazH6v2ZIPMV57dSNIqt09jEw==
=n1JR
-----END PGP SIGNATURE-----

--------------s2Jzyx84e5ayH7wHpFzOBj4y--
