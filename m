Return-Path: <SRS0=Eks8=4F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93788C34021
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 13:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731BA2070B
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Feb 2020 13:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgBQNj4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:39:56 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:35970 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgBQNjz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Feb 2020 08:39:55 -0500
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01HDddcD022495;
        Mon, 17 Feb 2020 05:39:40 -0800
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     vinay.yadav@chelsio.com, rohitm@chelsio.com,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH] MAINTAINERS: Update maintainers for chelsio crypto drivers
Date:   Mon, 17 Feb 2020 19:09:27 +0530
Message-Id: <20200217133927.22443-1-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.25.0.114.g5b0ca87
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This updates the maintainer list for chelsio crypto drivers.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38fe2f3f7b6f..12765a0b08e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4542,7 +4542,9 @@ S:	Supported
 F:	drivers/scsi/cxgbi/cxgb3i
 
 CXGB4 CRYPTO DRIVER (chcr)
-M:	Atul Gupta <atul.gupta@chelsio.com>
+M:	Ayush Sawal <ayush.sawal@chelsio.com>
+M:	Vinay Kumar Yadav <vinay.yadav@chelsio.com>
+M:	Rohit Maheshwari <rohitm@chelsio.com>
 L:	linux-crypto@vger.kernel.org
 W:	http://www.chelsio.com
 S:	Supported
-- 
2.25.0.114.g5b0ca87

