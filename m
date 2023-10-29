Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C853C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 04:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjJ2E7A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 00:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ2E67 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 00:58:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC19FC5;
        Sat, 28 Oct 2023 21:58:57 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565CCC433C7;
        Sun, 29 Oct 2023 04:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698555537;
        bh=75TmNIw9o5wwMcE/v+GkI5Pw98/aJRyGJi9NVTJa7bg=;
        h=From:To:Cc:Subject:Date:From;
        b=YqPpo7OCdKYtvbsrLiZmUZ2BY9ZFLJbFmS4MFMQVLGNk4OvkT9cDpT+8EFplfS9lR
         TtFhrydRd1wDOp9ft25n+NB1QtyvDbkL7yS/zhwAniQ0nxO1vG1SG/r0LVK9C/ZoDq
         r5mCyagNT97SS0fWE/gfI7nzAnV5mHd3Ml4bZddx+O9WOiK2dqgQOLc1ClEYuZ3iJ4
         mjLIqbMYElXvHShQnfOYeTFyPVpjuZrUl3KOMORl6C92pFOaB66B9CiN+1CcWXdHth
         IQBfTB/cH/ylGXhIspK1ec1CNKnNiyz5bbjy5y+W8SGZfPr36ECmFaz+16vKoyaJUL
         TvQpV6HXeYY+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] RDMA/siw: use crypto_shash_digest() in siw_qp_prepare_tx()
Date:   Sat, 28 Oct 2023 21:58:39 -0700
Message-ID: <20231029045839.154071-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify siw_qp_prepare_tx() by using crypto_shash_digest() instead of
an init+update+final sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 60b6a4135961..5b390f08f1cd 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -242,28 +242,24 @@ static int siw_qp_prepare_tx(struct siw_iwarp_tx *c_tx)
 				c_tx->pkt.c_untagged.ddp_mo = 0;
 			else
 				c_tx->pkt.c_tagged.ddp_to =
 					cpu_to_be64(wqe->sqe.raddr);
 		}
 
 		*(u32 *)crc = 0;
 		/*
 		 * Do complete CRC if enabled and short packet
 		 */
-		if (c_tx->mpa_crc_hd) {
-			crypto_shash_init(c_tx->mpa_crc_hd);
-			if (crypto_shash_update(c_tx->mpa_crc_hd,
-						(u8 *)&c_tx->pkt,
-						c_tx->ctrl_len))
-				return -EINVAL;
-			crypto_shash_final(c_tx->mpa_crc_hd, (u8 *)crc);
-		}
+		if (c_tx->mpa_crc_hd &&
+		    crypto_shash_digest(c_tx->mpa_crc_hd, (u8 *)&c_tx->pkt,
+					c_tx->ctrl_len, (u8 *)crc) != 0)
+			return -EINVAL;
 		c_tx->ctrl_len += MPA_CRC_SIZE;
 
 		return PKT_COMPLETE;
 	}
 	c_tx->ctrl_len += MPA_CRC_SIZE;
 	c_tx->sge_idx = 0;
 	c_tx->sge_off = 0;
 	c_tx->pbl_idx = 0;
 
 	/*

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

