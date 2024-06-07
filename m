Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F8187323
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 11:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761123; cv=none; b=hPq/Pw86KfOD2rRvvDdBSb6CWpEdXmvNbfwo/5l0rLCeFK9P6Q5Rn4FbjKDNC0T8NPBUBAD9NLWLfU69Qhc+IaxljoOWWE/yqclt4VGhFKlDmgSGOZOuft/barihnXX+cF4bOH90q5zhUu0ifcFcAHpzrl4hrysvuQEv53mPUls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761123; c=relaxed/simple;
	bh=OJn/Lj0XTQ++R3vPlUj7/CQCcUBt4lr86VP4msG3lQo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=eceU2c3q+mPCWF181J+FE/AFOcp/6KvU4bpK3+CHI0XByvFAIoV9aKPqaBRl17S0fQ+j66A6tUxiX+8XVbsbUL/8iE0BjILskDhCzGsB4QflRbHKCxFf+eQsvIj6UiTk4Sks1kqYUQGVtlCd46vpif2TOb09QdsfbST6XrUuRxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFY8S-006p7A-19;
	Fri, 07 Jun 2024 19:51:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:51:58 +0800
Date: Fri, 7 Jun 2024 19:51:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - test setkey in no-SIMD context
Message-ID: <ZmL0XgXJKYnPBvJY@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240527080539.163052-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since crypto_shash_setkey(), crypto_ahash_setkey(),
> crypto_skcipher_setkey(), and crypto_aead_setkey() apparently need to
> work in no-SIMD context on some architectures, make the self-tests cover
> this scenario.  Specifically, sometimes do the setkey while under
> crypto_disable_simd_for_test(), and do this independently from disabling
> SIMD for the other parts of the crypto operation since there is no
> guarantee that all parts happen in the same context.  (I.e., drivers
> mustn't store the key in different formats for SIMD vs. no-SIMD.)
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/testmgr.c | 29 ++++++++++++++++++++++++-----
> 1 file changed, 24 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
