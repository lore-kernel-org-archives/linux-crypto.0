Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D132755E5;
	Wed, 26 Feb 2025 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740604590; cv=none; b=Qiqv+IZ7ufz6zXu8f+okEFgLozhqIj+m0NqfoCy3X2V2vYqsCSDpS1n1TLIpzoDoyelYytxR8dm0/gt+IxSmF1/XSXdxHzCwA05ik1Rh2EjYgaWsxDK1+yKocb5PdVLoik3sZSTUVw2FBrkej954Son8jp9DpmA6PIt2jkIVd7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740604590; c=relaxed/simple;
	bh=BlXrr5d0eV/LhE0K1ldO09vh9dZWhnRmDBzqcBJ+MDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r9KkXfRCXZRzIGowlUr6fKL/dBA53TkMAjy9p5ezkmPpIRb2kUIxDiBp4LxsikLBC5YaNOsFGHcKzvi/jQEfg7iXikL0weldIjZF0FHJEPaRrp4eF69LfQAziMhhkpECx867W9bqiDqzF03el83jXgpfMaag5sTEwz/Css7lN6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjJlQYC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjJlQYC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEAAC4CEE7;
	Wed, 26 Feb 2025 21:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740604590;
	bh=BlXrr5d0eV/LhE0K1ldO09vh9dZWhnRmDBzqcBJ+MDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PjJlQYC6X0Ysyd0rN4GOVuwn8p1vTM0P/RTtiVegzerz7GdF/X8yBE1ul9r8dIvme
	 v4pmKoPifGMG7esQKPU2DDle9YL8BV9r9Ifm31rUYkQEcthrbkqOCXf5+aiL3tIrna
	 OC+bYnJxK8E4N9G86mVOs7hBOCP1d8R4B9Fz/cX7ZqgjPqfa7dFgjZK6UckAtvaU63
	 FnTr+OXy399bfR/1hbmvQwKEbitnTw0w8Rd93GjUDUjtC47AwS5/tqB1JrMMuxHNDN
	 KtIvu/UEGFElCZECX5tsqoBx1znqsJZVRuwd2q+fOYeLHY03n9m/fMXIkq1/2nkVFe
	 cobiK/OYjJdWw==
Date: Wed, 26 Feb 2025 21:16:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: zswap: fix crypto_free_acomp() deadlock in
 zswap_cpu_comp_dead()
Message-ID: <20250226211628.GD3949421@google.com>
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
 <20250226200016.GB3949421@google.com>
 <Z796VjPjno2PLTut@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z796VjPjno2PLTut@google.com>

On Wed, Feb 26, 2025 at 08:32:22PM +0000, Yosry Ahmed wrote:
> On Wed, Feb 26, 2025 at 08:00:16PM +0000, Eric Biggers wrote:
> > On Wed, Feb 26, 2025 at 06:56:25PM +0000, Yosry Ahmed wrote:
> > > Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
> > > the per-CPU acomp_ctx mutex. crypto_free_acomp() then holds scomp_lock
> > > (through crypto_exit_scomp_ops_async()).
> > > 
> > > On the other hand, crypto_alloc_acomp_node() holds the scomp_lock
> > > (through crypto_scomp_init_tfm()), and then allocates memory.
> > > If the allocation results in reclaim, we may attempt to hold the per-CPU
> > > acomp_ctx mutex.
> > 
> > The bug is in acomp.  crypto_free_acomp() should never have to wait for a memory
> > allocation.  That is what needs to be fixed.
> 
> crypto_free_acomp() does not explicitly wait for an allocation, but it
> waits for scomp_lock (in crypto_exit_scomp_ops_async()), which may be
> held while allocating memory from crypto_scomp_init_tfm().
> 
> Are you suggesting that crypto_exit_scomp_ops_async() should not be
> holding scomp_lock?

I think the solution while keeping the bounce buffer in place would be to do
what the patch
https://lore.kernel.org/linux-crypto/Z6w7Pz8jBeqhijut@gondor.apana.org.au/ does,
i.e. make the actual allocation and free happen outside the lock.

> > But really the bounce buffering in acomp (which is what is causing this problem)
> > should not exist at all.  There is really no practical use case for it; it's
> > just there because of the Crypto API's insistence on shoehorning everything into
> > scatterlists for no reason...
> 
> I am assuming this about scomp_scratch logic, which is what we need to
> hold the scomp_lock for, resulting in this problem.

Yes.

> If this is something that can be done right away I am fine with dropping
> this patch for an alternative fix, although it may be nice to reduce the
> lock critical section in zswap_cpu_comp_dead() to the bare minimum
> anyway.

Well, unfortunately the whole Crypto API philosophy of having a single interface
for software and for hardware offload doesn't really work.  This is just yet
another example of that; it's a problem caused by shoehorning software
compression into an interface designed for hardware offload.  zcomp really
should just use the compression libs directly (like most users of compression in
the kernel already do), and have an alternate code path specifically for
hardware offload (using acomp) for the few people who really want that.

- Eric
