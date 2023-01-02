Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5B9C3DA7A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Jan 2023 10:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjABKS7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Jan 2023 05:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbjABKS6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2023 05:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C9F2A0
        for <linux-crypto@vger.kernel.org>; Mon,  2 Jan 2023 02:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA9A7B80CBB
        for <linux-crypto@vger.kernel.org>; Mon,  2 Jan 2023 10:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AC2C433F0;
        Mon,  2 Jan 2023 10:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672654735;
        bh=KdDWgEFVyzEa6v17Q5MNkjJFsOPzBC63N1mLtXppZdM=;
        h=From:To:Cc:Subject:Date:From;
        b=QvsPZCOhyi+QdGcSpsIVkPWqhqETa09Bo3dbWCN68ov6ttTTZgwA2w/o0yH37+TId
         3YnzT6V6H4kXRxnvMixwi/9vNJH0GsicnIeu0soL0Og2PGYYNi6t0Gphx/bNckG9kL
         ZkVFNcOn8pHBu75WCziz5kxCD6sraeV0zyVuh1Q61DDMbjMa6iK/kc7yUSbWzdQs4I
         nBROW3kTRk+D3ehDcfdWhhKUGEn1bmrMafZEa4R6yqJc2Swj7mGZOcKU+ZPclzTJmc
         KIV5b8d6nh9k8qN6xlKVmncj4PPL6rQZT6t0kdGmJ1RAPfpYPQYf2uMIGuwd5URXt6
         dYSijhQagIKcQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: skcipher - Use scatterwalk (un)map interface for dst and src buffers
Date:   Mon,  2 Jan 2023 11:18:46 +0100
Message-Id: <20230102101846.116448-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2128; i=ardb@kernel.org; h=from:subject; bh=KdDWgEFVyzEa6v17Q5MNkjJFsOPzBC63N1mLtXppZdM=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjsq+F2apjR4sVoezUCg90l8iQp4Ol/foi90yyLyIN EX0Gdi6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY7KvhQAKCRDDTyI5ktmPJFDlC/ 9E6l2u1jPdsD5SwKwwfXoWG0PjU4sTB8s4eip/vAXN3Nd/qzw1xtENFnnpdEwjud77xyWVicfBZ/T1 Q/idwAYMp9oJh8vw3BxuKokylBmHel+TUzXm2b3OwstBKojMuYm0IL3539TOTI/B6ne598ibtzC/pI UrCRLtbBkGdosIrZEVI06jJtiqfW1ewKcK6R3HrSydqk2D86azCW1Sp53mJCqXeDD7g3epgIRREclc hNkndXLzBs9ZLc+Ie14cj3cQzaMscubIVtAqYCl5lcTL+fUqq8YzHdqwiqGSeY+RX3Cnjcbra/hPjh l7JRMqMpo2IpuQXYv/q1P5xaTwqqsbWEblmSj2NsYsFzAMS8bM9FqLkqTijxpBccYn5FKxyVsrcsp3 8Omcb6v2nO/agx4BfLoZexo/FORASnJB42Zk+aXQG5hxkvH9Fs7hHYdnLZiaGODn6jxF0xCg98qMJj +Mkb8zcGLPKlGbaDu9DJ0Oqn0xaHNoCuKz2C4wlRjBxtU=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The skcipher walk API implementation avoids scatterwalk_map() for
mapping the source and destination buffers, and invokes kmap_atomic()
directly if the buffer in question is not in low memory (which can only
happen on 32-bit architectures). This avoids some overhead on 64-bit
architectures, and most notably, permits the skcipher code to run with
preemption enabled.

Now that scatterwalk_map() has been updated to use kmap_local(), none of
this is needed, so we can simply use scatterwalk_map/unmap instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/skcipher.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0ecab31cfe79bfd8..7bf4871fec8006ac 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -42,38 +42,24 @@ struct skcipher_walk_buffer {
 
 static int skcipher_walk_next(struct skcipher_walk *walk);
 
-static inline void skcipher_unmap(struct scatter_walk *walk, void *vaddr)
-{
-	if (PageHighMem(scatterwalk_page(walk)))
-		kunmap_atomic(vaddr);
-}
-
-static inline void *skcipher_map(struct scatter_walk *walk)
-{
-	struct page *page = scatterwalk_page(walk);
-
-	return (PageHighMem(page) ? kmap_atomic(page) : page_address(page)) +
-	       offset_in_page(walk->offset);
-}
-
 static inline void skcipher_map_src(struct skcipher_walk *walk)
 {
-	walk->src.virt.addr = skcipher_map(&walk->in);
+	walk->src.virt.addr = scatterwalk_map(&walk->in);
 }
 
 static inline void skcipher_map_dst(struct skcipher_walk *walk)
 {
-	walk->dst.virt.addr = skcipher_map(&walk->out);
+	walk->dst.virt.addr = scatterwalk_map(&walk->out);
 }
 
 static inline void skcipher_unmap_src(struct skcipher_walk *walk)
 {
-	skcipher_unmap(&walk->in, walk->src.virt.addr);
+	scatterwalk_unmap(walk->src.virt.addr);
 }
 
 static inline void skcipher_unmap_dst(struct skcipher_walk *walk)
 {
-	skcipher_unmap(&walk->out, walk->dst.virt.addr);
+	scatterwalk_unmap(walk->dst.virt.addr);
 }
 
 static inline gfp_t skcipher_walk_gfp(struct skcipher_walk *walk)
-- 
2.39.0

