Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011063.outbound.protection.outlook.com [40.93.194.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F19434B683;
	Tue, 11 Nov 2025 11:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762860116; cv=fail; b=Rw+bjXMh0pyLcVQOkFij6knXUgNuVQokbqEBm+Sqattx6e3J8MajbEEn32OO0I3N/DWNfB1BlQLJKzr9Z73tz4XH66YzL+5ghiWTlb1zlBtiRkbbOAct8ymmYGfzr7UWoqRZsMVMLW9eJkzG6ecKWq/2STuruMQ4f3EqC8XuW3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762860116; c=relaxed/simple;
	bh=gCGLt4uy9IGLN/ZmjXL5UsAZ14t3LyuF13JiC321BkA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKcigngkH0qXKaDZeRipbqV4xH9fZ7hYN5t4QktAoznJo/eyZ3gZ63bORBsV4MHXkALahDZxbYj2Rxa60FMItIdLQzB7+D15z2KFiT62CDkmwcbZ5N2SZYMqY/+lrQ8wAf6J3jmJIF63AMus8T3SW7GXweWdOa3JHUPxkOEJewE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qdp4U2TM; arc=fail smtp.client-ip=40.93.194.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qdp4U2TM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Aw8zGop/tr8f3zfCq6x/W3jxyBUt0HnxD65uOXsVUnz/TAdZVoqDpRg0PtybAM92w4RovJ7trcyxhTJaz3Q0DmietgGhPMR+cNUk3dyu4jgokGCj6Ge86noifXe2G+NreYHqcxhVaULN/WW3Ii7h/PxZX2fcdqtlDt/VZT+EoYBLikRunEwJYCcX1Y2XHRsOxsnwwMY5Ki/ikrtUu68Gt78UtzF+mJt9EYe0uJxWFWpYBygE+yQQJqU49bQAUveajagKdJkqsJ0IRDfNuY//sfuq33F35Di9TB42vJ9388hKgYOgOSHdUtmcfY8GduvevmwMNc+YcSw7YELH+++4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fz04j89tIaVo7xyhXvepye3oqUlKfWLjAd/nd0nddGY=;
 b=saYeZi1xpwySo+/X2DyO+H3+hE334V43iN53l1Dir8W+hDjd8az1DxPXFRIxMucYQ0mGVpqdsk1mHzeoeBiBmOWGn+6hvh9FRvvHWCZLicku5e2YAjfP8/oIQUUQ+vXeoQMjYmlgy3bEs94JjiDZAPFx/Cc+8UOd+BsrveZMsmKnij54IyhdGafzyUYrt+uqb+awySh7YNzWi11qY4GEj8B32LyNQWm0nmTJrR/H3PDliWuvb4HMTzOMgFbe6YRjKEhFuY53Zvp15m8+oY8OiVidDBmx/F2rJfIumAYCTxV19s0BniyZOM6uuCuiBEMGVBgaenoQSNoEGHmNpYwowA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fz04j89tIaVo7xyhXvepye3oqUlKfWLjAd/nd0nddGY=;
 b=qdp4U2TMsNi9BcxuVDmscgjrtwa4tmxg5ipbSwbzsqwoAK8LGlcRhGgQjbbGex/3X54R6leQYYVWje8/0xH/rA3HxGr4KWa8KweF7SfdsABvqjFHIwNOg5ez5yV6ZJuf5mPmKU/2v6iFrWnDumuxco3yTne/hNnCqQ9F16qAFHA=
Received: from SA9PR13CA0011.namprd13.prod.outlook.com (2603:10b6:806:21::16)
 by CY8PR10MB6708.namprd10.prod.outlook.com (2603:10b6:930:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Tue, 11 Nov
 2025 11:21:50 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:21:cafe::e0) by SA9PR13CA0011.outlook.office365.com
 (2603:10b6:806:21::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Tue,
 11 Nov 2025 11:21:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Tue, 11 Nov 2025 11:21:48 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:48 -0600
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Nov
 2025 05:21:47 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 11 Nov 2025 05:21:47 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ABBLk0D828241;
	Tue, 11 Nov 2025 05:21:47 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v6 0/4] Add support for more AES modes in TI DTHEv2
Date: Tue, 11 Nov 2025 16:38:29 +0530
Message-ID: <20251111112137.976121-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|CY8PR10MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e61a31f-2318-4c14-f3e0-08de2114816f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PbovpwxyqTLZFes+px41/rhxdc693kaUYfIhNy3S3NJ+oJ0Yf9cHDtInJBLH?=
 =?us-ascii?Q?DBNanVuDtLwAZQf/swTe/9FLOX1E8QOEVj0nCVQMKWb5ShYR5Ryd20E8NSBE?=
 =?us-ascii?Q?EsO8q5arBPMaWYPU4NoPqu8vvVudR/jdPNtEnRfafJWeRCSIWGH2CnbHD3/o?=
 =?us-ascii?Q?fBFZpzEbTa7fVgQEePvV9DHlwfNMfdsDvS7FcF5o7BWu1Q09nQKfXTekyV67?=
 =?us-ascii?Q?7wuFmHLgoc0E5uyt8vBZfFd5rq6a821VJPTmL27byplEhofB78BCCHG43AVp?=
 =?us-ascii?Q?4nZo7xcbM7Hn5njIpOBdLKWqh9LGaKI9BB3F41m6frUE1UlhO34UFfA7Cyeh?=
 =?us-ascii?Q?HpJ24VlTPWaBZfj7jxPPxpJgkdPhF8b6zX+b6/8qEnRklS5RgfFhoVp3NM1K?=
 =?us-ascii?Q?KPhk6I7mc0Xv9yaoKfvWG+vBx2sap9OTAASWw4Bf/AXgLrg0sZdc+B8+xm9o?=
 =?us-ascii?Q?51u00ovH7F43KprmzQUDvRG3Kzzy3WsE2lXiFK9PHAD+I6oXP+UdWl4ZABop?=
 =?us-ascii?Q?HTCNA47VYa4W502921pb4ODDJlRZFY0dxPj9MRPd6dKqF8QHF7gm1hkOOOib?=
 =?us-ascii?Q?/AsPpNxEQonym09D6RaKMGSDYmupiJCC9utaKBE5xkVhvxU/3prayufptQNT?=
 =?us-ascii?Q?zoO+K/y+TUfgOxTASlA8FazOr5+W+ysqSUCx40noZDZaw6OJq6Cy6XM6OqxI?=
 =?us-ascii?Q?r4IUjHVJDnHrn4FagFnV77j60Lx6ZTJfkQd9ecHRb1CTuuvt2DhTfuJaJYno?=
 =?us-ascii?Q?vIrtQ+6NES+xRLlewhgqkod4YyhWi/p3fIrVpi9Dj4qlP7ei45ykjAL/tILL?=
 =?us-ascii?Q?2aHD7YESgDW+o2jEa14XQKRoWep2IOPBiwuZDEAmaUq9evlqZu8ehwSKaV5m?=
 =?us-ascii?Q?d17IDtoWU/vwcfXRdWxW0wCKusCd7x2tJaHGTJ9nEwGI+0iYZ5JMSekQxCLW?=
 =?us-ascii?Q?zOkQy6+GHINnie7nIPaCriO8UhnNTqIKWhmtCBL+9P0xG3oedTzzX+E4H8wW?=
 =?us-ascii?Q?qUUrnvF8RW3PXah+OkjiEEBrZYbmIUye3B1duzvtVLpKMBRoSA6w3ZHCQbdu?=
 =?us-ascii?Q?OP4KA4dppkM0zM8+wV2xihxlLLa3s5kDkLFgIo7PJCwb7XEZO1KIGmkSmZA2?=
 =?us-ascii?Q?3R9XpFFYfUveDcCLp+SNML7v7baR7S/ElbuVz9METvkZrmINyI2U58SiulnS?=
 =?us-ascii?Q?bAspz4FtFFvhTapCGYJQK1S0lZTQgCKIgumfPzu71RC0UhEbsJuUSq/eTLxa?=
 =?us-ascii?Q?YpvFsGR2EGhvaOeDMutE2JByFzclMXariI0XWmjikeT6tV4m7tiwSzVeps6v?=
 =?us-ascii?Q?o/163ANa9pfsPOwn4fC/dEvNMiJRY9JrQAB44zSikMV4Se4v9uvBEbwGtCGS?=
 =?us-ascii?Q?Ai31KAk9wdXL603hTat1SUN0UpulGDGG/vySZGpPzf+StZkhOvxXQF6DOYts?=
 =?us-ascii?Q?t9K1jd7q/av4nxpgbI48GWZfqxNSjxysmnhuxXTvDedLqCOT6cjr9VVmz7oE?=
 =?us-ascii?Q?zZGJ8Y6i/ITddr6xpA/65lf6qrauD03/udDY?=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2025 11:21:48.7100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e61a31f-2318-4c14-f3e0-08de2114816f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6708

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 and details of AES modes supported were detailed in
[1]. Additional hardware details available in SoC TRM [2].

This patch series adds support for the following AES modes:
 - AES-XTS
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

v5: https://lore.kernel.org/all/20251022180302.729728-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20251009111727.911738-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250910100742.3747614-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (4):
  crypto: ti - Add support for AES-XTS in DTHEv2 driver
  crypto: ti - Add support for AES-CTR in DTHEv2 driver
  crypto: ti - Add support for AES-GCM in DTHEv2 driver
  crypto: ti - Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   5 +
 drivers/crypto/ti/dthev2-aes.c    | 964 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  33 +-
 4 files changed, 1004 insertions(+), 17 deletions(-)

-- 
2.43.0

