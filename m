Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D2AC33C9C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56B724650
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024088;
	bh=FN1XiRPNgcl1byUgyyMQgAKON6dwUAIQGzOeQAYdqfw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WmEgAySSIduBqttXycKULjWKFrHRxeSaxQTSenf00LE0JxLLcTYWWBTCcCciR78v4
	 kAKimqm+Zz5+FZhHba47UpHinhpSHmclEQ+uXDXJRzoIxpfG0YTGCasuevD0FrSZ4o
	 4TH1VLYoimbp3ij9i37dfHVlzDWjpTi0Zbi214V8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgACEB1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:33558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726837AbgACEB0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8A7122525
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024085;
        bh=FN1XiRPNgcl1byUgyyMQgAKON6dwUAIQGzOeQAYdqfw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RLya6r+Qig9q2JPT7vysRyqBEeJPSgRYj5oayfDPnfkFXij2uQPDZf7WI0tiOp9mI
         kZ+tJa+lVBHemSwM14IycgTd0kaHVJxPucdUuC90R3b2uLi+BeULi3R9SHC2nGXr9d
         6hW02dDyMBTF/G7DFp5frI8suKDiJgqBQxCeeX3Y=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 09/28] crypto: shash - introduce crypto_grab_shash()
Date:   Thu,  2 Jan 2020 19:58:49 -0800
Message-Id: <20200103035908.12048-10-ebiggers@kernel.org>
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

Currently, shash spawns are initialized by using shash_attr_alg() or
crypto_alg_mod_lookup() to look up the shash algorithm, then calling
crypto_init_shash_spawn().

This is different from how skcipher, aead, and akcipher spawns are
initialized (they use crypto_grab_*()), and for no good reason.  This
difference introduces unnecessary complexity.

The crypto_grab_*() functions used to have some problems, like not
holding a reference to the algorithm and requiring the caller to
initialize spawn->base.inst.  But those problems are fixed now.

So, let's introduce crypto_grab_shash() so that we can convert all
templates to the same way of initializing their spawns.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c                 |  9 +++++++++
 include/crypto/internal/hash.h | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 7243f60dab87..e0872ac2729a 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -469,6 +469,15 @@ static const struct crypto_type crypto_shash_type = {
 	.tfmsize = offsetof(struct crypto_shash, base),
 };
 
+int crypto_grab_shash(struct crypto_shash_spawn *spawn,
+		      struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_shash_type;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_shash);
+
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 3b426b09bd32..4d1a0d8e4f3a 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -128,11 +128,21 @@ int crypto_init_shash_spawn(struct crypto_shash_spawn *spawn,
 			    struct shash_alg *alg,
 			    struct crypto_instance *inst);
 
+int crypto_grab_shash(struct crypto_shash_spawn *spawn,
+		      struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask);
+
 static inline void crypto_drop_shash(struct crypto_shash_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
 }
 
+static inline struct shash_alg *crypto_spawn_shash_alg(
+	struct crypto_shash_spawn *spawn)
+{
+	return __crypto_shash_alg(spawn->base.alg);
+}
+
 struct shash_alg *shash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
-- 
2.24.1

