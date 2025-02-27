Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17C206F15
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740679925; cv=none; b=JUbVEFp6zFbXf15hNJ7CrNWejGdQacNR1pBnlYRsqY6oH3mHxQn+4ba/E1uwsl0duUPWp95G7Od2RRMNYzdMWAVvy8ot7FtdYQ/4sQq+A/MTCfAgeNG5rU9IqGS9Lvaeg2ZB2zWCj9RwYquZ2aOKt2heA7fmFqkmPbYlOdOmqro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740679925; c=relaxed/simple;
	bh=XWDqjf80UaziUXR2xOwVUzxJTkll273AypoLtp7KdEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlGLFz+oQMAQrpbHR5FPJhTMK0a7Piy10yd/OdQYrx/WBXjY0gdGyg/czXS0EBWyp4FHHCJLW1ivCgJstt3EaONuFCEef3HyDuhlhHpSF9bozzzAX8jX+oxl7driLnLduR7Z8B1Ysd2I5Dv5deS/bjdZsaeX4PjGCBiGT36Koe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HPRRaNTC; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HPRRaNTC"
Date: Thu, 27 Feb 2025 18:11:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740679920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LCctv8wSN6bCRwTC2hagGzXBZX0Q7buHswhO5UFIEQs=;
	b=HPRRaNTCA4l/hXNyDVXuRCttx8JLwUQybC+niohvNNpqtA3nce4tFG0Zdc15Tsm024Hkh3
	i+afWr0vCS2ADGPUU1w+njg0OvrfW7chbo3D/UlfSxE/at4t4S7sOXsWofOniOQv6YU+JL
	xwObJeKv0QPkSGBsqkoh3okosPcBCeg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/7] crypto: acomp - Add request chaining and virtual
 address support
Message-ID: <Z8Cq7OYkaNtzJoWe@google.com>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 06:14:53PM +0800, Herbert Xu wrote:
> This patch series adds reqeust chaining and virtual address support
> to the crypto_acomp interface.  The last patch is a demo of what
> it looks like to the user.  It will not be applied.

What tree/branch is this series based on?

> 
> Herbert Xu (7):
>   crypto: iaa - Test the correct request flag
>   crypto: acomp - Remove acomp request flags
>   crypto: acomp - Add request chaining and virtual addresses
>   crypto: testmgr - Remove NULL dst acomp tests
>   crypto: scomp - Remove support for non-trivial SG lists
>   crypto: scomp - Add chaining and virtual address support
>   mm: zswap: Use acomp virtual address interface
> 
>  crypto/acompress.c                         | 207 ++++++++++++++++++++-
>  crypto/scompress.c                         | 175 ++++++-----------
>  crypto/testmgr.c                           |  29 ---
>  drivers/crypto/intel/iaa/iaa_crypto_main.c |   4 +-
>  include/crypto/acompress.h                 |  95 +++++++---
>  include/crypto/internal/acompress.h        |  22 +++
>  include/crypto/internal/scompress.h        |   2 -
>  mm/zswap.c                                 |  23 +--
>  8 files changed, 365 insertions(+), 192 deletions(-)
> 
> -- 
> 2.39.5
> 
> 
