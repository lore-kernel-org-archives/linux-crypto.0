Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9736213F;
	Wed, 21 Jan 2026 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769001894; cv=fail; b=AmliORR2DocpiSPp8ERglUW7xOTDU3ADCGQLsKf2KhFdyrn4aeksv5hhGJM4PVetjaONoj87plPf5TyCFjFNdsR4z4+Jv+znogjCVFpO6JaSx+/ca8toH5f1pQ8mdwA2nw7UDsJWlvDvHsvDCbBcz11VhCItfvC/ncJ7mskagS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769001894; c=relaxed/simple;
	bh=zkXqwsYr/RAgr8rc1RzcuQwxL7SE3BEXtpfFhmKm490=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUpWFvyrqwwd0ZgkpoFOTgdOPhljB/bPWkWOisvJX/id/zLxb2t3rmIkQyrmsWbeDR8iApyo2lVSCoAsxjbffjTdmhYCzGEyyLsoJYRg7pUdiFCoPCj7roEVADvPTmjZYm/JKTcgfUAvbIR68a+/gGJtwpS5cb3snWK+IUkL0kY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=slxwrU+2; arc=fail smtp.client-ip=52.101.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="slxwrU+2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSmF9CNLbRSfhIYbeVgeY9EHn7ytAW58tRGYoAZO0Kw47p/Op0OjbzqF12L1JBHyo7iemcaLtJlRAXz3zNwdY/rZYKAZfAVVKhBMubNIXGXwmwRJKNdUUmaktfVwWq6T/2tJjsvdcoDfx8BMlRAhQaKQXxDfBtQ6itXmy29cE9nEYJB0PxbwoiqqRUMeqRdRfzqMX+3G8b4hpoRXuvbZ/XfVuHQPMRxm6RGOmOy7/KkilY8DMxEjpgFYlOsKQuv1Yl9U2o7QmMcSl3ojvbYs1Iy9sn7swSHePxrOc41T5eO4A34ituVNFrL4/+1OfE9iLR1X1XVA92TlRsnRcGkKjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKdZIcbWXqez8ELpEg/yZ27Vlzzg+jaCG+ZTdGCSk9Q=;
 b=oTFvbAPPm0LCDq16yZYI30ojX/BtSdzfZtyHyHW5KiSiCZxmwe7heBNWnNA7ZmgkpG4B+h8+/Rf7klaSIF3KQS32CT7AAg3RaVtCPcJjIHEX5cFWAqcDCIb9pT0QlxAYyASD5zRgeOiMKbvLtxAsAIh23k6dxPizJtLdiSWKlLT5VY2P70fr87x9dOoWiT5jE380B9B7mEYUnYAjjUYXMTgEf1tJ7h+PFfgiKL3YKXzyUQwbzSHWWTS/9qOaJ//EHxErfZFoQJWKMqdPuPmKDuAwwqH0HTXcV33iwIYhuqLP5J26WKEb+x5oFzWXE7yWYug02PZur9Qo6xGO8kbx4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKdZIcbWXqez8ELpEg/yZ27Vlzzg+jaCG+ZTdGCSk9Q=;
 b=slxwrU+2k7tSmdbG9+4aVJjOYZl3FIb6e/Oryp/eFIep070b4lp/fhThopdHyGy4dYmqPbwgt6+zuSLwrsKqkvvWf42hhLv6Hg7IvilNNS5i4kUbc5rY9NQ21pxFZFuL/vUSy1HYUAgemsZ4/M3daUS9/snyMZCNSUrzaOR6IUQ=
Received: from SJ0PR03CA0352.namprd03.prod.outlook.com (2603:10b6:a03:39c::27)
 by PH0PR10MB7026.namprd10.prod.outlook.com (2603:10b6:510:289::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 13:24:47 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::79) by SJ0PR03CA0352.outlook.office365.com
 (2603:10b6:a03:39c::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 13:24:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 13:24:46 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 07:24:46 -0600
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 07:24:45 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 07:24:45 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60LDOi9P3065849;
	Wed, 21 Jan 2026 07:24:45 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
Date: Wed, 21 Jan 2026 18:54:06 +0530
Message-ID: <20260121132408.743777-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260121132408.743777-1-t-pratham@ti.com>
References: <20260121132408.743777-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|PH0PR10MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: 833dd6a8-4463-43b9-daf8-08de58f0727b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jZMN5KiEXo68rJy1899xVZi6c55WNfp8wCC89HAkrrNJ5d/9IHmeTH2wBXCD?=
 =?us-ascii?Q?pTzRWJMZBOlrCZPe+b28KfnkIlfaAp86ZmnC2eCHJhqvS7PfkoYS8rCjyE0d?=
 =?us-ascii?Q?hrLakyqwT4+EtwiRtT+W5OEOH3UMRYAgVDXQezxlrKdnNF3vtCabaYf1MTS4?=
 =?us-ascii?Q?1r/GtECver2xJqZROhERoe9SI4QtpmkMov6K6CWth5nIQEf5Iah4ixzIUhth?=
 =?us-ascii?Q?L+QvC5fG8AwcblWITtQqv2ayLCe6G+DjvoRbp1EXiBdCo2/8jfR9X6uaQd5e?=
 =?us-ascii?Q?y5dv1sLxp7pghauDCX6bYmlReGQdlqmiSPfw9+xPqGTfSdZBa4/U18xsCMhn?=
 =?us-ascii?Q?ER0RWhjGT7K3G1Huqj+P9MGNQFKuiyl+6h1DxNYyVTXSSF8SmaWbunxQJSMy?=
 =?us-ascii?Q?JUvcJ5iJAI+5B4eTzyaD6VYLJwy4p/ePnT61r1YL9L+PZJkPvIhCrFI8zL9F?=
 =?us-ascii?Q?BuVCIZJM7u60xrP7UZPBsOIEoXfuo7v+IBIPjNIJr4bYzhRxdO6XFn37GPp6?=
 =?us-ascii?Q?hfnbT7y90FfJDNHKsjS38CGu+irruokjRB9c2ABSilA0SOiujZsGwCMd0iog?=
 =?us-ascii?Q?A4BQgtonrSJykdykzMpeH8OFMP5fKEPIXfw0najRcL0oj37Yx2EC0LuPkyyz?=
 =?us-ascii?Q?JLG+R+coLt+3oM66YkJByE4/ZDBAkdkyJbEDkcKjem2JLUctt/q/JKoekxn0?=
 =?us-ascii?Q?tnEb2MzugbnuMKYLmzYEoKdzqKicfBPpyHPdiIoZQoTdxt/VTrQdssbWY4QE?=
 =?us-ascii?Q?6pF1JUMssXkzogHd4wzaieRkx4xRc0K0yTXrSfUkykHw135UK+dmVgST+lq3?=
 =?us-ascii?Q?JUQEpljqOyKGh9lgyOydhWBFboY+kvd4XE+tHX+gBhsrh6WSgQ5uJNG78QIx?=
 =?us-ascii?Q?0sF51PxTl5Hg+nroKdkd/4mbyO1YD1bL5/ODfG14F93ESeQyM+0hGa1Dkht7?=
 =?us-ascii?Q?slhgOKCyBhFRzI7AH9w7DAfSjCUhv8pEqWaIyWkKIBrNMmtJzgCpakeKlxOQ?=
 =?us-ascii?Q?PP4GfeBoi8Qm3bakX821rvoPanjB7WgGVldEGA52E8amuMVpgL7vyTVt6XlC?=
 =?us-ascii?Q?vwxj8v2giUWS0OBSwT0O05mYm7yjNMge4S7IF7ZMOPs36UW5HXhOHKDKNRjs?=
 =?us-ascii?Q?e9xzR0eKmm3HTy6qsQHNMN3aN4oXeaiGcu2MFhqivtbA+Z4kr+k0ZuWLhm3f?=
 =?us-ascii?Q?+HlBZtY9GOl+McGsxK9QsnRA+7evD6mg+/qNRIxKgn2FPcHqKfZeLYlB0ZnZ?=
 =?us-ascii?Q?p22ywjrGFfEumdl/bw0yAdfCPw+k0huYb2v4070KSvPCXYqFFoEhhDTdcn4F?=
 =?us-ascii?Q?LG8nFusbZgCV+qu572oTIQp+dq/M1xpSlVUnhpfE+4MBUotcmfRajk7oPIGI?=
 =?us-ascii?Q?cEMPUaJJoVCetDYI7z5Z+w31dzwZ9N5JO9OPghuXoxSVcm1DNgIY43SNMDPk?=
 =?us-ascii?Q?eO7CEs5DWRIoh6eEhbRp91aueWSX3V7vyBRp+vles7K+AoijiQfUZQN7OlIE?=
 =?us-ascii?Q?wfoxOfOf65XduKuDQdOAAzyvN7/UGfe9yVQqxDrJgNsqCsEqLc7ZLUPRIjlG?=
 =?us-ascii?Q?OELOsr6JoEkctCBkHV7kSxmGub1P/XwVofRBKWAMTxkVHeOnrapXVUwIGw0U?=
 =?us-ascii?Q?ezCuiVbcz6UAyT0C2v0a8sD0gk41Q/Y3OGFu98AnoeMeyCU/IZuYf+x8LxcJ?=
 =?us-ascii?Q?jFdxXQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 13:24:46.8052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 833dd6a8-4463-43b9-daf8-08de58f0727b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7026

Add support for MD5 algorithm in the hashing engine of DTHEv2 hardware
cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |  1 +
 drivers/crypto/ti/dthev2-common.h |  1 +
 drivers/crypto/ti/dthev2-hash.c   | 43 +++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 90af2c7cb1c55..9c2aa50cfbfbe 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -12,6 +12,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CCM
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_MD5
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index c2e8fbb566cc4..c305eca26ce82 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -17,6 +17,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 
 #include <linux/delay.h>
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index b1394262bf630..e4efcad375bf9 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -9,6 +9,7 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/internal/hash.h>
+#include <crypto/md5.h>
 #include <crypto/sha2.h>
 
 #include "dthev2-common.h"
@@ -65,6 +66,9 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
 	case DTHE_HASH_SHA224:
 		memcpy(dst, sha224_zero_message_hash, SHA224_DIGEST_SIZE);
 		break;
+	case DTHE_HASH_MD5:
+		memcpy(dst, md5_zero_message_hash, MD5_DIGEST_SIZE);
+		break;
 	default:
 		break;
 	}
@@ -93,6 +97,9 @@ static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
 	case SHA224_DIGEST_SIZE:
 		hash_mode = DTHE_HASH_SHA224;
 		break;
+	case MD5_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_MD5;
+		break;
 	default:
 		hash_mode = DTHE_HASH_ERR;
 		break;
@@ -114,6 +121,9 @@ static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
 	case DTHE_HASH_SHA224:
 		phash_size = SHA256_DIGEST_SIZE;
 		break;
+	case DTHE_HASH_MD5:
+		phash_size = MD5_DIGEST_SIZE;
+		break;
 	default:
 		break;
 	}
@@ -578,6 +588,39 @@ static struct ahash_engine_alg hash_algs[] = {
 		},
 		.op.do_one_request = dthe_hash_run,
 	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "md5",
+				.cra_driver_name = "md5-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = MD5_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
 };
 
 int dthe_register_hash_algs(void)
-- 
2.34.1

