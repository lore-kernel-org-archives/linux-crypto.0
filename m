From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [PATCH] [crypto] LRW: use proper alignment.
Date: Mon, 3 Mar 2008 00:23:19 +0800
Message-ID: <20080302162319.GA23822@gondor.apana.org.au>
References: <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <1b5471b654eea02f82ccf0aad032fbbb951cbbc5.1204465942.git.sebastian@breakpoint.cc> <47CAB33E.2050207@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <sebastian@breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53508 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754004AbYCBQX1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 2 Mar 2008 11:23:27 -0500
Content-Disposition: inline
In-Reply-To: <47CAB33E.2050207@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 02, 2008 at 03:01:34PM +0100, Stefan Hellermann wrote:
> Sebastian Siewior schrieb:
> > The LRW blockmode uses a copy of the IV which is saved on the stack
> > and may or may not be properly aligned. If it is not, it will break
> > hardware cipher like the geode or padlock.
> > This patch moves the copy of IV to the private structre which has the
> > same aligment as the underlying cipher.
> > Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> Tested-by: Stefan Hellermann <stefan@the2masters.de>

Thanks Sebastian and Stefan!  I'll apply this for 2.6.25 and push
it to stable as well.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
