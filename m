From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [patch 3/3] change the XTEA test vectors.
Date: Sun, 03 Feb 2008 13:55:27 +0100
Message-ID: <20080203130750.598243061@breakoint.cc>
References: <20080203125524.339000971@breakoint.cc>
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34772 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765057AbYBCNRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Feb 2008 08:17:30 -0500
Content-Disposition: inline; filename=0003-crypto-change-the-XTEA-test-vectors.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The third test vector of ECB-XTEA-ENC fails for me all other
are fine. I could not find a RFC or something else where they
are defined. The test vector has not been modified since git
started recording histrory. The implementation is very close
(not to say equal) to what is available as Public Domain (they
recommend 64 rounds and the in kernel uses 32). Therefore I
belive that there is typo somewhere and tcrypt reported always
*fail* instead of *okey*.
This patch replaces input + result of the third test vector with
result + input from the third decryption vector. The key is the
same, the other three test vectors are also the reverse.

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 crypto/tcrypt.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 1ac6ecd..aae79e9 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -5631,11 +5631,11 @@ static struct cipher_testvec xtea_enc_tv_template[] = {
 		.key	= "\x09\x65\x43\x11\x66\x44\x39\x25"
 			  "\x51\x3a\x16\x10\x0a\x08\x12\x6e",
 		.klen	= 16,
-		.input	= "\x3e\xce\xae\x22\x60\x56\xa8\x9d"
+		.input	= "\x6c\x6f\x6e\x67\x65\x72\x5f\x74"
 			  "\x65\x73\x74\x5f\x76\x65\x63\x74",
 		.ilen	= 16,
-		.result	= "\xe2\x04\xdb\xf2\x89\x85\x9e\xea"
-			  "\x61\x35\xaa\xed\xb5\xcb\x71\x2c",
+		.result	= "\x3e\xce\xae\x22\x60\x56\xa8\x9d"
+			  "\x77\x4d\xd4\xb4\x87\x24\xe3\x9a",
 		.rlen	= 16,
 	}, {
 		.key	= "\x4d\x76\x32\x17\x05\x3f\x75\x2c"
-- 
1.5.3.7

-- 
