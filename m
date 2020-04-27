Return-Path: <SRS0=Oy//=6L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFBBC5519A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 09:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2584920663
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Apr 2020 09:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgD0Jtj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Apr 2020 05:49:39 -0400
Received: from foss.arm.com ([217.140.110.172]:32784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgD0Jti (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Apr 2020 05:49:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D0181FB;
        Mon, 27 Apr 2020 02:49:38 -0700 (PDT)
Received: from ssg-dev-vb.arm.com (E111385.Arm.com [10.50.65.9])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 988AF3F68F;
        Mon, 27 Apr 2020 02:49:34 -0700 (PDT)
From:   Hadar Gat <hadar.gat@arm.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hadar Gat <hadar.gat@arm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: [PATCH v2 3/3] hwrng: cctrng - update help description
Date:   Mon, 27 Apr 2020 12:49:06 +0300
Message-Id: <1587980946-363-4-git-send-email-hadar.gat@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587980946-363-1-git-send-email-hadar.gat@arm.com>
References: <1587980946-363-1-git-send-email-hadar.gat@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Improved the HW_RANDOM_CCTRNG help description.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
---
 drivers/char/hw_random/Kconfig | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index fc8bb31..d53470d 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -478,13 +478,14 @@ config HW_RANDOM_CCTRNG
 	tristate "Arm CryptoCell True Random Number Generator support"
 	depends on HAS_IOMEM & OF
 	help
-	  This driver provides support for the True Random Number
-	  Generator available in Arm TrustZone CryptoCell.
-
-	  To compile this driver as a module, choose M here: the module
+	  Say 'Y' to enable the True Random Number Generator driver for the
+	  Arm TrustZone CryptoCell family of processors.
+	  Currently the CryptoCell 713 and 703 are supported.
+	  The driver is supported only in SoC where Trusted Execution
+	  Environment is not used.
+	  Choose 'M' to compile this driver as a module. The module
 	  will be called cctrng.
-
-	  If unsure, say Y.
+	  If unsure, say 'N'.
 
 endif # HW_RANDOM
 
-- 
2.7.4

