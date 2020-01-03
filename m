Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A8CC33C8C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F0E9222C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024086;
	bh=+9Xnas3uoUxlpPskJipaxSFlWbLDFA4vpAqy8OR6gNc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hfYB0yYUY0vRbUea11kd9Rkqc7QeTxX/JMc2khLyoWRyQH03q4iYXOdIRD8WGz/RQ
	 /BhRUFC3XcmGhtDh35WDlfDCxuGzVBMyYB5Ptw5GTC9n48lxE+xogl4ieSMmvhWqxM
	 9kDV76AQVX9iAZyO+9QVSzJXNcCtfF+z13LjM/Qw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgACEBZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgACEBZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:25 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D09C82253D
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024084;
        bh=+9Xnas3uoUxlpPskJipaxSFlWbLDFA4vpAqy8OR6gNc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=VgkvvxjBWtwK5HxRZ7SOg83Sk/Q01jEq4nCH6wGH8G9JcWabrdJk0yIoLaAJVxrLr
         tArDme49tAS1I6TOiqPbX/SkxUWKTBkMS3TtqQwOxcnq0Q4Yw/RzO7P8bYiY908XXt
         66PObDJBlVXBiYo+jiUxaM1qSSykQAt0zXm5B5RM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 04/28] crypto: ahash - make struct ahash_instance be the full size
Date:   Thu,  2 Jan 2020 19:58:44 -0800
Message-Id: <20200103035908.12048-5-ebiggers@kernel.org>
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

Define struct ahash_instance in a way analogous to struct
skcipher_instance, struct aead_instance, and struct akcipher_instance,
where the struct is defined to include both the algorithm structure at
the beginning and the additional crypto_instance fields at the end.

This is needed to allow allocating ahash instances directly using
kzalloc(sizeof(*inst) + sizeof(*ictx), ...) in the same way as skcipher,
aead, and akcipher instances.  In turn, that's needed to make spawns be
initialized in a consistent way everywhere.

Also take advantage of the addition of the base instance to struct
ahash_instance by simplifying the ahash_crypto_instance() and
ahash_instance() functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/internal/hash.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 7f25eff69d36..3b426b09bd32 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -30,7 +30,13 @@ struct crypto_hash_walk {
 };
 
 struct ahash_instance {
-	struct ahash_alg alg;
+	union {
+		struct {
+			char head[offsetof(struct ahash_alg, halg.base)];
+			struct crypto_instance base;
+		} s;
+		struct ahash_alg alg;
+	};
 };
 
 struct shash_instance {
@@ -155,13 +161,13 @@ static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 static inline struct crypto_instance *ahash_crypto_instance(
 	struct ahash_instance *inst)
 {
-	return container_of(&inst->alg.halg.base, struct crypto_instance, alg);
+	return &inst->s.base;
 }
 
 static inline struct ahash_instance *ahash_instance(
 	struct crypto_instance *inst)
 {
-	return container_of(&inst->alg, struct ahash_instance, alg.halg.base);
+	return container_of(inst, struct ahash_instance, s.base);
 }
 
 static inline void *ahash_instance_ctx(struct ahash_instance *inst)
-- 
2.24.1

