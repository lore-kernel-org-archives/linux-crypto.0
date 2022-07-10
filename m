Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B65AC43334
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Jul 2022 12:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiGJMTd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Jul 2022 08:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiGJMTb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Jul 2022 08:19:31 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C927EE3A
        for <linux-crypto@vger.kernel.org>; Sun, 10 Jul 2022 05:19:28 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AVuGokWd9dl7zAVuGohTTG; Sun, 10 Jul 2022 14:19:27 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 10 Jul 2022 14:19:27 +0200
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
Subject: [PATCH 2/3] crypto: octeontx2: Use the bitmap API to allocate bitmaps
Date:   Sun, 10 Jul 2022 14:19:23 +0200
Message-Id: <c0314fd119665918d2e6b098f7683aed50507455.1657455515.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a9fa76b5091f1626fa19e8e5650a95d8b2257eda.1657455515.git.christophe.jaillet@wanadoo.fr>
References: <a9fa76b5091f1626fa19e8e5650a95d8b2257eda.1657455515.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index f10050fead16..a28a310090e9 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1351,7 +1351,7 @@ void otx2_cpt_cleanup_eng_grps(struct pci_dev *pdev,
 	for (i = 0; i < OTX2_CPT_MAX_ENGINE_GROUPS; i++) {
 		grp = &eng_grps->grp[i];
 		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
-			kfree(grp->engs[j].bmap);
+			bitmap_free(grp->engs[j].bmap);
 			grp->engs[j].bmap = NULL;
 		}
 	}
@@ -1387,9 +1387,8 @@ int otx2_cpt_init_eng_grps(struct pci_dev *pdev,
 		grp->idx = i;
 
 		for (j = 0; j < OTX2_CPT_MAX_ETYPES_PER_GRP; j++) {
-			grp->engs[j].bmap =
-				kcalloc(BITS_TO_LONGS(eng_grps->engs_num),
-					sizeof(long), GFP_KERNEL);
+			grp->engs[j].bmap = bitmap_zalloc(eng_grps->engs_num,
+							  GFP_KERNEL);
 			if (!grp->engs[j].bmap) {
 				ret = -ENOMEM;
 				goto cleanup_eng_grps;
-- 
2.34.1

