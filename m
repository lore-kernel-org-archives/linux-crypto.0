Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4617DC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 07:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BD320880
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 07:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="sjBhBHk9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfDHHm6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 03:42:58 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:11846 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725871AbfDHHm6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 03:42:58 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x387bVNi016730;
        Mon, 8 Apr 2019 09:42:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=mzgL90xy/Z18CpzSweHDi9oQPt1aVLICyetmISiGRGQ=;
 b=sjBhBHk9OxbLO9LyUd9VeNj5y2fc3lJof9vc/0E/va6r3H+2wyME2Eu8NXIOXsdbTjIs
 lLMGbuytQOTHBgLnMMPpUDHhPXmhANmI0ibrgOk5j+6CpJWyTIHZAj6qE3MyO9eWxlDJ
 U3RKU73FDof5UukZ/X5zlK9lDb8fWyE7TUPUgDUjyGM5Ff4L8PXoJS2qJglcXN7sBRLn
 6TZECxLxYMd1bggwRn+1217xjEbBJD0/lS4YK95KgWyWnf4FHEvALhOYHmejlPa7FZIJ
 qMOFQYqLTO/jefnMT17lqOxpi/BajbVdwJYFX1u/HmYHmnhBir6V8Tin9Is1SvLMEgss jA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2rprcf1jfg-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 08 Apr 2019 09:42:01 +0200
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E951738;
        Mon,  8 Apr 2019 07:41:59 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 9BC5512E1;
        Mon,  8 Apr 2019 07:41:59 +0000 (GMT)
Received: from SAFEX1HUBCAS23.st.com (10.75.90.47) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.361.1; Mon, 8 Apr 2019
 09:41:59 +0200
Received: from localhost (10.201.23.65) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 8 Apr 2019 09:41:58
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
Subject: [PATCH 1/1] crypto: stm32/hash - Fix self test issue during export
Date:   Mon, 8 Apr 2019 09:41:58 +0200
Message-ID: <1554709318-25389-1-git-send-email-lionel.debieve@st.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.23.65]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-08_04:,,
 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the wait condition to check if the hash is busy.
Context can be saved as soon as hash has finishing processing
data. Remove unused lock in the device structure.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 4a6cc8a..bfc49e6 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -181,8 +181,6 @@ struct stm32_hash_dev {
 	u32			dma_mode;
 	u32			dma_maxburst;
 
-	spinlock_t		lock; /* lock to protect queue */
-
 	struct ahash_request	*req;
 	struct crypto_engine	*engine;
 
@@ -977,7 +975,7 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 
 	pm_runtime_get_sync(hdev->dev);
 
-	while (!(stm32_hash_read(hdev, HASH_SR) & HASH_SR_DATA_INPUT_READY))
+	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
 		cpu_relax();
 
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
-- 
2.7.4

