Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F88C2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7221207FD
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656205;
	bh=o4OzcvqIdyJ6YIW9hU9gmpOjoV0BHrX/rhFquRitSjY=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=N+WLRaT4QlwaFTnsDtTXR6rWVX0qR8NS81X8rfyCxfE4uTPK0JZI3qTgQVEw0NpkE
	 i+4ZR9LS4EjrD1GXrPZhswNynp4qNgD0Y3fJtL7oOX+fzFNggdtpuV07fVA8FwbZnm
	 +BwdPV4LScFq088S+AOUcYMCma7ZuknSSd5HLGnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfL2VuF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:55490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbfL2VuF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:05 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF5D20748
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656203;
        bh=o4OzcvqIdyJ6YIW9hU9gmpOjoV0BHrX/rhFquRitSjY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=W/4QAoazyzaYF2oFD3gzi7dU1HUZ3ggkSJ3uURHGvpngJ85Tk+3dgnvvX3v2Ff6Ux
         XNj3tW5rs5z4nE3QsSXD9/9Y0Jvx24SRtx3QpDr/GAQCiRQ6MKWpBZgrg8vn9RE4X3
         GC7Oo5t76W78HYUvCtCOOZOOYouSK7SKWvl+BKJw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/6] crypto: hash - add support for new way of freeing instances
Date:   Sun, 29 Dec 2019 15:48:25 -0600
Message-Id: <20191229214830.260965-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229214830.260965-1-ebiggers@kernel.org>
References: <20191229214830.260965-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support to shash and ahash for the new way of freeing instances
(already used for skcipher, aead, and akcipher) where a ->free() method
is installed to the instance struct itself.  These methods are more
strongly-typed than crypto_template::free(), which they replace.

This will allow removing support for the old way of freeing instances.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 13 +++++++++++++
 crypto/shash.c                 | 13 +++++++++++++
 include/crypto/internal/hash.h |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index c77717fcea8e..61e374d76b04 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -511,6 +511,18 @@ static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
 	return crypto_alg_extsize(alg);
 }
 
+static void crypto_ahash_free_instance(struct crypto_instance *inst)
+{
+	struct ahash_instance *ahash = ahash_instance(inst);
+
+	if (!ahash->free) {
+		inst->tmpl->free(inst);
+		return;
+	}
+
+	ahash->free(ahash);
+}
+
 #ifdef CONFIG_NET
 static int crypto_ahash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -547,6 +559,7 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 static const struct crypto_type crypto_ahash_type = {
 	.extsize = crypto_ahash_extsize,
 	.init_tfm = crypto_ahash_init_tfm,
+	.free = crypto_ahash_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
diff --git a/crypto/shash.c b/crypto/shash.c
index 4d6ccb59e126..2f6adb49727b 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -423,6 +423,18 @@ static int crypto_shash_init_tfm(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static void crypto_shash_free_instance(struct crypto_instance *inst)
+{
+	struct shash_instance *shash = shash_instance(inst);
+
+	if (!shash->free) {
+		inst->tmpl->free(inst);
+		return;
+	}
+
+	shash->free(shash);
+}
+
 #ifdef CONFIG_NET
 static int crypto_shash_report(struct sk_buff *skb, struct crypto_alg *alg)
 {
@@ -459,6 +471,7 @@ static void crypto_shash_show(struct seq_file *m, struct crypto_alg *alg)
 static const struct crypto_type crypto_shash_type = {
 	.extsize = crypto_alg_extsize,
 	.init_tfm = crypto_shash_init_tfm,
+	.free = crypto_shash_free_instance,
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
 #endif
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index c84b7cb29887..c550386221bb 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -30,6 +30,7 @@ struct crypto_hash_walk {
 };
 
 struct ahash_instance {
+	void (*free)(struct ahash_instance *inst);
 	union {
 		struct {
 			char head[offsetof(struct ahash_alg, halg.base)];
@@ -40,6 +41,7 @@ struct ahash_instance {
 };
 
 struct shash_instance {
+	void (*free)(struct shash_instance *inst);
 	union {
 		struct {
 			char head[offsetof(struct shash_alg, base)];
-- 
2.24.1

