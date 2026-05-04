Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD7C2C9D;
	Mon,  4 May 2026 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902694; cv=none; b=dHg3QehCiYzx9IkXIcD62g9VRHc6e/TwJQZ2htgrVY+NwC3xDOHSNfEJcVQIxiFE2psOZ2ybnVW5NV596lrYI6MRMKpBT/cnxeWupO/LNtk4Td8rPdzYvlxhBMT98Q252hJBIsTUk0jmO2OM6Yiy2MKUnfer2rZ1OEdldldnO/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902694; c=relaxed/simple;
	bh=7S1mBfsnVF+FvbLlO+ZpnuRJBa0IQPTXZypaBn7u59A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cpeapxj99LnmizUmjWcUJbz9zNebufWf7/ukLRbyjmUe3YSEknBKgyp+z0zqQGNbLmJbTDkFuQR/PcUydBU0mzdNkh8cuIDRwIYO+55apm89sAofIcBcFbFMYR4FMfZLQl1FIr17BJLp7rweMcNiAh8xIZ5kmYbOLdJwJy8slKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jMHWQCz1; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jMHWQCz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777902693; x=1809438693;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7S1mBfsnVF+FvbLlO+ZpnuRJBa0IQPTXZypaBn7u59A=;
  b=jMHWQCz1QAx+yXtQqn1BPL6fmr27P+xVPRZjOV0BWbePDx09OAs0ebRj
   ElgXjj4Ht9eQGI10wFHHRf4xhbhirLkbsTvlFXjfwaM/6pc0ouSH/AOf4
   TWWZ5/rL4u6MVOSggWZd2UsfuLKt0ZT2DuneoPn2gkJc/MRfqd7ZPDPBS
   1MFg8IVRkXY09OYUErXBUCy31Boae3SOIHA89/imIvaWRL/hEYvtuWq/j
   JWeHmxJ5NXM2bvpbxergXVxuZp/Ms8qWOh6vAljCCj81dS8IOpRTskBeV
   cRIvUOhsGElib2BYiUnIXwebjliJBVnOZeooTTSeo0rQ/ZNUQ7f8dHtLj
   w==;
X-CSE-ConnectionGUID: JzWBrPVeSkSx7YYtaO2GNA==
X-CSE-MsgGUID: ypi58CoTT/aSjPedS5ZKEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="89449485"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="89449485"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:51:32 -0700
X-CSE-ConnectionGUID: SudLECB5RBS/8L8kzHaUwA==
X-CSE-MsgGUID: eh4nEmgmRBuAttfjuf3Vwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="229021784"
Received: from ettammin-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.245.198])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 06:51:30 -0700
Date: Mon, 4 May 2026 16:51:28 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH v1 1/1] hwrng: core - Replace strlcat() with better
 alternative
Message-ID: <afikYP56xL2gwtAJ@ashevche-desk.local>
References: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
 <afib61h9JJPiPcMv@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afib61h9JJPiPcMv@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, May 04, 2026 at 03:15:23PM +0200, Thorsten Blum wrote:
> On Mon, May 04, 2026 at 03:02:59PM +0200, Andy Shevchenko wrote:
> > strlcpy() and strlcat() are confusing APIs and the former one already
> > gone from the kernel.
> > 
> > In preparation to kill strlcat() replace it with the better alternative.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> I already took care of this one a few days ago:
> 
> https://lore.kernel.org/lkml/20260430110047.248825-8-thorsten.blum@linux.dev/

Very good, thanks!

-- 
With Best Regards,
Andy Shevchenko


