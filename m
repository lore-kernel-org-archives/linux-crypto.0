Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E73948125E;
	Fri, 25 Sep 2026 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790330776; cv=none; b=paQ8kHjxSG0Xco9tAFcbEdd7qYmjy7oVmQy7q6igC2lkWHZADfivnjF1LZEahkrdvcQ2cw/UmNC94RYBvX0pPuT2LE3uMY7HL+70LDGUKu/lwC1dxIMU7L2qevWe2XToZd6Cy+B+tJKhrHXDlh4f5KoFpzYvvveoip49xXDHa18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790330776; c=relaxed/simple;
	bh=O29JxlP7H3AHO7oC6sS4ggkHIQdHda2i0tIQ6RtdsqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MQbwXmRkb9ncHwMt9NhgVfPa9VQOG6KElDrqFk+ZZaxadLOLdlVh0jew47uAg+iCVWK6EJhOr1ciHPvEPF59cS+PKdxyl8UQNFwFBkA6CvENYFAXWzqMUQy+RUOP68ujMmurdZXB7n7IGJw/yB5Imw1teTU+97mrSJR89eNDfL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOBcu3Rs; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOBcu3Rs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790330775; x=1821866775;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O29JxlP7H3AHO7oC6sS4ggkHIQdHda2i0tIQ6RtdsqU=;
  b=kOBcu3RsSvBPpQTuMri3UMKThJCFh+GaaMpRRGFIxU8Woy6Rebuw+8aN
   Kvnf1mrO3lbiH8pSd1TEeXY+2ua6+/zE+O7liN8LJ/Kn3dZF9Sj3tgpKd
   yG9sxtgNtH37zIyILO5jrdZEh3oSEq9K+SQFpBQws2b4hf18iY5cXACnP
   iq1azcgsOTt6HZcMEnP2xKxM/24jNT9C8b9h3fQ+jWAkZ8LrVPIha6iRo
   p/n/lvnk1a5fe67HgJZN3QsftYG8qw6j3b4mvbPJRbQUMQcNy1FRIzxG+
   ybIXcJrDWTeuLxX+GhOJ2V3Stj5H0KSK/bHb0FyoW5wR4aFc/2D8qtVB5
   w==;
X-CSE-ConnectionGUID: 8FUMETemREWIjub/nnvksg==
X-CSE-MsgGUID: mMETd6xSTh6YJOm6Dti4xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101287806"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="101287806"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 03:06:15 -0700
X-CSE-ConnectionGUID: E8ziHc+2SiaXStz2awS3mw==
X-CSE-MsgGUID: 1vRteQK8QTC3c4GFY/TKBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="274389613"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.27])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 03:06:12 -0700
Date: Fri, 25 Sep 2026 13:06:09 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Manos Pitsidianakis <manos@pitsidianak.is>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	Lianjie Wang <karin0.zst@gmail.com>,
	"Thomas Richard (TI)" <thomas.richard@bootlin.com>,
	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: core - reject unknown RNG names
Message-ID: <arZHkd8efyV0IFYQ@ashevche-desk.local>
References: <20260924212114.120633-2-blum@kernel.org>
 <arZGQxGEP-i9fLiJ@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arZGQxGEP-i9fLiJ@ashevche-desk.local>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Sep 25, 2026 at 01:00:39PM +0300, Andy Shevchenko wrote:
> On Thu, Sep 24, 2026 at 11:21:13PM +0200, Thorsten Blum wrote:
> > In rng_current_store(), err is 0 after successfully locking rng_mutex,
> > and if the requested RNG name cannot be found, the function reports
> > success even though the current RNG was not changed.
> > 
> > Set err = -ENODEV before searching the RNG list to reject unknown names.
> 
> Yeah, from the
> 
> > Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
> 
> it looks like it was the intention, but the mutex_lock_interruptible() rewrites
> an error code. That's a good example on why I often tell people to decouple
> assignment from the definition and the very same issue might happen and would be
> hard to debug later on. Surprisingly this happened in the same patch...
> 
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Also

Fixes: cb028f1662a9 ("hwrng: core - remove redundant initialization of variable err")

as that one removed the indeed redundant assignment, but forget to fix the issue.

-- 
With Best Regards,
Andy Shevchenko


