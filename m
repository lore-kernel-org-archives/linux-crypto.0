Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC74C00A8F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjJVITN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjJVISw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572E2D52
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD22FC433D9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962728;
        bh=Jyn1t2greDYzdz7O1r+I/8upwMzEU2EOZa2ql2m36SU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=cO6D7C3jr/jsnZEnRO3A2HnkD0kHQT928PblRT4aqi7RsMdAwxsEg5wi2rp74RJjr
         8rNiVqDNHG7Qjy6YRCkZ4RoqFy34vNiCdSxBIcTObYr8ssUoRI6qada44djgDS3fqG
         GWKTBLqi3aW47+u1IpOblRtEQPgX0CyvtepsBZ8lkqnTL39FrAYkX8G80gtBf0NaoT
         0y6eElC/oz/hC4nbKvj8lZuxmLM8cpJtnRHbkXqBfYvNOH5guTtexoK1PMYtKGAzAF
         KSueuPBAiqBNpNHfMKH2OCzaHInMC7kMQrHlEkpeG6EvLWNrdTmboAYGtsLD+Io+ci
         XgyD6hrFBAqLw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 24/30] crypto: ahash - remove struct ahash_request_priv
Date:   Sun, 22 Oct 2023 01:10:54 -0700
Message-ID: <20231022081100.123613-25-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

struct ahash_request_priv is unused, so remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 744fd3b8ea258..556c950100936 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -18,28 +18,20 @@
 #include <linux/seq_file.h>
 #include <linux/string.h>
 #include <net/netlink.h>
 
 #include "hash.h"
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
 static const struct crypto_type crypto_ahash_type;
 
-struct ahash_request_priv {
-	crypto_completion_t complete;
-	void *data;
-	u8 *result;
-	u32 flags;
-	void *ubuf[] CRYPTO_MINALIGN_ATTR;
-};
-
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int offset = walk->offset;
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
 	walk->data = kmap_local_page(walk->pg);
 	walk->data += offset;
 	walk->entrylen -= nbytes;
 	return nbytes;
-- 
2.42.0

