Return-Path: <SRS0=SZPK=6N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8ABAC83006
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 14:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF4221D7B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 14:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="DtkHvJq9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgD2Om2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Apr 2020 10:42:28 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:55316 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgD2Om2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Apr 2020 10:42:28 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03TEgN85101676;
        Wed, 29 Apr 2020 09:42:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588171343;
        bh=zZFduS8gFGnDWsW8M2oqT5mnD6om2vMq4XFrDQ8AF8M=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=DtkHvJq95Z2UvOv1FlleDr3iIGHFNAhfiA+B30YL/3L4zF7GNS+LF7LCVTf7PKYLK
         uqOuV2WnTMU3Mw1fFJoilQG5TAOxvqBmFCqk2rEBVt+GEeDhR1VXOvyCeoFmSiqUwy
         /uSu1MWjwwmPTXX+mY4XhaHyCXJhOZPaeJnw9GEE=
Received: from DFLE101.ent.ti.com (dfle101.ent.ti.com [10.64.6.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03TEgNYt012435
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 29 Apr 2020 09:42:23 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 29
 Apr 2020 09:42:23 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 29 Apr 2020 09:42:23 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03TEgHjN103561;
        Wed, 29 Apr 2020 09:42:21 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-omap@vger.kernel.org>
Subject: [PATCH 3/6] crypto: omap-crypto: fix userspace copied buffer access
Date:   Wed, 29 Apr 2020 17:42:02 +0300
Message-ID: <20200429144205.5291-4-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429144205.5291-1-t-kristo@ti.com>
References: <20200429144205.5291-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case buffers are copied from userspace, directly accessing the page
will most likely fail because it hasn't been mapped into the kernel
memory space. Fix the issue by forcing a kmap / kunmap within the
cleanup functionality.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-crypto.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-crypto.c b/drivers/crypto/omap-crypto.c
index cc88b7362bc2..cbc5a4151c3c 100644
--- a/drivers/crypto/omap-crypto.c
+++ b/drivers/crypto/omap-crypto.c
@@ -178,11 +178,14 @@ static void omap_crypto_copy_data(struct scatterlist *src,
 		amt = min(src->length - srco, dst->length - dsto);
 		amt = min(len, amt);
 
-		srcb = sg_virt(src) + srco;
-		dstb = sg_virt(dst) + dsto;
+		srcb = kmap_atomic(sg_page(src)) + srco + src->offset;
+		dstb = kmap_atomic(sg_page(dst)) + dsto + dst->offset;
 
 		memcpy(dstb, srcb, amt);
 
+		kunmap_atomic(srcb);
+		kunmap_atomic(dstb);
+
 		srco += amt;
 		dsto += amt;
 		len -= amt;
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
