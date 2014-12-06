From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/2] crypto: qat - Fix for invalid dma mapping and numa
Date: Sat, 6 Dec 2014 14:45:28 +0800
Message-ID: <20141206064528.GB30388@gondor.apana.org.au>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
 <5481FAB9.3000901@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51496 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaLFGpd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Dec 2014 01:45:33 -0500
Content-Disposition: inline
In-Reply-To: <5481FAB9.3000901@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2014 at 10:34:33AM -0800, Tadeusz Struk wrote:
>
> Looks like these two are not in cryptodev-2.6 yet.
> Do you plan to merge it sometime soon or should I generate incremental
> patches based on crypto-2.6 instead of cryptodev-2.6

Just generate them on top of all your existing patches.  If
necessary I will merge the crypto tree into cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
