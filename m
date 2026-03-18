Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6AE373C02;
	Wed, 18 Mar 2026 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773836180; cv=none; b=GWCZGHDRhfmytDzXqPIj0u6+lF4MS6Y/n/UYEXwY5ZAiqaAeuzxruQEAcv6EOq94hVQpoH5CyjzLiCdOfqS3okLwDMj8/6hj+glhHwu3ZFPOcc7R1Tnjg4HlhVIunAQTsnS5VdGmKU3yFVK4xBVBme4rS+Rk78hjuxUAV4CJcN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773836180; c=relaxed/simple;
	bh=uOreDMcqeQ466bTFq/zQ6/ClqMUrdjfwsTzWUrk94MQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1zjylytF7xxW8/fMCxDFFrzm4CyZaEqNZhnEW3hCXVngY0HBKm2PiYetM7+NlHr6H9+nI1tAO4b5TB0L9Ff8aQaIBaUuQv5v5mrNsbfZqlDg4aisHubYIMzh7dhuC1SiB0/XqncSLUCDUMdvlDgb9uW0GYg1xYaCD4EQoKfj6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VfxU2J70; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VfxU2J70"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vSw5ZKHs4fnsQKYg95wz84FMtjXdALmHHoPImRYM7PM=; 
	b=VfxU2J70/Z4sdWlJn5t3cWV61dQeDZgLbZdzadge+lQ2jA/gdExw0iQCye4vcf8gohGrVRy3Ugc
	CueZXN+ilHNyWtOqMaPKSAgkyGh8sL8tmr+I3v3UAw87X7/A2ibv6dVMKEVqR6PMNQ+k3bUidulRv
	mMyssAXhXdH5vsF4jAz7zslrNvw1U3sznvyHsf7GiCgM/P2mrFDzBMLW5faLYRMympjqXaVJ0bUpL
	gsz6Hi8h6jBCMWeRgs48hIEMKeJ3izlgQZQ8uUHBYg8SBYA90to052wKOb8tugtLgyPXssA4d9/BN
	3SFsXNJetdKAPfmbo1Z6Xp+8gOf4ZJQ0V7Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w2pog-00FQTD-1D;
	Wed, 18 Mar 2026 20:16:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Mar 2026 21:16:02 +0900
Date: Wed, 18 Mar 2026 21:16:02 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Yuan Kang <Yuan.Kang@freescale.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - remove HMAC key hex dumps from
 hash_digest_key
Message-ID: <abqXgt5x232kEPUj@gondor.apana.org.au>
References: <20260306111204.302544-1-thorsten.blum@linux.dev>
 <abTqefme_iApfHZi@gondor.apana.org.au>
 <abk4_r-KUYIhvyNL@linux.dev>
 <abpYWkDzofozlOWp@gondor.apana.org.au>
 <abqUQxdoH7zuszZQ@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abqUQxdoH7zuszZQ@linux.dev>

On Wed, Mar 18, 2026 at 01:02:11PM +0100, Thorsten Blum wrote:
>
> My main concern is that with CONFIG_DYNAMIC_DEBUG enabled, which doesn't
> require DEBUG, these raw key dumps can still be turned on at runtime in
> a deployed kernel.
> 
> If we want to keep the dumps for debug-only kernels, then #ifdef DEBUG
> plus print_hex_dump() might be a good compromise.

Exactly.  Having sensitive information printed with DYNAMIC_DEBUG
is arguably a problem, but putting them behind DEBUG is definitely
OK.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
