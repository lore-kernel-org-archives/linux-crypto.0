Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794861403;
	b=FtjSReaW4vX/dMDYgWodC4NpA6wWdUyJj7RiO16tEiANijaATfJVXSLHnitEEZEjKqiU
	 e+RxIyRmIKTnefuYffvTnOib5KxRrwvRn7ghli6Pu2CqcNQUKpY8s+EVVuDDNcfnGaLNT
	 qWE6FO3x7CufrBA2houoLpOnRutbPuxBxQHCzfS9+42/twiNYUiOat5YNWYcz4pXP7bvm
	 CABxGRrfjrZ2/ViqhCT0TEeXcQp52hG40SqAxIbS75zFtcifxHpqXyedTjCrEcBG5yIV1
	 mH6bg0V4C/X1Q4bmd5Yj7Fn0i2Tdljxkpml8LVwSA5M3pqRK3wDbGXTcsf7wzMX9S6g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794861403;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=eeZOPO3QLfvWLA8CHiJx3zwNTnETF1XOOEPEFdBmXsM=;
	b=hdX7T2MH/3w2ziNQtDdy2XodL9wRs+eyBsYWJCn2ZC5h0BGGSY+gFoTq3aYfZaKy2dgv
	 pLPvr/DhdIfwxzGQDAkn31j+5Yyzl0ci4i4NnzvD324v4xzuDjCr/Cq/AoEA1cpbZrSpT
	 d13Ihhn84uEXzxBrcu8+inCr3XTEAPkKchtR+DEAZw2c8ccO+56hKz6UtHej3vHp2T9Kr
	 dpnYKSJisW5qPFBWzY59oBrpyqxnL4vednOCC1zzCXK2O90xhl6dRi95ybW8TrCwdqE9s
	 JM5MypCNWaofJQgPVLDGo7aik1SUJKPz31+uqXkFfFF2cCMsBAPxEDB4hD3K6QNzEXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=z0VoxvvV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.20
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012020.outbound.protection.outlook.com [40.107.200.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD9A606A33E;
	Mon, 16 Nov 2026 20:36:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFD9A606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=z0VoxvvV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UDv8T8hKUaoBXJDZbsXWXT2jnpJoSz3Pnsiin3uZpH8/zNYUwptWuqsaDY7oaMTB7DJRhvghK8SDqUlRVajMzs3wJbD3BjxgnxMk8vU9nFz0+CPtVVsZH2UZs1gz3jhBhguyM5TQFs5f9sfIYqPV5t9RSM+P3G6ew5Vky1sQHRH+VUVI/mvFWK1DjC5qBnKJsrFUmS1JpnSXQS79U7U9xZCbsT2M8r1w5BUUU0bcBOUDSwilUCdt6x1tmhHFltpUkdHdijflFY03Iw7gPVtMKbOgRNyBjtL7Ozc+okUl5lOSAK6vwldOvEMpw2bebuOFsHqE0zcTYjX7NF6zwiLrqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeZOPO3QLfvWLA8CHiJx3zwNTnETF1XOOEPEFdBmXsM=;
 b=aijQb12pxIOoFLH62LWo60FG+xFiXXJCo/2G+JSh9/nd2dZjF+8PJ6vGATM4UnLUtHrQUNaraMIc+OZzcxN5myKCRpzg13+fnt6H4a9/aFLc9nCLlzGQQZ8ysxsoq2qirLWclK9vjUeg992ibQEmR/tY+RszYYL82eS7PDytW7Dct1+uAOinBBETcD2KAIE2aCMjSPMXXZME0S48WZ2rj1OqxOZ2HEhcRgXrbVuqs+SP5ItfUwp9PDfCxJ93xeODoQ+SRPVJY/UENHnol1uLCBYcfY11/0NUg03lQhcYakBJmW2KUBBBY7+RzWkwhaBhC6c0N8O5nK1jad6cqgOasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeZOPO3QLfvWLA8CHiJx3zwNTnETF1XOOEPEFdBmXsM=;
 b=z0VoxvvVZc9IBUEZ+QtRD361Fmbbe9N00+oBJL/ro71EiXqy+/JNb5SvaQ04ovybE+nMYaKloKSxUt8tu6+EIBNpfMJbT6/U4qcMS+bX7wrONiOn1NfIdLBJaQ91b+tu5xyYbeVbbrKCZPoC4ZdzNUEO36fga86xb2JijfEoQeY=
Received: from BYAPR21CA0029.namprd21.prod.outlook.com (2603:10b6:a03:114::39)
 by IA1PR12MB6209.namprd12.prod.outlook.com (2603:10b6:208:3e7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 20:36:35 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:a03:114:cafe::af) by BYAPR21CA0029.outlook.office365.com
 (2603:10b6:a03:114::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.0 via Frontend Transport; Mon, 16
 Nov 2026 20:36:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 16 Nov 2026 20:36:32 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Mon, 16 Nov
 2026 14:36:31 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: <kim.phillips@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
	"Rijo Thomas" <Rijo-john.Thomas@amd.com>, Mario Limonciello
	<mario.limonciello@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sashiko
	<sashiko-bot@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2] crypto: ccp - unwind PSP sub-devices on partial psp_init() failure
Date: Mon, 16 Nov 2026 14:36:22 -0600
Message-ID: <20261116203622.615371-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|IA1PR12MB6209:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d09d3e1-5780-4955-0e61-08df44214d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|23010399003|82310400026|261022105027099003|10067099003|11063799006|56012099006|261021123027099003|261009221227099003|261021121427099003|261009223027099003|261026140227099003|261102123227099003|261026121527099003|261028144727099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	6IkEuJCr7I00dAy/CDXk8JTNZ1Fo4+S1ioYJ+iJln1LE7kg/risYLPnXLU4xiiLM/tVWRvvzZp1t2uZrbGgT15ncsWI9t9bU5iOnv9uDyo24O2XTHwb9Z6M8XNxy52v8KiaUQDXeV2zRrdI+v/ZqlYf8z09zplTZ8fMDrMVyxP8Ak0UVAjzfKruXdzvHcNjwCLz/sw/J83Aq6DLzn9zOBj/Z8u3fxaIM6eeOcFQvApGGAzwT4naiVxSxIa/s83PS3WMm5wxRps9NeATW4Yi05jPnEGx6MXrkjsEw8EnpVxkeoVSdnTAo19inF9o46x4eD6nWFoyo5+6R0T1dIlaGrs5q4v3y/ZfK2T6ZhZxBr3OQ+potYIq2MBz2Py1WhGE02b1pktd5L82jJCoiMtPtWnimzLC5qPr6bwsK0DxTnOO9cm1QG3GVPypgQ8ms1fNYvy7AdWg7ShpEhj38JB6pj+ntOnTWBAdjT2Cpa6pK0D20dROab+j8wQoLD+rGRovaGGHwHafyvVYVjYN29HWfanY7vmZ+M7A68/A5tOxykfC2+Ricon756588n+NtpeccLMenAuEGoZ1pxPjxbSb3z+gI+zjrNhVL2wYEjsq3Y9EdSPfh2PE1c0IF3YxQpwuI25zM2bZytgLJV/fuPOCu+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(261022105027099003)(10067099003)(11063799006)(56012099006)(261021123027099003)(261009221227099003)(261021121427099003)(261009223027099003)(261026140227099003)(261102123227099003)(261026121527099003)(261028144727099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sIPgZsKkkZ7UalOtI9jiZxdhDyEDeCKajNwfnuncbO+YnxfM8vMzO0iPHXcIUnfwRgbF7YfNGVhhJQ9tn98rMxdGAtyv3NmUjXiA5RjA2K7HW2EgxpOs8bxnFjgzw+e5udHSsyfuQJbCTsgLW5vtpfmKGDlaHI14EBzMVSUgQyPvt1CzRIU0oKXlrqPBiYKeyk9u7THk+O04VMzl4g0BI9O8vlSjUndxUypNsqHI239GUYRk9o5tA/+tb57jXvCp2sk9nuIx9Fjaoxd1k2xuR3WZ7sjmrTgqD6RJjyUD2JD+h3Lb0dFzBx3GPKLMj20qvUpOnw430LY/fNAAnwXLVrheWc0g4jL199jQXygImvndKgUEv0b2cZzVpGfUbwoZfKV6VbrkGp/Zgf8BZj9OdP9WEuUCIuOtcC9hwVIlomRBgQzEgaiIUkI8awXu8tzt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 20:36:32.5885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d09d3e1-5780-4955-0e61-08df44214d08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6209

psp_init() initializes sub-devices sequentially but returns immediately
on the first failure, leaving earlier sub-devices registered. Its caller
psp_dev_init() then sets sp->psp_data = NULL, so the later
psp_dev_destroy() on unbind bails out early and never unregisters them.

Non-devm resources such as the /dev/sev and /dev/dbc character devices
stay globally visible while their devm-allocated backing structures are
freed by the driver core, giving a use-after-free if userspace opens the
orphaned device.

Add reverse-order unwind labels to psp_init() so each sub-device is torn
down before the error is propagated. Every *_dev_destroy() is already
NULL-guarded on its own psp->*_data pointer, so skipped or unreached
sub-devices are no-ops.

sp_init() continues to ignore the psp_dev_init() return value on
purpose: a PSP failure must not fail the probe, as the CCP can still
initialize successfully.

Fixes: 33960acccfbd ("crypto: ccp - add TEE support for Raven Ridge")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-0de87f0c-0f5a-4dad-8ef1-f49844eb4cce
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v1: https://lore.kernel.org/linux-crypto/20261021215716.1076732-1-kim.phillips@amd.com/

 drivers/crypto/ccp/psp-dev.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b14ce51065d5..3d9341c2876d 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -207,19 +207,19 @@ static int psp_init(struct psp_device *psp)
 	if (!psp_check_tee_support(psp)) {
 		ret = tee_dev_init(psp);
 		if (ret)
-			return ret;
+			goto e_sev;
 	}
 
 	if (!psp_check_sfs_support(psp)) {
 		ret = sfs_dev_init(psp);
 		if (ret)
-			return ret;
+			goto e_tee;
 	}
 
 	if (psp->vdata->platform_access) {
 		ret = platform_access_dev_init(psp);
 		if (ret)
-			return ret;
+			goto e_sfs;
 	}
 
 	/* dbc must come after platform access as it tests the feature */
@@ -227,15 +227,28 @@ static int psp_init(struct psp_device *psp)
 	    psp->capability.dbc_thru_ext) {
 		ret = dbc_dev_init(psp);
 		if (ret)
-			return ret;
+			goto e_platform_access;
 	}
 
 	/* HSTI uses platform access on some systems. */
 	ret = psp_init_hsti(psp);
 	if (ret)
-		return ret;
+		goto e_dbc;
 
 	return 0;
+
+e_dbc:
+	dbc_dev_destroy(psp);
+e_platform_access:
+	platform_access_dev_destroy(psp);
+e_sfs:
+	sfs_dev_destroy(psp);
+e_tee:
+	tee_dev_destroy(psp);
+e_sev:
+	sev_dev_destroy(psp);
+
+	return ret;
 }
 
 int psp_dev_init(struct sp_device *sp)

base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
-- 
2.43.0

