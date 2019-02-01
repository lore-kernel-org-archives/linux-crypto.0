Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32722C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2F2220869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007625;
	bh=4as1W2dKHamG293eWiOgwTcudrNyOzzBEot+dZ1iHEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NBfFiiJpuesJYQzUCy97mJ43PeiYcxmRszlR+z5Tpi/95l1q/JrL+uTqXOAyaDfb3
	 QYQdIzi6B8ab3kE/TV5UNG0eYRJXyMygZaWOiIeZGYl9HFHeMUjT0nc+bwyk2kIVsr
	 81ltFK81R6vzAKMD/a+vuOHeMjdluzg/qSW13hNY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfBAHxj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:53:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfBAHwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:01 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8203220B1F;
        Fri,  1 Feb 2019 07:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007520;
        bh=4as1W2dKHamG293eWiOgwTcudrNyOzzBEot+dZ1iHEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PECAh2aSeMDCPC3fx8NQaF/cwxlU5Nwj4y6zdT1GVLt8aXknDoFVE2qNNg0TQHLFG
         ep0uUuikxBh1mAanureky1nHp4TVMpq92p3FSbXvc0jJIuttJ8PY0Fqzo00WsEtnd2
         rCpW/Nhb5Gmp/PZnFgwnWwUBV4UCNM1CRO65EuTE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 01/15] crypto: aegis - fix handling chunked inputs
Date:   Thu, 31 Jan 2019 23:51:36 -0800
Message-Id: <20190201075150.18644-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The generic AEGIS implementations all fail the improved AEAD tests
because they produce the wrong result with some data layouts.  The issue
is that they assume that if the skcipher_walk API gives 'nbytes' not
aligned to the walksize (a.k.a. walk.stride), then it is the end of the
data.  In fact, this can happen before the end.  Fix them.

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
index 96e078a8a00a1..3718a83413032 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -286,19 +286,19 @@ static void crypto_aegis128_process_crypt(struct aegis_state *state,
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
index a210e779b911b..275a8616d71bd 100644
--- a/crypto/aegis128l.c
+++ b/crypto/aegis128l.c
@@ -349,19 +349,19 @@ static void crypto_aegis128l_process_crypt(struct aegis_state *state,
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
index 49882a28e93e9..ecd6b7f34a2d2 100644
--- a/crypto/aegis256.c
+++ b/crypto/aegis256.c
@@ -299,19 +299,19 @@ static void crypto_aegis256_process_crypt(struct aegis_state *state,
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
2.20.1

