Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013057.outbound.protection.outlook.com [40.93.196.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BCB3AB29E;
	Mon,  8 Jun 2026 20:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780952301; cv=fail; b=ib1Jl9u2iaxUq+ix+uAONWiiGjw3Zia41HelAYqvF/TIoMo8jibKRczqvLyQhJj9nHkEk04c/qKgP/s3PmR09TxMJzeRqZg5by/m8BsvSlJXGuSJrLCIt5sU826icDjKk2BzJz4vEJ9xhXm3+QwzMN1Y4/aeRORD+2c82Kgqi0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780952301; c=relaxed/simple;
	bh=AtxMmn+Vn/gv7J7TjfOxG4/2gGoGmmTEKYDaYLDb7Qk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aV5FOu/IvF+T6RPhvh5hDlH91DoKL5JmUdpC++X953HtS/6O3xcfRQnpJgIGerGv7kjKKLMzsmMoZpK1IDq4aKm1LW2JZ5jEW5YHcXMgVbCQH86jcLVvxU5EGkwyA5yypd6T5HsEmGECtS3hrrx5M8InU5bih1pRKV16HvDLLdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yUpzDSzh; arc=fail smtp.client-ip=40.93.196.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yUpzDSzh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dpiC4W6FrmvRpBtfH2XuOxgJgBO2i2LP42GaNonaSHY7zeERnNucPzq72gLjo3SfqzVcT5EoBTmV+Wh/F4fsVQzL394mHwmRJCTBVZwIr9V2El4ipJe2O2Hl/WBrsOC+PXbBtq3eqmF2WNONfJ2kZcHwFQ+e3VmSpkTxJanpTXXPt7WgFRR2Uj7XqoHiKk/S+n8s11ASMowY7JCcQKYH2KxXDZB34vNWHPwOY8151XlW8/eeTK9nuVoDt2QCY4BP0pnI1xIEuX8yEjxzMrFw4a2Gixq60oqMRcgJpJtIM5e1bUmC58NTGVBiRM+Z3tbxCWxvXwK4Wecad/daa/VA+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcHBIk9RROanhDcBMgRcHDAxAOZF5qRyrSta4xwB4sU=;
 b=HBuihZXTLTMp02hb4ct+EuUJFwWrK7zWDqZ8CqunR8mz1trs9eiVU2oD09xJq8HFCTHjTQtjFmfLQoO4tG5UpKfXM8dNmBGfMSBR5Im3YhvJBewJ61MD9biki5PI6qAEX6urAdBy/UzJHDp60KwLFdtjBXagvCEKipIlBqr8QwolM0vpg7JPSN7Su2iK4sHvRX+sQJorjlg7wYoxXV4sWZYaIe1JTR4nkACQh7exfNpZUrpyVIBPsCWAKKONeuyV1z0N0O049+ADMs+Pgaubse4xbaF1qEx8vfiiV9VXfIyg1J7ROVcKfPAy9JBjg5ciegxE3WSIFfbkY2+cRMSPag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcHBIk9RROanhDcBMgRcHDAxAOZF5qRyrSta4xwB4sU=;
 b=yUpzDSzhfqwL4DvUTeX5VIqXMR5WWo9J1XA2mWs3v+WE6hRGSlmzJctTi2a2QsMzj2n6+uKRIqfO6vfPf+ismBDudDTk/zUoMJjGhi/LzOwEW7qRMtGCRInpu1z4QeNuFe6LKoizgtIy0EOYYBGJzDt1mmo+nwVnvJWnbe0YWBE=
Received: from BN9PR03CA0401.namprd03.prod.outlook.com (2603:10b6:408:111::16)
 by DM4PR12MB6304.namprd12.prod.outlook.com (2603:10b6:8:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.13; Mon, 8 Jun 2026 20:58:12 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:408:111:cafe::b) by BN9PR03CA0401.outlook.office365.com
 (2603:10b6:408:111::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 20:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 20:58:08 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 15:58:07 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <ashish.kalra@amd.com>, <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<prsampat@amd.com>
Subject: [PATCH v4] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Date: Mon, 8 Jun 2026 20:58:01 +0000
Message-ID: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|DM4PR12MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: 5428c0c8-85c1-43fa-000e-08dec5a0a4cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|13003099007|6133799003|3023799007|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	MuVygxzg5H0vt9X/dr53UxcGU0/WYgPHIbjXSU4US6P13KkEr1sWS5LGG6SdhQPWUv/RBJPYBX90NGsADIvv6ZK9Fy32yJM6dswnZUUD+lnEbU+FvBElLBQt2EMynOz6pIianWzOH5YkzIZkDZVgfLxC+WsueOPLZ+ir+1MCjD36sspLWjjejkkqPCTe+K/2yVWyV+2mUd9lf3KWYgv9/2VYb3t8G0d1Wi/7u5KxlHUhk6zsmk4iylGufsvh5jPXy4i1ZeHegiPrJluBvVUJBHRmI2eHdHKtH6q8CSUSV6nqrqGAInyIdo7GZH77KddDt0vOLGr0IHDvsvcstsKviMHMpkIvtenqnam+fCWaN0ttqisbIoim6iLXqLWj8WFl9IOBV/sz21Ieg4Had2ra7afVadlUYq0JvQBi0YoPlDklza9ygjx1K3a2HcVipp42zxPl8uEqLqGFoKqY9x9qhib2b9qWFA2IBS/GkxJUl1okzGoN0qdwiFqO4TwJmzqI8ULJQhS7Z1FlLWlNm+aPyfneQjOdGb9HiIr7XSnyib5xZ8ZP4m5ETSB8JDePH9uj+i6LJFpMKHCJiiiTr5U0EBddCVkVhuB23QiggNbGAOSOpbei/m3O9qQldF+2DmuaKb7xn8YZeIsuWUlmvWwEEe6fujnXj1A+rQsWQmIziHVLb4U62hZyLL0W8exGRJ4eqJScwrbVR5c7XRUUw+O5zZnr9qZsCeyBRiU016ZwWm8=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(13003099007)(6133799003)(3023799007)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	or16s2LMbCcv8wqJt8MPtJAIqiLZaU6bVKX8BuMnb0BsqjCb5Aq5aQIp7tAka3JkXIE39fL/eKIGU0I693xK21Rn6omm6gTnFhrAq+OhsBV4AnhitZvrV6AnF4Dd93JSIGUXsk1yHZimfJMCOQcAO17UAwALXq/zVP7ulJDnzcDF2GBw6h9B2SQLeIX9plSf+ALkHS3ZZELmxXxYmiLclPTgFDDf2ya4iGlGNrt2mFYGhGZJGvGkAu5803B7P2P5WyS8o1SvH4gl+o8rmnF8JZONGTPJTWdlbTcET7XkayC/GMxaBFhChwzFZZSt1qzH0mbAAksh/SOzHIiTRcYRX8UPzo1dJqVb5fq0MkQcJ1FrhXXSOepyb8GHxLJ38tTpibiAj/5FtUOYJZp2NhXmn+DQgChcdP0fjz9wosc95bYz3q0VRRDK+ZKipExv5jSt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 20:58:08.2950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5428c0c8-85c1-43fa-000e-08dec5a0a4cb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6304

The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
can be used to query the status of currently supported vulnerability
mitigations and to initiate mitigations within the firmware.

This command is an explicit mechanism to ascertain if a firmware
mitigation is applied without needing a full RMP re-build, which is most
useful in a live firmware update scenario.

The firmware supports two subcommands: STATUS and VERIFY. The STATUS
subcommand is used to query the supported and verified mitigation bits.
The VERIFY subcommand initiates the mitigation process within the FW for
the specified vulnerability. Expose a userspace interface under:
/sys/firmware/sev/vulnerabilities/
  - supported_mitigations (read-only): supported mitigation vector mask
  - verified_mitigations (read/write): current verified mask; write a
    vector to request VERIFY for that bit

The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
it are bug-specific. Information about supported mitigations and its
corresponding vector is to be published as part of the AMD Security
Bulletin.

See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
more details.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v4:
 * Split interface definitions in documentation - Kernel Test Bot
 * Wrap snp_verify_mitigation() under #ifdef CONFIG_SYSFS - Tom
 * Remove check for snp initialized and feature info active for
   registering mitigigation interface - Tom
 * Since init vs init races should not be possible anymore[1], remove the
   sysfs mutex guard as sysfs' own synchornization suffices - Tom, Tycho
 * Dropping the reviewed-by since the patch has changed in a meaningful
   way

v3: https://lore.kernel.org/linux-crypto/a043a82c-f3dd-4f29-86fb-60638eaddc9b@amd.com/
  * Remove failed_status interface and report failure via dev_err - Tycho
  * Make vulnerability interfaces root only accessible - Sashiko
  * Move /sys/firmware/vulnerabilities/ to
    /sys/firmware/sev/vulnerabilities/ to be platform specific - Sashiko
  * Guard sysfs creation under a new mutex to avoid racing during
    creation and using the sev_cmd_mutex which would race with
    vulnerability operations - Sashiko

v2: https://lore.kernel.org/linux-crypto/20260501152051.17469-1-prsampat@amd.com/
  * Intrdouce /sys/firmware/vulnerabilities sysfs interface instead of
    an ioctl interface - Boris
  * Reword commit message to focus on need for a userspace interface - Sean
  * Since download_firmware_ex is the primary usecase of this feature,
    posting this patch in parallel to those discussions[2].
RFC: https://lore.kernel.org/linux-crypto/20250630202319.56331-1-prsampat@amd.com/

[1]: https://lore.kernel.org/all/20260504165147.1615643-5-tycho@kernel.org/
[2]: https://lore.kernel.org/linux-crypto/20260430160716.1120553-1-tycho@kernel.org/

Patch based on cryptodev-2.6
---
 .../sysfs-firmware-sev-vulnerabilities        |  19 ++
 drivers/crypto/ccp/sev-dev.c                  | 171 ++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h                  |   3 +
 include/linux/psp-sev.h                       |  51 ++++++
 4 files changed, 244 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities

diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
new file mode 100644
index 000000000000..964362558bb2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
@@ -0,0 +1,19 @@
+What:		/sys/firmware/sev/vulnerabilities/supported_mitigations
+Date:		June 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:
+		Read-only interface that reports the vector of SEV-SNP
+		firmware vulnerability mitigations supported by the firmware.
+
+What:		/sys/firmware/sev/vulnerabilities/verified_mitigations
+Date:		June 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:
+		Read/write interface that reports the vector of SEV-SNP
+		firmware vulnerability mitigations already verified by the
+		firmware. Writing a vector value requests the firmware to
+		VERIFY the corresponding mitigation bit(s).
+
+		The list of supported mitigations and the meaning of each
+		vector bit are both platform- and bug-specific and are
+		published as part of the AMD Security Bulletin.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 068b901034cb..251cc7540f51 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -245,6 +245,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
 	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
 	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
 	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
@@ -1352,6 +1353,156 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+#ifdef CONFIG_SYSFS
+static int snp_verify_mitigation(u16 command, u64 vector,
+				 struct sev_data_snp_verify_mitigation_dst *dst)
+{
+	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
+	struct sev_data_snp_verify_mitigation data = {0};
+	struct sev_device *sev = psp_master->sev_data;
+	int ret, error = 0;
+
+	mit_dst = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
+	if (!mit_dst)
+		return -ENOMEM;
+
+	data.length = sizeof(data);
+	data.subcommand = command;
+	data.vector = vector;
+	data.dst_paddr = __psp_pa(mit_dst);
+	data.dst_paddr_en = true;
+
+	ret = sev_do_cmd(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &error);
+	if (!ret)
+		memcpy(dst, mit_dst, sizeof(*mit_dst));
+	else
+		dev_err(sev->dev, "SNP_VERIFY_MITIGATION command failed, ret = %d, error = %#x\n",
+			ret, error);
+
+	snp_free_firmware_page(mit_dst);
+
+	return ret;
+}
+
+static ssize_t supported_mitigations_show(struct kobject *kobj,
+					  struct kobj_attribute *attr, char *buf)
+{
+	struct sev_data_snp_verify_mitigation_dst dst;
+	int ret;
+
+	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%llx\n", dst.mit_supported_vector);
+}
+
+static struct kobj_attribute supported_attr =
+		__ATTR_RO_MODE(supported_mitigations, 0400);
+
+static ssize_t verified_mitigations_show(struct kobject *kobj,
+					 struct kobj_attribute *attr, char *buf)
+{
+	struct sev_data_snp_verify_mitigation_dst dst;
+	int ret;
+
+	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%llx\n", dst.mit_verified_vector);
+}
+
+static ssize_t verified_mitigations_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct sev_data_snp_verify_mitigation_dst dst;
+	struct sev_device *sev = psp_master->sev_data;
+	u64 vector;
+	int ret;
+
+	ret = kstrtoull(buf, 0, &vector);
+	if (ret)
+		return ret;
+
+	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_VERIFY, vector, &dst);
+	if (ret)
+		return ret;
+
+	if (dst.mit_failure_status) {
+		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
+			dst.mit_failure_status);
+		return -EIO;
+	}
+
+	return count;
+}
+
+static struct kobj_attribute verified_attr =
+		__ATTR_RW_MODE(verified_mitigations, 0600);
+
+static struct attribute *mitigation_attrs[] = {
+	&supported_attr.attr,
+	&verified_attr.attr,
+	NULL
+};
+
+static const struct attribute_group mit_attr_group = {
+	.attrs = mitigation_attrs,
+};
+
+static void sev_snp_register_verify_mitigation(struct sev_device *sev)
+{
+	int rc;
+
+	if (!(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED) ||
+	    sev->verify_mit)
+		return;
+
+	if (!sev->sev_kobj) {
+		sev->sev_kobj = kobject_create_and_add("sev", firmware_kobj);
+		if (!sev->sev_kobj)
+			return;
+	}
+
+	sev->verify_mit = kobject_create_and_add("vulnerabilities", sev->sev_kobj);
+	if (!sev->verify_mit)
+		goto err_sev_kobj;
+
+	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
+	if (rc)
+		goto err_verify_mit;
+
+	return;
+
+err_verify_mit:
+	kobject_put(sev->verify_mit);
+	sev->verify_mit = NULL;
+err_sev_kobj:
+	kobject_put(sev->sev_kobj);
+	sev->sev_kobj = NULL;
+
+}
+
+static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
+{
+	if (sev->verify_mit) {
+		sysfs_remove_group(sev->verify_mit, &mit_attr_group);
+		kobject_put(sev->verify_mit);
+		sev->verify_mit = NULL;
+	}
+
+	if (sev->sev_kobj) {
+		kobject_put(sev->sev_kobj);
+		sev->sev_kobj = NULL;
+	}
+}
+#else
+static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
+static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
+#endif
+
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
@@ -1673,6 +1824,17 @@ int sev_platform_init(struct sev_platform_init_args *args)
 	rc = _sev_platform_init_locked(args);
 	mutex_unlock(&sev_cmd_mutex);
 
+	/*
+	 * Register the sysfs interface outside the sev_cmd_mutex. The
+	 * _show()/_store() handlers issue SEV commands that acquire the
+	 * sev_cmd_mutex, so creating (and on the shutdown path, removing) the
+	 * sysfs group must stay outside that lock. sysfs provides its own
+	 * synchronization between group creation/removal and concurrent
+	 * attribute access.
+	 */
+	if (!rc)
+		sev_snp_register_verify_mitigation(psp_master->sev_data);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
@@ -2752,6 +2914,15 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	if (sev->tio_status)
 		sev_tsm_uninit(sev);
 
+	/*
+	 * Remove the sysfs interface before taking the sev_cmd_mutex.
+	 * sysfs_remove_group() waits for in-flight _show()/_store() handlers
+	 * to drain, and those handlers issue SNP_VERIFY_MITIGATION via
+	 * sev_do_cmd() which acquires the sev_cmd_mutex. Removing the group
+	 * while holding the mutex would therefore deadlock.
+	 */
+	sev_snp_unregister_verify_mitigation(sev);
+
 	mutex_lock(&sev_cmd_mutex);
 
 	__sev_firmware_shutdown(sev, false);
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index b1cd556bbbf6..d5e596606def 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -59,6 +59,9 @@ struct sev_device {
 
 	bool snp_initialized;
 
+	struct kobject *sev_kobj;
+	struct kobject *verify_mit;
+
 	struct sev_user_data_status sev_plat_status;
 
 	struct sev_user_data_snp_status snp_plat_status;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d5099a2baca5..98666c5a6f79 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -129,6 +129,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
 	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
 	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
+	SEV_CMD_SNP_VERIFY_MITIGATION	= 0x0B2,
 	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
 	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
 	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
@@ -898,10 +899,60 @@ struct snp_feature_info {
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
 #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)
 #define SNP_CXL_ALLOW_POLICY_SUPPORTED		BIT(5)
+#define SNP_VERIFY_MITIGATION_SUPPORTED	BIT(13)
 
 /* Feature bits in EBX */
 #define SNP_SEV_TIO_SUPPORTED			BIT(1)
 
+#define SNP_MIT_SUBCMD_REQ_STATUS      0x0
+#define SNP_MIT_SUBCMD_REQ_VERIFY      0x1
+
+/**
+ * struct sev_data_snp_verify_mitigation - SNP_VERIFY_MITIGATION command params
+ *
+ * @length: Length of the command buffer read by the PSP
+ * @subcommand: Mitigation sub-command for the firmware to execute.
+ *              REQ_STATUS: 0x0 - Request status about currently supported and
+ *                                verified mitigations
+ *              REQ_VERIFY: 0x1 - Request to initiate verification mitigation
+ *                                operation on a specific mitigation
+ * @rsvd: Reserved
+ * @vector: Bit specifying the vulnerability mitigation to process
+ * @dst_paddr_en: Destination paddr enabled
+ * @src_paddr_en: Source paddr enabled
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @src_paddr: Source address for optional input data
+ * @dst_paddr: Destination address to write the result
+ * @rsvd3: Reserved
+ */
+struct sev_data_snp_verify_mitigation {
+	u32 length;
+	u16 subcommand;
+	u16 rsvd;
+	u64 vector;
+	u32 dst_paddr_en : 1,
+	    src_paddr_en : 1,
+	    rsvd1 : 30;
+	u8 rsvd2[4];
+	u64 src_paddr;
+	u64 dst_paddr;
+	u8 rsvd3[24];
+} __packed;
+
+/**
+ * struct sev_data_snp_verify_mitigation_dst - mitigation result vectors
+ *
+ * @mit_verified_vector: Bit vector of vulnerability mitigations verified
+ * @mit_supported_vector: Bit vector of vulnerability mitigations supported
+ * @mit_failure_status: Status of the verification operation
+ */
+struct sev_data_snp_verify_mitigation_dst {
+	u64 mit_verified_vector;                /* OUT */
+	u64 mit_supported_vector;               /* OUT */
+	u32 mit_failure_status;                 /* OUT */
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
-- 
2.43.0

