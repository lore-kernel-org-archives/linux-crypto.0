Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFE31A063;
	Thu, 21 Aug 2025 12:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755781024; cv=none; b=DRBWLvrX+zWwBPX2PFIjGWHQjUFoN9t2YmVCvLshiF3VD9Nyzjg44dLfcerMbV+VRGz8OMheaK6TrYUIZBIRhrxMSnbKl3CZbRgQUf0mpfsS3S6jcS/rIRG4gheonAXO3b1ZTA09+wmEp2Kbj62RF1JYQWGzfCIm8Jks592TpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755781024; c=relaxed/simple;
	bh=uHJd7Pb5ae2gpz/lAOltjUou5PKEACTRLIkY9GFloXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=to9v8njiGZbWBVx9cc0kTv4xiKhMxm5MKfrWEKuybGhQ+yfeFluTPZts6tGA9VD1iXZ19tupsHmIet0ngsvL7sFy74eyyUTqYyPeBVmODiwlP6XqF920aV8KgV8k+Y96FWXiIjhNhI8stjj6ah70NrDxnT1iFPKb18aUgrFL4AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CWXAkW8k; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CWXAkW8k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755781023; x=1787317023;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uHJd7Pb5ae2gpz/lAOltjUou5PKEACTRLIkY9GFloXw=;
  b=CWXAkW8kI6AtT72XCwOsIZbgxMspH08EpkSS8U4Zh83vClXgs30kPtee
   wlTyL+i5VbR/u3CbQMa+IaGzvMSY75y/Q4Xa05QNJpc70AiEcFLHJrmmF
   ZhY8Jk+GmVhpDyrQclhEsIMNLKiWigLF7bXufB9a3nmVEvfdTGGPRkaSm
   UqaFOPaMq5EqrycgP/z3+V0T/u3rp+3TecXfqTSPrRmgqXb6nbGvdufzN
   /0yce7apIU+KixWcAlIfgBnEqTeZveqtnOFe2JX2Tf8adTrGqmRqpeYTJ
   MUr5TbqqumK8MxtTZokYV5G2E1wDzXNxnIz3oq4wk3kDIOZNRD6ER9R62
   A==;
X-CSE-ConnectionGUID: XIXvF1MmSc+aeZDpPS5CuQ==
X-CSE-MsgGUID: H+y+gUzvTA6jO3CTiyUOAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="60696496"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="60696496"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 05:57:02 -0700
X-CSE-ConnectionGUID: 0/9YlzXFSuaO7mVcP18Dkg==
X-CSE-MsgGUID: +06T7zzhTMOF6d0UpO2kOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199388543"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 05:56:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1up4qe-00000007EjG-1UbI;
	Thu, 21 Aug 2025 15:56:56 +0300
Date: Thu, 21 Aug 2025 15:56:55 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Message-ID: <aKcXlxNRDr5IQYwh@smile.fi.intel.com>
References: <20250821123544.629821-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821123544.629821-1-rongqianfeng@vivo.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Aug 21, 2025 at 08:35:42PM +0800, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.

> [1]: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

Make it a Link tag.

Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>

(also note no blank lines in tag block)

...

> -	mobj_hdr = kzalloc((uobj_chunk_num + sobj_chunk_num) *
> +	mobj_hdr = kcalloc(uobj_chunk_num + sobj_chunk_num,

size_add() ?

>  			   sizeof(*mobj_hdr), GFP_KERNEL);
>  	if (!mobj_hdr)
>  		return -ENOMEM;

-- 
With Best Regards,
Andy Shevchenko


