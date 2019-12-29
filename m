Return-Path: <SRS0=lkKn=2T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD2CC2D0DA
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17C5D206F4
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Dec 2019 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577588296;
	bh=hy8jBH2alNRHIec3TjwuxiCmcfNcCFSjUlmYkWL4T/E=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cDP0xPOBZ1hdyoGu04Mjgp5C3lo9Co9XsXmVLZkpwqo21Z6vVMx7mOOKIzrCk7vMG
	 QqJtr4j3Gfw1+655yanN1IIQSxcNFbdwkQD4lxZHfq9cpeKgXcAUGI2G6GsMFkquFz
	 1Yv8u8XTpsq/ICKlWoKvxYakHuOEacuE15Lx03zQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfL2C6P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Dec 2019 21:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfL2C6O (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Dec 2019 21:58:14 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E012D222C2
        for <linux-crypto@vger.kernel.org>; Sun, 29 Dec 2019 02:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577588294;
        bh=hy8jBH2alNRHIec3TjwuxiCmcfNcCFSjUlmYkWL4T/E=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UMFkirSIRgcauosq5vbORfbY4wECVDAGzPj1pTJ0iZGzYOsUNUTzeXY1sYLq+8gu7
         KhHkUWt4ReLE9Y/IE6M+flQppyT36GcHoDxaKfGpI/Y8ozJKv6l6L19iV9ID6jAJf7
         8D8s7Zf+c4BTPvX6HzAkR9ODbLtW1lpO9csDlaK4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 27/28] crypto: ahash - unexport crypto_ahash_type
Date:   Sat, 28 Dec 2019 20:57:13 -0600
Message-Id: <20191229025714.544159-28-ebiggers@kernel.org>
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

