Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D2313F011
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124222; cv=none; b=lw0g+1Rp4cbk7YY5r6L5yb8+BJepX8486rTKWuZb3RKV0s4ATZq91uYpBassGQsoJP7nzHHiUGQPqpJ47d10NnMjzj8sGUlXnxL06FXgBeqnYAfwouBt9UIlO7YpLNmWW6s7OFnSN9n/huIDLjqgk504SoVDA3QQmxDk4sq7ZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124222; c=relaxed/simple;
	bh=2MwuGDvwtx0QFo7PEKbULQU9XvjCruVu65HAxS7UtDM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EKRyOdCW/HwuFz87nZiO8RduPrhW7qWyFCWB/BTd2WEijZ+q/ETl3dmIM0RCGwVeCtq4QhNUayEaEAVuwtbNVGZr3ZqlAfpmFlEzojhQdGwCXgzOhHo/+A3Nffqdi7huJFA4RWnajOSmhcwC8PnN6sLkysa/HOw8jvennbmErnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0I0m-006eXb-IK; Fri, 26 Apr 2024 17:36:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:37:14 +0800
Date: Fri, 26 Apr 2024 17:37:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - delete unused GCM assembly code
Message-ID: <Zit1yjqDjSSngqX7@gondor.apana.org.au>
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

I wonder if we can get the tooling to warn about unused assembly
code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
