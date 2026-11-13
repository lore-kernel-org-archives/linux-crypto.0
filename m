Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794558099;
	b=17IFY42J/sexdYbJxYLUxjoC1jv+K76ZDxQS71aMcnr1/hZc3s8XrFIXsLC33vDMVpDX
	 jCRhloK/4XmXhb3Kxx3y5F7MRnAtv/q8xGFsigoxl4dB9VmA99ShjahCJy0fyupuSSB3F
	 yfG3WHTSCMt774nRu0yke9L3KF42I4H3IvnCZvoBrQmON+wbwAGWsYz3w1R8Re4qssnz9
	 gW4w0el6GH88hJiydB52/1bdqab/NR2i3prnxragI1SejZOURZ9+8c+EiHsmSh0VrDeEX
	 keSX9vOnadgkgETcnMZQ3V4J9pRRu5Dras6kIZgoaIVoClepxb6cmdKmiTUYCCyj3TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794558099;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=1Tcvpi3LpKzePvlc0jvv759IgtyBU7ME80xAVQKcXpA=;
	b=jkFz9o/Dl39xzT/aesA4bJJixJ+bkv9q7+neE8DYQXRtgHRo8mXR4h2GQLG4G9cRelpV
	 o9DjJ3V91b8VKA8GD4kDFK0g5bgAK/uXqG3TYgdwr1O7V1yF6xHCxmZgvwmEh6iFqu2+a
	 /WjuAlrLo/pLB31q0XphWtblKc5m7KNAc89Kka5/yjI7rEgukVugLqQFfdNk41IJTXI4H
	 VX/pQ5YaRXsJlB++m6GSHlSYjWeIXGo0af5A+NEhabBUzpDT1xuv6nIu8qXtWnbIO6N1J
	 kc/dxF7YmZIzzhQ8myg2WKKVd+dYs1xUs8sWGuw9K+96evm6UaX6VKwQGHpqcDGNrqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBZIhk3c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1A7606A891
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 08:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CBZIhk3c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41FC1F000C8;
	Fri, 13 Nov 2026 08:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794558098;
	bh=1Tcvpi3LpKzePvlc0jvv759IgtyBU7ME80xAVQKcXpA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CBZIhk3c+GsfIZPJ5DGBm9aeZqfaA/dYF/DllxWo7o3osW/teH3S3+CdWeG3fX/mI
	 Eoqq23cc73NbteQhh+iGfXTwFc3WI1ULYmzxCiOWVQQBNXembNw6kQvSs7+hwKqhSF
	 vtepEO8QbyhFnl1Rv0MxhvDcdCN8BSBzoHAdWWeHTXQEUohlVnWU9RmcDvVBd5oGey
	 FhKKaXHQjw+T3Cbg0Jz5WPCJ4MVGoEhxUKDgzc8TTXKLbN2U/DTwCzRptOrOgh4A8A
	 Moq39NCY2oyyPMPo0B+ZBtxmkt7ExlZkZRU8mnT1Ad99OF6HN7eTA9mjBAtYob5HSF
	 v+BQknc9qVFDg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1AD50198003A;
	Fri, 13 Nov 2026 03:21:36 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 13 Nov 2026 03:21:36 -0500
X-ME-Sender: <xms:jsj2ako0GMoOR_MUFB39ms0_r0h2vE9Jz5MD7OYLoErOvB2ilTmmZQ>
    <xme:jsj2aleTDwddePZnWOBiAD066V1E3JiLN5jIbv71RCoojgeinVNbbnz-Y52B1Wg1K
    wvBYEfd2rKXy4wq-r1sc1r_OhjY0Wp18gwLIfzklGN5xaILXLUYamY>
X-ME-Proxy-Cause: dmFkZTGHEOpvFjmBlJKeiFz+CGPGN6rTqAg2GvLAJvFMQZkl3OzFSTaIh7BGtI6o8R5iPl
    QeT7duB20g2AM67/Mwfi5bm9GeCRw3JqV/QDDVmgeuYCrklaV2MRQTUPC69HnUJ+2B++h9
    wMrnQxznPl1ArJBZH7CFCvJS/pKPzFIrsBJIZNagfsbXSBgSB7cdEHo1vzj6d1RG/G2bID
    KxnzGabTHhwIG3b0efW3v0FaY6ujKlQbmRaOa3393CiORxUhS8XuVBFu0BweH2ZEFKKbTU
    CT4cnq31TtpFwEM5qehrUSQzDl6aOGzM+tLlA3zbEj0NxYgjwPm1c8vehjLg7cs5sEMUE2
    0wrmO1q1oAG3UKEeriQGe2to5sV+I61W3ZaVDG0mW26ja7C0Bb4/hdKcpo2Q5GCdxoPut+
    eWmYtJ6h+Bb1ekNzEf8MBxqPxW1seqIam+9rwJA7xPtd/s6vq2FulHvuui6anawiCkpznv
    UvSGu84MF86ucm5EQh1Zd3v/3nDT3m1uI646zcetIs6zu8vhMWraYGyC6LRQNpEpS2NdpP
    ZcrS1a/Nci0v55HGx0GxLnrHYTtWA09YT16ubgDtx004tgYZCn1zToE1lghVbeKRKyBEiJ
    WoQXUp4/EzWaypnMBablVTy2t4L9jDer3IsKK2nrEDTv+OKp6crDeGh/X94Q
X-ME-Proxy: <xmx:kMj2avsKfxXsDUqmLmQY1HPXTk_RSq-1CdMHcNCQU4WiY055Ih302g>
    <xmx:kMj2avgpwqIyYYPH7-9AG1wd4PNCNdPu5NZfSSSbzQiwAsm3Z3ByiQ>
    <xmx:kMj2ao9sjRIqq_3WwyPHSarZLzkTLmBSh1F5xrxMH8p3hwzO0k1x7w>
    <xmx:kMj2aqvQfID1E17SnaGVbvJVHgTcqJjHHexQUD6vaFkDTEdToglh3Q>
    <xmx:kMj2akoJgahwi4ikXmYBJNDahtXUymAw9ZMDiGZbLxYNfsof_PuZfcMr>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 19DB2F8008E; Fri, 13 Nov 2026 03:21:34 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AtU-W_z_8zgF
Date: Fri, 13 Nov 2026 09:21:13 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
 "Antonio Quartulli" <antonio@mandelbit.com>
Cc: "Jason A . Donenfeld" <jason@zx2c4.com>,
 "Antonio Quartulli" <antonio@openvpn.net>, linux-crypto@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, "Ralf Lici" <ralf@mandelbit.com>
Message-Id: <edce094e-2cbe-4b7f-8d5e-6e99f3aa5320@app.fastmail.com>
In-Reply-To: <20261113020601.GA1742@sol>
References: <20261112125432.3064939-1-antonio@openvpn.net>
 <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
 <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
 <c24fdd26-7e77-4dca-a0fc-94c998ebdff8@mandelbit.com>
 <20261113020601.GA1742@sol>
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 13 Nov 2026, at 03:06, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 11:54:05PM +0100, Antonio Quartulli wrote:
>> > > We used to have implementations of aegis128l and aegis256 in the kernel as
>> > > well (along with morus), but we removed them on the basis that it was
>> > > aegis128 that won the competition.
>> > > 
>> > > As far as I know, nobody actually uses any of that code, though, so I am
>> > > quite to surprised to see now that it was aegis128 that was dropped
>> > > from the portfolio, and aegis128l and aegis256 have made a miraculous
>> > > return, along with some other variants that appear to be tied to the
>> > > register width. What happens when 8-way vector registers become
>> > > commonplace? Create yet another aegis variant that case use them
>> > > efficiently?
>> > > 
>> > > So I'm struggling to see why we should take this RFC seriously, to be
>> > > honest ...
>> > 
>> > I'm also not really sure what's going on. CAESAR competition selected
>> > aegis128 and listed 128l and 256 as "additional finalists". And then
>> > RFC10032 has written up 128L, 256, 128X, 256X, but not the original
>> > 128 that was selected. And then none of this has been picked up by
>> > NIST. Meanwhile, NIST's light weight crypto competition selected
>> > ASCON, which as the "lightweight" as opposed to "high performance"
>> > pick in CAESAR. So I dunno! I've been waiting for the dust to settle
>> > for a little bit.
>> 
>> To be honest I did not try to figure out what was going on, but for sure
>> there was "some confusion".
>> 
>> By looking at RFC10032 and its references, it seems that various studies
>> were conducted on AEGIS128 after it won CAESAR and they highlighted some
>> deficiencies. I am assuming that this is why it was decided to skip it
>> during the standardization process and focus on its stronger siblings.
>> 
>> This said, our decision to work on AEGIS128X4 came from the fact that it was
>> expected to be faster than AES-GCM (current default for ovpn), especially
>> when working on chunks larger than a standard packet (i.e. TSO/GSO/GRO
>> case).
>> 
>> With RFC10032 standardizing it (and its siblings), we thought this would be
>> the beginning of the AEGIS era, with more use cases popping up.
>> 
>> RFC10032 was published last September - why wouldn't you take this seriously
>> at this point?
>
> The kernel previously carried 5 AEGIS and MORUS algorithms, and that was
> a mistake.  We ended up having to maintain all of them, with heavily
> duplicated code (and often buggy, generating syzbot reports).
> Eventually we were able to drop 4 -- after 2 were even cryptographically
> broken.  Now it seems even the last 1 was a mistake too.
>
> Now we have RFC 10032, which specifies an unbounded number of
> incompatible AEAD algorithms in four families.  It leaves the degree of
> parallelism "D" unspecified, with only a few examples given in the
> "Operational Considerations" section -- not the actual specification.
>

The RFC also mentions

"""
Protocols SHOULD opt for a parallel mode only when all the involved parties
agree on a specific variant. AEGIS-128L and AEGIS-256 SHOULD remain the
default choices.
"""

If the degree of parallelism is an unbounded design parameter of the cipher,
I don't see how this can ever be used optimally in an asymmetrical context
such as VPN concentrators serving numerous VPN clients: the optimal D value
for the server is highly unlikely to be optimal for all clients.

