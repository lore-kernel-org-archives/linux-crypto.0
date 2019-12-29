Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9844CC2D0CE
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EE1A21927
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588291;
	bh=FN1XiRPNgcl1byUgyyMQgAKON6dwUAIQGzOeQAYdqfw=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=B89ZDzJudm6CZ43qaCedkuz98F3epWWsJoTeZBZ5/PDRhyfivWohQyVRIQ8ioUli6
	 oeUbVRI6gtggJ6Tb3l7CE4McqqncoFtg1zh+KuLGQohXoQ92FECNbZDekel2w+7P8S
	 xr3ojUo8m/Ta5jgQ/bQWxazpA21u5nW9FqMjVpYk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfL2C6K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfL2C6H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:07 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D8521775
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588286;
        bh=FN1XiRPNgcl1byUgyyMQgAKON6dwUAIQGzOeQAYdqfw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=FhjfUcxhe9rv39Qg55PQApqr3hnkEQ1zMIxmBwDxPhBJ8xylk21nQo+wAFCKAt4vm
         sj2Z1nG/te8Y33LUro4YpHeQCykYxVwMO/pxRqka4mPNty9ZIRHI7E4jyGqF0T8fv1
         /NkfiIzXeKSoESHaeGWv1/lcd9OSJBGnz1Kiiogo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 09/28] crypto: shash - introduce crypto_grab_shash()
Date:   Sat, 28 Dec 2019 20:56:55 -0600
Message-Id: <20191229025714.544159-10-ebiggers@kernel.org>
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

