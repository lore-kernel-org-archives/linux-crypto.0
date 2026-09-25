Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C4D48BD35;
	Fri, 25 Sep 2026 10:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790330443; cv=none; b=Du0QLgm+DdhX5HLQqqUOwj+9Iixy+pbO5yBLs0skIUTT6/TqibUQa4EvdegVzEBbfuyWbtFa24CnBs8wlixMeBRgr3xH9JpNbwZSQqSEwgfWHHUBRTbYl551e9eOglUpCjljEoAHDY/O9dYbp/S97QcXaXMScgROjHDMsgQqdG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790330443; c=relaxed/simple;
	bh=WExlPcgeo/X9vKd4sIoM6fXef/myb6ofHGuT1oKyCDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZLOLRAD5k9r52L23FnJp0rUan5qJPx6h8uTGpzzqC3Ar/t29LgdlEv71gkNSqXFVHvmXx1f8TvMBECYR7o4UbUk+yfeYC8c4TySGZ8y/d3hKN+fKcPf4+FpKBz2IyuEuCGD5ScalBPz50XjLv/nScAwhYeZ5rxZy06apeaFyLM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qs4YcDK9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qs4YcDK9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790330440; x=1821866440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WExlPcgeo/X9vKd4sIoM6fXef/myb6ofHGuT1oKyCDo=;
  b=Qs4YcDK9Ebhd0qXCkn9uy+VCX6kcgECJB0nBbFulVGP7fJdbHWVlM8PA
   NeFsFtNy1jssyT2WaIr3z1i8ROqR2odjDbGI5SwA1fMlMdMVJjocnEa6V
   307HeR8IPC7lLr+WksOtm5d++FIO7MVxxhL3SMVb15N+iSR+33tHouS5w
   nrVGTJDFvurVLb02quNoEcIG/z7DiVQP5vLH93r64jnH1jzmxJQ+ogeFJ
   olvPA0M0tlU2qW5x1o6A7XfeE13qC4zZJxExbfZYlbR6P9ulQ6rZw936s
   ZYTQKONX7ooND6fRYMK4iA9G09nqry/UINSYX1Xo/CMjsp3WMtJIR+zH7
   w==;
X-CSE-ConnectionGUID: wYgoyjdJRuaXwp2bGWkFsA==
X-CSE-MsgGUID: Xm2l5LIsQmCwoiAhSil9qQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="90240308"
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="90240308"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 03:00:39 -0700
X-CSE-ConnectionGUID: VbpjZQ9YQ/yufrQWJ/xuVA==
X-CSE-MsgGUID: ln1o0BBTRuWQZZfomhhbCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,122,1787036400"; 
   d="scan'208";a="300559958"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.27])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 03:00:37 -0700
Date: Fri, 25 Sep 2026 13:00:35 +0300
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
Message-ID: <arZGQxGEP-i9fLiJ@ashevche-desk.local>
References: <20260924212114.120633-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924212114.120633-2-blum@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Sep 24, 2026 at 11:21:13PM +0200, Thorsten Blum wrote:
> In rng_current_store(), err is 0 after successfully locking rng_mutex,
> and if the requested RNG name cannot be found, the function reports
> success even though the current RNG was not changed.
> 
> Set err = -ENODEV before searching the RNG list to reject unknown names.

Yeah, from the

> Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")

it looks like it was the intention, but the mutex_lock_interruptible() rewrites
an error code. That's a good example on why I often tell people to decouple
assignment from the definition and the very same issue might happen and would be
hard to debug later on. Surprisingly this happened in the same patch...

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

-- 
With Best Regards,
Andy Shevchenko


