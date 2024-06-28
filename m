Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139828EA;
	Fri, 28 Jun 2024 01:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719536658; cv=none; b=dsr/5LEYk2Cjrf+yrY7pBD8k/ZAtH5cyd2tqeRzMFovE5Pk2Fb2QSuVvvlSHpJD+0JmfsC4qIa4AhO9SvWCKFawqSt5Bq7DThi2yDgh8a2Tfab78+ZGII/pSD2dp5pO5x0+FPduuLfg53cq/rgoq3Fj4lS1Eq+ZLk2MX3NXdDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719536658; c=relaxed/simple;
	bh=f7Cv0c1sT79r4wmQl923NLIjPFbM8FMzILmtJ+gVcks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDNaX2GSnyoTHUB455A0jAM5eVUJutYa7vKGNkuNzWaPdN0+IdHDuu1jP/FZb3LYLDrlyBNkvF+eMYlRFMA2bABvLaehvC8AVeIMMHAA/9NjsLhC2t2EkUlOQApIYUpsHlCE7pHATenrCE22j41zSA6U2o+QanDcdSR+g2QyViA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN01u-004FjC-1o;
	Fri, 28 Jun 2024 11:03:59 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:03:58 +1000
Date: Fri, 28 Jun 2024 11:03:58 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Helge Deller <deller@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: xor - fix template benchmarking
Message-ID: <Zn4L/pyXgyukCt8+@gondor.apana.org.au>
References: <ZnMWDdKJHfYQLDzS@p100>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnMWDdKJHfYQLDzS@p100>

On Wed, Jun 19, 2024 at 07:31:57PM +0200, Helge Deller wrote:
> Commit c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> switched from using jiffies to ktime-based performance benchmarking.
> 
> This works nicely on machines which have a fine-grained ktime()
> clocksource as e.g. x86 machoines with TSC.
> But other machines, e.g. my 4-way HP PARISC server, don't have such
> fine-grained clocksources, which is why it seems that 800 xor loops
> take zero seconds, which then calculates in the logs as:
> 
>  xor: measuring software checksum speed
>     8regs           : -1018167296 MB/sec
>     8regs_prefetch  : -1018167296 MB/sec
>     32regs          : -1018167296 MB/sec
>     32regs_prefetch : -1018167296 MB/sec

Ard, could you please take a look at this patch when you get a
chance? Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
