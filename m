Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D481F45D5DE
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.202.192.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784804642; cv=none; b=pAIa/ZQOlyG6f1U23HIXh80iIop30RtuwdQ5i20GLQ7WVREuadrWLKiYf4bIILz1GxhCOiZwGe9ZddNqbQIWoW1Iip6me5f4cB4c8YpPrGN9MF0kpg2qFOtNII7K+W8/3TKd++WPwkMnpvb9KM4t6tIXKdvI7iZ9Um6HTOKrS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784804642; c=relaxed/simple;
	bh=f9kM+Bn9LeaFNJZOYTL5tDZfdRTTKy3UJSaGESHo634=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s824wNTEq1nmQVycIj0/R8lI1eGoxu3fenvzNqM2ZjTS8g2wYXJJ9za6aJj+MOj6TNNaB7emTPbmGbX2z6a919PGesLZ05YKOsFoVBdYG/lfHz2UAmqIE09yOn+I5KEXQw4acx50rbWT4ujF65RpaCV43OPpymGkDhsRAHKsfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org; spf=pass smtp.mailfrom=strongswan.org; dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b=MA01Np5+; arc=none smtp.client-ip=109.202.192.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b="MA01Np5+"
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id A96445A0005;
	Thu, 23 Jul 2026 13:03:51 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id tW9nhlvWo4Cp; Thu, 23 Jul 2026 13:03:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1784804630;
	bh=f9kM+Bn9LeaFNJZOYTL5tDZfdRTTKy3UJSaGESHo634=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MA01Np5+X0mRkOs4W8NNoXfK7oYD/z/evkDOqoMoYvsqIyXrLRLj+BAFFgHFNuOf3
	 wd6v9t0KL7VunaayGhtTqtgpT9ZAqdjJVTrRhitVBmdTTGSlALyPzm84Sd29onGd6B
	 Sp3D0FWh8RAs3WSnrTFGz6v+m4qRvAqbFQ1mBqDBEPTlMetqGOjiW8EtPc5s1q9QeF
	 u13Br229BC770MV2fuENh/ptei5StsX05dMrJdTyeZfLFkXK11GnkZML9Cmtqahw0a
	 cZU0HuxyTEAyozjg/TBHZSj6jY1vVfLtbS92ABoMgccMdQSVMumQwVtfgmLP4Svy/n
	 ruPLAu0yTES4A==
Received: from [10.6.0.128] (unknown [185.12.128.225])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 4B92A5A0004;
	Thu, 23 Jul 2026 13:03:50 +0200 (CEST)
Message-ID: <aaca79db6bd81c539b1f1698603c7249be48a7b7.camel@strongswan.org>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, 	linux-crypto@vger.kernel.org
Date: Thu, 23 Jul 2026 13:03:50 +0200
In-Reply-To: <20260722232424.GA50619@quark>
References: <20260722153247.630519-1-martin@strongswan.org>
	 <20260722232424.GA50619@quark>
Autocrypt: addr=martin@strongswan.org; prefer-encrypt=mutual;
 keydata=mQENBEhbeIwBCADbKW4rqhkBsvQumeWTAfy+Q+YciIbbqLvxwRZPKpxz19nxJQPbWF7pG
 oiPb3TWLK3TitWVKKZuNILStsKTGiR4RqLUs8n3sESPoz5HmRqsijm6yJDzzPAE3/B7IWHBeAOssV
 TWS7b9ROz4iFI+fNLnqMqE22zMEItC2r9zi6GpDmi/QP3CcxHFzPMF5iQkMPp6QJMwOdPvYR9kBb1
 x1ubDOjsfWqI41neJTGlv3EVFc5nkv0s7PfoYxMkf8/VStd29pMe4csKJUaPDkLqenLl8Omq8Z3F+
 sbjdo+hcim4i3EsROYh59kA4/UuMFfI0hxaIaoW6UAb6gyqOHkS6vC+VABEBAAG0Jk1hcnRpbiBXa
 WxsaSA8bWFydGluLndpbGxpQHJldm9zZWMuY2g+iQE4BBMBAgAiBQJRsHoSAhsvBgsJCAcDAgYVCA
 IJCgsEFgIDAQIeAQIXgAAKCRAQGu6ewTL0wxf8B/9EThZXuVqNTK2nH2QuRi2zQntFXkK2QbU11sv
 zkfZV8xDfWKHdq67LLako/FOE1dXN6iurWFChgMexs0bSMzaftCmHGSSgGaQhBhANSObKu8M+UyHd
 bes88zNpQKdwVd9guIo6oRrX33IYkb63ifZReChcBffu6cjXQky7/79kpnl6f3qlP5ZluyNGX9Iwe
 z1EpmG2zHkJlc+3oPQbsQbFKjUOdR1hfyKbcVVQHs1ddv830Z0cpM6QbcknR81VsCQ7FYBrH5Hw3N
 AKhrfbIaZMvwBgQfXIgc7mwPZFg2oONZMzauzX6EpZ29Z+kCsy3AArnZssVAwxk+ydRJhUWlZmtCR
 NYXJ0aW4gV2lsbGkgPG1hcnRpbkBzdHJvbmdzd2FuLm9yZz6JATYEEwECACAFAkhbeIwCGy8GCwkI
 BwMCBBUCCAMEFgIDAQIeAQIXgAAKCRAQGu6ewTL0w9ruCADDGN0JgrImHOPGgsJwdP2nKwBytO8mM
 Z/Z/folgH20zqiMqyNR4lOZW9L3DF4rz83fKXQFbP7nCf6GZ/tmjmrImiTZBkKwr37ZsaBRaCz3i9
 rYITY94njenYp7jy6roMcvlBMhNjSI04AvLjaA/hcPuSexqqso+qoNTa7+VplF7OpikB8vKPt+fMp
 XuGP8TF/q8v9TrY+gcVv0c8ZOrGDnI5vJt1Fp0PvoH/vXFx3Jy90g+hRUYFbLW2S76geiGVML9AeK
 IQKjEpp2bxsd+JYGo91MeKBqjlllonxZ17eKNtlA+X+iluwcDJZzdabB19EQG7ZEf0jAy6Sy09au6
 MYFtCBNYXJ0aW4gV2lsbGkgPG1hcnRpbkByZXZvc2VjLmNoPokBNgQTAQIAIAUCSzjspgIbLwYLCQ
 gHAwIEFQIIAwQWAgMBAh4BAheAAAoJEBAa7p7BMvTDaP4IALJRUmUEagBRrdAi1SrxxcsgPDr5vo8
 1UrPADXKnMdf6KXPqfPMN4hIeS4zbFyC/FA9cg0T9680pVk8hLmcD3iCRMMnL9d38hOQmMxw2TYnd
 7rth1LuoDRhIwI1bfADw3EJGEMsTy49zVtVl1KwmqBZDDk3PGHvukHYawleOrTRVitOEvavg0vfgg
 CgqvSeSBy3tkX2EIlagC/5eXpYLguj1iI84xG01M4bZ9PU+PuzZADaHL+a9iPelBvk0uNjwKvKjPx
 OPDfaxsmEgjNG7M9gZjBkjSjvclRUlLMpe+3qHhGEYf2yKsv72hCLYy8my5jRnu59eZq72lX9YWVs
 jlXU=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Eric,

> This is very similar to the existing chacha_8block_xor_avx512vl(), just
> with 512-bit vectors instead of 256-bit.=C2=A0 They even use the same CPU
> instruction set extensions: there are actually no cases where a CPU can
> run chacha_8block_xor_avx512vl() but not chacha_16block_xor_avx512()
> (the choice of vector length is just going to be made by policy).
>=20
> Given that, could we consolidate these implementations?

Yes, it is doable, but with some constraints:

 * In the 512-bit version, adding the initial state to the result uses
   a small optimization with re-broadcasting, so it differs from the
   256-bit variant. That optimization can be applied to the 256-bit
   version for a unification, but would mean a change to it.
 * The larger part of the interleaving tail is different and will
   require separate code paths.

So the net win is shared broadcasting/doubleround at the cost of some
macro complexity. I'll give it a try.

> Well, this is one of the cases where
> cpu_has_xfeatures(XFEATURE_MASK_AVX512) was already required by the
> existing code (since all AVX512 bits need to be enabled for any EVEX
> coded instructions to work, even on xmm/ymm).=C2=A0 But it was never chec=
ked,
> and no one ever noticed.=C2=A0 I would just continue to leave it out.
>=20
> You can also drop the check of X86_FEATURE_AVX512F, which is implied by
> X86_FEATURE_AVX512VL and X86_FEATURE_AVX512BW already.

Ok, will do so.

Thanks!
Martin
