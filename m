From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: sahara - remove unneeded mutex in the
 exported state
Date: Sat, 6 Feb 2016 15:48:02 +0800
Message-ID: <20160206074802.GH22220@gondor.apana.org.au>
References: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: s.trumtrar@pengutronix.de, marex@denx.de, linux@arm.linux.org.uk,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47271 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbcBFHsX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 02:48:23 -0500
Content-Disposition: inline
In-Reply-To: <1454503612-21344-1-git-send-email-fabio.estevam@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 03, 2016 at 10:46:50AM -0200, Fabio Estevam wrote:
> As pointed out by Herbert Xu we should not include the mutex in the
> exported state, so let's just get rid of it.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
