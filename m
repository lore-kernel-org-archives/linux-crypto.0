From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC] consider keysize in algorithm selection
Date: Wed, 10 Oct 2007 18:44:00 +0200
Message-ID: <20071010164400.GA19471@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45504 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbXJJQoB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Oct 2007 12:44:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

this is my first attempt. 
patch 1 - the main patch (touching core api)
patch 2 - fixing remaining crypto infrastructure
patch 3 - fixing some users

Almost all users are easy to fix. The wlan stack allocates the cipher at
one time and sets the key at another time. So I don't know the requested
keysize at allocation time.
In the fixup, crypto_authenc_alloc() got a little ugly. The keysize is
only consider for the blkcipher but the hash might also be limited. Tell
me what you thing about this one. Maybe something like cbc(aes|192) is a
better solution.

Sebastian
