Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA8D2FD1D5;
	Mon, 25 Aug 2025 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135650; cv=none; b=h6lTIxACZyrxmDRplCoFmwyyWB/Dn/reZNNMOXH0YlRpzgFIuXf02TOdXcUyT8D7WgudeuiTRGQFkBd0l8mBKj0D9nfBt4nFOwcAcppsr/iq/poyWeHsIa+wyYTXzWblAVC9KAmugkCohrQ59D1A4PR5MS+fZurMLAg+2NcSkc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135650; c=relaxed/simple;
	bh=6fp6Ga3ikEpS+n+78dXlZSC5leONT7yD5YMaNN8maeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ij3kG/9AVG6sTBNJ53GihsW3HRg+zbjVRdsghVobUrJBfk6Zw0a6VB5sky2v8/iPrxWyWuBuRMY9CQ3zkU0YUr4SpPjVX0il6AAf9VN+tGRwj+TMLXXfumXzOtjiHpXoVqQ4V76e67Ia84OPg2mPQEUBdVJcxd8cdD+Z64ZDLX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ODHZYoFL; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ODHZYoFL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756135650; x=1787671650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6fp6Ga3ikEpS+n+78dXlZSC5leONT7yD5YMaNN8maeI=;
  b=ODHZYoFLAm/qR8QFYNyQFVGS10uml8QvA/X2GaOtk/TTcJZ8zZkXh5Ln
   HFunRJtQUvKVfwtfz0UZczNM7/goSy3Y1g5rTg99y/97r49honX0+bGXX
   DiPgVvZYwOqg/tRFGUlGChac/fXQRm+WHWzr1bOKjS8GXvQOLeoLLaGbv
   CGZiJQLj0rSePYCXCqYOE96fYXAmW0skjPmdiz0toMpL45/9G9NKoditN
   97Y/gl8p+WOF77S5fbDXElBt/gAGJ/sywEWhfg8BdIgZ9hcqvzNrZNMnU
   Kek++cdYeC9CgtiSutxtLVLgB3qIN/SxjwYd69dgzbyJkv3yUdu8PdefY
   w==;
X-CSE-ConnectionGUID: S2KBjS5wRLuNABZiRFnm7A==
X-CSE-MsgGUID: SVgGcmGhRCCaVeJYsSmU0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="61995339"
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="61995339"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 08:27:29 -0700
X-CSE-ConnectionGUID: S6te/EH3TMOWB20AcCgPEw==
X-CSE-MsgGUID: iG4TRLi2SHiK7LnQhaoKKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,213,1751266800"; 
   d="scan'208";a="168534351"
Received: from smile.fi.intel.com ([10.237.72.52])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 08:27:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1uqZ6R-00000008XtB-1DDM;
	Mon, 25 Aug 2025 18:27:23 +0300
Date: Mon, 25 Aug 2025 18:27:23 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Message-ID: <aKyA2_1qugoOZSRj@smile.fi.intel.com>
References: <20250821132634.654864-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821132634.654864-1-rongqianfeng@vivo.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Aug 21, 2025 at 09:26:31PM +0800, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.  Similarly, use size_add() instead of explicit addition
> for 'uobj_chunk_num + sobj_chunk_num'.

FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


