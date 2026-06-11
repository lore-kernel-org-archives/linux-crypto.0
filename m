Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B4B3672B8;
	Thu, 11 Jun 2026 20:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781208379; cv=none; b=UkASyhy6IMiOTLERzk1UDggwe8lFA+r36M053eKyU1fX9conh4M1h2/wpvxDCIerPZQxtJgdfe+r9Wd18u2+gYhvRdc5rjDT5BzH1U79H7+gMo7iJutwRmSsDWJFJA4c2PsojTPhkH3y+8LMbiUvpiCZ9NBW3HWWtJ6/JvQBOqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781208379; c=relaxed/simple;
	bh=qwzD9S9Y4owA/pvTxXepCbpVFgDE1i+3P5YhmoD1LTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dYXCv4632rnzRfUmtllNSo00RytYnohTKToDAqPwEce9We3tPW9B1Re8kVk52tV4UK+PwtWmOx8pYWtMjbc2rOShfYjmafnxivQJ+10m+7+1jWMtUQeyMP6JNc5stsRYwHyDZcblVYYXo1yCQBVd15mfvOk/B6dV0ZOVwIk/b+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xg7Fuhsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xg7Fuhsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6041F000E9;
	Thu, 11 Jun 2026 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781208378;
	bh=zY2hp1dArk0UoN5n3fkWpXplSZVVooBTr/ql6+NZrvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xg7FuhsfqiLPUpYZF10TG3Kuns14rm95gMOe83P3fp6umx0otuvcWYCFtC7jcQvxo
	 Thm4hbedlhyL0m+KNebrLVpyYSjsdGbsC29b/4r5iVpKTZ59wrqTmxf12DkYWANVH3
	 z5/+8Vwo5xkGBjXnZEYqibfFn9AzrBiP1eM4WcpBiPI0v/VnqBgGgyxGAHvSQSGom9
	 J6Qp0dMFFL+NZexgEL195yP12z/gaua/D4elO0CUM64aC1SK7CgZgKOkrw1Sn4uDC4
	 apAQFVTtJec9PU1HhuB+epv2+PEi8ARUeeHIDLplds790/GP9MnVxrB6+K1X99QnsS
	 739b+WBnikScw==
Date: Thu, 11 Jun 2026 13:06:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] lib/crypto: gf128hash: mark clmul32() as
 noinline_for_stack
Message-ID: <20260611200616.GA1747@quark>
References: <20260611125952.3387258-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611125952.3387258-1-arnd@kernel.org>

On Thu, Jun 11, 2026 at 02:59:39PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> During randconfig testing, I came across a lot of warnings for the newly
> added carryless multiplication function triggering excessive stack usage
> from spilling temporary variables to the stack:
> 
> lib/crypto/gf128hash.c:166:1: error: stack frame size (1192) exceeds limit (1024) in 'polyval_mul_generic' [-Werror,-Wframe-larger-than]
> 
> In addition to the possible risk of overflowing the kernel stack,
> the generated object code surely performs very poorly.
> 
> This only happens on architectures that don't provide uint128_t
> (which should be all 32-bit architectures on modern compilers), but
> though I tested random x86 and arm configs, I only saw this with arm's
> CONFIG_THUMB2_KERNEL, which adds more pressure to the register allocator.
> 
> The testing was done using clang-22, I don't know if gcc has the same
> problem. Marking clmul32() as noinline_for_stack experimentally shows
> all of the affected builds to completely solve the problem, reducing
> the stack usage to a few bytes as expected.
> 
> Since u64 arithmetic frequently leads to compilers badly optimizing
> 32-bit targets, keeping clmul32 out of line is likely to help on
> other 32-bit configurations as well when they run into this problem,
> though it may also result in a small performance degradation in
> configurations that would benefit from inlining.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
