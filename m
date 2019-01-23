Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4146CC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1718221726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfAWL77 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:59 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40663 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfAWL77 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 37E0518293;
        Wed, 23 Jan 2019 12:59:57 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id osTRjk52EFKc; Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id A69051848F;
        Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B17A1A077;
        Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F6E61A075;
        Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id 634571CA2;
        Wed, 23 Jan 2019 12:59:55 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id 61452409B9; Wed, 23 Jan 2019 12:59:55 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vincent Whitchurch <rabinv@axis.com>,
        Lars Persson <larper@axis.com>
Subject: [PATCH 7/7] crypto: axis - move request unmap outside of the queue lock
Date:   Wed, 23 Jan 2019 12:59:46 +0100
Message-Id: <f2ecac9d188d1d7e1939951a758ff2ac448ad7c5.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Vincent Whitchurch <rabinv@axis.com>

The request unmap and bounce buffer copying is currently unnecessarily
done while holding the queue spin lock.

Signed-off-by: Lars Persson <larper@axis.com>
Signed-off-by: Vincent Whitchurch <rabinv@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 71ef9ce68fd8..47b76cf2c764 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2127,11 +2127,7 @@ static void artpec6_crypto_task(unsigned long data)
 
 		list_move_tail(&req->list, &complete_done);
 
-		artpec6_crypto_dma_unmap_all(req);
-		artpec6_crypto_copy_bounce_buffers(req);
-
 		ac->pending_count--;
-		artpec6_crypto_common_destroy(req);
 	}
 
 	artpec6_crypto_process_queue(ac, &complete_in_progress);
@@ -2142,6 +2138,10 @@ static void artpec6_crypto_task(unsigned long data)
 	 * to allow new request submissions from the callbacks.
 	 */
 	list_for_each_entry_safe(req, n, &complete_done, list) {
+		artpec6_crypto_dma_unmap_all(req);
+		artpec6_crypto_copy_bounce_buffers(req);
+		artpec6_crypto_common_destroy(req);
+
 		req->complete(req->req);
 	}
 
-- 
2.11.0

