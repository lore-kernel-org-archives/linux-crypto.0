From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: replace scatterwalk_sg_next with sg_next
Date: Mon, 26 Jan 2015 13:55:35 +1100
Message-ID: <20150126025534.GB19796@gondor.apana.org.au>
References: <20131128142130.GC32124@gondor.apana.org.au>
 <1421741176-2663-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:47899 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbAZCzn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Jan 2015 21:55:43 -0500
Content-Disposition: inline
In-Reply-To: <1421741176-2663-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 20, 2015 at 10:06:16AM +0200, Cristian Stoica wrote:
> Modify crypto drivers to use the generic SG helper since
> both of them are equivalent and the one from crypto is redundant.
> 
> See also:
>   468577abe37ff7b453a9ac613e0ea155349203ae   reverted in
>   b2ab4a57b018aafbba35bff088218f5cc3d2142e
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
