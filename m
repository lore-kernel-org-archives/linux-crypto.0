Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10EB386561
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124012; cv=fail; b=B6nA4MopqfsOUJhPkxgIGt06RUSeIGWlxlbOJxa/OOuYeEjALA9QUCZ4L6+Tmyb8Tk5+IYWbOaoWBmr1rAJRCC5PWPB4L9NhetnJL9TSoQ6z5QdhIFyN2Ymya4N4ENvZibkioRWAfDhhkr+AwzjZwKPjcgI8tFk9P8+UOdzzHtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124012; c=relaxed/simple;
	bh=/cCB5RjYzl0oztZ4b4FhAaqYkTqGZL5AZrzYdauvUUE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6YFdgP4tEF86dUNymeodKih8mMg1+YHRwFB0i1xG5kBPcz+iqsKyMRGGGedkkd8n7tAE30jjm5CIXIzj6uTCZxNuxRIjhtfCUjglfxyGm6gYFzl4DUx3D3iKHRjK/sL/XO6tdRXbIGpBTj8M/gzzbtKnhJIu6DO2LiCBRoTRtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tQE4I6lE; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tQE4I6lE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sSaV46lnQWklXebC4cXAZz2JGC0H5HZhKfUi85XQwSpdO40Yvps6QnMD+khT4qjWI9Wu946EpNGI4KQweUQ2kJ4QWH5CizB3NmPPkxLXcVPF6bHOI7wzHdMvsKgtd+I0OYsbt1gFKscwfOKcJpMTXTTyhiGLQIKMhQ+ZHYCOrftwPB5gQRrwNf9VntJj6Ox8b1OLb7OojfmAMeoJsv7TqBzuwSLTKScfzwCjfpkToA87meGOzwi1QaQYDuVqhpt1oJXtf/G49GrJw3CPfcNTKAUE27I5vtjdZViG6rHrI4iq/He/c6izfrwHc4y9RgNTwn5kkivOcyLVXgkPwdqYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tu0VGytkEvfRGoUCwelNTs6PfqQ1Ngv3DuYUnJWZm7Y=;
 b=xl8UB2ttoXjGF+yMVJ8Jb4WLvcNRCHB596MArOdrovqYnfPnTyPWtls+MQ9Cv9GfwhxIWazwBqS6jv+08iZSbBypXVyBxrUoQMZIKijRIMHpQGuCkq8432n08A/IsY/aU2WwSlXvYJBb3YZXEhQg/G64RpS/pneRZaFjSP9XLuF7n2NyoXTBCo8Y6La/6nLF42NQy88b01ao8NQgTLLjVIqdxFFf7YlgmU4eP/jvuvwM9bpal83gOVlioRXhm+/ZA+WJsQUEoZLYGJM4N8TCkYfd3CJuPkwlaBlE8d+NIn5el+TAf6b7KzF+Jhy9a5UWQaU/bKJ7a0tpZJaBwxL/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tu0VGytkEvfRGoUCwelNTs6PfqQ1Ngv3DuYUnJWZm7Y=;
 b=tQE4I6lEh1uQmyITBSHDxbHEnTcQuzsKV6t6TwrPNwZWPIA3gstwpQtCj3Xo4YD7NMDnBmHi+QVrCw6b7W4vyfUXN4SNLRUjtm/GVkTnfD6yS88KaI0dkOuHgPgSjbDNdjd1IbdNJIPNbd0JZHK9xVyZQzo9jsQWQS/jL51DdFk=
Received: from PH8P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::17)
 by IA0PR12MB8746.namprd12.prod.outlook.com (2603:10b6:208:490::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 04:13:27 +0000
Received: from CY7PEPF000000F6.namprd05.prod.outlook.com
 (2603:10b6:510:2d7:cafe::6d) by PH8P222CA0023.outlook.office365.com
 (2603:10b6:510:2d7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 04:13:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F6.mail.protection.outlook.com (10.167.247.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:13:26 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:13:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 9/9] crypto: ccp - Allocate status page outside sev_cmd_mutex in SNP_PLATFORM_STATUS
Date: Thu, 15 Oct 2026 23:09:37 -0500
Message-ID: <20261016041109.1778673-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016041109.1778673-1-michael.roth@amd.com>
References: <20261016041109.1778673-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F6:EE_|IA0PR12MB8746:EE_
X-MS-Office365-Filtering-Correlation-Id: 70fcd98d-1440-41ba-b309-08df2b3bd3f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|6133799003|22082099003|10067099003|18002099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	V2LPYLGkTl3n0AO0sI3sTWomnGkTjwhKmcm7JIdTOudZhvDtf28qbHrfOPPmW7zIyTK3pbNj7P8xT8JPUher4aK3Us0xYlieqFqst9qTq28qEnQLd39U2Ppb63/C4vA1LQjyEm0sQfpRgjuTWCjyHYF05tSU+feNPV4cePeC0h4NkjNCHmMGg7z8giuEkvVBA8S8pGeBNqUa9woNKwcUVxGNYrNlMyIj63WvkF1z3atx+qOKiOs6b+28UCnNRCojJv5TMh+SktlyLdOkJWCyofXdB6fjrqMsTwiHtmyY3hqRVIK9bXmrpFMprnvdSMuuUm+d0mfenOlJUAy9rBrkEpC8rQkYLekyw1I/lSBR0UYpMQbK+icCMmGuMDduHvWGgjLfCVdpX1HVBcCFzXVKMx6xouQkD7IHLGh4+R9kj0kmmScgGQf1rNpqiyoTNHCqf79HOs5KIGksxzbPIFRZlEx1OLcf/lieGSd5V+vRIWC4HOon2XfUM0m6VuovX5F/XdjSLWIb6Vi0Z1Wojrud3r8RCwC3K5qPJvcYOOVvnSy6d3vNcmO9XPWmS3Ti7cbSyz+vsva0ZiU8sOE+2OaxTnqv2gaXM1hDbRGhtrv9l++rMq8bA+NnH6T0Y79E1RFXkxw/199IOICab9yqDPe+Ogf4Y7Zpr/ATXKyaTOcpw0nQWHNmI4dlZZ0zVu1E53VHrNO5SNiQDkaJGoDjaiwibg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(6133799003)(22082099003)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7gf5jBNa0NVo2haob1kDED+YEFQSO7B7oAFWvMskisPSM7cinej5rs7TEsrkJESHejTDDlsgspPscKePqrQqa0Sp/Pn24jd5zGmSNi5t6fANt2xvWyU6d5GEhHk8Rx7yxRBetuXwRTa3c4tOQKbPOKcw2X4Ub5Gr9gfouLRDkR3laBojrq7xEB4dhKargM2OeNRoAlQimDPZd68RWg+vGgkkAjiPVzal2Cvwb7fNPbrkUsES2jiZXrmFdFmj1mzFbzXWtR34WAA0t+Jn1l5XI6kqHs155zx+GOKjn00OwCA+YklrMJhxyXzx6QTM0PH/pEKeYchIEZA0Zq8Ag7y15tzoDDksswV+a8PmIUqGcjIlXdHrzdmGBgXYQN0Tjty7XqQ2v/FNdSN/mizDDJryW9AXVvdoEZPiT4Ssgf74K9bsqiKa9c2tfuhe74pKsnrA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:13:26.8099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70fcd98d-1440-41ba-b309-08df2b3bd3f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8746

Allocating memory while holding the global SEV command mutex
(sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
across the system if page allocation stalls. Handle allocation/freeing
outside of the mutex instead.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 62 ++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1e017783dd03..aa4f0fd731c0 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2532,8 +2532,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
-static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
-					int *error)
+static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+				      int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	void *data __free(free_page) = NULL;
@@ -2544,31 +2544,36 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 	if (!data)
 		return -ENOMEM;
 
-	/*
-	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
-	 * when SNP has been initialized, the status page must be firmware-owned.
-	 */
-	if (sev->snp_initialized) {
+	scoped_guard(mutex, &sev_cmd_mutex) {
 		/*
-		 * Firmware expects the status page to be in Firmware state,
-		 * otherwise it will report an error INVALID_PAGE_STATE.
+		 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
+		 * when SNP has been initialized, the status page must be firmware-owned.
 		 */
-		if (rmp_mark_pages_firmware(__pa(data), 1, true))
-			return -EFAULT;
-	}
+		if (sev->snp_initialized) {
+			/*
+			 * Firmware expects the status page to be in Firmware state,
+			 * otherwise it will report an error INVALID_PAGE_STATE.
+			 */
+			if (rmp_mark_pages_firmware(__pa(data), 1, true))
+				return -EFAULT;
+		}
 
-	buf.address = __psp_pa(data);
-	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
+		buf.address = __psp_pa(data);
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
 
-	if (sev->snp_initialized) {
-		/*
-		 * The status page will be in Reclaim state on success, or left
-		 * in Firmware state on failure. Use snp_reclaim_pages() to
-		 * transition either case back to Hypervisor-owned state.
-		 */
-		if (snp_reclaim_pages(__pa(data), 1, true)) {
-			data = NULL;
-			return -EFAULT;
+		if (sev->snp_initialized) {
+			/*
+			 * The status page will be in Reclaim state on success, or left
+			 * in Firmware state on failure. Use snp_reclaim_pages() to
+			 * transition either case back to Hypervisor-owned state. If
+			 * for some reason that fails, it will have been added to the
+			 * leaked pages list, so indicate to the caller to not free
+			 * the page.
+			 */
+			if (snp_reclaim_pages(__pa(data), 1, true)) {
+				data = NULL;
+				return -EFAULT;
+			}
 		}
 	}
 
@@ -2586,8 +2591,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (!argp->data)
 		return -EINVAL;
 
-	scoped_guard(mutex, &sev_cmd_mutex)
-		ret = __sev_do_snp_platform_status(&status, &argp->error);
+	ret = sev_do_snp_platform_status(&status, &argp->error);
 	if (ret < 0)
 		return ret;
 
@@ -3086,9 +3090,7 @@ static int get_v1_svn(struct sev_device *sev)
 	struct sev_user_data_snp_status status;
 	int ret, error = 0;
 
-	mutex_lock(&sev_cmd_mutex);
-	ret = __sev_do_snp_platform_status(&status, &error);
-	mutex_unlock(&sev_cmd_mutex);
+	ret = sev_do_snp_platform_status(&status, &error);
 	if (ret < 0)
 		return ret;
 
@@ -3103,9 +3105,7 @@ static int get_v2_svn(struct sev_device *sev)
 	struct sev_snp_tcb_version_turin *tcb;
 	int ret, error = 0;
 
-	mutex_lock(&sev_cmd_mutex);
-	ret = __sev_do_snp_platform_status(&status, &error);
-	mutex_unlock(&sev_cmd_mutex);
+	ret = sev_do_snp_platform_status(&status, &error);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0

