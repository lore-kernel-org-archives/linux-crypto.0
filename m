Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214E43DC4D5;
	Mon,  4 May 2026 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902863; cv=none; b=fANetbD3XjGKHq4Mr0ScVmN6A4krHNHYhmjCoFQWOOS5nhVV8mJg0nhcQqSzpjc08IKU577CmnpmYrvUGTa9Mjt3vQyCYlBK1cnNhtK/OcGlp04IL7l8rxsZljnWmVtSJAw/YjgaNYB3POM5ErRMbOr57m0/g9ojXShpyG3JM7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902863; c=relaxed/simple;
	bh=zfpufSzFxHcyDB8cF32ccL0cIZ8QZ8HshsbDrY6Pjeo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvpSoUnJZXluDqs8QK2Tw+JBRCtfOblGoD89wJXXVr8IDeMJquCbPQ0kO0pRDy7HqmR3ASiB7MjXeynPS+62I3fUWv/3BHYf1PvxTCK3V+sXUItq9fiLvclMWOEk0Y6CUuCUKLVwRwWl3eDpdhSL4APyAVVT3feswqP4uHtyjFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DtpNtFsi; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DtpNtFsi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777902861; x=1809438861;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zfpufSzFxHcyDB8cF32ccL0cIZ8QZ8HshsbDrY6Pjeo=;
  b=DtpNtFsibLjRgO2K5HkBYgc85ZXTaH/If/Te6dqqCKkOYEel5G0Qwt4a
   j1fUL2DJb4pYOHMAufaemRKw/u5J9rt1RE6XZUIOxjfY+7DaV7detJ1vJ
   aItTko4jGwNg5vU2DvVP21wIGZOUbsM4IWvTi2NNUpVhfxJN6t2SwyzHz
   /OV0MlA45Anj9Erwnvj9zZYnY1DViDh+atkRAbKmIl/JbqtSqA/pI+I3M
   ZLs6n/f2B4Py+Rx+N8QYsyJJgxkpn2FuOSL34mLUo2g3hlSSJdglJMvTD
   aBX6Itl6Cowg0hmjc8YSr1Jdx5BAvYGw8LEZqF5EMOHc+96KUFCg6SNRv
   g==;
X-CSE-ConnectionGUID: m8UMabqtTy+URDnaLkP46w==
X-CSE-MsgGUID: 3vChX2ypSVuJ9+VsoQP2ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="90216542"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="90216542"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:54:17 -0700
X-CSE-ConnectionGUID: O5P75wlvS4u6xHmn5DPRIQ==
X-CSE-MsgGUID: 639mjRroTZ6FInzmVThZoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="232860428"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa008.fm.intel.com with ESMTP; 04 May 2026 06:54:15 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 5F75398; Mon, 04 May 2026 15:54:14 +0200 (CEST)
Date: Mon, 4 May 2026 15:54:14 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hwrng: core - use bool for wait parameter in
 rng_get_data
Message-ID: <afilBnLk4lapbAj4@black.igk.intel.com>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
 <20260430110047.248825-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430110047.248825-6-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Apr 30, 2026 at 01:00:49PM +0200, Thorsten Blum wrote:
> The 'wait' parameter in rng_get_data() is a boolean flag - use bool
> instead of int to better reflect its actual type.

...

>  static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
> -			int wait) {
> +			bool wait) {

You want to fix the checkpatch warnings while at it and indentation.

static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
			       bool wait)
{

...

> -		rc = rng_get_data(rng, rng_fillbuf,
> -				  rng_buffer_size(), 1);
> +		rc = rng_get_data(rng, rng_fillbuf, rng_buffer_size(), true);

Is it the only user? Why parameter is needed at all?

-- 
With Best Regards,
Andy Shevchenko


