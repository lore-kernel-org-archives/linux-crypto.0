Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679273DE438;
	Mon,  4 May 2026 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903102; cv=none; b=bGaO891x6hIwxHy8Ky/gKI0nsGYdJfmeqcf4QZ7eg9CgoOmg84Ha6N8QSGCW47IuVEA6NLaJzlh5umUcHXypKHaPlxZILn/V7EevG96lhTzZXGCviD1lc0eFIDrQZZiVXcEwGuRAFCf/0+ZB72DUF/pT/Fjzxdg9RQxzD/Kh/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903102; c=relaxed/simple;
	bh=t9qwbwdSBrRT/FHk5KaKgBCb4asrPCQmvr5JC5eulqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEe7O5ENFjkRA86R6A71wO15VvFYVXOVC47WVL5JmMzlv+q7pgSJVIY6Jb3diusf19YUDCTe5vACIr6ZH8MBVpjy624Zrr/+xUEttYawggxvlQaCB9ALfBzMsRfOza8tCX1zY/JOEn/K/WzxvV65tuyV0MFeDuYYC6zba+7Dcys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4msPwwX; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4msPwwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777903101; x=1809439101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t9qwbwdSBrRT/FHk5KaKgBCb4asrPCQmvr5JC5eulqw=;
  b=N4msPwwXUTu4B1uXoY4AVN8q0wI9ViypKLR2kPlE2cnNgFT1+mGyME5c
   TzdQjY+ia0ypoISuONqjwREK81WYYC7XkHQJBNRFAFqlQu0PeynAAfmwi
   0LFxy/qc6dOvZqW4o2RCarFiasB6gWckF7namiRXPcNSOcwXN4KcFC2oy
   FznDG9z6poCN4jlUYYWRB0S+Xpcqu+Wu7wFTyr0z/gCzbXH4V92b9jUao
   Bvv7zQHpsXAddybepudhJyzE9v+4JTTMHG7xsPCiBu7QoWYUmKZDOvgak
   I4WEtIkQcKYHRHFWEmC7emDOwV95Vo9lo5+eV1vFCooY4F7rJt922tNSs
   w==;
X-CSE-ConnectionGUID: Sdx8Zk1BSQCOmfFrsWEM4g==
X-CSE-MsgGUID: YFRhdhFGSTSa5BZpt1nI4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="89065777"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="89065777"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:58:20 -0700
X-CSE-ConnectionGUID: AVV4lKLeQ7+bBYzftHlSgw==
X-CSE-MsgGUID: H1ukazDhQ0+fGA0M+xdUbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="237296315"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa004.fm.intel.com with ESMTP; 04 May 2026 06:58:18 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 8FF6898; Mon, 04 May 2026 15:58:17 +0200 (CEST)
Date: Mon, 4 May 2026 15:58:17 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] hwrng: core - use sysfs_emit_at in rng_available_show
Message-ID: <afil-SSHn259HFkG@black.igk.intel.com>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
 <20260430110047.248825-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430110047.248825-8-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Apr 30, 2026 at 01:00:51PM +0200, Thorsten Blum wrote:
> Replace strlcat() with sysfs_emit_at() in rng_available_show() and add
> 'int len' to keep track of the number of bytes written. sysfs_emit_at()
> is preferred for formatting sysfs output because it provides safer
> bounds checking.
> 
> Inline mutex_lock_interruptible() and drop the now-unused local error
> variable. Remove the unnecessary 'buf' NUL initialization. Return 'len'
> directly instead of strlen(buf).

This is almost the same I came up with (but only today), hence
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Also note, when series is more than a single patch, it's highly recommended to
have a cover letter. Some maintainers do even require that.

-- 
With Best Regards,
Andy Shevchenko


