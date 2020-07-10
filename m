Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240B1C433E1
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02FFA2072E
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594362110;
	bh=r0w2odrLp0N96ssJQr1TgQnSkm7SPhCc1wX8DNkp0Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=djuEV1t9bTe8JBKcsRr/gQkN4s92hx2KEVY62JfjPmvYBfHhcFEsaHNZ+YTZPfTol
	 vy65dJEOVgar6C4/RVjMBH0lPUv/jSQKY+TbteBlGqXRv/HCiOTk4m9E4K6bcynytf
	 Mvh1HeriwccA18DjqCBwfyddXQXXkoz+DlNHh6d8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgGJGVr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbgGJGVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:21:46 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DBFB2078D;
        Fri, 10 Jul 2020 06:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594362106;
        bh=r0w2odrLp0N96ssJQr1TgQnSkm7SPhCc1wX8DNkp0Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfKKIIUq1nioIoeC4hyizj1JmYx5BaaGaEAg2pwQC4qc2NeM6gDbsO5y20hLyNTJj
         43iMDfLccUtDgt9fqUF8jWXqbfu9luicbWUQ102oyuyZE6PtArIl8rWYpt1W0xFgMW
         Tt73FSuRImLEon4mWPsaNiQPmyq5917x49pnFmVU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mikulas Patocka <mpatocka@redhat.com>, linux-crypto@vger.kernel.org
Cc:     dm-devel@redhat.com
Subject: [PATCH v2 4/7] crypto: algapi - add NEED_FALLBACK to INHERITED_FLAGS
Date:   Thu,  9 Jul 2020 23:20:39 -0700
Message-Id: <20200710062042.113842-5-ebiggers@kernel.org>
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

CRYPTO_ALG_NEED_FALLBACK is handled inconsistently.  When it's requested
to be clear, some templates propagate that request to child algorithms,
while others don't.

It's apparently desired for NEED_FALLBACK to be propagated, to avoid
deadlocks where a module tries to load itself while it's being
initialized, and to avoid unnecessarily complex fallback chains where we
have e.g. cbc-aes-$driver falling back to cbc(aes-$driver) where
aes-$driver itself falls back to aes-generic, instead of cbc-aes-$driver
simply falling back to cbc(aes-generic).  There have been a number of
fixes to this effect:

commit 89027579bc6c ("crypto: xts - Propagate NEED_FALLBACK bit")
commit d2c2a85cfe82 ("crypto: ctr - Propagate NEED_FALLBACK bit")
commit e6c2e65c70a6 ("crypto: cbc - Propagate NEED_FALLBACK bit")

But it seems that other templates can have the same problems too.

To avoid this whack-a-mole, just add NEED_FALLBACK to INHERITED_FLAGS so
that it's always inherited.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ctr.c            | 2 --
 crypto/skcipher.c       | 2 --
 crypto/xts.c            | 2 --
 include/crypto/algapi.h | 3 ++-
 include/linux/crypto.h  | 4 ++--
 5 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index ae8d88c715d6..c39fcffba27f 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -265,8 +265,6 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 3b93a74ad124..467af525848a 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -943,8 +943,6 @@ struct skcipher_instance *skcipher_alloc_instance_simple(
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return ERR_PTR(err);
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
diff --git a/crypto/xts.c b/crypto/xts.c
index 35a30610569b..9a7adab6c3e1 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -340,8 +340,6 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
 	if (err)
 		return err;
-	mask |= crypto_requires_off(crypto_get_attr_type(tb),
-				    CRYPTO_ALG_NEED_FALLBACK);
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index da64c37482b4..22cf4d80959f 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -245,7 +245,8 @@ static inline u32 crypto_requires_off(struct crypto_attr_type *algt, u32 off)
  * template), these are the flags that should always be set on the "outer"
  * algorithm if any "inner" algorithm has them set.
  */
-#define CRYPTO_ALG_INHERITED_FLAGS	CRYPTO_ALG_ASYNC
+#define CRYPTO_ALG_INHERITED_FLAGS	\
+	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK)
 
 /*
  * Given the type and mask that specify the flags restrictions on a template
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 7cd2d00f0a05..f73f0b51e1cd 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -60,8 +60,8 @@
 #define CRYPTO_ALG_ASYNC		0x00000080
 
 /*
- * Set this bit if and only if the algorithm requires another algorithm of
- * the same type to handle corner cases.
+ * Set if the algorithm (or an algorithm which it uses) requires another
+ * algorithm of the same type to handle corner cases.
  */
 #define CRYPTO_ALG_NEED_FALLBACK	0x00000100
 
-- 
2.27.0

