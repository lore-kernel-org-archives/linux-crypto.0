Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C86E24BD1A;
	Fri, 13 Jun 2025 09:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807377; cv=none; b=Kn+VBasPbvGRZZHG8AKllLmg/TNsdB9+DYr8JfjXo2FMciTGChc9OQzK5jqtHQD5Q1nHOl6o5iP08NspmlX6KSr2MYITbbRmYsLzlmj/OkuOIsUX2KKH4eMLRQsAggfxar2i1mp40ebVQ2+Cb0MLbOUfI+jRj3y7eYORqzMvFJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807377; c=relaxed/simple;
	bh=Ns10xPiktRlEhZz0m1QXNynNw6e3w7+yxtmCtvE1GlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8pp26xauQiohaKLBc7JkavzxgVAOpm+BwFz5Bpylk5ykAiMVC6G0CYWJRnunFqlG3SPIc7PluOSu7SF/lnHBaajnfp0+AfBabLf267dp0sTNZe79UFmtHzMx4HFwQonxJeMZVfqvdg2Mm27nsjXRaic22YUt195VSRVfe3XjOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rOWYkXid; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rOWYkXid"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J710XCWaUNQIV1THRMGx0lwVtu60XlriSgjoReft8g0=; b=rOWYkXid7/mLVZpctBhg6/2+9Q
	nyZjKxVF8WPtVRCY0JdLcaaamO2uvsDcyJ2PB68Hvk8Rv3X0aHzK6qeGlZJVMdGkEjpwkNJhLqE03
	9MUJD49b8kQx6DhiO1hGXJquQcE4PGF7kvlTq5Cs99X5hF1VS8CuJAEu5fWt6vYBxyLu2KscDDQ/W
	/r/Dc407EhaynybMH6PW8fHzPiDar5h6icZn0VPakLzT27sTFMoiD53JVZwOn2A/HPbQHU5AY9Wv/
	kafHfEqQjm5B3EhwXwYBIZTi3DV3kkIwEhjdefzWRN4E5iODgs+K0bXC8ORafOzriNAXS3hORNpRr
	Ti44VQrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0pN-00Ct2F-2g;
	Fri, 13 Jun 2025 17:36:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:36:01 +0800
Date: Fri, 13 Jun 2025 17:36:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	bharatb.linux@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v4] crypto: octeontx2: Fix hang and address alignment
 issues
Message-ID: <aEvxARwwLxwBO1Zj@gondor.apana.org.au>
References: <20250522100627.175210-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522100627.175210-1-bbhushan2@marvell.com>

On Thu, May 22, 2025 at 03:36:23PM +0530, Bharat Bhushan wrote:
> First patch of the series fixes possible infinite loop.
> 
> Remaining three patches fixes address alignment issue observed
> after "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
>        smaller cache_line_size()"
> 
> First 3 patches applies to Linux version 6.5 onwards.
> Patch-4 applies to Linux version 6.8 onwards
> 
> v3->v4:
>  - Again fixed memory size calculation as per review comment
> 
> v2->v3:
>  - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
>    bidirectional
> 
> v1->v2:
>  - Fixed memory padding size calculation as per review comment
> 
> Bharat Bhushan (4):
>   crypto: octeontx2: add timeout for load_fvc completion poll
>   crypto: octeontx2: Fix address alignment issue on ucode loading
>   crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
>   crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0
> 
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 125 +++++++++++++-----
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  51 ++++---
>  2 files changed, 130 insertions(+), 46 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
