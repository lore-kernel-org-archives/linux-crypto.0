Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.36
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794954000;
	b=Q6rkCV0rb5SkQEUKfjnFjDshis0jL/aT2ZA+cvAwc8z/EK/rowblFC+0uJxOEwYGVcLk
	 LHXSGUYbja9M0DVzoaxWEjV0gL76DE6GodtMiqbf4e6A/klK8GR1h6DTw261QJBAa1tnK
	 MFB0hFFuAucFajMCL0RzI9SGQzkrwpYOD1gNGY8f9ZeipjpToWSwMuquzAcgfwx4sWGCd
	 16xmhM87iaxKjllppEiNvo4e5CRbHsmUzACOBsGpHjITKUAK5X3tYKsdm/DaczD3o4ULC
	 PKvjk82vW7IKpM/tJYVMsTzOerfu4LoDLO4nOKnqjY4A7bLJgq25xGSynWaa5ujVZlw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794954000;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
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
	bh=vZITBorG07bq4a51NfMZfLBtlf9HiVD+J8e5SteS/kI=;
	b=5ixvJ8zGIhBrpjUSWdQfaeyLJzuskn+8832cAC3ISv6fvnrQS+Ex9+sS+oPcRG/WxGD5
	 LZh80kgZnp0smIpbVd/vwwS1W7B6l0/HhU2wTlwV1ROC5p7Mv6RIOm9LH1+ZALZVMbz1j
	 vzWYFYrkopUAlkseu+fvdOwXH3SdxuqZK2J/7pAV+UThcNXErCHM5+Wby9olJhxRBYw+B
	 PGvDstJSq/Qm6FIRxdI14VRpXDDATOiSnsDbCZw6GT5MSYlp5h8Mk6t8YascuvzSGPiM1
	 k5wRxrZYEpTmmaeVuXsurq/H/GTSLCmog06YrRv5vAudapN7SATocjyxjyguvtOotog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=f3cZorgo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.36
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010036.outbound.protection.outlook.com [52.101.61.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4CA606A31C;
	Tue, 17 Nov 2026 22:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA4CA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=f3cZorgo
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dUbTRp/6WvA87euI+p89S57Is8cleQLnY+uszjnCyZ44QDCRJmhc7wa7yXERGpoJcN8GpBmYA0mQXWURTuzvYl+JeDScMYORs8w1w6mou+MCalb+/0EEBr1M4tQZU8rw0AkvfuUaxsE774uF3naE9/jZceKX2UhU8Gu4D5FB09/u+hZGWAJlPjmoy3m7bp4SnO8Q4KKX7y6n+lt/LgUe818TVaiGlG4u10NlrchUrEbAInXdseFxH91bCYrbD9AubOJamvPHxpLI8T7lOCnAeJuB2muRV3h0XUbRxadKOFcNmoiy6vCd1r233somdAIfqiNfMjAe+A77DT7jwntPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZITBorG07bq4a51NfMZfLBtlf9HiVD+J8e5SteS/kI=;
 b=zD28m1A3yEIbksyiQ3w/F0lWXnh70l2QrNwuBgOC6BaSQlL6HTl9unxxUbNnWoUvdDloMd2uhLPvQPct63Pg7yTHERo6lqS15NriFaKOM8BTO467/ewWewIhw5s2xq0THO4eFjHegiek9KG0SsmmV1kDUT8L0ifkdNgVNTtNGklfvJ01aZ46N9XPsukD8yjBt8wG7TdgKAlfzxNxKihLH1z6aB3FWE6e4aSP0mrpMf2f/a/S9eNEuXh6vd8yJLnBbJVyzIBGLm8m42ED+66Pzx3xcyz3ZwNHq0UNoX7Aoj8kdEXE6T+JadtvwpwM2UGda7cn262t0QyCTz07nQY/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZITBorG07bq4a51NfMZfLBtlf9HiVD+J8e5SteS/kI=;
 b=f3cZorgozhRuCeEplsnhsXdopiy8QzUeA9rIhGNYd3IzAKmkkBSXNX5wLgh8uperLUOwsEFb8ieVzO9Q2RUkOnnSkgxbFXzeOHI2/Hhhojlq440x0HHfo8EUSDuDkFBtKznVMkdnrUHoQ37Fl3l2yX9dLGWoZXCEjlL9aHK4Kak=
Received: from DSSP221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::16) by
 SA1PR12MB7366.namprd12.prod.outlook.com (2603:10b6:806:2b3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.14; Tue, 17 Nov 2026 22:19:41 +0000
Received: from DS2PEPF00006E21.namprd05.prod.outlook.com
 (2603:10b6:8:3d5:cafe::6) by DSSP221CA0004.outlook.office365.com
 (2603:10b6:8:3d5::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 22:19:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00006E21.mail.protection.outlook.com (10.167.23.214) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 22:19:41 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 16:19:40 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Ashish Kalra <ashish.kalra@amd.com>, Rijo Thomas
	<Rijo-john.Thomas@amd.com>, Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>, Sashiko
	<sashiko-bot@kernel.org>
Subject: [PATCH 2/2] crypto: ccp - fix leak and stale misc_dev on SEV misc_register() failure
Date: Tue, 17 Nov 2026 16:19:01 -0600
Message-ID: <20261117221901.746427-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117221901.746427-1-kim.phillips@amd.com>
References: <20261117221901.746427-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00006E21:EE_|SA1PR12MB7366:EE_
X-MS-Office365-Filtering-Correlation-Id: fca7ce7a-6e02-4fe5-511c-08df44f8e023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|23010399003|18002099003|6133799003|22082099003|261009223027099003|13003099007|11063799006|56012099006|261102123227099003|261028144727099003|261026121527099003|261026140227099003|261021121427099003|261022075727099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	962zL6VePMPfne7+5sS033XcR5ev3chhBcy+73Kg21qHJ3KQwWddWs1Tx1A4Wvk9cU6f08rYZ9EBuGdlgvoF3OVa4+/3f+KuKXQM7SGkjtq1SdCVKOvWAxLev7WI/DKlSu30gXEuYAlwZaTbEIeOiCs9ga4jlQAl5YHjDDSEGGOHzl8dOto0y4UjE51IrwHutLqXvj4yFhv24YWNCnDR0LYl07N7GFEF4lyeDvE6mOWPb43uQ/wZOirUgR6vPHdeqH57x9YUZKRnbirYE21oVXNoYY4DQYSbefDSXTS0ULqvekPOE+ff5nj/v2M6wAI6hylN6lZgNBin14m/9/XqJKB2iRBr37zqArLi3+nts7SEB+C6AH0GRvk0ZL5/ZzLcFz+lA2kABRahq6S3hKV4Mr5rGHN1FKDOU4fWSSK8fxctH36VmierhBN01qE4hXJCPrYW5k1TPM8K2lyPHKkcO9sxd0r3OiyLLFda5lpKOCxeZwFcB0XtS+Q4kNOC6ncebxtDcMaqYQaiFacOgp53h7jSV2viODRGK7IWXoIfTYjSMi78VoJJO+6UwrkQIV/1YgKM8HRhRQlK5QBMIBb+6NvqlBFP8NlXbJv/yVTB+iH9Koi/6XyF1lxEIjz1zHYh3S831Q8yNCWoR/ub71D9Gw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(18002099003)(6133799003)(22082099003)(261009223027099003)(13003099007)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(261021121427099003)(261022075727099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Hx7ipi3qD2IWEC4ykCxDUrD40gUnd1d/YyvQ/16DdDoIRFjpVPb6/6MbXmlzt2Eunbyo6zDVcCE4LqmMwIDwmemmKhznhh4scQn5ucu6ZGdtDgLvjcv1UC/EpqnLo0xcCGrBMomeh1FeuZ/jSoVC5CoGNPzxpua1uxj6+sX3U4pQpZ1nPN1aXoj2yXf/L0sDUPneEGUpLzU+olGvvZ0uImy+xiaN0M4pchRuXIcp70Td0J4d0WmQyjDPqt5UtQkIwJf35Fp+OuyZ9HXzKln6ty2XO1+kVSd8afPCDgdTCwSP7+RRHKjDAQyq8GetOt4bvChvIAJxxtm0GOi5pTyFfjgQx3Bg3XMylaEmIba09KkgzmoRNwBOvHoLzmXnUPC0jwBJSR3Jo9+pO0nB+tM7p64VE5AeXsAPwYlOoPhSF9Aq4qE+kZDyA11ek1yxQkfK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 22:19:41.1977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fca7ce7a-6e02-4fe5-511c-08df44f8e023
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00006E21.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7366

sev_misc_init() assigns the newly allocated structure to the global
misc_dev before registering the misc device, but returns early when
misc_register() fails, without freeing the allocation or clearing the
global pointer.  The early return also skips kref_init(), so the
embedded refcount stays at the zero left by kzalloc_obj().

SEV support can be detected on multiple devices, and the failure only
aborts the probe of the device that hit it.  When a subsequent device
probes, sev_misc_init() observes the stale non-NULL misc_dev and takes
the else branch, calling kref_get() on the zeroed refcount.  That
triggers a "refcount_t: addition on 0; use-after-free" warning and
leaves the count at zero, so the matching kref_put() in
sev_dev_destroy() warns too and never reaches sev_exit().  The device
ends up with sev->misc pointing at a never-registered miscdevice while
/dev/sev does not exist, and the original allocation is leaked.

Free the allocation and reset misc_dev to NULL on the misc_register()
error path.

The stale pointer dates back to the introduction of the driver, but the
leak only appeared once the allocation moved off devm_kzalloc(), which
is also the point from which this kfree() is safe to apply.

Fixes: 1f14b57ffc0a ("crypto: ccp - Cleanup misc_dev on sev_exit()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-c271284a-0608-480f-8b5c-eee039d6b4c0
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b980dfc7f3a3..56e38a9539da 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2883,8 +2883,11 @@ static int sev_misc_init(struct sev_device *sev)
 		misc->fops = &sev_fops;
 
 		ret = misc_register(misc);
-		if (ret)
+		if (ret) {
+			kfree(misc_dev);
+			misc_dev = NULL;
 			return ret;
+		}
 
 		kref_init(&misc_dev->refcount);
 	} else {
-- 
2.43.0

