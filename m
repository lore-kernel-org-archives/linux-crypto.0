Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF2C33AE8B;
	Wed, 17 Sep 2025 15:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758123333; cv=none; b=RO7ZyvgfOFu5A2b0A2vh/JcRLsXq11dNqSOfjXEC8gs99XF1kDhKAITPcz8pC984f7OPXBId5NeZbhqLhceyXfh5xq5gj/pn+rTjNBAbQoH17rJ9pgHDvB9Dv1gzTRMrtZpybjWEu6OqOGulTccbp8Wvw+Ot+HgoEl2L2QSZFpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758123333; c=relaxed/simple;
	bh=nZQmPYQCP3V4ITomeSxoV+uy8f0B16OIffQH9A20qOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KuzRN3ndeOILoHUatKE08bIntnr5VjkR862+6o5qUPYidNQz8NZYay6nYAtOHDFaBDsOEyNG0/kbfZhGPvU9BRKbx1t71hJ4V9/O1/7b9FHQbExl0SOaYJBR7Pvi+nJesqUkOWsIVszWMy4RnntbcsUekTpTtmpgqOVpyOrYSkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcMv7Zz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcMv7Zz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8896DC4CEFB;
	Wed, 17 Sep 2025 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758123332;
	bh=nZQmPYQCP3V4ITomeSxoV+uy8f0B16OIffQH9A20qOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mcMv7Zz6T6tGTriSDVWaKbFL6i2iWb3ourTAd4+bYfjU2Rexh0wG0hggzCTZG30cI
	 YFYE9m65FmPgEBFhgNuUMwxPFkgkINiIf/1akmcMsjS60AlxQxun1i4uAWfO7JWGGf
	 AJJXnIPxtDE6nCwIsK938pLgPaV0ob7Y0J105rmhUOMR6WzqtlXniKSUVHBaH69QaY
	 B0vFcXp2RUtB4awYOsUkXqRxbQc3zSMKWRlH249br1ifFKx5091v8D/PK4gsdzXrku
	 plfwG5WXHierR2Xvm/pWkEVUIxjfV8q8fp6PMObe0EQr9jI8RTbKwu/LEcjYZH9dzy
	 cf1XDAMp4lE8Q==
Date: Wed, 17 Sep 2025 10:35:29 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] Optimize fsverity using 2-way interleaved SHA-256
 hashing
Message-ID: <20250917153529.GA45754@quark>
References: <20250915160819.140019-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915160819.140019-1-ebiggers@kernel.org>

On Mon, Sep 15, 2025 at 11:08:13AM -0500, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha256_finup_2x-v2
> 
> This series adds support for 2-way interleaved SHA-256 hashing to
> lib/crypto/, implements it for arm64 and x86_64, and makes fsverity use
> it.  This significantly improves fsverity performance on many CPUs.
> 
> Later patches will make dm-verity use this optimization as well.
> 
> Changed in v2:
> - Made the new arm64 assembly compatible with CONFIG_CPU_BIG_ENDIAN=y.
> - Omitted sha256_finup_2x() from pre-boot environments.
> - Made alloc_guarded_buf() assert that the allocation succeeded.
> - Minor tweaks to comments and whitespace.
> 
> Eric Biggers (6):
>   lib/crypto: sha256: Add support for 2-way interleaved hashing
>   lib/crypto: arm64/sha256: Add support for 2-way interleaved hashing
>   lib/crypto: x86/sha256: Add support for 2-way interleaved hashing
>   lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()
>   fsverity: Remove inode parameter from fsverity_hash_block()
>   fsverity: Use 2-way interleaved SHA-256 hashing when supported
> 
>  fs/verity/enable.c              |  12 +-
>  fs/verity/fsverity_private.h    |   2 +-
>  fs/verity/hash_algs.c           |   3 +-
>  fs/verity/verify.c              | 175 ++++++++++++---
>  include/crypto/sha2.h           |  28 +++
>  lib/crypto/arm64/sha256-ce.S    | 284 +++++++++++++++++++++++-
>  lib/crypto/arm64/sha256.h       |  37 ++++
>  lib/crypto/sha256.c             |  71 +++++-
>  lib/crypto/tests/sha256_kunit.c | 184 ++++++++++++++++
>  lib/crypto/x86/sha256-ni-asm.S  | 368 ++++++++++++++++++++++++++++++++
>  lib/crypto/x86/sha256.h         |  39 ++++
>  11 files changed, 1147 insertions(+), 56 deletions(-)

FYI, applied to https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-next

I decided to use the fsverity tree instead of the libcrypto one.  There
are no dependencies on other libcrypto changes for 6.18, and this makes
it easier to do a separate pull request.

Also, as always, reviews and acks would be appreciated!  Note that I
dropped the reviews and acks that were on the original crypto_shash
version from earlier this year, due to changes in the patches.  The
high-level idea is still the same, though.  If people could
re-review/ack this latest version, that would be great.  Thanks,

- Eric
