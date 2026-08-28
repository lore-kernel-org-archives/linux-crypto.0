Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02D03ABD83;
	Fri, 28 Aug 2026 09:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787909550; cv=none; b=D+fPZtGs0hY+JsWoRjQ5YwYvHZvGHLRukytH15UWBgb/0XYO6J57hT3Gi3NFNLXgmm00xpsS415UdOdDZ2L8yq/dM4Jf9pxk1V1tcNfuu/UprCk4J99kxFz7nq50z4Jy3sMsnDAxA6Hva/M+MPgtTW03YK+htuCv8M4iqR2GfWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787909550; c=relaxed/simple;
	bh=SOOKcccjHdokT3Gm6jWS5PsSmgC2ZmP5eBSowkZz40E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BZHQGcyVMcfjINPCvgHWs3U62dsvWsq8a5y/fPRjUQksLVJhs+V4HSMCg8DFaW0bG9H5CcMeQv774RnbhnuYN/cLR28oVlJveFOrHOpdNnw0bdMyLZHKzR8q6YFff6beJD2U9qmg+3KbTyxdZjaowkviHp9Ip5h2V69ao3sH2Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5aa6cab2a2c311f19a56ed5b684f684d-20260828
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dcb9b930-7f0b-47d0-8b1a-9599af8b65e9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:de7f7b520905538144b6a9cbf562d347,BulkI
	D:nil,BulkQuantity:0,SF:102|136|850|865|898,TC:nil,Content:0|15|50,EDM:-3|
	-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5aa6cab2a2c311f19a56ed5b684f684d-20260828
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1162320256; Fri, 28 Aug 2026 17:32:14 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Radu Solea <radu.solea@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>,
	linux-crypto@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH] crypto: mxs-dcp: handle zero-length skcipher requests
Date: Fri, 28 Aug 2026 17:32:09 +0800
Message-Id: <20260828093209.3179074-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
When such a request reaches the worker, last_out_len remains zero. The
CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
value when updating the IV, causing the offset to underflow. On
decryption, the resulting source address precedes aes_in_buf.

Return success before enqueueing zero-length requests. This avoids the
invalid source access and leaves the IV unchanged for a no-op.

Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/crypto/mxs-dcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 133ebc998236..60794b4d49fa 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -473,6 +473,9 @@ static int mxs_dcp_aes_enqueue(struct skcipher_request *req, int enc, int ecb)
 	struct dcp_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	int ret;
 
+	if (!req->cryptlen)
+		return 0;
+
 	if (unlikely(actx->key_len != AES_KEYSIZE_128 && !actx->key_referenced))
 		return mxs_dcp_block_fallback(req, enc);
 

base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
2.25.1

