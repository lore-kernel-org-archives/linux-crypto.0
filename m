Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E60549251C;
	Fri,  6 Mar 2026 21:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772832905; cv=none; b=Vejr3SQD7f4QNZIz6Bz73Eif3ApxpvXkE8eGV3alMHrnInC/LhuSRLrTuktKys7Czz/wra/Uy+I5dPKZtIWjj4Mg4/ZFO+jsQWB5cFC2J3bka8U4avi1RxF1Du/uEV+8j5FSisjHTQSr0fCRnUPV8R7G4pZHmjcfPWcxPIFRC6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772832905; c=relaxed/simple;
	bh=a26CKCAuN0e+AQQ0s400WD7JDj7RShgZZsSMsEYZLOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4TyeV2X8na5oiZeIXqJ60L3tHS2op/TVi0Osx7tZZnEKoxayZ8itiiiy3cUh3d33KmCuJ5iFjUYyi09PZsssphuc8DZzfUQ26zAh6ROriPGbRvODexLPHqKnQEo9LfgcVv4nVsL3isU1iW5/EYrVpmjAsQyEIkNJmiU+GCrgQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YI1Tx+Bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YI1Tx+Bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2754FC4CEF7;
	Fri,  6 Mar 2026 21:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772832904;
	bh=a26CKCAuN0e+AQQ0s400WD7JDj7RShgZZsSMsEYZLOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YI1Tx+BpOwYKUOSt+7Cv+ovahSQrK49t8Z4jzkF+72b07lRCMddjsopN1H9nAg9jY
	 htJESw7R8DQNXRGoi8aX8f+sj7JyNiwqZKlg9plFSfXKA27TmWVkz/V4GasvvtUWXL
	 g3BslE5zHApzYL/B0Z4FXM1/XHzHHCcHffJNEro/2mI7E0MmaCgoPQvBlabmqMrsGH
	 8SP/0lMbMRStiEAGxb98KUG+lSKdYwO4DHWA/s0ab3/g+ixUUzMbUjPhWmCt+PAPju
	 gcdVwGOmRJAkW06IcU3ocTDzJH/D2fXqrrblYSy1xDbh4oDsdVSpeG1oIfAScOKYn4
	 xH/yUr16X2LWw==
Date: Fri, 6 Mar 2026 13:35:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Cheng-Yang Chou <yphbchou0911@gmail.com>, herbert@gondor.apana.org.au
Cc: davem@davemloft.net, catalin.marinas@arm.com, will@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, jserv@ccns.ncku.edu.tw
Subject: Re: [PATCH v2] crypto: arm64/aes-neonbs - Move key expansion off the
 stack
Message-ID: <20260306213502.GB9593@quark>
References: <20260306064254.2079274-1-yphbchou0911@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306064254.2079274-1-yphbchou0911@gmail.com>

On Fri, Mar 06, 2026 at 02:42:54PM +0800, Cheng-Yang Chou wrote:
> aesbs_setkey() and aesbs_cbc_ctr_setkey() allocate struct crypto_aes_ctx
> on the stack. On arm64, the kernel-mode NEON context is also stored on
> the stack, causing the combined frame size to exceed 1024 bytes and
> triggering -Wframe-larger-than= warnings.
> 
> Allocate struct crypto_aes_ctx on the heap instead and use
> kfree_sensitive() to ensure the key material is zeroed on free.
> Use a goto-based cleanup path to ensure kfree_sensitive() is always
> called.
> 
> Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
> ---
> Changes in v1:
> - Replace memzero_explicit() + kfree() with kfree_sensitive()
>   (Eric Biggers)
> - Link to v1: https://lore.kernel.org/all/20260305183229.150599-1-yphbchou0911@gmail.com/
> 
>  arch/arm64/crypto/aes-neonbs-glue.c | 37 ++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 14 deletions(-)

Looks okay for now, though as I mentioned I'd like to eventually
refactor this code to not need so much temporary space.

I'll plan to take this through the libcrypto-fixes tree.  Herbert, let
me know if you prefer to take it instead.

I'll plan to add:

    Fixes: 4fa617cc6851 ("arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack")

... since that is the change that put the stack usage over the "limit".

- Eric
