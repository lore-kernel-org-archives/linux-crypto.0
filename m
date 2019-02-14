Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8923C10F06
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75C6222D2
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131462;
	bh=WdK2r9YNHAgcRAnbkOKdnZHevIDhZNlCSMsQM2yzLd0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=BGWkaFyy1zXB6yt8C+UU2jc9mMFHdVB418clP7Bo9eyMvQ3hwisR3xQWWrrbxJayM
	 zvaXOfNWr+cf+M5UfENfvW6NhtA+9CWyyliqPTswr7pvAHtWWHC4Qat75lZLlefsFs
	 3pRVDqyn+VlYT65DmP+/wUBgeoGT03LncD2I5gFY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391867AbfBNIEV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:59988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfBNIES (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:18 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 240CB222D4;
        Thu, 14 Feb 2019 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131457;
        bh=WdK2r9YNHAgcRAnbkOKdnZHevIDhZNlCSMsQM2yzLd0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=0A0lALhd569z6CCXzQnrqpE7siySMN7YvEJ4ueunYGpekMLfKq3fGOUu/Mu2CKPGk
         wfbClce4A1fVnJq4ToG3VCZtRoetZVR/RjCXBKBoUPmVddCPgEQ38qNjiylnyPbIQH
         HGbv9G45KxG6uhabP9tF3GDa3BQ51sx2gQmf6Ep4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/6] crypto: testmgr - support checking skcipher output IV
Date:   Thu, 14 Feb 2019 00:03:51 -0800
Message-Id: <20190214080355.8112-3-ebiggers@kernel.org>
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

Allow skcipher test vectors to declare the value the IV buffer should be
updated to at the end of the encryption or decryption operation.

(This check actually used to be supported in testmgr, but it was never
used and therefore got removed except for the AES-Keywrap special case.
But it will be used by CBC and CTR now, so re-add it.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c |  6 ++++--
 crypto/testmgr.h | 12 +++++++-----
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d582a2758feb..8386038d67c7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1542,7 +1542,9 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	if (ivsize) {
 		if (WARN_ON(ivsize > MAX_IVLEN))
 			return -EINVAL;
-		if (vec->iv && !(vec->generates_iv && enc))
+		if (vec->generates_iv && !enc)
+			memcpy(iv, vec->iv_out, ivsize);
+		else if (vec->iv)
 			memcpy(iv, vec->iv, ivsize);
 		else
 			memset(iv, 0, ivsize);
@@ -1635,7 +1637,7 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	}
 
 	/* If applicable, check that the algorithm generated the correct IV */
-	if (vec->generates_iv && enc && memcmp(iv, vec->iv, ivsize) != 0) {
+	if (vec->iv_out && memcmp(iv, vec->iv_out, ivsize) != 0) {
 		pr_err("alg: skcipher: %s %s test failed (wrong output IV) on test vector %u, cfg=\"%s\"\n",
 		       driver, op, vec_num, cfg->name);
 		hexdump(iv, ivsize);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e01c77eeded3..980f7abb6115 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -47,7 +47,8 @@ struct hash_testvec {
  * cipher_testvec:	structure to describe a symmetric cipher test
  * @key:	Pointer to key
  * @klen:	Length of @key in bytes
- * @iv:		Pointer to IV (optional for some ciphers)
+ * @iv:		Pointer to IV.  If NULL, an all-zeroes IV is used.
+ * @iv_out:	Pointer to output IV, if applicable for the cipher.
  * @ptext:	Pointer to plaintext
  * @ctext:	Pointer to ciphertext
  * @len:	Length of @ptext and @ctext in bytes
@@ -55,12 +56,13 @@ struct hash_testvec {
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  * 		( e.g. test needs to fail due to a weak key )
  * @fips_skip:	Skip the test vector in FIPS mode
- * @generates_iv: Encryption should ignore the given IV, and output @iv.
- *		  Decryption takes @iv.  Needed for AES Keywrap ("kw(aes)").
+ * @generates_iv: Encryption should ignore the given IV, and output @iv_out.
+ *		  Decryption takes @iv_out.  Needed for AES Keywrap ("kw(aes)").
  */
 struct cipher_testvec {
 	const char *key;
 	const char *iv;
+	const char *iv_out;
 	const char *ptext;
 	const char *ctext;
 	bool fail;
@@ -21771,7 +21773,7 @@ static const struct cipher_testvec aes_kw_tv_template[] = {
 		.ctext	= "\xf6\x85\x94\x81\x6f\x64\xca\xa3"
 			  "\xf5\x6f\xab\xea\x25\x48\xf5\xfb",
 		.len	= 16,
-		.iv	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
+		.iv_out	= "\x03\x1f\x6b\xd7\xe6\x1e\x64\x3d",
 		.generates_iv = true,
 	}, {
 		.key	= "\x80\xaa\x99\x73\x27\xa4\x80\x6b"
@@ -21784,7 +21786,7 @@ static const struct cipher_testvec aes_kw_tv_template[] = {
 		.ctext	= "\xd3\x3d\x3d\x97\x7b\xf0\xa9\x15"
 			  "\x59\xf9\x9c\x8a\xcd\x29\x3d\x43",
 		.len	= 16,
-		.iv	= "\x42\x3c\x96\x0d\x8a\x2a\xc4\xc1",
+		.iv_out	= "\x42\x3c\x96\x0d\x8a\x2a\xc4\xc1",
 		.generates_iv = true,
 	},
 };
-- 
2.20.1

