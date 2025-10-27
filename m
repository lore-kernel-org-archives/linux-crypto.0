Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5E62F28F4;
	Mon, 27 Oct 2025 09:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761555744; cv=none; b=bj2o4xcTIzMCWeqsMKHY/aZuSjVX/Bmbcm4WKz7lV37OH6kM08Ss0y8YVUOaWu/dbx7y8oJk7M6am7J3IMQzaMO3jm6aiLtm+6lvT4snD6eazhcehqukLev5vpwX2qnvtXd6657SSU8kjBpq+JBLK54iFkEF9jwqUY5sjU9Y8BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761555744; c=relaxed/simple;
	bh=HFb0eEemxJ1NaWKC9oWQekWf7ol2w4zgCMnLm3Wg9cE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JW+njP7ruPfBm8D++Je+X/PBN3bhk+35KvTraIIxwFTH25hL0jBUXyE5UBTZjCAdJ8Lz1sDOU3P9Ri37stquicTbo9kaVdKYeStpQOARXyfEv2cFh1/k2bUnBX8/+d+07gqBXi2tiDNNy4mKnuDNVddTz/WT3EkzJLLg6eeDdTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEp458am; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEp458am"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761555743; x=1793091743;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HFb0eEemxJ1NaWKC9oWQekWf7ol2w4zgCMnLm3Wg9cE=;
  b=YEp458am7Fb0zJOzEhgLy1uba5UKT29avBD1EBvuuLYNFgMGnNRuUQfP
   AgO/qYdgO5lIFXSbXP8M1sLUlcR7zL8M07QRk6BEBugR6zUmyw6HeH7o7
   5eFXoRCk/YXrGBEuoaQ51qLEwGgf4XjwjO3DlLnXYUBDMl6u1/2lSeTpG
   sLNd1AcGTMCYGcYMf0VaQFn7ECSFsNRmBBVe13eAiiljivWVEZKhIpHBF
   HxL9TChkptZl4JgnPEvDwRSKvN2axSANI82+lhJkYlGgPNQgfWY0six7Q
   nFkNxUnieA0NI5TARalN0OVhfBY56sjWAo1xUjC/xtxePs/XBmlvYFb2j
   Q==;
X-CSE-ConnectionGUID: KeWrncpyTAKPJmx3z5ELjg==
X-CSE-MsgGUID: wd81uNQpTZWzVAW7b+oM2Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74973931"
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="74973931"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:02:22 -0700
X-CSE-ConnectionGUID: uAZrE9wnT42Kw+QPuBC//w==
X-CSE-MsgGUID: 6nAVXN/ZQcqqcoJ7Cv5cOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,258,1754982000"; 
   d="scan'208";a="215643398"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.244.5])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 02:02:19 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vDJ7I-00000002xMN-1txo;
	Mon, 27 Oct 2025 11:02:16 +0200
Date: Mon, 27 Oct 2025 11:02:16 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aP81GIlKmMv4pW-8@smile.fi.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026015710.1368-1-thorsten.blum@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> Replace the manual string copying and parsing logic with a call to
> simple_strtoull() to simplify and improve qat_uclo_parse_num().
> 
> Ensure that the parsed number does not exceed UINT_MAX, and add an
> approximate upper-bound check (no more than 19 digits) to guard against
> overflow.

Reviewed-by; Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> ---
> Changes in v2:
> - Use simple_strtoull(), return -EINVAL, and guard against overflow as
>   suggested by Andy

(some) overflows :-) But at least it keeps the code on par with the original.

And we ignore false positive (in this case!) checkpatch warning.

-- 
With Best Regards,
Andy Shevchenko


