Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E216C877;
	Fri, 30 Aug 2024 10:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014210; cv=none; b=Y3w/qlUc1msHYDQGsQa0Fv+QweYsvsuUZKzU5aIfx+r7IECZT9CyKcByU3aGnHmkgG/bVYo2jOd50KBNLYX3xylmsRNgG+fVLGnGmtO/RSVN48U0pRc/R3/v+HVNJS3BtuaRcI6FxpeF8LveqWRQGcWZBUVgts9pgtWIyG42zFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014210; c=relaxed/simple;
	bh=jF2QMu9IY8eTSqDkYdpxOVExKVuW9wRtm+UWp71AO3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqB1gpx0bA6NQo1WEYa5bEUuVzRImyhVWHhUsgo2nH/Hq4TjMHXuM2nbpS3epT1FbY3+2Utp/nSHddZ/bYg0sP0cef8Yvrm05owfbIbyAGOf665yI/fc+29qVlm/MvQYeMw6bK9zc+i09uEDKJj7SlWaMdlDFtFcFIojY7RpykE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjyqx-008Uog-1U;
	Fri, 30 Aug 2024 18:36:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:36:24 +0800
Date: Fri, 30 Aug 2024 18:36:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yue Haibing <yuehaibing@huawei.com>
Cc: davem@davemloft.net, clabbe@baylibre.com, linus.walleij@linaro.org,
	atenart@kernel.org, arno@natisbad.org, bbrezillon@kernel.org,
	thomas.lendacky@amd.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next 0/6] Cleanup unused function declarations
Message-ID: <ZtGgqISfvQNdt0fN@gondor.apana.org.au>
References: <20240820082525.259337-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820082525.259337-1-yuehaibing@huawei.com>

On Tue, Aug 20, 2024 at 04:25:19PM +0800, Yue Haibing wrote:
> Cleanup unused declarations for crypto driver subsystem.
> 
> Yue Haibing (6):
>   crypto: safexcel - Remove unused declaration
>     safexcel_ring_first_rptr()
>   crypto: sl3516 - Remove unused declaration sl3516_ce_enqueue()
>   crypto: octeontx - Remove unused declaration otx_cpt_callback()
>   crypto: ccp - Remove unused declaration sp_get_master()
>   crypto: amlogic - Remove unused declaration meson_enqueue()
>   crypto: crypto4xx - Remove unused declaration crypto4xx_free_ctx()
> 
>  drivers/crypto/amcc/crypto4xx_core.h             | 1 -
>  drivers/crypto/amlogic/amlogic-gxl.h             | 2 --
>  drivers/crypto/ccp/sp-dev.h                      | 1 -
>  drivers/crypto/gemini/sl3516-ce.h                | 2 --
>  drivers/crypto/inside-secure/safexcel.h          | 1 -
>  drivers/crypto/marvell/octeontx/otx_cptvf_algs.h | 1 -
>  6 files changed, 8 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
