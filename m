Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19376C4725A
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96112184D
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397631;
	bh=yP0ei9eeyV64D7gyzyKJiWXxmKwgWffX6x3jaj5oYJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gBhhwxkrLKABIaUKqefXCb5FUAsQ056eFsdDs+cLZYmtCPEfHJ6FS6cHZ439aX2nx
	 sBAJPEiOSaALXyiI2kA7SRRWsTHeSk5I42nn0o2m758ijmq0zL/v/EwW4XW5ZRytcm
	 oLxBgwkftYAtDQLm382NyyffHVZaZ8pjRduqdV30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbgEBFdu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEBFdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21EC821974;
        Sat,  2 May 2020 05:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397624;
        bh=yP0ei9eeyV64D7gyzyKJiWXxmKwgWffX6x3jaj5oYJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBUQzoNQj4V13fMB1Vpahw0ccNQnb3jfpta6w3juUullhJDNAFWq38H2RetXCjjTT
         +MC6q0hNSHRUf8qtr1HloK+AOvl95VtwjoIZNnWizGzV6hJsuwF2q4u0SvWr3xYcb6
         M90cy9XT2wYZFnnkEJe2Dg6FZz5+NSLZgrP6yJVU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@samsung.com>
Subject: [PATCH 11/20] crypto: s5p-sss - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:13 -0700
Message-Id: <20200502053122.995648-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Kamil Konieczny <k.konieczny@samsung.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/s5p-sss.c | 39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 2a16800d257954..341433fbcc4a8b 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1520,37 +1520,6 @@ static int s5p_hash_update(struct ahash_request *req)
 	return s5p_hash_enqueue(req, true); /* HASH_OP_UPDATE */
 }
 
-/**
- * s5p_hash_shash_digest() - calculate shash digest
- * @tfm:	crypto transformation
- * @flags:	tfm flags
- * @data:	input data
- * @len:	length of data
- * @out:	output buffer
- */
-static int s5p_hash_shash_digest(struct crypto_shash *tfm, u32 flags,
-				 const u8 *data, unsigned int len, u8 *out)
-{
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, data, len, out);
-}
-
-/**
- * s5p_hash_final_shash() - calculate shash digest
- * @req:	AHASH request
- */
-static int s5p_hash_final_shash(struct ahash_request *req)
-{
-	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
-	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
-
-	return s5p_hash_shash_digest(tctx->fallback, req->base.flags,
-				     ctx->buffer, ctx->bufcnt, req->result);
-}
-
 /**
  * s5p_hash_final() - close up hash and calculate digest
  * @req:	AHASH request
@@ -1582,8 +1551,12 @@ static int s5p_hash_final(struct ahash_request *req)
 	if (ctx->error)
 		return -EINVAL; /* uncompleted hash is not needed */
 
-	if (!ctx->digcnt && ctx->bufcnt < BUFLEN)
-		return s5p_hash_final_shash(req);
+	if (!ctx->digcnt && ctx->bufcnt < BUFLEN) {
+		struct s5p_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+
+		return crypto_shash_tfm_digest(tctx->fallback, ctx->buffer,
+					       ctx->bufcnt, req->result);
+	}
 
 	return s5p_hash_enqueue(req, false); /* HASH_OP_FINAL */
 }
-- 
2.26.2

