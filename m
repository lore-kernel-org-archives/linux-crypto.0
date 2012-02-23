From: Phil Sutter <phil@nwl.cc>
Subject: Re: mv_cesa hash functions
Date: Thu, 23 Feb 2012 19:34:39 +0100
Message-ID: <20120223183439.GA18545@orbit.nwl.cc>
References: <005b01ccf162$64bd0520$2e370f60$@org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	uri@jdland.co.il, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Simon Baatz <simon2012@baatz.info>
To: Frank <frank@debian-nas.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orbit.nwl.cc ([91.121.141.167]:44504 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2BWSpF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Feb 2012 13:45:05 -0500
Content-Disposition: inline
In-Reply-To: <005b01ccf162$64bd0520$2e370f60$@org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

On Wed, Feb 22, 2012 at 02:03:38PM +0100, Frank wrote:
> After doing some trials with hardware crypto offloading through usermode interfaces (af_alg and cryptodev) to Marvell CESA accelerated ciphers and hash functions with the 3.2.4 kernel's mv_cesa in Debian Wheezy on a Marvell Kirkwood system, I've noticed the following kernel output when I load the mv_cesa kernel module:
> 
> [490889.448060] alg: hash: Test 1 failed for mv-sha1
> [490889.452786] 00000000: c1 94 3f 2e a2 41 ce 88 d5 47 07 43 c4 a8 17 5d
> [490889.459368] 00000010: 77 e8 47 ca
> [490889.464321] alg: hash: Test 1 failed for mv-hmac-sha1
> [490889.469493] 00000000: 06 71 4d 7c cc cc b5 cf 1b d6 c7 ab d0 25 c4 21
> [490889.476068] 00000010: 66 0b 8e 70

I've tracked down the problem to commit 6ef8450, "crypto: mv_cesa - make
count_sgs() null-pointer proof". So apparently it was me who broke it.

The simpification introduced by that commit assumes a zero 'nbytes'
field in the ahash_request struct passed to mv_hash_final, but
crypto/testmgr.c calls crypto_ahash_update() and crypto_ahash_final()
without altering the ahash_request in between.

Herbert, please clarify: is it intended behaviour that ahash_alg's final
callback ignores possibly present data in the request? If I wanted to
finalise a hash operation with some final data, would I then use the
finup callback instead? (Note the implied question of the actual
difference between the two callbacks.)

If my assumptions are correct, fixing this issue would be as easy as
adding a call to ahash_request_set_crypt() to mv_hash_final(). Or
manually zeroing req->nbytes, but that's probably unclean. Anyway, if
the 'final' callback is always to ignore request data, why doesn't the
API do this already? At least mv_cesa could use a single function for
both callbacks then.

> Using SHA1 in a ssl/tls handshake fails in tests with mv_cesa loaded, which might be related to this.

You are using cryptodev-linux for that, right? If so, this should be
unrelated since cryptodev-linux always calls crypto_ahash_final() with
an empty request payload (from cryptodev_cipher.c):

| ahash_request_set_crypt(hdata->async.request, NULL, output, 0);
| 
| ret = crypto_ahash_final(hdata->async.request);

But you might suffer from another problem, which is only present on ARM
machines with VIVT cache and linux >= 2.6.37: due to commit f8b63c1,
"ARM: 6382/1: Remove superfluous flush_kernel_dcache_page()" which
prevents pages being flushed from inside the scatterlist iterator API.
This patch seems to introduce problems in other places (namely NFS), too
but I sadly did not have time to investigate this further. I will post a
possible (cryptodev-internal) solution to cryptodev-linux-devel@gna.org,
maybe this fixes the problem with openssl.

Greetings, Phil
