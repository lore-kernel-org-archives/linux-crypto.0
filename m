Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC8A1CD1E4;
	Sun, 24 May 2026 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779658529; cv=none; b=Xbla4JdF1iuaOyQ702fOJkZlxmPND08F7Av74HKQ/FIL4IRRSvJVS3Y4NTQZmR/GaNGHLu6XvZwqCUx2rKe8sBsF8QxsuF018x0NGhcNNAvG4AjKRvjLXx7ZZ1cz+BoJMMSiIT2NMovrfXuz7oLtKkEOyNgYg3WnyaUu31FE420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779658529; c=relaxed/simple;
	bh=O7DiqNwDxk0PUYWi6EVIn3eyFKIJV4hMB0Cml1WUMzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aE0lmDlPGO/I6gzJ3oyOo3QjVCoyMFfIA+g6TKudXznWjsACIgXJHJTZiQJKdQfcaQPQXNisp0x9YC4fmeZjG1+nci1mETwLKtm8xhzT2un6q5/NT+mb4NtK+575W7gTcQUtuQ1uLpBsuSMLd3wCi5SJFuQYQHaf6bAFkz9sRL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfXrugTg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfXrugTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79F1F000E9;
	Sun, 24 May 2026 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779658528;
	bh=U6GP2HYz504qxqIvc8Ml5fkvXwFc8EWnUWB8skfrUuw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FfXrugTgPzcl9wLXaVk0gF/vp8j1ec6p6Z0M3e0VbZjr7Thm3n+eGj1ZEjYHpOuY+
	 ridfOzbZH65lqYLVh9RZ8FuMXRbQbXQLyRUXQbLvrno/Ks0xz8ux+81boN/UX06Rla
	 A7fZfRlXqChzbPIKGxlVSTi8J7zwvTMU1BmNV/tCBkCM2fkxgEojm8kJKYF4QMsm3r
	 ePshs/URUul2KSAWrwJQJ9AE94hex9+ELFriuGGgcRbX83FAZ8CBSplpxM9HpQ/RV2
	 kWdS0FLNZVb+cQJM1gGghV6hd+ujz/Y0uG9e+6jPjvaJJlIKbxtMZyVLM0bPCPgekW
	 Cx3ur9rFvheSw==
Date: Sun, 24 May 2026 16:35:25 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: powerpc: update VMX AES entries
Message-ID: <20260524213525.GA112327@quark>
References: <20260524212943.799757-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260524212943.799757-3-thorsten.blum@linux.dev>

On Sun, May 24, 2026 at 11:29:45PM +0200, Thorsten Blum wrote:
> Commit 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized
> code into library") removed arch/powerpc/crypto/aes.c and moved
> arch/powerpc/crypto/aesp8-ppc.pl to lib/crypto/powerpc/.
> 
> However, the "IBM Power VMX Cryptographic instructions" entry still
> references the removed file and no longer covers the moved aesp8-ppc.pl.
> 
> Remove the stale entry, add lib/crypto/powerpc/aesp8-ppc.pl, and tighten
> the arch/powerpc/crypto/aesp8-ppc.* pattern to match the remaining
> header only.
> 
> Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Eric Biggers <ebiggers@kernel.org>

If this doesn't get picked up through the powerpc tree, I can take this
through libcrypto-next.

- Eric
