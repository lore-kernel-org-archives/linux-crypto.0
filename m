From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/1] crypto:drbg- Fixes panic in wait_for_completion call.
Date: Fri, 26 May 2017 12:12:51 +0200
Message-ID: <12466881.1IDO9Q7xg5@positron.chronox.de>
References: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59696 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764256AbdEZKMy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 06:12:54 -0400
In-Reply-To: <ea78b839-5717-2edb-c073-82fa82a0b403@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 25. Mai 2017, 17:23:47 CEST schrieb Harsh Jain:

Hi Harsh,

> Initialise ctr_completion variable before use.

Thank you very much for catching this.

But I think the chosen function is wrong. When we have an HMAC or Hash DRBG, this completion function does not need to be initialized.

May I ask you to check this patch?

Ciao
Stephan

---8<---

>From 1ec5f753644eb9005ad758c9bfd75032602c9727 Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Fri, 26 May 2017 12:11:31 +0200
Subject: [PATCH] crypto: drbg- Fixes panic in wait_for_completion call

Initialise ctr_completion variable before use.

Signed-off-by: Harsh Jain <harshjain.prof@gmail.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index fa749f4..433c425 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1691,6 +1691,7 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 		return PTR_ERR(sk_tfm);
 	}
 	drbg->ctr_handle = sk_tfm;
+	init_completion(&drbg->ctr_completion);
 
 	req = skcipher_request_alloc(sk_tfm, GFP_KERNEL);
 	if (!req) {
-- 
2.9.3
