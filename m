Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592805;
	b=XQu9AaQbdnkL4I9rKceWAJhIMG50EuKUAFzUeM7tz0h/oC52Gj8XvLUjx1OmCUhJHFgB
	 Jl7NbM6pLAn2HTLmrXKN4KgfnigYE37jdtc6OSVie5vClEFmslaRTeIIR0hci706ZlvsC
	 h0eveKtHFRclSgcnS1KGe+dp3RhX7kkP/9sdmoztmP8gm2HeQcmZ4yoSHs2NIJbPoHUl0
	 SKFpwFHcbfW9i1WFfGbilKrc8zqi4UlID+dt3z2bcmS52cUW5KR3KR7ZTCH0De+HpWnTS
	 ee5cAEvCp8QL3+UxuzhSzQv2UjMA/0hZpOhUh9LK+cIgtBFCVR2VCSgtyqY1jIQO94A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592805;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=KUnEXXB+kzAIiXjHIMN04bGtEdzozMgJ0VtfgRKm+KA=;
	b=D9/TnLeLs/uI9zCzJ4KfOa+2QPIGAP7AI4tcwkcpwGv7xLvBl5h8qR+bCF5Mv9Eaktui
	 9nmxai2kltu2zcdDrcFItq/VKrGvf4qGCtyRnn+h3tiM3P0B06CVRwplwqqqgxCvvjpUT
	 UE1rhb03vWIFpxWQ+yL6400NDHHvGp1k+dFNriVeqDaIK2IMU2/zWwJXkarQuGvACsvPz
	 XNQQip08KFKbJCT8pM33V9ejk4zHeqnWimXPD5oh1p3eAzuSKtbFdGr4VsWJ/VIbtGKeD
	 xmwq30NMn9tw+i9TtJJo7fuUFkiIqRDyB17gRVRZYkj0a4P4csqPx0XEmBTsGcADZ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E99A60A3812;
	Wed, 25 Nov 2026 07:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E99A60A3812
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZn6FJSzVcBK;
	Wed, 25 Nov 2026 15:46:41 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZm29LgzVcB9;
	Wed, 25 Nov 2026 15:46:40 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id ABE567741;
	Wed, 25 Nov 2026 15:46:33 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:39 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 09/11] crypto: ccp - detect the Hygon CCP engines from the version register
Date: Wed, 25 Nov 2026 15:46:07 +0800
Message-ID: <57e545fa739fb63e618a1456636885ab0b20bef8.1795588986.git.yangdepei@hygon.cn>
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

The Hygon CCP reports the engines it implements in the upper bits of the
CCP version register, starting at bit 6: SM2, SM3, SM4, SM4-CTR, ECC,
AES, SHA2, TRNG and SM4-GCM.

Translate the presence bits into engine capabilities in
ccp5_hygon_get_caps().  The same function stores the raw register value
and the engine version read from the new CMD5_PSP_CCP_ENG_VERSION
register; neither is used yet.  Only the SM engines are advertised for
now; the other presence bits are defined but not translated until those
engines are enabled.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 42 +++++++++++++++++++++++++++++----
 drivers/crypto/ccp/ccp-dev.h    |  1 +
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index d2586625700b..0284be103ad1 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -1203,13 +1203,47 @@ const struct ccp_vdata ccpv5b = {
  * Hygon CCP is a v5 derivative with the SM3/SM4 engines added.  It
  * uses the same queue, LSB and interrupt model as the AMD v5 CCP.
  *
- * TODO: derive the legacy engines from the Hygon engine register once
- * its layout is confirmed.  Until then only the engines that cannot be
- * detected from a register are advertised.
+ * Engine presence is reported by the bits 6 and above of the CCP
+ * version register; the layout differs from the AMD one.
  */
+#define HYGON_RI_SM2		BIT(6)
+#define HYGON_RI_SM3		BIT(7)
+#define HYGON_RI_SM4		BIT(8)
+#define HYGON_RI_SM4_CTR	BIT(9)
+#define HYGON_RI_ECC		BIT(10)
+#define HYGON_RI_AES		BIT(11)
+#define HYGON_RI_SHA2		BIT(12)
+#define HYGON_RI_TRNG		BIT(13)
+#define HYGON_RI_SM4_GCM	BIT(14)
+
 static void ccp5_hygon_get_caps(struct ccp_device *ccp)
 {
-	ccp->caps.engines = CCP_CAPS_SM3 | CCP_CAPS_SM4 | CCP_CAPS_SM4_CTR;
+	/*
+	 * Only the SM engines are advertised for now.  SM2, ECC, AES,
+	 * SHA2, TRNG and SM4-GCM are not enabled for the Hygon CCP yet;
+	 * they will be added to the table once the driver supports them
+	 * on this hardware.
+	 */
+	static const struct {
+		u32 presence;
+		u32 cap;
+	} engines[] = {
+		{ HYGON_RI_SM3,		CCP_CAPS_SM3 },
+		{ HYGON_RI_SM4,		CCP_CAPS_SM4 },
+		{ HYGON_RI_SM4_CTR,	CCP_CAPS_SM4_CTR },
+	};
+	u32 version;
+	unsigned int i;
+
+	version = ioread32(ccp->io_regs + CMD5_PSP_CCP_VERSION);
+	ccp->caps.ccp_version = version;
+	ccp->caps.engine_version =
+		ioread32(ccp->io_regs + CMD5_PSP_CCP_ENG_VERSION);
+	ccp->caps.engines = 0;
+
+	for (i = 0; i < ARRAY_SIZE(engines); i++)
+		if (version & engines[i].presence)
+			ccp->caps.engines |= engines[i].cap;
 }
 
 const struct ccp_vdata ccpv5a_hygon = {
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index f499e6868d82..c2b8068bc123 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -71,6 +71,7 @@
 #define LSB_PRIVATE_MASK_LO_OFFSET	0x20
 #define LSB_PRIVATE_MASK_HI_OFFSET	0x24
 #define CMD5_PSP_CCP_VERSION		0x100
+#define CMD5_PSP_CCP_ENG_VERSION	0x104
 
 #define CMD5_Q_CONTROL_BASE		0x0000
 #define CMD5_Q_TAIL_LO_BASE		0x0004
-- 
2.34.1


