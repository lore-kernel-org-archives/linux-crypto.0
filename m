Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729097AbfAJUSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/11] crypto: af_alg - use list_for_each_entry() in af_alg_count_tsgl()
Date: Thu, 10 Jan 2019 12:18:01 -0800
Message-Id: <20190110201802.82442-11-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

af_alg_count_tsgl() iterates through a list without modifying it, so use
list_for_each_entry() rather than list_for_each_entry_safe().  Also make
the pointers 'const' to make it clearer that nothing is modified.

No actual change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/af_alg.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ccae4a7ada8ab..1dd573a441279 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -530,17 +530,17 @@ static int af_alg_alloc_tsgl(struct sock *sk)
  */
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 {
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl, *tmp;
+	const struct alg_sock *ask = alg_sk(sk);
+	const struct af_alg_ctx *ctx = ask->private;
+	const struct af_alg_tsgl *sgl;
 	unsigned int i;
 	unsigned int sgl_count = 0;
 
 	if (!bytes)
 		return 0;
 
-	list_for_each_entry_safe(sgl, tmp, &ctx->tsgl_list, list) {
-		struct scatterlist *sg = sgl->sg;
+	list_for_each_entry(sgl, &ctx->tsgl_list, list) {
+		const struct scatterlist *sg = sgl->sg;
 
 		for (i = 0; i < sgl->cur; i++) {
 			size_t bytes_count;
-- 
2.20.1.97.g81188d93c3-goog
