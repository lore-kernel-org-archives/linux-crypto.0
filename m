Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28F6C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE7920838
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfBKLDf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:03:35 -0500
Received: from Galois.linutronix.de ([146.0.238.70]:38589 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfBKLDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 06:03:35 -0500
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1gt9N0-0002kJ-6Z; Mon, 11 Feb 2019 12:03:26 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Atul Gupta <atul.gupta@chelsio.com>,
        Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 1/2] crypto: chtls: remove cdev_list_lock
Date:   Mon, 11 Feb 2019 12:02:50 +0100
Message-Id: <20190211110251.17377-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Last user of cdev_list_lock was removed in commit

  6422ccc5fbefb ("crypto/chelsio/chtls: listen fails with multiadapt")

Cc: Atul Gupta <atul.gupta@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 563f8fe7686ad..dd2daf2a54e06 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -30,7 +30,6 @@
  */
 static LIST_HEAD(cdev_list);
 static DEFINE_MUTEX(cdev_mutex);
-static DEFINE_MUTEX(cdev_list_lock);
 
 static DEFINE_MUTEX(notify_mutex);
 static RAW_NOTIFIER_HEAD(listen_notify_list);
-- 
2.20.1

