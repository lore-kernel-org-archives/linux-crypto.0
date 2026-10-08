Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE8930D3E8;
	Thu,  8 Oct 2026 08:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447722; cv=none; b=sMTE/Lj4W9yKx6BnmISKmQZgs4IOD8sNRLGx8+dzp3bMQK6FvoAHEkmYp3b2MMF48bdyqq+yarI/z0YgISdYjTK4uXAOShxpNJWOyVvmHFrwHNMvhZhh7mhRqljGmcg9XZwQw/jfeK0NZGPzRrvQEDSF7+jFqZY4PfSdTyjwk2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447722; c=relaxed/simple;
	bh=vkhh1kav9jYXrHUQaaXLU+1oyqlHK6L+Ks1wqdBLaSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vnr3jTFqyTQXsW7M9uBpg5I6vs4+jRigaR8qwAsa/jay7YockWb/UGWmFhhicQONQO3zpUV/2Id+neL/lw6pyQinD3lOt/mkXaQIrcKj1ysuF7Om8aapHl9INTnn1aH1jEwWOwjQX/s0arVMyY9rz+aG/kaYHWnm3O9DC0U6BrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ykmg9qvH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ykmg9qvH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fIv3HBeRAgp2YK0+oTNO3tJ3u2ms8phxGB5xde7o6Mw=; 
	b=Ykmg9qvHZN2CdMMwvBtFWv4oxqg6s2lXJdlk2HTGaQg7Rzd0bB4goOBpKPX9bW7N6RV9vf2WDqQ
	wUTW61/GP7MjHfi9B/VEOoZVYYKZJlaXTY39CFcYliXc3Uo2GEzU4MjW01SezrRKUsRVXSihySpt0
	X4srW5f4eofC2HpwPTceq6Om0jaHGKRH5RcLHXQ2BsQ7ytBXsLXR2jxezZTIc8wKOIo52ZKsQ/PDp
	vWMAg/fKFIXzAaExBxvVXUASYHgEOrUesRVZvjca3ukwXerEynzHJ2tyYKZtpCa9SyKRpPKvygDVc
	4qHPbYVcvhVV5tyeLsWwP+E0xzrDl+lZEmIw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjNv-00000001nkf-2mt4;
	Thu, 08 Oct 2026 16:21:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:21:51 +1100
Date: Thu, 8 Oct 2026 19:21:51 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: vjardin@free.fr
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam/qi2 - lower the algorithm priority
Message-ID: <asdSn2eaGbEs2FM_@gondor.apana.org.au>
References: <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929-for-upstream-caam-qi2-priority-v2-1-bf0559ebf574@free.fr>

On Tue, Sep 29, 2026 at 10:29:04PM +0200, Vincent Jardin via B4 Relay wrote:
> From: Vincent Jardin <vjardin@free.fr>
> 
> Lower the priority to 100, as done for QAT in commit
>   8024774190a5 ("crypto: qat - lower priority for skcipher and aead algorithms").
> 
> The SEC stays reachable by driver name, and user space can raise its
> priority through the crypto_user interface.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Link: https://lore.kernel.org/r/aruvJECCDNdguMdw@gondor.apana.org.au
> Signed-off-by: Vincent Jardin <vjardin@free.fr>
> ---
> v2 lowers the priority to 100, as was done for QAT, and leaves the
> choice to user space through crypto_user.
> ---
> Changes in v2:
> - Drop both the dpaa2_caam.priority module parameter and the
>   fsl,qi2-crypto-priority DT property
> - Lower the default priority to 100, user space adjust it with
>   crypto_user (Herbert).
> - No policy in the device tree (Krzysztof, Eric).
> - Link to v1: https://lore.kernel.org/r/20260928-for-upstream-caam-qi2-priority-v1-0-e4a8e5f01dbc@free.fr
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
