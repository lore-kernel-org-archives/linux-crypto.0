Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1E6C5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDEF208C4
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 11:27:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="mUfFigTv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfF1L13 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:27:29 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42335 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726524AbfF1L12 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 07:27:28 -0400
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SBPoTB020526;
        Fri, 28 Jun 2019 13:27:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=B6KqXSyspmxT0bd7YntUlngpbE0mK1d5i/1VLUqBWcI=;
 b=mUfFigTvElxyHlwiLQxFJ/k3QpDOJNIxbstkUDF7lWH4w3tSGN6OCoYGHlH178Haqnkh
 NODZvcZA5yMsAwow863FlIj0H9PgE/zYeUvxEAmOoy9onEgPAyMBpv9wVaY59g+FP+Rw
 X38VFHECgUvzzWg7ZU3YIFnYaHHWkbV3hJLFuocD+5seFir99rJZqEx27RluT5Ey8ixg
 91bi6eoP74jk8xf+5TZ/FXaTXxtcnBoWRKiqKvVQMFn48LL/Ka+LQB5Pu+owq5J81hgk
 ODg/6bFKhiTcnNaWbHR2nGQ7aeG0NIWyrwGDaQzT+1SI8j/idjakxtP5xy08NcfoHqL6 zw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2tcyq0e4kv-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 28 Jun 2019 13:27:16 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id EEAB531;
        Fri, 28 Jun 2019 11:27:15 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9802827A6;
        Fri, 28 Jun 2019 11:27:15 +0000 (GMT)
Received: from SAFEX1HUBCAS22.st.com (10.75.90.93) by SAFEX1HUBCAS23.st.com
 (10.75.90.46) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun
 2019 13:27:15 +0200
Received: from localhost (10.201.23.65) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 28 Jun 2019 13:27:15
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 2/2] crypto: stm32/hash: remove interruptible condition for dma
Date:   Fri, 28 Jun 2019 13:26:55 +0200
Message-ID: <20190628112655.9341-3-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628112655.9341-1-lionel.debieve@st.com>
References: <20190628112655.9341-1-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When DMA is used, waiting for completion must not be
interruptible as it can generate an error that is not handle
by the driver. There is no need to put the completion
interruptible in this driver.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index c37d1a336f98..23061f2bc74b 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -447,8 +447,8 @@ static int stm32_hash_xmit_dma(struct stm32_hash_dev *hdev,
 
 	dma_async_issue_pending(hdev->dma_lch);
 
-	if (!wait_for_completion_interruptible_timeout(&hdev->dma_completion,
-						       msecs_to_jiffies(100)))
+	if (!wait_for_completion_timeout(&hdev->dma_completion,
+					 msecs_to_jiffies(100)))
 		err = -ETIMEDOUT;
 
 	if (dma_async_is_tx_complete(hdev->dma_lch, cookie,
-- 
2.17.1

