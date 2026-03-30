Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA4D37BE6E;
	Mon, 30 Mar 2026 16:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774886715; cv=none; b=XZm5seCikrMpOdOktRZRVmujuTI/fkgiDY53HemKC1XEOdKpJaJiQ9WUA9V1HxkZ+rOISuaWIisStAgsuK668CCL4b0NHv7alKnt1w05d8ifP98hG4IP+z8OtMt1wsCmCLYp4P06ohZBzIttvocD3SmwF4VeABKrUWuRvf+IyEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774886715; c=relaxed/simple;
	bh=TgLSk+5bBoGnTqULZQT4gLbfagMrrJBmQBpdAzOaMYc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ul98ur24mThBYLiDRmOBsl8WYcT7YYB+P8+Fealys6/KNESpr+bXAjNxlAJNNgngcCF6y+8ATlihRjK3r+i+3V0lLmzDV10tZoq4Nk0Or6iHY/uJitXPIwvUPcyxoZGX37wuq+bwuWoNsd+0hNXk7DQWd6gV7KS2KHWSU9AV2wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mw8D5kZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mw8D5kZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEE7C19423;
	Mon, 30 Mar 2026 16:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774886715;
	bh=TgLSk+5bBoGnTqULZQT4gLbfagMrrJBmQBpdAzOaMYc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=mw8D5kZyZGE8J6onjn91vjtSVKw192T4fATzMQ0s/QKMJdbGcyqjJntVvZp1TmRXZ
	 wKCtwrofk87HajEFfTS3EozCDk1e5tms0NnCGSZ/pXWFgIXaz7nwBDlKG761jfF9EW
	 q9SzFRsAKzb1Y14Zknfd088X9kT6t14qkBHkYP1W1nija/ovRJ483U6EFvQPqZ8RzB
	 m6oXZ3EsUdzJndPYeOV4cfgMvKTgbHtcfLss/fCkhlVFzSfkJLS0Ittc4fTLKKB7v0
	 PHF7K4gnveSpMjYTZJ3qi3nULiVbavhEiZJZyFRJv7g4UX7giBRJnEwd4TrBSqMXZX
	 7LDt3sG9A6o1A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2963DF40073;
	Mon, 30 Mar 2026 12:05:14 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 30 Mar 2026 12:05:14 -0400
X-ME-Sender: <xms:Op_KaXWl9o0KRTOQXZLXHVAri9Q6c3x7Jt7ItTK-Ypq2UhE285VZKQ>
    <xme:Op_KaaZkFuSik0xg-IysdMa_7BBHFnc-Fg94XVKsZtrjrbTbgh5WS3qNKTocwngte
    vcGMgo6T4LLvWwR2Qkf7KxXbvAEP0KsIRp4JJZ3CkKo5bcMX4JfOa5j>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehglhgruhgs
    ihhtiiesphhhhihsihhkrdhfuhdqsggvrhhlihhnrdguvgdprhgtphhtthhopehlihhnuh
    igqdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehsph
    grrhgtlhhinhhugiesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghs
    ohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:Op_KaYHVnBcbAbW-NRIAlDnkxxEUz3YOrs91uVVJtt1sFsK7Zs9D4g>
    <xmx:Op_KaT6uONk5y3TkK_EC_aRP5m3SB4enFi-ORxj-cRy1E-vHTvhjIA>
    <xmx:Op_KaVy581VDm6ljNoLnDZ3pUtcbi0uFUrPfR6720EOyZ6IASZ4d3g>
    <xmx:Op_KaaNJq0cJpQLMGnYT79K6g0pw6AiQzkle9GoBaBKZbxE7_b43eQ>
    <xmx:Op_KaTn82iWTLowQbvRxwn0QGWB5MK2xHquiiirFovcHpyUhpOTsHnvz>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id F197D700071; Mon, 30 Mar 2026 12:05:13 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A5MJLS9D-sX3
Date: Mon, 30 Mar 2026 18:04:53 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>,
 "John Paul Adrian Glaubitz" <glaubitz@physik.fu-berlin.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, sparclinux@vger.kernel.org
Message-Id: <5ad43f1d-8a89-495c-a331-7bfc8ae8c389@app.fastmail.com>
In-Reply-To: <20260327201456.GB25969@quark>
References: <20260326203341.60393-1-ebiggers@kernel.org>
 <fc5a80f3579d642a9f792a33b0f7ef6101838f83.camel@physik.fu-berlin.de>
 <20260326230232.GA67831@quark> <20260327201456.GB25969@quark>
Subject: Re: [PATCH] lib/crypto: sparc: Drop optimized MD5 code
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 27 Mar 2026, at 21:14, Eric Biggers wrote:
> On Thu, Mar 26, 2026 at 04:02:32PM -0700, Eric Biggers wrote:
>> On Thu, Mar 26, 2026 at 10:51:01PM +0100, John Paul Adrian Glaubitz wrote:
>> > On Thu, 2026-03-26 at 13:33 -0700, Eric Biggers wrote:
>> > > MD5 is obsolete.  Continuing to maintain architecture-optimized
>> > > implementations of MD5 is unnecessary and risky.  It diverts resources
>> > > from the modern algorithms that are actually important.
>> > 
>> > Why is it risky? That makes no sense.
>> 
>> Because there can be issues in architecture-optimized algorithm
>> implementations that don't exist in the generic implementations.  That's
>> a very common class of issue that has repeated over time.
>> 
>> > I also don't see how it diverts resources as no one is forced to work
>> > on the code.
>> > 
>> > SPARC is an architecture used by hobbyists and in space these days (in
>> > the form of Leon). I don't think any other kernel developer will have
>> > to take a look at it.
>> 
>> Huh?  We've been refactoring how the various crypto and CRC algorithms
>> are integrated, for all architectures.
>> 
>> So people outside the SPARC community, especially myself, been having to
>> spend quite a bit of time updating the SPARC code so that it can still
>> be used.
>> 
>> And this isn't new.  I've had to patch arch/sparc/crypto/ many times
>> over the years as things change in the crypto subsystem.  Many other
>> people, again outside the SPARC community, have as well.
>> 
>> The fact that you're denying that we've had to do this is really
>> frustrating.  There is a significant maintenance cost to keeping this
>> code working, which is being paid by people outside the SPARC community.
>> 
>> It seems best to at least focus that effort on modern algorithms like
>> AES and SHA-256, and not obsolete ones like MD5 and DES.  Note that
>> dropping those eliminates the need to add them to QEMU, as well.
>> 
>> I think that makes things easier for everyone.
>
> Let me know if you're aware of a real user that needs the obsolete MD5
> algorithm to be accelerated for SPARC in the kernel.
>
> Otherwise, I suggest we proceed with this patch, as this objection seems
> to based only on principles and misunderstandings.
>

Agreed. I do sympathise with the hobbyists, (and with the astronauts, for that matter), but the mainline kernel is not a museum. If someone has a desire to run obsolete code on an obsolete architecture, they are more than welcome to do so. But demanding that the rest of the world spends time on this is unreasonable, especially given that few people have access to the hardware.

The upshot of that is that the burden falls on the maintainers to chase bot reports and other reported regressions on obsolete architectures, and doing so for code such as MD5 which is entirely obsolete itself is just busywork.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
