Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C28C11D2F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 14:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3552720838
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 14:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="JSQ9hzcF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbgBXOrt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 09:47:49 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35914 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727463AbgBXOrt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 09:47:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so10704859wru.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2020 06:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=KDPBtGVPBVQPLZB50FaWbCJtaH0jJpShP4zemqcplEE=;
        b=JSQ9hzcF3mCf5GvenAuVUKTcFJKeFCn0zzl4m6DPVldFFbHeRhui0mprbAZxqQSygM
         S92kaHzJVaIZCzJGrZ+/UpI+laYz1EZ8q9bGWuhOVSysrEq0EEJ73+x5mQUWbWI2cHIv
         plbbwLhaVkngP+8i01HCJNN0R1DyplTti2QXBbMft3QfAbN4PB9BIVyib3aTrpWhsgUa
         xEbI2LltdPFa/9n190aN5C5cUZtYLyNmo0zq78INttuyUFgWL2annLHfekp3hWfJ/r9a
         OOEJRGi+miGPreuQ+udReKLe7GC8EwnbKPVVR0JITLCtFW2YtRoLk+hCtaXRgvSnCFic
         WlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KDPBtGVPBVQPLZB50FaWbCJtaH0jJpShP4zemqcplEE=;
        b=XfuHZm7Ha+9rIWhnCB2pXSnuhW6S/xljW3CnBzB/QkFDKB+fGtOl9RmXj4i0bXxlVC
         U7H8IgwnX4yaZNg/2YNzfjqvVPqwrdO8rwQ7NZb4qUG0gG+R9bM75X8heWuowXFopcf2
         Dj2EDTffxBChvVq07WWYO6cboPNwb7OEGgWFJfWCabysnKASYJt5+kLoBL3qPAFkDcxi
         eBONsQSnhyMIgMDg4ATtLb4tp8TqRJtblPP/1duDLo6n3Rm5wB7g9O/JyQx7rI866LzQ
         xYY3FBnw//bcDp3e3LtxruI66F6BLDZeHf6dZ3W6mZwYw478M6jROmAYHSYE8xx4+RzP
         JNkQ==
X-Gm-Message-State: APjAAAWqTvhGkjXK/Nn4xAmmHdZYHu/6DXMFcWSoT5n6p3I296Krv8wq
        kAlV46bLbMvVk4neGzV2y5wFdQ==
X-Google-Smtp-Source: APXvYqzGK4+c332KH5IGra98Ax5NpmLFd6tEuMOmZpD6uXoAmVEK8xtY+u8D/Db3A8UAroJjRuoxDg==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr65798433wrt.367.1582555667583;
        Mon, 24 Feb 2020 06:47:47 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id w1sm19579363wro.72.2020.02.24.06.47.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Feb 2020 06:47:46 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     ard.biesheuvel@linaro.org, catalin.marinas@arm.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, will@kernel.org,
        ebiggers@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2] crypto: arm64: CE: implement export/import
Date:   Mon, 24 Feb 2020 14:47:41 +0000
Message-Id: <1582555661-25737-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When an ahash algorithm fallback to another ahash and that fallback is
shaXXX-CE, doing export/import lead to error like this:
alg: ahash: sha1-sun8i-ce export() overran state buffer on test vector 0, cfg=\"import/export\"

This is due to the descsize of shaxxx-ce being larger than struct shaxxx_state
off by an u32.
For fixing this, let's implement export/import which rip the finalize
variant instead of using generic export/import.

Fixes: 6ba6c74dfc6b ("arm64/crypto: SHA-224/SHA-256 using ARMv8 Crypto Extensions")
Fixes: 2c98833a42cd ("arm64/crypto: SHA-1 using ARMv8 Crypto Extensions")

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Changes since v1:
- memcpy directly &sctx->sst instead of sctx. As suggested by Eric Biggers

 arch/arm64/crypto/sha1-ce-glue.c | 20 ++++++++++++++++++++
 arch/arm64/crypto/sha2-ce-glue.c | 23 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 63c875d3314b..565ef604ca04 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -91,12 +91,32 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 	return sha1_base_finish(desc, out);
 }
 
+static int sha1_ce_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, &sctx->sst, sizeof(struct sha1_state));
+	return 0;
+}
+
+static int sha1_ce_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(&sctx->sst, in, sizeof(struct sha1_state));
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
index a8e67bafba3d..9450d19b9e6e 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -109,12 +109,32 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 	return sha256_base_finish(desc, out);
 }
 
+static int sha256_ce_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, &sctx->sst, sizeof(struct sha256_state));
+	return 0;
+}
+
+static int sha256_ce_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(&sctx->sst, in, sizeof(struct sha256_state));
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

