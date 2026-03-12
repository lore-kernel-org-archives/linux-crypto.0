Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092B939A057;
	Thu, 12 Mar 2026 16:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773332289; cv=none; b=jO82fq4N0YNex0OU8kMNKv4j7NRif1Sl7DEc5QwLXLG5NCuyB+Obzem1fCXIqnqWg14SqTZ6ZETZMyRYhM+cC4NYOj0UQjlTViD47MONzLGqpyw0pMQWbkkyvPba2NKv010LgRlMEK2VsaNryEGl9mBRyLPZ/79nNZsQkMAHnIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773332289; c=relaxed/simple;
	bh=r/9VB0qa5qUmevk8A9traJPtKTtJU4GoRm0wb49237U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZnEhTLaYjt3VPM5CCsghRtU/dkAyHFNf3HUDbgyblRDR21GhQ3BY7/nHvR46avZwwfy6cjnkAi3b6d2d2IEqWy2RMSD6XcxzbJHb4YavYpFtGljWI1nV30xvmryPa9vTrm9sz+wrBKUTZiSXbJt/aYDiU1YmX96eHoBAThleaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UW455EQf; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UW455EQf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773332288; x=1804868288;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r/9VB0qa5qUmevk8A9traJPtKTtJU4GoRm0wb49237U=;
  b=UW455EQfwzYzx1CJvllOkXf+RKZwAX+HLzkuYS10uEAFX3ak/g3IRTTG
   K7UYLPFPXvwKsizuQYq/r9Pa2Phnj7gQ79PnzZz2A3z6zFcOamAOGuxd4
   P4m0sLN/ZAtWdCB1gSqbK1Ppw52sdLheuYYkZU6wFVbTe4ccbBbgjgGxu
   0Y1yYrOrjoYVQS2KbxpXBY65nbMeWL+nhL/f9RmTfXR0PzBECTEsxfapC
   2M9k0loywXW1C1bz8WhAbTqadkHNX2se79EN9QiCHgRGorQpekB+7Cnj3
   m9CssVnfyTk0eA6K0LZcBzbKoDZP5/NDjUR40wDqFqY3hE+hlCcmPrYP7
   Q==;
X-CSE-ConnectionGUID: 7g2oRnnuQVmOG69vEHpPOA==
X-CSE-MsgGUID: rC2qv+/7TLqwF2wA5GdQxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="85911683"
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="85911683"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 09:18:08 -0700
X-CSE-ConnectionGUID: ijOu1H5eS2Sv5fpaRL4kOQ==
X-CSE-MsgGUID: xGf+JUxKRRCcQqV3SqxhGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="220807150"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.112])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 09:18:01 -0700
Date: Thu, 12 Mar 2026 18:17:48 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] lib: crypto: fix comments for count_leading_zeros()
Message-ID: <abLnLIRf6z8nh_Pu@ashevche-desk.local>
References: <20260312161133.249374-1-ynorov@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312161133.249374-1-ynorov@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Mar 12, 2026 at 12:11:32PM -0400, Yury Norov wrote:
> count_leading_zeros() is based on fls(), which is defined for x == 0,
> contrary to ffs() family. The comment in crypto/mpi erroneously states
> that the function may return undef in such case.
> 
> Fix the comment together with the outdated function signature, and now
> that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
> it too.

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


