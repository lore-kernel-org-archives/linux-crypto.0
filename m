Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8857C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 15:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbhKVP5Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 10:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240060AbhKVP5N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 10:57:13 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F783C061757
        for <linux-crypto@vger.kernel.org>; Mon, 22 Nov 2021 07:54:07 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:e4da:38c:79e9:48bf])
        by xavier.telenet-ops.be with bizsmtp
        id MTu5260054yPVd601Tu5EE; Mon, 22 Nov 2021 16:54:05 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBds-00EL23-Ql; Mon, 22 Nov 2021 16:54:04 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mpBds-00HGnV-48; Mon, 22 Nov 2021 16:54:04 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] crypto: sa2ul - Use bitfield helpers
Date:   Mon, 22 Nov 2021 16:54:02 +0100
Message-Id: <ca89d204ef2e40193479db2742eadf0d9cf3c0ff.1637593297.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <a1445d3abb45cfc95cb1b03180fd53caf122035b.1637593297.git.geert+renesas@glider.be>
References: <a1445d3abb45cfc95cb1b03180fd53caf122035b.1637593297.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the FIELD_PREP() helper, instead of open-coding the same operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.

See "[PATCH 00/17] Non-const bitfield helper conversions"
(https://lore.kernel.org/r/cover.1637592133.git.geert+renesas@glider.be)
for background and more conversions.
---
 drivers/crypto/sa2ul.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index bcbc38dc6ae8fa6b..51b58e57153f61d2 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -8,6 +8,7 @@
  *		Vitaly Andrianov
  *		Tero Kristo
  */
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
@@ -646,8 +647,8 @@ static inline void sa_update_cmdl(struct sa_req *req, u32 *cmdl,
 		cmdl[upd_info->enc_offset.index] &=
 						~SA_CMDL_SOP_BYPASS_LEN_MASK;
 		cmdl[upd_info->enc_offset.index] |=
-			((u32)req->enc_offset <<
-			 __ffs(SA_CMDL_SOP_BYPASS_LEN_MASK));
+			FIELD_PREP(SA_CMDL_SOP_BYPASS_LEN_MASK,
+				   req->enc_offset);
 
 		if (likely(upd_info->flags & SA_CMDL_UPD_ENC_IV)) {
 			__be32 *data = (__be32 *)&cmdl[upd_info->enc_iv.index];
@@ -666,8 +667,8 @@ static inline void sa_update_cmdl(struct sa_req *req, u32 *cmdl,
 		cmdl[upd_info->auth_offset.index] &=
 			~SA_CMDL_SOP_BYPASS_LEN_MASK;
 		cmdl[upd_info->auth_offset.index] |=
-			((u32)req->auth_offset <<
-			 __ffs(SA_CMDL_SOP_BYPASS_LEN_MASK));
+			FIELD_PREP(SA_CMDL_SOP_BYPASS_LEN_MASK,
+				   req->auth_offset);
 		if (upd_info->flags & SA_CMDL_UPD_AUTH_IV) {
 			sa_copy_iv((void *)&cmdl[upd_info->auth_iv.index],
 				   req->auth_iv,
@@ -689,16 +690,16 @@ void sa_set_swinfo(u8 eng_id, u16 sc_id, dma_addr_t sc_phys,
 		   u8 hash_size, u32 *swinfo)
 {
 	swinfo[0] = sc_id;
-	swinfo[0] |= (flags << __ffs(SA_SW0_FLAGS_MASK));
+	swinfo[0] |= FIELD_PREP(SA_SW0_FLAGS_MASK, flags);
 	if (likely(cmdl_present))
-		swinfo[0] |= ((cmdl_offset | SA_SW0_CMDL_PRESENT) <<
-						__ffs(SA_SW0_CMDL_INFO_MASK));
-	swinfo[0] |= (eng_id << __ffs(SA_SW0_ENG_ID_MASK));
+		swinfo[0] |= FIELD_PREP(SA_SW0_CMDL_INFO_MASK,
+					cmdl_offset | SA_SW0_CMDL_PRESENT);
+	swinfo[0] |= FIELD_PREP(SA_SW0_ENG_ID_MASK, eng_id);
 
 	swinfo[0] |= SA_SW0_DEST_INFO_PRESENT;
 	swinfo[1] = (u32)(sc_phys & 0xFFFFFFFFULL);
 	swinfo[2] = (u32)((sc_phys & 0xFFFFFFFF00000000ULL) >> 32);
-	swinfo[2] |= (hash_size << __ffs(SA_SW2_EGRESS_LENGTH));
+	swinfo[2] |= FIELD_PREP(SA_SW2_EGRESS_LENGTH, hash_size);
 }
 
 /* Dump the security context */
-- 
2.25.1

