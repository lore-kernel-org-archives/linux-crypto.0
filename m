Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F2682864
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 09:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714039106; cv=none; b=qK48xTaZ62ksOwM1PqAxB5OIn+t8XAV+tNPUeNsxcdaIxaa1OWFM/0ElyFtWTjxzKm7a85sOUEAsJKRppXpyyScno6lxAV+7SneQd/DGa4LpJEZ39NjulRZzFtEzShOUNsZBuZr/y3/oOyF2oh6gx9vO3b5gWxubxcPzZ71GUXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714039106; c=relaxed/simple;
	bh=J5GvCNpllLEV9nzuDJavMIJX+Q1mfT07hoyNoeT6k6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTO1vsG70T2ptXrFi9eDvDV07R3OC7Fk//hJr1d9R4zAr5TiSxCBtSfUEM0FWL+FaxcaxPkN6S87sawpUZilhFUNZqT0F0UXVdbpyyqb2S+bqy8m5O4fj3oFEMW6OWtt/ZZYSddS2P8UhKphmruuev0H+lEbqgoe4o4wI1vfppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: OkCnHsToRPeNWzGNJPIo/Q==
X-CSE-MsgGUID: xoFb9CbTQSWhfz6qDQu9xw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9584018"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9584018"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 02:58:25 -0700
X-CSE-ConnectionGUID: Cg4/5Cm3RVGi2RzuHv7fuQ==
X-CSE-MsgGUID: 5oOkjPLhRiKjs3troc24TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25052602"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 02:58:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1rzvrv-00000000xJU-0yPK;
	Thu, 25 Apr 2024 12:58:19 +0300
Date: Thu, 25 Apr 2024 12:58:18 +0300
From: Andy Shevchenko <andy@kernel.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>,
	Arnd Bergmann <arnd@arndb.de>, soc@kernel.org, arm@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v7 6/9] platform: cznic: turris-omnia-mcu: Add support
 for MCU provided TRNG
Message-ID: <ZiopOgbF18MObiOj@smile.fi.intel.com>
References: <20240424173809.7214-1-kabel@kernel.org>
 <20240424173809.7214-7-kabel@kernel.org>
 <ZilQiHLLj1eQxP2L@smile.fi.intel.com>
 <20240424205123.5fc82a1a@dellmb>
 <Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Apr 24, 2024 at 10:47:11PM +0300, Andy Shevchenko wrote:
> On Wed, Apr 24, 2024 at 08:51:23PM +0200, Marek Behún wrote:
> > On Wed, 24 Apr 2024 21:33:44 +0300
> > Andy Shevchenko <andy@kernel.org> wrote:
> > > On Wed, Apr 24, 2024 at 07:38:05PM +0200, Marek Behún wrote:

...

> > > > +static void omnia_irq_mapping_drop(void *res)
> > > > +{
> > > > +	irq_dispose_mapping((unsigned int)(unsigned long)res);
> > > > +}
> > > 
> > > Leftover?
> > 
> > What do you mean? I dropped the devm-helpers.h changes, now I do
> > devm_add_action_or_reset() manually, with this function as the action.
> 
> But why?

...

> > > > +	irq_idx = omnia_int_to_gpio_idx[__bf_shf(INT_TRNG)];
> > > > +	irq = gpiod_to_irq(gpiochip_get_desc(&mcu->gc, irq_idx));
> > > > +	if (irq < 0)
> > > > +		return dev_err_probe(dev, irq, "Cannot get TRNG IRQ\n");
> 
> > > > +	err = devm_add_action_or_reset(dev, omnia_irq_mapping_drop,
> > > > +				       (void *)(unsigned long)irq);
> > > > +	if (err)
> > > > +		return err;
> > > 
> > > Are you sure it's correct now?
> > 
> > Yes, why wouldn't it?
> 
> For what purpose? I don't see drivers doing that. Are you expecting that
> the same IRQ mapping will be reused for something else? Can you elaborate
> how? (I can imagine one theoretical / weird case how to achieve that,
> but impractical.)
> 
> Besides above, this is asymmetrical call to gpiod_to_irq(). If we really care
> about this, it should be provided by GPIO library.

FWIW, gpiochip_irqchip_remove() disposes mappings for internally allocated IRQ
domains. So with your code it even might be a double-disposal.

-- 
With Best Regards,
Andy Shevchenko


