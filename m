Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6A531A7E6;
	Fri, 19 Sep 2025 19:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758311601; cv=fail; b=UgOch0YEYkv4RtlEQR8/2u0oyNkwNXk2/PWn7g0GIND/gPZh5UHTQrbOO+StCLwpD96GHgiW9vIT7v20VJ3VobAg/h1SnSSvwrZithNzEmvz68OBsvE/6npRKZsV69ZLYTW3sEKvhXmcV6h63zKFW42reNQob5XX/FXDhkbjwq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758311601; c=relaxed/simple;
	bh=PcPg2b5OhUKmtHs/VTSBZQtLXxZuUIYji+OCpZ4cVjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbtsxt4Qn1QSFmqGdGyBa3rIqM92ZmBxx+Ab3WjbxPFexyeE6eHBH1AtL2p5UjKai6VVsVK8oWFZ7gYcHxszORODsUHaY6/FP2phb58GZ602Pio23XexeKFi106/rBdIt6f+Jyd57z0mXNoxaAVTzBil1hfjH0BTqA6L/g2kDig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ClBEHHF8; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ClBEHHF8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q+7y3h/MivMQq7pblrl8nLqJzM05oYnMqSmg/WsYcu4DGZsz3zIV+g0L3cQ+kUmjV80oxcIIgKQJxPUh3B9W+woAQOiHzY2saz7or8Qp7gKwvGXXu/H9O4TvXyiOVOzXABPFcFGjgMv32HTnRU3vwUg6/9Xa0r5uU79ojeG6Smua4UGLsJ6Iaj6ssPqINfiX1c/9anRlaqriS1c8QQduleohMhboaIvTNYMXALc8zntnNj+QOASMGsSjFfsV9uE0C2RryTbKHBFTExq4YVLX//KWmcK8OqPX9XgsFdp4if12Ds5d0T0H5QlNiTMsbBm9MuzUjACo4Fh6dusK23/WkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GayJZDCZLyH8AF+aL7r3ft7zt59QG2tTZt4jqHQ9Jg=;
 b=Nx7lFBqhmnHpKuCp+MZOQHnetgNIxgJGYetjkDy1j9er+Z2KfrTvFhctXS3DnXCBF2BbvsUYFCdqkLdC8XOYlWR59NX5DznFuJMJ6aXH1fFpwZU/AvKBCCwvIBm5M+hc7boozr6WXU22ZBq5to2BWnLnn8v6HO+usYyZ/daERfeVn8o+b2xX637YtBNbMuQ/Oj5e21KkuqK6JhhW6NZEoCw+YPDw7yj0QCFgPUxs4x9HgqlfRrDPyM1i/9barZw6XqaZpIAzDHw5CE1C8IlwIm9e5lwhSNdx7cjEPOO+GWIAoHliX1oo3GMVa5f9n0O2eX0rvEjZDXKQlgq0qLkwRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GayJZDCZLyH8AF+aL7r3ft7zt59QG2tTZt4jqHQ9Jg=;
 b=ClBEHHF8xlow6ugRkLY+BBEhFvB6XgNMAZcWEK1DwZUkingvUwaXoBWGA4/ldEdoe2V03NFy5erWgKHeQW6O7+7FqXO/Z+icK/44afSaHRSOCkwQcXbjIY75tY8hLLLle4QZHstfJkASXHqrZr+PfsLbFthyrv6jJhcpE9hY1PKQi5lE3Vh3/h/3oLZd/sYhO9g80u/P3AJLySDzjFLmbLjo83prtKeztpMB7AC4fNENUFAdzYojXNtQzNJmr1HDxDsB0P2t0cRo0fcIOCUi84Olr8LnrAkH51KyKyPVG8XbrN5zFO9RZoXhpQljCqYWWtIPM7DuXmvcSZY0AWMkRA==
Received: from CH2PR17CA0015.namprd17.prod.outlook.com (2603:10b6:610:53::25)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 19:53:04 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::73) by CH2PR17CA0015.outlook.office365.com
 (2603:10b6:610:53::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Fri,
 19 Sep 2025 19:53:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 19:53:03 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Fri, 19 Sep
 2025 12:51:38 -0700
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
Subject: [PATCH v3 1/3] platform/mellanox/mlxbf_pka: Add core BlueField PKA platform driver
Date: Fri, 19 Sep 2025 19:51:30 +0000
Message-ID: <20250919195132.1088515-2-xiangrongl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250919195132.1088515-1-xiangrongl@nvidia.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f23b014-38e3-4230-6ccf-08ddf7b6258b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmlRaXA2cm13c2ZxVnFhRTRROU9VWmoySHVCRzlmZ3U3c1JjVHYzTGRiNDFP?=
 =?utf-8?B?Y0ZxeWtMd1lxVkZraXMybkJ2Q0ZmeU5wSGwvQWt0a1djWTNjYXk3OXNGOEk2?=
 =?utf-8?B?ZmZ0QUpDbUN6Z1dDdkFKeks1Z2NVREQvUHBJd05pRU5GUHNPZmtOWlZsNk9F?=
 =?utf-8?B?VVhESFhMVlloM2dhcGFYaDZJTkJoOUhOTklrYW1aUVEwQjZwZGxHbThCK1Av?=
 =?utf-8?B?NHRCc1J5NTFMTUtQSUhDbHN6SHpjZkU5NmFmcWkwdXBnamUxcUJDU3daM0NS?=
 =?utf-8?B?QnJTR0N4U1ZyZkRLYldIYTJkekNzZVlmQUs1dzgrcjQ1bUZ3NGptdWFMUGwz?=
 =?utf-8?B?L1lRZ1h2WEFlS09CcVRDWlB6TkZ6YlMyRmNENGxiWU9TaFBTaFdhWlgxdGRP?=
 =?utf-8?B?L2VTVHJkWW1aTkJ3OHJnVnJiSVZzdWhBOTk1S1NBOWdxNWVEcFRsWS9Lam1L?=
 =?utf-8?B?NzBGVEJ5dEJycFBtNjczaFp5NFJDYmpXSElwdnBYVHdNVGsvSEhLWU5zTGx1?=
 =?utf-8?B?M1Nka1lKV3B2R2k4Nk12RFMzUGQ0NUw5cFhidjh0RG96WHJvYmtxalZ4SGoz?=
 =?utf-8?B?V3I4VTRxSjJlTFFCK2lGVkluMDk4Zm4zVnovNVA0NUZiM3VkaU9DdTNYbjN1?=
 =?utf-8?B?UTB5QkV0RjdqbE1HRit5MzUyTnByWmYzREQzMk1Fc3grYXZUWVh0cjZZRDYx?=
 =?utf-8?B?M3l5V1ZyQ0gzQ3ZSaUZmL2w2Y3haV0ZKVDZ3a0VtdkNwOTVoTXJaNEZJSk1j?=
 =?utf-8?B?S3FsOSs1YitJaWVvbEo5a3MvRXphTGtGVUF3enVKSDJBRStGVmhZWTRTanhB?=
 =?utf-8?B?MDQ5VmwvQmtLU2hEalFLZnFiYnNUdzdFR1VjMmhweHpmNEpRcE44Z2NTZUd1?=
 =?utf-8?B?WHFYcWdXd05STWQ4REVtY2xyV2FtQzdjd2xYd05SRUNoRm9GakFOSUxDVjFY?=
 =?utf-8?B?NWJ3ZHdvelJ1ZUNHUzhwcEl1UDlybkl4bU8wYnpQMWlVSEdKY0NJVm1Nc0Rl?=
 =?utf-8?B?NUJ6M3cyMW16YWhKRGxQZjV3TEtwd3RrdlErVE9YdmdJS2toMHpsMnREMjRC?=
 =?utf-8?B?by9SblhEV1A2bFgxNnhwZm1aajkwUEhaUmNDVnZQUy84OUhuU0hRVW52V0pv?=
 =?utf-8?B?cHMybVY0aFRBV1VCNUZWT0ZUUUxTamtlNXFSZ2MvWC9uV0VNdHlvbzJJSSs2?=
 =?utf-8?B?K0FDV1FwUVdBcnpBa0szWVlBa1ZWNnJ3V2J2RnNiQ2tVQ01Rak4yYjdyekpa?=
 =?utf-8?B?QkF5L1hTZ2VkUkl4WklFZjdCSkUvMjRnSU5OQWVUWFRKazAvaWIvbndueUUv?=
 =?utf-8?B?ZHYyb2UyQlJJbkdhM2ppY0dhdHhqSUdidnVpenVIZlcyZnVXc3ZuR0Y1aGRa?=
 =?utf-8?B?U290azU0cjB2blpQV0wvYlFYcWY0MDBSc3FhMXVsZU5kK3BmTC9OZUlCNDQ2?=
 =?utf-8?B?cGMyaGpwWlVNVXVFU0tVV1hKeGZxMEovYXU4aDkxM25sSmZSSEoxTTRlVlR1?=
 =?utf-8?B?cVNUdHJaQmdZQThSWm5oWXkwUVgxK1FrY3BtQjhLWHhPbWVXUG9YM3F1UmlP?=
 =?utf-8?B?Z0pQS2ZKNXE4ZDVQak91eSt4WDVCUm5aRUtoSDBDM2NyV1JVWlY2d09hRnFS?=
 =?utf-8?B?TFpuTXB6cW1sRE83RXZqK3pUZzRRZFZ5M1dKRU1KTmNoT3NoR0ZOL1A3ZjBw?=
 =?utf-8?B?cUZoRENYemxteTFEaWgwSG9UdW8xcVNCOWFLZ0ZROW1oMkdZNjJNVnl0cDhF?=
 =?utf-8?B?MmNQaW5TT0FsYUlZMkhrdTNLL05ubkh6b29WbXEyK1hDWU1EL3poMjNVRzNt?=
 =?utf-8?B?bGNaOGM3YWZaSlVTekMyY2ErQTNpQlgrSE5UL0pocjNpZzhsWFpNWGVIZis1?=
 =?utf-8?B?YlpQMCtEMmV5Q2xsSW93Wno2YlBwUVhMK3E0bE5ZcXNRUW01TFpIQWlzaE12?=
 =?utf-8?B?RUxVaklaVXVSOGgvNExDbUplUHJIVnRtWW5NaERtZW0xNll1dTM5L254WTdo?=
 =?utf-8?B?MkhVQ1BWRmhoUlc4cklKNmltdU4rSFREQWVaTEpFT1hDUTdKU3h5RW5zWTVj?=
 =?utf-8?Q?LOG4Zs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:53:03.9240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f23b014-38e3-4230-6ccf-08ddf7b6258b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

Add the initial mlxbf_pka driver to support the BlueField DPU Public Key
Acceleration (PKA) hardware. The PKA provides a simple, complete framework
for crypto public key hardware offload. It supports direct access to the
public key hardware resources from the user space, and makes available
several arithmetic operations: some basic operations (e.g., addition and
multiplication), some complex operations (e.g., modular exponentiation and
modular inversion), and high-level operations such as RSA, Diffie-Hellman,
Elliptic Curve Cryptography, and the Federal Digital Signature Algorithm
(DSA as documented in FIPS-186) public-private key systems.

This patch wires up the platform driver and the device/shim layer:

- ACPI matching for BF1/BF2/BF3 (MLNXBF10/20/51)
- Probe flow to verify boot status, discover EIP154, Window RAM, alt Window RAM,
  and CSR resources
- Register a PKA "shim" via the device layer, which maps resources and tracks
  per-shim state
- Provide shim lifecycle helpers (register/unregister)

This driver is placed under drivers/platform/mellanox as it exposes platform
resources and does not provide in-kernel crypto offload.

Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Ron Li <xiangrongl@nvidia.com>
---
 .../ABI/testing/sysfs-platform-mellanox-pka   |  16 +
 MAINTAINERS                                   |   8 +
 drivers/platform/mellanox/Kconfig             |  10 +
 drivers/platform/mellanox/Makefile            |   1 +
 drivers/platform/mellanox/mlxbf_pka/Makefile  |  10 +
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        | 395 +++++++++++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        | 298 +++++++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        | 413 ++++++++++++++++++
 8 files changed, 1151 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-mellanox-pka
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/Makefile
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c

diff --git a/Documentation/ABI/testing/sysfs-platform-mellanox-pka b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
new file mode 100644
index 000000000000..cf8dd292c781
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
@@ -0,0 +1,16 @@
+What:		/sys/devices/platform/<pka-device-id>/<pka-ring-device-id>
+Date:		Oct 2025
+KernelVersion:	6.18
+Contact:	"Ron Li <xiangrongl@nvidia.com>"
+Description:
+		The mlxbf_pka driver to support the BlueField SoC Public Key Acceleration (PKA)
+		hardware. It supports direct access to the public key hardware resources from the
+		user space.
+
+		There are three PKA device IDs that support different BlueField product:
+
+		===========  ==============================================
+		BlueField-1  MLNXBF10:xx, where xx ranges from '00' to '03'
+		BlueField-2  MLNXBF20:xx, where xx ranges from '00' to '07'
+		BlueField-3  MLNXBF51:xx, where xx ranges from '00' to '17'
+		===========  ==============================================
diff --git a/MAINTAINERS b/MAINTAINERS
index f6206963efbf..64b995b16d1a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15755,6 +15755,14 @@ L:	linux-i2c@vger.kernel.org
 S:	Supported
 F:	drivers/i2c/busses/i2c-mlxbf.c
 
+MELLANOX BLUEFIELD PKA DRIVER
+M:	Ron Li <xiangrongl@nvidia.com>
+M:	Khalil Blaiech <kblaiech@nvidia.com>
+L:	platform-driver-x86@vger.kernel.org
+S:	Supported
+F:	Documentation/ABI/testing/sysfs-platform-mellanox-pka
+F:	drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_*
+
 MELLANOX ETHERNET DRIVER (mlx4_en)
 M:	Tariq Toukan <tariqt@nvidia.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/platform/mellanox/Kconfig b/drivers/platform/mellanox/Kconfig
index e3afbe62c7f6..b09681c137e6 100644
--- a/drivers/platform/mellanox/Kconfig
+++ b/drivers/platform/mellanox/Kconfig
@@ -121,4 +121,14 @@ config NVSW_SN2201
 	  C3338R which is one of the Denverton product families.
 	  System equipped with Nvidia®Spectrum-1 32x100GbE Ethernet switch.
 
+config MLXBF_PKA
+        tristate "Mellanox BlueField Public Key Accelerator driver"
+        depends on ARM64 && ACPI
+        help
+          If you say yes to this option, support will be included for the
+          Public Key Accelerator device on Mellanox BlueField SoCs.
+
+          This driver can also be built as a module. If so, the module will
+          be called pka-mlxbf.
+
 endif # MELLANOX_PLATFORM
diff --git a/drivers/platform/mellanox/Makefile b/drivers/platform/mellanox/Makefile
index e86723b44c2e..a6535959cde4 100644
--- a/drivers/platform/mellanox/Makefile
+++ b/drivers/platform/mellanox/Makefile
@@ -5,6 +5,7 @@
 #
 obj-$(CONFIG_MLX_PLATFORM)	+= mlx-platform.o
 obj-$(CONFIG_MLXBF_BOOTCTL)	+= mlxbf-bootctl.o
+obj-$(CONFIG_MLXBF_PKA)		+= mlxbf_pka/
 obj-$(CONFIG_MLXBF_PMC)		+= mlxbf-pmc.o
 obj-$(CONFIG_MLXBF_TMFIFO)	+= mlxbf-tmfifo.o
 obj-$(CONFIG_MLXREG_DPU)	+= mlxreg-dpu.o
diff --git a/drivers/platform/mellanox/mlxbf_pka/Makefile b/drivers/platform/mellanox/mlxbf_pka/Makefile
new file mode 100644
index 000000000000..67465a63edb8
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+# SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved.
+#
+# Mellanox BlueField PKA Driver
+#
+
+obj-$(CONFIG_MLXBF_PKA) += mlxbf-pka.o
+
+mlxbf-pka-objs := mlxbf_pka_drv.o
+mlxbf-pka-objs += mlxbf_pka_dev.o
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
new file mode 100644
index 000000000000..0a5db1be6eaa
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
@@ -0,0 +1,395 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved.
+
+#include <linux/bitfield.h>
+#include <linux/compiler.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/math.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/time.h>
+#include <linux/timex.h>
+#include <linux/types.h>
+
+#include "mlxbf_pka_dev.h"
+
+struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
+
+/* Global PKA shim resource info table. */
+static struct mlxbf_pka_dev_gbl_shim_res_info_t mlxbf_pka_gbl_res_tbl[MLXBF_PKA_MAX_NUM_IO_BLOCKS];
+
+/* Add the resource to the global resource table. */
+static int mlxbf_pka_dev_add_resource(struct mlxbf_pka_dev_res_t *res_ptr, u32 shim_idx)
+{
+	u8 res_cnt;
+
+	res_cnt = mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt;
+	if (res_cnt >= MLXBF_PKA_DEV_SHIM_RES_CNT)
+		return -ENOMEM;
+
+	mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_cnt] = res_ptr;
+	mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt++;
+
+	return 0;
+}
+
+/* Remove the resource from the global resource table. */
+static int mlxbf_pka_dev_put_resource(struct mlxbf_pka_dev_res_t *res, u32 shim_idx)
+{
+	struct mlxbf_pka_dev_res_t *res_ptr;
+	u8 res_idx;
+
+	for (res_idx = 0; res_idx < MLXBF_PKA_DEV_SHIM_RES_CNT; res_idx++) {
+		res_ptr = mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
+		if (!res_ptr || strcmp(res_ptr->name, res->name))
+			continue;
+
+		mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx] = NULL;
+		mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt--;
+		break;
+	}
+
+	/*
+	 * Check whether the resource shares the same memory map; If so, the memory
+	 * map shouldn't be released.
+	 */
+	for (res_idx = 0; res_idx < MLXBF_PKA_DEV_SHIM_RES_CNT; res_idx++) {
+		res_ptr = mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
+		if (res_ptr && res_ptr->base == res->base)
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+static void __iomem *mlxbf_pka_dev_get_resource_ioaddr(u64 res_base, u32 shim_idx)
+{
+	struct mlxbf_pka_dev_res_t *res_ptr;
+	u8 res_cnt, res_idx;
+
+	res_cnt = mlxbf_pka_gbl_res_tbl[shim_idx].res_cnt;
+	if (!res_cnt)
+		return NULL;
+
+	for (res_idx = 0; res_idx < res_cnt; res_idx++) {
+		res_ptr = mlxbf_pka_gbl_res_tbl[shim_idx].res_tbl[res_idx];
+		if (res_ptr->base == res_base)
+			return res_ptr->ioaddr;
+	}
+
+	return NULL;
+}
+
+/* Set PKA device resource config and map io memory if needed. */
+static int mlxbf_pka_dev_set_resource_config(struct device *dev,
+					     struct mlxbf_pka_dev_shim_s *shim,
+					     struct mlxbf_pka_dev_res_t *res_ptr,
+					     u64 res_base,
+					     u64 res_size,
+					     u64 res_type,
+					     char *res_name)
+{
+	if (res_ptr->status == MLXBF_PKA_DEV_RES_STATUS_MAPPED)
+		return -EPERM;
+
+	switch (res_type) {
+	case MLXBF_PKA_DEV_RES_TYPE_REG:
+		res_ptr->base = res_base;
+		break;
+	case MLXBF_PKA_DEV_RES_TYPE_MEM:
+		res_ptr->base = shim->mem_res.eip154_base + res_base;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	res_ptr->size = res_size;
+	res_ptr->type = res_type;
+	res_ptr->name = res_name;
+	res_ptr->status = MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
+	res_ptr->ioaddr = mlxbf_pka_dev_get_resource_ioaddr(res_ptr->base, shim->shim_id);
+	if (!res_ptr->ioaddr) {
+		if (!devm_request_mem_region(dev, res_ptr->base, res_ptr->size, res_ptr->name)) {
+			dev_err(dev, "failed to get io memory region\n");
+			return -EPERM;
+		}
+
+		res_ptr->ioaddr = devm_ioremap(dev, res_ptr->base, res_ptr->size);
+		if (!res_ptr->ioaddr) {
+			dev_err(dev, "unable to map io memory into CPU space\n");
+			return -ENOMEM;
+		}
+	}
+
+	res_ptr->status = MLXBF_PKA_DEV_RES_STATUS_MAPPED;
+
+	if (!res_ptr->ioaddr || mlxbf_pka_dev_add_resource(res_ptr, shim->shim_id)) {
+		dev_err(dev, "unable to map io memory\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/* Unset PKA device resource config - unmap io memory if needed. */
+void mlxbf_pka_dev_unset_resource_config(struct device *dev,
+					 struct mlxbf_pka_dev_shim_s *shim,
+					 struct mlxbf_pka_dev_res_t *res_ptr)
+{
+	if (res_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED)
+		return;
+
+	if (!res_ptr->ioaddr)
+		return;
+
+	if (-EBUSY == mlxbf_pka_dev_put_resource(res_ptr, shim->shim_id))
+		return;
+
+	dev_dbg(dev, "PKA device resource released\n");
+	res_ptr->status = MLXBF_PKA_DEV_RES_STATUS_UNMAPPED;
+}
+
+/*
+ * mlxbf_pka_dev_create_shim - Create shim.
+ *
+ * Set shim parameters and configure shim resources.
+ *
+ * Return: 0 on success, a negative error code on failure.
+ */
+static int mlxbf_pka_dev_create_shim(struct device *dev,
+				     struct mlxbf_pka_dev_shim_s *shim,
+				     u32 shim_id,
+				     u8 split,
+				     struct mlxbf_pka_dev_mem_res *mem_res)
+{
+	u64 reg_base;
+	u64 reg_size;
+	int ret;
+
+	if (shim->status == MLXBF_PKA_SHIM_STATUS_CREATED)
+		return 0;
+
+	if (shim->status != MLXBF_PKA_SHIM_STATUS_UNDEFINED) {
+		dev_err(dev, "PKA device must be undefined\n");
+		return -EPERM;
+	}
+
+	if (shim_id > MLXBF_PKA_MAX_NUM_IO_BLOCKS - 1) {
+		dev_err(dev, "invalid shim identifier\n");
+		return -EINVAL;
+	}
+
+	shim->shim_id = shim_id;
+	shim->mem_res = *mem_res;
+
+	if (split)
+		shim->window_ram_split = MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED;
+	else
+		shim->window_ram_split = MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLED;
+
+	/* Set PKA device Buffer RAM config. */
+	ret = mlxbf_pka_dev_set_resource_config(dev,
+						shim,
+						&shim->resources.buffer_ram,
+						MLXBF_PKA_BUFFER_RAM_BASE,
+						MLXBF_PKA_BUFFER_RAM_SIZE,
+						MLXBF_PKA_DEV_RES_TYPE_MEM,
+						"MLXBF_PKA_BUFFER_RAM");
+	if (ret) {
+		dev_err(dev, "unable to set Buffer RAM config\n");
+		return ret;
+	}
+
+	/* Set PKA device Master Controller register. */
+	reg_size = PAGE_SIZE;
+	reg_base = mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_base,
+						   MLXBF_PKA_MASTER_SEQ_CTRL_ADDR);
+	ret = mlxbf_pka_dev_set_resource_config(dev,
+						shim,
+						&shim->resources.master_seq_ctrl,
+						reg_base,
+						reg_size,
+						MLXBF_PKA_DEV_RES_TYPE_REG,
+						"MLXBF_PKA_MASTER_SEQ_CTRL");
+	if (ret) {
+		dev_err(dev, "unable to set Master Controller register config\n");
+		return ret;
+	}
+
+	/* Set PKA device AIC registers. */
+	reg_size = PAGE_SIZE;
+	reg_base = mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_base,
+						   MLXBF_PKA_AIC_POL_CTRL_ADDR);
+	ret = mlxbf_pka_dev_set_resource_config(dev,
+						shim,
+						&shim->resources.aic_csr,
+						reg_base,
+						reg_size,
+						MLXBF_PKA_DEV_RES_TYPE_REG,
+						"MLXBF_PKA_AIC_CSR");
+	if (ret) {
+		dev_err(dev, "unable to set AIC registers config\n");
+		return ret;
+	}
+
+	shim->status = MLXBF_PKA_SHIM_STATUS_CREATED;
+
+	return ret;
+}
+
+/* Delete shim and unset shim resources. */
+static int mlxbf_pka_dev_delete_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
+{
+	struct mlxbf_pka_dev_res_t *res_master_seq_ctrl, *res_aic_csr;
+	struct mlxbf_pka_dev_res_t *res_buffer_ram;
+
+	dev_dbg(dev, "PKA device delete shim\n");
+
+	if (shim->status == MLXBF_PKA_SHIM_STATUS_UNDEFINED)
+		return 0;
+
+	if (shim->status != MLXBF_PKA_SHIM_STATUS_FINALIZED &&
+	    shim->status != MLXBF_PKA_SHIM_STATUS_CREATED) {
+		dev_err(dev, "PKA device status must be finalized\n");
+		return -EPERM;
+	}
+
+	res_buffer_ram = &shim->resources.buffer_ram;
+	res_master_seq_ctrl = &shim->resources.master_seq_ctrl;
+	res_aic_csr = &shim->resources.aic_csr;
+
+	mlxbf_pka_dev_unset_resource_config(dev, shim, res_buffer_ram);
+	mlxbf_pka_dev_unset_resource_config(dev, shim, res_master_seq_ctrl);
+	mlxbf_pka_dev_unset_resource_config(dev, shim, res_aic_csr);
+
+	shim->status = MLXBF_PKA_SHIM_STATUS_UNDEFINED;
+
+	return 0;
+}
+
+/*
+ * Initialize PKA IO block referred to as shim. It configures shim's
+ * parameters and prepares resources by mapping corresponding memory. The
+ * function also configures shim registers and loads firmware to shim
+ * internal rams. The struct mlxbf_pka_dev_shim_s passed as input is also
+ * an output. It returns 0 on success, a negative error code on failure.
+ */
+static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
+{
+	int ret;
+
+	if (shim->status != MLXBF_PKA_SHIM_STATUS_CREATED) {
+		dev_err(dev, "PKA device must be created\n");
+		return -EPERM;
+	}
+
+	ret = devm_mutex_init(dev, &shim->mutex);
+	if (ret)
+		return ret;
+
+	shim->status = MLXBF_PKA_SHIM_STATUS_INITIALIZED;
+
+	return ret;
+}
+
+/* Release a given shim. */
+static int mlxbf_pka_dev_release_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
+{
+	int ret = 0;
+
+	if (shim->status != MLXBF_PKA_SHIM_STATUS_INITIALIZED &&
+	    shim->status != MLXBF_PKA_SHIM_STATUS_STOPPED) {
+		dev_err(dev, "PKA device must be initialized or stopped\n");
+		return -EPERM;
+	}
+
+	shim->status = MLXBF_PKA_SHIM_STATUS_FINALIZED;
+
+	return ret;
+}
+
+/* Return the shim associated with the given identifier. */
+struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id)
+{
+	return mlxbf_pka_gbl_config.dev_shims[shim_id];
+}
+
+int mlxbf_pka_dev_register_shim(struct device *dev,
+				u32 shim_id,
+				struct mlxbf_pka_dev_mem_res *mem_res,
+				struct mlxbf_pka_dev_shim_s **shim)
+{
+	struct mlxbf_pka_dev_shim_s *shim_ptr;
+	u8 split;
+	int ret;
+
+	if (!shim)
+		return -EINVAL;
+
+	dev_dbg(dev, "register shim id=%u\n", shim_id);
+
+	shim_ptr = devm_kzalloc(dev, sizeof(*shim_ptr), GFP_KERNEL);
+	if (!shim_ptr)
+		return -ENOMEM;
+
+	/*
+	 * Shim state MUST be set to undefined before calling
+	 * 'mlxbf_pka_dev_create_shim' function.
+	 */
+	shim_ptr->status = MLXBF_PKA_SHIM_STATUS_UNDEFINED;
+
+	/* Set the Window RAM user mode. */
+	split = MLXBF_PKA_SPLIT_WINDOW_RAM_MODE;
+
+	/* Create PKA shim. */
+	ret = mlxbf_pka_dev_create_shim(dev, shim_ptr, shim_id, split, mem_res);
+	if (ret) {
+		dev_err(dev, "failed to create shim %u\n", shim_id);
+		mlxbf_pka_dev_delete_shim(dev, shim_ptr);
+		goto exit_create_shim;
+	}
+
+	/* Initialize PKA shim. */
+	ret = mlxbf_pka_dev_init_shim(dev, shim_ptr);
+	if (ret) {
+		dev_err(dev, "failed to init shim %u\n", shim_id);
+		goto exit_init_shim;
+	}
+
+	mlxbf_pka_gbl_config.dev_shims[shim_ptr->shim_id] = shim_ptr;
+	mlxbf_pka_gbl_config.dev_shims_cnt += 1;
+
+	*shim = shim_ptr;
+	return 0;
+
+exit_init_shim:
+	mlxbf_pka_dev_release_shim(dev, shim_ptr);
+
+exit_create_shim:
+	mlxbf_pka_dev_delete_shim(dev, shim_ptr);
+	return ret;
+}
+
+int mlxbf_pka_dev_unregister_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
+{
+	int ret;
+
+	if (!shim)
+		return -EINVAL;
+
+	mlxbf_pka_gbl_config.dev_shims[shim->shim_id] = NULL;
+	mlxbf_pka_gbl_config.dev_shims_cnt -= 1;
+
+	/* Release shim. */
+	ret = mlxbf_pka_dev_release_shim(dev, shim);
+	if (ret)
+		return ret;
+
+	/* Delete shim. */
+	return mlxbf_pka_dev_delete_shim(dev, shim);
+}
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
new file mode 100644
index 000000000000..df51202f79bd
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
@@ -0,0 +1,298 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+/* SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef __MLXBF_PKA_DEV_H__
+#define __MLXBF_PKA_DEV_H__
+
+/*
+ * @file
+ *
+ * API to handle the PKA EIP-154 I/O block (shim). It provides functions and
+ * data structures to initialize and configure the PKA shim. It's the "southband
+ * interface" for communication with PKA hardware resources.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/ioctl.h>
+#include <linux/mutex.h>
+#include <linux/sizes.h>
+#include <linux/types.h>
+#include <linux/units.h>
+
+#define MASTER_CONTROLLER_OUT_OF_RESET 0
+
+/* PKA address related definitions. */
+
+/*
+ * Global Control Space CSR addresses/offsets. These are accessed from the ARM
+ * as 8 byte reads/writes. However only the bottom 32 bits are implemented.
+ */
+#define MLXBF_PKA_CLK_FORCE_ADDR 0x11C80
+
+/*
+ * Advanced Interrupt Controller CSR addresses/offsets. These are accessed from
+ * the ARM as 8 byte reads/writes. However only the bottom 32 bits are
+ * implemented.
+ */
+#define MLXBF_PKA_AIC_POL_CTRL_ADDR 0x11E00
+
+/*
+ * Control register address/offset. This is accessed from the ARM using 8 byte
+ * reads/writes. However only the bottom 32 bits are implemented.
+ */
+#define MLXBF_PKA_MASTER_SEQ_CTRL_ADDR 0x27F90
+
+/* PKA buffer RAM */
+#define MLXBF_PKA_BUFFER_RAM_BASE 0x00000
+#define MLXBF_PKA_BUFFER_RAM_SIZE SZ_16K
+
+/*
+ * PKA Buffer RAM offsets. These are NOT real CSR's but instead are specific
+ * offset/addresses within the EIP154 MLXBF_PKA_BUFFER_RAM.
+ */
+
+/* Alternate Window RAM size. */
+#define MLXBF_PKA_WINDOW_RAM_REGION_SIZE SZ_16K
+
+/* PKA configuration related definitions. */
+
+/* The maximum number of PKA shims referred to as IO blocks. */
+#define MLXBF_PKA_MAX_NUM_IO_BLOCKS 24
+
+/*
+ * PKA Window RAM parameters.
+ * Define whether to split window RAM during PKA device creation phase.
+ */
+#define MLXBF_PKA_SPLIT_WINDOW_RAM_MODE 0
+
+/* Defines for window RAM partition, valid for 16K memory. */
+#define MLXBF_PKA_WINDOW_RAM_DATA_MEM_SIZE	0x3800 /* 14KB. */
+
+/* Window RAM/Alternate window RAM offset mask for BF1 and BF2. */
+#define MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK (GENMASK(17, 16) | GENMASK(22, 20))
+
+/* Window RAM/Alternate window RAM offset mask for BF3. */
+#define MLXBF_PKA_WINDOW_RAM_OFFSET_BF3_MASK GENMASK(18, 16)
+
+/*
+ * PKA Master Sequencer Control/Status Register.
+ * Writing '1' to bit [31] puts the Master controller Sequencer in a reset
+ * state. Resetting the Sequencer (in order to load other firmware) should
+ * only be done when the EIP-154 is not performing any operations.
+ */
+#define MLXBF_PKA_MASTER_SEQ_CTRL_RESET BIT(31)
+/*
+ * Writing '1' to bit [30] will reset all Command and Result counters. This bit
+ * is write-only and self clearing and can only be set if the 'Reset' bit [31]
+ * is '1'.
+ */
+#define MLXBF_PKA_MASTER_SEQ_CTRL_CLEAR_COUNTERS BIT(30)
+
+/**
+ * struct mlxbf_pka_dev_res_t - Device resource structure
+ * @ioaddr: The (iore)mapped version of addr, driver internal use
+ * @base: Base address of the device's resource
+ * @size: Size of IO
+ * @type: Type of resource addr points to
+ * @status: Status of the resource
+ * @name: Name of the resource
+ */
+struct mlxbf_pka_dev_res_t {
+	void __iomem *ioaddr;
+	u64 base;
+	u64 size;
+	u8 type;
+	s8 status;
+	char *name;
+};
+
+/* Defines for mlxbf_pka_dev_res->type. */
+#define MLXBF_PKA_DEV_RES_TYPE_MEM	1 /* Resource type is memory. */
+#define MLXBF_PKA_DEV_RES_TYPE_REG	2 /* Resource type is register. */
+
+/* Defines for mlxbf_pka_dev_res->status. */
+#define MLXBF_PKA_DEV_RES_STATUS_MAPPED		1 /* The resource is (iore)mapped. */
+#define MLXBF_PKA_DEV_RES_STATUS_UNMAPPED	-1 /* The resource is unmapped. */
+
+/**
+ * struct mlxbf_pka_dev_shim_res_t - PKA Shim resources structure
+ * @buffer_ram: Buffer RAM
+ * @master_seq_ctrl: Master sequencer controller CSR
+ * @aic_csr: Interrupt controller CSRs
+ */
+struct mlxbf_pka_dev_shim_res_t {
+	struct mlxbf_pka_dev_res_t buffer_ram;
+	struct mlxbf_pka_dev_res_t master_seq_ctrl;
+	struct mlxbf_pka_dev_res_t aic_csr;
+};
+
+/* Number of PKA device resources. */
+#define MLXBF_PKA_DEV_SHIM_RES_CNT 6
+
+/* Platform global shim resource information. */
+struct mlxbf_pka_dev_gbl_shim_res_info_t {
+	struct mlxbf_pka_dev_res_t *res_tbl[MLXBF_PKA_DEV_SHIM_RES_CNT];
+	u8 res_cnt;
+};
+
+/**
+ * struct mlxbf_pka_dev_mem_res - PKA device memory resources
+ * @eip154_base: Base address for EIP154 mmio registers
+ * @eip154_size: EIP154 mmio register region size
+ * @wndw_ram_off_mask: Common offset mask for alt window RAM and window RAM
+ * @wndw_ram_base: Base address for window RAM
+ * @wndw_ram_size: Window RAM region size
+ * @alt_wndw_ram_0_base: Base address for alternate window RAM 0
+ * @alt_wndw_ram_1_base: Base address for alternate window RAM 1
+ * @alt_wndw_ram_2_base: Base address for alternate window RAM 2
+ * @alt_wndw_ram_3_base: Base address for alternate window RAM 3
+ * @alt_wndw_ram_size: Alternate window RAM regions size
+ * @csr_base: Base address for CSR registers
+ * @csr_size: CSR area size
+ */
+struct mlxbf_pka_dev_mem_res {
+	u64 eip154_base;
+	u64 eip154_size;
+
+	u64 wndw_ram_off_mask;
+	u64 wndw_ram_base;
+	u64 wndw_ram_size;
+
+	u64 alt_wndw_ram_0_base;
+	u64 alt_wndw_ram_1_base;
+	u64 alt_wndw_ram_2_base;
+	u64 alt_wndw_ram_3_base;
+	u64 alt_wndw_ram_size;
+
+	u64 csr_base;
+	u64 csr_size;
+};
+
+/**
+ * struct mlxbf_pka_dev_shim_s - PKA Shim structure
+ * @mem_res: Memory resources
+ * @shim_id: Shim identifier
+ * @resources: Shim resources
+ * @window_ram_split: If non-zero, the split window RAM scheme is used
+ * @status: Status of the shim
+ * @mutex: Mutex lock for sharing shim
+ */
+struct mlxbf_pka_dev_shim_s {
+	struct mlxbf_pka_dev_mem_res mem_res;
+	u32 shim_id;
+	struct mlxbf_pka_dev_shim_res_t resources;
+	u8 window_ram_split;
+	s8 status;
+	struct mutex mutex;
+};
+
+/* Defines for mlxbf_pka_dev_shim->status. */
+#define MLXBF_PKA_SHIM_STATUS_UNDEFINED		-1
+#define MLXBF_PKA_SHIM_STATUS_CREATED		1
+#define MLXBF_PKA_SHIM_STATUS_INITIALIZED	2
+#define MLXBF_PKA_SHIM_STATUS_RUNNING		3
+#define MLXBF_PKA_SHIM_STATUS_STOPPED		4
+#define MLXBF_PKA_SHIM_STATUS_FINALIZED		5
+
+/* Defines for mlxbf_pka_dev_shim->window_ram_split. */
+
+/* Window RAM is split into 4 * 16KB blocks. */
+#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_ENABLED 1
+/* Window RAM is not split and occupies 64KB. */
+#define MLXBF_PKA_SHIM_WINDOW_RAM_SPLIT_DISABLED 2
+
+/**
+ * struct mlxbf_pka_dev_gbl_config_t - Platform global configuration structure
+ * @dev_shims_cnt: Number of registered PKA shims
+ * @dev_shims: Table of registered PKA shims
+ */
+struct mlxbf_pka_dev_gbl_config_t {
+	u32 dev_shims_cnt;
+	struct mlxbf_pka_dev_shim_s *dev_shims[MLXBF_PKA_MAX_NUM_IO_BLOCKS];
+};
+
+extern struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
+
+/*
+ * Processor speed in hertz, used in routines which might be called very early
+ * in boot.
+ */
+static inline u64 mlxbf_pka_early_cpu_speed(void)
+{
+	/*
+	 * Initial guess at our CPU speed.  We set this to be larger than any
+	 * possible real speed, so that any calculated delays will be too long,
+	 * rather than too short.
+	 *
+	 * CPU Freq for High/Bin Chip - 1.255GHz.
+	 */
+	return 1255 * HZ_PER_MHZ;
+}
+
+/* Start a PKA device timer. */
+static inline u64 mlxbf_pka_dev_timer_start_msec(u32 msec)
+{
+	u64 cur_time = get_cycles();
+
+	return cur_time + mlxbf_pka_early_cpu_speed() * msec / MSEC_PER_SEC;
+}
+
+/* Test a PKA device timer for completion. */
+static inline bool mlxbf_pka_dev_timer_done(u64 timer)
+{
+	return get_cycles() >= timer;
+}
+
+/* Return register base address. */
+static inline u64 mlxbf_pka_dev_get_register_base(u64 base, u64 reg_addr)
+{
+	return (base + reg_addr) & PAGE_MASK;
+}
+
+/* Return register offset. */
+static inline u64 mlxbf_pka_dev_get_register_offset(u64 base, u64 reg_addr)
+{
+	return (base + reg_addr) & ~PAGE_MASK;
+}
+
+/* Return word offset within io memory. */
+static inline u64 mlxbf_pka_dev_get_word_offset(u64 mem_base, u64 word_addr, u64 mem_size)
+{
+	return (mem_base + word_addr) & (mem_size - 1);
+}
+
+static inline u64 mlxbf_pka_dev_io_read(void __iomem *mem_ptr, u64 mem_off)
+{
+	return readq_relaxed(mem_ptr + mem_off);
+}
+
+static inline void mlxbf_pka_dev_io_write(void __iomem *mem_ptr, u64 mem_off, u64 value)
+{
+	writeq_relaxed(value, mem_ptr + mem_off);
+}
+
+/*
+ * Shim getter for mlxbf_pka_dev_gbl_config_t structure which holds all system
+ * global configuration. This configuration is shared and common to kernel
+ * device driver associated with PKA hardware.
+ */
+struct mlxbf_pka_dev_shim_s *mlxbf_pka_dev_get_shim(u32 shim_id);
+
+void mlxbf_pka_dev_unset_resource_config(struct device *dev,
+					 struct mlxbf_pka_dev_shim_s *shim,
+					 struct mlxbf_pka_dev_res_t *res_ptr);
+
+/*
+ * Register PKA IO block. This function initializes a shim and configures its
+ * related resources, and returns the error code.
+ */
+int mlxbf_pka_dev_register_shim(struct device *dev,
+				u32 shim_id,
+				struct mlxbf_pka_dev_mem_res *mem_res,
+				struct mlxbf_pka_dev_shim_s **shim);
+
+/* Unregister PKA IO block. */
+int mlxbf_pka_dev_unregister_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim);
+
+#endif /* __MLXBF_PKA_DEV_H__ */
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
new file mode 100644
index 000000000000..42bfe30fbe49
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
@@ -0,0 +1,413 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved.
+
+#include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/cdev.h>
+#include <linux/cleanup.h>
+#include <linux/device.h>
+#include <linux/idr.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/ioport.h>
+#include <linux/kdev_t.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+
+#include "mlxbf_pka_dev.h"
+
+#define MLXBF_PKA_DRIVER_DESCRIPTION		"BlueField PKA driver"
+
+#define MLXBF_PKA_DEVICE_ACPIHID_BF1		"MLNXBF10"
+
+#define MLXBF_PKA_DEVICE_ACPIHID_BF2		"MLNXBF20"
+
+#define MLXBF_PKA_DEVICE_ACPIHID_BF3		"MLNXBF51"
+
+#define MLXBF_PKA_DEVICE_ACCESS_MODE	0666
+#define MLXBF_PKA_DEVICE_RES_CNT	7
+#define MLXBF_PKA_DEVICE_NAME_MAX	14
+
+enum mlxbf_pka_mem_res_idx {
+	MLXBF_PKA_ACPI_EIP154_IDX = 0,
+	MLXBF_PKA_ACPI_WNDW_RAM_IDX,
+	MLXBF_PKA_ACPI_ALT_WNDW_RAM_0_IDX,
+	MLXBF_PKA_ACPI_ALT_WNDW_RAM_1_IDX,
+	MLXBF_PKA_ACPI_ALT_WNDW_RAM_2_IDX,
+	MLXBF_PKA_ACPI_ALT_WNDW_RAM_3_IDX,
+	MLXBF_PKA_ACPI_CSR_IDX
+};
+
+enum mlxbf_pka_plat_type {
+	/* Platform type Bluefield-1. */
+	MLXBF_PKA_PLAT_TYPE_BF1 = 0,
+	/* Platform type Bluefield-2. */
+	MLXBF_PKA_PLAT_TYPE_BF2,
+	/* Platform type Bluefield-3. */
+	MLXBF_PKA_PLAT_TYPE_BF3
+};
+
+struct mlxbf_pka_drv_plat_info {
+	enum mlxbf_pka_plat_type type;
+	u64 wndw_ram_off_mask;
+};
+
+static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf1_info = {
+	.type = MLXBF_PKA_PLAT_TYPE_BF1,
+	.wndw_ram_off_mask = MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK,
+};
+
+static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf2_info = {
+	.type = MLXBF_PKA_PLAT_TYPE_BF2,
+	.wndw_ram_off_mask = MLXBF_PKA_WINDOW_RAM_OFFSET_BF1_BF2_MASK,
+};
+
+static const struct mlxbf_pka_drv_plat_info mlxbf_pka_bf3_info = {
+	.type = MLXBF_PKA_PLAT_TYPE_BF3,
+	.wndw_ram_off_mask = MLXBF_PKA_WINDOW_RAM_OFFSET_BF3_MASK,
+};
+
+static DEFINE_MUTEX(mlxbf_pka_drv_lock);
+
+static u32 mlxbf_pka_device_cnt;
+
+static const char mlxbf_pka_acpihid_bf1[] = MLXBF_PKA_DEVICE_ACPIHID_BF1;
+
+static const char mlxbf_pka_acpihid_bf2[] = MLXBF_PKA_DEVICE_ACPIHID_BF2;
+
+static const char mlxbf_pka_acpihid_bf3[] = MLXBF_PKA_DEVICE_ACPIHID_BF3;
+
+static const struct acpi_device_id mlxbf_pka_drv_acpi_ids[] = {
+	{ MLXBF_PKA_DEVICE_ACPIHID_BF1, (kernel_ulong_t)&mlxbf_pka_bf1_info, 0, 0 },
+	{ MLXBF_PKA_DEVICE_ACPIHID_BF2, (kernel_ulong_t)&mlxbf_pka_bf2_info, 0, 0 },
+	{ MLXBF_PKA_DEVICE_ACPIHID_BF3, (kernel_ulong_t)&mlxbf_pka_bf3_info, 0, 0 },
+	{},
+};
+
+struct mlxbf_pka_info {
+	/* The device this info struct belongs to. */
+	struct device *dev;
+	/* Device name. */
+	const char *name;
+	/* Device ACPI HID. */
+	const char *acpihid;
+	/* Device flags. */
+	u8 flag;
+	struct module *module;
+	/* Optional private data. */
+	void *priv;
+};
+
+/* Defines for mlxbf_pka_info->flags. */
+#define MLXBF_PKA_DRIVER_FLAG_DEVICE 2
+
+struct mlxbf_pka_platdata {
+	struct platform_device *pdev;
+	struct mlxbf_pka_info *info;
+	/* Generic spinlock. */
+	spinlock_t lock;
+};
+
+#define MLXBF_PKA_DRIVER_DEV_MAX MLXBF_PKA_MAX_NUM_IO_BLOCKS
+
+struct mlxbf_pka_device {
+	struct mlxbf_pka_info *info;
+	struct device *device;
+	u32 device_id;
+	struct resource *resource[MLXBF_PKA_DEVICE_RES_CNT];
+	struct mlxbf_pka_dev_shim_s *shim;
+};
+
+static int mlxbf_pka_drv_verify_bootup_status(struct device *dev)
+{
+	const char *bootup_status;
+	int ret;
+
+	ret = device_property_read_string(dev, "bootup_done", &bootup_status);
+	if (ret < 0) {
+		dev_err(dev, "failed to read bootup_done property\n");
+		return ret;
+	}
+
+	if (strcmp(bootup_status, "true")) {
+		dev_err(dev, "device bootup required\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void mlxbf_pka_drv_get_mem_res(struct mlxbf_pka_device *mlxbf_pka_dev,
+				      struct mlxbf_pka_dev_mem_res *mem_res,
+				      u64 wndw_ram_off_mask)
+{
+	enum mlxbf_pka_mem_res_idx acpi_mem_idx;
+
+	acpi_mem_idx = MLXBF_PKA_ACPI_EIP154_IDX;
+	mem_res->wndw_ram_off_mask = wndw_ram_off_mask;
+
+	/* PKA EIP154 MMIO base address. */
+	mem_res->eip154_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	mem_res->eip154_size = resource_size(mlxbf_pka_dev->resource[acpi_mem_idx]);
+	acpi_mem_idx++;
+
+	/* PKA window RAM base address. */
+	mem_res->wndw_ram_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	mem_res->wndw_ram_size = resource_size(mlxbf_pka_dev->resource[acpi_mem_idx]);
+	acpi_mem_idx++;
+
+	/*
+	 * PKA alternate window RAM base address.
+	 * Note: the size of all the alt window RAM is the same, depicted by
+	 * 'alt_wndw_ram_size' variable. All alt window RAM resources are read
+	 * here even though not all of them are used currently.
+	 */
+	mem_res->alt_wndw_ram_0_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	mem_res->alt_wndw_ram_size = resource_size(mlxbf_pka_dev->resource[acpi_mem_idx]);
+
+	if (mem_res->alt_wndw_ram_size != MLXBF_PKA_WINDOW_RAM_REGION_SIZE)
+		dev_warn(mlxbf_pka_dev->device, "alternate Window RAM size from ACPI is wrong.\n");
+
+	acpi_mem_idx++;
+
+	mem_res->alt_wndw_ram_1_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	acpi_mem_idx++;
+
+	mem_res->alt_wndw_ram_2_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	acpi_mem_idx++;
+
+	mem_res->alt_wndw_ram_3_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	acpi_mem_idx++;
+
+	/* PKA CSR base address. */
+	mem_res->csr_base = mlxbf_pka_dev->resource[acpi_mem_idx]->start;
+	mem_res->csr_size = resource_size(mlxbf_pka_dev->resource[acpi_mem_idx]);
+}
+
+/*
+ * Note: this function must be serialized because it calls
+ * 'mlxbf_pka_dev_register_shim' which manipulates common counters for the
+ * PKA devices.
+ */
+static int mlxbf_pka_drv_register_device(struct mlxbf_pka_device *mlxbf_pka_dev,
+					 u64 wndw_ram_off_mask)
+{
+	struct mlxbf_pka_dev_mem_res mem_res;
+	u32 mlxbf_pka_shim_id;
+	int ret;
+
+	/* Assert that the driver lock is held for serialization */
+	lockdep_assert_held(&mlxbf_pka_drv_lock);
+
+	mlxbf_pka_shim_id = mlxbf_pka_dev->device_id;
+
+	mlxbf_pka_drv_get_mem_res(mlxbf_pka_dev, &mem_res, wndw_ram_off_mask);
+
+	ret = mlxbf_pka_dev_register_shim(mlxbf_pka_dev->device,
+					  mlxbf_pka_shim_id,
+					  &mem_res,
+					  &mlxbf_pka_dev->shim);
+	if (ret) {
+		dev_dbg(mlxbf_pka_dev->device, "failed to register shim\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int mlxbf_pka_drv_unregister_device(struct mlxbf_pka_device *mlxbf_pka_dev)
+{
+	if (!mlxbf_pka_dev || !mlxbf_pka_dev->shim)
+		return -EINVAL;
+
+	dev_dbg(mlxbf_pka_dev->device, "unregister device shim\n");
+	return mlxbf_pka_dev_unregister_shim(mlxbf_pka_dev->device, mlxbf_pka_dev->shim);
+}
+
+static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
+{
+	struct mlxbf_pka_drv_plat_info *plat_info;
+	enum mlxbf_pka_mem_res_idx acpi_mem_idx;
+	struct mlxbf_pka_device *mlxbf_pka_dev;
+	const struct acpi_device_id *aid;
+	struct platform_device *pdev;
+	u64 wndw_ram_off_mask;
+	struct device *dev;
+	int ret;
+
+	if (!info)
+		return -EINVAL;
+
+	dev = info->dev;
+	pdev = to_platform_device(dev);
+
+	mlxbf_pka_dev = devm_kzalloc(dev, sizeof(*mlxbf_pka_dev), GFP_KERNEL);
+	if (!mlxbf_pka_dev)
+		return -ENOMEM;
+
+	scoped_guard(mutex, &mlxbf_pka_drv_lock) {
+		mlxbf_pka_device_cnt += 1;
+		if (mlxbf_pka_device_cnt > MLXBF_PKA_DRIVER_DEV_MAX) {
+			dev_dbg(dev, "cannot support %u devices\n", mlxbf_pka_device_cnt);
+			return -ENOSPC;
+		}
+		mlxbf_pka_dev->device_id = mlxbf_pka_device_cnt - 1;
+	}
+
+	mlxbf_pka_dev->info = info;
+	mlxbf_pka_dev->device = dev;
+	info->flag = MLXBF_PKA_DRIVER_FLAG_DEVICE;
+
+	for (acpi_mem_idx = MLXBF_PKA_ACPI_EIP154_IDX;
+	     acpi_mem_idx < MLXBF_PKA_DEVICE_RES_CNT;
+	     acpi_mem_idx++) {
+		mlxbf_pka_dev->resource[acpi_mem_idx] = platform_get_resource(pdev,
+									      IORESOURCE_MEM,
+									      acpi_mem_idx);
+	}
+
+	/* Verify PKA bootup status. */
+	ret = mlxbf_pka_drv_verify_bootup_status(dev);
+	if (ret)
+		return ret;
+
+	/* Window RAM offset mask is platform dependent. */
+	aid = acpi_match_device(mlxbf_pka_drv_acpi_ids, dev);
+	if (!aid)
+		return -ENODEV;
+
+	plat_info = (struct mlxbf_pka_drv_plat_info *)aid->driver_data;
+	if (!plat_info) {
+		dev_err(dev, "missing platform data\n");
+		return -EINVAL;
+	}
+
+	wndw_ram_off_mask = plat_info->wndw_ram_off_mask;
+
+	scoped_guard(mutex, &mlxbf_pka_drv_lock) {
+		ret = mlxbf_pka_drv_register_device(mlxbf_pka_dev, wndw_ram_off_mask);
+		if (ret) {
+			dev_dbg(dev, "failed to register shim\n");
+			return ret;
+		}
+	}
+
+	info->priv = mlxbf_pka_dev;
+
+	return 0;
+}
+
+static void mlxbf_pka_drv_remove_device(struct platform_device *pdev)
+{
+	struct mlxbf_pka_platdata *priv = platform_get_drvdata(pdev);
+	struct mlxbf_pka_info *info = priv->info;
+	struct mlxbf_pka_device *mlxbf_pka_dev = (struct mlxbf_pka_device *)info->priv;
+
+	if (!mlxbf_pka_dev)
+		return;
+
+	mlxbf_pka_drv_unregister_device(mlxbf_pka_dev);
+}
+
+static int mlxbf_pka_drv_acpi_probe(struct platform_device *pdev, struct mlxbf_pka_info *info)
+{
+	struct device *dev = &pdev->dev;
+	struct acpi_device *adev;
+	int ret;
+
+	if (acpi_disabled)
+		return -ENOENT;
+
+	adev = ACPI_COMPANION(dev);
+	if (!adev) {
+		dev_dbg(dev, "ACPI companion device not found for %s\n", pdev->name);
+		return -ENODEV;
+	}
+
+	info->acpihid = acpi_device_hid(adev);
+	if (WARN_ON(!info->acpihid))
+		return -EINVAL;
+
+	if (!strcmp(info->acpihid, mlxbf_pka_acpihid_bf1) ||
+	    !strcmp(info->acpihid, mlxbf_pka_acpihid_bf2) ||
+	    !strcmp(info->acpihid, mlxbf_pka_acpihid_bf3)) {
+		ret = mlxbf_pka_drv_probe_device(info);
+		if (ret) {
+			dev_dbg(dev, "failed to register device\n");
+			return ret;
+		}
+		dev_info(dev, "device probed\n");
+	}
+
+	return 0;
+}
+
+static int mlxbf_pka_drv_probe(struct platform_device *pdev)
+{
+	struct mlxbf_pka_platdata *priv;
+	struct device *dev = &pdev->dev;
+	struct mlxbf_pka_info *info;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	spin_lock_init(&priv->lock);
+	priv->pdev = pdev;
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->name = pdev->name;
+	info->module = THIS_MODULE;
+	info->dev = dev;
+	priv->info = info;
+
+	platform_set_drvdata(pdev, priv);
+
+	ret = mlxbf_pka_drv_acpi_probe(pdev, info);
+	if (ret) {
+		dev_dbg(dev, "unknown device\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static void mlxbf_pka_drv_remove(struct platform_device *pdev)
+{
+	struct mlxbf_pka_platdata *priv = platform_get_drvdata(pdev);
+	struct mlxbf_pka_info *info = priv->info;
+
+	if (info->flag == MLXBF_PKA_DRIVER_FLAG_DEVICE) {
+		dev_info(&pdev->dev, "remove PKA device\n");
+		mlxbf_pka_drv_remove_device(pdev);
+	}
+}
+
+MODULE_DEVICE_TABLE(acpi, mlxbf_pka_drv_acpi_ids);
+
+static struct platform_driver mlxbf_pka_drv = {
+	.driver = {
+		   .name = KBUILD_MODNAME,
+		   .acpi_match_table = ACPI_PTR(mlxbf_pka_drv_acpi_ids),
+		  },
+	.probe = mlxbf_pka_drv_probe,
+	.remove = mlxbf_pka_drv_remove,
+};
+
+module_platform_driver(mlxbf_pka_drv);
+MODULE_DESCRIPTION(MLXBF_PKA_DRIVER_DESCRIPTION);
+MODULE_AUTHOR("Ron Li <xiangrongl@nvidia.com>");
+MODULE_AUTHOR("Khalil Blaiech <kblaiech@nvidia.com>");
+MODULE_AUTHOR("Mahantesh Salimath <mahantesh@nvidia.com>");
+MODULE_AUTHOR("Shih-Yi Chen <shihyic@nvidia.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.34.1

