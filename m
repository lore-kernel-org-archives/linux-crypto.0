Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A0C190050
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 10:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717668677; cv=none; b=RjsWFleuMnAx8h8EAXIXqbsbOpdLveMdx4b9PpCmJzje3oJyVhdtBsByeJtJHyYp2ThVwCItRU4KKHZxnmRo4mF3k+eRwP4L0eR+8jhVmGq/lN9DyhNhc7c1XL+2JVFiaYdnIoeYh6LXZNvZx5J780K+8ViABgTxCfxgPYG0FPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717668677; c=relaxed/simple;
	bh=WwDhHrCg66CehUGFX31CT+BpYB6Pf4Fud9/NsTVb81Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcM4ckpD+MuDvnmOQOrnj1rcxHTd9MDVbYtsL+xNLO6tihYPqgulTStZ3iEYU6vYs1nrTiPBg/1fYCxUU41Y66TPLIIrrXl4ygQEMtrOL3w0DVE4LqzasQomfpXztjtrdhNnNZscVpy8r5lOloJJrpZVFgwnYSmtjAiR8959D1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
X-CSE-ConnectionGUID: 9kYBYMWBSEmpR6c9fqQp/Q==
X-CSE-MsgGUID: w1YahqPJS/yNk/RKoupGRA==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="14129439"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="14129439"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 03:11:15 -0700
X-CSE-ConnectionGUID: oBY/CkLHQ/yjdo9IHbaarg==
X-CSE-MsgGUID: 141Z3JYSSlOsiqpqgiFO1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="37878894"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 03:11:12 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy.shevchenko@gmail.com>)
	id 1sFA5N-0000000E8B3-2Tap;
	Thu, 06 Jun 2024 13:11:09 +0300
Date: Thu, 6 Jun 2024 13:11:09 +0300
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
Message-ID: <ZmGLPW6vUqOFEK4j@smile.fi.intel.com>
References: <20240605161851.13911-1-kabel@kernel.org>
 <20240605161851.13911-7-kabel@kernel.org>
 <CAHp75VfWZhmw00QP-ra4Zajn7LMvDW+NUT2fMx5kqeQ9eHLv5A@mail.gmail.com>
 <20240606105308.3e02cf1e@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240606105308.3e02cf1e@dellmb>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Jun 06, 2024 at 10:53:08AM +0200, Marek Behún wrote:
> On Wed, 5 Jun 2024 22:00:20 +0300
> Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> 
> > > +       irq_idx = omnia_int_to_gpio_idx[__bf_shf(OMNIA_INT_TRNG)];
> > > +       irq = gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > +       if (irq < 0)
> > > +               return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");  
> > 
> > Okay, it's a bit more complicated than that. The gpiochip_get_desc()
> > shouldn't be used. Bart, what can you suggest to do here? Opencoding
> > it doesn't sound to me a (fully) correct approach in a long term.
> 
> Note that I can't use gpiochip_request_own_desc(), nor any other
> function that calls gpio_request_commit() (like gpiod_get()), because
> that checks for gpiochip_line_is_valid(), and this returns false for
> the TRNG line, cause that line is not a GPIO line, but interrupt only
> line.
> 
> That is why I used
>   irq = irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> until v7, with no reference to gpio descriptors, since this line is not
> a GPIO line.
> 
> We have discussed this back in April, in the thread
>   https://lore.kernel.org/soc/20240418121116.22184-8-kabel@kernel.org/
> where we concluded that
>   irq = gpiod_to_irq(gpiochip_get_desc(gc, irq_idx));
> is better...

That's fine to not use other APIs, the problem here is with reference counting
on the GPIO device. The API you could use is gpio_device_get_desc(). But you
need to have a GPIO device pointer somewhere in your driver being available.

-- 
With Best Regards,
Andy Shevchenko


