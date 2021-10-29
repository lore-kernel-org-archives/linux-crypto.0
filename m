Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746C4C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E76161177
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhJ2ODQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:03:16 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:48954 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231504AbhJ2ODN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:03:13 -0400
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDE7L001315;
        Fri, 29 Oct 2021 15:56:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=ApzKX0Ohee8Bs+HYdLXyjIjlJjwLbFK+nNLOPyTFAjc=;
 b=dHEhZhTz3eJHToQRMO8gNOxBXj50TzlqqSQHOsDpKaHCow799JROZWXyX8l+KAodH6w8
 wNy8nWTKjKV2bYbq8C9JiukCmqzrQfXx9TOKsUd9skO9nLbMAdZJ84Y3kuHdDVTDkFkO
 6s0O4iRPhT0cuStbSB7mkXLZUxuMuBa42llE5XCry0FDgwyh8MyKL9BYJkogXKdZbk1D
 +d6nZWwwnNeKtMtfKX2nCYQNGLtIPrnMbTWwBfkrDtQl1c9pSx/tsYbb8zRZ2rtfRazq
 2b/gCnOZwyCTMorKG5+YTbJrlJJM5zLzYo3QyVYtkr5IwXDDX6lb73z3pjikrj30MmSu 8g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c07xgkp7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:56:04 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9057710002A;
        Fri, 29 Oct 2021 15:56:03 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8863F24C73F;
        Fri, 29 Oct 2021 15:56:03 +0200 (CEST)
Received: from localhost (10.75.127.49) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:56:03
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
        <linux-kernel@vger.kernel.org>,
        Etienne Carriere <etienne.carriere@foss.st.com>
Subject: [PATCH 1/8] crypto: stm32/cryp - defer probe for reset controller
Date:   Fri, 29 Oct 2021 15:54:47 +0200
Message-ID: <20211029135454.4383-2-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
References: <20211029135454.4383-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Etienne Carriere <etienne.carriere@foss.st.com>

Change stm32 CRYP driver to defer its probe operation when
reset controller device is registered but has not been probed yet.

Signed-off-by: Etienne Carriere <etienne.carriere@foss.st.com>
Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 7389a0536ff0..dcdd313485de 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1973,7 +1973,11 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 
 	rst = devm_reset_control_get(dev, NULL);
-	if (!IS_ERR(rst)) {
+	if (IS_ERR(rst)) {
+		ret = PTR_ERR(rst);
+		if (ret == -EPROBE_DEFER)
+			goto err_rst;
+	} else {
 		reset_control_assert(rst);
 		udelay(2);
 		reset_control_deassert(rst);
@@ -2024,7 +2028,7 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	spin_lock(&cryp_list.lock);
 	list_del(&cryp->list);
 	spin_unlock(&cryp_list.lock);
-
+err_rst:
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-- 
2.17.1

