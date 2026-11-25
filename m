Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592795;
	b=qb0yDSram76HbSoX0xCFVO/lfJiOngpOQn08EPK7zL9mxylbgBBp+0IwKotYISZDgqcq
	 aEM59yDC3SJr0HrVt14iHc/1c86vUkhCQRZ+/H1Di1n0eUDJSKtfnEqIbXbSQkw2wlD4P
	 n9xg8xulgBGeyxQljb/KOn3Il3Ay+W4l3UILfH2Nq+tB1joiFkYbfQaQup1FH0jRbtxUY
	 w57tohOVBf4IbjvXI+ma/FUZdU/tDCY25HxJviC99d/kqgQPJHfJYOSr8GjajWhLMnRFf
	 8u32Fqu97QL7vHeX4ixon56ASSmQw4hXGmV6ptD9w8ha+cZ2HJsYWDIfG4bxWjGh2yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592795;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=iVGNWXxllBHd7EdQJg7ldmdQ+3GVjGXPgvFVzNqtowc=;
	b=lCPoi2M94FOOyDxvOnLtG3yOH0GQKVE66Ugci05Y+b6w8uM1LLq4J2piFlnMfSYt92vN
	 DKqS+LonpcRSoP/1remLIrA8hzRBw854chihGIwLrTB0+Tf7eEzIuMz5Enqq9cTENuAor
	 3UH/gicDYmupkoKAKyH9AggD6n4RO4FgIP1lkO30j/obuvcE8mmnUzKGtqcPtsc5hek1y
	 i24FE7SWcfddgh8WaQaLyW1c+SLNKBALntUQTfYR/EjIllwHxvxhf02tQOLt+oBqIqueB
	 Cq+HctQIi27SVMIIWwCdCLF4cfjx2DsApRLgBsguXuu00VvXXvXY3bINRPPbmarJvkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C24606A31E;
	Wed, 25 Nov 2026 07:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C24606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZc6DxLzVcB5;
	Wed, 25 Nov 2026 15:46:32 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZb57bPzVcB5;
	Wed, 25 Nov 2026 15:46:31 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 1CD3C7741;
	Wed, 25 Nov 2026 15:46:25 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:31 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 03/11] crypto: ccp - add engine capability and version information
Date: Wed, 25 Nov 2026 15:46:01 +0800
Message-ID: <2512ecc20c8969a2d51403d8f184bf2f3260cc29.1795588986.git.yangdepei@hygon.cn>
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

Add a struct ccp_caps to struct ccp_device to record which engines a
device implements, together with the CCP and engine versions.  The
versions are not used yet; they are needed to tell features of the same
engine apart, for example whether an SM4 engine can run XTS.

A get_caps callback fills the set at probe time, after the register
mapping and device setup, so a device can derive it from a register
instead of a table.  Capabilities are BIT(enum ccp_engine) behind the
CCP_CAPS_* helpers, so the engine id in a command descriptor and its
capability bit cannot drift apart; ccp_has_cap() requires a single
device to provide every bit in the mask.

No algorithm registration is gated on this yet.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 12 +++++++++++
 drivers/crypto/ccp/ccp-dev-v5.c | 16 ++++++++++++++
 drivers/crypto/ccp/ccp-dev.c    | 37 +++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h    |  2 ++
 drivers/crypto/ccp/sp-dev.h     | 12 +++++++++++
 include/linux/ccp.h             | 22 ++++++++++++++++++++
 6 files changed, 101 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 02f7575e8f9b..b4715b694b53 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -587,12 +587,23 @@ static const struct ccp_actions ccp3_actions = {
 	.irqhandler = ccp_irq_handler,
 };
 
+/* Engines implemented for the v3 CCP.  3DES is not wired up for it. */
+#define CCP3_BASE_ENGINES	(CCP_CAPS_AES | CCP_CAPS_AES_XTS |	\
+				 CCP_CAPS_SHA | CCP_CAPS_RSA |		\
+				 CCP_CAPS_PASSTHRU | CCP_CAPS_ECC)
+
+static void ccp3_get_caps(struct ccp_device *ccp)
+{
+	ccp->caps.engines = CCP3_BASE_ENGINES;
+}
+
 const struct ccp_vdata ccpv3_platform = {
 	.version = CCP_VERSION(3, 0),
 	.setup = NULL,
 	.perform = &ccp3_actions,
 	.offset = 0,
 	.rsamax = CCP_RSA_MAX_WIDTH,
+	.get_caps = ccp3_get_caps,
 };
 
 const struct ccp_vdata ccpv3 = {
@@ -601,4 +612,5 @@ const struct ccp_vdata ccpv3 = {
 	.perform = &ccp3_actions,
 	.offset = 0x20000,
 	.rsamax = CCP_RSA_MAX_WIDTH,
+	.get_caps = ccp3_get_caps,
 };
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index bf76743845e3..372ccf7d1c8b 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -1118,12 +1118,27 @@ static const struct ccp_actions ccp5_actions = {
 	.get_free_slots = ccp5_get_free_slots,
 };
 
+/*
+ * Engines implemented by the AMD v5 CCP variants.  They are described
+ * statically, there is no engine presence register to read.
+ */
+#define CCP5_BASE_ENGINES	(CCP_CAPS_AES | CCP_CAPS_AES_XTS |	\
+				 CCP_CAPS_DES3 | CCP_CAPS_SHA |		\
+				 CCP_CAPS_RSA | CCP_CAPS_PASSTHRU |	\
+				 CCP_CAPS_ECC)
+
+static void ccp5_get_caps(struct ccp_device *ccp)
+{
+	ccp->caps.engines = CCP5_BASE_ENGINES;
+}
+
 const struct ccp_vdata ccpv5a = {
 	.version = CCP_VERSION(5, 0),
 	.setup = ccp5_config,
 	.perform = &ccp5_actions,
 	.offset = 0x0,
 	.rsamax = CCP5_RSA_MAX_WIDTH,
+	.get_caps = ccp5_get_caps,
 };
 
 const struct ccp_vdata ccpv5b = {
@@ -1133,4 +1148,5 @@ const struct ccp_vdata ccpv5b = {
 	.perform = &ccp5_actions,
 	.offset = 0x0,
 	.rsamax = CCP5_RSA_MAX_WIDTH,
+	.get_caps = ccp5_get_caps,
 };
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index aff3348b8351..ceaeca3d755a 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -242,6 +242,40 @@ int ccp_present(void)
 }
 EXPORT_SYMBOL_GPL(ccp_present);
 
+/**
+ * ccp_has_cap - check whether any CCP device provides a capability
+ *
+ * @cap: mask of BIT(enum ccp_engine) values
+ *
+ * Returns true if at least one registered CCP device provides all the
+ * engines in @cap.
+ *
+ * Commands are dispatched to the devices by round-robin without checking
+ * their capabilities, so a caller may only rely on this result when all
+ * the CCP devices of the system provide the same engines, as they do when
+ * they are instances of the same hardware.  A system mixing devices with
+ * different engines would need per-command capability filtering in the
+ * dispatch path.
+ */
+bool ccp_has_cap(unsigned int cap)
+{
+	struct ccp_device *dp;
+	unsigned long flags;
+	bool ret = false;
+
+	read_lock_irqsave(&ccp_unit_lock, flags);
+	list_for_each_entry(dp, &ccp_units, entry) {
+		if ((dp->caps.engines & cap) == cap) {
+			ret = true;
+			break;
+		}
+	}
+	read_unlock_irqrestore(&ccp_unit_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ccp_has_cap);
+
 /**
  * ccp_version - get the version of the CCP device
  *
@@ -634,6 +668,9 @@ int ccp_dev_init(struct sp_device *sp)
 	if (ccp->vdata->setup)
 		ccp->vdata->setup(ccp);
 
+	if (ccp->vdata->get_caps)
+		ccp->vdata->get_caps(ccp);
+
 	ret = ccp->vdata->perform->init(ccp);
 	if (ret) {
 		/* A positive number means that the device cannot be initialized,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 83350e2d9821..ef88962ff6e6 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/dmaengine.h>
+#include <linux/ccp.h>
 
 #include "sp-dev.h"
 
@@ -340,6 +341,7 @@ struct ccp_device {
 	struct list_head entry;
 
 	struct ccp_vdata *vdata;
+	struct ccp_caps caps;
 	unsigned int ord;
 	char name[MAX_CCP_NAME_LEN];
 	char rngname[MAX_CCP_NAME_LEN];
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index a83751cfd006..2513a3e92631 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -35,6 +35,17 @@
 
 /* Structure to hold CCP device data */
 struct ccp_device;
+
+/*
+ * Engines implemented by a CCP device, plus the CCP and engine
+ * versions.  A version of 0 means that it is not known.
+ */
+struct ccp_caps {
+	unsigned int engines;		/* BIT(enum ccp_engine) */
+	unsigned int ccp_version;
+	unsigned int engine_version;
+};
+
 struct ccp_vdata {
 	const unsigned int version;
 	const unsigned int dma_chan_attr;
@@ -42,6 +53,7 @@ struct ccp_vdata {
 	const struct ccp_actions *perform;
 	const unsigned int offset;
 	const unsigned int rsamax;
+	void (*get_caps)(struct ccp_device *ccp);
 };
 
 struct sev_vdata {
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index e6c599243f11..06c3b14a1eb6 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -11,6 +11,7 @@
 #ifndef __CCP_H__
 #define __CCP_H__
 
+#include <linux/bits.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
@@ -30,6 +31,13 @@ struct ccp_cmd;
  */
 int ccp_present(void);
 
+/**
+ * ccp_has_cap - check whether any CCP device provides a capability
+ *
+ * Returns: true if at least one registered CCP device provides it.
+ */
+bool ccp_has_cap(unsigned int cap);
+
 #define	CCP_VSIZE 16
 #define	CCP_VMASK		((unsigned int)((1 << CCP_VSIZE) - 1))
 #define	CCP_VERSION(v, r)	((unsigned int)((v << CCP_VSIZE) \
@@ -79,6 +87,11 @@ static inline unsigned int ccp_version(void)
 	return 0;
 }
 
+static inline bool ccp_has_cap(unsigned int cap)
+{
+	return false;
+}
+
 static inline int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
 	return -ENODEV;
@@ -630,6 +643,15 @@ enum ccp_engine {
 	CCP_ENGINE__LAST,
 };
 
+/* Engine capability bits, indexed by enum ccp_engine */
+#define CCP_CAPS_AES		BIT(CCP_ENGINE_AES)
+#define CCP_CAPS_AES_XTS	BIT(CCP_ENGINE_XTS_AES_128)
+#define CCP_CAPS_DES3		BIT(CCP_ENGINE_DES3)
+#define CCP_CAPS_SHA		BIT(CCP_ENGINE_SHA)
+#define CCP_CAPS_RSA		BIT(CCP_ENGINE_RSA)
+#define CCP_CAPS_PASSTHRU	BIT(CCP_ENGINE_PASSTHRU)
+#define CCP_CAPS_ECC		BIT(CCP_ENGINE_ECC)
+
 /* Flag values for flags member of ccp_cmd */
 #define CCP_CMD_MAY_BACKLOG		0x00000001
 #define CCP_CMD_PASSTHRU_NO_DMA_MAP	0x00000002
-- 
2.34.1


