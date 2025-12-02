Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013030.outbound.protection.outlook.com [40.107.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE663FF1;
	Tue,  2 Dec 2025 02:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643674; cv=fail; b=Ik+iYsxTRqK4fsiQpjf6OLD9kkwI4e/w/0A4AGCAq1SfA0anIaUWaVQFLOX32lMT0tBlzN4RIPSuw6+1WR4CI/nBo1Lp8db/c5P8PD++g8MC7wTVL+WhWNeUASVTJaDG5oiLuEsN6hmiOGiFSRUJuLuiptUbfJ+wvQcuWIysc78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643674; c=relaxed/simple;
	bh=Eq8OtGU21KijTMRy10zhejfV8bpqjLEuUO0Dlvqm3hQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWBO0+Ao4ODByoK2f3tQWgErOGPMb03IVpnGqCsfzlPRQsvWwxL8rcDarlhxVSQrZj65KYm8nO3P8v/vb137yrT23Z2cD6GpUweUxp6zlbaRtGMV+2v8DE5KDBzKPAANMAr+w/K2yr/w55ETbOLRTvtB+utm+jWqVhdCO5T6GKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=h/L/0s2b; arc=fail smtp.client-ip=40.107.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="h/L/0s2b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mY0q6w3gEpLL8iBG/mBDWyiSI+7/hTIzYhT3vJ4vnPyDr1CBzd48ODOXOzrPHWpWo8gqHVhOJYZIbl/JJROLSIF6ips5jtSmwBvnUUBwZ9FzdLEjQcfs4QKBFtRk1h+UkrFQ3X4do15WZoJv5osGoZrquYo9CVWEfSoW6QTw/hGv6986ih1EWEWlJ0C04dELUMFFd4VqQLK9bFFDtIJzhOhK/OEo9vj/86+OREhuOy+82SCB9RWYk8kgqn4FCQ5cYS0D8OxQrHpTR/QXy/18IEvZMaHYzTATe1Km613rziJgpoZwFCqJocYUtkv6M19FS7J/TQJq3VDoH8IZCxDD1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jxsl56+bmSZ/rOgxInCxUJMdDId4CPkyOQ1+U02asdQ=;
 b=PPKgJF1S3e039C3SRDoIFt1IAH9vNM0nFpu8at9hWJxvRf+J6J9t0p0Sql3WwuS+lcfLUKVMWrVuuJQ53r01xLBZ+PkHG8O6MSX82XEKKTMUmj5daU0YYhKO+9am6qHIgfFUqqGLltcHQ0xv8Lan/mIDtCe5pJFQbZd/oulCqy4bsIgXorwS01gdgT/Pp55NjyWupff66hW5Yr63U580LF3roUu0lCfUPR/qEHE0nx+JTVh7/lussFRfaeRv6Udh/GWJKg/J2KtcDaHIW5lRHXm2P7YqiUqIz+5u19MlGXKBjJBoL7sZqcYjqS8lri8xwzpjDj49TpYIpqv0btuOdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jxsl56+bmSZ/rOgxInCxUJMdDId4CPkyOQ1+U02asdQ=;
 b=h/L/0s2bXBk7BlD9pybZCJ+6dxl2W3fXDXJ0HG3hQ3u74Dk1wxpIzA2Cl7KiiwW+ApCvCczV+EuCau/9cw3+/hDJwUvOw6U34Jfy+Es9rB+s8ueEE0+w3iGtGuy5DAqItAXvz2+87eIk9JNl8XL/gkcWbl8JLmXGXo4X+niFJY4=
Received: from BY5PR17CA0024.namprd17.prod.outlook.com (2603:10b6:a03:1b8::37)
 by CH1PR12MB9575.namprd12.prod.outlook.com (2603:10b6:610:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 02:47:43 +0000
Received: from SJ5PEPF000001EA.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::d0) by BY5PR17CA0024.outlook.office365.com
 (2603:10b6:a03:1b8::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Tue,
 2 Dec 2025 02:47:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EA.mail.protection.outlook.com (10.167.242.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 02:47:43 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 20:47:28 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-crypto@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Gao Shiyuan <gaoshiyuan@baidu.com>, "Sean
 Christopherson" <seanjc@google.com>, Kim Phillips <kim.phillips@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, <iommu@lists.linux.dev>, "Alexey
 Kardashevskiy" <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH kernel v3 4/4] crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)
Date: Tue, 2 Dec 2025 13:44:49 +1100
Message-ID: <20251202024449.542361-5-aik@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251202024449.542361-1-aik@amd.com>
References: <20251202024449.542361-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EA:EE_|CH1PR12MB9575:EE_
X-MS-Office365-Filtering-Correlation-Id: 037abce2-21d2-4cc9-0e4b-08de314d2adb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TaVLsr4aLqJJH+xWzH7DUhLfWVhetIel27iCe/Gf/bS0IUSEHxYzS805jMK3?=
 =?us-ascii?Q?Ppku/B6i0BZjLqxM3d+OMktLeIWHbk7RUVcmwDcQNs6WGCerMkr6CEMY1EPL?=
 =?us-ascii?Q?jmrlkIKklR/zAI+h8H8p67ulAAAl+RM9/tJXn+5HkL19ak3oLjnf4OlYhwNh?=
 =?us-ascii?Q?qWAavuSKc8oIhlHgLI9bpGOuE1r2u/02B9ELBEpzYE4ssq8zuc8hh6pQh2va?=
 =?us-ascii?Q?7kdZtn+A9PzDdx8UJrG+F7CXJPs9Bke2e/F6++shNUAk+S/QCsYkfH047Tth?=
 =?us-ascii?Q?EOCoazNxPdKjyevod/FfH6fwRU0OG9QaV/CZuPAz9QpJx3TN4Y85tW2GFKX7?=
 =?us-ascii?Q?ifIaILFkoJgvfCokR7+5QcogsffTNhoSnpCHAcdKHrXl5JIvD8LkzeBtEJWA?=
 =?us-ascii?Q?tABsmGn/QbM2B/YZ2wqp4XNSudGn0h+Xm6eNzSn0udhT0HAYPt6xoYM+cXQc?=
 =?us-ascii?Q?6HHo5+RfZX/snVsr0Q29GeO9ouuxNR0xidbP36/rzzBnP6UzoZS6luPLJ5UJ?=
 =?us-ascii?Q?0cANsJb+VGsBfQAgj7svXwsdB7HIrIJy1/lQLTiVH5egJd4OANPPD3Bx8EBj?=
 =?us-ascii?Q?gT+/mEQyvpnxg5MaSdM5q4cWYsU4mCRnR5b3L+chvIqt8e4SG61w7LyAwSnl?=
 =?us-ascii?Q?+C71C2tOrurYfNcmJtG/lmyX8DWrgtdlmMdl6yVFJPh84J2Qelya/6p8iFr2?=
 =?us-ascii?Q?aUCgiwjo6i8zBY4x1BGSq4pd2Ju5VZshJ88QviQWdtmwZ9cCjlsurxTUOG1L?=
 =?us-ascii?Q?DquvOoUiMMF6EFDUZGVR9qLz8vk4BfBz/iQmTVasXlvD1YUPM3i+cesVtyDJ?=
 =?us-ascii?Q?IQiBq2XCmpCLkuEdqtfnH+3ktojMLjvkdM/Wi1jJETu++Y6jTDgrLRLC0gC/?=
 =?us-ascii?Q?3PTCo51gabbxgzQTqzNw+PEQfvuQhIoIg4DMKxUfdcJwYLuZNoSISRo8TPpD?=
 =?us-ascii?Q?7U6VloA0T7hVerAQyNK0tU2tZgyBkDEvvGajHAKvHgWmml1UsYyKsx68/dmE?=
 =?us-ascii?Q?NhwQGeh3mrbKyQhcI2+XCSgkDdXJJyPMonKnZqwMp+ItPkjRfm1uMbTr+H99?=
 =?us-ascii?Q?cQugpflFoWj2Edmzf97zpdG7xln70xmUwIp5Pi2MBCPaRO4om5L2JS2FIsPM?=
 =?us-ascii?Q?JYPSjgNUOyYbm1EgaMO7swU7DQLn9jSJK0NlYP0iWdh0h0R4QubJF26b5EjZ?=
 =?us-ascii?Q?yWV/jwtvo+sVMHaHEVDl7DvRoqIXWHwmHdmP9nwGAhmuS2aeAPp+slc3fV6Z?=
 =?us-ascii?Q?zrO4F1jkEkeGqPWSeM+9M0canWMWUJ8gXgnMkUeDbX4TM7ml8aXWQl5DvJmF?=
 =?us-ascii?Q?B/kNR29qHpm96d/AAfvrq5dB+mS0nCEmRuDMZyrfjCdIdX2Kgh3taoW3Qk48?=
 =?us-ascii?Q?ssP1BD70xm9oEV5jI50lBL8vJ7Ijxn0mRfUbG7m5XW3LCPX2nzrZpMwF+JRA?=
 =?us-ascii?Q?vgStwtp7R/TlkjlK2hZD6nrP0ZhCdSa6Xl6uoZK9sEJ8zxiHBGijZ1mAGKC1?=
 =?us-ascii?Q?K62OJE2H7yM5tlO+uSMkD2rHsk1mzIF8WW/HOD3yc0fcaluxbqoXFGCaRy+m?=
 =?us-ascii?Q?oPJv4U8h/zPZTEHl5ts=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:47:43.3091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 037abce2-21d2-4cc9-0e4b-08de314d2adb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9575

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

Detect the PSP support (reported via FEATURE_INFO + SNP_PLATFORM_STATUS)
and enable SEV-TIO in the SNP_INIT_EX call if the hardware supports TIO.

Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
the data in the SEV-TIO-specific structs.

Implement TSM hooks and IDE setup in sev-dev-tsm.c.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
Changes:
v2:
* moved declarations from sev-dev-tio.h to sev-dev.h
* removed include "sev-dev-tio.h" from sev-dev.c to fight errors when TSM is disabled
* converted /** to /* as these are part of any external API and trigger unwanted kerneldoc warnings
* got rid of ifdefs
* "select PCI_TSM" moved under CRYPTO_DEV_SP_PSP
* open coded SNP_SEV_TIO_SUPPORTED
* renamed tio_present to tio_supp to match the flag name
* merged "crypto: ccp: Enable SEV-TIO feature in the PSP when supported" to this one
---
 drivers/crypto/ccp/Kconfig       |   1 +
 drivers/crypto/ccp/Makefile      |   4 +
 drivers/crypto/ccp/sev-dev-tio.h | 123 +++
 drivers/crypto/ccp/sev-dev.h     |   9 +
 include/linux/psp-sev.h          |  11 +-
 drivers/crypto/ccp/sev-dev-tio.c | 864 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
 drivers/crypto/ccp/sev-dev.c     |  51 +-
 8 files changed, 1465 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f394e45e11ab..e2b127f0986b 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -39,6 +39,7 @@ config CRYPTO_DEV_SP_PSP
 	bool "Platform Security Processor (PSP) device"
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
+	select PCI_TSM
 	help
 	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index a9626b30044a..0424e08561ef 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -16,6 +16,10 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
                                    hsti.o \
                                    sfs.o
 
+ifeq ($(CONFIG_PCI_TSM),y)
+ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev-tsm.o sev-dev-tio.o
+endif
+
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes.o \
diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
new file mode 100644
index 000000000000..67512b3dbc53
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __PSP_SEV_TIO_H__
+#define __PSP_SEV_TIO_H__
+
+#include <linux/pci-tsm.h>
+#include <linux/pci-ide.h>
+#include <linux/tsm.h>
+#include <uapi/linux/psp-sev.h>
+
+struct sla_addr_t {
+	union {
+		u64 sla;
+		struct {
+			u64 page_type	:1,
+			    page_size	:1,
+			    reserved1	:10,
+			    pfn		:40,
+			    reserved2	:12;
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
+	struct { /* Version of the data object structure */
+		u8 minor;
+		u8 major;
+	} version;
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
+	u32 tio_en	  :1,
+	    tio_init_done :1,
+	    reserved	  :30;
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
+	u8 reserved2[12];
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
+#endif	/* __PSP_SEV_TIO_H__ */
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index b9029506383f..b1cd556bbbf6 100644
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
@@ -61,6 +63,9 @@ struct sev_device {
 
 	struct sev_user_data_snp_status snp_plat_status;
 	struct snp_feature_info snp_feat_info_0;
+
+	struct tsm_dev *tsmdev;
+	struct sev_tio_status *tio_status;
 };
 
 int sev_dev_init(struct psp_device *psp);
@@ -74,4 +79,8 @@ void sev_pci_exit(void);
 struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
 void snp_free_hv_fixed_pages(struct page *page);
 
+void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
+void sev_tsm_uninit(struct sev_device *sev);
+int sev_tio_cmd_buffer_len(int cmd);
+
 #endif /* __SEV_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 34a25209f909..cce864dbf281 100644
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
 
@@ -750,7 +757,8 @@ struct sev_data_snp_init_ex {
 	u32 list_paddr_en:1;
 	u32 rapl_dis:1;
 	u32 ciphertext_hiding_en:1;
-	u32 rsvd:28;
+	u32 tio_en:1;
+	u32 rsvd:27;
 	u32 rsvd1;
 	u64 list_paddr;
 	u16 max_snp_asid;
@@ -850,6 +858,7 @@ struct snp_feature_info {
 } __packed;
 
 #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
+#define SNP_SEV_TIO_SUPPORTED			BIT(1) /* EBX */
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
new file mode 100644
index 000000000000..9a98f98c20a7
--- /dev/null
+++ b/drivers/crypto/ccp/sev-dev-tio.c
@@ -0,0 +1,864 @@
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
+/*
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
+/*
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
+/*
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
+/*
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
+/*
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
+/*
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
+/*
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
+/*
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
+
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
+	    tio_status->reserved)
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
index 9e0c16b36f9c..d6095d1467b3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
 module_param(psp_init_on_probe, bool, 0444);
 MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
 
+static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM);
+module_param_named(tio, sev_tio_enabled, bool, 0444);
+MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
+
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -251,7 +255,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
-	default:				return 0;
+	default:				return sev_tio_cmd_buffer_len(cmd);
 	}
 
 	return 0;
@@ -1434,6 +1438,19 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		data.init_rmp = 1;
 		data.list_paddr_en = 1;
 		data.list_paddr = __psp_pa(snp_range_list);
+
+		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
+
+		data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
+
+		/*
+		 * When psp_init_on_probe is disabled, the userspace calling
+		 * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
+		 * unexpected state loss.
+		 */
+		if (data.tio_en && !psp_init_on_probe)
+			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
+
 		cmd = SEV_CMD_SNP_INIT_EX;
 	} else {
 		cmd = SEV_CMD_SNP_INIT;
@@ -1471,7 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
 	sev->snp_initialized = true;
-	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
+	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
+		data.tio_en ? "enabled" : "disabled");
 
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
@@ -1479,6 +1497,23 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &snp_panic_notifier);
 
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
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -2758,8 +2793,20 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
 
 static void sev_firmware_shutdown(struct sev_device *sev)
 {
+	/*
+	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
+	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
+	 */
+	if (sev->tio_status)
+		sev_tsm_uninit(sev);
+
 	mutex_lock(&sev_cmd_mutex);
+
 	__sev_firmware_shutdown(sev, false);
+
+	kfree(sev->tio_status);
+	sev->tio_status = NULL;
+
 	mutex_unlock(&sev_cmd_mutex);
 }
 
-- 
2.51.1

