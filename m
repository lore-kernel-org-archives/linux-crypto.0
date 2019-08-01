Return-Path: <SRS0=q4N3=V5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A52C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 11:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C39214DA
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Aug 2019 11:18:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0AkX7V4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfHALSc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Aug 2019 07:18:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50880 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730613AbfHALS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Aug 2019 07:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-Id:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VK3Hh07yOV3Yg1wZLHnP2R78PkXj5PY4cFA9iQ9nZOw=; b=B0AkX7V4h01FBmBVo2bJD4cvyP
        qKTW2bt/BcFI725B5ENvjzRj7mbzfQaGXdUt2TMvUnPesvmCRYKxIb1Hve84GgjRKYd79cIJdkS46
        EV/POKHHmb/Fz+xgQtlp33iQ7CizTEwKbqRd5b93NX3S3KIbnMkCgJu3hWNmwZBUvR27x1HWYTTa7
        WdiMQYIRWyXxTd9c/vNqj9+JbyyJYcF5/10rto5Flb/lOyJvnDJjvw+/Uk9EMKheKFzVxQjIipJwU
        XpCV98bnQsZuTfMfd/YqINhYooGw1jUZ8EJla3EA3laebU4aST6EZPGcHhEP7xzxoHDrKY0aXCEW3
        NrzlHa7Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1ht968-0005fb-G0; Thu, 01 Aug 2019 11:18:16 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 85916202975E1; Thu,  1 Aug 2019 13:18:12 +0200 (CEST)
Message-Id: <20190801111541.800409062@infradead.org>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 13:13:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] crypto: Reduce default RT priority
References: <20190801111348.530242235@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto engine initializes its kworker thread to FIFO-99 (when
requesting RT priority), reduce this to FIFO-50.

FIFO-99 is the very highest priority available to SCHED_FIFO and
it not a suitable default; it would indicate the crypto work is the
most important work on the machine.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 crypto/crypto_engine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -425,7 +425,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  */
 struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
 	struct crypto_engine *engine;
 
 	if (!dev)


