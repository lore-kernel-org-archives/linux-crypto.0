Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CEB4E50B4
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984257; cv=fail; b=Auvq0FDwDCyzk9dqvWrwfjTTSPZSmt7SiKsK7cgpT8GRaEO+++pHotAgD7LupNTAL6KzgcYMy8yD2twY96NEzv1blteVXTZ5Pe1M501x0/Go+6URkxrnbNo361xz3d2L9Ktf8KvyF8SLhUBHyYSoYktMY3ArB0Cr8GZlc4nN9gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984257; c=relaxed/simple;
	bh=NNDBiVAeDKCDX7LfJ9JHMT3do/9nCAF5tIc5cpQS4Fw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRZzwmSySswEJ6/dKndh2tjDE6It8T8ACaHhTkjQEb0mpnJ0Hw39h7lMAC4doeUyXwzUsJf9q/Qhso3DS30zId6KLKIcA12RBcnpTy9yOwfMSPuc23jKPkyY+7ihjL9Fse7p5sW53hYvTfPuk5q7Bt+foaeIR1JFiZNzdT2yjqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nhTqSaIT; arc=fail smtp.client-ip=52.101.46.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nhTqSaIT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7swS0xnPbzA7iZw4nIdU1aD46wjxex3eANQV6Qw+91wwQ46bxKMjDOYVvH/jc7qjTkYA0V0H37s3I8JXPytYyC4hIG+0ekGX3zM39VmDSsGVMQHqc0df/SmYUpB1x3/mjCIzEusmBpCrGnk9AVBLASO0rRtxfHnWxMtUqXdwEBhGCj7IbVXoePJSwxkxu1GZ5j/41EKTOzjS5Yzemk2vUDsa8CdkOR9P8+sxvuGcf+GXzjQGQ8yPy1yjvK9GGRx2fiSIppvQI0AiPvvKZrV+9xETyDlDh2nnR1ttME22qNvyb17m9Ht+RAxXbmyhZvk0l32Fv4KOD5TL9TL1+r/Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTvdfpBoWs8oDJCXme72QSxJGZ5yTMlQEUbd6Bbkqts=;
 b=DngXVH9Bwrx8kbgd8rhfaspg/ZU8cPq4CKnZonEcLmIfI2JKGsN6B6JAqPEKqS9taj/v3x2WuzJRpX550Lw0IgvqS5etyGG2PYhqQyy05zgrEPxI5MxMkEpsyegOHjzWB33IKJKu0QdqrfvuwNlbVpy+CCHDHbed5PjtGPd6xaOkLKXsCDzhh4rW+cjrjwayCKvbj2afdwNIFPRMwK/a1dXiibb54EaLlThFasCG4qyagndnLjEGQfiDI9lWbPO4P3DhbuP14RyFpz11vw5TjEu2EkxHNxE/RjCqsATQXaoDHL+FkWoxAwX9nFyY0QbavRnn6xbIdelIXg1XDSWjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTvdfpBoWs8oDJCXme72QSxJGZ5yTMlQEUbd6Bbkqts=;
 b=nhTqSaITwrByaouCFwzmbn/rBwZfVIaW7zEE68q8Y3Yg6LNlZdT7SFMlrRP92e1CHTmcTqWTIZ7wjtSMjXYduhubXHp8D1E+gPSzGK1mqjBW+rIAkGKiJCwt/zTBIkp0w/QHQSXkXU1YiXvPi8GdgJVa/cVoCSQzCqcfEUoL+YA=
Received: from SJ0PR05CA0155.namprd05.prod.outlook.com (2603:10b6:a03:339::10)
 by MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 13:24:04 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::e) by SJ0PR05CA0155.outlook.office365.com
 (2603:10b6:a03:339::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 13:24:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 13:24:04 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 08:23:57 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH 4/4] crypto: ccp - Allocate status page outside sev_cmd_mutex in SNP_PLATFORM_STATUS
Date: Wed, 14 Oct 2026 08:20:33 -0500
Message-ID: <20261014132145.1726322-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014132145.1726322-1-michael.roth@amd.com>
References: <20261014132145.1726322-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|MN0PR12MB5716:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a8f5511-35ea-4b30-7417-08df29f66b0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|23010399003|6133799003|10067099003|18002099003|22082099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	zZxllqpUJAhRaePXULRoYUbY+kBOM4h/WNq7rjD20aMwqJlc1sGJ7O1J0zI7G564P6IRmWqYghyBR6DIdI9MgrrkNdc+00JRPM+EQX7lkHnltBrEIVVnKFw1RVJ6YvdvlVsvM/moM2kAOdbwTzy7Zft1+QWKjkokflstlMW3NWtrgbrrKuN//tz9grsJMTyM49uzZDrUYBrjhBI+6RKMfYYw0UZaSNXoVZVWSmbBbqxdWxe0e8iWF4nAyj/5ZgGaY7TkK/FPs4nnrZPSd20AI6IvsB849a0P7rKG/nGBtoUh034OlpkQpahoBtpEOhFFoWFKoTQJXL9oisoRncrRX+dZn1v9sifINu2eenIYRc1OzMmavPQNN9+U7dn7xOjK9UxbKQSwfOq5v42HsQEhbCrFYk/8XOHKK652OoNiySXCwUPTpGfxnsthibgpwbXwq0rLD6pwGgf9F93SS1VrSYs4v+GbhJQtjbLjcA4ppj63tUn9V2dHbiuV5piZc0kEZcrPVeTvnBfOWF74yy8EYqiHUz1qftMcDcGJQpaZVGDhTPo1gK8hv6UvrP2hNtutiQbjTsBWGw/eHD5lvCJfTrbZxMMVuubqqI4KblavqyV7EL0Jc7Q7hstNSwzpYRU4q0s0ngRgv/Jx7X+KRX2uapTNJS8V7evfQQg8ZdC8Eoy6wHT2sXQzNezuNrkuMVZSV3PIKeLTlNyl60IWrxeEng==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(6133799003)(10067099003)(18002099003)(22082099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DchIjLZAveF4YWZD57Dw6iU+GDLMfVNDzzSxUw6FttNgKQQCbyZlr2bVUEtFxPW0nydJ+Xsa8ZkLswU+vIiia3roJhG9GRVp0433n9w14QGPa1QpL0D3ksZAJCPtDyexsNQbGalHWBSKhiZXhWEisJJspdiNIkpxkS2k3vVJdBnQt32RTj8p8AEzNyb5YhcQ4DWCf51/doDSevDnzrKssQGAPVMDtMsPWNfKArhDXZlxqM6SWrwy9ENZ4SwQc6ufz5gql7lOl3/4Jk+FJDSHfmRq/CYOrDYqzz+L1Z0/O5xCn1t30Jyy75hm+TMXtHGbk4hkj+xuxHn3vLfVfryrSur7sCHMJbGnIJIrQrEpMt9ryqireEPXLSdHV/I+ptkpXLlSl0x5Fcn3Gp/INjrGkR7GmBzHcNMAobfJQhbz/JJ91jpsRhfrTPsOg1vv93Yx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:24:04.3161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8f5511-35ea-4b30-7417-08df29f66b0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5716

Allocating memory while holding the global SEV command mutex
(sev_cmd_mutex) unnecessarily blocks concurrent SEV and SNP operations
across the system if page allocation stalls or triggers memory reclaim.

Rename __sev_do_snp_platform_status() to sev_do_snp_platform_status()
and push the sev_cmd_mutex and firmware call down into a new routine so
that allocation/freeing of the status page can be done outside of the
mutex.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 60 +++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c8c229a6757c..37b948a81bc9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2554,20 +2554,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
-static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
-					int *error)
+static int __sev_do_snp_platform_status(void *data, int *error, bool *free)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_data_snp_addr buf;
-	struct page *status_page;
-	void *data;
 	int ret;
 
-	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
-	if (!status_page)
-		return -ENOMEM;
-
-	data = page_address(status_page);
+	*free = true;
 
 	/*
 	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
@@ -2578,10 +2571,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
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
@@ -2591,19 +2582,45 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
 		/*
 		 * The status page will be in Reclaim state on success, or left
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
-		 * transition either case back to Hypervisor-owned state.
+		 * transition either case back to Hypervisor-owned state. If
+		 * for some reason that fails, it will have been added to the
+		 * leaked pages list, so indicate to the caller to not free
+		 * the page.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true))
+		if (snp_reclaim_pages(__pa(data), 1, true)) {
+			*free = false;
 			return -EFAULT;
+		}
 	}
 
+	return ret;
+}
+
+static int sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
+				      int *error)
+{
+	struct page *status_page;
+	void *data;
+	bool free;
+	int ret;
+
+	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
+	if (!status_page)
+		return -ENOMEM;
+
+	data = page_address(status_page);
+
+	scoped_guard(mutex, &sev_cmd_mutex)
+		ret = __sev_do_snp_platform_status(data, error, &free);
+
 	if (ret)
 		goto cleanup;
 
 	memcpy(status, data, sizeof(*status));
 
 cleanup:
-	__free_pages(status_page, 0);
+	if (free)
+		__free_pages(status_page, 0);
 	return ret;
 }
 
@@ -2615,8 +2632,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 	if (!argp->data)
 		return -EINVAL;
 
-	scoped_guard(mutex, &sev_cmd_mutex)
-		ret = __sev_do_snp_platform_status(&status, &argp->error);
+	ret = sev_do_snp_platform_status(&status, &argp->error);
 	if (ret < 0)
 		return ret;
 
@@ -3114,9 +3130,7 @@ static int get_v1_svn(struct sev_device *sev)
 	struct sev_user_data_snp_status status;
 	int ret, error = 0;
 
-	mutex_lock(&sev_cmd_mutex);
-	ret = __sev_do_snp_platform_status(&status, &error);
-	mutex_unlock(&sev_cmd_mutex);
+	ret = sev_do_snp_platform_status(&status, &error);
 	if (ret < 0)
 		return ret;
 
@@ -3131,9 +3145,7 @@ static int get_v2_svn(struct sev_device *sev)
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

