Return-Path: <SRS0=vV99=6Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9658AC54E4B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 May 2020 11:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65FA72192A
	for <linux-crypto@archiver.kernel.org>; Mon, 11 May 2020 11:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MKYHEgW5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgEKLTm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 May 2020 07:19:42 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52256 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729264AbgEKLTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 May 2020 07:19:40 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04BBJMsq099218;
        Mon, 11 May 2020 06:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589195962;
        bh=8Yqex108W/YEVd8v7+4W/b3nDUCqYAUv+6/1luZSKk8=;
        h=From:To:CC:Subject:Date;
        b=MKYHEgW5xnw/5yCYhettgxacMp+ySeGPYCn8WV+IoTSi5ZbbdynIAW3bunH6ORme0
         5lLj5xAVHlPDEXqOLKacmotQRBXRRSkTxRkvxyXhVhVY4yYvihcxQ26lnf2vYipF8K
         TYqaqseqqhjrndv+aUx2gAoqCxJzRig4AX60/mJc=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04BBJMRb061614
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 06:19:22 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 11
 May 2020 06:19:22 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 11 May 2020 06:19:22 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04BBJKOU004306;
        Mon, 11 May 2020 06:19:21 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-omap@vger.kernel.org>
Subject: [PATCHv2 0/7] crypto: omap: sha/aes fixes
Date:   Mon, 11 May 2020 14:19:06 +0300
Message-ID: <20200511111913.26541-1-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Compared to v1 [1], added dcache flush handling in patch #3, and added a
new patch #7 which fixes SHA multi-accelerator core support. It doubles
the performance of raw SHA acceleration on devices where two cores are
available (like DRA7.) Will follow with platform code fixes once the
driver change is accepted.

-Tero

[1] https://www.spinics.net/lists/linux-crypto/msg47372.html


--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
