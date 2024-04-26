Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C53F7EF
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124347; cv=none; b=p0gjlYNguHRxRd8TUKIF+0+VB81KEg8jJvQJSCgmks5K6mTuEh4J9MFdtNYQW1N++HAixEBWYihQTBmAEi44IlKxKzWgthAeo03IlM/JcXPMJ0ZURoVBJ3lXEQAeWpES1Dh9hhR+CC3eNqMuQA7qNbyi6yhUDIytotyH0aoDZJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124347; c=relaxed/simple;
	bh=i6V/bkg4ETS0YrOhrpcr/JglgWtvAdRm5yZsV7yOwSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ewIUSB8FVyTAU3WYZIOOPmZkyTuyVitRt6hJ92I4+rNqoSurHs7VWuXU5nTW2t0H8B+WFAAfHYenMexmRd0Q5pCAXELvA4+I+ryTXyz8mr+ycsmAv08QnmG2AmZTAbiFf98teTqCx1SyXIXdPtPRKck+m4mBsvtFvHH8771DwLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0I2n-006ebe-GQ; Fri, 26 Apr 2024 17:39:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:39:19 +0800
Date: Fri, 26 Apr 2024 17:39:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - simplify GCM hash subkey derivation
Message-ID: <Zit2R6Ju7UvAiuwS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420181942.GA786@quark.localdomain>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> On Fri, Apr 19, 2024 at 11:00:37PM -0700, Eric Biggers wrote:
>> +     aes_encrypt(aes_key, hash_subkey, page_address(ZERO_PAGE(0)));
> 
> Actually, page_address(ZERO_PAGE(0)) expands into a surprisingly large number of
> instructions.  Using empty_zero_page directly would avoid this, but there's
> little precedent for doing that.  For now, I think just using something like
> 'static const u8 zeroes[16]' is the way to go for small buffers like this.

Yes it's not worth the effort given the small size.  But still it
looks like lib/raid6 could benefit from using a shared zero page
too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
