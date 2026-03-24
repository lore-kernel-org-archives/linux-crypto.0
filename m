Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95AB1684A4;
	Tue, 24 Mar 2026 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394842; cv=none; b=OITgUNolQJNmkpml/KX9XLy09x7X1JSN0mH9+4/j5nfpiHrJLfIJ6TMqEl5/E88CyQhG2Zh0tR5ctfmQpsIW2RZXTYm6IgEF10ybljmgyRLzwSVWWQXA61pv2bDIYU5lfwjmo4vEW0LpIzaom9i32zFvmslCHICh2EYH2Lx3MVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394842; c=relaxed/simple;
	bh=7Vksh/TZbAbO2ZdMTl4B7tAMqUDtCF8BMGNIcRTQQSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsCeoafKBOdbpAFfXTz4vsRBBtKGJYqqMcCPMmza2G0Y6l5D0uJ+IBUYL4YC+n0lTUbCFAcbF2L2d2qPfuvnoffS2Iiu6GsEr18eH6zOxNA2d0C3AhwgR9Q9vzSnkmXMZVGBAyYy5HytjJ6UfBWbK9V5G2cNwQLgwiNL1qk3uuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4Up3lKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4Up3lKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233C6C19424;
	Tue, 24 Mar 2026 23:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774394842;
	bh=7Vksh/TZbAbO2ZdMTl4B7tAMqUDtCF8BMGNIcRTQQSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n4Up3lKqsTJ3zA02PVZEJYOgzoUtGJISGUakPl4rAUImUrn+UgsknQlJHaRjt57lL
	 8JWg8RWsV4B0DKiXiKQj4ruMsCnTFfp2DZ6VPmpx+EVpkyylr4eNa2eBM1EB04qYbE
	 cgUn6EaeXjb8IRyke2xPHl48rwxIgKkfKqU7RMlyrwbLTcndVJ13JPflqV7/Q9kBL8
	 Vm7ml0IaPzD24ag4Th1J0lkTTd+t6EiJ8hI3W2P6VS9fu3o9c1BsUFkYxxsOLAioYB
	 fsrmsTXqx87TXptkHPy0kFW1xkhve7dVL93RwuLXwBU6feouEQQT6QFdwZ3ifla6q6
	 WFZPq95BI9Y/A==
Date: Tue, 24 Mar 2026 16:27:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 00/12] SM3 library
Message-ID: <20260324232720.GA3622@quark>
References: <20260321040935.410034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321040935.410034-1-ebiggers@kernel.org>

On Fri, Mar 20, 2026 at 09:09:23PM -0700, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sm3-lib-v1
> 
> This series cleans up the kernel's existing SM3 hashing code:
> 
> - First, it updates lib/crypto/sm3.c to implement the full SM3 instead
>   of just SM3's compression function.
> 
> - Next, it adds a KUnit test suite for the new library API.
> 
> - Next, it replaces the "sm3-generic" crypto_shash with a wrapper around
>   the new library API.
> 
> - Finally, it accelerates the API using the existing SM3 assembly code
>   for arm64, riscv, and x86.  The architecture-specific crypto_shash
>   glue code for SM3 is no longer needed and is removed.
> 
> This should look quite boring.  It's the same cleanup that I've already
> done for the other hash functions.
> 
> Note: I don't recommend using SM3.  There also don't appear to be any
> immediate candidate users of the SM3 library other than crypto_shash.
> 
> Still, this seems like the clear way to go.  It's simpler, and it gets
> the hash algorithms integrated in a consistent way.  We won't have to
> keep track of two quite different ways of doing things.  With KUnit the
> code becomes much easier to test and benchmark, as well.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
