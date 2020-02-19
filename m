Return-Path: <SRS0=xEWH=4H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE126C34053
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 16:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 866DA24682
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Feb 2020 16:00:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="i8sh2k09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSQAq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Feb 2020 11:00:46 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35290 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBSQAq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Feb 2020 11:00:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so1190670wrt.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2020 08:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=oOz4MXPPY4nwvxNiM5TAeaZ5xNN9V5e9W7QtMDUB25U=;
        b=i8sh2k09ezvG04DhkRH2eRpBJXwPHBMPzRvXtwE8VZUIgaPBEFmW5sWPdFcfrnDKSY
         nzLK5SmE2DvFD5RH+oM33WeM1FCtA+EelnJr6VlPyqst0gAsxAMud+JDUb/w1TAOKOoT
         lYPzjPd56VIatBt2RSvdZta318UzJBdJykCplqK6lZ8A1doixFkAbcgwmV2YT8jzH0AO
         7nPDVy7M0tg6EDAYzTD73ODmFHbwnz0SWcyJYUkhoMtf+Uan56XLsj2iWwYHhQ5wx/dd
         cQq0qWAoDaPlk04P3rBGes4Oh2/nxWWFzTMastrc+RAgQb2nxI8vD6GdC7bKSLBqpY/p
         pSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oOz4MXPPY4nwvxNiM5TAeaZ5xNN9V5e9W7QtMDUB25U=;
        b=LppSR7VtgtOePsO1Qz2eEaDDqnFwbnUmxKPPRATaAYFxTh4xfZG4/HrPyj987EH/77
         PSX35Axo4bFeMN9AZIcpTxyg+mnLOG7dH/gTX9gJv/qw4kqrwTt56DNrvnxbAk9YQ1rc
         u68KkMKrkRQ8uSPa7eZdulmUzDRlavjQvXn6R+awe99UR7uko5RIzih+5/kgDZVCm5lt
         QHYK3cP8NyN6MtRVzBdw4VaGN52M8CoTwuCG/8TZ5EQNTkyljmioOHqtzvUVhgBuakfO
         55Cou4jhX0oVKIYg9dcm0cOg2RuurBBqz9d+wt8RZtVfjJ38c7bNQAYFEqkXseepC2CE
         2TMA==
X-Gm-Message-State: APjAAAWNnJKfS7eEV9F9r4+66Pn0k76/7MQbjpqgJvJsioOhjEvXBF4Y
        kOHDzaUb8yKb1uKEMJGBVYQ3lw==
X-Google-Smtp-Source: APXvYqyAzmVr0iYvKTKSsd5W5HUczeQN5XhXF8zmcFRGDub01v7kzAK40uKhqE+JM1xZJ3K4XOSCEQ==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr35938544wrt.36.1582128042486;
        Wed, 19 Feb 2020 08:00:42 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id t13sm277027wrw.19.2020.02.19.08.00.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 08:00:41 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, will@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: arm64: CE: implement export/import
Date:   Wed, 19 Feb 2020 16:00:37 +0000
Message-Id: <1582128037-18644-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When an ahash algorithm fallback to another ahash and that fallback is
shaXXX-CE, doing export/import lead to error like this:
alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\"

This is due to the descsize of shaxxx-ce larger than struct shaxxx_state off by an u32.
For fixing this, let's implement export/import which rip the finalize
variant instead of using generic export/import.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/crypto/sha1-ce-glue.c | 20 ++++++++++++++++++++
 arch/arm64/crypto/sha2-ce-glue.c | 23 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 63c875d3314b..dc44d48415cd 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -91,12 +91,32 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 	return sha1_base_finish(desc, out);
 }
 
+static int sha1_ce_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(struct sha1_state));
+	return 0;
+}
+
+static int sha1_ce_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(struct sha1_state));
+	sctx->finalize = 0;
+	return 0;
+}
+
 static struct shash_alg alg = {
 	.init			= sha1_base_init,
 	.update			= sha1_ce_update,
 	.final			= sha1_ce_final,
 	.finup			= sha1_ce_finup,
+	.import			= sha1_ce_import,
+	.export			= sha1_ce_export,
 	.descsize		= sizeof(struct sha1_ce_state),
+	.statesize		= sizeof(struct sha1_state),
 	.digestsize		= SHA1_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha1",
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index a8e67bafba3d..f986d4a323b3 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -109,12 +109,32 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 	return sha256_base_finish(desc, out);
 }
 
+static int sha256_ce_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(struct sha256_state));
+	return 0;
+}
+
+static int sha256_ce_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(struct sha256_state));
+	sctx->finalize = 0;
+	return 0;
+}
+
 static struct shash_alg algs[] = { {
 	.init			= sha224_base_init,
 	.update			= sha256_ce_update,
 	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
+	.export			= sha256_ce_export,
+	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
+	.statesize		= sizeof(struct sha256_state),
 	.digestsize		= SHA224_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha224",
@@ -128,7 +148,10 @@ static struct shash_alg algs[] = { {
 	.update			= sha256_ce_update,
 	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
+	.export			= sha256_ce_export,
+	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
+	.statesize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha256",
-- 
2.24.1

