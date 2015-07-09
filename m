From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/14] crypto: nx - Use new IV convention
Date: Thu, 9 Jul 2015 14:56:15 +0800
Message-ID: <20150709065615.GB32698@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <E1ZCyap-0007ag-GT@gondolin.me.apana.org.au>
 <2029636.zIROss5U0I@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46944 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbGIG4T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 02:56:19 -0400
Content-Disposition: inline
In-Reply-To: <2029636.zIROss5U0I@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2015 at 08:19:45AM +0200, Stephan Mueller wrote:
> Am Donnerstag, 9. Juli 2015, 07:17:31 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> >This patch converts rfc4106 to the new calling convention where
> >the IV is now part of the AD and needs to be skipped.  This patch
> >also makes use of type-safe AEAD functions where possible.
> >
> >Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> This patch fails to apply on your current kernel tree.

You need to pull in the crypto-2.6 tree to apply it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
