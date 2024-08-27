Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB556146590;
	Tue, 27 Aug 2024 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784521; cv=none; b=h3qpFzUoFU7MrzLqKoT1qAGmcYjGaXOME8Pmeyahf/QtoN/OZhpsc1G3J2HfcwO2mcnRX2ZARnuXN36Fv56zEBKBQ+lefpto6UYzt+7YeznIMY++MukTl5geu2wVTI17l97rYON0727Tuzxyt0LQWFzgZSXzxVI+EPeyV0l5eQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784521; c=relaxed/simple;
	bh=TOskMyqvmJnMMdMK9trHR8rWGt1L+cQe4Dtdla0PK+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNV3ZgJIuhWI7cd0FLWy8YlQw+H96t0bJjAsOwkqEK6E0mMx7seYWBPInzd6gEWzGcyXSxNx+xZtjGJ2lqVBtbYMo2ZzNvu8nyyv+CT2zG/ROIhSWF5JnfEsMoqeb9snp+XSvroCUIpccs8LDFSemhNdqWZpBAt4Htvd5TSvCQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=murPJKnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="murPJKnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A4DC4FF4D;
	Tue, 27 Aug 2024 18:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784521;
	bh=TOskMyqvmJnMMdMK9trHR8rWGt1L+cQe4Dtdla0PK+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=murPJKnrocvWfXX7rWlYLG3ledHoOxLgwG/e1Qwf9cs/KuUhuSnLz6a4PwpOAICuO
	 7I+yhTbPeHZEp0GMdcgKfU0849z1wX6+w4+F9r3xzYA8tUC5mvlm6uoY/lydfbwgcL
	 YbZIPndcqpP30be39cIFQKzkQXAUHFLV4iZilqIUEFJk/d1I4ZpM9MeRfk61F3L/UW
	 qi4FAvEF0mCdQd+kCGVRsp45+khRStTBMoO2AwnBPxsNa1wzB6aRfW1uEKXueg92JN
	 9KlbU+LvI6rKoGjx+2KIIvtsiGAkGuLnPpWBzAzReks4ZfNBEaaseoATd97fcjlw86
	 yeTIdEUTFmOhw==
Date: Tue, 27 Aug 2024 11:48:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [v3 PATCH 3/3] crypto: simd - Do not call crypto_alloc_tfm
 during registration
Message-ID: <20240827184839.GD2049@sol.localdomain>
References: <ZrbTUk6DyktnO7qk@gondor.apana.org.au>
 <202408161634.598311fd-oliver.sang@intel.com>
 <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsBKG0la0m69Dyq3@gondor.apana.org.au>

On Sat, Aug 17, 2024 at 02:58:35PM +0800, Herbert Xu wrote:
> Algorithm registration is usually carried out during module init,
> where as little work as possible should be carried out.  The SIMD
> code violated this rule by allocating a tfm, this then triggers a
> full test of the algorithm which may dead-lock in certain cases.
> 
> SIMD is only allocating the tfm to get at the alg object, which is
> in fact already available as it is what we are registering.  Use
> that directly and remove the crypto_alloc_tfm call.
> 
> Also remove some obsolete and unused SIMD API.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  arch/arm/crypto/aes-ce-glue.c     |  2 +-
>  arch/arm/crypto/aes-neonbs-glue.c |  2 +-
>  crypto/simd.c                     | 76 ++++++-------------------------
>  include/crypto/internal/simd.h    | 12 +----
>  4 files changed, 19 insertions(+), 73 deletions(-)
> 

I'm getting a test failure with this series applied:

[    0.383128] alg: aead: failed to allocate transform for gcm_base(ctr(aes-generic),ghash-generic): -2
[    0.383500] alg: self-tests for gcm(aes) using gcm_base(ctr(aes-generic),ghash-generic) failed (rc=-2)

This is on x86_64 with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

- Eric
