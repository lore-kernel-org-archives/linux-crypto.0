Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794566226;
	b=wj1/j1TbyicW1VqKkDG8B7KlujE6lFfOAEx9w7FdN+0lSkuR8F0ctQCUDZh7Q6dC5wJ/
	 WAYC6je5Cldwc+78GmW7FUytSa05bzG1UWpuwWmIv02DMZUHMfzXplftdQuEYN4X+fHpu
	 S1UYZ8ijdf3o5KtvaFyxclRBIwJPij8EHPpeYCMaJ8Az8IVcO7H1jQa9e+CUuEpvSVEuk
	 66/bimDzrZPLpzBdyyynjOOYhG2X44rPz73TmNIeIKAkvXsEY72ntUK47huyW+wr+w5PL
	 fSOoL55eX5leXjkAcO71QG4Da0eZXyAkP0JHIvKfc4c3HV9v1JsLZ2DdXCghfHDmXrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794566226;
	h=DMARC-Filter:Received:DKIM-Signature:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=mcEaM2ur2M0qtp8COwjOtk3VZ9VEp78bGrqfRJ8uL1c=;
	b=BeYlSEIPorOTx0y4R0ZoZazyZ0hyWB1RxB32fbPclQF7NbR+hbRET8zM3La/YwYYAInL
	 +v6F9BoMDNJaT3vViEdLvzJAHkyYDs8OQ+cdbqwOU83Z47A0Qoofz7u/VB/AdWLuw2/od
	 ZaE7iUnGJJYx45s4XPfvO41HeIJ/xF8pbQCmyczYPTzH2ep5SEaMtYUBO/dRlguqlB7In
	 5vKKzVY0vmZsjCi6wciMm4NKqkBipwKimB5efGZj+aKTR0UphCzddGfZR8PT25y1Uu20N
	 mVVSwBmwdm9SH1lTg1XTJUEDPyBJ38ICyJp3G4FqZOAQKCiPBpk8rRQwKxlFjiS2rpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b="z/6Ep7Db";
	arc=none smtp.remote-ip=195.10.208.62
Received: from mout-b-202.mailbox.org (mout-b-202.mailbox.org [195.10.208.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B8C606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 10:37:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40B8C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=z/6Ep7Db
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-202.mailbox.org (Postfix) with ESMTPS id 4jQtwj6wrYzKpVf;
	Fri, 13 Nov 2026 11:36:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794566214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcEaM2ur2M0qtp8COwjOtk3VZ9VEp78bGrqfRJ8uL1c=;
	b=z/6Ep7DbGqcVICFzW4IH9MPnta0dyYFODxR47Fv7wN/VRycZ/RjHZntix8iAsY2k3T7n0f
	AGj4m3nR13rdXlB/SowGPiUjLQ4S9stx/xOcGhL1FKY2gAY2VXOqm2vSNGVp5mWRdIFB1j
	iouLpu5ny7NMV3+L7dutSWOpDZJsqqvuRtwQMA5gy1cKmd1uOm5CSh9aFCPJC9IRX+aGwk
	bo9pA85tTYP+IHOZydRHLfpIiq18Wu1yyy3hftz54Crctu2FEK5MUzTSnQHhSR0DX8lV2c
	TEdTeKZmQl8U0GnpyrZlEt59PtLWZjlVVU/qxESyCzpnU1u/+dMctD37AyqU5Q==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
Message-ID: <818d8649-5bfc-46ac-a0d8-b9a5a2a052e9@mandelbit.com>
Date: Fri, 13 Nov 2026 11:36:50 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] lib/crypto: Add AEGIS-128X4
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>,
 Antonio Quartulli <antonio@openvpn.net>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Ralf Lici <ralf@mandelbit.com>
References: <20261112125432.3064939-1-antonio@openvpn.net>
 <1906b5ed-7650-484c-9eb0-a99c8e27c943@app.fastmail.com>
 <CAHmME9qSPWDhrvoQH=QX2hj+Ei7mcTYFqy-M+kMnJhgzRuJ1dQ@mail.gmail.com>
 <c24fdd26-7e77-4dca-a0fc-94c998ebdff8@mandelbit.com>
 <20261113020601.GA1742@sol>
Content-Language: en-US
From: Antonio Quartulli <antonio@mandelbit.com>
Organization: Mandelbit SRL
In-Reply-To: <20261113020601.GA1742@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4jQtwj6wrYzKpVf

On 13/11/2026 03:06, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 11:54:05PM +0100, Antonio Quartulli wrote:
>>>> We used to have implementations of aegis128l and aegis256 in the kernel as
>>>> well (along with morus), but we removed them on the basis that it was
>>>> aegis128 that won the competition.
>>>>
>>>> As far as I know, nobody actually uses any of that code, though, so I am
>>>> quite to surprised to see now that it was aegis128 that was dropped
>>>> from the portfolio, and aegis128l and aegis256 have made a miraculous
>>>> return, along with some other variants that appear to be tied to the
>>>> register width. What happens when 8-way vector registers become
>>>> commonplace? Create yet another aegis variant that case use them
>>>> efficiently?
>>>>
>>>> So I'm struggling to see why we should take this RFC seriously, to be
>>>> honest ...
>>>
>>> I'm also not really sure what's going on. CAESAR competition selected
>>> aegis128 and listed 128l and 256 as "additional finalists". And then
>>> RFC10032 has written up 128L, 256, 128X, 256X, but not the original
>>> 128 that was selected. And then none of this has been picked up by
>>> NIST. Meanwhile, NIST's light weight crypto competition selected
>>> ASCON, which as the "lightweight" as opposed to "high performance"
>>> pick in CAESAR. So I dunno! I've been waiting for the dust to settle
>>> for a little bit.
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

I see..it definitely sounds like a maintenance nightmare.

> Now we have RFC 10032, which specifies an unbounded number of
> incompatible AEAD algorithms in four families.  It leaves the degree of
> parallelism "D" unspecified, with only a few examples given in the
> "Operational Considerations" section -- not the actual specification.
> 

This is indeed a non-negligible detail I underestimated.

>> I am not the one writing ciphers and judging them during competitions,
>> therefore I think the 8-way question should not be for me :-)
> 
> I'm afraid it is for you, as you're the one proposing that the kernel
> carry this particular variant.  This proposal does not seem to consider
> any of the other incompatible variants specified in RFC 10032, including
> 256-bit key variants which are generally preferred these days.  It also
> still has the flaw of a fixed degree of parallelism.  Finally, it also
> ignores the kernel's existing legacy AEGIS-128 code, which we still have
> to support too, and doesn't attempt to share any code with it.
> 

Fair enough.

> Fragmentation is a huge problem, especially when code cannot be shared
> and each algorithm has to be optimized for each architecture.
> 
>> As a side note, our tests on a prototype ovpn using AEGIS128X4 confirmed
>> higher throughput, therefore we were hoping to have a chance to see it
>> merged.
> 
> Anyway, we do not support things just because they have an RFC.  There
> has to be a technical reason.
> 
> Being faster than AES-GCM is indeed a technical reason, so there is
> still a chance this could be worth doing.
> 
> It's just not very convincing when AES-GCM is already so fast.  It got
> 3-4x faster on x86_64 in the last few years, due to the VAES
> instructions and the code I wrote to use them, and of course AES-GCM's
> natural parallelism (there's no need for "AES-GCMX4").
> 
> Moreover, from the benchmark numbers you gave, it seems most of the
> remaining overhead is not in the crypto algorithm itself anyway.
> 
> So perhaps it's best to focus optimizations elsewhere in the networking
> stack for now, maybe work on switching from crypto_aead to lib/crypto/
> to eliminate the known-problematic crypto_aead overhead too, and wait
> for the dust to settle on AEGIS a bit?

At this point I believe this is the right thing to do.

Better wait for situation to be a bit more clear and then we can 
re-evaluate the path forward for AEGIS.


Thank you all for taking the time to explain in larger detail what 
happened in the past and why we should be cautious with (re-)introducing 
this code.

Regards,

> 
> If we are going to support this, we would at least need to know that it
> is actually worthwhile and will be "the one", rather than the first of
> many variants springing up with duplicated code.
> 
> - Eric

-- 
Antonio Quartulli

CEO and Co-Founder
Mandelbit Srl
https://www.mandelbit.com

