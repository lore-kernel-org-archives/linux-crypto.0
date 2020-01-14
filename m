Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A5EFC33CB2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09BD24685
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZGzjrkK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgANOAD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:03 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39330 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbgANOAC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 09:00:02 -0500
Received: by mail-wm1-f67.google.com with SMTP id 20so13832894wmj.4;
        Tue, 14 Jan 2020 06:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+qS8cmFG129sXx7XLwvT27GqZEqHpjOOs5rdHnFSHiU=;
        b=IZGzjrkKewPPH+1qPChWS+BhLPaglsstZcFbIFMqVrWlnEyYo4D//EwlO073t5dWRt
         wsEUkhhhPmT8ar86gm41TZiFZdKhJ2hH3xwEbn3ADew+ZParRG4n8k5o10jGL1LVRUU2
         BrBFsb3E1LCR5wy9kjfteNYmsmUS3a6zFMW85ywB2QE/McqEpFsR6LhS7Q4jCZc/iMUv
         PlIJAqPajK75h7F0rRdhNWoe63r2OhG9YYn/0wMxi/hX/wkIBchGVH/aHmOKmpMenkfJ
         zmjXb4+u1GtLTbLFq3gs2YUvR/hG+0pZd1Z57g5j0ZHtScUCIuDBo32GjFTElntjiR5m
         nDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+qS8cmFG129sXx7XLwvT27GqZEqHpjOOs5rdHnFSHiU=;
        b=q11OWSEesovI4m+PrmHb30wvYAYC7nz1KzpRnOcRUZF9W1C9JDl+iXyHmW0WHxIwGu
         FXz0+2x4dJS6vAXqQ5aKfwaxO48MTKFw5fUceINWEHp0zX9/dZlopz/AorZLIPzAsGVY
         108kCqdTt7S9jlFfDXkbikTpxHyDV4vCCi3avci8wEzWFyHVLrWR4UWNpMNlA9UWUcB8
         N2kJmXTDqxNeiOQB41sAPtI6yeniLrjCZ4loK0N5IFtBRF1jV+De9Gc/vGAJOz4U1RJY
         eqnm6/DBmwwlwN645flm4wJKgspUtwyY4IPtRFgVGWZZQkjQ07AEg8XLWPDwBSBFOh8p
         NBtw==
X-Gm-Message-State: APjAAAVFM5pMxiuHUGsiE8nOu/TQe7i+oMDmXnAqOCpPbr8+UK6dTw7j
        25pQMgIwqsM6fgJJWpfOq4E=
X-Google-Smtp-Source: APXvYqww13Rw2lNgkQnVrqZqhVvYRprXFy6sm0G6g1K6ZSDEAxdwdk/Iiwdc3bXXKo2jLD2F6nJdKg==
X-Received: by 2002:a1c:a702:: with SMTP id q2mr27788126wme.6.1579010400417;
        Tue, 14 Jan 2020 06:00:00 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:59 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     alexandre.torgue@st.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, mcoquelin.stm32@gmail.com,
        mripard@kernel.org, wens@csie.org, iuliana.prodan@nxp.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 07/10] crypto: sun8i-ce: handle slot > 0
Date:   Tue, 14 Jan 2020 14:59:33 +0100
Message-Id: <20200114135936.32422-8-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Handle the fact a slot could be different than 0.
This imply:
- linking two task via next
- set interrupt flag just before running the batch in the last task.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 8 +++++++-
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 ++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 9c1f6c9eaaf9..d56c992fbf93 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -99,6 +99,9 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int slot = 0;
 	int err = 0;
 
+	if (slot < 0 || slot >= MAXTASK)
+		return -EINVAL;
+
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
 	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
@@ -120,8 +123,11 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	cet->t_id = cpu_to_le32(flow);
 	common = ce->variant->alg_cipher[algt->ce_algo_id];
-	common |= rctx->op_dir | CE_COMM_INT;
+	common |= rctx->op_dir;
 	cet->t_common_ctl = cpu_to_le32(common);
+	if (slot > 0)
+		chan->tl[slot - 1].next = cpu_to_le32(chan->t_phy + 176 * slot);
+
 	/* CTS and recent CE (H6) need length in bytes, in word otherwise */
 	if (ce->variant->has_t_dlen_in_bytes)
 		cet->t_dlen = cpu_to_le32(areq->cryptlen);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index bd355f4b95f3..39bf684c0ff5 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -106,6 +106,8 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	ce->chanlist[flow].stat_req++;
 #endif
+	/* mark last one */
+	ce->chanlist[flow].tl[ce->chanlist[flow].engine->ct - 1].t_common_ctl |= cpu_to_le32(CE_COMM_INT);
 
 	mutex_lock(&ce->mlock);
 
-- 
2.24.1

