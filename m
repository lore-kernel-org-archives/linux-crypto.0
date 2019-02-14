Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8660CC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DBFF222A1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131461;
	bh=vrlr6/Drcb6ex2z5eKR1LzJ5YqPUel4JimzGI1eZEq8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Dr57g4LprXY2X+SnUW76d2zQfK/cIa4qIor4SGqyfTp6aqYQicRTlS1g3TY9xIP6+
	 uy3pWmFikCfQjIMMxm2KGild6W/6qXeYo9Ad6Gjzy/Uc8ZfO6IEphvgOMEo0jkJsnC
	 sKvw5ZE91KPzch721UDrOKz8G2ViEp4npbm0z0lo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394121AbfBNIEU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391978AbfBNIET (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:19 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C569222D5;
        Thu, 14 Feb 2019 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131457;
        bh=vrlr6/Drcb6ex2z5eKR1LzJ5YqPUel4JimzGI1eZEq8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=QUy+bhCCxho5Kbu5fUGneJ7K1xRGj7b/smY440jsnCrJO4N4qll3J9BJR+L8Girbp
         lr363GFCCRquC84+oCz6ObDLnn/Rz39BHnYqf3KXHfVMqv+a9ViH3tkfesRKS5fJPS
         4687kVM1mrhkyV+fdcT/tE9n7lnhQUadDbpeYdoY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/6] crypto: testmgr - add iv_out to all CBC test vectors
Date:   Thu, 14 Feb 2019 00:03:52 -0800
Message-Id: <20190214080355.8112-4-ebiggers@kernel.org>
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

Test that all CBC implementations update the IV buffer to contain the
last ciphertext block, aka the IV to continue the encryption/decryption
of a larger message.  Users may rely on this for chaining.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 980f7abb6115..3e68d4062e51 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -7007,6 +7007,7 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
 		.iv	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.iv_out	= "\x46\x8e\x91\x15\x78\x88\xba\x68",
 		.ptext	= "\x37\x36\x35\x34\x33\x32\x31\x20"
 			  "\x4e\x6f\x77\x20\x69\x73\x20\x74"
 			  "\x68\x65\x20\x74\x69\x6d\x65\x20",
@@ -7018,6 +7019,7 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
 		.iv	= "\x12\x34\x56\x78\x90\xab\xcd\xef",
+		.iv_out	= "\xe5\xc7\xcd\xde\x87\x2b\xf2\x7c",
 		.ptext	= "\x4e\x6f\x77\x20\x69\x73\x20\x74",
 		.ctext	= "\xe5\xc7\xcd\xde\x87\x2b\xf2\x7c",
 		.len	= 8,
@@ -7025,6 +7027,7 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
 		.iv	= "\xe5\xc7\xcd\xde\x87\x2b\xf2\x7c",
+		.iv_out	= "\x43\xe9\x34\x00\x8c\x38\x9c\x0f",
 		.ptext	= "\x68\x65\x20\x74\x69\x6d\x65\x20",
 		.ctext	= "\x43\xe9\x34\x00\x8c\x38\x9c\x0f",
 		.len	= 8,
@@ -7032,6 +7035,7 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
 		.iv	= "\x43\xe9\x34\x00\x8c\x38\x9c\x0f",
+		.iv_out	= "\x68\x37\x88\x49\x9a\x7c\x05\xf6",
 		.ptext	= "\x66\x6f\x72\x20\x61\x6c\x6c\x20",
 		.ctext	= "\x68\x37\x88\x49\x9a\x7c\x05\xf6",
 		.len	= 8,
@@ -7039,6 +7043,7 @@ static const struct cipher_testvec des_cbc_tv_template[] = {
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
 		.iv	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47",
+		.iv_out	=  "\xC6\x4A\xF3\x55\xC7\x29\x2E\x63",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -7408,6 +7413,7 @@ static const struct cipher_testvec des3_ede_cbc_tv_template[] = {
 			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
 		.klen	= 24,
 		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.iv_out	= "\x6b\xfa\xb1\x91\x13\xb0\xd9\x19",
 		.ptext	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
 			  "\x53\x20\x63\x65\x65\x72\x73\x74"
 			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
@@ -7448,6 +7454,7 @@ static const struct cipher_testvec des3_ede_cbc_tv_template[] = {
 		.klen	= 24,
 		.iv	= "\xB2\xD7\x48\xED\x06\x44\xF9\x12"
 			  "\xB7\x28\x4D\x83\x24\x59\xF2\x17",
+		.iv_out	= "\x95\x63\x73\xA2\x44\xAC\xF8\xA5",
 		.ptext	= "\x05\xEC\x77\xFB\x42\xD5\x59\x20"
 			  "\x8B\x12\x86\x69\xF0\x5B\xCF\x56"
 			  "\x39\xAD\x34\x9F\x66\xEA\x7D\xC4"
@@ -8035,6 +8042,7 @@ static const struct cipher_testvec bf_cbc_tv_template[] = {
 			  "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
 		.klen	= 16,
 		.iv	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
+		.iv_out	= "\x59\xf1\x65\x2b\xd5\xff\x92\xcc",
 		.ptext	= "\x37\x36\x35\x34\x33\x32\x31\x20"
 			  "\x4e\x6f\x77\x20\x69\x73\x20\x74"
 			  "\x68\x65\x20\x74\x69\x6d\x65\x20"
@@ -8051,6 +8059,7 @@ static const struct cipher_testvec bf_cbc_tv_template[] = {
 			  "\x78\xBE\x9B\x78\x55\x32\x0F\x55",
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\xB4\x98\xD8\x6B\x74\xE7\x65\xF4",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -8756,6 +8765,8 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 		.key	= zeroed_string,
 		.klen	= 16,
 		.iv	= zeroed_string,
+		.iv_out	= "\x9f\x58\x9f\x5c\xf6\x12\x2c\x32"
+			  "\xb6\xbf\xec\x2f\x2a\xe8\xc3\x5a",
 		.ptext	= zeroed_string,
 		.ctext	= "\x9f\x58\x9f\x5c\xf6\x12\x2c\x32"
 			  "\xb6\xbf\xec\x2f\x2a\xe8\xc3\x5a",
@@ -8765,6 +8776,8 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 		.klen	= 16,
 		.iv	= "\x9f\x58\x9f\x5c\xf6\x12\x2c\x32"
 			  "\xb6\xbf\xec\x2f\x2a\xe8\xc3\x5a",
+		.iv_out	= "\xd4\x91\xdb\x16\xe7\xb1\xc3\x9e"
+			  "\x86\xcb\x08\x6b\x78\x9f\x54\x19",
 		.ptext	= zeroed_string,
 		.ctext	= "\xd4\x91\xdb\x16\xe7\xb1\xc3\x9e"
 			  "\x86\xcb\x08\x6b\x78\x9f\x54\x19",
@@ -8774,6 +8787,8 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 		.klen	= 16,
 		.iv	= "\xd4\x91\xdb\x16\xe7\xb1\xc3\x9e"
 			  "\x86\xcb\x08\x6b\x78\x9f\x54\x19",
+		.iv_out	= "\x05\xef\x8c\x61\xa8\x11\x58\x26"
+			  "\x34\xba\x5c\xb7\x10\x6a\xa6\x41",
 		.ptext	= zeroed_string,
 		.ctext	= "\x05\xef\x8c\x61\xa8\x11\x58\x26"
 			  "\x34\xba\x5c\xb7\x10\x6a\xa6\x41",
@@ -8782,6 +8797,8 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 		.key	= zeroed_string,
 		.klen	= 16,
 		.iv	= zeroed_string,
+		.iv_out	= "\x05\xef\x8c\x61\xa8\x11\x58\x26"
+			  "\x34\xba\x5c\xb7\x10\x6a\xa6\x41",
 		.ptext	= zeroed_string,
 		.ctext	= "\x9f\x58\x9f\x5c\xf6\x12\x2c\x32"
 			  "\xb6\xbf\xec\x2f\x2a\xe8\xc3\x5a"
@@ -8798,6 +8815,8 @@ static const struct cipher_testvec tf_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\x30\x70\x56\xA4\x37\xDD\x7C\xC0"
+			  "\x0A\xA3\x30\x10\x26\x25\x41\x2C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -10166,6 +10185,8 @@ static const struct cipher_testvec serpent_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\xFC\x66\xAA\x37\xF2\x37\x39\x6B"
+			  "\xBC\x08\x3A\xA2\x29\xB3\xDF\xD1",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -11375,6 +11396,8 @@ static const struct cipher_testvec sm4_cbc_tv_template[] = {
 			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
+		.iv_out	= "\x4C\xB7\x01\x69\x51\x90\x92\x26"
+			  "\x97\x9B\x0D\x15\xDC\x6A\x8F\x6D",
 		.ctext	= "\x78\xEB\xB1\x1C\xC4\x0B\x0A\x48"
 			  "\x31\x2A\xAE\xB2\x04\x02\x44\xCB"
 			  "\x4C\xB7\x01\x69\x51\x90\x92\x26"
@@ -11390,6 +11413,8 @@ static const struct cipher_testvec sm4_cbc_tv_template[] = {
 			  "\xaa\xaa\xaa\xaa\xbb\xbb\xbb\xbb",
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
+		.iv_out	= "\x91\xf2\xc1\x47\x91\x1a\x41\x44"
+			  "\x66\x5e\x1f\xa1\xd4\x0b\xae\x38",
 		.ctext	= "\x0d\x3a\x6d\xdc\x2d\x21\xc6\x98"
 			  "\x85\x72\x15\x58\x7b\x7b\xb5\x9a"
 			  "\x91\xf2\xc1\x47\x91\x1a\x41\x44"
@@ -11622,6 +11647,8 @@ static const struct cipher_testvec cast6_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\x4D\x59\x7D\xC5\x28\x69\xFA\x92"
+			  "\x22\x46\x89\x2D\x0F\x2B\x08\x24",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -12365,6 +12392,8 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.klen   = 16,
 		.iv	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
 			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.iv_out	= "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
+			  "\x27\x08\x94\x2d\xbe\x77\x18\x1a",
 		.ptext	= "Single block msg",
 		.ctext	= "\xe3\x53\x77\x9c\x10\x79\xae\xb8"
 			  "\x27\x08\x94\x2d\xbe\x77\x18\x1a",
@@ -12375,6 +12404,8 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.klen   = 16,
 		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
 			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.iv_out	= "\x75\x86\x60\x2d\x25\x3c\xff\xf9"
+			  "\x1b\x82\x66\xbe\xa6\xd6\x1a\xb1",
 		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -12391,6 +12422,8 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.klen	= 24,
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.iv_out	= "\x08\xb0\xe2\x79\x88\x59\x88\x81"
+			  "\xd9\x20\xa9\xe6\x4f\x56\x15\xcd",
 		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -12416,6 +12449,8 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.iv_out	= "\xb2\xeb\x05\xe2\xc3\x9b\xe9\xfc"
+			  "\xda\x6c\x19\x07\x8c\x6a\x9d\x1b",
 		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
 			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
 			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
@@ -12441,6 +12476,8 @@ static const struct cipher_testvec aes_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE7\x82\x1D\xB8\x53\x11\xAC\x47"
 			  "\xE2\x7D\x18\xD6\x71\x0C\xA7\x42",
+		.iv_out	= "\xE0\x1F\x91\xF8\x82\x96\x2D\x65"
+			  "\xA3\xAA\x13\xCC\x50\xFF\x7B\x02",
 		.ptext	= "\x50\xB9\x22\xAE\x17\x80\x0C\x75"
 			  "\xDE\x47\xD3\x3C\xA5\x0E\x9A\x03"
 			  "\x6C\xF8\x61\xCA\x33\xBF\x28\x91"
@@ -22874,6 +22911,7 @@ static const struct cipher_testvec cast5_cbc_tv_template[] = {
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
 		.klen	= 16,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F",
+		.iv_out	= "\x1D\x18\x66\x44\x5B\x8F\x14\xEB",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
@@ -23405,6 +23443,8 @@ static const struct cipher_testvec anubis_cbc_tv_template[] = {
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
 		.klen	= 16,
+		.iv_out	= "\x86\xd8\xb5\x6f\x98\x5e\x8a\x66"
+			  "\x4f\x1f\x78\xa1\xbb\x37\xf1\xbe",
 		.ptext	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
@@ -23421,6 +23461,8 @@ static const struct cipher_testvec anubis_cbc_tv_template[] = {
 			  "\x35\x35\x35\x35\x35\x35\x35\x35"
 			  "\x35\x35\x35\x35\x35\x35\x35\x35",
 		.klen	= 40,
+		.iv_out	= "\xa2\xbc\x06\x98\xc6\x4b\xda\x75"
+			  "\x2e\xaa\xbe\x58\xce\x01\x5b\xc7",
 		.ptext	= "\x35\x35\x35\x35\x35\x35\x35\x35"
 			  "\x35\x35\x35\x35\x35\x35\x35\x35"
 			  "\x35\x35\x35\x35\x35\x35\x35\x35"
@@ -23823,6 +23865,8 @@ static const struct cipher_testvec camellia_cbc_tv_template[] = {
 		.klen   = 16,
 		.iv	= "\x3d\xaf\xba\x42\x9d\x9e\xb4\x30"
 			  "\xb4\x22\xda\x80\x2c\x9f\xac\x41",
+		.iv_out	= "\xea\x32\x12\x76\x3b\x50\x10\xe7"
+			  "\x18\xf6\xfd\x5d\xf6\x8f\x13\x51",
 		.ptext	= "Single block msg",
 		.ctext	= "\xea\x32\x12\x76\x3b\x50\x10\xe7"
 			  "\x18\xf6\xfd\x5d\xf6\x8f\x13\x51",
@@ -23833,6 +23877,8 @@ static const struct cipher_testvec camellia_cbc_tv_template[] = {
 		.klen   = 16,
 		.iv     = "\x56\x2e\x17\x99\x6d\x09\x3d\x28"
 			  "\xdd\xb3\xba\x69\x5a\x2e\x6f\x58",
+		.iv_out	= "\x19\xb4\x3e\x57\x1c\x02\x5e\xa0"
+			  "\x15\x78\xe0\x5e\xf2\xcb\x87\x16",
 		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
 			  "\x10\x11\x12\x13\x14\x15\x16\x17"
@@ -23850,6 +23896,8 @@ static const struct cipher_testvec camellia_cbc_tv_template[] = {
 		.klen	= 32,
 		.iv	= "\xE2\x24\x89\xEE\x53\xB8\x1D\x5F"
 			  "\xC4\x29\x8E\xF3\x35\x9A\xFF\x64",
+		.iv_out	= "\x55\x01\xD4\x58\xB2\xF2\x85\x49"
+			  "\x70\xC5\xB9\x0B\x3B\x7A\x6E\x6C",
 		.ptext	= "\x56\xED\x84\x1B\x8F\x26\xBD\x31"
 			  "\xC8\x5F\xF6\x6A\x01\x98\x0C\xA3"
 			  "\x3A\xD1\x45\xDC\x73\x0A\x7E\x15"
-- 
2.20.1

