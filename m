Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437204A1E
	for <linux-crypto@vger.kernel.org>; Thu,  8 Aug 2024 06:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098050; cv=none; b=WRgdUAIk5ixLy0bmVogoTABLwqTrwTfuiC1ZMp49j3KdRflK/q4PWw3tGelJ/6m+14Yg4U7Z0qwMNatP/F+HDomLv1CCSjRhJYTq3/FRskr+r5VJM5ClO4LwB+wtfxfkxV4l0l3490bci9+Xl7D+rxS7rtgF5fsNBL/SIu8LkPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098050; c=relaxed/simple;
	bh=lz+vgTfPCTOuvQihu+Bd6BQqI9KyCUskc5QQpJk/OKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D9qsNq0R/XraQpcFVtZkf76i0LMwhPUiPdPj2IIESWnYtU0x+HPyvsaojy5YNwsAKXuWTJ/yM6E5V40V054Ag8LdxM+dbqxczCCkJ/sIFoMoNEq6hd8mkxWSgdBylJVhK8dLVH9ZCXvdL5mJvOLlh4kDXRb/+iC72Vx4Eq4TO4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sbwNS-003Ekd-1x;
	Thu, 08 Aug 2024 14:20:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Aug 2024 14:20:43 +0800
Date: Thu, 8 Aug 2024 14:20:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Jeff Barnes <jeffbarnes@microsoft.com>,
	Vladis Dronov <vdronov@redhat.com>,
	"marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
	Tyler Hicks <Tyler.Hicks@microsoft.com>,
	Shyam Saini <shyamsaini@microsoft.com>
Subject: Re: Intermittent EHEALTH Failure in FIPS Mode - jitterentropy
 jent_entropy_init() in Kernel 6.6.14
Message-ID: <ZrRju-vVlIT_AMED@gondor.apana.org.au>
References: <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2533289.B1Duu4BR7M@tauon.atsec.com>
 <ZrRhR-IRZPrQ5DSe@gondor.apana.org.au>
 <2416186.INgNo8UaUA@tauon.atsec.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2416186.INgNo8UaUA@tauon.atsec.com>

On Thu, Aug 08, 2024 at 08:13:56AM +0200, Stephan Mueller wrote:
>
> However, the heart of the problem is the following: This failure mode is 
> probabilistic in nature. A number of folks trying to push rules that the 
> failure does not need to be handled with a panic.
> 
> A changed OSR only changes the probability, but that probability is always 
> strictly higher than zero.

That's fine.  There are many places in the kernel that will fail
with a probably that is non-zero.  It is considered to be acceptable
as long as the value is negligible (e.g., equal or less than the
probablility of cosmic rays hitting DRAM).

But if it happens reproducibly it clearly is not acceptable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
