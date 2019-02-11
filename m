Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FA5C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE82F20838
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfBKLDc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:03:32 -0500
Received: from Galois.linutronix.de ([146.0.238.70]:38586 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfBKLDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 06:03:32 -0500
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1gt9N2-0002kJ-IA; Mon, 11 Feb 2019 12:03:28 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 2/2] crypto: user: remove crypto_cfg_mutex
Date:   Mon, 11 Feb 2019 12:02:51 +0100
Message-Id: <20190211110251.17377-2-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211110251.17377-1-bigeasy@linutronix.de>
References: <20190211110251.17377-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

crypto_cfg_mutex was never used since it got introduced in commit

  cac5818c25d04 ("crypto: user - Implement a generic crypto statistics")

Cc: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/crypto_user_stat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 3e9a53233d804..028be6a1ea781 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -20,8 +20,6 @@
 
 #define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
 
-static DEFINE_MUTEX(crypto_cfg_mutex);
-
 extern struct sock *crypto_nlsk;
 
 struct crypto_dump_info {
-- 
2.20.1

