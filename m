Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8021B3AD50E;
	Tue, 19 May 2026 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220250; cv=fail; b=ATdC0KfxEO6Pdh0zrtlMYjZHv7SlMM/rjVMlF3OG0SwzL2dXmBmDdG7UDKoMVpq1Ksbdkass6TxaLAqfeVjoojXr+M4Qbg9Gk0KRb3CLE/eJmtM8f1un2Lccun0Wi0fL+5CmwonfjObwDS+p0Acc4aqVM1TZkf3x6c6T94R4+M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220250; c=relaxed/simple;
	bh=znaW6uv7ed6fsb9bf2kndskrF5bGu6M3GSv4vmxnU/g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZKxqUk9pbk1LtIgmY+vAiYnCbBbDo3OoxviEMq148g0j/RA+bEc701+fMMn7nEp0fF9KFOR60BDnVys6k3X9zzdruYrh7TA5JIQUMPliki0BzQ6IL1rj/r7slOLsWIqKC9a8yzNq/1JxOsqoHZXDveWzKgzfhEaIGIAxQ3AbFW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hwp4qDW2; arc=fail smtp.client-ip=40.93.198.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hwp4qDW2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTLmIgpY/fi4hkn0pF+wuNYPNtqDZF3nFuUGmmHZ1d0PAwpl6OTAZf468PFxfD0s89K8KHaFNjfhkFuA3rQOnAiVObiQf7w0u1bDj7OuvEQakhOEBeAIgcskA+PJFT4U93fGrSDWrxZb8oqsOsL2/884M5N/MVHzqnqBe4cF4QCVAXg+e8q1/zJq9iUb/5K32/bwy610P6Gd3HjG+CCmTcUw1iv2ch7w0UC94yiqRqQ4ztI0hsSqMzsrX6NdmTUAZWWQybhTKxssFr+3Zj7cXSYImCQiPaFPV4Ef0lZHMwgykFJ0M0EJZWljdf5PJy/6iE550lIyhshKThaqwtGouQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZZ3WV7xvLowAcm+j4GOWxY84IrP9rrAyI4Ukmktu90=;
 b=eEGPUP+HQzar2q1G5JA6qWb6kmq3Q3dm2lRpASUJUi7Xpxgqnul2XzHz+jjJe8hhwx3vxnfiSY1khSXbfBgJ7Mio1F8j7EvWJQn0WDEG+PbNvrGA9c0JyRoHWeyNZfhvFUVGccpxQ/eZNiLZONtE2kcTifRZeB1YEq9IDJn8PScyOu0KWUCwxM3p/T8bpA3g1ETiHwMcfQHHxh+ziF7dw+igPu4iPSc+9UgdKHcXuMgHiSCkohlHDQWujbUtTm/E6eow1tKNPpTYO9EpfowdAU0iAWBRME6UU1kLz+JIj2ZooOHjXcypPrsUj6E44c6/X+wbZqP2/qPr7xH+ZSJtZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VZZ3WV7xvLowAcm+j4GOWxY84IrP9rrAyI4Ukmktu90=;
 b=hwp4qDW27zGYhz2UMhK7uJcqfjXm5fOL+Xjd5YJx8KyBXc+XyGwKtPVQP/SYLknqAGtNcUhwhe5Brc51ZBa9oAz08rEfRBGkCVfowF0uetDtr4sVTwVg34XSlyLV6JhpkNgyCfJU54FD+fysIYmlW+quWjvA2Ugi6/82tCVNxlw=
Received: from PH8PR22CA0002.namprd22.prod.outlook.com (2603:10b6:510:2d1::26)
 by IA1PR12MB6308.namprd12.prod.outlook.com (2603:10b6:208:3e4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 19 May
 2026 19:50:37 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:510:2d1:cafe::f1) by PH8PR22CA0002.outlook.office365.com
 (2603:10b6:510:2d1::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.14 via Frontend Transport; Tue, 19
 May 2026 19:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Tue, 19 May 2026 19:50:35 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 19 May
 2026 14:50:34 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <ashish.kalra@amd.com>, <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<prsampat@amd.com>
Subject: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Date: Tue, 19 May 2026 14:50:29 -0500
Message-ID: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
X-Mailer: git-send-email 2.53.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|IA1PR12MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c51028a-c369-4864-4299-08deb5dfe4d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|3023799007|11063799006|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	u9BnQasg32D1eO2DnyaGi0bYpuo3XkFnvVI7hZTD2H0txSOvI59lITwf1GMJItIv+dRABK0Lp2OYSPajZC4JIJv8cQMlbGSq+YP06f6erP2S4q+zbs9ZEPAXiNAGotMO+dJRUJKSVfdattR+CC/JuRc1c8Oysxm8hoKkMiC9lVWZIc7/btLgqYBQr2Td9MersV51FRyE26S7MVtlPpkXbc7xD7QqnePnWNI2Ejd2qtujbh1F6gCojO9ysWHs4OlprxIDs5taPqAj8YlGq4wwR1kyvlN2/ulgW+2boxQojKNu2rnSpTQAwy3dzxnuhoNZI84SHyXUBNePR5xF1wLQbc201CXk6GhDzAbLz0qcBP5nU5om89rkfdDvxW8BS7grCYuZDG6HHL0w1Xhu8iEUfKiXxKA8+q6B0co3ZQ+Tqs8EQk+wk1w5wowfl4UMSPa83XRS3zrWP9W6Pxup6+0EDHxEjCk0GnVmQm/oArgtv83HV6fQTEo+bcWwHaI3fdHD+IYJpG5B8RG+4D2QgrHRe1aAxz1gvin6JjE+kS4dzjg3c6kfeNofFRK29RLRdrMCaDNfUl8CW8OR82DVatVOCuk6twrnGf6nedSy/ews2+ZpguCQFT8NKB5IQgovgjFQG0cFSEG1PLRiDmv2J4Tvd9V84Q+Lr8mZ9S558mVDB1CQTIby2kulxGQO+bf9k4yCXy6fAqkFfiR/uLTDB50bRNS8pIrNBrQiIoVKRkvoqu0=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(3023799007)(11063799006)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5ZkkFivC5eCJnWhqgONbsy15HXEoMKcUaUzUXco4PK0bNySxSsSxtku1/mqkJm8zdt6RmluIN4q3u2hswYYxAg7TMQ/sBWlopi8tVVvtW2Fzz9AfgTHyyQpLAcBUoy8gnWhnzJ6mISEXvURxqbJy51zgRA7dpeGXT1rMo2kJALFodbY6O8v8FyDVUGmpd+bS7hI4vk55Pj80Fb7V2jIxqLuNXngNLUJ5B4NahudZ77u75rD2U3CGY/TZnYKVsafJxSp/J7QIvD7518q0akFLUozr93AngvfZ0ZMzBALnINj2IYlHnwBoX2MKU9bn336uHkTJ20Bc2r/g02HFcQIyRxNHz4waJhB2gu+cn1BZx6zZL99vmMdOvJEaTjdo97Kq7ntUnzGdz1NQJ+lBobQdscaw5Cb/9OJ4ReEzni/sE/UMt/Q3HzBdixGLkz4VVgaO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 19:50:35.3686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c51028a-c369-4864-4299-08deb5dfe4d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6308

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
 .../sysfs-firmware-sev-vulnerabilities        |  17 ++
 drivers/crypto/ccp/sev-dev.c                  | 172 ++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h                  |   3 +
 include/linux/psp-sev.h                       |  51 ++++++
 4 files changed, 243 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities

diff --git a/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
new file mode 100644
index 000000000000..cc84adbac3c0
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-sev-vulnerabilities
@@ -0,0 +1,17 @@
+What:		/sys/firmware/sev/vulnerabilities/
+		/sys/firmware/sev/vulnerabilities/supported_mitigations
+		/sys/firmware/sev/vulnerabilities/verified_mitigations
+Date:		May 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:	Information about SEV-SNP firmware vulnerability mitigations.
+		supported_mitigations: Read-only interface that reports
+				       the vector of mitigations supported by
+				       the firmware.
+		verified_mitigations: Read/write interface that reports
+				      the vector of mitigations already verified
+				      by the firmware. Writing a vector value
+				      requests the firmware to VERIFY the
+				      corresponding mitigation bit(s).
+		The list of supported mitigations and the meaning of each
+		vector bit are both platform- and bug-specific and are
+		published as part of the AMD Security Bulletin.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..eec4864c6597 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -57,6 +57,7 @@
 #define CMD_BUF_DESC_MAX (CMD_BUF_FW_WRITABLE_MAX + 1)
 
 static DEFINE_MUTEX(sev_cmd_mutex);
+static DEFINE_MUTEX(sev_mit_sysfs_mutex);
 static struct sev_misc_dev *misc_dev;
 
 static int psp_cmd_timeout = 100;
@@ -245,6 +246,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
 	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
 	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
 	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
@@ -1351,6 +1353,162 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
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
+#ifdef CONFIG_SYSFS
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
+	if (!sev->snp_initialized || !sev->snp_plat_status.feature_info ||
+	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED))
+		return;
+
+	guard(mutex)(&sev_mit_sysfs_mutex);
+
+	if (sev->verify_mit)
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
+}
+
+static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
+{
+	guard(mutex)(&sev_mit_sysfs_mutex);
+
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
@@ -1670,6 +1828,14 @@ int sev_platform_init(struct sev_platform_init_args *args)
 	rc = _sev_platform_init_locked(args);
 	mutex_unlock(&sev_cmd_mutex);
 
+	/*
+	 * The shutdown + init path can race with in-flight _show()/_store() operations
+	 * which acquire the sev_cmd_mutex. Register the sysfs interface outside
+	 * the sev_cmd_mutex and serialize by sev_mit_sysfs_mutex instead.
+	 */
+	if (!rc)
+		sev_snp_register_verify_mitigation(psp_master->sev_data);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
@@ -2796,6 +2962,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	if (sev->tio_status)
 		sev_tsm_uninit(sev);
 
+	/*
+	 * Concurrent access to the sysfs entry will call sev_do_cmd() for
+	 * SNP_VERIFY_MITIGATION which locks the mutex and can cause a deadlock.
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
2.53.0

