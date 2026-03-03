Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063D0382364;
	Tue,  3 Mar 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772550570; cv=none; b=TyNuzIgB6wl/XpmPd77EqWUJt70MHaNAf9qiDN0R32vRrOZiSHEqIlneE0mogpT+NeIp75H9NhtupGC3obP4LIDTU8nn7g51h1IRuzBpb76eLnN0FC3gmyACPHfmDGEyrFrJzTIE10o5L7ZUayOPmpfE6SCu+7mAX5cW91qg2so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772550570; c=relaxed/simple;
	bh=SJ8YfvbyVHg26jWohVqn/EIMb35pocimMITUFtwIHlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJfn5CPFcOZn2R03J0KnkLcGlIlf+iPOgC2T2BKArIRYMN/8x5zT0p70LcaCxSWotLk83t/k/yt/8nDTw7WFwL5wUL5nEu4LxO8Y+j99adz9+baLReIQmKGuXTJc4Fnzsc3CDnZJg6VKokDJvQhpIXtGTi3DgzQqNThe92Whg5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ec9wJZPO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ec9wJZPO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sLOteAlb1KnKUFn91vnOM93Z12m5uOFjMDhUK2pQp74=; b=ec9wJZPOETfaffdcB7XpMYnyGK
	hlm6bcbwHN7kWP8pl3Nvd7urjmB3xujb+NzbMIt2LL48LIsAR6l+Pmugw/+uTG7XeWv+A/kk8QXf7
	6MpItIm8xbESf6pExqvZu3+msETgeeOWNXV/kdsip36+4t6BkA20g6BKIk2kupwRuQqsZ4S3aASMK
	YArckOaNq1UrtqCl5wxWVWZIn4q8T2ndxWVrMWSiELlueUrO85eWDISVvwRYo37tT51fWQL8dMz1a
	8LaL/hEN5WG7eWCDIMcBuzcVD8tQ35A8fyNTS5spcj0TwY7Ql+TjGYnpA0MFChDMHVOkSENjVZlZo
	515Q01xg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRNG-0000000FO6L-3qh5;
	Tue, 03 Mar 2026 15:09:26 +0000
Date: Tue, 3 Mar 2026 07:09:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
Message-ID: <aab5ptuamQ7d_tTi@infradead.org>
References: <20260303060509.246038-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303060509.246038-1-git@jvdsn.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 03, 2026 at 12:05:09AM -0600, Joachim Vandersmissen wrote:
> xxhash64 is not a cryptographic hash algorithm, but is offered in the
> same API (shash) as actual cryptographic hash algorithms such as
> SHA-256. The Cryptographic Module Validation Program (CMVP), managing
> FIPS certification, believes that this could cause confusion. xxhash64
> must therefore be blocked in FIPS mode.
> 
> The only usage of xxhash64 in the kernel is btrfs. Commit fe11ac191ce0
> ("btrfs: switch to library APIs for checksums") recently modified the
> btrfs code to use the lib/crypto API, avoiding the Kernel Cryptographic
> API. Consequently, the removal of xxhash64 from the Crypto API in FIPS
> mode should now have no impact on btrfs usage.

It sounds like xxhash should be removed the crypto API entirely.
There's no user of it, it's not crypto, and doing xxhash through
the userspace crypto API socket is so stupid that I doubt anyone
attempted it.

