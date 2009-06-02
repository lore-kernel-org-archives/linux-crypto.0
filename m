From: Jarod Wilson <jarod@redhat.com>
Subject: Re: sha384 self-test failure oddity
Date: Tue, 2 Jun 2009 09:01:42 -0400
Message-ID: <200906020901.42920.jarod@redhat.com>
References: <20090602051027.GA24415@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34574 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZFBNCe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2009 09:02:34 -0400
In-Reply-To: <20090602051027.GA24415@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday 02 June 2009 01:10:27 Herbert Xu wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> > While doing a bit of testing of some other crypto code, I've repeatedly
> > noticed a sha384 self-test failure. If you 'modprobe tcrypt', the
> > sha384 self-test fails, then immediately after it, sha384-generic
> > self-tests succeed. Something is awry w/sha384 initialization, as
> > can be more plainly seen by the following after a reboot:
> > 
> > # modprobe tcrypt mode=11 (run sha384 self-test)
> > 
> > dmesg
> > -----
> > alg: hash: Failed to load transform for sha384: -2
> 
> What kernel version

Straight up clone of cryptodev-2.6 -- i.e., not linus' tree + cryptodev
tacked on top. uname -r just says 2.6.29.

> and config?

Pretty much a dupe of the latest Fedora 11 kernel configs, run through
make oldconfig.

> I can't reproduce this with 2.6.30-rc7.

I'll rebase my cryptodev tree to 2.6.30-rcX and see if I can still
reproduce the problem.

> What does modinfo sha512_generic say?

# modinfo sha512_generic
filename:       /lib/modules/2.6.29/kernel/crypto/sha512_generic.ko
alias:          sha512
alias:          sha384
description:    SHA-512 and SHA-384 Secure Hash Algorithms
license:        GPL
srcversion:     8709387FD8370A6569E17F3
depends:        
vermagic:       2.6.29 SMP mod_unload

-- 
Jarod Wilson
jarod@redhat.com
