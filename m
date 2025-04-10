Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86501E5B89
	for <linux-crypto@vger.kernel.org>; Thu, 10 Apr 2025 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744298121; cv=none; b=EYpeq4gSGMrP1l6+xIIYmHz1qU8VDgCZvGtBFyZpvHkYM6EqJSYfBAgjlKCazQpKNwQhqC1UpjHEWH3gZPh37xpSA3tD8rS3kTQTc3cD2Sb9ZMdvPLfeDVdYRV0T4CBU0ktbuTSKaTJQTDAQreZ9taoESEMHQScq1MKt1OECBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744298121; c=relaxed/simple;
	bh=V4GHZJ8ckeMnMp0rIGnPoc0LafTsnMm513zi7ZBVHVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bm6dYcjRnlZpCF2a7ZSbzgh33oIzxjb33zud7ddH3KrzSlLlF65HonqaVqgeRkA/rzmooo8nk7iX4GjfjGiolgF/V7OHuQa2GyF0s6x/xyLTrothMeWlZgHdquCVuNwFZh06sq5dMGnisSrXGM+lNSVh06CBG3sJTh6KOD5Wub8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CROV4MqH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CROV4MqH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744298120; x=1775834120;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=V4GHZJ8ckeMnMp0rIGnPoc0LafTsnMm513zi7ZBVHVQ=;
  b=CROV4MqHXSGRrysn0smbGdwbh+/D7iWjm6THt1yJxbQ/YVZ7YTPK55in
   Dtd7hacN4FxRk/ng3DwDV5cfaRu7VnpKgAP5IWnBbuCOwCxOdyVYMeRYQ
   Z64I1dwezzk3RMwcK0xGHLIqU15Tw5zrWFtOr2m9bQ01CasZPhGcaFCdu
   l37do29E9a32b0LJXFqQXS1uCRp0A+QTNMTKlZLYfGWstAFn0C7M+Uj5q
   om67Yduxrdb3lsb/XTr89ILMY7dgNrs2HueHdDxjcBpHPSzQ7fJEkrHyw
   NdPxHrK8zXDoxigbQmZM2IkffjHWmES2WIQKxTgFMpDqdGQrR4zPlDcYV
   w==;
X-CSE-ConnectionGUID: rXFoZ5trT7Wvde/dgYzcRw==
X-CSE-MsgGUID: 5ooxh4lVSSGk2ZbEbHpwCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="48534419"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="48534419"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:15:18 -0700
X-CSE-ConnectionGUID: vQ7lhxf+QZ2w5KQxjMC4EQ==
X-CSE-MsgGUID: XLyoK8lKQ9C7x/NfnQcgNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128912597"
Received: from turnipsi.fi.intel.com (HELO kekkonen.fi.intel.com) ([10.237.72.44])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 08:15:15 -0700
Received: from kekkonen.localdomain (localhost [127.0.0.1])
	by kekkonen.fi.intel.com (Postfix) with SMTP id CE9BF11F74E;
	Thu, 10 Apr 2025 18:15:12 +0300 (EEST)
Date: Thu, 10 Apr 2025 15:15:12 +0000
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
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
Subject: Re: [PATCH 1/3] hwrng: atmel - Add a local variable for struct
 device pointer
Message-ID: <Z_fggNyPaotb2mYh@kekkonen.localdomain>
References: <20250410070623.3676647-1-sakari.ailus@linux.intel.com>
 <20250410070623.3676647-2-sakari.ailus@linux.intel.com>
 <Z_d2fcuWPiel_OnT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_d2fcuWPiel_OnT@gondor.apana.org.au>

Hi Herbert,

On Thu, Apr 10, 2025 at 03:42:53PM +0800, Herbert Xu wrote:
> On Thu, Apr 10, 2025 at 10:06:21AM +0300, Sakari Ailus wrote:
> > Add a local variable for a struct device pointer instead of obtaining the
> > hwrng priv field and casting it as a struct device pointer whenever it's
> > needed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/char/hw_random/atmel-rng.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/char/hw_random/atmel-rng.c b/drivers/char/hw_random/atmel-rng.c
> > index 143406bc6939..5192c39ebaeb 100644
> > --- a/drivers/char/hw_random/atmel-rng.c
> > +++ b/drivers/char/hw_random/atmel-rng.c
> > @@ -56,12 +56,13 @@ static int atmel_trng_read(struct hwrng *rng, void *buf, size_t max,
> >  			   bool wait)
> >  {
> >  	struct atmel_trng *trng = container_of(rng, struct atmel_trng, rng);
> > +	struct device *dev = (struct device *)trng->rng.priv;
> 
> Please stop using the priv field and instead add a struct device
> pointer to struct atmel_trng.

Thanks for the review. I'll do that in v2.

-- 
Regards,

Sakari Ailus
