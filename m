Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E016370808;
	Wed, 10 Dec 2025 00:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765326631; cv=none; b=LS7bpHPE9Im5ssQw8mKytD5iQzrE5UugVzvk5G3X+20aQPtTqesyZsNxIz7iNUJ8BQlLo/Xedj5F/KylmBc0mFGiMbt5kib5myItMK+Y5b6pThzbNHgVaCBgNkeoae4MPTtOP2Zvhd94FsLFeYc26s+iDXafT2XQCkxXWHHcr6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765326631; c=relaxed/simple;
	bh=TmJNhm+njmALNP3L4ljbZmBzGPihgoVSO4K2zy5v3ig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EE2pAkb7B7vbJGdD9qOyuY7FigQNQg9Ic9gxvoe62KdqEQDql7wquSod7C1fN6sd+gZgyv1wCpvm8B7KlJwV2+wO32VQNbxJZ2VmJColI04+9+Zz3PN9ctwC3wG6YwfAYAcyXoegfU2rv2RLU0K4KU7HOThJ8+Kt5Bqqpi48iwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8XbRskD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8XbRskD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F205C4CEF5;
	Wed, 10 Dec 2025 00:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765326630;
	bh=TmJNhm+njmALNP3L4ljbZmBzGPihgoVSO4K2zy5v3ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R8XbRskDJulZRK8C6nooZbSqEgU+UpEp+g+eU99P+IUAB2IiXMmk4J3wDPvTZJtcx
	 uvhwRvzwaz/x5qzVLm+yMR3BrozWVHrya/vFtP/+0+Z/9agSRJJk17n2m72cvG6BZO
	 XVAkeXyf5XNLxTzi0FM91j1V9/+eFG9wqF7XOpG3e4rj3ill/PQi8tMHUIEkNqFMy0
	 rEh2nW6TDLoZKVckOm+kneWHOUDKIf43rXZQjL/39xaTmQpSuMYiOnJvmBjc14eSGc
	 C6kNZcdeyeasQIqWwEKas8/xbx7iLCJX9o8rQ6sNum+qqSOZzCoxAEi1Ct3w6HQ2P3
	 cgDSi9tEXL3kw==
Date: Wed, 10 Dec 2025 00:30:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	Diederik de Haas <diederik@cknow-tech.com>
Subject: Re: [PATCH] crypto: arm64/ghash - Fix incorrect output from
 ghash-neon
Message-ID: <20251210003028.GA1783653@google.com>
References: <DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com>
 <20251209223417.112294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209223417.112294-1-ebiggers@kernel.org>

On Tue, Dec 09, 2025 at 02:34:17PM -0800, Eric Biggers wrote:
> Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
> handling") made ghash_finup() pass the wrong buffer to
> ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
> outputs when the message length isn't divisible by 16 bytes.  Fix this.
> 
> (I didn't notice this earlier because this code is reached only on CPUs
> that support NEON but not PMULL.  I haven't yet found a way to get
> qemu-system-aarch64 to emulate that configuration.)
> 
> Fixes: 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block handling")
> Cc: stable@vger.kernel.org
> Reported-by: Diederik de Haas <diederik@cknow-tech.com>
> Closes: https://lore.kernel.org/linux-crypto/DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> If it's okay, I'd like to just take this via libcrypto-fixes.
> 
>  arch/arm64/crypto/ghash-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

(As always, additional reviews/acks still appreciated!)

- Eric
