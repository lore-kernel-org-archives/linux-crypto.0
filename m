Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D757CC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABE1D206A2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="DfoAI+m5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfF1E1s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:27:48 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58850 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfF1E1q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:46 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RdXp020857;
        Thu, 27 Jun 2019 23:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696059;
        bh=+JcQY1LG9gNG3F7q1r1Itpd36WhWjpw9sV8+qyxk/l4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=DfoAI+m5ulodTcEV/3sZfwocTG9PwdYpPjMlPPX5eI9yxNyyL0ghs3B1Bwrz9x0SO
         XgSxYG4i937bwVGxuiKw/3j7JFGwkvgMeBkOD0nxGh0JUViC7SwccgVsbzAG35sqMR
         b+rRYJJYCFElNx2aOaTE/G3qxUxAlEniGadinVlI=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RdYl021629
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:39 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:39 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPP062595;
        Thu, 27 Jun 2019 23:27:36 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 05/10] crypto: sha256_generic: Export the Transform function
Date:   Fri, 28 Jun 2019 09:57:40 +0530
Message-ID: <20190628042745.28455-6-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The transform function can be used as is by other crypto
drivers that need to transform the 256 bit key using cpu.
Hence export it.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 crypto/sha256_generic.c | 3 ++-
 include/crypto/sha.h    | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index b7502a96a0d4..583a3c3b93e0 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -63,7 +63,7 @@ static inline void BLEND_OP(int I, u32 *W)
 	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
 }
 
-static void sha256_transform(u32 *state, const u8 *input)
+void sha256_transform(u32 *state, const u8 *input)
 {
 	u32 a, b, c, d, e, f, g, h, t1, t2;
 	u32 W[64];
@@ -225,6 +225,7 @@ static void sha256_transform(u32 *state, const u8 *input)
 	a = b = c = d = e = f = g = h = t1 = t2 = 0;
 	memzero_explicit(W, 64 * sizeof(u32));
 }
+EXPORT_SYMBOL(sha256_transform);
 
 static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
 				    int blocks)
diff --git a/include/crypto/sha.h b/include/crypto/sha.h
index 8a46202b1857..6e04f412b0c2 100644
--- a/include/crypto/sha.h
+++ b/include/crypto/sha.h
@@ -95,6 +95,7 @@ struct sha512_state {
 
 struct shash_desc;
 
+extern void sha256_transform(u32 *state, const u8 *input);
 extern int crypto_sha1_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len);
 
-- 
2.17.1

