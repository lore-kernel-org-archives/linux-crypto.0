Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4271136EA9B
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 06:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774939612; cv=none; b=s3sbdNQzS9SXMMzffMUfEFvrFLReIxTO0OhKwKMTInGdAmO51e9tYfGX2/ytMRj+R5bepC5vYQ8zE2e0QcO3BuqwqXl2WAXB/rXLrqz77D5HwQALk+2y3fI376wjNKb7NVvcnbB+9sDJSyVEoYxqrniLMHmh3qzenF1YV4fqAjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774939612; c=relaxed/simple;
	bh=wTYbKATF02gHL0BNmh4jiIrPFPGv6EmLaO3h0rzG3u0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WlTWO5JlsLIx8HOtfO/uSmxt8V05tUTk1tmVfx4L474g/lJyZrVp89Egk4kBO3pwUZYJNlurHdxuaKaHDDiFo/Rn+aCXOmxNYnlwOgU9uyCCyS6atZ1i2+DGZEJtjut8Nu1xDnqu85mS6NVIlLDhFyfW4Z/y9VSWogkUolt8dOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXsRnYym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXsRnYym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D69C19424
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 06:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774939612;
	bh=wTYbKATF02gHL0BNmh4jiIrPFPGv6EmLaO3h0rzG3u0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=VXsRnYymoME9kKLEVXNGVH2ntuZHuHLSUvsL/xw5rzsRiUeZIrW6kzy9kiCAagCKy
	 pmWJRWBW64LY5219Sj8RbPlhSy8LLKZauUU3/4o73FASWReqMpYlbOhkkiZRh1fhUi
	 ywXMC2XyqcGYWcySE871sL/Xejd4w+5nmMdAG+pXJYBZkKOdwTEZ3z0aAadCHICt83
	 SJIiJum7lRR0bvrITf9QDKsrF0l9AXlhvU+yU7qsZ5GT+ijHRaiIYN+pGkyD/ArqPY
	 Rl2rEwNlBe0uJJmKwGD9nK48yTHeOmqjY2QMu5kUlId9WUee2oMDhu8hFmt+ZeMSu5
	 aBw1lipq8shXA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id E8B69F40076;
	Tue, 31 Mar 2026 02:46:50 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 31 Mar 2026 02:46:50 -0400
X-ME-Sender: <xms:2m3LadZ6990gFEY53WPCCZQmyz8wb2yBNxGITQ0PxhsRXOePW4iwwQ>
    <xme:2m3LafNkkofmZJCyU9uJSs8GQgtohxWtAOctPxz6wffD5Z5tCpp0jk611pMQU60zy
    HZc9VxPB4oNoAKgdqfdKhelUZDq0CoywZzJw6yGa2dWor0zBqkFiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgeduvddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghs
    ohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:2m3LaVHn8PHPALwBhnQHLOBl-NFtAANNwrbcAZfM7JrQP2vDvv2jKQ>
    <xmx:2m3LaTqz_tPGD3tRzM53CFFNzlJ_QqAnk846NO8PPF9a0SfivZzspw>
    <xmx:2m3LaeY6ZgT6Fy8mxKbLYEHsLeI6I2QM2Li6nw55S-DTtpTBXLfupA>
    <xmx:2m3LacXWqQebsyKItlzKRFyp8BcF92VO0Yfhxtxjb90Y-VXsGFhXXw>
    <xmx:2m3LaX_m6bu6pEkP2EbNO4ulD9VxiwI8lHUOSpi-B5bx_NB8UWvN_Mdh>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C7987700065; Tue, 31 Mar 2026 02:46:50 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A1cFwBCEjsB7
Date: Tue, 31 Mar 2026 08:46:30 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <0bf31d9e-7d61-4ab6-b7f2-6f00a9b17ce4@app.fastmail.com>
In-Reply-To: <20260331024414.51545-1-ebiggers@kernel.org>
References: <20260331024414.51545-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: aescfb: Don't disable IRQs during AES block encryption
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 31 Mar 2026, at 04:44, Eric Biggers wrote:
> aes_encrypt() now uses AES instructions when available instead of always
> using table-based code.  AES instructions are constant-time and don't
> benefit from disabling IRQs as a constant-time hardening measure.
>
> In fact, on two architectures (arm and riscv) disabling IRQs is
> counterproductive because it prevents the AES instructions from being
> used.  (See the may_use_simd() implementation on those architectures.)
>
> Therefore, let's remove the IRQ disabling/enabling and leave the choice
> of constant-time hardening measures to the AES library code.
>
> Note that currently the arm table-based AES code (which runs on arm
> kernels that don't have ARMv8 CE) disables IRQs, while the generic
> table-based AES code does not.  So this does technically regress in
> constant-time hardening when that generic code is used.  But as
> discussed in commit a22fd0e3c495 ("lib/crypto: aes: Introduce improved
> AES library") I think just leaving IRQs enabled is the right choice.
> Disabling them is slow and can cause problems, and AES instructions
> (which modern CPUs have) solve the problem in a much better way anyway.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/aescfb.c | 25 +++----------------------
>  1 file changed, 3 insertions(+), 22 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

