Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793570429;
	b=i+ThxsmTyLft6XYLheSfZBDGFSr8RyEqIzeOvbLkDn+z/WAht10CO38ZpuTRS8tqc74W
	 Khmw5WdFSxq5B9dKTWkEexY/PlZPOZrGxTNAjlXyM8WplbyjTsODASgn8C54kfdanrmuF
	 YeQKi/dJePVzQbjcAWjQpf6BRHnyJaAEw1UQerVKfCeuu4pzMxvP8sMe2UnZhy4H66EIK
	 p0QhsX/O0Ubq2604tiCT6q1i3wUphZNnB47RCbA/j4ixMYazLr+M8x1nObNCvbJKTqL6F
	 qyhPH6vXu3mSTlm0z4tytIsjYytyA8lALNm1ljxJM2m5S22aZc8ej3IVufDXhsIdJDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793570429;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/NsG/k61SgKGNBtT9Y6zpwIPwXzGtY/Em27D4FxMuwU=;
	b=koTKq8oSJj+UIlxpMIGNfMOqC2Lxkq8cC9yKz84hMwhwahPb/G7YP6NP/asGJ3X1qE0+
	 T4KBuyeCpjXTbxxI2peFQa6XZM8nigkfgndobkq2V4HxEZftjS5wexHaOK6GVg5JTZQoW
	 PPfEui/uqPIgMTz8pqIaXtDUJHTqLXMeq1880q3vTVV2Bq8tMZuGKzT0gAGwiYdDfpZzz
	 dBtQO+wyBkxLuhohSFbYCwxSYPYvg9s5ZgsfBTI3cPyRZslb2IGII7Of7sT+u1MBvcKV7
	 IqW4F/peQ1oypjZ4T+Nuby+nr9bNn+f8tZsUPWg2WSkDdhNCQaQSxRc89VLUN1oy+tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wy65muEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A671A606A324;
	Sun,  1 Nov 2026 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wy65muEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239F51F000C1;
	Sun,  1 Nov 2026 22:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793570428;
	bh=/NsG/k61SgKGNBtT9Y6zpwIPwXzGtY/Em27D4FxMuwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wy65muEI16UbrZF8U12iYKWcfYfjwFOUGE0H6XtVmJWBES/b0HMQ2fT1EzAHv1lF8
	 iCW7h9wKfEpEwcPR7VT5peJrj2MdNydheEh1x2Q1dZ4d0WiJx+EekeZRjIZyoeZF6u
	 r2BG/TJJVIntRCze78IhKBwsU0/ZqZ+mSLYdaAzE9jH0xXZi5jvx2NAeDIt6Bf7Cpr
	 fx64tbOhwXEZQR/jYcmfJWdvzpfOZMSvchV7wEGNdesPe027vOIF08sKw1pnbYquqG
	 /8XyRaKRf4OqaYsoXWVSyhnq3Nu3/t4SUxk+Am11vAhmzruXaJv7NDZ5gttz6bN0iw
	 ed8T8mCSiRuuQ==
Date: Sun, 1 Nov 2026 14:00:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Message-ID: <20261101220023.GA2689@quark>
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>

On Thu, Oct 29, 2026 at 02:50:20PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Recent Clang has become more finicky when it comes to overriding the
> type macros that the freestanding stdint.h consumes when defining the
> uintXX_t types, and so it is time to finally get rid of this entirely.
> 
> So instead of making stdint.h (which comes from the compiler when
> -ffreestanding is set on the command line) agree with the kernel's
> linux/types.h header, avoid the latter entirely in the compilation units
> that actually use the NEON intrinsics (which are always leaf functions
> that are not tightly coupled to kernel APIs).
> 
> Note that the disagreements are about long vs. long long on arm64, and
> long vs. int on 32-bit ARM, so never about types that actually have
> conflicting representations.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> 
> Ard Biesheuvel (4):
>   lib/crc: Don't include <linux/types.h> in NEON intrinsics code
>   xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
>   arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
>   ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
