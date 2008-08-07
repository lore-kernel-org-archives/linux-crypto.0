From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Thu, 7 Aug 2008 10:00:10 +0800
Message-ID: <20080807020010.GA6176@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain> <20080806094226.GA23685@atrey.karlin.mff.cuni.cz> <1218020727.29030.16.camel@localhost.localdomain> <20080806121452.GA22459@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Austin Zhang <austin_zhang@linux.intel.com>, bunk@kernel.org,
	dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49950 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbYHGCAi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 22:00:38 -0400
Content-Disposition: inline
In-Reply-To: <20080806121452.GA22459@elf.ucw.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 06, 2008 at 02:14:52PM +0200, Pavel Machek wrote:
> On Wed 2008-08-06 07:05:27, Austin Zhang wrote:
> > Paval,
> > 
> > Thanks for your comments. 
> > 
> > On Wed, 2008-08-06 at 11:42 +0200, Pavel Machek wrote:
> > > Copyright / GPL?
> > Yes, as : ???+MODULE_LICENSE("GPL");
> 
> Well, it should normally go to comment at the beggining of file.

I've made the following change.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel.c
index 6cd20c5..c0e1e6b 100644
--- a/arch/x86/crypto/crc32c-intel.c
+++ b/arch/x86/crypto/crc32c-intel.c
@@ -5,6 +5,15 @@
  * http://www.intel.com/products/processor/manuals/
  * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
  * Volume 2A: Instruction Set Reference, A-M
+ *
+ * Copyright (c) 2008 Austin Zhang <austin_zhang@linux.intel.com>
+ * Copyright (c) 2008 Kent Liu <kent.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
  */
 #include <linux/init.h>
 #include <linux/module.h>
