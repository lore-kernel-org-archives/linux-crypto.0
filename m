Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85664C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68BA32196E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 10:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfKLKUp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Nov 2019 05:20:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:56910 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727183AbfKLKUp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Nov 2019 05:20:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16BDFB3F9;
        Tue, 12 Nov 2019 10:20:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 66818DA7AF; Tue, 12 Nov 2019 11:20:48 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 5/7] crypto: blake2b: open code set last block helper
Date:   Tue, 12 Nov 2019 11:20:28 +0100
Message-Id: <8b671f0aec1c18f26dde397da71f38595ffb7db6.1573553665.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573553665.git.dsterba@suse.com>
References: <cover.1573553665.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The helper is trival and called once, inlining makes things simpler.
There's a comment to tie it back to the idea behind the code.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index 442c639c9ad9..463ac597ef04 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -65,11 +65,6 @@ static const u8 blake2b_sigma[12][16] = {
 	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 }
 };
 
-static void blake2b_set_lastblock(struct blake2b_state *S)
-{
-	S->f[0] = (u64)-1;
-}
-
 static void blake2b_increment_counter(struct blake2b_state *S, const u64 inc)
 {
 	S->t[0] += inc;
@@ -231,7 +226,8 @@ static int blake2b_final(struct shash_desc *desc, u8 *out)
 	size_t i;
 
 	blake2b_increment_counter(state, state->buflen);
-	blake2b_set_lastblock(state);
+	/* Set last block */
+	state->f[0] = (u64)-1;
 	/* Padding */
 	memset(state->buf + state->buflen, 0, BLAKE2B_BLOCKBYTES - state->buflen);
 	blake2b_compress(state, state->buf);
-- 
2.23.0

