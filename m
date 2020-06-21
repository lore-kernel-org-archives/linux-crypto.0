Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A072C433E0
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B17125239
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="jjkqmJxp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgFUTbZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730522AbgFUTbY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:24 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1A6C061796
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:23 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l26so12968434wme.3
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0dGwXCSVQvElT7TpcVdbWKGX6coZv9pEyimy5T+xruU=;
        b=jjkqmJxpyg+xomXLLgGXvDekVWNlewhi/vo2OlozzdTmwvRhwx8dmIVf2lr/IgD2d3
         MdMmgTJOMsgZLe4GBnnzPOoVGU4rpVou3fYJtpsKJvSFQUNwrXtbvbTzslWeQJOI86vD
         Tt97RDVIJzmXRcezbOY7OIlyYrczMos2x5o/Dz2dtzBKtTuGI4+njCmG9ZAeJ7An4/RZ
         Ha3g0V1gsc/LT2DWqJZdJmU5gNJ7X9n0RT6pRQBt+xTV7X7CcEYcpB5bmP/vBxsb7H+9
         UlHQnhs629dXUFAvtqepXuBD6QIRAehTZR5cbQoI55iSbhzDs+MG4+505RvxzFRK014y
         3xCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0dGwXCSVQvElT7TpcVdbWKGX6coZv9pEyimy5T+xruU=;
        b=AuQCvXXkN/weKR6L1ZinNtyIzyQMCsa3WeTipP850ha339tb+wI2KUFg4FoMN0n+Z1
         wBoijOXNWbfXcnNztSpWL9dcP+Tlqf/Ti+TwJuZFJy53NG2R0Ap9tG4b6dntKIrBmPgW
         NUS8t/X4QvaZHMAgyz01NirCwyFpE11xxljDz8wPSYLg6SY24dIi0XcJYNxGPv7lL+HH
         bnTsWEpvLcVX/vrzQskz6qsKyt6X/SKVT7EO4h6mF1+rcTtkiu599ghgHpBNqtOk65VD
         n6kUBmaesek9gjUqkhcxbH2ZhXdni32K55dqwbMy/NGgQ+46TWhMxDmZZzyx2dxrJX/Z
         +lsA==
X-Gm-Message-State: AOAM532mV8oO+wlb00umeqCafG3Qp3GG+w5hmR3uTj6zrYFvPwiPHzWs
        nqIhCuhuv+9YKz09GANyAjctlw==
X-Google-Smtp-Source: ABdhPJzJxDTJ5HHwbvpQbN1mngtsM3tKaAQ4aWQiLfaeTMEWbCKGgQ99cGsQFAr92pvLz4sx5uBzSA==
X-Received: by 2002:a1c:6788:: with SMTP id b130mr14296931wmc.100.1592767882523;
        Sun, 21 Jun 2020 12:31:22 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 10/14] crypto: sun8i-ce: rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
Date:   Sun, 21 Jun 2020 19:31:03 +0000
Message-Id: <1592767867-35982-11-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
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
index d662dac83361..ee7add582e90 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -122,7 +122,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	common |= rctx->op_dir | CE_COMM_INT;
 	cet->t_common_ctl = cpu_to_le32(common);
 	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
-	if (ce->variant->has_t_dlen_in_bytes)
+	if (ce->variant->cipher_t_dlen_in_bytes)
 		cet->t_dlen = cpu_to_le32(areq->cryptlen);
 	else
 		cet->t_dlen = cpu_to_le32(areq->cryptlen / 4);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 94969f86b967..8091ea1d5afc 100644
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
index ed1a91da967b..0a70fcc102f1 100644
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

