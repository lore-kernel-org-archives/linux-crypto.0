Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509044AA595;
	Tue,  8 Sep 2026 09:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860689; cv=none; b=uLSR60VL189q+XdpVZU3vwptrtUxlFIBbl9NbiPp8n024CRsf8ESYEht/MtCyBJA68L42XEcpoRzOfMWMocX7AMxbzgy5ho6f5O3I92+z+hqwlSPCPMYVUHv6eWcX7UZmBNv4hKCM2iiWBgm7KI/I0eCm7vXnFSUgF9Tz81SNdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860689; c=relaxed/simple;
	bh=hZE62hYy80JCmRJl8frLe8BRekVemno7foWWlr7ByQA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oznXUkV7GN7jfeUHEOmJArXfnt/tyOSM7v29C2c3iWi+37AhkhR7VjesEWJdu6B2iuS1YCZA2yQFdbrxEyr9ohWd1tM2m0tn0ZqBTdbK/oUiphhSOS8zuUOFUw/Ni4x4WgJgEEeO7HJQt+UWy3ScnsFi5v27/H+uUDm77dUks7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ea830a7aab6911f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:1aaeb123-10e7-410a-b55b-6715d5593966,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:b7342ac129824bbfa49c5374921c0be9,BulkI
	D:nil,BulkQuantity:0,SF:102|136|850|865|898,TC:nil,Content:0|15|50|99,EDM:
	-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
	SA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ea830a7aab6911f19a56ed5b684f684d-20260908
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1401455100; Tue, 08 Sep 2026 17:44:41 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Frank Li <Frank.Li@oss.nxp.com>,
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
Subject: [PATCH v2] crypto: mxs-dcp: handle zero-length skcipher requests
Date: Tue,  8 Sep 2026 17:44:37 +0800
Message-Id: <20260908094437.1548278-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The generic ECB and CBC implementations return success for zero-length
requests, but MXS-DCP queues them anyway. When such a request reaches
the worker, last_out_len remains zero. The CBC completion path then
subtracts AES_BLOCK_SIZE from this unsigned value when updating the IV,
causing the offset to underflow. On decryption, the resulting source
address precedes aes_in_buf.

Return success before enqueueing zero-length requests, matching the
generic implementations. This avoids the invalid source access and
leaves the IV unchanged.

Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
v2: Clarify commit message: describe zero-length return-0 as existing
    generic ECB/CBC behavior rather than a general API rule (Frank Li).
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

