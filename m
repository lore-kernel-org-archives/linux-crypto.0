Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9374BC38145
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Sep 2022 20:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiIHUBp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Sep 2022 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiIHUBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Sep 2022 16:01:14 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A18FE489
        for <linux-crypto@vger.kernel.org>; Thu,  8 Sep 2022 13:01:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lz22so19729216ejb.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 Sep 2022 13:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=H2N4r24xffuQzjnz0S6Tp2HVsxJb1+KqLlP/Qh70Xos=;
        b=K+VL5x3t8nb2mwWmAxLE7VinydD5ROPD/Uy7SbFoR20MrWEo5JvVUXVcFLc7V4o+ez
         U+H4q3i2WKKNiN898b39B1kxvMlhnVP2I9zrylJs9U3lZ/s/wfqUvNH0WhPAWNMGOFpB
         gGc/lUNwvh3meRBSRAbq1PR7YFObsurmA6i4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=H2N4r24xffuQzjnz0S6Tp2HVsxJb1+KqLlP/Qh70Xos=;
        b=LauSp1SX5TsUn691mH527C2c52LhPHgcb9JE+XpVbSzfQJyCSyEnHII5q694whBsLI
         NaOj0KJW9VE1nAF9UaXAoKkvSyArOHwqCu+92RIO2JMn1Phv4z1aWOCbCWZuSwd1EGF0
         40th0yeZvVXoniTzckuQXqys6RmRzOvBVhie9dU6YYSFUn0eaqMLXcf6YxKxwB2uQBfy
         pv+y9ImhFsWdUncFMkImI/3KG3HUjsDzYSSS27FFUH/ELC7QTiSKRq27H9UHH1siBoWb
         i22KwNWBnrULjgu+C47hVLxt74CXeXaUA2TgiUUD5nlGvY4pGcmcaWVsopGgsNqoSzK2
         W+vQ==
X-Gm-Message-State: ACgBeo0JQbSaSQmCKEQ+s7qv14SXfCpLs7g+jQO85ke4Uz+G6rZCCJlR
        OevU8W5jK92BjbKRV8QVG3oRfg==
X-Google-Smtp-Source: AA6agR7gc4qkLQrIM9YMcYyCvS4uQt3kyf/XWm0yXCWiV4WoEDcjRw+18myg4e++UvOZFf8g6LPmZw==
X-Received: by 2002:a17:907:6da4:b0:76f:4e07:f735 with SMTP id sb36-20020a1709076da400b0076f4e07f735mr7110756ejc.246.1662667271195;
        Thu, 08 Sep 2022 13:01:11 -0700 (PDT)
Received: from localhost.localdomain ([104.28.243.158])
        by smtp.gmail.com with ESMTPSA id kx11-20020a170907774b00b00778e3e2830esm521202ejc.9.2022.09.08.13.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:01:10 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     lei he <helei.sig11@bytedance.com>, kernel-team@cloudflare.com,
        Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH 3/4] crypto: pkcs8 parser support ECDSA private keys
Date:   Thu,  8 Sep 2022 21:00:35 +0100
Message-Id: <20220908200036.2034-4-ignat@cloudflare.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220908200036.2034-1-ignat@cloudflare.com>
References: <20220908200036.2034-1-ignat@cloudflare.com>
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
2.36.1

