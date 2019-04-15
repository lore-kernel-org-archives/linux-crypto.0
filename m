Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DA8C10F14
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455FB2084E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555288753;
	bh=XKv/WY5HRVs536knZXWZqPLOw+TI8Du1/WeDOvb264g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sfmMnSgvjvoku+26A3RhC6bun2Xhz8MZnSI5FoBFObL34CW84BPdEpUwcjyvDQiC1
	 x81pL1paoPxZmUHHWHCVVmPyotDXVnMwAMyMITdTyuxFjXZwxyEqoChtb7fTLAum9o
	 c24EDmUCuB/ZxM4HtqrADMCLNVSId+sSNNqttgLw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbfDOAjM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 20:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbfDOAjM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 20:39:12 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF0420870;
        Mon, 15 Apr 2019 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555288751;
        bh=XKv/WY5HRVs536knZXWZqPLOw+TI8Du1/WeDOvb264g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlnFWiWuIAtglWzdtdKJjXevwMAwTlBt8vI3rU6duulirNBxPG2N/MBcO37duziCi
         Qt9q8dHLI1HmkAE60c6pzhVYDwrbzO/2zNzk8Bu5plUe9Fj51/yISk2VKhfFQF5xkh
         5cPgzmGwMJ50oHtgAP2CjpA4i5e4r6RemhqVD6Vg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
Subject: [RFC PATCH 2/3] crypto: nx - don't abuse shash MAY_SLEEP flag
Date:   Sun, 14 Apr 2019 17:37:08 -0700
Message-Id: <20190415003709.1531-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415003709.1531-1-ebiggers@kernel.org>
References: <20190415003709.1531-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The nx driver uses the MAY_SLEEP flag in shash_desc::flags as an
indicator to not retry sending the operation to the hardware as many
times before returning -EBUSY.  This is bogus because (1) that's not
what the MAY_SLEEP flag is for, and (2) the shash API doesn't allow
failing if the hardware is busy anyway.

For now, just make it always retry the larger number of times.  This
doesn't actually fix this driver, but it at least makes it not use the
shash_desc::flags field anymore.  Then this field can be removed, as no
other drivers use it.

Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/nx/nx-aes-xcbc.c | 12 ++++--------
 drivers/crypto/nx/nx-sha256.c   |  6 ++----
 drivers/crypto/nx/nx-sha512.c   |  6 ++----
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/nx/nx-aes-xcbc.c b/drivers/crypto/nx/nx-aes-xcbc.c
index ad3358e74f5c4..8f5820b78a83b 100644
--- a/drivers/crypto/nx/nx-aes-xcbc.c
+++ b/drivers/crypto/nx/nx-aes-xcbc.c
@@ -105,8 +105,7 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 	if (rc)
 		goto out;
 	atomic_inc(&(nx_ctx->stats->aes_ops));
@@ -134,8 +133,7 @@ static int nx_xcbc_empty(struct shash_desc *desc, u8 *out)
 	nx_ctx->op.inlen = (nx_ctx->in_sg - in_sg) * sizeof(struct nx_sg);
 	nx_ctx->op.outlen = (nx_ctx->out_sg - out_sg) * sizeof(struct nx_sg);
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 	if (rc)
 		goto out;
 	atomic_inc(&(nx_ctx->stats->aes_ops));
@@ -279,8 +277,7 @@ static int nx_xcbc_update(struct shash_desc *desc,
 			goto out;
 		}
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 		if (rc)
 			goto out;
 
@@ -361,8 +358,7 @@ static int nx_xcbc_final(struct shash_desc *desc, u8 *out)
 		goto out;
 	}
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 	if (rc)
 		goto out;
 
diff --git a/drivers/crypto/nx/nx-sha256.c b/drivers/crypto/nx/nx-sha256.c
index a6764af83c6dc..e06f0431dee5f 100644
--- a/drivers/crypto/nx/nx-sha256.c
+++ b/drivers/crypto/nx/nx-sha256.c
@@ -162,8 +162,7 @@ static int nx_sha256_update(struct shash_desc *desc, const u8 *data,
 			goto out;
 		}
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 		if (rc)
 			goto out;
 
@@ -243,8 +242,7 @@ static int nx_sha256_final(struct shash_desc *desc, u8 *out)
 		goto out;
 	}
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 	if (rc)
 		goto out;
 
diff --git a/drivers/crypto/nx/nx-sha512.c b/drivers/crypto/nx/nx-sha512.c
index 92956bc6e45ee..0293b17903d0c 100644
--- a/drivers/crypto/nx/nx-sha512.c
+++ b/drivers/crypto/nx/nx-sha512.c
@@ -166,8 +166,7 @@ static int nx_sha512_update(struct shash_desc *desc, const u8 *data,
 			goto out;
 		}
 
-		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-				   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+		rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 		if (rc)
 			goto out;
 
@@ -249,8 +248,7 @@ static int nx_sha512_final(struct shash_desc *desc, u8 *out)
 		goto out;
 	}
 
-	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op,
-			   desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP);
+	rc = nx_hcall_sync(nx_ctx, &nx_ctx->op, 0);
 	if (rc)
 		goto out;
 
-- 
2.21.0

