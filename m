From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Wed, 5 Aug 2009 19:45:06 +1000
Message-ID: <20090805094506.GA12528@gondor.apana.org.au>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46568 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932956AbZHEJpI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2009 05:45:08 -0400
Content-Disposition: inline
In-Reply-To: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 03, 2009 at 03:44:43PM +0800, Huang Ying wrote:
> When doing "modeprobe tcrypt mode=10", the following error will show
> in dmesg.
> 
> alg: skcipher: Failed to load transform for ctr(aes): -22
> alg: skcipher: Failed to load transform for ctr(aes): -22
> tcrypt: one or more tests failed!

I can't reproduce it here:

etch1:~# modprobe tcrypt mode=10
FATAL: Error inserting tcrypt (/lib/modules/2.6.30/kernel/crypto/tcrypt.ko): Resource temporarily unavailable
etch1:~# dmesg|tail
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
padlock: VIA PadLock Hash Engine not detected.
padlock: VIA PadLock Hash Engine not detected.
eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth0: no IPv6 routers present
etch1:~# 

The tcrypt test shouldn't use geniv at all.

What kernel version was this?

> Because ctr(aes) testing code will allocate ctr(aes) with geniv, but
> defualt geniv mode may not work with ctr(aes). As that of rfc3686,
> this is fixed via specifying geniv mode to "seqiv".
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

I think this patch makes sense as the default IV generator is not
designed to guarantee uniqueness (although repetitions would be
very rare).

But I'd like to get to the bottom of the failure that you were
seeing so that we don't commit this with a potentially misleading
message.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
