Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF619DF9C
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730204; cv=none; b=foiwe5Z+mM7ZDa/uMwvt6fW9wnp8a07INFpGK62tKvKfm1q5i8a8aIFUFihVDm2ZxzTRuQGqG8hI4F0nsr6CUhTtZH8FMUFXQ+euQI2c2ndgt0I28ZAWb/YZkNejcS9PnwiaTwNUIt+utiksSPvn3LzIlGJW4A2dMXgvwT8PYc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730204; c=relaxed/simple;
	bh=vqxWsJzciRMbILiYK+Kat3pn1oc69qfxQfFSLs7kul0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To; b=hUUXTXKuEeH5rpJ5cftShXJ1pp7X1vjPSmQqgoZf77689dKLFLqrwBAWo5LO/7tQZpLnjT29PEqmhpLg7i7BsPvI9J4strNuvMSex1hI7rvjgvWlLl1eGn4vujFyrYd/xYTdfjqraUG8nMnyABJkqcDuNwMDMWeGGMt7di2IM1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=zK9QEZX9; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="zK9QEZX9"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1723730199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=jRUdXH2Gl6rw+xJJhhgxHtdMQ1UkSxCrnpLh3C7+fX8=;
	b=zK9QEZX90pzd4bqhseXo1FpO5UsNhnweJu6H4bUBMb3SvWcgZJgc7B7WTF6JeKqmjdsP6Q
	xnGx0iZJ7QMZ38iRpdc/mBBLPj90ZUkC4hjXIiJq9kgZkzMSbqyhdu5WZIRpseLNsdOK66
	7W5/vQK+TaNVjrYMmzjYWX5MXAurfMHqTBavN7aix+J3v36N7wkYnXIPJY6f+oVsNqOoCY
	en5TUjlYYjohLiSZ9XFJWan8SxCDzmhfY7y6cu+h0aYNHbq9gSdtEfvwQLFCdNg7q/53Hf
	jaOhsd2iJfLhEaChZISjXP4+g8KdMz8Uya0cG+1qBY+06u8P75xM8j4o3Hwyrw==
Content-Type: multipart/signed;
 boundary=62032c8257d9ec58f3454a49951ee88f6705259ff7df0bbe783d64edb2fc;
 micalg=pgp-sha256; protocol="application/pgp-signature"
Date: Thu, 15 Aug 2024 15:56:26 +0200
Message-Id: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
Subject: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Diederik de Haas" <didi.debian@cknow.org>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, "John Allen"
 <john.allen@amd.com>
X-Migadu-Flow: FLOW_OUT

--62032c8257d9ec58f3454a49951ee88f6705259ff7df0bbe783d64edb2fc
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi,

I recently bought an Asus ROG STRIX B550-F GAMING MB with an
AMD Ryzen 5 5500GT CPU (and installed the latest BIOS: 3607).
I'm running Debian Testing/Sid on it with kernel 6.9 and now 6.10
and it seems to work great.
I've been doing some (unrelated) tests with `rngtest` from the
`rng-tools5` package and wondered how it would fare on my AMD CPU.

And I found out it doesn't work at all!
But on another system I have (Asus ROG CROSSHAIR VII HERO MB +
AMD Ryzen 1800X CPU) it works absolutely fine.

# dmesg | grep ccp
[    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
be running a broken BIOS.
[    5.401031] ccp 0000:07:00.2: tee enabled
[    5.401113] ccp 0000:07:00.2: psp enabled

Found an article [1] which could be relevant and downloaded and ran the
accompanying test program (written by Jason Donenfeld):
# ./amd-rdrand-bug
Your RDRAND() does not have the AMD bug.
# ./test-rdrand
RDRAND() = 0x47c993c0
RDRAND() = 0xec7c697d
... (more seemingly random numbers)
RDRAND() = 0xba858101

I tried it with the latest microcode dd 2024-07-10, but that didn't make
a difference.

So I'd like to know if this may actually be a bug on the kernel side.

Happy to provide additional information or run tests or try patches.

Cheers,
  Diederik

[1] https://arstechnica.com/gadgets/2019/10/how-a-months-old-amd-microcode-bug-destroyed-my-weekend/

--62032c8257d9ec58f3454a49951ee88f6705259ff7df0bbe783d64edb2fc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCZr4JDgAKCRDXblvOeH7b
blWgAP0dg1azuw0JBqEIdwQkI/hE8oZw3WkNKYwBckEcCQEY0gEAkr8b4LpvK/jw
J3Rp0WKaYWWd7IXn8Y+R86U+1kkYYgU=
=1wh9
-----END PGP SIGNATURE-----

--62032c8257d9ec58f3454a49951ee88f6705259ff7df0bbe783d64edb2fc--
