Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2106C337BB3;
	Fri, 21 Nov 2025 08:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712574; cv=fail; b=D+neDtN4QJmAJ0bp2Wt4r1mUDILEzMSf4RtsqxSAd59iEeNumquolGiURSRVq0bqFjTf/VaPix1R9FxJhOXBh2MZkR7FAUVkV+niPUMP4VW23Wkjnllj37ySi1EqoaXXU8CUU/IWEqoAE9eT3VH45Mzo5WwFMHp5MYdcYK5iVs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712574; c=relaxed/simple;
	bh=t7EerIki8oUxL0p2X1to4CYJuyHcHmITx8X2fxeaG8A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fm/JszW03m5+ui+7XUP3+b0Ad9OOH/RoZ4UvsrgWMw1L0V6PZpnb5pqXDyat3fb8xUgmXFRIYtPFS4hmjXkiTiQkZxmAr+M7roH8IvqAb8GAcFNxa5QSABqz0jJk/oUlwtBZg6HZ4RJvxhw793zb5WiOIfqTKu52lUv1e9nlYT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Za/X0S5n; arc=fail smtp.client-ip=52.101.85.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Za/X0S5n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IhzmsyhVCmIAEUtZQNWHZHcPrCrDjQuOK8NV3sNbgzasdiW2SFImw7QXGS1p9zGs5/jEkKlTJiiOAlaKiuSpIH/mEB3GvCByhK0EqLwX4p1IyywwivEEuBesB/MeazaAyQGRAgtyU62s4s6suSrqX/jBcmtKm4fA5XCmuYKQhEXekJIsHhl7JbCOgkF6vnbGCFXTFB1rhyArJO2h6mYO+c8WmP4qUB9etVnRQDjgUjm2zHsKaiDcOZDuITXfgdVmvHQACoNYKnoKAu1pFcWvDj7tscE0B9RaAU//YtvJW+SrgLXM0Msqmq+HMP9gJs44UpGehcq4DuPkoHvwbSdXIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TULNlnKH7AdMBIk0qIimVhr3tVxIJeijKihq4sz0x+8=;
 b=DRUXQFCehDraSCmJwJDXNTiIFxcJdLzA80zbmpV5XjlOsvhqMpXJdLe/oG7+sBZWr3dkURjII+EN4PXLKeo3usnf7L7zCxtn9TOGnGFcGSfAKcS+U1Vm8Em6wyQn5yOMTZ2oychxYEyOzjlQXpK8x7BuC65tJ2M8nLmC2ni285+0a/vivlncaFo3vzIv0gix8QSrPfkB8wjEni0uvqmGixxNmfH+BkOCIR9kj1sMHSV1ECTxBb/2D8uG9cwvH1TVE0z+2SEsuBY+bNgUT1+NfuyOu+J8hcidHPzagWHOCJYSm1eIXSt07MgYbPR6OAAOzcoWmUDCgBL2BklKSvUZ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TULNlnKH7AdMBIk0qIimVhr3tVxIJeijKihq4sz0x+8=;
 b=Za/X0S5nX2ci50JmfxbYm11b4lHtYKZAZAz2HNbbO6TI09n60D44IDWWlL50JMS5YNnGxvVtEVnNW8os0fUxfmAC55iezsZ+ibbKcxBQcVJL/ppxZra6ICKkdy8kXwQzOaunjcmY5Eawo5FDk3Vai8AXnigQGM7/EZuf1uZfOAw=
Received: from SJ0PR05CA0205.namprd05.prod.outlook.com (2603:10b6:a03:330::30)
 by MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 08:09:20 +0000
Received: from CO1PEPF000042AD.namprd03.prod.outlook.com
 (2603:10b6:a03:330::4) by SJ0PR05CA0205.outlook.office365.com
 (2603:10b6:a03:330::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Fri,
 21 Nov 2025 08:09:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000042AD.mail.protection.outlook.com (10.167.243.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:09:19 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:09:06 -0800
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Kim Phillips
	<kim.phillips@amd.com>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Gao Shiyuan
	<gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, Amit Shah
	<amit.shah@amd.com>, Peter Gonda <pgonda@google.com>,
	<iommu@lists.linux.dev>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH kernel v2 5/5] crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)
Date: Fri, 21 Nov 2025 19:06:29 +1100
Message-ID: <20251121080629.444992-6-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121080629.444992-1-aik@amd.com>
References: <20251121080629.444992-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AD:EE_|MN2PR12MB4304:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d36094-9f95-417a-2eeb-08de28d545ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?906RXnfTbXf2yrj+maa5L8sVxcydver5RWuUl5xywSQ2mth5uPR18lfCQXNc?=
 =?us-ascii?Q?XWvxAr+3xCXK7R5kFPRdEkytmoCCh9vqlQM8DC6wqyWCal3+nWhveF+qDGiP?=
 =?us-ascii?Q?NdqrcmCzt2Eqb8gt0CT1ZP3FTpYp7z4ieMXEfBtMKXtZpphi7IVDDI7sEzZJ?=
 =?us-ascii?Q?XP6sg8lSfMm0TwY2+HST3M20J1B8pRgVD4EVD3eUEDDn+EWPSXpZvU5Virzl?=
 =?us-ascii?Q?CkE5KYm0d/OiCWOX/rHfq27kcVU7rERX56uSC7R//RJP2LzhMZOBmItFz9pN?=
 =?us-ascii?Q?3Y1m9ml6eQsMd2fNeiG+Q0Duc9IK+ZInNN0x6QkifRMdnUBJthe5JavualEM?=
 =?us-ascii?Q?Y8ZL7qa4e722Uo25Cpwcc7rYuzUrBFAHKXw92sPC1h48KXBHQ3zTwxUdLj5o?=
 =?us-ascii?Q?A137esvGJxKSAbq7aIG7GKHORluckGkByH/yXoYbpMqPj6GOBzSZFIw1XjlK?=
 =?us-ascii?Q?o73DeQDNoeMk6VZz11JLT+wdg6xQta6k3P518wFcsJSo7gqUL29VPFK5WaaP?=
 =?us-ascii?Q?fP9v91LDs1ur3aQUaURYLZ38hWQszhitGP9v7F6mexznpE9sdgbVxe2cvOqz?=
 =?us-ascii?Q?DE43D9p3moge30H5gPrk7fIjrAlzK9IP2r1hbXbzeBms7BBchxEEQSflCPOZ?=
 =?us-ascii?Q?kTIYrG6VaiGCGtRh8MLRfVSqMP/HNjzTGNBIjZFBXNCi5VPgds/9u/eSkYQj?=
 =?us-ascii?Q?RR1vS1cN5yt1FARfEklcSSBgfVTYzTviJdgQrc2pxp2H+N9AejwoH3iWCiAt?=
 =?us-ascii?Q?fBD15Xb/Sx/ZnaOnqI2g5WqlJI66Tf9S0IheHj1K++E2rNrHDBB1u6I9Hjy7?=
 =?us-ascii?Q?iIBjpZfR8oYx3cUFVLoLwLz+qtmMhY5w4Ews1zCB1IKmklBtK2hCxAUKrvkO?=
 =?us-ascii?Q?sjlaWqR6korAfruaf/uyKEIQdH64itCznRLy7yrrso5EwyRZlVlomlnoWZZs?=
 =?us-ascii?Q?ALGzfT5R4cilZn8YO/dxQ6s/QvcerJTg1uXXf0kOOyPWV/8NU4Bzo4L+TEo3?=
 =?us-ascii?Q?1XQbASC9KdckXzvCTgXrkvIs7C9NTKAT7JVeCFfzniaayuvi5fsqoMfCln27?=
 =?us-ascii?Q?Kcasg5FFuCtrpn76jl9ZKe8sSSLkDXFB+WteVWNJqMSfIoDTvqdpWdFzMif/?=
 =?us-ascii?Q?4EO0/tZCWyWmDam/Cs4cw7s+AVJdCzVcu6kpAiHndzKH0I8DuqHnddsW0TGm?=
 =?us-ascii?Q?NX58gl7ErgwGzix7rU/qaNeDkRbyB+3lswQsAS3xaYbwtiSQwJSyPmH4d1Sy?=
 =?us-ascii?Q?Vh5DFKx81yITmw15xBWcYI7Mv/E166x9hbAXpBasPdKCVJrTiMFCUK9vYu88?=
 =?us-ascii?Q?+IiVEXOoMbgulW6ZhDWv51ZAEAU1DPdQMsUHUVeaVRUoJ6KcwnKhjE5HGvWj?=
 =?us-ascii?Q?gTke+ycnZ7iNN49kGNUDP5v1Kyg+8+UMAwnNBsvqSx8TcJVGAuuEx2b4/GuP?=
 =?us-ascii?Q?O8YtsenRfedi5fmOlerifqL4BZJqzv3zOrAei3zy1sVD5iTsW0KOenEht+Km?=
 =?us-ascii?Q?Ua1g/BAqT0vwZx9+HFLsEXcnBR0ov42A/NjkyugwRa8pWabp0vKVl0HMYuWL?=
 =?us-ascii?Q?jzCprCBpyCc2m2+1N1A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:09:19.6100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d36094-9f95-417a-2eeb-08de28d545ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304

Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
(Trust Domain In-Socket Protocol). This enables secure communication
between trusted domains and PCIe devices through the PSP (Platform
Security Processor).

The implementation includes:
- Device Security Manager (DSM) operations for establishing secure links
- SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
- IDE (Integrity Data Encryption) stream management for secure PCIe

This module bridges the SEV firmware stack with the generic PCIe TSM
framework.

This is phase1 as described in Documentation/driver-api/pci/tsm.rst.

On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
The CCP driver provides the interface to it and registers in the TSM
subsystem.

Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
the data in the SEV-TIO-specific structs.

Implement TSM hooks and IDE setup in sev-dev-tsm.c.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v2:
* address bunch of comments from v1 (almost all)
---
 drivers/crypto/ccp/Kconfig       |   1 +
 drivers/crypto/ccp/Makefile      |   8 +
 drivers/crypto/ccp/sev-dev-tio.h | 142 ++++
 drivers/crypto/ccp/sev-dev.h     |   7 +
 include/linux/psp-sev.h          |   7 +
 drivers/crypto/ccp/sev-dev-tio.c | 863 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
 drivers/crypto/ccp/sev-dev.c     |  48 +-
 8 files changed, 1480 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f394e45e11ab..3e737d3e21c8 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -25,6 +25,7 @@ config CRYPTO_DEV_CCP_CRYPTO
 	default m
 	depends on CRYPTO_DEV_CCP_DD
 	depends on CRYPTO_DEV_SP_CCP
+	select PCI_TSM
 	select CRYPTO_HASH
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AUTHENC
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index a9626b30044a..839df68b70ff 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -16,6 +16,14 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    hsti.o \
                                    sfs.o
 
+ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),yy)
+ccp-y += sev-dev-tsm.o sev-dev-tio.o
+endif
+
+ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),my)
+ccp-m += sev-dev-tsm.o sev-dev-tio.o
+endif
+
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes.o \
diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
new file mode 100644
index 000000000000..7c42351210ef
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.h
@@ -0,0 +1,142 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __PSP_SEV_TIO_H__
+#define __PSP_SEV_TIO_H__
+
+#include <linux/pci-tsm.h>
+#include <linux/tsm.h>
+#include <linux/pci-ide.h>
+#include <uapi/linux/psp-sev.h>
+
+#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
+
+struct sla_addr_t {
+	union {
+		u64 sla;
+		struct {
+			u64 page_type:1;
+			u64 page_size:1;
+			u64 reserved1:10;
+			u64 pfn:40;
+			u64 reserved2:12;
+		};
+	};
+} __packed;
+
+#define SEV_TIO_MAX_COMMAND_LENGTH	128
+
+/* SPDM control structure for DOE */
+struct tsm_spdm {
+	unsigned long req_len;
+	void *req;
+	unsigned long rsp_len;
+	void *rsp;
+};
+
+/* Describes TIO device */
+struct tsm_dsm_tio {
+	u8 cert_slot;
+	struct sla_addr_t dev_ctx;
+	struct sla_addr_t req;
+	struct sla_addr_t resp;
+	struct sla_addr_t scratch;
+	struct sla_addr_t output;
+	size_t output_len;
+	size_t scratch_len;
+	struct tsm_spdm spdm;
+	struct sla_buffer_hdr *reqbuf; /* vmap'ed @req for DOE */
+	struct sla_buffer_hdr *respbuf; /* vmap'ed @resp for DOE */
+
+	int cmd;
+	int psp_ret;
+	u8 cmd_data[SEV_TIO_MAX_COMMAND_LENGTH];
+	void *data_pg; /* Data page for DEV_STATUS/TDI_STATUS/TDI_INFO/ASID_FENCE */
+
+#define TIO_IDE_MAX_TC	8
+	struct pci_ide *ide[TIO_IDE_MAX_TC];
+};
+
+/* Describes TSM structure for PF0 pointed by pci_dev->tsm */
+struct tio_dsm {
+	struct pci_tsm_pf0 tsm;
+	struct tsm_dsm_tio data;
+	struct sev_device *sev;
+};
+
+/* Data object IDs */
+#define SPDM_DOBJ_ID_NONE		0
+#define SPDM_DOBJ_ID_REQ		1
+#define SPDM_DOBJ_ID_RESP		2
+
+struct spdm_dobj_hdr {
+	u32 id;     /* Data object type identifier */
+	u32 length; /* Length of the data object, INCLUDING THIS HEADER */
+	union {
+		u16 ver; /* Version of the data object structure */
+		struct {
+			u8 minor;
+			u8 major;
+		} version;
+	};
+} __packed;
+
+/**
+ * struct sev_tio_status - TIO_STATUS command's info_paddr buffer
+ *
+ * @length: Length of this structure in bytes
+ * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
+ * @tio_init_done: Indicates TIO_INIT has been invoked
+ * @spdm_req_size_min: Minimum SPDM request buffer size in bytes
+ * @spdm_req_size_max: Maximum SPDM request buffer size in bytes
+ * @spdm_scratch_size_min: Minimum SPDM scratch buffer size in bytes
+ * @spdm_scratch_size_max: Maximum SPDM scratch buffer size in bytes
+ * @spdm_out_size_min: Minimum SPDM output buffer size in bytes
+ * @spdm_out_size_max: Maximum for the SPDM output buffer size in bytes
+ * @spdm_rsp_size_min: Minimum SPDM response buffer size in bytes
+ * @spdm_rsp_size_max: Maximum SPDM response buffer size in bytes
+ * @devctx_size: Size of a device context buffer in bytes
+ * @tdictx_size: Size of a TDI context buffer in bytes
+ * @tio_crypto_alg: TIO crypto algorithms supported
+ */
+struct sev_tio_status {
+	u32 length;
+	union {
+		u32 flags;
+		struct {
+			u32 tio_en:1;
+			u32 tio_init_done:1;
+		};
+	};
+	u32 spdm_req_size_min;
+	u32 spdm_req_size_max;
+	u32 spdm_scratch_size_min;
+	u32 spdm_scratch_size_max;
+	u32 spdm_out_size_min;
+	u32 spdm_out_size_max;
+	u32 spdm_rsp_size_min;
+	u32 spdm_rsp_size_max;
+	u32 devctx_size;
+	u32 tdictx_size;
+	u32 tio_crypto_alg;
+	u8 reserved[12];
+} __packed;
+
+int sev_tio_init_locked(void *tio_status_page);
+int sev_tio_continue(struct tsm_dsm_tio *dev_data);
+
+int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id, u16 root_port_id,
+		       u8 segment_id);
+int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot);
+int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
+int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
+
+#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
+
+#if defined(CONFIG_PCI_TSM)
+void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
+void sev_tsm_uninit(struct sev_device *sev);
+int sev_tio_cmd_buffer_len(int cmd);
+#else
+static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
+#endif
+
+#endif	/* __PSP_SEV_TIO_H__ */
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index b9029506383f..dced4a8e9f01 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -34,6 +34,8 @@ struct sev_misc_dev {
 	struct miscdevice misc;
 };
 
+struct sev_tio_status;
+
 struct sev_device {
 	struct device *dev;
 	struct psp_device *psp;
@@ -61,6 +63,11 @@ struct sev_device {
 
 	struct sev_user_data_snp_status snp_plat_status;
 	struct snp_feature_info snp_feat_info_0;
+
+#if defined(CONFIG_PCI_TSM)
+	struct tsm_dev *tsmdev;
+	struct sev_tio_status *tio_status;
+#endif
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index c0c817ca3615..cce864dbf281 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -109,6 +109,13 @@ enum sev_cmd {
 	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
 	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
 
+	/* SEV-TIO commands */
+	SEV_CMD_TIO_STATUS		= 0x0D0,
+	SEV_CMD_TIO_INIT		= 0x0D1,
+	SEV_CMD_TIO_DEV_CREATE		= 0x0D2,
+	SEV_CMD_TIO_DEV_RECLAIM		= 0x0D3,
+	SEV_CMD_TIO_DEV_CONNECT		= 0x0D4,
+	SEV_CMD_TIO_DEV_DISCONNECT	= 0x0D5,
 	SEV_CMD_MAX,
 };
 
diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
new file mode 100644
index 000000000000..f7b2a515aae7
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.c
@@ -0,0 +1,863 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+// Interface to PSP for CCP/SEV-TIO/SNP-VM
+
+#include <linux/pci.h>
+#include <linux/tsm.h>
+#include <linux/psp.h>
+#include <linux/vmalloc.h>
+#include <linux/bitfield.h>
+#include <linux/pci-doe.h>
+#include <asm/sev-common.h>
+#include <asm/sev.h>
+#include <asm/page.h>
+#include "sev-dev.h"
+#include "sev-dev-tio.h"
+
+#define to_tio_status(dev_data)	\
+		(container_of((dev_data), struct tio_dsm, data)->sev->tio_status)
+
+#define SLA_PAGE_TYPE_DATA	0
+#define SLA_PAGE_TYPE_SCATTER	1
+#define SLA_PAGE_SIZE_4K	0
+#define SLA_PAGE_SIZE_2M	1
+#define SLA_SZ(s)		((s).page_size == SLA_PAGE_SIZE_2M ? SZ_2M : SZ_4K)
+#define SLA_SCATTER_LEN(s)	(SLA_SZ(s) / sizeof(struct sla_addr_t))
+#define SLA_EOL			((struct sla_addr_t) { .pfn = ((1UL << 40) - 1) })
+#define SLA_NULL		((struct sla_addr_t) { 0 })
+#define IS_SLA_NULL(s)		((s).sla == SLA_NULL.sla)
+#define IS_SLA_EOL(s)		((s).sla == SLA_EOL.sla)
+
+static phys_addr_t sla_to_pa(struct sla_addr_t sla)
+{
+	u64 pfn = sla.pfn;
+	u64 pa = pfn << PAGE_SHIFT;
+
+	return pa;
+}
+
+static void *sla_to_va(struct sla_addr_t sla)
+{
+	void *va = __va(__sme_clr(sla_to_pa(sla)));
+
+	return va;
+}
+
+#define sla_to_pfn(sla)		(__pa(sla_to_va(sla)) >> PAGE_SHIFT)
+#define sla_to_page(sla)	virt_to_page(sla_to_va(sla))
+
+static struct sla_addr_t make_sla(struct page *pg, bool stp)
+{
+	u64 pa = __sme_set(page_to_phys(pg));
+	struct sla_addr_t ret = {
+		.pfn = pa >> PAGE_SHIFT,
+		.page_size = SLA_PAGE_SIZE_4K, /* Do not do SLA_PAGE_SIZE_2M ATM */
+		.page_type = stp ? SLA_PAGE_TYPE_SCATTER : SLA_PAGE_TYPE_DATA
+	};
+
+	return ret;
+}
+
+/* the BUFFER Structure */
+#define SLA_BUFFER_FLAG_ENCRYPTION	BIT(0)
+
+/**
+ * struct sla_buffer_hdr - Scatter list address buffer header
+ *
+ * @capacity_sz: Total capacity of the buffer in bytes
+ * @payload_sz: Size of buffer payload in bytes, must be multiple of 32B
+ * @flags: Buffer flags (SLA_BUFFER_FLAG_ENCRYPTION: buffer is encrypted)
+ * @iv: Initialization vector used for encryption
+ * @authtag: Authentication tag for encrypted buffer
+ */
+struct sla_buffer_hdr {
+	u32 capacity_sz;
+	u32 payload_sz; /* The size of BUFFER_PAYLOAD in bytes. Must be multiple of 32B */
+	u32 flags;
+	u8 reserved1[4];
+	u8 iv[16];	/* IV used for the encryption of this buffer */
+	u8 authtag[16]; /* Authentication tag for this buffer */
+	u8 reserved2[16];
+} __packed;
+
+enum spdm_data_type_t {
+	DOBJ_DATA_TYPE_SPDM = 0x1,
+	DOBJ_DATA_TYPE_SECURE_SPDM = 0x2,
+};
+
+struct spdm_dobj_hdr_req {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_REQ */
+	u8 data_type; /* spdm_data_type_t */
+	u8 reserved2[5];
+} __packed;
+
+struct spdm_dobj_hdr_resp {
+	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_RESP */
+	u8 data_type; /* spdm_data_type_t */
+	u8 reserved2[5];
+} __packed;
+
+/* Defined in sev-dev-tio.h so sev-dev-tsm.c can read types of blobs */
+struct spdm_dobj_hdr_cert;
+struct spdm_dobj_hdr_meas;
+struct spdm_dobj_hdr_report;
+
+/* Used in all SPDM-aware TIO commands */
+struct spdm_ctrl {
+	struct sla_addr_t req;
+	struct sla_addr_t resp;
+	struct sla_addr_t scratch;
+	struct sla_addr_t output;
+} __packed;
+
+static size_t sla_dobj_id_to_size(u8 id)
+{
+	size_t n;
+
+	BUILD_BUG_ON(sizeof(struct spdm_dobj_hdr_resp) != 0x10);
+	switch (id) {
+	case SPDM_DOBJ_ID_REQ:
+		n = sizeof(struct spdm_dobj_hdr_req);
+		break;
+	case SPDM_DOBJ_ID_RESP:
+		n = sizeof(struct spdm_dobj_hdr_resp);
+		break;
+	default:
+		WARN_ON(1);
+		n = 0;
+		break;
+	}
+
+	return n;
+}
+
+#define SPDM_DOBJ_HDR_SIZE(hdr)		sla_dobj_id_to_size((hdr)->id)
+#define SPDM_DOBJ_DATA(hdr)		((u8 *)(hdr) + SPDM_DOBJ_HDR_SIZE(hdr))
+#define SPDM_DOBJ_LEN(hdr)		((hdr)->length - SPDM_DOBJ_HDR_SIZE(hdr))
+
+#define sla_to_dobj_resp_hdr(buf)	((struct spdm_dobj_hdr_resp *) \
+					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_RESP))
+#define sla_to_dobj_req_hdr(buf)	((struct spdm_dobj_hdr_req *) \
+					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_REQ))
+
+static struct spdm_dobj_hdr *sla_to_dobj_hdr(struct sla_buffer_hdr *buf)
+{
+	if (!buf)
+		return NULL;
+
+	return (struct spdm_dobj_hdr *) &buf[1];
+}
+
+static struct spdm_dobj_hdr *sla_to_dobj_hdr_check(struct sla_buffer_hdr *buf, u32 check_dobjid)
+{
+	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
+
+	if (WARN_ON_ONCE(!hdr))
+		return NULL;
+
+	if (hdr->id != check_dobjid) {
+		pr_err("! ERROR: expected %d, found %d\n", check_dobjid, hdr->id);
+		return NULL;
+	}
+
+	return hdr;
+}
+
+static void *sla_to_data(struct sla_buffer_hdr *buf, u32 dobjid)
+{
+	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
+
+	if (WARN_ON_ONCE(dobjid != SPDM_DOBJ_ID_REQ && dobjid != SPDM_DOBJ_ID_RESP))
+		return NULL;
+
+	if (!hdr)
+		return NULL;
+
+	return (u8 *) hdr + sla_dobj_id_to_size(dobjid);
+}
+
+/**
+ * struct sev_data_tio_status - SEV_CMD_TIO_STATUS command
+ *
+ * @length: Length of this command buffer in bytes
+ * @status_paddr: System physical address of the TIO_STATUS structure
+ */
+struct sev_data_tio_status {
+	u32 length;
+	u8 reserved[4];
+	u64 status_paddr;
+} __packed;
+
+/* TIO_INIT */
+struct sev_data_tio_init {
+	u32 length;
+	u8 reserved[12];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_create - TIO_DEV_CREATE command
+ *
+ * @length: Length in bytes of this command buffer
+ * @dev_ctx_sla: Scatter list address pointing to a buffer to be used as a device context buffer
+ * @device_id: PCIe Routing Identifier of the device to connect to
+ * @root_port_id: PCIe Routing Identifier of the root port of the device
+ * @segment_id: PCIe Segment Identifier of the device to connect to
+ */
+struct sev_data_tio_dev_create {
+	u32 length;
+	u8 reserved1[4];
+	struct sla_addr_t dev_ctx_sla;
+	u16 device_id;
+	u16 root_port_id;
+	u8 segment_id;
+	u8 reserved2[11];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_connect - TIO_DEV_CONNECT command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ * @tc_mask: Bitmask of the traffic classes to initialize for SEV-TIO usage.
+ *           Setting the kth bit of the TC_MASK to 1 indicates that the traffic
+ *           class k will be initialized
+ * @cert_slot: Slot number of the certificate requested for constructing the SPDM session
+ * @ide_stream_id: IDE stream IDs to be associated with this device.
+ *                 Valid only if corresponding bit in TC_MASK is set
+ */
+struct sev_data_tio_dev_connect {
+	u32 length;
+	u8 reserved1[4];
+	struct spdm_ctrl spdm_ctrl;
+	u8 reserved2[8];
+	struct sla_addr_t dev_ctx_sla;
+	u8 tc_mask;
+	u8 cert_slot;
+	u8 reserved3[6];
+	u8 ide_stream_id[8];
+	u8 reserved4[8];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_disconnect - TIO_DEV_DISCONNECT command
+ *
+ * @length: Length in bytes of this command buffer
+ * @flags: Command flags (TIO_DEV_DISCONNECT_FLAG_FORCE: force disconnect)
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ */
+#define TIO_DEV_DISCONNECT_FLAG_FORCE	BIT(0)
+
+struct sev_data_tio_dev_disconnect {
+	u32 length;
+	u32 flags;
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_meas - TIO_DEV_MEASUREMENTS command
+ *
+ * @length: Length in bytes of this command buffer
+ * @flags: Command flags (TIO_DEV_MEAS_FLAG_RAW_BITSTREAM: request raw measurements)
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ * @meas_nonce: Nonce for measurement freshness verification
+ */
+#define TIO_DEV_MEAS_FLAG_RAW_BITSTREAM	BIT(0)
+
+struct sev_data_tio_dev_meas {
+	u32 length;
+	u32 flags;
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+	u8 meas_nonce[32];
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_certs - TIO_DEV_CERTIFICATES command
+ *
+ * @length: Length in bytes of this command buffer
+ * @spdm_ctrl: SPDM control structure defined in Section 5.1
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ */
+struct sev_data_tio_dev_certs {
+	u32 length;
+	u8 reserved[4];
+	struct spdm_ctrl spdm_ctrl;
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+/**
+ * struct sev_data_tio_dev_reclaim - TIO_DEV_RECLAIM command
+ *
+ * @length: Length in bytes of this command buffer
+ * @dev_ctx_sla: Scatter list address of the device context buffer
+ *
+ * This command reclaims resources associated with a device context.
+ */
+struct sev_data_tio_dev_reclaim {
+	u32 length;
+	u8 reserved[4];
+	struct sla_addr_t dev_ctx_sla;
+} __packed;
+
+static struct sla_buffer_hdr *sla_buffer_map(struct sla_addr_t sla)
+{
+	struct sla_buffer_hdr *buf;
+
+	BUILD_BUG_ON(sizeof(struct sla_buffer_hdr) != 0x40);
+	if (IS_SLA_NULL(sla))
+		return NULL;
+
+	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+		struct sla_addr_t *scatter = sla_to_va(sla);
+		unsigned int i, npages = 0;
+
+		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
+			if (WARN_ON_ONCE(SLA_SZ(scatter[i]) > SZ_4K))
+				return NULL;
+
+			if (WARN_ON_ONCE(scatter[i].page_type == SLA_PAGE_TYPE_SCATTER))
+				return NULL;
+
+			if (IS_SLA_EOL(scatter[i])) {
+				npages = i;
+				break;
+			}
+		}
+		if (WARN_ON_ONCE(!npages))
+			return NULL;
+
+		struct page **pp = kmalloc_array(npages, sizeof(pp[0]), GFP_KERNEL);
+		if (!pp)
+			return NULL;
+
+		for (i = 0; i < npages; ++i)
+			pp[i] = sla_to_page(scatter[i]);
+
+		buf = vm_map_ram(pp, npages, 0);
+		kfree(pp);
+	} else {
+		struct page *pg = sla_to_page(sla);
+
+		buf = vm_map_ram(&pg, 1, 0);
+	}
+
+	return buf;
+}
+
+static void sla_buffer_unmap(struct sla_addr_t sla, struct sla_buffer_hdr *buf)
+{
+	if (!buf)
+		return;
+
+	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+		struct sla_addr_t *scatter = sla_to_va(sla);
+		unsigned int i, npages = 0;
+
+		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
+			if (IS_SLA_EOL(scatter[i])) {
+				npages = i;
+				break;
+			}
+		}
+		if (!npages)
+			return;
+
+		vm_unmap_ram(buf, npages);
+	} else {
+		vm_unmap_ram(buf, 1);
+	}
+}
+
+static void dobj_response_init(struct sla_buffer_hdr *buf)
+{
+	struct spdm_dobj_hdr *dobj = sla_to_dobj_hdr(buf);
+
+	dobj->id = SPDM_DOBJ_ID_RESP;
+	dobj->version.major = 0x1;
+	dobj->version.minor = 0;
+	dobj->length = 0;
+	buf->payload_sz = sla_dobj_id_to_size(dobj->id) + dobj->length;
+}
+
+static void sla_free(struct sla_addr_t sla, size_t len, bool firmware_state)
+{
+	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	struct sla_addr_t *scatter = NULL;
+	int ret = 0, i;
+
+	if (IS_SLA_NULL(sla))
+		return;
+
+	if (firmware_state) {
+		if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
+			scatter = sla_to_va(sla);
+
+			for (i = 0; i < npages; ++i) {
+				if (IS_SLA_EOL(scatter[i]))
+					break;
+
+				ret = snp_reclaim_pages(sla_to_pa(scatter[i]), 1, false);
+				if (ret)
+					break;
+			}
+		} else {
+			ret = snp_reclaim_pages(sla_to_pa(sla), 1, false);
+		}
+	}
+
+	if (WARN_ON(ret))
+		return;
+
+	if (scatter) {
+		for (i = 0; i < npages; ++i) {
+			if (IS_SLA_EOL(scatter[i]))
+				break;
+			free_page((unsigned long)sla_to_va(scatter[i]));
+		}
+	}
+
+	free_page((unsigned long)sla_to_va(sla));
+}
+
+static struct sla_addr_t sla_alloc(size_t len, bool firmware_state)
+{
+	unsigned long i, npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	struct sla_addr_t *scatter = NULL;
+	struct sla_addr_t ret = SLA_NULL;
+	struct sla_buffer_hdr *buf;
+	struct page *pg;
+
+	if (npages == 0)
+		return ret;
+
+	if (WARN_ON_ONCE(npages > ((PAGE_SIZE / sizeof(struct sla_addr_t)) + 1)))
+		return ret;
+
+	BUILD_BUG_ON(PAGE_SIZE < SZ_4K);
+
+	if (npages > 1) {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg)
+			return SLA_NULL;
+
+		ret = make_sla(pg, true);
+		scatter = page_to_virt(pg);
+		for (i = 0; i < npages; ++i) {
+			pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (!pg)
+				goto no_reclaim_exit;
+
+			scatter[i] = make_sla(pg, false);
+		}
+		scatter[i] = SLA_EOL;
+	} else {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg)
+			return SLA_NULL;
+
+		ret = make_sla(pg, false);
+	}
+
+	buf = sla_buffer_map(ret);
+	if (!buf)
+		goto no_reclaim_exit;
+
+	buf->capacity_sz = (npages << PAGE_SHIFT);
+	sla_buffer_unmap(ret, buf);
+
+	if (firmware_state) {
+		if (scatter) {
+			for (i = 0; i < npages; ++i) {
+				if (rmp_make_private(sla_to_pfn(scatter[i]), 0,
+						     PG_LEVEL_4K, 0, true))
+					goto free_exit;
+			}
+		} else {
+			if (rmp_make_private(sla_to_pfn(ret), 0, PG_LEVEL_4K, 0, true))
+				goto no_reclaim_exit;
+		}
+	}
+
+	return ret;
+
+no_reclaim_exit:
+	firmware_state = false;
+free_exit:
+	sla_free(ret, len, firmware_state);
+	return SLA_NULL;
+}
+
+/* Expands a buffer, only firmware owned buffers allowed for now */
+static int sla_expand(struct sla_addr_t *sla, size_t *len)
+{
+	struct sla_buffer_hdr *oldbuf = sla_buffer_map(*sla), *newbuf;
+	struct sla_addr_t oldsla = *sla, newsla;
+	size_t oldlen = *len, newlen;
+
+	if (!oldbuf)
+		return -EFAULT;
+
+	newlen = oldbuf->capacity_sz;
+	if (oldbuf->capacity_sz == oldlen) {
+		/* This buffer does not require expansion, must be another buffer */
+		sla_buffer_unmap(oldsla, oldbuf);
+		return 1;
+	}
+
+	pr_notice("Expanding BUFFER from %ld to %ld bytes\n", oldlen, newlen);
+
+	newsla = sla_alloc(newlen, true);
+	if (IS_SLA_NULL(newsla))
+		return -ENOMEM;
+
+	newbuf = sla_buffer_map(newsla);
+	if (!newbuf) {
+		sla_free(newsla, newlen, true);
+		return -EFAULT;
+	}
+
+	memcpy(newbuf, oldbuf, oldlen);
+
+	sla_buffer_unmap(newsla, newbuf);
+	sla_free(oldsla, oldlen, true);
+	*sla = newsla;
+	*len = newlen;
+
+	return 0;
+}
+
+static int sev_tio_do_cmd(int cmd, void *data, size_t data_len, int *psp_ret,
+			  struct tsm_dsm_tio *dev_data)
+{
+	int rc;
+
+	*psp_ret = 0;
+	rc = sev_do_cmd(cmd, data, psp_ret);
+
+	if (WARN_ON(!rc && *psp_ret == SEV_RET_SPDM_REQUEST))
+		return -EIO;
+
+	if (rc == 0 && *psp_ret == SEV_RET_EXPAND_BUFFER_LENGTH_REQUEST) {
+		int rc1, rc2;
+
+		rc1 = sla_expand(&dev_data->output, &dev_data->output_len);
+		if (rc1 < 0)
+			return rc1;
+
+		rc2 = sla_expand(&dev_data->scratch, &dev_data->scratch_len);
+		if (rc2 < 0)
+			return rc2;
+
+		if (!rc1 && !rc2)
+			/* Neither buffer requires expansion, this is wrong */
+			return -EFAULT;
+
+		*psp_ret = 0;
+		rc = sev_do_cmd(cmd, data, psp_ret);
+	}
+
+	if ((rc == 0 || rc == -EIO) && *psp_ret == SEV_RET_SPDM_REQUEST) {
+		struct spdm_dobj_hdr_resp *resp_hdr;
+		struct spdm_dobj_hdr_req *req_hdr;
+		struct sev_tio_status *tio_status = to_tio_status(dev_data);
+		size_t resp_len = tio_status->spdm_req_size_max -
+			(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) + sizeof(struct sla_buffer_hdr));
+
+		if (!dev_data->cmd) {
+			if (WARN_ON_ONCE(!data_len || (data_len != *(u32 *) data)))
+				return -EINVAL;
+			if (WARN_ON(data_len > sizeof(dev_data->cmd_data)))
+				return -EFAULT;
+			memcpy(dev_data->cmd_data, data, data_len);
+			memset(&dev_data->cmd_data[data_len], 0xFF,
+			       sizeof(dev_data->cmd_data) - data_len);
+			dev_data->cmd = cmd;
+		}
+
+		req_hdr = sla_to_dobj_req_hdr(dev_data->reqbuf);
+		resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
+		switch (req_hdr->data_type) {
+		case DOBJ_DATA_TYPE_SPDM:
+			rc = PCI_DOE_FEATURE_CMA;
+			break;
+		case DOBJ_DATA_TYPE_SECURE_SPDM:
+			rc = PCI_DOE_FEATURE_SSESSION;
+			break;
+		default:
+			return -EINVAL;
+		}
+		resp_hdr->data_type = req_hdr->data_type;
+		dev_data->spdm.req_len = req_hdr->hdr.length -
+			sla_dobj_id_to_size(SPDM_DOBJ_ID_REQ);
+		dev_data->spdm.rsp_len = resp_len;
+	} else if (dev_data && dev_data->cmd) {
+		/* For either error or success just stop the bouncing */
+		memset(dev_data->cmd_data, 0, sizeof(dev_data->cmd_data));
+		dev_data->cmd = 0;
+	}
+
+	return rc;
+}
+
+int sev_tio_continue(struct tsm_dsm_tio *dev_data)
+{
+	struct spdm_dobj_hdr_resp *resp_hdr;
+	int ret;
+
+	if (!dev_data || !dev_data->cmd)
+		return -EINVAL;
+
+	resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
+	resp_hdr->hdr.length = ALIGN(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
+				     dev_data->spdm.rsp_len, 32);
+	dev_data->respbuf->payload_sz = resp_hdr->hdr.length;
+
+	ret = sev_tio_do_cmd(dev_data->cmd, dev_data->cmd_data, 0,
+			     &dev_data->psp_ret, dev_data);
+	if (ret)
+		return ret;
+
+	if (dev_data->psp_ret != SEV_RET_SUCCESS)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void spdm_ctrl_init(struct spdm_ctrl *ctrl, struct tsm_dsm_tio *dev_data)
+{
+	ctrl->req = dev_data->req;
+	ctrl->resp = dev_data->resp;
+	ctrl->scratch = dev_data->scratch;
+	ctrl->output = dev_data->output;
+}
+
+static void spdm_ctrl_free(struct tsm_dsm_tio *dev_data)
+{
+	struct sev_tio_status *tio_status = to_tio_status(dev_data);
+	size_t len = tio_status->spdm_req_size_max -
+		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
+		 sizeof(struct sla_buffer_hdr));
+	struct tsm_spdm *spdm = &dev_data->spdm;
+
+	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
+	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
+	spdm->rsp = NULL;
+	spdm->req = NULL;
+	sla_free(dev_data->req, len, true);
+	sla_free(dev_data->resp, len, false);
+	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
+
+	dev_data->req.sla = 0;
+	dev_data->resp.sla = 0;
+	dev_data->scratch.sla = 0;
+	dev_data->respbuf = NULL;
+	dev_data->reqbuf = NULL;
+	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
+}
+
+static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
+{
+	struct sev_tio_status *tio_status = to_tio_status(dev_data);
+	struct tsm_spdm *spdm = &dev_data->spdm;
+	int ret;
+
+	dev_data->req = sla_alloc(tio_status->spdm_req_size_max, true);
+	dev_data->resp = sla_alloc(tio_status->spdm_req_size_max, false);
+	dev_data->scratch_len = tio_status->spdm_scratch_size_max;
+	dev_data->scratch = sla_alloc(dev_data->scratch_len, true);
+	dev_data->output_len = tio_status->spdm_out_size_max;
+	dev_data->output = sla_alloc(dev_data->output_len, true);
+
+	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
+	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
+		ret = -ENOMEM;
+		goto free_spdm_exit;
+	}
+
+	dev_data->reqbuf = sla_buffer_map(dev_data->req);
+	dev_data->respbuf = sla_buffer_map(dev_data->resp);
+	if (!dev_data->reqbuf || !dev_data->respbuf) {
+		ret = -EFAULT;
+		goto free_spdm_exit;
+	}
+
+	spdm->req = sla_to_data(dev_data->reqbuf, SPDM_DOBJ_ID_REQ);
+	spdm->rsp = sla_to_data(dev_data->respbuf, SPDM_DOBJ_ID_RESP);
+	if (!spdm->req || !spdm->rsp) {
+		ret = -EFAULT;
+		goto free_spdm_exit;
+	}
+
+	dobj_response_init(dev_data->respbuf);
+
+	return 0;
+
+free_spdm_exit:
+	spdm_ctrl_free(dev_data);
+	return ret;
+}
+
+int sev_tio_init_locked(void *tio_status_page)
+{
+	struct sev_tio_status *tio_status = tio_status_page;
+	struct sev_data_tio_status data_status = {
+		.length = sizeof(data_status),
+	};
+	int ret, psp_ret;
+
+	data_status.status_paddr = __psp_pa(tio_status_page);
+	ret = __sev_do_cmd_locked(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
+	if (ret)
+		return ret;
+
+	if (tio_status->length < offsetofend(struct sev_tio_status, tdictx_size) ||
+	    tio_status->flags & 0xFFFFFF00)
+		return -EFAULT;
+
+	if (!tio_status->tio_en && !tio_status->tio_init_done)
+		return -ENOENT;
+
+	if (tio_status->tio_init_done)
+		return -EBUSY;
+
+	struct sev_data_tio_init ti = { .length = sizeof(ti) };
+
+	ret = __sev_do_cmd_locked(SEV_CMD_TIO_INIT, &ti, &psp_ret);
+	if (ret)
+		return ret;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
+		       u16 root_port_id, u8 segment_id)
+{
+	struct sev_tio_status *tio_status = to_tio_status(dev_data);
+	struct sev_data_tio_dev_create create = {
+		.length = sizeof(create),
+		.device_id = device_id,
+		.root_port_id = root_port_id,
+		.segment_id = segment_id,
+	};
+	void *data_pg;
+	int ret;
+
+	dev_data->dev_ctx = sla_alloc(tio_status->devctx_size, true);
+	if (IS_SLA_NULL(dev_data->dev_ctx))
+		return -ENOMEM;
+
+	data_pg = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!data_pg) {
+		ret = -ENOMEM;
+		goto free_ctx_exit;
+	}
+
+	create.dev_ctx_sla = dev_data->dev_ctx;
+	ret = sev_do_cmd(SEV_CMD_TIO_DEV_CREATE, &create, &dev_data->psp_ret);
+	if (ret)
+		goto free_data_pg_exit;
+
+	dev_data->data_pg = data_pg;
+
+	return 0;
+
+free_data_pg_exit:
+	snp_free_firmware_page(data_pg);
+free_ctx_exit:
+	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
+	return ret;
+}
+
+int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data)
+{
+	struct sev_tio_status *tio_status = to_tio_status(dev_data);
+	struct sev_data_tio_dev_reclaim r = {
+		.length = sizeof(r),
+		.dev_ctx_sla = dev_data->dev_ctx,
+	};
+	int ret;
+
+	if (dev_data->data_pg) {
+		snp_free_firmware_page(dev_data->data_pg);
+		dev_data->data_pg = NULL;
+	}
+
+	if (IS_SLA_NULL(dev_data->dev_ctx))
+		return 0;
+
+	ret = sev_do_cmd(SEV_CMD_TIO_DEV_RECLAIM, &r, &dev_data->psp_ret);
+
+	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
+	dev_data->dev_ctx = SLA_NULL;
+
+	spdm_ctrl_free(dev_data);
+
+	return ret;
+}
+
+int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot)
+{
+	struct sev_data_tio_dev_connect connect = {
+		.length = sizeof(connect),
+		.tc_mask = tc_mask,
+		.cert_slot = cert_slot,
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.ide_stream_id = {
+			ids[0], ids[1], ids[2], ids[3],
+			ids[4], ids[5], ids[6], ids[7]
+		},
+	};
+	int ret;
+
+	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+	if (!(tc_mask & 1))
+		return -EINVAL;
+
+	ret = spdm_ctrl_alloc(dev_data);
+	if (ret)
+		return ret;
+
+	spdm_ctrl_init(&connect.spdm_ctrl, dev_data);
+
+	return sev_tio_do_cmd(SEV_CMD_TIO_DEV_CONNECT, &connect, sizeof(connect),
+			      &dev_data->psp_ret, dev_data);
+}
+
+int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force)
+{
+	struct sev_data_tio_dev_disconnect dc = {
+		.length = sizeof(dc),
+		.dev_ctx_sla = dev_data->dev_ctx,
+		.flags = force ? TIO_DEV_DISCONNECT_FLAG_FORCE : 0,
+	};
+
+	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx)))
+		return -EFAULT;
+
+	spdm_ctrl_init(&dc.spdm_ctrl, dev_data);
+
+	return sev_tio_do_cmd(SEV_CMD_TIO_DEV_DISCONNECT, &dc, sizeof(dc),
+			      &dev_data->psp_ret, dev_data);
+}
+
+int sev_tio_cmd_buffer_len(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_TIO_STATUS:		return sizeof(struct sev_data_tio_status);
+	case SEV_CMD_TIO_INIT:			return sizeof(struct sev_data_tio_init);
+	case SEV_CMD_TIO_DEV_CREATE:		return sizeof(struct sev_data_tio_dev_create);
+	case SEV_CMD_TIO_DEV_RECLAIM:		return sizeof(struct sev_data_tio_dev_reclaim);
+	case SEV_CMD_TIO_DEV_CONNECT:		return sizeof(struct sev_data_tio_dev_connect);
+	case SEV_CMD_TIO_DEV_DISCONNECT:	return sizeof(struct sev_data_tio_dev_disconnect);
+	default:				return 0;
+	}
+}
diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
new file mode 100644
index 000000000000..ea29cd5d0ff9
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -0,0 +1,405 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+// Interface to CCP/SEV-TIO for generic PCIe TDISP module
+
+#include <linux/pci.h>
+#include <linux/device.h>
+#include <linux/tsm.h>
+#include <linux/iommu.h>
+#include <linux/pci-doe.h>
+#include <linux/bitfield.h>
+#include <linux/module.h>
+
+#include <asm/sev-common.h>
+#include <asm/sev.h>
+
+#include "psp-dev.h"
+#include "sev-dev.h"
+#include "sev-dev-tio.h"
+
+MODULE_IMPORT_NS("PCI_IDE");
+
+#define TIO_DEFAULT_NR_IDE_STREAMS	1
+
+static uint nr_ide_streams = TIO_DEFAULT_NR_IDE_STREAMS;
+module_param_named(ide_nr, nr_ide_streams, uint, 0644);
+MODULE_PARM_DESC(ide_nr, "Set the maximum number of IDE streams per PHB");
+
+#define dev_to_sp(dev)		((struct sp_device *)dev_get_drvdata(dev))
+#define dev_to_psp(dev)		((struct psp_device *)(dev_to_sp(dev)->psp_data))
+#define dev_to_sev(dev)		((struct sev_device *)(dev_to_psp(dev)->sev_data))
+#define tsm_dev_to_sev(tsmdev)	dev_to_sev((tsmdev)->dev.parent)
+
+#define pdev_to_tio_dsm(pdev)	(container_of((pdev)->tsm, struct tio_dsm, tsm.base_tsm))
+
+static int sev_tio_spdm_cmd(struct tio_dsm *dsm, int ret)
+{
+	struct tsm_dsm_tio *dev_data = &dsm->data;
+	struct tsm_spdm *spdm = &dev_data->spdm;
+
+	/* Check the main command handler response before entering the loop */
+	if (ret == 0 && dev_data->psp_ret != SEV_RET_SUCCESS)
+		return -EINVAL;
+
+	if (ret <= 0)
+		return ret;
+
+	/* ret > 0 means "SPDM requested" */
+	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
+		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG, ret,
+			      spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
+		if (ret < 0)
+			break;
+
+		WARN_ON_ONCE(ret == 0); /* The response should never be empty */
+		spdm->rsp_len = ret;
+		ret = sev_tio_continue(dev_data);
+	}
+
+	return ret;
+}
+
+static int stream_enable(struct pci_ide *ide)
+{
+	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
+	int ret;
+
+	ret = pci_ide_stream_enable(rp, ide);
+	if (ret)
+		return ret;
+
+	ret = pci_ide_stream_enable(ide->pdev, ide);
+	if (ret)
+		pci_ide_stream_disable(rp, ide);
+
+	return ret;
+}
+
+static int streams_enable(struct pci_ide **ide)
+{
+	int ret = 0;
+
+	for (int i = 0; i < TIO_IDE_MAX_TC; ++i) {
+		if (ide[i]) {
+			ret = stream_enable(ide[i]);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static void stream_disable(struct pci_ide *ide)
+{
+	pci_ide_stream_disable(ide->pdev, ide);
+	pci_ide_stream_disable(pcie_find_root_port(ide->pdev), ide);
+}
+
+static void streams_disable(struct pci_ide **ide)
+{
+	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
+		if (ide[i])
+			stream_disable(ide[i]);
+}
+
+static void stream_setup(struct pci_ide *ide)
+{
+	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
+
+	ide->partner[PCI_IDE_EP].rid_start = 0;
+	ide->partner[PCI_IDE_EP].rid_end = 0xffff;
+	ide->partner[PCI_IDE_RP].rid_start = 0;
+	ide->partner[PCI_IDE_RP].rid_end = 0xffff;
+
+	ide->pdev->ide_cfg = 0;
+	ide->pdev->ide_tee_limit = 1;
+	rp->ide_cfg = 1;
+	rp->ide_tee_limit = 0;
+
+	pci_warn(ide->pdev, "Forcing CFG/TEE for %s", pci_name(rp));
+	pci_ide_stream_setup(ide->pdev, ide);
+	pci_ide_stream_setup(rp, ide);
+}
+
+static u8 streams_setup(struct pci_ide **ide, u8 *ids)
+{
+	bool def = false;
+	u8 tc_mask = 0;
+	int i;
+
+	for (i = 0; i < TIO_IDE_MAX_TC; ++i) {
+		if (!ide[i]) {
+			ids[i] = 0xFF;
+			continue;
+		}
+
+		tc_mask |= BIT(i);
+		ids[i] = ide[i]->stream_id;
+
+		if (!def) {
+			struct pci_ide_partner *settings;
+
+			settings = pci_ide_to_settings(ide[i]->pdev, ide[i]);
+			settings->default_stream = 1;
+			def = true;
+		}
+
+		stream_setup(ide[i]);
+	}
+
+	return tc_mask;
+}
+
+static int streams_register(struct pci_ide **ide)
+{
+	int ret = 0, i;
+
+	for (i = 0; i < TIO_IDE_MAX_TC; ++i) {
+		if (ide[i]) {
+			ret = pci_ide_stream_register(ide[i]);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static void streams_unregister(struct pci_ide **ide)
+{
+	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
+		if (ide[i])
+			pci_ide_stream_unregister(ide[i]);
+}
+
+static void stream_teardown(struct pci_ide *ide)
+{
+	pci_ide_stream_teardown(ide->pdev, ide);
+	pci_ide_stream_teardown(pcie_find_root_port(ide->pdev), ide);
+}
+
+static void streams_teardown(struct pci_ide **ide)
+{
+	for (int i = 0; i < TIO_IDE_MAX_TC; ++i) {
+		if (ide[i]) {
+			stream_teardown(ide[i]);
+			pci_ide_stream_free(ide[i]);
+			ide[i] = NULL;
+		}
+	}
+}
+
+static int stream_alloc(struct pci_dev *pdev, struct pci_ide **ide,
+			unsigned int tc)
+{
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct pci_ide *ide1;
+
+	if (ide[tc]) {
+		pci_err(pdev, "Stream for class=%d already registered", tc);
+		return -EBUSY;
+	}
+
+	/* FIXME: find a better way */
+	if (nr_ide_streams != TIO_DEFAULT_NR_IDE_STREAMS)
+		pci_notice(pdev, "Enable non-default %d streams", nr_ide_streams);
+	pci_ide_set_nr_streams(to_pci_host_bridge(rp->bus->bridge), nr_ide_streams);
+
+	ide1 = pci_ide_stream_alloc(pdev);
+	if (!ide1)
+		return -EFAULT;
+
+	/* Blindly assign streamid=0 to TC=0, and so on */
+	ide1->stream_id = tc;
+
+	ide[tc] = ide1;
+
+	return 0;
+}
+
+static struct pci_tsm *tio_pf0_probe(struct pci_dev *pdev, struct sev_device *sev)
+{
+	struct tio_dsm *dsm __free(kfree) = kzalloc(sizeof(*dsm), GFP_KERNEL);
+	int rc;
+
+	if (!dsm)
+		return NULL;
+
+	rc = pci_tsm_pf0_constructor(pdev, &dsm->tsm, sev->tsmdev);
+	if (rc)
+		return NULL;
+
+	pci_dbg(pdev, "TSM enabled\n");
+	dsm->sev = sev;
+	return &no_free_ptr(dsm)->tsm.base_tsm;
+}
+
+static struct pci_tsm *dsm_probe(struct tsm_dev *tsmdev, struct pci_dev *pdev)
+{
+	struct sev_device *sev = tsm_dev_to_sev(tsmdev);
+
+	if (is_pci_tsm_pf0(pdev))
+		return tio_pf0_probe(pdev, sev);
+	return 0;
+}
+
+static void dsm_remove(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+
+	pci_dbg(pdev, "TSM disabled\n");
+
+	if (is_pci_tsm_pf0(pdev)) {
+		struct tio_dsm *dsm = container_of(tsm, struct tio_dsm, tsm.base_tsm);
+
+		pci_tsm_pf0_destructor(&dsm->tsm);
+		kfree(dsm);
+	}
+}
+
+static int dsm_create(struct tio_dsm *dsm)
+{
+	struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
+	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
+	struct pci_dev *rootport = pcie_find_root_port(pdev);
+	u16 device_id = pci_dev_id(pdev);
+	u16 root_port_id;
+	u32 lnkcap = 0;
+
+	if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
+				  &lnkcap))
+		return -ENODEV;
+
+	root_port_id = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
+
+	return sev_tio_dev_create(&dsm->data, device_id, root_port_id, segment_id);
+}
+
+static int dsm_connect(struct pci_dev *pdev)
+{
+	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
+	struct tsm_dsm_tio *dev_data = &dsm->data;
+	u8 ids[TIO_IDE_MAX_TC];
+	u8 tc_mask;
+	int ret;
+
+	if (pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+				 PCI_DOE_FEATURE_SSESSION) != dsm->tsm.doe_mb) {
+		pci_err(pdev, "CMA DOE MB must support SSESSION\n");
+		return -EFAULT;
+	}
+
+	ret = stream_alloc(pdev, dev_data->ide, 0);
+	if (ret)
+		return ret;
+
+	ret = dsm_create(dsm);
+	if (ret)
+		goto ide_free_exit;
+
+	tc_mask = streams_setup(dev_data->ide, ids);
+
+	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
+	ret = sev_tio_spdm_cmd(dsm, ret);
+	if (ret)
+		goto free_exit;
+
+	streams_enable(dev_data->ide);
+
+	ret = streams_register(dev_data->ide);
+	if (ret)
+		goto free_exit;
+
+	return 0;
+
+free_exit:
+	sev_tio_dev_reclaim(dev_data);
+
+	streams_disable(dev_data->ide);
+ide_free_exit:
+
+	streams_teardown(dev_data->ide);
+
+	return ret;
+}
+
+static void dsm_disconnect(struct pci_dev *pdev)
+{
+	bool force = SYSTEM_HALT <= system_state && system_state <= SYSTEM_RESTART;
+	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
+	struct tsm_dsm_tio *dev_data = &dsm->data;
+	int ret;
+
+	ret = sev_tio_dev_disconnect(dev_data, force);
+	ret = sev_tio_spdm_cmd(dsm, ret);
+	if (ret && !force) {
+		ret = sev_tio_dev_disconnect(dev_data, true);
+		sev_tio_spdm_cmd(dsm, ret);
+	}
+
+	sev_tio_dev_reclaim(dev_data);
+
+	streams_disable(dev_data->ide);
+	streams_unregister(dev_data->ide);
+	streams_teardown(dev_data->ide);
+}
+
+static struct pci_tsm_ops sev_tsm_ops = {
+	.probe = dsm_probe,
+	.remove = dsm_remove,
+	.connect = dsm_connect,
+	.disconnect = dsm_disconnect,
+};
+
+void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
+{
+	struct sev_tio_status *t = kzalloc(sizeof(*t), GFP_KERNEL);
+	struct tsm_dev *tsmdev;
+	int ret;
+
+	WARN_ON(sev->tio_status);
+
+	if (!t)
+		return;
+
+	ret = sev_tio_init_locked(tio_status_page);
+	if (ret) {
+		pr_warn("SEV-TIO STATUS failed with %d\n", ret);
+		goto error_exit;
+	}
+
+	tsmdev = tsm_register(sev->dev, &sev_tsm_ops);
+	if (IS_ERR(tsmdev))
+		goto error_exit;
+
+	memcpy(t, tio_status_page, sizeof(*t));
+
+	pr_notice("SEV-TIO status: EN=%d INIT_DONE=%d rq=%d..%d rs=%d..%d "
+		  "scr=%d..%d out=%d..%d dev=%d tdi=%d algos=%x\n",
+		  t->tio_en, t->tio_init_done,
+		  t->spdm_req_size_min, t->spdm_req_size_max,
+		  t->spdm_rsp_size_min, t->spdm_rsp_size_max,
+		  t->spdm_scratch_size_min, t->spdm_scratch_size_max,
+		  t->spdm_out_size_min, t->spdm_out_size_max,
+		  t->devctx_size, t->tdictx_size,
+		  t->tio_crypto_alg);
+
+	sev->tsmdev = tsmdev;
+	sev->tio_status = t;
+
+	return;
+
+error_exit:
+	kfree(t);
+	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
+	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
+}
+
+void sev_tsm_uninit(struct sev_device *sev)
+{
+	if (sev->tsmdev)
+		tsm_unregister(sev->tsmdev);
+
+	sev->tsmdev = NULL;
+}
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2f1c9614d359..365867f381e9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -38,6 +38,7 @@
 
 #include "psp-dev.h"
 #include "sev-dev.h"
+#include "sev-dev-tio.h"
 
 #define DEVICE_NAME		"sev"
 #define SEV_FW_FILE		"amd/sev.fw"
@@ -75,6 +76,12 @@ static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
 
+#if defined(CONFIG_PCI_TSM)
+static bool sev_tio_enabled = true;
+module_param_named(tio, sev_tio_enabled, bool, 0444);
+MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
+#endif
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -251,7 +258,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
-	default:				return 0;
+	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
 	return 0;
@@ -1439,8 +1446,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
+
+#if defined(CONFIG_PCI_TSM)
 		data.tio_en = sev_tio_present(sev) &&
+			sev_tio_enabled && psp_init_on_probe &&
 			amd_iommu_sev_tio_supported();
+		if (sev_tio_present(sev) && !psp_init_on_probe)
+			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
+#endif
 		cmd = SEV_CMD_SNP_INIT_EX;
 	} else {
 		cmd = SEV_CMD_SNP_INIT;
@@ -1487,6 +1500,24 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &snp_panic_notifier);
 
+#if defined(CONFIG_PCI_TSM)
+	if (data.tio_en) {
+		/*
+		 * This executes with the sev_cmd_mutex held so down the stack
+		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
+		 * unlikely) but will cause a deadlock.
+		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
+		 * for this one call here.
+		 */
+		void *tio_status = page_address(__snp_alloc_firmware_pages(
+			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
+
+		if (tio_status) {
+			sev_tsm_init_locked(sev, tio_status);
+			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
+		}
+	}
+#endif
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -2766,7 +2797,22 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 
 static void sev_firmware_shutdown(struct sev_device *sev)
 {
+#if defined(CONFIG_PCI_TSM)
+	/*
+	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
+	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
+	 */
+	if (sev->tio_status)
+		sev_tsm_uninit(sev);
+#endif
+
 	mutex_lock(&sev_cmd_mutex);
+
+#if defined(CONFIG_PCI_TSM)
+	kfree(sev->tio_status);
+	sev->tio_status = NULL;
+#endif
+
 	__sev_firmware_shutdown(sev, false);
 	mutex_unlock(&sev_cmd_mutex);
 }
-- 
2.51.1

