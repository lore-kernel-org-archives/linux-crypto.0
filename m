Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC63B315D4E;
	Thu, 30 Oct 2025 17:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761846104; cv=none; b=c80N/Zw84sVxTjnjAupz70mJVme648D1Y9KWRIND9OVvv5HlqwPYYTPM9llnY4E/OCUxBpi5ULA3aAwN0Fklk+uC8ohDO+8EfwFfRZaDe/WF62LGCvmYnsWDAxEAOAU8a//475HRdEjiqLEt4wYNks31NroFg1JIShhhg3SEIss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761846104; c=relaxed/simple;
	bh=URuRo1dhGqAFfFwhTV0hZS+/C986ZcGEsKUnVYLDfVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEZVPn6oM4dx/SzDK1df5GD8Dod7J3+dBdSvvF/lp4AYPw0QrB3jMM1ss9fkJqhjsl1bjLWI7wuEe1ORYvVS/BFHIHJxJKL9Wo+lgnlKlHdOuZhLthlASlLN9K8IYuhyubX/Aa/aH3wvaF1+y4Rf9xJe9qk6WpDJxnTNcVliVRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bZn5tqoz; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bZn5tqoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761846103; x=1793382103;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=URuRo1dhGqAFfFwhTV0hZS+/C986ZcGEsKUnVYLDfVQ=;
  b=bZn5tqozDJ34E9Q5vrgicIHutWvIov27IQvvH7WHhdCRd023HC4xwDZH
   6QO7P4eRUJRw0E5fYh6uXPYxZIzHgohlJML+P+2R12mrOJ/3O4+5esBdM
   Usao4bLiGY6y3facLPBhevAE29V4JsqbfRkn1RPsYUdKQaR0/gNAcUQ1J
   BcGzQfcVYnQSExEHIOj44s9fgcn4cpZ6d074JNm2EXtq5OuQ0rQhWsSHm
   4GSR4o2/eH0p9507uKmOwgLl+KZdSy2YRztL0CglzDte4r9KybPXwxHX5
   Ovf5qamKcIORu3XyCNq8+JA+YKjTRuRnYXncuB1pvK64m5Cti5tyKzabv
   w==;
X-CSE-ConnectionGUID: QTWly6XHSpyvVytCNWkV7Q==
X-CSE-MsgGUID: UXpfsV6WToKh+Jt9sccxkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="75117280"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="75117280"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:41:43 -0700
X-CSE-ConnectionGUID: fbXW1JogSAG0cbsa690JRQ==
X-CSE-MsgGUID: 5rMsNbEnRY2BoBShyXbFdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="216862580"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.174])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 10:41:40 -0700
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vEWeX-00000003zCg-2ZNk;
	Thu, 30 Oct 2025 19:41:37 +0200
Date: Thu, 30 Oct 2025 19:41:37 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Qianfeng Rong <rongqianfeng@vivo.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: qat - use simple_strtoull to improve
 qat_uclo_parse_num
Message-ID: <aQOjUdxfECKQ6uy7@smile.fi.intel.com>
References: <20251026015710.1368-1-thorsten.blum@linux.dev>
 <aP81GIlKmMv4pW-8@smile.fi.intel.com>
 <aQNLqclwOpEhMcaT@gcabiddu-mobl.ger.corp.intel.com>
 <aQNwHuNwPy6rDz-1@smile.fi.intel.com>
 <aQNxx+sTMydyG2ub@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQNxx+sTMydyG2ub@gcabiddu-mobl.ger.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Oct 30, 2025 at 02:10:15PM +0000, Giovanni Cabiddu wrote:
> On Thu, Oct 30, 2025 at 04:03:10PM +0200, Andy Shevchenko wrote:
> > On Thu, Oct 30, 2025 at 11:27:37AM +0000, Giovanni Cabiddu wrote:
> > > On Mon, Oct 27, 2025 at 11:02:16AM +0200, Andy Shevchenko wrote:
> > > > On Sun, Oct 26, 2025 at 02:57:07AM +0100, Thorsten Blum wrote:
> > > > > Replace the manual string copying and parsing logic with a call to
> > > > > simple_strtoull() to simplify and improve qat_uclo_parse_num().
> > > > > 
> > > > > Ensure that the parsed number does not exceed UINT_MAX, and add an
> > > > > approximate upper-bound check (no more than 19 digits) to guard against
> > > > > overflow.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> > > I just noticed this while applying the patch to my local tree.
> > > 
> > > Due to the typo, patchwork is not applying your tag [1].
> > 
> > Oh, thanks for catching this. Have you added it manually or should I do
> > something about it?
> I haven't added it manually. If you reply with your tag again it will
> get sorted.

-- 
With Best Regards,
Andy Shevchenko


