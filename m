Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973A734D4ED;
	Wed, 22 Oct 2025 18:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761157780; cv=none; b=QShFZIXB+b5YqqM6EH4ISdOg/p2zziG//3lvgd2N6EV6VQyAbBsTJbzUm1U3rXDlX85vVZVEApxPXcFMEaBMK6maVL6nD5D2wpftgslf/lu0n2XOD+y5xyNKYtiWdVVxT236lFmSSUYrUlTxUOaABnRTA6cJEOfPC5wF91d+fP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761157780; c=relaxed/simple;
	bh=tKK/reHlzPmVqXOpf9AgjGzyga0qVK9u1akkTrZBx1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uugO87TaxHV+k5/bm/wBwoU5AuUFeCsxjOFDen6Hzp1Z6SyUAqsBOoxWMzaPZJFI5ZpsSlX8Qww+GScNxIGy6zsEv3jmJhYgeth/l72ft/CHczWpxFjXF3nxRGXbEJJzP7VQ5A88dmpFJeO5fIYR0ocUy+zBx6PMIZmxVeVqnZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y822QoUX; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y822QoUX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761157777; x=1792693777;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tKK/reHlzPmVqXOpf9AgjGzyga0qVK9u1akkTrZBx1s=;
  b=Y822QoUXtHxYBVHtmWWyJHBIfPCnAbmVj3XoC/NWohQ/ETddxlS1yGKr
   fBLgad96Vq9OrzmdMTDMGIyIW6OFkEK55BvGiwomBgM0xjTo1vdCSLPy3
   af/bZ+Bpl14EQvcSnfucmOFMADsVH4uYVXGmrTsovMb3wUiZR3TpkH3Rt
   9V8FU/64rLE2VzVrrbG2ftKkY52mAK2KGWJA/KEi5XJHnqE4+eIM5xvzC
   THNFNvfduhvqK+bvJfUw1UHVBYFUA8pfQRpZ9G2ptXQPAMUZNwHjmdt+h
   7G/NCD9N2+A1/b37/GNMGZDnWmPmRCh+6ZrcC9y8KuOy8O7+p6Oym3ziy
   g==;
X-CSE-ConnectionGUID: gWfIPHPES2C4Fj2O7OlpcQ==
X-CSE-MsgGUID: 5v3dq3cpQzOGZMUOu4dbvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63356719"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="63356719"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:29:37 -0700
X-CSE-ConnectionGUID: dXekTRVYQLSfBpc91TuW2Q==
X-CSE-MsgGUID: F4lL6WHjQMGrNdzuFwWg8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="183883082"
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.244.83])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:29:35 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vBdaW-00000001lYQ-0HkO;
	Wed, 22 Oct 2025 21:29:32 +0300
Date: Wed, 22 Oct 2025 21:29:31 +0300
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
Message-ID: <aPkii_HgX1f0MUVc@smile.fi.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPkfsuliKYy5UAbB@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Oct 22, 2025 at 09:17:22PM +0300, Andy Shevchenko wrote:
> On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:
> > Use strscpy_pad() to copy the string and zero-pad the destination buffer
> > in a single step instead of zero-initializing the buffer first and then
> > immediately overwriting it using strscpy().
> > 
> > Replace the magic number 16 with sizeof(buf) and remove the redundant
> > parentheses around kstrtoul() while we're at it.
> 
> I understand that you focused on strscpy*() conversions, but the below I think
> needs a bigger refactoring, see my remarks.

...

> > -	char buf[16] = {0};
> > +	char buf[16] = {};
> >  	unsigned long ae = 0;
> >  	int i;
> >  
> > -	strscpy(buf, str, sizeof(buf));
> > -	for (i = 0; i < 16; i++) {
> > +	strscpy_pad(buf, str);
> 
> First of all, why do we need a _pad() version here? Is the data somehow being
> used as a whole?
> 
> > +	for (i = 0; i < sizeof(buf); i++) {
> >  		if (!isdigit(buf[i])) {
> >  			buf[i] = '\0';
> >  			break;
> >  		}
> >  	}
> > -	if ((kstrtoul(buf, 10, &ae)))
> > +	if (kstrtoul(buf, 10, &ae))
> >  		return -EFAULT;

On top of that the function is called only from one place and returns different
error code, instead it would have returned what kstrtoul() gives...

> Looking at this, it tries to work around the kstrtoul() inability to perform
> partial parses. Instead, this should do something like
> 
> 	unsigned long long x;
> 	const char *end;
> 
> 	simple_strtoull(...);
> 	if (x > UINT_MAX || end == buf)
> 		return $ERR; // wrong input / overflow

Yeah, the overflow check here is not comprehensive, it won't catch the overflow
(wrap around) of 64-bit value. But we can add a check for the end not to be
farther than ~19 characters from the start, which would correspond the initial
copy of 16 characters.

-- 
With Best Regards,
Andy Shevchenko


