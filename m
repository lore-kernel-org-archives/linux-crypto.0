Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492E539FE4;
	Tue, 11 Jun 2024 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120356; cv=none; b=E2Y6C0ZDZh5gjj8CESvD0x7+hHaSnj61JLLqs3Kcr7aPdyoLAo028DtrBbclhdW0Bn65Iv2ffzem08JsPDunDj7UONUyj1dtZsathajD/EW31V+QXyiv/heE9svokYHzdMBBSNDDPy4lLVi8XAqIH7Nib6pC0coNszQK8G1BhYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120356; c=relaxed/simple;
	bh=KOtsX4mQc3+UMO9q0hASaqOyTNqiH8W67XbpUkOZ7e4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WfLS8/T9QhA8VfFg7mxoeliHfWwhTOKy/JD392bCoD87cjfc35T//Bxr0YZqM1UDBjK0UsKuLmig0w+ip44H/BJyoDFT+KIZlVmGvAxHWG76RBVXDPMtWyVs1iG6yGGoMFlc6GC277jEpOpixfcaPUOeSzAnaB3LbzaaMa2ygFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sH3aT-00886N-31;
	Tue, 11 Jun 2024 23:39:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 23:39:08 +0800
Date: Tue, 11 Jun 2024 23:39:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZmhvnBsqKe7AakY-@gondor.apana.org.au>
References: <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
 <20240610164258.GA3269@sol.localdomain>
 <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>

On Tue, Jun 11, 2024 at 11:21:43PM +0800, Herbert Xu wrote:
>
> Therefore if we switched to a linked-list API networking could
> give us the buffers with minimal changes.

BTW, this is not just about parallelising hashing.  Just as one of
the most significant benefits of GSO does not come from hardware
offload, but rather the amortisation of (network) stack overhead.
IOW you're traversing a very deep stack once instead of 40 times
(this is the factor for 64K vs MTU, if we extend beyond 64K (which
we absolute should do) the benefit would increase as well).

The same should apply to the Crypto API.  So even if this was a
purely software solution with no assembly code at all, it may well
improve GCM performance (at least for users able to feed us bulk
data, like networking).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
