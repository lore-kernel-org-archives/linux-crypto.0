From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v2 11/12] crypto: sun4i-ss: fix large block size support
Date: Mon, 29 May 2017 22:27:37 +0200
Message-ID: <20170529202738.2167-12-antoine.tenart@free-electrons.com>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        clabbe.montjoie@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:36630 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbdE2U2X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 16:28:23 -0400
In-Reply-To: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The run-time self-tests fail quite early, as soon as the input block
size is larger than 64 bytes:

  alg: hash: Test 4 failed for sha1-sun4i-ss
  00000000: b9 c9 1e 52 c0 26 d8 39 81 ff f2 3c 99 b1 27 b2
  00000010: 30 d6 c9 85

One thing to notice is the value of the last word, which is the one
expected (it can sometime be the last two words). The datasheet isn't
very clear about when the digest is ready to retrieve and is seems the
bit SS_DATA_END is cleared when the digest was computed *but* that
doesn't mean the digest is ready to retrieve in the registers.

A ndelay(1) is added before reading the computed digest to ensure it is
available in the SS_MD[] registers.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index 685de5b6ab17..a4b5ff2b72f8 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -358,6 +358,15 @@ static int sun4i_hash(struct ahash_request *areq)
 		goto release_ss;
 	}
 
+	/*
+	 * The datasheet isn't very clear about when to retrieve the digest. The
+	 * bit SS_DATA_END is cleared when the engine has processed the data and
+	 * when the digest is computed *but* it doesn't mean the digest is
+	 * available in the digest registers. Hence the delay to be sure we can
+	 * read it.
+	 */
+	ndelay(1);
+
 	for (i = 0; i < crypto_ahash_digestsize(tfm) / 4; i++)
 		op->hash[i] = readl(ss->base + SS_MD0 + i * 4);
 
@@ -446,6 +455,15 @@ static int sun4i_hash(struct ahash_request *areq)
 		goto release_ss;
 	}
 
+	/*
+	 * The datasheet isn't very clear about when to retrieve the digest. The
+	 * bit SS_DATA_END is cleared when the engine has processed the data and
+	 * when the digest is computed *but* it doesn't mean the digest is
+	 * available in the digest registers. Hence the delay to be sure we can
+	 * read it.
+	 */
+	ndelay(1);
+
 	/* Get the hash from the device */
 	if (op->mode == SS_OP_SHA1) {
 		for (i = 0; i < 5; i++) {
-- 
2.9.4
