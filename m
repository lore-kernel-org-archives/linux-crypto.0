Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26B3AE6F4
	for <linux-crypto@vger.kernel.org>; Tue, 18 Aug 2026 04:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787027309; cv=none; b=eNbrxcZ52NbHNX4fKstGVU9TFbHkOZ8PI/ehyMTWCFaPW71AFTbMRRqaRiX7nhsSKktoacCw6C1XwY0y2e6izE8lBloBf+2yVUpluo89YA7XXdMNLvqKMal7LjBJTBqJBOtTythxL94coUzNtwfQDFJfn+ElwtUl2y+3yV09H5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787027309; c=relaxed/simple;
	bh=3s1wefT+Wvz5UdnvC5/+5H3jWHtxXuh+/O18PSykZiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SknmeNI5rIfVEmO7UmcGtoz5x0DacCv3lmcSixmepsSLnaQN0B7ZFmiFKaZPSnzgWZiGy1QJqJTCB8tAPs1Oo+RRUFxz/b1NzZjaYWFc2pftUHzT/wmn908Vqofb2FP85mfKUjMD3BdXtSGMAar6kxLrbtWFO86irlTBDhxUQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WatR0tnY; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WatR0tnY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787027307; x=1818563307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3s1wefT+Wvz5UdnvC5/+5H3jWHtxXuh+/O18PSykZiw=;
  b=WatR0tnYK3pMR8ZCbmI9bZmHQfSJ4doTGDcFBw5LtdKDdkJRNtPTiUiB
   WretGQ2QuKhEgqq/a6rQruP9naGoVV3etlWr5g1dGcTk3pPUsFTmNQ9gI
   h9Vf9vHNTUBFVFrUkas4EjnS4mYrrMRI5n4vpmld0mIuZ8Yv2zmzhwTDV
   NtmqQSlgDC2rPZzdRrLMtOhz0xyvoL6rFtXKpbCxRInykB5+fzjOlG+7H
   TfupmAsE+drPAKrOBP2uYQ/1rBomwf0DWwTlD9/JDZvHoI/7jxgR/0LVT
   dYW4Ahnwniy+Jn6cqgTcV/A4aFpG8YdxcXO09ctKSj+fT0IMbZs82TmNL
   w==;
X-CSE-ConnectionGUID: hFqNlipQQmeqiGlrENBXdQ==
X-CSE-MsgGUID: 7hr1TIVxQme3/KnzTfD6CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="104891221"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="104891221"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 21:28:27 -0700
X-CSE-ConnectionGUID: F/fHRdOGQr2eB5/fY9Rs4Q==
X-CSE-MsgGUID: xug39NTeRS2ge/1781rXIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="289922469"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.209])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 21:28:25 -0700
Date: Tue, 18 Aug 2026 07:28:22 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-drivers-review@eclists.intel.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Subject: Re: [linux-drivers-review] [PATCH] crypto: qat - remove dead ADF_HEX
 code
Message-ID: <aoPfZihxkjUPEmxC@ashevche-desk.local>
References: <20260731124832.159453-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731124832.159453-1-ahsan.atta@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Fri, Jul 31, 2026 at 01:48:32PM +0100, Ahsan Atta wrote:
> The ADF_HEX value type is defined in the adf_cfg_val_type enum and
> handled in adf_cfg_add_key_value_param(), but no caller in the tree
> uses it.
> 
> Remove the unused ADF_HEX enum value and its dead handling code.
> 
> Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")

Why is this a fix? Is there any security threat?

-- 
With Best Regards,
Andy Shevchenko


