Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5319F77F19
	for <linux-crypto@vger.kernel.org>; Tue,  6 Feb 2024 05:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707196560; cv=none; b=D3IAOnqEHG/tbfqaNseE1xwgmW8Jm3DcYhgpIkTNVbY6fpAnChQlF4zH88QSp7++87YsJBj161QMQ1b12n+EQYWJlMKjlBxduuMDANfj6j88INAwF8ZVJzFqtmFl1cfZvrQ1SDxIrEFUoUzN0FwXoCiMEAxHYrRmGkoIi0clVf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707196560; c=relaxed/simple;
	bh=iAlMRhzaxQsSNUgqKwQMeksATh0vRaMf4UqfDXsW9Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lh65n34MQ9SIlQN4KqqeLOwAlbNJgAGL128ePk3R7rSG9okzwOsrj1UyAGOTUESGLeoAUknwbo9Kx1rkNBaJtBL9mIKlTdeI315smwCyVzi103urSMHC6grQCQj8+dwk18Hc0tpUqOpTYB8DMImAJK6J4lCEMqgVZFHQVqhRee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rXDoF-00ASSZ-3c; Tue, 06 Feb 2024 13:15:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Feb 2024 13:16:04 +0800
Date: Tue, 6 Feb 2024 13:16:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: Failed self-test on ffdhe6144(qat-dh)
Message-ID: <ZcHAlLdWfMhcACn5@gondor.apana.org.au>
References: <ZcC/C/kpcKaoVPp4@gondor.apana.org.au>
 <ZcDwxipP+CR8LBE8@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcDwxipP+CR8LBE8@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Feb 05, 2024 at 02:29:26PM +0000, Cabiddu, Giovanni wrote:
>
> Thanks for the bug report.
> I'm looking at it. It appears that even if I have
> CONFIG_CRYPTO_DH_RFC7919_GROUPS=y, ffdhe is not getting registered.
> I'm trying to understand what's going wrong.
> 
> BTW, do you have more details, like platform and kernel version?

This algorithm requires instantiation, so try:

modprobe tcrypt alg="ffdhe6144(dh)" type=8 mode=0 mask=15

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
