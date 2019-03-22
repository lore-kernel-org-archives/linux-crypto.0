Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FA5C4360F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60545218FC
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 06:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2c+5zPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfCVG1t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 02:27:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42267 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfCVG1s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 02:27:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id r15so810161pfn.9;
        Thu, 21 Mar 2019 23:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=burGcdVB6qhefLFFLVD5su+F5xWlQ/GIS5x59dGTJvM=;
        b=E2c+5zPD0ijvrfKmkHWzwJwXOyzRS2ySSwkrzrFOzncOl5rUv6OY+ziHiqPcwnpVKF
         Xo7HEeLvGUFsu78k2+Nmn/91gUobtr2b+1zlYqsweCxerTmB1pxuwFNAcyUwaujFLGk0
         ikVG2Pc3vM1580wp4frV84Y9pks+/hgAS7e0VLOqSaqGxNeKqNdj3oqabF8MTKilJyFg
         f/8o+buP6zrwkCM/jjYuT8D2LBubJ7aboTzaEBoF5Ez99BF7xdrFLPbuT+LWJ9OJGSZy
         W85oaH3vmTn0MgcKcQhFB4XqTndfr67l+GxSq94DCCYgDM7KzuJu36noq8apJ5yKIQUL
         8apQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=burGcdVB6qhefLFFLVD5su+F5xWlQ/GIS5x59dGTJvM=;
        b=O+dfaM5dhazfU06fNXlhB/0JdsNc4U6if58cttloa9x8Ntx9btvQcNxgezmGyl3ACK
         FwcopO1feDxRSkeHm6VnXc6YRrmCQ2Jy9TE2237DT4Yh/YY6tgN47uBfdBLZvZRQKCCB
         m/WfKO3PeyYdMnHoK7Pzrc9j2VOB8xkqEpX1XqnYrrKKOx721HZjZMbFPqVp4mzl4j3J
         2bjgpYygZqQ3H5ujhnv8KTEcPejta0Rd8JvS0iTyCcM2sllzMv8oVX5N+VEUknUXhgU4
         +O/S78PNOOXq0f24ki/cVKnL0yaDIYBHWAvTfpzR3VsVokFd3sLuXuqLR7GwFMlaUzSA
         SNDA==
X-Gm-Message-State: APjAAAX9xZjpVGvZ91WXlwTjGnURmaoG7IDrYjb8DEQO7l5xIMgM+boZ
        u3VdWc0+by1dY6Os6JD48ew=
X-Google-Smtp-Source: APXvYqycAK5Zt3439jSaPxFORhp8Q61TOAa8N0AO1lUhlLALd48GVcehnZGdzs2VH6q0yooC+dMvLw==
X-Received: by 2002:a17:902:2bc9:: with SMTP id l67mr7745824plb.102.1553236067597;
        Thu, 21 Mar 2019 23:27:47 -0700 (PDT)
Received: from linux-l9pv.suse ([202.47.205.198])
        by smtp.gmail.com with ESMTPSA id n75sm10368394pfb.39.2019.03.21.23.27.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Mar 2019 23:27:46 -0700 (PDT)
From:   "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] X.509: Add messages for obsolete OIDs
Date:   Fri, 22 Mar 2019 14:27:38 +0800
Message-Id: <20190322062738.19852-1-jlee@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We found that the db in Acer machine has self signed certificates
(CN=DisablePW or CN=ABO) that they used obsolete OID 1.3.14.3.2.29
sha1WithRSASignature and 2.5.29.1 subjectKeyIdentifier. Kernel
emits -65 error code when loading those certificates to platform
keyring:

[    1.484388] integrity: Loading X.509 certificate: UEFI:MokListRT
[    1.485557] integrity: Problem loading X.509 certificate -65
[    1.486100] Error adding keys to platform keyring UEFI:MokListRT

Because the -65 error code is not enough for appeasing user when
loading a outdated certificate. This patch add messages against
1.3.14.3.2.29 and 2.5.29.1 OIDs.

Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1129471
Cc: David Howells <dhowells@redhat.com> 
Cc: Herbert Xu <herbert@gondor.apana.org.au> 
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c | 7 +++++++
 include/linux/oid_registry.h              | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 991f4d735a4e..bbd22d5c5b5d 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -192,6 +192,8 @@ int x509_note_pkey_algo(void *context, size_t hdrlen,
 	pr_debug("PubKey Algo: %u\n", ctx->last_oid);
 
 	switch (ctx->last_oid) {
+	case OID_sha1WithRSASignature:
+		pr_info("1.3.14.3.2.29 sha1WithRSASignature is obsolete.\n");
 	case OID_md2WithRSAEncryption:
 	case OID_md3WithRSAEncryption:
 	default:
@@ -464,6 +466,11 @@ int x509_process_extension(void *context, size_t hdrlen,
 		return 0;
 	}
 
+	if (ctx->last_oid == OID_subjectKeyIdentifier_obsolete) {
+		pr_info("2.5.29.1 subjectKeyIdentifier OID is obsolete.\n");
+		return -ENOPKG;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index d2fa9ca42e9a..0641d5aa2251 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -62,6 +62,7 @@ enum OID {
 
 	OID_certAuthInfoAccess,		/* 1.3.6.1.5.5.7.1.1 */
 	OID_sha1,			/* 1.3.14.3.2.26 */
+	OID_sha1WithRSASignature,	/* 1.3.14.3.2.29 */
 	OID_sha256,			/* 2.16.840.1.101.3.4.2.1 */
 	OID_sha384,			/* 2.16.840.1.101.3.4.2.2 */
 	OID_sha512,			/* 2.16.840.1.101.3.4.2.3 */
@@ -83,6 +84,7 @@ enum OID {
 	OID_generationalQualifier,	/* 2.5.4.44 */
 
 	/* Certificate extension IDs */
+	OID_subjectKeyIdentifier_obsolete,	/* 2.5.29.1 */
 	OID_subjectKeyIdentifier,	/* 2.5.29.14 */
 	OID_keyUsage,			/* 2.5.29.15 */
 	OID_subjectAltName,		/* 2.5.29.17 */
-- 
2.16.4

