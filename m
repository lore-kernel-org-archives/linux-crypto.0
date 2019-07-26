Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4AAC7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 20:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CB822BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 20:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfGZUTO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 16:19:14 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50341 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfGZUTO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 16:19:14 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hr6gG-00020s-T7; Fri, 26 Jul 2019 22:19:09 +0200
Date:   Fri, 26 Jul 2019 22:19:07 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     linux-crypto@vger.kernel.org
cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: Remove redundant #ifdef in crypto_yield()
Message-ID: <alpine.DEB.2.21.1907262217130.1791@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While looking at CONFIG_PREEMPT dependencies treewide the #ifdef in
crypto_yield() matched.

CONFIG_PREEMPT and CONFIG_PREEMPT_VOLUNTARY are mutually exclusive so the
extra !CONFIG_PREEMPT conditional is redundant.

cond_resched() has only an effect when CONFIG_PREEMPT_VOLUNTARY is set,
otherwise it's a stub which the compiler optimizes out.

Remove the whole conditional.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 include/crypto/algapi.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -409,10 +409,8 @@ static inline int crypto_memneq(const vo
 
 static inline void crypto_yield(u32 flags)
 {
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_VOLUNTARY)
 	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
 		cond_resched();
-#endif
 }
 
 int crypto_register_notifier(struct notifier_block *nb);
