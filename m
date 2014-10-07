From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: sahara - add support for SHA1/256
Date: Tue, 7 Oct 2014 10:02:01 +0800
Message-ID: <20141007020201.GA27094@gondor.apana.org.au>
References: <1412606625-828-1-git-send-email-s.trumtrar@pengutronix.de>
 <1412606625-828-3-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel@pengutronix.de
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:55860 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGCCG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Oct 2014 22:02:06 -0400
Content-Disposition: inline
In-Reply-To: <1412606625-828-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 06, 2014 at 04:43:45PM +0200, Steffen Trumtrar wrote:
> Add support for the MDHA unit in the SAHARA core.
> The MDHA can generate hash digests for MD5 and SHA1 in version 3 and
> additionally SHA224 and SHA256 in version 4.
> 
> Add the SHA1 and SHA256 algorithms to the driver.
> 
> The implementation was tested with the in-kernel testmgr on i.MX27 and
> i.MX53.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
> Changes since v1:
> 	- save context in the sahara_ctx struct

This is still wrong since the context needs to be stored in the
request.  Otherwise multiple requests will corrupt each other's
state.

Also please implement export/import.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
