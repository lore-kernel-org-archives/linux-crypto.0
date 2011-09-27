From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] whirlpool: count rounds from 0
Date: Tue, 27 Sep 2011 08:26:24 +0300
Message-ID: <20110927052624.GA15691@p183.telecom.by>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab1I0F0a (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Sep 2011 01:26:30 -0400
Received: by fxe4 with SMTP id 4so6754172fxe.19
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2011 22:26:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

rc[0] is unused because rounds are counted from 1.
Save an u64!

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 crypto/wp512.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -762,11 +762,17 @@ static const u64 C7[256] = {
 	0x86228644a411c286ULL,
 };
 
-static const u64 rc[WHIRLPOOL_ROUNDS + 1] = {
-	0x0000000000000000ULL, 0x1823c6e887b8014fULL, 0x36a6d2f5796f9152ULL,
-	0x60bc9b8ea30c7b35ULL, 0x1de0d7c22e4bfe57ULL, 0x157737e59ff04adaULL,
-	0x58c9290ab1a06b85ULL, 0xbd5d10f4cb3e0567ULL, 0xe427418ba77d95d8ULL,
-	0xfbee7c66dd17479eULL, 0xca2dbf07ad5a8333ULL,
+static const u64 rc[WHIRLPOOL_ROUNDS] = {
+	0x1823c6e887b8014fULL,
+	0x36a6d2f5796f9152ULL,
+	0x60bc9b8ea30c7b35ULL,
+	0x1de0d7c22e4bfe57ULL,
+	0x157737e59ff04adaULL,
+	0x58c9290ab1a06b85ULL,
+	0xbd5d10f4cb3e0567ULL,
+	0xe427418ba77d95d8ULL,
+	0xfbee7c66dd17479eULL,
+	0xca2dbf07ad5a8333ULL,
 };
 
 /**
@@ -793,7 +799,7 @@ static void wp512_process_buffer(struct wp512_ctx *wctx) {
 	state[6] = block[6] ^ (K[6] = wctx->hash[6]);
 	state[7] = block[7] ^ (K[7] = wctx->hash[7]);
 
-	for (r = 1; r <= WHIRLPOOL_ROUNDS; r++) {
+	for (r = 0; r < WHIRLPOOL_ROUNDS; r++) {
 
 		L[0] = C0[(int)(K[0] >> 56)       ] ^
 			   C1[(int)(K[7] >> 48) & 0xff] ^
