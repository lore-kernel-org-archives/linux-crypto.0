Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011021.outbound.protection.outlook.com [52.101.57.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6903D75DC;
	Tue, 26 May 2026 09:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779788716; cv=fail; b=HglYwpV1stI/U93MoRuxZPkljhXs5zFkiFYssgYVwPcjpNSxg9GUwQDNAZqeWgCEIn9sxMl67G1AX6yrtMZntMYlupAVGtskJ8ryXOkVuda11oUia9d0coN2FQXIO9hHaG8mL9YT+mPRSXHZRT6cbm3yRS5fosG9vNku3Oj2Dhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779788716; c=relaxed/simple;
	bh=t3d4YtVNeqe0QLZ1NQ7BodEge9fdPKMna3lRvlOSenU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kEPehCR7TZBYnJAdgMGIGdmz5NpDHs99xg4wz0dPlxSYEWoaZqNxfyOat/cKVXdULhyBrJPRonGCeXl2NulIhOg+7jABmxx/4pTbsAwdFdJSqRry1Dzj9I+qkkhNyTrxKBqqu3y3l+WJUf87EUA/TF7BkV0r4xIA9ff1mDSoF2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=q3dMxalm; arc=fail smtp.client-ip=52.101.57.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="q3dMxalm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyIyGjId5goVny9wNfufKz2gotA1OiU65ZJhqXH6sLmGXE/Zgs1pQnbm/Lrbgfa8WLe40Nw0R5+v/uCtzuZlZEKq0eDut+ohbnU09WsKa5EDaivnb/8X4zTaKm09XC6zOfwbpoIFAJUXZve/r9ysLtEVYMCSAkvIUBC89nTvcGDv0In0aU7v9IWnkAzd/DfTo+4xYRObQP0XE963eQffEv/yqfF1/HkmmBxj2uEHhKDdptW+YLPeyMvK6xH1o4QcADD7cpCo3ZCOAY5uWeIpYkS2ZCNTzJL28hIjV1sxAJGHqgY706vsmVueOiWM7OP9msdAVBQcmwrTc8WtRevTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vezjNulXaHDKZ1joXglnPD1fQOeTua2IU9IGT8ARgAY=;
 b=c0PDyYMqCGNCa5UntW3jGQ8gDyq6jCqf7WFef9CF+cxTyZGBc0gnhMZKUPND0VPRdq6yzrqCiBuhqzevA7/ztEsv9FiSfD8dBH/B0sPBz0XcJDsujAOfVUjACSK4/zBSrdwxukT+zkCy89UHZ7Y3HRdsi9AClrADHhs6tNcgBEOOa5m85GoB7900N/x4Uiv1DzdYUEz30LZoXlDrMFADWvYiLKVKfh8l0jUiuegTKMdTnDnedVKCuBm8BUVbqw3F18vlYzScD8sFkGjEpXozpeku9k/NOGbKK3uZtqnLk0IBDaF1EwlG2A2/MAv2QmS8y3lYIvzaKHjDMYJRxzIY1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vezjNulXaHDKZ1joXglnPD1fQOeTua2IU9IGT8ARgAY=;
 b=q3dMxalm+lbrnBPHPQinplENryzbUrEi7hjX1UFvBQB5M49XPDlN/s3pZMRRJCsvLFYShlWjGZ1e2zTI3UIjIAzBhWYLfPtGQhCX1ZZGqQfky4z+hbkbKGaxYRD4QW3ota62gNDqpmt/SN3DGzNzt9HRPmS2obPt2v3W0sYFchg=
Received: from BN0PR04CA0134.namprd04.prod.outlook.com (2603:10b6:408:ed::19)
 by SJ5PPF1D755039F.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::790) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Tue, 26 May
 2026 09:45:11 +0000
Received: from BN3PEPF0000B075.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::92) by BN0PR04CA0134.outlook.office365.com
 (2603:10b6:408:ed::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.11 via Frontend Transport; Tue, 26
 May 2026 09:45:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN3PEPF0000B075.mail.protection.outlook.com (10.167.243.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.7 via Frontend Transport; Tue, 26 May 2026 09:45:09 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 26 May
 2026 04:45:03 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Tue, 26 May
 2026 04:45:03 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Tue, 26 May 2026 04:45:03 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 64Q9j2OL630967;
	Tue, 26 May 2026 04:45:02 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/3] crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
Date: Tue, 26 May 2026 15:13:52 +0530
Message-ID: <20260526094355.555712-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526094355.555712-1-t-pratham@ti.com>
References: <20260526094355.555712-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B075:EE_|SJ5PPF1D755039F:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a58003-f0f3-4694-4ff4-08debb0b7a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	VqKeE85WSeGrnOsBP7wGjGQKenJjiaZZ3EWgEy2IErr3LwrglVM08rFp+9e+ZEBZKnSubinoW/xnFZMsdf1OX0G7aIbjsvFyZ4LvTh/D3WM5lNlcGEWZXCvqXaItjhbPKVWhbsYscGPo+VWNVPeXJs5wXvrOqF9dow66SZEwN6Mgg8RQ6ev1grSiyqOYpG9YTfMAuHwywCUhd19P05yNwh9vAvtxKRJ0stkysbYApxtNd8mTCMoNE5GPWlgR5Hlir7fds46a0IiKBhss5BZwpiXQkNenD7PmhPte1gv5cflA5ziRkS1uVXN81e3r9KTL7J2Ajx60wh3Ebz8hQjDTgea7RVfhM0I3uKckqn8n+9A0vpYtpFSMtCDzqxKXO7c8ZKnqEbqmZLX4L7+IVM0Ht+vxJOQw60vm+GeYkz1Mlcx6F/FlV9THNJG42kvvDJBz/EQmxaBF5T1cfKMvVS/f/CCh35tLgmZ4QXz0AmSJ+tLHW5MQW/z1y7tmXT9vB4otlg9Pt5xFarXlMMTDTQ4TM85G/HmsH3MYA/7SbPGflMTd/gBhqSRPkT9loiH7bhIf0I2glcPmrUC89X/1b8vELtCYrWpRFoKJ0yQk92qfcw0m1bYI0vLKcbtS2nPC9TpS/7oYfn0/E22LVhwSm/5ZOIEBvm64YZxdyEag4gmvHirr7u8j+qxkyyMRskez3k7gOSwqbm7Tb5nUvcRbjxCpMPJD25stqq/aFomfe5p3lr4=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QJoSVpee6XKA4dapSZQ0OXIGsSFM4l9YZg5DyJBULuB7DCVAWi6ehl95VJiJWz1uFPCWEv9mgpdSFT4Yv/O752+JLSOSUX2nLEUHiUOm3zsxYYEZIcsCu3NDJrhP4NuNC1Wol/WwhF+dn6ynx9pxw3bFy5OcCKbEE4+Yl6Y7v5aJ1ayhwdeian7FvwzJxWprbt2ZLBgAQZwA6eGCuIfY8KMKDi6DFYqukDfwBo8ag4iecIU44BstSTRsxYMFUDPt4S+RcBuXKCGv9Ir1pO8OZ9+0AEgVTQc5cKoTQ5wRbT2abyaQlY+9Z2aez5cbQ/iRiSbbpfACrrCnDgo7gy2J8ZHlsEJqosXrtPoDnCamqa5qWKNHAID+q0S9DzQgXMc/CSq2KhYgOBnsgrOE7I3arwLE9MXEDMrMa3pnKwZuS8ffQGGSHD9pCEVaCzGMvfT9
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 09:45:09.7926
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a58003-f0f3-4694-4ff4-08debb0b7a04
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B075.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1D755039F

Add support for MD5 algorithm in the hashing engine of DTHEv2 hardware
cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |  1 +
 drivers/crypto/ti/dthev2-common.h |  1 +
 drivers/crypto/ti/dthev2-hash.c   | 49 +++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

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
index 204637ab72374..4b5df4fdcaa5f 100644
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
@@ -426,6 +436,10 @@ static const u64 sha512_init_state[SHA512_DIGEST_SIZE / sizeof(u64)] = {
 	SHA512_H4, SHA512_H5, SHA512_H6, SHA512_H7
 };
 
+static const u32 md5_init_state[MD5_DIGEST_SIZE / sizeof(u32)] = {
+	MD5_H0, MD5_H1, MD5_H2, MD5_H3
+};
+
 static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 {
 	switch (ctx->hash_mode) {
@@ -437,6 +451,8 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 		return sha384_init_state;
 	case DTHE_HASH_SHA512:
 		return sha512_init_state;
+	case DTHE_HASH_MD5:
+		return md5_init_state;
 	default:
 		return NULL;
 	}
@@ -618,6 +634,39 @@ static struct ahash_engine_alg hash_algs[] = {
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

