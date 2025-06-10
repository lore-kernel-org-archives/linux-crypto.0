Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB932472B6;
	Tue, 10 Jun 2025 18:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749580981; cv=none; b=iMPyrLGAi/LY9xDRJ9WCfP7z//Rhx03kUSOR6ntcOWEhFNuBhzNk6vWLPdqGyj7r/MulWDKn/Dhg4rZ8vGWUiklGxiY+NiJUqifvEBQzNhmKc0z1hY8hBDy80fcphnDWQFpwplfSz2QHY9rP2sz8EF4YEqK+pyw6Ayq3Rvsrfx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749580981; c=relaxed/simple;
	bh=76AFPhpIHmHUuCuBRSQyPGtgXYLqcKab6s57DbAk9BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCQH8J0WoWv77jnDaMrImYgFIyP018pJRjY4TtmhdjOEqdIP6S+hXxQRL2c9u4SJ0+/FHtFkQ3FgK6gvpWqz9v0MnZRv4w0RvJOfYQ3Rq3FCjLjGEfInKsrIp0/QLA4pgLO3vgTTsn1REfWVj/Wsig1g/xztRpPH88oL2moDOJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8QJF7UL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8QJF7UL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B65DC4CEED;
	Tue, 10 Jun 2025 18:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749580981;
	bh=76AFPhpIHmHUuCuBRSQyPGtgXYLqcKab6s57DbAk9BU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8QJF7ULNO0d9Bxmy8u9L/ktJXugbopyy1Yt5iPtHj31mU74LQtmz3FcPx7Lchq8y
	 DcRwgx3VGXDzA/2RYyNNZYTShGL88SCvpo+1NqUUx6DiMFASLpKp6G3ObAxBTWKtOE
	 cju96Y6tJ0NhOGNvMogJNARP+rLi9k89H5nT2vlqB+zKFP9ObgDzzj3oOWQe/ztlnk
	 lOtYLycjq3nLqaxxtENP3iuvAxyXWHCd2nPUId87oyzdkAvr7gEH7lxu+jXpOQizpT
	 n63d3cZbwEhDds9b9EvgnsgP4kq3HoNmwR1TxGJlrUCxBR1zXIOqOaOfNXSdqM7tpA
	 GV+t5Vk/OQwWA==
Date: Tue, 10 Jun 2025 11:42:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] crypto: lib/curve25519-hacl64 - Disable KASAN with
 clang-17 and older
Message-ID: <20250610184237.GB1649@sol>
References: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>

On Mon, Jun 09, 2025 at 03:45:20PM -0700, Nathan Chancellor wrote:
> After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
> causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
> allmodconfig builds with clang-17 and older show an instance of
> -Wframe-larger-than (which breaks the build with CONFIG_WERROR=y):
> 
>   lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (2336) exceeds limit (2048) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
>     757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
>         |      ^
> 
> When KASAN is disabled, the stack usage is roughly quartered:
> 
>   lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (608) exceeds limit (128) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
>     757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
>         |      ^
> 
> Using '-Rpass-analysis=stack-frame-layout' shows the following variables
> and many, many 8-byte spills when KASAN is enabled:
> 
>   Offset: [SP-144], Type: Variable, Align: 8, Size: 40
>   Offset: [SP-464], Type: Variable, Align: 8, Size: 320
>   Offset: [SP-784], Type: Variable, Align: 8, Size: 320
>   Offset: [SP-864], Type: Variable, Align: 32, Size: 80
>   Offset: [SP-896], Type: Variable, Align: 32, Size: 32
>   Offset: [SP-1016], Type: Variable, Align: 8, Size: 120
> 
> When KASAN is disabled, there are still spills but not at many and the
> variables list is smaller:
> 
>   Offset: [SP-192], Type: Variable, Align: 32, Size: 80
>   Offset: [SP-224], Type: Variable, Align: 32, Size: 32
>   Offset: [SP-344], Type: Variable, Align: 8, Size: 120
> 
> Disable KASAN for this file when using clang-17 or older to avoid
> blowing out the stack, clearing up the warning.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  lib/crypto/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

Thanks!

- Eric
