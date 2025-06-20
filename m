Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D235D17A2FC;
	Fri, 20 Jun 2025 20:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750451378; cv=none; b=qWOkC6y2esQTpi2LozMWML+QG9JeaM41TyMTc8FQsdQz2u0TEA3rHLxzY8KR2H2Hq5UmSGOco9fN4UGtFOCXlPLglMMNJXvMAcR6sEOGqcIHUm5AIwhgirDCT3qAlgYdYIHU5t9IIfYwe8vO0g7qVtXaRpLfIHDZ2R5clkoQa38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750451378; c=relaxed/simple;
	bh=oKz1LT33m9jsQ4CxJ5fRgauawkfw2GApHL5/a2fWSdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gr2GkuMLw0Th/oHtGhR9MAhJCRwmGmTDJ4zemP1XT7nJ2TvEfpvUxROamt00f7eVOHiSITzv9SrNKT0IL0987YuGi5sXqkqwZ0747XTPNtryxxLEKQCKIEG6ykgQ6r0XjNLBpavN29l7wmqZpn0Xyd0SMAgjdh3lwvKA3YLBtjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mWI247ws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mWI247ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495D5C4CEE3;
	Fri, 20 Jun 2025 20:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750451378;
	bh=oKz1LT33m9jsQ4CxJ5fRgauawkfw2GApHL5/a2fWSdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mWI247ws50YQTWeXFSlEj353U4dlyqMrvkrWq6MGMEqs6okCBAc7KSYiDxCqMQp43
	 9zR0YR+Ljt+gqCQU+9L7swfXpk92w1H0RtK6oqC17ZHYrBJBwcQ1mARfTRyj4NYSzr
	 8uTKEwAjMhuAulRTMRxvcORY6I5B6WHkus/pwHocFAYGsmO2p7NYNYNaVL2ev0Mrp7
	 Sd9Pv4XBt/hByspwZE/uFzwiUY8KnLCqzkP2DCk7cEpmIunVvmun7yyPUUggkDiobU
	 ynWRS+qeuoF/VNovdDhxg1RnPYUwAxhazbep00KODOrGj+QJIHZYJ6GnMQFg6rAbZR
	 9iIL0U9DCbffg==
Date: Fri, 20 Jun 2025 13:29:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sha256 - mark sha256_choose_blocks as
 __always_inline
Message-ID: <20250620202936.GA5460@quark>
References: <20250620191952.1867578-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250620191952.1867578-1-arnd@kernel.org>

On Fri, Jun 20, 2025 at 09:19:40PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the compiler chooses to not inline sha256_choose_blocks() in
> the purgatory code, it fails to link against the missing CPU
> specific version:
> 
> x86_64-linux-ld: arch/x86/purgatory/purgatory.ro: in function `sha256_choose_blocks.part.0':
> sha256.c:(.text+0x6a6): undefined reference to `irq_fpu_usable'
> sha256.c:(.text+0x6c7): undefined reference to `sha256_blocks_arch'
> sha256.c:(.text+0x6cc): undefined reference to `sha256_blocks_simd'
> 
> Mark this function as __always_inline to prevent this, same as sha256_finup().
> 
> Fixes: ff8f037d394f ("crypto: sha256 - Use the partial block API for generic")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This is likely compiler specific, I found it in randconfig testing using
> gcc-9.5 on x86.
> ---
>  include/crypto/internal/sha2.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, applied to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

I have some additional cleanups to SHA-256 planned, which will supersede the odd
sha256_choose_blocks() thing which shouldn't have been pushed out in the first
place.  For 6.16 I'll take this straightforward fix though.

I don't think the Fixes commit you gave is quite correct.  I revised it to:

    Fixes: 5b90a779bc54 ("crypto: lib/sha256 - Add helpers for block-based shash")

I also adjusted the commit title to be consistent with what I'm planning to use
for lib/crypto changes:

    lib/crypto: sha256: Mark sha256_choose_blocks as __always_inline

Thanks!

- Eric
