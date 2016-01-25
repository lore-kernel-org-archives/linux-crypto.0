From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/3] crypto: mxs-dcp - provide statesize and
 import/export()
Date: Mon, 25 Jan 2016 22:10:21 +0800
Message-ID: <20160125141021.GB8414@gondor.apana.org.au>
References: <1452707524-7695-1-git-send-email-festevam@gmail.com>
 <1452707524-7695-3-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: marex@denx.de, s.trumtrar@pengutronix.de, thomas.lendacky@amd.com,
	linux@arm.linux.org.uk, linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57002 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbcAYOKd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:10:33 -0500
Content-Disposition: inline
In-Reply-To: <1452707524-7695-3-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 03:52:04PM -0200, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> Currently the mxs-dcp driver fails to probe:
> 
> mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> mxs-dcp: probe of 80028000.dcp failed with error -22
> 
> This happens since commit 8996eafdcbad ("crypto: ahash - ensure statesize
> is non-zero"), which requires statesize to be filled.
> 
> Other than filling statesize, we also need to provide the import/export
> functions.
> 
> Based on the implementation of the sahara and caam drivers.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

This driver is hopelessly broken as its request context doesn't
contain the hash state at all.  Unless someone can fix that we
should probably just remove the hash implementations altogether.

Cheers,,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
