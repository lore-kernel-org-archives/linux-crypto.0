Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121E117597;
	Wed,  9 Jul 2025 19:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752088640; cv=none; b=D5aLzcBD8LDckjhf8mEArlPOb3SzXmmJ9lVaq+HyFG1wDLo4Rbx6OocCfIxjobvW7/DZAml8YZ745t2jVrFnRdVNG32TuNc9SVO5lT4ev5zV4wlVFDeCMttfJsd2gV3D2pX7DvTJJQebXuidbjHX8AJprCl9lOqFrjNx44LigWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752088640; c=relaxed/simple;
	bh=jAgStzgTXM2O4+1cFvDzq8iYsGJs2o//jW34p27qwno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l2qA6zfyRha3+JAAI10sFM6cnCmRtzSMF2N+ufuT9kUUq7YxnFChN268QnluKjW/IoYHv/qAvUwxNvNNFp4SWlP7XU6DTEMaKI6WTrTNyykvCi2qs4yR4tmZER8fpDxHFGv6v+OkZ2CoA2CxFaHnpVelUEDHBa6BaDWd3woUoCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbUYyJSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbUYyJSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635BFC4CEEF;
	Wed,  9 Jul 2025 19:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752088639;
	bh=jAgStzgTXM2O4+1cFvDzq8iYsGJs2o//jW34p27qwno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EbUYyJSrCKCM8gLFTMV4Fi49SXucfus/W1v1iN4KMYD42BqPIf4RCcs0o375st9Wv
	 zDfk6ABrx1qopS7G/nbtsMcjwe+KQf+PDN9D0aEb8cCifMaFk2a59dgDLVrk7HRKsK
	 yAboIgYlLwIfkE3J0Ozp8WOcYWAsS0nhvzOBKUpA40oKkIrQD4tVkaPyVGYcWL0eiP
	 h4gDaouGHka7543w0uHxln4rc89vIl/N5T6znoSIpF4NZeJIDuNR3OflxOgtV8Ysky
	 Ig/iKUAqQN0gta8A+LrK85Ag+mDUPkiK/3HPw/fO8kO53B2eWIRGLAv9w3MmSPKbRD
	 ZRdMfAeAdP8/A==
Date: Wed, 9 Jul 2025 12:16:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH 0/5] lib/crypto: Poly1305 fixes
Message-ID: <20250709191635.GA28537@sol>
References: <20250706231100.176113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>

On Sun, Jul 06, 2025 at 04:10:55PM -0700, Eric Biggers wrote:
> This series is also available at:                                                                        
>                                                                         
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git poly1305-fixes
> 
> This series fixes the arm, arm64, and x86 Poly1305 functions to not
> corrupt random tasks' registers when called in the "wrong" context.  It
> also fixes a performance regression on x86 with short messages.
> 
> This series is needed for my upcoming poly1305_kunit test to pass.
> 
> Eric Biggers (5):
>   lib/crypto: arm/poly1305: Remove unneeded empty weak function
>   lib/crypto: arm/poly1305: Fix register corruption in no-SIMD contexts
>   lib/crypto: arm64/poly1305: Fix register corruption in no-SIMD
>     contexts
>   lib/crypto: x86/poly1305: Fix register corruption in no-SIMD contexts
>   lib/crypto: x86/poly1305: Fix performance regression on short messages
> 
>  lib/crypto/arm/poly1305-glue.c   |  8 ++----
>  lib/crypto/arm64/poly1305-glue.c |  3 +-
>  lib/crypto/x86/poly1305_glue.c   | 48 +++++++++++++++++++++++++++++++-
>  3 files changed, 51 insertions(+), 8 deletions(-)
> 
> 
> base-commit: f1da28dfadd26ef95bbd0b1ddf066e7ffe1505ff

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
