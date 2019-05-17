Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6759C04E87
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89E8E20848
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 09:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfEQJ3K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 05:29:10 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57047 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbfEQJ3K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 05:29:10 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-00056R-Q5; Fri, 17 May 2019 11:29:07 +0200
Received: from sha by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1hRZAp-0004Go-2u; Fri, 17 May 2019 11:29:07 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/3] crypto: caam: remove unused defines
Date:   Fri, 17 May 2019 11:29:03 +0200
Message-Id: <20190517092905.1264-2-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517092905.1264-1-s.hauer@pengutronix.de>
References: <20190517092905.1264-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The CAAM driver defines its own debug() macro, but it is unused. Remove
it.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/crypto/caam/caamalg.c  | 7 -------
 drivers/crypto/caam/caamhash.c | 8 --------
 2 files changed, 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3e23d4b2cce2..007c35cfc670 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -77,13 +77,6 @@
 #define DESC_MAX_USED_BYTES		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
-#ifdef DEBUG
-/* for print_hex_dumps with line references */
-#define debug(format, arg...) printk(format, arg)
-#else
-#define debug(format, arg...)
-#endif
-
 struct caam_alg_entry {
 	int class1_alg_type;
 	int class2_alg_type;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 7205d9f4029e..8aee7c9bf862 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -82,14 +82,6 @@
 #define HASH_MSG_LEN			8
 #define MAX_CTX_LEN			(HASH_MSG_LEN + SHA512_DIGEST_SIZE)
 
-#ifdef DEBUG
-/* for print_hex_dumps with line references */
-#define debug(format, arg...) printk(format, arg)
-#else
-#define debug(format, arg...)
-#endif
-
-
 static struct list_head hash_list;
 
 /* ahash per-session context */
-- 
2.20.1

