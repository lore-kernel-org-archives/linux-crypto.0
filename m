Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B232368975;
	Tue, 10 Mar 2026 22:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183234; cv=none; b=YL1I3i624EJ+Xu0I0ojHIWtff1jdwl9bcppAIRN41/Zo944sZ+1lXtPkcicPtjUgpSlWVRDX23RdOCMXs/9QIjqprzJmWt6Q7kDa0BAvRGH1oRCb2JXQrTNVAkBhInJYGbc3Vc3V7CTG0Bm1nncDBREf0vGF+2RHvgcdFXrE70s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183234; c=relaxed/simple;
	bh=Bmc8yWEGt25JOsN6jnmCLKvcvOEH6RlcqwZ9eOM8geY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j/1/GWBYZ2a0714GWEocTonXzquPCKIfIJK1pCmPjPykTfZaWhFqk+rNqCjl2fZCgIvIVY0KDdiKd9z6FFqIE5zyJJFgIfQ+EbEkFuiwdhb1cbhH4j7essz+37YT+gu96QcxTaa9J0EDOgjPSmGzLihYi/06M4dxWtZN/AKNY58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ju1/Bf03; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ju1/Bf03"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773183232; x=1804719232;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bmc8yWEGt25JOsN6jnmCLKvcvOEH6RlcqwZ9eOM8geY=;
  b=ju1/Bf03zgxje5K+97EtKtp41oJHjhg4M45B0DUh73GKG5uyQyvXImXw
   q0sEKuXRJG2/JITwP5XxU+Fnx4DR5qZEJMXdjqLFVG4BEQm9fEMm7u3M1
   wGy6pw5/wPBfbyfao0IcKK06EGZOmvIBoAq3SHsX0hqVqRQIQkNos1c7J
   8/REHIr/IvkqsR3y7Lwz3aYGPofeHEpzoiH44CUbh2OW1+WlAz5UzXOCo
   fsY83gSFUIWfq6H6sQfxnQem1bLeutD0EJX+nG485zExmLIglkCUXeep1
   Pl0Jref87EBt4TTsB42YiXLMPmXO7Vskul1zcRu4yed6xUNyk0XQNz7xi
   Q==;
X-CSE-ConnectionGUID: 3r9+KmXHRwWtYMjleJMV8A==
X-CSE-MsgGUID: 5GO2n/j7QIyh81jkLlVG7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85720738"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85720738"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 15:53:52 -0700
X-CSE-ConnectionGUID: KzFV4T4wRYyj52S0WDozjA==
X-CSE-MsgGUID: BGZTuQvQSEaSaaDjKl4luQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="215583043"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.244.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2026 15:53:49 -0700
Date: Wed, 11 Mar 2026 00:53:47 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib: crypto: fix comments for count_leading_zeros()
Message-ID: <abCg-0AGnvyTJqdc@ashevche-desk.local>
References: <20260310211021.95362-1-ynorov@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310211021.95362-1-ynorov@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Mar 10, 2026 at 05:10:20PM -0400, Yury Norov wrote:
> count_leading_zeros() is based on fls(), which is defined for x == 0,
> contrary to ffs() family. The comment in crypto/mpi erroneously states

> that the function may return undef in such case. 

You have a trailing space in this line.

> Fix the comment together with the outdated function signature, and now
> that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
> it too.

...

> - * 6) count_trailing_zeros(count, x) like count_leading_zeros, but counts
> + * 6) count_trailing_zeros() like count_leading_zeros, but counts

While at it,

	count_leading_zeros()

-- 
With Best Regards,
Andy Shevchenko


