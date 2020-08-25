Return-Path: <SRS0=bFPd=CD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C04C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 13:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9BAB206F0
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Aug 2020 13:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cgrIB4OR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgHYNbZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Aug 2020 09:31:25 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:47212 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgHYNbZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Aug 2020 09:31:25 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07PDVKQY048023;
        Tue, 25 Aug 2020 08:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598362280;
        bh=2SfrK0eHenlCVkqBRpYix7m8N1N8a2l1yYmb7XeCvjA=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=cgrIB4ORCiPSD0airAeC9X8uzhplIGEOH67o1NaQNTrGqvdpHFkD+ILuM4azv2/i5
         4DUSGaePAY0Nu0kFA4x3YkpIxIrVOMkrBVDVM069l2trjvIqfx2eBRWw4SEPbhGh5J
         Zy9GLbuUu5BJGJO9GjKKt/zw2DM/nKLcUaXAu6mA=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07PDVKLk016393
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 08:31:20 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 25
 Aug 2020 08:31:20 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 25 Aug 2020 08:31:20 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07PDVFs0046832;
        Tue, 25 Aug 2020 08:31:19 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/2] crypto: sa2ul: fix compiler warning produced by clang
Date:   Tue, 25 Aug 2020 16:31:06 +0300
Message-ID: <20200825133106.21542-3-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200825133106.21542-1-t-kristo@ti.com>
References: <20200825133106.21542-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang detects a warning for an assignment that doesn't really do
anything. Fix this by removing the offending piece of code.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/sa2ul.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5bc099052bd2..ff8bbdb4d235 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1148,12 +1148,10 @@ static int sa_run(struct sa_req *req)
 			ret = sg_split(req->dst, mapped_dst_nents, 0, 1,
 				       &split_size, &dst, &dst_nents,
 				       gfp_flags);
-			if (ret) {
-				dst_nents = dst_nents;
+			if (ret)
 				dst = req->dst;
-			} else {
+			else
 				rxd->split_dst_sg = dst;
-			}
 		}
 	}
 
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
