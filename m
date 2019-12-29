Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7ABAC2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A47A821775
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588285;
	bh=za0h9SO7Ok2opAq2WuG0SE2eh0YyqvISRvGT64IrBR8=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=c97fLk1s7Ogmmk8uXxgrZE15bBWcULeAVo7Sz3f5dnPfc2oo/HzXEw2s3c3CIQ5nk
	 NOG6NMWWRtpjWoOOu2Qe1W46XL17M9y4Y/UQeso9Gs+Do4HmSnk0doOWe/lZ4sgxnH
	 SBCRDqjyUZZNX8zoZJU8Ml8V6JXjG774yr2lmHfk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfL2C6E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfL2C6E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:04 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B125206F4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588283;
        bh=za0h9SO7Ok2opAq2WuG0SE2eh0YyqvISRvGT64IrBR8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PNi9tOEXqNXp9S/mzmycYlAG6s6OkXBKaYMtTsb3m15kKwxJS7vvaFLlnMVaHbnDp
         zIT3qVBn1sQh3TgizEv75hdtZV5POL4bIdp11H+ct4N+zxAFPOv2y4qOEFN6TxFP3H
         TjsUyHm005JnQMDqzPo0pOT8b1ijN0VPfQ9N/XgU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 03/28] crypto: shash - make struct shash_instance be the full size
Date:   Sat, 28 Dec 2019 20:56:49 -0600
Message-Id: <20191229025714.544159-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229025714.544159-1-ebiggers@kernel.org>
References: <20191229025714.544159-1-ebiggers@kernel.org>
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

