From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cleanup: Use max() in blkcipher_get_spot() to state the intention.
Date: Wed, 19 Sep 2007 19:16:01 +0800
Message-ID: <20070919111601.GB19488@gondor.apana.org.au>
References: <5562608.649291189210157514.JavaMail.root@tahiti.vyatta.com> <200709102146.47655.ioe-lkml@rameria.de> <20070911084058.GA4469@gondor.apana.org.au> <200709112153.25959.ioe-lkml@rameria.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Gilligan <gilligan@vyatta.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2980 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756928AbXISLQR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2007 07:16:17 -0400
Content-Disposition: inline
In-Reply-To: <200709112153.25959.ioe-lkml@rameria.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2007 at 09:53:24PM +0200, Ingo Oeser wrote:
> [PATCH] crypto: cleanup: Use max() in blkcipher_get_spot() to state the intention.
> 
> Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>

Patch applied.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
