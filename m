Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601EECDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 18:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjJVSWb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 14:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbjJVSWa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 14:22:30 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C8ADD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:28 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C48173FA6A
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697998946;
        bh=75g1uVytfAfB4G7pprF2u0HAHdd4i0yuLNQrH1gJqY8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=kYo5WF4Jrs1knzFKw3J0L+mGZBhsCsrGpVI16TESEt2I5ZU1r1vyhE+NZj5Tn3kHH
         E/SgSKMSgcgIESWGx/UBkxHHVVjoYPzOER0gQcljZt9JDdcIWZ+KNHHHM96AzCEmIj
         uOljo1nETDLv0azo4cVafT7hSHmIuBQh2LlP/aNbHD9K+v6m7UVHdoD33cTq5qE4kv
         AiIu/1xjkAb+OLjDbRsVa/LAQ2OvgdFdxJRaWjamSdcRl2RsM5D5EGY5kLTaZAdBKO
         KmNxVprlJnS2duE0m7cyGDWqJtlERUxB9lLsK6enKW1owh0Cb1sp5eJNEFzytcaOJO
         pnyNtk5711DAw==
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4083865e0b7so14592295e9.3
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 11:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697998946; x=1698603746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75g1uVytfAfB4G7pprF2u0HAHdd4i0yuLNQrH1gJqY8=;
        b=Ng+LCSepmB/+S7kUQFlD9oNIG8HRtPmFWfOkOhbJv3kbyaiM0u1zNr7PmaiTGBOMNG
         blipgO74rOIMpbT2D0zMHhqK74Gm8cGJ1wH5dpYclTX1up9xS+M9zJg/5MJXU7F6IwOE
         s0qVFhXM0UzT4IgOx1pWjUN/OGVzyK1vBUDNmcdFT141ce8aMXbTk0l2D8lYzP/J7r1u
         XQQBSPAzlstWFJJ4Q/OKEyvzHsn0DqGDXBQk1rBoODFJliYlAeKhyELmiVViJ5rmQfD2
         43YnVbKB3EgMXEGoi+07e+lD2SZGrTzPT8p5+vwo2ArzBhnkHaO1CqYGGJmLWneq2fSH
         UTwQ==
X-Gm-Message-State: AOJu0YxQr1EhMwnj5LP42bYebA5c8YBi1DTTVsclgTErolMrhk+3cfwB
        I1S3yLoUNGSfOb3UTNPMeIcRTMQiOOLNGNTS7+pzCpULuAB5vh8iQtnNwnoRs+Wc4qSObubIrND
        k6bEEPiUgCiSdYdb7kBIgJC2HzsccH/TTme6Zr7Xohg==
X-Received: by 2002:adf:eb46:0:b0:319:6997:942e with SMTP id u6-20020adfeb46000000b003196997942emr4867521wrn.8.1697998946472;
        Sun, 22 Oct 2023 11:22:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkCnQiPm0AcaX3BXXR4mWgyDORPbAGUupIRssUsWEFx0Fo94HRnUYhw26PnU5ahgaRxLHjgQ==
X-Received: by 2002:adf:eb46:0:b0:319:6997:942e with SMTP id u6-20020adfeb46000000b003196997942emr4867511wrn.8.1697998946101;
        Sun, 22 Oct 2023 11:22:26 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id f10-20020adff98a000000b0031aef72a021sm6091289wrr.86.2023.10.22.11.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Oct 2023 11:22:25 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x509: Add OIDs for FIPS 202 SHA-3 hash and signatures
Date:   Sun, 22 Oct 2023 19:22:03 +0100
Message-Id: <20231022182208.188714-2-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231022182208.188714-1-dimitri.ledkov@canonical.com>
References: <20231022182208.188714-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add OID for FIPS 202 SHA-3 family of hash functions, RSA & ECDSA
signatures using those. Limit to 256 or larger sizes, for
interoperability reasons. 224 is too weak for any practical uses.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 include/linux/oid_registry.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/oid_registry.h b/include/linux/oid_registry.h
index 8b79e55cfc..3921fbed0b 100644
--- a/include/linux/oid_registry.h
+++ b/include/linux/oid_registry.h
@@ -129,6 +129,17 @@ enum OID {
 	OID_TPMImportableKey,		/* 2.23.133.10.1.4 */
 	OID_TPMSealedData,		/* 2.23.133.10.1.5 */
 
+	/* CSOR FIPS-202 SHA-3 */
+	OID_sha3_256,                           /* 2.16.840.1.101.3.4.2.8 */
+	OID_sha3_384,                           /* 2.16.840.1.101.3.4.2.9 */
+	OID_sha3_512,                           /* 2.16.840.1.101.3.4.2.10 */
+	OID_id_ecdsa_with_sha3_256,             /* 2.16.840.1.101.3.4.3.10 */
+	OID_id_ecdsa_with_sha3_384,             /* 2.16.840.1.101.3.4.3.11 */
+	OID_id_ecdsa_with_sha3_512,             /* 2.16.840.1.101.3.4.3.12 */
+	OID_id_rsassa_pkcs1_v1_5_with_sha3_256, /* 2.16.840.1.101.3.4.3.14 */
+	OID_id_rsassa_pkcs1_v1_5_with_sha3_384, /* 2.16.840.1.101.3.4.3.15 */
+	OID_id_rsassa_pkcs1_v1_5_with_sha3_512, /* 2.16.840.1.101.3.4.3.16 */
+
 	OID__NR
 };
 
-- 
2.34.1

