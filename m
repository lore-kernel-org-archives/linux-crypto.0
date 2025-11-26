Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1333176E4;
	Wed, 26 Nov 2025 11:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764156178; cv=fail; b=SyCDOswoIha6IdeUUbN2ykWCJqay92X7G6It/MNRD5QNe37cvLc5OXlMuY79ZKCgte5bK0WcMpYJmGe0sJVrdwm0Qb6zXV4AOPLLPCE3bEehlf1iiE+7UflTlHbJ33aKG8Mzb/xpK/w9sAi7vvKyO3OK9u9smY9OyL9ahHS+wSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764156178; c=relaxed/simple;
	bh=lSV1SqrMzz7rkK14inLSvQXU5okTUS5yzHOimAjJiYE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t10xvguYUdwd1Eu3QX0Lnfr+AjC0O++nZVZrFly6f++YsKoUo/ZR8aexkdf8gQ/wZTvXj6D4TvGpAHeuCvO6X15eEkzxo7qzUyc7KIrkgAlrnUPnBX4cVb0RFSgticjDqrLwB9XLpkQr8Nf9P86s646rjvRv8GiiEwebW179r74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=kLxe1d72; arc=fail smtp.client-ip=52.101.61.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="kLxe1d72"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGqGsk1grIs44rSJFYtqk9CqmczsQxfKpZJ31mC5AR4xYGw5aj9AFLCiL+Zrj6oycWa5PA7LLJzLMq97UFC5BFNC3E6ZLh/jdRb5P0toeTk4xYIxKaMTB0mTcXrs6uyMTGHWYJWQxwHZnLCSwttCYH436bbdK9oRTDIDM8kl+Fm6Mqu757TN+eZ2IO6PNwK7S9AhwSKTEUkFjLRwBCGU9nF0JnylEqtWtnlWqhuYPcZ6t+YGTKPQyX/LMsPdPKk0NWWXVnNcrW96pS7O1DoOdwmyHZNx2eCj2x/jD52SUvplfi5IkaBIC08KKwkxVeoPT9heT52iGMseZ6sHh5+G8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJi0ItJsnYNjIW7An2BeGbkP7QT00CUOPrVksvTD1fs=;
 b=qghOxSGdZz4lAOKel5zIdHCytaEp1BAZkw5nvQZvNMnbBwEd4E++ULtO8EG6vq25QrPunc9khlUHNzp6XYn9IKdFKHKWWzh3NWZha3/2LH++ofdmZ0tLzgZ2RjmUY8ZupnAhlnVLYF2Iw8UmT7aHq1/2i5T4TY0r83wBWF6tS+ge95s4ZbGdpJYbTdOQHAi2WFwS5pHy4Q2oUTUOnDnVDk7YCyeMRnP61SXcOwHdtkvXsLH4mEYssoEaJZZom8DCll5rQ9RqKmSNcaKiokN4Jf2WLhdZ8JhBL7PWFtoAjZs+rMJvhjZYy5j1APv718TwhDXzuiWOEj5V4uWiXfbExA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJi0ItJsnYNjIW7An2BeGbkP7QT00CUOPrVksvTD1fs=;
 b=kLxe1d72HiFEhLnmVwnRm3/qvTqlXbn5HNGMHLP54pxnnaAF70IkiZ/uYaa5olWij4/mpbuC2Vi3UIh351W1pivltkouWIlSiFwuKNQZz+2YAMyZ9cJToxWfxyAa2OzASs4jsv/RTQteYse2NB/bFgIvrI5qA/USI/zXXaoR3z8=
Received: from DM6PR06CA0066.namprd06.prod.outlook.com (2603:10b6:5:54::43) by
 LV8PR10MB7775.namprd10.prod.outlook.com (2603:10b6:408:1ed::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 11:22:53 +0000
Received: from DS2PEPF00003444.namprd04.prod.outlook.com
 (2603:10b6:5:54:cafe::b5) by DM6PR06CA0066.outlook.office365.com
 (2603:10b6:5:54::43) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 11:22:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 DS2PEPF00003444.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 11:22:52 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:22:50 -0600
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 05:22:50 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 26 Nov 2025 05:22:50 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5AQBMm1Q1140973;
	Wed, 26 Nov 2025 05:22:49 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v7 0/3] Add support for more AES modes in TI DTHEv2
Date: Wed, 26 Nov 2025 16:46:14 +0530
Message-ID: <20251126112207.4033971-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003444:EE_|LV8PR10MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: 352daf61-e4c3-4d6e-79d9-08de2cde2377
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QOMOt4vebRMDm2a5og3bBSZy0cEk2twP+R86vamIOVBq2ax2pKLCCWy+Rw/T?=
 =?us-ascii?Q?9bZKfOOJD1vv88+mtHgBQjtnICI/BTi8LByJzSvJYjHHXeRBR1LoaIAlolBs?=
 =?us-ascii?Q?wjFaFZOtokScEnoSnf4vnjjUQvg3uBJp7oVi6Rc5QrdnIml4eq4qA+I8IjFu?=
 =?us-ascii?Q?GZmaWB8jJYppQG5NgAwKcvAMTWB6u6HVcDxtgekZKBf2filyvnJmOIWlPf1n?=
 =?us-ascii?Q?lQySGaQUszKiYDS2SWZQ92Djf9XtnHSUdAkm8P/lX/UhHa8oTZS5O9+vTXwV?=
 =?us-ascii?Q?pKuMpN7uJxaTyqJJwlJSpshYQNlQGG6o6kwNo+JlFLwwjmVOGjPF7AJfIgLT?=
 =?us-ascii?Q?TF7zOS1fn8U4rTHYs9tBSKmY0H1VfXVw8jfXc1CfQyhaaPQn/GEBl9Rtu7Rx?=
 =?us-ascii?Q?Vq9APtgRcqoSDKpsG67IluyfS8AYB2VxOxMh6hrT4fbBgismgMvMb62Nsyen?=
 =?us-ascii?Q?Ql6Ouws4E0cQrcWsd08r7LLKN5AhaETM08uaMqohDyxc+9jlNWZfh95qMWw7?=
 =?us-ascii?Q?Sjl7a8KdY/Kdw06ViGxhRHfuD/OOSiA9MPRh3tnMaaGox8OZvedoomWOHxoq?=
 =?us-ascii?Q?N7FsU8JyA9WxEQgogUcSVk8KVh0S6Iuc5N7F0pPMb58E5oyyvJxoo100CgEC?=
 =?us-ascii?Q?DM79v3VT4Ei/fCriuBXXOUsKadDr68yVJOaRm1Q0MYHct7E5Y+8aWvGTG7UJ?=
 =?us-ascii?Q?xFi3GxCA/+ivn+YXOMhTfIjoVPnE6FdWLll80o5J9nu2Zg60+yrBCd+cLhX3?=
 =?us-ascii?Q?kDVwJhqcnNSkaUP2gfb7jnNVihtRTvK/tf2w2AGamtJ50hh/DDLVf6GkSlWV?=
 =?us-ascii?Q?oh5er6wp8jwHA2CUtdogj2kFYD/Ye2iAUQqXv7XIp2bDbBkSRPA7BTIzjnWx?=
 =?us-ascii?Q?gRWolG2aoFrNiYlV4fXyxgd/URmL2r5HHo4v62RQmxZz8u0fuzSiJi71TTtO?=
 =?us-ascii?Q?kRTPOBiGvAs+rU9YQbMDSsXHSXrsH4cZl82jNJkHn4OePUiFh+iNNjF8grs5?=
 =?us-ascii?Q?CJgPs2w+VtH4f4O0LBkggSyuU+CETqGWx9e0TeUxCrZ/JMK1PEvHPOv8/eJZ?=
 =?us-ascii?Q?bRIaxaR8MQ1yCxV+jEjrpgoYFtwbwIfKFEZwUDyJOcFReT44EK8U9vH0x10p?=
 =?us-ascii?Q?UCMb+tLBoOT/0pBoAEtZ2U+vuWPqwC+HKBO0uhHuDF1ncGvEqsdo6Af+LEpF?=
 =?us-ascii?Q?w0xNP8yROFfzenVR5C8u0WXLtNwa04HS4wc3BOKBr21PrbpdiIEvj/26LKYy?=
 =?us-ascii?Q?+OAnZgo2VoVQz9Rds/vKQGc0RSty56/4SlTl4sp7BKp2USvdYxokeXeNMSxd?=
 =?us-ascii?Q?eeXCM4AaojXolD2I9Xiy5+l6TSpVoYSpSTa2yLc4mrUWqOa9LELc01FAXRCl?=
 =?us-ascii?Q?NfXNKBSyzm4994o7zVa0WF05BsuYXdteIO3xvUqk1OEhy0d1gOB1+eTNrWPD?=
 =?us-ascii?Q?E8/KAyNXlTj6aSiRkeA/QX4r+PrLCFtlls416V+G9k91RmAMDnoeVv9Dl5sL?=
 =?us-ascii?Q?MKBv8omxsKKpl7XkMaQQVtsI7FanHbFHXN20jMhAz6StCGqdzET5yRyjjbeX?=
 =?us-ascii?Q?T3yLVoRmLREJ2cqgwMQ=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 11:22:52.1560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 352daf61-e4c3-4d6e-79d9-08de2cde2377
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003444.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7775

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
 drivers/crypto/ti/dthev2-aes.c    | 832 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  28 +-
 4 files changed, 872 insertions(+), 11 deletions(-)


base-commit: ebbdf6466b30e3b37f3b360826efd21f0633fb9e
-- 
2.43.0

