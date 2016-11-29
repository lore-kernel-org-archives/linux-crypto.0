From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/4] crypto: skcipher - fix crash in skcipher_walk_aead()
Date: Tue, 29 Nov 2016 13:05:31 +0000
Message-ID: <1480424733-10797-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f170.google.com ([209.85.210.170]:36612 "EHLO
        mail-wj0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933366AbcK2NFm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:05:42 -0500
Received: by mail-wj0-f170.google.com with SMTP id qp4so144596140wjc.3
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2016 05:05:41 -0800 (PST)
In-Reply-To: <1480424733-10797-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The new skcipher_walk_aead() may crash in the following way due to
the walk flag SKCIPHER_WALK_PHYS not being cleared at the start of the
walk:

Unable to handle kernel NULL pointer dereference at virtual address 00000001
[..]
Internal error: Oops: 96000044 [#1] PREEMPT SMP
[..]
PC is at skcipher_walk_next+0x208/0x450
LR is at skcipher_walk_next+0x1e4/0x450
pc : [<ffff2b93b7104e20>] lr : [<ffff2b93b7104dfc>] pstate: 40000045
sp : ffffb925fa517940
[...]
[<ffff2b93b7104e20>] skcipher_walk_next+0x208/0x450
[<ffff2b93b710535c>] skcipher_walk_first+0x54/0x148
[<ffff2b93b7105664>] skcipher_walk_aead+0xd4/0x108
[<ffff2b93b6e77928>] ccm_encrypt+0x68/0x158

So clear the flag at the appropriate time.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0f3071991b13..5367f817b40e 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -506,6 +506,8 @@ int skcipher_walk_aead(struct skcipher_walk *walk, struct aead_request *req,
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	int err;
 
+	walk->flags &= ~SKCIPHER_WALK_PHYS;
+
 	scatterwalk_start(&walk->in, req->src);
 	scatterwalk_start(&walk->out, req->dst);
 
-- 
2.7.4
