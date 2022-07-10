Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF11C43334
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Jul 2022 12:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiGJMTl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Jul 2022 08:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJMTk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Jul 2022 08:19:40 -0400
Received: from smtp.smtpout.orange.fr (smtp05.smtpout.orange.fr [80.12.242.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5062AB64
        for <linux-crypto@vger.kernel.org>; Sun, 10 Jul 2022 05:19:39 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id AVuQotAaQ6rrEAVuQoiB3Q; Sun, 10 Jul 2022 14:19:37 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 10 Jul 2022 14:19:37 +0200
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
Subject: [PATCH 3/3] crypto: octeontx2: Avoid some useless memory initialization
Date:   Sun, 10 Jul 2022 14:19:33 +0200
Message-Id: <d23bb174321f48dbc4ca2d325a57c616a2fafb8b.1657455515.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <a9fa76b5091f1626fa19e8e5650a95d8b2257eda.1657455515.git.christophe.jaillet@wanadoo.fr>
References: <a9fa76b5091f1626fa19e8e5650a95d8b2257eda.1657455515.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In otx2_cpt_eng_grp_info(), 'tmp_bmap' is zero'ed at each iteration in the
first 'for' loop.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index a28a310090e9..b14a8f6dae63 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -848,7 +848,7 @@ static int eng_grp_update_masks(struct device *dev,
 				struct otx2_cpt_eng_grp_info *eng_grp)
 {
 	struct otx2_cpt_engs_rsvd *engs, *mirrored_engs;
-	struct otx2_cpt_bitmap tmp_bmap = { {0} };
+	struct otx2_cpt_bitmap tmp_bmap;
 	int i, j, cnt, max_cnt;
 	int bit;
 
-- 
2.34.1

