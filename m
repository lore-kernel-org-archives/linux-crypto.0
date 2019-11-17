Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA58DC432C3
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 16:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4CCF20730
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 16:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="pG+7ldUt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfKQQKC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 17 Nov 2019 11:10:02 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53545 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbfKQQKC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 17 Nov 2019 11:10:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id u18so14850722wmc.3
        for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2019 08:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=r75CWfA1X0sIcmZW5tWDpI9Z4F5uola06SzlvQ/omrc=;
        b=pG+7ldUt2UFM7+cJJkkiAankeXHQEzrKg5pZFTA1A9LVockjLgz2WPBvZIRzOgCQU/
         i2hjEuEFUvbXEEG4FJMMTrodoBl0AiKdaJit/y6PBrGym+C7c97oEpsBeCzv9AVpz1Y9
         Mj0WJD4J5ISW8727siRT0B9r5r3S3bF+vIfpRvcQAu5o2C3ZWhaeufv7Xamwk/6Sxax2
         jtP6OIFftD7chEvBEC3gRQtiLeknreXTPPtvy7D2gjc5oo5CiWX3Fp+yVNXpBW9j3Iof
         xcPgs7i61te1UlmEJtPo+n9n5R6KX9TAoGQB5DeiGKIqZwz3wdvVFIW25m3jBmAV++4C
         gWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r75CWfA1X0sIcmZW5tWDpI9Z4F5uola06SzlvQ/omrc=;
        b=qdr6r1DXQV33OETbh2kvRXz9XbxcZkC/BcdJg8J52rL+4VH+ChctQcAShQL+Y9nmHI
         ph2EGAIe022esfcvzGCSPzhtpckyn5RXafq8Wo+DQpUqKYltLQQmUK+xkmEV3Nk/dWJu
         oSIqEYe4xmXAOqsiXdw89vOv83kyzzwLfXgOrOxutC3UR05lkaWQ8MQsLO2BkatXjbdl
         QStJGchiL8ZNZXxYNF60qkXzobnwgFYKxKn/2E9EliRlrovwiahJF6XUrrrAOOXyc1MM
         M5IztAaAU6hVigi8JCOOCu8f29LpvU3k5C+4pZut4tVDzx9R0OkUx8L5+VIhD9MVUboS
         3DdQ==
X-Gm-Message-State: APjAAAWLF/ZsdkPt8buCCj8dloNQ4fFzY7gW59zCDdT9DCKbw12uanEc
        YI+gl5MJGO2f1Pa8DBXpY7hvdA==
X-Google-Smtp-Source: APXvYqz0jtaJot5k11NPTvFCDVrV0UF47Ijh5rByeWF3EmaXYXIYY9ASxbnWP6wbGlFO0kqh2PWa5g==
X-Received: by 2002:a1c:9a81:: with SMTP id c123mr23816158wme.118.1574006999634;
        Sun, 17 Nov 2019 08:09:59 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id j10sm19942357wrx.30.2019.11.17.08.09.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:09:58 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        narmstrong@baylibre.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: amlogic: enable working on big endian kernel
Date:   Sun, 17 Nov 2019 16:09:53 +0000
Message-Id: <1574006993-27022-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On big endian kernel, the GXL crypto driver does not works.
This patch do the necessary modification to permit it to work on BE
kernel (removing bitfield and adds some cpu_to_le32).

Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 26 +++++------
 drivers/crypto/amlogic/amlogic-gxl.h        | 51 +++++++++------------
 2 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 1ddb14e9a99a..e589015aac1c 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -101,6 +101,7 @@ static int meson_cipher(struct skcipher_request *areq)
 	unsigned int keyivlen, ivsize, offset, tloffset;
 	dma_addr_t phykeyiv;
 	void *backup_iv = NULL, *bkeyiv;
+	__le32 v;
 
 	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
 
@@ -165,11 +166,11 @@ static int meson_cipher(struct skcipher_request *areq)
 		desc = &mc->chanlist[flow].tl[tloffset];
 		memset(desc, 0, sizeof(struct meson_desc));
 		todo = min(keyivlen - eat, 16u);
-		desc->t_src = phykeyiv + i * 16;
-		desc->t_dst = i * 16;
-		desc->len = 16;
-		desc->mode = MODE_KEY;
-		desc->owner = 1;
+		desc->t_src = cpu_to_le32(phykeyiv + i * 16);
+		desc->t_dst = cpu_to_le32(i * 16);
+		v = (MODE_KEY << 20) | DESC_OWN | 16;
+		desc->t_status = cpu_to_le32(v);
+
 		eat += todo;
 		i++;
 		tloffset++;
@@ -208,18 +209,17 @@ static int meson_cipher(struct skcipher_request *areq)
 		desc = &mc->chanlist[flow].tl[tloffset];
 		memset(desc, 0, sizeof(struct meson_desc));
 
-		desc->t_src = sg_dma_address(src_sg);
-		desc->t_dst = sg_dma_address(dst_sg);
+		desc->t_src = cpu_to_le32(sg_dma_address(src_sg));
+		desc->t_dst = cpu_to_le32(sg_dma_address(dst_sg));
 		todo = min(len, sg_dma_len(src_sg));
-		desc->owner = 1;
-		desc->len = todo;
-		desc->mode = op->keymode;
-		desc->op_mode = algt->blockmode;
-		desc->enc = rctx->op_dir;
+		v = (op->keymode << 20) | DESC_OWN | todo | (algt->blockmode << 26);
+		if (rctx->op_dir)
+			v |= DESC_ENCRYPTION;
 		len -= todo;
 
 		if (!sg_next(src_sg))
-			desc->eoc = 1;
+			v |= DESC_LAST;
+		desc->t_status = cpu_to_le32(v);
 		tloffset++;
 		src_sg = sg_next(src_sg);
 		dst_sg = sg_next(dst_sg);
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index fd9192b4050b..b7f2de91ab76 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -26,43 +26,34 @@
 
 #define MAXDESC 64
 
+#define DESC_LAST BIT(18)
+#define DESC_ENCRYPTION BIT(28)
+#define DESC_OWN BIT(31)
+
 /*
  * struct meson_desc - Descriptor for DMA operations
  * Note that without datasheet, some are unknown
- * @len:	length of data to operate
- * @irq:	Ignored by hardware
- * @eoc:	End of descriptor
- * @loop:	Unknown
- * @mode:	Type of algorithm (AES, SHA)
- * @begin:	Unknown
- * @end:	Unknown
- * @op_mode:	Blockmode (CBC, ECB)
- * @block:	Unknown
- * @error:	Unknown
- * @owner:	owner of the descriptor, 1 own by HW
+ * @t_status:	Descriptor of the cipher operation (see description below)
  * @t_src:	Physical address of data to read
  * @t_dst:	Physical address of data to write
+ * t_status is segmented like this:
+ * @len:	0-16	length of data to operate
+ * @irq:	17	Ignored by hardware
+ * @eoc:	18	End means the descriptor is the last
+ * @loop:	19	Unknown
+ * @mode:	20-23	Type of algorithm (AES, SHA)
+ * @begin:	24	Unknown
+ * @end:	25	Unknown
+ * @op_mode:	26-27	Blockmode (CBC, ECB)
+ * @enc:	28	0 means decryption, 1 is for encryption
+ * @block:	29	Unknown
+ * @error:	30	Unknown
+ * @owner:	31	owner of the descriptor, 1 own by HW
  */
 struct meson_desc {
-	union {
-		u32 t_status;
-		struct {
-			u32 len:17;
-			u32 irq:1;
-			u32 eoc:1;
-			u32 loop:1;
-			u32 mode:4;
-			u32 begin:1;
-			u32 end:1;
-			u32 op_mode:2;
-			u32 enc:1;
-			u32 block:1;
-			u32 error:1;
-			u32 owner:1;
-		};
-	};
-	u32 t_src;
-	u32 t_dst;
+	__le32 t_status;
+	__le32 t_src;
+	__le32 t_dst;
 };
 
 /*
-- 
2.23.0

