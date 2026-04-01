Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E62D3630B9;
	Wed,  1 Apr 2026 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775074729; cv=none; b=KnRD5BCLDtcbYCx3abuYn527oK6iOKlauP5ZKpkFwvFfLsHBtsBwpXRoBlKZmQ2EJEkrwmEqCQpw9xzk+1kN2omdMNrIEDuc13It1SwGQQvlT8PeVpuAz5my91Syvcs2whmJ4+yRQVll0+S0Ubb8cl9rN8zyTdu1LekVxurd+F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775074729; c=relaxed/simple;
	bh=QuFRnM3S5kd6qPOKy5HubX7OVOmossUj5JDjFTFx+Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSSrKN2nAr1mlJE2RIwIAwk5D5At3POXTFTafitnVtQeh10JUbX5pgHriZV75mpsPtqb0EsRh2pIWfM0cURsQ57seR2SccwaNeQHOqS5RA48w73wpH27oOTOOWapPHuVWTp+yaofqR5pHe4u+8Op0n5V1VVdx8zVFVLkMjHkODs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvkmYeXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvkmYeXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A1AC116C6;
	Wed,  1 Apr 2026 20:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775074728;
	bh=QuFRnM3S5kd6qPOKy5HubX7OVOmossUj5JDjFTFx+Nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lvkmYeXxF0QgMqshyCDLkNzXA/pUmC4ubmso8EWA8Zps6J+qSktZrcUYx09MKkzCX
	 ZYe5a1tNbrccGFW/95Qqyxi4ugsCejCrn7cdGHsSjomxHC4nOrdol+EKZp6+niTHLi
	 l33iMQneIK+IxygjNn32WnwJ+YY6xxrCjJJWlbORM2Nmd1jMSm5j+udxlBGTrF6hLB
	 EoZH3jNO/4MAS+Gw7Gapl4Mg+4V54Ud9opqxKPStaLxeG8kX9zcqB/yQ3KuhjJY3Zh
	 D0+oDbJqLLA5a/MYMpTZIDQI1ToHc3umDcmbEbbwVqWncnO7JZN6+BkxO+TBwyGhXP
	 ORCI3nfP2I5Ig==
Date: Wed, 1 Apr 2026 13:18:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org,
	Nikunj A Dadhania <nikunj@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] lib/crypto: aesgcm: Don't disable IRQs during AES block
 encryption
Message-ID: <20260401201846.GB2466@quark>
References: <20260331024430.51755-1-ebiggers@kernel.org>
 <20260331050234.GA4451@sol>
 <1e04994d-4d82-48f4-8022-ea488d203653@app.fastmail.com>
 <20260331205511.GA2452@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331205511.GA2452@quark>

On Tue, Mar 31, 2026 at 01:55:11PM -0700, Eric Biggers wrote:
> > AIUI, if we drop the IRQ dis/enable from this code, the generic path
> > will be taken during early boot, but later invocations will use the
> > accelerated implementations once they become available, right?
> 
> Yes, that's correct.  The optimized code gets enabled by a
> subsys_initcall.

Also just to clarify, once the optimized crypto library code has been
enabled by the initcalls, it applies to all later function calls.  So
the library (e.g. the aesgcm_*() functions) doesn't have the problem
that the traditional crypto API (e.g. crypto_aead) has where unoptimized
code may continue to be used for an arbitrarily long time.

Anyway, I'll plan to apply this patch.  But it would be interesting to
hear from the x86 and SEV folks whether there is interest in making the
early AES-GCM operations in snp_secure_tsc_prepare() use the AES-NI and
PCLMULQDQ optimized code for better performance and side-channel
resistance.

- Eric
