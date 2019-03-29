Return-Path: <SRS0=TS5y=SA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39017C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 13:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C84E2075E
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Mar 2019 13:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfC2NKL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Mar 2019 09:10:11 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:55429 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729524AbfC2NKL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Mar 2019 09:10:11 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1h9rGn-0001sc-Tx; Fri, 29 Mar 2019 14:10:06 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] crypto: scompress: return proper error code for allocation failure
Date:   Fri, 29 Mar 2019 14:09:55 +0100
Message-Id: <20190329130956.15935-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If scomp_acomp_comp_decomp() fails to allocate memory for the
destination then we never copy back the data we compressed.
It is probably best to return an error code instead 0 in case of
failure.
I haven't found any user that is using acomp_request_set_params()
without the `dst' buffer so there is probably no harm.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 crypto/scompress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/scompress.c b/crypto/scompress.c
index 6f8305f8c3004..aea1a8e5d1954 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -171,8 +171,10 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	if (!ret) {
 		if (!req->dst) {
 			req->dst = sgl_alloc(req->dlen, GFP_ATOMIC, NULL);
-			if (!req->dst)
+			if (!req->dst) {
+				ret = -ENOMEM;
 				goto out;
+			}
 		}
 		scatterwalk_map_and_copy(scratch_dst, req->dst, 0, req->dlen,
 					 1);
-- 
2.20.1

