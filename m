Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D90C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA5C1613F9
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbhD2PID (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbhD2PH7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 11:07:59 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C689C061342
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:11 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id o1so7738274qta.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FUSrZlERR89hZzHNyP4QRMbV2CihmITrCmz3k1LlYk4=;
        b=MHnQJNbVziLM0NPBDtmnwCmOJ2FoMf3Ip14Lec6yiW9Uw6wXJuecmb+TjAI0QTEitc
         WNpma+n25xPeN4F8PqiRZsQ6R4aIVkCH8d6gs9+6AfMPjY8703EY42h09Hbts2W5+UaI
         7bSZMJ1iZtva1r4TQEM9PtgSONILCgKOb5B2IOoR9Q4vGpzBW04aewKE2JlYZG1wp/Q8
         IBVIhhlfHUPc+UsCWZMk2wz3B+9/8qML3QPrJzw2tvPHDQ8XFUWsMVUqYSqeFE6ztPPt
         nM80jMCXcIZ/xuB/Q6/o3HFuQBnSqLdiOHnlJTv+/Q5Goxb65N+HCS6tj7RP2wi/KOl9
         LU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUSrZlERR89hZzHNyP4QRMbV2CihmITrCmz3k1LlYk4=;
        b=G9J9q5Tok5/IeX6KChsmZ5Z/pST7WmmFRfBHGKe1ibwJmpfwFz7uhjS6pOuruJtVm7
         dcbIuXtCoPd4fByWakkDA/zikt1BAQAeWVGlmaBoe4w3DVmzYPhTd9t2yAgNU9clGFrW
         AwWjtXPdNqRhtCBk3GfLU1PhMdMeN3e/WpqMsTDqAEhGsCkuYM53QyQ75Gvd0zHcOec/
         NBNbmANdPDUa1Bx+6suL6X1tX+yW9JdwhB0O1vm2FhGyfTGz7vVC6TOSMPUCnI55xklN
         y30YqZT9aRVWuWgNjosO7vS3zwGLTYqBBjI6SlNDVwLwqH/sN/kx/Oi2ZKiCogn2KRLm
         daqA==
X-Gm-Message-State: AOAM530g8JbHKqypT/Kx1Ju1BoHCaDk+rNa5YBUowGPVpLclWtjQKlbL
        BpROiTzyx9maCz53qKrmUxiA9w==
X-Google-Smtp-Source: ABdhPJxnEVT2K9UkClrAOM08gSZ9saJsmBh5srRf+Bp4JISfSe2v4i9eQbW+SiK5/rikm63ANJHTmA==
X-Received: by 2002:ac8:7344:: with SMTP id q4mr22981494qtp.278.1619708829856;
        Thu, 29 Apr 2021 08:07:09 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id j191sm2223822qke.131.2021.04.29.08.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:07:09 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v4 1/7] crypto: qce: common: Add MAC failed error checking
Date:   Thu, 29 Apr 2021 11:07:01 -0400
Message-Id: <20210429150707.3168383-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210429150707.3168383-1-thara.gopinath@linaro.org>
References: <20210429150707.3168383-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

MAC_FAILED gets set in the status register if authenthication fails
for ccm algorithms(during decryption). Add support to catch and flag
this error.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---

v1->v2:
	- Split the error checking for -ENXIO and -EBADMSG into if-else clause
	  so that the code is more readable as per Bjorn's review comment.

 drivers/crypto/qce/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index dceb9579d87a..dd76175d5c62 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -419,6 +419,8 @@ int qce_check_status(struct qce_device *qce, u32 *status)
 	 */
 	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
 		ret = -ENXIO;
+	else if (*status & BIT(MAC_FAILED_SHIFT))
+		ret = -EBADMSG;
 
 	return ret;
 }
-- 
2.25.1

