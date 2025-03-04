Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDB61DC985;
	Tue,  4 Mar 2025 05:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741065601; cv=none; b=LO65/rvx4mVTMQtTQSonzQDSU1if5QY7kl18AJRBPJmIYm2oCoehrgIa4JRXgfI42SizJpbzNGi7HWQww76EVanbo7DbeSqZSc0m3xPlV9friCViH+anqnp+w3xM+GLS1HoW/2vl0QvwYPreyS4A8jxow943124j/kcau2nmdPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741065601; c=relaxed/simple;
	bh=LrU1y8Yk/oZhM5YIACdZYLM99zyWeHAhmfmSrvfD8IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6X5efFygVPf6BQMq3nHvqWedlVez2ev/Ypx4VLzhUg1je5HEUdWU/WbTpblVlbLJd/AbnLzySnBS9+w1zjdAJaOx+CIUGsOMFCUNuFJRcKm/ixPO74mMYRBIQfmUgi8ENjTwjMClYXBd+hFawnsLiT+FHexTiKg1qkiUdvpumE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z9TSs+Oh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z9TSs+Oh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sTB7OSG/jPKCsZcpm18gwfMQ6rv4CO/v9UhqKKSFcP4=; b=Z9TSs+Oha0afGDaZXLt5NJNPpi
	K6nfiV4QEDPMp8IBscvfsrZEPZzf/poZz8rY3Ba2gxv0NkTYlqujzUTcH1kIERwlksmB+LjAtQnes
	IIg0v0ER05zyDYBEfYoqrfeTA1jhuD7C/xKcgEqJ45XANnUUksiUBCDSdpvbVRuVa74dxzWBqYOX0
	TF6KWRH9WwgI0oKPy1ys+KCtlaRDxOiODr2yeb/++ZojxDTQnvTXgsjQvHxhgG65Z/RFrcIjPWyma
	ylLuSvH35X6nSgX0+Cb4VhD1sDzrFjlnrbzeNqzLaAH1M8Oomm52ZMaGh8TCsPKm8lDLkkl7W+5i6
	nHjweGFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tpKgl-003VMD-1r;
	Tue, 04 Mar 2025 13:19:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 04 Mar 2025 13:19:31 +0800
Date: Tue, 4 Mar 2025 13:19:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v7 01/15] crypto: acomp - Add synchronous/asynchronous
 acomp request chaining.
Message-ID: <Z8aNY5TFj_-os4Fd@gondor.apana.org.au>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
 <20250228100024.332528-2-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228100024.332528-2-kanchana.p.sridhar@intel.com>

On Fri, Feb 28, 2025 at 02:00:10AM -0800, Kanchana P Sridhar wrote:
>
>  Step 2: Process the request chain using the specified compress/decompress
>          "op":
> 
>   2.a) Synchronous: the chain of requests is processed in series:
> 
>        int acomp_do_req_chain(struct acomp_req *req,
>                               int (*op)(struct acomp_req *req));
> 
>   2.b) Asynchronous: the chain of requests is processed in parallel using a
>        submit-poll paradigm:
> 
>        int acomp_do_async_req_chain(struct acomp_req *req,
>                                     int (*op_submit)(struct acomp_req *req),
>                                     int (*op_poll)(struct acomp_req *req));
> 
> Request chaining will be used in subsequent patches to implement
> compress/decompress batching in the iaa_crypto driver for the two supported
> IAA driver sync_modes:
> 
>   sync_mode = 'sync' will use (2.a),
>   sync_mode = 'async' will use (2.b).

There shouldn't be any sync/async toggle.  The whole zswap code is
synchronous only and it makes zero sense to expose this to the user.
Just do whatever is the fastest from the driver's point of view.

I've actually implemented acomp chaining in my tree and I will be
reposting soon.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
