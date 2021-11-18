Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEC1C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E979B61547
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhKRPMe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 10:12:34 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:55706 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231439AbhKRPMd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 10:12:33 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AICTtGa008347;
        Thu, 18 Nov 2021 16:09:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=c3P0JBoOld0KDv09Q6IshVxFhYKHwNh/H1gEQQ26NpQ=;
 b=ZWX8MZOynO/hdT+gSBwGzzZf2OvwAlOkE+GiW712ykS7rlcmLn3o1uXH60LDFyqea9h2
 /ClDJaOeiau8+DzPA25yRGNLSo7T2jhUsZiwuuv2WAjPfLtGeL6bgAq/Wc2waUwTgfrn
 1AA1EKQRCYJtCEhdSO65tcnoHs7/ra1CgtpBX+Zo7HFRK1VsN3gctp8z4kJ8bfnSxoc7
 qftrehy1ahR0/bBrhZSNxjyXUezOX/VHlh0WENBE4KVgqW8xI8UL1CDtbqDfdcjpCi0R
 vKg0Fq0TW/LoZgpy5zLLhst18NuuHyYL4Kg+tj2ZJL2lWt7l8oUz+OpaJaNhfzd9DoDD sA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3cdjp6awb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:09:20 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CFAA610002A;
        Thu, 18 Nov 2021 16:09:19 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id C732523153D;
        Thu, 18 Nov 2021 16:09:19 +0100 (CET)
Received: from localhost (10.75.127.51) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 18 Nov 2021 16:09:19
 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
CC:     Marek Vasut <marex@denx.de>,
        Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/9] crypto: stm32/cryp - fix race condition in crypto_engine requests
Date:   Thu, 18 Nov 2021 16:07:51 +0100
Message-ID: <20211118150756.6593-5-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
References: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Erase key after finalizing request.

The key was reseted to 0 before the crypto_finalize_.*_request() call, in
some running path a pending call could run with a key={ 0 }.
Fixes: 9e054ec21ef8 ("crypto: stm32 - Support for STM32 CRYP crypto module")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 9d6ccf1eb4ce..c0903025a4cc 100644
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

