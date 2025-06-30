Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3614285C9C;
	Mon, 30 Jun 2025 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751302724; cv=none; b=UFlkWJMdOM3+F68hoH7kF63AlxYDttuPBTJWXA+upuhj96YlyNuj+hGAYSsajEUs+BesMvp3iOdVtA8+mqaXxldKlV+6JAvulEcefb/Nfoj8RCRJprwhtAZmQL96BtksDMC10E+vWXLkUNqClPlMSQe5Sll+/fMJw2BU0otOwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751302724; c=relaxed/simple;
	bh=3DCH+rKNoeq/lfCaQPMunq8kzDYn2xRMvA4Dmlv54fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTQyBLaB4UKa1bPi1uW/veIsPWyOvcSWVbGinKx1NQwL2sU7c/TpiQwEkXmRzEo/ZSQTQfReue7zmG+3OXX0H/woBV38VQX1hHDaGEfmSkhTXTHzqACNWZoD0rzs/8V24ETRJSxe0IIe4cgK3BeGJ6ZrgVALoLe/htDleVfWHg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUpFe0O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUpFe0O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B7C4CEE3;
	Mon, 30 Jun 2025 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751302724;
	bh=3DCH+rKNoeq/lfCaQPMunq8kzDYn2xRMvA4Dmlv54fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SUpFe0O+tcK0vV/3qvMY8oOyjTEtjbASNyCuDULM7K4EezHi/Xd/6u/aVVWbXxBXl
	 +Jq1FH5PnJM0azsT9MgRg/x6G5yAEbOOdBHjkX80FNBVQqoKZ6uwrjG2l4HHK0g1yp
	 R58tVJtweuQz6Z6noKl5YN4jPRJ1q1q3S59yKUjtv/dc9zocfwPipT1JgfAskLlBze
	 GqGI35v2D6x5vtC8uQTSduoqEN+Ql4K4Kp5a70DH0PyaHXV5jych2vdy7RKeZ3RbDN
	 AJ9NdFeqKPn3vN/74GVCM/RxtbO1DZ979z25XQ7EFZEWUffHNvtTobY9ysz1NVoqGk
	 xQFHd68+Zivwg==
Date: Mon, 30 Jun 2025 09:58:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Joerg Schmidbauer <jschmidb@de.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
	Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
Message-ID: <20250630165805.GC1220@sol>
References: <20250627185649.35321-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627185649.35321-1-ebiggers@kernel.org>

On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
> Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> added the field s390_sha_ctx::first_message_part and made it be used by
> s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> the initialization functions for SHA-3 were updated, leaving SHA-1 and
> SHA-2 using first_message_part uninitialized.
> 
> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> problem earlier; this bug was found only when UBSAN detected the
> uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> and SHA-2.  Regardless, let's fix this.  For now just initialize to
> false, i.e. don't try to "optimize" the SHA state initialization.
> 
> Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> hadn't yet been librarified (which incidentally fixed this bug).
> 
> Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> Cc: stable@vger.kernel.org
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is targeting 6.16.  I'd prefer to take this through
> libcrypto-fixes, since the librarification work is also touching this
> area.  But let me know if there's a preference for the crypto tree or
> the s390 tree instead.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
