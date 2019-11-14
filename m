Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CF7C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 12:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2E9206E1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 12:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a5edst1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfKNM64 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 07:58:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45889 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfKNM64 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 07:58:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id z10so6328460wrs.12;
        Thu, 14 Nov 2019 04:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/yZewMOwSUNa5I83y+T0aelSU0qIk8Vc3mk35F3rOY=;
        b=a5edst1XV+upr79EpSARNH1rcJkMpsPeGN84GGciH7M7yuP8Ervh7VUSJYq+WVKxLl
         x3ofgMaRe2fgA/pSIFcPQbQ670Tr5EWECXLBtgWD3St5nKubOs1Z53ELy/18R/pYV4e1
         fsjOb2T7iMRnEyix3y5GwW+XFZDVO62MUDXuN4ZHA8R5qXIEO9/F25XYYCTlJohA6Cls
         kjsPKGSBO7QO36AlDPM7Rfsx0Cs2PvqDoaNC428RZ0buJODbIDvC3OtbO4Y3CgrEiDJs
         yX2h1uoiMg4Qw6tPkAXQzFg0bc/AhzAU1fnKWTpEuiS3sFHGOQCmtsYrQphr59MTUSEb
         AXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/yZewMOwSUNa5I83y+T0aelSU0qIk8Vc3mk35F3rOY=;
        b=lclJhkgjRFvObiSu+gcPGiCa4CWbcX1E4payv4qvE1aEq6hd8DIG0LTKsBUPQV84jZ
         j9/fLPJEJUmdc43xOYgVaahx3LaGwOT59hzZ6z/CIZP7MJ80p+9LgMKa8sDaUfYS8iTe
         IShWy9IJaXBFUDR9/3EtUBxVTAkcFsOVRdiHRfX6OoNciNKyLBwfueH1M5q7XVlqWdOM
         KRyO3L2lSTbbHuhbgV1zqo5lvmg4Dq0Ht3p2CwEo0nPxqlG8yWWI6Fk4qoEHr6kgOr7a
         7qkaj/KdtuNerB2w1NGa56rzntzkT1puCQx37qzLbD7QGiAC8l105jrwEcPHU1pzMiZq
         C1wQ==
X-Gm-Message-State: APjAAAXaNU+Ju1EbeI5Vv7kyzFneET+L3rkTRx8mcvdp1qYrrDzDVLeb
        svBLVMuXmtFiQKtuxtngM2w=
X-Google-Smtp-Source: APXvYqwCsRaLS7yOkF7Xv7eprjPRs8ArvDI7XkSFkV6AXyxJaxxVH5FbEacxPkmt+Da39iMiBhecUg==
X-Received: by 2002:adf:f18e:: with SMTP id h14mr8497661wro.348.1573736332664;
        Thu, 14 Nov 2019 04:58:52 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id z6sm7540220wro.18.2019.11.14.04.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 04:58:51 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: sun4i-ss: fix big endian issues
Date:   Thu, 14 Nov 2019 13:58:49 +0100
Message-Id: <20191114125849.22829-1-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When testing BigEndian kernel, the sun4i-ss was failling all crypto
tests.
This patch fix endian issues with it.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index ec5d9ce24bb8..b233f67f491f 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -187,7 +187,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	 */
 	unsigned int i = 0, end, fill, min_fill, nwait, nbw = 0, j = 0, todo;
 	unsigned int in_i = 0;
-	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, wb = 0, v, ivmode = 0;
+	u32 spaces, rx_cnt = SS_RX_DEFAULT, bf[32] = {0}, v, ivmode = 0;
 	struct sun4i_req_ctx *op = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun4i_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
@@ -196,6 +196,7 @@ static int sun4i_hash(struct ahash_request *areq)
 	struct sg_mapping_iter mi;
 	int in_r, err = 0;
 	size_t copied = 0;
+	__le32 wb = 0;
 
 	dev_dbg(ss->dev, "%s %s bc=%llu len=%u mode=%x wl=%u h0=%0x",
 		__func__, crypto_tfm_alg_name(areq->base.tfm),
@@ -407,7 +408,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 		nbw = op->len - 4 * nwait;
 		if (nbw) {
-			wb = *(u32 *)(op->buf + nwait * 4);
+			wb = cpu_to_le32(*(u32 *)(op->buf + nwait * 4));
 			wb &= GENMASK((nbw * 8) - 1, 0);
 
 			op->byte_count += nbw;
@@ -416,7 +417,7 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the remaining bytes of the nbw buffer */
 	wb |= ((1 << 7) << (nbw * 8));
-	bf[j++] = wb;
+	bf[j++] = le32_to_cpu(wb);
 
 	/*
 	 * number of space to pad to obtain 64o minus 8(size) minus 4 (final 1)
@@ -435,13 +436,13 @@ static int sun4i_hash(struct ahash_request *areq)
 
 	/* write the length of data */
 	if (op->mode == SS_OP_SHA1) {
-		__be64 bits = cpu_to_be64(op->byte_count << 3);
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__be64 *bits = (__be64 *)&bf[j];
+		*bits = cpu_to_be64(op->byte_count << 3);
+		j += 2;
 	} else {
-		__le64 bits = op->byte_count << 3;
-		bf[j++] = lower_32_bits(bits);
-		bf[j++] = upper_32_bits(bits);
+		__le64 *bits = (__le64 *)&bf[j];
+		*bits = cpu_to_le64(op->byte_count << 3);
+		j += 2;
 	}
 	writesl(ss->base + SS_RXFIFO, bf, j);
 
@@ -487,7 +488,7 @@ static int sun4i_hash(struct ahash_request *areq)
 		}
 	} else {
 		for (i = 0; i < 4; i++) {
-			v = readl(ss->base + SS_MD0 + i * 4);
+			v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
 			memcpy(areq->result + i * 4, &v, 4);
 		}
 	}
-- 
2.23.0

