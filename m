Return-Path: <SRS0=dn2r=SD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D99BC43381
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3672E20883
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Apr 2019 12:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfDAMyr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 08:54:47 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46911 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725882AbfDAMyr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 08:54:47 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x31CpA2n030648;
        Mon, 1 Apr 2019 14:54:26 +0200
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rjee285pb-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 01 Apr 2019 14:54:26 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id C16CE38;
        Mon,  1 Apr 2019 12:54:25 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 640A0290A;
        Mon,  1 Apr 2019 12:54:25 +0000 (GMT)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.47) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.435.0; Mon, 1 Apr 2019
 14:54:25 +0200
Received: from localhost (10.201.23.65) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.435.0; Mon, 1 Apr 2019 14:54:25
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
Subject: [PATCH 1/1] crypto: testmgr - call shash_init in crc32c algo
Date:   Mon, 1 Apr 2019 14:54:24 +0200
Message-ID: <1554123264-24243-1-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-01_05:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case of device call required in low level driver,
the context must be initialized before calling the final
function.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 crypto/testmgr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8386038..4a00d7c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2181,6 +2181,13 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		shash->tfm = tfm;
 		shash->flags = 0;
 
+		err = crypto_shash_init(shash);
+		if (err) {
+			printk(KERN_ERR "alg: crc32c: init failed for "
+			       "%s: %d\n", driver, err);
+			break;
+		}
+
 		*ctx = 420553207;
 		err = crypto_shash_final(shash, (u8 *)&val);
 		if (err) {
-- 
2.7.4

