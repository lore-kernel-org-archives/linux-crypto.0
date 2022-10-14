Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4DDC4167D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Oct 2022 10:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiJNKID (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Oct 2022 06:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJNKH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2022 06:07:59 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A271C8D42
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r13so6773130wrj.11
        for <linux-crypto@vger.kernel.org>; Fri, 14 Oct 2022 03:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOV0/JHYEg81m6+HxEgpndLefaJ+Ca9O4oLBIpfzJQg=;
        b=RJR6YVOdooXE1ewExAo012x6+ETUffZf9JSuN3wIAQMjSS52jgw0YElszm7b2hfOU9
         j9/r+7BCB5NuBVtfceRoJR+MG5bC7zDU0dKqpv8sX76TcTT1KDPv6CFtr+I2QgTyFeV5
         whm8Y4wRQ4JhWP52lRcrdgX7vlqNx5cmNZPSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MOV0/JHYEg81m6+HxEgpndLefaJ+Ca9O4oLBIpfzJQg=;
        b=Bsl0dErXxmER/iXbKgcYvda90ED77g+j9+vtN/pRxvLcvgAjde9HPMv9PPZCdsf4md
         mgHDSJC84AMzGeQEBa6XJsLo2bFGBI+/nx46sqJzJjaq/yPQziTStaVk2f2OBmhoxRjf
         wirMNdVCjX/22G/ojrL57nzhSLAKDNWWdO3+APojJGjOHZinMOuj8cZVvoaWRWCdbVlk
         d3g+Wg4qZXKM6ytGTZhnEsKt7+z5hqyHHZpIsS4bZ3ZqNVPKQ9+bKyOkWOkFX0uhRFNH
         359brWjYksLHnpDp17MrggOtqdyj5dH5qsVag4cOdhxHUbsA5AOG4W2yLDXAPdcWrjXx
         yhvQ==
X-Gm-Message-State: ACrzQf0OCEb6+P5j0CmjfGDt3upro0a3eBie9SnI/Wq0uqNYNjtRcbIE
        u/eum5/D+48W5GnYMDs893lUnw==
X-Google-Smtp-Source: AMsMyM6R7T5D7MBjCPKvu+8/PVJ4EhCvqGhG3oqYXHeE+m7Y5CMK8iCqDUp6B9RIwHswAyehRH6PqA==
X-Received: by 2002:a5d:584a:0:b0:231:636c:de28 with SMTP id i10-20020a5d584a000000b00231636cde28mr2816767wrf.175.1665742074550;
        Fri, 14 Oct 2022 03:07:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:c7c:5308:6600:49a0:d6bf:5c1a:f3da])
        by smtp.gmail.com with ESMTPSA id c15-20020a5d414f000000b002285f73f11dsm1931008wrq.81.2022.10.14.03.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 03:07:54 -0700 (PDT)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, lei he <helei.sig11@bytedance.com>,
        Ignat Korchagin <ignat@cloudflare.com>
Subject: [PATCH v2 3/4] crypto: pkcs8 parser support ECDSA private keys
Date:   Fri, 14 Oct 2022 11:07:36 +0100
Message-Id: <20221014100737.94742-4-ignat@cloudflare.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221014100737.94742-1-ignat@cloudflare.com>
References: <20221014100737.94742-1-ignat@cloudflare.com>
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

