Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EC4C3526C
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F12B623BCA
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgLSDcM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLSDbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 22:31:51 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16771C0611CC
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:34 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id 7so2926112qtp.1
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LrTDV1JC3FHqRkPuc+wq4o33QEiL82RGRHhUmIGgN6s=;
        b=FV0bA/glG6mM2oq/0OIUCIVCj6ovoytZ5Qj/7e+wkIWZ2ELS8XCIiKnF6W4r6i7jRT
         CFWxHpAaKVstazgf50GOecmqvoxJ2c/3Af0zFXqfBCUnWWXQ3csgizyva8ZTedaBRUyp
         SlbsXze46vnkooO1wMFJVXrx/DLreGecZ7HHnYRpDtxesRsJPbyQiaUGm95dmA1Sa3dj
         UwcPkuerUDLJjuvenqZZs+gD6LhbxVI9wf19i/Lu9hfL5LGveHHuUCxxb05T7GkrQavn
         jjMUfR3lwsQfMjOjnOV+SrD3sgnnXrTlpuBtEZawPuKmA0uTzkWQNSg7GdlQ1D/LA+6q
         iT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LrTDV1JC3FHqRkPuc+wq4o33QEiL82RGRHhUmIGgN6s=;
        b=IyjVbPp9hEYwz3wrrlz8penJ5eHzpyfr8QaTbpVwIVo0nbaObOeWNAmVkXnu7Gv3TP
         NVeXBn9wBWMl1bIGW4LJzJIQMyyO7dpaZ+zb71uL+giXBw9bz+VTDvQ+7XbZQsEDYl8c
         +bavyGfPvee1NSIOBBHFrE+dj/3lDVfd5e6S6CsqV3cfYkZeEFM9h7zcW9rbuRLv4TDF
         BXYUs+ITR6MO8/KEAzJpiL7ZcSu908PVASCH2Eis4fc5Uhevrfl/X5DMENFjGs9IlxFX
         EE+F8mg5jWOcjAP+Zldb8Um3muA1rbkfrN66W9e7uSW4w5tk6ZZoX0LkzWmuXsbAl5jj
         p+6w==
X-Gm-Message-State: AOAM5318a1TsIRlvQak2mIc+NPTR6QsQCmWzpFiOB/cpzs6frIFdd2tV
        Q+ho5NRPH8Opvcb/NZF/PSObhg==
X-Google-Smtp-Source: ABdhPJyLn6gTjUXMIfEImNEoRb2yDuEHvY0BV+clvgYgkiG4hWdWLhGB0lP4Ja9P51BVOBuZ1T5/sg==
X-Received: by 2002:ac8:5b82:: with SMTP id a2mr7248502qta.215.1608348633318;
        Fri, 18 Dec 2020 19:30:33 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id y16sm4376045qki.132.2020.12.18.19.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 19:30:32 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] drivers: crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Fri, 18 Dec 2020 22:30:25 -0500
Message-Id: <20201219033027.3066042-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201219033027.3066042-1-thara.gopinath@linaro.org>
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
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
index 5006e74c40cd..7ae0b779563f 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -294,15 +294,15 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
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

