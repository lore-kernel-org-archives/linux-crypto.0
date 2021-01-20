Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922BDC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FC6233EB
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 19:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391917AbhATTSV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392096AbhATSuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 13:50:50 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA7BC061795
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:50 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id d15so11590267qtw.12
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jan 2021 10:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ckoNO1YJt5QKI0zTcMaiAvFZHq1fWNUxmCXeDkmSik=;
        b=sPpCMyU5a/KbiaJEZnuL75dHd3hNUe5y2Qm6K2Tygsn0dLPHKWCEcibvsA75MTKTpP
         s8hUQV1RREpcP+iJBh4k2an/TDE6qPYsHXDCH0Lqh74plPbvzyS30bHiIc2iOmTjdySx
         ZWS4BaBYfaUd3X6oN/ljIJSCwsQ0LaG+JpQdn72u3RspT1sdON+Nw8Ooq/bu9Hx7ucZ5
         skjek77aXLjVyShV0pGYb+8CAf50A/aBn+my1BD0OqjNZM1/STccUR6yQTzfHfp+kSjd
         smA5Z/s1tvK8hafVPNppx08HXa4YUz1SoBnm/5gAF6nNEL0ORirFKAc4F7CAjPH/k1xo
         e20A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ckoNO1YJt5QKI0zTcMaiAvFZHq1fWNUxmCXeDkmSik=;
        b=CpZh1eNPpwIdzBKdoasyJceFNWUeObCDDAaoG3eYyxval5p/yDhF5Ym4HU52OrheWG
         z5cDwGrLvkq+59FUQtinbAs/PzqXn3d9YRhtyIQMEfsT82xfpklPkQxkDD0nGlwX//+A
         gZy246A/dKFsb9byLI3eMN7JUuJaG/stSZFLpEJOwFwZbk9OsQChN1+QcFJAi3VIk8A7
         cMHC3H59PjbmM/piP7oLZorxG9esQP3VdmpmLv3Fpa6/LhxWYWQImgYzIH5b1R/BPzaK
         wKtWy6nizZTPL2VExWbhrNFxdcS1D66i9PbXeG7eo+p9me6K56nI7kSbvvCIFvMpDBjT
         jo+A==
X-Gm-Message-State: AOAM530RsRXeSUcR+SRQx6iDzPZdJR8eD1DGeA0hqOgWUO2mHsS/+f50
        8dWXplL5jg0G6tvLvmv2t9RdUA==
X-Google-Smtp-Source: ABdhPJxUwOEs2lcO5h+zfhLY+6rFbR/C19jbgImjc6kM5gI//Eqx33qYWRewdzyvcPdlg/yxiOtKSg==
X-Received: by 2002:ac8:5852:: with SMTP id h18mr10039542qth.357.1611168529688;
        Wed, 20 Jan 2021 10:48:49 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id w8sm1769903qts.50.2021.01.20.10.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 10:48:48 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] drivers: crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Wed, 20 Jan 2021 13:48:41 -0500
Message-Id: <20210120184843.3217775-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210120184843.3217775-1-thara.gopinath@linaro.org>
References: <20210120184843.3217775-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the register REG_ENCR_XTS_DU_SIZE to cryptlen for AES XTS
transformation. Anything else causes the engine to return back
wrong results.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index a73db2a5637f..f7bc701a4aa2 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -295,15 +295,15 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
 {
 	u32 xtskey[QCE_MAX_CIPHER_KEY_SIZE / sizeof(u32)] = {0};
 	unsigned int xtsklen = enckeylen / (2 * sizeof(u32));
-	unsigned int xtsdusize;
 
 	qce_cpu_to_be32p_array((__be32 *)xtskey, enckey + enckeylen / 2,
 			       enckeylen / 2);
 	qce_write_array(qce, REG_ENCR_XTS_KEY0, xtskey, xtsklen);
 
-	/* xts du size 512B */
-	xtsdusize = min_t(u32, QCE_SECTOR_SIZE, cryptlen);
-	qce_write(qce, REG_ENCR_XTS_DU_SIZE, xtsdusize);
+	/* Set data unit size to cryptlen. Anything else causes
+	 * crypto engine to return back incorrect results.
+	 */
+	qce_write(qce, REG_ENCR_XTS_DU_SIZE, cryptlen);
 }
 
 static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
-- 
2.25.1

