Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A0BC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58646145B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 16:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhENQOg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 12:14:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:39830 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbhENQOd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 12:14:33 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 14EGDHpI083558;
        Fri, 14 May 2021 11:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1621008797;
        bh=vXSH04tSnl7PfQFFczb4yWsfxSBpijqYvTaWF7m0q5c=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=mF+voaCdkjEYOOAmzeiiQibIyCvg9SxFTqJSExSawnZqjizHye+vKyQMSv73nfFKd
         kSPJY7abJS4FJ1HTCM+2CVJaoquA5ScFJkRRc0sGfU2FNOdrKjJfec4Gmkfn8xBrbh
         T9nwa4Y0zOQDk4J44vNwT8Dbr/pu+M+b7w2h9fOo=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 14EGDHsK066034
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 14 May 2021 11:13:17 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 14
 May 2021 11:13:17 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 14 May 2021 11:13:17 -0500
Received: from fllv0103.dal.design.ti.com (fllv0103.dal.design.ti.com [10.247.120.73])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 14EGDHI8050019;
        Fri, 14 May 2021 11:13:17 -0500
Received: from localhost ([10.250.35.60])
        by fllv0103.dal.design.ti.com (8.14.7/8.14.7) with ESMTP id 14EGDHJj035832;
        Fri, 14 May 2021 11:13:17 -0500
From:   Suman Anna <s-anna@ti.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     Deepak Saxena <dsaxena@plexity.net>,
        Tero Kristo <kristo@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 6/6] crypto: sa2ul - Remove child devices in remove
Date:   Fri, 14 May 2021 11:12:46 -0500
Message-ID: <20210514161246.22517-7-s-anna@ti.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210514161246.22517-1-s-anna@ti.com>
References: <20210514161246.22517-1-s-anna@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The sa_ul_probe creates child devices using of_platform_populate(),
but these are not cleaned up in driver remove. Clean these up
by removing the child devices using of_platform_depopulate().

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/crypto/sa2ul.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 216702fef945..51bb69bc573c 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2467,6 +2467,8 @@ static int sa_ul_remove(struct platform_device *pdev)
 {
 	struct sa_crypto_data *dev_data = platform_get_drvdata(pdev);
 
+	of_platform_depopulate(&pdev->dev);
+
 	sa_unregister_algos(&pdev->dev);
 
 	dma_release_channel(dev_data->dma_rx2);
-- 
2.30.1

