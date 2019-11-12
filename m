Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB69CC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D412196E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfKLKUk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 05:20:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:56796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726910AbfKLKUk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 05:20:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8F16AFA8;
        Tue, 12 Nov 2019 10:20:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1BB2DDA7AF; Tue, 12 Nov 2019 11:20:43 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 3/7] crypto: blake2b: simplify key init
Date:   Tue, 12 Nov 2019 11:20:26 +0100
Message-Id: <15b9fcb26351a1bb3242ce0c4819391f38545648.1573553665.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573553665.git.dsterba@suse.com>
References: <cover.1573553665.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The keyed init writes the key bytes to the input buffer and does an
update. We can do that in two ways: fill the buffer and update
immediatelly. This is what current blake2b_init_key does. Any other
following _update or _final will continue from the updated state.

The other way is to write the key and set the number of bytes to process
at the next _update or _final, lazy evaluation. Which leads to the the
simplified code in this patch.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index d3da6113a96a..fd0fbb076058 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -85,8 +85,6 @@ static const u8 blake2b_sigma[12][16] = {
 	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 }
 };
 
-static void blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen);
-
 static void blake2b_set_lastnode(struct blake2b_state *S)
 {
 	S->f[1] = (u64)-1;
@@ -235,12 +233,12 @@ static int blake2b_init(struct shash_desc *desc)
 	state->h[0] ^= 0x01010000 | mctx->keylen << 8 | digestsize;
 
 	if (mctx->keylen) {
-		u8 block[BLAKE2B_BLOCKBYTES];
-
-		memset(block, 0, BLAKE2B_BLOCKBYTES);
-		memcpy(block, mctx->key, mctx->keylen);
-		blake2b_update(state, block, BLAKE2B_BLOCKBYTES);
-		memzero_explicit(block, BLAKE2B_BLOCKBYTES);
+		/*
+		 * Prefill the buffer with the key, next call to _update or
+		 * _final will process it
+		 */
+		memcpy(state->buf, mctx->key, mctx->keylen);
+		state->buflen = BLAKE2B_BLOCKBYTES;
 	}
 	return 0;
 }
-- 
2.23.0

