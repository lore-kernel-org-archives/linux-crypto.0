Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498971E1C36;
	Sat,  6 Sep 2025 07:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145041; cv=none; b=hXeJCj4QrIoy+UC3qMzR6LsQrDyMuGCKo2JnBL55k0PVm/cXpumwa937GoZImyeiZkHjUtmMtbBYppm/ATD5P9ISeBxNSREAu2bXb0JJLOeq/i69GBy91glszODSZRL/LWlMO1qVfCsHJPtdj+xfFoUPlbL+1MpmMjpHQgnomCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145041; c=relaxed/simple;
	bh=I6ewirHfFilzgWFJsIp7J6JT5ooxIoH4iIHeDPyElrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGDFFuPt2afEkq4sqWqdREajKkgEClzfn/aoii9oa0Lz17EWTQC4NBu4GG+9VLCMn39AAbpUpfd2g4uuulZKCgjpdPzhBJTapGNE0gr0YV2FtX/qAzBT1s41WjL7zQLzMRF/OSwhgtLB0no2+udSyDFHXcR0DmKs7sJOmYfHkAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PZNPnqH1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PZNPnqH1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lctvNUGYcgi3Bt8h4rA2xHl4eo82dhImqIQzH6nPiLg=; b=PZNPnqH1ZAh0CEk3SVCqzTGxis
	Rwoe67UVOqJ8Jb//CInpWzVGwjgAHbPkxQGnMPpBZ6V3UHhcjOTDE83E1B63ieO6n3qbw86Meordz
	b8Ygky+mvLseswMRZlgY2i7PFmMOJfFwSVBbi0FMX4a9LPib/EBPoXDESQWiFz9PERDC5m+z78CSo
	zIb7NvvUilX/8dAzxEM795XzR9dHDWdU26AR3MoVXP3r3S9KWngeoCo6rwMZsCGrJXOe17tclK/1O
	fXz9r2sjLJE7skXjI4Q/d74gbkHpKcR3Nkk9bEXbyfk4ezUu2PcHs+BfM5kPPQMWsnnTMJicCS8Fy
	dazcJdoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uunRN-003BJP-2G;
	Sat, 06 Sep 2025 15:50:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 15:50:26 +0800
Date: Sat, 6 Sep 2025 15:50:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <h.jain@amd.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com, smueller@chronox.de, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org
Subject: Re: [PATCH V6 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <aLvnwjp-ms67ah0A@gondor.apana.org.au>
References: <20250825071700.819759-1-h.jain@amd.com>
 <20250825071700.819759-4-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825071700.819759-4-h.jain@amd.com>

On Mon, Aug 25, 2025 at 12:47:00PM +0530, Harsh Jain wrote:
>
> +	rng->tfm = crypto_alloc_cipher("aes", 0, 0);

Please don't add any new users of crypto_alloc_cipher.  This
particular case should switch over to lib/crypto/aes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
