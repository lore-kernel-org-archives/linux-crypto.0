Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64066C43461
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4706461442
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhENQOM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 12:14:12 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39558 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbhENQOL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 12:14:11 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14EGCqlw083265;
        Fri, 14 May 2021 11:12:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1621008772;
        bh=OQ+Ix9MIKU9XQ3zLGXvsa0ysovBtndx9AhnqN1l25i8=;
        h=From:To:CC:Subject:Date;
        b=vo88a/V6/b955trrrBR1Xn52swmO2EE31c1lc0Sm0NCWXOzCBVoDS5FoV0z1zrj6e
         Uz/r9B42w4lVvSkJ6rUocu0kM0b7GqVJc9M7IMDzQik6YqD5IhvPtcWShf8b5/UgeV
         hJV9jm8E+nTB/Dr9XuebX2R6dq2bgQvtVRZyZSJs=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14EGCqnM007526
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 May 2021 11:12:52 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 14
 May 2021 11:12:51 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 14 May 2021 11:12:51 -0500
Received: from fllv0103.dal.design.ti.com (fllv0103.dal.design.ti.com [10.247.120.73])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14EGCpr0042030;
        Fri, 14 May 2021 11:12:51 -0500
Received: from localhost ([10.250.35.60])
        by fllv0103.dal.design.ti.com (8.14.7/8.14.7) with ESMTP id 14EGCp7u035302;
        Fri, 14 May 2021 11:12:51 -0500
From:   Suman Anna <s-anna@ti.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Deepak Saxena <dsaxena@plexity.net>,
        Tero Kristo <kristo@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 0/6] Misc. SA2UL fixes/cleanups
Date:   Fri, 14 May 2021 11:12:40 -0500
Message-ID: <20210514161246.22517-1-s-anna@ti.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi All,

The following series includes various fixes for multiple minor
cleanup issues on failure paths in the TI K3 SA2UL Crypto driver.
The patches are all based on top of 5.13-rc1.

Patch 1 is the only non SA2UL patch, and allows the OMAP RNG driver
to be built for K3 platforms and probed properly when SA2UL is
selected, and the SA2UL driver is probed (the rng device is a child
of the sa2ul device).

regards
Suman

Suman Anna (6):
  hwrng: omap - Enable driver for TI K3 family
  crypto: sa2ul - Fix leaks on failure paths with sa_dma_init()
  crypto: sa2ul - Fix pm_runtime enable in sa_ul_probe()
  crypto: sa2ul - Use of_device_get_match_data() helper
  crypto: sa2ul - Use devm_platform_ioremap_resource()
  crypto: sa2ul - Remove child devices in remove

 drivers/char/hw_random/Kconfig |  2 +-
 drivers/crypto/sa2ul.c         | 46 ++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 23 deletions(-)

-- 
2.30.1

