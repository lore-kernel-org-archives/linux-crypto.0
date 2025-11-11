Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B866A325712;
	Tue, 11 Nov 2025 19:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762889396; cv=none; b=K/PArSr8VJVJb3WsopnDB+s/aoC5q3sweeeABnpaxdG9Bt856s4i0J+tTvlvZVIKUX2z2RrzyQpIgmjzKSZ/BGunGtnKi9aSz+IVmPxpNuLNy4mg1Ar2RzPw4N/FIU6HblcUqdPG60eTTGUnxZBB6Lf1TJcW4lQY2/ldAgXQXoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762889396; c=relaxed/simple;
	bh=QEQRyRtbWV2VK7CgqH0yvvXph5ozEnh5UmyQPeLfVak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IEFii/h3LxwbJCa80QPDqDy7Fw5KNx5yykLve58OCPLONJUvrAb1G1o8QGtxIqwi8uIK9kAo0RT0TWaDzBp/OVmeyLR4i1WDi9oxxjra/vXxzQOkUHz8Z/SmJRy1kGsFm5wtpgihiPJ1RaERJ5JpT1uNb1QUN/9BJ0d/DkNW1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIO2W4Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIO2W4Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAC0C4CEF7;
	Tue, 11 Nov 2025 19:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762889396;
	bh=QEQRyRtbWV2VK7CgqH0yvvXph5ozEnh5UmyQPeLfVak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jIO2W4OtgKY8Tu7AnSbQwCcBHruQkERn9khHXG5ZP9BkFDGtNiLrOEt8qgyIIiS7a
	 Q16FiKtsbrCwHX4c6inNBoli/nGF3K6U6ryZF3NIk9W8U1qYo0T1YPfshZZ2QqU55q
	 ctougBfuUO26wUOAEkGD+cvECce2Qv4IaLwvlKNUFbtS0oZnkAx13sdupkf+VvVEUA
	 0dxzWNpdDA26tHFOfz2apRmUjhcPUkqmpkuV64/xyVFdd7+LHkKJpBKSSKTaSllMEe
	 OuLl0gVinFmgCF44b6Db5HkTbX9yBV4Y7lTY63mi5MTmcVncvrgHL3hS3GjWnBcAtr
	 O8cu7OLX4j1AQ==
Date: Tue, 11 Nov 2025 11:28:15 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 0/9] POLYVAL library
Message-ID: <20251111192815.GA1748@sol>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>

On Sun, Nov 09, 2025 at 03:47:15PM -0800, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git polyval-lib-v1
> 
> This series migrates the POLYVAL code to lib/crypto/.  It turns out that
> just like Poly1305, the library is a much better fit for it.
> 
> This series also replaces the generic implementation of POLYVAL with a
> much better one.
> 
> Notably, this series improves the performance of HCTR2, since it
> eliminates unnecessary overhead that was being incurred by accessing
> POLYVAL via the crypto_shash API.  I see a 45% increase in throughput
> with 64-byte messages, 53% with 128-byte, or 6% with 4096-byte.
> 
> It also eliminates the need to explicitly enable the optimized POLYVAL
> code, as it's now enabled automatically when HCTR2 support is enabled.
> 
> Eric Biggers (9):
>   crypto: polyval - Rename conflicting functions
>   lib/crypto: polyval: Add POLYVAL library
>   lib/crypto: tests: Add KUnit tests for POLYVAL
>   lib/crypto: arm64/polyval: Migrate optimized code into library
>   lib/crypto: x86/polyval: Migrate optimized code into library
>   crypto: hctr2 - Convert to use POLYVAL library
>   crypto: polyval - Remove the polyval crypto_shash
>   crypto: testmgr - Remove polyval tests
>   fscrypt: Drop obsolete recommendation to enable optimized POLYVAL
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
