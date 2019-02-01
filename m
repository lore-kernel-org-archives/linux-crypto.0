Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEA4C282DA
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E032320B1F
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007583;
	bh=gX2BhYd/DPOZBaEWf1iLOJQgiJFSisxbFv46xmuuEkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OB/lS4l9QGwwHF3tGCQ9zDHYNgYRhAxppLSsF0uyqGgnhOAPy/IKlqUU8NHWJkUcT
	 qXFWLVEf455SrsvOAFEXcvUtLrUlbNVZ/K69fIZ6rvzacQOJA9ydS4NnbRDDiGQX8A
	 OfAVtwEb49srrFPpSlAa6zEmgyksKVACfq5Es/Yk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbfBAHxB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfBAHwE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:04 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B69821726;
        Fri,  1 Feb 2019 07:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007523;
        bh=gX2BhYd/DPOZBaEWf1iLOJQgiJFSisxbFv46xmuuEkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KITViIDkUrgs17Om5alchFKaugawV1PnHDXwLNwol2537fqsEP+vOUcKhJSGneOHS
         KOShQJs1LCqceJ14h4CWQJ2ZwWmGW5NCOYF/vjGrLk80x+yMANiI96LjmZMbyRgR2r
         fAgHo4cxV3U7wOWjFmkeEZqag3F/MRwN6iwspEws=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/15] crypto: testmgr - implement random testvec_config generation
Date:   Thu, 31 Jan 2019 23:51:45 -0800
Message-Id: <20190201075150.18644-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add functions that generate a random testvec_config, in preparation for
using it for randomized fuzz tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5e527dbe6524c..b9e28d4edb5cc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -28,6 +28,7 @@
 #include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/once.h>
+#include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -603,6 +604,122 @@ static int build_cipher_test_sglists(struct cipher_test_sglists *tsgls,
 				 alignmask, dst_total_len, NULL, NULL);
 }
 
+#ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
+static char *generate_random_sgl_divisions(struct test_sg_division *divs,
+					   size_t max_divs, char *p, char *end,
+					   bool gen_flushes)
+{
+	struct test_sg_division *div = divs;
+	unsigned int remaining = TEST_SG_TOTAL;
+
+	do {
+		unsigned int this_len;
+
+		if (div == &divs[max_divs - 1] || prandom_u32() % 2 == 0)
+			this_len = remaining;
+		else
+			this_len = 1 + (prandom_u32() % remaining);
+		div->proportion_of_total = this_len;
+
+		if (prandom_u32() % 4 == 0)
+			div->offset = (PAGE_SIZE - 128) + (prandom_u32() % 128);
+		else if (prandom_u32() % 2 == 0)
+			div->offset = prandom_u32() % 32;
+		else
+			div->offset = prandom_u32() % PAGE_SIZE;
+		if (prandom_u32() % 8 == 0)
+			div->offset_relative_to_alignmask = true;
+
+		div->flush_type = FLUSH_TYPE_NONE;
+		if (gen_flushes) {
+			switch (prandom_u32() % 4) {
+			case 0:
+				div->flush_type = FLUSH_TYPE_REIMPORT;
+				break;
+			case 1:
+				div->flush_type = FLUSH_TYPE_FLUSH;
+				break;
+			}
+		}
+
+		BUILD_BUG_ON(TEST_SG_TOTAL != 10000); /* for "%u.%u%%" */
+		p += scnprintf(p, end - p, "%s%u.%u%%@%s+%u%s",
+			       div->flush_type == FLUSH_TYPE_NONE ? "" :
+			       div->flush_type == FLUSH_TYPE_FLUSH ?
+			       "<flush> " : "<reimport> ",
+			       this_len / 100, this_len % 100,
+			       div->offset_relative_to_alignmask ?
+					"alignmask" : "",
+			       div->offset, this_len == remaining ? "" : ", ");
+		remaining -= this_len;
+		div++;
+	} while (remaining);
+
+	return p;
+}
+
+/* Generate a random testvec_config for fuzz testing */
+static void generate_random_testvec_config(struct testvec_config *cfg,
+					   char *name, size_t max_namelen)
+{
+	char *p = name;
+	char * const end = name + max_namelen;
+
+	memset(cfg, 0, sizeof(*cfg));
+
+	cfg->name = name;
+
+	p += scnprintf(p, end - p, "random:");
+
+	if (prandom_u32() % 2 == 0) {
+		cfg->inplace = true;
+		p += scnprintf(p, end - p, " inplace");
+	}
+
+	if (prandom_u32() % 2 == 0) {
+		cfg->req_flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
+		p += scnprintf(p, end - p, " may_sleep");
+	}
+
+	switch (prandom_u32() % 4) {
+	case 0:
+		cfg->finalization_type = FINALIZATION_TYPE_FINAL;
+		p += scnprintf(p, end - p, " use_final");
+		break;
+	case 1:
+		cfg->finalization_type = FINALIZATION_TYPE_FINUP;
+		p += scnprintf(p, end - p, " use_finup");
+		break;
+	default:
+		cfg->finalization_type = FINALIZATION_TYPE_DIGEST;
+		p += scnprintf(p, end - p, " use_digest");
+		break;
+	}
+
+	p += scnprintf(p, end - p, " src_divs=[");
+	p = generate_random_sgl_divisions(cfg->src_divs,
+					  ARRAY_SIZE(cfg->src_divs), p, end,
+					  (cfg->finalization_type !=
+					   FINALIZATION_TYPE_DIGEST));
+	p += scnprintf(p, end - p, "]");
+
+	if (!cfg->inplace && prandom_u32() % 2 == 0) {
+		p += scnprintf(p, end - p, " dst_divs=[");
+		p = generate_random_sgl_divisions(cfg->dst_divs,
+						  ARRAY_SIZE(cfg->dst_divs),
+						  p, end, false);
+		p += scnprintf(p, end - p, "]");
+	}
+
+	if (prandom_u32() % 2 == 0) {
+		cfg->iv_offset = 1 + (prandom_u32() % MAX_ALGAPI_ALIGNMASK);
+		p += scnprintf(p, end - p, " iv_offset=%u", cfg->iv_offset);
+	}
+
+	WARN_ON_ONCE(!valid_testvec_config(cfg));
+}
+#endif /* CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
+
 static int ahash_guard_result(char *result, char c, int size)
 {
 	int i;
-- 
2.20.1

