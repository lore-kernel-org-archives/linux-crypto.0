Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D22DECA8;
	Thu, 25 Sep 2025 01:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758765493; cv=none; b=RBeDyKmoOxcJfpcVjvxAjI4sqHM2cW6pAy9Pjc4up+tGyY1++J/pBRrP+t95Vjrn3c0kFH6HZIncVZ9IkYDwdqoS5urECemscFntanuoTxVfif81xu8bl2XYe8VfcMdP9WDAjGmSlYWzunq2Tj11fmYE20hMmnQnLctGli9qGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758765493; c=relaxed/simple;
	bh=H8Rj4asJaipHXxxgtHOO9BUcZ5cJp1cMrLc6q1vmdPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyyfwjsYOvQ6UZmZFe3I4YtoNg8cVS2eF8sD/wM7+Uoa6Q9T8iEC+LOuuupLkvcQmrK/BIVbTaHpfGan66rf4CiTW3huLG4HoycX6kLv1tagZdq3S0IcYv/p2a6IeV97XzINPqCrYRceT6qrMMoI1ytjNpIC/XRXWEaeYn13GLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cIQXy5CG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cIQXy5CG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=XwIYTskSgPTahGYa+QHM5I7Pu31iE3cN8pC4sStasH4=; b=cIQXy5CGvFS+TWYxmTdJugfGaF
	m2FrlucNwRmT8EDWN6r58fSt57VPdowrfiV6l10rGznI4sUPpETiO84jMkk19f5ELQBGLnoZ9WsyX
	HNMJc5PfCbUAQKp7W71N9ZF1C7xWG47zKdLKIaEVVA8FRCNDgoNau3FeXcpGoadcixD6bTi+y30Lw
	ot4o0y7RrvvvHlSM42LMxYeYsdzvHtG+nXjn5RflvMlIoXolRii+pg84R87ZCt14YgvM3tte7dmS1
	yS3m+3xrgdfCh3a8ct3VBD87djT7wfdN3UiMGCnBwxIQn7FwvmDkfcWccVqVBkX1xx+KjmwUjlwbR
	LHDXIFOA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v1bFD-0087U5-1i;
	Thu, 25 Sep 2025 09:58:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 25 Sep 2025 09:58:03 +0800
Date: Thu, 25 Sep 2025 09:58:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: af_alg - Fix incorrect boolean values in
 af_alg_ctx
Message-ID: <aNShq_wAowyu4q2n@gondor.apana.org.au>
References: <20250924201822.9138-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924201822.9138-1-ebiggers@kernel.org>

On Wed, Sep 24, 2025 at 01:18:22PM -0700, Eric Biggers wrote:
> Commit 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in
> af_alg_sendmsg") changed some fields from bool to 1-bit bitfields of
> type u32.  However, some assignments to these fields, specifically
> 'more' and 'merge', assign values greater than 1.  These relied on C's
> implicit conversion to bool, such that zero becomes false and nonzero
> becomes true.  With a 1-bit bitfields of type u32 instead, mod 2 of the
> value is taken instead, resulting in 0 being assigned in some cases when
> 1 was intended.  Fix this by restoring the bool type.
> 
> Fixes: 1b34cbbf4f01 ("crypto: af_alg - Disallow concurrent writes in af_alg_sendmsg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: keep the bitfields and just change the type, as suggested by Linus
> 
>  include/crypto/if_alg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks for catching this and fixing it.  I wish there was a warning
for this.  Gcc will warn if a constant like 2 is assigned to the
bitfield, but there are no warnings if you assign an int to it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
