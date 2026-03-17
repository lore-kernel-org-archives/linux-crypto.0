Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405B13DCD9B
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760126; cv=none; b=PlGHH2OXs4plRT1T41mZ5rxgDJzPlbFYsGbyYZQ4qEq8Cdn1q0R0aSs1z9O64JJOKBlFDFdn0aKelOLVPIjrQJHOcbPYVXU8PZOG1w2h6UOjk1mX/rqCcgeIWn9c9qaPkmDDe9NirTUBxWcpi92JG9vuW5DQ6EdijGvn296JvDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760126; c=relaxed/simple;
	bh=Mr8nFOMXA5ElV7SfPAaspq7Qh87bB2g0Z7bO4Atcjpg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=XFrYf5H0E+VaQnBH+Oba9KNmFD34pt+dRMC/agaxpH9NRWz4s44tZ7unLNPEoJdqP/+YQRS0OINHDO6Mi/0ewEM1Ut6w5d1rJogJFzZTchM+SXbNudBjL/6GW/SZCX9SHNLzPEBtehHacFV5wqfDa2g/OFhD907EFiuvRWaGPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+iyLf3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+iyLf3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DA3C4CEF7
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773760125;
	bh=Mr8nFOMXA5ElV7SfPAaspq7Qh87bB2g0Z7bO4Atcjpg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=n+iyLf3TrBcbZZEbvqJhydPFoC2NxIXZZ+6jE08vgtdvcROgq85/Koml7Iw21lBpP
	 JNhTRj87v3/r2mAZK+ELeYyrkNM0WUZ6P0l2HOGltj7uM0szQu7vPsDeJppHAliBL9
	 J03wmeQQlUNzJTZsivVvqiNLP0qlgOaxkfHdhrZ6eKD/mUM00xwe18etIFM2IBd9x3
	 4Cnot66fR0FZKzdMXRyiUtky6vPvGPuzrXa0b2l9FrhQiYZfCUMCSLVSJ2EXZ0kXnB
	 l2CVBbeUjE95r5xvxJzgpHmIJJ8FvBz9Sodc/S0X/QtMbT5i23LjmTQGke0pTnPRpG
	 6UD/TOAczDK0A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D2968F40071;
	Tue, 17 Mar 2026 11:08:44 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 11:08:44 -0400
X-ME-Sender: <xms:fG65abCxstZNJj7FHEq82SEXWQTV0TaPWLeFvc6KUqnHXAq2YrAA7g>
    <xme:fG65acWbiD_mtCj5Ytly0zEfZT4tf0KVbdomRu-83YlDK4d3g7DefisHbB7lK3P9W
    j_EHJSak51OC4np04ybaWULo9mVClDwytwAPyEBADf-esHNxckmyzBG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduheejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohephh
    gvrhgsvghrthesghhonhguohhrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopehh
    tghhsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepvggsihhgghgvrhhssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepjhgrshhonhesiiigvdgtgedrtghomh
X-ME-Proxy: <xmx:fG65aYuok-blM0mBAaiWPna8oMSA1snjL6wMV5SBp3mWm9JbsgsC5A>
    <xmx:fG65abcccpnRaI6yp8h-Ey8KvFrIHGq_Q55Yaf3AG4RCW7gDVzKC8w>
    <xmx:fG65aekM15kjzIgQX43LElqb3j07OVoxNlukOhhYj_NJpZkMByo8mg>
    <xmx:fG65aeDlZ219m8e0_mmv2ShikggnfaoZQeC7GWtBs6cs3ddfWEzEcA>
    <xmx:fG65aYPivqHq_hB2TWaqMw72jeXSf3Cx5EAk9Jh0VsZ4G6D2xp6_Ar7B>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AD9CD700065; Tue, 17 Mar 2026 11:08:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0MGIhlQvLYV
Date: Tue, 17 Mar 2026 16:08:24 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>
Message-Id: <ef71c58d-3950-474e-bddb-fc95f8d18b07@app.fastmail.com>
In-Reply-To: <ablpCtKCV5goM_AD@infradead.org>
References: <20260314175049.26931-1-ebiggers@kernel.org>
 <38a37b02-602a-42a4-8974-b8a6cd750c3e@app.fastmail.com>
 <ablpCtKCV5goM_AD@infradead.org>
Subject: Re: [PATCH] lib/crypto: arm64: Drop checks for CONFIG_KERNEL_MODE_NEON
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Tue, 17 Mar 2026, at 15:45, Christoph Hellwig wrote:
> On Tue, Mar 17, 2026 at 12:09:34PM +0100, Ard Biesheuvel wrote:
>> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>> 
>> Actually, we should just get rid of CONFIG_KERNEL_MODE_NEON entirely on arm64, although there is some code shared with ARM that would still need some checks. But anything that is arm64-only should never look at this at all.
>
> I'll also drop it from the XOR series.
>

Ack - mind cc'ing me on the next revision?

> Talking about which (sorry for highjacking this thread), arm32 and arm64
> have completely different neon XOR implementations, where arm32 uses
> #pragma GCC optimize "tree-vectorize" or clang auto-vectorization of
> the generic C implementation, and arm64 uses intrinsics.  Is there any
> chance those could share a single implementation?

If we're migrating the XOR arch code to live under lib (if that is what you are proposing), I think we could tweak the arm64 implementation to make it build for ARM too, with the caveat that the 3-input EOR3 instruction does not exist there.
