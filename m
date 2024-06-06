Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6C146A85
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717666534; cv=none; b=dya6FUhZBJBJiohNQ92iz0zhRAw4Xs6IOBUFq2ky33O9Q9qGuwoBR59kbQNlj5G7EiFeysgRMabvuZjeghKVSO3MrhBzq5zi9tqXF1xYAmDbr0d+x0HGSg+b2z2QD1GWccDB7w70QZUzC71iRryErRHYK2VtfTz97/26qgavdSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717666534; c=relaxed/simple;
	bh=AyYMIq8nW7fswqbP7HmYZwUQQyS4VQRzi6wBVzsp27E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHuhniy4FybF+ZpL+zTKR05cz7ZoaVwq2wW9L2+rEB87TQIALc9TYP7UUqPrwiTM7KGtYvHm9oKDMKSZNvzY4u5r5BdkaOP+KDgQps0eEdkIqqqhBzfTWQCn35toMCN+vfUZpE0bHZrFbrOUFVQOsqFbL2nmaGlKgXeyf2K1Yd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
X-CSE-ConnectionGUID: WoAwy5PzR4uBhji4c59W+A==
X-CSE-MsgGUID: x83QQP6uS9q7XAGYM3swQw==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="24954351"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="24954351"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 02:35:32 -0700
X-CSE-ConnectionGUID: EWQ0bgVtRwWYr9tt00L29A==
X-CSE-MsgGUID: iI3GwdagTe6sj/XsU5IoeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="42844269"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 02:35:29 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1sF9Wo-0000000E7ht-2BQq;
	Thu, 06 Jun 2024 12:35:26 +0300
Date: Thu, 6 Jun 2024 12:35:26 +0300
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v11 6/8] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <ZmGC3sacfMxnshEA@smile.fi.intel.com>
References: <20240605161851.13911-1-kabel@kernel.org>
 <20240605161851.13911-7-kabel@kernel.org>
 <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
 <20240606111113.7f836744@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240606111113.7f836744@dellmb>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Jun 06, 2024 at 11:11:13AM +0200, Marek Behún wrote:
> On Wed, 5 Jun 2024 22:00:20 +0300
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> 
> > > +#include <linux/bitfield.h>
> > > +#include <linux/completion.h>
> > 
> > + errno.h
> 
> I use -EIO, -EINVAL and -ENOMEM in turris-omnia-mcu-base.c,
> -EINVAL, -ENOTSUPP in turris-omnia-mcu-gpio.c.

> Should I include errno.h in those also?

If you have err.h, then no (it includes asm/errno.h), otherwise, yes.

> Or is this only needed for -ERESTARTSYS?

Definitely yes for Linux internal error codes (>= 512).
Note, that ENOTSUPP is also Linux internal code.


-- 
With Best Regards,
Andy Shevchenko


