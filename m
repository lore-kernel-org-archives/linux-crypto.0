Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1D7C5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 13:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA762214D8
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 13:48:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbfKFNss (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Nov 2019 08:48:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:32890 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbfKFNss (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Nov 2019 08:48:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6015B38A;
        Wed,  6 Nov 2019 13:48:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 88BE1DA79A; Wed,  6 Nov 2019 14:48:53 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-crypto@vger.kernel.org
Cc:     ebiggers@kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] crypto: blake2b: delete unused structs or members
Date:   Wed,  6 Nov 2019 14:48:28 +0100
Message-Id: <39e1029a1b1dfb3132268829474c1ca166fb46cc.1573047517.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573047517.git.dsterba@suse.com>
References: <cover.1573047517.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

All the code for param block has been inlined, last_node and outlen from
the state are not used or have become redundant due to other code.
Remove it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 crypto/blake2b_generic.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
index fd0fbb076058..442c639c9ad9 100644
--- a/crypto/blake2b_generic.c
+++ b/crypto/blake2b_generic.c
@@ -32,10 +32,7 @@
 
 enum blake2b_constant {
 	BLAKE2B_BLOCKBYTES    = 128,
-	BLAKE2B_OUTBYTES      = 64,
 	BLAKE2B_KEYBYTES      = 64,
-	BLAKE2B_SALTBYTES     = 16,
-	BLAKE2B_PERSONALBYTES = 16
 };
 
 struct blake2b_state {
@@ -44,25 +41,8 @@ struct blake2b_state {
 	u64      f[2];
 	u8       buf[BLAKE2B_BLOCKBYTES];
 	size_t   buflen;
-	size_t   outlen;
-	u8       last_node;
 };
 
-struct blake2b_param {
-	u8 digest_length;			/* 1 */
-	u8 key_length;				/* 2 */
-	u8 fanout;				/* 3 */
-	u8 depth;				/* 4 */
-	__le32 leaf_length;			/* 8 */
-	__le32 node_offset;			/* 12 */
-	__le32 xof_length;			/* 16 */
-	u8 node_depth;				/* 17 */
-	u8 inner_length;			/* 18 */
-	u8 reserved[14];			/* 32 */
-	u8 salt[BLAKE2B_SALTBYTES];		/* 48 */
-	u8 personal[BLAKE2B_PERSONALBYTES];	/* 64 */
-} __packed;
-
 static const u64 blake2b_IV[8] = {
 	0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
 	0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
@@ -85,16 +65,8 @@ static const u8 blake2b_sigma[12][16] = {
 	{ 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3 }
 };
 
-static void blake2b_set_lastnode(struct blake2b_state *S)
-{
-	S->f[1] = (u64)-1;
-}
-
 static void blake2b_set_lastblock(struct blake2b_state *S)
 {
-	if (S->last_node)
-		blake2b_set_lastnode(S);
-
 	S->f[0] = (u64)-1;
 }
 
@@ -334,8 +306,6 @@ static struct shash_alg blake2b_algs[] = {
 
 static int __init blake2b_mod_init(void)
 {
-	BUILD_BUG_ON(sizeof(struct blake2b_param) != BLAKE2B_OUTBYTES);
-
 	return crypto_register_shashes(blake2b_algs, ARRAY_SIZE(blake2b_algs));
 }
 
-- 
2.23.0

