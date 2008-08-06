From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
Date: Wed, 06 Aug 2008 07:20:14 -0400
Message-ID: <1218021614.29030.19.camel@localhost.localdomain>
References: <1218000211.4231.23.camel@localhost.localdomain>
	 <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
	 <1218020727.29030.16.camel@localhost.localdomain>
	 <20080806111724.GA32129@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pavel Machek <pavel@suse.cz>, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbYHFLWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 07:22:16 -0400
In-Reply-To: <20080806111724.GA32129@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2008-08-06 at 19:17 +0800, Herbert Xu wrote:
> On Wed, Aug 06, 2008 at 07:05:27AM -0400, Austin Zhang wrote:
> >
> > > > +		return -1;
> > > 
> > > That's supposed to be errno, right?
> > Are you suggest "ENODEV"? It's a feature from the device but the device is exact here. 
> 
> Yes I think this should be ENODEV to be consistent with the
> existing drivers such as padlock-aes.c.
> 
> I'll make that change in cryptodev.
> 
> Thanks,
Thank you, Pavel and Herbert. 

