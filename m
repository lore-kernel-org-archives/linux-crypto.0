Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABF9C33C8C
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B078207FD
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 19:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgK48k3V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgAFTcN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 14:32:13 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45947 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFTcM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 14:32:12 -0500
Received: by mail-wr1-f67.google.com with SMTP id j42so50993605wrj.12;
        Mon, 06 Jan 2020 11:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8o2sKD5F6r3n9vP99rpxAg/yvqUr2DBBH2v8mEkde6I=;
        b=cgK48k3VEm1ZZSOwvZZXnLvzdte4R7HCAi9cjvE1hg14+B4gbzHfe5gKggshw0KRgG
         zWRQa/KGy1uOzgO4qrQyEwRJdoZhn/cDL9yd3jwKvnumeeMhqNmRXCe+HEcsvgkDkQhT
         YT8NqKFKPzKPXLZbTRDVZVasjCsDY6gKYyiy70xHW0yDnxM6OHEkfyySsZKkFGUEQH6+
         BBMo54zdnX++k0D4Qc8eE4W9LaeXfU/sJdisHCVRABjux0Z3jzK3Z5kJzQWmygRn+49Q
         3kAU17KywWRH8kNtb58EyGbM8rguEYFW8kpyzqsVGf6Ns24mXKpcFAxgW2+QhEWdAhSw
         muJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8o2sKD5F6r3n9vP99rpxAg/yvqUr2DBBH2v8mEkde6I=;
        b=N4JVbrIltyaCTZnOJIcvGR+ulhiKWoygYE9hry215zwpI5zEv15QUvubLKKFwwheqH
         haaRXQE1XY5f6hE+ogkdMHnUvMFnGrl0VuHzs1qfyXXKjXtQ//fuYRJ0tub4jwHv4bg6
         JIoO7a2qxTvg2CojVf7DiHYdSjvLOyNvNq4IEVPwCvQvBkM0HsFygO2vbPuaf7FO/7Fs
         6hbhaGSN7TTFhPtE3tqP/tCzaIlaNQ8L7t/m73nugtuVFPdjDIP0WN6eDOOQiI5jTcyP
         vkmfIpLA4XLIrt0AvwO38+eVPBybxhV+CNrENW6qr4GmW1VCnqePOIS7YOhhVSJb3Z5M
         L7PA==
X-Gm-Message-State: APjAAAUyigah00omYSnJsCLIwSE1u+GymJi2xzIF0FWiU4VY/x+Kc0Bv
        MYJgpMdy7BBjkG4K7GtGHbQ=
X-Google-Smtp-Source: APXvYqxtiAnjS9xP3tqTG2THQF5l24EjHH58DXeaAWMYglXCec6eS/XofGQ04SMvGbMB+eteCGA/iw==
X-Received: by 2002:adf:c145:: with SMTP id w5mr104778252wre.205.1578339131597;
        Mon, 06 Jan 2020 11:32:11 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r68sm22143312wmr.43.2020.01.06.11.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 11:32:11 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun8i-ce: remove dead code
Date:   Mon,  6 Jan 2020 20:32:08 +0100
Message-Id: <20200106193208.4367-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some code were left in the final driver but without any use.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 5 -----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        | 8 --------
 2 files changed, 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 37d0b6c386a0..75e2bef2b363 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -144,11 +144,6 @@ static int sun8i_ce_cipher(struct skcipher_request *areq)
 	cet->t_sym_ctl = cpu_to_le32(sym);
 	cet->t_asym_ctl = 0;
 
-	chan->op_mode = ce->variant->op_mode[algt->ce_blockmode];
-	chan->op_dir = rctx->op_dir;
-	chan->method = ce->variant->alg_cipher[algt->ce_algo_id];
-	chan->keylen = op->keylen;
-
 	addr_key = dma_map_single(ce->dev, op->key, op->keylen, DMA_TO_DEVICE);
 	cet->t_key = cpu_to_le32(addr_key);
 	if (dma_mapping_error(ce->dev, addr_key)) {
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 43db49ceafe4..8f8404c84a4d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -131,12 +131,8 @@ struct ce_task {
  * @engine:	ptr to the crypto_engine for this flow
  * @bounce_iv:	buffer which contain the IV
  * @ivlen:	size of bounce_iv
- * @keylen:	keylen for this flow operation
  * @complete:	completion for the current task on this flow
  * @status:	set to 1 by interrupt if task is done
- * @method:	current method for flow
- * @op_dir:	direction (encrypt vs decrypt) of this flow
- * @op_mode:	op_mode for this flow
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
  * @stat_req:	number of request done by this flow
@@ -145,12 +141,8 @@ struct sun8i_ce_flow {
 	struct crypto_engine *engine;
 	void *bounce_iv;
 	unsigned int ivlen;
-	unsigned int keylen;
 	struct completion complete;
 	int status;
-	u32 method;
-	u32 op_dir;
-	u32 op_mode;
 	dma_addr_t t_phy;
 	int timeout;
 	struct ce_task *tl;
-- 
2.24.1

