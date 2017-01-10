From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 10/13] crypto: caam - copy AAD during encryption
Date: Tue, 10 Jan 2017 02:39:48 +0100
Message-ID: <1546323.qutA2LIN2H@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55378 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933311AbdAJBmE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 20:42:04 -0500
In-Reply-To: <10526995.lyZ7Je1KMx@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Invoke the crypto_aead_copy_ad function during the encryption code path
to copy the AAD from the source to the destination buffer.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/crypto/caam/caamalg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 662fe94..30ad943 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1433,6 +1433,10 @@ static int gcm_encrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
+	ret = crypto_aead_copy_ad(req);
+	if (ret)
+		return ret;
+
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, GCM_DESC_JOB_IO_LEN, &all_contig, true);
 	if (IS_ERR(edesc))
@@ -1476,6 +1480,10 @@ static int aead_encrypt(struct aead_request *req)
 	u32 *desc;
 	int ret = 0;
 
+	ret = crypto_aead_copy_ad(req);
+	if (ret)
+		return ret;
+
 	/* allocate extended descriptor */
 	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
 				 &all_contig, true);
-- 
2.9.3
