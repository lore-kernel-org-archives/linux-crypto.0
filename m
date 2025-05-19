Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA5217A2F0;
	Mon, 19 May 2025 06:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634537; cv=none; b=SERwf7v+Hv+H6c4kJQ5IVx+k95wNrNgUJI8GTy/taqIQA/LJjAFjRgKEvcbQHK5DL0h2Ktw7JvGEEmacSqQFUYyWRm//NZQeYJv9CYI1wBWrS+wH7QV21q9yefrcz90Q8OkMEt5KX9dso0uycspqq8W3vQ0QY6jfIctPpDUKFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634537; c=relaxed/simple;
	bh=yCQpkFnZvB0r5rJ8XyKXobZmZ51eXrtT9MiWv1FUYjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsZpt+2Q4xnRpWaXS4+8RWfjcju0x0vB59ib/BM3qrGk2b1/A4qkovIjofn7TH3djlEgbDBIYG8i2tN51oZufbVL+QD/CcgpNqym6djOGLvjHCX5xgGQuuBWOPAD7HLdLQfTYRNxaFVFGUDVNkB+Zxzm+L4Zy5uZFEpFAFnFtTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CqROsIKD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CqROsIKD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GyPcsHb4lJYqUKYH+wocJgceQJOyJgu3uQqKhRHwTx4=; b=CqROsIKDjIckqJ00sHzBcmlFjw
	8YDE1dHrfbLpVG66HzfMp6DI2zRvqKRiTiSiV2o1bZski8lugJSTu5jyPum5DsPajhF+frFy5Z81f
	NNVYElfrrlGzZU5dCRTNUdo0I7oLESKICMNcA/5golaAPdLFcGODyO//E31FpIL+R91/qvKxku+Cw
	kQZIC4KVfQtphKlsjsI7JwCkBBDnQI7gYbUg/mCaTBBFiuERWgD+2RthwgTiH4wz+8MJsHySMoy2+
	mDiRaw133mxPEYw4m0RU+PDUB/RcktSiXxsFa7wRc4cKUTHF+elAqT0wXrg5wA2bbsPHNwFSxL/Ft
	GbJl9zkw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtZc-007889-0k;
	Mon, 19 May 2025 14:02:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:02:04 +0800
Date: Mon, 19 May 2025 14:02:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bharat Bhushan <bbhushan2@marvell.com>
Cc: bbrezillon@kernel.org, schalla@marvell.com, davem@davemloft.net,
	giovanni.cabiddu@intel.com, linux@treblig.org,
	bharatb.linux@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/2] crypto: octeontx2: Changes related to LMTST memory
Message-ID: <aCrJXLJ2XvHwXwVi@gondor.apana.org.au>
References: <20250516084441.3721548-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516084441.3721548-1-bbhushan2@marvell.com>

On Fri, May 16, 2025 at 02:14:39PM +0530, Bharat Bhushan wrote:
> v1->v2:
>  -  Removed changes in pci-host-common.c, those were comitted
>     by mistake.
> 
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
>  12 files changed, 133 insertions(+), 47 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
