Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDC1C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 20:48:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjJ2Usz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 16:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjJ2Usu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 16:48:50 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5554CFA
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:46 -0700 (PDT)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3CF19406D3
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 20:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1698612524;
        bh=CZ05zwSbIcchFahU+bSausQMNazT3la51HxfbHwy+5I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=X+NuSWCdSFWNAbf6zWXiC6KS+wODp35EpbvePw5fqaVhubkJbOzZWcW/+NwvArhpV
         dSnDbDRvekprNbsmI7g5OpPRZ1w9AE5pYaIlj204zx0v7olf0HGYPIbtOTBMMVW3L0
         QxDanCW2+rZJNI2G956WvhVEQlv5b6s9vqMxnDGkhAC8TZeK+jwU9aDNdsm7FZ98i1
         EmLP64P6GWnrp3+Hf+fTCBu8ZTAGTKj4ejo36mqR931SJLU9FDwYjfmB7b+KviMyot
         EdsInCPvh2aLca2T3wwGFYwMDaPjRv4DqCgHFqLLBP5DYmiRuftoYiRg/Jbs4Cjwhg
         2evV+qrNSpPyA==
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-32f521150aaso1819528f8f.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Oct 2023 13:48:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698612520; x=1699217320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZ05zwSbIcchFahU+bSausQMNazT3la51HxfbHwy+5I=;
        b=GeNeXmjJoGtceo1fozmiQ8RRJgmrRYCElZkq40TMsxIJqkQrlOkmc0dUWxXIhH67fe
         ouAv2yCNhiLiAJjRakPaUQuPsZIHqPEd7GZUyD+4TGPEb3iILqrVQ/bJbqU3W1j4lJsv
         LliFgPeEmR7S3JUHLMB+kROikn7skbISQtw48InRqlWV/irgq0PTDMiAYfRtB0ru9HNN
         mpMfcVHKvmWIbZBA6CgjnDSTaZz4Hhu20CgxBiuSwxLBiS0q8+4sywhRjATz7kldEBYE
         O7QQ5AGpkcxsP+mqPH6Xgxh8G2DJ+EcOMLqdVC/6v+IWxTG00ckNzlG/BGbn4XiVy3O/
         pD6w==
X-Gm-Message-State: AOJu0YwpTSQ4Rs83P6NHiFf2uPjXM1/v+VB8uFUXyXXIU8UGAXC97EMw
        uHMlyPCvlqr8zPqJom7jeeYN8HtkApFJj8PfD2caRje/BZhMpNbdBIyi4ubZSOEYzxYBpLnN3+M
        AVWqGvXDXhqJ7mjHZ6CX5dY6SpPgndX5zX4XA7Ty52w==
X-Received: by 2002:adf:e881:0:b0:32d:7162:7ffe with SMTP id d1-20020adfe881000000b0032d71627ffemr6439294wrm.69.1698612520286;
        Sun, 29 Oct 2023 13:48:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3296prb3EpPU46aNfWMI+tY2ZtonmUuq5do3RPO8Q2CMxhHwePLbXIh9Z2jhDbnqlm9vTAg==
X-Received: by 2002:adf:e881:0:b0:32d:7162:7ffe with SMTP id d1-20020adfe881000000b0032d71627ffemr6439283wrm.69.1698612520054;
        Sun, 29 Oct 2023 13:48:40 -0700 (PDT)
Received: from localhost ([2001:67c:1560:8007::aac:c15c])
        by smtp.gmail.com with ESMTPSA id d2-20020adff842000000b0032d9a1f2ec3sm6661495wrq.27.2023.10.29.13.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Oct 2023 13:48:39 -0700 (PDT)
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     simo@redhat.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] crypto: drbg - Remove SHA1 from drbg
Date:   Sun, 29 Oct 2023 22:48:23 +0200
Message-Id: <20231029204823.663930-4-dimitri.ledkov@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
References: <20231029204823.663930-1-dimitri.ledkov@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SP800-90C 3rd draft states that SHA-1 will be removed from all
specifications, including drbg by end of 2030. Given kernels built
today will be operating past that date, start complying with upcoming
requirements.

No functional change, as SHA-256 / SHA-512 based DRBG have always been
the preferred ones.

Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
---
 crypto/drbg.c    | 16 ----------------
 crypto/testmgr.c | 25 ++++---------------------
 2 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 99666193d9..bccadaedcf 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -139,12 +139,6 @@ static const struct drbg_core drbg_cores[] = {
 #endif /* CONFIG_CRYPTO_DRBG_CTR */
 #ifdef CONFIG_CRYPTO_DRBG_HASH
 	{
-		.flags = DRBG_HASH | DRBG_STRENGTH128,
-		.statelen = 55, /* 440 bits */
-		.blocklen_bytes = 20,
-		.cra_name = "sha1",
-		.backend_cra_name = "sha1",
-	}, {
 		.flags = DRBG_HASH | DRBG_STRENGTH256,
 		.statelen = 111, /* 888 bits */
 		.blocklen_bytes = 48,
@@ -166,12 +160,6 @@ static const struct drbg_core drbg_cores[] = {
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 	{
-		.flags = DRBG_HMAC | DRBG_STRENGTH128,
-		.statelen = 20, /* block length of cipher */
-		.blocklen_bytes = 20,
-		.cra_name = "hmac_sha1",
-		.backend_cra_name = "hmac(sha1)",
-	}, {
 		.flags = DRBG_HMAC | DRBG_STRENGTH256,
 		.statelen = 48, /* block length of cipher */
 		.blocklen_bytes = 48,
@@ -648,8 +636,6 @@ MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha384");
 MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha256");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha256");
-MODULE_ALIAS_CRYPTO("drbg_pr_hmac_sha1");
-MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha1");
 
 /* update function of HMAC DRBG as defined in 10.1.2.2 */
 static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
@@ -768,8 +754,6 @@ MODULE_ALIAS_CRYPTO("drbg_pr_sha384");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha384");
 MODULE_ALIAS_CRYPTO("drbg_pr_sha256");
 MODULE_ALIAS_CRYPTO("drbg_nopr_sha256");
-MODULE_ALIAS_CRYPTO("drbg_pr_sha1");
-MODULE_ALIAS_CRYPTO("drbg_nopr_sha1");
 
 /*
  * Increment buffer
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 216878c8bc..209b21ef79 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4849,14 +4849,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.drbg = __VECS(drbg_nopr_ctr_aes256_tv_template)
 		}
-	}, {
-		/*
-		 * There is no need to specifically test the DRBG with every
-		 * backend cipher -- covered by drbg_nopr_hmac_sha256 test
-		 */
-		.alg = "drbg_nopr_hmac_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_nopr_hmac_sha256",
 		.test = alg_test_drbg,
@@ -4865,7 +4857,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.drbg = __VECS(drbg_nopr_hmac_sha256_tv_template)
 		}
 	}, {
-		/* covered by drbg_nopr_hmac_sha256 test */
+		/*
+		 * There is no need to specifically test the DRBG with every
+		 * backend cipher -- covered by drbg_nopr_hmac_sha512 test
+		 */
 		.alg = "drbg_nopr_hmac_sha384",
 		.test = alg_test_null,
 	}, {
@@ -4875,10 +4870,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
 		}
-	}, {
-		.alg = "drbg_nopr_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_nopr_sha256",
 		.test = alg_test_drbg,
@@ -4910,10 +4901,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "drbg_pr_ctr_aes256",
 		.fips_allowed = 1,
 		.test = alg_test_null,
-	}, {
-		.alg = "drbg_pr_hmac_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_hmac_sha256",
 		.test = alg_test_drbg,
@@ -4929,10 +4916,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "drbg_pr_hmac_sha512",
 		.test = alg_test_null,
 		.fips_allowed = 1,
-	}, {
-		.alg = "drbg_pr_sha1",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "drbg_pr_sha256",
 		.test = alg_test_drbg,
-- 
2.34.1

