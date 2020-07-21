Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA00C433E5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BFEC206E3
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="m1KZnXuN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgGUTHp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730389AbgGUTGx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:53 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387A0C05BD0F
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:53 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so11943466wrh.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IAzax0iAInzAko5yIFWiXgbe0PWCrK9UQn54BhF64QE=;
        b=m1KZnXuNUVbBvZhFNWCDC9GibXG8kn2La7zpp3vY38Gy9Cf4u6JQYGxg0X0pI0nvFl
         rNQtzF5nI/1fRnCshLvo7TSOoVxusaYR0WCRm/JW4fdlB020XpGh1HAxKMJvgGT70fks
         oCvAtKllhcjKE22qO84UHiLnWEf0iEs+kmgMlYlcdpQrRiLTdFj2H1+ImPjlPtNe9JVm
         W9qqBpWuKdpSMPEBdxPhy7c0Bbvmvr+FukwRGWL0gZIiilnQmOGowHeCp2fjvxmxJKyk
         mlZZAGMjFxtzPIN9/WO1F4HevQVp1MPquHP7/k+xWttv/giY+VjoPnhA4vovC5dm5wal
         l3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IAzax0iAInzAko5yIFWiXgbe0PWCrK9UQn54BhF64QE=;
        b=kiGY5Urw4BHyD06loGPcRaxXKjkDu+H8BOrAKffvkWR//RquxrtrXqmcUyxGNOPe8X
         8OlYnKp0HpBRnoFzRUMYImx2apmlS5Dbpy1QCngr5cjuMDvZMr3WP0yq+bJO/8smPIyl
         1tOua2CO5hAl9xEbiuzjNyEWbTpnd4Dpw/ScoxV2ZvCHeOeDgG3vO7mJvEdHSWyVsUcK
         rdj4tZfU9LqtMqBASDcx3uKiEYlqwDZK1TvZa2T+d7LexG7nQb+pZ92yCsGw0GYH+zK7
         FTVCI9X7D2udPdg4gPEUo/yvV7VJDYs7ggF5Hy0Hk2W+48vBJbpEjMLffWYtNSPdzK5x
         M8QA==
X-Gm-Message-State: AOAM53132vhkW9Qvgeyq9q8hCHpzvNp5sxaGZjvLhH+Y8V9AHaSmLO5R
        O6ZAG5MPks4tVN8iLBArZvYxoQ==
X-Google-Smtp-Source: ABdhPJwUuh03MeS1LQlCCh4M8Y0/zoF8AU1cm9XXkn7ajfNy9hLcx7W0C6HjpklqTa/e8IfnnYIWXw==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr5377184wrf.309.1595358411966;
        Tue, 21 Jul 2020 12:06:51 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:51 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 11/17] crypto: sun8i-ce: rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
Date:   Tue, 21 Jul 2020 19:06:25 +0000
Message-Id: <1595358391-34525-12-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hash algorithms will need also a spetial t_dlen handling, but since the
meaning will be different, rename the current flag to specify it apply
only on ciphers algorithms.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index fa12c966c45f..2dcf508b0f18 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -119,7 +119,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	common |= rctx->op_dir | CE_COMM_INT;
 	cet->t_common_ctl = cpu_to_le32(common);
 	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
-	if (ce->variant->has_t_dlen_in_bytes)
+	if (ce->variant->cipher_t_dlen_in_bytes)
 		cet->t_dlen = cpu_to_le32(areq->cryptlen);
 	else
 		cet->t_dlen = cpu_to_le32(areq->cryptlen / 4);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 4cc98180be3f..de4d70f87a9c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -61,7 +61,7 @@ static const struct ce_variant ce_h6_variant = {
 	},
 	.op_mode = { CE_OP_ECB, CE_OP_CBC
 	},
-	.has_t_dlen_in_bytes = true,
+	.cipher_t_dlen_in_bytes = true,
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index eea0847dc1e8..3dbf8ca47b7c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -97,7 +97,7 @@ struct ce_clock {
  * @alg_cipher:	list of supported ciphers. for each CE_ID_ this will give the
  *              coresponding CE_ALG_XXX value
  * @op_mode:	list of supported block modes
- * @has_t_dlen_in_bytes:	Does the request size for cipher is in
+ * @cipher_t_dlen_in_bytes:	Does the request size for cipher is in
  *				bytes or words
  * @ce_clks:	list of clocks needed by this variant
  * @esr:	The type of error register
@@ -105,7 +105,7 @@ struct ce_clock {
 struct ce_variant {
 	char alg_cipher[CE_ID_CIPHER_MAX];
 	u32 op_mode[CE_ID_OP_MAX];
-	bool has_t_dlen_in_bytes;
+	bool cipher_t_dlen_in_bytes;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
 	int esr;
 };
-- 
2.26.2

