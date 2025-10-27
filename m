Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4501D1C6A3;
	Mon, 27 Oct 2025 08:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761553189; cv=none; b=jiNjWh3mglgFd6uI0DB1BjoCCgf0WTku9Hfu8kSGHEkjgbvQFSHaD8Ceqqke8SbmBErfVpKNNuWIz8cP1p5PnlktZXV2LbUjJTLltoGmLtSrIXTGXrAiUP8GpSpSOW8EtEn+Ih8KjzN3Lfrph6FEr5FUxXusNWJ5hSVy8yH7eBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761553189; c=relaxed/simple;
	bh=e/0INg1R4ncPWvqOqGKVxG5udNRPm41Kt9OtiuObcYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nyKmnyn1MgNeZXvtW68eRUwQsxv6Yl6TBmmBEwfPoodlzxM6JQNFS+jvuWWp9ATyfT6R55NYeYCSoUvCEnomLss1PMo+cbtl1N1l61aKpDRv8DRyoyD89qleZz7LwVjG6pMwYi1mz4TZCY3uBN0N2zRFXIj686PhFcMFsvQ+oF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ls7gkiDu; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ls7gkiDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761553187; x=1793089187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e/0INg1R4ncPWvqOqGKVxG5udNRPm41Kt9OtiuObcYk=;
  b=Ls7gkiDu2sphHghxxcJKiSM8jjvvKQZI5NisvqK6uEH7oWW8RgUwG4WZ
   q2oHDRxYIoTb2mi1I+jywj6X3q/8RErQa7ZsqyWNBs7QMXwfXyj+yTquB
   wHh/Q5gb7fG4jv+NsKwKCPCZ7hoHRtJnpUYTWiHx+e94LluhObKWH+fmG
   uipcNiayBeKgRuQikhHtE0a3eQZOaCJjxfLWaA5fX9XWsl4YA0QssHh9o
   a591ibmu/3hKJ3S7jmrrfBpecjUSK3TwCte0MS0CSmFXWp22oSrwbyf7e
   /yvwvZjn+65KYnjWVRRXbn0tTWQmfisTj1VM4NnmbeoB4g1yNsnJBMf3w
   Q==;
X-CSE-ConnectionGUID: BLI0c5CjQqaFJDJ+EnyNTA==
X-CSE-MsgGUID: BPUCujByS+yO+fCd9ZaV1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="81052652"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="81052652"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:19:47 -0700
X-CSE-ConnectionGUID: VkgjIQUZRFm89SDyQlULDg==
X-CSE-MsgGUID: H57LwCEdSi+Yf7XkGwb+EQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="222192081"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.244.5])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 01:19:45 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vDIS5-00000002wiW-3UmY;
	Mon, 27 Oct 2025 10:19:41 +0200
Date: Mon, 27 Oct 2025 10:19:41 +0200
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
Message-ID: <aP8rHYq4I09pvhFa@smile.fi.intel.com>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
 <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
 <B981F95A-287C-44CF-8852-B4642E728975@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B981F95A-287C-44CF-8852-B4642E728975@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Oct 24, 2025 at 08:47:02PM +0200, Thorsten Blum wrote:
> On 23. Oct 2025, at 20:44, Andy Shevchenko wrote:
> > On Thu, Oct 23, 2025 at 05:35:00PM +0200, Thorsten Blum wrote:
> >> On 22. Oct 2025, at 20:17, Andy Shevchenko wrote:
> >>> On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:

...

> >> How about this?
> > 
> > LGTM, and that's what I had in mind, ...
> 
> I was about to submit v2, but checkpatch warns me about simple_strtoull:
> 
>   WARNING: simple_strtoull is obsolete, use kstrtoull instead
> 
> Any recommendations?

Yes, fix checkpatch as per commit 885e68e8b7b1 ("kernel.h: update comment about
simple_strto<foo>() functions") or ignore this false positive.

-- 
With Best Regards,
Andy Shevchenko


