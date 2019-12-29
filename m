Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC25C2D0D1
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914AC21927
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588292;
	bh=45LRpqjc8rNhpMtauQo9/WmcXxMmtA/5AuM8d0DzFeg=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QXhxRTagX5zPcboQigsHiXwEvo/ezHKQmyGQuGeUHzfinhUpNzqZG3KLugqhDGGiy
	 XDrNamAdpq17VqiyPgvoPMaSzF3pBRx+Lr2hBUUDgrOQHTHzje9U1KNA2bM0OculiB
	 VJoF9kt5U0BOsayTvxeFUa53v5uCmB6DCOPXVLwU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfL2C6K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbfL2C6I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:08 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0835421744
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588287;
        bh=45LRpqjc8rNhpMtauQo9/WmcXxMmtA/5AuM8d0DzFeg=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EhRntJnHflr7aqBCaPESUJueT7P6XOk/15XMDuPvEsLwlSRBMWhBzKVR59NyDDbNG
         m7hFOFMUuNxBX2E4qZCpl3WuQ/fWSMIdO5R7j7BtIhXWu40a7YcTSllrE0Ku2l/Fnv
         1i0reSIYWacj7hzot/0r4GGJdXJlfduXhmeyA42k=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 11/28] crypto: cipher - introduce crypto_cipher_spawn and crypto_grab_cipher()
Date:   Sat, 28 Dec 2019 20:56:57 -0600
Message-Id: <20191229025714.544159-12-ebiggers@kernel.org>
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

Currently, "cipher" (single-block cipher) spawns are usually initialized
by using crypto_get_attr_alg() to look up the algorithm, then calling
crypto_init_spawn().  In one case, crypto_grab_spawn() is used directly.

The former way is different from how skcipher, aead, and akcipher spawns
are initialized (they use crypto_grab_*()), and for no good reason.
This difference introduces unnecessary complexity.

The crypto_grab_*() functions used to have some problems, like not
holding a reference to the algorithm and requiring the caller to
initialize spawn->base.inst.  But those problems are fixed now.

Also, the cipher spawns are not strongly typed; e.g., the API requires
that the user manually specify the flags CRYPTO_ALG_TYPE_CIPHER and
CRYPTO_ALG_TYPE_MASK.  Though the "cipher" algorithm type itself isn't
yet strongly typed, we can start by making the spawns strongly typed.

So, let's introduce a new 'struct crypto_cipher_spawn', and functions
crypto_grab_cipher() and crypto_drop_cipher() to grab and drop them.

Later patches will convert all cipher spawns to use these, then make
crypto_spawn_cipher() take 'struct crypto_cipher_spawn' as well, instead
of a bare 'struct crypto_spawn' as it currently does.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cipher.c         | 11 +++++++++++
 include/crypto/algapi.h | 19 +++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/crypto/cipher.c b/crypto/cipher.c
index aadd51cb7250..924d9f6575f9 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -92,3 +92,14 @@ void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 	cipher_crypt_one(tfm, dst, src, false);
 }
 EXPORT_SYMBOL_GPL(crypto_cipher_decrypt_one);
+
+int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
+		       struct crypto_instance *inst,
+		       const char *name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_grab_cipher);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 2779c8d34ba9..aad3348f60d1 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -208,6 +208,25 @@ static inline void *crypto_instance_ctx(struct crypto_instance *inst)
 	return inst->__ctx;
 }
 
+struct crypto_cipher_spawn {
+	struct crypto_spawn base;
+};
+
+int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
+		       struct crypto_instance *inst,
+		       const char *name, u32 type, u32 mask);
+
+static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_alg *crypto_spawn_cipher_alg(
+	struct crypto_cipher_spawn *spawn)
+{
+	return spawn->base.alg;
+}
+
 static inline struct crypto_cipher *crypto_spawn_cipher(
 	struct crypto_spawn *spawn)
 {
-- 
2.24.1

