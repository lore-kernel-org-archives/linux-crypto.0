Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B221617597;
	Tue, 10 Jun 2025 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749577307; cv=none; b=DdSu4+Vlgk0z2gWxPrqD/T0CS38KPArk5w4Zk8RtX97k0nR/NCFVMAq5BxPAE9OuEdtxCKLR1E93xf8QTia4yIWm1iLsCzq9VKT9jvKnyl19gdxi+Up3BTQCXnxbIuKGPi54Y6K1Ts18TSanXGyp/U5jjRKQhW2SNCL0RpYj764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749577307; c=relaxed/simple;
	bh=ShmDIz4IjwxKgsDsXKxC8zACRiS6yn9HJIhe64Yor0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pusGzm/oSie2HsWiG9Z3ZNyzibS8SCPAWRjZNd8oi8YW2TMVKnDx9Vhacv/BrA7ei3B5QoW7euvq/FfWt7JWr3KHa1Xxn9Sh7yh66MlknPS70IoVcvPGtbWxxKiiubZNeRn4Bfq27vtSvI7WRae3OgWWBIylkEwV03b2GUY/6ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=DHvk4QeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DHvk4QeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993A6C4CEED;
	Tue, 10 Jun 2025 17:41:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DHvk4QeI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1749577305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BXpIwPYy6cKJGLdxGbZzzWU5aohYEOBWm6g1ETEEBYI=;
	b=DHvk4QeIYgo8A6Xd5xEeAxl/GthpmjmXXtZQMUFUIxjy9iM7x5u24YSessQzufsLsBdvZ1
	ssbFbJfb/6q0chwVAsdeCjyXXncq1PrByld/UDKaVReTU/bIh5TUPyNhSEOjLtNQE6f6LT
	1ruS4PvxGND0eZWR0v44w11sf1KkiwM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dd2a51a7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 10 Jun 2025 17:41:45 +0000 (UTC)
Date: Tue, 10 Jun 2025 11:41:43 -0600
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] crypto: lib/curve25519-hacl64 - Disable KASAN with
 clang-17 and older
Message-ID: <aEhuVwzeY1LwxCNh@zx2c4.com>
References: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index 3e79283b617d..18664127ecd6 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -35,6 +35,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519-generic.o
>  libcurve25519-generic-y				:= curve25519-fiat32.o
>  libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
>  libcurve25519-generic-y				+= curve25519-generic.o
> +# clang versions prior to 18 may blow out the stack with KASAN
> +ifeq ($(call clang-min-version, 180000),)
> +KASAN_SANITIZE_curve25519-hacl64.o := n
> +endif

Seems reasonable. We've had a hassle with this for a while.

    Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
