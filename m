Return-Path: <SRS0=EWVs=PV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbfAMXeU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jan 2019 18:34:20 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] crypto: testmgr - skip AEAD encryption test vectors with novrfy set
Date: Sun, 13 Jan 2019 15:32:24 -0800
Message-Id: <20190113233228.5851-2-ebiggers@kernel.org>
In-Reply-To: <20190113233228.5851-1-ebiggers@kernel.org>
References: <20190113233228.5851-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In preparation for unifying the AEAD encryption and decryption test
vectors, skip AEAD test vectors with the 'novrfy' (verification failure
expected) flag set when testing encryption rather than decryption.
These test vectors only make sense for decryption.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f684a414acbe..e075b896c0290 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -671,6 +671,8 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 	for (i = 0, j = 0; i < tcount; i++) {
 		if (template[i].np)
 			continue;
+		if (enc && template[i].novrfy)
+			continue;
 
 		j++;
 
@@ -787,6 +789,9 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		if (!template[i].np)
 			continue;
 
+		if (enc && template[i].novrfy)
+			continue;
+
 		j++;
 
 		if (template[i].iv)
-- 
2.20.1
