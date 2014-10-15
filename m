From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [cryptodev PATCH] qat: cleanup unnecessary break checkpatch warning
Date: Wed, 15 Oct 2014 11:33:27 -0700
Message-ID: <20141015183327.23860.11389.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, qat-linux@intel.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43771 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJOSdX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Oct 2014 14:33:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

WARNING:UNNECESSARY_BREAK: break is not useful after a goto or return
#472: FILE: drivers/crypto/qat/qat_common/qat_algs.c:472:
+               goto bad_key;
+               break;

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/qat_algs.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 3e26fa2..e03afe9 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -469,7 +469,6 @@ static int qat_alg_init_sessions(struct qat_alg_session_ctx *ctx,
 		break;
 	default:
 		goto bad_key;
-		break;
 	}
 
 	if (qat_alg_init_enc_session(ctx, alg, &keys))
