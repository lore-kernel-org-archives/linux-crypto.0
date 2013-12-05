From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: remove unnecessary includes
Date: Thu, 5 Dec 2013 16:22:20 +0800
Message-ID: <20131205082220.GB31822@gondor.apana.org.au>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
 <1628287275CAA9409F1E349DEF3C6CCE78CBF0@039-SN2MPN1-012.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Cristian Stoica <cristian.stoica@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:57583 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3LEIW1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 03:22:27 -0500
Content-Disposition: inline
In-Reply-To: <1628287275CAA9409F1E349DEF3C6CCE78CBF0@039-SN2MPN1-012.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 05, 2013 at 08:14:55AM +0000, Cristian Stoica wrote:
> Hi Herbert,
> 
> Your original response was terse and left me more puzzled. Do you have a sensible explanation why some includes should be kept in the source even they serve no purpose during the build?

If you can't work out why authenc.c needs slab.h I don't think
you should be submitting patches removing unnecessary header
files.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
