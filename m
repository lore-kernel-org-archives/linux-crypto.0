Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D65DC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE662184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284019;
	bh=Q9W59TbgJ1Q9YUDkqEDbFDT7Hi9s2AJUXcFF9AsLb3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rIz28MBOSK6XCn1RPH4vbEKqmKOggKB/tu2RLrFSukVh7Z4OB/D7B8uhdEa8q6byw
	 6LHWukYQ3X1VQcKpqSUcC4epiNDBle53Z+YNvl+JZWZRQr+Xc3ql8fg1gcxnBtDZli
	 JIlqTam+4gCifW4guZfoGkPei2uR3CDtol5BawM8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfAWWwe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:52:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbfAWWwc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:32 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A728A218A2;
        Wed, 23 Jan 2019 22:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283951;
        bh=Q9W59TbgJ1Q9YUDkqEDbFDT7Hi9s2AJUXcFF9AsLb3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0i6PbAKgb5zeFpSjHHhP5wllsgP4h3jXQMHa5IinFziCptvRz1KYIVrrK26/dVhKL
         yNEoXMNUJxhMBoAyp1n3wxt7x3D0nCunJRTTVu3PlrhwiS73RVyDg9al8eHMh8cVaT
         3fV8agJ8gtmqWZ//WsHLOPMYUfr6vJOoV4sz2SZ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [RFC/RFT PATCH 02/15] crypto: morus - fix handling chunked inputs
Date:   Wed, 23 Jan 2019 14:49:13 -0800
Message-Id: <20190123224926.250525-3-ebiggers@kernel.org>
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

The generic MORUS implementations all fail the improved AEAD tests
because they produce the wrong result with some data layouts.  Fix them.

Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementations")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/morus1280.c | 13 +++++++------
 crypto/morus640.c  | 13 +++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/crypto/morus1280.c b/crypto/morus1280.c
index 3889c188f266..b83576b4eb55 100644
--- a/crypto/morus1280.c
+++ b/crypto/morus1280.c
@@ -366,18 +366,19 @@ static void crypto_morus1280_process_crypt(struct morus1280_state *state,
 					   const struct morus1280_ops *ops)
 {
 	struct skcipher_walk walk;
-	u8 *dst;
-	const u8 *src;
 
 	ops->skcipher_walk_init(&walk, req, false);
 
 	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
+		unsigned int nbytes = walk.nbytes;
 
-		ops->crypt_chunk(state, dst, src, walk.nbytes);
+		if (nbytes < walk.total)
+			nbytes = round_down(nbytes, walk.stride);
 
-		skcipher_walk_done(&walk, 0);
+		ops->crypt_chunk(state, walk.dst.virt.addr, walk.src.virt.addr,
+				 nbytes);
+
+		skcipher_walk_done(&walk, walk.nbytes - nbytes);
 	}
 }
 
diff --git a/crypto/morus640.c b/crypto/morus640.c
index da06ec2f6a80..b6a477444f6d 100644
--- a/crypto/morus640.c
+++ b/crypto/morus640.c
@@ -365,18 +365,19 @@ static void crypto_morus640_process_crypt(struct morus640_state *state,
 					  const struct morus640_ops *ops)
 {
 	struct skcipher_walk walk;
-	u8 *dst;
-	const u8 *src;
 
 	ops->skcipher_walk_init(&walk, req, false);
 
 	while (walk.nbytes) {
-		src = walk.src.virt.addr;
-		dst = walk.dst.virt.addr;
+		unsigned int nbytes = walk.nbytes;
 
-		ops->crypt_chunk(state, dst, src, walk.nbytes);
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

