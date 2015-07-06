From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 08/10] crypto: omap-aes: gmc: Add algo info
Date: Mon, 6 Jul 2015 15:35:39 +0800
Message-ID: <20150706073539.GA20192@gondor.apana.org.au>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-9-git-send-email-lokeshvutla@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
	t-kristo@ti.com, nsekhar@ti.com
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35737 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbGFHfp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 03:35:45 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-9-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2015 at 10:48:38AM +0530, Lokesh Vutla wrote:
> Now the driver supports gcm mode, add omap-aes-gcm
> algo info to omap-aes driver.
> 
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>

You're using the old AEAD interface.  We are now moving to the
new AEAD interface so I will not be accepting any new implementations
using the old interface.

Please convert your driver over to the new interface.

Also please merge your GCM patches into a single patch.  Splitting
out bug fixes makes no sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
