Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA1E2BEC44;
	Fri, 18 Jul 2025 11:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837216; cv=none; b=e8nwIqPPlUQ0NGyWOstMZ7lSvuuQZOlMuNl3VqLLBdeTguOAuJEOujOgJDRCH/UdtAOm9LLeDOOIjQSsW4gJsL84dMPCRLI6p++J5Cgb4inVPuHWCEiOoDlUNfLWqtAHnRzAjxtH86LNCQLBGknlCiZDVOWVnH9WdIvQN0s5pZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837216; c=relaxed/simple;
	bh=JL5F+QMyAbZRgl1qNW2EXe1o8d3EBJKY1WaFusUNqmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCKlw6UqI6kps1lGVrHCpR/HTtwSTi9reQ4nDdnJH5UdPwQTrLoTy9YQrUKLW9P9OioVTez/OLbpYYTJ+UInrgru3LehpHdAS/8nBImDGRjYimODjunkxKQqgQRsf1LC1CPwduO0yKpy6GhliJT5Uyk5118nBxys1QnfEuaJNJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IRqfuQIK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IRqfuQIK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wV4SP9Ub4GxAfJeEGt1fuHcJt5aoaEgYsz+HesyeccQ=; b=IRqfuQIKz9uFJUibejaVU0BHYf
	t0CaJ6GP7AWLHFNH2ArHDmicIZrO8AizfkOoMgaCf6UhxZAcGiOl+muPjvzjpKxMZY2pf519zvDoY
	S5hal3TZkVSYRzGWJ3a1VxrYVzfEqXMrygasSUmBBQ04aD4GPhdZm6vu2nQp0778bnIeovS0Use0U
	h0qb/05UbaLnEIy/yCmSTYd8rMv6tiSai0Q4E3ElEo6k0JCMVu5jQQBPb9kXWSNGJ4SFctAbvBCZL
	E1PIvgQgyHIGV2xymGhV1uvLESWUPrZRj+FdNWX9BvVMPi+002U3m/VxOhX65HBwALeFERImS6xnS
	3BQj8TZQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucimR-007ynq-1Z;
	Fri, 18 Jul 2025 19:13:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:13:27 +1000
Date: Fri, 18 Jul 2025 21:13:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, freude@linux.ibm.com,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	arei.gonglei@huawei.com, virtualization@lists.linux.dev
Subject: Re: [PATCH 1/2] crypto: engine: remove request batching support
Message-ID: <aHosV3T9l0OQkKY0@gondor.apana.org.au>
References: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711182932.918257-1-ovidiu.panait.oss@gmail.com>

On Fri, Jul 11, 2025 at 09:29:31PM +0300, Ovidiu Panait wrote:
> Remove request batching support from crypto_engine, as there are no
> drivers using this feature and it doesn't really work that well.
> 
> Instead of doing batching based on backlog, a more optimal approach
> would be for the user to handle the batching (similar to how IPsec
> can hook into GSO to get 64K of data each time or how block encryption
> can use unit sizes much greater than 4K).
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
> Cc: freude@linux.ibm.com
> Cc: dengler@linux.ibm.com
> Cc: linux-s390@vger.kernel.org
> Cc: horia.geanta@nxp.com
> Cc: pankaj.gupta@nxp.com
> Cc: gaurav.jain@nxp.com
> Cc: arei.gonglei@huawei.com
> Cc: virtualization@lists.linux.dev
> 
>  arch/s390/crypto/paes_s390.c               |  2 +-
>  arch/s390/crypto/phmac_s390.c              |  2 +-
>  crypto/crypto_engine.c                     | 25 +---------------------
>  drivers/crypto/caam/jr.c                   |  3 +--
>  drivers/crypto/virtio/virtio_crypto_core.c |  2 +-
>  include/crypto/engine.h                    |  1 -
>  include/crypto/internal/engine.h           |  4 ----
>  7 files changed, 5 insertions(+), 34 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
