Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25BBC41514
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2ACD20679
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 07:54:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r3iP9PNl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfHMHyN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 03:54:13 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44672 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbfHMHyM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 03:54:12 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so48919737plr.11
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2019 00:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/LDCXgnTbDgwlPQDLk7SsYNcNi/37UGWjEQF7+J/ZYE=;
        b=r3iP9PNlcM0kO4YJClGM6fwe6D1fs37ubXNz1GmGBEoLJ5tQF7vRq2VYK4DtybDTq7
         UtpKrnGXk9qz6fN9pF6jHtg7y7i+uNm30gBprWeCu1vWcwwl6eo32Z51IKeo+I9z4fIE
         yi6vjFUv2x8HeaETU6FKL3ehtqXUWB0NTvC9MQjYJTEpMP5UpcFSwxSjJpX9mp4DaREy
         jQLZAHgi+p8VkhOp6P8RtGEu4UxhCRe/LrKxLcymL0IMwhF4S7EZUc3zbuxA/GXJWpSo
         bEFsi+jXsjclbAAMjyuUEvypg2xR4i+RDwU3nBssaoeDd94bl24Q6wW+cunLN6hKpc/r
         RQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/LDCXgnTbDgwlPQDLk7SsYNcNi/37UGWjEQF7+J/ZYE=;
        b=inlGZHvxIAyI599mNQstAaOI39A6Bk7hBZ4sAaQ0mqj2hnNw/R6yB05EaLNnxHiAge
         1PKxjZKa6FPPrlVlRpRBV/lWHyG2RsFljBSBT99aJNVh96537fHtDB1wQg89AdfBUgK0
         7Rn5Lh+mX2mfQKb8ET56ZHXKuai0rbSUIvlhLndRUOMMYhBEXfz9BFMc35f5ANEcPnwJ
         NWuR38QzyUhMczIfEICHDb7puD/gPmyqnb6K/+0QCfD09zqN+GXB6PB40PdMtXHYyYK7
         pU64KmgS1Hke9C2+ouXXuTcq/Toumg8hoOtPBzGJDsyX7ZCPL1I9eu9o4Oi2OK24VDjn
         oi0g==
X-Gm-Message-State: APjAAAWk3Z3O6qegQZfMwvuqIzRsRLjojkBEh0Dlmz6rrOi3C+fKaUoN
        D7XubMxE8QI/ldoZ/KeITTvI7yNW7dk=
X-Google-Smtp-Source: APXvYqwsbeExH/nr+zaEx9TScTxEo/nl1s4NPJ89pIYFr06y4gHh2Z1IbKyPNOATwEh9lXJ3a1cgHg==
X-Received: by 2002:a17:902:883:: with SMTP id 3mr2354968pll.318.1565682852238;
        Tue, 13 Aug 2019 00:54:12 -0700 (PDT)
Received: from localhost.localdomain ([45.114.72.100])
        by smtp.gmail.com with ESMTPSA id l25sm131462563pff.143.2019.08.13.00.54.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 13 Aug 2019 00:54:11 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     keyrings@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, peterhuewe@gmx.de, jgg@ziepe.ca,
        jejb@linux.ibm.com, jarkko.sakkinen@linux.intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, casey@schaufler-ca.com,
        ard.biesheuvel@linaro.org, daniel.thompson@linaro.org,
        linux-kernel@vger.kernel.org, tee-dev@lists.linaro.org,
        Sumit Garg <sumit.garg@linaro.org>
Subject: [RFC/RFT v4 2/5] KEYS: trusted: use common tpm_buf for TPM1.x code
Date:   Tue, 13 Aug 2019 13:23:01 +0530
Message-Id: <1565682784-10234-3-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
References: <1565682784-10234-1-git-send-email-sumit.garg@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Utilize common heap based tpm_buf code for TPM1.x trusted keys rather
than using stack based tpm1_buf code. Also, remove tpm1_buf code.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 include/keys/trusted.h  | 37 +------------------
 security/keys/trusted.c | 98 ++++++++++++++++++++++---------------------------
 2 files changed, 44 insertions(+), 91 deletions(-)

diff --git a/include/keys/trusted.h b/include/keys/trusted.h
index 841ae11..29e3e9b 100644
--- a/include/keys/trusted.h
+++ b/include/keys/trusted.h
@@ -5,10 +5,6 @@
 /* implementation specific TPM constants */
 #define MAX_BUF_SIZE			1024
 #define TPM_GETRANDOM_SIZE		14
-#define TPM_OSAP_SIZE			36
-#define TPM_OIAP_SIZE			10
-#define TPM_SEAL_SIZE			87
-#define TPM_UNSEAL_SIZE			104
 #define TPM_SIZE_OFFSET			2
 #define TPM_RETURN_OFFSET		6
 #define TPM_DATA_OFFSET			10
@@ -17,13 +13,6 @@
 #define LOAD32N(buffer, offset)	(*(uint32_t *)&buffer[offset])
 #define LOAD16(buffer, offset)	(ntohs(*(uint16_t *)&buffer[offset]))
 
-struct tpm1_buf {
-	int len;
-	unsigned char data[MAX_BUF_SIZE];
-};
-
-#define INIT_BUF(tb) (tb->len = 0)
-
 struct osapsess {
 	uint32_t handle;
 	unsigned char secret[SHA1_DIGEST_SIZE];
@@ -46,7 +35,7 @@ int TSS_checkhmac1(unsigned char *buffer,
 			  unsigned int keylen, ...);
 
 int trusted_tpm_send(unsigned char *cmd, size_t buflen);
-int oiap(struct tpm1_buf *tb, uint32_t *handle, unsigned char *nonce);
+int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce);
 
 #define TPM_DEBUG 0
 
@@ -109,28 +98,4 @@ static inline void dump_tpm_buf(unsigned char *buf)
 {
 }
 #endif
-
-static inline void store8(struct tpm1_buf *buf, const unsigned char value)
-{
-	buf->data[buf->len++] = value;
-}
-
-static inline void store16(struct tpm1_buf *buf, const uint16_t value)
-{
-	*(uint16_t *) & buf->data[buf->len] = htons(value);
-	buf->len += sizeof value;
-}
-
-static inline void store32(struct tpm1_buf *buf, const uint32_t value)
-{
-	*(uint32_t *) & buf->data[buf->len] = htonl(value);
-	buf->len += sizeof value;
-}
-
-static inline void storebytes(struct tpm1_buf *buf, const unsigned char *in,
-			      const int len)
-{
-	memcpy(buf->data + buf->len, in, len);
-	buf->len += len;
-}
 #endif
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index 0736671..f7134d6 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -395,7 +395,7 @@ static int pcrlock(const int pcrnum)
 /*
  * Create an object specific authorisation protocol (OSAP) session
  */
-static int osap(struct tpm1_buf *tb, struct osapsess *s,
+static int osap(struct tpm_buf *tb, struct osapsess *s,
 		const unsigned char *key, uint16_t type, uint32_t handle)
 {
 	unsigned char enonce[TPM_NONCE_SIZE];
@@ -406,13 +406,10 @@ static int osap(struct tpm1_buf *tb, struct osapsess *s,
 	if (ret != TPM_NONCE_SIZE)
 		return ret;
 
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_OSAP_SIZE);
-	store32(tb, TPM_ORD_OSAP);
-	store16(tb, type);
-	store32(tb, handle);
-	storebytes(tb, ononce, TPM_NONCE_SIZE);
+	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OSAP);
+	tpm_buf_append_u16(tb, type);
+	tpm_buf_append_u32(tb, handle);
+	tpm_buf_append(tb, ononce, TPM_NONCE_SIZE);
 
 	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
@@ -430,17 +427,14 @@ static int osap(struct tpm1_buf *tb, struct osapsess *s,
 /*
  * Create an object independent authorisation protocol (oiap) session
  */
-int oiap(struct tpm1_buf *tb, uint32_t *handle, unsigned char *nonce)
+int oiap(struct tpm_buf *tb, uint32_t *handle, unsigned char *nonce)
 {
 	int ret;
 
 	if (!chip)
 		return -ENODEV;
 
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_COMMAND);
-	store32(tb, TPM_OIAP_SIZE);
-	store32(tb, TPM_ORD_OIAP);
+	tpm_buf_reset(tb, TPM_TAG_RQU_COMMAND, TPM_ORD_OIAP);
 	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
 		return ret;
@@ -464,7 +458,7 @@ struct tpm_digests {
  * Have the TPM seal(encrypt) the trusted key, possibly based on
  * Platform Configuration Registers (PCRs). AUTH1 for sealing key.
  */
-static int tpm_seal(struct tpm1_buf *tb, uint16_t keytype,
+static int tpm_seal(struct tpm_buf *tb, uint16_t keytype,
 		    uint32_t keyhandle, const unsigned char *keyauth,
 		    const unsigned char *data, uint32_t datalen,
 		    unsigned char *blob, uint32_t *bloblen,
@@ -535,20 +529,17 @@ static int tpm_seal(struct tpm1_buf *tb, uint16_t keytype,
 		goto out;
 
 	/* build and send the TPM request packet */
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_AUTH1_COMMAND);
-	store32(tb, TPM_SEAL_SIZE + pcrinfosize + datalen);
-	store32(tb, TPM_ORD_SEAL);
-	store32(tb, keyhandle);
-	storebytes(tb, td->encauth, SHA1_DIGEST_SIZE);
-	store32(tb, pcrinfosize);
-	storebytes(tb, pcrinfo, pcrinfosize);
-	store32(tb, datalen);
-	storebytes(tb, data, datalen);
-	store32(tb, sess.handle);
-	storebytes(tb, td->nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, td->pubauth, SHA1_DIGEST_SIZE);
+	tpm_buf_reset(tb, TPM_TAG_RQU_AUTH1_COMMAND, TPM_ORD_SEAL);
+	tpm_buf_append_u32(tb, keyhandle);
+	tpm_buf_append(tb, td->encauth, SHA1_DIGEST_SIZE);
+	tpm_buf_append_u32(tb, pcrinfosize);
+	tpm_buf_append(tb, pcrinfo, pcrinfosize);
+	tpm_buf_append_u32(tb, datalen);
+	tpm_buf_append(tb, data, datalen);
+	tpm_buf_append_u32(tb, sess.handle);
+	tpm_buf_append(tb, td->nonceodd, TPM_NONCE_SIZE);
+	tpm_buf_append_u8(tb, cont);
+	tpm_buf_append(tb, td->pubauth, SHA1_DIGEST_SIZE);
 
 	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0)
@@ -579,7 +570,7 @@ static int tpm_seal(struct tpm1_buf *tb, uint16_t keytype,
 /*
  * use the AUTH2_COMMAND form of unseal, to authorize both key and blob
  */
-static int tpm_unseal(struct tpm1_buf *tb,
+static int tpm_unseal(struct tpm_buf *tb,
 		      uint32_t keyhandle, const unsigned char *keyauth,
 		      const unsigned char *blob, int bloblen,
 		      const unsigned char *blobauth,
@@ -628,20 +619,17 @@ static int tpm_unseal(struct tpm1_buf *tb,
 		return ret;
 
 	/* build and send TPM request packet */
-	INIT_BUF(tb);
-	store16(tb, TPM_TAG_RQU_AUTH2_COMMAND);
-	store32(tb, TPM_UNSEAL_SIZE + bloblen);
-	store32(tb, TPM_ORD_UNSEAL);
-	store32(tb, keyhandle);
-	storebytes(tb, blob, bloblen);
-	store32(tb, authhandle1);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, authdata1, SHA1_DIGEST_SIZE);
-	store32(tb, authhandle2);
-	storebytes(tb, nonceodd, TPM_NONCE_SIZE);
-	store8(tb, cont);
-	storebytes(tb, authdata2, SHA1_DIGEST_SIZE);
+	tpm_buf_reset(tb, TPM_TAG_RQU_AUTH2_COMMAND, TPM_ORD_UNSEAL);
+	tpm_buf_append_u32(tb, keyhandle);
+	tpm_buf_append(tb, blob, bloblen);
+	tpm_buf_append_u32(tb, authhandle1);
+	tpm_buf_append(tb, nonceodd, TPM_NONCE_SIZE);
+	tpm_buf_append_u8(tb, cont);
+	tpm_buf_append(tb, authdata1, SHA1_DIGEST_SIZE);
+	tpm_buf_append_u32(tb, authhandle2);
+	tpm_buf_append(tb, nonceodd, TPM_NONCE_SIZE);
+	tpm_buf_append_u8(tb, cont);
+	tpm_buf_append(tb, authdata2, SHA1_DIGEST_SIZE);
 
 	ret = trusted_tpm_send(tb->data, MAX_BUF_SIZE);
 	if (ret < 0) {
@@ -670,23 +658,23 @@ static int tpm_unseal(struct tpm1_buf *tb,
 static int key_seal(struct trusted_key_payload *p,
 		    struct trusted_key_options *o)
 {
-	struct tpm1_buf *tb;
+	struct tpm_buf tb;
 	int ret;
 
-	tb = kzalloc(sizeof *tb, GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
+	ret = tpm_buf_init(&tb, 0, 0);
+	if (ret)
+		return ret;
 
 	/* include migratable flag at end of sealed key */
 	p->key[p->key_len] = p->migratable;
 
-	ret = tpm_seal(tb, o->keytype, o->keyhandle, o->keyauth,
+	ret = tpm_seal(&tb, o->keytype, o->keyhandle, o->keyauth,
 		       p->key, p->key_len + 1, p->blob, &p->blob_len,
 		       o->blobauth, o->pcrinfo, o->pcrinfo_len);
 	if (ret < 0)
 		pr_info("trusted_key: srkseal failed (%d)\n", ret);
 
-	kzfree(tb);
+	tpm_buf_destroy(&tb);
 	return ret;
 }
 
@@ -696,14 +684,14 @@ static int key_seal(struct trusted_key_payload *p,
 static int key_unseal(struct trusted_key_payload *p,
 		      struct trusted_key_options *o)
 {
-	struct tpm1_buf *tb;
+	struct tpm_buf tb;
 	int ret;
 
-	tb = kzalloc(sizeof *tb, GFP_KERNEL);
-	if (!tb)
-		return -ENOMEM;
+	ret = tpm_buf_init(&tb, 0, 0);
+	if (ret)
+		return ret;
 
-	ret = tpm_unseal(tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
+	ret = tpm_unseal(&tb, o->keyhandle, o->keyauth, p->blob, p->blob_len,
 			 o->blobauth, p->key, &p->key_len);
 	if (ret < 0)
 		pr_info("trusted_key: srkunseal failed (%d)\n", ret);
@@ -711,7 +699,7 @@ static int key_unseal(struct trusted_key_payload *p,
 		/* pull migratable flag out of sealed key */
 		p->migratable = p->key[--p->key_len];
 
-	kzfree(tb);
+	tpm_buf_destroy(&tb);
 	return ret;
 }
 
-- 
2.7.4

