Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62E3C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 13:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82C0B60F21
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Sep 2021 13:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhIPNnh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Sep 2021 09:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240304AbhIPNng (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Sep 2021 09:43:36 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21176C061574
        for <linux-crypto@vger.kernel.org>; Thu, 16 Sep 2021 06:42:16 -0700 (PDT)
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id AA01982DA1;
        Thu, 16 Sep 2021 15:42:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1631799732;
        bh=/vyfvHfygDbIbPm95BDMztXGPHzk1GB38j2+1DC2aU0=;
        h=From:To:Cc:Subject:Date:From;
        b=dS5tG391JqaRVPCtWG8q9M6ySM8uLIie53KukjG+b+e2yhByOeNzHOftu1ss2O3ET
         lpnt2ES+ygNB3W2GSlEJh0pxO6AsJoHx3CMVnjThc/G+6K3GG2RriXX77b7AZGE99S
         Vm5ilAjqfn+OjWvq4+aSAlA71aKYBl7NmWxUiL2LRo1XmzrAMEQyPAL0EalhpHw8V6
         hobzabbCRubNw1OFrVbRZPqZc3h+/iXaCSd1j8F5KmZ5Ioc216Jf9jqfv2PmKFxehc
         VpkmvW8epzNTOV0BD8lNhoQvFPxHVlwOz01QT9jS2UcJOknyGTB/sPhfmgOJlWtB3K
         qb9oGNGC/hESw==
From:   Marek Vasut <marex@denx.de>
To:     linux-crypto@vger.kernel.org
Cc:     ch@denx.de, Marek Vasut <marex@denx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [RFC][PATCH] crypto: caam - Add missing MODULE_ALIAS
Date:   Thu, 16 Sep 2021 15:41:54 +0200
Message-Id: <20210916134154.8764-1-marex@denx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add MODULE_ALIAS for caam and caam_jr modules, so they can be auto-loaded.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/caam/ctrl.c | 1 +
 drivers/crypto/caam/jr.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb07..f4a1babb418dc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -923,3 +923,4 @@ module_platform_driver(caam_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("FSL CAAM request backend");
 MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
+MODULE_ALIAS("platform:caam");
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6f669966ba2c1..3b7ea315226aa 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -635,3 +635,4 @@ module_exit(jr_driver_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("FSL CAAM JR request backend");
 MODULE_AUTHOR("Freescale Semiconductor - NMG/STC");
+MODULE_ALIAS("platform:caam_jr");
-- 
2.33.0

