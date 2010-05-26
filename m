From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] mv_cesa: fixup error handling in mv_probe()
Date: Wed, 26 May 2010 10:45:35 +1000
Message-ID: <20100526004535.GF20073@gondor.apana.org.au>
References: <20100525094947.GF22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Uri Simchoni <uri@jdland.co.il>,
	Nicolas Pitre <nico@marvell.com>, Tejun Heo <tj@kernel.org>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:52063 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758456Ab0EZAp5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:45:57 -0400
Content-Disposition: inline
In-Reply-To: <20100525094947.GF22515@bicker>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 25, 2010 at 11:49:47AM +0200, Dan Carpenter wrote:
> The error handling in mv_probe() was a bit messed up.  There were some 
> gotos to the wrong labels so it ended up releasing stuff that that hadn't
> been aquired and not releasing stuff that was meant to be released.  I
> shuffled it around a bit to fix it and make it clearer.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Patch applied.  Thank you.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
