From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Fri, 10 Jul 2015 21:38:02 +0800
Message-ID: <20150710133802.GB17850@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <2012703.RafZhkfDBX@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50627 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbbGJNiF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 09:38:05 -0400
Content-Disposition: inline
In-Reply-To: <2012703.RafZhkfDBX@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 09, 2015 at 12:19:53PM +0200, Stephan Mueller wrote:
>
> All GCM implementations available on recent Intel systems successfully tested 
> (i.e NX and CAAM not tested).
> 
> Just to clarify: from a caller's perspective, using seqniv(rfc4106(gcm(aes))) 
> is still the right invocation? Or shall I now use seqiv?

You should use seqiv from now on.  But I should update the patches
so that seqniv is not visible to user-space.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
