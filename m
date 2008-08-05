From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Tue, 05 Aug 2008 06:12:59 -0400
Message-ID: <1217931179.1613.5.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <20080804102711.1c6aecde.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:61385 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758557AbYHEKOo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 06:14:44 -0400
In-Reply-To: <20080804102711.1c6aecde.randy.dunlap@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 10:27 -0700, Randy Dunlap wrote:
> On Mon, 04 Aug 2008 05:35:07 -0400 Austin Zhang wrote:
> 
> > diff -Naurp linux-2.6/crypto/Kconfig linux-2.6-patch/crypto/Kconfig
> > --- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
> > +++ linux-2.6-patch/crypto/Kconfig	2008-08-04 01:59:00.000000000 -0400
> > @@ -221,6 +221,17 @@ config CRYPTO_CRC32C
> >  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
> >            Module will be crc32c.
> >  
> > +config CRYPTO_CRC32C_INTEL
> > +        tristate "CRC32c INTEL hardware acceleration"
> > +        select CRYPTO_HASH
> > +        help
> > +          In Intel processor with SSE4.2 supported, the processor will
> > +          support CRC32C implemetation using hardware accelerated CRC32 
> 
> 	                    implementation
> 
> > +          instruction. This option will create 'crc32c-intel' module,
> > +          which will enable any routine to use the CRC32 instruction to 
> > +          gain performance compared with software implementation.
> > +          Module will be crc32c-intel.
> 
> and don't end lines with spaces...
> 
> 
Thanks a lot:)

