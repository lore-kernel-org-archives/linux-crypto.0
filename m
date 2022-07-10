Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72500CCA479
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Jul 2022 12:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiGJMM7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Jul 2022 08:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJMM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Jul 2022 08:12:58 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E69713D48
        for <linux-crypto@vger.kernel.org>; Sun, 10 Jul 2022 05:12:57 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AVnvoW3X8V0xUAVnwoV0dy; Sun, 10 Jul 2022 14:12:55 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 10 Jul 2022 14:12:55 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] crypto: marvell/octeontx: Simplify bitmap declaration
Date:   Sun, 10 Jul 2022 14:12:50 +0200
Message-Id: <eb4dc7930c66b659718555edcf7fc1bbea6f5298.1657455082.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

'OTX_CPT_ENGS_BITMASK_LEN' is only used to allocate a bitmap. This macro
only works because OTX_CPT_MAX_ENGINES is 64. BITS_TO_LONGS() should be
used to compute the correct size.

In order to simplify the code, remove OTX_CPT_ENGS_BITMASK_LEN and use
DECLARE_BITMAP to declare the 'bits' bitmap.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
index 8620ac87a447..e7e9d1a9a0db 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.h
@@ -39,8 +39,6 @@
 /* Maximum number of supported engines/cores on OcteonTX 83XX platform */
 #define OTX_CPT_MAX_ENGINES		64
 
-#define OTX_CPT_ENGS_BITMASK_LEN	(OTX_CPT_MAX_ENGINES/(BITS_PER_BYTE * \
-					 sizeof(unsigned long)))
 
 /* Microcode types */
 enum otx_cpt_ucode_type {
@@ -54,7 +52,7 @@ enum otx_cpt_ucode_type {
 };
 
 struct otx_cpt_bitmap {
-	unsigned long bits[OTX_CPT_ENGS_BITMASK_LEN];
+	DECLARE_BITMAP(bits, OTX_CPT_MAX_ENGINES);
 	int size;
 };
 
-- 
2.34.1

