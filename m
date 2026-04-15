Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5661C2D837C;
	Wed, 15 Apr 2026 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263845; cv=fail; b=NVQGN06TFmiNU/uobpR0wEoXPVKsyzsS00ucyYR8gd8VfD4dk7604zLoc9nq3f/Y6dgHcHKHRlZEycnJxgxy38N4M64g8y+nTar5ra0QZnP4XFLjms3L5t6/vONjMArq0G17xry31zJab6bQnjgZ5hz4/AaEuRQr1murg2bgs+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263845; c=relaxed/simple;
	bh=1GS/CWVV3HPxn1m1t18TbRpuVDSzHBeqhvfUPJ+Vcnc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QV169y8Nnq9MhKGqg/AzPJyCpaDttCVMemxRT1CSRWL/B6zt0LCaQ4c+3sIjbUZsFQdKr8vUcS1kOuLdi+NiUxhMPfeT2OCh+0Ajt4a7J+ZjsS3VPFnSuxVKnZx0amL0O1fq5pDEJNBzljd+YswKlDxCWJ9HFGCJsnj2+wEF/Y0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=fV1oAw98; arc=fail smtp.client-ip=52.101.48.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fV1oAw98"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GuvAZ6E/+9r5kkcnxnLP1DIzbznGsoWBtnaH4FuXeYVfidpyyaVTvjhcMFh3O/nq4+7dMqieq7onYjaXYkF9ejq9tA+ZDc+oxCl7ykyrUb/YkJ3hmIyNDokQrqbkzOBAK1hdNHZHY4q+9EuLZHM1Y0YRneLY1Kv3RMFMOSzpfaytahOpOz2MOMRrNkpy0bKt2c+/WN5KaZ/SYLKyY0vf8AT6uSj71RfK0aNjrh4vkXpJch58kE9yIcMbUTBiy6tHbSa9wCGp93EuONEIBAJ0QTwqEJrA8kzDfLtGJcolZjDVjGI8VHFqHAvHr9b0JQalwF0bDiwnN4tAYR6xKaya6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhW14jBAb70dOPTNPvDaHeWh0yf11yyDvKn+z5HN+sc=;
 b=yuVBSDFxu7mVVLyQDBAAmnLfXiTebdRDtjESGPAEqz00Ck2bkOWwXs0vIxeONHkqxNYYyZ44qr263z3zSNohm9G1UHFHTHKVNPZx5lYI7nqxeiGHqXEPkRSXSaA2ZzsFvCvaLmyyLDegQtLMi6AKq6MugwYe5Hr4/1kzBux4NeIcW2ZvUo08tZVH8wW50VtRavsWrRwFcWSIcGvau0xIN2r0NYIqbUJdhxZQScnAPsZ0s+y/wAdgjrhcjLEnPFZMo7YqAft6+piuZG2btSExvRwU1BSlKWwqEpqc2aBLgT+QilLpNvXDc4BdSlM7IE4aJs4QuZIn23PMP6IsZjea0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhW14jBAb70dOPTNPvDaHeWh0yf11yyDvKn+z5HN+sc=;
 b=fV1oAw98nIJ55IDVfSjtyRdxrAuPjJENigWtblTeQTKWwCYtEgG7Q4ZXp4LtG9QwOmRH6CqT3wlPeB0EzJ9zD5MuecfYFRLEeFqdQK/LH2FeYtsYioIHlzOSs2p7Lkon9xe+CaLVMgH8c2QzdSE1eaHEYE8unEpwHu7SpL+qJNg=
Received: from SN6PR05CA0024.namprd05.prod.outlook.com (2603:10b6:805:de::37)
 by CYYPR10MB7673.namprd10.prod.outlook.com (2603:10b6:930:cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Wed, 15 Apr
 2026 14:37:21 +0000
Received: from SA2PEPF00003AE7.namprd02.prod.outlook.com
 (2603:10b6:805:de:cafe::2) by SN6PR05CA0024.outlook.office365.com
 (2603:10b6:805:de::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Wed,
 15 Apr 2026 14:37:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003AE7.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.21 via Frontend Transport; Wed, 15 Apr 2026 14:37:19 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 15 Apr
 2026 09:37:17 -0500
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 15 Apr
 2026 09:37:17 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 15 Apr 2026 09:37:17 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 63FEbGpp2396707;
	Wed, 15 Apr 2026 09:37:16 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>, Tero Kristo
	<t-kristo@ti.com>
CC: T Pratham <t-pratham@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>, "Shiva
 Tripathi" <s-tripathi1@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>, "Kavitha
 Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] crypto: sa2ul - Fix AEAD fallback algorithm names
Date: Wed, 15 Apr 2026 20:06:58 +0530
Message-ID: <20260415143700.1168634-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE7:EE_|CYYPR10MB7673:EE_
X-MS-Office365-Filtering-Correlation-Id: 5876adaa-5f64-4d26-9c24-08de9afc7fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oeaRVBROcxpeGX/ImwqtZc9xCnpoJFy60vQ0ktZ4NP7MFjBxxgrly1MIo00pG/vv4KyNdouJqVJIY7bwiNy88yBGABKC8Xyw3SucSIoBD0Y7MjLcbSkul7ItclLi5mCqgOKCEFQkVmN2IZKY0F/1IxzGoQSI1EH1WA0WD7GpxNg+etmSAWNHJpTQ8TbRIHtsWByPiZN4qYd0jLBlT1oL2FvnaHWSD9TNEhJtHkJMSCYeefdWRf4MDTmNwH1Vq4uoRgBKcr/mHk+cJzQpeQIbF0WLSxsNCJ3YA/aL6xYNpqs7rtC7kew5qkBWqFHeQo2PNuLM34oYAXlmL84i7LA1y/t2RlKHGBR24K0VIItimCbw2GXdnulJqrEwfCMofyFrY9Jf4mI1sK6mS0+ZP5hrIiPrZmEuMWhKxqZiqbOXXRWF/QE0QTlUSYyJ8ERZ+wQgpS4v/TzPKQnp7VtJUYZ+CtrRhCJ1SbdVBbMk3Tibhihf6g7nMQLey3B1ojfyCBx1MR4Py21MQPrLvqU8/+bKxiob4kAcHO4G3AVp+lvfx1qO5Nxh1QDk4Wyg6P7QJpTsBbF+CzjgeYUzO3MwplIPK2R/9ktmlU3WKa5ePSCr3/dgA1w4ClOmn9a1rBwkT9Y3yeLGL1tRXzoVmjRclbtS5RnggdwsJZkAeMvjW2HLh1iEMu4pSJfb7/UTO8ImjSCdhYlWmk3tXHn3ygG6PKsN/9nVMHTv0vt3vckWqiamh6UTI/H1hIuEjZk+LcNmn2nOYjHHAWL7EO+t4x2ZW+ZH3w==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2yGn1mpPi5IHO+QH8O9pNt1NiGWfGmb/ISNu/qKFquyxIWtUI01DJvpsPIfFgDE3FLjLX+ueBi9Sqz48+zdK0Wh+EH7oZKPI1nGE8fQNnsNosY0ip8WdDlp4/s3LqMzzHaRV9NtlZqGgcfRo4ZGsogMjxUbpRt8C5yl6CpZBU+SCcIXySUmPCox2OOsUrYzytoj6xU1Hcxpe/y+xRWcKQ6zFTSB3+05BfACTEBcFidfQKDkGZkXL7f5VjYhDa4Wcf97alc0NPgthdjF2uEFeIUkrWK1hCkSF+rLleEsGV53PgMAEDkRqwyrPBkQCXHzKgVGPH4ld4zxtOz7/UKXgSMxeC/9RNUfrnW9+53qLucuhNppwSdipRoxpBMl2/wP7cD4h0OiDzrAoVgqLFL7uq/Epd/WAJCic/cokBhhu0eDJcWZbdYfncRnoC3qcqDNR
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 14:37:19.9086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5876adaa-5f64-4d26-9c24-08de9afc7fcd
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7673

For authenc AEAD algorithms, sa2ul is trying to register very specific
-ce version as a fallback. This causes registration failure on SoCs
which do not have ARMv8-CE enabled/available. Change the fallback
algorithm from the specific driver name to generic algorithm name so
that the kernel can allocate any available fallback.

Fixes: d2c8ac187fc92 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/sa2ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index df3defa1ef4b6..965a03d5b27ae 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1744,13 +1744,13 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha1",
-				"authenc(hmac(sha1-ce),cbc(aes-ce))");
+				"authenc(hmac(sha1),cbc(aes))");
 }
 
 static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
 {
 	return sa_cra_init_aead(tfm, "sha256",
-				"authenc(hmac(sha256-ce),cbc(aes-ce))");
+				"authenc(hmac(sha256),cbc(aes))");
 }
 
 static void sa_exit_tfm_aead(struct crypto_aead *tfm)
-- 
2.34.1

