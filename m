Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D78C55199
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6A0208FE
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 06:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="eci8SxyS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgD0GnX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 02:43:23 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1593 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726496AbgD0GnU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 02:43:20 -0400
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03R6cO6G024040;
        Mon, 27 Apr 2020 08:42:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=lh1kBYgL+JLuoCQaaOo5FYMEjoKA0Zs0ybVKkeHad0s=;
 b=eci8SxyS83Z1lVviB+tuVkqLFpMh+zwi0AEZGatqH2sQ9FAqxu2M7g+2A6oSgZ3Gm4GN
 mTJUhpBAUVh/xf1WX0VSTowK/ONKfTj2aWFjwVf/1Q1DuLoMM3/rU1sJ9Q7yRmW6hun7
 Bqmx2Luc07UgcJ1sbHHs5AmXmB193dQiBR8bIHm1lMpNd7x3yPStqKKdm/g/Q+TpcrRG
 2XzHOLf979Fqk77FjP560ci6aMT5pyfcZx7wVj8/IZodcD1j/mVs6XcdPfPzs9pmtq98
 E1DPmXG6+kZqHtI7hxL3GrB70hHWvvQU+acbS3IjpA0p1bY3y3a7vXHn5//klolzavCi LQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 30mhq5r2h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 08:42:59 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id CB560100038;
        Mon, 27 Apr 2020 08:42:58 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag7node2.st.com [10.75.127.20])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id B92AB21F679;
        Mon, 27 Apr 2020 08:42:58 +0200 (CEST)
Received: from localhost (10.75.127.46) by SFHDAG7NODE2.st.com (10.75.127.20)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Apr 2020 08:42:58
 +0200
From:   Lionel Debieve <lionel.debieve@st.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: [PATCH 3/3] crypto: stm32/hash - don't print error on probe deferral
Date:   Mon, 27 Apr 2020 08:42:26 +0200
Message-ID: <20200427064226.6991-4-lionel.debieve@st.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200427064226.6991-1-lionel.debieve@st.com>
References: <20200427064226.6991-1-lionel.debieve@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.46]
X-ClientProxiedBy: SFHDAG3NODE1.st.com (10.75.127.7) To SFHDAG7NODE2.st.com
 (10.75.127.20)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_03:2020-04-24,2020-04-27 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change driver to not print an error message when the device
probe is deferred for a clock resource.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 0d592f55a271..03c5e6683805 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1464,8 +1464,11 @@ static int stm32_hash_probe(struct platform_device *pdev)
 
 	hdev->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(hdev->clk)) {
-		dev_err(dev, "failed to get clock for hash (%lu)\n",
-			PTR_ERR(hdev->clk));
+		if (PTR_ERR(hdev->clk) != -EPROBE_DEFER) {
+			dev_err(dev, "failed to get clock for hash (%lu)\n",
+				PTR_ERR(hdev->clk));
+		}
+
 		return PTR_ERR(hdev->clk);
 	}
 
-- 
2.17.1

