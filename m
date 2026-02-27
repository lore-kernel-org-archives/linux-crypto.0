Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F3036BCE8;
	Fri, 27 Feb 2026 08:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772180456; cv=none; b=JGWhZkLTwMVTFS/aIJTGagFAAtcFjSd+aZzWNGxfTjPUWpbH/RNp6tusALH0WdL3h8gdUyN9E0M5gyL5PUfkTcnwh2zy/cfySoV9bfQeEUvHTXPU2LhRXsD1PSvzsJx6PahFW6KBwyGlaVykNgMwaLWFiwB9SvDYHA38swlOXlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772180456; c=relaxed/simple;
	bh=Ma05PAJS2sHYWrB7zsSciI7rt0n0mEZqIsK5RXDOiKA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=HHeCDDn6yWjLZ3cE24tRDmvhXs6EgmV5fD1HUSJlE/E4z/zUcG0639mO4wNgrny/tiGX3K4KxIge3qmA2d58NvuSDcihTSHuAJDAlPROwR2ouHrSUTVeMoimMuoVYnY1ZNPmdrnGhP/2Y0pLdg25KZSd2IqSeVBpfFj78sBJjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g08jlodW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g08jlodW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C66CC116C6;
	Fri, 27 Feb 2026 08:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772180456;
	bh=Ma05PAJS2sHYWrB7zsSciI7rt0n0mEZqIsK5RXDOiKA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=g08jlodWM3lBAR/0wVJsdh1xIXLTH1XUgamdxXko/+khtLITvOBPDsmZm4CSvsHvh
	 beXeUyPL108AG3winLenrccqSHabHo9rrb36vmGEuJRrziMQ/EwuVfGMYgL+VkgwaZ
	 Df8jOy14BGAbvKlk1fue5ptYnKLyqghdUpnTC7I08oOLR8BcegLt+/vO0yJ7FsoOsK
	 WBEveiGF0gwyhAO6eoz9Qc+wC0I15k+SPbWfdHTcwqBU4u0df0sbL9o7CY0AFhV1an
	 VvV0GNcxKIQgV2RB23ltkIxqFgS3SOpkDpl/ZN8fg/RUfjjTUQG4CT+pM8Y7Lrn3N+
	 Fymjy/0kSfcag==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 35C67F40068;
	Fri, 27 Feb 2026 03:20:55 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 03:20:55 -0500
X-ME-Sender: <xms:51OhaVg9DNPydCh5ie2A9_1sFX2YIYzmBSVGpMJBTp2yzWO47POZ-g>
    <xme:51OhaU0CApTr1qBWHZ7z48oruZTSXWWtP41akTI_sScwhiqCNij7dqATf6c2NMHWz
    qafsV9KNPjAdj-8JHEO8Qn9MKdBWQx_6QKHPrlrL8kFknszFLPr0Hg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeekgeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    uddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrrggvmhhorghrieefsehgmh
    grihhlrdgtohhmpdhrtghpthhtohephhgvrhgsvghrthesghhonhguohhrrdgrphgrnhgr
    rdhorhhgrdgruhdprhgtphhtthhopegurghvihgughhofiesghhoohhglhgvrdgtohhmpd
    hrtghpthhtohepkhhunhhithdquggvvhesghhoohhglhgvghhrohhuphhsrdgtohhmpdhr
    tghpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehgvg
    gvrhhtsehlihhnuhigqdhmieekkhdrohhrghdprhgtphhtthhopegsrhgvnhgurghnrdhh
    ihhgghhinhhssehlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqtghrhihpth
    hosehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhn
    vghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:51OhaWTdiy5feTXI-x2drZ5Rh3fIIw1TuMihlGpcEoe3GcLtvHUHuQ>
    <xmx:51OhafcOa-irIlLngAAQ6bnsW9cYDVuUd5cSYBLjXhoi02uWLFe6JQ>
    <xmx:51OhaceWMupLI0BRiePuHgik39NjhG_PTsJW_7-J6n-eV0f9wXM2kg>
    <xmx:51OhaTZE9ewqZLaJ2yBFVbF4qdmkMGUl0i7e8xFrUeZWu-asFsd3Gw>
    <xmx:51OhaQ4X6RQoUHG-MctAM6YTwwApnF4NlhZoj33IW08iPJAph17t2fY5>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1512C700065; Fri, 27 Feb 2026 03:20:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A3dcfFOTEQoo
Date: Fri, 27 Feb 2026 09:20:34 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org,
 "Brendan Higgins" <brendan.higgins@linux.dev>,
 "David Gow" <davidgow@google.com>, "Rae Moar" <raemoar63@gmail.com>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>, stable@vger.kernel.org
Message-Id: <bc7bd2a1-4878-465e-8784-e4dd9d2747f5@app.fastmail.com>
In-Reply-To: <20260226191749.39397-1-ebiggers@kernel.org>
References: <20260226191749.39397-1-ebiggers@kernel.org>
Subject: Re: [PATCH] lib/crypto: tests: Depend on library options rather than selecting
 them
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 26 Feb 2026, at 20:17, Eric Biggers wrote:
> The convention for KUnit tests is to have the test kconfig options
> visible only when the code they depend on is already enabled.  This way
> only the tests that are relevant to the particular kernel build can be
> enabled, either manually or via KUNIT_ALL_TESTS.
>
> Update lib/crypto/tests/Kconfig to follow that convention, i.e. depend
> on the corresponding library options rather than selecting them.  This
> fixes an issue where enabling KUNIT_ALL_TESTS enabled non-test code.
>
> This does mean that it becomes more difficult to enable *all* the crypto
> library tests (which is what I do as a maintainer of the code), since
> doing so will now require enabling other options that select the
> libraries.  Regardless, we should follow the standard KUnit convention.
>
> Note: currently most of the crypto library options are selected by
> visible options in crypto/Kconfig, which can be used to enable them
> without too much trouble.  If in the future we end up with more cases
> like CRYPTO_LIB_CURVE25519 which is selected only by WIREGUARD (thus
> making CRYPTO_LIB_CURVE25519_KUNIT_TEST effectively depend on WIREGUARD
> after this commit), we could consider adding a new kconfig option that
> enables all the library code specifically for testing.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Closes: 
> https://lore.kernel.org/r/CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com
> Fixes: 4dcf6caddaa0 ("lib/crypto: tests: Add KUnit tests for SHA-224 
> and SHA-256")
> Fixes: 571eaeddb67d ("lib/crypto: tests: Add KUnit tests for SHA-384 
> and SHA-512")
> Fixes: 6dd4d9f7919e ("lib/crypto: tests: Add KUnit tests for Poly1305")
> Fixes: 66b130607908 ("lib/crypto: tests: Add KUnit tests for SHA-1 and 
> HMAC-SHA1")
> Fixes: d6b6aac0cdb4 ("lib/crypto: tests: Add KUnit tests for MD5 and 
> HMAC-MD5")
> Fixes: afc4e4a5f122 ("lib/crypto: tests: Migrate Curve25519 self-test 
> to KUnit")
> Fixes: 6401fd334ddf ("lib/crypto: tests: Add KUnit tests for BLAKE2b")
> Fixes: 15c64c47e484 ("lib/crypto: tests: Add SHA3 kunit tests")
> Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
> Fixes: ed894faccb8d ("lib/crypto: tests: Add KUnit tests for ML-DSA 
> verification")
> Fixes: 7246fe6cd644 ("lib/crypto: tests: Add KUnit tests for NH")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch applies to v7.0-rc1 and is targeting libcrypto-fixes
>
>  lib/crypto/tests/Kconfig | 35 ++++++++++++-----------------------
>  1 file changed, 12 insertions(+), 23 deletions(-)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
