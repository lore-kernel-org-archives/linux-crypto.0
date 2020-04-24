Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6B5C55194
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB4221569
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="DvyaBcQJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgDXOCs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728463AbgDXOCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C39C09B046
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:47 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so10980466wrx.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g8U0XNbBq8ssolXmS0TLiEjhDwf6nz3yMHXDCMAD7sc=;
        b=DvyaBcQJNGWVZFD/KC3yEryBXIDwQgzX41kqbDE1JtzMJeRsGTiVE4RWEsUE2jKI4d
         WfDzZKJ+X8l2lVeS4suyru8mstxkQJUBzRsPR2D2bUZsWxsmfnuNRDPJyxTpUggfQIx6
         NODPu6tDNArn+nEEPr+O+0cBOsAzVuw1C4uGje7mWI9Z9J8WROFtBgOnMjS9N65wsNrW
         CtZIA5Q5x7bH+Jlpq00ngCzFugkIVG+kXL3DpgsRkNA7BE8qkrntot8y6mARKJXaE0EC
         N5F3X/CI5wuyMldZo4zqKO6yXtXKuc5cYn1zmUrW8CelFcfYh3c3gJbPtZtdW2y8D0Yi
         gtDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g8U0XNbBq8ssolXmS0TLiEjhDwf6nz3yMHXDCMAD7sc=;
        b=h0U4tZ80ADTJuZcSbHYedJyXfiTK1Dcd0RfIVbNueF5odIEkkYfgBA0mil6tt48aFA
         qBy0G9NfyzqRTDN+sEPeYXIz8Mj0BJpUZNu1gBPcsEQSNI2VZO+BcpUkFgORSp+WDLcH
         74ktIkcRYf9+CnhWmGBH99alnD1I/UU1uVqufMKmrhuUVPu+6L4mRtPhSQ8pJIEQBHcS
         qtQ80pthBCec5TCJRHUOukTI3FJD2cGGsG//pbC4wLA5LhkSxER0KnGdkK2LolHhVe9l
         vNXCfSD/XMTLHEgUgHk1eFOYeWmLyIw8+NAUCk2Rq6JjPFLZOR+jGckMAenGeITsVy16
         D9eQ==
X-Gm-Message-State: AGi0PuYtorOpBXIyJh3KuQmJXhGtBClaVFuj6k0j2F6rYg0B3dWcIuBI
        BzITdepM5tMni1Kh6Mtqy8mKGA==
X-Google-Smtp-Source: APiQypKpesTpZF+Cl8O0C7Cg5hyDE+qe5ZCnpiV8wq9RtKMvRqWamf8VuzxeA/XldX6c4hfQW95pXg==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr12047098wrw.351.1587736966051;
        Fri, 24 Apr 2020 07:02:46 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:44 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 10/14] crypto: sun8i-ce: rename has_t_dlen_in_bytes to cipher_t_dlen_in_bytes
Date:   Fri, 24 Apr 2020 14:02:10 +0000
Message-Id: <1587736934-22801-11-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
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
index 80f7918fbea8..8bc669f18010 100644
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

