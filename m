Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF61C32767
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3E522314
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024093;
	bh=hy8jBH2alNRHIec3TjwuxiCmcfNcCFSjUlmYkWL4T/E=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mH5XJ7wh6ItaRhUrvkcBE78gb2dhT6bbPYTjhUVjWR/HBVDDgVSNpEvx4U6HzMUD9
	 0TrCCogBAwygjQ9x5mzkO+mLHa3NwESYBgQbqYrA1gtVkEMYzVMwHJd6UjsDvT8EQ3
	 2JiI3HNaeBSgLHuJrIZRj2fiToT6YelxJ4tCmtf4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgACEBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727227AbgACEBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6780324650
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024089;
        bh=hy8jBH2alNRHIec3TjwuxiCmcfNcCFSjUlmYkWL4T/E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=u4mDnaeYQ6vX8Y4rzTcePvpLmLg0zdu5g/GmH6Hv6vHFDB7jvb2GvViAzHjrm5Hx/
         Z6qWIPP+XvKDIgljDA0x/Mhgc09yjYwTOb1HOsXyjBm/Vgaa+soKr/p2pZXyCE3Fw2
         GR6dFGwMepiZO0Bags6ywaZZRQqr0o32XQDC9qkg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 27/28] crypto: ahash - unexport crypto_ahash_type
Date:   Thu,  2 Jan 2020 19:59:07 -0800
Message-Id: <20200103035908.12048-28-ebiggers@kernel.org>
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

Now that all the templates that need ahash spawns have been converted to
use crypto_grab_ahash() rather than look up the algorithm directly,
crypto_ahash_type is no longer used outside of ahash.c.  Make it static.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c                 | 5 +++--
 include/crypto/internal/hash.h | 2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 2b8449fdb93c..c77717fcea8e 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -23,6 +23,8 @@
 
 #include "internal.h"
 
+static const struct crypto_type crypto_ahash_type;
+
 struct ahash_request_priv {
 	crypto_completion_t complete;
 	void *data;
@@ -542,7 +544,7 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 		   __crypto_hash_alg_common(alg)->digestsize);
 }
 
-const struct crypto_type crypto_ahash_type = {
+static const struct crypto_type crypto_ahash_type = {
 	.extsize = crypto_ahash_extsize,
 	.init_tfm = crypto_ahash_init_tfm,
 #ifdef CONFIG_PROC_FS
@@ -554,7 +556,6 @@ const struct crypto_type crypto_ahash_type = {
 	.type = CRYPTO_ALG_TYPE_AHASH,
 	.tfmsize = offsetof(struct crypto_ahash, base),
 };
-EXPORT_SYMBOL_GPL(crypto_ahash_type);
 
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 79e561abef61..c84b7cb29887 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -57,8 +57,6 @@ struct crypto_shash_spawn {
 	struct crypto_spawn base;
 };
 
-extern const struct crypto_type crypto_ahash_type;
-
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
-- 
2.24.1

