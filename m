Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794535563;
	b=5Boe91CoKFJQm/d+/7QvpHxQlu5lM0/pG0QMd5QSyq10oOfloIeBl5xZnAJOtT4NBnZH
	 Vl4uNaFAV07z8X0RCPyAUD0YMVaJPNVD6PLM4/W0O/aRlQLEayxrv3bxNA2EP+FcVMVW8
	 Lsh9Tm5MXkEuAnqsuUc6t8s2Lv9+xB7iOBTUcUoz5vr8n0PSgbPhZTYTodwZCBkj+8wZb
	 MskhOHh5n1ZaRCBB/TeJeGVwAoTtTdaDzR9Qu9VKyr3wkowQX7weIDm95yoHfS7qGx9JC
	 JhBROL03Rnlnq6cgf9IBoUykoWsXRuXmWg2vNndsxQ6zEWQUQi0l0mF57EZZVed2Qag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794535563;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=l5tMon5YzJfGYUGzk9WgYwO2N+qtAdyA80U9bsn0Dxs=;
	b=D3jF0JtqhqU7gAZG+89jNBeSIdNZfSz8eWoCK0wklvHLPNpxagngBuhBnOWRI8sg5h2z
	 QCzJMzs/2GpnNlMCMqZ/lLB41WvPIu7QwXXl82YVYpteLrnFngMMlWh9R5mD7T2JPT7vk
	 M2o2C7UswzdfFrOf7M24IVy+ob45lOX6jU4cyxNqkyXKA2dW/p7CLy1aaZZuZN2t95IoP
	 rIckqDS7azQj14HSXx97lzKmzoGUhS72MUIrbqyfE0wVJ5g3aDuUzkP3x0J5q7wPNnfu9
	 PNsUB5uO/U8CAGDYieo/RNZoWKyVG1Sbldf5wTXCsgQYZSA5l+ZrgxTzTvoM0S2u11g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbH7aEOy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9A5606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 02:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbH7aEOy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0061F000C4;
	Fri, 13 Nov 2026 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794535563;
	bh=l5tMon5YzJfGYUGzk9WgYwO2N+qtAdyA80U9bsn0Dxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbH7aEOygWyXy/y12asxR1BlN2IHPSFTip75dcg0e7i3gtQCdpYljI+qgdRF1WHXf
	 Yz8zaeMVfvwy9jzEYanC6C5bN8EPEnMV526XPuViDxlf97z2aBwOSQwgqoHeP7QaQ9
	 HMoXMpJcKfQHdS2BVvTBfBTTGvvtk9DQHxw6ZhHRiRUtbIPmQT9f/zN7eiDUGommAF
	 TWJSnA+dflm4ITRf5EtAnO20NiuBOAzUOg9z9uMIHRWHriPgaku0rH+BFp6UB/itwV
	 SOW2RvSQETwYMgxf8Ama9mL7fGHVQq4WbzKvJkTJjADkc9mhYGOrQ7Y+aySGyPxB7H
	 uonV1m8pu36yA==
Date: Thu, 12 Nov 2026 18:06:01 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@openvpn.net>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ralf Lici <ralf@mandelbit.com>
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
Message-ID: <20261113020601.GA1742@sol>
References: <20261112125432.3064939-1-antonio@openvpn.net>
 <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
 <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
 <c24fdd26-7e77-4dca-a0fc-94c998ebdff8@mandelbit.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c24fdd26-7e77-4dca-a0fc-94c998ebdff8@mandelbit.com>

On Thu, Nov 12, 2026 at 11:54:05PM +0100, Antonio Quartulli wrote:
> > > We used to have implementations of aegis128l and aegis256 in the kernel as
> > > well (along with morus), but we removed them on the basis that it was
> > > aegis128 that won the competition.
> > > 
> > > As far as I know, nobody actually uses any of that code, though, so I am
> > > quite to surprised to see now that it was aegis128 that was dropped
> > > from the portfolio, and aegis128l and aegis256 have made a miraculous
> > > return, along with some other variants that appear to be tied to the
> > > register width. What happens when 8-way vector registers become
> > > commonplace? Create yet another aegis variant that case use them
> > > efficiently?
> > > 
> > > So I'm struggling to see why we should take this RFC seriously, to be
> > > honest ...
> > 
> > I'm also not really sure what's going on. CAESAR competition selected
> > aegis128 and listed 128l and 256 as "additional finalists". And then
> > RFC10032 has written up 128L, 256, 128X, 256X, but not the original
> > 128 that was selected. And then none of this has been picked up by
> > NIST. Meanwhile, NIST's light weight crypto competition selected
> > ASCON, which as the "lightweight" as opposed to "high performance"
> > pick in CAESAR. So I dunno! I've been waiting for the dust to settle
> > for a little bit.
> 
> To be honest I did not try to figure out what was going on, but for sure
> there was "some confusion".
> 
> By looking at RFC10032 and its references, it seems that various studies
> were conducted on AEGIS128 after it won CAESAR and they highlighted some
> deficiencies. I am assuming that this is why it was decided to skip it
> during the standardization process and focus on its stronger siblings.
> 
> This said, our decision to work on AEGIS128X4 came from the fact that it was
> expected to be faster than AES-GCM (current default for ovpn), especially
> when working on chunks larger than a standard packet (i.e. TSO/GSO/GRO
> case).
> 
> With RFC10032 standardizing it (and its siblings), we thought this would be
> the beginning of the AEGIS era, with more use cases popping up.
> 
> RFC10032 was published last September - why wouldn't you take this seriously
> at this point?

The kernel previously carried 5 AEGIS and MORUS algorithms, and that was
a mistake.  We ended up having to maintain all of them, with heavily
duplicated code (and often buggy, generating syzbot reports).
Eventually we were able to drop 4 -- after 2 were even cryptographically
broken.  Now it seems even the last 1 was a mistake too.

Now we have RFC 10032, which specifies an unbounded number of
incompatible AEAD algorithms in four families.  It leaves the degree of
parallelism "D" unspecified, with only a few examples given in the
"Operational Considerations" section -- not the actual specification.

> I am not the one writing ciphers and judging them during competitions,
> therefore I think the 8-way question should not be for me :-)

I'm afraid it is for you, as you're the one proposing that the kernel
carry this particular variant.  This proposal does not seem to consider
any of the other incompatible variants specified in RFC 10032, including
256-bit key variants which are generally preferred these days.  It also
still has the flaw of a fixed degree of parallelism.  Finally, it also
ignores the kernel's existing legacy AEGIS-128 code, which we still have
to support too, and doesn't attempt to share any code with it.

Fragmentation is a huge problem, especially when code cannot be shared
and each algorithm has to be optimized for each architecture.

> As a side note, our tests on a prototype ovpn using AEGIS128X4 confirmed
> higher throughput, therefore we were hoping to have a chance to see it
> merged.

Anyway, we do not support things just because they have an RFC.  There
has to be a technical reason.

Being faster than AES-GCM is indeed a technical reason, so there is
still a chance this could be worth doing.

It's just not very convincing when AES-GCM is already so fast.  It got
3-4x faster on x86_64 in the last few years, due to the VAES
instructions and the code I wrote to use them, and of course AES-GCM's
natural parallelism (there's no need for "AES-GCMX4").

Moreover, from the benchmark numbers you gave, it seems most of the
remaining overhead is not in the crypto algorithm itself anyway.

So perhaps it's best to focus optimizations elsewhere in the networking
stack for now, maybe work on switching from crypto_aead to lib/crypto/
to eliminate the known-problematic crypto_aead overhead too, and wait
for the dust to settle on AEGIS a bit?

If we are going to support this, we would at least need to know that it
is actually worthwhile and will be "the one", rather than the first of
many variants springing up with duplicated code.

- Eric
