From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Sat, 11 Jul 2015 10:37:56 +0800
Message-ID: <20150711023756.GA24197@gondor.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
 <2012703.RafZhkfDBX@tauon.atsec.com>
 <20150710133802.GB17850@gondor.apana.org.au>
 <1818049.ejfyYJhW4k@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbGKIVM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Jul 2015 04:21:12 -0400
Content-Disposition: inline
In-Reply-To: <1818049.ejfyYJhW4k@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 10, 2015 at 08:46:00PM +0200, Stephan Mueller wrote:
> Am Freitag, 10. Juli 2015, 21:38:02 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> >On Thu, Jul 09, 2015 at 12:19:53PM +0200, Stephan Mueller wrote:
> >> All GCM implementations available on recent Intel systems successfully
> >> tested (i.e NX and CAAM not tested).
> >> 
> >> Just to clarify: from a caller's perspective, using
> >> seqniv(rfc4106(gcm(aes))) is still the right invocation? Or shall I now
> >> use seqiv?
> >
> >You should use seqiv from now on.  But I should update the patches
> >so that seqniv is not visible to user-space.
> 
> In this case, wouldn't xfrm_algo.c need to be changed too?

I will change it once the conversion is complete.  For now seqniv
is identical to seqiv for kernel users so it'll continue to work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
