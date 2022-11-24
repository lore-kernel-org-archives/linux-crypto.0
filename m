Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94405C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Nov 2022 14:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiKXOBA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Nov 2022 09:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiKXOAj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Nov 2022 09:00:39 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C9E1448E1
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:36 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id j5-20020a05600c410500b003cfa9c0ea76so1301487wmi.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Nov 2022 05:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOV0/JHYEg81m6+HxEgpndLefaJ+Ca9O4oLBIpfzJQg=;
        b=GLYA1v5eNATQO1vvCsTT7oynkA2oTGIWJuo/nJ3SRsduvSWWv1gi2qbfBprG4o33Sw
         pu/YCPsZ531MyXFGwDXmAqU3aIUuyXibH+njYOHGDEDztc/3xMCcGEdFRKb4ut3KKXAx
         PkmPtnjn4r5dE7R+FXG0ngW2YTigncjLXWcfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOV0/JHYEg81m6+HxEgpndLefaJ+Ca9O4oLBIpfzJQg=;
        b=xwgu4BbCem5+PD/Qornh0ts1djX9VtUjJrV75owUKb7Rcz6YP5jeUiFIB4wFhDTh2r
         Vwb0zixIjL9LqWR8B8Z78fqtL1rsIW+2ztmvLt+MQ2+E5QKNX+HKu+vV06S7opQnhsH4
         vvUKC6mGSbI4QdwUy0O0zt/2vp5mUtXuBwiVD6vz6g0B2AS6COiJPEiR2CMrfEM+66J0
         cmu43uqj0rEhcJJG9CgOktEKw2N+7/n34iIsONMjudD7sx0Xa7mwjxiwF4Y/Lq1+CMU+
         ZQkFSerad6u8TooCC+mCYWerR6j/LGGF59AFhr+8irOMUtbczGHXw2rql4uujVw3NPTp
         5U1Q==
X-Gm-Message-State: ANoB5pk6hGwIuqG9bKfCCJ3flwwauV+EDCLO370n6OUWWSKidgY9C9si
        BsXM7BeGpROfbtKeRkbTuHCsVg==
X-Google-Smtp-Source: AA0mqf6yuhIqzkcaBsLjdvn8dN0YTQXYBrCWAHXnfZsbLp3dN5z5ny5VpIH1qO2r8e0Ds8cZ3PstSQ==
X-Received: by 2002:a05:600c:3542:b0:3cf:6c2f:950c with SMTP id i2-20020a05600c354200b003cf6c2f950cmr16568410wmq.146.1669298315035;
        Thu, 24 Nov 2022 05:58:35 -0800 (PST)
Received: from localhost.localdomain ([2a09:bac1:28c0:140::15:1b6])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d660e000000b00241bee11825sm1371440wru.103.2022.11.24.05.58.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 24 Nov 2022 05:58:34 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        keyrings@vger.kernel.org
Cc:     kernel-team@cloudflare.com, lei he <helei.sig11@bytedance.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Subject: [RESEND PATCH v2 3/4] crypto: pkcs8 parser support ECDSA private keys
Date:   Thu, 24 Nov 2022 13:58:11 +0000
Message-Id: <20221124135812.26999-4-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20221124135812.26999-1-ignat@cloudflare.com>
References: <20221124135812.26999-1-ignat@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: lei he <helei.sig11@bytedance.com>

Make pkcs8_private_key_parser can identify ECDSA private keys.

Signed-off-by: lei he <helei.sig11@bytedance.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 crypto/asymmetric_keys/pkcs8.asn1     |  2 +-
 crypto/asymmetric_keys/pkcs8_parser.c | 45 +++++++++++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

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
2.30.2

