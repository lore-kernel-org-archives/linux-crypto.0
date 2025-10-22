Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BEB1D5141;
	Wed, 22 Oct 2025 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761157051; cv=none; b=HZXta45zagXVxQhr0V4Z6nsP2hfFPxGGL7txvRTjSBKksOLJrzpaoyiQScR3CLq6ptPHVl5lNx0IUIr5NK6Y9sOMSVHvNgXGrvJUL1B8ZOt2i7uQNF4IyHenOLD0P+DSoW/BNFIwHtYTrRbLmMGt384NMBUB4pHo0BOWmEMF0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761157051; c=relaxed/simple;
	bh=VrRkp96TdUXfWdgJg0N2j+dDuC04eq5WN8H7LtYOQEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL58xRBcLNeUn/sCJK5bkn8K1VgX57zf/xwQ+pzqWepiGxSH0lwdIkt0HEsTfr78u51CdvlR+KmPPS3A3Djv/420rECtzbU1pAXmHCCrpDTPKBwX4zHmui74HpUpfv+YWHNt++l2WDdJTTWFq9KPzdSLjRtPDSD9M2SF6cWoxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzEve8Fr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzEve8Fr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761157049; x=1792693049;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VrRkp96TdUXfWdgJg0N2j+dDuC04eq5WN8H7LtYOQEE=;
  b=UzEve8Fr6Vqb8bWBz9dfJtAcqoszdmw+DQHnXuXrEtiS24gLbq1xp6SL
   mhHVbr1xYOwDekKAP9tUFVuZtQ1kSuvDaKRX8a/q5N7edqqISAt0cIg+h
   9y3oCPJlVVF2VvmmEDZGa+AWvd8NRTbnhYWUhgm2R0WL5vXkTaJF+vh8a
   pfzYdlI4HwKPMWnXMn2mVGO4pQWFFBsVErDFdXYRXTt7xrlySEM7m1Xhb
   qQ0PGvEneo+m8/K9/TN/M6SdR7A/p7CZmkAXbygYiq4jK+dyb+81ttgoB
   QD2gF9oKx8CTBU+yCV3XJq0LSzxoNUcsipTbv4jOqvp3eJlruxVyTKKVU
   g==;
X-CSE-ConnectionGUID: gHZi9msbSnazzZxiXhPVfg==
X-CSE-MsgGUID: QKVa46xERKajaSTp1Sa9Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="65932528"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="65932528"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:17:28 -0700
X-CSE-ConnectionGUID: vqBnbYezR12iAHo5CNh3ow==
X-CSE-MsgGUID: 178MEu8WT7CEjrAUbrivRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="189065719"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.244.83])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:17:25 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vBdOk-00000001lP2-3aC1;
	Wed, 22 Oct 2025 21:17:22 +0300
Date: Wed, 22 Oct 2025 21:17:22 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify buffer
 initialization
Message-ID: <aPkfsuliKYy5UAbB@smile.fi.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022123622.349544-1-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:
> Use strscpy_pad() to copy the string and zero-pad the destination buffer
> in a single step instead of zero-initializing the buffer first and then
> immediately overwriting it using strscpy().
> 
> Replace the magic number 16 with sizeof(buf) and remove the redundant
> parentheses around kstrtoul() while we're at it.

I understand that you focused on strscpy*() conversions, but the below I think
needs a bigger refactoring, see my remarks.

...

> -	char buf[16] = {0};
> +	char buf[16] = {};
>  	unsigned long ae = 0;
>  	int i;
>  
> -	strscpy(buf, str, sizeof(buf));
> -	for (i = 0; i < 16; i++) {
> +	strscpy_pad(buf, str);

First of all, why do we need a _pad() version here? Is the data somehow being
used as a whole?

> +	for (i = 0; i < sizeof(buf); i++) {
>  		if (!isdigit(buf[i])) {
>  			buf[i] = '\0';
>  			break;
>  		}
>  	}
> -	if ((kstrtoul(buf, 10, &ae)))
> +	if (kstrtoul(buf, 10, &ae))
>  		return -EFAULT;

Looking at this, it tries to work around the kstrtoul() inability to perform
partial parses. Instead, this should do something like

	unsigned long long x;
	const char *end;

	simple_strtoull(...);
	if (x > UINT_MAX || end == buf)
		return $ERR; // wrong input / overflow

-- 
With Best Regards,
Andy Shevchenko


