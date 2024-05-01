Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3750C4E1D1
	for <linux-crypto@vger.kernel.org>; Wed,  1 May 2024 08:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714550727; cv=none; b=uQQHMnBYTcCP+wlH1/jK9VZMlzTDVKPvM4XMDCqWkNkpfe9/R5Q405EhnPMV2fseBkQqMjMze5PMKxt3mgOnyritnAXhuoXaGjCGoSPaocE0F5SY07NiiaoGLouyfxlnAJ+Ski06/yckhcMyE60iPz67x8X0rrOsWIGlukSvM8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714550727; c=relaxed/simple;
	bh=MZof5d1mhgv7CzpcqH+KM7GSyrV67SjSEWIYBEUuDs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DMVbdyuU4kPbAwBfqKZJqUgVG/Jnz81yla0YqqZe5owr8Ti8krM3jgoI2tv8MuE8QpO5vQVEsCj2k+iumsi0ktqwRitmaFZsXiHQFClZOm3RaHSnCBBxJsGt3ZrqMYbRj/LdLC9hL2b86bLMJ5RPNY10d5noAr8O9rfO3oLO85c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s24xp-0092mr-1M;
	Wed, 01 May 2024 16:05:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 May 2024 16:05:35 +0800
Date: Wed, 1 May 2024 16:05:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v7 0/5] Add Tegra Security Engine driver
Message-ID: <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>

On Wed, May 01, 2024 at 04:52:05AM +0000, Akhil R wrote:
>
> I had a question based on some of our customer feedback with this driver.
> While running tcrypt mode=10 with Tegra SE driver, it shows errors for lrw(aes),
> rfc3686(ctr(aes)) etc. which it does not support. 

Algorithms that are not supported by your driver should automatically
be routed to software implementations.  What errors are you getting?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
