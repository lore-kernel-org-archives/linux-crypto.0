Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE3B2BDC02;
	Fri, 19 Sep 2025 19:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758311593; cv=fail; b=g4CTDCLm3mVeXtY0S3tB3riof20RfXBDwHj9+L/wg8a4eJfHUrNd5pivQQjKoCoVbn3YYcRgqwWEzNPGijwx36IKKeuNIXzUdRcUNJvtDvln8bTMkM1oLv7eOWZSsXSn0U6X7qPDUxxioGjJwUSVeOdgoJm/SUttMM0IknjAp/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758311593; c=relaxed/simple;
	bh=FZI2PZLgc0I8PEJCV8VKSQ5ISKoG+WPi+RUhkZ3IbHQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mvoRhl+NPvI4lMqf7UnUu0DSs98HWl8rSCVWztpbNz+s5I/XqCKkgqb9FVbeV3ZXSCdTlzfMpM+6aZcx4umoyW3Hn/kCAy9euSk0uA3H93GPJVjjuRBGu/jT2Zwb1dQH2Y8W1/VNRgRpb2x3psvE+kPRPbtirHhfT7BvqyYa+B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bhEUeLrb; arc=fail smtp.client-ip=40.107.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bhEUeLrb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TEM/Z9nCEp4L0yxc4i+tQ5uBicgbzAo6Ywgp+ahoyWmaxtaG4A2qEqm7zHVKWYdtXUAL4dP8t+B0+apCP9/lPaYl49dl5oxEAirs9gFinsZVvn7CxFIMm4JmrNNqhFKQ3NsBOjEwDO7I3qlGWI4IPqLXxPxoFyPnuLpjkW+3KKBykI3dHuE5tVAZO6VNbhmFV+5WBXuK+WAnhvawtLlFWHZIkalBGYYvZbpqdkoLAeWpZPjaFRSlQQY1m9TYy75F15H7z82FZtS71kO/fNzft970vjbCHZ+LhQ+w0qI4wHT3psjfvV6YigSV4eA5Vpf8rmpQvhrE4I6+3N3P1xbjOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sI2tkMTSriuejgoV7c9qUPAbCiwja3GkvgmV+IC1UhU=;
 b=aLBx5pu09s961EST55TWuesSsDaZEFlbyfL2MaaIOdJE0B0gd4rKU7q4WaUPZYmrBRhsSJGEykBxytTpk8iB934ntPXUXemDYgaXag2Gi1TBgRjyw8feMPwj7YB3KIMi6wEC/NexfoC1FDY9ajBufyByixyLil2/PQrBpezgyZpHFQax9DDhXI2YmnaP5Mj9H7Jc4lhqg5sG8Mq9yTfaJFgcW+yEXKqEfgQRuKq65OUQLHUe6IrqYFqwAUOjpEZEd7ssAx3q7HJMOareRKBbf9S0vXvLrawyNpmBqvjW1t+svLjfYspCNQcfdcvXMbOaKLUNKO1lMEPxUX7pa7RQMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sI2tkMTSriuejgoV7c9qUPAbCiwja3GkvgmV+IC1UhU=;
 b=bhEUeLrb/7t4rG+4mLaWRZkRrhCqyWAJE1Bb9GfGsJWH46MLzsGRMxNLu1bCC4X3r8BoKPzBHI0L6oy3hmhwSZxXgnOTsghEXI5Wg/Tp8OE7kSVSaVJK3Neuq9uhUwQKc6aWqQP+zZD/UXRYb78W1BRFODiZnCFVaUfzIS6d74AypVCLFw9yjQ9UGaUWSIuhn3jAHFrrS9OJkIBFQUNMkK82vV8jN77mP92hRXiI2y3GvBEY58AJmwKvvHb6p4Xq5Z2HJA4m3z9Kg5QLs7CxvylsdsL8Woiag7Zk8xq9qwT38VjyyVaMZ8RqqwXdJ+5Wptxy3y6OTBGX9PNZjstvuQ==
Received: from BLAPR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:36e::11)
 by MW4PR12MB7000.namprd12.prod.outlook.com (2603:10b6:303:208::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 19:53:07 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:208:36e:cafe::7b) by BLAPR05CA0008.outlook.office365.com
 (2603:10b6:208:36e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.17 via Frontend Transport; Fri,
 19 Sep 2025 19:53:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 19:53:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 19 Sep
 2025 12:51:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 19 Sep
 2025 12:51:37 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.1544.34 via Frontend Transport; Fri, 19
 Sep 2025 12:51:37 -0700
From: Ron Li <xiangrongl@nvidia.com>
To: <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<vadimp@nvidia.com>, <alok.a.tiwari@oracle.com>, <kblaiech@nvidia.com>,
	<davthompson@nvidia.com>
CC: <platform-driver-x86@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, Ron Li <xiangrongl@nvidia.com>
Subject: [PATCH v3 0/3] platform/mellanox: Add mlxbf_pka driver for BlueField DPU
Date: Fri, 19 Sep 2025 19:51:29 +0000
Message-ID: <20250919195132.1088515-1-xiangrongl@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|MW4PR12MB7000:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b4b652c-e04c-4743-ccbf-08ddf7b62747
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ion4/F0kkiSZEzUAPnu7Z3+t2nwxwM8Rn0AySFMfMooGIc8Azy/G0HwTeqlt?=
 =?us-ascii?Q?N2KgKWIPGof6Hvwmjy2P41G2P565nDYTFBzVvmz4KPPb8NGC71jQ48yA4f41?=
 =?us-ascii?Q?4XXbpTlodn+4mBb95or9GIOZ48zaD5QYEwzts1YWhYTK348HBTVFOKv9Vh0g?=
 =?us-ascii?Q?C1C4ps657jz29uAbvBrMuFxQBov4KXv2HO+3LuFLoJlOx6gI5Lu+Mb9rV0yB?=
 =?us-ascii?Q?nALiKgg3n9NNJQAPLthKXN7j60lLzxFPcL19drB3BX+kxn/ReGn1J/35qukg?=
 =?us-ascii?Q?cmTWV2b38KyC2sM8UNk/PFtagH2OdxpSO+YEyu5hqj/k9tY24jFCRh6rv+VA?=
 =?us-ascii?Q?yTawCcDYnFvpHdeafetPhvG4UmtAZdBu+ZQdea9dnMYMjXQpQT07pinLms0d?=
 =?us-ascii?Q?Qe4Nq4p7zsCwvdWko0H+g8RAdZYlBE0mfekO44jd3ZcPkaqEQ0rYqLJ5xv8v?=
 =?us-ascii?Q?PlDXMPqMaiNZNPhNQQ5pVZJEXINbND05afgoUTkEzgKZrIE3VL0gzNyaXaoR?=
 =?us-ascii?Q?WCEpXPguhe4u2GotWK2abS+ggMaur95Xp4EWdXSxfXAtHONGl/v6On2etwcI?=
 =?us-ascii?Q?xGI+cPd4NqLoDok7yBgnkNKmMCTjEmks2hw4O4GrA4xgmLpGp91XaiuCUE/R?=
 =?us-ascii?Q?JMGl7H7F21mKV6YxE5oACpCEqrhJlQ3NrbMhtaVnF2n8XU5sM4Z6ltvH82HE?=
 =?us-ascii?Q?u5dmUx5gDIjEQ2nL6lJwllWNq8VE9tn/fgItFPPIqowsGfWAoOO/aS5nMUUO?=
 =?us-ascii?Q?984g0Ntm3JJFRrJlUwAVya2IOwFzUEf85BYzJfI5RZRz1eEWN9iUDl/3WdX5?=
 =?us-ascii?Q?5gnVtZtoJFSquPgOnobqAL+jLn6TWPApqQaavpLX6K2/ulQFP4YYA1KlQv6O?=
 =?us-ascii?Q?r6oZ4lNQHuqgJrA5cCtsAgfV+0AQSy+nmlRsVyYoXEFK9Nh2G2+UrXdgyXa9?=
 =?us-ascii?Q?J/1JdfTVxSR68rui2tPSoENerAIhynWdfeRomU5EHyf9zsNf1+dPvkfDIYtc?=
 =?us-ascii?Q?X3PFEh1SGcDXX/Ms6cKmVtpURCNhaXo/+HvuHgE3fiKs/AXGlVSkTOj6RJda?=
 =?us-ascii?Q?sUtvTa+ONHVeIMxHitAF4BUrDxbXMwPTzUKCN+qkxs2s27pTW9Zwh3MRXjl/?=
 =?us-ascii?Q?yjzGIU+0nFLFH8pUvIqw6TD5jcemctL3hYGHhYDu1SkWQdPjDZmq4krJBgye?=
 =?us-ascii?Q?77ZeMvtaJgZnZpRBbOaUQNaQP4a2nAyPdlXrFV2mqE7Kg+yiG3edheaHCrO8?=
 =?us-ascii?Q?Abb6Bk9mhgbCYT9qyG4bISCOF+JcEzrDsvBl3rk8dGAiHoAU5cUJh7vJMYuy?=
 =?us-ascii?Q?HpYHQS1sobJUuovTM0/C9bOcOfUxZv3XTzjnflkIHE8Gj4wbCtsLbKBJCfw/?=
 =?us-ascii?Q?7BwMWJ2he4kub8gNf0L8Sj/Set02sdb061jdGygzSTPMun1BnqblNpscFk+H?=
 =?us-ascii?Q?am3GRIlM98MQwhW7jZwWsYfLbnqIGOHiyXTvVpIRNQEeI9Uht7Qo9mRf+uq7?=
 =?us-ascii?Q?kUG6M1PQetnrrv6fULKlOXO0hYkNE3mjPeNE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:53:06.8324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4b652c-e04c-4743-ccbf-08ddf7b62747
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7000

This patch series adds the mlxbf_pka driver to support the BlueField DPU Public
Key Acceleration (PKA) hardware. The three patches in this series are:

Patch 1: Base implementation that wires up the platform driver and the
         device/shim layer:

Patch 2: Add userspace PKA ring device interface.

Patch 3: Add True Random Number Generator support to the BlueField PKA driver
         and wire it into the HWRNG core to feed kernel entropy (/dev/hwrng).

Testing:
- Kernel builds for ARM64
- Tested ARM64 build on several Mellanox BlueField 2 and 3 SoC boards that
  include the PKA hardware.
- PKA shim devices probe and remove successfully
- The PKA ring devices presented at /dev/mlxbf_pka/.
- The PKA device validation test passed.
- /dev/hwrng present; rng_available lists mlxbf_pka
- Generating random numbers succeeds on BlueField platforms

Signed-off-by: Ron Li <xiangrongl@nvidia.com>
---
v2->v3:
- Split the source code into three patches to improve the readability. Each
  patch introduces new device features and functions.
- The latest kernel APIs are used for each patch in the series.
- Updated some variable names to improve the readability.
- Fixed the logic in the mlxbf_pka_ring_mem_addr() function.
- Update all the pr_xxx() to dev_xxx(). Except for one pr_xxx() print when
  the PKA device is not available yet.

v1->v2:
For patch 0001:
- Move ioctl related definition to include/uapi/linux/mlxbf-pka.h.
- Changed the ioctl number from 0xB7 to 0xBF, to avoid conflict with other
  drivers.
- Remove interrupt related code, since the PKA driver uses polling instread
  of interrupt.
- Use devm_kcalloc() to allocate memory with calculated length.
- Use read_poll_timeout() to handle infinite loop checking.
- Use lockdep_assert_held() to enforce serialization.
- Create mlxbf_pka_drv_verify_bootup_status() to handle duplicated code.
- Remove error handling in ***_remove_device functions since nothing useful
  can be done.
- Fix the rollbacks in some functions by adding proper goto rollback path.
- Updated all comments to under 80 characters per line.
- Upgrade some constant with kernel definitions.
- Include missing kernel libraries.
- Update some pr_xxx() to dev_xxx().
- Use FIELD_PREP and GENMASK to handle mask and offset of register access.
- Refactor some code snippet to improve readability.
- Update the comments of some functions and type definitions.
- The FRO in the source code stands for Free Running Oscillator.
- Fix typos.
---

Ron Li (3):
  platform/mellanox/mlxbf_pka: Add core BlueField PKA platform driver
  platform/mellanox/mlxbf_pka: Add userspace PKA ring device interface
  platform/mellanox/mlxbf_pka: Add TRNG support and hwrng integration

 .../ABI/testing/sysfs-platform-mellanox-pka   |   35 +
 .../userspace-api/ioctl/ioctl-number.rst      |    2 +
 MAINTAINERS                                   |    8 +
 drivers/platform/mellanox/Kconfig             |   10 +
 drivers/platform/mellanox/Makefile            |    1 +
 drivers/platform/mellanox/mlxbf_pka/Makefile  |   12 +
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        |  481 ++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        |  327 ++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 1016 +++++++++++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_ring.c       |  563 +++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_ring.h       |  255 +++++
 .../mellanox/mlxbf_pka/mlxbf_pka_trng.c       |  874 ++++++++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_trng.h       |  152 +++
 include/uapi/linux/mlxbf-pka.h                |  112 ++
 14 files changed, 3848 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-mellanox-pka
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/Makefile
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_ring.h
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h
 create mode 100644 include/uapi/linux/mlxbf-pka.h

-- 
2.34.1

