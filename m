From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH cryptodev 1/4] crypto: caam - remove error propagation
 handling
Date: Fri, 21 Mar 2014 22:40:20 +0800
Message-ID: <20140321144020.GB25820@gondor.apana.org.au>
References: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60842 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760413AbaCUOkW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Mar 2014 10:40:22 -0400
Content-Disposition: inline
In-Reply-To: <1394812012-13714-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 14, 2014 at 05:46:49PM +0200, Horia Geanta wrote:
> Commit 61bb86bba169507a5f223b94b9176c32c84b4721
> ("crypto: caam - set descriptor sharing type to SERIAL")
> changed the descriptor sharing mode from SHARE_WAIT to SHARE_SERIAL.
> 
> All descriptor commands that handle the "ok to share" and
> "error propagation" settings should also go away, since they have no
> meaning for SHARE_SERIAL.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
