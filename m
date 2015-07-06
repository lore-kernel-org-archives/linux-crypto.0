From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/6] nx-842-platform: if NX842 platform drivers are not
 modules, don't try to load them
Date: Mon, 6 Jul 2015 10:07:40 -0700
Message-ID: <20150706170740.GB3578@linux.vnet.ibm.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224225.GG1712@linux.vnet.ibm.com>
 <20150706081307.GA20616@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:43672 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbbGFRHp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 13:07:45 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <nacc@linux.vnet.ibm.com>;
	Mon, 6 Jul 2015 13:07:44 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5E4AF38C8056
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2015 13:07:42 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t66H7gGg58458206
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2015 17:07:42 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t66H7f7b025900
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2015 13:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20150706081307.GA20616@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06.07.2015 [16:13:07 +0800], Herbert Xu wrote:
> On Thu, Jul 02, 2015 at 03:42:26PM -0700, Nishanth Aravamudan wrote:
> > Based off the CONFIG_SPU_FS_MODULE code, only attempt to load platform
> > modules if the nx-842 pseries/powernv drivers are built as modules.
> > 
> > Otherwise, if CONFIG_DEV_NX_COMPRESS=y,
> > CONFIG_DEV_NX_COMPRESS_PSERIES=y, CONFIG_DEV_NX_POWERNV=y, the following
> > message is emitted at boot:
> > 
> > nx_compress: no nx842 driver found.
> > 
> > even though the drivers successfully loads.
> > 
> > This is because in the =y case, the module_init() calls get converted to
> > initcalls and the nx842_init() runs before the platform driver
> > nx842_pseries_init() or nx842_powernv_init() functions, which are what
> > normally set the static platform driver.
> > 
> > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> > Cc: Dan Streetman <ddstreet@us.ibm.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linuxppc-dev@lists.ozlabs.org
> 
> Ugh, I think this whole thing is redundant.  The whole point of
> the crypto API is to allow the coexistence of multiple underlying
> implementations.

Sure, that makes sense -- sorry, I was picking this up while Dan was on
vacation. Will provide a better v2.

> Please get rid of nx-842-platform.c completely and move the crypto
> registration into the individual platform drivers.  That is, powernv
> and pseries should each register their own crypto driver.  They can of
> course share a common set of crypto code which can live in its own
> module.  There should be no need for mucking with module reference
> counts at all.

Will do, thanks!

-Nish
