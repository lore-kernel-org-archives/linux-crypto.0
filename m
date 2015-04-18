From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crypto: drbg - do not create shadow copy
Date: Sat, 18 Apr 2015 18:49:43 +0800
Message-ID: <20150418104943.GA5408@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <1700799.nu8dYZU873@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35941 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbbDRKtu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 06:49:50 -0400
Content-Disposition: inline
In-Reply-To: <1700799.nu8dYZU873@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 02:54:58PM +0200, Stephan Mueller wrote:
> The creation of a shadow copy is intended to only hold a short term
> lock. But the drawback is that parallel users have a very similar DRBG
> state which only differs by a high-resolution time stamp.
> 
> As the locking is changed to use a long-term lock to avoid such similar
> DRBG states, the entire creation and maintenance of a shadow copy can be
> removed.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

This patch needs to come after the lock/mutex conversion.  Otherwise
you will break bisections.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
