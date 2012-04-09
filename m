From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - properly lock access to global
	talitos registers
Date: Mon, 9 Apr 2012 15:14:36 +0800
Message-ID: <20120409071423.GA30875@gondor.apana.org.au>
References: <1333118993-17522-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:50793 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752919Ab2DIHPA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Apr 2012 03:15:00 -0400
Content-Disposition: inline
In-Reply-To: <1333118993-17522-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 30, 2012 at 05:49:53PM +0300, Horia Geanta wrote:
> Access to global talitos registers must be protected for the case when
> affinities are configured such that primary and secondary talitos irqs
> run on different cpus.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
