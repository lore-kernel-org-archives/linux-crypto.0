Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECB3C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FFF5611C1
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhJ2OEM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:04:12 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:49642 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231418AbhJ2OEB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:04:01 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDN3T001431;
        Fri, 29 Oct 2021 15:56:49 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=jsaels+ddUZtfsywBFS4CqwXVBDosXtO8sG+jb6tKR0=;
 b=DhzfQ8C84cc0Ebr4BjC4FRbOFcGMP1A2zFMsxWgdX0Hrcvvz8+74UUAGR8dqvIDPEjuh
 ADz8+83ta89pdPNyTTuowAa9kjPjDFjrRPM1cVnEwUx20VGNeBtKMO+FClT2ooiuh9UT
 FtAs0+uJhPrmbDub2FFHs++wvSWZT1kihDnOf3G1v+xjUKyuoPLiRbG6hq+LUYAusZYg
 K8mumx4TVUOI+c2z6J7igLUWR6wJ2mKedY3VE6BEf1tjoCyydNeKc3epnrHGAr4BAbFv
 KPg02iyBbdzolF7Yt5bNV0yoNZ2eQWpT6Hyfa2DSjGh/+7l8nfk5dr/oHzP35k57bbBn xg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c07xgkpa1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:56:49 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id F0732100034;
        Fri, 29 Oct 2021 15:56:48 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E751124C742;
        Fri, 29 Oct 2021 15:56:48 +0200 (CEST)
Received: from localhost (10.75.127.50) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:56:48
 +0200
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] crypto: stm32/cryp - fix race condition
Date:   Fri, 29 Oct 2021 15:54:50 +0200
Message-ID: <20211029135454.4383-5-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Erase key before finalizing request.
Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 6eeeca0d70ce..f97f9ee68d6f 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -666,6 +666,8 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		free_pages((unsigned long)buf_out, pages);
 	}
 
+	memset(cryp->ctx->key, 0, sizeof(cryp->ctx->key));
+
 	pm_runtime_mark_last_busy(cryp->dev);
 	pm_runtime_put_autosuspend(cryp->dev);
 
@@ -674,8 +676,6 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 	else
 		crypto_finalize_skcipher_request(cryp->engine, cryp->req,
 						   err);
-
-	memset(cryp->ctx->key, 0, cryp->ctx->keylen);
 }
 
 static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
-- 
2.17.1

