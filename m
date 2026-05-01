Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012008.outbound.protection.outlook.com [40.107.200.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1C42DB798;
	Fri,  1 May 2026 15:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777648873; cv=fail; b=XkmJFQmNmFI5MB/IUFRwg277SMW4UiiAk7hSGeoG5cXml9bmx8w+/odqe8uoVgA+sf11a0m/qvxRuImpEYQMCFHu6d4LjKTvKpaxRa10qyuKPPtUqPzCL13wlhxnKsBm9RmCi96nJj9WwD112+4c/uRGRlmlTz6npAmJ7/HI6ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777648873; c=relaxed/simple;
	bh=qnrPObAgKL0QRlWFydH3HD505vVWYOP7e79qk1zaQSo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mvL4NgYPm5s7804RE02XBONxtese/4PQg6o39142j39oJfWKBZtaNiKZOeA2WiyXGy0n5NgCaI7Yf0KHaKqXUjmQUoIMwwhzMCas5bM0rkjC6CojMDtWexitusf71NdbZZ5PVP9VLjhnCEVrVPjZo5gcR8/X/seUEAIkJseFv7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kTmyMwxC; arc=fail smtp.client-ip=40.107.200.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kTmyMwxC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdMTbtBc2MH3afJWjOnkDBy2MGcV0iJ4MxUhxwx4SWgHUbRmEw1hq/JWOZ0mVKAYAFZNmyQj5anyr821Nii1O3RDIIhybwntU5irXJh9VO7XfMvm/ENN9I+C9DVrwiaof/ueyj/3YjK2DBSvIYbJ7Azzxz2hjLhvrONPpVRciD+76Ksf3rdgn959ypvitLsP8J9ce3Sn3eijRDSDUSGvL9w+CoQ9C1t/Lw9Ect27hG1sJl5Hnz/GS17okbPUfqZT0CG7/MTvpsZRZ3I6r9D4A3eqKum7+6PZarZZqerCQI4jhJad9nKNt+lealNpXximhbVbviIFh1pp9+rb3wcpgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qU1qj/H213IL3UMKkAVew7gjy2UViW5OwXt2aHIFhPA=;
 b=P96jXIwOXvEiAp/tYxr4+I6km3TcZxh/A1FpVvpUW0JlMhqvoQLTDHDHAn/pvEAW6NrFomqMwDCWnSXkUTLmcLE8QHEW7t/j0lrAawGEQ48ufBwt9wpvD7Keny5hmOQvTEzcwIWllwT74Zz5fHRTzHoO1sCkqc7Qfqm5pAlmgxzorikQCPtYuEeVjDajmWzFbbqihT2+jpIfq/hE1PakS3Tk/STp9c2Bq/ghZ7FOXbUe1n1+0TNkjD/4Q8RWpAfB8P3GEdvTAjZFYEW90Tbwe9g7xfGrcxmZuBbw8mFUhoY7pFD1Vl+/X8yNeAVcjemeoly0Fv34lNcgZXr3E1yYug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qU1qj/H213IL3UMKkAVew7gjy2UViW5OwXt2aHIFhPA=;
 b=kTmyMwxCC1oJ4BuCb3g0fLyGDkTkQ3Gi3vinHMtNc6ZpC9zSWgPOZyUO/GkW2U88SJQXZMDaqDAetwjEDSFYS1aEj0QcEKiScEU1FCL/xX7crDAkz+DfGMfzD9Zs+QTiykZaGpMehqwMScLG47qjJS0W4RuwN3ek6HKjQEwFRCM=
Received: from SJ0PR03CA0013.namprd03.prod.outlook.com (2603:10b6:a03:33a::18)
 by SJ2PR12MB8830.namprd12.prod.outlook.com (2603:10b6:a03:4d0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.22; Fri, 1 May
 2026 15:21:04 +0000
Received: from SJ1PEPF00002317.namprd03.prod.outlook.com
 (2603:10b6:a03:33a:cafe::3a) by SJ0PR03CA0013.outlook.office365.com
 (2603:10b6:a03:33a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.23 via Frontend Transport; Fri,
 1 May 2026 15:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002317.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Fri, 1 May 2026 15:21:03 +0000
Received: from AUSPRSAMPAT.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 1 May
 2026 10:21:02 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <ashish.kalra@amd.com>, <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<prsampat@amd.com>
Subject: [RFC v2] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Date: Fri, 1 May 2026 11:20:51 -0400
Message-ID: <20260501152051.17469-1-prsampat@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002317:EE_|SJ2PR12MB8830:EE_
X-MS-Office365-Filtering-Correlation-Id: 5603c936-b7e1-4421-81ef-08dea7954236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|1800799024|13003099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	hmY+bgcyh1xn/2rAdDIQ/F34Ykuw+yBrqoITNUdQMDuNVHIcpHJFaQtPIfwcg0huxkgNKpUi/ZJxX4MFSTMAIhwd6GaLI4vEGSHGquiF70Hzdr3WEH1DsxAvvgGUL/OKF2fbBqOthqSFMgOI1z1OKebxNDhX0QkiLq09wSwUwTUyZRjXB2kgoiGlmdH3w+GG/q1s5alvknNFhVOH3NHCg4/cUnUA2fG4xzfqj9af4r54AqgEm4Vsc3CXMVA9fWphrQneIySvufnLzdJL3lUTX6k62M8NTlBwabjGSC8rnMdnQf47S5mCkOCPQ24alXn/mr7MY1FcvB7mGJyP30NchY5Unr2z8Gqf4pClkODRqNwIQOdJEJAGJStxKPl+2XHviO7eMDeecJiN0Ae71GkK6WLKz+GGipsjRM8Dme/9CREWgtEpsLjEbMH24b4Dki+/m5YUAz5DtIZCL6RRQmS2wvDb5GxIyIeRFGDLpGZN/SRgzCVFXJwrNudj9VEEI4/4NFibADhm6ROdS6JM98x5UDta0vSxQkzkIdq9YHSEYgoExS+WASef1PZZA4zZaJn1YrfFiyWVtAmpJeJ22t5l+PgCV/T2hSUDpN+6YBWZBTCXkCgx3ZBShkwcCVl9pI0NSATNBCwYwK/hYaauiGgkv4ZH7FLKQfoMUyRf0i8ZFoo+3XsmPGWJdCexH8BelHdzEvhmYyORyfpHvasFjAJgXlKJBSthc+Ndt8Z82H3T6wo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(1800799024)(13003099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S9sTMeomzZmCWgtwhppoSz4sjcocs8c8dQdicam8B2dWM8u8YoORoWWyoIMXLZy+L9VuL3odulJCCesqfUeFmc1QtpCr3I9R1jNttBUjGZ9LwrtOtovaoovb5RXpcQG5PAXhYDnRIOvqUopFVTTPNbywIOIzFbHpNsf0F4yEd7FGf3pPzdu32WuHoicJrvB9jFSM+zIKSpXDZguX1SiV96uc01/57I09gP6jFWWW03enKRorIizg/C0hBPAKyl+kflwuOAu/wbhwm2EZiuZYQgCrbvGtWLHwP34ZX9MqAFgxOJPM5Y7wwsHmx0Wmr4m5cKjAsxUh2jreKsQQJgpi+pcAliVGI6IIj73YoBlwgS3lCQK08uO6Cqiw1RoQaaLG2MRvwiGYpLFFL2/9dqk8zOJDD+0bZo8IYoj8wm/IaNLHtRVe9nsSVbbiuaLUjfE6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 15:21:03.5248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5603c936-b7e1-4421-81ef-08dea7954236
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002317.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8830

The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
can be used to query the status of currently supported vulnerability
mitigations and to initiate mitigations within the firmware.

This command is an explicit mechanism to ascertain if a firmware
mitigation is applied without needing a full RMP re-build, which is most
useful in a live firmware update scenario.

The firmware supports two subcommands: STATUS and VERIFY. The STATUS
subcommand is used to query the supported and verified mitigation bits.
The VERIFY subcommand initiates the mitigation process within the FW for
the specified vulnerability.Expose a userspace interface under:
/sys/firmware/vulnerabilities/
  - supported_mitigations (read-only): supported mitigation vector mask
  - verified_mitigations (read/write): current verified mask; write a
    vector to request VERIFY for that bit
  - failed_status (read-only): firmware-reported failure status from the
    last operation, as returned alongside the status vectors

The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
it are bug-specific. Information about supported mitigations and it's
corresponding vector is to be published as part of the AMD Security
Bulletin.

See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
more details.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
RFC v2:
  * Intrdouce /sys/firmware/vulnerabilities sysfs interface instead of
    an ioctl interface - Boris
  * Reword commit message to focus on need for a userspace interface - Sean
  * Since download_firmware_ex is the primary usecase of this feature,
    posting this patch in parallel to those discussions[1].
  Link to RFC: https://lore.kernel.org/linux-crypto/20250630202319.56331-1-prsampat@amd.com/

[1]: https://lore.kernel.org/linux-crypto/20260430160716.1120553-1-tycho@kernel.org/ 
---
 .../testing/sysfs-firmware-vulnerabilities    |  20 +++
 drivers/crypto/ccp/sev-dev.c                  | 152 ++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h                  |   2 +
 include/linux/psp-sev.h                       |  51 ++++++
 4 files changed, 225 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-vulnerabilities

diff --git a/Documentation/ABI/testing/sysfs-firmware-vulnerabilities b/Documentation/ABI/testing/sysfs-firmware-vulnerabilities
new file mode 100644
index 000000000000..ef9233d9129a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-vulnerabilities
@@ -0,0 +1,20 @@
+What:		/sys/firmware/vulnerabilities
+		/sys/firmware/vulnerabilities/supported_mitigations
+		/sys/firmware/vulnerabilities/verified_mitigations
+		/sys/firmware/vulnerabilities/failed_status
+Date:		May 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:	Information about SEV-SNP firmware vulnerabilities
+
+		supported_mitigations: Read only interface that reports the
+				       vector of mitigations supported by the
+				       firmware
+		verified_mitigations: Read/write interface that allows applying
+				      a firmware mitigation and reports
+				      already verified mitigations.
+		failed_status: Read only interface that reports the status of
+			       the verification operation.
+
+		The list of supported mitigations, their applications are both
+		platform and bug specific posted as part of the AMD Security
+		Bulletin.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d1e9e0ac63b6..ac6547165359 100644
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
@@ -1351,6 +1352,144 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
 	return 0;
 }
 
+static int snp_verify_mitigation(u16 command, u64 vector,
+				 struct sev_data_snp_verify_mitigation_dst *dst)
+{
+	struct sev_data_snp_verify_mitigation_dst *mit_dst = NULL;
+	struct sev_data_snp_verify_mitigation data = {0};
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
+static struct kobj_attribute supported_attr = __ATTR_RO(supported_mitigations);
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
+	if (dst.mit_failure_status)
+		return -EIO;
+
+	return count;
+}
+
+static struct kobj_attribute verified_attr = __ATTR_RW(verified_mitigations);
+
+static ssize_t failed_status_show(struct kobject *kobj,
+				  struct kobj_attribute *attr, char *buf)
+{
+	struct sev_data_snp_verify_mitigation_dst dst;
+	int ret;
+
+	ret = snp_verify_mitigation(SNP_MIT_SUBCMD_REQ_STATUS, 0, &dst);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "0x%x\n", dst.mit_failure_status);
+}
+
+static struct kobj_attribute failed_attr = __ATTR_RO(failed_status);
+
+static struct attribute *mitigation_attrs[] = {
+	&supported_attr.attr,
+	&verified_attr.attr,
+	&failed_attr.attr,
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
+	if (!sev->snp_initialized || sev->verify_mit || !sev->snp_plat_status.feature_info ||
+	    !(sev->snp_feat_info_0.ecx & SNP_VERIFY_MITIGATION_SUPPORTED))
+		return;
+
+	sev->verify_mit = kobject_create_and_add("vulnerabilities", firmware_kobj);
+	if (!sev->verify_mit)
+		return;
+
+	rc = sysfs_create_group(sev->verify_mit, &mit_attr_group);
+	if (rc) {
+		kobject_put(sev->verify_mit);
+		sev->verify_mit = NULL;
+	}
+}
+
+static void sev_snp_unregister_verify_mitigation(struct sev_device *sev)
+{
+	if (!sev->verify_mit)
+		return;
+
+	sysfs_remove_group(sev->verify_mit, &mit_attr_group);
+	kobject_put(sev->verify_mit);
+	sev->verify_mit = NULL;
+}
+#else
+static void sev_snp_register_verify_mitigation(struct sev_device *sev) { }
+static void sev_snp_unregister_verify_mitigation(struct sev_device *sev) { }
+#endif
+
 static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 {
 	struct sev_data_range_list *snp_range_list __free(kfree) = NULL;
@@ -1670,6 +1809,13 @@ int sev_platform_init(struct sev_platform_init_args *args)
 	rc = _sev_platform_init_locked(args);
 	mutex_unlock(&sev_cmd_mutex);
 
+	/*
+	 * Register SNP mitigation sysfs attributes after the mutex is dropped
+	 * so that concurrent sysfs reads/writes do not deadlock init.
+	 */
+	if (!rc)
+		sev_snp_register_verify_mitigation(psp_master->sev_data);
+
 	return rc;
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
@@ -2796,6 +2942,12 @@ static void sev_firmware_shutdown(struct sev_device *sev)
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
index b1cd556bbbf6..16d38e011f84 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -59,6 +59,8 @@ struct sev_device {
 
 	bool snp_initialized;
 
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

