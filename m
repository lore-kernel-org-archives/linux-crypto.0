Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DDE1DE3BB;
	Mon, 19 May 2025 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634482; cv=none; b=AOqfXCuYo+wqlV74fal/Ec8p0TUB+nDNmULjzg90d7GJYBqEybNtkCNEsGk73GfVfMb3scVY7eBHF1XLzM2wv4IRIzMEzg6Ghf4F1Upf6lY6oldbYMlISnKNSppi5mVaDwDStQ5e4kzTMJ1JyOT5LNfQix0A6u4DIEk0/PIpbrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634482; c=relaxed/simple;
	bh=Fdqvp7kzs5Ktwl7Gggic/Pnwcu5Bylzo072+O52ISb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fzjlGCUzmFW1O79n6BwjFB7JjhRFOBVU9sO+vGRKNZPTTF3tM5Q4WvlChuqkVJXWN1uJKw26trH37IX/jtWmT0TaFQ9lsqZDSOi/00ACfTR49I7sDkWZuoo6xRcgmBp43/dOTkod9My+iwXCWRU6XW3xAHcRLXDu9Nu+iY7xvi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FVXJpZBF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FVXJpZBF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M6RFoAec+QlM/AHDzlG7xHt7suHi0oVdNryEUUrPnXQ=; b=FVXJpZBFLWkC+g3XJ8cw9BjpYa
	6cL+5kiIGPYgEEglMb+tSWm2TR56OZSwDoZ+IwmNLz1vve72I3EFR8+s3xPrxvubfNmvg8Bbe/Yrm
	px5p8F1yvWG6QGk+XgJquZFWWvw9BfihAwmmb0DTKZPR3zgLGb8puG8zJ5Td6lUUEMY3YyB+serTz
	5B0VXiHerVSz8ZdSsq6mgcumnw+hJ1ZuwbA6sdvPmBWeIPqDsPoIN4ORfLz0r1GImzkPwfnAwodYS
	5l8Uvt1TVVzVziwt6FQo4rMb3GtoTMYOcqVuqq9YeFYOoXkc5MvBin8cBzU6BlsSPwWeVCXpJTvUc
	apgwtCsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtYe-007874-34;
	Mon, 19 May 2025 14:01:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:01:04 +0800
Date: Mon, 19 May 2025 14:01:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: octeontx2: Changes related to LMTST memory
Message-ID: <aCrJIFS2KBy-kxd7@gondor.apana.org.au>
References: <20250515061336.3348493-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515061336.3348493-1-bbhushan2@marvell.com>

On Thu, May 15, 2025 at 11:43:34AM +0530, Bharat Bhushan wrote:
> The first patch moves the initialization of cptlfs device info to the early
> probe stage, also eliminate redundant initialization.
> 
> The second patch updates the driver to use a dynamically allocated
> memory region for LMTST instead of the statically allocated memory
> from firmware. It also adds myself as a maintainer.
> 
> Bharat Bhushan (2):
>   crypto: octeontx2: Initialize cptlfs device info once
>   crypto: octeontx2: Use dynamic allocated memory region for lmtst
> 
>  MAINTAINERS                                   |  1 +
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.c  | 89 ++++++++++++++-----
>  drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  1 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |  1 +
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  | 25 ++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  5 +-
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 12 ++-
>  .../marvell/octeontx2/otx2_cptpf_main.c       | 18 +++-
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  6 +-
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  2 -
>  .../marvell/octeontx2/otx2_cptvf_main.c       | 19 ++--
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  1 +
>  drivers/pci/controller/pci-host-common.c      |  4 +
>  13 files changed, 137 insertions(+), 47 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
