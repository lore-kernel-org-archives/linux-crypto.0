Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E55C2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE01206F4
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588291;
	bh=axmFbQoKU2rhg2ddd/chkcLSQ3CDgMpshQeAmkY/HBg=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Bu2jcqojYxVpcsf/H8S+FrSxgGbevy3GEytzqOZ/IgB7iZ74UrmhI8es3cco18Zni
	 Hh0E4XX+/YZu/TuQwi8ZRrNO3C803NMDBmNVwIKdlgqf1QF45ASFlxBs50UN1GVaHR
	 J2DVphZAlaTOyKLxJNkYLn+RSh61u9Ge3TwlH7Zk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfL2C6K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfL2C6H (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:07 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F8BE206F4
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588286;
        bh=axmFbQoKU2rhg2ddd/chkcLSQ3CDgMpshQeAmkY/HBg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XxK75LoyCG8Xt9BtkL19Nd+JOovqviW7Hjbh967JyrD2pWEbO42ZLIN+YnUuqOy+T
         oFZI7rw4Grg/MS/WDkQlyX/Ml8ZhLYvorXbWbGSbw8WxUpJxW9rdZfMhAoeonC1R7j
         wzCJypdojNaeCK9FXreruN70Ar5yRA0+aau4CvnM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 10/28] crypto: ahash - introduce crypto_grab_ahash()
Date:   Sat, 28 Dec 2019 20:56:56 -0600
Message-Id: <20191229025714.544159-11-ebiggers@kernel.org>
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

Currently, ahash spawns are initialized by using ahash_attr_alg() or
crypto_find_alg() to look up the ahash algorithm, then calling
crypto_init_ahash_spawn().

This is different from how skcipher, aead, and akcipher spawns are
initialized (they use crypto_grab_*()), and for no good reason.  This
difference introduces unnecessary complexity.

The crypto_grab_*() functions used to have some problems, like not
holding a reference to the algorithm and requiring the caller to
initialize spawn->base.inst.  But those problems are fixed now.

So, let's introduce crypto_grab_ahash() so that we can convert all
templates to the same way of initializing their spawns.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 |  9 +++++++++
 include/crypto/internal/hash.h | 10 ++++++++++
 2 files changed, 19 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 181bd851b429..e98a1398ed7f 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -556,6 +556,15 @@ const struct crypto_type crypto_ahash_type = {
 };
 EXPORT_SYMBOL_GPL(crypto_ahash_type);
 
+int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
+		      struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask)
+{
+	spawn->base.frontend = &crypto_ahash_type;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_ahash);
+
 struct crypto_ahash *crypto_alloc_ahash(const char *alg_name, u32 type,
 					u32 mask)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 4d1a0d8e4f3a..e1024fa0032f 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -109,11 +109,21 @@ int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
 			    struct hash_alg_common *alg,
 			    struct crypto_instance *inst);
 
+int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
+		      struct crypto_instance *inst,
+		      const char *name, u32 type, u32 mask);
+
 static inline void crypto_drop_ahash(struct crypto_ahash_spawn *spawn)
 {
 	crypto_drop_spawn(&spawn->base);
 }
 
+static inline struct hash_alg_common *crypto_spawn_ahash_alg(
+	struct crypto_ahash_spawn *spawn)
+{
+	return __crypto_hash_alg_common(spawn->base.alg);
+}
+
 struct hash_alg_common *ahash_attr_alg(struct rtattr *rta, u32 type, u32 mask);
 
 int crypto_register_shash(struct shash_alg *alg);
-- 
2.24.1

