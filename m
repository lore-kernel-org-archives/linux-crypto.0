Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F203C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2577B20730
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574061762;
	bh=rFbhxfoyXzQ0sYAB93UxZybE+gpRzxxiVVNVYzVkamg=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ubE+65aC2tDK76NCzrpt4Rp8G8yjV2uID3P9woR13rvCUgns9x0eBhGkUiOnq9K4A
	 JP2kPWVMxTc/S1bpi/Yk61L0fTMOybhBOAhQp4Q3F6tYDOnkZGQTxlUcLG3yYJTrqY
	 EzbcN/iAv3++EG+CrOoscJbRAcFUAHkYYNbJQgtg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfKRHWl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfKRHWl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 02:22:41 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C9520722;
        Mon, 18 Nov 2019 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574061760;
        bh=rFbhxfoyXzQ0sYAB93UxZybE+gpRzxxiVVNVYzVkamg=;
        h=From:To:Cc:Subject:Date:From;
        b=Uj5ihUcQOzoKQyZmj3pzoQhgypFyVPUAtxCUwtkM2arjv1HEwupP8TEv+v9cZYvwE
         7BcxFRM5uOaLmktA9Cj4SBVcwlkNSNGAM1ohgVWJpvcLV7KYxo8w6tpzzBeZnfSUQf
         SgA/dTo7MdDifKy23TZYarEWuVsLMaE0b5ltjUjE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: lib/chacha20poly1305 - use chacha20_crypt()
Date:   Sun, 17 Nov 2019 23:22:16 -0800
Message-Id: <20191118072216.467693-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use chacha20_crypt() instead of chacha_crypt(), since it's not really
appropriate for users of the ChaCha library API to be passing the number
of rounds as an argument.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crypto/chacha20poly1305.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 821e5cc9b14e..6d83cafebc69 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -66,14 +66,14 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
 		__le64 lens[2];
 	} b;
 
-	chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
+	chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
 	poly1305_init(&poly1305_state, b.block0);
 
 	poly1305_update(&poly1305_state, ad, ad_len);
 	if (ad_len & 0xf)
 		poly1305_update(&poly1305_state, pad0, 0x10 - (ad_len & 0xf));
 
-	chacha_crypt(chacha_state, dst, src, src_len, 20);
+	chacha20_crypt(chacha_state, dst, src, src_len);
 
 	poly1305_update(&poly1305_state, dst, src_len);
 	if (src_len & 0xf)
@@ -140,7 +140,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 	if (unlikely(src_len < POLY1305_DIGEST_SIZE))
 		return false;
 
-	chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
+	chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
 	poly1305_init(&poly1305_state, b.block0);
 
 	poly1305_update(&poly1305_state, ad, ad_len);
@@ -160,7 +160,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
 
 	ret = crypto_memneq(b.mac, src + dst_len, POLY1305_DIGEST_SIZE);
 	if (likely(!ret))
-		chacha_crypt(chacha_state, dst, src, dst_len, 20);
+		chacha20_crypt(chacha_state, dst, src, dst_len);
 
 	memzero_explicit(&b, sizeof(b));
 
@@ -241,7 +241,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 	b.iv[1] = cpu_to_le64(nonce);
 
 	chacha_init(chacha_state, b.k, (u8 *)b.iv);
-	chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
+	chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
 	poly1305_init(&poly1305_state, b.block0);
 
 	if (unlikely(ad_len)) {
@@ -278,14 +278,14 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 
 			if (unlikely(length < sl))
 				l &= ~(CHACHA_BLOCK_SIZE - 1);
-			chacha_crypt(chacha_state, addr, addr, l, 20);
+			chacha20_crypt(chacha_state, addr, addr, l);
 			addr += l;
 			length -= l;
 		}
 
 		if (unlikely(length > 0)) {
-			chacha_crypt(chacha_state, b.chacha_stream, pad0,
-				     CHACHA_BLOCK_SIZE, 20);
+			chacha20_crypt(chacha_state, b.chacha_stream, pad0,
+				       CHACHA_BLOCK_SIZE);
 			crypto_xor(addr, b.chacha_stream, length);
 			partial = length;
 		}
-- 
2.24.0

