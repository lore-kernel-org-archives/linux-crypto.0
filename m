Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795166992;
	b=iXEokAc9bMVImL111o5NJif2hqDSmlXQ9/s28JJn7crY3Y2SOItCDG3Bxdo340pMlC/K
	 QHqKFnCvknIMxbxELVfAPnV9LDkLzF2y4ugHwNjNyBjJ97fNZdQ30D/Z3y7g1cQ4V4mp0
	 MLmmh+A6lwzavv5XvgkM1miW7Ri3NAYVM4vPYJI6gG8itZ+BHFtn/PG0TumQ+vOs6707D
	 ooOI8gmdsL32oA9LBS2+ougkURC4+j3iVh2lDwgCataF0UgTzq6wqwHXqV6bIs0ma+mxC
	 DtL6XwgvKdSUBp/PLw4EKfKK78S+NYph1kDZTIsgwX8odngqkbE4KXRH6ueloVbyQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795166992;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=OneOAIqipo41bSZQOI9fI6qsJAqBEiRyetb1aN1SI40=;
	b=up0zoSvfQlaphYX4uCf+eOL6lVhyDI9xQzBiEXAQ6g3lTf4ZRKHy5hr4lngXWpt+hG7T
	 9OUPaB3crqEWOp+X8jdh3hBw5gwYGW5W/GN7dQ+ak4o4u4V5ZqNjH1qnOWwp5lfA6s2Hv
	 7RxDdOaK+pn/8Xee3Cql3bNh1y4WTWG9AiHOFe5ttb1JLytZ/qn6Ck/GIzlwIydtd+dZD
	 c3PCXJAlsj/+kUxQFKVrHlQPGrWQxw8bb5/3EFgqkykCkwbGywtNjtzd/Jl2mCdR+HMV7
	 D5xxJawHQeJxOqa/YtOI4yWBsNnb4eE6SeT9k08JpQoOIkssWwhQGAygD8p3OaYHm5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Hl6MbtI1;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF7F606A326;
	Fri, 20 Nov 2026 09:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDF7F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Hl6MbtI1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OneOAIqipo41bSZQOI9fI6qsJAqBEiRyetb1aN1SI40=; 
	b=Hl6MbtI1Rf6SLjejsPOKjAXvmMujLeuUubPVFLgiD+sfJtyh8V+ZaG8hts3dnRWO9sLK2PHn6W0
	UW6DH43ksunxdDCH4RmVTuXvJQdQMkbmngMEzR0AQSjPtAcccUfvEjG5Y2ZA4RRsYpjC2pEbBBlsz
	HtuLbOIeh74vPT3geb3oPwx5bxsxNxAmq7na3kUmCvMwfwk1Lgr2eulVo5UDe4YcB3R0itn3mnk1U
	quAqvxfng0SxWp2K+P5gtEFBcI2LYZMYgYSJzxh4lCbW5bYJXK0YaIY+zwVGZrDKmEnwmSqOO7I3D
	5pQEaYecJX23JNuvYPDGDrqG8m8c+K9qapmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xUKw2-0000000HY28-2KbD;
	Fri, 20 Nov 2026 17:29:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:29:34 +0800
Date: Fri, 20 Nov 2026 17:29:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: sahil.malhotra@nxp.com, davem@davemloft.net, horia.geanta@nxp.com,
	pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	jeffbarnes@linux.microsoft.com, stephane.debusne@cynove.com,
	iuliana.prodan@nxp.com, martin.kepplinger-novakovic@ginzinger.com,
	lukas@wunner.de, sahil.malhotra@oss.nxp.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] crypto: caam - Fix RSA error-path unmap and
 unaligned dst buffers
Message-ID: <awAS_kKAVkL2uWKT@gondor.apana.org.au>
References: <20261114060032.872141-1-changwei.zou@canonical.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114060032.872141-1-changwei.zou@canonical.com>

On Sat, Nov 14, 2026 at 05:00:30PM +1100, Changwei Zou wrote:
> This series fixes two issues in the rsa-caam driver.
> 
> Patch 1 fixes wrong unmap operations where rsa_pub_unmap() was called
> regardless of the key type.
> 
> Patch 2 adds a bounce buffer to handle unaligned RSA destination
> buffers on DMA-incoherent hardware such as i.MX8, fixing intermittent
> -EKEYREJECTED errors when loading signed kernel modules.
> 
> Changes in v6:
> - Patch 1: Factor the priv_form switch into rsa_priv_unmap(), shared by
>   rsa_priv_f_done() and rsa_pdb_unmap(), removing the duplicated switch.
> - Patch 2: Hoist req_ctx to function scope in set_rsa_priv_f{1,2,3}_pdb(),
>   removing the duplicate block-local declarations in the src/dst branches.

Your series didn't apply for Sashiko:

https://sashiko.dev/#/patchset/20261114060032.872141-1-changwei.zou%40canonical.com

Please rebase and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
