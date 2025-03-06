Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD881F3FF8;
	Thu,  6 Mar 2025 08:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741248754; cv=none; b=IT8c3N+qhhoFUHTp5qhLjHOOu9J+QWNPMpiY2op0WPUAWxJfWZb9ohmZauOwbWQcGegjfTH3iMyBILf91rkHnefGXLUlel3lWJCTtIp0KqRolC9ysPAXbefyrjNejF1Pn/nZtq8uo8YxMGlvSMRcTrK+G0/3v1kzuif5vgqFbAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741248754; c=relaxed/simple;
	bh=wl2BDLiRBF6hoKXY6axrcQy8DYsjUmOVVI7P/s2cE1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tREu7I4fH8/7ORIcwRjqyk1qhJWOOScvvC6MPAeVKjVmOu8vJngGS56dZY7jNrZcRGR4bedrBm1kRaAldx8iGRwoZRrTGl/kjN4ggCVefy4tXH3n+dTmsSKkfCItIHfDSdFIVs7TXEcnLVgJ3+zfukV5AAgmNTZIUuJn68YW+6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N2Z4VPpn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N2Z4VPpn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/9lsyVw/jLL6PgCYLWqutBR3oMdvMfXAvoJtnAK45Do=; b=N2Z4VPpn/+sXJ/OvgU9GgY+ZUj
	uvaxUzXZQsf5WCP6hxVswH6hia1WFb3T3XUCs/Nq4XXrWTxcl1u1m1qZbqm7tMEfaDdIIqCMycmlb
	CoX1syO69gChTmRaC/BKPeYHC24bvg23a6lRKPdY8sGTR7Yv73IX/SeZp7cc0g+lviZMcHja4fJjS
	XixyyY0JXWOnsaUowgbk7BxnNV1aG8szWyhKNp2UgCOW/5fB+dfauAN8u8kTP9hgkJL16UbQ9HmOb
	o26gjtwCi7md86nfKxqfvZkENi4C8+aNOJ7qG8Z/c6VgXtokFP2Jfxpek82AUr5+usvsNk+26BRDC
	jRMcn6pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tq6L7-004D90-1i;
	Thu, 06 Mar 2025 16:12:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Mar 2025 16:12:21 +0800
Date: Thu, 6 Mar 2025 16:12:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Akhil R <akhilrajeev@nvidia.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate
 dynamically
Message-ID: <Z8lY5Qd4g5eMDMnu@gondor.apana.org.au>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
 <20250224091610.49683-10-akhilrajeev@nvidia.com>
 <PH7PR12MB8178B92B6ED11B891AAFCE0BC0CB2@PH7PR12MB8178.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR12MB8178B92B6ED11B891AAFCE0BC0CB2@PH7PR12MB8178.namprd12.prod.outlook.com>

On Wed, Mar 05, 2025 at 07:05:25AM +0000, Akhil R wrote:
>
> Do we have any other concerns with the patches in this series.
> If all those look good, I can push a new version with this change included.

I have no other concerns.  I can fold this change in if you want.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
