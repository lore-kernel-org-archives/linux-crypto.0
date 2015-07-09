From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 9/14] crypto: tcrypt - Add support for new IV convention
Date: Thu, 9 Jul 2015 16:00:38 +0800
Message-ID: <20150709080038.GA1246@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <E1ZCyak-0007Zf-No@gondolin.me.apana.org.au>
 <2007103.oHXJK7Kc2I@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54578 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbGIIAl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 04:00:41 -0400
Content-Disposition: inline
In-Reply-To: <2007103.oHXJK7Kc2I@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2015 at 09:59:01AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 9. Juli 2015, 07:17:26 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> >This patch allows the AEAD speed tests to cope with the new seqiv
> >calling convention as well as the old one.
> >
> >Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Using your crypto-2.6 tree, this patch fails to apply (and others have hunks 
> e.g. patch 8).

You need to pull the crypto tree into the cryptodev tree, and then
apply these patches.

Sorry if I wasn't clear.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
