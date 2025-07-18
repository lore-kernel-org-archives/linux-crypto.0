Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05B28B41A;
	Fri, 18 Jul 2025 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837134; cv=none; b=p22N0utvBjaS02IK9anVOOdkeB1B3lcrL8YPPME3AIifpNcYORqlD7RT/P+d4XwTQJJvdW6wv/ndDkqFdxhv015lSJ91ndvbou9drfnyIgipPsGzQpwS3T+rBMEf5OWq8XlllJX8JwG0PBfBTGAAFnCFaxVvWZkS3HPqFaZuZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837134; c=relaxed/simple;
	bh=N2XLZDCRYGtexR/9tdoFJGwoiacEHtXF7ymricM12dM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=aj30lBWbSDJAYqNXX5+wxFo7ZuMBbb6gjUc/I9VWmCCa79BU1tubnYpdpKdTEN7/b+YGkCIxntXIFhrdVy+1U5MUftCTlqhHa3UOUj6Gr+8Dz/zvwTA+u0jWfQu8vIQea4j22/rlOnbV5M4G6l+72K+XOXisRVwx4gMl+9Lxo6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r7zcNSLk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r7zcNSLk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EbJtC/SQmRLjsz0TAS+IJf7R78OwujIoAj2DCleQcPI=; b=r7zcNSLk/m27HaYfyXStkiLVIx
	0aGboDrqa8LHa6T0k1RSXR+mqvjqcWiKFWWI5ehv4eAa4A1jBR6ww+oj7aioC4kYkfXDkhvsXTtgw
	3EmINwHNsiWvD1nOlD2fmh3X8UUXJdmoHSA47CRF/gfnwyhkwm2cBRLSdiKupEWkAC3pFh0pGSuBB
	r6RLXkcdiNQgQK4qfaqh9cI1+JLP+OQSMqUcvpV++t0j5hXcaEZ2cfiNaSoxfdtURhUNkFWOSLx5a
	UdYlDpcC62jZ96LW60lyBtxkwgI0IkOC586DoPc038MzOPYtttlhkXEIrwMS3IsB33/vcYSvHB47L
	flj7b2bw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucil5-007ymV-2o;
	Fri, 18 Jul 2025 19:12:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:12:04 +1000
Date: Fri, 18 Jul 2025 21:12:04 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	suman.kumar.chakraborty@intel.com, ebiggers@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: acomp - Fix CFI failure due to type punning
Message-ID: <aHosBA15RgslSFui@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709005954.155842-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> To avoid a crash when control flow integrity is enabled, make the
> workspace ("stream") free function use a consistent type, and call it
> through a function pointer that has that same type.
> 
> Fixes: 42d9f6c77479 ("crypto: acomp - Move scomp stream allocation code into acomp")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> crypto/deflate.c                    | 7 ++++++-
> crypto/zstd.c                       | 7 ++++++-
> include/crypto/internal/acompress.h | 5 +----
> 3 files changed, 13 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
