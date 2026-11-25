Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592794;
	b=R6f0eTiGzfT0JTd6dB4K4pvFaZ/iwQbRBsZDmlag/uUfZKWYufv1FFpl2UlXEwgzCsVL
	 iZGP8K4e7roCIaquCGCryNyBATpexeAlp6b0m3kuH3gRDMzKfageHAaT1afLgyjivDpoa
	 gXXfaDKxPg8arqwH9xcMicMWnPIQEUTqhk/wqWqB3wu4UTkhlgLXPP1zSpBFAN3cNG95j
	 TgCra5MOaUBeT4O79CO8iW4EOWo8kcNoH5f9u9k/RoYBpzSfVBqDtsoMljKHMIjYt94f/
	 pN3QOPQZK80wgveZ0jhewrsLlffqC9kjwLoayYarnVUPjr+0UVMx8Audd47tfKYPvBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592794;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=OUE1Ji+RCTKkcHGjstISp0TSklHcKzn+D/hs1RowxLc=;
	b=qTtdTBXnbTGRn+ZBcBwmy2z/NAvepGtknCFzSIsfkD7ybn5T07gO6uJPTzXtNWD/Isig
	 wub+MMYJ+0oSbw5gJrIKiCfMRg7T6+IRLfE+LN0PhbJ0G5v0BwSkwtghpZNy2pI5l7atR
	 orCRUxFQEOe0SHm4SOl/Kr8Ja873WdadzM3Is+b3/VbbeyYPPEOKvNcSn0veRja6b0mq6
	 qXgy7Q7uGNikLVGLG4fuTUAgUL9L84iUYo/Y8V90oSs5y3e3+V6j7vGCT19YGAzlTOCNa
	 KslpeeOeu0uqudvwPlVPRGMm0PKWVFXYcEi1yzJDL3KVgLK0fuvWrrVuXr5O1aCGfrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37059606A335;
	Wed, 25 Nov 2026 07:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37059606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZY6DwHzVhfS;
	Wed, 25 Nov 2026 15:46:29 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZW4Jt6zVhfS;
	Wed, 25 Nov 2026 15:46:27 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 0151D157D;
	Wed, 25 Nov 2026 15:46:21 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:27 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>,
	<stable@vger.kernel.org>
Subject: [PATCH 01/11] crypto: ccp - fix LSB region mask calculation
Date: Wed, 25 Nov 2026 15:45:59 +0800
Message-ID: <4ee059fdd4a5f374b94625c25ea4abd2b2c10237.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

ccp_find_lsb_regions() tests the queue bit of status before shifting the
register by the region width, so region 0 is examined for region 1 and
the last region is never checked.  Shift the status before the loop so
that each iteration tests the region it records.

Fixes: 4b394a232df7 ("crypto: ccp - Let a v5 CCP provide the same function as v3")
Cc: stable@vger.kernel.org
Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index dacde9614e8a..4a546224af79 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -593,6 +593,7 @@ static int ccp_find_lsb_regions(struct ccp_cmd_queue *cmd_q, u64 status)
 	/* Build a bit mask to know which LSBs this queue has access to.
 	 * Don't bother with segment 0 as it has special privileges.
 	 */
+	status >>= LSB_REGION_WIDTH;
 	for (j = 1; j < MAX_LSB_CNT; j++) {
 		if (status & q_mask)
 			bitmap_set(cmd_q->lsbmask, j, 1);
-- 
2.34.1


