Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0561C43217
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387472AbiEBUYl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387438AbiEBUXr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:47 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9341E003
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:20:01 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 129so8853908wmz.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gVZKFf6rPDkmO5DXMIf8r+ln13AjKZcUQ+EmJhnMbco=;
        b=vAeTdnHo3qR1FWUwsf55Yu8pevDNugRWHgAMolHx7E8DXRIRmHwHTz8j72yZWy9JL1
         /DFhUMBAtwBCSTM1+dBVlXlmHosxwvoh/VgDPJ1OUt7AsbV5NFbo9clH7nIh9IdfmYQs
         4ak6bMgydmbgchikddawHYISXTOv/TXpt42dUEN5jyQIKjeFSJ2L9VfRd/RyO8RIbaSL
         9DlTuMDb2DQx2n2HfYRirnD/AsBLglHPakph5+N2xOW903EgTzi8W2TlBV89z4ldK7kA
         XYGTQOFj8ZHeracuk2vuVMteU+d3CsNfhUuOT18GlT4rS8oRQHJme8dnuqdpFCxME5yf
         m+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gVZKFf6rPDkmO5DXMIf8r+ln13AjKZcUQ+EmJhnMbco=;
        b=Iq9qwZIwisYzhasNrmNZQWIpVEsLpSF8rtMn7DyTztMufDB4SEDJ70jsBQljR8AMKZ
         0dgHYwCaw7HxLY8e8E7rfrh5ohkjnx/zktcmLTef9IDn+pCbaiGCyBuGNYg5hulAuLjp
         xnkRpiGBDS3EGo6ojxpWJJXNy/bPZ6+czygpmQVOT5IX9nOBJA1VTX3Zn9x27FtdlUVS
         qABa0xUliND/Umc+T5sWTLWLTaOsiAIKfQ6i+ud3F3x7y8c9pp8JxvybbH0VnlodYvJd
         KKfi7+HZctO9twnuHC4r3gkB7V4+wrEZ51ItSPlEVwEkYAN2TS9/8LevVncbJiSDGnOW
         Osig==
X-Gm-Message-State: AOAM5324d8/wIqFU42WaLSLVPUK/qylvSuZ9839cbdgl4UjxVxfWcNbZ
        j15htev7MjyFG9f1mx1V1y8U2g==
X-Google-Smtp-Source: ABdhPJw3HaxpGN8whizH4wdXki0y1JP1MvY1TkcYUphltpBI7YZfTUqOiVT/4q729FA3sZ2p48OI5g==
X-Received: by 2002:a05:600c:2045:b0:394:2457:9c36 with SMTP id p5-20020a05600c204500b0039424579c36mr578104wmg.76.1651522800228;
        Mon, 02 May 2022 13:20:00 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:59 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 19/19] crypto: sun8i-ce: do not fallback if cryptlen is less than sg length
Date:   Mon,  2 May 2022 20:19:29 +0000
Message-Id: <20220502201929.843194-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sg length could be more than remaining data on it.
So check the length requirement against the minimum between those two
values.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 315a62e424d6..74b4e910a38d 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -27,6 +27,7 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	struct scatterlist *sg;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct sun8i_ce_alg_template *algt;
+	unsigned int todo, len;
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
 
@@ -51,28 +52,35 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 		return true;
 	}
 
+	len = areq->cryptlen;
 	sg = areq->src;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 			algt->stat_fb_srcali++;
 			return true;
 		}
-		if (sg->length % 4) {
+		todo = min(len, sg->length);
+		if (todo % 4) {
 			algt->stat_fb_srclen++;
 			return true;
 		}
+		len -= todo;
 		sg = sg_next(sg);
 	}
+
+	len = areq->cryptlen;
 	sg = areq->dst;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 			algt->stat_fb_dstali++;
 			return true;
 		}
-		if (sg->length % 4) {
+		todo = min(len, sg->length);
+		if (todo % 4) {
 			algt->stat_fb_dstlen++;
 			return true;
 		}
+		len -= todo;
 		sg = sg_next(sg);
 	}
 	return false;
-- 
2.35.1

