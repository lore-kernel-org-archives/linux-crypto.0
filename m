From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/14] crypto: aead - Phase oute seqniv
Date: Thu, 09 Jul 2015 12:19:53 +0200
Message-ID: <2012703.RafZhkfDBX@tauon.atsec.com>
References: <20150708231330.GA28797@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47938 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbbGIKUC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jul 2015 06:20:02 -0400
In-Reply-To: <20150708231330.GA28797@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. Juli 2015, 07:13:30 schrieb Herbert Xu:

Hi Herbert,

>Hi:
>
>This series attempts to phase out the recently introduced seqniv
>generator.  The reason is that the logic of seqniv should not be
>implemented at the IV generator layer.  Having the IV skipping
>logic in seqniv means that you cannot perform encryption without
>doing IV generation.
>
>In fact moving the IV skipping logic out of seqniv and into the
>underlying rfcXXXX (e.g., rfc4106) template allows optimisations
>to be made as the underlying code can often skip the IV in a more
>efficient manner.
>
>Unfortunately we've already begun the conversion process so this
>series adds a new flag CRYPTO_ALG_AEAD_NEW to indicate whether
>a given algorithm has been converted to the new interface where
>IV skipping is done outside of the IV generator.  This flag can
>be removed once the conversion is complete.

All GCM implementations available on recent Intel systems successfully tested 
(i.e NX and CAAM not tested).

Just to clarify: from a caller's perspective, using seqniv(rfc4106(gcm(aes))) 
is still the right invocation? Or shall I now use seqiv?
>
>Cheers,


Ciao
Stephan
