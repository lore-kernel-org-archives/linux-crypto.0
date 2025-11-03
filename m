Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF6E31A579;
	Mon,  3 Nov 2025 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762191391; cv=none; b=ZtGDnbFlmefWU+zlEAwy1a3c/TD5zdX8L+QfV8qW7xFQ5ywS3a9mPb1AdtufdfSOdBC0kuczid7qe7zm2RqxcMX1RxSBz2ulHfXEGUfYvwjJoeirbcmFgN9jSiwA5WK68Gj0nwnipFL9MrM1pyiCKn4SaQCSvYRl+uS41XDLEy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762191391; c=relaxed/simple;
	bh=9EcSpTnGG+3lF1LspBXYvB/oLK+tUJK+pPR4eGAWoF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgbbFAdH+4eUK6r/41Bg+xPUCZb58vW5ScO/213llH/bEEHsQ7rNuz1mT9YR+KX8x5y59bDKmbJynjreo+rfC0PY5QrUZp7aR032c9kQGtMLerNbg1kfj45Y8WdmhIk4kRtGme1R2KG0Otf+uplxMFpInxnDGDmJBCw54oVeShc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KubwgKY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KubwgKY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A529AC4CEE7;
	Mon,  3 Nov 2025 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762191390;
	bh=9EcSpTnGG+3lF1LspBXYvB/oLK+tUJK+pPR4eGAWoF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KubwgKY0KUWVM7l32G93OfNgqEAOEsAC8ZB6ZzBpRG/tHOd+U4kcNVvPR0geDHYY5
	 5tSwUj/WFukSVhgNqwfCXw+lJ7lFrl68S9RgvusAZYrFniazel03A9N4oBhjv0Ha7j
	 thaFrVS/Zn4MNWqXY7y/cKCG/Cl/ts/PGDw0k2/0VJh0aWgfLh4xZPTKz3P2TIH46u
	 RT3j5vIYjCQLKeG9FOtYLl6Hh0sTx4hwHvJc9Ai4VO9L+KYWrp/hqxUbKrfRx8vd9h
	 VM26QhMcg9hpiAukTzEYORdExDHsp4yVRs/ZTmLfZV8jdEGsat/T7AvWecGKwTm8/3
	 l+L02LCN6R0Uw==
Date: Mon, 3 Nov 2025 09:34:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] lib/crypto: arm/blake2s: Fix some comments
Message-ID: <20251103173449.GF1735@sol>
References: <20251102014541.170188-1-ebiggers@kernel.org>
 <20251102021553.176587-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102021553.176587-1-ebiggers@kernel.org>

On Sat, Nov 01, 2025 at 07:15:53PM -0700, Eric Biggers wrote:
> Fix the indices in some comments in blake2s-core.S.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: Fixed the same mistake in another place.
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
