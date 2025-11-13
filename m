Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011055.outbound.protection.outlook.com [40.107.208.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FAB26E6EB;
	Thu, 13 Nov 2025 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042908; cv=fail; b=PbdoLRkd3kcxUkFO1neuSF8Ch58IE7InGpEEAzKzNunIvLIU/JTo9F4k5F/wiCWCaWtIL5I5kQI8XQT+7D8LeYAMyB2fGNY9HRMBpDHiltgkZUD5gCM6NDIV1oQEkV3amBJsCamhxqijBRl6THoz9PdXQdvQz4Ao9TQ0ulcFekU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042908; c=relaxed/simple;
	bh=tw3mYPt5Dp0gY6fYyA2YIbriQi256DWcDyIBim3t0/o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXMi3RgWIhBkt9AxZGb785NGkJa8XWU+eISEyL4dLrU92b0kZq4eNcyk5J7kvvnpS51a5WsS76ND/mduZu44sPMsIB2x5H6ePa/mAvgij4NO8qOksrceRJEs/4w3XC/KR3atbpbG50fBS2UtcXdH4ve2ek6+YoclS0RMH41dFNE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=YhS4cRQn; arc=fail smtp.client-ip=40.107.208.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="YhS4cRQn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYx4Ct+JiuF4rzCnrp9yZ7pcO3NFUWrkOp1F0bg7VyX2BA1pKQRNzDoxpvuWf7qdxDPws3cYULBQCKaT0c6QaeQ3U98DYHoZDaZ6uBwvOwBFpXzVYTB7GzK2ZA6bP1aJuJ74Xr2IW0Uqa8w0bowp+w+7oG+B890T5iuknfaxTmhnbmVDu1fJQlvvB+Mzkg81tT3rbzZJi1I2xrPg8UdXPAiRoqLKRJIj5FMU22p/JP1S5MPdjeK68Eh3W2GeMHQGZmSDg/TNmqt11SZ7OSZNOHHhbv2xU4X++4yR37Fs1NHwzLDMI4Rksl12Hsp4C8OdG1Fr1uezpq95sdxZ2srucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TK3QnIiFjRAnuT2gkBgd0Nfy/8mEjcLseOL9qtiQZAM=;
 b=yXFmWdu+znDNfNXx+224srizqvREPzMHoEIH3J2Nc4GtuNYmMOVg6JbPy99rg72wT9lX+/6m42RpyBqbLwg5gIvrDF972ZSY7sIg0WR52SVabz/g5mFh1ogwLZPQwh27ObQFmSSl832pABjIAooNNPKZSDUCTQBtUc6nKo4cA6QjMVAd9nDGNVJelu6bpOZMPWplmcLNAxyva5+ODesL4l92Axb4WYcIh4wihTklU2EO/0LvJbPPPo7MZMk2d3yeKsGcN6+Sf/OIJ598q4u67x8wsr1+BwjeTSTc0J6IY4TPpfTRQfkjYkIHK4JezJ627pyBnrbUZZzLivYyrpYTng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TK3QnIiFjRAnuT2gkBgd0Nfy/8mEjcLseOL9qtiQZAM=;
 b=YhS4cRQnfgrCG56bel5GGD0iqo1Gv+OFcoz5mMrppY5KshFbS5GIpiLVxeC2ETL7kINdgZNi2zHGQqSSqFqw0CHxqfVJ3cQvPAT24dc+1ukvPbJxWq+lboMQ0uRbrrNZS8g/c3SJ4vCfhL42/lb/DnpGGZ/MpYDyjhE94/lMna4=
Received: from BL1PR13CA0074.namprd13.prod.outlook.com (2603:10b6:208:2b8::19)
 by DM3PPF2DE5834CD.namprd10.prod.outlook.com (2603:10b6:f:fc00::c14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 14:08:21 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:2b8:cafe::cf) by BL1PR13CA0074.outlook.office365.com
 (2603:10b6:208:2b8::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Thu,
 13 Nov 2025 14:08:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 14:08:19 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:14 -0600
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:13 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 13 Nov 2025 08:08:13 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ADE8C00385904;
	Thu, 13 Nov 2025 08:08:13 -0600
From: T Pratham <t-pratham@ti.com>
To: <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>
Subject: [BUG 1/2] crypto: ahash - import/export fails for algs using CRYPTO_AHASH_ALG_BLOCK_ONLY
Date: Thu, 13 Nov 2025 19:30:12 +0530
Message-ID: <20251113140634.1559529-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251113140634.1559529-1-t-pratham@ti.com>
References: <20251113140634.1559529-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|DM3PPF2DE5834CD:EE_
X-MS-Office365-Filtering-Correlation-Id: 3951c038-b495-4274-5095-08de22be192e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?23CmcE4tUNInCHlNUaO/Lxm86GIGvTfmUpvSVTkyXEfe3GDzUId5u9bLysvq?=
 =?us-ascii?Q?YjbjqYCBFfpOc5IhuLxjFmMHf2xvbrXJyJcQzXDVqXhRh7ksFlnu9yfiVKAK?=
 =?us-ascii?Q?53imXrkiag/TRuZkf5roM2gEfBTTcQvU+arplO3qUrZSVb7QfN7GuotIJkkB?=
 =?us-ascii?Q?u/LfO+oONcZXy0AjqgMZzKGAHZglbZSdbgIWYYvdqzl1s/yo4IeUtZvIn14u?=
 =?us-ascii?Q?3YZTf57CTW698brMoL2msRBUnpENdBQ2JYOcuiKLEKQ1/xuz3vMtsQnl+7yH?=
 =?us-ascii?Q?EBBf40JVWtckVDjLn7hphMgHoWYkjhx4Qf2LKfCRyk7T9MhK50hfwYDAh8be?=
 =?us-ascii?Q?Mm5eez3VefrivpHU34EoFW4nVnH5I/MgFl3phJ1Wu/ADixTRXDF4L5FhDW7e?=
 =?us-ascii?Q?7YQVfD+EcCvkmLfi8A3MoC65kQGpzGtkvvzB0IO8CPLkkxFg6AAaHkRFumXL?=
 =?us-ascii?Q?8cdpQeGxvL6RELcSbPykl+lsnP5e9kGKzbnnHVovFeHUyFCRoT8DRmWUwzck?=
 =?us-ascii?Q?+ugtH/Yf+9owaxCmcTummb4AcUW+Ys//oFkMQoeg8qoJncJXGvNjq4WEMAIt?=
 =?us-ascii?Q?0QuW6jJG+qeZTYwufJeKeatP9wtQZsJijR6jBvfxXr5iSb1uxXUMmeiPdQLx?=
 =?us-ascii?Q?fp5JqfHExPymQLVSo4BsonJ5hw7tDgcpV3vPRuRDgr2ZweAnFdbwLsBT1GZu?=
 =?us-ascii?Q?yO5d4F1NIVmR2JdMmJp0ctGw02uBat9RgXdR1HVZIs7LYuxtTKLigEE15Z2b?=
 =?us-ascii?Q?Ci/yu3ip2IVoP5bDwC71HMC9eefiU2eTDsBLC/iYcYJ4mGlzuDJp5eM+Fo85?=
 =?us-ascii?Q?qN9mqPuv71RnieLlISa0KEDmZrgBHSxJ+wG5TCwDyfYZf3BNg/FyPqaS3wl4?=
 =?us-ascii?Q?lQjSK7CdA1Bff7Q0iRALUHWDeiulh/vtII7y0NOsRZJb4QuUbYOg9WG4x7CE?=
 =?us-ascii?Q?jFuWNUEc83k9OXxTa3OOzJGLDmvXgzb7BGKNpvzDHDekx4OEknCNLDvYsYSc?=
 =?us-ascii?Q?P5xjnbS3drqcC9LWVf6wLsjam3/GTf569igWf6U3ETYz9isYXzu3mLnEcY43?=
 =?us-ascii?Q?PltTijfLUWDm19VtEqWy305LsqjEcolwPW/CmJSJBI6DU8ROYMfhQ4dx+PVv?=
 =?us-ascii?Q?ceAVPNix0hTfLypbG3gtgd1aMs7+EGRLKWLXmhvo01htd5vj7ikHXdIzzqiB?=
 =?us-ascii?Q?nlb3Nt+PVmZo4bknDhAMyHVTmKL5818Vfb40Uf+BFDdOuC1galyRVNlTxjt7?=
 =?us-ascii?Q?57DxoJe6GW1lpK1QoJD/V0FHS3m1kOdyyZ1GveC9sdZ7Nf1vsrVlFVsbXhzk?=
 =?us-ascii?Q?aKj6jvGvAZKgA8a1Y3LGxdtXaeoKwVAYnExUT4VV5fJO0z+d0O7BhXNXfFVT?=
 =?us-ascii?Q?M1xBuh6JI63wzEkUMt/v/Xg34rzzpdqPPs5FDq6EXRtcVurKxYMsR1+uyKAQ?=
 =?us-ascii?Q?3Gjm2yQasfk5x3RbMN8h2q4Lksn6PUDvHKTO5I/qvZphmlAeFIVqaJCmzcCd?=
 =?us-ascii?Q?8KR2IaDP5bZfwT1Xg7ToyZz6nqsSgsMeIzi6zb7WoVHsuSuYpEQGTprmzCr+?=
 =?us-ascii?Q?0q+ICMId0623yfeL8Tk=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 14:08:19.4060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3951c038-b495-4274-5095-08de22be192e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF2DE5834CD

Hi,

Commit 9d7a0ab1c7536 ("crypto: ahash - Handle partial blocks in API")
introduced partial block handling for ahashes in the crypto API layer itself.
This enables ahash algorithms to return a positive integer from the update
function to indicate the number of bytes in the input which are not processed
and should be buffered for next update/finup/final call to process.

When CRYPTO_AHASH_ALG_BLOCK_ONLY is enabled to let crypto layer handle the
buffering for ahashes, it appears that the import/export for ahashes is broken.
Below are dmesg logs from my (work-in-progress) TI dthev2 hash driver:

[   12.713654] alg: ahash: sha256-dthev2 test failed (wrong result) on test vector 1, cfg="import/export"
[   12.735778] alg: ahash: sha512-dthev2 test failed (wrong result) on test vector 1, cfg="import/export"
[   12.740207] alg: self-tests for sha256 using sha256-dthev2 failed (rc=-22)
[   12.752055] alg: self-tests for sha256 using sha256-dthev2 failed (rc=-22)
[   12.760127] alg: self-tests for sha512 using sha512-dthev2 failed (rc=-22)
[   12.847079] alg: self-tests for sha512 using sha512-dthev2 failed (rc=-22)
[   13.632318] alg: ahash: md5-dthev2 test failed (wrong result) on test vector 2, cfg="import/export"
[   13.643908] alg: self-tests for md5 using md5-dthev2 failed (rc=-22)
[   13.655051] alg: self-tests for md5 using md5-dthev2 failed (rc=-22)

While debugging, I noticed the rather odd asymmetrical handling of the buffer
which stores the partial block in crypto_ahash_export vs crypto_ahash_import in
crypto/ahash.c: 

Export:
> if (crypto_ahash_block_only(tfm)) {
> 		unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
> 		unsigned int reqsize = crypto_ahash_reqsize(tfm);
> 		unsigned int ss = crypto_ahash_statesize(tfm);
> 		u8 *buf = ahash_request_ctx(req);
> 
> 		memcpy(out + ss - plen, buf + reqsize - plen, plen);
> 	}

Import:
> if (crypto_ahash_block_only(tfm)) {
> 		unsigned int reqsize = crypto_ahash_reqsize(tfm);
> 		u8 *buf = ahash_request_ctx(req);
> 
> 		buf[reqsize - 1] = 0;
> 	}

Import seemingly not copying the buffer back to request ctx and zeroing the
length seems incorrect. Making export and import symmetrical seems to work and
my driver passes through import/export tests.

diff --git a/crypto/ahash.c b/crypto/ahash.c
index dfb4f5476428f..9510bdeda51de 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -674,10 +674,12 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
        if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
                return -ENOKEY;
        if (crypto_ahash_block_only(tfm)) {
+               unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
                unsigned int reqsize = crypto_ahash_reqsize(tfm);
+               unsigned int ss = crypto_ahash_statesize(tfm);
                u8 *buf = ahash_request_ctx(req);
 
-               buf[reqsize - 1] = 0;
+               memcpy(buf + reqsize - plen, in + ss - plen, plen);
        }
        return crypto_ahash_alg(tfm)->import(req, in);
 }

Is there any particular reason why import is like how it is currently? As per
my understanding import should reverse whatever export is doing and vice-versa.

It is also noteworthy that similarly import/export could be broken for shash
algorithms as well. There also, import function zeros the length byte and does
not copy the buffer when CRYPTO_AHASH_ALG_BLOCK_ONLY is used. However I haven't
tested any shash algorithm to verify this.

Let me know if the above is the complete fix for ahash, so that I can send it
as a patch.

-- 
Regards
T Pratham <t-pratham@ti.com>


