Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CF132143E;
	Fri, 19 Sep 2025 19:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758311602; cv=fail; b=lXwI0ZB9c9q0W+TurtVQkZtZstEXoDUuMGLs+Ly/kte5vcmWSWn+kAgMEfVptArLo1HsyznEkw19vGMlj6e1i+f9GsrywI6s+X0goBhxwddwgD3tCBh+urhKmQiy4bu8kO9VQcp5B6Vts2ETS4jhCtOGnXPmIkxztA1GNF4BP6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758311602; c=relaxed/simple;
	bh=PC3pgxfvBJ2p2GI9qLU2qXj3g5+0cCsVg+Sr8pR7Hi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RlZtOLLlXfy7gljFjtK5zOVpfXxYE5GrPYxU3Agv5jCnRY5r6CsTnPSCRHjcqTV0VdGwCqSwGVRApUUawPbDxpVX+KHWk1D6tLSHBXamSmN4qCZovUr2dF1En/+HX+IBHer+j8eZB2U8fDRAsKrIL9FaDRNZ1TQBCCWIz0f2oxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SQv0jeaW; arc=fail smtp.client-ip=52.101.43.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SQv0jeaW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xx58w32kCACqi4WoErc9gAuy9aA2HT4987Ik/i4yLcz1lM8iYTK4599eLvlx2Xw7nlLV1TuRVCTGAOWS/XEpqmjNmXwlcy64e8QGIDv7FAKKECwBS5WovUYUmMtYLOWoeR36ok3VrpJhsh5R391xu+vNCWvwLuHNYqbBvvOJTAoNR8oIHQWXLV5ootoh0UoLqozguF+olHrjxo7lkwqTNTYaLsQXVxXzgF/xU4keSq+NLFgikXhvtQsjBr+2bFuJzW5lvfQotxZKyvtJY0loEu5AZj9DWRTuJHFG9w/WzupRkRvZaf7lpkTmeW4mukcld7JvGdQrFb83GJ3pN6mSWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=go2a0ObE3Trq89zOLUqiti0Qw7XEHjlsq00e/g8s/80=;
 b=jzJjRXeWz2xFv2kdi1ZZpQzOliKHedr7agVgHbReQet3rqbrVOnpwrAEdsyKk4iGL6yy7aaSn3qVy/C7e8rGq0/jAAPBpnqwSRMdPs5IHLRplhfIh2eDM1Aq5tPu5HGV9vxTAdETN4LqqpZ2b3zVDIffuIsmDVXBOQVLFPuRl6m2xvEmnlBcoMJSEo+rGJNpTk7l37+yddwjSN9wBLOwgW2JvPjHzK+YlaOChPYbQKMa3ptiRiCAWCRaxDPu5pGZNTyaVpIRtEgiZcMku52Rlfnxe2vxVIJkpby1FbcJSrY5rIPiVRCiVbho8j4B7wVsb1z/WP+FXR/oPbCu0xMWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go2a0ObE3Trq89zOLUqiti0Qw7XEHjlsq00e/g8s/80=;
 b=SQv0jeaWsMjdAhUYo4mHfKzupuyEJmN2FJcn1rt0mymyRHIgAmKz0uMFKXps8g1rPVMRr3Ut91RPupflJmOfjpRtBlVUdjDb0sAlAhvU5BIYDYQhja90DxWd14o4cTTLMJYo6F5FkStry6v48F3thlHhcbaHJumDYmjlU6J5XiHL9PLKc4koDJsLZpOrM3FAVeYFQBQpVHksN4HZZeB5CWporlEbl3yyUourFsfpWsJ+Ue9vD6Wwh0hzcNAryWcZPW45RqSwfZOIVit9KmnJ7z8NVw2tmYUmdjGNkWv+jy2v400nYebe1MTWx0/LiDwbq6MKhEU7TU2j5zlZzuRSbQ==
Received: from CH2PR16CA0011.namprd16.prod.outlook.com (2603:10b6:610:50::21)
 by SJ0PR12MB6880.namprd12.prod.outlook.com (2603:10b6:a03:485::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 19:53:06 +0000
Received: from CH1PEPF0000AD82.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::91) by CH2PR16CA0011.outlook.office365.com
 (2603:10b6:610:50::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.15 via Frontend Transport; Fri,
 19 Sep 2025 19:53:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD82.mail.protection.outlook.com (10.167.244.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Fri, 19 Sep 2025 19:53:05 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Fri, 19 Sep
 2025 12:51:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 19 Sep
 2025 12:51:38 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.1544.34 via Frontend Transport; Fri, 19
 Sep 2025 12:51:38 -0700
From: Ron Li <xiangrongl@nvidia.com>
To: <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<vadimp@nvidia.com>, <alok.a.tiwari@oracle.com>, <kblaiech@nvidia.com>,
	<davthompson@nvidia.com>
CC: <platform-driver-x86@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, Ron Li <xiangrongl@nvidia.com>
Subject: [PATCH v3 3/3] platform/mellanox/mlxbf_pka: Add TRNG support and hwrng integration
Date: Fri, 19 Sep 2025 19:51:32 +0000
Message-ID: <20250919195132.1088515-4-xiangrongl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250919195132.1088515-1-xiangrongl@nvidia.com>
References: <20250919195132.1088515-1-xiangrongl@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD82:EE_|SJ0PR12MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a06956-d6f8-4270-cab3-08ddf7b62672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xPLUPVs1FR6iQ/KrgLULubFMLV9Fnr2PFt9DTiH2ElbuzHAyzOPRdumY7pUW?=
 =?us-ascii?Q?LQmlDjvGP4WMC0KCI2Z74/KdsyhCtFa7Wdwof5OBB5hgvF+dYITfOUZsyi2B?=
 =?us-ascii?Q?KLflAQXj2rY2wkW9w/Om/Pj8mBjmUfFiFsOkEm5a7FEYejXOCipB4yFXrarV?=
 =?us-ascii?Q?Ol/BFi/Bf3wTdibqMuOLE/Y6JbQUhnZxIiZz1jwLgLwDfdjP77zZLsKmWwNs?=
 =?us-ascii?Q?7lfuiKQRRAg7VBm115RSAEjtlG2WJfmvrcplH8R3nZxzLU9JVygyby5DJOmj?=
 =?us-ascii?Q?cX4hK+w99yiyd6vMogGwcELo3gGrWWdk5rBMDIS4xl1lMXcTUkDXp4elIXIW?=
 =?us-ascii?Q?suTbRY68i8jFzEtv+QATrfA6BEYu+9bohP2d5N3mOZZUrWOeaDFjl3K0gsh3?=
 =?us-ascii?Q?FwVqrjJ8w8WwMn94mAjJFC7u6X0ieGObiKAh0fWlWf8H2jtR64flGKR7Xjmn?=
 =?us-ascii?Q?6SBmciM6xTtYICKq4FAEE1eOIpjFO0XkqtzjE0FLDL04Kfk7RGAA6bEU/Rxy?=
 =?us-ascii?Q?FOSk1/ON3celXyut+vxUiAV1cOJZ4q1lEo6a7aby5XLUbFw1+u00PUGcAZZs?=
 =?us-ascii?Q?JgquAKxoi2Ahshe/u2drOt2Ralhp7YAeX0le0DNAHjU2PqWxm3uWlu+iz6CJ?=
 =?us-ascii?Q?0o000GghBUczVFDtCDQ+uY5YQz+A2IH2UoMHEIDFwhRoNsZog8k5sFxZkfOr?=
 =?us-ascii?Q?slmNDusPem/jQHoYsZkx68tDLs9ZNDshFKHrZQmbrLyN/I2ehZI3kY3HLs50?=
 =?us-ascii?Q?IlTXGnQHm9cFpD3SB0KtLnpSlW4Wr+jc2UkJ4OQX+xFfaqK01AsqSdzm4J8b?=
 =?us-ascii?Q?SIuat/txQFXYkoROMZQ3BSwyJbPIEoqQR8IBTHzFT5OdN7PqdXmzh7pZke8n?=
 =?us-ascii?Q?jBaix9mcurG51iZFmUqN9IGxXrRAm3PmV/rGBTmeMsUm1Bxh1eSuD7PrdrGA?=
 =?us-ascii?Q?OMVAA3QDbUJ5wumHmvsoG2qohi5asmzfpPGImP7mabGLz2qjKqaujPV5j2cJ?=
 =?us-ascii?Q?bEEnyFG+PdIKkXWLkIIeDYRMGCbjcBRoucYKurm9YfDAfjbQ+kUE/cTK54F2?=
 =?us-ascii?Q?yBe6/sbrT9QBbSXt+iJoZn+JGxqn/bJs8G3VMIBv80L0wwaTNN0wU01z/NeP?=
 =?us-ascii?Q?6XRUVubnIoYAb+wt4k3uvxkimR/05x0SdQHOP3q07AnaScIEIMSEVv16dgnl?=
 =?us-ascii?Q?EbwYjTrFNrwX5Em5wk2P2kPD7zZ+dg5e8Ibi3aaRjVDWfFHeDsPRzK4hSwzm?=
 =?us-ascii?Q?/RquDKML5jPVj2K6FGED78CGA4bVUF6lN3g17emNd1Vj5KlCerK28r0OeFMU?=
 =?us-ascii?Q?f8f2TmhEfV2k4pyjCYlpKH7h+DtlUdMcCSFPzSG4AWMg8J95dPpdOMSE45QM?=
 =?us-ascii?Q?WoOCNQt76JdRrJ8SxGLkq0ADU/C9aDkCdnC8qTK2GsgqcPR3xqQTZ6HT5OY8?=
 =?us-ascii?Q?rZnuxD9GYzrecVl2IGSHN6Tc+chM67fVBGSm/4fddWBjuJOO0qOmFFUH4wJl?=
 =?us-ascii?Q?1QKL4a2AiaDZo5m5pDp6+INuW1j1LWgZpYS2?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:53:05.4885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a06956-d6f8-4270-cab3-08ddf7b62672
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD82.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6880

Add True Random Number Generator support to the BlueField PKA driver and
wire it into the HWRNG core to feed kernel entropy (/dev/hwrng).

- Enable TRNG clock and configure hardware
- Run TRNG health tests (monobit/run/poker) and a sanity check
- Implement shutdown-overflow recovery and FRO detune/reenable
- Initialize TRNG during shim bring-up and prefetch initial output
- Provide read path from TRNG output registers
- Register/unregister with the HWRNG core

Reviewed-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Ron Li <xiangrongl@nvidia.com>
---
 .../ABI/testing/sysfs-platform-mellanox-pka   |   3 +-
 drivers/platform/mellanox/mlxbf_pka/Makefile  |   1 +
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.c        |  48 +-
 .../mellanox/mlxbf_pka/mlxbf_pka_dev.h        |   6 +
 .../mellanox/mlxbf_pka/mlxbf_pka_drv.c        |  75 ++
 .../mellanox/mlxbf_pka/mlxbf_pka_trng.c       | 874 ++++++++++++++++++
 .../mellanox/mlxbf_pka/mlxbf_pka_trng.h       | 152 +++
 include/uapi/linux/mlxbf-pka.h                |  19 +
 8 files changed, 1176 insertions(+), 2 deletions(-)
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c
 create mode 100644 drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h

diff --git a/Documentation/ABI/testing/sysfs-platform-mellanox-pka b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
index e7d331bca8fb..d45575dc0d77 100644
--- a/Documentation/ABI/testing/sysfs-platform-mellanox-pka
+++ b/Documentation/ABI/testing/sysfs-platform-mellanox-pka
@@ -30,5 +30,6 @@ Description:
 		- release(): close the PKA ring device specified by the device ID, and release the
 		  related RAM regions.
 		- unlocked_ioctl(): make PKA related system calls, including getting ring device or
-		  RAM region information, clearing PKA ring counter.
+		  RAM region information, clearing PKA ring counter and getting random bytes from
+		  the TRNG module from the PKA device.
 		- mmap(): map the PKA ring device to the virtual memory region.
diff --git a/drivers/platform/mellanox/mlxbf_pka/Makefile b/drivers/platform/mellanox/mlxbf_pka/Makefile
index 6e536794d339..4f6df4de9cb7 100644
--- a/drivers/platform/mellanox/mlxbf_pka/Makefile
+++ b/drivers/platform/mellanox/mlxbf_pka/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_MLXBF_PKA) += mlxbf-pka.o
 mlxbf-pka-objs := mlxbf_pka_drv.o
 mlxbf-pka-objs += mlxbf_pka_dev.o
 mlxbf-pka-objs += mlxbf_pka_ring.o
+mlxbf-pka-objs += mlxbf_pka_trng.o
\ No newline at end of file
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
index 12df11dd1eee..f649ae9ef967 100644
--- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.c
@@ -18,6 +18,7 @@
 
 #include "mlxbf_pka_dev.h"
 #include "mlxbf_pka_ring.h"
+#include "mlxbf_pka_trng.h"
 
 struct mlxbf_pka_dev_gbl_config_t mlxbf_pka_gbl_config;
 
@@ -250,6 +251,22 @@ static int mlxbf_pka_dev_create_shim(struct device *dev,
 		return ret;
 	}
 
+	/* Set PKA device TRNG registers. */
+	reg_size = PAGE_SIZE;
+	reg_base = mlxbf_pka_dev_get_register_base(shim->mem_res.eip154_base,
+						   MLXBF_PKA_TRNG_OUTPUT_0_ADDR);
+	ret = mlxbf_pka_dev_set_resource_config(dev,
+						shim,
+						&shim->resources.trng_csr,
+						reg_base,
+						reg_size,
+						MLXBF_PKA_DEV_RES_TYPE_REG,
+						"MLXBF_PKA_TRNG_CSR");
+	if (ret) {
+		dev_err(dev, "unable to setup the TRNG\n");
+		return ret;
+	}
+
 	shim->status = MLXBF_PKA_SHIM_STATUS_CREATED;
 
 	return ret;
@@ -258,7 +275,7 @@ static int mlxbf_pka_dev_create_shim(struct device *dev,
 /* Delete shim and unset shim resources. */
 static int mlxbf_pka_dev_delete_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
 {
-	struct mlxbf_pka_dev_res_t *res_master_seq_ctrl, *res_aic_csr;
+	struct mlxbf_pka_dev_res_t *res_master_seq_ctrl, *res_aic_csr, *res_trng_csr;
 	struct mlxbf_pka_dev_res_t *res_buffer_ram;
 
 	dev_dbg(dev, "PKA device delete shim\n");
@@ -275,10 +292,12 @@ static int mlxbf_pka_dev_delete_shim(struct device *dev, struct mlxbf_pka_dev_sh
 	res_buffer_ram = &shim->resources.buffer_ram;
 	res_master_seq_ctrl = &shim->resources.master_seq_ctrl;
 	res_aic_csr = &shim->resources.aic_csr;
+	res_trng_csr = &shim->resources.trng_csr;
 
 	mlxbf_pka_dev_unset_resource_config(dev, shim, res_buffer_ram);
 	mlxbf_pka_dev_unset_resource_config(dev, shim, res_master_seq_ctrl);
 	mlxbf_pka_dev_unset_resource_config(dev, shim, res_aic_csr);
+	mlxbf_pka_dev_unset_resource_config(dev, shim, res_trng_csr);
 
 	shim->status = MLXBF_PKA_SHIM_STATUS_UNDEFINED;
 
@@ -294,7 +313,9 @@ static int mlxbf_pka_dev_delete_shim(struct device *dev, struct mlxbf_pka_dev_sh
  */
 static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_dev_shim_s *shim)
 {
+	u32 data[MLXBF_PKA_TRNG_OUTPUT_CNT];
 	int ret;
+	u8 i;
 
 	if (shim->status != MLXBF_PKA_SHIM_STATUS_CREATED) {
 		dev_err(dev, "PKA device must be created\n");
@@ -311,6 +332,31 @@ static int mlxbf_pka_dev_init_shim(struct device *dev, struct mlxbf_pka_dev_shim
 		return ret;
 	}
 
+	shim->trng_enabled   = MLXBF_PKA_SHIM_TRNG_ENABLED;
+	shim->trng_err_cycle = 0;
+
+	/* Configure the TRNG. */
+	ret = mlxbf_pka_dev_config_trng_drbg(dev,
+					     &shim->resources.aic_csr,
+					     &shim->resources.trng_csr);
+
+	/*
+	 * Pull out data from the content of the TRNG buffer RAM and start the
+	 * regeneration of new numbers; read and drop 512 words. The read must
+	 * be done over the 4 TRNG_OUTPUT_X registers at a time.
+	 */
+	for (i = 0; i < MLXBF_PKA_TRNG_NUM_OF_FOUR_WORD; i++)
+		mlxbf_pka_dev_trng_read(dev, shim, data, sizeof(data));
+
+	if (ret) {
+		/*
+		 * Keep running without TRNG since it does not hurt, but notify
+		 * users.
+		 */
+		dev_err(dev, "failed to configure TRNG\n");
+		shim->trng_enabled = MLXBF_PKA_SHIM_TRNG_DISABLED;
+	}
+
 	ret = devm_mutex_init(dev, &shim->mutex);
 	if (ret)
 		return ret;
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
index 12512850cf79..ba0bbc87c832 100644
--- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_dev.h
@@ -128,11 +128,13 @@ struct mlxbf_pka_dev_res_t {
  * @buffer_ram: Buffer RAM
  * @master_seq_ctrl: Master sequencer controller CSR
  * @aic_csr: Interrupt controller CSRs
+ * @trng_csr: TRNG module CSRs
  */
 struct mlxbf_pka_dev_shim_res_t {
 	struct mlxbf_pka_dev_res_t buffer_ram;
 	struct mlxbf_pka_dev_res_t master_seq_ctrl;
 	struct mlxbf_pka_dev_res_t aic_csr;
+	struct mlxbf_pka_dev_res_t trng_csr;
 };
 
 /* Number of PKA device resources. */
@@ -180,6 +182,7 @@ struct mlxbf_pka_dev_mem_res {
 /**
  * struct mlxbf_pka_dev_shim_s - PKA Shim structure
  * @mem_res: Memory resources
+ * @trng_err_cycle: TRNG error cycle
  * @shim_id: Shim identifier
  * @rings_num: Number of supported rings (hardware specific)
  * @rings: Pointer to rings which belong to the shim
@@ -188,11 +191,13 @@ struct mlxbf_pka_dev_mem_res {
  * @resources: Shim resources
  * @window_ram_split: If non-zero, the split window RAM scheme is used
  * @busy_ring_num: Number of active rings (rings in busy state)
+ * @trng_enabled: Whether the TRNG engine is enabled
  * @status: Status of the shim
  * @mutex: Mutex lock for sharing shim
  */
 struct mlxbf_pka_dev_shim_s {
 	struct mlxbf_pka_dev_mem_res mem_res;
+	u64 trng_err_cycle;
 	u32 shim_id;
 	u32 rings_num;
 	struct mlxbf_pka_dev_ring_t **rings;
@@ -201,6 +206,7 @@ struct mlxbf_pka_dev_shim_s {
 	struct mlxbf_pka_dev_shim_res_t resources;
 	u8 window_ram_split;
 	u32 busy_ring_num;
+	u8 trng_enabled;
 	s8 status;
 	struct mutex mutex;
 };
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
index a009437e4a48..a1ae007ba903 100644
--- a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_drv.c
@@ -6,6 +6,7 @@
 #include <linux/cdev.h>
 #include <linux/cleanup.h>
 #include <linux/device.h>
+#include <linux/hw_random.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
@@ -22,6 +23,7 @@
 
 #include "mlxbf_pka_dev.h"
 #include "mlxbf_pka_ring.h"
+#include "mlxbf_pka_trng.h"
 
 #define MLXBF_PKA_DRIVER_DESCRIPTION		"BlueField PKA driver"
 
@@ -187,6 +189,7 @@ struct mlxbf_pka_device {
 	u32 device_id;
 	struct resource *resource[MLXBF_PKA_DEVICE_RES_CNT];
 	struct mlxbf_pka_dev_shim_s *shim;
+	struct hwrng rng;
 };
 
 static int mlxbf_pka_drv_verify_bootup_status(struct device *dev)
@@ -435,6 +438,44 @@ static long mlxbf_pka_drv_ring_ioctl(void *device_data, unsigned int cmd, unsign
 
 	} else if (cmd == MLXBF_PKA_CLEAR_RING_COUNTERS) {
 		return mlxbf_pka_dev_clear_ring_counters(ring_dev->ring);
+	} else if (cmd == MLXBF_PKA_GET_RANDOM_BYTES) {
+		struct mlxbf_pka_dev_trng_info trng_data;
+		struct mlxbf_pka_dev_shim_s *shim;
+		bool trng_present;
+		u32 byte_cnt;
+		int ret;
+
+		shim = ring_dev->ring->shim;
+		ret = copy_from_user(&trng_data,
+				     (void __user *)(arg),
+				     sizeof(struct mlxbf_pka_dev_trng_info));
+		if (ret) {
+			dev_dbg(ring_dev->device, "failed to copy user request.\n");
+			return -EFAULT;
+		}
+
+		/*
+		 * Need byte count which is multiple of 4 as required by the
+		 * mlxbf_pka_dev_trng_read() interface.
+		 */
+		byte_cnt = round_up(trng_data.count, MLXBF_PKA_TRNG_OUTPUT_CNT);
+
+		u32 *data __free(kfree) = kzalloc(byte_cnt, GFP_KERNEL);
+		if (!data)
+			return -ENOMEM;
+
+		trng_present = mlxbf_pka_dev_has_trng(shim);
+		if (!trng_present)
+			return -EAGAIN;
+
+		ret = mlxbf_pka_dev_trng_read(ring_dev->device, shim, data, byte_cnt);
+		if (ret) {
+			dev_dbg(ring_dev->device, "TRNG failed %d\n", ret);
+			return ret;
+		}
+
+		ret = copy_to_user((void __user *)(trng_data.data), data, trng_data.count);
+		return ret ? -EFAULT : 0;
 	}
 
 	return -ENOTTY;
@@ -659,6 +700,23 @@ static void mlxbf_pka_drv_unregister_ring_device(struct mlxbf_pka_ring_device *r
 	mlxbf_pka_dev_unregister_ring(ring_dev->device, ring_dev->ring);
 }
 
+static int mlxbf_pka_drv_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct mlxbf_pka_device *mlxbf_pka_dev = container_of(rng, struct mlxbf_pka_device, rng);
+	u32 *buffer = data;
+	int ret;
+
+	ret = mlxbf_pka_dev_trng_read(mlxbf_pka_dev->device, mlxbf_pka_dev->shim, buffer, max);
+	if (ret) {
+		dev_dbg(mlxbf_pka_dev->device,
+			"%s: failed to read random bytes ret=%d",
+			rng->name, ret);
+		return 0;
+	}
+
+	return max;
+}
+
 static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
 {
 	struct mlxbf_pka_drv_plat_info *plat_info;
@@ -667,6 +725,7 @@ static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
 	const struct acpi_device_id *aid;
 	struct platform_device *pdev;
 	u64 wndw_ram_off_mask;
+	struct hwrng *trng;
 	struct device *dev;
 	int ret;
 
@@ -727,6 +786,19 @@ static int mlxbf_pka_drv_probe_device(struct mlxbf_pka_info *info)
 		}
 	}
 
+	/* Setup the TRNG if needed. */
+	if (mlxbf_pka_dev_has_trng(mlxbf_pka_dev->shim)) {
+		trng = &mlxbf_pka_dev->rng;
+		trng->name = pdev->name;
+		trng->read = mlxbf_pka_drv_rng_read;
+
+		ret = hwrng_register(&mlxbf_pka_dev->rng);
+		if (ret) {
+			dev_err(dev, "failed to register trng\n");
+			return ret;
+		}
+	}
+
 	info->priv = mlxbf_pka_dev;
 
 	return 0;
@@ -741,6 +813,9 @@ static void mlxbf_pka_drv_remove_device(struct platform_device *pdev)
 	if (!mlxbf_pka_dev)
 		return;
 
+	if (mlxbf_pka_dev_has_trng(mlxbf_pka_dev->shim))
+		hwrng_unregister(&mlxbf_pka_dev->rng);
+
 	mlxbf_pka_drv_unregister_device(mlxbf_pka_dev);
 }
 
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c
new file mode 100644
index 000000000000..0a0007fb9e31
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.c
@@ -0,0 +1,874 @@
+// SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause
+// SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved.
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/iopoll.h>
+
+#include "mlxbf_pka_dev.h"
+#include "mlxbf_pka_ring.h"
+#include "mlxbf_pka_trng.h"
+
+/* Personalization string "NVIDIA-MELLANOX-BLUEFIELD-TRUE_RANDOM_NUMBER_GEN". */
+static u32 mlxbf_pka_trng_drbg_ps_str[] = {
+	0x4e564944, 0x49412d4d, 0x454c4c41, 0x4e4f582d,
+	0x424c5545, 0x4649454c, 0x442d5452, 0x55455f52,
+	0x414e444f, 0x4d5f4e55, 0x4d424552, 0x5f47454e
+};
+
+/* Personalization string for DRBG test. */
+static u32 mlxbf_pka_trng_drbg_test_ps_str[] = {
+	0x64299d83, 0xc34d7098, 0x5bd1f51d, 0xddccfdc1,
+	0xdd0455b7, 0x166279e5, 0x0974cb1b, 0x2f2cd100,
+	0x59a5060a, 0xca79940d, 0xd4e29a40, 0x56b7b779
+};
+
+/* First Entropy string for DRBG test. */
+static u32 mlxbf_pka_trng_drbg_test_etpy_str1[] = {
+	0xaa6bbcab, 0xef45e339, 0x136ca1e7, 0xbce1c881,
+	0x9fa37b09, 0x63b53667, 0xb36e0053, 0xa202ed81,
+	0x4650d90d, 0x8eed6127, 0x666f2402, 0x0dfd3af9
+};
+
+/* Second Entropy string for DRBG test. */
+static u32 mlxbf_pka_trng_drbg_test_etpy_str2[] = {
+	0x35c1b7a1, 0x0154c52b, 0xd5777390, 0x226a4fdb,
+	0x5f16080d, 0x06b68369, 0xd0c93d00, 0x3336e27f,
+	0x1abf2c37, 0xe6ab006c, 0xa4adc6e1, 0x8e1907a2
+};
+
+/* Known answer for DRBG test. */
+static u32 mlxbf_pka_trng_drbg_test_output[] = {
+	0xb663b9f1, 0x24943e13, 0x80f7dce5, 0xaba1a16f
+};
+
+/* Known answer for poker test. */
+static u64 poker_test_exp_cnt[] = {
+	0x20f42bf4, 0xaf415f4, 0xf4f4fff4, 0xfff4f4f4
+};
+
+static int mlxbf_pka_dev_config_trng_clk(struct device *dev,
+					 struct mlxbf_pka_dev_res_t *aic_csr_ptr)
+{
+	u32 trng_clk_en = 0;
+	void __iomem *csr_reg_ptr;
+	u64 csr_reg_base;
+	u64 csr_reg_off;
+	u64 timer;
+
+	if (aic_csr_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
+	    aic_csr_ptr->type != MLXBF_PKA_DEV_RES_TYPE_REG)
+		return -EPERM;
+
+	dev_dbg(dev, "turn on TRNG clock\n");
+
+	csr_reg_base = aic_csr_ptr->base;
+	csr_reg_ptr = aic_csr_ptr->ioaddr;
+
+	/*
+	 * Enable the TRNG clock in MLXBF_PKA_CLK_FORCE. In general, this
+	 * register should be left in its default state of all zeroes. Only
+	 * when the TRNG is directly controlled via the Host slave interface,
+	 * the engine needs to be turned on using the 'trng_clk_on' bit in
+	 * this register. In case the TRNG is controlled via internal firmware,
+	 * this is not required.
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_CLK_FORCE_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_CLK_FORCE_TRNG_ON);
+	/*
+	 * Check whether the system clock for TRNG engine is enabled. The clock
+	 * MUST be running to provide access to the TRNG.
+	 */
+	timer = mlxbf_pka_dev_timer_start_msec(100);
+	while (!trng_clk_en) {
+		trng_clk_en |= mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off)
+						     & MLXBF_PKA_CLK_FORCE_TRNG_ON;
+		if (mlxbf_pka_dev_timer_done(timer)) {
+			dev_dbg(dev, "failed to enable TRNG clock\n");
+			return -ETIMEDOUT;
+		}
+	}
+	dev_dbg(dev, "trng_clk_on is enabled\n");
+
+	return 0;
+}
+
+static bool mlxbf_pka_dev_trng_wait_test_ready(struct device *dev,
+					       void __iomem *csr_reg_ptr,
+					       u64 csr_reg_base)
+{
+	u64 csr_reg_off, timer, csr_reg_val, test_ready = 0;
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STATUS_ADDR);
+	timer = mlxbf_pka_dev_timer_start_msec(MSEC_PER_SEC);
+
+	while (!test_ready) {
+		csr_reg_val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+		test_ready = csr_reg_val & MLXBF_PKA_TRNG_STATUS_TEST_READY;
+
+		if (mlxbf_pka_dev_timer_done(timer)) {
+			dev_dbg(dev, "TRNG test ready timer done, 0x%llx\n", csr_reg_val);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int mlxbf_pka_dev_trng_enable_test(struct device *dev,
+					  void __iomem *csr_reg_ptr,
+					  u64 csr_reg_base, u32 test)
+{
+	u64 csr_reg_val, csr_reg_off;
+	int ret;
+
+	/*
+	 * Set the 'test_mode' bit in the TRNG_CONTROL register and the
+	 * 'test_known_noise' bit in the TRNG_TEST register - this will
+	 * immediately set the 'test_ready' bit (in the TRNG_STATUS register)
+	 * to indicate that data can be written. It will also reset the
+	 * 'monobit test', 'run test' and 'poker test' circuits to their
+	 * initial states. Note that the TRNG need not be enabled for this
+	 * test.
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	csr_reg_val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+			       csr_reg_val | MLXBF_PKA_TRNG_CONTROL_TEST_MODE);
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_TEST_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, test);
+	/* Wait until the 'test_ready' bit is set. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STATUS_ADDR);
+	ret = read_poll_timeout(mlxbf_pka_dev_io_read, csr_reg_val,
+				csr_reg_val & MLXBF_PKA_TRNG_STATUS_TEST_READY,
+				USEC_PER_MSEC / 100, USEC_PER_SEC, false,
+				csr_reg_ptr, csr_reg_off);
+	if (ret) {
+		dev_err(dev, "timeout waiting for test ready\n");
+		return -ETIMEDOUT;
+	}
+
+	/*
+	 * Check whether the 'monobit test', 'run test' and 'poker test'
+	 * are reset.
+	 */
+	if (csr_reg_val & MLXBF_PKA_TRNG_STATUS_FAIL_MODES) {
+		dev_err(dev, "test bits aren't reset, TRNG_STATUS:0x%llx\n", csr_reg_val);
+		return -EIO;
+	}
+
+	/*
+	 * Set 'stall_run_poker' bit to allow inspecting the state of the
+	 * result counters which would otherwise be reset immediately for the
+	 * next 20,000 bits block to test.
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMCNT_ADDR);
+	csr_reg_val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+	mlxbf_pka_dev_io_write(csr_reg_ptr,
+			       csr_reg_off,
+			       csr_reg_val | MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER);
+
+	return 0;
+}
+
+static int mlxbf_pka_dev_trng_test_circuits(struct device *dev,
+					    void __iomem *csr_reg_ptr,
+					    u64 csr_reg_base,
+					    u64 datal, u64 datah,
+					    int count, u8 add_half,
+					    u64 *monobit_fail_cnt,
+					    u64 *run_fail_cnt,
+					    u64 *poker_fail_cnt)
+{
+	u64 status, csr_reg_off;
+	unsigned int test_idx;
+	int ret;
+
+	if (!monobit_fail_cnt || !run_fail_cnt || !poker_fail_cnt)
+		return -EINVAL;
+
+	for (test_idx = 0; test_idx < count; test_idx++) {
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_RAW_L_ADDR);
+		mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, datal);
+
+		if (!add_half || test_idx < count - 1) {
+			csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+									MLXBF_PKA_TRNG_RAW_H_ADDR);
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, datah);
+		}
+
+		/*
+		 * Wait until the 'test_ready' bit in the TRNG_STATUS register
+		 * becomes '1' again, signalling readiness for the next 64 bits
+		 * of test data. At this point, the previous test data has been
+		 * handled so the counter states can be inspected.
+		 */
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_STATUS_ADDR);
+		ret = read_poll_timeout(mlxbf_pka_dev_io_read, status,
+					status & MLXBF_PKA_TRNG_STATUS_TEST_READY,
+					USEC_PER_MSEC / 100, USEC_PER_SEC, false,
+					csr_reg_ptr, csr_reg_off);
+		if (ret) {
+			dev_err(dev, "timeout waiting for test ready in circuits\n");
+			return -ETIMEDOUT;
+		}
+
+		/* Check test status bits. */
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_INTACK_ADDR);
+		if (status & MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL) {
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+					       MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL);
+			*monobit_fail_cnt += 1;
+		} else if (status & MLXBF_PKA_TRNG_STATUS_RUN_FAIL) {
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+					       MLXBF_PKA_TRNG_STATUS_RUN_FAIL);
+			*run_fail_cnt += 1;
+		} else if (status & MLXBF_PKA_TRNG_STATUS_POKER_FAIL) {
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+					       MLXBF_PKA_TRNG_STATUS_POKER_FAIL);
+			*poker_fail_cnt += 1;
+		}
+	}
+
+	return *monobit_fail_cnt || *poker_fail_cnt || *run_fail_cnt ? -EIO : 0;
+}
+
+static void mlxbf_pka_dev_trng_disable_test(struct device *dev,
+					    void __iomem *csr_reg_ptr,
+					    u64 csr_reg_base)
+{
+	u64 status, val, csr_reg_off;
+
+	/*
+	 * When done, clear the 'test_known_noise' bit in the TRNG_TEST
+	 * register (will immediately clear the 'test_ready' bit in the
+	 * TRNG_STATUS register and reset the 'monobit test', 'run test'
+	 * and 'poker test' circuits) and clear the 'test_mode' bit in the
+	 * TRNG_CONTROL register.
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_TEST_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STATUS_ADDR);
+	status = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+	if (status & MLXBF_PKA_TRNG_STATUS_TEST_READY)
+		dev_info(dev, "test ready bit is still set\n");
+
+	if (status & MLXBF_PKA_TRNG_STATUS_FAIL_MODES)
+		dev_info(dev, "test bits are still set, TRNG_STATUS:0x%llx\n", status);
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, val & ~MLXBF_PKA_TRNG_STATUS_TEST_READY);
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMCNT_ADDR);
+	val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+	mlxbf_pka_dev_io_write(csr_reg_ptr,
+			       csr_reg_off,
+			       val & ~MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER);
+}
+
+static int mlxbf_pka_dev_trng_test_known_answer_basic(struct device *dev,
+						      void __iomem *csr_reg_ptr,
+						      u64 csr_reg_base)
+{
+	u64 poker_cnt[MLXBF_PKA_TRNG_POKER_TEST_CNT];
+	u64 monobit_fail_cnt = 0;
+	u64 poker_fail_cnt = 0;
+	u64 run_fail_cnt = 0;
+	u64 monobit_cnt;
+	u64 csr_reg_off;
+	int cnt_idx;
+	int cnt_off;
+	int ret;
+
+	dev_dbg(dev, "run known-answer test circuits\n");
+
+	ret = mlxbf_pka_dev_trng_enable_test(dev, csr_reg_ptr, csr_reg_base,
+					     MLXBF_PKA_TRNG_TEST_KNOWN_NOISE);
+	if (ret)
+		return ret;
+
+	ret = mlxbf_pka_dev_trng_test_circuits(dev,
+					       csr_reg_ptr,
+					       csr_reg_base,
+					       MLXBF_PKA_TRNG_TEST_DATAL_BASIC_1,
+					       MLXBF_PKA_TRNG_TEST_DATAH_BASIC_1,
+					       MLXBF_PKA_TRNG_TEST_COUNT_BASIC_1,
+					       MLXBF_PKA_TRNG_TEST_HALF_NO,
+					       &monobit_fail_cnt,
+					       &run_fail_cnt,
+					       &poker_fail_cnt);
+
+	ret |= mlxbf_pka_dev_trng_test_circuits(dev,
+						csr_reg_ptr,
+						csr_reg_base,
+						MLXBF_PKA_TRNG_TEST_DATAL_BASIC_2,
+						MLXBF_PKA_TRNG_TEST_DATAH_BASIC_2,
+						MLXBF_PKA_TRNG_TEST_COUNT_BASIC_2,
+						MLXBF_PKA_TRNG_TEST_HALF_ADD,
+						&monobit_fail_cnt,
+						&run_fail_cnt,
+						&poker_fail_cnt);
+
+	dev_dbg(dev, "monobit_fail_cnt : 0x%llx\n", monobit_fail_cnt);
+	dev_dbg(dev, "poker_fail_cnt   : 0x%llx\n", poker_fail_cnt);
+	dev_dbg(dev, "run_fail_cnt     : 0x%llx\n", run_fail_cnt);
+
+	for (cnt_idx = 0, cnt_off = 0;
+	     cnt_idx < MLXBF_PKA_TRNG_POKER_TEST_CNT;
+	     cnt_idx++, cnt_off += 8) {
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_POKER_3_0_ADDR +
+								cnt_off);
+		poker_cnt[cnt_idx] = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+	}
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							MLXBF_PKA_TRNG_MONOBITCNT_ADDR);
+	monobit_cnt = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+	if (ret)
+		goto exit;
+
+	if (memcmp(poker_cnt, poker_test_exp_cnt, sizeof(poker_test_exp_cnt))) {
+		dev_dbg(dev, "invalid poker counters!\n");
+		ret = -EIO;
+		goto exit;
+	}
+
+	if (monobit_cnt != MLXBF_PKA_TRNG_MONOBITCNT_SUM) {
+		dev_dbg(dev, "invalid sum of squares!\n");
+		ret = -EIO;
+		goto exit;
+	}
+
+exit:
+	mlxbf_pka_dev_trng_disable_test(dev, csr_reg_ptr, csr_reg_base);
+	return ret;
+}
+
+static int mlxbf_pka_dev_trng_test_known_answer_poker_fail(struct device *dev,
+							   void __iomem *csr_reg_ptr,
+							   u64 csr_reg_base)
+{
+	u64 monobit_fail_cnt = 0;
+	u64 poker_fail_cnt = 0;
+	u64 run_fail_cnt = 0;
+
+	dev_dbg(dev, "run known-answer test circuits (poker fail)\n");
+
+	mlxbf_pka_dev_trng_enable_test(dev, csr_reg_ptr, csr_reg_base,
+				       MLXBF_PKA_TRNG_TEST_KNOWN_NOISE);
+
+	/*
+	 * Ignore the return value here as it is expected that poker test
+	 * should fail. Check failure counts thereafter to assert only poker
+	 * test has failed.
+	 */
+	mlxbf_pka_dev_trng_test_circuits(dev,
+					 csr_reg_ptr,
+					 csr_reg_base,
+					 MLXBF_PKA_TRNG_TEST_DATAL_POKER,
+					 MLXBF_PKA_TRNG_TEST_DATAH_POKER,
+					 MLXBF_PKA_TRNG_TEST_COUNT_POKER,
+					 MLXBF_PKA_TRNG_TEST_HALF_NO,
+					 &monobit_fail_cnt,
+					 &run_fail_cnt,
+					 &poker_fail_cnt);
+
+	dev_dbg(dev, "monobit_fail_cnt : 0x%llx\n", monobit_fail_cnt);
+	dev_dbg(dev, "poker_fail_cnt   : 0x%llx\n", poker_fail_cnt);
+	dev_dbg(dev, "run_fail_cnt     : 0x%llx\n", run_fail_cnt);
+
+	mlxbf_pka_dev_trng_disable_test(dev, csr_reg_ptr, csr_reg_base);
+
+	return poker_fail_cnt && !run_fail_cnt && !monobit_fail_cnt ? 0 : -EIO;
+}
+
+static int mlxbf_pka_dev_trng_test_unknown_answer(struct device *dev,
+						  void __iomem *csr_reg_ptr,
+						  u64 csr_reg_base)
+{
+	u64 datal = 0, datah = 0, csr_reg_off;
+	int ret = 0, test_idx;
+
+	dev_dbg(dev, "run unknown-answer self test\n");
+
+	/* First reset, the RAW registers. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_RAW_L_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_RAW_H_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	/*
+	 * There is a small probability for this test to fail. So run the test
+	 * 10 times, if it succeeds once then assume that the test passed.
+	 */
+	for (test_idx = 0; test_idx < 10; test_idx++) {
+		mlxbf_pka_dev_trng_enable_test(dev, csr_reg_ptr, csr_reg_base,
+					       MLXBF_PKA_TRNG_TEST_NOISE);
+
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_RAW_L_ADDR);
+		datal = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_RAW_H_ADDR);
+		datah = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+		dev_dbg(dev, "datal=0x%llx\n", datal);
+		dev_dbg(dev, "datah=0x%llx\n", datah);
+
+		mlxbf_pka_dev_trng_disable_test(dev, csr_reg_ptr, csr_reg_base);
+
+		if (!datah && !datal)
+			ret = -EIO;
+		else
+			return 0;
+	}
+	return ret;
+}
+
+/* Test TRNG. */
+static int mlxbf_pka_dev_test_trng(struct device *dev, void __iomem *csr_reg_ptr, u64 csr_reg_base)
+{
+	int ret;
+
+	ret = mlxbf_pka_dev_trng_test_known_answer_basic(dev, csr_reg_ptr, csr_reg_base);
+	if (ret)
+		return ret;
+
+	ret = mlxbf_pka_dev_trng_test_known_answer_poker_fail(dev, csr_reg_ptr, csr_reg_base);
+	if (ret)
+		return ret;
+
+	ret = mlxbf_pka_dev_trng_test_unknown_answer(dev, csr_reg_ptr, csr_reg_base);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
+static void mlxbf_pka_dev_trng_write_ps_ai_str(void __iomem *csr_reg_ptr,
+					       u64 csr_reg_base,
+					       u32 input_str[])
+{
+	u64 csr_reg_off;
+	u8 i;
+
+	for (i = 0; i < MLXBF_PKA_TRNG_PS_AI_REG_COUNT; i++) {
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_PS_AI_0_ADDR + i *
+								MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET);
+
+		mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, input_str[i]);
+	}
+}
+
+static void mlxbf_pka_dev_trng_drbg_generate(void __iomem *csr_reg_ptr, u64 csr_reg_base)
+{
+	u64 csr_reg_off;
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTROL_REQ_DATA);
+}
+
+static int mlxbf_pka_dev_test_trng_drbg(struct device *dev,
+					void __iomem *csr_reg_ptr,
+					u64 csr_reg_base)
+{
+	u64 csr_reg_off, csr_reg_val;
+	u8 i;
+
+	/* Make sure the engine is idle. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	/* Enable DRBG, TRNG need not be enabled for this test. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTROL_DRBG_ENABLE);
+
+	/* Set 'test_sp_800_90' bit in the TRNG_TEST register. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_TEST_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_TEST_DRBG);
+
+	/* Wait for 'test_ready' bit to be set. */
+	if (!mlxbf_pka_dev_trng_wait_test_ready(dev, csr_reg_ptr, csr_reg_base))
+		return -ETIMEDOUT;
+
+	/* 'Instantiate' function. */
+	mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
+					   csr_reg_base,
+					   mlxbf_pka_trng_drbg_test_ps_str);
+	if (!mlxbf_pka_dev_trng_wait_test_ready(dev, csr_reg_ptr, csr_reg_base))
+		return -ETIMEDOUT;
+
+	/* 'Generate' function. */
+	mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
+					   csr_reg_base,
+					   mlxbf_pka_trng_drbg_test_etpy_str1);
+	if (!mlxbf_pka_dev_trng_wait_test_ready(dev, csr_reg_ptr, csr_reg_base))
+		return -ETIMEDOUT;
+
+	/*
+	 * A standard NIST SP 800-90A DRBG known-answer test discards the
+	 * result of the first 'Generate' function and only checks the result
+	 * of the second 'Generate' function. Hence 'Generate' is performed
+	 * again.
+	 */
+
+	/* 'Generate' function. */
+	mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr,
+					   csr_reg_base,
+					   mlxbf_pka_trng_drbg_test_etpy_str2);
+	if (!mlxbf_pka_dev_trng_wait_test_ready(dev, csr_reg_ptr, csr_reg_base))
+		return -ETIMEDOUT;
+
+	/* Check output registers. */
+	for (i = 0; i < MLXBF_PKA_TRNG_OUTPUT_CNT; i++) {
+		csr_reg_off =
+		mlxbf_pka_dev_get_register_offset(csr_reg_base,
+						  MLXBF_PKA_TRNG_OUTPUT_0_ADDR +
+						  (i * MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET));
+
+		csr_reg_val = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+		if ((u32)csr_reg_val != mlxbf_pka_trng_drbg_test_output[i]) {
+			dev_dbg(dev, "DRBG known answer test failed: output register:%d, 0x%x\n",
+				i, (u32)csr_reg_val);
+			return -EIO;
+		}
+	}
+
+	/* Clear 'test_sp_800_90' bit in the TRNG_TEST register. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_TEST_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	return 0;
+}
+
+static bool mlxbf_pka_dev_trng_shutdown_oflo(struct mlxbf_pka_dev_res_t *trng_csr_ptr,
+					     u64 *err_cycle)
+{
+	u64 curr_cycle_cnt, fro_stopped_mask, fro_enabled_mask;
+	u64 csr_reg_base, csr_reg_off, csr_reg_value;
+	void __iomem *csr_reg_ptr;
+
+	csr_reg_base = trng_csr_ptr->base;
+	csr_reg_ptr = trng_csr_ptr->ioaddr;
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STATUS_ADDR);
+	csr_reg_value = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+	if (csr_reg_value & MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO) {
+		curr_cycle_cnt = get_cycles();
+		/*
+		 * See if any FROs were shut down. If they were, toggle bits in
+		 * the FRO detune register and reenable the FROs.
+		 */
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_ALARMSTOP_ADDR);
+		fro_stopped_mask = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+		if (fro_stopped_mask) {
+			csr_reg_off =
+			mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							  MLXBF_PKA_TRNG_FROENABLE_ADDR);
+			fro_enabled_mask = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+			csr_reg_off =
+			mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							  MLXBF_PKA_TRNG_FRODETUNE_ADDR);
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, fro_stopped_mask);
+
+			csr_reg_off =
+			mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							  MLXBF_PKA_TRNG_FROENABLE_ADDR);
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+					       fro_stopped_mask | fro_enabled_mask);
+		}
+
+		/* Reset the error. */
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_ALARMMASK_ADDR);
+		mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_ALARMSTOP_ADDR);
+		mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+		csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+								MLXBF_PKA_TRNG_INTACK_ADDR);
+		mlxbf_pka_dev_io_write(csr_reg_ptr,
+				       csr_reg_off,
+				       MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO);
+
+		/*
+		 * If this error occurs again within about a second, the hardware
+		 * is malfunctioning. Disable the trng and return an error.
+		 */
+		if (*err_cycle &&
+		    (curr_cycle_cnt - *err_cycle < MLXBF_PKA_TRNG_TEST_ERR_CYCLE_MAX)) {
+			csr_reg_off =
+			mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							  MLXBF_PKA_TRNG_CONTROL_ADDR);
+			csr_reg_value  = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+			csr_reg_value &= ~MLXBF_PKA_TRNG_CONTROL;
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, csr_reg_value);
+			return false;
+		}
+
+		*err_cycle = curr_cycle_cnt;
+	}
+
+	return true;
+}
+
+static int mlxbf_pka_dev_trng_drbg_reseed(struct device *dev,
+					  void __iomem *csr_reg_ptr,
+					  u64 csr_reg_base)
+{
+	u64 csr_reg_off;
+
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTROL_DRBG_RESEED);
+
+	if (!mlxbf_pka_dev_trng_wait_test_ready(dev, csr_reg_ptr, csr_reg_base))
+		return -ETIMEDOUT;
+
+	/* Write personalization string. */
+	mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr, csr_reg_base, mlxbf_pka_trng_drbg_ps_str);
+
+	return 0;
+}
+
+/* Configure the TRNG. */
+int mlxbf_pka_dev_config_trng_drbg(struct device *dev,
+				   struct mlxbf_pka_dev_res_t *aic_csr_ptr,
+				   struct mlxbf_pka_dev_res_t *trng_csr_ptr)
+{
+	u64 csr_reg_base, csr_reg_off;
+	void __iomem *csr_reg_ptr;
+	int ret;
+
+	if (trng_csr_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
+	    trng_csr_ptr->type != MLXBF_PKA_DEV_RES_TYPE_REG)
+		return -EPERM;
+
+	dev_dbg(dev, "starting up the TRNG\n");
+
+	ret = mlxbf_pka_dev_config_trng_clk(dev, aic_csr_ptr);
+	if (ret)
+		return ret;
+
+	csr_reg_base = trng_csr_ptr->base;
+	csr_reg_ptr = trng_csr_ptr->ioaddr;
+
+	/*
+	 * Perform NIST known-answer tests on the complete SP 800-90A DRBG
+	 * without BC_DF functionality.
+	 */
+	ret = mlxbf_pka_dev_test_trng_drbg(dev, csr_reg_ptr, csr_reg_base);
+	if (ret)
+		return ret;
+
+	/* Starting up the TRNG with a DRBG. */
+
+	/* Make sure the engine is idle. */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	/* Disable all FROs initially. */
+	csr_reg_off =
+	mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FROENABLE_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+	csr_reg_off =
+	mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FRODETUNE_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	/*
+	 * Write all configuration values in the TRNG_CONFIG and TRNG_ALARMCNT,
+	 * write zeroes to the TRNG_ALARMMASK and TRNG_ALARMSTOP registers.
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONFIG_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONFIG);
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMCNT_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_ALARMCNT);
+
+	csr_reg_off =
+	mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMMASK_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+	csr_reg_off =
+	mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_ALARMSTOP_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, 0);
+
+	/*
+	 * Enable all FROs in the TRNG_FROENABLE register. Note that this can
+	 * only be done after clearing the TRNG_ALARMSTOP register.
+	 */
+	csr_reg_off =
+	mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_FROENABLE_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_FROENABLE);
+
+	/*
+	 * Optionally, write 'Personalization string' of up to 384 bits in
+	 * TRNG_PS_AI_xxx registers.
+	 * The contents of these registers will be XOR-ed into the output of the
+	 * SHA-256 'Conditioning Function' to be used as seed value for the
+	 * actual DRBG.
+	 */
+	mlxbf_pka_dev_trng_write_ps_ai_str(csr_reg_ptr, csr_reg_base, mlxbf_pka_trng_drbg_ps_str);
+
+	/*
+	 * Run TRNG tests after configuring TRNG.
+	 * NOTE: TRNG need not be enabled to carry out these tests.
+	 */
+	ret = mlxbf_pka_dev_test_trng(dev, csr_reg_ptr, csr_reg_base);
+	if (ret)
+		return ret;
+
+	/*
+	 * Start the actual engine by setting the 'enable_trng' and 'drbg_en'
+	 * bit in the TRNG_CONTROL register (also a nice point to set the
+	 * interrupt mask bits).
+	 */
+	csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_CONTROL_ADDR);
+	mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off, MLXBF_PKA_TRNG_CONTROL_DRBG);
+
+	/*
+	 * The engine is now ready to handle the first 'Generate' request using
+	 * the 'request_data' bit of the TRNG_CONTROL register. The first output
+	 * for these requests will take a while, as Noise Source and
+	 * Conditioning Function must first generate seed entropy for the DRBG.
+	 *
+	 * Optionally, when buffer RAM is configured: Set a data available
+	 * interrupt threshold using the 'load_thresh' and 'blocks_thresh'
+	 * fields of the TRNG_INTACK register. This allows delaying the data
+	 * available interrupt until the indicated number of 128-bit words a
+	 * available in the buffer RAM.
+	 *
+	 * Start the actual 'Generate' operation using the 'request_data' and
+	 * 'data_blocks' fields of the TRNG_CONTROL register.
+	 */
+	mlxbf_pka_dev_trng_drbg_generate(csr_reg_ptr, csr_reg_base);
+
+	/* Delay 200 ms. */
+	mdelay(200);
+
+	return 0;
+}
+
+/* Read from DRBG enabled TRNG. */
+int mlxbf_pka_dev_trng_read(struct device *dev,
+			    struct mlxbf_pka_dev_shim_s *shim,
+			    u32 *data, u32 cnt)
+{
+	u64 csr_reg_base, csr_reg_off, csr_reg_value, timer;
+	struct mlxbf_pka_dev_res_t *trng_csr_ptr;
+	u8 output_idx, trng_ready = 0;
+	u32 data_idx, word_cnt;
+	void __iomem *csr_reg_ptr;
+	int ret = 0;
+
+	if (!shim || !data || (cnt % MLXBF_PKA_TRNG_OUTPUT_CNT != 0))
+		return -EINVAL;
+
+	if (!cnt)
+		return ret;
+
+	guard(mutex)(&shim->mutex);
+
+	trng_csr_ptr = &shim->resources.trng_csr;
+
+	if (trng_csr_ptr->status != MLXBF_PKA_DEV_RES_STATUS_MAPPED ||
+	    trng_csr_ptr->type != MLXBF_PKA_DEV_RES_TYPE_REG)
+		return -EPERM;
+
+	csr_reg_base = trng_csr_ptr->base;
+	csr_reg_ptr = trng_csr_ptr->ioaddr;
+
+	if (!mlxbf_pka_dev_trng_shutdown_oflo(trng_csr_ptr, &shim->trng_err_cycle))
+		return -EWOULDBLOCK;
+
+	word_cnt = cnt >> ilog2(sizeof(u32));
+
+	for (data_idx = 0; data_idx < word_cnt; data_idx++) {
+		output_idx = data_idx % MLXBF_PKA_TRNG_OUTPUT_CNT;
+
+		/* Tell the hardware to advance. */
+		if (!output_idx) {
+			csr_reg_off = mlxbf_pka_dev_get_register_offset(csr_reg_base,
+									MLXBF_PKA_TRNG_INTACK_ADDR);
+			mlxbf_pka_dev_io_write(csr_reg_ptr, csr_reg_off,
+					       MLXBF_PKA_TRNG_STATUS_READY);
+			trng_ready = 0;
+
+			/*
+			 * Check if 'data_blocks' field is zero in TRNG_CONTROL
+			 * register. If it is zero, need to issue a 'Reseed and
+			 * Generate' request for DRBG enabled TRNG.
+			 */
+			csr_reg_off =
+			mlxbf_pka_dev_get_register_offset(csr_reg_base,
+							  MLXBF_PKA_TRNG_CONTROL_ADDR);
+			csr_reg_value = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+
+			if (!((u32)csr_reg_value & MLXBF_PKA_TRNG_DRBG_DATA_BLOCK_MASK)) {
+				/* Issue reseed. */
+				ret = mlxbf_pka_dev_trng_drbg_reseed(dev,
+								     csr_reg_ptr,
+								     csr_reg_base);
+				if (ret)
+					return -EBUSY;
+
+				/* Issue generate request. */
+				mlxbf_pka_dev_trng_drbg_generate(csr_reg_ptr, csr_reg_base);
+			}
+		}
+
+		/*
+		 * Wait until a data word is available in the TRNG_OUTPUT_X
+		 * registers, using the interrupt and/or 'ready' status bit
+		 * in the TRNG_STATUS register. The only way this would hang
+		 * is if the TRNG is never initialized. This function cannot
+		 * be called if that happened.
+		 */
+		timer = mlxbf_pka_dev_timer_start_msec(1000);
+		csr_reg_off =
+		mlxbf_pka_dev_get_register_offset(csr_reg_base, MLXBF_PKA_TRNG_STATUS_ADDR);
+		while (!trng_ready) {
+			csr_reg_value = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+			trng_ready = csr_reg_value & MLXBF_PKA_TRNG_STATUS_READY;
+
+			if (mlxbf_pka_dev_timer_done(timer)) {
+				dev_dbg(dev, "shim %u got error obtaining random number\n",
+					shim->shim_id);
+				return -EBUSY;
+			}
+		}
+
+		/* Read the registers. */
+		csr_reg_off =
+		mlxbf_pka_dev_get_register_offset(csr_reg_base,
+						  MLXBF_PKA_TRNG_OUTPUT_0_ADDR +
+						  (output_idx * MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET));
+		csr_reg_value = mlxbf_pka_dev_io_read(csr_reg_ptr, csr_reg_off);
+		data[data_idx] = (u32)csr_reg_value;
+	}
+
+	return ret;
+}
+
+bool mlxbf_pka_dev_has_trng(struct mlxbf_pka_dev_shim_s *shim)
+{
+	if (!shim)
+		return false;
+
+	return shim->trng_enabled == MLXBF_PKA_SHIM_TRNG_ENABLED;
+}
diff --git a/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h
new file mode 100644
index 000000000000..97ed6045781e
--- /dev/null
+++ b/drivers/platform/mellanox/mlxbf_pka/mlxbf_pka_trng.h
@@ -0,0 +1,152 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
+/* SPDX-FileCopyrightText: Copyright (c) 2025 NVIDIA CORPORATION. All rights reserved. */
+
+#ifndef __MLXBF_PKA_TRNG_H__
+#define __MLXBF_PKA_TRNG_H__
+
+/*
+ * The True Random Number Generator CSR addresses/offsets. These are accessed
+ * from the ARM as 8 byte reads/writes. However only the bottom 32 bits are
+ * implemented.
+ */
+#define MLXBF_PKA_TRNG_OUTPUT_0_ADDR	0x12000
+#define MLXBF_PKA_TRNG_STATUS_ADDR	0x12020
+#define MLXBF_PKA_TRNG_INTACK_ADDR	MLXBF_PKA_TRNG_STATUS_ADDR
+#define MLXBF_PKA_TRNG_CONTROL_ADDR	0x12028
+#define MLXBF_PKA_TRNG_CONFIG_ADDR	0x12030
+#define MLXBF_PKA_TRNG_ALARMCNT_ADDR	0x12038
+#define MLXBF_PKA_TRNG_FROENABLE_ADDR	0x12040
+#define MLXBF_PKA_TRNG_FRODETUNE_ADDR	0x12048
+#define MLXBF_PKA_TRNG_ALARMMASK_ADDR	0x12050
+#define MLXBF_PKA_TRNG_ALARMSTOP_ADDR	0x12058
+#define MLXBF_PKA_TRNG_TEST_ADDR	0x120E0
+#define MLXBF_PKA_TRNG_RAW_L_ADDR	0x12060
+#define MLXBF_PKA_TRNG_RAW_H_ADDR	0x12068
+#define MLXBF_PKA_TRNG_MONOBITCNT_ADDR	0x120B8
+#define MLXBF_PKA_TRNG_POKER_3_0_ADDR	0x120C0
+#define MLXBF_PKA_TRNG_PS_AI_0_ADDR	0x12080
+
+/*
+ * 'trng_clk_on' mask for PKA Clock Switch Forcing Register. Turn on the TRNG
+ * clock. When the TRNG is controlled via the host slave interface, this engine
+ * needs to be turned on by setting bit 11.
+ */
+#define MLXBF_PKA_CLK_FORCE_TRNG_ON BIT(11)
+
+/* Number of TRNG output registers. */
+#define MLXBF_PKA_TRNG_OUTPUT_CNT 4
+
+/* Number of TRNG poker test counts. */
+#define MLXBF_PKA_TRNG_POKER_TEST_CNT 4
+
+/* TRNG configuration. */
+#define MLXBF_PKA_TRNG_CONFIG  0x00020008
+/* TRNG Alarm Counter Register value. */
+#define MLXBF_PKA_TRNG_ALARMCNT 0x000200ff
+/* TRNG FRO Enable Register value. */
+#define MLXBF_PKA_TRNG_FROENABLE 0x00ffffff
+/*
+ * TRNG Control Register value. Set bit 10 to start the EIP-76 (i.e. TRNG
+ * engine), gathering entropy from the Free Running Oscillators (FROs).
+ */
+#define MLXBF_PKA_TRNG_CONTROL 0x00000400
+
+/* TRNG Control bit. */
+#define MLXBF_PKA_TRNG_CONTROL_TEST_MODE BIT(8)
+
+/*
+ * TRNG Control Register value. Set bit 10 and 12 to start the EIP-76 (i.e.
+ * TRNG engine) with DRBG enabled, gathering entropy from the FROs.
+ */
+#define MLXBF_PKA_TRNG_CONTROL_DRBG 0x00001400
+
+/*
+ * DRBG enabled TRNG 'request_data' value. REQ_DATA (in accordance with
+ * DATA_BLOCK_MASK) requests 256 blocks of 128-bit random output. 4095 blocks
+ * is the maximum number that can be requested for the TRNG (with DRBG)
+ * configuration on Bluefield platforms.
+ */
+#define MLXBF_PKA_TRNG_CONTROL_REQ_DATA 0x10010000
+
+/* Mask for 'Data Block' in TRNG Control Register. */
+#define MLXBF_PKA_TRNG_DRBG_DATA_BLOCK_MASK GENMASK(31, 20)
+
+/* Set bit 12 of TRNG Control Register to enable DRBG functionality. */
+#define MLXBF_PKA_TRNG_CONTROL_DRBG_ENABLE BIT(12)
+
+/* Set bit 7 (i.e. 'test_sp_800_90 DRBG' bit) in the TRNG Test Register. */
+#define MLXBF_PKA_TRNG_TEST_DRBG BIT(7)
+
+/* Number of Personalization String/Additional Input Registers. */
+#define MLXBF_PKA_TRNG_PS_AI_REG_COUNT 12
+
+/* Offset bytes of Personalization String/Additional Input Registers. */
+#define MLXBF_PKA_TRNG_OUTPUT_REG_OFFSET 0x8
+
+/* Maximum TRNG test error cycle, about one second. */
+#define MLXBF_PKA_TRNG_TEST_ERR_CYCLE_MAX (1000 * 1000 * 1000)
+
+/* DRBG Reseed enable. */
+#define MLXBF_PKA_TRNG_CONTROL_DRBG_RESEED BIT(15)
+
+/* TRNG Status bits. */
+#define MLXBF_PKA_TRNG_STATUS_READY		BIT(0)
+#define MLXBF_PKA_TRNG_STATUS_SHUTDOWN_OFLO	BIT(1)
+#define MLXBF_PKA_TRNG_STATUS_TEST_READY	BIT(8)
+#define MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL	BIT(7)
+#define MLXBF_PKA_TRNG_STATUS_RUN_FAIL		BIT(4)
+#define MLXBF_PKA_TRNG_STATUS_POKER_FAIL	BIT(6)
+
+#define MLXBF_PKA_TRNG_STATUS_FAIL_MODES (MLXBF_PKA_TRNG_STATUS_MONOBIT_FAIL | \
+					 MLXBF_PKA_TRNG_STATUS_RUN_FAIL | \
+					 MLXBF_PKA_TRNG_STATUS_POKER_FAIL)
+
+/* TRNG Alarm Counter bits. */
+#define MLXBF_PKA_TRNG_ALARMCNT_STALL_RUN_POKER BIT(15)
+
+/* TRNG Test bits. */
+#define MLXBF_PKA_TRNG_TEST_KNOWN_NOISE	BIT(5)
+#define MLXBF_PKA_TRNG_TEST_NOISE	BIT(13)
+
+/* TRNG Test constants*/
+#define MLXBF_PKA_TRNG_MONOBITCNT_SUM	9978
+
+#define MLXBF_PKA_TRNG_TEST_HALF_ADD	1
+#define MLXBF_PKA_TRNG_TEST_HALF_NO	0
+
+#define MLXBF_PKA_TRNG_TEST_DATAL_BASIC_1	0x11111333
+#define MLXBF_PKA_TRNG_TEST_DATAH_BASIC_1	0x3555779f
+#define MLXBF_PKA_TRNG_TEST_COUNT_BASIC_1	11
+
+#define MLXBF_PKA_TRNG_TEST_DATAL_BASIC_2	0x01234567
+#define MLXBF_PKA_TRNG_TEST_DATAH_BASIC_2	0x89abcdef
+#define MLXBF_PKA_TRNG_TEST_COUNT_BASIC_2	302
+
+#define MLXBF_PKA_TRNG_TEST_DATAL_POKER		0xffffffff
+#define MLXBF_PKA_TRNG_TEST_DATAH_POKER		0xffffffff
+#define MLXBF_PKA_TRNG_TEST_COUNT_POKER		11
+
+#define MLXBF_PKA_TRNG_NUM_OF_FOUR_WORD		128
+
+/* Defines for mlxbf_pka_dev_shim->trng_enabled. */
+#define MLXBF_PKA_SHIM_TRNG_ENABLED	1
+#define MLXBF_PKA_SHIM_TRNG_DISABLED	0
+
+/* Configure the TRNG. */
+int mlxbf_pka_dev_config_trng_drbg(struct device *dev,
+				   struct mlxbf_pka_dev_res_t *aic_csr_ptr,
+				   struct mlxbf_pka_dev_res_t *trng_csr_ptr);
+
+/*
+ * Read data from the TRNG. Drivers can fill up to 'cnt' bytes of data into the
+ * buffer 'data'. The buffer 'data' is aligned for any type and 'cnt' is a
+ * multiple of 4.
+ */
+int mlxbf_pka_dev_trng_read(struct device *dev,
+			    struct mlxbf_pka_dev_shim_s *shim,
+			    u32 *data, u32 cnt);
+
+/* Return true if the TRNG engine is enabled, false if not. */
+bool mlxbf_pka_dev_has_trng(struct mlxbf_pka_dev_shim_s *shim);
+
+#endif /* __MLXBF_PKA_TRNG_H__ */
diff --git a/include/uapi/linux/mlxbf-pka.h b/include/uapi/linux/mlxbf-pka.h
index 9da6c1e5044b..2f2b11c2dacd 100644
--- a/include/uapi/linux/mlxbf-pka.h
+++ b/include/uapi/linux/mlxbf-pka.h
@@ -90,4 +90,23 @@ struct mlxbf_pka_dev_hw_ring_info {
  */
 #define MLXBF_PKA_CLEAR_RING_COUNTERS _IO(MLXBF_PKA_IOC_TYPE, 0x2)
 
+/**
+ * struct mlxbf_pka_dev_trng_info - TRNG information
+ * @count: Number of random bytes in the buffer or length of the buffer
+ * @data: Data buffer to hold the random bytes
+ *
+ * MLXBF_PKA_GET_RANDOM_BYTES:
+ * _IOWR(MLXBF_PKA_IOC_TYPE, 0x3, mlxbf_pka_dev_trng_info).
+ *
+ * Get random bytes from True Random Number Generator(TRNG).
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct mlxbf_pka_dev_trng_info {
+	__u32 count;
+	__u8 *data;
+};
+
+#define MLXBF_PKA_GET_RANDOM_BYTES _IOWR(MLXBF_PKA_IOC_TYPE, 0x3, struct mlxbf_pka_dev_trng_info)
+
 #endif /* _UAPI_LINUX_MLXBF_PKA_H */
-- 
2.34.1

