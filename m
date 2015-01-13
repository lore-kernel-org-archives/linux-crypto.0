From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Fix for qat_aes_cbc_hmac_sha512
Date: Tue, 13 Jan 2015 12:27:53 -0800
Message-ID: <20150113202753.32216.26250.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:60104 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbbAMUb3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 15:31:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

After commit ad511e2 the qat_aes_cbc_hmac_sha512 stopped working:

alg: aead: Test 1 failed on encryption for qat_aes_cbc_hmac_sha512.
00000000: e3 53 77 9c 10 79 ae b8 27 08 94 2d be 77 18 1a
00000010: 94 8a 3a b4 70 5d 3b e5 89 f9 35 14 e5 3f dc 9b
00000020: 45 a2 a9 0b 95 eb 23 0a 81 d8 44 5c 0d 30 90 b8
00000030: 1e c6 de 20 23 66 c3 1f 5f 19 ce f2 f8 10 38 66
00000040: fc e7 1c 47 88 cf c3 34 0c 28 16 4e 17 d1 d0 75

We need to explicitly clean the rest of the context buffer
to make it working again.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index a0d95f3..1c2f259 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -186,10 +186,14 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 
 		memcpy(ipad, buff, digest_size);
 		memcpy(opad, buff, digest_size);
+		memset(ipad + digest_size, 0, block_size - digest_size);
+		memset(opad + digest_size, 0, block_size - digest_size);
 		memzero_explicit(buff, sizeof(buff));
 	} else {
 		memcpy(ipad, auth_key, auth_keylen);
 		memcpy(opad, auth_key, auth_keylen);
+		memset(ipad + auth_keylen, 0, block_size - auth_keylen);
+		memset(opad + auth_keylen, 0, block_size - auth_keylen);
 	}
 
 	for (i = 0; i < block_size; i++) {
