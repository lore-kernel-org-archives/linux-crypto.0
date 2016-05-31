From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Intel SHA - add MODULE_ALIAS
Date: Tue, 31 May 2016 18:13:16 +0800
Message-ID: <20160531101316.GA15376@gondor.apana.org.au>
References: <2277976.2OBcIJC5tF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55850 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbcEaKNY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 06:13:24 -0400
Content-Disposition: inline
In-Reply-To: <2277976.2OBcIJC5tF@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 13, 2016 at 02:02:00PM +0200, Stephan Mueller wrote:
> Add the MODULE_ALIAS for the cra_driver_name of the different ciphers to
> allow an automated loading if a driver name is used.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
