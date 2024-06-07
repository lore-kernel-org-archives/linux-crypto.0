Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68881847;
	Fri,  7 Jun 2024 11:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761198; cv=none; b=hBgqnwRP1e3cu0Qd/GHkBSOFJjXqMrUiuV66NXlV9T39cEgqXjMHmifzt40f51fdnDVPEU0onG6VvXmrQ/AmpeEVYnmlAluUli2aGAD+Pjus9KvC7tVxJCBXnjI5NaReX8SWbnKpCzjQTfVx/0Wngr0Y9u6fETIlbHyVEyTkO/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761198; c=relaxed/simple;
	bh=ic5oUjYcQFZahlr2HCLFRnMbQ0rxTmKGaLjzGnF52Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpmVfiFwPCG+x1t/xjsf/YCDgv991j62U+obA+EMZ1LvBMjZlqTTzG1xjv8Y6SvY4ckmK02QcUtGcSAFkAmoMdoL6+jx/WDLdxBewV1H8kTMQ2pmXC5CPShlGmY4KwLYZ8EURCeZuyI73Aaek0U+xBZeypvg9V667V5qL8DZnWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFY9R-006p8p-1G;
	Fri, 07 Jun 2024 19:52:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:52:59 +0800
Date: Fri, 7 Jun 2024 19:52:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: Olivia Mackall <olivia@selenic.com>, Michael Buesch <mb@bu3sch.de>,
	Andrew Morton <akpm@osdl.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Message-ID: <ZmL0m6xaL9JXb2mu@gondor.apana.org.au>
References: <20240527132615.14170-1-ilpo.jarvinen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240527132615.14170-1-ilpo.jarvinen@linux.intel.com>

On Mon, May 27, 2024 at 04:26:15PM +0300, Ilpo Järvinen wrote:
> amd_rng_mod_init() uses pci_read_config_dword() that returns PCIBIOS_*
> codes. The return code is then returned as is but amd_rng_mod_init() is
> a module_init() function that should return normal errnos.
> 
> Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
> errno before returning it.
> 
> Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  drivers/char/hw_random/amd-rng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
