Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4A1FF5E3
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124200; cv=fail; b=fmK2YoLcnMcLIu/e4Y7Fy7nvnqSYRoOWkStot18QHgWw28nrlAdI9ZCrt7XHMETaMXGSgT5DrgVOL39s008WMMshp6eo9l4CuEeUnnUe5yOqaPpjJZE8rSWK7r8nIUDXwtBATw6EFqdo4XhZYpNwZ5smmcbqmSM8+ynJOpM8RGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124200; c=relaxed/simple;
	bh=xjZWKuYmAtz0CjPceDWiL3lUMEJFus23BvjrUBANjoA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mktUraLsnUw545wx5wi2MYrrNY2SNcNkJckLlxim1PqFLE3jGFOFsx0uBYRs3NHM0hLKS5sWIqfkqwd0JKhpn9pJ/1F8sn8vyZpjE83sZX158M6jb4VtDeTSD+boOb6i0fx+FSpjg5ewQb83ySJ8uyOAGpLnOi98CZGCJWgwBUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lA+ivCAk; arc=fail smtp.client-ip=40.93.195.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lA+ivCAk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y0F/y9uwN8sGwdYm0hjx4I9d7EfjfJvP01xaBmbtbDF4x2Ib4KRyDJQwqYc/hBFPTc1GTUytT8jML+jQU7WWzoSU6zryvwlf1AgnWt/VyNahfEJDqv4GXNZ0U082ohkQyzl923Xip/FCoQbFopKrZOUqKlEHvCm6Y0LNEvDF9xu/nohlVaBgHC7ep7dBx+tXuA5Vp0+xAbo1OhagNRVzUVLZ3c+rqYJDKUkNeTVHlifXtmh0WGH3GtNKayOW2YG2e4Z42VhwwOMOja9JJGKG2RyDDbk8RzbwykSyxYVK7eyP50f1IY1KBsgTYjrVJyYfhyzj5ACEid3c7KlgEWR78Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PANc0jBPMBCHpVsPQehrfmvvZkHH/+GSZKbANS87MKw=;
 b=hjxkLG6DUmixiyuYj47XNggYfd/RqVwbdbU7emLMw9JI1b7WO0ZIU+tvVNYPMt8qCmKL2QGxhsRK/+d+16BUlsoo03rkAaVm4w2SMGPy6uv5EXPXal3jQCfLW+P1TBDg3l62g0S6mMpvdltwU/VAOnMjnXuNPp4YX6z0lpr01Op9m+nvVe2O8oTVDaAgn3NpkAIDRszQridfbQSVZjXj4rLYmRBG1yt3+Xq6WWtWzyccC2oaz2JzxyZKOWPkA7+QU4me5CgUOVfnGuxuTPt9sNSm3TnCipDDhEkCKVgUJ01UzRqXIm6tDuujA5WDvSezN1xaQn3qTyoP2Ub31sMWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PANc0jBPMBCHpVsPQehrfmvvZkHH/+GSZKbANS87MKw=;
 b=lA+ivCAkUFtIc32QNMb8y9SMIj2VZ3ewQMX96z/ghsYwbJG6PdyCL5ZjCqKPHtZTVgEut43Mwk/nLHxYdWI2V/C99cMzI2o6xz4/nn12Wf2BTgzbOq+H7OAkbwuK6XgB9pJEG1yQ8Cnn4QXzNg5bEsj4frQhBqiTaohJlOAXXeM=
Received: from BN9PR03CA0643.namprd03.prod.outlook.com (2603:10b6:408:13b::18)
 by SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Fri, 16 Oct
 2026 04:16:33 +0000
Received: from MN7PEPF0000014A.namprd04.prod.outlook.com
 (2603:10b6:408:13b:cafe::11) by BN9PR03CA0643.outlook.office365.com
 (2603:10b6:408:13b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 04:16:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN7PEPF0000014A.mail.protection.outlook.com (10.167.254.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:16:32 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:16:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 8/9] crypto: ccp - Use __free() handlers for __sev_do_snp_platform_status() allocations
Date: Thu, 15 Oct 2026 23:09:36 -0500
Message-ID: <20261016041109.1778673-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014A:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: fff5d4bf-bea7-4c93-5404-08df2b3c42e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|376014|36860700016|56012099006|11063799006|261009223027099003|22082099003|18002099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	NNyOeORMm2OOpEpUkuNaQV4fysOwgyHEA/dBL/LyqKaayofx+0AdaONZJ55GND08KBke/5GztJOSAbDzPaUZ3GKisC/I49pPcwEMELOPSEWBKF3jENK+YW08TIDoTvXbO9Hd2WraWLfGFBpmr60N0GzUVY6Vd++BRZSM13kWUGaokjJWb39dERpU6xCU4RjVsprjoH3gc0rFvvf4UgCZ2+7aG1r7Rau3AjFBatBTtDzv4Gf6Dja0ETCu8UJr3lw2oTg7EpgiYX4ynZ7D5n0hhzdS47zxLa1xdsTn771C5mN+Is8H7AVf6vOQy2uliDYAmRT+SX0FNNYdk+oWjE94oxVxsG6uPwvd/CqKJeIS0nLE5910ajllhKDESf+4yhmMmb49lFqZYHDkMG8hi7Mopwf5SLJJaG3BZBV2pzZCGElijCcLs6jL2jp2cjjE1xHHUs/1R2exJ2umBPfxFflR8AsdJ2iNSVsyeEj9ZD7XwBs+qA1ZFB6fPqB0dfCKn3hEw299/YybTkf+Cn0OPhFxny82OLLXrIfAa9mvUEI3IeNxUyzq7WK/3bG9kRClpE6jqMR8XHpCO5w7RqHRmLjbfUGkcLi4wiF5esigXAxZRK2Ph3GF0MGE3uS9IG8dWNJuhvLQX8k93I51fc9hWyXqrg3ccq9066i0BrmY5RpbS8MHwtOSZt9yrngMZwQaIwBBThA7aK3epXRd5yaYDG/hbQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(376014)(36860700016)(56012099006)(11063799006)(261009223027099003)(22082099003)(18002099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TTldPVfXvp3zthBaTwxx+IR7zN22cgjwW0SMyvVDsEXJEBw8mrDNJgEG5y2hD0M0iR5ghHiXpXk3/KlcoxARY1KTsVB7blr1/q54JI1mQSDQNjAgkZcF0C1/sDG8RM38W9Xwh3+T2U+EMCqBv84uxSbaa1lS3tMBJJp12/YNvAPZv9gXrToxEUsyry6ibMu96tlvyl3jS4n5ou52r6kH2F9/cUATmamyBEZ1FRHH3QQ3uBbXCxR9Ojsh/xQnJpiqjKwoL741JlKZONbEJw9BhSapTPFwxDwy+aU+37I0kNCWyH4NwnHViOIZavVCwGBU4H+7w+FyCpCrHPTGAYV/sxiWiC5H0oQaUqd9qVGP5jkwSN+VhGBVlS94O6xpwPc+enJaCoI/HqnJozZhsPi+k9sPw/r02OjKCDC1/CcKFs9yjJWPqki1uy93oaK8AGgP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:16:32.9994
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fff5d4bf-bea7-4c93-5404-08df2b3c42e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217

Make use of __free() handlers so that the related goto statements can be
dropped. This is in preparation for switching over to using mutex
guard()'s.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index aae0b15a10d9..1e017783dd03 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2536,17 +2536,14 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 					int *error)
 {
 	struct sev_device *sev = psp_master->sev_data;
+	void *data __free(free_page) = NULL;
 	struct sev_data_snp_addr buf;
-	struct page *status_page;
-	void *data;
 	int ret;
 
-	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!status_page)
+	data = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!data)
 		return -ENOMEM;
 
-	data = page_address(status_page);
-
 	/*
 	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
 	 * when SNP has been initialized, the status page must be firmware-owned.
@@ -2556,10 +2553,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 		 * Firmware expects the status page to be in Firmware state,
 		 * otherwise it will report an error INVALID_PAGE_STATE.
 		 */
-		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
-			ret = -EFAULT;
-			goto cleanup;
-		}
+		if (rmp_mark_pages_firmware(__pa(data), 1, true))
+			return -EFAULT;
 	}
 
 	buf.address = __psp_pa(data);
@@ -2571,17 +2566,15 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
 		 * transition either case back to Hypervisor-owned state.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true))
+		if (snp_reclaim_pages(__pa(data), 1, true)) {
+			data = NULL;
 			return -EFAULT;
+		}
 	}
 
-	if (ret)
-		goto cleanup;
-
-	memcpy(status, data, sizeof(*status));
+	if (!ret)
+		memcpy(status, data, sizeof(*status));
 
-cleanup:
-	__free_pages(status_page, 0);
 	return ret;
 }
 
-- 
2.43.0

