Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8060E3D0D5
	for <linux-crypto@vger.kernel.org>; Sun, 22 Dec 2024 04:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734841165; cv=none; b=f8lDfbjAiKElTSYgM9MJKO1qqoXUanBHjyiAI5qGoKyzwBSg/RcOgcftcWmRJk2wQDjzWFHi4Yo1iMYMvcgiZUvhrYaPx8viwMRu0jCX8ukqucYCZZ2v4HsPksjm4jggsgYKoao+1kkasjV9bc8fMFGmDgLst/s9hNK2NCzCLbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734841165; c=relaxed/simple;
	bh=FzfYIuOOK5IKMQvCS/cwCa1bcP1dURbsd9yvhK4PgQg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=oPgAPr9k/dSyai3U82iZhGPYvMoG+MCqJRokI4qF1jR0JtAN43LDOr5wXpF9cprJb/BsIu0PrhhcwkoEJcfEas13SM+CRIPm9wXP3VqdtcAufNu3bD3DshKDIBj1KjtA3Z/OfJn52PKcStjEpvTAPXxtrO+4d+z1dsjBNUoWjJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mI4HCpid; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mI4HCpid"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dHA8s3L95xwErMgV6YTHCPCNqMkW8WyF/4m+9xgbUyM=; b=mI4HCpidi+NyEtr8a7PttlHZNg
	LRsfyVFwLOML5UJr/i98WsCMScmeQoD7e7vsP9BDgOt6X3sxPKTslzMHpuQ+Ti+8qd/4BMfFaZRos
	KK2svzmDBuRRE3suu4OGjqYYKffPNTZjbT6raZxeTQutujp+HPk+W84GZ4BePHgKh8+2+ySZrvnCy
	0I6tw6fvKefyV+TRPvQt4MmxZTsq3u2z8ukb/gykNAIZUrkrk7oawhZwVwPVKptpU7RhV04yKbIvl
	1EW2mOMcbui/FWuM8Qfg3+RMmwqvi0HMWJW905SdfvsRY16qQyrizgmvUQTK5BRxjsTyu8/UXMYmz
	I5bq8uYw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tPDE5-002UeW-2u;
	Sun, 22 Dec 2024 12:19:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Dec 2024 12:19:18 +0800
Date: Sun, 22 Dec 2024 12:19:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 0/8] crypto: x86 - minor optimizations and cleanup to
 VAES code
Message-ID: <Z2eTRq3f3KVf_hw3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212212845.40333-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> This series contains a few minor optimizations and cleanups for the
> VAES-optimized AES-XTS and AES-GCM code.
> 
> Changed in v2:
>  - Added patch "crypto: x86/aes-xts - additional optimizations"
>  - Small additions to "x86/aes-xts - use .irp when useful" and
>    "x86/aes-xts - improve some comments"
> 
> Eric Biggers (8):
>  crypto: x86/aes-gcm - code size optimization
>  crypto: x86/aes-gcm - tune better for AMD CPUs
>  crypto: x86/aes-xts - use .irp when useful
>  crypto: x86/aes-xts - make the register aliases per-function
>  crypto: x86/aes-xts - improve some comments
>  crypto: x86/aes-xts - change len parameter to int
>  crypto: x86/aes-xts - more code size optimizations
>  crypto: x86/aes-xts - additional optimizations
> 
> arch/x86/crypto/aes-gcm-avx10-x86_64.S | 119 ++++-----
> arch/x86/crypto/aes-xts-avx-x86_64.S   | 329 +++++++++++++------------
> arch/x86/crypto/aesni-intel_glue.c     |  10 +-
> 3 files changed, 221 insertions(+), 237 deletions(-)
> 
> 
> base-commit: f04be1dddc70fcdd01497d66786e748106271eb6

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
