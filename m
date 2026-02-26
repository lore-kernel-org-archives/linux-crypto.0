Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012011.outbound.protection.outlook.com [40.107.209.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EBD2D9EDB;
	Thu, 26 Feb 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111484; cv=fail; b=mEE5uOq2/yF4WOTJeIep8g7PZv53PCcIJJJ8BWs3SI7w3ZKiEMj7gJ8Jcvhvo2cTSWP5zhXTfyPPAYBMV6ssV1lIK6up6fYGcWB/aiJoAxFAdIJAPLiRD9tl8ZjEour/mxNsScDDfbS+cLL+A8PTU462ZSz5Nc90qKRSJlNa1Ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111484; c=relaxed/simple;
	bh=8PCFVsvjB0Ql46a0X1eX/kNp2WDZzJFAEW8x2+4j+eI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EurpphMqhbiACwHrahaGOiZItWfDiJlk6jztxBGwYjc7zRzf55fWuZsO0wpPAzCUjfyOHmtrYOFUVBhiT5s78q3Y8EZdzULwm3IDnODaBQuNuuo7SVzTH9tURwQ5ZUpOC+7QjmKeWpMmMKoHSZnxKUgTzGqbNHLBKbkqa+mIYnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=giyNYOHo; arc=fail smtp.client-ip=40.107.209.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="giyNYOHo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgfuGiDE9QMrE9mTUiIDnN4dEVZ5CgGjtv7jPit/Nvv8LYLH2T6rIgUP4CfkXwMFt0Tj3vToS3BZVednHHeSGf9hCGEXeXsHWwvD4PF5TaOINFWgZXKKUEkso47WOg8v9S3aEFh7OOb4/LCABHuY1X6L1cP6/9sAXB+eS2aoCdUuMwtNdo37dU0iDe+XvPgzAiYvHlacbURwjxhdiuceNJc16K9p5VE2Il+RCcuiPsri9Sp68YwtuRSyUA35OhA2OB9DmifVOiydEItwr2yTNr5YCfVbeGPbpodjpLc7JvL2XWM6+ARvTwlM2E7Va7Rx4RbaZoAnIsXYp2fChOsM9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f10NGWA1OjS2WILYTgGdfSEU5oLOC36KR4diogdPk28=;
 b=rdhWk6qbn0cbLKphZ0fHXvrwg2MawlocBQqET7QvMJYSh/wWmxjm1YM1fqPFIYK8ZhqurP41WK80LSGgcmhPjN7l4Z+ff+oiOB8hLhimiD8koYWHJye1dqn52JFVY/nG/q+iDztPrQksZR7IdR6srXufV9WneRmNbkb3GKOLg9uDWWoCROTExZVTEgQLoTLCds4CWrpHwQzluNEvlALuNBzZyO3xsp1WaOP4x+EXCSwKOYV+mHT9h3ZqcnLC99/D96uW6H/0mwxuU1R3lyNv1t8TFm0eoocV69D3rlyyF42nzxrXmi/uqGF9tHa7/2hB+ATVeOoXbfXI7AETmi7/Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f10NGWA1OjS2WILYTgGdfSEU5oLOC36KR4diogdPk28=;
 b=giyNYOHodG9l4M7rKwSvl7FRAfJHiUZYfp5efPJWkD+ubeDnTcuyu9KUgrYdbxESuObUqdVKvczUmpgPXWbgoGJQ4bAofXLCGiQ1yi+plEowjSjHmXpEEL/nb0cHEechiW6j5bg+1fMhGNLFGIoqVvZN3Xz4UArjNTlfbcbYf64=
Received: from BY5PR20CA0004.namprd20.prod.outlook.com (2603:10b6:a03:1f4::17)
 by CY5PR10MB6071.namprd10.prod.outlook.com (2603:10b6:930:39::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 13:11:19 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::4c) by BY5PR20CA0004.outlook.office365.com
 (2603:10b6:a03:1f4::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.25 via Frontend Transport; Thu,
 26 Feb 2026 13:11:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 13:11:18 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:16 -0600
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:15 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 07:11:15 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QDBEmm1917403;
	Thu, 26 Feb 2026 07:11:15 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v3 0/3] Add support for hashing algorithms in TI DTHE V2
Date: Thu, 26 Feb 2026 18:41:00 +0530
Message-ID: <20260226131103.3560884-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|CY5PR10MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e36220a-cc9b-4f60-7fff-08de75388772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|34020700016|36860700013|82310400026|376014|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	WZkMjWzfdDKLdkv6UrRKHzzc+wuwasLWMeJ23Xc0G+pUFoKYlLorCIyXMAaeSShgnK7A7j6KzIQQwPx+MY6O7WmP2CUS3p0qxC5l6L4VHfx8ICfSO7M+CF7GsFP2KAcqz5mKf5tB8KV7MpZm+v2AJXVOp86tqclvodkpZPFqGYR/2mc3+Lk5u0gbulne8PBR0hZUOs+GRu1d5xYFD8dIadLuhDQtk3MMJu4VEZOIEFjSTCIXJcPmH0vEbtl1Y6v1nk1dXMs0r7q4P3UIppG+Y172l0rM63ZxWOeitr1b3KhKjzW529Z8LE2+3LkTpZ6yI00bbqRqMUO5JCAOGqo5WUfT6VAnZfbh27x5ERoRyp/GeFUucZrX0CJntMPre4ke8uwtCuMarHgTiQzYCBZwtAGJ4qflJIyeqWz75acSKB4TU5xV5CihOgjzpIIfZ6srkrqRPtr7LiXpq8KAM5AQD01T4TYh/G8ljm7WiNcFvVgsTvnf7vbLYshbFzmIEEJ49gZA37oSDpYO/1h5IYmVnpncXH53HDeWg3ErLExk3LBxqki8QPaDPbWE5sNgyTsF+DFAZ4KcnIcY+b//n67h/xY2PorTq7mIw4DhOU8DqfLBKR+T3Sh/ZdNw21m/VBc/MaHHJkIbHFsf3QJ8u/md0XoeSXy8ZLis9SKP5DlAXgD5+b3ZwlG+ZEDif8rLW9BpSKxuuWCnh9KGextkEwjeXHuObLaJ0PmssYhcQ6jj15lMKCLNEuJC0TNLOBPTcRl4NPpetGRStyLCFtv0ocs6mV0vo5YC9u9SA8vz+0YMwoE=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(34020700016)(36860700013)(82310400026)(376014)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jnLaQ1br2mxh5Qged5dOJ8T1138jERC3CMVr1TucYGSJlp+CgM9Wn2JeINnHJZ5rB31kw8zdLFH9+cBqBYIxqwsx+yTqgpBCl99Rq5yM/T3X1AIhv+mgtSxyriEBSSnzEz7QOmUZttL2JLszGDSy3EwNGkmXSfkUfSKV6qVvcQNdxAKqxauB8OkMnL49xTl3FkMXz1tBgKaz8PlcNA/e8ypNs85f43vtKWJxZpJEvDDZjTTbWiJ5N1bujEIKdW/3ezG3tQXJJnZP3+m8NsgSJCUc1mZyo/nxRriIs7Adwk0yF7QWkAF5A/l6+ZippUEBrSzILinwr1WrWTH3j+ShQ/BYrIFLVAsvMlYzhlB1faxhqXRQC7FBoySxqSyKRij7kZBmzi+kAvRpXpltkqPmqhKo9+1/NtHktQo+Vk6LaJcYZjed1IwNJ5vKcbW6b6/P
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:11:18.2871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e36220a-cc9b-4f60-7fff-08de75388772
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6071

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 and MD5 as well as their HMAC counnterparts for the
hashing engine of Texas Instruments DTHE V2 crypto driver.

This patch series depends on the following previous series [3]:
[PATCH v10 0/3] Add support for more AES modes in TI DTHEv2

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [4].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: [PATCH v10 0/3] Add support for more AES modes in TI DTHEv2
Link: https://lore.kernel.org/all/20260226125441.3559664-1-t-pratham@ti.com/

[4]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

Changelog:
v3:
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v2: https://lore.kernel.org/all/20260121132408.743777-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
  crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver

 drivers/crypto/ti/Kconfig         |   4 +
 drivers/crypto/ti/Makefile        |   2 +-
 drivers/crypto/ti/dthev2-aes.c    |   6 +-
 drivers/crypto/ti/dthev2-common.c |  43 +-
 drivers/crypto/ti/dthev2-common.h |  58 +-
 drivers/crypto/ti/dthev2-hash.c   | 922 ++++++++++++++++++++++++++++++
 6 files changed, 1017 insertions(+), 18 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

