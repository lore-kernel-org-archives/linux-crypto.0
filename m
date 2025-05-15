Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8BB4B1E44;
	Thu, 15 May 2025 20:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747339498; cv=none; b=Y0TB+erSxKMDJWk9cKYPzG8nn9RtyCJ8Wkric1wRjq1Kd1jfSNaNyNx3ryMFLlZyJ7EUmAbKF/xhzxqahCocT4IG8KX+ZclSDoEoTww2B5dL/5VxtlIx4h1pPAXCNLgyIBC4GcpY9ZSp5lHOWadbwqTLIIJ62xr3RcWB8jVexAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747339498; c=relaxed/simple;
	bh=ztz69GY2bsxQRxJ+h/b5wHYeWx2keRfeVyGJwKbiJ9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rDvV73rIqMtKsgLzkfDWuEBp9M0LAs3WzygTdMJ6uVLXSB/YQ/hfkWpsEbr3xjURjSh8HHpteqvXd71NzCCBz40QngUcm2oot8p60KlZPMcbufCrNiesaG9DwaA4YNOh+ne49Iy8CxCq89d1gZiOBxm+63G24ofRt8LkNOz6TRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4g4noOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4g4noOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E991DC4CEE7;
	Thu, 15 May 2025 20:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747339497;
	bh=ztz69GY2bsxQRxJ+h/b5wHYeWx2keRfeVyGJwKbiJ9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y4g4noOpydFlzGAG/fR0Jls4+OFyeK4qKCLWabrBT+36c4jcAim+2Ry1/IqCVQd1L
	 FPZpNXddwlEtjhrNAWVeKPmm8f9/J1ZZc3wOPDgZzirI3cNS8TNWv1jA5tFb5kl9It
	 3HztJS2e2q8TKlH1tNK2Y/TR3VTQQ92fw6GFoBdjHR6Ym0FIDD0RTBoLhEp/LxPpRm
	 8+6Bdo+P4QyJ/pjDEuNP9qm4BH1AoRO+NOFCTKiPtNPHO20CSCpsRuX449klXdScpr
	 75RiNkJgH5nub1R6isr13GeEiKRidPq6y2DgB6ZNqiIS0hdPSLuBtHjwj49jI+3PFA
	 PbiA2Xg93CS4w==
Date: Thu, 15 May 2025 13:04:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lrw - Only add ecb if it is not already there
Message-ID: <20250515200455.GL1411@quark>
References: <202505151503.d8a6cf10-lkp@intel.com>
 <aCWlmOE6VQJoYeaJ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCWlmOE6VQJoYeaJ@gondor.apana.org.au>

On Thu, May 15, 2025 at 04:28:08PM +0800, Herbert Xu wrote:
> On Thu, May 15, 2025 at 03:41:05PM +0800, kernel test robot wrote:
> >
> > [   16.077514][  T327] ------------[ cut here ]------------
> > [   16.079451][  T327] alg: self-tests for lrw(twofish) using lrw(ecb(twofish-asm)) failed (rc=-22)
> 
> The crucial line actually got cut off:
> 
> alg: skcipher: error allocating lrw(ecb(twofish-generic)) (generic impl of lrw(twofish)): -22
> 
> The bug is in lrw, which unconditionally adds ecb() around its
> parameter, so we end up with ecb(ecb(twofish-generic)), which is
> then correctly rejected by the ecb template when it tries to
> create the inner ecb(twofish-generic) as a simple cipher.

Please include this explanation in the commit message itself.

Also adding ecb wasn't unconditional, but only if it wasn't found with one ecb.

> Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")

It didn't actually make a difference until 795f85fca229 ("crypto: algboss - Pass
instance creation error up") though, right?  Before then, if "ecb(...)" gave
ENOENT then "ecb(ecb(...))" gave ENOENT too.

As I said in
https://lore.kernel.org/linux-crypto/20240924222839.GC1585@sol.localdomain/,
that commit (which had no explanation) just seems wrong.  We should have simply
stuck with ENOENT.

But as usual my concern just got ignored and it got pushed out anyway.

- Eric
