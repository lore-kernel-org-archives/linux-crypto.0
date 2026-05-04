Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E003E0249;
	Mon,  4 May 2026 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777905859; cv=none; b=aEVx5IBuu9oyzlQU5q9uDtnoTQNKOq5g6tiPE4lkWm2/7+F/NuwIie3tdAYzXAVBFBYF+OZf4c4HAh8llT5NOhijFm+YqvmiUbZbT67GbcnIJrZ8ycr3Dgl0jH917xKbz+D63cwej0CdCsMi9nRKYWVLs3IOZrWacQu3bwR5HHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777905859; c=relaxed/simple;
	bh=Hcd+c5ejDq9HmZ/RCyyMXAR0oqXfPOkprJJVWljHL1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvkitN6a6KmJ9M0tfJHpB2gt1nAf3zrgurew/dDpcKx6LBLMf1sbPi9b+Gft2g+iF/p5PENiFTq11W8W2x4GLua1PAo1GrBmO7Oo0GOB/BSbFQ1hy+33/O4mTctEg6W05GpmtZnzsSO4MDcthwDl3+lTqiA99oWbTBTM6t3H7/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gG3Xw+2i; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gG3Xw+2i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777905858; x=1809441858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hcd+c5ejDq9HmZ/RCyyMXAR0oqXfPOkprJJVWljHL1I=;
  b=gG3Xw+2i+GkjUBHLBESiY/Yzup7nGNUB4ceLw7eFf1DisTstKD1vRf4a
   65z4jVNQZue/cI3QuUj45mHgSIq1SAk8+kfU/V2MTflDBhdPQ9Qa4Y+PF
   kcesuuBs+Tt70Pb4WG7TzbqGbDkUXL9+nYF77tjb+RaIk0QOKcTD+b7KO
   N4uu58cTfjdOCl2/rmqnp/Q+Anrck9iWDuJbU2NSvxz7s0YH2jmeb7Sb2
   AAJAGzQMAuVqeWZ4D7nfJOd1WPzbCIq1iv535CUqcDX5CHLh77zS3ZA9/
   ePplL1loLc1Nk/vhn5gDE0ETsFXfqGXborr3gKjmmvtu+6qJpOd7gqrMC
   Q==;
X-CSE-ConnectionGUID: 4rj+7D5PSfGrgQCXz7t4zA==
X-CSE-MsgGUID: LsR42FjkT06Fl6x2IuULGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78467467"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="78467467"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 07:44:18 -0700
X-CSE-ConnectionGUID: ayBP/g22R1iN9HyLaGb2ug==
X-CSE-MsgGUID: 6qRLhbp3T3yujl/++awl7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="231171546"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.245.198])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 07:44:16 -0700
Date: Mon, 4 May 2026 17:44:13 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] hwrng: core - use bool for wait parameter in
 rng_get_data
Message-ID: <afiwvXUnPhZ6xcAV@ashevche-desk.local>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
 <20260430110047.248825-6-thorsten.blum@linux.dev>
 <afilBnLk4lapbAj4@black.igk.intel.com>
 <afivHbWdCprHpJSB@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afivHbWdCprHpJSB@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, May 04, 2026 at 04:37:17PM +0200, Thorsten Blum wrote:
> On Mon, May 04, 2026 at 03:54:14PM +0200, Andy Shevchenko wrote:
> > On Thu, Apr 30, 2026 at 01:00:49PM +0200, Thorsten Blum wrote:

...

> > >  static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
> > > -			int wait) {
> > > +			bool wait) {
> > 
> > You want to fix the checkpatch warnings while at it and indentation.
> 
> I just checked again, but I don't get any checkpatch warnings.

Hmm... I remember for sure that checkpatch warns when it's a { on the line of
the prototype... Maybe it's about different scenario. Whatever, the coding
style is to have { on the new line.

...

> > > -		rc = rng_get_data(rng, rng_fillbuf,
> > > -				  rng_buffer_size(), 1);
> > > +		rc = rng_get_data(rng, rng_fillbuf, rng_buffer_size(), true);
> > 
> > Is it the only user? Why parameter is needed at all?
> 
> The other one in rng_dev_read() already uses a boolean expression, hence
> no changes.

Good, thanks for clarification.

-- 
With Best Regards,
Andy Shevchenko


