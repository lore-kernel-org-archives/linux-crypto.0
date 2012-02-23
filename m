From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: mv_cesa hash functions
Date: Thu, 23 Feb 2012 15:17:15 +0100
Message-ID: <20120223141715.GA3506@breakpoint.cc>
References: <005b01ccf162$64bd0520$2e370f60$@org>
 <4F454BC6.7000409@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Frank <frank@debian-nas.org>, uri@jdland.co.il,
	linux-crypto@vger.kernel.org
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52176 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752642Ab2BWORW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Feb 2012 09:17:22 -0500
Content-Disposition: inline
In-Reply-To: <4F454BC6.7000409@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 22, 2012 at 09:10:46PM +0100, Nikos Mavrogiannopoulos wrote:
> On 02/22/2012 02:03 PM, Frank wrote:
> 
> > Hi,
> > 
> > After doing some trials with hardware crypto offloading through usermode interfaces (af_alg and cryptodev) to Marvell CESA accelerated ciphers and hash functions with the 3.2.4 kernel's mv_cesa in Debian Wheezy on a Marvell Kirkwood system, I've noticed the following kernel output when I load the mv_cesa kernel module:
> > 
> > [490889.448060] alg: hash: Test 1 failed for mv-sha1
> > [490889.452786] 00000000: c1 94 3f 2e a2 41 ce 88 d5 47 07 43 c4 a8 17 5d
> > [490889.459368] 00000010: 77 e8 47 ca
> > [490889.464321] alg: hash: Test 1 failed for mv-hmac-sha1
> > [490889.469493] 00000000: 06 71 4d 7c cc cc b5 cf 1b d6 c7 ab d0 25 c4 21
> > [490889.476068] 00000010: 66 0b 8e 70
> > Using SHA1 in a ssl/tls handshake fails in tests with mv_cesa loaded, which might be related to this.
> 
> 
> It might be related. I noticed the same issue in userspace with
> /dev/crypto. It can be solved by adding a 50 ms delay after the
> encryption, decryption and hashing operations. (a delay less than that
> didn't work).

It might a missing cache flush before/after the opration or before passing
the data to userland. I've seen that some hash operation fail which are not
perfromed in one go but via the start, update, end path. However I had no
time to get to the bottom of this.

> 
> regards,
> Nikos

Sebastian
