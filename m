Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16058C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 14:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E37062146F
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 14:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfCaOqn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 10:46:43 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:41198 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731130AbfCaOqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 10:46:42 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id E40C072CCAE;
        Sun, 31 Mar 2019 17:46:38 +0300 (MSK)
Received: from beacon.altlinux.org (unknown [185.6.174.98])
        by imap.altlinux.org (Postfix) with ESMTPSA id B87014A4A16;
        Sun, 31 Mar 2019 17:46:38 +0300 (MSK)
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Denis Kenzior <denkenz@gmail.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KEYS: asym_tpm: move setting set_pub_key parameters into derive_pub_key
Date:   Sun, 31 Mar 2019 17:46:12 +0300
Message-Id: <20190331144612.22029-1-vt@altlinux.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The only reason for derive_pub_key() is to take a TPM-blob formatted
public key and convert it to ASN.1 format understood by
crypto_akcipher_set_pub_key. Because we are changing set_pub_key input
format (adding key parameters) - update that function to generate proper
zero values instead of generating them each time after the call.

Suggested-by: Denis Kenzior <denkenz@gmail.com>
Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
This should be applied after "crypto: add EC-RDSA (GOST 34.10) algorithm" patchset.

 crypto/asymmetric_keys/asym_tpm.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/crypto/asymmetric_keys/asym_tpm.c b/crypto/asymmetric_keys/asym_tpm.c
index d95d7ec50e5a..b138acf3a5e6 100644
--- a/crypto/asymmetric_keys/asym_tpm.c
+++ b/crypto/asymmetric_keys/asym_tpm.c
@@ -276,6 +276,10 @@ static int tpm_sign(struct tpm_buf *tb,
 
 	return datalen;
 }
+
+/* Room to fit two u32 zeros for algo id and parameters length. */
+#define SETKEY_PARAMS_SIZE (sizeof(u32) * 2)
+
 /*
  * Maximum buffer size for the BER/DER encoded public key.  The public key
  * is of the form SEQUENCE { INTEGER n, INTEGER e } where n is a maximum 2048
@@ -286,8 +290,9 @@ static int tpm_sign(struct tpm_buf *tb,
  *     - 257 bytes of n
  *   - max 2 bytes for INTEGER e type/length
  *     - 3 bytes of e
+ * - 4+4 of zeros for set_pub_key parameters (SETKEY_PARAMS_SIZE)
  */
-#define PUB_KEY_BUF_SIZE (4 + 4 + 257 + 2 + 3)
+#define PUB_KEY_BUF_SIZE (4 + 4 + 257 + 2 + 3 + SETKEY_PARAMS_SIZE)
 
 /*
  * Provide a part of a description of the key for /proc/keys.
@@ -364,6 +369,8 @@ static uint32_t derive_pub_key(const void *pub_key, uint32_t len, uint8_t *buf)
 	cur = encode_tag_length(cur, 0x02, sizeof(e));
 	memcpy(cur, e, sizeof(e));
 	cur += sizeof(e);
+	/* Zero parameters to satisfy set_pub_key ABI. */
+	memset(cur, 0, SETKEY_PARAMS_SIZE);
 
 	return cur - buf;
 }
@@ -395,12 +402,6 @@ static int determine_akcipher(const char *encoding, const char *hash_algo,
 	return -ENOPKG;
 }
 
-static u8 *tpm_pack_u32(u8 *dst, u32 val)
-{
-	memcpy(dst, &val, sizeof(val));
-	return dst + sizeof(val);
-}
-
 /*
  * Query information about a key.
  */
@@ -428,14 +429,11 @@ static int tpm_key_query(const struct kernel_pkey_params *params,
 	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
 					 der_pub_key);
 
-	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
+	pkey = kmalloc(der_pub_key_len + SETKEY_PARAMS_SIZE, GFP_KERNEL);
 	if (!pkey)
 		goto error_free_tfm;
-	memcpy(pkey, der_pub_key, der_pub_key_len);
+	memcpy(pkey, der_pub_key, der_pub_key_len + SETKEY_PARAMS_SIZE);
 	ptr = pkey + der_pub_key_len;
-	/* Set dummy parameters to satisfy set_pub_key ABI. */
-	ptr = tpm_pack_u32(ptr, 0); /* algo */
-	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
 
 	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
 	if (ret < 0)
@@ -493,13 +491,11 @@ static int tpm_key_encrypt(struct tpm_key *tk,
 	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
 					 der_pub_key);
 
-	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
+	pkey = kmalloc(der_pub_key_len + SETKEY_PARAMS_SIZE, GFP_KERNEL);
 	if (!pkey)
 		goto error_free_tfm;
-	memcpy(pkey, der_pub_key, der_pub_key_len);
+	memcpy(pkey, der_pub_key, der_pub_key_len + SETKEY_PARAMS_SIZE);
 	ptr = pkey + der_pub_key_len;
-	ptr = tpm_pack_u32(ptr, 0); /* algo */
-	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
 
 	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
 	if (ret < 0)
@@ -798,13 +794,11 @@ static int tpm_key_verify_signature(const struct key *key,
 	der_pub_key_len = derive_pub_key(tk->pub_key, tk->pub_key_len,
 					 der_pub_key);
 
-	pkey = kmalloc(der_pub_key_len + sizeof(u32) * 2, GFP_KERNEL);
+	pkey = kmalloc(der_pub_key_len + SETKEY_PARAMS_SIZE, GFP_KERNEL);
 	if (!pkey)
 		goto error_free_tfm;
-	memcpy(pkey, der_pub_key, der_pub_key_len);
+	memcpy(pkey, der_pub_key, der_pub_key_len + SETKEY_PARAMS_SIZE);
 	ptr = pkey + der_pub_key_len;
-	ptr = tpm_pack_u32(ptr, 0); /* algo */
-	ptr = tpm_pack_u32(ptr, 0); /* parameter length */
 
 	ret = crypto_akcipher_set_pub_key(tfm, pkey, der_pub_key_len);
 	if (ret < 0)
-- 
2.11.0

