Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83E926D4F3
	for <linux-crypto@vger.kernel.org>; Mon, 19 May 2025 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747647301; cv=none; b=qbtwJw5hUIhAM8YT45qwplSspAfr6Y2N2Ak4Sf0cC6SndTyRPclqnbr8w5WsdLBsQ8N249UbFSqb54tWh5Su3lm9PXxrQMiBd8bVdvig/x+nFZiZPZNzotk5qHDVlmkoAq+vfF2QG+s4KeLy8X+J1elXJcfZZKiCIzYDAwgvUUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747647301; c=relaxed/simple;
	bh=8Er8gKsbUo02is3ymjhXKIwYDLUHPE5K4PaDWD7UGPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5Cb1f5x5z8Vc6h57RPlrQocNOmiO8gC7jfSYAp32Bc7ukfP27Ks0r2jas5nBV1Toq9aswcFF8wYG6wGSoCBjuPEShy4Bu0uABMu5rXbD8uh3FKsJV6rXS3DFNBQJGZ1ABQ+FKiLJ6OFDMVHvDHDs1/ryelM8FpMvuk8SuI2/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o9qXecOz; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o9qXecOz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ib6SFvyH2+rUB5D/8pWH0zGgzO20KOTWDJrcW1tYhI4=; b=o9qXecOzTv74yHGsKfxYeLg4c6
	PkdTxxaZWVYpgcwAeVYAnbqlN1bzLYTtya2L3RQvpIZy9y0eBgcBNf4hbF+wC+aJE2gLwMots7vfL
	V7QRWPgyBl8UuWGl0ESnsSVF4lMD/zhQpnFYyts4Sv0OAjE6daTgmfxOpsHdcE7SKkbb5V3pFFlgS
	r/YUHKmy6rSK97DAKUkd/S0eFdPmfnreGCkHb1lXugIhEMu13R2L8JOgKoEjwcxZ8de9zGRnhEPR1
	2lpL0q30NAnG8sjMD+qV/JwFRGx2dcjHjDq+CMJGxFcytoR7I8Y5oUSDbb7s5A9ZkArQPdMpZNNHx
	UaBq5gEw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGwtT-007CSD-2f;
	Mon, 19 May 2025 17:34:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 17:34:47 +0800
Date: Mon, 19 May 2025 17:34:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: Sporadic errors with alg selftest on next kernel.
Message-ID: <aCr7N5Cxrb_WGk3l@gondor.apana.org.au>
References: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35642f32-68ae-4064-9055-a4e1d8965257@linux.ibm.com>

On Mon, May 19, 2025 at 10:09:10AM +0200, Ingo Franzki wrote:
> Hi Herbert,
> 
> besides the regression found in paes-crt on s390x (reported and analyzed by Harald already), we sporadically encounter additional strange failures in our CI on the next kernel:
> 
> During this weekend's CI run, we got the following:
> 
>     alg: aead: error allocating gcm_base(ctr(aes-generic),ghash-generic) (generic impl of gcm(aes)): -17
>     alg: self-tests for gcm(aes) using gcm-aes-s390 failed (rc=-17)
> 
> Last week, we had a similar failure:
> 
>     aes_s390: Allocating AES fallback algorithm ctr(aes) failed
>     alg: skcipher: failed to allocate transform for ctr-aes-s390: -17
>     alg: self-tests for ctr(aes) using ctr-aes-s390 failed (rc=-17)

OK I think I can see one scenario where this can happen.  Because
you guys use a fallback, and the extra tests are also using a
generic fallback, they will both be trying to construct the same
thing at the same time.

However, they will construct them with different names: the s390
driver will allocate ctr(aes), and the extra tests will instead
opt for the more verbose ctr(aes-generic).  The larval scheme only
works if everyone uses the same name, e.g., ctr(aes).

So yes they can indeed talk past each other and end up with a clash
at registration time and the losing side will get EEXIST.

Let me try to work out a solution for this, probably by retrying
on EEXIST.  Or perhaps by turning EEXIST into EAGAIN in the template
instantiation code path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
