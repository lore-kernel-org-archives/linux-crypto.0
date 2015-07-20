From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: crypto: qat - Add support for RSA algorithm
Date: Mon, 20 Jul 2015 21:59:02 +0300
Message-ID: <20150720185902.GL5422@mwanda>
References: <20150720151236.GA5464@mwanda>
 <55AD1E2C.5090302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30831 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbGTS7K (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2015 14:59:10 -0400
Content-Disposition: inline
In-Reply-To: <55AD1E2C.5090302@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 20, 2015 at 09:13:32AM -0700, Tadeusz Struk wrote:
> On 07/20/2015 08:12 AM, Dan Carpenter wrote:
> > The patch a990532023b9: "crypto: qat - Add support for RSA algorithm"
> > from Jul 15, 2015, leads to the following Smatch warning:
> > 
> > 	drivers/crypto/qat/qat_common/qat_asym_algs.c:446 qat_rsa_get_n()
> > 	warn: was && intended here instead of ||?
> > 
> > drivers/crypto/qat/qat_common/qat_asym_algs.c
> >    444          ret = -EINVAL;
> >    445          /* In FIPS mode only allow key size 2K & 3K */
> >    446          if (fips_enabled && (ctx->key_sz != 256 || ctx->key_sz != 384)) {
> >                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Looks like the static checker is correct.
> 
> The logic is if fips_enabled we want to accept only key size 2K (256 bytes) or 3K (384 bytes)
> so the condition looks ok to me. Maybe the comment above is misleading?

Logically ->key_sz can't be both 256 and 384 at the same time.  What you
are describing is &&.  This seems like an important function, my guess
is we have never tested it with fips_enabled?

regards,
dan carpenter
