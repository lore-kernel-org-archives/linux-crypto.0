Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BC8C433FE
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0577D60EB8
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbhKBQur (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:50:47 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:33802 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231881AbhKBQuo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Nov 2021 12:50:44 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A2EMM4J011759;
        Tue, 2 Nov 2021 17:47:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=23KQt3SEHQG2x+P/jacjp6tL0OJTLQOO2vIEH5W7XlU=;
 b=IKDDoyq4SSJg7hlvBpSzSglCmssE4vrrIGuzOq8oPaxJpDFsgwDMjwxOLV9u+P9DHiAK
 YkYgNLfEslixcP1xRp9ujeJ2u0i/a282cMbCTOTI4n32nlOaSpje5ZsxdVqLkbVMuhs7
 WUmzaAaKGWKJ+6LGO0zl9Bap1hZGYn2JWbmrskPrlA9k4h/kL+DeitwMhKdN/2dm2Qg3
 1HvJoo+JUI8DtPY/+0t1VwvCPBBoU3qvRG3IRoDPqC02WH02So9kj+/MvotBjIGdHaIp
 s90VqkoM4KFFASXvhof+dpsqi1i+UONHd/1E/NrD1d9dob2sVDX72DjcUbfumukLXuid pA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3c2jfj6pc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Nov 2021 17:47:55 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id AE268100034;
        Tue,  2 Nov 2021 17:47:54 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id A650822FA5E;
        Tue,  2 Nov 2021 17:47:54 +0100 (CET)
Received: from localhost (10.75.127.46) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 2 Nov 2021 17:47:54
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
        <linux-kernel@vger.kernel.org>,
        Etienne Carriere <etienne.carriere@foss.st.com>
Subject: [PATCH v2 2/8] crypto: stm32/cryp - don't print error on probe deferral
Date:   Tue, 2 Nov 2021 17:47:23 +0100
Message-ID: <20211102164729.9957-3-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211102164729.9957-1-nicolas.toromanoff@foss.st.com>
References: <20211102164729.9957-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG1NODE3.st.com (10.75.127.3) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Etienne Carriere <etienne.carriere@foss.st.com>

Change driver to not print an error message when the device
probe is deferred for a clock resource.

Signed-off-by: Etienne Carriere <etienne.carriere@foss.st.com>
Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index dcdd313485de..7b55ad6d2f1a 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -1955,7 +1955,8 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 
 	cryp->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(cryp->clk)) {
-		dev_err(dev, "Could not get clock\n");
+		dev_err_probe(dev, PTR_ERR(cryp->clk), "Could not get clock\n");
+
 		return PTR_ERR(cryp->clk);
 	}
 
-- 
2.17.1

