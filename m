From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 03/13] crypto: crypto4xx: fix type mismatch compiler error
Date: Wed,  4 Oct 2017 01:00:07 +0200
Message-ID: <e53844a4a81ec2d60a3fc4dc4b17f54bb14f45e4.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51832 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbdJCXAW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 19:00:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id f4so11743595wme.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2017 16:00:21 -0700 (PDT)
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a type mismatch error that I accidentally
introduced when I moved and refactored the dynamic_contents
helpers.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_sa.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_sa.h b/drivers/crypto/amcc/crypto4xx_sa.h
index 7cc04f1ff8a0..8040c82dc354 100644
--- a/drivers/crypto/amcc/crypto4xx_sa.h
+++ b/drivers/crypto/amcc/crypto4xx_sa.h
@@ -266,9 +266,9 @@ get_dynamic_sa_offset_state_ptr_field(struct dynamic_sa_ctl *cts)
 	return sizeof(struct dynamic_sa_ctl) + offset * 4;
 }
 
-static inline u8 *get_dynamic_sa_key_field(struct dynamic_sa_ctl *cts)
+static inline u32 *get_dynamic_sa_key_field(struct dynamic_sa_ctl *cts)
 {
-	return (u8 *) ((unsigned long)cts + sizeof(struct dynamic_sa_ctl));
+	return (u32 *) ((unsigned long)cts + sizeof(struct dynamic_sa_ctl));
 }
 
 #endif
-- 
2.14.2
