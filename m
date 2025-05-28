Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18692741D1;
	Wed, 28 May 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423499; cv=none; b=r59pGB1BVgaXKaHbtehkAQHPD70M+BP0RfIE07vxknChSF0TnxQnOy9SdZGeC6vqtVxAKqP7d2/NbAcgWh+KesLYR2Eh7XytfALkSnA591ydXts9l6kP8DVrRBQrBtzULD7YjGBO91Ds1ncOik4gB2oCsRqVwbOsd7LRNFDHlVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423499; c=relaxed/simple;
	bh=/vFKPh1GQHh0XWIVc4hvR0PFnGcJUo/nTfkkPEZSCHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUg5DYj657Od/HbRfFtdeNJ2LAVNCcrdSJ290Vg+jtg99mUcrV55WrRsnkgYsnoAR0hhWiT2PZKFGKDsIvKpcjXsCgi6SDVkWIAo6UEBhX0HsxSQjTjTzyH6Yjp+ldYhG2bg6iwPVqqBX/jsR13GcKuOs7ut9Fl3nBk3oWKgClQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XiYGsPpB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XiYGsPpB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/hsewaW5gU0vrr/tJ3ygObI/8cfPfFw3hytDh49lKGQ=; b=XiYGsPpBuaWC3YQZni+30nSzjA
	xGxLsD0LdOE6O8C/2gdpedsoyGm07jG917zdcMvwPGa+fz2AdxxdzgiWcEUWwnr5Y6HcG4uPPYidN
	3uLWTJCGj745hWOOCq3ALwXH6CCokZxLUpMFhgYdgm7N3AdZ9WsFkyYLCLKZpFLouunI6530ZZJyZ
	xgwH+45vviAp7kuM0mN0zkQOQK1OrOOhb2JXvT7QxHyB/8qp5nlsISoVOmKLGTXzzXryuZCwM2QJG
	o4HwnH7ah9B0SATr1cgppuhBS7WPIT1M58/UIPY7xF5oxSydl5deo4UcsUg4zTS1Usrrf5KzKesRw
	D1Qv6Lwg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uKCoi-009OwC-1g;
	Wed, 28 May 2025 17:11:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 May 2025 17:11:20 +0800
Date: Wed, 28 May 2025 17:11:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
	lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [linux-next:master 1170/9308] drivers/crypto/ccp/sev-dev.c:1312
 __sev_platform_init_locked() error: we previously assumed 'error' could be
 null (see line 1297)
Message-ID: <aDbTOBjTo0Le7T5a@gondor.apana.org.au>
References: <202505071746.eWOx5QgC-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202505071746.eWOx5QgC-lkp@intel.com>

On Wed, May 07, 2025 at 02:09:22PM +0300, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   0a00723f4c2d0b273edd0737f236f103164a08eb
> commit: 9770b428b1a28360663f1f5e524ee458b4cf454b [1170/9308] crypto: ccp - Move dev_info/err messages for SEV/SNP init and shutdown
> config: x86_64-randconfig-161-20250430 (https://download.01.org/0day-ci/archive/20250507/202505071746.eWOx5QgC-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202505071746.eWOx5QgC-lkp@intel.com/
> 
> smatch warnings:
> drivers/crypto/ccp/sev-dev.c:1312 __sev_platform_init_locked() error: we previously assumed 'error' could be null (see line 1297)

Ashish, please fix this or I will revert the commit listed above.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
