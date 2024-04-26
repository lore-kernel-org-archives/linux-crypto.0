Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBAB13C9A0
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124130; cv=none; b=nGzOqqNzUzq/GLAuJ2qmrjppJeeymtkhaBeyearRKQp1UEmXPfJyzpAXI3MHxt5ThTUoUAZRA8msA3e5/4Aj26oqdHk+ca6gY1rpZQCpZFPqZYpiREn+/wyJE0a6WKtN5pgyDB2PdSxXu9ytjDX35WKqfpBTNoaknW+ITYV2l9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124130; c=relaxed/simple;
	bh=mP55Tra7GyeRSlRmxLpwHM1klt5XqG3bE3kggmsGPYw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=mohE7hZtbPAwtaWTDSPz6o/4s60wRHgsKZP9z/zrSiwyp8miqjOXBllNhLim/c/fQUw+uyDPjY4FW2BSao64CtC0J+X9aTwYNs39Ys2wIizlDQIhIOmW0zMOkh29ctnb+ATk5NcrySPA2EBpGKzfGlRK9lbvWELmJvp5bDK2fLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0HzJ-006eVR-08; Fri, 26 Apr 2024 17:35:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:35:43 +0800
Date: Fri, 26 Apr 2024 17:35:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-xts - simplify loop in
 xts_crypt_slowpath()
Message-ID: <Zit1b7bdWmnRe1ZC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420055455.25179-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since the total length processed by the loop in xts_crypt_slowpath() is
> a multiple of AES_BLOCK_SIZE, just round the length down to
> AES_BLOCK_SIZE even on the last step.  This doesn't change behavior, as
> the last step will process a multiple of AES_BLOCK_SIZE regardless.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aesni-intel_glue.c | 13 +++++--------
> 1 file changed, 5 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
