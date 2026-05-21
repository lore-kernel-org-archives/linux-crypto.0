Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEA839D6EE;
	Thu, 21 May 2026 07:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779349406; cv=fail; b=Oh2zfvUMugYSSwS7XRM2qp3Bvk6V5r9WybQC/4eTBp3mBArIAGLOJy3znMLqekYzUHmQ2nQzHC6wHgKOqphlpkEPmKDVdwMLX11hUCvwGaPAO7iCQfzbH1fkjIrRxnX0BLAQmnEh0J1uzM56iYvG9NRqAVnA0OC++8LdSRAg3rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779349406; c=relaxed/simple;
	bh=2pt3o7rnn/j/FskeBkOiZtXjk8L+aiXT02zEENIlEvw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MZ2npM+14aeYm1v2hsIo3Urd+UODyYwrLvwV11S/S9rkoLSBYz5u5Pw0x3r+lHtNzGrCg27ek79jn7ukM6r2l8FBX4LKBRdv1WrYzvv1z5jMJIkbtfWIdWSZRYawp4h0B3fLodU8IFsyq1gFSiTVIK9FzCilWJrKpafyB4jKyw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=injCpeAm; arc=fail smtp.client-ip=40.93.195.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="injCpeAm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RoIeaD8UkA2nmQCSDk5L00Q9ooy71xDTUDyp/dyg4ydbQO3M2SWNs4Ryt7IKr9yTojPVL1n77oxz5ZEUTYFhaqtSGBKVb2V3WdUoyQg9PqkUPqRTzeYAXpYMqGAn/gleU6VhDhPFN0RL+0120ZUdt1HACkH5t4SuV2YH6QuWxGB8D2nvVaqtDK2bFUq3OlDXZanplyVt5L/ttcslhZgWe1mBaw2aZa+KQJfqMo6GGSkigIjzZ7EQJrp5Hkxr0UqKspub3b3V6KGm8NnZHaCxzkLG9S+u+W12lqKMDlnKG5E9v7HgU1SwIx0qVX625aHUM2m+soMu6prfyWvbHa3Oaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4e+mZGiwMdyAvG2qK6R3pjHBD0djoN9tKWfnnGva8U=;
 b=ViyVjerNbLTfXbUeFyAusaZlp3lsloqq631I/s5L8UuM9u8M9fFcRShM+agolM+WeyTz+uAmCLOCyir91wZpPB28evBNgu6+QGeI0uySoMdSIUGuyUVkPevDOlUDv1ROGLlnBK3t6t9QM1jkosBeAIC4sKeSb4YQ7kjDiDPxPs/xYK7gPXl2AyqUaQ/UO3akg0vQyFTHvuNCZK1QeF/L+YBFGis6l6EfSr15ROkOnDUEhBY/0gnnU9eaF13C9z0nFxH9SIUdFA7bUtGlzGEuGAN4IbjAqzKL7idLwh+RBclb5NNAUSdmSVkILQSPTt7jWt/HAl4QkvlIvWG5b/HT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4e+mZGiwMdyAvG2qK6R3pjHBD0djoN9tKWfnnGva8U=;
 b=injCpeAmy+up3u/1pDArAb6aCKxCs3AFNwsBYddHJw2yG1JzREIWQlwdIw/MPUGqCZS5g8Qnbmtg7kbOnLKlDTinAVZqZ6MhNtylbvBg9BXkGmk5fzTWVFMXvIVY7s/QMmzX4g/Rn0UAFpeU21Acju6LcVFT3xcP/jQPzk69IM0=
Received: from BY5PR20CA0031.namprd20.prod.outlook.com (2603:10b6:a03:1f4::44)
 by CY1PR12MB9603.namprd12.prod.outlook.com (2603:10b6:930:108::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 07:43:20 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::f8) by BY5PR20CA0031.outlook.office365.com
 (2603:10b6:a03:1f4::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.17 via Frontend Transport; Thu, 21
 May 2026 07:43:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.48.11 via Frontend Transport; Thu, 21 May 2026 07:43:19 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 21 May
 2026 02:43:12 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <djbw@kernel.org>, Alexey Kardashevskiy
	<aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>, "Pratik R .
 Sampat" <prsampat@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, "Aneesh
 Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH kernel] crypto/ccp/tsm: Enable the root port after the endpoint
Date: Thu, 21 May 2026 17:43:01 +1000
Message-ID: <20260521074301.2369293-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|CY1PR12MB9603:EE_
X-MS-Office365-Filtering-Correlation-Id: c09e7ec3-a2f6-433e-067c-08deb70ca0b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|6133799003|18002099003|56012099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	WDoqAy815OctFyB2+nNemu/A0hM48lRZp3hGL+M5V3hRRLpJGMqoXG9azDas9K+oFbQz83m4/IbkO8LGTTrWuEQWanIivIlyqi5VXI8ScLeaSyBVgse5LW0biXrDvOSVhCFUMRvzpfgf0MGdm8StipQZyQ8iVrgzw8MMX6E4i8blSBWuKSsoXJ6QWKmuao9pFTn/UIg2xg43LKkb8TX5l1oqy1gTuot8inXTTMtyPiyp+yReuXviBP3A1Lfy4hanTMALRvTo/j9WjwR9UcIXxzm/vvtth8UhfQeCTEU3dETttTSe5xaadb60gbUWn2eS6h/slGNIimgA9xsA2BPgstPB6qooOGK1/1XrrbW8tU8QA43BpwlZayB3nwzAWN2h/SM7e1H0NklMxzKaggg7cJTDCSjimPb052fbA3n81lx1+XQu7EM1bWPgUFgXwfkZU/R/PSdvcQn72jldWJqTAZeZdWPiCNQL089v+zagsinUsEI+1M9F50BoB5Gofa2dr65DKaWeftE52FEPO2M40UFrgeTv80o37YD1Z97naFaxeukBzVU25zq3CzLyPxDOJEeUcfyD6IqIBgcoBx4MWPLEis9w5ms+RFw4jymECfTgHlaQrBVvaPXfcAJN9asCi0pTWkkQrcGrCkwn0mxoCB8KzmkThtZHFi+LyBfZf2Q4kXP/skiSBBh4FYAfWjYX3bia9PNaVaDQulnV7ZeDzN2EW8KPOwaVm130pzjjQBg=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(6133799003)(18002099003)(56012099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	32N6BR3sFhDhiK9m8+ZXH21aGk1XYpPA5cKceE08GZVrADHQqpK2fhuc/7L3U/u6fulrSXO3G5gEONFiOzBunLVXX6ClX9Rid/IJPxdXvtRO35rScKLXB1yjIjOtuMABi0YSq2XUkQ/qvl0u9fK1lJAzLqW3D8GjFlrkvlELcsxwlxdvibV6O159C95ir06V1spR7gE3rhNhR8JNTccZtWhn3Xr+pQPGUZRLc4PiRKA31X9AUlOvrPkCnAVO9sKf+KyULW47ZGkdr6S5Yzx3WJihVTtyvcd8VxMnEUtEgbWkQ9+rdI+PaNYBjwtT8JtTzmGRK6y+Nu3ckV0ModkxPw/LBwo8fk6OebEA7nAj3pjjsiZJVlYUfgIaTA+CPmOS3pgn1G9ZyxppShxeJKf55NguxixxS8DNHWlNfN/eIDvfoxw7Az2U7WMZtjWJcXv1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 07:43:19.5214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c09e7ec3-a2f6-433e-067c-08deb70ca0b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9603

The PCIe r7.0, chapter "6.33.8 Other IDE Rules" mandates if selective IDE
is enabled for config requersts, a stream must be enabled on the endpoint
before enabling it on the rootport:

===
For Selective IDE, the Stream must not be used until it has been enabled in
both Partner Ports. For cases where one of the Partner Ports is a Root Port
and Selective IDE for Configuration Requests is enabled, the other
Partner Port must be enabled prior to the Root Port. For other scenarios,
the mechanisms to satisfy this requirement are implementation-specific.
===

Do what the spec says.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index b07ae529b591..10549a2cc2ae 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -58,13 +58,13 @@ static int stream_enable(struct pci_ide *ide)
 	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
 	int ret;
 
-	ret = pci_ide_stream_enable(rp, ide);
-	if (ret)
+	ret = pci_ide_stream_enable(ide->pdev, ide);
+	if (ret && ret != -ENXIO)
 		return ret;
 
-	ret = pci_ide_stream_enable(ide->pdev, ide);
-	if (ret)
-		pci_ide_stream_disable(rp, ide);
+	ret = pci_ide_stream_enable(rp, ide);
+	if (ret && ret != -ENXIO)
+		pci_ide_stream_disable(ide->pdev, ide);
 
 	return ret;
 }
-- 
2.53.0

