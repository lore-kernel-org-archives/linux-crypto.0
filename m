Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA75C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A22460F4B
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJ2OEc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:04:32 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:49866 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231418AbhJ2OER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:04:17 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDN3W001431;
        Fri, 29 Oct 2021 15:57:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=01NjtFfBtaK5E1FB/9vM3Btk4wC8avobYetx7lHu0cA=;
 b=vIGn6NSfAw8D31ZHP6xcDMF0qercAGrAkchMw9B1nc5lhp2P3yqx8Q1NT1m8n6wOAN2+
 iLkAubgkBWa+dujnhhWhPfiodPpQ0wUOh6QETHyv5PhAXKjQHPqZ4xg5rqAMxoZ5NqVm
 7EChtoAO012lTD9kKrIhgaWNIMNZ1R/yBHhMlpsG7Dka1wihbrgeFOaClrJGQL6o0rM+
 34zOPBfqsVCHBbObY4ZyE0WJdwxIQvn5MDO06B+LTEseuRttFNq4udZl3dZg9ZljFIlg
 1O16CxULOBYCgpOOsvCtfPimJZDrItCFeRJzPesmneAv8+EE8vumDZP/CDDoIj6yj/Vn Lg== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c07xgkpas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:57:06 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 34FFB10002A;
        Fri, 29 Oct 2021 15:56:59 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2D35824C742;
        Fri, 29 Oct 2021 15:56:59 +0200 (CEST)
Received: from localhost (10.75.127.49) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:56:58
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
Subject: [PATCH 6/8] crypto: stm32/cryp - fix double pm exit.
Date:   Fri, 29 Oct 2021 15:54:52 +0200
Message-ID: <20211029135454.4383-7-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE3.st.com (10.75.127.6) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While probe, in error exit, fix pm disabled twice.

Fixes: 65f9aa36ee47 ("crypto: stm32/cryp - Add power management support")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 874bec6d868e..632f21f6e15b 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2145,8 +2145,6 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 err_rst:
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 
 	clk_disable_unprepare(cryp->clk);
 
-- 
2.17.1

