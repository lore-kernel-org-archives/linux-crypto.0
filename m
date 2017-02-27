From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: ccm - move cbcmac input off the stack
Date: Mon, 27 Feb 2017 15:30:56 +0000
Message-ID: <1488209456-7653-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: johannes@sipsolutions.net,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:36552 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdB0Pcw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 10:32:52 -0500
Received: by mail-wr0-f177.google.com with SMTP id u108so24786497wrb.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2017 07:31:13 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
refactored the CCM driver to allow separate implementations of the
underlying MAC to be provided by a platform. However, in doing so, it
moved some data from the linear region to the stack, which violates the
SG constraints when the stack is virtually mapped.

So move idata/odata back to the request ctx struct, of which we can
reasonably expect that it has been allocated using kmalloc() et al.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Fixes: f15f05b0a5de ("crypto: ccm - switch to separate cbcmac driver")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ccm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 442848807a52..1ce37ae0ce56 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -45,6 +45,7 @@ struct crypto_rfc4309_req_ctx {
 
 struct crypto_ccm_req_priv_ctx {
 	u8 odata[16];
+	u8 idata[16];
 	u8 auth_tag[16];
 	u32 flags;
 	struct scatterlist src[3];
@@ -183,8 +184,8 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	AHASH_REQUEST_ON_STACK(ahreq, ctx->mac);
 	unsigned int assoclen = req->assoclen;
 	struct scatterlist sg[3];
-	u8 odata[16];
-	u8 idata[16];
+	u8 *odata = pctx->odata;
+	u8 *idata = pctx->idata;
 	int ilen, err;
 
 	/* format control data for input */
-- 
2.7.4
