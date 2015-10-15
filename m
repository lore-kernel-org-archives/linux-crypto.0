From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 12:10:41 +0200
Message-ID: <3096789.LEo1AbLp1U@myon.chronox.de>
References: <5314960.0aGFzHXOSP@myon.chronox.de> <14602522.JAGjWGXiOv@myon.chronox.de> <20151015071712.GA1300@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34354 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbJOKKo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 06:10:44 -0400
In-Reply-To: <20151015071712.GA1300@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Oktober 2015, 15:17:12 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Oct 15, 2015 at 09:13:55AM +0200, Stephan Mueller wrote:
> > Note, I had to convert akcipher to skcipher -- thus, I guess you want to
> > take the newer patch and once you get back to Boris' original submission,
> > just pull the updates to the test vectors.
> 
> What I'll do is apply Boris's patch #1, and then followed by your
> v3.  That should work, right?

That would work, if you replace the ablkcipher calls in Boris' patch with 
skcipher to make that patch work.

My patch v3 3/3 works unchanged on top of Boris' patch as tested before 
releasing v4 -- the patch 3/3 may have a hunk due to the changes in the number 
of lines.

-- 
Ciao
Stephan
