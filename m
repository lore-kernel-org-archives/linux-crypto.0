Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 039CEC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7EE2071F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3FkiYCW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbfKTQy7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:54:59 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40599 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732932AbfKTQy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:54:58 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep1so90687pjb.7;
        Wed, 20 Nov 2019 08:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1DtsNhw9v1gDBQhovceUYU94x/2uJ8teNAnS6FI6Te8=;
        b=a3FkiYCW6DBeKzfiRotDLAhEy4bHGAdzhJs2OvYhN/vpeN1mLnZ8xYXtqVrdaI4480
         +Aih7x09GQnb7KAEzkQPkBJfN7CLWngL9WmI5kdDwcw9zFaor8D19sSdcfhPk78Gc3UL
         TvzyWZzL2D9HolqyFKiqKY9FrEnXlnihGb5qI7itBBdMrQ6EWRS08mgRVar5PtDvJNub
         Wjq0yPRDU/t9bAvfyZgBBiE9DT1kZVWbrsPowCm6dNxXqsEQ3VDlCFn1X0iEKZ9WlzNZ
         33mJwpDl0eFVPGDDg+BxW/5XPcWVrcOS+fhykgkl9FGyDCWIlsBjITW0jY4DURgEbeE9
         B6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1DtsNhw9v1gDBQhovceUYU94x/2uJ8teNAnS6FI6Te8=;
        b=tPM/+XA1B7HjkG9gqXblRfSX2d6uUPCp17sZDKR8B8+dnQU52OTXCpnqy036WhCVvZ
         khGKZ9VJ7wvWORWC90Fyl/GpdUWsJvBVFfitDZuQ+q3iMDDV1XJ9rANgPGZRhEyq0MHZ
         54zIOnS4ZLZfEtH+nD2lO+1ICYY9MCapjKQRJHTh6LVHpHPNRgEyRUoWdI7t3WTUzmm8
         UtewWRPwdy7tiOtajFZsiA4vsaA4EzXG93veVbAiLKz0l4cNK7ilqFpHPS4LjJUiaJrk
         MbZ5mfm/mXHNeWNYQYmgLUT2lzw2QWUDE5wzU2x6GIGetcbc9zweH+h7C+3jFi5qJQ3U
         xAsQ==
X-Gm-Message-State: APjAAAXbZ5SkKeJ7iU9eHpP6a2uUE7L1RO2bKqva4WYZt1udKEuqzOGd
        NRitbH5ubOQTh4YuZT0vU3LXm7um
X-Google-Smtp-Source: APXvYqx+TkVLOrzoGSzX5bRIAd/sOSJ9Qy74u8zdKIx6k/P6WCmVNCSwjuZdBnY+ONhcWhr3K+l0Hw==
X-Received: by 2002:a17:90a:9286:: with SMTP id n6mr5170984pjo.84.1574268897255;
        Wed, 20 Nov 2019 08:54:57 -0800 (PST)
Received: from localhost.hsd1.wa.comcast.net ([2601:602:847f:811f:babe:8e8d:b27e:e6d7])
        by smtp.gmail.com with ESMTPSA id e11sm29841483pff.104.2019.11.20.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 08:54:55 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v3 2/6] crypto: caam - enable prediction resistance in HRWNG
Date:   Wed, 20 Nov 2019 08:53:37 -0800
Message-Id: <20191120165341.32669-3-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191120165341.32669-1-andrew.smirnov@gmail.com>
References: <20191120165341.32669-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instantiate CAAM RNG with prediction resistance enabled to improve its
quality.

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
 drivers/crypto/caam/caamrng.c | 3 ++-
 drivers/crypto/caam/ctrl.c    | 8 +++++---
 drivers/crypto/caam/desc.h    | 2 ++
 drivers/crypto/caam/regs.h    | 4 +++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e8baacaabe07..6dde8ae3cd9b 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -202,7 +202,8 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Generate random bytes */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+			 OP_ALG_PR_ON);
 
 	/* Store bytes */
 	append_seq_fifo_store(desc, RN_BUF_SIZE, FIFOST_TYPE_RNGSTORE);
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index df4db10e9fca..a1c879820286 100644
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
@@ -275,11 +276,12 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 		return -ENOMEM;
 
 	for (sh_idx = 0; sh_idx < RNG4_MAX_HANDLES; sh_idx++) {
+		const u32 rdsta_mask = (RDSTA_PR0 | RDSTA_IF0) << sh_idx;
 		/*
 		 * If the corresponding bit is set, this state handle
 		 * was initialized by somebody else, so it's left alone.
 		 */
-		if ((1 << sh_idx) & state_handle_mask)
+		if (rdsta_mask & state_handle_mask)
 			continue;
 
 		/* Create the descriptor for instantiating RNG State Handle */
@@ -302,7 +304,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 
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

