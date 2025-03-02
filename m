Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1648821;
	Sun,  2 Mar 2025 08:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903117; cv=none; b=THkV0DIeCuKdxC72wxX5fHccWZs9GBKy3SrYyvpU5LzxzQcJokfN49FlH3I0qTFX8pVKllAz/2YvdFaFRnmscJ7ihwFriK4O3truobK+o2JxUOztDOGrbqFL95PEziZPdj0TsWXqOc32FtmtzEDMPU0cesH3dsZWD5VOY9oxy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903117; c=relaxed/simple;
	bh=SypUWD7JvXsZ8WWu/4Aqu2lePFUiyZcBf45ug9F5Dg4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VniVfikmo8d0kB6OMf3F5QC8WyTxUs7+KUlx/9PCfL2gU2/KNEWuFlwDcSvIETdWASZ9LYXxt1qv8kx+QHXfD8JrB2i98kg04GBjjZDhEPr/02esas4aeK2+i5AZRsp/OgLpqX/j+iJKUcAnF6jM911dzKN+dSxpjOQrR6aIrGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bF4eLKAl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bF4eLKAl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5kouLZOcAsnYgTyKbKrcWCTUkyAf0QX+/rOD4IR60EI=; b=bF4eLKAlIgOVJHOQNx2Wa4he05
	JZmvAW98Cd35hzVxDE2QqZTceWAl5Km4FP1XenM8a28kQ1tUzsLEe9ccBYBZRKkQ8TGXWmu3+H/pS
	byfxQWDvHFPGLCgRrkRirONWgjY+NbyiXNZiQywGzRxE1vmlkgHeDOXlTHNR3s6mdNsjR0pjZ9wsJ
	zMyGyYziZhguHNMtmGOm+23jAc7LqJu8wzQZp+wFmB9PCr+lptsjKSyBBAHcFfot+EWL1lSyfozr4
	c5HQCPlsQn+twftKU9IGVzc5kw0uGIrxnZBmYzk95efVkvtL43p4l1zgtko55mCc/xeQ6Dimme9uM
	L23HsV/A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toeQR-0030qN-2n;
	Sun, 02 Mar 2025 16:11:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:11:51 +0800
Date: Sun, 2 Mar 2025 16:11:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 00/19] crypto: scatterlist handling improvements
Message-ID: <Z8QSx5_1khF4UsqD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219182341.43961-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev

Eric Biggers <ebiggers@kernel.org> wrote:
> This series can also be retrieved from:
> 
>    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crypto-scatterlist-v3
> 
> This series cleans up and optimizes the code that translates between
> scatterlists (the input to the API) and virtual addresses (what software
> implementations operate on) for skcipher and aead algorithms.
> 
> This takes the form of cleanups and optimizations to the skcipher_walk
> functions and a rework of the underlying scatter_walk functions.
> 
> The unnecessary use of scatterlists still remains a huge pain point of
> many of the crypto APIs, with the exception of lib/crypto/, shash, and
> scomp which do it properly.  But this series at least reduces (but not
> eliminates) the impact on performance that the scatterlists have.
> 
> An an example, this patchset improves IPsec throughput by about 5%, as
> measured using iperf3 bidirectional TCP between two c3d-standard-4 (AMD
> Genoa) instances in Google Compute Engine using transport mode IPsec
> with AES-256-GCM.
> 
> This series is organized as follows:
> 
> - Patch 1-5 improve scatter_walk, introducing easier-to-use functions
>  and optimizing performance in some cases.
> - Patch 6-17 convert users to use the new functions.
> - Patch 18 removes functions that are no longer needed.
> - Patch 19 optimizes the walker on !HIGHMEM platforms to start returning
>  data segments that can cross a page boundary.  This can significantly
>  improve performance in cases where messages can cross pages, such as
>  IPsec.  Previously there was a large overhead caused by packets being
>  unnecessarily divided into multiple parts by the walker, including
>  hitting skcipher_next_slow() which uses a single-block bounce buffer.
> 
> Changed in v3:
> - Dropped patches that were upstreamed.
> - Added a Reviewed-by and Tested-by.
> 
> Changed in v2:
> - Added comment to scatterwalk_done_dst().
> - Added scatterwalk_get_sglist() and use it in net/tls/.
> - Dropped the keywrap patch, as keywrap is being removed by
>  https://lore.kernel.org/r/20241227220802.92550-1-ebiggers@kernel.org
> 
> Eric Biggers (19):
>  crypto: scatterwalk - move to next sg entry just in time
>  crypto: scatterwalk - add new functions for skipping data
>  crypto: scatterwalk - add new functions for iterating through data
>  crypto: scatterwalk - add new functions for copying data
>  crypto: scatterwalk - add scatterwalk_get_sglist()
>  crypto: skcipher - use scatterwalk_start_at_pos()
>  crypto: aegis - use the new scatterwalk functions
>  crypto: arm/ghash - use the new scatterwalk functions
>  crypto: arm64 - use the new scatterwalk functions
>  crypto: nx - use the new scatterwalk functions
>  crypto: s390/aes-gcm - use the new scatterwalk functions
>  crypto: s5p-sss - use the new scatterwalk functions
>  crypto: stm32 - use the new scatterwalk functions
>  crypto: x86/aes-gcm - use the new scatterwalk functions
>  crypto: x86/aegis - use the new scatterwalk functions
>  net/tls: use the new scatterwalk functions
>  crypto: skcipher - use the new scatterwalk functions
>  crypto: scatterwalk - remove obsolete functions
>  crypto: scatterwalk - don't split at page boundaries when !HIGHMEM
> 
> arch/arm/crypto/ghash-ce-glue.c       |  15 +-
> arch/arm64/crypto/aes-ce-ccm-glue.c   |  17 +--
> arch/arm64/crypto/ghash-ce-glue.c     |  16 +-
> arch/arm64/crypto/sm4-ce-ccm-glue.c   |  27 ++--
> arch/arm64/crypto/sm4-ce-gcm-glue.c   |  31 ++--
> arch/s390/crypto/aes_s390.c           |  33 ++---
> arch/x86/crypto/aegis128-aesni-glue.c |  10 +-
> arch/x86/crypto/aesni-intel_glue.c    |  28 ++--
> crypto/aegis128-core.c                |  10 +-
> crypto/scatterwalk.c                  |  91 +++++++-----
> crypto/skcipher.c                     |  65 +++------
> drivers/crypto/nx/nx-aes-ccm.c        |  16 +-
> drivers/crypto/nx/nx-aes-gcm.c        |  17 +--
> drivers/crypto/nx/nx.c                |  31 +---
> drivers/crypto/nx/nx.h                |   3 -
> drivers/crypto/s5p-sss.c              |  38 ++---
> drivers/crypto/stm32/stm32-cryp.c     |  34 ++---
> include/crypto/scatterwalk.h          | 203 +++++++++++++++++++++-----
> net/tls/tls_device_fallback.c         |  31 +---
> 19 files changed, 363 insertions(+), 353 deletions(-)
> 
> 
> base-commit: c346fef6fef53fa57ff323b701e7bad82290d0e7

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
