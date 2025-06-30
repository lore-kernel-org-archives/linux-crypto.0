Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB0CA4E;
	Mon, 30 Jun 2025 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303004; cv=none; b=bCHpAXapkg84PEsLe2lKNznAYrGU6ozGaqVahj1mkxKTMhGI+YuulS78hDI7PjHe2RZ4XY5T8AmulcIYKqaWHhaqymK0geKOgC9G8lpoA/RVHMAeX1FQlwFxt5IyZ6N0yJQ6Gy+gbkSEXi0tFUkeZ0b/mvzUoqfYNI/DlpA9JAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303004; c=relaxed/simple;
	bh=7pdCdKfXKgNVJgSu9uMlTMuwlr8iJXqLYAu7X1e5P9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyOMLUcSziZwFh+nzSY7fWNcrNmaiBkwxRfmCiDA7JnTj/pMuOgw8xG7LjFouxobq5SchHArU6qUSmr6PhBh9XUCFQ+IE6gOL8d0sWie+PPRHUEPaEjmqWRQmAg6CramoWlKjTjjZXKlpHEV8Y3q9OHtNOK5YzmyRvlrPg7yNWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sQiB/pHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sQiB/pHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D609CC4CEE3;
	Mon, 30 Jun 2025 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751303004;
	bh=7pdCdKfXKgNVJgSu9uMlTMuwlr8iJXqLYAu7X1e5P9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sQiB/pHKX4Cf2mkicAi9zi8JVZfNw+FgwpmOeSbmE2l0IjR36sr21mD/5bPKOjf+a
	 JFQ0lTKLsgQ3pnSIR8UKLn/B6y4eMObpon8TTO4TvgxzWv9fHOyh5fHZmiNMTzqBzx
	 QRkMiYJjvRQBvTa+67B+wjMxz/D50fOUXpdYIpt112vyzDIUcsCnPsHlLXlyn3FXCl
	 SZS+EAEumBgQDLs0mCuy426H4rwGlkMeZqyq9S4L6e8udQD/NDydYWRU09Ew9J+TcD
	 d3APRAHVSbWbmtGTaymXOoO4sMr4OqmXgj9WghKipAirSeQSMBv9zqnzf51b9tTSN7
	 yv4jmr0vy5k5w==
Date: Mon, 30 Jun 2025 10:02:45 -0700
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
Message-ID: <20250630170245.GD1220@sol>
References: <20250627185649.35321-1-ebiggers@kernel.org>
 <20250630165805.GC1220@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630165805.GC1220@sol>

On Mon, Jun 30, 2025 at 09:58:05AM -0700, Eric Biggers wrote:
> On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
> > Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> > added the field s390_sha_ctx::first_message_part and made it be used by
> > s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> > used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> > the initialization functions for SHA-3 were updated, leaving SHA-1 and
> > SHA-2 using first_message_part uninitialized.
> > 
> > This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> > instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> > problem earlier; this bug was found only when UBSAN detected the
> > uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> > and SHA-2.  Regardless, let's fix this.  For now just initialize to
> > false, i.e. don't try to "optimize" the SHA state initialization.
> > 
> > Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> > and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> > hadn't yet been librarified (which incidentally fixed this bug).
> > 
> > Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> > Cc: stable@vger.kernel.org
> > Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> > Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> > 
> > This is targeting 6.16.  I'd prefer to take this through
> > libcrypto-fixes, since the librarification work is also touching this
> > area.  But let me know if there's a preference for the crypto tree or
> > the s390 tree instead.
> 
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

Forgot to mention: I revised the first two paragraphs of the commit message to
fix a couple things and clarify that the accidental CPACF_KIMD_NIP was indeed
ignored (as per Ingo):

    crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2
    
    Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
    added the field s390_sha_ctx::first_message_part and made it be used by
    s390_sha_update() (now s390_sha_update_blocks()).  At the time,
    s390_sha_update() was used by all the s390 SHA-1, SHA-2, and SHA-3
    algorithms.  However, only the initialization functions for SHA-3 were
    updated, leaving SHA-1 and SHA-2 using first_message_part uninitialized.
    
    This could cause e.g. the function code CPACF_KIMD_SHA_512 |
    CPACF_KIMD_NIP to be used instead of just CPACF_KIMD_SHA_512.  This
    apparently was harmless, as the SHA-1 and SHA-2 function codes ignore
    CPACF_KIMD_NIP; it is recognized only by the SHA-3 function codes
    (https://lore.kernel.org/r/73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com/).
    Therefore, this bug was found only when first_message_part was later
    converted to a boolean and UBSAN detected its uninitialized use.
    Regardless, let's fix this by just initializing to false.
    
    Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
    and earlier, we'll also need to patch SHA-224 and SHA-256, as they
    hadn't yet been librarified (which incidentally fixed this bug).
    
    Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
    Cc: stable@vger.kernel.org
    Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
    Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
    Acked-by: Heiko Carstens <hca@linux.ibm.com>
    Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>
    Link: https://lore.kernel.org/r/20250627185649.35321-1-ebiggers@kernel.org
    Signed-off-by: Eric Biggers <ebiggers@kernel.org>
