Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366C91D88B4;
	Sun, 15 Mar 2026 04:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773549161; cv=none; b=dzqyl6uhBNO6kWhEuip+BGlau4v+53xlcebF+wKHwzUW1zHvhOiq9RsiadClgXhjR2eRMTeZeTmb+ClthGI7Q3LsPvAqgjgK0lKE/QUz8XxK43vW2iimlEjGMfRPdG6DBogzXDFziV35xArvRByTNnLO8x0nkIcwOHavAc+PeqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773549161; c=relaxed/simple;
	bh=zpq+sNxamMrBg1Uq7drlzN/QlSL0QimAsnNvPrtia+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OhJ0uPM/te3ZVaMgKsD7a7DfxsGNAS8EoYcsgROGxfqO6DtrL+c/G02SZduAHnOoB6NSCt+z9BAyZD21aLIkAwCnIxcoHWDLY7ORG5BDbCJS9xd94/usaXjCGI/4gdHXYX4NsO8VZRAOiO/0rapN/ACPq3ORKFWnZ4FFUyhYZG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fRMnyzqU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fRMnyzqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lwCbCJuGf54eMlx7TTx9iL5exST1ZLf1KA3NYOxhd5E=; 
	b=fRMnyzqUzYko9QxYOXu3oIikIHzzRCOrMZt3dciIa72DMgK1SjfbNxYUwgxhnFdU6EaNlck+fis
	f/cVPV7EoWUzGLuLaaHDUfewI0NERLsylOD6ViIvaXTI81NDXriw9NSWM+JRUIU17fnAEngMoiao0
	zADZaNE0gqTB7s4zCCVMM5tJQKlShzF3yQOfINPBlCtd+CkI/owc9io41IFkG4djuFL3K8jgc4vwC
	nyfR3yi6ux5kvWyERL6+ycu7LOi/+bN8eAGPiNTIJK93clWq2eOJSU+gu+EjRQlqLdUzXS0ZIdtia
	SCvbShXe7TdIiNlyUJqtIL41QNny1/pr6rnw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1d9M-00EXUY-2b;
	Sun, 15 Mar 2026 12:32:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 15 Mar 2026 13:32:24 +0900
Date: Sun, 15 Mar 2026 13:32:24 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
Message-ID: <abY2WLnFhfdJXO4U@gondor.apana.org.au>
References: <20260303060509.246038-1-git@jvdsn.com>
 <abTuFto8Tc3mhRRe@gondor.apana.org.au>
 <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64592fee-1956-4a70-a751-9ac3335cfc27@jvdsn.com>

On Sat, Mar 14, 2026 at 07:43:15PM -0500, Joachim Vandersmissen wrote:
> Hi Herbert,
> 
> I don't think this one can be applied yet since dm-integrity still uses
> xxhash64 through the crypto API. This would break fips=1 systems that use
> it.

OK I've removed the patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
