From: Anton Blanchard <anton@ozlabs.org>
Subject: [PATCH 2/2] crypto: vmx: Increase priority of aes-cbc cipher
Date: Fri, 10 Jun 2016 16:47:03 +1000
Message-ID: <1465541223-17537-2-git-send-email-anton@ozlabs.org>
References: <1465541223-17537-1-git-send-email-anton@ozlabs.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
To: pfsmorigo@linux.vnet.ibm.com, benh@kernel.crashing.org,
	paulus@samba.org, mpe@ellerman.id.au, herbert@gondor.apana.org.au,
	davem@davemloft.net, strosake@austin.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48941 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbcFJGrL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 02:47:11 -0400
In-Reply-To: <1465541223-17537-1-git-send-email-anton@ozlabs.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anton Blanchard <anton@samba.org>

All of the VMX AES ciphers (AES, AES-CBC and AES-CTR) are set at
priority 1000. Unfortunately this means we never use AES-CBC and
AES-CTR, because the base AES-CBC cipher that is implemented on
top of AES inherits its priority.

To fix this, AES-CBC and AES-CTR have to be a higher priority. Set
them to 2000.

Testing on a POWER8 with:

cryptsetup benchmark --cipher aes --key-size 256

Shows decryption speed increase from 402.4 MB/s to 3069.2 MB/s,
over 7x faster. Thanks to Mike Strosaker for helping me debug
this issue.

Fixes: 8c755ace357c ("crypto: vmx - Adding CBC routines for VMX module")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 drivers/crypto/vmx/aes_cbc.c | 2 +-
 drivers/crypto/vmx/aes_ctr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/aes_cbc.c b/drivers/crypto/vmx/aes_cbc.c
index 495577b..94ad5c0 100644
--- a/drivers/crypto/vmx/aes_cbc.c
+++ b/drivers/crypto/vmx/aes_cbc.c
@@ -182,7 +182,7 @@ struct crypto_alg p8_aes_cbc_alg = {
 	.cra_name = "cbc(aes)",
 	.cra_driver_name = "p8_aes_cbc",
 	.cra_module = THIS_MODULE,
-	.cra_priority = 1000,
+	.cra_priority = 2000,
 	.cra_type = &crypto_blkcipher_type,
 	.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_alignmask = 0,
diff --git a/drivers/crypto/vmx/aes_ctr.c b/drivers/crypto/vmx/aes_ctr.c
index 0a3c1b0..38ed10d 100644
--- a/drivers/crypto/vmx/aes_ctr.c
+++ b/drivers/crypto/vmx/aes_ctr.c
@@ -166,7 +166,7 @@ struct crypto_alg p8_aes_ctr_alg = {
 	.cra_name = "ctr(aes)",
 	.cra_driver_name = "p8_aes_ctr",
 	.cra_module = THIS_MODULE,
-	.cra_priority = 1000,
+	.cra_priority = 2000,
 	.cra_type = &crypto_blkcipher_type,
 	.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_alignmask = 0,
-- 
2.7.4
