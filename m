Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7923D6CB8;
	Mon, 30 Mar 2026 17:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774891598; cv=none; b=ZicXEuQgTjR+2X/sTqtUv1LS/kQ81rCnV/tqun/prkKWJsEHvLjDAUMPKMpqtXx68xK3iDt0I66+3367bT8qo2BO3/xdOloXR0KQPfQGEty4aE7veDXGEpCjW4vud0ePSqWMqhT2O9Jl0euhPDT9G1kwoT0QJ7s/xnvFEMXGWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774891598; c=relaxed/simple;
	bh=zIQ5iEH0F8CEll7aB8UqgVW0O9d0TCU0mqPJWBOS5f0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=unZYBVqHHGUrnAcMWeyQ2oQ+EMf294vkvxIm1PAonO/hPXnJ0pHyc2yUWCpsHNLqDFu1wpWAjkKnbGn45e1py38hcRhhKrdgTsPurWDlEv9GCwMAvOQ14CiXOZPsuXHo+mVVKt+o8pcLfUozEYyF90om3I2AbewsoR2cLYvyvUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFk97jlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFk97jlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AC6C2BC9E;
	Mon, 30 Mar 2026 17:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774891598;
	bh=zIQ5iEH0F8CEll7aB8UqgVW0O9d0TCU0mqPJWBOS5f0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=nFk97jlpJeCQNil8sdtB2EYUavbAyetMVr0uJS6GRXN34cZrypR2nHL1Rwz0Qls3u
	 pbwn2kpa54Vbf+FCFTFFiiAqSbAzzQSiA+3OP27Tt070ZjxmqCKAUnNHItif5xl5r4
	 hfj14ocmCYJk79zncRAVfA5kdZumj5xcqXvIYNPBRZ2PHlFZP01REOMFLwjT+J2jEa
	 idlo+bkZwL+EDCHohWsrjVVYeFfNcyoEVyprGS1id336aYgEFk61ZoXjHKElZj7qRO
	 sFEsIFCXUP3BpSiR9TvOpYFNXwktqtsbs3G+GHNuaENKac+aq1R15U9SdVkG//2bmS
	 pbkfYxCV6Gt4Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 1E551F40080;
	Mon, 30 Mar 2026 13:26:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 30 Mar 2026 13:26:37 -0400
X-ME-Sender: <xms:TbLKaT9wpY3pdQDRKCY7hRI-b2AzqyB1A_Dwozp7TKh8HfflrzGp3w>
    <xme:TbLKaag47OnACs5v_uQhgsBNa0cNDdQLrT5NVrAFCZ1TrnQjEsAuWCrZPXRQ4JiTl
    K_RIqyFjM7_loTwgZRDdnMGmGcE6VTYe0B6FSziaxFZDYEOCsJbIks>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelheejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtghpth
    htohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdgtrhihphhtohesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghs
    ohhnseiigidvtgegrdgtohhm
X-ME-Proxy: <xmx:TbLKaVo5t0cfeS3NS3dYgz3aRsLtpsIKBcu8e7wuvL744oc7Kzzp9g>
    <xmx:TbLKaQ-3b_VXKQ5OLmniE256s0C-3pMGkHAzwGT6Q_D-zKj520C6Sw>
    <xmx:TbLKaZc6UgkTYpPc2TQBrwE0qVA1TmLnRZjmIwm9__pTfeQ4_ZVzCQ>
    <xmx:TbLKaSK7Cl2wnHfh8n3A_DJQqXbDWn5YxYt2gDrBv9ieLhiA7C_2uQ>
    <xmx:TbLKaRiwEk-5FyENlDL4lMfpXUX1fm3sMYX9TUkmy-3wPoF1JuqWElUD>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E721B700065; Mon, 30 Mar 2026 13:26:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ADfhoPKVufpN
Date: Mon, 30 Mar 2026 19:26:16 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
Message-Id: <8f1d106f-172d-404c-b7d5-3d56fe074161@app.fastmail.com>
In-Reply-To: <20260327224229.137532-1-ebiggers@kernel.org>
References: <20260327224229.137532-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: tests: Migrate ChaCha20Poly1305 self-test to KUnit
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 27 Mar 2026, at 23:42, Eric Biggers wrote:
> Move the ChaCha20Poly1305 test from an ad-hoc self-test to a KUnit test.
>
> Keep the same test logic for now, just translated to KUnit.
>
> Moving to KUnit has multiple benefits, such as:
>
> - Consistency with the rest of the lib/crypto/ tests.
>
> - Kernel developers familiar with KUnit, which is used kernel-wide, can
>   quickly understand the test and how to enable and run it.
>
> - The test will be automatically run by anyone using
>   lib/crypto/.kunitconfig or KUnit's all_tests.config.
>
> - Results are reported using the standard KUnit mechanism.
>
> - It eliminates one of the few remaining back-references to crypto/ from
>   lib/crypto/, specifically a reference to CONFIG_CRYPTO_SELFTESTS.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/crypto/chacha20poly1305.h             |    2 -
>  lib/crypto/.kunitconfig                       |    1 +
>  lib/crypto/Makefile                           |    1 -
>  lib/crypto/chacha20poly1305.c                 |   14 -
>  lib/crypto/tests/Kconfig                      |   10 +
>  lib/crypto/tests/Makefile                     |    1 +
>  .../chacha20poly1305_kunit.c}                 | 1493 +++++++++--------
>  7 files changed, 760 insertions(+), 762 deletions(-)
>  rename lib/crypto/{chacha20poly1305-selftest.c => 
> tests/chacha20poly1305_kunit.c} (91%)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
