Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6D885299
	for <linux-crypto@vger.kernel.org>; Thu, 25 Apr 2024 10:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714039455; cv=none; b=e6pWnvyR+yn0RBp+KT6Innm0lbXJSGaPAlapRhyVZQVnfVfFFSqa1phE1lifeVEls+JWiwrHvOz1RMWQEb0BJxosiHjirRCH2GKGrIt/LMZSQ9t5lV9G6m54HR6BB1D/DfpF+kAwDVzh1sYWdpRJiTOstFCdIabiQS/NaOK6r9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714039455; c=relaxed/simple;
	bh=thc86tFSjlJx/H0DHzsqy20AFf1tuOO4NRPeFx+2qr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFA2JcTqgq/XKxQhMB95ZmHx0Veg7wLDmIhsHUXwzzCcLkB40jE1OEA7SCwY5JBIMoyUVHC5JWA/z/y+UZTo2ZrN7J4kBwHMiUarDtd29NweVsCwH0QSDPIclV/seZKwgM3bzdkr0gnpBSDeGnEWnB8+fCbbcmTO3KY7BX9B57w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: yI3vW6rWQZybNimMCUeNaQ==
X-CSE-MsgGUID: UfKIBtzNS6WaoQj9wl1LyQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9584774"
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="9584774"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 03:04:13 -0700
X-CSE-ConnectionGUID: yZtPqqnrQ7enbZvr3/8aJw==
X-CSE-MsgGUID: XtFGhbl0QVKu36aiAOns4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,229,1708416000"; 
   d="scan'208";a="25643272"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 03:04:11 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andy@kernel.org>)
	id 1rzvxX-00000000xPX-1VBZ;
	Thu, 25 Apr 2024 13:04:07 +0300
Date: Thu, 25 Apr 2024 13:04:07 +0300
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
Message-ID: <Zioql5TSzTLtMsX7@smile.fi.intel.com>
References: <20240424173809.7214-1-kabel@kernel.org>
 <20240424173809.7214-7-kabel@kernel.org>
 <ZilQiHLLj1eQxP2L@smile.fi.intel.com>
 <20240424205123.5fc82a1a@dellmb>
 <Zilhvv3ffWMDL1Uj@smile.fi.intel.com>
 <20240425113447.5d4b21f4@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240425113447.5d4b21f4@dellmb>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Apr 25, 2024 at 11:34:47AM +0200, Marek Behún wrote:
> On Wed, 24 Apr 2024 22:47:10 +0300
> Andy Shevchenko <andy@kernel.org> wrote:
> > On Wed, Apr 24, 2024 at 08:51:23PM +0200, Marek Behún wrote:

...

> > For what purpose? I don't see drivers doing that. Are you expecting that
> > the same IRQ mapping will be reused for something else? Can you elaborate
> > how? (I can imagine one theoretical / weird case how to achieve that,
> > but impractical.)
> 
> I do a lot of binding/unbinding of that driver. I was under the
> impression that all resources should be dropped on driver unbind.
> 
> > Besides above, this is asymmetrical call to gpiod_to_irq(). If we really care
> > about this, it should be provided by GPIO library.
> 
> Something like the following?

Not needed. IRQ mappings are per domain, and GPIO chip has its own associated
with the respective lifetime, AFAIU when you remove the GPIO chip, all mappings
will be disposed (as I pointed out in previous mail).

-- 
With Best Regards,
Andy Shevchenko


