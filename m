Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AD630BB97;
	Fri, 24 Oct 2025 09:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761299387; cv=none; b=PYkrDK36pziUs95bjC8gXAtkW1BDSDqqwYdABnbP/L9qlWMw9/24uj81ZRpSTS+8vpHrTmmn69N2xG+CJ9XhteRAfbHMiB54jfyrAobaIXpXHR5vMKYc75MdwOHDNtl8b2dwmNhRYWcbrgT1aqQ6M2yOYLrN8pkTjFfNUMih0Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761299387; c=relaxed/simple;
	bh=QMYBK66FoFOnoF9+evPxFyW8O913BfjGPY1tujhpGE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkzvxqKULNy84yTKgtZV3YLY+TWuQf0YoPqA3cy4nTT2xCNCdlln2GExlPmUfbmwpQWFGmI2BeZM+b10EnGeis/2OCgRpoDi4lTd9jd2A9l0+gI7ZNwGZ/QivgtQvBtnjUZ+wTXHJ1GL5byoWJSo6ZMGKyKyD+YSjO4SDhpeiMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k9VkgDud; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k9VkgDud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761299387; x=1792835387;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QMYBK66FoFOnoF9+evPxFyW8O913BfjGPY1tujhpGE0=;
  b=k9VkgDudADtEZQZG2LxGLENOg1zmyhliPOuSMKBblxjzCzApa3qaJpyr
   AtbW0vKH3XZHkXHwgogb/XQYHHxZgaT5hL5Bx9/UnRAf5ZRktB+/294NY
   Bsy9fys0YaAsrh3s/CWpfv/uhBHVr4qmAMuQyMdTtG2Kq9M16rtgKRCLv
   FHo0xxZNgeyyag/A4aPdBx99jh9iHMK/iBq7KrBo4M+DvE0n25hr1jsIN
   8VSsLQJldMUHAHQqIVf9bsRQuxBOvRqJDEefvNgon4wfvfEgrjsG0HOfj
   IzWJgro5ZaC9eEUlo0w8Ymj1xg/33wB6QlTTo7kloDKn6tvEV7swrmgC/
   g==;
X-CSE-ConnectionGUID: tgDQDm/pRIqDu7xNUzJU7w==
X-CSE-MsgGUID: gJaP6KlOQzy6Y5ALeT5Zsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67124004"
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="67124004"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 02:49:46 -0700
X-CSE-ConnectionGUID: jkvGJtw6QCKVquoZaeU8UQ==
X-CSE-MsgGUID: +BcNt2dTSbeyTIHzGgmyHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,252,1754982000"; 
   d="scan'208";a="184105994"
Received: from opintica-mobl1 (HELO ashevche-desk.local) ([10.245.245.60])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2025 02:49:43 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vCEQW-000000028JV-1gDY;
	Fri, 24 Oct 2025 12:49:40 +0300
Date: Fri, 24 Oct 2025 12:49:40 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify buffer
 initialization
Message-ID: <aPtLtEJJ3jV12FNJ@smile.fi.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
 <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
 <aPs9w2su33uXfD09@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPs9w2su33uXfD09@gcabiddu-mobl.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Oct 24, 2025 at 09:50:11AM +0100, Giovanni Cabiddu wrote:
> On Thu, Oct 23, 2025 at 09:44:01PM +0300, Andy Shevchenko wrote:
> > On Thu, Oct 23, 2025 at 05:35:00PM +0200, Thorsten Blum wrote:
> > > On 22. Oct 2025, at 20:17, Andy Shevchenko wrote:
> > > > On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:

...

> > > How about this?
> > 
> > LGTM, and that's what I had in mind, but please double check the behaviour of
> > kstrtox() on an empty strings.
> 
> LGTM as well.
> 
> I checked the behaviour of kstrtoul() when given an empty string. It
> returns -EINVAL (-22). The result variable (the third parameter) is only
> modified if the conversion is succesful.

Thanks for confirming!

> Anyway, the caller will not provide a NULL string to this function [1].
> 
> > > +	unsigned long long ae;
> > > +	char *end;
> > >  
> > > +	ae = simple_strtoull(str, &end, 10);
> > > +	if (ae > UINT_MAX || str == end || (end - str) > 20)
> > 
> > I would go with >= 20, the 64-bit value is approx. 1 * 10^19.
> 
> Just an insight into the type of strings being parsed here. If they are
> well-formed, the format looks like:
> 
>     <AE_NUMBER>!<...>
> 
> Example:
> 
>     11!l0000!lm_thread_ctrl_struct_base
> 
> This function just extract the first number. Currently, that is 2 digits [2],
> and I believe it is unlikely to exceed 3 in future gens.

Yep, but it is better to make code more robust (and esp. in case somebody
copies'n'pastes to somewhere else).

> [1] https://elixir.bootlin.com/linux/v6.17.4/source/drivers/crypto/intel/qat/qat_common/qat_uclo.c#L237
> [2] https://elixir.bootlin.com/linux/v6.17.4/source/drivers/crypto/intel/qat/qat_common/icp_qat_uclo.h#L11

-- 
With Best Regards,
Andy Shevchenko


