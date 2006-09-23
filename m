From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: [PATCH] adding speed_test_template for lrw(aes)
Date: Sat, 23 Sep 2006 19:20:34 +0200
Message-ID: <11590320342437-git-send-email-rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:30736 "EHLO
	smtp-vbr15.xs4all.nl") by vger.kernel.org with ESMTP
	id S1750766AbWIWRVM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 Sep 2006 13:21:12 -0400
To: herbert@gondor.apana.org.au
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

lrw(aes) needs a different speed_test_template from standard aes because of
the different keysize, lrw(aes) has 256, 320 and 384 bits and other aes
modes have 128, 192, 256 bits.

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 crypto/tcrypt.c |    4 ++--
 crypto/tcrypt.h |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index ccad842..777fc63 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1200,9 +1200,9 @@ static void do_test(void)
 		test_cipher_speed("cbc(aes)", DECRYPT, sec, NULL, 0,
 				  aes_speed_template);
 		test_cipher_speed("lrw(aes)", ENCRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				  aes_lrw_speed_template);
 		test_cipher_speed("lrw(aes)", DECRYPT, sec, NULL, 0,
-				  aes_speed_template);
+				  aes_lrw_speed_template);
 		break;
 
 	case 201:
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index ab98b28..59fbc39 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -3589,6 +3589,27 @@ static struct cipher_speed aes_speed_tem
 	{  .klen = 0, .blen = 0, }
 };
 
+static struct cipher_speed aes_lrw_speed_template[] = {
+	{ .klen = 32, .blen = 16, },
+	{ .klen = 32, .blen = 64, },
+	{ .klen = 32, .blen = 256, },
+	{ .klen = 32, .blen = 1024, },
+	{ .klen = 32, .blen = 8192, },
+	{ .klen = 40, .blen = 16, },
+	{ .klen = 40, .blen = 64, },
+	{ .klen = 40, .blen = 256, },
+	{ .klen = 40, .blen = 1024, },
+	{ .klen = 40, .blen = 8192, },
+	{ .klen = 48, .blen = 16, },
+	{ .klen = 48, .blen = 64, },
+	{ .klen = 48, .blen = 256, },
+	{ .klen = 48, .blen = 1024, },
+	{ .klen = 48, .blen = 8192, },
+
+	/* End marker */
+	{  .klen = 0, .blen = 0, }
+};
+
 static struct cipher_speed des3_ede_speed_template[] = {
 	{ .klen = 24, .blen = 16, },
 	{ .klen = 24, .blen = 64, },
-- 
1.4.2.1

