Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A10C4332E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D6222D70
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 03:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387608AbhALDHJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733259AbhALDHI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 22:07:08 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B557DC0617A5
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:51 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id n142so772146qkn.2
        for <linux-crypto@vger.kernel.org>; Mon, 11 Jan 2021 19:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ckoNO1YJt5QKI0zTcMaiAvFZHq1fWNUxmCXeDkmSik=;
        b=RvUHC9efiBoahnjz2FjLCD+IuvX86QT5zWbdiCacODGMTQGYVBOLw51LGdvI6/Ce1H
         PwrDw6JDzPF6Mz27YuLEbStFEnBESjXagprqey7vNXtq8UzW74p+ocfBN9MMH9ipSk67
         7S4aYdodeQzhiQLmnCpqaaXcXXvKhvs4FtgD6bsnZUby3k1ssGR/H7eR0P0vklIby8Rd
         kQ/tL9IdYXWIuBNximdCNNerKwj1C6QyShlSuwi7ktMOOEelrdtSmdiP3SLRz+UpKVCB
         eZvf9fgLjC/LfI9nEsMFp18YReehWclMoL36KdUCy8JmQ4lP9bbSQPzWaEiXvORERn5y
         lEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ckoNO1YJt5QKI0zTcMaiAvFZHq1fWNUxmCXeDkmSik=;
        b=ZjIh5z5oi0iVvtYkMUKbwpNPsf6KstkEfb12mqiqWcU0xzwn1CK0r0mxGxCzNqlDX5
         oS5GCs1B3iKyxoNQSHU1PP2iwl7btj51Z3qc9Mt4jtvJ8jNrwqtvFgW/L1VHJil60Jxq
         yTFNdF3L+vRpc8HuPwXC+KqlvVcglOelUuMUsjic7FcopqAx9Z5iywJr3X/yb9v6Bqlm
         LkotJpaB5Hh7YfC+jxaitqqCeqJrE9TRwLtbOf5i4bEy3rKC/gjfBKEfYPLb/+pZsRMC
         CYYc+4cxNd9MWXcVBObhZKVDT0Xa4Ys6LoZBe+1uW+SonYivnq+qfRX2WRnNo5Mhulcd
         y8Ug==
X-Gm-Message-State: AOAM530mYD9/8mRDC4HUnlWVPDFK7lhoCQoGqXC7QKBPFY4rIRHMOkVN
        ftDUjcQAXd2aYXsgQClr0XyLbQ==
X-Google-Smtp-Source: ABdhPJxzxKhiEsftSsOs8LwuKbvVHCRrhfAI0/KLdehVkiC7h8bh/zTIoHs7SsrmsTAvW5JAorkCzA==
X-Received: by 2002:ae9:e8c5:: with SMTP id a188mr2405243qkg.479.1610420751003;
        Mon, 11 Jan 2021 19:05:51 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c7sm814235qkm.99.2021.01.11.19.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 19:05:50 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] drivers: crypto: qce: common: Set data unit size to message length for AES XTS transformation
Date:   Mon, 11 Jan 2021 22:05:43 -0500
Message-Id: <20210112030545.669480-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112030545.669480-1-thara.gopinath@linaro.org>
References: <20210112030545.669480-1-thara.gopinath@linaro.org>
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

