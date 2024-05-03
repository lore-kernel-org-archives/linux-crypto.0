Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3A41DFCE
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 10:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714730447; cv=none; b=Dl5f8SsYCXeTiTaqAOijPUY2JVAePPvV5bCfpZRp4qwZbaTVQznaYS4cyAVaXyRVYrnzYrnQ7nQvBGCo1GzKSO8rblYalsNykfPqP5XpoOS0QT+Uelu+0LurRd1+TY7YdpVmpSzzRsgm+YsMS5AwU80OQP/t6hmG5WyQvEPwNu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714730447; c=relaxed/simple;
	bh=N8Q2Qgbo8xTLPpg+S3wjHiWyeBcDt2VrhxQNAt/Ns+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KnsiURrPmbGa5adPzhr1GTScS8LG6C4N/AmuPfa/NcWJjgejgweKptva9i5M3OLSVuCcsCKCqfXjT+T+KJPPRQWRhTUR2G14qBP97AFdJi2vvj9dRPba1efJ0BViVCW/Qz4tID2B3DSayCuQAY78W6EP+UTBs3bLBLOARnEqhTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s2piV-009tuw-1L;
	Fri, 03 May 2024 18:00:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 May 2024 18:00:35 +0800
Date: Fri, 3 May 2024 18:00:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v7 0/5] Add Tegra Security Engine driver
Message-ID: <ZjS1w5S-8FGOVLtb@gondor.apana.org.au>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
 <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>

On Thu, May 02, 2024 at 02:56:42PM +0000, Akhil R wrote:
>
> I get the below error. But this is because we don't have CONFIG_LRW
> enabled in our defconfig. 
> 
> [ 1240.771301] alg: skcipher: failed to allocate transform for lrw(aes): -2
> [ 1240.778308] alg: self-tests for lrw(aes) using lrw(aes) failed (rc=-2)
> 
> So, I suppose enabling the defconfig is the right and only fix here?

You're not supposed to be using tcrypt to test drivers.  The driver
will be tested automatically upon registration.

The tcrypt module is vestigial.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
