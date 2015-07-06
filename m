From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/6] nx-842-platform: if NX842 platform drivers are not
 modules, don't try to load them
Date: Mon, 6 Jul 2015 16:13:07 +0800
Message-ID: <20150706081307.GA20616@gondor.apana.org.au>
References: <20150702223800.GA1712@linux.vnet.ibm.com>
 <20150702224225.GG1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42405 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbGFINQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 04:13:16 -0400
Content-Disposition: inline
In-Reply-To: <20150702224225.GG1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 03:42:26PM -0700, Nishanth Aravamudan wrote:
> Based off the CONFIG_SPU_FS_MODULE code, only attempt to load platform
> modules if the nx-842 pseries/powernv drivers are built as modules.
> 
> Otherwise, if CONFIG_DEV_NX_COMPRESS=y,
> CONFIG_DEV_NX_COMPRESS_PSERIES=y, CONFIG_DEV_NX_POWERNV=y, the following
> message is emitted at boot:
> 
> nx_compress: no nx842 driver found.
> 
> even though the drivers successfully loads.
> 
> This is because in the =y case, the module_init() calls get converted to
> initcalls and the nx842_init() runs before the platform driver
> nx842_pseries_init() or nx842_powernv_init() functions, which are what
> normally set the static platform driver.
> 
> Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> Cc: Dan Streetman <ddstreet@us.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org

Ugh, I think this whole thing is redundant.  The whole point of
the crypto API is to allow the coexistence of multiple underlying
implementations.

Please get rid of nx-842-platform.c completely and move the crypto
registration into the individual platform drivers.  That is, powernv
and pseries should each register their own crypto driver.  They can
of course share a common set of crypto code which can live in its own
module.  There should be no need for mucking with module reference
counts at all.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
