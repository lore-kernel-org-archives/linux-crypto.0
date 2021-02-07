Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81674C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51CEE64E42
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhBGOmS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBGOla (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:30 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA7FC061221
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:56 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id u16so5818138qvo.9
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=veORIMbTEFHdV2ZFA+S4kEqUqMfKyKjfNRJMTAEVlAONkV2h5bwCaHF3o9lCgPjfFb
         EJIYZZBFcFhsE+mnA4rdIKkppadaNlyCpp4ZoeiueOvoGJ+BBPJPpMCg/oopX/tMdU4k
         GorzXEKwPixX/LLKL6FbW4GPvfRshWd8T8J/Ak63guKJSWL5O/3Qycm+ti+q9y/vI4MB
         Km6FCq47E9QImjzb1P3QQlioEPjq5Cxlc+I3cRp61L2J8VI0wY+2UiZkXJ1zzl8R2GNt
         8vOXhAksSFd2wew/MXWwXO+9IZZmJMgDEz9+r8OALJUMCFp4p6aU9odGTWTH+6ZlnBKv
         O9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4BViZmMHUNQYYu9VpJJKST4ly897JCfdbGhTeJJKpE=;
        b=i4slo6RJ7x3ejd4zivQZ/x7ObBYXMgDlxty2dZtZU8dgGTtKRZ/L2SvajbGOK3OP6t
         wwdJJ1zikZ3E0qY86Lx4Wq04sq8WrGI5wOc20YHOf3e/uPHLXQMmxz8n9mwVo6W/WqDT
         d6BlMeowz+tx+A+tUo3JnuHOth8FkKVbz5rhu1LntDPYkFQdQL00UM3ddNqNKAqtsBWk
         b1PlLUwo2Ik11frV1hRoqWVicZ9xX5QQxci3eEPzl/En1J974vW3fP1ocU6TxbRo+YSf
         icxNYCCtL0ym8ezzHisxONGg0wUzBCVuIKOLy5zRssVVk0NRpBYfQ0/y7UTrZVea1g5O
         XGgg==
X-Gm-Message-State: AOAM532TAWfvIrlLBCU2LKfbNk29Uh6ixGE7u+v1tpVqgJ/jDqIV5E9s
        XvBzM7Wca0yMyvDl1RpinkvXnQ==
X-Google-Smtp-Source: ABdhPJzeSgh2p+L/L8h1gjw16RyNB+thQjs39W/uAo60+eoIlMsLixTMZakTLAeIhiYcy6WxhKioLg==
X-Received: by 2002:a05:6214:1341:: with SMTP id b1mr12650305qvw.57.1612708796200;
        Sun, 07 Feb 2021 06:39:56 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:55 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 09/11] crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Sun,  7 Feb 2021 09:39:44 -0500
Message-Id: <20210207143946.2099859-10-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the register REG_ENCR_XTS_DU_SIZE to cryptlen for AES XTS
transformation. Anything else causes the engine to return back
wrong results.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
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

