Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6050FC282DA
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357CC20869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007617;
	bh=i+sTjqzor656AeRIILzJaNSQqu6AxZ1gWunRKb33rjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IRNDWr9zB58kyCAg/KtRwXIbJ83L/kGFFdQjKF/ql8qOIB/1az6XkrY6sUh0r7Ki1
	 /44dYY5/A/TOYbym1ufJL5stHctho57rgoIu40yeqBX5vWVWwMJj/bu/QL3Q+nQRBQ
	 qotv6hJL4iBgI6sfLjPP564X5s+nks5+EOK3JpsU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfBAHxa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfBAHwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:01 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0ED021726;
        Fri,  1 Feb 2019 07:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007521;
        bh=i+sTjqzor656AeRIILzJaNSQqu6AxZ1gWunRKb33rjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G45f+qIz8EEojMmwfooSSJr2PKbQdr5LcunwpRZKR7lMcxhWTbmFG1DhedO6KYKlZ
         U0KaK4xYU96eO560+9d6p7a509BbmtRp6XKevxPaouwmS4OhvyFdLbvyW+GkuqbO96
         Q/o9z0w7kGFc6DghGI45darpYzohpxuzzYGXho5Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 02/15] crypto: morus - fix handling chunked inputs
Date:   Thu, 31 Jan 2019 23:51:37 -0800
Message-Id: <20190201075150.18644-3-ebiggers@kernel.org>
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

The generic MORUS implementations all fail the improved AEAD tests
because they produce the wrong result with some data layouts.  The issue
is that they assume that if the skcipher_walk API gives 'nbytes' not
aligned to the walksize (a.k.a. walk.stride), then it is the end of the
data.  In fact, this can happen before the end.  Fix them.

Fixes: 396be41f16fd ("crypto: morus - Add generic MORUS AEAD implementations")
Cc: <stable@vger.kernel.org> # v4.18+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/morus1280.c | 13 +++++++------
 crypto/morus640.c  | 13 +++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/crypto/morus1280.c b/crypto/morus1280.c
index 78ba09db7328c..0747732d5b78a 100644
--- a/crypto/morus1280.c
+++ b/crypto/morus1280.c
@@ -362,18 +362,19 @@ static void crypto_morus1280_process_crypt(struct morus1280_state *state,
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
index 5cf530139b271..1617a1eb8be13 100644
--- a/crypto/morus640.c
+++ b/crypto/morus640.c
@@ -361,18 +361,19 @@ static void crypto_morus640_process_crypt(struct morus640_state *state,
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
2.20.1

