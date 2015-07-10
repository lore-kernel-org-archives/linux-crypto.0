From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Fri, 10 Jul 2015 20:46 +0200
Message-ID: <1818049.ejfyYJhW4k@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au> <2012703.RafZhkfDBX@tauon.atsec.com> <20150710133802.GB17850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47949 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbbGJSqE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jul 2015 14:46:04 -0400
In-Reply-To: <20150710133802.GB17850@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. Juli 2015, 21:38:02 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Jul 09, 2015 at 12:19:53PM +0200, Stephan Mueller wrote:
>> All GCM implementations available on recent Intel systems successfully
>> tested (i.e NX and CAAM not tested).
>> 
>> Just to clarify: from a caller's perspective, using
>> seqniv(rfc4106(gcm(aes))) is still the right invocation? Or shall I now
>> use seqiv?
>
>You should use seqiv from now on.  But I should update the patches
>so that seqniv is not visible to user-space.

In this case, wouldn't xfrm_algo.c need to be changed too?
>
>Cheers,


Ciao
Stephan
