From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp - Initialize .statesize fields
Date: Fri, 27 Nov 2015 20:52:39 +0800
Message-ID: <20151127125239.GA29303@gondor.apana.org.au>
References: <1448552861-17410-1-git-send-email-fabio.estevam@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: marex@denx.de, smueller@chronox.de, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59228 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbK0Mw5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 07:52:57 -0500
Content-Disposition: inline
In-Reply-To: <1448552861-17410-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 26, 2015 at 01:47:41PM -0200, Fabio Estevam wrote:
> Initialize .statesize fields in order to avoid the following error
> on probe:
> 
> mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> mxs-dcp: probe of 80028000.dcp failed with error -22
> 
> Cc: <stable@vger.kernel.org> # 4.1+
> Suggested-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

It's not as simple as that.  You must implement import and export
for it before we can turn it back on.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
