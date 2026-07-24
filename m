Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566C93793D2;
	Fri, 24 Jul 2026 05:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784870946; cv=none; b=uMtg39UIIWrxYKGBd1LBB+gMKDmBntqz56+aDl2iIB024fUmrPsftytpzFRVK43y2r6GTMljmSESZN/5Hiyxdolk1kPDECgFyRsavxpZJl+X9VHHZnosh65Y2+GecvlRFRmJOrJLM7BI977DLmLKuZAPASNe8XcUdymDUNcvk3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784870946; c=relaxed/simple;
	bh=uDsz1nrPJQim4JFn7ZTXwlumZwBZwWw2XHXkPxMpYU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO9iAF5j6LgsnGpbAzyYTOk9iBmNItw6rkUKPMg+4nkiIFzHZ+f9JKp5A+xp+MbMwvNCzWWHKo2En6bWO0KtDRYW8bld9ELzpnqweWvJo90Qq/vcFYE+lof6ZgOd/YgcBzcP72zHVibnLtVhf4VR/tWCu/KFkmgS6XFKRtChC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+bk7Vgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+bk7Vgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657471F000E9;
	Fri, 24 Jul 2026 05:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784870944;
	bh=q53deWRRK/b91M73sD9YZ3ZgsNtt8lj3y8LlgTKiW5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L+bk7VgwsbrJ8l4jJtUHhfiAwHSs/8g1M3vrAb3vwvR5wovGNLum4KO14XHHWT/MD
	 qK6s3m9ftLdWqrK7FdCDXZBpydWxM9N5PxHJcggouPF2KI41ZDqjep5KSjujBHKGM7
	 ZQlidywgGaNOsnom9QTwGrLwfwVXobaMDi8eorHs=
Date: Fri, 24 Jul 2026 07:28:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <2026072410-drained-acts-3502@gregkh>
References: <20260724050645.223799-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724050645.223799-1-ebiggers@kernel.org>

On Thu, Jul 23, 2026 at 10:06:45PM -0700, Eric Biggers wrote:
> This obsolete driver was already marked as BROKEN.  However, keeping
> BROKEN code around in the tree is unnecessary and causes problems.  It's
> much better to just remove it entirely.  Let's do that.
> 
> Crypto acceleration remains well-supported on Qualcomm SoCs via the
> Qualcomm Inline Crypto Engine and the ARMv8 Crypto Extensions, which are
> what Linux actually uses in practice.  The obsolete QCE driver is a
> dead-end approach.  It's extremely slow and just doesn't work well.
> 
> While there's been discussion around using QCE for restricted media
> content protection, that functionality has very little to do with the
> current crypto API driver and belongs in a separate, clean proposal
> (likely under a different subsystem/directory).
> 
> The extensive reasons for marking this driver as BROKEN were already
> documented in commit df373d39c6f0 ("crypto: qce - Mark QCE as BROKEN").
> 
> Since then, it's also been found that under realistic workloads, the
> driver is not only ~48x slower than ARMv8 CE, but due to massive driver
> overhead it actually consumes significantly *more* CPU cycles than doing
> the hashing directly on the CPU -- with much of that time spent in
> non-preemptible hardirq and softirq contexts
> (https://lore.kernel.org/linux-crypto/20260724020608.GA51735@sol/).  The
> proposed BAM locking fixes would only further degrade performance.
> 
> Additional bugs have been found as well
> (https://lore.kernel.org/linux-crypto/20260723205801.GD110634@quark/).
> Pending fixes for some bugs don't change the big picture.  Nor have
> security-related claims held up.  Of course, these issues are largely
> moot anyway when this driver's functionality isn't being used in
> practice, beyond the module loading due to it being in the kconfig.
> 
> Note that this removal does *not* imply that various other drivers in
> drivers/crypto/ don't have similar issues.  They do.  Rather, the
> evidence is just exceptionally clear for this one, in part because
> hardware availability has enabled independent testing.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
