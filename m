Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC36C3F68F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE5524125
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024086;
	bh=za0h9SO7Ok2opAq2WuG0SE2eh0YyqvISRvGT64IrBR8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2loJWkCdzHgyWbiAr0+7yMwaOY9UAAU5Ppn5bbRUBEENg0WYkiDJDfJFDJoOgRBvw
	 5+JQFSuvA8d0eePoWVb7M1cqRF3afx++4K07HpDmzJzAtR5Rvm6UI0Wwo7+11CuLLM
	 Bn49My5OwSOa9JVW/jnAkQbUD4NQt0nIYTW7rMYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgACEBZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726504AbgACEBZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:25 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A121522525
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024084;
        bh=za0h9SO7Ok2opAq2WuG0SE2eh0YyqvISRvGT64IrBR8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=orAwhMQYX+PDugze1qYuNjnQrcIqicl3d33suGreC5lqyhT1op5PgA/p+uQy1koAa
         vN+EUKPeH0mEPMHqRaUDVqiqlVns/8XJRvjNCiB4m2wRzaV2ssFFFQbBa43KfrZ8Qo
         N8lJ7wSJThJRlevtNlUymHBszsChuKSOhBa6sb8A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 03/28] crypto: shash - make struct shash_instance be the full size
Date:   Thu,  2 Jan 2020 19:58:43 -0800
Message-Id: <20200103035908.12048-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Define struct shash_instance in a way analogous to struct
skcipher_instance, struct aead_instance, and struct akcipher_instance,
where the struct is defined to include both the algorithm structure at
the beginning and the additional crypto_instance fields at the end.

This is needed to allow allocating shash instances directly using
kzalloc(sizeof(*inst) + sizeof(*ictx), ...) in the same way as skcipher,
aead, and akcipher instances.  In turn, that's needed to make spawns be
initialized in a consistent way everywhere.

Also take advantage of the addition of the base instance to struct
shash_instance by simplifying the shash_crypto_instance() and
shash_instance() functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/hash.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index d4b1be519590..7f25eff69d36 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -34,7 +34,13 @@ struct ahash_instance {
 };
 
 struct shash_instance {
-	struct shash_alg alg;
+	union {
+		struct {
+			char head[offsetof(struct shash_alg, base)];
+			struct crypto_instance base;
+		} s;
+		struct shash_alg alg;
+	};
 };
 
 struct crypto_ahash_spawn {
@@ -210,14 +216,13 @@ static inline void *crypto_shash_ctx(struct crypto_shash *tfm)
 static inline struct crypto_instance *shash_crypto_instance(
 	struct shash_instance *inst)
 {
-	return container_of(&inst->alg.base, struct crypto_instance, alg);
+	return &inst->s.base;
 }
 
 static inline struct shash_instance *shash_instance(
 	struct crypto_instance *inst)
 {
-	return container_of(__crypto_shash_alg(&inst->alg),
-			    struct shash_instance, alg);
+	return container_of(inst, struct shash_instance, s.base);
 }
 
 static inline struct shash_instance *shash_alg_instance(
-- 
2.24.1

