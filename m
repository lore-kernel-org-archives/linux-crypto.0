Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E5DC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 820F7206C3
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgF2TTO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:19:14 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731791AbgF2TTN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:19:13 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jpolr-0003wR-3z; Mon, 29 Jun 2020 18:04:08 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Jun 2020 18:04:07 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 29 Jun 2020 18:04:07 +1000
Subject: [PATCH 7/7] hwrng: octeon - Fix sparse warnings
References: <20200629080316.GA11246@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1jpolr-0003wR-3z@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes a bunch of sparse warnings by adding __force tags
when casting __iomem poitners to u64.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/octeon-rng.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 7be8067ac4e87..8561a09b46814 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -33,7 +33,7 @@ static int octeon_rng_init(struct hwrng *rng)
 	ctl.u64 = 0;
 	ctl.s.ent_en = 1; /* Enable the entropy source.  */
 	ctl.s.rng_en = 1; /* Enable the RNG hardware.  */
-	cvmx_write_csr((u64)p->control_status, ctl.u64);
+	cvmx_write_csr((__force u64)p->control_status, ctl.u64);
 	return 0;
 }
 
@@ -44,14 +44,14 @@ static void octeon_rng_cleanup(struct hwrng *rng)
 
 	ctl.u64 = 0;
 	/* Disable everything.  */
-	cvmx_write_csr((u64)p->control_status, ctl.u64);
+	cvmx_write_csr((__force u64)p->control_status, ctl.u64);
 }
 
 static int octeon_rng_data_read(struct hwrng *rng, u32 *data)
 {
 	struct octeon_rng *p = container_of(rng, struct octeon_rng, ops);
 
-	*data = cvmx_read64_uint32((u64)p->result);
+	*data = cvmx_read64_uint32((__force u64)p->result);
 	return sizeof(u32);
 }
 
