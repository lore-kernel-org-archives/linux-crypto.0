Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267C82FB989;
	Fri, 17 Oct 2025 17:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720709; cv=none; b=odH8Ru+pzLVWPEiuPBe4WH4LRzr6BJZpvz1aDaC+H4UtjpUHvdU+9taCXIu3rscY8gHDLCzv2WR9itB9V4F+x3sI3CqB8Sek3D9dBvjUmpSS0phGDM0as0+7rKg9Q6JZJPkAekOZXAEaWKzUNLDarAdDr50tAE8YITubGsunwN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720709; c=relaxed/simple;
	bh=ZzqvD5CR8Z19/7B84GmUXyMCiquP30hbhl+Hs/ZEsP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVKgThcMuggRcdxyvPYwJpzpxQE3nGd0qItzkNiAu9rPnpkahyotTpqQIVnQ14P6f2aPwgdAtnTinMzpz10oIwPfJj35CopejwZOjZKv7c3rjNaYQx6PrWHF0umrYnX0BK4f6eIkEoylZEroqYy92ZcQ0lfNqpnULdKUsRwTyPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDxL0QfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDxL0QfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CE3C4CEE7;
	Fri, 17 Oct 2025 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760720708;
	bh=ZzqvD5CR8Z19/7B84GmUXyMCiquP30hbhl+Hs/ZEsP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GDxL0QfDK4x7YqA+7gEMgd/gRq0/xeuBwqPC4chpeMImVSMF/zD8eFv23kh4oCF/c
	 es1UfR6MRAnT64y6sLzk2Dbd9Lh+3w067LmpqM9NRxhOmsMjE2Esi9dms3f/uI21h3
	 tAaIX/0WBfkzLVUyYTzpSe4DUu1M3pe5M3bEyHKLKPYp9zk00CPlNgM/1Z1iZVZA63
	 NbRch/mX3EoOoSVtdvSVe1DynZqNQWs1hv7LQ1ABZtuczQmZmGdRElIS5wjLo2vjjv
	 5VBtLJebljSBvIHi2gM8H6/XTbiexK5uBQLR6qq9CyMLD0r1gsGykbuokaavqReClC
	 o1aLmKdRKxhag==
Date: Fri, 17 Oct 2025 10:03:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 02/21] crypto/arm64: sm4-ce-ccm - Avoid pointless
 yield of the NEON unit
Message-ID: <20251017170335.GC1566@sol>
References: <20251008154533.3089255-23-ardb+git@google.com>
 <20251008154533.3089255-25-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008154533.3089255-25-ardb+git@google.com>

On Wed, Oct 08, 2025 at 05:45:36PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it when calling APIs that may sleep.
> 
> Also, move the calls to kernel_neon_end() to the same scope as
> kernel_neon_begin(). This is needed for a subsequent change where a
> stack buffer is allocated transparently and passed to
> kernel_neon_begin().
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> [ardb: Simplify convoluted logic]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
