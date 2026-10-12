Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5038038C423
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.202.192.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791797413; cv=none; b=ITV74XLFsh6aqt2yKXmPhUWhJ3SZyzgvILocvWhwpXZ0YeAk35B7UDCQquM9FDV379syFm5sAm35OQxnKUz2lLEyJjonH6lWKeTsxQ6r5nSRV2IUQ/Hce2vaYbhphe601GRkamDQIcHTvaa+1R8gph+GVq9YFGgr28RSgARH9n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791797413; c=relaxed/simple;
	bh=rL0fvVP9fDZc1blGZLqu9RtCF1FfXYpJwfhKydWrzCU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k0MfW2jl28MxguRlZ/Aqp4VNyQ9pICykLn4ZLsCEVPVflAevyxUWASVDkVv0bTG62DCd0A49EXMh/evJtM0Pd0hJSK4Sl1PdM68ODXC6vx2v+EKJpArfqN+LKh7sQm/Eg7HzfVthg2nXqy/DB8t96B6gsbhLIxb6cZkATCPQLG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org; spf=pass smtp.mailfrom=strongswan.org; dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b=boGYg4yP; arc=none smtp.client-ip=109.202.192.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=strongswan.org header.i=@strongswan.org header.b="boGYg4yP"
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 262115A0005;
	Mon, 12 Oct 2026 11:20:52 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id 8vKntI9c464r; Mon, 12 Oct 2026 11:20:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1791796851;
	bh=rL0fvVP9fDZc1blGZLqu9RtCF1FfXYpJwfhKydWrzCU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=boGYg4yPKd0PZ/GfbIeUa+IfLuFYo7Zka+wEeq4S+VyDJbQERZbYsnspGbstacovm
	 ZD4+4v3NyRlYb/L1BIFUuAgW8vicrHdpbHNanVqFrvwhTOtytOXhWsgj2vssZ+Ot2J
	 MAmT1EPAo0QqE6AiB8u76pj8WFiHuUS3GLgfQabataqfr6IYVbC/q2QcTINMU7SXM7
	 ZSGvaNlb0Zxg4U7p7m/G7OzKn1TocoKUgaWlCVsqYHgXdrsNMtB9VmlOxH0VLPzdDA
	 hfcsnblS3GlY5gyAqqDnpqLhxdtNCsPpGDFzxaadmefHZhjNmtuv2XHGwCgucf7Gyl
	 9emFde/x9ZuTA==
Received: from [10.6.32.205] (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 0FE845A0004;
	Mon, 12 Oct 2026 11:20:51 +0200 (CEST)
Message-ID: <3a56d9305a01872b127269e7afa4b105adcf0f85.camel@strongswan.org>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel
 <ardb@kernel.org>, 	linux-crypto@vger.kernel.org
Date: Mon, 12 Oct 2026 11:20:50 +0200
In-Reply-To: <20261004180316.GE1906@quark>
References: <20260722153247.630519-1-martin@strongswan.org>
	 <20260722232424.GA50619@quark>
	 <aaca79db6bd81c539b1f1698603c7249be48a7b7.camel@strongswan.org>
	 <20261004180316.GE1906@quark>
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

> > > This is very similar to the existing
> > > chacha_8block_xor_avx512vl(), just
> > > with 512-bit vectors instead of 256-bit.=C2=A0[..]
> > >=20
> > > Given that, could we consolidate these implementations?
> >=20
> > Yes, it is doable [...]
>=20
> Hi Martin, is there any update on this?

I prepared a patchset that wraps the AVX-512 and AVX-2 block functions
in macros. On top it adds this 16-block and a 4-block ZMM that is then
almost free and probably worth it.

It is a series with 9 patches now, and unfortunately I haven't found
the time to bring it in shape for a submission. I hope that I can do
this soon...

Thanks,
Martin
