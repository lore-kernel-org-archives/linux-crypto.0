Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C15EC25B48
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 20:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjJ0Uay (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 16:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbjJ0Uax (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 16:30:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552FD1B1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 13:30:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F67C433C8
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698438651;
        bh=ZPpToBo9f/BPTKEQSRWOpAwLyMXcWe8VSQX6hlr9/ag=;
        h=From:To:Subject:Date:From;
        b=cUI81fCdawrE1uKiLbv3uUGwe9ca1sH8FzUyHkfSHZX3tAnZZlEasntD90rnd/Xqb
         XekqwW5Ac1dHnNtticpEoLOzGdb7UrbL2Ifd8+1M3GW2Ep8lDix/0rwx6+WgdltbR+
         Zoc9A8FxRhjHk1DZV32aoZ5iqLn1mfn2gJOoZgu/m+Zdn1pjOFoh48Jg8eIhKcTgwl
         JLbZkS8OvWwY41kA9hnYpECTEIB1xDN/WE7V4D4Q173qbnOfl0ezFsfX8FFr0/GXUN
         aFL0nSXfp7QTzz+kLNyuaHUGZH4YQJzYYpOLeXN7VpG63A/CAMgdkRRgwt728J+PaW
         peQKkwtIH5n2g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: adiantum - flush destination page before unmapping
Date:   Fri, 27 Oct 2023 13:30:17 -0700
Message-ID: <20231027203017.57004-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Upon additional review, the new fast path in adiantum_finish() is
missing the call to flush_dcache_page() that scatterwalk_map_and_copy()
was doing.  It's apparently debatable whether flush_dcache_page() is
actually needed, as per the discussion at
https://lore.kernel.org/lkml/YYP1lAq46NWzhOf0@casper.infradead.org/T/#u.
However, it appears that currently all the helper functions that write
to a page, such as scatterwalk_map_and_copy(), memcpy_to_page(), and
memzero_page(), do the dcache flush.  So do it to be consistent.

Fixes: dadf5e56c967 ("crypto: adiantum - add fast path for single-page messages")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/adiantum.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 9ff3376f9ed3..60f3883b736a 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -293,30 +293,32 @@ static int adiantum_finish(struct skcipher_request *req)
 
 	/*
 	 * Second hash step
 	 *	enc: C_R = C_M - H_{K_H}(T, C_L)
 	 *	dec: P_R = P_M - H_{K_H}(T, P_L)
 	 */
 	rctx->u.hash_desc.tfm = tctx->hash;
 	le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &rctx->header_hash);
 	if (dst_nents == 1 && dst->offset + req->cryptlen <= PAGE_SIZE) {
 		/* Fast path for single-page destination */
-		void *virt = kmap_local_page(sg_page(dst)) + dst->offset;
+		struct page *page = sg_page(dst);
+		void *virt = kmap_local_page(page) + dst->offset;
 
 		err = crypto_shash_digest(&rctx->u.hash_desc, virt, bulk_len,
 					  (u8 *)&digest);
 		if (err) {
 			kunmap_local(virt);
 			return err;
 		}
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 		memcpy(virt + bulk_len, &rctx->rbuf.bignum, sizeof(le128));
+		flush_dcache_page(page);
 		kunmap_local(virt);
 	} else {
 		/* Slow path that works for any destination scatterlist */
 		err = adiantum_hash_message(req, dst, dst_nents, &digest);
 		if (err)
 			return err;
 		le128_sub(&rctx->rbuf.bignum, &rctx->rbuf.bignum, &digest);
 		scatterwalk_map_and_copy(&rctx->rbuf.bignum, dst,
 					 bulk_len, sizeof(le128), 1);
 	}

base-commit: f2b88bab69c86d4dab2bfd25a0e741d7df411f7a
-- 
2.42.0

