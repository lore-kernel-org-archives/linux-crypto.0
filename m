Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D775E145355;
	Tue, 17 Mar 2026 11:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773745796; cv=none; b=mtHO2LcLuHT4PnfFSRn0he1GLHmRgitEEgjzJL5yUoYdlgDxIG9m2z8NHddNsZs4OP7Bhhaz/1SF7aA80E6kuOXdFMZANn4U73bcDjQKfu/ThnGx5LXMZZ069YAMI4l6mlhkwhAfZVL+sfy3dwl6t3D9pxSQ/PFeWOH6K120zN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773745796; c=relaxed/simple;
	bh=+qqQskHxd2Ir6u497JK/n+4v7VBPyV/EnedgQr4zm+E=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WS9BWExcc/YO4aL91KEO111EQvjDH8vLB9b1PyHaJVdOCgKdoUNeZugOTmf8jTQxUwVAGP2pMyN0ihvzSemgoYdt0fQvPM9YBoPfEI3/APrccWYv0BN0+mkYRVJOtZmwo8KoVpvNEhtSrK0M+c/YqXeoTqy51bIHOmnlvcTt05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlJIRRMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlJIRRMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BDEC4AF0B;
	Tue, 17 Mar 2026 11:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745796;
	bh=+qqQskHxd2Ir6u497JK/n+4v7VBPyV/EnedgQr4zm+E=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=LlJIRRMJV1UFBEU/vQMAGx3oLvs4PKSYKjkDg4tU0LkZ2crHsRgHSbDhr0arQ8BcJ
	 aYWP/jciA1J4sb3oo+iPF3CL9te+3PdfRUy4T9ONNGYOCV9HCc5IX/ULFJ/+sXZcTU
	 rLdWXSaf8t+X6fGC5MHlT+ENBqA2h//LBJTHS7vQkr2dRqtu1lGt+vf5AebxC9ACpZ
	 51ypH2y9n3ERm2dEHnFKRKddX1xavUBtHDKJEnSuiEVJsMi+g7A2ANGwOLKkhqGXVF
	 lyKvG67i3BUNSSS3BQUG0jjkLqpKKlgIIH0IPWhfclwZZLsVhKQFCRkvyJItvchJtw
	 2JWk6ct88npqA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 286B0F40069;
	Tue, 17 Mar 2026 07:09:55 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Mar 2026 07:09:55 -0400
X-ME-Sender: <xms:gza5aV2EpSanM8JhpWDtLOG5pRs4CI9Zf-qqt7o-DAd6G5vHUb45iw>
    <xme:gza5aW69r7A6EkJJObzdg6BH3dhIPD0uXZxls44Vj-HGdeWUv7o2YTo3Lr57XNF5U
    PE9UIR18SP6tI1q4y76XKva0mJCZaq4UNHRq6UC5D8qBoDnS9qX3Ls>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinh
    grshesrghrmhdrtghomhdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghp
    rghnrgdrohhrghdrrghupdhrtghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqrghrmhdqkhgvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpd
    hrtghpthhtoheplhhinhhugidqtghrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepjhgrshhonhesiiigvdgtgedrtghomh
X-ME-Proxy: <xmx:gza5aaHkGUjhaAr50GrqV7zKSgEarJjRVBqoBXOQVwTER4_4nDppvw>
    <xmx:gza5aby0fGrrwaCVv5Vw4ivctunLeHPXMqvUIPGsdKw54Rrr1zGryQ>
    <xmx:gza5aU3Y0M-sND_S5zRXbN_SIV6ftWjjfUTm4fxoKpRJRTzUZJCPrA>
    <xmx:gza5abotCcNiyMzP2eYK7USlG4mBBC19-zSV5nY0WOe29T9O59kdDg>
    <xmx:gza5aRXNGzFyIzd6RFZ045AUczCoD91Fd5eUZu7hG28GhpXgrEYMFuKW>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 014BA700065; Tue, 17 Mar 2026 07:09:54 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0MGIhlQvLYV
Date: Tue, 17 Mar 2026 12:09:34 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>
Message-Id: <38a37b02-602a-42a4-8974-b8a6cd750c3e@app.fastmail.com>
In-Reply-To: <20260314175049.26931-1-ebiggers@kernel.org>
References: <20260314175049.26931-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: arm64: Drop checks for CONFIG_KERNEL_MODE_NEON
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sat, 14 Mar 2026, at 18:50, Eric Biggers wrote:
> CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
> been since its introduction in 2013.  Given that and the fact that the
> usefulness of kernel-mode NEON has only been increasing over time,
> checking for this option in arm64-specific code is unnecessary.  Remove
> these checks from lib/crypto/ to simplify the code and prevent any
> future bugs where e.g. code gets disabled due to a typo in this logic.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
> (https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next)
>
>  lib/crypto/Kconfig        | 12 ++++++------
>  lib/crypto/Makefile       | 17 ++++++-----------
>  lib/crypto/arm64/aes.h    | 16 ++++------------
>  lib/crypto/arm64/sha256.h |  8 ++------
>  lib/crypto/arm64/sha512.h |  5 +----
>  5 files changed, 19 insertions(+), 39 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Actually, we should just get rid of CONFIG_KERNEL_MODE_NEON entirely on arm64, although there is some code shared with ARM that would still need some checks. But anything that is arm64-only should never look at this at all.

