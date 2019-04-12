Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A1EC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 15:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 719AF2084D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 15:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfDLPOR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 11:14:17 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:37598 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLPOR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 11:14:17 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hExsd-0006Fi-8v; Fri, 12 Apr 2019 17:14:15 +0200
Date:   Fri, 12 Apr 2019 17:14:15 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de
Subject: [PATCH] crypto: scompress - initialize per-CPU variables on each CPU
Message-ID: <20190412151415.de33mytvtga6ihvi@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In commit 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead
multiple variables") I accidentally initialized multiple times the memory on a
random CPU. I should have initialize the memory on every CPU like it has
been done earlier. I didn't notice this because the scheduler didn't
move the task to another CPU.
Guenter managed to do that and the code crashed as expected.

Allocate / free per-CPU memory on each CPU.

Fixes: 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead multiple variables")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
Guenter, this should cure that.

 crypto/scompress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index da31f6fe1f833..712b4c2ea021f 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -76,7 +76,7 @@ static void crypto_scomp_free_scratches(void)
 	int i;
 
 	for_each_possible_cpu(i) {
-		scratch = raw_cpu_ptr(&scomp_scratch);
+		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		vfree(scratch->src);
 		vfree(scratch->dst);
@@ -93,7 +93,7 @@ static int crypto_scomp_alloc_scratches(void)
 	for_each_possible_cpu(i) {
 		void *mem;
 
-		scratch = raw_cpu_ptr(&scomp_scratch);
+		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
 		if (!mem)
-- 
2.20.1

