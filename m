From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Prevent information leakage on export
Date: Wed, 13 Apr 2016 10:52:25 -0500
Message-ID: <20160413155225.6730.31823.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0081.outbound.protection.outlook.com ([65.55.169.81]:57096
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186AbcDMPwn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Apr 2016 11:52:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Prevent information from leaking to userspace by doing a memset to 0 of
the export state structure before setting the structure values and copying
it. This prevents un-initialized padding areas from being copied into the
export area.

Cc: <stable@vger.kernel.org> # 3.14.x-
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    3 +++
 drivers/crypto/ccp/ccp-crypto-sha.c      |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 3d9acc5..60fc0fa 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -225,6 +225,9 @@ static int ccp_aes_cmac_export(struct ahash_request *req, void *out)
 	struct ccp_aes_cmac_req_ctx *rctx = ahash_request_ctx(req);
 	struct ccp_aes_cmac_exp_ctx state;
 
+	/* Don't let anything leak to 'out' */
+	memset(&state, 0, sizeof(state));
+
 	state.null_msg = rctx->null_msg;
 	memcpy(state.iv, rctx->iv, sizeof(state.iv));
 	state.buf_count = rctx->buf_count;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index b5ad728..8f36af6 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -212,6 +212,9 @@ static int ccp_sha_export(struct ahash_request *req, void *out)
 	struct ccp_sha_req_ctx *rctx = ahash_request_ctx(req);
 	struct ccp_sha_exp_ctx state;
 
+	/* Don't let anything leak to 'out' */
+	memset(&state, 0, sizeof(state));
+
 	state.type = rctx->type;
 	state.msg_bits = rctx->msg_bits;
 	state.first = rctx->first;
