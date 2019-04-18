Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA27C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B57F72083D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbfDRNk0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:26 -0400
Received: from foss.arm.com ([217.140.101.70]:33566 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388762AbfDRNkZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CE271688;
        Thu, 18 Apr 2019 06:40:25 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9475D3F5AF;
        Thu, 18 Apr 2019 06:40:23 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/35] crypto: ccree: fix backlog notifications
Date:   Thu, 18 Apr 2019 16:38:46 +0300
Message-Id: <20190418133913.9122-12-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We were doing backlog notification callbacks via a cipher/hash/aead
request structure cast to the base structure, which may or may not
work based on how the structure is laid in memory and is not safe.

Fix it by delegating the backlog notification to the appropriate
internal callbacks which are type aware.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org # v4.19+
---
 drivers/crypto/ccree/cc_aead.c        |  4 ++++
 drivers/crypto/ccree/cc_cipher.c      | 10 +++++++---
 drivers/crypto/ccree/cc_hash.c        | 28 +++++++++++++++++++--------
 drivers/crypto/ccree/cc_request_mgr.c | 11 ++++++++---
 4 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index a3527c00b29a..8c08a50a4008 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -220,6 +220,10 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(cc_req);
 	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
+	/* BACKLOG notification */
+	if (err == -EINPROGRESS)
+		goto done;
+
 	cc_unmap_aead_request(dev, areq);
 
 	/* Restore ordinary iv pointer */
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 15da3a35a6a1..1ba7c8a7bd52 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -818,9 +818,13 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 	struct crypto_skcipher *sk_tfm = crypto_skcipher_reqtfm(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
 
-	cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
-	memcpy(req->iv, req_ctx->iv, ivsize);
-	kzfree(req_ctx->iv);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_cipher_request(dev, req_ctx, ivsize, src, dst);
+		memcpy(req->iv, req_ctx->iv, ivsize);
+		kzfree(req_ctx->iv);
+	}
+
 	skcipher_request_complete(req, err);
 }
 
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 2c4ddc8fb76b..e824ab60b59c 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -280,8 +280,12 @@ static void cc_update_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
@@ -295,9 +299,13 @@ static void cc_digest_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
@@ -311,9 +319,13 @@ static void cc_hash_complete(struct device *dev, void *cc_req, int err)
 
 	dev_dbg(dev, "req=%pK\n", req);
 
-	cc_unmap_hash_request(dev, state, req->src, false);
-	cc_unmap_result(dev, state, digestsize, req->result);
-	cc_unmap_req(dev, state, ctx);
+	if (err != -EINPROGRESS) {
+		/* Not a BACKLOG notification */
+		cc_unmap_hash_request(dev, state, req->src, false);
+		cc_unmap_result(dev, state, digestsize, req->result);
+		cc_unmap_req(dev, state, ctx);
+	}
+
 	req->base.complete(&req->base, err);
 }
 
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 88c97a580dd8..c2e8190bb067 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -364,10 +364,12 @@ static void cc_enqueue_backlog(struct cc_drvdata *drvdata,
 			       struct cc_bl_item *bli)
 {
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
+	struct device *dev = drvdata_to_dev(drvdata);
 
 	spin_lock_bh(&mgr->bl_lock);
 	list_add_tail(&bli->list, &mgr->backlog);
 	++mgr->bl_len;
+	dev_dbg(dev, "+++bl len: %d\n", mgr->bl_len);
 	spin_unlock_bh(&mgr->bl_lock);
 	tasklet_schedule(&mgr->comptask);
 }
@@ -377,7 +379,7 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 	struct cc_req_mgr_handle *mgr = drvdata->request_mgr_handle;
 	struct cc_bl_item *bli;
 	struct cc_crypto_req *creq;
-	struct crypto_async_request *req;
+	void *req;
 	bool ivgen;
 	unsigned int total_len;
 	struct device *dev = drvdata_to_dev(drvdata);
@@ -387,17 +389,20 @@ static void cc_proc_backlog(struct cc_drvdata *drvdata)
 
 	while (mgr->bl_len) {
 		bli = list_first_entry(&mgr->backlog, struct cc_bl_item, list);
+		dev_dbg(dev, "---bl len: %d\n", mgr->bl_len);
+
 		spin_unlock(&mgr->bl_lock);
 
+
 		creq = &bli->creq;
-		req = (struct crypto_async_request *)creq->user_arg;
+		req = creq->user_arg;
 
 		/*
 		 * Notify the request we're moving out of the backlog
 		 * but only if we haven't done so already.
 		 */
 		if (!bli->notif) {
-			req->complete(req, -EINPROGRESS);
+			creq->user_cb(dev, req, -EINPROGRESS);
 			bli->notif = true;
 		}
 
-- 
2.21.0

