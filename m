Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D4FC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512A46115C
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 14:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhJ2ODf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 10:03:35 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:56486 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhJ2ODc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 10:03:32 -0400
Received: from pps.filterd (m0241204.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TDDDqc016823;
        Fri, 29 Oct 2021 15:56:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=fW1tk5zeBnk73g+SYKt7UAVeKB2ehFbROg+bJXyRRzM=;
 b=Lw5oD1aVlqngxAbnyLVk+WfvlYeCJQCBWMPI5uGx7DHVFAyAMi8ZdcUZUB4uPtu/sJmC
 yM4XTCiOlQ24fXwVfYLvi1TJq7e6kc2VVrzsBIdQvAxvvFmT+47DG0d/g8yY0kxn+Hqw
 CMh4M0+mlOm8+NnD/bd1wdgAOi0LW3aJfcQ5kr6SsqI4kNCCbGh7kWLdL/3+/qPQUJ6Z
 df0W4EJAoJCcLApFXC3PFqw08cmX4uT3ivnsVLLVweumpQghq5mfRahkfDiILLTQMiRk
 wDxskCcIB00ffCxtkvs5TMrZUDF9izxnMq8UGs8h65t0pnkD2yqHUU1vyokRcdA2JSsH jQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 3c089ruj7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Oct 2021 15:56:14 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id EE1D710002A;
        Fri, 29 Oct 2021 15:56:13 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E41FC24C741;
        Fri, 29 Oct 2021 15:56:13 +0200 (CEST)
Received: from localhost (10.75.127.49) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 29 Oct 2021 15:56:13
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
Subject: [PATCH 3/8] crypto: stm32/cryp - fix CTR counter carry
Date:   Fri, 29 Oct 2021 15:54:49 +0200
Message-ID: <20211029135454.4383-4-nicolas.toromanoff@foss.st.com>
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

Fix issue in CTR counter overflow, the carry-over is now properly
managed.
Fixes: bbb2832620ac ("crypto: stm32 - Fix sparse warnings")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 7b55ad6d2f1a..6eeeca0d70ce 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -163,7 +163,7 @@ struct stm32_cryp {
 	struct scatter_walk     in_walk;
 	struct scatter_walk     out_walk;
 
-	u32                     last_ctr[4];
+	__be32                  last_ctr[4];
 	u32                     gcm_ctr;
 };
 
@@ -1219,25 +1219,26 @@ static void stm32_cryp_check_ctr_counter(struct stm32_cryp *cryp)
 
 	if (unlikely(cryp->last_ctr[3] == 0xFFFFFFFF)) {
 		cryp->last_ctr[3] = 0;
-		cryp->last_ctr[2]++;
+		cryp->last_ctr[2] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[2]) + 1);
 		if (!cryp->last_ctr[2]) {
-			cryp->last_ctr[1]++;
+			cryp->last_ctr[1] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[1]) + 1);
 			if (!cryp->last_ctr[1])
-				cryp->last_ctr[0]++;
+				cryp->last_ctr[0] = cpu_to_be32(be32_to_cpu(cryp->last_ctr[0]) + 1);
 		}
 
 		cr = stm32_cryp_read(cryp, CRYP_CR);
 		stm32_cryp_write(cryp, CRYP_CR, cr & ~CR_CRYPEN);
 
-		stm32_cryp_hw_write_iv(cryp, (__be32 *)cryp->last_ctr);
+		stm32_cryp_hw_write_iv(cryp, cryp->last_ctr);
 
 		stm32_cryp_write(cryp, CRYP_CR, cr);
 	}
 
-	cryp->last_ctr[0] = stm32_cryp_read(cryp, CRYP_IV0LR);
-	cryp->last_ctr[1] = stm32_cryp_read(cryp, CRYP_IV0RR);
-	cryp->last_ctr[2] = stm32_cryp_read(cryp, CRYP_IV1LR);
-	cryp->last_ctr[3] = stm32_cryp_read(cryp, CRYP_IV1RR);
+	/* The IV registers are BE  */
+	cryp->last_ctr[0] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0LR));
+	cryp->last_ctr[1] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV0RR));
+	cryp->last_ctr[2] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1LR));
+	cryp->last_ctr[3] = cpu_to_be32(stm32_cryp_read(cryp, CRYP_IV1RR));
 }
 
 static bool stm32_cryp_irq_read_data(struct stm32_cryp *cryp)
-- 
2.17.1

