From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 09:13:55 +0200
Message-ID: <14602522.JAGjWGXiOv@myon.chronox.de>
References: <5314960.0aGFzHXOSP@myon.chronox.de> <2963701.QnyuGqI2Hv@myon.chronox.de> <20151015071150.GA1223@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34352 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbbJOHN6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 03:13:58 -0400
In-Reply-To: <20151015071150.GA1223@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Oktober 2015, 15:11:50 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Oct 15, 2015 at 09:07:40AM +0200, Stephan Mueller wrote:
> > The testmanager code for symmetric ciphers is extended to allow
> > verification of the IV after a cipher operation.
> > 
> > In addition, test vectors for kw(aes) for encryption and decryption are
> > added.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Oh I see.  This patch can be applied without affect any existing
> drivers.  In that case I'll just apply Boris's original patch #1
> and then reapply your previous submission.
> 
> Sorry for the confusion.

Note, I had to convert akcipher to skcipher -- thus, I guess you want to take 
the newer patch and once you get back to Boris' original submission, just pull 
the updates to the test vectors.
> 
> Thanks,


-- 
Ciao
Stephan
