Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792865722;
	b=3A4v3mYurf9U6ahnEpVZT0AzGlMzZiGgiiBkLDIIhz3HcJxq/SwBC3D4VaM0v1nNm8Gp
	 8myE7JLmQa98p2QPjZP03fksCce6+nPIbSBKVuXj58nx/hYyhXoV0bsHivWa2UFYLplBr
	 wIY6xt8Ms0/VkViZ4SW856k86xiEQ21F5/TmEMYO8L4mbDytSjuyMKipg54BZNr4NMuR2
	 OE8q+2844luwuNhvyN4CFo52dqcLY8txdHNuADNwglBNgFfWsLD3J1+sPGTUndO//c6y0
	 btROJ0CXzIp9IPEosucf7lbhjnZjAbDHX0IJASct2fqoU0PHzXSQh6Lan2nz7ocOa3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792865722;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=O9Ghwq3YxLnhvg1SfUO5FnegZQBi1IXv8ieg5lnnI7Q=;
	b=bcYGa0QWXH2Q0l8IOhl+WIQ9Ufwyjwe19oGpjAms3cIG+MkHhngca+d/c09ok2vrXB5D
	 alhZs3HyOArQ3idkGQil5uuP5FvoC1RhO1/Nf8PO7yALsB6KlW8VA3jDGEPcxrFt54CVH
	 bSwD2sq1ld6Bsswo6K019VRq6a9FCPbrsGgAWJakcs5sN342oDs8BKudxcxiiV1JvQJk1
	 0MLEfvLj76KMAqvqvKoaz5+kdq/JUIbPPmK9iZCiXweDERiXw3N5UV5KgatNON3kW9qF5
	 ZYPkeNGlPKHrJeCJcj6Ws27Tq+PrxMGwbg4X1wLFHDWmR2SKn5qd9OH49KbnljqPBtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvGrMrvG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2FD606A31E;
	Sat, 24 Oct 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvGrMrvG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64401F01825;
	Sat, 24 Oct 2026 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792865722;
	bh=O9Ghwq3YxLnhvg1SfUO5FnegZQBi1IXv8ieg5lnnI7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mvGrMrvGE/e/jSEKo/DgqnRJPUNjna2wpdlxX2Ec0BR/fDd0WxSuVvLMgqj7i/L3N
	 ffeA+GKMJIymNIpTsN7uAo6AiQqTB0tZdujUuOVjlcyudx8LxmLqpVj5AzeQszkHiT
	 IPYSehQrViL+GsW4NSWQciNGNRLKp8klMpamXKmar52DVRr7y23lQnLbfm7Ruq59mN
	 N7i98HBxmt1AotvksZFqfKqZfG4keXiTEcTEQaFCfwLx439m7vl7E9PQBRO9IyByZD
	 Hdu7OjcxXZ9YcPM/yZW3a6D301YGJwhfdflx/OhLh/PXXT+VBzQg8VijdOcnoXlvv1
	 6Qg+gzj7RbDFw==
Date: Sat, 24 Oct 2026 11:15:20 -0700
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
Message-ID: <20261024181520.GC2553@quark>
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

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

> v2: drop the two unused macros instead of making all three
> function-like (Alexander Lobakin).
> v1: https://lore.kernel.org/all/20261016025613.2690485-1-shingekinocore@gmail.com/
> 
> Eric, this version no longer touches lib/crypto/. Would you still
> take it through libcrypto-next, or should it go through Andrew's -mm
> tree (unroll.h has no MAINTAINERS entry)?

Either way is fine with me.  It's one of the unowned files, which are
always problematic.  If Andrew hasn't taken it by the time -rc1 rolls
around, I'll apply it to libcrypto-next: it's at least somewhat related,
given that lib/crypto/ is one of the few users of this file.

- Eric
