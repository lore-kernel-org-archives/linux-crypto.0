Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903F72DA742
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 07:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749801476; cv=none; b=pawXOeUwDIpbz9vxDWSCxBzb0fMgEDOZZwkaP7BrFiKTmE1Fp6pgIzX+vPyodYagZ6MPJGLqeBdHWETglMBW6sTsVRpff14vW8/9vy6FsQg3hfoU0CQzBxkvhBCPKsQJjbGPPegT4x96aOByhn0jTyVYeQw5I6OCe8L8A5avbYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749801476; c=relaxed/simple;
	bh=QqKEj8d/6nhYZGpndkGRC6psU7P4KEDelUr5aNfYhQU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=E7XdHsabqPfgXhb8ZH4VuoKDkWRtRJKwwmkOxjrtqqT3E+0ZMXttvp1pchJTRX3T2Tas0pr2dAWnHPgKBlXCrFOS46L76ljeRL1OAVwisIXI+VuWzk6VdnwDXG4ioT82XrFLcO/85btzrfznUQVhjCcCkIUJeEUKORxdIjGolWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=sG6q1yao; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="sG6q1yao"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1749801470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L+YN4MTZBkTzMLCaO2wC4gmmUGZnS4C1FG9BefD5M2o=;
	b=sG6q1yaomuV3OMNUoQqhkbuH1Xcj2p7del+A7bay2fusZru9OEE8vWFR9UthMbY3VpLLfI
	FUolafPTe92AVJjXi4pi5inFQskTUn+5VcHL1uolO93tIKvk8tlCvfrwE0e3akdsHhcC8V
	xULhpn0qpRQt3dVp2ppv0jcfC8bE3yRFWAhE3OIwjSlJd+fb0tB+Svm/dPDtaN8FVUic8Q
	AlUuSwdrSq1M+QGe+Yic0cPdymG4mu6zz0PJ+rqKgAXWDJlPscQ3e8bvOMPMPVcUGhiwnQ
	jVaBmQpd3KW1TkF59UGitXhqsK7wY8V8Q1vheo3YthkTxgD8q+/QVo+u1ZZMvg==
Content-Type: multipart/signed;
 boundary=8d0444eb434897e482c102aa76e1f2eca706077e00be5351cd2962a65c42;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 13 Jun 2025 09:57:32 +0200
Message-Id: <DAL8UI7TH6IJ.2EVGYOYRQSS89@cknow.org>
Cc: <linux-crypto@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>, "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/7] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
To: "Eric Biggers" <ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
 <20250505203345.802740-4-ebiggers@kernel.org>
 <DAJOCL4UQWZ1.2CB0NH55US5EI@cknow.org> <20250611163430.GA1254@sol>
In-Reply-To: <20250611163430.GA1254@sol>
X-Migadu-Flow: FLOW_OUT

--8d0444eb434897e482c102aa76e1f2eca706077e00be5351cd2962a65c42
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Jun 11, 2025 at 6:34 PM CEST, Eric Biggers wrote:
> On Wed, Jun 11, 2025 at 01:41:06PM +0200, Diederik de Haas wrote:
>> On Mon May 5, 2025 at 10:33 PM CEST, Eric Biggers wrote:
>> > The negative-sense of CRYPTO_MANAGER_DISABLE_TESTS is a longstanding
>> > mistake that regularly causes confusion.  Especially bad is that you c=
an
>> > have CRYPTO=3Dn && CRYPTO_MANAGER_DISABLE_TESTS=3Dn, which is ambiguou=
s.
>> >
>> > Replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS which has t=
he
>> > expected behavior.
>> >
>> > The tests continue to be disabled by default.
>> > ---
>> >  <snip>
>>=20
>> I built a 6.16-rc1 kernel [1] and its config is based upon Debian's and
>> that has enabled CRYPTO_SELFTESTS [2] (due to Debian bug 599441 [3]).
>>=20
>> I then installed it on 3 Rockchip based devices and booted into that.
>> 1. Radxa Rock 5B (rk3588)
>> 2. PINE64 Quartz64 Model B (rk3568)
>> 3. PINE64 RockPro64 (rk3399)
>>=20
>> The filtered dmesg output for Rock 5B:
>> ERROR:
>> [    0.709822] basic hdkf test(hmac(sha256)): failed to allocate transfo=
rm: -2
>> WARNING:
>
> https://lore.kernel.org/r/20250610191600.54994-1-ebiggers@kernel.org/ fix=
ed the
> HKDF failure.  It was caused by a patch that changed initcall levels.
>
>> [    8.877288] alg: skcipher: skipping comparison tests for xctr-aes-ce =
because xctr(aes-generic) is unavailable
>
> That's expected if you have CONFIG_CRYPTO_AES_ARM64_CE_BLK enabled but
> CONFIG_CRYPTO_XCTR disabled.  Some tests are skipped in that case.

Happy to report that with that patch and that config option, the error
and warning are now gone. Thanks :-)

PULL request for the patch is already sent to Linus:
https://lore.kernel.org/linux-crypto/aEupSzhTI4h8kz-5@gondor.apana.org.au/

>> [   14.172991] alg: ahash: rk-sha1 export() overran state buffer on test=
 vector 0, cfg=3D"import/export"
>> [   14.202291] alg: ahash: rk-sha256 export() overran state buffer on te=
st vector 0, cfg=3D"import/export"
>> [   14.230887] alg: ahash: rk-md5 export() overran state buffer on test =
vector 0, cfg=3D"import/export"
>
> That means the Rockchip crypto driver is broken.

The crypto driver for rk3399 is still broken.

> Anyway, the more interesting part of your email is that you pointed out t=
hat
> Debian has the crypto self-tests enabled, precisely in order to automatic=
ally
> disable buggy drivers like these.
>
> So I'll send a patch that adds back a kconfig knob to run the fast tests =
only,
> which I had removed in commit 698de822780f.

I responded about this to a new patch submission here:
https://lore.kernel.org/linux-crypto/DAJXJHLY2ITB.3IBN23DX0RO4Z@cknow.org/
and v2 of that patch can be found here:
https://lore.kernel.org/linux-crypto/20250612174709.26990-1-ebiggers@kernel=
.org/

Cheers,
  Diederik

--8d0444eb434897e482c102aa76e1f2eca706077e00be5351cd2962a65c42
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCaEvZ9AAKCRDXblvOeH7b
bgePAP4+kEWYKZ1eqayKsFe8tBfUVxnfdStRKU8Qr/95saO95wEApLF/txTDorHT
OXmTzRTcsInQy9LVjH2/+08cAly/KQs=
=NvpI
-----END PGP SIGNATURE-----

--8d0444eb434897e482c102aa76e1f2eca706077e00be5351cd2962a65c42--
