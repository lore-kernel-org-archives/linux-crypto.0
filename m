Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12ED31AF3C;
	Mon,  3 Nov 2025 17:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191411; cv=none; b=EoqJi1kZIXup2V2i6Dv2O5m2/Xien1C+Bq5ErsZnflAe82mW0ZtFh+7GKE0elsDZlXWaU6HF2H6yMiCHc5WR7b/zwAf+Gu9w++iQXnIk6/+yiZEU8emJDURs/x6fDfpg8vdyDxh9zX1DbTeCT+KgDcpWL7+x0GbeS/IzqqOxA9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191411; c=relaxed/simple;
	bh=RT/KjfpFsFH8lkq+Zj6GW/iKKp9K1F7T3uWdzH94VzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UpXpNvB7uC85wx5W6jIrtG+FvemJyXq7jChP+0a/l91dSZmmYevoPvDMOS1SaU8X01diDipESdnQ4Ybh2xazVKpf8Y2bRPx7I4fAq63/ZL+AozIjIk6VFxYMXK6oVfdWAIxFPP/BzOn7pa7xkPApW8itvgAIF9NOb8bF3DHlQPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0ojfsKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0ojfsKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22133C4CEE7;
	Mon,  3 Nov 2025 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762191410;
	bh=RT/KjfpFsFH8lkq+Zj6GW/iKKp9K1F7T3uWdzH94VzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n0ojfsKQVvgJZHw/MqBgX2n1kdLlaljE8QjOJc/q9ftJQnD08JS7jOSHRrUZl5QIv
	 kB+lVQkDQTH+4Qpee7PsuXxWGn9hG+brQyUctnq7q3ND0MsB6aKQQj2h0mW22DYy+z
	 c52pCvThqh56ocHiSNDyvQqrNTwp7QrqmGFwm0Q/kVXQGA0MbLAqIAyTi2DfYQiUGP
	 aWgl5f68Sg5FfSKPxzfIIaasKsPTIUmm8A1uJfIDVz6dvp+PWBAZdZCUsUtrsKTua2
	 kM3C7thnR/uN1lir0SJO/95962bkYY8eFPSER94PU+K1zrtPvvb7cCR1wc++fPuSzU
	 Xn60tcnAz347A==
Date: Mon, 3 Nov 2025 09:35:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: arm, arm64: Drop filenames from file comments
Message-ID: <20251103173509.GG1735@sol>
References: <20251102014809.170713-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102014809.170713-1-ebiggers@kernel.org>

On Sat, Nov 01, 2025 at 06:48:06PM -0700, Eric Biggers wrote:
> Remove self-references to filenames from assembly files in
> lib/crypto/arm/ and lib/crypto/arm64/.  This follows the recommended
> practice and eliminates an outdated reference to sha2-ce-core.S.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
