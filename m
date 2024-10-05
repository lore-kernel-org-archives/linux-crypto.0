Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A043D67A0D;
	Sat,  5 Oct 2024 05:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106729; cv=none; b=WcyKh1bdGj0V27DRNt1f40BbcL2VAY+q6IS5u4ehBnapfntCm5tYads+WxpDz8WbhV4Ou7w6SBa9mrn6y0J4uet7sIf7ERJBojyrlAsYXGW3FsSMhYe/za1YrHiAXNarAgFq40e123oNCopzPig1QwAvy5O++XyxtnVTSiFXm30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106729; c=relaxed/simple;
	bh=atLFrNZEDjDQjjFLmt6CxKrY9olvExa9lyJvDKFFrYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVDDXrhuDT8cQ3MuTSW1Nx8eJoXyJRMi/W1tW2OwI0t0bLO0fHmW0QCvW3Qimq9UQy6URcRQAYA2igTapd3SY/qzJPEOY+z9gAs6P5LMOo34pwF1Y3fPqGoLcCw5W95IgfKQOOLWXOGgh9xTpOglrhYfwqQZBQ3R5cszCyDMthU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=etrrLw9m; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="etrrLw9m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1GMpXlsg1kAimabeSQ+m/nn+r6XfSsq4cKbfKqdPwSE=; b=etrrLw9mZskuvQAM70eW/kKkHA
	yV/CJmSCvZDIk8TMypFBxMc+qo5aqhhpu/U32KcbbYCMmNaHWHyj7PHLenmUD7kmXSzyfhqntEgfc
	Cqn7cNGB8kTzBWlSk0WQZPIIp2RG1mbj1pTkNl6p5wODw+ryjxKBDndSa6m66S7+PhcGuCbOVQPTa
	Jap86VT6v7ye37OqD+M1BFLkE8CfMVke76AozOcoLsS/QXBumzhYrPWv2cq+zZSHvsAniVwjlYYoM
	qWonPEUcWNKxTCVJQKVjGtPOFYs1DE1gmrQacxI5/wEiMYtpeJvdwgPNGC3Nma77fg8k3guBijYQQ
	gglxT0PA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxL3-0071cv-2f;
	Sat, 05 Oct 2024 13:38:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:38:35 +0800
Date: Sat, 5 Oct 2024 13:38:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jie Wang <jie.wang@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Dong Xie <dong.xie@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - (qat_420xx) fix off by one in
 uof_get_name()
Message-ID: <ZwDQ2zEEnYYn4tth@gondor.apana.org.au>
References: <796ecd7c-54ad-4bec-b748-3e156cc0a1aa@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796ecd7c-54ad-4bec-b748-3e156cc0a1aa@stanley.mountain>

On Sat, Sep 28, 2024 at 01:05:01PM +0300, Dan Carpenter wrote:
> This is called from uof_get_name_420xx() where "num_objs" is the
> ARRAY_SIZE() of fw_objs[].  The > needs to be >= to prevent an out of
> bounds access.
> 
> Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
