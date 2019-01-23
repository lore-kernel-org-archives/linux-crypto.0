Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D83C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 958172184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284017;
	bh=oKS3kcktzzR287q6H0rR3/ZGl2v281gm1CFxOCbTNKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IQaysv04at5A8qjGEsLFGPs+GuEFl7d7aEbTSFbdliVXtFdWDjONXfj6gcn6TGq+Z
	 KdoZyuBpyne4v7xDx88efYSvWRNkDshEv8/KIBA38MyY+1lWaBDghAOCr90umER3q0
	 feRAfqrxw3eZ2K3oNLinQSbVHnMU+LyNc+eO+W4I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfAWWwe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbfAWWwc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:32 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55B17218A1;
        Wed, 23 Jan 2019 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283951;
        bh=oKS3kcktzzR287q6H0rR3/ZGl2v281gm1CFxOCbTNKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQTo9TsyJIFSx7B9fdB6gM9g3V+tk13EL4VtX36GanzcAkhpi3ChJCsMX0xGvr/iL
         rYDAaeiNZOTnHQippOj+MpyIPCuJdMPXG4RjL1gaEsVvmjXkUPeFf7Ag/+R18ZZ2TK
         nd3H9MJCBn8t9dny/yrew0AMtQEdUTXhs+8Rrq/A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [RFC/RFT PATCH 01/15] crypto: aegis - fix handling chunked inputs
Date:   Wed, 23 Jan 2019 14:49:12 -0800
Message-Id: <20190123224926.250525-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The generic AEGIS implementations all fail the improved AEAD tests
because they produce the wrong result with some data layouts.  Fix them.

Fixes: f606a88e5823 ("crypto: aegis - Add generic AEGIS AEAD implementations")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aegis128.c  | 14 +++++++-------
 crypto/aegis128l.c | 14 +++++++-------
 crypto/aegis256.c  | 14 +++++++-------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index c22f4414856d..789716f92e4c 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -290,19 +290,19 @@ static void crypto_aegis128_process_crypt(struct aegis_state *state,
 					  const struct aegis128_ops *ops)
 {
 	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize;
 
 	ops->skcipher_walk_init(&walk, req, false);
 
 	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
+		unsigned int nbytes = walk.nbytes;
 
-		ops->crypt_chunk(state, dst, src, chunksize);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		skcipher_walk_done(&walk, 0);
+		ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 nbytes);
+
+		skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 }
 
diff --git a/crypto/aegis128l.c b/crypto/aegis128l.c
index b6fb21ebdc3e..73811448cb6b 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -353,19 +353,19 @@ static void crypto_aegis128l_process_crypt(struct aegis_state *state,
 					   const struct aegis128l_ops *ops)
 {
 	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize;
 
 	ops->skcipher_walk_init(&walk, req, false);
 
 	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
+		unsigned int nbytes = walk.nbytes;
 
-		ops->crypt_chunk(state, dst, src, chunksize);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		skcipher_walk_done(&walk, 0);
+		ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 nbytes);
+
+		skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 }
 
diff --git a/crypto/aegis256.c b/crypto/aegis256.c
index 11f0f8ec9c7c..8a71e9c06193 100644
--- a/crypto/aegis256.c
+++ b/crypto/aegis256.c
@@ -303,19 +303,19 @@ static void crypto_aegis256_process_crypt(struct aegis_state *state,
 					  const struct aegis256_ops *ops)
 {
 	struct skcipher_walk walk;
-	u8 *src, *dst;
-	unsigned int chunksize;
 
 	ops->skcipher_walk_init(&walk, req, false);
 
 	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
-		chunksize = walk.nbytes;
+		unsigned int nbytes = walk.nbytes;
 
-		ops->crypt_chunk(state, dst, src, chunksize);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		skcipher_walk_done(&walk, 0);
+		ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 nbytes);
+
+		skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 }
 
-- 
2.20.1.321.g9e740568ce-goog

