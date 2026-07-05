Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B1521CA03;
	Sun,  5 Jul 2026 05:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783229527; cv=none; b=eABXYYBsFD8EEnfvWLjomxuu7t/IbhweKJg1kU8ntSbuo/9K8cWnq1IwKxJgZdQehQViETAJt1z8LXI2WgX2U2MhLQdGZjpOwEOAI6qkxIjQ4Jw0RW3i3UUZefDH5jzXKtzxwlz8b5wx/15t5Np/fMbljI7AAPmu2sE5zCxn2p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783229527; c=relaxed/simple;
	bh=o7B7SPrsBy5mQXuqsUqrrXjPlfdTB+mlWhlN+kpUbX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOBcAbnXKuet25ec6RapJnvoqwR4gPhUudG814YuPdu6R6cllC0ELTD0xaU6EQmszi5/Jjb3nKcsbYt9r3L7a8qlBlBdI3HlD98doASPuRyZWJwxM52zZwOiJA6ryZFWedRsIwDOg57E7KkvqfJuMkihmkE5l/sNbtdvEEonkyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=smC5ncv7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="smC5ncv7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=18J8h4umtbr8fqXNd/YM77/wiXxEnUfTQe5KI3DFGms=; 
	b=smC5ncv7VZTSMytxfbPr+1l2tjmfBWost6j/O/5TAIQJ9C18wENJz2TK720W2fEBlcOyQunS7ri
	bhU54KKA5mPDsWZTUljSSKoFIF6vv2f5mIVgIe3WIG+lhlxYAZYDPdno8rfLvLYLzD1vfOENszrAx
	ZqKtXIqhDbSYnV9yfXEzJ351BacpMRDtNn+48b9lkBBse9e1hHwGLIccIfHcnmGZDRcOahP574glk
	6mYNh0GjBURjeG8C5C9TGIKMvMb8ENhS7njEnu7r82a1LfodlWDsx7pOFFK5FXQ+cq1NbSecYCxKu
	TZ0nt7FtJxTXwekR0tluD4V64N3oj+ozKjww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgFSF-0000000Aje0-2Syv;
	Sun, 05 Jul 2026 13:31:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 13:31:47 +0800
Date: Sun, 5 Jul 2026 13:31:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	qat-linux@intel.com
Subject: Re: [PATCH v2 0/6] crypto: use 2-arg strscpy where destination size
 is known
Message-ID: <aknsQ7s_MCs0rRp7@gondor.apana.org.au>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>

On Sat, Jun 06, 2026 at 01:10:57AM +0200, Thorsten Blum wrote:
> To simplify the code, drop explicit and hard-coded size arguments from
> strscpy() where the destination buffer has a fixed size and strscpy()
> can automatically determine it using sizeof().
> 
> Changes in v2:
> - Rebase and split up
> - v1: https://lore.kernel.org/r/20260525103038.825690-4-thorsten.blum@linux.dev/
> 
> Thorsten Blum (6):
>   crypto: use 2-arg strscpy where destination size is known
>   crypto: cavium - use 2-arg strscpy where destination size is known
>   crypto: ccp - use 2-arg strscpy where destination size is known
>   crypto: hisilicon - use 2-arg strscpy where destination size is known
>   crypto: qat - use 2-arg strscpy where destination size is known
>   crypto: octeontx - use 2-arg strscpy where destination size is known
> 
>  crypto/api.c                                             | 2 +-
>  crypto/crypto_user.c                                     | 9 ++++-----
>  crypto/hctr2.c                                           | 3 +--
>  crypto/lrw.c                                             | 2 +-
>  crypto/lskcipher.c                                       | 3 +--
>  crypto/xts.c                                             | 3 ++-
>  drivers/crypto/cavium/nitrox/nitrox_hal.c                | 3 ++-
>  drivers/crypto/ccp/ccp-crypto-sha.c                      | 2 +-
>  drivers/crypto/hisilicon/qm.c                            | 5 +----
>  drivers/crypto/intel/qat/qat_common/adf_cfg.c            | 7 ++++---
>  drivers/crypto/intel/qat/qat_common/adf_cfg_services.c   | 2 +-
>  drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c     | 3 ++-
>  .../crypto/intel/qat/qat_common/adf_transport_debug.c    | 3 ++-
>  drivers/crypto/intel/qat/qat_common/qat_compression.c    | 3 ++-
>  drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c        | 4 ++--
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c      | 4 ++--
>  16 files changed, 29 insertions(+), 29 deletions(-)
> 
> 
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
