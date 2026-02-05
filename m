Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3F2C0F91;
	Thu,  5 Feb 2026 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308164; cv=none; b=NNegc2KOnmGrSQrb6Vv6g8IB8oI0hjoNwyEZe/oQDdnL1ROYX6cnBQZoWTrC2O5XN2/FCpvGJ93BO3Pd1famGWMRK0tMh40jmyyZr/E4p7KYRznQoXDYSB7vQJv5fz3Y41dIbiTMDjhgAXt21BkO0yKWSlQg4dYo7aWFZL3CJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308164; c=relaxed/simple;
	bh=zfpUg2iTjUL5OJw3y5RnQaAYqivYKuOCIM2vg3TZvbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kzwqn8aIZs45+0WIK+tPSal5p3cJM3vog8LwB6eIzQiWMCdke+ofZ8+jFb93P4aIfdt6y18ahczFkWhudHdmZ2/qs/yYLcjZZqVmdJCBFtXONGsKMphLV1Z0etiw35PACPFrL8Ol5n7saRiWLzv8nXKh5oXs3l1b+2h3TFW7UFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UATxMK2L; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UATxMK2L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770308164; x=1801844164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zfpUg2iTjUL5OJw3y5RnQaAYqivYKuOCIM2vg3TZvbk=;
  b=UATxMK2LjEeIZKK7sDzDCx3+nJxTKUWjLXmr8X3+H3AOfmDrAKyXujve
   P3ijCYDlgjtTTTCJkwr9QbBAKoRq2+4rkDWdYUeHbzfaRp6JMJsMNXG9I
   HVovItyOh9egCyIjN2nQxi/CQuWRrOEB9M8jxWGOd44TTQw8Tiz4q5N7C
   rz/kTB0O91aQu8EdYD8l6Dg0DEx0aJPPDrHwPWyzGxwj6hCgmfKP2qYNJ
   ig/QZQB2XQbkvs6opDfs+/Lr9I4srnylBFD1b9RbfdgyaaG93aT4hearR
   W4cfIh945nOw30TOLFZnCr0iDnFLbFcQtWJy6ceES0L8FJYOk9pREL8t3
   A==;
X-CSE-ConnectionGUID: N501MhTNSjSdAKcy25kpKA==
X-CSE-MsgGUID: 4Sg83mWSTtKRCccwoiUU2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="75364822"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="75364822"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:15:57 -0800
X-CSE-ConnectionGUID: BpF+q1jXRlK4x1kAk4fAgA==
X-CSE-MsgGUID: dg+e1BL2QJ2Fd0X8CWBZdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="215547961"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.244.142])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 08:15:52 -0800
Date: Thu, 5 Feb 2026 18:15:50 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: WangYuli <wangyuli@aosc.io>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mika.westerberg@linux.intel.com, jsd@semihalf.com,
	andi.shyti@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	bp@alien8.de, ashish.kalra@amd.com, markhas@chromium.org,
	jarkko.nikula@linux.intel.com, wsa@kernel.org,
	WangYuli <wangyl5933@chinaunicom.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2] i2c: designware: Enable PSP semaphore for AMDI0010
 and fix probe deferral
Message-ID: <aYTCNi7-cPA1ECdM@smile.fi.intel.com>
References: <20260205114451.30445-1-wangyuli@aosc.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205114451.30445-1-wangyuli@aosc.io>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Feb 05, 2026 at 07:44:51PM +0800, WangYuli wrote:

Don't send patches too quickly. Leave some time for others to have a chance
to review. This version not anyhow better than v1. Please, refer to the v1
discussion.

-- 
With Best Regards,
Andy Shevchenko


