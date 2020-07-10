Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90D2C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8646207F9
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362107;
	bh=M2LJLdqjUm7yfCY4y6nL/ZL6rGEtyApO+/OjoQPAIs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ynsiXHES9cVJ8O0w5NhqtjV5lnT8QQQnTCNAjZF7asAv7/EMuRYcr7jyObL+nNv4s
	 RSOn2pR+uCYrUZyIaUZh6sAClfKm9GXOaQ66qmYAxW1UwGVSBspLiXrcr+mmMc0B4n
	 M6hc+RaA9To/7S6aulKUzCkNntzE2Th48fIXZO4g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGJGVq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38977 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbgGJGVp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:21:45 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C31A2077D;
        Fri, 10 Jul 2020 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362105;
        bh=M2LJLdqjUm7yfCY4y6nL/ZL6rGEtyApO+/OjoQPAIs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8cQq3KV1EfHe3mQ+vEN6lNpWqnpJ6wjWy7MJLZ3qflkELWXRg71D6e2NMOBkqRB0
         fgqA9LQbSA8+WAppEVe8wZtwamoDU7REcPu74zzD4gIbqXeOUQrppSosPjqkGGV6oQ
         QXV7il+VeiXbhbvt6JL4+T3VCNl1kQ1LDrHDRF/A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH v2 1/7] crypto: geniv - remove unneeded arguments from aead_geniv_alloc()
Date:   Thu,  9 Jul 2020 23:20:36 -0700
Message-Id: <20200710062042.113842-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710062042.113842-1-ebiggers@kernel.org>
References: <20200710062042.113842-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The type and mask arguments to aead_geniv_alloc() are always 0, so
remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/echainiv.c               | 2 +-
 crypto/geniv.c                  | 7 ++++---
 crypto/seqiv.c                  | 2 +-
 include/crypto/internal/geniv.h | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/crypto/echainiv.c b/crypto/echainiv.c
index 4a2f02baba14..69686668625e 100644
--- a/crypto/echainiv.c
+++ b/crypto/echainiv.c
@@ -115,7 +115,7 @@ static int echainiv_aead_create(struct crypto_template *tmpl,
 	struct aead_instance *inst;
 	int err;
 
-	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
+	inst = aead_geniv_alloc(tmpl, tb);
 
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
diff --git a/crypto/geniv.c b/crypto/geniv.c
index 6a90c52d49ad..07496c8af0ab 100644
--- a/crypto/geniv.c
+++ b/crypto/geniv.c
@@ -39,7 +39,7 @@ static void aead_geniv_free(struct aead_instance *inst)
 }
 
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb, u32 type, u32 mask)
+				       struct rtattr **tb)
 {
 	struct crypto_aead_spawn *spawn;
 	struct crypto_attr_type *algt;
@@ -47,6 +47,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	struct aead_alg *alg;
 	unsigned int ivsize;
 	unsigned int maxauthsize;
+	u32 mask;
 	int err;
 
 	algt = crypto_get_attr_type(tb);
@@ -63,10 +64,10 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	spawn = aead_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
-	mask |= crypto_requires_sync(algt->type, algt->mask);
+	mask = crypto_requires_sync(algt->type, algt->mask);
 
 	err = crypto_grab_aead(spawn, aead_crypto_instance(inst),
-			       crypto_attr_alg_name(tb[1]), type, mask);
+			       crypto_attr_alg_name(tb[1]), 0, mask);
 	if (err)
 		goto err_free_inst;
 
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index f124b9b54e15..e48f875a7aac 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -138,7 +138,7 @@ static int seqiv_aead_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct aead_instance *inst;
 	int err;
 
-	inst = aead_geniv_alloc(tmpl, tb, 0, 0);
+	inst = aead_geniv_alloc(tmpl, tb);
 
 	if (IS_ERR(inst))
 		return PTR_ERR(inst);
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 229d37681a9d..7fd7126f593a 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -20,7 +20,7 @@ struct aead_geniv_ctx {
 };
 
 struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb, u32 type, u32 mask);
+				       struct rtattr **tb);
 int aead_init_geniv(struct crypto_aead *tfm);
 void aead_exit_geniv(struct crypto_aead *tfm);
 
-- 
2.27.0

