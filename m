Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80D1FBC90;
	Fri, 18 Jul 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836278; cv=none; b=hFPRHXLJv80p9TMhBlLMWWuKqoyjbgQh8bAvKRw7gUMPeVx6eCKNbPjU8bxsajBF7aGjTQNKBKPzp+N0/UilHkDLEEybdA0yv2X2vtCK4YCiuITx5GFducCmi0cpWFDx/JzdTwDOxx09Fk9Hn7I5ERAhKdYGDZHVWFt9zjq5bUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836278; c=relaxed/simple;
	bh=9Sas/9RWDgjKPPg5Wakrc5PaU0az/U20Xx2jtfiJH/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cKnxsMDaMAN54tslI7x6uXuZ8CJMK4aClyOpH8kuD0es+ppZClFsxrwTM0rOV+7r+1dhQZuScb+1pHdxj/wVGZXYTVABlahKwmHFMWzuF2eb1LTkSHOKykkvVeHWC0TxEJx8sb2y7AXVmnhmH92XWTGsQwPgiRU/ZGMtZ1rB0yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jvkVwIk5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jvkVwIk5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zYEm9n8Fg8OJrUS6PB50lr19hINVLQMjXj8flmJUffg=; b=jvkVwIk5Y/Mt+Q7VOqdM4YtjT1
	uiLJcllJ8P4RXxH2EXmKPK14jUAn65pqfRFhZwp0a+dsJ8PYTlL7lqiY5jaMq7SyeT5ZMhJHa6Reg
	SW52ADN7FEZi64J5Qt/6ZOPOt+hI08S3SvUlgPkwIWwHEXZNzKOTqr1F80uKul+cS3vo/j4jZEt0J
	EpI3Rb73DJQoNGVMrKvntKGUmme57NOjRmfEvcWVQlYcPiahWByeFQpwlgqb6WeARD4VuJaj5lfbY
	kx6FTDuccQCufFfCxLvsFbV4c6L3Zc5I9ThUzdf3gjd5en6eDDnRlvaXrrr/rjafX9niebfKY07i5
	xyMGHdxQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciXJ-007yZH-0I;
	Fri, 18 Jul 2025 18:57:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:57:49 +1000
Date: Fri, 18 Jul 2025 20:57:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] crypto: caam - avoid option aliasing with the
 CONFIG_CAAM_QI build option
Message-ID: <aHoorRAImpjjvolm@gondor.apana.org.au>
References: <20250701112045.18386-1-lukas.bulwahn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701112045.18386-1-lukas.bulwahn@redhat.com>

On Tue, Jul 01, 2025 at 01:20:45PM +0200, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> In the Makefile, the new build option CONFIG_CAAM_QI is defined conditioned
> on the existence of the CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI, which is
> properly defined in the Kconfig file. So, CONFIG_CAAM_QI is just a local
> alias for CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI.
> 
> There is little benefit in the source code of having this slightly shorter
> alias for this configuration, but it complicates further maintenance, as
> searching for the impact of CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI
> requires to grep once, and then identify the option introduced and continue
> searching for that. Further, tools, such as cross referencers, and scripts
> to check Kconfig definitions and their use simply do not handle this
> situation. Given that this is the only incidence of such a config alias in
> the whole kernel tree, just prefer to avoid this pattern of aliasing here.
> 
> Use CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI throughout the Freescale
> CAAM-Multicore platform driver backend source code.
> 
> No functional change.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> ---
>  drivers/crypto/caam/Makefile  | 4 ----
>  drivers/crypto/caam/ctrl.c    | 6 +++---
>  drivers/crypto/caam/debugfs.c | 2 +-
>  drivers/crypto/caam/debugfs.h | 2 +-
>  drivers/crypto/caam/intern.h  | 4 ++--
>  5 files changed, 7 insertions(+), 11 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
