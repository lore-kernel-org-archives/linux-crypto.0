Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012071.outbound.protection.outlook.com [52.101.53.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDAC2DC764;
	Thu, 26 Feb 2026 13:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111490; cv=fail; b=AqRl/sOEkxcWLXXFwwWj28cUo8kckwsv50UzzB7C0VNVdAkL+2gyEZ6Cdc6rQhpxolDc0j9HKgMFfjFEcZAIzSJ5JUWRioGjgTEQg64BucgROnCFO8yZIQkVUAE0Khe+ez2yXPv/AngPWJgKFfX16IerkanetJhdCm2ws1J85Po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111490; c=relaxed/simple;
	bh=GC0+hoCmqay7IJbFD3xh+T0U3lENMyo+vX1RKqGY/8k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xqbpo0OIPlezlRX5rBdrze7SUwMM50HWmPA9uN27SPelVwT6ShsNNw+lGqasVFROmWNQEzOZ6UqUR848dL9qLy2WaVtKZWCaESkuZa4cSwftH3X96r91PvfWCCt6Zw1sydlDJt0wzy2b0UJMQM1im7CE1OhqFUZ+BRyJttVutsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ic1ZsnRX; arc=fail smtp.client-ip=52.101.53.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ic1ZsnRX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zdi+TpInrURHEZNZ/WTP84gN3vPsowfcl0ZLm6Zw6LEz1smXofLBhkMr6k3gob0BllQ8OglVt7YeuXSoxTTLjBlSNOVnkw0z7lSpjwSujzHu5FQSY/lEUj2Cq9HbPRwYk8UDzfmkmSWX/XtSFKTc8SuGTElK8omfy5ojMHeqotITeldduqjAhPYDFAODlvDiTU+0O5n4FWuyNJFYIJw90nixlHAOJlu5BEKYCFZaZwoyVBYkHQeTIgw66TOQ29RamLFhwAXLo0gO3pxwJvoKWfQt5euLo6OuoCAN5DFn2Oc7a8UHgwtbhNtBn0VmkPwpwzm7woXuXWvdCl1V0YF9kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XALM3Yp2d2dXir2PybPtTdNnhwJ+rgEJI2lyiOmcSc=;
 b=PPk+kKjKfJlHqFsyjnYcSz0oFdLwqw1RyzwbNfeH/zMu6OrJsVH9H3q9tjADceqSAWQt/JCMLEmMKXMn7NVyYOq7cpixCZG2+TZUQchEBAM+KC3fcvuee+7ENvENcQUNBJLllL7AwRsGOxtNQUeGhnV3N202r3yO50AWeLiXJfiECbIHS5Na2ziElP6zP5jGOcIuqmfM5DMw0SVIeBM8S+Kt4A8TzRs9uKJeMljpK4o4IxtyWtGCPkaOPhMAzzCrll9FjeEfgYE/d6TA4WIf5IFG7XFpSlFgeXwUTM3DqpltGYmTmNawYrLSiycldqCu/8xR241d/gEET+bL/hJZxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XALM3Yp2d2dXir2PybPtTdNnhwJ+rgEJI2lyiOmcSc=;
 b=Ic1ZsnRXdZq8MpKKgCfB2DgawVsOpTzX81/wLzyvbI41e/P+RLLw+57fblcWsTpd+tSKwpUnJS62oTs2wAZF5gG4e5e1+lIePoo4M97HXDB+sDbR+NTJd5I8cyoPZL8D9eSurMz7WhzOi3IPDvqtzrSu8bHu8/sP+4j8zfyD5to=
Received: from BY5PR03CA0010.namprd03.prod.outlook.com (2603:10b6:a03:1e0::20)
 by PH7PR10MB6177.namprd10.prod.outlook.com (2603:10b6:510:1f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Thu, 26 Feb
 2026 13:11:25 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::19) by BY5PR03CA0010.outlook.office365.com
 (2603:10b6:a03:1e0::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.24 via Frontend Transport; Thu,
 26 Feb 2026 13:11:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 13:11:24 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:24 -0600
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:23 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 07:11:23 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QDBMEg1917516;
	Thu, 26 Feb 2026 07:11:23 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
Date: Thu, 26 Feb 2026 18:41:02 +0530
Message-ID: <20260226131103.3560884-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226131103.3560884-1-t-pratham@ti.com>
References: <20260226131103.3560884-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|PH7PR10MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ca26398-cb3d-4962-a0f2-08de75388b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|34020700016|376014|7142099003;
X-Microsoft-Antispam-Message-Info:
	FnNs65smcyMDY77sDr2fH7DLNqOALxKoGTWoFLBLkOiUgCBcPxMdH1nIkzORfTKimnUQUcCXhWyAzxg2X8vgONl+XgSIOCaos0H/xevOhYJt+zJQzhoKT/1MeJGCFGdPBvbS4NmvDVCbKT6aRgXRg7tgrjwPdnd1GYQsGIaKYyqVcJyH//oJeIpJXKSWcA7PlMx3ukY/tTmStHNxw4l4XoyGghSa56gatXN2yJIyVcL8wPggIENn451CzDxmPVf9NBH7bSBInpWML8/NSwVJYzRNhxTUupMkl7QebXT1/8kdLydCpWA//OyS36/NqV5VDRDECUHQcQH5RdPLh/xgc4y2RIxJ4pvlj+0LKdJDY/wCJJN5SPlQTzFrEC7R8gJpr7l6MVQaK23sT+aHW4OP5pyaX7iLLIuBCT+9ON5/tvOsmlfpo3IC14o+YRyfLfK4JS8eCCyEQRSBPIQIL8W/uIzPGNCvw2dr/ODL8xiW9ozeHUnTmRZIoii6UnqOm5AFiBoshRyEkhNuBYlIVKvHv0dCPBPWAWns0bxjHOQSBHmivdOkJ6Ue61xG8bGlKF9M7j7vZPq/SuyTMduAly5uA8VMF7c2uGDiD1Go6oH7kgOky1pYvFGau6L3+1Eg6O5y26mfHIxnWLL2wvD95vV28OlEv3lPzb1Nv4H7Edxj7U9/dSsR9T/h2Dkx9BTGZ7pQvDmT8DH4k1txMtD7HfevRBdb47+ckxQOoVf83tJSBfrNaIjhCtkEgF5/WLpC7fEd6jIuak+Ari7ds5ZgNHkHQe7/JP4mRKm4k9pJomMTBRIyauN4Rx8TeaNKgEaDHkIAbNDef+oW//tCpFvC/OCmLg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(34020700016)(376014)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LAxiXlKRMFfeRVRzq9ILdmXniYPx4xV2cGs2JQmhln6t3pVnBiGt4miYLTlX3Z9ZcKHs4JCVRUKmIeA5lgkiEnt1ynWv96XHip3uxpfNxpDVThtjH5Fn/K/2sJxHErx+XdStSDRDpDFmGLRwR1d61uu6zzOVf3UgwYjUgsoEG1HE18itYS5Q7Vt7+8Zo79PDkFndFf+34nFDAFhXd26Q8MIhpPG3jiYFFtG5uf4+N8clq1i7Ze7zyw6VDlP5LpMowibY7oH4CSG51dyhlw6T9op0TXRRp1gNyjwX819EbGSZ6+QXmjJF6+9Vg9rTwQ77mtqaNbwdFEogzfToro/bm7pq+OC2jtDjAX+K9Hp0CBmot5VmTgsRc1UMzN4SNDwO6C5qdk2RezsGTyTPVmq6j4YfwBObPQauIM2CafE1CXoa5ylVOFDszmqqLqP3gI1o
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:11:24.7123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca26398-cb3d-4962-a0f2-08de75388b46
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6177

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
index bfe7f2de4415c..24799007ea81f 100644
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

