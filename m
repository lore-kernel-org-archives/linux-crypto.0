Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91631C2D0DD
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66F26207FD
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577656207;
	bh=oKWKD6vvBCPdZ7WlDJtKTsaZgdwd0SitWN8pKrtBo68=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t2uwIKtcxwjNxBJCCvslEUNp2pL432dxt9f9EXjjfm/Nf5bw/14TKfYd3pa7B/fXz
	 Ipj1oMqswwIyVpdH5ZmBDhniynuOqLe1XRd13Yllo3yvEWaeDkkseZGdKv8eAxWhRX
	 wXfbGF+f/RqmahjSDkTGXFDPWn68daETkLsYT3Y0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfL2VuG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfL2VuG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Dec 2019 16:50:06 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6090E20748
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577656205;
        bh=oKWKD6vvBCPdZ7WlDJtKTsaZgdwd0SitWN8pKrtBo68=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ci7lBawJ8NdW+uOt76+TtQpiT1b+qKhqniX/69SOggYl7W9dxRAoU6WTp7r18d1Lg
         KU0Br7tyCzUkDMmHZ3v1fq4MrFRZF9uvacwtrWGVf6Tpc1ujdo+YA9vZkrd1z+Hpf7
         hCrhVGjkg7wJKosAww5zcN4+kZ95luR+PqYKMGq4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/6] crypto: algapi - remove crypto_template::{alloc,free}()
Date:   Sun, 29 Dec 2019 15:48:29 -0600
Message-Id: <20191229214830.260965-6-ebiggers@kernel.org>
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

Now that all templates provide a ->create() method which creates the
instance, installs a strongly-typed ->free() method directly to it, and
registers it, the older ->alloc() and ->free() methods in
'struct crypto_template' are no longer used.  Remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c           |  5 -----
 crypto/ahash.c          |  5 -----
 crypto/algapi.c         |  5 -----
 crypto/algboss.c        | 12 +-----------
 crypto/shash.c          |  5 -----
 include/crypto/algapi.h |  2 --
 6 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 02a0db076d7e..7707d3223101 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -185,11 +185,6 @@ static void crypto_aead_free_instance(struct crypto_instance *inst)
 {
 	struct aead_instance *aead = aead_instance(inst);
 
-	if (!aead->free) {
-		inst->tmpl->free(inst);
-		return;
-	}
-
 	aead->free(aead);
 }
 
diff --git a/crypto/ahash.c b/crypto/ahash.c
index 61e374d76b04..cd5d9847d513 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -515,11 +515,6 @@ static void crypto_ahash_free_instance(struct crypto_instance *inst)
 {
 	struct ahash_instance *ahash = ahash_instance(inst);
 
-	if (!ahash->free) {
-		inst->tmpl->free(inst);
-		return;
-	}
-
 	ahash->free(ahash);
 }
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 72592795c7e7..69605e21af92 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -65,11 +65,6 @@ static int crypto_check_alg(struct crypto_alg *alg)
 
 static void crypto_free_instance(struct crypto_instance *inst)
 {
-	if (!inst->alg.cra_type->free) {
-		inst->tmpl->free(inst);
-		return;
-	}
-
 	inst->alg.cra_type->free(inst);
 }
 
diff --git a/crypto/algboss.c b/crypto/algboss.c
index a62149d6c839..535f1f87e6c1 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -58,7 +58,6 @@ static int cryptomgr_probe(void *data)
 {
 	struct cryptomgr_param *param = data;
 	struct crypto_template *tmpl;
-	struct crypto_instance *inst;
 	int err;
 
 	tmpl = crypto_lookup_template(param->template);
@@ -66,16 +65,7 @@ static int cryptomgr_probe(void *data)
 		goto out;
 
 	do {
-		if (tmpl->create) {
-			err = tmpl->create(tmpl, param->tb);
-			continue;
-		}
-
-		inst = tmpl->alloc(param->tb);
-		if (IS_ERR(inst))
-			err = PTR_ERR(inst);
-		else if ((err = crypto_register_instance(tmpl, inst)))
-			tmpl->free(inst);
+		err = tmpl->create(tmpl, param->tb);
 	} while (err == -EAGAIN && !signal_pending(current));
 
 	crypto_tmpl_put(tmpl);
diff --git a/crypto/shash.c b/crypto/shash.c
index e05e75b0f402..70faf28b2d14 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -427,11 +427,6 @@ static void crypto_shash_free_instance(struct crypto_instance *inst)
 {
 	struct shash_instance *shash = shash_instance(inst);
 
-	if (!shash->free) {
-		inst->tmpl->free(inst);
-		return;
-	}
-
 	shash->free(shash);
 }
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index be6a99a63fcd..414bbc6a4b08 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -63,8 +63,6 @@ struct crypto_template {
 	struct hlist_head instances;
 	struct module *module;
 
-	struct crypto_instance *(*alloc)(struct rtattr **tb);
-	void (*free)(struct crypto_instance *inst);
 	int (*create)(struct crypto_template *tmpl, struct rtattr **tb);
 
 	char name[CRYPTO_MAX_ALG_NAME];
-- 
2.24.1

