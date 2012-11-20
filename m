From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: testmgr - remove superfluous initializers for xts(aes)
Date: Wed, 21 Nov 2012 00:29:31 +0100
Message-ID: <1353454171-24217-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Jarod Wilson <jarod@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55710 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2KTX3z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Nov 2012 18:29:55 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so2680824bkw.19
        for <linux-crypto@vger.kernel.org>; Tue, 20 Nov 2012 15:29:54 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The test vectors for 'xts(aes)' contain superfluous initializers.
Remove them.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Jarod Wilson <jarod@redhat.com>
---
 crypto/testmgr.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 17db4a9..b5667a4 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15011,8 +15011,6 @@ static struct cipher_testvec aes_xts_enc_tv_template[] = {
 		.klen	= 64,
 		.iv	= "\xff\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.input	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -15355,8 +15353,6 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 		.klen	= 64,
 		.iv	= "\xff\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
-			  "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.input	= "\x1c\x3b\x3a\x10\x2f\x77\x03\x86"
 			  "\xe4\x83\x6c\x99\xe3\x70\xcf\x9b"
 			  "\xea\x00\x80\x3f\x5e\x48\x23\x57"
-- 
1.7.10.4
