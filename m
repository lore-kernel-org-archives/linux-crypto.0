From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev PATCH] qat: cleanup coccicheck warning - NULL check
 before freeing functions
Date: Fri, 24 Oct 2014 22:54:57 +0800
Message-ID: <20141024145457.GD21055@gondor.apana.org.au>
References: <20141015183321.23860.21499.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	davem@davemloft.net, qat-linux@intel.com
To: Bruce Allan <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:40691 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502AbaJXOzA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:55:00 -0400
Content-Disposition: inline
In-Reply-To: <20141015183321.23860.21499.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 15, 2014 at 11:33:21AM -0700, Bruce Allan wrote:
> Analyzing with coccinelle MODE=report...
> 
> Please check for false positives in the output before submitting a patch.
> When using "patch" mode, carefully review the patch before submitting it.
> 
> drivers/crypto/qat/qat_dh895xcc/adf_isr.c:191:3-8: WARNING: NULL check
> before freeing functions like kfree, debugfs_remove,
> debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
> reorganizing relevant code to avoid passing NULL values.
> 
> drivers/crypto/qat/qat_dh895xcc/adf_isr.c:208:3-8: WARNING: NULL check
> before freeing functions like kfree, debugfs_remove,
> debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider
> reorganizing relevant code to avoid passing NULL values.
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
