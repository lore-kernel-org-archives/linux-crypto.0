Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054D0C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 07:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiFWHGQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiFWHGO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 03:06:14 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B784553A
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:06:10 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 65so461890pfw.11
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rr6W1HmkOzqLYvFXcgRYRczNT4ybnvSLXNzzsMN6g3Q=;
        b=jpw63lepLX00PxAQ3AB/XZKTFPXKTzvrs68AuvGp25NlOeJ56IQLggJ7BO2bJhZNuh
         UPsUi+ElRlVUUoiqWOmRpIxUJITt6gLIXZSV86CqTkmlOJguy5aka6mJcAtm20NhahN4
         fdn4ziaG4eQ/zzGSXITzXXLlSo8XRiekSJD5kdz/tVJumIJegODQTYRKWtST96OeiImK
         n4v7AIEqLqKqnvqMZRcdFfYJCFQFO+j5GA/nSuTloDBfGGFqIirXKXprgYR9puWhtLwJ
         GSRKc5BFk2oRoamk+y0tquO4xdIo8VYl8y3PEcFcre6Cd4VUlsD/2Euql1nW6o4LDDkI
         MJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rr6W1HmkOzqLYvFXcgRYRczNT4ybnvSLXNzzsMN6g3Q=;
        b=TuaXcR0ccXFJpCo/LEtqX8+GUw2AtT3L0HdHugIeqiZzXFvfAKuDvqI6oRLFfoODJc
         d07154PPoiRWvh/Hbl+TLgTZISEsxQcGilvfAe1XnDqQPZMlljYxrdWGU1Uxai+qYZwA
         eBWBFCzcEjuO22fV0hMxuV4RQenCdfo37b2kfAIXRpFM6rM3D6hcfvba+cZCoGlkCtJt
         uZL+nOYsoPqGgtN/zhMH4a7C94w0wVf3oEWYou+JfpNba+H9LAceIU/281cjzgDROWH8
         E+oTs1KGTrQRLTS9NWuqFfxlKTmNzztw2C1hPJKeLb4ayKib6Ag7PrVk1GJ86bldpyba
         jhTw==
X-Gm-Message-State: AJIora+V/iQ0SYw2O/HrFe+/ZBerz5eMM9DOn5sUcHxJeZW0do42m+GK
        2TNIqxiH50w65FEvRwgYw42O5A==
X-Google-Smtp-Source: AGRyM1v3ykNRyuxjHSfiYDbsQhb64H9DNnWlAEDV8OnbkM6BtOpCMueRS4/hHlnPuW9ToGNpToas9A==
X-Received: by 2002:a63:6886:0:b0:406:2777:70f7 with SMTP id d128-20020a636886000000b00406277770f7mr6382468pgc.389.1655967969743;
        Thu, 23 Jun 2022 00:06:09 -0700 (PDT)
Received: from FVFDK26JP3YV.bytedance.net ([139.177.225.250])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b0016a15842cf5sm9125184plb.121.2022.06.23.00.06.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 00:06:09 -0700 (PDT)
From:   Lei He <helei.sig11@bytedance.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com
Cc:     mst@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, berrange@redhat.com,
        pizhenwei@bytedance.com, lei he <helei.sig11@bytedance.com>
Subject: [PATCH v2 2/4] crypto: pkcs8 parser support ECDSA private keys
Date:   Thu, 23 Jun 2022 15:05:48 +0800
Message-Id: <20220623070550.82053-3-helei.sig11@bytedance.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220623070550.82053-1-helei.sig11@bytedance.com>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

Make pkcs8_private_key_parser can identify ECDSA private keys.

Signed-off-by: lei he <helei.sig11@bytedance.com>
---
 crypto/akcipher.c                     | 10 ++++++
 crypto/asymmetric_keys/pkcs8.asn1     |  2 +-
 crypto/asymmetric_keys/pkcs8_parser.c | 45 +++++++++++++++++++++++++--
 3 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index f866085c8a4a..3adcdc6d48c2 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -120,6 +120,12 @@ static int akcipher_default_op(struct akcipher_request *req)
 	return -ENOSYS;
 }
 
+static int akcipher_default_set_key(struct crypto_akcipher *tfm,
+				    const void *key, unsigned int keylen)
+{
+	return -ENOSYS;
+}
+
 int crypto_register_akcipher(struct akcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
@@ -132,6 +138,10 @@ int crypto_register_akcipher(struct akcipher_alg *alg)
 		alg->encrypt = akcipher_default_op;
 	if (!alg->decrypt)
 		alg->decrypt = akcipher_default_op;
+	if (!alg->set_pub_key)
+		alg->set_pub_key = akcipher_default_set_key;
+	if (!alg->set_priv_key)
+		alg->set_priv_key = akcipher_default_set_key;
 
 	akcipher_prepare_alg(alg);
 	return crypto_register_alg(base);
diff --git a/crypto/asymmetric_keys/pkcs8.asn1 b/crypto/asymmetric_keys/pkcs8.asn1
index 702c41a3c713..1791ddf4168a 100644
--- a/crypto/asymmetric_keys/pkcs8.asn1
+++ b/crypto/asymmetric_keys/pkcs8.asn1
@@ -20,5 +20,5 @@ Attribute ::= ANY
 
 AlgorithmIdentifier ::= SEQUENCE {
 	algorithm   OBJECT IDENTIFIER ({ pkcs8_note_OID }),
-	parameters  ANY OPTIONAL
+	parameters  ANY OPTIONAL ({ pkcs8_note_algo_parameter })
 }
diff --git a/crypto/asymmetric_keys/pkcs8_parser.c b/crypto/asymmetric_keys/pkcs8_parser.c
index 105dcce27f71..e507c635ead5 100644
--- a/crypto/asymmetric_keys/pkcs8_parser.c
+++ b/crypto/asymmetric_keys/pkcs8_parser.c
@@ -24,6 +24,8 @@ struct pkcs8_parse_context {
 	enum OID	algo_oid;		/* Algorithm OID */
 	u32		key_size;
 	const void	*key;
+	const void	*algo_param;
+	u32		algo_param_len;
 };
 
 /*
@@ -47,6 +49,17 @@ int pkcs8_note_OID(void *context, size_t hdrlen,
 	return 0;
 }
 
+int pkcs8_note_algo_parameter(void *context, size_t hdrlen,
+			      unsigned char tag,
+			      const void *value, size_t vlen)
+{
+	struct pkcs8_parse_context *ctx = context;
+
+	ctx->algo_param = value;
+	ctx->algo_param_len = vlen;
+	return 0;
+}
+
 /*
  * Note the version number of the ASN.1 blob.
  */
@@ -69,11 +82,37 @@ int pkcs8_note_algo(void *context, size_t hdrlen,
 		    const void *value, size_t vlen)
 {
 	struct pkcs8_parse_context *ctx = context;
-
-	if (ctx->last_oid != OID_rsaEncryption)
+	enum OID curve_id;
+
+	switch (ctx->last_oid) {
+	case OID_id_ecPublicKey:
+		if (!ctx->algo_param || ctx->algo_param_len == 0)
+			return -EBADMSG;
+		curve_id = look_up_OID(ctx->algo_param, ctx->algo_param_len);
+
+		switch (curve_id) {
+		case OID_id_prime192v1:
+			ctx->pub->pkey_algo = "ecdsa-nist-p192";
+			break;
+		case OID_id_prime256v1:
+			ctx->pub->pkey_algo = "ecdsa-nist-p256";
+			break;
+		case OID_id_ansip384r1:
+			ctx->pub->pkey_algo = "ecdsa-nist-p384";
+			break;
+		default:
+			return -ENOPKG;
+		}
+		break;
+
+	case OID_rsaEncryption:
+		ctx->pub->pkey_algo = "rsa";
+		break;
+
+	default:
 		return -ENOPKG;
+	}
 
-	ctx->pub->pkey_algo = "rsa";
 	return 0;
 }
 
-- 
2.20.1

