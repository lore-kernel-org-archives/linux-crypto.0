Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EC555C329;
	Thu, 10 Sep 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059805; cv=fail; b=hLeQ6IfaSqhR7S6NC9PJM5cUhsUUzrdtX937QWARzMvVJjmbFBtK5zBQka5mTPvv6118ecaZTjBH0XqgP3Pfy/GevzHziTinxL3kufsKnWcAISRejmFj5JDV7l+4fS8SQiPWOi9BBQVteO72MwutaG6VTr2fZUq8pj5Z0VNecAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059805; c=relaxed/simple;
	bh=GTlLBdeLAgc6tq3dZWi/wBPVSeyahCHz4UI98GE9JqY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YFkzFbWfWPq2qyMQtZZ7FgKgnTq97+Ws7VdgdpbU48VProMhfGhFsevF/oszN192+anJonI+mipBxkYxGEr/vSJs7Om9isPDxLD7wRZFAa4W3e3LY3ZMtbbuP4YOBGdS9vupz8oJKn7FM3hF3X57JSVWPeNT5uxZL7edJIzRQlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nS07CA6F; arc=fail smtp.client-ip=52.101.62.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nS07CA6F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NRfMsG1FY0y3Z7pCCtf+sK5mz4R2v57qkCEFDanUfqm0XIiIfCxintcI0B9nXUxEqeCgsCmbNOvhhUfkKd+A3e0Bnkpg9NKS4vOxsBndzGyA3ftyxxMNRggNBfDE/WagUDVhG58ADAVuS6Rr0jSrcGwFkCX8ETm32remYTw/gRE67bCUv6bTu97iStqJckSOFM/1WW/v+6tBGbjKCEg34iflLMBOCmqTha6wHOjuVMjJWWE9s21NuSg0eSwzsZRPHlm52akP2xFwMZMtRfWSfodVhIv+tHMHXMXIMJzzsfb24EYN++gZJl4PJRtO7zd9Doxbcl3pbzuqzOmw2Kyu2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=dt578Hx2keRmyUMyqhfPX9FuT4xrMF17IfRw6K/ZqfvrvzEFkvJG6HvxCSvgerWRSjVkjVKgbWhEZZ7UvVYmphLHymOLfHgBj75b15wVhTMJ58CaFMN5Os2/CkRiqPJnAopxg9ScWhq/LbMgnRDwG/M43VdT03WG/1hmw3eaYz1vxnqXTFdfr3dsckBWLKRjmTXKS55YPsDwwpYyoQr4TLdZt0oRN51A19fYhVKWGkoV02z9s50AQwNMOQDHc0dZunS0egmZL5GU9E1xPyI1e//vhm5nOOH+HjrXRVx2PScFzFSkKiq12ZRCG6OfB5XkruHpgQsss2lzE+ST9lOaGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSU/TK891p11aT2gEU2Zcn8LN3F1xITGAxP0LT/EZ+4=;
 b=nS07CA6FQUl9whYoYY9cTth2f30C00CP0vuue1f9dKJ4B/WBMvMQKpeAbcvvHIUqsbPKGOLleUvRyduIqVxzhK373ebE2aroE1mIOLtNJQR/Kgr6vzw4khnQZIPJFU4+AoRWIUOxvGopwXWU/Q2wC96O9R2p3P8jBVo1f5SSOCM=
Received: from CH0PR07CA0024.namprd07.prod.outlook.com (2603:10b6:610:32::29)
 by IA1PR12MB6411.namprd12.prod.outlook.com (2603:10b6:208:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:02:58 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::6b) by CH0PR07CA0024.outlook.office365.com
 (2603:10b6:610:32::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:02:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:02:58 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:02:57 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 4/7] crypto: ccp - Factor out the release of the SEV firmware buffers
Date: Thu, 10 Sep 2026 17:01:59 +0000
Message-ID: <51d7f3c5ddf9f8c5ca0a163a7fba7d26267cdf35.1789059392.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789059391.git.prsampat@amd.com>
References: <cover.1789059391.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|IA1PR12MB6411:EE_
X-MS-Office365-Filtering-Correlation-Id: c24b66ec-dcb7-45f8-55ef-08df0f5d5d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|7416014|1800799024|10067099003|6133799003|22082099003|18002099003|56012099006|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	IhrX95fLligJveg/p7ByEc7VxkXk6UUuRb+5t6jtcLLEkq+zncKUU1aEs+bS6aonwI3cujDBhEb58KNb2sA4NhU1CNsWYSfpsInEHcz9gXga9iKiXym4KqAsHYG+LW4ECPtWzK1REMlBblExfClbx3l/u1TuzWNfIWBeaHh75LQykPlKOieyMT2b2pEHWxuANNxS6digHHNB7dYXclUD3/aH1FWAMqJ+CzCd35EZoDt1ITg698cWiqU9el4AQ3wS+uOEtvlRGAhbtCeQh/BZ2JgzFpxdABPF9B37w5Y7YZoO8nOZjzbLDh98Kb2X3B60+RxxQi1XJ7ouKsi2CW6FAGKWNSzV/H00VSv7ksYSla1ZzhQYQzZHvYGozA8HjGlFH9QUtbcqXsuCx8ViD0t6+OsWPIHxiAAjQBodhuw6jz47F80Ih84BECz538o/rAralt1Vr2s2L623HyzNVOmc8oYkQn+iI+artdj6M46caINCaAF2z8N/WjYmY0JvaMRiMl8cr9PYJfvwIKl08hQLu56zehFxwMF+IzJoE1RjcELbK0fXt8oq6EFuzHIuFhJjt0upTa7tZJImFjn/3/9gqdIDgO41rd8TPJ7xg/8mvSc7ocwU5eoSdWbYT3qx/jrZRCCqyGS+bDRjn8mBa3nsmsQL6d9YGclp9lQ+1bfJsjXTapEgQ6Tgid1MWiRiGUm0eaVqLxT+RmFuJ09UoATcLA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(7416014)(1800799024)(10067099003)(6133799003)(22082099003)(18002099003)(56012099006)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mtqFzjYWfdn4NpBRGQRYHaA2Qb54zx12ATu8K6Iup0hThOD+E239pcGvcLzWxNXl4EmjOcwVja86ZgYbh8U9gqOkp3tnVcgEg1bclza9VkGQua+6x17owo6yGRl7rPaVAXuXROOUWEEp5Fm9EEUL9p1xgYIoGaORrguPPdXgZDPJydCDwkOPp4F5XrVb6ki3RwfKRBjN79tnSU1CWm9V5o6YuaqsDWVbUSa/HctoDWcpzh3MzJB/gtFzoIVKiGbumJlukWebYcNTs6EXjcEEVmZp1t+GWwIFiUc67PvOCsWd0Qzg6iFkGjZ2uDSPcE4a/Gh+bQH7ZwNzsngQF+Y0fz+1BPbsPe0u/mPiFwJGxyzasYys+pX8SN1JVFeaVCc4aMMKnU4qK5Az+0OKUhsdso7U4j/2aL+C+FpM0dBtbVt8p+5F3WZB4VDGPIZL8kL5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:02:58.5921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c24b66ec-dcb7-45f8-55ef-08df0f5d5d97
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6411

__sev_firmware_shutdown() reclaims and frees the TMR and the INIT_EX NV
area once the platform has been taken down. Move that into a helper so
that other paths which de-initialize the platform can reuse the same
path.

No functional change intended.

Suggested-by: Shantanu Sinha <shansinha@google.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 55 ++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f833cb7e4da3..1ed9e61a95cc 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1881,6 +1881,35 @@ static int __sev_platform_shutdown_locked(int *error)
 	return ret;
 }
 
+static void __sev_release_firmware_buffers(bool panic)
+{
+	if (sev_es_tmr) {
+		/*
+		 * The TMR area was encrypted, flush it from the cache.
+		 *
+		 * If invoked during panic handling, local interrupts are
+		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
+		 * can't be used. In that case, wbinvd() is done on remote CPUs
+		 * via the NMI callback, and done for this CPU later during
+		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
+		 */
+		if (!panic)
+			wbinvd_on_all_cpus();
+
+		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
+					  get_order(sev_es_tmr_size),
+					  true);
+		sev_es_tmr = NULL;
+	}
+
+	if (sev_init_ex_buffer) {
+		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
+					  get_order(NV_LENGTH),
+					  true);
+		sev_init_ex_buffer = NULL;
+	}
+}
+
 static int sev_get_platform_state(int *state, int *error)
 {
 	struct sev_user_data_status data;
@@ -2906,31 +2935,7 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 
 	__sev_platform_shutdown_locked(&error);
 
-	if (sev_es_tmr) {
-		/*
-		 * The TMR area was encrypted, flush it from the cache.
-		 *
-		 * If invoked during panic handling, local interrupts are
-		 * disabled and all CPUs are stopped, so wbinvd_on_all_cpus()
-		 * can't be used. In that case, wbinvd() is done on remote CPUs
-		 * via the NMI callback, and done for this CPU later during
-		 * SNP shutdown, so wbinvd_on_all_cpus() can be skipped.
-		 */
-		if (!panic)
-			wbinvd_on_all_cpus();
-
-		__snp_free_firmware_pages(virt_to_page(sev_es_tmr),
-					  get_order(sev_es_tmr_size),
-					  true);
-		sev_es_tmr = NULL;
-	}
-
-	if (sev_init_ex_buffer) {
-		__snp_free_firmware_pages(virt_to_page(sev_init_ex_buffer),
-					  get_order(NV_LENGTH),
-					  true);
-		sev_init_ex_buffer = NULL;
-	}
+	__sev_release_firmware_buffers(panic);
 
 	__sev_snp_shutdown_locked(&error, panic);
 }
-- 
2.43.0

