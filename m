Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E772222E3F1
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790310; cv=none; b=DfzWfG73WEUK42+kZYT7FAd1qpp3RRgQ/vwitpp4INbqky1JnQWPIIsb4Zvs2PU111T978+J9PgCdskrZzPklcfKAuvVNi2AGa0AN+z+qal/H/qs2+IVWUBBRBAmY0RH55Fdm7nsNXJtZ5k/XHbn/rLijuUtnD+WITu1Hgd2UmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790310; c=relaxed/simple;
	bh=Wfx+PF36s8ilnvvCUrjso4IzuvqfByLL3voPwWcDTFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRrap9On2pLLhpoLXs2HCgZkF4TOXNWb299TfgrE52G4oXw3DFoRG8a+0kXAtsfVA4LskOAEKbQmgytXOZ/tMK8avw5HHcOu/l2MFy0esYpvtCJwMlBAWzE2CgX5Rm7gBkwX9ck2YYlCuCmQYU+E9uhoaGFsx455i8wO7nGaBOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JbKawVCg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JbKawVCg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xoWHXtften/lUbiJBml2hBCsuMZ21wIlk4QxBfXkS3s=; b=JbKawVCgPm2re7jfhUtUt73G74
	tXPzSu7vBAi/lpfKvoTqvBuTnY76PG1u0KigAwwwYbd0M6m7/KecLK1/21GlLJOIbiBP3Y2IYTMoI
	qoV94/bRmruE7Y9qoSbJ7VELrIIWWknHuIITaWnzbEqI34drIGV7sk0QkU8FDF3gHKGkQ/DGPcD51
	YGNqiadPiGl73aueuB3ZJiIVR+TUxW1iYKDc125n1OjsVhX305RI6P3fVsh3Y9dUbPdNNIurCtSIV
	LhMHUTzGtVur/QSSCecJSnC0ENsWkqHZ9z3cPrhtjqATW0tv5gc+QPampD0aZ0jY6O3uFqeZ3tqIU
	rnJC7fzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xf2-00G7tZ-2s;
	Wed, 16 Apr 2025 15:58:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:58:20 +0800
Date: Wed, 16 Apr 2025 15:58:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-crypto@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 0/3] Use a local device pointer for hwrng drivers
 instead of casting constantly
Message-ID: <Z_9jHLmgaG7wjAhT@gondor.apana.org.au>
References: <20250410152239.4146166-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410152239.4146166-1-sakari.ailus@linux.intel.com>

On Thu, Apr 10, 2025 at 06:22:36PM +0300, Sakari Ailus wrote:
> Hi folks,
> 
> Clean up random number reading by storing struct device pointer to device
> context struct. The changes are very similar in all three drivers.
> 
> since v2:
> 
> - Add a struct device pointer field to device context structs, don't use
>   struct hwrgn priv field for the purpose anymore.
> 
> Sakari Ailus (3):
>   hwrng: atmel - Add struct device pointer to device context struct
>   hwrng: mtk - Add struct device pointer to device context struct
>   hwrng: npcm - Add struct device pointer to device context struct
> 
>  drivers/char/hw_random/atmel-rng.c | 11 ++++++-----
>  drivers/char/hw_random/mtk-rng.c   |  9 +++++----
>  drivers/char/hw_random/npcm-rng.c  |  9 +++++----
>  3 files changed, 16 insertions(+), 13 deletions(-)
> 
> -- 
> 2.39.5

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
