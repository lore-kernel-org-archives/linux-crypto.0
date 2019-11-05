Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3794AC010DF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 12:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3A5E21D7C
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 12:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OIoEG1aX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388718AbfKEMiW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 07:38:22 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:33330 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388673AbfKEMiW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 07:38:22 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA5CcHPZ049261;
        Tue, 5 Nov 2019 06:38:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572957497;
        bh=ifdXaSh02lwWKojK7/ahJ85aJhHGaIR+HEH3a7yUkO0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=OIoEG1aXwChz6130cj4dsmB5pVBVfRaR2yAUDkLiFFX72L3BEUKR8t7+4iHRp6wwq
         bqm1+FhyxONspfLH8B3/kOoEpzRApx2mtOmy5Qh2w6oamqy8Jl2aBzBHdAGU0qOmbo
         4+UZEiK771xyhKAw3ynxuOduOSjBWYC1pdT3c0fU=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA5CcHMB023553
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Nov 2019 06:38:17 -0600
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Tue, 5 Nov
 2019 06:38:01 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Tue, 5 Nov 2019 06:38:01 -0600
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA5Cc6d2117093;
        Tue, 5 Nov 2019 06:38:15 -0600
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-omap@vger.kernel.org>, <ard.biesheuvel@kernel.org>
Subject: [PATCH 5/6] crypto: omap-des: handle NULL cipher request
Date:   Tue, 5 Nov 2019 14:37:58 +0200
Message-ID: <20191105123759.25053-6-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191105123759.25053-1-t-kristo@ti.com>
References: <20191105123759.25053-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If no data is provided for DES request, just return immediately. No
processing is needed in this case.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-des.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index d1d839164048..7a9491b7b8eb 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -637,6 +637,9 @@ static int omap_des_crypt(struct skcipher_request *req, unsigned long mode)
 		 !!(mode & FLAGS_ENCRYPT),
 		 !!(mode & FLAGS_CBC));
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (!IS_ALIGNED(req->cryptlen, DES_BLOCK_SIZE))
 		return -EINVAL;
 
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
