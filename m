Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677232E2F0E;
	Thu, 21 Aug 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755790853; cv=none; b=BNN8a2egn+VIvunZ9taH6j6ir4WwDziaklS2lfoRqpcR6beVwTziiw6XUsl4/942TfcGptAx3WpZW4E5FIGaCUj4elW9qNGpl4fjAlMT+yW0rxR7NuFfp2wJXzARhYC82BRISLDz9leLRezchka3vMVzrUOlWOSshKQtoxmY5rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755790853; c=relaxed/simple;
	bh=yuP5NjNY6ORzDi4IxT8giX54EGDttf6YI229VJ4Axnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2k/MilulsQFMyq2/jQxsAdKaACV4KvIQQNdhP8MWl/PJmVzXBklWYlvWZxHS1vHFZSlQN0iYWvgrh2XeCEh/lSmKpIWYG0Y/e1QtAxKN23C7t3VYfE38QL0eJsrOJQX2NvWG4L8MvFRgpCarHgcYBZ0nwR50Slv9VIdyjToED4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QMDIBxQ4; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QMDIBxQ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755790851; x=1787326851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yuP5NjNY6ORzDi4IxT8giX54EGDttf6YI229VJ4Axnk=;
  b=QMDIBxQ4ECZjUKz4Mz4DUr/jPY6ZVqZe1ngMMpvFJ3zbBDU5zpgDPAB1
   li5IwmohgKDPeA7z9ZRd1pVKKAsM7yUT1eJT0KDwWU86cMcLQRR/qGRMb
   S7UU3uvOCAzpE5x5po8uhXBgcHilmqVc/w1pLHYko2CV6spTb6Py41ps9
   p4wS18sHAmwtBFX1mj4EVrBs5Ts1xgSR2aLeK8eDIWbLlIXqg3RUDDLC+
   N6Wo5h1TRVcxRvMbP1iS/hJvrRk3FS0DyShkxoNYCMBVXrzC2U9wXrCLf
   yLAP2s/f1v0cN3xmyrFc24kzI8dFGqaC3HNaZHGrAjC7ciX5szDDSpTSS
   w==;
X-CSE-ConnectionGUID: 7HdqX8c7Sd6oo3aUpplb4A==
X-CSE-MsgGUID: DVgeBHEJRnioTP/v+eiNFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="58182657"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="58182657"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 08:40:36 -0700
X-CSE-ConnectionGUID: 3extm1kgS9yZL4W7U6g66w==
X-CSE-MsgGUID: LZPTUFqjQ6+3alyt9nWXkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172699000"
Received: from smile.fi.intel.com ([10.237.72.52])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 08:40:33 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1up7Ow-00000007H61-2Zmh;
	Thu, 21 Aug 2025 18:40:30 +0300
Date: Thu, 21 Aug 2025 18:40:30 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Message-ID: <aKc97iuDAiIacRiL@smile.fi.intel.com>
References: <20250821142028.33256-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821142028.33256-1-rongqianfeng@vivo.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Aug 21, 2025 at 10:20:26PM +0800, Qianfeng Rong wrote:
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


