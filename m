Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011066.outbound.protection.outlook.com [52.101.57.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8196739B978
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335798; cv=fail; b=HYpOl60oGd/UcpRvO00Su9lSvs+KwRgwGAt9qgMgXJZ1193kWG7Fo5o4HZpRIN4azu60RRA+VOpt0GJT7hXT7N3JJL+eUABgpd5tS8qf/82FU8N/oEzUYFIQ+DDtm4lyiSBDu4Hxwtw/6YLa3ff+YY1zc3Cy6D/H6lSFV6KkxK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335798; c=relaxed/simple;
	bh=iOf3DRCC97pjpNn3qRwyCOKeaxefvmaYWBS+bntFh9Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nFGZHB9D0uQdtDvRb/Q583KA61jWRnyBu2jFggfIkiFn1Nw+U852cGT7J4UW6PJpU2gYVCUSkxoaeRzOEjTkVHfd7vZtUmHsbrCbkapBsy5JoxV3V2HnXMVA88EdfaCloN7i69JLxD06tyU2htzJYEqi/NZBxUYkB4nfxs67Z6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FWdYkJYV; arc=fail smtp.client-ip=52.101.57.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FWdYkJYV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n08jtYZVe7mBbcXFkzp5jj8UBWyMBDm02iDuyP4WuqZQa+tyIJ0dNb8r/rImC/Egm4iy8Jj10vj2gdWYtD5c0zBuUZdgwHxqHtcYSYGJS8fIG6H7/TzOlIo24g+qR6i4PU6Y0mDuMoCEp8TOLuaCv97yJXsuctoYGfoeshrUxwWId0jjCW0KwUY4Z62M3xN0lB7JSOzVWg9PIGUE++DKanZwKdm3HSlNEkkEP0YqK4cSfOjQc2gpwiNYrpTKNzwfNFpGfsxT8WNBNbfucmbmWkrbZLF235tIqGmk1Lx6k70J2fPzR+bVfK8wY9Pn6ytPiIOPk/SPOCCOifASXINGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtTiTi0EMVnrgCpWmStiSQy8pOqWp9PWWZKl6TR2Ko0=;
 b=hlfVcg3Bqps4xvua4o0zVFgVZWfo5/Fv/Hkb0r7zFH+efoE0M2EkjpBDghXX/IhFyJh/FHZB/5z1GTqRHZdwlQyBWKSUL7bODWMZdg2dKc6Bs6MZaE2qAnjijpYHf//lVgnxSVGAN4y23tiwdUnyl/GRsA6Ofh+MG3W/M6k/pelMLj9qWKETLk4Cewa/oB9CGkJvW7uPSbZl3u6nMDRWVUyKE01d4OgW1vtFQ8Aq7hDDypb36CzsvPdI/ma1OXdeExHPY8bUVoMIkDjAv+c+Nyh/lXHNv1N5qM7tdEzjxu06MzYTocrf0sTlSBDnnOskhixvfW4NXsuEKE/mLE0KMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtTiTi0EMVnrgCpWmStiSQy8pOqWp9PWWZKl6TR2Ko0=;
 b=FWdYkJYVBge6kPTtJSS+lENYxG8aBjlxXPMeGzo9aKYXhtoRizq3VEGiUnYlglGdtfc+o/nShHRT4rTARSLz8jZCpqy+Hvy7q/+Dl4GoFJX6iGqxPCyVAEwECD0Hsmij3av5FZn3RFcoe6G0KRLgB1InTQh3n/ePhECFJCx3z0w=
Received: from CH2PR15CA0012.namprd15.prod.outlook.com (2603:10b6:610:51::22)
 by CH1PPF8423FDA82.namprd12.prod.outlook.com (2603:10b6:61f:fc00::617) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Mon, 6 Jul
 2026 11:03:14 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:51:cafe::9a) by CH2PR15CA0012.outlook.office365.com
 (2603:10b6:610:51::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon, 6
 Jul 2026 11:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.0 via Frontend Transport; Mon, 6 Jul 2026 11:03:13 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:13 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:12 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 6 Jul 2026 06:03:10 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 0/3]  crypto: xilinx: Map PLM error codes to Linux error
Date: Mon, 6 Jul 2026 16:32:51 +0530
Message-ID: <20260706110254.2427551-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|CH1PPF8423FDA82:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c19e90f-675b-4522-7579-08dedb4e2c70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|18002099003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	jbH7mAOt7oeDVol3omBiyeFR5x5bE/f5cHYOzRmzpuUZFFGe5g3LGooMbFHHMiQRfer87hW61VM5ktCk1emJ9FSpr/jUNpWbc+JIegQFS+52ztqhFpW5xSv1r2N6dICsQaB/vccFON1gYP3GTjVNUiRtmx89LAK/kzbn+JkCzl4VHNv21qISGGzthOWqLkxzqpIitY1GCvxOu2r+nsbgPcJHwFzr2SV0YF5B0BqlCs1rSLHEn5xsUvfBH2Z1LccQxwbYTJ3dIwGhrZte/7wx8hfKV7Qf3XnYfJZQpgqxnmG6eWKlEaWEi/Mu3kHtUIigfgL3dvEU0ZgQW8IlJZoFFV12+7NQaNLy8dTSTMoTI5KFmeMTsMen8QpySaYvsNCPsxEY7ldpPeragKiOAaz52unSzsKSpVKPORlsKO8au/3LRFc3rruRIbF/Xm3p+6tTdf84XqoHE+4KVFKwetGyfctvknWHiqKTawond6Gw49CnHVQxwa5iLPykqOThi1/r1TfXh1UVMCdk+Whdo007WArWHi/cta8Vlo9ApbBZxVTc+7pzR+D6Yzd/f84kBa8nAMjD7HRRr+V8Aak9CXNlh2y8lMmQ7ttaQ+aqlqA/95q0joVwx7pjkN3ldtkjZjgHsgnbWw4fvAXrWOq0h4XehAJgMnuQw7RpUk3LMQrNEX0bhfZMVkpQ/Wi9hRv9UIhw
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(18002099003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/R4rxsWC/myzKr/9lI+7cYSLH4v2qccLjll8+Ye1WM7yOtWvwaHLHVKAgMm5WMFUznqVwMCNpOEizCoIeihuXkdrtXtNkwVsoY0mLcqWOeLIvxH65h1qfVIvKdLFSclAmVRnkjSKThX9o7UZSCvovQl7Lx9ZUw9wvp8WcwdiwG6uIPqrH2KtA+EjYA1gkiBvygLGqlbLcph+pg4HQuZlJBk/IGP4a/4eZEHqOHhlJcu+aTRHrAYKS+HwlSuGtxpniL3zwSq2wGyk082jjMBH4uF3yvBBlW525aawL/CnhOg1djn0OLEcOTdA0C0mqDmw1WarcIUO6eWpSBBODxLBj9OzhblMo3LVzJyr8SEp50G8QLVoyimlfYgaRL7jHEm+mFRYAm7rnavqUMJEI6wxzMT2pVJgesUfpHqrDh+bs4vC+o+onnEosS71GRQsuAQR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:03:13.2353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c19e90f-675b-4522-7579-08dedb4e2c70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF8423FDA82

Update versal firmware API's to map GCM engine error code to Linux
error code.

Harsh Jain (3):
  firmware: xilinx: Rephrase documentation of aes API
  firmware: xilinx: Update AES PM-APIs to capture PLM error codes
  crypto: xilinx: zynqmp-aes-gcm: Send firmware decoded code instead of
    EBADMSG

 drivers/crypto/xilinx/zynqmp-aes-gcm.c  |   4 +-
 drivers/firmware/xilinx/zynqmp-crypto.c | 115 ++++++++++++++++++------
 2 files changed, 90 insertions(+), 29 deletions(-)

-- 
2.34.1

