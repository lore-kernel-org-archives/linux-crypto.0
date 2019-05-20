Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E55CC04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B0E12171F
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558371291;
	bh=b3o9a+Bom0TSbqpBjhZ5ZhVzjcpDQcaS/SCZlBKZ6UM=;
	h=From:To:Subject:Date:List-ID:From;
	b=a6wGgEiQ9wTTgRhX7p7dGNotFQVIp+e3Ero4UJG+7zXvRyvAk81NpdZfM3Q9fJFRn
	 u6aNofAKtdNCbzk4SHrs66YaXIcEObznjRzLMljqm2v7auRIRGvzNVLsH1Z9+1/zhZ
	 zFW47ENT6wwtOHi7FlEef1CuVJhWPafBkq+IXPZo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbfETQyu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388746AbfETQyu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:54:50 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB1B216B7;
        Mon, 20 May 2019 16:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558371289;
        bh=b3o9a+Bom0TSbqpBjhZ5ZhVzjcpDQcaS/SCZlBKZ6UM=;
        h=From:To:Subject:Date:From;
        b=LhKUOXkYDJaNSiJ+n6wfjL9zCQcHRTu6EqHwznMbztKhzmGi9ICaRxTp2vF2NNqe1
         wYPLNrUA17YQsvdueAtaimBzUwWirm41IBsaJIQnO7BKmAomWT55SL20LpUteP2COu
         Q8PkZRzoMiRop9R1X2D9YAVcuJwosJavtzw45VeA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hash - remove CRYPTO_ALG_TYPE_DIGEST
Date:   Mon, 20 May 2019 09:54:46 -0700
Message-Id: <20190520165446.169693-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Remove the unnecessary constant CRYPTO_ALG_TYPE_DIGEST, which has the
same value as CRYPTO_ALG_TYPE_HASH.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/architecture.rst | 4 +---
 crypto/cryptd.c                       | 2 +-
 include/linux/crypto.h                | 1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index ee8ff0762d7fa..3eae1ae7f7981 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -208,9 +208,7 @@ the aforementioned cipher types:
 -  CRYPTO_ALG_TYPE_KPP Key-agreement Protocol Primitive (KPP) such as
    an ECDH or DH implementation
 
--  CRYPTO_ALG_TYPE_DIGEST Raw message digest
-
--  CRYPTO_ALG_TYPE_HASH Alias for CRYPTO_ALG_TYPE_DIGEST
+-  CRYPTO_ALG_TYPE_HASH Raw message digest
 
 -  CRYPTO_ALG_TYPE_SHASH Synchronous multi-block hash
 
diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 1bf777b765127..c34d10309b1b3 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -925,7 +925,7 @@ static int cryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
 		return cryptd_create_skcipher(tmpl, tb, &queue);
-	case CRYPTO_ALG_TYPE_DIGEST:
+	case CRYPTO_ALG_TYPE_HASH:
 		return cryptd_create_hash(tmpl, tb, &queue);
 	case CRYPTO_ALG_TYPE_AEAD:
 		return cryptd_create_aead(tmpl, tb, &queue);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f2565a1031584..311237b1dab02 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -54,7 +54,6 @@
 #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
-#define CRYPTO_ALG_TYPE_DIGEST		0x0000000e
 #define CRYPTO_ALG_TYPE_HASH		0x0000000e
 #define CRYPTO_ALG_TYPE_SHASH		0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000f
-- 
2.21.0.1020.gf2820cf01a-goog

