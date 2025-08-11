Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77722D6E7C
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935154; cv=none; b=Nvz6y1bhzIJygxjo/7y4L88n6+hAkjvTnXjetp8+y9TSetkVEG+FG6ZV99uIzfPT9GjB4kjDomFcylU2mCo9XTTosbNvlp+NZop95mw+u3Pl3ZLlO2ERHxpIXvwUAP+iQdOQ99c4vc2WUCaQb8UVqqwmSxBRgdJoBjAsqMtpPNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935154; c=relaxed/simple;
	bh=uqajirfVkosPqsyAnl2TQotZWsCGCpVhDDWKXxPHx5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhdZOF1vPKvSwjUILCFxBkHjqGzsDaCLqfd7fJAroZqhR7ZQrnEI808gMIVaoyVlsp9TNxF1CTQswag7GaNEfU5KnDeCdL9SW+Ioul6tyHmYCVJb5g2kE+RuBEmMdLWoj8JNnic0/9uu8xjsKtDXsjGToHmvmR+dWnpgbQoeaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2GY8ySa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2GY8ySa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D66C4CEF5;
	Mon, 11 Aug 2025 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754935154;
	bh=uqajirfVkosPqsyAnl2TQotZWsCGCpVhDDWKXxPHx5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F2GY8ySa60AHv9ZWT5uKZeq6nwk6WvzbPDxjHNX9XIk2dFrzkqD0ghNuXxQPboKqL
	 k2vcW7Jzr+1z3plDkBpynUIsL4rx2IK+RI0D8ih+wTjktbHJZcSFkrTYUp7LzZ4pJl
	 UYVPJ8lvbp5g8H/Nr19JLXUsAfBCWdQ6RT9cn9KTqk44YMj20uMdpA3Nkg/J2YRX6m
	 XelId7JrxDwDMwXKGQkl0t3kCYQVPz6XYEAw7J3mab909H0x5vMEhdZ907dzS2tJxX
	 rbMv0zLkymEVyDgw8WdJr7DkWfHVvWceNtILJInGIjZ7Xd5+aplbYHhLK3HJokXS+c
	 bBXDmQNs4bAJg==
Date: Mon, 11 Aug 2025 10:58:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: sha256: Use underlying functions instead of
 crypto_simd_usable()
Message-ID: <20250811175812.GD1268@sol>
References: <20250731223510.136650-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731223510.136650-1-ebiggers@kernel.org>

On Thu, Jul 31, 2025 at 03:35:10PM -0700, Eric Biggers wrote:
> Since sha256_kunit tests the fallback code paths without using
> crypto_simd_disabled_for_test, make the SHA-256 code just use the
> underlying may_use_simd() and irq_fpu_usable() functions directly
> instead of crypto_simd_usable().  This eliminates an unnecessary layer.
> 
> While doing this, also add likely() annotations, and fix a minor
> inconsistency where the static keys in the sha256.h files were in a
> different place than in the corresponding sha1.h and sha512.h files.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/arm/sha256.h   | 10 +++++-----
>  lib/crypto/arm64/sha256.h | 10 +++++-----
>  lib/crypto/riscv/sha256.h |  8 ++++----
>  lib/crypto/x86/sha256.h   |  3 +--
>  4 files changed, 15 insertions(+), 16 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
