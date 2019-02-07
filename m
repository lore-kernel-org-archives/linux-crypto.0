Return-Path: <SRS0=Jc5W=QO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EB1C282C2
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 13:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5994121904
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Feb 2019 13:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfBGNoT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:44:19 -0500
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37324 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfBGNoT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Feb 2019 08:44:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C666EBD;
        Thu,  7 Feb 2019 05:44:19 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6D383F675;
        Thu,  7 Feb 2019 05:44:17 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     linux-kernel@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drag <ofir.drang@arm.com>
Subject: [PATCH] MAINTAINERS: crypto: ccree: remove co-maintainer
Date:   Thu,  7 Feb 2019 15:44:15 +0200
Message-Id: <20190207134415.311-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The best-laid plans of mice and men often go awry.
Remove Yael C. as co-maintainer as she moved on to other endeavours.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c68de3cfd80..45ea92863a05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3511,7 +3511,6 @@ F:	include/linux/spi/cc2520.h
 F:	Documentation/devicetree/bindings/net/ieee802154/cc2520.txt
 
 CCREE ARM TRUSTZONE CRYPTOCELL REE DRIVER
-M:	Yael Chemla <yael.chemla@foss.arm.com>
 M:	Gilad Ben-Yossef <gilad@benyossef.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
-- 
2.20.1

