From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: [6 PATCHes] IXP4xx crypto driver fixes.
Date: Sun, 10 Jan 2010 16:34:04 +0100
Message-ID: <m34omu3rf7.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:43044 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0AJPeJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Jan 2010 10:34:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Christian, Herbert,

I'm attaching 6 patches for IXP4xx crypto accelerator:

      IXP4xx: Fix ixp4xx_crypto little-endian operation.
      IXP4xx: Fix ixp4xx_crypto sparse warnings.
      IXP4xx: Simplify get_crypt_desc() and get_crypt_desc_emerg() in ixp4xx_crypto.
      IXP4xx: Fix whitespace problems in ixp4xx_crypto.
      ixp4xx_crypto: Fix possible NULL ptr dereference.
      ixp4xx_crypto: simplyfy the code a bit.

 drivers/crypto/ixp4xx_crypto.c |  219 +++++++++++++++++++---------------------
 1 files changed, 102 insertions(+), 117 deletions(-)


The first one fixes this on little-endian IXP425:

NPE-C: firmware functionality 0x5, revision 0x2:1
alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
00000000: 01 23 45 67 89 ab cd e7
alg: skcipher: Test 1 failed on encryption for ecb(des3_ede)-ixp4xx
00000000: 73 6f 6d 65 64 61 74 61
alg: skcipher: Test 1 failed on encryption for ecb(aes)-ixp4xx
00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff

There are missing tests there, not sure if they should be implemented
but it's a different story:

alg: No test for ...
authenc(hmac(md5),cbc(des))-ixp4xx
authenc(hmac(md5),cbc(des3_ede))-ixp4xx
authenc(hmac(sha1),cbc(des))-ixp4xx
authenc(hmac(sha1),cbc(des3_ede))-ixp4xx
authenc(hmac(md5),cbc(aes))-ixp4xx
authenc(hmac(sha1),cbc(aes))-ixp4xx

Not tested in any practical application yet, just got rid of the
warnings.

Since the changes are more related to IXP425 than they are to the crypto
code, I can send the patches to Linus myself, or you can do that, your
call.
Please state your ACK.
-- 
Krzysztof Halasa
