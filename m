Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DAE7C282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D2D2072A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baGZZ/Rm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgAHPmO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:42:14 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45962 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbgAHPmG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:42:06 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so1271306pls.12;
        Wed, 08 Jan 2020 07:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a0DGQ1NyXBS1YH7DaQs4FMIy+9goKt2JJcyNuNbw5NM=;
        b=baGZZ/RmRfsQfYAN9D3ZwCTZ49xzk10YRBistCKAbvK22uWGkHYdQyAGXnp5QvjIwl
         VQiAVxp7yk2JRNOyddB8rzFk3QIE9HM6VSe5P8QsjDRAB7MWGz5VdHt798pAAI+qMkCV
         3pNKk4Q4s9dFinUE21pf2CR5Yd1/s0GQrVMGjfKtzb9lGMloCVzhuWMR4/4Y7bEJ4kfA
         T85urEyXMiwxXGRwFqQy0mM/ffJyOuCRZcSFHKc65JcCHfQcJxflZ7BZSJ1gBKG5zpya
         SxYs0K8fAdMf1Q2Y0tavcEXEar0SMkc7LrsLJf4iisT+3tRLY6vMCqXPkeokJH4KTz8n
         wxHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a0DGQ1NyXBS1YH7DaQs4FMIy+9goKt2JJcyNuNbw5NM=;
        b=IJzuv1bb+u4W/avCTnRSyfkrHbHh3fofx5ZlNGhO0FdpYlVK4IZ8UCZZwkfxemVEFc
         WaziKNLRUIXyfeqHnJVvjg9J6LiJwZeK+rWFcHRCZREYE67gQyBU4dP8HWju6oQJ9sHP
         4nsbuKmYm5LKGe1pGK1ZCQgtblFIYWG2hpBVUfrnw568seqecIBcCb7bvbW50Tm7JMkt
         AwpN67qQwiZetG9PMkuvdLCHf3y7KYokhWJDTolt08U47bigh7Mfk2ullpobWdiKmNCW
         rLh9+zICu8sUYhoPl69gi2ZNunQlOl8kraAWsifOkdeVXdlIUjHyE725WaZMiJW0jk2f
         FKxg==
X-Gm-Message-State: APjAAAV3eZNMZbqCom8zmWZAonD49D3mOvAn9VzM+9Yp4XLY5QnedKeM
        9SGxJXCO275J8CpwnDWuEU6JkA+U
X-Google-Smtp-Source: APXvYqxefgu5EZ5v1cP9TxmF+1BBmL5QKj+FOMDj+BcprSrAddOwDfj9ipsGJAfNVVXCQIgCjQK+sg==
X-Received: by 2002:a17:902:a40c:: with SMTP id p12mr5911072plq.292.1578498124771;
        Wed, 08 Jan 2020 07:42:04 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:42:03 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 6/7] crypto: caam - enable prediction resistance in HRWNG
Date:   Wed,  8 Jan 2020 07:40:46 -0800
Message-Id: <20200108154047.12526-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200108154047.12526-1-andrew.smirnov@gmail.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instantiate CAAM RNG with prediction resistance enabled to improve its
quality (with PR on DRNG is forced to reseed from TRNG every time
random data is generated).

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c |  3 ++-
 drivers/crypto/caam/ctrl.c    | 22 ++++++++++++++++++----
 drivers/crypto/caam/desc.h    |  2 ++
 drivers/crypto/caam/regs.h    |  4 +++-
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 554aafbd4d11..91ccde0240fe 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -77,7 +77,8 @@ static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
 {
 	init_job_desc(desc, 0);	/* + 1 cmd_sz */
 	/* Generate random bytes: + 1 cmd_sz */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+			 OP_ALG_PR_ON);
 	/* Store bytes */
 	append_fifo_store(desc, dst_dma, len, FIFOST_TYPE_RNGSTORE);
 
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 22d8676dd610..85c2e831839a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -36,7 +36,8 @@ static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
 	init_job_desc(desc, 0);
 
 	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
+			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT |
+			OP_ALG_PR_ON;
 
 	/* INIT RNG in non-test mode */
 	append_operation(desc, op_flags);
@@ -275,12 +276,25 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		return -ENOMEM;
 
 	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		const u32 rdsta_if = RDSTA_IF0 << sh_idx;
+		const u32 rdsta_pr = RDSTA_PR0 << sh_idx;
+		const u32 rdsta_mask = rdsta_if | rdsta_pr;
 		/*
 		 * If the corresponding bit is set, this state handle
 		 * was initialized by somebody else, so it's left alone.
 		 */
-		if ((1 << sh_idx) & state_handle_mask)
-			continue;
+		if (rdsta_if & state_handle_mask) {
+			if (rdsta_pr & state_handle_mask)
+				continue;
+
+			dev_info(ctrldev,
+				 "RNG4 SH%d was previously instantiated without prediction resistance. Tearing it down\n",
+				 sh_idx);
+
+			ret = deinstantiate_rng(ctrldev, rdsta_if);
+			if (ret)
+				break;
+		}
 
 		/* Create the descriptor for instantiating RNG State Handle */
 		build_instantiation_desc(desc, sh_idx, gen_sk);
@@ -302,7 +316,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 
 		rdsta_val = rd_reg32(&ctrl->r4tst[0].rdsta) & RDSTA_IFMASK;
 		if ((status && status != JRSTA_SSRC_JUMP_HALT_CC) ||
-		    !(rdsta_val & (1 << sh_idx))) {
+		    (rdsta_val & rdsta_mask) != rdsta_mask) {
 			ret = -EAGAIN;
 			break;
 		}
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 4b6854bf896a..e796d3cb9be8 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -1254,6 +1254,8 @@
 #define OP_ALG_ICV_OFF		(0 << OP_ALG_ICV_SHIFT)
 #define OP_ALG_ICV_ON		(1 << OP_ALG_ICV_SHIFT)
 
+#define OP_ALG_PR_ON		BIT(1)
+
 #define OP_ALG_DIR_SHIFT	0
 #define OP_ALG_DIR_MASK		1
 #define OP_ALG_DECRYPT		0
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index c191e8fd0fa7..fe1f8c1409fd 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -524,9 +524,11 @@ struct rng4tst {
 	u32 rsvd1[40];
 #define RDSTA_SKVT 0x80000000
 #define RDSTA_SKVN 0x40000000
+#define RDSTA_PR0 BIT(4)
+#define RDSTA_PR1 BIT(5)
 #define RDSTA_IF0 0x00000001
 #define RDSTA_IF1 0x00000002
-#define RDSTA_IFMASK (RDSTA_IF1 | RDSTA_IF0)
+#define RDSTA_IFMASK (RDSTA_PR1 | RDSTA_PR0 | RDSTA_IF1 | RDSTA_IF0)
 	u32 rdsta;
 	u32 rsvd2[15];
 };
-- 
2.21.0

