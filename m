Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1C443D4F8;
	Tue, 20 Jan 2026 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920263; cv=fail; b=Y1rsDKbEUMabs+RMXACJVc2fx4vSSBzh/UWpt7uxrftRJ1qlQGtbb4lUDgpGWgEQUtv4BtZb7u57vne2x2hbeSjaivb+4fpKHH1zp8XLDoPyf+LCqUuSM+Y3EfdLEWwYdeyuq+qYzArlDjmaiK331w0RoTRY14Ra0pRgI+EK7+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920263; c=relaxed/simple;
	bh=wLT7rgD5vFx3ZcveVE3SG+v5Y2FU5OfxL28IQnJHG6A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=szZQrCC+k4z1E/xfsusSzUoYlRkNJK6eVXdut9ceVS0KUEhAAoHE8eYkRmt83eKoBrwWtd4sx4RmccJOncgQdR4n5rWe3Dz4S7MTi9Reo12PAIl+BnFvJClKip0M7TDSfYKI8qtRThdCQcPfjSA4PWHQv4MwMxaa1vhpptktShY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cIMWVYpV; arc=fail smtp.client-ip=52.101.52.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cIMWVYpV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4EY6nI/teEjYjIY1bmU/+r1uGGEgUHSqlDrQB1mrFS5PMsjJzUGVGZkPTHpWxfTEBvbi8WjcWtOzxhU+94jqZ6dKsNmWWJZKc1uU5Ykt6B83iNAEZu3hPpPSj5QyblV+TH16Qga0wmnGJSnmyNZ772UIQTUCr0jeMOsDvH24FjlrFx/L17GEZ5qJow4LO6hylFa72hTLFVhGYQKH6Z6h5fZdvLh+UgCeARi8okEZpuJWbfnV+tTXp1/zKIRpJVvbeYfZn1FseGJHmcgXBii5jorxb1LbQDKLsDrkLD/tPJMWtYSxzvKV8HmbHs4AH3Su9kSdbQPv/AwO7qH8hlMQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0OOcbG/k+Hg521Kpgbkfg6Szb+A1KZok2RvhkOmwyE=;
 b=wrBrJIP5S9B70ITrb2yySukJ8GTJM1EI4S1rwDICtGRQ8FbF+StYeiH7b77lq9cOYVDBdIGNudUQDSBwQNkZmNUPWl5cd0kxNA916mZRVQPVdMIql6NHnheyQP+JAR7gceftQC9csJFRE/hiS8uC774CBs4TtQE/rSGtXpS/SXN4N4v0HFkVOHhxYGPDj+hTrZqbOjDCsHiv3Icz0W2Ty411ZOcjO5Fbnq7WF7EaFb0r194Gq14wFatw1x304ae2+FK8AEpDof7Sd/DjNMgfX1o8PywNVRyGKNnLgH5MN0trcbXAmYRMhP2aMKzsgEQemyII65c6f69PTEf7ozqPRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0OOcbG/k+Hg521Kpgbkfg6Szb+A1KZok2RvhkOmwyE=;
 b=cIMWVYpVbjpYGr0NINj3NlEtHs/Ch6Z0FHNnJDX2s1P/LmoqWqVCQOipiy1cQ6q8XkVHhM3TLL2MbPZszykiyMzBjP/Pwx/ojuDhQQP/e25t0df7Mh+42tS3RhTtxYOJVmo59iW+xuRXXfAt/cF+Zy8VjRgCJTezp8GXY9PDLtA=
Received: from BL1PR13CA0388.namprd13.prod.outlook.com (2603:10b6:208:2c0::33)
 by IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 14:44:17 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:208:2c0:cafe::6c) by BL1PR13CA0388.outlook.office365.com
 (2603:10b6:208:2c0::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Tue,
 20 Jan 2026 14:44:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Tue, 20 Jan 2026 14:44:16 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:15 -0600
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 20 Jan
 2026 08:44:14 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 20 Jan 2026 08:44:14 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60KEiDfV1365857;
	Tue, 20 Jan 2026 08:44:13 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v8 0/3] Add support for more AES modes in TI DTHEv2
Date: Tue, 20 Jan 2026 20:14:05 +0530
Message-ID: <20260120144408.606911-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|IA0PR10MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c5f3fd7-beea-47dc-0401-08de583262be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FBWRTnEJODnuN0ZZuZdWVwU15aOtcCAB4IobPQRdLZYHC3SivimpRKkRZWpA?=
 =?us-ascii?Q?+DzwhW9RVX/d/XrD4eZu9hfAdkIsyWhz1K4ekONUbvVpA2f9B/JtmjkX+m0n?=
 =?us-ascii?Q?wnqMkPshh5m8HnFUZDvgT5lPb246x5OemFGvnLcf7mXWdWIHh+AE/pnq5k7q?=
 =?us-ascii?Q?d+IV+nt1I8L9E3NFLIHp+2QJ4wlPEoCVzcIWtYQb2gMOwsjC2yJQfAHy7jA3?=
 =?us-ascii?Q?KyFHWgoWVKe5o28oCRHcE0YMmgQz4PwdcOF7zCeBMZu7o4DPWReNvLxGnj89?=
 =?us-ascii?Q?4+NZ9+NuBKAxYTtYqnxgtMn0YJtKebtBzrlA/zUHIXWsIUlJtpthcZFvOWzd?=
 =?us-ascii?Q?QoF8IfWqSZI/T/MiGEQ91chqn5LSsJeU+J4NC4BrRgXf0fqFMQear0xV54AJ?=
 =?us-ascii?Q?AxLpdu7FeJhlQGSLuLSbOTA4pPeLrnDgBMY8ugp6EnLfXrEHiiMjIcNV/3wq?=
 =?us-ascii?Q?rrEgd19tpeV8PyEGTlrhC5DjYVTB2mf9IbY2XyogsC0Q6f7/1Ts+8jxwyXuy?=
 =?us-ascii?Q?MWjZJWnI/p0Mdfz6/dy/v7FJsLWjiUazDU6CfHm4kLZBLrx4Z842o5R/Tn/q?=
 =?us-ascii?Q?7aWMAt1wQfDfkocN/p1Z9Y5T1JAn9bl99PcKeJAOYDi1n02/DU5k256a8s1M?=
 =?us-ascii?Q?RdWrknd6GMhKWhLAliLdsn85Pn6In4bAo3rDZCK7n8toMsMgD4gPSlgjNaWZ?=
 =?us-ascii?Q?kvgyuDILjnxQ2BZ81T6SJogmv0JFZuEdteQPk0UDI0NUvxFM7VKEg98n9Sbv?=
 =?us-ascii?Q?sHOEXt168RFxHEhvms5aqELJ6c7785s4QE2i7euwY+rYGHna4RNoKIqdm6Bn?=
 =?us-ascii?Q?nNFrpiOSLljQ7FEIvpJRYSw0UIArdCiAx/HS/47Bqw1e00mvpOey7oH0qa0t?=
 =?us-ascii?Q?JT3xHboscvUyNiR94sdUqDLwoZra/kJOIofaWc7cWiM50alVofv96q7j9096?=
 =?us-ascii?Q?5binR0bdDR+fqZ/ekH8kzX+9Gx7ewUH2w6AUOKM4zt1BvoNirF4WQ1Y3UIYG?=
 =?us-ascii?Q?uWzED3TCwNA3MYeJvVk7mUiU+hO3nbW/TqwQjQRgmInEiaFwJ6WXQvkhaG02?=
 =?us-ascii?Q?AIiLET7poNE+wNJZwdhqgWfOCrB5kHn2oSmXgZGX7fo9FFBYH03W2F3OKsJ6?=
 =?us-ascii?Q?x3r7bZtiYEK6ESiEp+EPftdUb+b3vqpDPcFQ4HPfnjCjbyuQbC/W6Mb/HRFM?=
 =?us-ascii?Q?6dOO7qn/fXF8vRE1QpGkmZYeGaZHr+aEkPGh6oci+ygqLWS5sAfw7MW5jzY4?=
 =?us-ascii?Q?ijJhp49dMdnail/cc4IcOCFYFFDSSF5IbitrZTCPsD5FCof7bjLUNT7L0X/q?=
 =?us-ascii?Q?7XoIX6ij2qsgKsgQXoLsD987N1TJYp6v+jnGPzWU9UOva5wgQWwWZZN3SUNw?=
 =?us-ascii?Q?BTb8TcJ2/sYGK4H9OfqE+JhCRnBZ9I+jf4I/CVbTLhfyhlnMERhyP/drSKh3?=
 =?us-ascii?Q?mZ0DDFepeLpxX4qy+KZJJ2KlE8dkA9rzyDVI1KLDeiFivuhIxAQZO1B8aCMu?=
 =?us-ascii?Q?Lca2J8+M8skSr58sSWFGrXIS4WwmOV6DomYIG4LZgjEgRo1mSPxRDIzvkSkz?=
 =?us-ascii?Q?wGYdGeL4laMORT2Fz0HP6Ucb7tnVd68sRweOdaC5e/CxU01hc6holuap8St9?=
 =?us-ascii?Q?BBbRoFQLl0vqtbYo6hUgdLW/Ml2rfuXW/FU7gp7MCGyQlI2wF8hMJCK1E9i3?=
 =?us-ascii?Q?o2Oz/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 14:44:16.0207
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c5f3fd7-beea-47dc-0401-08de583262be
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7349

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 and details of AES modes supported were detailed in
[1]. Additional hardware details available in SoC TRM [2].

This patch series adds support for the following AES modes:
 - AES-CTR
 - AES-GCM
 - AES-CCM

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 AES Engine kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v8:
 - Removed scatterlist chaining from AES-CTR, along with accompanying
   helper functions added in v6. Replaced with sending only complete
   blocks to hardware and handling the last partial block in software.
v7:
 - Moved padding buffer to inside request ctx.
 - Removed already merged AES-XTS patch.
 - Moved dthe_copy_sg() helper from CTR patch to GCM patch, where it is
   being used for first time.
v6:
 - Removed memory alloc calls on the data path (CTR padding in aes_run),
   replaced with scatterlist chaining for added a pad buffer. Added two
   accompanying helpers dthe_chain_pad_sg() and
   dthe_unchain_padded_sg(). 
 - Replaced GFP_KERNEL to GFP_ATOMIC in AEAD src and dst scatterlist
   prep functions to avoid deadlock in data path.
 - Added fallback to software in AEADs on failure.
v5:
 - Simplified AES-XTS fallback allocation, directly using xts(aes) for
   alg_name
 - Changed fallback to sync and allocated on stack
v4:
 - Return -EINVAL in AES-XTS when cryptlen = 0
 - Added software fallback for AES-XTS when ciphertext stealing is
   required (cryptlen is not multiple of AES_BLOCK_SIZE)
 - Changed DTHE_MAX_KEYSIZE definition to use AES_MAX_KEY_SIZE instead
   of AES_KEYSIZE_256
 - In AES-CTR, also pad dst scatterlist when padding src scatterlist
 - Changed polling for TAG ready to use readl_relaxed_poll_timeout()
 - Used crypto API functions to access struct members instead of
   directly accessing them (crypto_aead_tfm and aead_request_flags)
 - Allocated padding buffers in AEAD algos on the stack.
 - Changed helper functions dthe_aead_prep_* to return ERR_PTR on error
 - Changed some error labels in dthe_aead_run to improve clarity
 - Moved iv_in[] declaration from middle of the function to the top
 - Corrected setting CCM M value in the hardware register
 - Added checks for CCM L value input in the algorithm from IV.
 - Added more fallback cases for CCM where hardware has limitations
v3:
 - Added header files to remove implicit declaration error.
 - Corrected assignment of src_nents and dst_nents in dthe_aead_run
 (Ran the lkp kernel test bot script locally to ensure no more such
 errors are present)
v2:
 - Corrected assignment of variable unpadded_cryptlen in dthe_aead_run.
 - Removed some if conditions which are always false, and documented the
   cases in comments.
 - Moved polling of TAG ready register to a separate function and
   returning -ETIMEDOUT on poll timeout.
 - Corrected comments to adhere to kernel coding guidelines.

Link to previous version:

v7: https://lore.kernel.org/all/20251126112207.4033971-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20251111112137.976121-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20251022180302.729728-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20251009111727.911738-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250910100742.3747614-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for AES-CTR in DTHEv2 driver
  crypto: ti - Add support for AES-GCM in DTHEv2 driver
  crypto: ti - Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   4 +
 drivers/crypto/ti/dthev2-aes.c    | 860 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  27 +-
 4 files changed, 889 insertions(+), 21 deletions(-)

-- 
2.34.1

