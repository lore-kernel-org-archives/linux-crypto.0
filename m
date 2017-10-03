From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 01/13] crypto: crypto4xx: wire up hmac_mc to hmac_muting
Date: Wed,  4 Oct 2017 01:00:05 +0200
Message-ID: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:43757 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXAU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id m72so12492305wmc.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:19 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The hmac_mc parameter of set_dynamic_sa_command_1()
was defined but not used. On closer inspection it
turns out, it was never wired up.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index d08e4c94abed..57b1dcef4cb4 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -63,6 +63,7 @@ static void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm,
 	sa->sa_command_1.bf.crypto_mode9_8 = cm & 3;
 	sa->sa_command_1.bf.feedback_mode = cfb,
 	sa->sa_command_1.bf.sa_rev = 1;
+	sa->sa_command_1.bf.hmac_muting = hmac_mc;
 	sa->sa_command_1.bf.extended_seq_num = esn;
 	sa->sa_command_1.bf.seq_num_mask = sn_mask;
 	sa->sa_command_1.bf.mutable_bit_proc = mute;
-- 
2.14.2
