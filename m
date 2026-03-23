Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7044D38C41E
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 14:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275231; cv=none; b=RrV6DCRQkbNZQABT91CDkFzPFbBDON9YIbaPc1pFAWzYnHAWeitiEECKuKKxeJ84fOHSd+FtrvvXC/+zSmAJZhX3Z+0sygjbz4/FPfbzaFMn5rNOWFboJnzmY73NnSamHagDXxuXehBmIfi15oXF0hxM0DxlL+tH9yu1S52UWNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275231; c=relaxed/simple;
	bh=WV9/8Y9Hrj0u/n0KxmeX/KThci2cUIx/HlMaJ7Ikq/0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DQP/HAr+H3ws93gzn4y9+ADkYGhxUxY7HxXZUcW2vBF+NbBKwn4IUqsbQbFKqKEoDn8Z22QE5jRv17gYS+R+k9DGU8kVD2jgavf7aS2Gif4iaiWG683K11b6xnvoKkcYMap2/EIWUZ9BW+gEP/WQkVYpmcTL3CGAwR/Cw+ELcAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gw864Nq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gw864Nq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77D5C2BCB4;
	Mon, 23 Mar 2026 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275231;
	bh=WV9/8Y9Hrj0u/n0KxmeX/KThci2cUIx/HlMaJ7Ikq/0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=gw864Nq8A8x0B7oVzEoTKd4osVd+NbMgvhsaJj1ek8d6Mp9NpH/FW2K7+DleIHDTM
	 xd56q+WtMuDWuvfZeD5mo+YAnSWA4yekxWo3NKgedd/OB1jAF2//E1+7zQZa3VLc5R
	 dhUgsrZP78t3N6bE0ESR+3zScgzyhJ0ftf6om5xxm8qfBtIU2umOPLvsMqy4ERwGcs
	 h5SnFZXq+szrkzVpCOUKMHL4LSZIFV+u5vob3ydky31dzG4bIyPdE+dwZmWqzcNuLG
	 OJsiC6A2XDI2ouyMGuzJtZ5f71Azma4ufNA6HoIOy8SO+BJpj9MbOn4T8/Ethob6yI
	 EXPLT6aS/Hqsg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F1681F40072;
	Mon, 23 Mar 2026 10:13:49 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 23 Mar 2026 10:13:49 -0400
X-ME-Sender: <xms:nUrBadC1_OtdHwg2b6gpiQ4aeHfv45Jy8mJT-MwRJkLVX-fyHOuXuQ>
    <xme:nUrBaWUdQV2rQedujW13Zmu6kmWLANVBh2FfvwxlsMP5pnua1SEpZOuyfYLEAxnFx
    juCfB5dbK4IqV3QSj0_2_e7qK547kRbxlHXKIbkfovwkp__JbWWfBs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefudekledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    ledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgvrhgsvghrthesghhonhguoh
    hrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epthhirghnjhhirgdriihhrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgt
    phhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhf
    rhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrh
    drkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrshhonhesiiigvdgtgedrtghomh
X-ME-Proxy: <xmx:nUrBaXO-P4p3-OW8sf0muUIQFxDsvyAThoJKUkCSXK5UMh6io_XVuQ>
    <xmx:nUrBaamskWWmfCaRs7Y-9MqXRtV5Y757z4swSogQQU2rcj2TJjqD3Q>
    <xmx:nUrBadss19Agzva72orfrm8YFKQULnCmpzw12XdXqsGMoDMek8NtQQ>
    <xmx:nUrBaVr2mVFtmeJGXKIMuC02yXKbginljF4UVrXZIzA0YohOzh9jdQ>
    <xmx:nUrBaTcrDPYzX39cxxGGcF5xdTSNjIO6RFr_hvSaKxGzHV1_xJ1j7B-_>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CD248700065; Mon, 23 Mar 2026 10:13:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AHn2Hf40_V7R
Date: Mon, 23 Mar 2026 15:13:29 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 "Tianjia Zhang" <tianjia.zhang@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org
Message-Id: <a51e6947-9767-4dda-8a66-a157fdd79f25@app.fastmail.com>
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Subject: Re: [PATCH 00/12] SM3 library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 21 Mar 2026, at 05:09, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
>
>     git fetch 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> sm3-lib-v1
>
> This series cleans up the kernel's existing SM3 hashing code:
>
> - First, it updates lib/crypto/sm3.c to implement the full SM3 instead
>   of just SM3's compression function.
>
> - Next, it adds a KUnit test suite for the new library API.
>
> - Next, it replaces the "sm3-generic" crypto_shash with a wrapper around
>   the new library API.
>
> - Finally, it accelerates the API using the existing SM3 assembly code
>   for arm64, riscv, and x86.  The architecture-specific crypto_shash
>   glue code for SM3 is no longer needed and is removed.
>
> This should look quite boring.  It's the same cleanup that I've already
> done for the other hash functions.
>
> Note: I don't recommend using SM3.  There also don't appear to be any
> immediate candidate users of the SM3 library other than crypto_shash.
>
> Still, this seems like the clear way to go.  It's simpler, and it gets
> the hash algorithms integrated in a consistent way.  We won't have to
> keep track of two quite different ways of doing things.  With KUnit the
> code becomes much easier to test and benchmark, as well.
>
> Eric Biggers (12):
>   crypto: sm3 - Fold sm3_init() into its caller
>   crypto: sm3 - Remove sm3_zero_message_hash and SM3_T[1-2]
>   crypto: sm3 - Rename CRYPTO_SM3_GENERIC to CRYPTO_SM3
>   lib/crypto: sm3: Add SM3 library API
>   lib/crypto: tests: Add KUnit tests for SM3
>   crypto: sm3 - Replace with wrapper around library
>   lib/crypto: arm64/sm3: Migrate optimized code into library
>   lib/crypto: riscv/sm3: Migrate optimized code into library
>   lib/crypto: x86/sm3: Migrate optimized code into library
>   crypto: sm3 - Remove sm3_base.h
>   crypto: sm3 - Remove the original "sm3_block_generic()"
>   crypto: sm3 - Remove 'struct sm3_state'
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
