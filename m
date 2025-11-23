Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE8F22B8CB;
	Sun, 23 Nov 2025 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763932403; cv=none; b=Zlsz3RzEzDCmUp6hDLmi9gbZ+HrVSdOrx4r21lYzJFo6QrbsrxYBegW9+t6S3Ph0qGZcBLeQvfTUw6h27q190Fx0oizGNR5zveXgSPIuUt1MiBx+BPYssZmv+KD4l8eHhVY1b5+NGkOoBayTWU+PYMP4mN7K8B1vvrXakOeqJmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763932403; c=relaxed/simple;
	bh=qot9aKr8UhiKhpzlxqypF15YYXmUh4DbYwXC7f0sRvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPrVc5SZRmMEwtpBsuY1YeOLv8v6hA3zWaXjB8kyHOo7IzBct+ic18/mZqXAFWMX+G4nozM0qHeQmSfJhrVcUsGFPMXJ0OhKVdPbKO6rqCJqCJGKeXL4YAHY4MhmUEcFmlFzfEmNwsmXgeVAOxKM8JcJIU0ky9iNkDRYAdAMjMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gW61p4t6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gW61p4t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAC9C113D0;
	Sun, 23 Nov 2025 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763932402;
	bh=qot9aKr8UhiKhpzlxqypF15YYXmUh4DbYwXC7f0sRvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gW61p4t6SnaxjJ811PhtLariE+r05qx9t/6jR045+2kDvX0xeZxCQQSVNyKe99iwL
	 lGCXUdtf0JbsI4w703J3dfOqrHXAGNy/Z3IcbqkTmVPKSFHoXhpncJkq6jJnlv7oMZ
	 5sDGxjJx10tdgjSVhL+Xmp3Wnao9pI5Fl02dIwKZ4owixsgCqttx4jJgyVW4gAXaYA
	 wphube11A+hQqJ85lgPKTYn4p0tLiY5vSI6FxfblzF3rVcTucV02j99D+E8wmCkz8r
	 5PRbWMZqvkYjShlxrjlq4bXUYdCdClRrmChBiWLQblhPf9KsV4jISsmxWxOHNOJz7F
	 1J2X7F+1I6BVg==
Date: Sun, 23 Nov 2025 14:13:17 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2] lib/crypto: blake2b: Limit frame size workaround to
 GCC
Message-ID: <20251123211317.GA3667167@ax162>
References: <20251123182515.548471-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251123182515.548471-3-thorsten.blum@linux.dev>

On Sun, Nov 23, 2025 at 07:25:17PM +0100, Thorsten Blum wrote:
> The GCC regression only affected i386 and has been fixed since GCC 12.2.
> However, modern GCC versions still generate large stack frames on other
> architectures (e.g., 3440 bytes for blake2b_compress_generic() on m68k
> with GCC 15.1.0). Clang handles these functions efficiently and should
> work fine with the default warning threshold.
> 
> Limit the frame size workaround to GCC only.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Since the below comments are mostly nits:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
> Changes in v2:
> - Restrict frame size workaround to GCC independent of its version or
>   the architecture
> - Update patch title and description
> - Link to v1: https://lore.kernel.org/lkml/20251122105530.441350-2-thorsten.blum@linux.dev/
> ---
>  lib/crypto/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index b5346cebbb55..95a48393ffb4 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -33,7 +33,9 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
>  
>  obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
>  libblake2b-y := blake2b.o
> +ifeq ($(CONFIG_CC_IS_GCC),y)

I tend to prefer

  ifdef CONFIG_CC_IS_GCC

when the symbol is bool since it is a little easier to understand.

It may be worth a comment about the warnings on other architectures to
help future travellers who may be tempted to remove this when the
fixed GCC version of that bug report becomes the minimum.

>  CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> +endif # CONFIG_CC_IS_GCC

This conditional feels small enough that it does not need this marker
but I guess that is maintainer preference.

>  ifeq ($(CONFIG_CRYPTO_LIB_BLAKE2B_ARCH),y)
>  CFLAGS_blake2b.o += -I$(src)/$(SRCARCH)
>  libblake2b-$(CONFIG_ARM) += arm/blake2b-neon-core.o
> -- 
> 2.51.1
> 
