Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793310070;
	b=iVhyYOdyG+FJmvxm3+zSJimSPhMScmsibOPgohYfGefxF9p9kdfKiEXw5wuFc64mh8FP
	 M/+cTzn9O2YgKHAIzneABHuTF1hkgpL9NlFW0jSZ4vq7GKEVkiLajla+z1EvUwLHbWnsE
	 uKs1mLAmaYJD+R8XefrRTKm28dmOXWHpcp/lySsXI3G3eaKO10I7i8euLRE6fasijjLBz
	 mDZCWTXMkZtgyByfgQcwSZB5xYWz0rCqtksq5PksejcjiH1ea/XlZUsCD6HLkSSy5gLSS
	 Zu9m0Bpj8ItPAAtKO1ZTys7bdLNBrUqkqGJSh6gtan7DJ7OdASTNCQbCSzlQBUXwuHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793310070;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DX4A7jq1CXzKQrspT1o5uwX5xayxjUsi8drR3g2wMS0=;
	b=V7LX8KZraHN4zEOrNOY++XwarrjUabBDho4F6H622SHFsDwBg4Pyfi7YMAEgfxijqilr
	 sve36au67c95kwPzhi3GHMLoGqsxT+OisSNq+hU5iQ6MDCROtWuMCSq2kLY/+KOiFz/jQ
	 pBn6zUN8c8H0nR4d9cbB1LOKS9Ju8Q4Q/HeGH6jDFops3nrfoAGdRRDg8TAZYRucgWeyX
	 KQH14UYBVgLoHCYQIGMhbZtW0NyEqZiX6yUUiuJsom5HJfp9Z2vkq+GaK5O8mwFeARsMm
	 W+F7bi4tQZLWYKJ1JASixvKwGw0M/DaeGpC07hwIoabpCzlNdx55hUJIo03I29qk0jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrI+asDx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF8606A31A;
	Thu, 29 Oct 2026 21:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrI+asDx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEC21F01824;
	Thu, 29 Oct 2026 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793310069;
	bh=DX4A7jq1CXzKQrspT1o5uwX5xayxjUsi8drR3g2wMS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OrI+asDx/ZZr8nZngTcpGFdpZ1DNs33qxqstWnQiMA7nEVHTNLe7llw2lWCyz3fRh
	 7VrPsn4PEXVlF4CCI6iju4bs6qvynJhLGYy8vxoqbZpPm2cMEvFZpuxf2il/WScP9F
	 a8jGuDnYjqjpjEgMtfuRUl/zMDGnBuDovtgw9VqNda0wq9bmWwdr0mnX3guTQx4GwQ
	 3PTlluVaOonFJKosINfwLbuJYpNgnZ6wqtbfCJvoi+5tvX3sSdMSz536ANahKJkY93
	 oyXsQQQsXg1cb3GgnwJQKfEoNsqaJsMhiF5k+vdI3VonRjOyNbc2QNqksO6+osyhBb
	 9uVcPT3gx8RkA==
Date: Thu, 29 Oct 2026 14:41:05 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Message-ID: <20261029214105.GA44297@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
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
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>

Hi Ard,

On Thu, Oct 29, 2026 at 02:50:20PM +0100, Ard Biesheuvel wrote:
> Recent Clang has become more finicky when it comes to overriding the
> type macros that the freestanding stdint.h consumes when defining the
> uintXX_t types, and so it is time to finally get rid of this entirely.

Just as information for other folks:

  https://github.com/llvm/llvm-project/pull/227722#issuecomment-6065215071

> So instead of making stdint.h (which comes from the compiler when
> -ffreestanding is set on the command line) agree with the kernel's
> linux/types.h header, avoid the latter entirely in the compilation units
> that actually use the NEON intrinsics (which are always leaf functions
> that are not tightly coupled to kernel APIs).

I had not even considered this as an option, thanks a lot for exploring
it and sending this series as a result. I definitely think this is the
preferred route forward based on my discussions with clang folks
upstream since they were quite unhappy with stdint.h being overridden in
this manner.

> Note that the disagreements are about long vs. long long on arm64, and
> long vs. int on 32-bit ARM, so never about types that actually have
> conflicting representations.
> 
> Ard Biesheuvel (4):
>   lib/crc: Don't include <linux/types.h> in NEON intrinsics code
>   xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
>   arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
>   ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h

This passes my arm and arm64 test matrix with LLVM 23.1.4 and a version
of LLVM 24 with the breaking change mentioned above. This will be needed
in stable but I don't mind taking a look at the backports when the time
comes.

Tested-by: Nathan Chancellor <nathan@kernel.org>

-- 
Cheers,
Nathan
