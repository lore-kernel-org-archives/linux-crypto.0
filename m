From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 05/13] crypto: ccm-aes-ce - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:38:04 +0100
Message-ID: <23557836.vhvS21O3kI@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55396 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:12 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From acad5f6af68d18bc1dbac460bd44f2298902018b Mon Sep 17 00:00:00 2001
From: Stephan Mueller <smueller@chronox.de>
Date: Mon, 9 Jan 2017 14:32:02 +0100
Subject: 

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 arch/arm64/crypto/aes-ce-ccm-glue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index cc5515d..7dfcb1f 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -155,6 +155,10 @@ static int ccm_encrypt(struct aead_request *req)
 	u32 len = req->cryptlen;
 	int err;
 
+	err = crypto_aead_copy_ad(req);
+	if (err)
+		return err;
+
 	err = ccm_init_mac(req, mac, len);
 	if (err)
 		return err;
-- 
2.9.3
