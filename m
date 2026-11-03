Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748294;
	b=p+yarn5MMErhJ56ROlPcmHELeVPZhqDWQLLZbrYKgQQK0Vajyie07ALO0Af1M3Gvu53w
	 dTuRZBow1tOjbXFaUDbhtUB3FXi7RzUIFoy8FTasdr9fROyEwhSLyeCguREY5jGeDkEz0
	 4ETnsEg2rv5c3MCw1BcONaYaCtTsdU6RFfYmwlNpiE23ERlsW+xd/b3LPIOhzAgSPRD1q
	 gnb9iORkjPxpyj8qolop95b6zukiJ0sEhvNgeMF0InYilaG/aDOFcRfJ1GIh3UYkUDUSl
	 tzSLHDnVWNO0/NJo7/0v0NklJ5qlV2dTlqoSf1OF06m1d3J2Zz8lyr0z5UO6C+VD/aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748294;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Ub33AwiTbl5j5ejD0YdroRfi93xSlsqCkCfErBeCvDQ=;
	b=yZ3v+atglVsIVo7hmdyue884Hw3nYQxvcDo9xvPWwOKSh/gg9ZSgGZdcn6AlAxniT/kU
	 5MREXsxIF1k1N2kQiS3NBZ6qQ9t8M7x3Y3sNsNgaPI1JOCfW/0aEsvga44U5KerOAAvN9
	 CPuMTy5aavCHb7qShxwDULpdYDYFkd6i6WW+rnTC0P+5tzhR3bPn+cDkz9sU1iu/46PYk
	 ro4eLNuaYl2Ya7LTkOcqcqFDYeLgpS09jv/I0BH1sCMVJWRfG8Rl7KabHWRFYykbBgqpQ
	 rDuSSZq/BfSMxxuNqAsmbfA8KTGQak152ByWetoWBfsJ9hYTfj6dRTpCw888Kdd8Azw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=as5bvSmr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1349606A31B;
	Tue,  3 Nov 2026 23:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=as5bvSmr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF941F0093A;
	Tue,  3 Nov 2026 23:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748293;
	bh=Ub33AwiTbl5j5ejD0YdroRfi93xSlsqCkCfErBeCvDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=as5bvSmr4tCB0xxH1/aFLd2ZB398jBjfJ9zs6u5RRa950j9pkoKghrGGJYG/PHIVb
	 eifE8dGAjfgdDFThQFHcrH/I5XS1Vo4gvrICxIxL0giwMRm6Ez7EAIVBkbAKUpPWDl
	 WZHRkvv22/2h0p4gEFk00mBvUt28JQ6JELZEC6tXHkBBHOVGkrGfxhOJA89Jf7uXEk
	 +4NH5NZ+z/EfgPp9UnnatW7C1m1ZVC9J9u8yTmna47hVGeX9IYzOKHQKH0lNFGTEaR
	 ZV2JGQAugs+Qmbj1x/LhHAAVVx8Yisvqsv3G+Cdxz2WAn6Hu4XKtVkvKNUNbRpOWd6
	 G7m49I+QfpneQ==
Date: Tue, 3 Nov 2026 15:24:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Tzu-Ching Yang <shingekinocore@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Jose E. Marchesi" <jose.marchesi@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] unroll: Drop the unused unrolled and unrolled_none
 macros
Message-ID: <20261103232451.GE2281@quark>
References: <20261023163108.2042675-1-shingekinocore@gmail.com>
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
In-Reply-To: <20261023163108.2042675-1-shingekinocore@gmail.com>

On Sat, Oct 24, 2026 at 12:31:08AM +0800, Tzu-Ching Yang wrote:
> unrolled and unrolled_none are object-like macros with lower-case
> names, and neither has had a user since commit c6594d642717 ("unroll:
> add generic loop unroll helpers") added them in February 2025.
> 
> The name unrolled also breaks code that uses it for something else. On
> GCC the macro expands to an empty _Pragma(), so a function parameter
> named unrolled compiles with only -Wunknown-pragmas warnings (errors
> only with CONFIG_WERROR) and silently loses its name:
> 
> 	int add(int unrolled, int x) { return unrolled + x; }
> 
> builds as "return x;" with GCC 11 to 16 (GCC 8 to 10 and Clang reject
> it).
> 
> Drop both macros, and retitle the kernel-doc comment from unrolled to
> unrolled_count(), the macro its usage example shows. unrolled_full and
> unrolled_count() stay; any clash with their names fails to build
> instead of compiling silently.
> 
> Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Link: https://lore.kernel.org/all/3c25921c-7bdf-4edd-ba06-838dd1765db6@intel.com/
> Signed-off-by: Tzu-Ching Yang <shingekinocore@gmail.com>
> ---
> v2: drop the two unused macros instead of making all three
> function-like (Alexander Lobakin).
> v1: https://lore.kernel.org/all/20261016025613.2690485-1-shingekinocore@gmail.com/
> 
> Eric, this version no longer touches lib/crypto/. Would you still
> take it through libcrypto-next, or should it go through Andrew's -mm
> tree (unroll.h has no MAINTAINERS entry)?

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
