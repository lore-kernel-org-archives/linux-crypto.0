Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D63C10F04
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900D9222A1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131461;
	bh=S2P+0ksxTnCDEMQ9kwGUVk5XTFYNPT34u1W/CeFJ1E4=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GKyPjdIoZvOt6AnD5l3R49fyYeJ0Fq/eg0RpG4FuMZybaaUF1f3HH/MEUSTwoNlbS
	 FFExb8WSdtZXZ5+3ElLPp0ERAjSXIrC9YB8K3XIk9YRXIkIBiqb/DNx7h2O3oDVBSO
	 +vMYRneOnwyRLoQcXTuJQEKcwgedM3+zkR4+Aw4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391978AbfBNIEU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:60006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391867AbfBNIES (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:18 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96536222D6;
        Thu, 14 Feb 2019 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131457;
        bh=S2P+0ksxTnCDEMQ9kwGUVk5XTFYNPT34u1W/CeFJ1E4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VKoJtVclfqyIzT5lO6TrjqdfJDSH0z+fRUuWWgwIRqM7yT3qwiziRAk80sxKTmaQ/
         u2YnQdIo/8eOfWgZPaSaV3Az+NqexdqI4vBhBuj0jftUXHoJYrzGN77O6RVYd/ZELw
         zqkbjO27lrHelY8NR5aqS9rWDYawfDMYAJUKkdoE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/6] crypto: testmgr - add iv_out to all CTR test vectors
Date:   Thu, 14 Feb 2019 00:03:53 -0800
Message-Id: <20190214080355.8112-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214080355.8112-1-ebiggers@kernel.org>
References: <20190214080355.8112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test that all CTR implementations update the IV buffer to contain the
next counter block, aka the IV to continue the encryption/decryption of
a larger message.  When the length processed is a multiple of the block
size, users may rely on this for chaining.

When the length processed is *not* a multiple of the block size, simple
chaining doesn't work.  However, as noted in commit 88a3f582bea9
("crypto: arm64/aes - don't use IV buffer to return final keystream
block"), the generic CCM implementation assumes that the CTR IV is
handled in some sane way, not e.g. overwritten with part of the
keystream.  Since this was gotten wrong once already, it's desirable to
test for it.  And, the most straightforward way to do this is to enforce
that all CTR implementations have the same behavior as the generic
implementation, which returns the *next* counter following the final
partial block.  This behavior also has the advantage that if someone
does misuse this case for chaining, then the keystream won't be
repeated.  Thus, this patch makes the tests expect this behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 3e68d4062e51..31bacd0f6823 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -7115,6 +7115,7 @@ static const struct cipher_testvec des_ctr_tv_template[] = {
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x1C",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -7182,6 +7183,7 @@ static const struct cipher_testvec des_ctr_tv_template[] = {
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
 		.iv	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47",
+		.iv_out	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x66",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -7590,6 +7592,7 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\xEB\xB4\x51\x72\xB4\x51\x72\x1F",
 		.klen	= 24,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x3D",
 		.ptext	= "\x05\xEC\x77\xFB\x42\xD5\x59\x20"
 			  "\x8B\x12\x86\x69\xF0\x5B\xCF\x56"
 			  "\x39\xAD\x34\x9F\x66\xEA\x7D\xC4"
@@ -7721,6 +7724,7 @@ static const struct cipher_testvec des3_ede_ctr_tv_template[] = {
 			  "\xEB\xB4\x51\x72\xB4\x51\x72\x1F",
 		.klen	= 24,
 		.iv	= "\xB2\xD7\x48\xED\x06\x44\xF9\x12",
+		.iv_out	= "\xB2\xD7\x48\xED\x06\x44\xF9\x51",
 		.ptext	= "\x05\xEC\x77\xFB\x42\xD5\x59\x20"
 			  "\x8B\x12\x86\x69\xF0\x5B\xCF\x56"
 			  "\x39\xAD\x34\x9F\x66\xEA\x7D\xC4"
@@ -8198,6 +8202,7 @@ static const struct cipher_testvec bf_ctr_tv_template[] = {
 			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x9E",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -8332,6 +8337,7 @@ static const struct cipher_testvec bf_ctr_tv_template[] = {
 			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x9E",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -8466,6 +8472,7 @@ static const struct cipher_testvec bf_ctr_tv_template[] = {
 			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
 		.klen	= 32,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x3C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -8954,6 +8961,8 @@ static const struct cipher_testvec tf_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x83",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -9087,6 +9096,8 @@ static const struct cipher_testvec tf_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
 			  "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x1C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -9220,6 +9231,8 @@ static const struct cipher_testvec tf_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x84",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -10324,6 +10337,8 @@ static const struct cipher_testvec serpent_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x83",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -10457,6 +10472,8 @@ static const struct cipher_testvec serpent_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x84",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -10592,6 +10609,8 @@ static const struct cipher_testvec serpent_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
 			  "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x1C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -11438,6 +11457,8 @@ static const struct cipher_testvec sm4_ctr_tv_template[] = {
 			  "\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb",
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
+		.iv_out	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x13",
 		.ctext	= "\xac\x32\x36\xcb\x97\x0c\xc2\x07"
 			  "\x91\x36\x4c\x39\x5a\x13\x42\xd1"
 			  "\xa3\xcb\xc1\x87\x8c\x6f\x30\xcd"
@@ -11461,6 +11482,8 @@ static const struct cipher_testvec sm4_ctr_tv_template[] = {
 			  "\xbb\xbb\xbb\xbb\xbb\xbb\xbb\xbb",
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
+		.iv_out	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x13",
 		.ctext	= "\x5d\xcc\xcd\x25\xb9\x5a\xb0\x74"
 			  "\x17\xa0\x85\x12\xee\x16\x0e\x2f"
 			  "\x8f\x66\x15\x21\xcb\xba\xb4\x4c"
@@ -11786,6 +11809,8 @@ static const struct cipher_testvec cast6_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x66",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A",
@@ -11801,6 +11826,8 @@ static const struct cipher_testvec cast6_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x83",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -14924,6 +14951,8 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 		.klen	= 16,
 		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.iv_out	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xff\x03",
 		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -14948,6 +14977,8 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 		.klen	= 24,
 		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.iv_out	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xff\x03",
 		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -14973,6 +15004,8 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
+		.iv_out	= "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			  "\xf8\xf9\xfa\xfb\xfc\xfd\xff\x03",
 		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -14998,6 +15031,8 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
 			  "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x1C",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -15131,6 +15166,8 @@ static const struct cipher_testvec aes_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47"
 			  "\xE2\x7D\x18\xD6\x71\x0C\xA7\x42",
+		.iv_out	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47"
+			  "\xE2\x7D\x18\xD6\x71\x0C\xA7\x62",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -23046,6 +23083,7 @@ static const struct cipher_testvec cast5_ctr_tv_template[] = {
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
 		.klen	= 16,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x62",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A",
@@ -23058,6 +23096,7 @@ static const struct cipher_testvec cast5_ctr_tv_template[] = {
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
 		.klen	= 16,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x9D",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -24163,6 +24202,8 @@ static const struct cipher_testvec camellia_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x83",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -24296,6 +24337,8 @@ static const struct cipher_testvec camellia_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
+			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\xA4",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -24559,6 +24602,8 @@ static const struct cipher_testvec camellia_ctr_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF"
 			  "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFD",
+		.iv_out	= "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x3C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
-- 
2.20.1

