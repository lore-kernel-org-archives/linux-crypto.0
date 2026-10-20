Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792511688;
	b=QukEbi44zHv2a7Yp0MYTtKOUXx5cbNtAM9smF/hBorLWz/mEVIRwTyKtJc/h9kOK8Z/D
	 /6aJu8LK4dqMHQC2zMnq4xPIda3aYhTz+Bsnb98WngnXbUSFJn3Jj1f4FUGtt0ubtwlP+
	 J4x+XxZthGSeOFgpWG0J+xvhfm5QhIk41eBNCKNVK8RfM/uMOnqM2zenhUMYxGBUucSrH
	 wJF5t3vO9WTmkHZxH3DZAHy1/2/AfJ3wszfjubv0hWTA+GTAQGoq4YVx/1+ZzE1gwEBlN
	 uIOZhHKFBx/txBqB8CkT42jnNPsswlj9qj5VAJVNGGvFzYsa4Ezu/FVRrTIckN7d1ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511688;
	h=Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=bD4jg+LJR83t+5Ev1f25chKLnVBKKwv+WsK5MzKinBw=;
	b=1ERHdXy/20mwNhkPjL8MTTPQv4QfQPF0H44r+l2kbiwXzkgb9FxTcO2KYCo/MOh2fcWW
	 b5ws2LefA8treIqIjkHtlkbKpzSH7uaT0/JjJSIC9xaG3PymXFMbUUutU1ZQBYGZWEOFe
	 NMr0lhQMLafeuAi1yzR87fP4uZGYZqO0PbtCYCtifai6/ryKleCEpTFabBRXZw5gWU/S/
	 BSymr4LqR+N4/hziUoKxuew52DHGfFFGlVGo3n8AcrpTgbxe1maWqXlEHbfff5ctLn1Qu
	 UYx/y9e32txnvGskkN+XLzNmvFQjFKLRkmGjOd28pDOwXbMdvohNcE4UJ7iyaPsP79A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57211606A31C;
	Tue, 20 Oct 2026 15:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9040A1F000C7;
	Tue, 20 Oct 2026 15:54:47 +0000 (UTC)
Date: Tue, 20 Oct 2026 15:54:16 +0000
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
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
Message-ID: <20261020155416.GC699485@google.com>
References: <20261016025613.2690485-1-shingekinocore@gmail.com>
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
In-Reply-To: <20261016025613.2690485-1-shingekinocore@gmail.com>

On Fri, Oct 16, 2026 at 10:56:13AM +0800, Tzu-Ching Yang wrote:
> unrolled, unrolled_full and unrolled_none are object-like macros with
> lower-case names, so in a file that includes <linux/unroll.h> every
> later identifier with one of these names is replaced with a _Pragma()
> operator. A local variable or struct member with one of these names
> fails to build. A function parameter named "unrolled" is worse: GCC
> expands "unrolled" to an empty pragma, which leaves the parameter
> unnamed and removes the name from the expressions that use it, and
> GCC 11 and later accept that with only -Wunknown-pragmas warnings.
> For example, GCC compiles
> 
> 	static int add(int unrolled, int x)
> 	{
> 		return unrolled + x;
> 	}
> 
> as "return +x;".
> 
> No variable, member or parameter in the tree uses these names yet, but
> the header is already pulled in by <linux/lsm_hooks.h>, the vhost and
> libeth headers and a few .c files, and every new includer exposes more
> code to the clash.
> 
> Make the three macros function-like, as unrolled_count() and UNROLL()
> already are. A function-like macro is expanded only where its name is
> followed by '(', so variables, struct members and parameters with the
> same names are left alone. Convert the only users, lib/crypto/blake2b.c
> and lib/crypto/blake2s.c, to unrolled_full(), and explain the empty
> argument list in the header comment.
> 
> No functional change: blake2b.c and blake2s.c preprocess to the same
> output as before, and every object that depends on <linux/unroll.h> is
> byte-identical in x86_64 (GCC 13, Clang 18), riscv64 (GCC 13) and arm64
> (Clang 18) builds, apart from the DWARF 5 checksum of the two edited
> source files in the arm64 debug info.
> 
> Signed-off-by: Tzu-Ching Yang <shingekinocore@gmail.com>
> ---
> unroll.h has no MAINTAINERS entry (hence Andrew on Cc), and the only
> users of these three macros are in lib/crypto/, so I think this fits
> the libcrypto tree best.
> 
> Testing: x86_64, riscv64 and arm64 defconfig plus the includers of
> <linux/unroll.h> (all LSMs, IMA/EVM, BPF LSM, vhost, i40e/ice/idpf),
> built without the patch and then rebuilt with it in the same source and
> output directories. Make rebuilt exactly the 135 objects that depend on
> <linux/unroll.h> or blake2{b,s}.c, plus the composite objects that
> contain them, so those are the objects compared. lib/crypto/,
> security/, drivers/vhost/ and idpf give the same result with riscv64
> GCC 8.1 and 16.2, x86_64 Clang 17.0.1 and arm64 Clang 23.1.1. GCC and
> Clang still report the BLAKE2 round loops as completely unrolled.
> 
> Stand-alone, with only <linux/unroll.h>: GCC 11.5, 12.5, 13.3, 14.2 and
> 16.2 build the add() example from the changelog, and it returns x; GCC
> 8.1, 9.5, 10.5 and Clang 17, 18 and 23 reject it. With this patch, a
> variable, struct member or parameter with any of the three names builds
> without warnings and gives the right result with all of these
> compilers.
> 
> The patch applies as is to next-20261014, libcrypto-next (40f47fa10a1d)
> and net-next (518bf436318e), and none of them has other users of these
> names. A user added elsewhere with the old spelling (unrolled_full
> without parentheses) fails to build rather than silently losing the
> hint.
> 
> Not addressed: a use followed by '(' is still expanded, so a function
> or function pointer with one of these names still clashes when it is
> called. With arguments, that fails to build. Without arguments, GCC
> still turns unrolled() into an empty pragma, so a call to a
> zero-argument function unrolled() declared before the header is
> included is dropped with only warnings (Clang rejects it).
> 
> unrolled and unrolled_none still have no users. If preferred, I can
> instead remove them, as Simon and Maciej suggested when they were
> added, and convert only unrolled_full; that also removes the case
> above.

Thanks.  If there are no objections I'll take this patch via
libcrypto-next.  It was too late to make the 7.4 pull request though, so
just FYI it will be a couple weeks before I apply it.

- Eric
