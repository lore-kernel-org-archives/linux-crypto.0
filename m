From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: testmgr - add a chunking test for cbc(aes)
Date: Mon,  6 Jul 2015 13:37:33 +0200
Message-ID: <1436182653-32683-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38581 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbGFLhr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 07:37:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All tests for cbc(aes) use only blocks of data with a multiple of 4.
This test adds a test with some odd SG size.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/testmgr.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 868edf1..b052555 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -14504,6 +14504,9 @@ static struct cipher_testvec aes_cbc_enc_tv_template[] = {
 		.result = "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
 			  "\x27\x08\x94\x2d\xbe\x77\x18\x1a",
 		.rlen   = 16,
+		.also_non_np = 1,
+		.np	= 8,
+		.tap	= { 3, 2, 3, 2, 3, 1, 1, 1 },
 	}, {
 		.key    = "\xc2\x86\x69\x6d\x88\x7c\x9a\xa0"
 			  "\x61\x1b\xbb\x3e\x20\x25\xa4\x5a",
@@ -14723,6 +14726,9 @@ static struct cipher_testvec aes_cbc_dec_tv_template[] = {
 		.ilen   = 16,
 		.result = "Single block msg",
 		.rlen   = 16,
+		.also_non_np = 1,
+		.np	= 8,
+		.tap	= { 3, 2, 3, 2, 3, 1, 1, 1 },
 	}, {
 		.key    = "\xc2\x86\x69\x6d\x88\x7c\x9a\xa0"
 			  "\x61\x1b\xbb\x3e\x20\x25\xa4\x5a",
-- 
2.3.6
