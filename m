Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92C2D3750;
	Wed,  8 Apr 2026 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775681872; cv=none; b=BnDuhZbXXwDuoiiLkhyjKc8eTZGq6MH7mC5/TYMEw+/PrLCOqcEoNpphjbe7jNPe1mDMNmHjg2kwmBr5AsqSMKZcLDo4ajENMcKRc+Vqaav6kdnL7/v06KhrazWks8D5ifiFqBkNVScH1p6iCnb2MQz5Eb6q4Rv3Dc/Mg5Ea6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775681872; c=relaxed/simple;
	bh=8auXtSzLuQ4lqJdpdSvIYUcs2qq1su7sg5k5rP4onIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCdi1/Ii9aIp/cA6OCFhEGHtKuMdbtZD8iMLt8eU1sTGF/bxiI2XA7caKCnLCXT5XkQvnOQ2/HNRgT9U/NCGgaRNchM5CPx4+bvd6gHJeA/5C7t9UDAifxETQ+A5yr7Xcis62pZz0R/1jhH4fPqfpS0M4HIizbo4cIhr2oSlK3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1Dyob8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1Dyob8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B392C19421;
	Wed,  8 Apr 2026 20:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775681872;
	bh=8auXtSzLuQ4lqJdpdSvIYUcs2qq1su7sg5k5rP4onIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n1Dyob8mII7PRXrdNqmJPv3JADBdvehkHZMKbZLfkz4C/2wnDGU5aipMyhBc5uDuD
	 yh/GZiCfvDcQuYsXw2Uhyagz/qOEPNU2vMTs0PK7cka7IW06E0SjFUCIpy25/WgC/v
	 MnYthtOq6vQ4tBRu3SPK2oEY7Wc+RjGiXG7TVsRSvnyuOPYkNDzC6NVjoKoaWyjW3t
	 mEg9Ep0pu4Z80oOQ502dwU3IffkslyB1HSYVOsXheHGlNzeVfx+fw+q7x/yMGdf+aU
	 sAC8HTGpsSfS+etQF5d/eN163pGiRyyc07fjbskmIudmUgIFk10tMJhbmMpG268yMT
	 1im3SxucIDRSg==
Date: Wed, 8 Apr 2026 13:57:46 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <20260408205746.GA2877926@ax162>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>

On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
> Andrew reports the following build breakage of arm allmodconfig,
> reproducible with gcc 14.2.0 and 15.2.0:
> 
>   crypto/ecc.c: In function 'ecc_point_mult':
>   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> gcc excessively inlines functions called by ecc_point_mult() (without
> there being any explicit inline declarations) and doesn't seem smart
> enough to stay below CONFIG_FRAME_WARN.
> 
> clang does not exhibit the issue.
> 
> The issue only occurs with CONFIG_KASAN_STACK=y because it enlarges the
> frame size.  This has been a controversial topic a couple of times:
> 
> https://lore.kernel.org/r/CAK8P3a3_Tdc-XVPXrJ69j3S9048uzmVJGrNcvi0T6yr6OrHkPw@mail.gmail.com/
> 
> Prevent gcc from going overboard with inlining to unbreak the build.
> The maximum inline limit to avoid the error is 101.  Use 100 to get a
> nice round number per Andrew's preference.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  crypto/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 04e269117589..b3ac7f29153e 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -181,6 +181,11 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
>  obj-$(CONFIG_CRYPTO_ECC) += ecc.o
>  obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
>  
> +# Avoid exceeding stack frame due to excessive gcc inlining in ecc_point_mult()
> +ifeq ($(ARCH)$(CONFIG_KASAN_STACK)$(LLVM),army)

Please use proper Kconfig variables here.

  ifeq ($(CONFIG_ARM)$(CONFIG_KASAN_STACK)$(CONFIG_CC_IS_GCC),yyy)

Which is both more robust, as $(LLVM) may not be set but CC=clang could
be, and it is clearer (in my opinion). If all supported versions of GCC
support this flag, you could drop the cc-option at that point.

> +CFLAGS_ecc.o += $(call cc-option,-finline-limit=100)
> +endif
> +
>  ecdh_generic-y += ecdh.o
>  ecdh_generic-y += ecdh_helper.o
>  obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
> -- 
> 2.51.0
> 
