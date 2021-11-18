Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BA5C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B330A61A8A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 15:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhKRPMk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 10:12:40 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:55828 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231588AbhKRPMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 10:12:37 -0500
Received: from pps.filterd (m0046668.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AICQENL008483;
        Thu, 18 Nov 2021 16:09:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=selector1;
 bh=l8PC2ksM2WYcZZ3EcrK2lSU88jSFlcOH9F9ZydceTRc=;
 b=xYIimynjYSJyLo5BSzYMIt33lchwPc4/yhLOVXUjmQyWgbfTNeO9YpkTQmYapT03ORKk
 NA97C/b1tvQQz35CbQQ+GUvbWndTqaoJ0kiyAfdE44Zj5sM/QdSw1TJvpQSfqa3WdSfe
 ECiz5GEMbhWvlhjDOEXJYZkpDhK5CWnKylnPU695cMCFHFQBRRyyGrdNDrp4Ef2CDIDD
 QdoKdxglBeAGDwC0x8snuaGD8CaXXXPqfC25+wdOiVDud/hJgzxRmuVxhkmfsaSdMQqJ
 EISTZbh6GA5N1kHdv4xg8QNVzYRGkBH+I35WCw177cuDN3WXqfsEjdNGdUf3ONC5ph4g dQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3cdjp6awbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Nov 2021 16:09:24 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 010F310002A;
        Thu, 18 Nov 2021 16:09:24 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id EC96F23153D;
        Thu, 18 Nov 2021 16:09:23 +0100 (CET)
Received: from localhost (10.75.127.48) by SFHDAG2NODE2.st.com (10.75.127.5)
 with Microsoft SMTP Server (TLS) id 15.0.1497.26; Thu, 18 Nov 2021 16:09:23
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
Subject: [PATCH v3 7/9] crypto: stm32/cryp - fix lrw chaining mode
Date:   Thu, 18 Nov 2021 16:07:54 +0100
Message-ID: <20211118150756.6593-8-nicolas.toromanoff@foss.st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
References: <20211118150756.6593-1-nicolas.toromanoff@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-18_12,2021-11-17_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes the lrw autotest if lrw uses the CRYP as the AES block cipher
provider (as ecb(aes)). At end of request, CRYP should not update the IV
in case of ECB chaining mode. Indeed the ECB chaining mode never uses
the IV, but the software LRW chaining mode uses the IV field as
a counter and due to the (unexpected) update done by CRYP while the AES
block process, the counter get a wrong value when the IV overflow.

Fixes: 5f49f18d27cd ("crypto: stm32/cryp - update to return iv_out")

Signed-off-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index d61608dc416a..537443a35d81 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -644,7 +644,7 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp, int err)
 		/* Phase 4 : output tag */
 		err = stm32_cryp_read_auth_tag(cryp);
 
-	if (!err && (!(is_gcm(cryp) || is_ccm(cryp))))
+	if (!err && (!(is_gcm(cryp) || is_ccm(cryp) || is_ecb(cryp))))
 		stm32_cryp_get_iv(cryp);
 
 	if (cryp->sgs_copied) {
-- 
2.17.1

