Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0663806A2;
	Fri, 20 Mar 2026 10:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003881; cv=fail; b=Y2sS6DildNW5Sl63Nc+PuIoeSOu+K3YaJ5TZrnQCe/xF2rcrKrSNaF3iPOMhYwhrk0YruAPH4Z9FQdYCvPP2MaXyJWCM6fOxP6TLkQX2oU+tGQFwvL3Z33rZ8wTib94+iF0yPUxXC7PPdF7aDdvOzK4EXGiRi1DNJYRLJ3s0CxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003881; c=relaxed/simple;
	bh=au319tKr1TNjrTFMQtoYJoGR1ddTd7NJxaJtn6Enrpc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMMGwZp5SkXPgreX1HgDRqqcUiNgnWqwTpnUNiphkC29fUXKc261FuKvGYHsIAroaSeYFK5xxQ0Xwb2q//EtXgF4/Ib3acTk/+BQHKzFP/0I5lvw8XnY7Xo00EAWE1CGDeP/HE+MFIKagc4svUlauMbsZ/qi2CUPNDUw/g7ElwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=NOPnnhj/; arc=fail smtp.client-ip=40.93.195.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="NOPnnhj/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ScWZm0vK0UHqaLJ8Sm0ykfKsJ9ustJxQHcAFV4wFi4rzTPCoTRR2zGIkqHmjVJHZDC4GLVwV/8i7maYfnufcjfGJl5OkNkyeLaqk/63MjA6KKc6rUhGaFxIRtAC+Ou5fviYsrNlIT2ETHLm9S5UKY6Uiq1HrVVDiSvSOaUe0UokQ3zn4yqGNIbVz2IeEzetDazGOECtNTHRQhyRtupz1pWvDJ2R4ippq3pqG5oHg9ppxg/Tx3NC1kBJLnOI7wgbF9xMZ2djaSNMSguQKY/PAQPbAIGzGN6UMta0W/eBGiEJgOmLW+glPS+ru8meKvCkjFI0wBQPzQ48FYl5SlZxTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ltcgk+GU16BCAvcHXOE2LpgjF2UCE7moQDqBm+nZkm8=;
 b=ZI5zCax08D8SgZwLDPoiEAuBNH4QjPwr1ChFF/s2TbkcTyXdRC2A0sFjdoZv++efhQTdkRCaRXjyyaOrhAB1nXKRlitRnOltaolqnpsKKU4YE8uqG1KNbF/QBuuztS6bE1xzQ2L/H+FYX+fuAOA6K4TDDtdQLrpxynqZ32XmhmXWOXhNXGgIDngQo/dTs1jkqN8hwDSPJINQb85Pc7q7x4QUVH2nqd7pIcVPK7D3qa/grcHZkkSiVnNRPUAqvdqfm96sbWC45ptuXHQ019xIIWD4fXnvqWiY+u+GOo+pgDDS+HcePfemifZjNvnSLS9Yi+Zu2VJvXNQ4xxi4G3KpfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltcgk+GU16BCAvcHXOE2LpgjF2UCE7moQDqBm+nZkm8=;
 b=NOPnnhj/pHWLh+cAuO5lXh/oXv3jOVmKkR+l/zxawACqFWTg0bPWtolr9f+HxG9gCVDgflIvobmoGgj03TnuxgPWLveo7MM3nsVpyVf+PejHA6OIMJXUPcaU0hQRO7WRaKpx2K0Vs9U0pgVjbLFuUC8a10BUoNpbxdra7w+WMfw=
Received: from DM6PR02CA0091.namprd02.prod.outlook.com (2603:10b6:5:1f4::32)
 by CY8PR10MB6681.namprd10.prod.outlook.com (2603:10b6:930:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 10:51:16 +0000
Received: from DS2PEPF000061C6.namprd02.prod.outlook.com
 (2603:10b6:5:1f4:cafe::3) by DM6PR02CA0091.outlook.office365.com
 (2603:10b6:5:1f4::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.20 via Frontend Transport; Fri,
 20 Mar 2026 10:51:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 DS2PEPF000061C6.mail.protection.outlook.com (10.167.23.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Fri, 20 Mar 2026 10:51:14 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:12 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 20 Mar 2026 05:51:11 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 62KApAp83695741;
	Fri, 20 Mar 2026 05:51:10 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v11 1/2] crypto: ti - Add support for AES-GCM in DTHEv2 driver
Date: Fri, 20 Mar 2026 16:20:51 +0530
Message-ID: <20260320105052.3931552-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320105052.3931552-1-t-pratham@ti.com>
References: <20260320105052.3931552-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C6:EE_|CY8PR10MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: b0170ec7-8002-412e-992e-08de866e9bb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AAg4mf9Q3wGYMG+stBDorN/VC+bJX7wcPJBPoZeWQqeQT6dCO+MV/6L5/f8MY+lClhR1Qh0AzhaEqDMCs0zNux20axA21f5JQ2lipqLQGT+HeWcXxLoU68n4yMA4qwKZHksg1NqwxeqofLFWJSPDN8IHLq1IfCeD+RSZPh8B1mge4GZrVcXZBgVCF0n+kL919NmlV3xRIKKsYuwIWy0FHM0NNWDG3C4nTMkfusOFiPKe9QE7yInFKXB773DgzW1+K09LRMSS2xiOdxvYsoI5y2kQfhBeg97fCGvDNmlIgitIAuxeY3ig8u7j92oST1sdc7HNx+4JDAtXf9gn52o2gNp+XSREDuLCsSI3DSzn4eJk+OtlGTFMEXfYxYU71fOIWxDrxiF++cWzSkYWdlPIB5jl1Ze6R0QNEVjXJIsBpSznh0lEI6BFvNn5V898a61daQHQ/tnNYomr26XPRvfhl5oxelIvuw2u7oFoJ72bNbR/dRqkqL+IRzBjbGLsXh3De/QXYRu/xgmEfTYcycB/g10otrEAkn35xxiAw2vU2IpzojAOH1Xnj0vyokwOsCg9IeFLBNUPky0hJ2xkp1dmCtnOccm4ibPJ25VV7xeJjspuikv277c018SR9yS0UjN1lnkqVV5d6E5zm8sn3oVNE1Ay7lSjGrzIvjvL/wmwiTZ1lDwtAtlDbmyHgwERJMen8I1o/5bvCXMlfgAnT84Pmkd+6EOJ60hg/+RVCCsZd3Q/F5M462SrDayNBtd/QOdjHW43AmBQy66C/2CHykCdIQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3jQZ4r5kNE3E4r/Ci5XxiKv8b/LoViTXsiAd9Gb4mpwi5CsJMbVeNrK0gZqLsoIHXMPJ+xXPbjg7psO9RFoajodn9rlgeooPlFtdxDZbQkIj7teT7IFXWOTDws6zb4nYRN+DVywLd0MD9XVutXJeq4hJ7d7RRqe5Xdtuj0IQje42mYJVzJctN7FqACuVC+V4ZI3HFU73K3Dp8KS5pZ4ZPvnGXO7C9YLgDQ2HUHyHdt+UiI+oQcG61qVGikX974+h8/FP98iqaW7T6gbYOy3NFcdWt03OID+IQwGO0/ypxoWXUfOzqBp0o27tqz2OBV5s7ZO9x68cOcsv1Gilv44USX1eW1ji/7VMn+9WXZhh3+S6/Qnp/p5zf+OI+OiHdTVOEVYRcyZbw7BQfE6atjUZULtGx1CTlquqA8NxE4HVwOx94eGtr/LIQgVX91ecMkj+
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 10:51:14.9194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0170ec7-8002-412e-992e-08de866e9bb8
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6681

AES-GCM is an AEAD algorithm supporting both encryption and
authentication of data. This patch introduces support for AES-GCM as the
first AEAD algorithm supported by the DTHEv2 driver.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   2 +
 drivers/crypto/ti/dthev2-aes.c    | 618 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.h |  11 +-
 3 files changed, 628 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 6027e12de279d..221e483737439 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -8,6 +8,8 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CBC
 	select CRYPTO_CTR
 	select CRYPTO_XTS
+	select CRYPTO_GCM
+	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
 	  which can be found on TI K3 SOCs. Selecting this enables use
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index bf7d4dcb4cd7d..5583386decbef 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -10,6 +10,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
+#include <crypto/gcm.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
 
@@ -19,6 +20,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/scatterlist.h>
 
 /* Registers */
@@ -53,6 +55,7 @@
 #define DTHE_P_AES_C_LENGTH_1	0x0058
 #define DTHE_P_AES_AUTH_LENGTH	0x005C
 #define DTHE_P_AES_DATA_IN_OUT	0x0060
+#define DTHE_P_AES_TAG_OUT	0x0070
 
 #define DTHE_P_AES_SYSCONFIG	0x0084
 #define DTHE_P_AES_IRQSTATUS	0x008C
@@ -65,6 +68,7 @@ enum aes_ctrl_mode_masks {
 	AES_CTRL_CBC_MASK = BIT(5),
 	AES_CTRL_CTR_MASK = BIT(6),
 	AES_CTRL_XTS_MASK = BIT(12) | BIT(11),
+	AES_CTRL_GCM_MASK = BIT(17) | BIT(16) | BIT(6),
 };
 
 #define DTHE_AES_CTRL_MODE_CLEAR_MASK		~GENMASK(28, 5)
@@ -91,6 +95,8 @@ enum aes_ctrl_mode_masks {
 #define AES_IV_SIZE				AES_BLOCK_SIZE
 #define AES_BLOCK_WORDS				(AES_BLOCK_SIZE / sizeof(u32))
 #define AES_IV_WORDS				AES_BLOCK_WORDS
+#define DTHE_AES_GCM_AAD_MAXLEN			(BIT_ULL(32) - 1)
+#define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
@@ -266,6 +272,9 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 	case DTHE_AES_XTS:
 		ctrl_val |= AES_CTRL_XTS_MASK;
 		break;
+	case DTHE_AES_GCM:
+		ctrl_val |= AES_CTRL_GCM_MASK;
+		break;
 	}
 
 	if (iv_in) {
@@ -542,6 +551,575 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 	return dthe_aes_crypt(req);
 }
 
+static int dthe_aead_init_tfm(struct crypto_aead *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	ctx->dev_data = dev_data;
+
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+
+	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
+					      CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->aead_fb)) {
+		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+			alg_name);
+		return PTR_ERR(ctx->aead_fb);
+	}
+
+	return 0;
+}
+
+static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_sync_aead(ctx->aead_fb);
+}
+
+/**
+ * dthe_aead_prep_aad - Prepare AAD scatterlist from input request
+ * @sg: Input scatterlist containing AAD
+ * @assoclen: Length of AAD
+ * @pad_buf: Buffer to hold AAD padding if needed
+ *
+ * Description:
+ *   Creates a scatterlist containing only the AAD portion with padding
+ *   to align to AES_BLOCK_SIZE. This simplifies DMA handling by allowing
+ *   AAD to be sent separately via TX-only DMA.
+ *
+ * Return:
+ *   Pointer to the AAD scatterlist, or ERR_PTR(error) on failure.
+ *   The calling function needs to free the returned scatterlist when done.
+ **/
+static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
+					      unsigned int assoclen,
+					      u8 *pad_buf)
+{
+	struct scatterlist *aad_sg;
+	struct scatterlist *to_sg;
+	int aad_nents;
+
+	if (assoclen == 0)
+		return NULL;
+
+	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (assoclen % AES_BLOCK_SIZE)
+		aad_nents++;
+
+	aad_sg = kmalloc_array(aad_nents, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!aad_sg)
+		return ERR_PTR(-ENOMEM);
+
+	sg_init_table(aad_sg, aad_nents);
+	to_sg = dthe_copy_sg(aad_sg, sg, assoclen);
+	if (assoclen % AES_BLOCK_SIZE) {
+		unsigned int pad_len = AES_BLOCK_SIZE - (assoclen % AES_BLOCK_SIZE);
+
+		memset(pad_buf, 0, pad_len);
+		sg_set_buf(to_sg, pad_buf, pad_len);
+	}
+
+	return aad_sg;
+}
+
+/**
+ * dthe_aead_prep_crypt - Prepare crypt scatterlist from req->src/req->dst
+ * @sg: Input req->src/req->dst scatterlist
+ * @assoclen: Length of AAD (to skip)
+ * @cryptlen: Length of ciphertext/plaintext (minus the size of TAG in decryption)
+ * @pad_buf: Zeroed buffer to hold crypt padding if needed
+ *
+ * Description:
+ *   Creates a scatterlist containing only the ciphertext/plaintext portion
+ *   (skipping AAD) with padding to align to AES_BLOCK_SIZE.
+ *
+ * Return:
+ *   Pointer to the ciphertext scatterlist, or ERR_PTR(error) on failure.
+ *   The calling function needs to free the returned scatterlist when done.
+ **/
+static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
+						unsigned int assoclen,
+						unsigned int cryptlen,
+						u8 *pad_buf)
+{
+	struct scatterlist *out_sg[1];
+	struct scatterlist *crypt_sg;
+	struct scatterlist *to_sg;
+	size_t split_sizes[1] = {cryptlen};
+	int out_mapped_nents[1];
+	int crypt_nents;
+	int err;
+
+	if (cryptlen == 0)
+		return NULL;
+
+	/* Skip AAD, extract ciphertext portion */
+	err = sg_split(sg, 0, assoclen, 1, split_sizes, out_sg, out_mapped_nents, GFP_ATOMIC);
+	if (err)
+		goto dthe_aead_prep_crypt_split_err;
+
+	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (cryptlen % AES_BLOCK_SIZE)
+		crypt_nents++;
+
+	crypt_sg = kmalloc_array(crypt_nents, sizeof(struct scatterlist), GFP_ATOMIC);
+	if (!crypt_sg) {
+		err = -ENOMEM;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
+
+	sg_init_table(crypt_sg, crypt_nents);
+	to_sg = dthe_copy_sg(crypt_sg, out_sg[0], cryptlen);
+	if (cryptlen % AES_BLOCK_SIZE) {
+		unsigned int pad_len = AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
+
+		sg_set_buf(to_sg, pad_buf, pad_len);
+	}
+
+dthe_aead_prep_crypt_mem_err:
+	kfree(out_sg[0]);
+
+dthe_aead_prep_crypt_split_err:
+	if (err)
+		return ERR_PTR(err);
+	return crypt_sg;
+}
+
+static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+{
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+	u32 val;
+	int ret;
+
+	ret = readl_relaxed_poll_timeout(aes_base_reg + DTHE_P_AES_CTRL, val,
+					 (val & DTHE_AES_CTRL_SAVED_CTX_READY),
+					 0, POLL_TIMEOUT_INTERVAL);
+	if (ret)
+		return ret;
+
+	for (int i = 0; i < AES_BLOCK_WORDS; ++i)
+		tag[i] = readl_relaxed(aes_base_reg +
+				       DTHE_P_AES_TAG_OUT +
+				       DTHE_REG_SIZE * i);
+	return 0;
+}
+
+static int dthe_aead_enc_get_tag(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	u32 tag[AES_BLOCK_WORDS];
+	int nents;
+	int ret;
+
+	ret = dthe_aead_read_tag(ctx, tag);
+	if (ret)
+		return ret;
+
+	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+
+	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
+			     req->assoclen + req->cryptlen);
+
+	return 0;
+}
+
+static int dthe_aead_dec_verify_tag(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	u32 tag_out[AES_BLOCK_WORDS];
+	u32 tag_in[AES_BLOCK_WORDS];
+	int nents;
+	int ret;
+
+	ret = dthe_aead_read_tag(ctx, tag_out);
+	if (ret)
+		return ret;
+
+	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+
+	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
+			   req->assoclen + req->cryptlen - ctx->authsize);
+
+	if (crypto_memneq(tag_in, tag_out, ctx->authsize))
+		return -EBADMSG;
+	else
+		return 0;
+}
+
+static int dthe_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
+	ctx->aes_mode = DTHE_AES_GCM;
+	ctx->keylen = keylen;
+	memcpy(ctx->key, key, keylen);
+
+	crypto_sync_aead_clear_flags(ctx->aead_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_aead_set_flags(ctx->aead_fb,
+				   crypto_aead_get_flags(tfm) &
+				   CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_aead_setkey(ctx->aead_fb, key, keylen);
+}
+
+static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+
+	/* Invalid auth size will be handled by crypto_aead_setauthsize() */
+	ctx->authsize = authsize;
+
+	return crypto_sync_aead_setauthsize(ctx->aead_fb, authsize);
+}
+
+static int dthe_aead_do_fallback(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
+
+	aead_request_set_callback(subreq, req->base.flags,
+				  req->base.complete, req->base.data);
+	aead_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req->iv);
+	aead_request_set_ad(subreq, req->assoclen);
+
+	return rctx->enc ? crypto_aead_encrypt(subreq) :
+		crypto_aead_decrypt(subreq);
+}
+
+static void dthe_aead_dma_in_callback(void *data)
+{
+	struct aead_request *req = (struct aead_request *)data;
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	complete(&rctx->aes_compl);
+}
+
+static int dthe_aead_run(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request, base);
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	unsigned int cryptlen = req->cryptlen;
+	unsigned int assoclen = req->assoclen;
+	unsigned int authsize = ctx->authsize;
+	unsigned int unpadded_cryptlen;
+	struct scatterlist *src = NULL;
+	struct scatterlist *dst = NULL;
+	struct scatterlist *aad_sg = NULL;
+	u32 iv_in[AES_IV_WORDS];
+
+	int aad_nents = 0;
+	int src_nents = 0;
+	int dst_nents = 0;
+	int aad_mapped_nents = 0;
+	int src_mapped_nents = 0;
+	int dst_mapped_nents = 0;
+
+	u8 *src_assoc_padbuf = rctx->padding;
+	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+
+	bool diff_dst;
+	enum dma_data_direction aad_dir, src_dir, dst_dir;
+
+	struct device *tx_dev, *rx_dev;
+	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+
+	int ret;
+	int err;
+
+	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
+
+	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
+	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
+	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
+
+	aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
+	writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
+
+	/* In decryption, the last authsize bytes are the TAG */
+	if (!rctx->enc)
+		cryptlen -= authsize;
+	unpadded_cryptlen = cryptlen;
+
+	memset(src_assoc_padbuf, 0, AES_BLOCK_SIZE);
+	memset(src_crypt_padbuf, 0, AES_BLOCK_SIZE);
+	memset(dst_crypt_padbuf, 0, AES_BLOCK_SIZE);
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
+	rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
+
+	if (req->src == req->dst) {
+		diff_dst = false;
+		src_dir = DMA_BIDIRECTIONAL;
+		dst_dir = DMA_BIDIRECTIONAL;
+	} else {
+		diff_dst = true;
+		src_dir = DMA_TO_DEVICE;
+		dst_dir = DMA_FROM_DEVICE;
+	}
+	aad_dir = DMA_TO_DEVICE;
+
+	/* Prep AAD scatterlist (always from req->src) */
+	aad_sg = dthe_aead_prep_aad(req->src, req->assoclen, src_assoc_padbuf);
+	if (IS_ERR(aad_sg)) {
+		ret = PTR_ERR(aad_sg);
+		goto aead_prep_aad_err;
+	}
+
+	/* Prep ciphertext src scatterlist */
+	src = dthe_aead_prep_crypt(req->src, req->assoclen, cryptlen, src_crypt_padbuf);
+	if (IS_ERR(src)) {
+		ret = PTR_ERR(src);
+		goto aead_prep_src_err;
+	}
+
+	/* Prep ciphertext dst scatterlist (only if separate dst) */
+	if (diff_dst) {
+		dst = dthe_aead_prep_crypt(req->dst, req->assoclen, unpadded_cryptlen,
+					   dst_crypt_padbuf);
+		if (IS_ERR(dst)) {
+			ret = PTR_ERR(dst);
+			goto aead_prep_dst_err;
+		}
+	} else {
+		dst = src;
+	}
+
+	/* Calculate padded lengths for nents calculations */
+	if (req->assoclen % AES_BLOCK_SIZE)
+		assoclen += AES_BLOCK_SIZE - (req->assoclen % AES_BLOCK_SIZE);
+	if (cryptlen % AES_BLOCK_SIZE)
+		cryptlen += AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
+
+	if (assoclen != 0) {
+		/* Map AAD for TX only */
+		aad_nents = sg_nents_for_len(aad_sg, assoclen);
+		aad_mapped_nents = dma_map_sg(tx_dev, aad_sg, aad_nents, aad_dir);
+		if (aad_mapped_nents == 0) {
+			dev_err(dev_data->dev, "Failed to map AAD for TX\n");
+			ret = -EINVAL;
+			goto aead_dma_map_aad_err;
+		}
+
+		/* Prepare DMA descriptors for AAD TX */
+		desc_aad_out = dmaengine_prep_slave_sg(dev_data->dma_aes_tx, aad_sg,
+						       aad_mapped_nents, DMA_MEM_TO_DEV,
+						       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_aad_out) {
+			dev_err(dev_data->dev, "AAD TX prep_slave_sg() failed\n");
+			ret = -EINVAL;
+			goto aead_dma_prep_aad_err;
+		}
+	}
+
+	if (cryptlen != 0) {
+		/* Map ciphertext src for TX (BIDIRECTIONAL if in-place) */
+		src_nents = sg_nents_for_len(src, cryptlen);
+		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+		if (src_mapped_nents == 0) {
+			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
+			ret = -EINVAL;
+			goto aead_dma_prep_aad_err;
+		}
+
+		/* Prepare DMA descriptors for ciphertext TX */
+		desc_out = dmaengine_prep_slave_sg(dev_data->dma_aes_tx, src,
+						   src_mapped_nents, DMA_MEM_TO_DEV,
+						   DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_out) {
+			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
+			ret = -EINVAL;
+			goto aead_dma_prep_src_err;
+		}
+
+		/* Map ciphertext dst for RX (only if separate dst) */
+		if (diff_dst) {
+			dst_nents = sg_nents_for_len(dst, cryptlen);
+			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
+			if (dst_mapped_nents == 0) {
+				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
+				ret = -EINVAL;
+				goto aead_dma_prep_src_err;
+			}
+		} else {
+			dst_nents = src_nents;
+			dst_mapped_nents = src_mapped_nents;
+		}
+
+		/* Prepare DMA descriptor for ciphertext RX */
+		desc_in = dmaengine_prep_slave_sg(dev_data->dma_aes_rx, dst,
+						  dst_mapped_nents, DMA_DEV_TO_MEM,
+						  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_in) {
+			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
+			ret = -EINVAL;
+			goto aead_dma_prep_dst_err;
+		}
+
+		desc_in->callback = dthe_aead_dma_in_callback;
+		desc_in->callback_param = req;
+	} else if (assoclen != 0) {
+		/* AAD-only operation */
+		desc_aad_out->callback = dthe_aead_dma_in_callback;
+		desc_aad_out->callback_param = req;
+	}
+
+	init_completion(&rctx->aes_compl);
+
+	/*
+	 * HACK: There is an unknown hw issue where if the previous operation had alen = 0 and
+	 * plen != 0, the current operation's tag calculation is incorrect in the case where
+	 * plen = 0 and alen != 0 currently. This is a workaround for now which somehow works;
+	 * by resetting the context by writing a 1 to the C_LENGTH_0 and AUTH_LENGTH registers.
+	 */
+	if (cryptlen == 0) {
+		writel_relaxed(1, aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+		writel_relaxed(1, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
+	}
+
+	if (req->iv) {
+		memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
+	} else {
+		iv_in[0] = 0;
+		iv_in[1] = 0;
+		iv_in[2] = 0;
+	}
+	iv_in[3] = 0x01000000;
+
+	/* Clear key2 to reset previous GHASH intermediate data */
+	for (int i = 0; i < AES_KEYSIZE_256 / sizeof(u32); ++i)
+		writel_relaxed(0, aes_base_reg + DTHE_P_AES_KEY2_6 + DTHE_REG_SIZE * i);
+
+	dthe_aes_set_ctrl_key(ctx, rctx, iv_in);
+
+	writel_relaxed(lower_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
+	writel_relaxed(upper_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
+	writel_relaxed(req->assoclen, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
+
+	/* Submit DMA descriptors: AAD TX, ciphertext TX, ciphertext RX */
+	if (assoclen != 0)
+		dmaengine_submit(desc_aad_out);
+	if (cryptlen != 0) {
+		dmaengine_submit(desc_out);
+		dmaengine_submit(desc_in);
+	}
+
+	if (cryptlen != 0)
+		dma_async_issue_pending(dev_data->dma_aes_rx);
+	dma_async_issue_pending(dev_data->dma_aes_tx);
+
+	/* Need to do timeout to ensure finalise gets called if DMA callback fails for any reason */
+	ret = wait_for_completion_timeout(&rctx->aes_compl, msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
+	if (!ret) {
+		ret = -ETIMEDOUT;
+		if (cryptlen != 0)
+			dmaengine_terminate_sync(dev_data->dma_aes_rx);
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
+
+		for (int i = 0; i < AES_BLOCK_WORDS; ++i)
+			readl_relaxed(aes_base_reg + DTHE_P_AES_DATA_IN_OUT + DTHE_REG_SIZE * i);
+	} else {
+		ret = 0;
+	}
+
+	if (cryptlen != 0)
+		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
+
+	if (rctx->enc)
+		err = dthe_aead_enc_get_tag(req);
+	else
+		err = dthe_aead_dec_verify_tag(req);
+
+	ret = (ret) ? ret : err;
+
+aead_dma_prep_dst_err:
+	if (diff_dst && cryptlen != 0)
+		dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
+aead_dma_prep_src_err:
+	if (cryptlen != 0)
+		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_prep_aad_err:
+	if (assoclen != 0)
+		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
+
+aead_dma_map_aad_err:
+	if (diff_dst && cryptlen != 0)
+		kfree(dst);
+aead_prep_dst_err:
+	if (cryptlen != 0)
+		kfree(src);
+aead_prep_src_err:
+	if (assoclen != 0)
+		kfree(aad_sg);
+
+aead_prep_aad_err:
+	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+
+	if (ret)
+		ret = dthe_aead_do_fallback(req);
+
+	local_bh_disable();
+	crypto_finalize_aead_request(engine, req, ret);
+	local_bh_enable();
+	return 0;
+}
+
+static int dthe_aead_crypt(struct aead_request *req)
+{
+	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine;
+	unsigned int cryptlen = req->cryptlen;
+
+	/* In decryption, last authsize bytes are the TAG */
+	if (!rctx->enc)
+		cryptlen -= ctx->authsize;
+
+	/*
+	 * Need to fallback to software in the following cases due to HW restrictions:
+	 * - Both AAD and plaintext/ciphertext are zero length
+	 * - AAD length is more than 2^32 - 1 bytes
+	 * PS: req->cryptlen is currently unsigned int type, which causes the above condition
+	 * tautologically false. If req->cryptlen were to be changed to a 64-bit type,
+	 * the check for this would need to be added below.
+	 */
+	if (req->assoclen == 0 && cryptlen == 0)
+		return dthe_aead_do_fallback(req);
+
+	engine = dev_data->engine;
+	return crypto_transfer_aead_request_to_engine(engine, req);
+}
+
+static int dthe_aead_encrypt(struct aead_request *req)
+{
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	rctx->enc = 1;
+	return dthe_aead_crypt(req);
+}
+
+static int dthe_aead_decrypt(struct aead_request *req)
+{
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+
+	rctx->enc = 0;
+	return dthe_aead_crypt(req);
+}
+
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
@@ -640,12 +1218,50 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* XTS AES */
 };
 
+static struct aead_engine_alg aead_algs[] = {
+	{
+		.base.init			= dthe_aead_init_tfm,
+		.base.exit			= dthe_aead_exit_tfm,
+		.base.setkey			= dthe_aead_setkey,
+		.base.setauthsize		= dthe_aead_setauthsize,
+		.base.maxauthsize		= AES_BLOCK_SIZE,
+		.base.encrypt			= dthe_aead_encrypt,
+		.base.decrypt			= dthe_aead_decrypt,
+		.base.chunksize			= AES_BLOCK_SIZE,
+		.base.ivsize			= GCM_AES_IV_SIZE,
+		.base.base = {
+			.cra_name		= "gcm(aes)",
+			.cra_driver_name	= "gcm-aes-dthev2",
+			.cra_priority		= 299,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= 1,
+			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_module		= THIS_MODULE,
+		},
+		.op.do_one_request = dthe_aead_run,
+	}, /* GCM AES */
+};
+
 int dthe_register_aes_algs(void)
 {
-	return crypto_engine_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	int ret = 0;
+
+	ret = crypto_engine_register_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	if (ret)
+		return ret;
+	ret = crypto_engine_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+	if (ret)
+		crypto_engine_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+
+	return ret;
 }
 
 void dthe_unregister_aes_algs(void)
 {
 	crypto_engine_unregister_skciphers(cipher_algs, ARRAY_SIZE(cipher_algs));
+	crypto_engine_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 }
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 5239ee93c9442..8514f0df8ac3d 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -38,6 +38,7 @@ enum dthe_aes_mode {
 	DTHE_AES_CBC,
 	DTHE_AES_CTR,
 	DTHE_AES_XTS,
+	DTHE_AES_GCM,
 };
 
 /* Driver specific struct definitions */
@@ -78,16 +79,22 @@ struct dthe_list {
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev_data: Device data struct pointer
  * @keylen: AES key length
+ * @authsize: Authentication size for modes with authentication
  * @key: AES key
  * @aes_mode: AES mode
+ * @aead_fb: Fallback crypto aead handle
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
 	struct dthe_data *dev_data;
 	unsigned int keylen;
+	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
 	enum dthe_aes_mode aes_mode;
-	struct crypto_sync_skcipher *skcipher_fb;
+	union {
+		struct crypto_sync_aead *aead_fb;
+		struct crypto_sync_skcipher *skcipher_fb;
+	};
 };
 
 /**
@@ -98,7 +105,7 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	u8 padding[AES_BLOCK_SIZE];
+	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
 };
 
-- 
2.34.1

