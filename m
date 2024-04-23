Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2571BC23
	for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2024 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713893122; cv=none; b=JTx0naOT0VEj7LfRI0sdf0hbSMf04TFmiaQo/COMZgNP0oSwyVi+gQ/5R8bqG8Zgfz/NVINUesSM9nL4FMno51NunMhPb5tTC2E3D5J/m5FvDPo7hwSVb5dSIgV1+rlqkxhOrr5bWeUzeaPPEYgw6reZwtL/DmvbEUC+2F+j5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713893122; c=relaxed/simple;
	bh=FajkJ2QvLktLkuWIAFJilqfX2YAMOTvTp7HdHkduzPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WyUf2KYa1oiOiUf4BuAmr3e1zwovhoYOsxm0mKRNgzmECGJrsquPSofgYBdtsrkKly8Yd9nZJCXU3Dc2TkHUYj9U4EhgkaiWZYumNLAz6RvXX3DFQTzYD+yNol6WEOUPnp8G+XlEzsVv1gS00UCjuX3xq04+iTK01inPrcKgRZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
X-CSE-ConnectionGUID: OplrNeh8TpGW5XdbYSWQFg==
X-CSE-MsgGUID: YS50gbWvSi6PJNvZJQn7Hw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="9612053"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9612053"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:25:20 -0700
X-CSE-ConnectionGUID: 9oqRrADpQuS4WG3/3jUS0g==
X-CSE-MsgGUID: 0WW+7nchRlKiYyH22DhnKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29246863"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 10:25:18 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1rzJtK-00000000PZ0-3jQ9;
	Tue, 23 Apr 2024 20:25:14 +0300
Date: Tue, 23 Apr 2024 20:25:14 +0300
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH v6 07/11] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <Zifu-l2o9ADkhMlW@smile.fi.intel.com>
References: <20240418121116.22184-1-kabel@kernel.org>
 <20240418121116.22184-8-kabel@kernel.org>
 <Zifamxfa18yjD_VS@smile.fi.intel.com>
 <20240423183225.6e4f90a7@thinkpad>
 <CAHp75VcfmTeG+G1DkteR6GN96y3+h_Mz1YQ8U5asHJ7oTq+KbQ@mail.gmail.com>
 <20240423185704.2237bc65@thinkpad>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240423185704.2237bc65@thinkpad>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Tue, Apr 23, 2024 at 06:57:04PM +0200, Marek Behún wrote:
> On Tue, 23 Apr 2024 19:43:41 +0300
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Tue, Apr 23, 2024 at 7:32 PM Marek Behún <kabel@kernel.org> wrote:
> > > On Tue, 23 Apr 2024 18:58:19 +0300
> > > Andy Shevchenko <andy@kernel.org> wrote:  
> > > > On Thu, Apr 18, 2024 at 02:11:12PM +0200, Marek Behún wrote:  

...

> > > > > +   irq_idx = omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > > > +   irq = devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> > > > > +   if (irq < 0)
> > > > > +           return dev_err_probe(dev, irq, "Cannot map TRNG IRQ\n");  
> > > >
> > > > This looks like some workaround against existing gpiod_to_irq(). Why do you
> > > > need this?  
> > >
> > > Hmmm, I thought that would not work because that line is only valid
> > > as an IRQ, not as a GPIO (this is enforced via the valid_mask member of
> > > gpio_chip and gpio_irq_chip).
> > >
> > > But looking at the code of gpiolib, if I do
> > >   irq = gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> > > the valid_mask is not enforced anywhere.  
> > 
> > Which one? GPIO has two: one per GPIO realm and one for IRQ domain.
> 
> The GPIO line validity is not enforced. The IRQ line validity is
> enforced in the gpiochip_to_irq() method.

Okay, but does it work for you as expected then?

If not, we should fix GPIO library to have gpiod_to_irq() to work as expected.

> > > Is this semantically right to do even in spite of the fact that the
> > > line is not a valid GPIO line?  
> > 
> > Yes. It's orthogonal to that.

-- 
With Best Regards,
Andy Shevchenko


