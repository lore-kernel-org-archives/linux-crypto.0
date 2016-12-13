From: Ilya Lesokhin <ilyal@mellanox.com>
Subject: [PATCH] crypto: aesni-intel - RFC4106 can zero copy when !PageHighMem
Date: Tue, 13 Dec 2016 16:32:06 +0200
Message-ID: <1481639526-71743-1-git-send-email-ilyal@mellanox.com>
Cc: tls-fpga-sw-dev@mellanox.com, Ilya Lesokhin <ilyal@mellanox.com>
To: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
        herbert@gondor.apana.org.au, davejwatson@fb.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34541 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932452AbcLMOcU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 09:32:20 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the common case of !PageHighMem we can do zero copy crypto
even if sg crosses a pages boundary.

Signed-off-by: Ilya Lesokhin <ilyal@mellanox.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index b1ab0cb..b494ad7 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -903,9 +903,11 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 	*((__be32 *)(iv+12)) = counter;
 
 	if (sg_is_last(req->src) &&
-	    req->src->offset + req->src->length <= PAGE_SIZE &&
+	    (!PageHighMem(sg_page(req->src)) ||
+	    req->src->offset + req->src->length <= PAGE_SIZE) &&
 	    sg_is_last(req->dst) &&
-	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
+	    (!PageHighMem(sg_page(req->dst)) ||
+	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
 		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		assoc = scatterwalk_map(&src_sg_walk);
@@ -990,9 +992,11 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 	*((__be32 *)(iv+12)) = counter;
 
 	if (sg_is_last(req->src) &&
-	    req->src->offset + req->src->length <= PAGE_SIZE &&
+	    (!PageHighMem(sg_page(req->src)) ||
+	    req->src->offset + req->src->length <= PAGE_SIZE) &&
 	    sg_is_last(req->dst) &&
-	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
+	    (!PageHighMem(sg_page(req->dst)) ||
+	    req->dst->offset + req->dst->length <= PAGE_SIZE)) {
 		one_entry_in_sg = 1;
 		scatterwalk_start(&src_sg_walk, req->src);
 		assoc = scatterwalk_map(&src_sg_walk);
-- 
1.8.3.1
