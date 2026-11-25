Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592801;
	b=QHO7wlRP0eVdTaE6nrBINEnYMvDn17949GuDOrGG6IwnDAaNzIK+QzvvvgH5Gm1j1M5X
	 mQq4L6fCoxg0gCLXVxURNyptwCcGJYDkz93EtuOs28yps78QWq/zoHIIBgMhr+KvFPMHs
	 Wh/p7oUO42hs31qUlkDENaCGqn1B5MEQTbC3nF8jkLoICJSdLvtHO0SgjPDT1AqJYPP0O
	 mee1whzyZlDrlMckXH2zaxXBxhyiPqpAt5wlE7G0Ysdi/inHxwWsh11Roe6n0bRjXCF6a
	 KAIaiA4cugJBheFQQ2QFB3SUfTAqMkioDf9TaJuDwZRTtnVmtxiXmVK9b98M2w6b5tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592801;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=KJMl/nkzigcnvNvswfuEjq665DntRv/CP48PL/cpQsM=;
	b=gepWPGiLlsGh7t6lk1jx3h0WE8ilN2Q+tiWBiGZKE8GOseTT2oUmPbo44qEYZdoe+nJn
	 Hk+MPsF/GrHMw9zIpzBmx76CUl8IsdO2eIKfBzEuZoJ/kCdOulRfjrlKZyBGWvu90BFzt
	 QvNvpjtWo4vu70hkEmo041DlI3lTKK7cjNA+V46pvfFq1c+iDMBd1RkglW9RWYiAiB/k6
	 Zr34ScBu5bZAMUXRJ79Bd74zMpdtEkWxovPbs6H6ETKnC+49nhAHe4fWzcgaRg7zWzcv6
	 /1yEdBjD/AakN67jTOMJ4jqjG5VE3qM6HudC51OymidAGe91k/EgUPy4jbtwVxuPHrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F53A60A2617;
	Wed, 25 Nov 2026 07:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F53A60A2617
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZk6F6TzVcBH;
	Wed, 25 Nov 2026 15:46:38 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZk19GHzVcB6;
	Wed, 25 Nov 2026 15:46:38 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 893957741;
	Wed, 25 Nov 2026 15:46:31 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:37 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 07/11] crypto: ccp - add Hygon CCP device IDs and vdata
Date: Wed, 25 Nov 2026 15:46:05 +0800
Message-ID: <8a1c16c33938b0e169c282136c85d7b522caedf1.1795588986.git.yangdepei@hygon.cn>
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

Hygon CCP devices use the v5 programming model.  Add the PCI IDs and a
minimal vdata table.  The get_caps callback is a placeholder that
advertises only the SM engines; a later patch replaces it with
register-based detection.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v5.c | 32 ++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |  2 ++
 drivers/crypto/ccp/sp-pci.c     | 35 +++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 9b1593703ec5..34832b830785 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -1198,3 +1198,35 @@ const struct ccp_vdata ccpv5b = {
 	.rsamax = CCP5_RSA_MAX_WIDTH,
 	.get_caps = ccp5_get_caps,
 };
+
+/*
+ * Hygon CCP is a v5 derivative with the SM3/SM4 engines added.  It
+ * uses the same queue, LSB and interrupt model as the AMD v5 CCP.
+ *
+ * TODO: derive the legacy engines from the Hygon engine register once
+ * its layout is confirmed.  Until then only the engines that cannot be
+ * detected from a register are advertised.
+ */
+static void ccp5_hygon_get_caps(struct ccp_device *ccp)
+{
+	ccp->caps.engines = CCP_CAPS_SM3 | CCP_CAPS_SM4 | CCP_CAPS_SM4_CTR;
+}
+
+const struct ccp_vdata ccpv5a_hygon = {
+	.version = CCP_VERSION(5, 0),
+	.setup = ccp5_config,
+	.perform = &ccp5_actions,
+	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
+	.get_caps = ccp5_hygon_get_caps,
+};
+
+const struct ccp_vdata ccpv5b_hygon = {
+	.version = CCP_VERSION(5, 0),
+	.dma_chan_attr = DMA_PRIVATE,
+	.setup = ccp5other_config,
+	.perform = &ccp5_actions,
+	.offset = 0x0,
+	.rsamax = CCP5_RSA_MAX_WIDTH,
+	.get_caps = ccp5_hygon_get_caps,
+};
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 813a1b20c3c2..f499e6868d82 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -694,5 +694,7 @@ extern const struct ccp_vdata ccpv3_platform;
 extern const struct ccp_vdata ccpv3;
 extern const struct ccp_vdata ccpv5a;
 extern const struct ccp_vdata ccpv5b;
+extern const struct ccp_vdata ccpv5a_hygon;
+extern const struct ccp_vdata ccpv5b_hygon;
 
 #endif
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index ede6ff9ad0c2..dafd934836dc 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -551,6 +551,33 @@ static const struct sp_dev_vdata dev_vdata[] = {
 	},
 
 };
+
+/*
+ * Hygon secure processor devices.  They are CCP v5 derivatives, so
+ * they reuse the v5 CCP programming model.  The PSP/CSV side is not
+ * described here.
+ */
+static const struct sp_dev_vdata hygon_dev_vdata[] = {
+	{	/* 0 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_CCP
+		.ccp_vdata = &ccpv5a_hygon,
+#endif
+	},
+	{	/* 1 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_CCP
+		.ccp_vdata = &ccpv5b_hygon,
+#endif
+	},
+	{	/* 2 */
+		.bar = 2,
+#ifdef CONFIG_CRYPTO_DEV_SP_CCP
+		.ccp_vdata = &ccpv5a_hygon,
+#endif
+	},
+};
+
 static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1537), .driver_data = (kernel_ulong_t)&dev_vdata[0] },
 	{ PCI_VDEVICE(AMD, 0x1456), .driver_data = (kernel_ulong_t)&dev_vdata[1] },
@@ -565,6 +592,14 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x156E), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
 	{ PCI_VDEVICE(AMD, 0x17D8), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
 	{ PCI_VDEVICE(AMD, 0x115A), .driver_data = (kernel_ulong_t)&dev_vdata[9] },
+	{ PCI_VDEVICE(HYGON, 0x1456), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[0] },
+	{ PCI_VDEVICE(HYGON, 0x1468), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[1] },
+	{ PCI_VDEVICE(HYGON, 0x1486), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[2] },
+	{ PCI_VDEVICE(HYGON, 0x14b8), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[1] },
+	{ PCI_VDEVICE(HYGON, 0x14a6), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[2] },
+	{ PCI_VDEVICE(HYGON, 0x14d8), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[1] },
+	{ PCI_VDEVICE(HYGON, 0x14c6), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[2] },
+	{ PCI_VDEVICE(HYGON, 0x2006), .driver_data = (kernel_ulong_t)&hygon_dev_vdata[2] },
 	/* Last entry must be zero */
 	{ }
 };
-- 
2.34.1


