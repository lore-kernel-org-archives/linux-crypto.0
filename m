Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C08C43217
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 21:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiAZVFA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 16:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiAZVE6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 16:04:58 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F91C06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso4568982wmj.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=snYrFJ12aUfxHMb2aqbQr58aBrO9I7pzj7+8V1Dw+/A=;
        b=4ulCosohtZpKHKk1OWZvg15RfCT5UKS1+RX7vVL4SOremHHI031JCQQpK4rmR26rrz
         sncnRcjqlcn/aNLuhLe4gpkJdGxAwSaAVhujtXACxeo0tMhyIzkskAWEDshjgajbUUoL
         MbRYqeK7HlPbBOuLGz2L6FtBtVuHO34J9qm0UEcmJkTXsxGQbUKvq+K8PWToMHofCpNG
         wd+ln/PqR7hEzYAsc9qOup9JfzLBm7EN+RLBDTgA+lb5G0AnXlIjaGZhzAMnW5gxEoKx
         c/dstabSdqeOY1eOIDthWf6qFk12kiX5Hfz5wlAg5/tyBbYSkbpR6JTqUYSVEBVkWTh3
         zOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=snYrFJ12aUfxHMb2aqbQr58aBrO9I7pzj7+8V1Dw+/A=;
        b=IRLa6T5phKDY75Ue2kFL3HsXfmDjMMxLrrYBRhMCFR3mUE6iLBXsC6FRok2NaaGgFe
         PkiKjH0HWX7hvKhjaV6h799WKpVPN9f2hmiiB+wY+5fmxM//kbw1CxVr8fncNi9H6OuM
         TcPpOJuPoxfgz+GT2RPDzt+o1B9x3xADgjy+uG58rt6pHVtHbVBuZeBlROUoyvS0Z+yA
         x9m0WZUwr6kwMWqVFRH7LhXKf6XVt98KTawRjQyK3Lc2gb4IYdVAdcW/E3wo3C/Tbq+X
         tpmLMNfFF3t/IHfCOwMTgB3XmzyoUNmoW3v13HebPa6lOWZ68Bmt16E+bqe1I+CV41WV
         F9Dg==
X-Gm-Message-State: AOAM531B+3jjJjvmFsoaYbYttFDzWmnNr54XnZQoZnbiv0b89VhlFqDv
        6Yd9iz4oygsPL4t4saBN29HuGA==
X-Google-Smtp-Source: ABdhPJw+yWKxm6iGT9HIPz6Vr8isQ+lpFIiKvyXZgf1R+aoAldml+w5ZXDElVXNYI3y5J0Jnqz5IVA==
X-Received: by 2002:a7b:c3c3:: with SMTP id t3mr488729wmj.94.1643231095799;
        Wed, 26 Jan 2022 13:04:55 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j19sm4948611wmq.17.2022.01.26.13.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:04:55 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@gmail.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 6/8] crypto: sun8i-ss: remove redundant test
Date:   Wed, 26 Jan 2022 21:04:39 +0000
Message-Id: <20220126210441.3661782-7-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126210441.3661782-1-clabbe@baylibre.com>
References: <20220126210441.3661782-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some fallback tests were redundant with what sun8i_ss_hash_need_fallback() already do.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index ef3020bc9547..7ebd11d3ff7d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -287,21 +287,11 @@ int sun8i_ss_hash_digest(struct ahash_request *areq)
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct crypto_engine *engine;
-	struct scatterlist *sg;
-	int nr_sgs, e, i;
+	int e;
 
 	if (sun8i_ss_hash_need_fallback(areq))
 		return sun8i_ss_hash_digest_fb(areq);
 
-	nr_sgs = sg_nents(areq->src);
-	if (nr_sgs > MAX_SG - 1)
-		return sun8i_ss_hash_digest_fb(areq);
-
-	for_each_sg(areq->src, sg, nr_sgs, i) {
-		if (sg->length % 4 || !IS_ALIGNED(sg->offset, sizeof(u32)))
-			return sun8i_ss_hash_digest_fb(areq);
-	}
-
 	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
 	ss = algt->ss;
 
-- 
2.34.1

