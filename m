Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A160AC43215
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 718722089F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 07:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="rTjPLx0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbfKUH1p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:27:45 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50808 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfKUH1m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 02:27:42 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RQ5b081613;
        Thu, 21 Nov 2019 01:27:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574321246;
        bh=0mklLlGbDBmknLDikiMI3ZT2ftD03wZnmdNF6PCexZ4=;
        h=From:To:CC:Subject:Date;
        b=rTjPLx0cPnSYUVgxGX1jeHWiWy3ix9ZFW2Yg84wTDI/07eRSAmuUoPeJrJ5z7ZQZT
         m97PsLJg8YuAryCltWAc5+pMGC57Rr6gIOUM9tGQ/bhff2oi3uHscj3jqIFOM3p4Hf
         7fs1qEhEyaxdq1VYYRWjAX/OWfcWeh8YjhwnOxJU=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAL7RQ1A013789
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 Nov 2019 01:27:26 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 21
 Nov 2019 01:27:26 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 21 Nov 2019 01:27:26 -0600
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAL7RNTq079857;
        Thu, 21 Nov 2019 01:27:24 -0600
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>
CC:     <vkoul@kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] crypto: atmel - Retire dma_request_slave_channel_compat()
Date:   Thu, 21 Nov 2019 09:27:20 +0200
Message-ID: <20191121072723.28479-1-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I'm going through the kernel to crack down on dma_request_slave_channel_compat()
users.

These drivers no longer needs it as they are only probed via DT and even if they
would probe in legacy mode, the dma_request_chan() + dma_slave_map must be used
for supporting non DT boots.

I have only compile tested the drivers!

Regards,
Peter
---
Peter Ujfalusi (3):
  crypto: atmel-aes - Retire dma_request_slave_channel_compat()
  crypto: atmel-sha - Retire dma_request_slave_channel_compat()
  crypto: atmel-tdes - Retire dma_request_slave_channel_compat()

 drivers/crypto/atmel-aes.c  | 50 ++++++++-----------------------------
 drivers/crypto/atmel-sha.c  | 39 ++++++-----------------------
 drivers/crypto/atmel-tdes.c | 47 ++++++++++------------------------
 3 files changed, 30 insertions(+), 106 deletions(-)

-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

