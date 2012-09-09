From: Mathias Krause <minipli@googlemail.com>
Subject: Re: Linux 3.6-rc5
Date: Sun, 9 Sep 2012 22:09:10 +0200
Message-ID: <20120909200910.GA11919@r00tworld.net>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com> <87har7h84h.fsf@silenus.orebokech.com> <20120909191958.GB9782@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Romain Francoise <romain@orebokech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:46549 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2IIURT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 9 Sep 2012 16:17:19 -0400
Content-Disposition: inline
In-Reply-To: <20120909191958.GB9782@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 09, 2012 at 12:19:58PM -0700, Herbert Xu wrote:
> On Sun, Sep 09, 2012 at 11:13:02AM +0200, Romain Francoise wrote:
> > Still seeing this BUG with -rc5, that I originally reported here:
> > http://marc.info/?l=linux-crypto-vger&m=134653220530264&w=2
> > 
> > [   26.362567] ------------[ cut here ]------------
> > [   26.362583] kernel BUG at crypto/scatterwalk.c:37!
> > [   26.362606] invalid opcode: 0000 [#1] SMP 
> 
> Can you try blacklisting/not loading sha1_ssse3 and aesni_intel
> to see which one of them is causing this crash? Of course if you
> can still reproduce this without loading either of them that would
> also be interesting to know.

It happens with the C variants of SHA1 and AES, too. You can easily
trigger the bug with Steffen's crconf[1]:

$ crconf add alg "authenc(hmac(sha1-generic),cbc(aes-generic))" type 3

So the problem is likely not related to sha1-ssse3.ko or aesni-intel.ko.


Regards,
Mathias

[1] http://sourceforge.net/projects/crconf/
