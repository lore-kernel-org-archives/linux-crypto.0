Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28EB4C10F1;
	Mon,  5 Oct 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217038; cv=fail; b=uHX0dYY9OXMknJjvUzZpkpUEns1SIs5yhdoSDBBFivbmp7yNkqD3+O0WljZcH+BPKXn1xszKJwb89ksAUlhRyhQ0udaA5A3UtPpjQGxlYq2Hv8KNWUYVooHjFCwrUfQVhXgemV3lyR7co2dVtgt+oi3CkV/PeaQumTAOyezRacg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217038; c=relaxed/simple;
	bh=z0TpWuB6dQ6Q6QSrGedNHGUaUaa+8/RN/fVQ++C5bc8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JpJSb2rE5pLPwaHRws6EA4sg9CzOWgt5YMUUI4P5KqZAgmO9Oao0nPyyVe9eBPoqiVl6qUBB3jwPx3Q6EBzuluOHSwzxJmkRNTAY8hq35hJf8WVdgxMdPzjKQBdLuQPaEXbCmql+NKmLhVjPmeZXMhUfjMp1h8hLHYSsdUo2B6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LtIWuzAJ; arc=fail smtp.client-ip=52.101.52.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LtIWuzAJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AiWQWaV2ag4d6pxnAKN9+3WT7zMoEtzAIy9UnrG/iNZXvu3976dPN5ujwlH/+ci7iBmrtmPrehe7gFWWfR5txgjPj4KrJvkCEGsIpbPLXc2ugzEMyKEC3HBwCaBxKpZaBJ4s98iGOtJSXAMzzhkFago6sG/Zb03acXtkROs0NcPuIsyxXnVmoXFnAdESDzv4JN9fHILtPZXZu6uDXVmS0xMo5/XTu+xHEfjVqjmEn6oqu1kSONGhNFG40Wd0LH5uHDlFDM5HE8KpZsuv/RisCbjXKz/ugu0DwtNzQ88tuGlhbeNytzxuterYuz/w4TXGBbeyAuTjsTR3vUBQtoKewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+lA+yz70ZUa25egURUUltLJ2RVo4+cyIQtYQ6NU+p8=;
 b=WkA3wewzJ2GYd/hGHWuAeHyKoUXdUPcxrM/NBJekJNKU86SgurCwjGSlDaZH+428A/jCK5Cya7Sty0p43vMTBlwY+ekAkxQWL2fghxpTuF/CtQczQXb7AgKIavtv9/ghYvA7sv2/OrwROb6F7Xkwd7uDa+rPBW9i5WyLVSRTLH+KwTWtMilAqsmgGA/n/WOy4VSOcAj6/l9OGYkZMyGZR7LVcSNNMUwbeIvioawwXmdh7ys+Vbo7++mTPtrCvmU5rRnguYSifoq77vYyyBQFn92uK08E3Va9So4c6cQvzY4EcpSbCQtARDCMK4TdHAOG1h9KFj3L6+bidmxhTIQj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+lA+yz70ZUa25egURUUltLJ2RVo4+cyIQtYQ6NU+p8=;
 b=LtIWuzAJaOZpPI0V3nu03/VrzzzzITorri2vEoB9QdEw73utKgHB3pLbyt95C35nu0NX9/uQRhc8IznoRLzUExU3VqZOcxLgTBGhj/NXlrx/gvoo+hE609ER0o9R1MXuDRb+eCdTbjvTrn2BvZ6jqC43mesCGNenMj83GD7k3u8=
Received: from BLAPR03CA0024.namprd03.prod.outlook.com (2603:10b6:208:32b::29)
 by IA0PPFFEC453979.namprd12.prod.outlook.com (2603:10b6:20f:fc04::beb) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 16:17:09 +0000
Received: from BN2PEPF00004FBA.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::95) by BLAPR03CA0024.outlook.office365.com
 (2603:10b6:208:32b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:17:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBA.mail.protection.outlook.com (10.167.243.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 16:17:09 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:17:07 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 6/7] crypto/ccp: Register with fw_uploader and always fail
Date: Mon, 5 Oct 2026 16:15:40 +0000
Message-ID: <35ce536c154380a2f8f3af9b2b50069ce16804d0.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBA:EE_|IA0PPFFEC453979:EE_
X-MS-Office365-Filtering-Correlation-Id: bd64426c-9651-4173-ce8a-08df22fc1b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|23010399003|36860700016|22082099003|18002099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	nx3jf2hYETWwlkdFyEvSKQQ8/WA3eYoibdLKFijAoyesNiv4+eWchzm5eUpCzthP8JYkjwEq3ki9agSuUf9BaNlPXaxxlEm6NFXjS+7WWx9Ea+0Q/DUMDABAn0yZV63Gw+X8vsESsdBT5XxCQwWbmLQ4S9sMbGtiipDOeErbLykd+8K0hlN+hbF+i8JN0RD5vtTqYel7OuPN1coYcXLjohrz9TpdKm/kHiQ7Fy4NZRFEfKJuyTiYiKWU/tSD1ArNmbBuUBJuJl9Vb7Q4ohLdKrAvCuLxQeiU/pRKaxoOjX2pPpzo0Jq/8zsDBDYLOYm+wV1PLVr7lLPGjMHFQgN1XLpCgC+5z8KyjtSVcKnHv1ucAVrsxroowHdBV2YWSTVUBRWMSWE3IOkCdgqCN+DSgyVFn/CKabgC7x1ctzcxfrXPscg84QEtLB3r8JTOUeppgRWeqFuMb2FwmCWDxvTxXbrq/EPWQFIKwKe0Eir3SbOx7ML6supKePI+uY81Kj7AdzOB8MiMvJiz/uTgrzDzyLk42Y+0TFsy/95PT1MkEIC2UC+jVmMp4VP7N8lo2EP/GeNMDhcvrqLsi/0N9PfI+lMuJ9UEXDvHu5dcrss7EML1YnWKdJQbm9NKdHEsrkmUiLZCbx3WpMs55a+55YUterSqqdK/UYK1Fsic5vF71C9FxMkmQac6NLFw1QjCliWrl3K8usZgPfOqlk+fghf3NQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(23010399003)(36860700016)(22082099003)(18002099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6tuG6WX27YfZpGiqKslEBPCZ4ZCbRH+msasfNQzxCkLkSAsnSS18wWD6tLAWEzL7ApA0r3uQdjJ0CBr4NpbboSCOJswAJiXjg3CLkPyIsec3u6tOYD/KTFPuaM0t0xPQNKmm1umd31mSQwtl1xt8PLP9MWijAupSbS7EgBLu9ytBSHSdcCa1YpDkzy0qWIel9L5urfmLiRfljcX6o/cp0TdyoLZuJH5mQhEG+th8tuHlxGzWwtzzRF+UO1E5gYsjBbDt4KlqC/ssLulmdL3ya/c1qEJ67ET5aAfLooZt2DW007Ciy6HGeSb9rlvufPT6/pXUBCMESrpl5zWvWdvwnxrQH4/3wqDdfIACJlVlei9zrYT7u+I+Hxd+je5bLJ1/XvAcxO1pnHOkw4KFrEEPyqxrJJAsjI8zzYto4RxNxhdpHYuVl4vIqTPbVSFS/VgD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:17:09.5110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd64426c-9651-4173-ce8a-08df22fc1b54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFFEC453979

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 80 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  2 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c40401c861d3..88cf60a9640e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2212,6 +2212,80 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+#ifdef CONFIG_FW_UPLOAD
+static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
+						const u8 *data, u32 size)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
+					      const u8 *data, u32 offset,
+					      u32 size, u32 *written)
+{
+	return FW_UPLOAD_ERR_BUSY;
+}
+
+static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static void sev_fw_upload_cancel(struct fw_upload *fw_upload)
+{
+	/* intentional no-op */
+}
+
+static const struct fw_upload_ops sev_fw_upload_ops = {
+	.prepare = sev_fw_upload_prepare,
+	.write = sev_fw_upload_write,
+	.poll_complete = sev_fw_upload_poll_complete,
+	.cancel = sev_fw_upload_cancel,
+};
+
+/* Serializes registration and unregistration of sev->fwl */
+static DEFINE_MUTEX(sev_fwl_lock);
+
+static void register_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl;
+
+	guard(mutex)(&sev_fwl_lock);
+
+	/*
+	 * The interface only drives DOWNLOAD_FIRMWARE_EX, which is an SNP
+	 * command, so do not advertise it where SNP is unavailable or the
+	 * interface already exists.
+	 */
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) || sev->fwl)
+		return;
+
+	fwl = firmware_upload_register(sev->dev, "sev", &sev_fw_upload_ops,
+				       sev);
+	if (IS_ERR(fwl)) {
+		dev_err(sev->dev, "SEV firmware upload registration failure: %ld\n",
+			PTR_ERR(fwl));
+		return;
+	}
+
+	sev->fwl = fwl;
+}
+
+static void unregister_sev_fw_uploader(struct sev_device *sev)
+{
+	guard(mutex)(&sev_fwl_lock);
+
+	if (!sev->fwl)
+		return;
+
+	firmware_upload_unregister(sev->fwl);
+	sev->fwl = NULL;
+}
+#else	/* CONFIG_FW_UPLOAD */
+static void register_sev_fw_uploader(struct sev_device *sev) { }
+static void unregister_sev_fw_uploader(struct sev_device *sev) { }
+#endif	/* CONFIG_FW_UPLOAD */
+
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct psp_device *psp = psp_master;
@@ -3018,6 +3092,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 
 	if (sev->misc)
@@ -3081,6 +3157,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
+
 	return;
 
 err:
@@ -3096,6 +3174,8 @@ void sev_pci_exit(void)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index d5e596606def..7ec692e2147e 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -69,6 +69,8 @@ struct sev_device {
 
 	struct tsm_dev *tsmdev;
 	struct sev_tio_status *tio_status;
+
+	struct fw_upload *fwl;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.43.0

