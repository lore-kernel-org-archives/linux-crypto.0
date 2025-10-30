Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED537A3A0;
	Thu, 30 Oct 2025 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761832998; cv=none; b=HJgMmdtUg3gBRMWK1WLCthZWwCA9hyMXLkTNkrtQGraQQ6GyWK5JndMnVg9cTuYCML+PC2QYlJ9/wEhdYk5hBe1qDpzTXh+sSTiJSGptkwB9oNEKxBtWRYC5HwTEy6La+DoLcgEwQ1Dgq/6jy/mBc/ODeovIEnJcb2OpfPF0ESo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761832998; c=relaxed/simple;
	bh=cd1zznPMVCTB+FHh1yOKfotODj/rGn2QXoKwYTFEHB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eLlsct2tQSNGTeuvZpBZRe60rEyoLIRSspdTKqZLZ4nMC9jqhtWQIGm7Iy+cGjsY23kP5sBJQpN80rfFyJRdWd430T8xkkOAOlBphxg/7yjwqZaWdF8fao13xupJIAEYpXYInHrA8PxC3xS/Vnjq/6x5vFPJJ7+S+UeBA0a0HbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P2SBRmMA; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P2SBRmMA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761832996; x=1793368996;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cd1zznPMVCTB+FHh1yOKfotODj/rGn2QXoKwYTFEHB4=;
  b=P2SBRmMACI7xz57sNzSva0oJOCpDgTYnpfaOzj3OubgqSJTUSOgeITZV
   r80Lt3jFO9YXY0MjYyhGWhD3ahzDEzzUd16SuT2eTJNzGLuV7O0iuKj9e
   pXsvYe6xZz1eAeZ+vhRUbMymiVO1tM9ikHQZbntBN72KIE4S7V0JYQ10w
   oVCqFPb2/TpTxmmJQRGi4mYBUHcCR4YF2z23Kd+78G8/NxGdl8GgEvJGQ
   r6JQX0Fpadpft25jbKNR58rQmNz3xRsShgZamM6A54342+1JnAvtaC83u
   xI6YuctJxG0pnLT+3uqr60KBhdqzzkpRSjVex6dSur0x/Jul1N7zUNlgz
   w==;
X-CSE-ConnectionGUID: dEZGdFRVSgqpHmuafX2g5g==
X-CSE-MsgGUID: H6LtCyGgQsqgaB75jxI1SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="89440618"
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="89440618"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 07:03:15 -0700
X-CSE-ConnectionGUID: G30XbJJiQLyLL7E6RiebJg==
X-CSE-MsgGUID: y3YhTuarQLOPyOngw4Idxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="190301204"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.174])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 07:03:14 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vETF8-00000003vn8-2J4S;
	Thu, 30 Oct 2025 16:03:10 +0200
Date: Thu, 30 Oct 2025 16:03:10 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aQNwHuNwPy6rDz-1@smile.fi.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
 <aP81GIlKmMv4pW-8@smile.fi.intel.com>
 <aQNLqclwOpEhMcaT@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQNLqclwOpEhMcaT@gcabiddu-mobl.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Oct 30, 2025 at 11:27:37AM +0000, Giovanni Cabiddu wrote:
> On Mon, Oct 27, 2025 at 11:02:16AM +0200, Andy Shevchenko wrote:
> > On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> > > Replace the manual string copying and parsing logic with a call to
> > > simple_strtoull() to simplify and improve qat_uclo_parse_num().
> > > 
> > > Ensure that the parsed number does not exceed UINT_MAX, and add an
> > > approximate upper-bound check (no more than 19 digits) to guard against
> > > overflow.
> > 
> > Reviewed-by; Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> s/;/:
> 
> I just noticed this while applying the patch to my local tree.
> 
> Due to the typo, patchwork is not applying your tag [1].

Oh, thanks for catching this. Have you added it manually or should I do
something about it?

> [1] https://patchwork.kernel.org/project/linux-crypto/patch/20251026015710.1368-1-thorsten.blum@linux.dev/mbox/

-- 
With Best Regards,
Andy Shevchenko


