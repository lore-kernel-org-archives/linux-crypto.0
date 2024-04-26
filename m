Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1013DDD5
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124144; cv=none; b=T5Vz0eVOBE/+xU2c1rQ8E0FCCO2eQf2LVsLs6GJVL1hPJCJQaoV6H50RpTYSdHnngiMYYlf8Qi30EoygN7NvceGLAeS1ACf+FhpBPnWuBFDESqdF4WBFeXKf+bTHy34U0Cl2rCVqQKjpYb/MTLKb6yaCxilB8XrzoAkzINbf4tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124144; c=relaxed/simple;
	bh=ifQuhJmiRcqmjOHcdouB75jLYPQO3LPZPZdpgqeMr7g=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NUekV+XDgEcl5AC3Ba4j1kS5uS7TS0OF6aAOJZfZzCKWHKclcBEpCJ/PH41maREDfAhQn6CP+uEFYGMMoJjI+NA3aL5EkswHSFXIWK9XeoDLPQ9CxuMvBGrHOSpsJTqobBjYPA6CydGqGeofXV+i22jJcWB3NAdoOS12Dz7jTeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0HzW-006eVv-Ky; Fri, 26 Apr 2024 17:35:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:35:56 +0800
Date: Fri, 26 Apr 2024 17:35:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - delete unused GCM assembly code
Message-ID: <Zit1fDfrzSMuPwlq@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420055642.25409-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Delete aesni_gcm_enc() and aesni_gcm_dec() because they are unused.
> Only the incremental AES-GCM functions (aesni_gcm_init(),
> aesni_gcm_enc_update(), aesni_gcm_finalize()) are actually used.
> 
> This saves 17 KB of object code.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aesni-intel_asm.S | 186 ------------------------------
> 1 file changed, 186 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
