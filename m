Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E936EC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A12611EE
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhDTDgg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDgf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 23:36:35 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C1AC06138A
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:05 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id z25so5064734qtn.8
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FUSrZlERR89hZzHNyP4QRMbV2CihmITrCmz3k1LlYk4=;
        b=JKfUHhwohTAlIErOZ5oVcBUy/U3OOTDr2G7VEB2UxHxsSijfkzoHaIRv30O3iTSSgb
         IAAQIpxOUIL8Cj1R5RBtffr7tOw83iHNxZnF1N5xredPDOrc/+cqC85bswlh8q+EySk7
         8dwWPjm06xrtLktshNebkbjlV07CloyqAOPlpB42aVCMZXTOrxeunMYJMRRqi3CFCT5c
         HdmyoO8W/86tk2pYta/3XmrfNJNgJ5MqnoZXP9Ii3z0qkteGfg9l7Tt15GMHGBbIuww+
         Y8v8HAh9UE9wiPuayC68mvhuvfJC8L/xg5wof7AjZO7SsUenw3LyWh/RttBVZcyPKiMZ
         YpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FUSrZlERR89hZzHNyP4QRMbV2CihmITrCmz3k1LlYk4=;
        b=Tv2JxJeoKxq2jrAJVAJ+YGSuiDNq8tvWW1wmF+M0CR5EM8UFGkByi+3Dyv0MPdMf3Z
         ayq/iWnD4nek2hCcwsfZDLmZC+jg44/rnOJI6o1996s5PIpG+s7uQ1iShHoviY59c3+z
         Yz7jVaCtys28UANDzRtAYlW/OW23j7/OgxQB34DZNb+G5e7A04v8z2xbR4hq3w/v4hVk
         Q6y29NjJRf22apGIjbAw89UAK/tcBHOEpFrM0+pII+NLrq0F8jaGSLEvrrXW6+ZFfB9J
         ZQ73BYKSjhMDPQCWVEgs2SjsFNJPM4tbjTuMaGPO+C9TNYmwUJZcsjDPHsEruyqAx7mC
         6kbw==
X-Gm-Message-State: AOAM530PldEQcav7a3neujreHMV1CIyi49dgnTomdl0RdlTTwiYeCnqC
        ALnNQzAH00bhm0EwtRKbv+PSWqd4txcKYw==
X-Google-Smtp-Source: ABdhPJzKd+ZMz2eSTUaVL36KyA695VaU5Fn50hDEKwGyZAXSPvHSEi+qJ5PcjO/NTwQR2xEWz2dEsg==
X-Received: by 2002:a05:622a:13cb:: with SMTP id p11mr14753149qtk.349.1618889764259;
        Mon, 19 Apr 2021 20:36:04 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id b8sm3562643qka.117.2021.04.19.20.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 20:36:03 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v3 1/7] crypto: qce: common: Add MAC failed error checking
Date:   Mon, 19 Apr 2021 23:35:56 -0400
Message-Id: <20210420033602.1729947-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420033602.1729947-1-thara.gopinath@linaro.org>
References: <20210420033602.1729947-1-thara.gopinath@linaro.org>
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

