Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23295C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E83202468C
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 14:00:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EUO5m76U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgANOAX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:00:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34765 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgANN76 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 08:59:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id w5so2378446wmi.1;
        Tue, 14 Jan 2020 05:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjPV4Ha5BYE0MCX17Wl6xnLI6QAy5DnWASz8VTCVvYQ=;
        b=EUO5m76UvmdUwWtNzcIKhgu1b3wsytiLJXK+nCU8Jd+QLUFj3sjQ6tp4GDPLdz01Tk
         CqD2W85UbyrcCOMSjLf/dFpOusOr7BW9TGliVE1RP6bXsB8Sxe8ahdtC2GAFpvVWPHtu
         huctNx72GCsTAiGkF1SCKWPEXR1HgUR4pAxwdKl8372GYVvlcoKFEIjoubnexI0StKy6
         x656qiDvIBYjjnHT10RUOQDzOjyDF4tIiOjDG3EtntrJNHGhnm/SU9hhc3qJmCNhKtuH
         mUG4dI9ncJ9bO9nTWh1qxkJkNIl9HucXdHS5WgPs9si0eKsDk+9KCo/JNtoxvjSE9hva
         LINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjPV4Ha5BYE0MCX17Wl6xnLI6QAy5DnWASz8VTCVvYQ=;
        b=ZBE7vZM9HVNLRuZmt9dln8hZtzG/Us4DLZr+UkHN7nm4HMJvN4Gqrl2wRu119GoQfl
         Eb9uRuejZQePAs8jFmSExHCdaC1xF+0h/NnubT9CY4tz+Vg/+CRtwOojC6ofk1Rh3Qpb
         gp+MwiT9p5gNYN5OTWZlSG+39b9Z82sEeL/E+Ol8wu8L3pm9ybxY0G0E882c/ckB3f8c
         WkMR5hRpDvFQT0n3QyrTKZ/joAK+VRre6nfAeHfGqVspHI3PcU5cDpZZJUUwOkppVJXN
         nkSaz/NGPu8B0ZkewieLw5gRkchdcStg28nnGTeh/zqZDt4m075m6iRIlnwyBpy4mQO+
         h2zQ==
X-Gm-Message-State: APjAAAWxKCwXYbGOKXbGWrRqd1S8ymmvzKMRPXtfLPd4pzq/0psrM+MQ
        MFPePSigY86y5dUpyx5ZBsY=
X-Google-Smtp-Source: APXvYqzVCraPGaXbAoGqhP1ygDTY7R+QHVftrzEYOGKAwqSEbThaIsz0cQp5wFfFNd9DXBamDMmh5Q==
X-Received: by 2002:a1c:62c1:: with SMTP id w184mr28138545wmb.150.1579010396021;
        Tue, 14 Jan 2020 05:59:56 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 4sm17854448wmg.22.2020.01.14.05.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 05:59:55 -0800 (PST)
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
Subject: [PATCH RFC 04/10] crypto: sun8i-ce: introduce the slot number
Date:   Tue, 14 Jan 2020 14:59:30 +0100
Message-Id: <20200114135936.32422-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the slot position, for choosing which task in the task
list should be prepared/unprepared.
The slot is for the moment is always 0 until the infrastructure will handle
non 0 value.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 6 ++++--
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 401f39f144ea..9c1f6c9eaaf9 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -96,6 +96,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int flow, i;
 	int nr_sgs = 0;
 	int nr_sgd = 0;
+	int slot = 0;
 	int err = 0;
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
@@ -114,7 +115,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 	chan = &ce->chanlist[flow];
 
-	cet = chan->tl;
+	cet = &chan->tl[slot];
 	memset(cet, 0, sizeof(struct ce_task));
 
 	cet->t_id = cpu_to_le32(flow);
@@ -301,11 +302,12 @@ static int sun8i_ce_cipher_unprepare(struct crypto_engine *engine, void *async_r
 	unsigned int ivsize, offset;
 	int nr_sgs = rctx->nr_sgs;
 	int nr_sgd = rctx->nr_sgd;
+	int slot = 0;
 	int flow;
 
 	flow = rctx->flow;
 	chan = &ce->chanlist[flow];
-	cet = chan->tl;
+	cet = &chan->tl[slot];
 	ivsize = crypto_skcipher_ivsize(tfm);
 
 	if (areq->src == areq->dst) {
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index e8bf7bf31061..bd355f4b95f3 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -120,7 +120,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 	/* Be sure all data is written before enabling the task */
 	wmb();
 
-	v = 1 | (ce->chanlist[flow].tl->t_common_ctl & 0x7F) << 8;
+	v = 1 | (ce->chanlist[flow].tl[0].t_common_ctl & 0x7F) << 8;
 	writel(v, ce->base + CE_TLR);
 	mutex_unlock(&ce->mlock);
 
-- 
2.24.1

