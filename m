Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519CA3597B;
	Tue,  2 Dec 2025 02:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643556; cv=fail; b=NoDh3cKD4cKRnIYg5ARbREPAPUUBPUw1Q36ewTVTGBALC7y2k+zBKt+cZh6ch7bJz5u8IpPLoItiBFYbozp5gQBmDbl9fkDxJ1ffZI5q1CwOIRRKoo+y0677kunccxJNFcZZC7gFnzF2LlOLzgZs7wLjQbirvm47iNeJI5UBSiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643556; c=relaxed/simple;
	bh=vRj/N0mJXU+2YtMgMm0oZXE1zLKHm6NcQogcdznNdYg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Psvv+vJilhl8TItKwQ6wwpx8pr7sTDJ+9OSM7L6vX/I3LYKH0mYa+4q0SSri3oBUFwnn8ZFMTska0BLcKt9drTigrm6b81vylEuXSvIWtDGnLNtCHee0ZtZOAIsm5j1Msuk30BQexfS3S2Zv507ziXwJ6sBNSa0LGb7LAbQ9vNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dYY8QQKV; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dYY8QQKV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ch9MWp5kJKZKF6iw/arBZdLY3UpghEd7ue8bpHoDhd5NsKPjN6iRQB5wePzY2ioDMAkbrr9tQE2s2pDYnEYels4BCOJYTSwpu6f8R0OVMfAYoYJtktlhALGnLFBlVqZxyg1buwyCVWZ65sjdprtxeppMqNNGQyP2jWBNAR5Jlavd9BQQiJ6ocaq82Nt3u8nQTydX5bJKMm1VxGd41x1hQSQGv/+rfwYDe3TfgUoz00DoCGKmkpYQ69ZyYan2ri9t5hYzoAMMYwrwzbh8g/DAkaTHiCFcQjceU8b1Fi5MAvQ+JdSFEnsPdKzcXGS1XoQxORoBu5ehUTmoiwPq2a6WyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UE5Bu7pdMDUmMUBstAYhr683llJR92UiMcvAF8DXC4=;
 b=SEpUVsAH7KAAE2YCtRRt1Q1kK7posAo0iK1T5gSbCe1INf2XY/WllipOYmzZbDNykG4bGJ4LcMz9nxd5twWYQEMLlLbSI436SBGXpmWrEY0X8oeBQb5tEaNQ/uRP2MIWvg3gSLxuCinxoO+RXVkqdiTNaQ8zaUj9BaREcZe8AN6b1q0HBFDrhHom/YZGhsxif/nOo9i6VwuEAxoCc1+RoUfJQMC8xmVtXaWh5UxpbKsJURAuH6kl9kYFTK2P9GGLovHCNVnb0S1oKTm38d339J1uOCAHDRlDxCNar/im6j8VMOchoqMR4ZvWItgPXMXvRoW5rMt1Hv6KIV03JLGYHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UE5Bu7pdMDUmMUBstAYhr683llJR92UiMcvAF8DXC4=;
 b=dYY8QQKVmXz2y9oIy6ka4NdPp0YT1gH8pOPy/I7veRbsw1rJ1QeBsnBoYNg/nmg87731+rFWv5vBTcfg8Y74s2H38hg3E9VF+G+mtWhidgGKN9EaWRkUvHk9c99n2TOs/kCwxAdxFXclg5bCZtWTQJ3DR8OdIo7NWU+4V72nACs=
Received: from SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12)
 by CY8PR12MB8362.namprd12.prod.outlook.com (2603:10b6:930:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 02:45:51 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::e1) by SJ0PR05CA0007.outlook.office365.com
 (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Tue, 2
 Dec 2025 02:45:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 02:45:50 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 20:45:37 -0600
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
Subject: [PATCH kernel v3 0/4] PCI/TSM: Enabling core infrastructure on AMD SEV TIO
Date: Tue, 2 Dec 2025 13:44:45 +1100
Message-ID: <20251202024449.542361-1-aik@amd.com>
X-Mailer: git-send-email 2.51.1
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|CY8PR12MB8362:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ee0734e-3107-40c4-e0f4-08de314ce7a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M7Rh0y79GM5H5ZRpnm2UV/3S+Jzn+EWQh04dovXnHIexOtp+o3Ii0ydYfHvs?=
 =?us-ascii?Q?A3NVbbzvc3e4BXieLF2Pa/SAD+1aiVva1QraZBZn4qtMFwdB4XBKYxNSlKbu?=
 =?us-ascii?Q?ty3cV5JUBTaZjSPLsXqZFkChkaiflsoUW48Z4sYaxxSBLOlcplr5Dk7l9+zR?=
 =?us-ascii?Q?gC+8sTKFxNRkKlXekrDAuhSi95oq3bAPYboXb/8l0eRYTH5kz1ZobIf8/OCt?=
 =?us-ascii?Q?X9CXPqJujVfhyqCf78xYYzKJEpF2VM/ivJXmmnItflGPVgbOkoAa4CSTKyFQ?=
 =?us-ascii?Q?KKFKoEOCPx2WDJBOm2QmE5mQmRnj8rN8lMm0Mvx7sWtxyhhMCd443QgJ+6U1?=
 =?us-ascii?Q?EjgNS3xPZBw3M9NbcrN+XjodfZtGl23XWHTnulmu6I3NODIXDEZyj30VH41r?=
 =?us-ascii?Q?t/DSgfa/FCS78GbGyIXoHJc7fNaKOryZronfBho7i0zK0hJ6wQjXMvTi0r0f?=
 =?us-ascii?Q?Z+l/vCoXDrnLMtagVRnSPOmupNt2ZoagJjg+jMESc/EcjFFs0oH9u724niBK?=
 =?us-ascii?Q?G6qzuB7XfcPMzyxpIfNfXKMNbBUAZsD5dmGvSCNRi1e4r9+3ecNmu8K3LJCf?=
 =?us-ascii?Q?GmXPcy+uS5LgNZSbTpWTe1WbHe3Mh7dXhjp4j1lzyTpdjIBZcIWWC8nUf0VS?=
 =?us-ascii?Q?siVHSB+33VroriQOEJwaOfI8wwwcsmqszDN8kz0MfFC96kKvxVzVq/HlFD+e?=
 =?us-ascii?Q?C7+y+Vuttjx8hJ8SgJ/g+pKeS3PXF+njEoFz+sAwJreZOe38Fd/NMOKJF/VG?=
 =?us-ascii?Q?B8tO2rlM4+RJ99uTbQpl8HSy+DiCVzZ9Al24+v1pwCy2+UOR6t0eGl3Cyko6?=
 =?us-ascii?Q?iNoLmMMXVz74K9HraBhXavUl9h1fALV11/8BTPh8Xp2PkNrtanPDP85XSXpV?=
 =?us-ascii?Q?9nJMBup/wMqrbmdO46mmvcDYQ6bRujem6rCGnDHau4Yg7Wsc2q+pDonq57Cz?=
 =?us-ascii?Q?Rse7UiLXKFuFjr3FVdJeSUNT+vd/78D6AfEKm784mQtRMh6rpcT5Gc3NhQkd?=
 =?us-ascii?Q?jz/+PI5zWG2Ad32mKFuKRqrLfYf+czfh5S5mRDKetIoschemz2l3zDgW+IAu?=
 =?us-ascii?Q?DtRhfWyaSCnuY2m0JZo2kUb0JzTKgzQTfbOlLU7sLDpt7IfENvmsR9ORjb16?=
 =?us-ascii?Q?JlYbDML8ZtiwolW8c6qhbn6fpHWOwLNJktSTTVHbgj8Yvk5WJIy4v88d6c+S?=
 =?us-ascii?Q?cAzqjZPVvRH87cNBQUKUeP1EUHEz2MI61yF9LbQW8KQA+VayZaVjMVBGY/ZR?=
 =?us-ascii?Q?iu9nzhYz4V9qACmxJZbdVFcQdgG9A2V/eAkq70Zl4FtOuqMzdcgMjdWIVOod?=
 =?us-ascii?Q?LOS6pppsswag94hXwnYDbxKYsnFdpoKeK2vMK3ipqSW5d+0eygV0G5uLE/Ju?=
 =?us-ascii?Q?0ed1rErzcMcVrIrMi5pjOYqNFmCqriyjbF+LeyNIAhVLNWSbJZ6t2bswWSJb?=
 =?us-ascii?Q?pTX/juqE/1g3NVQkgLDLwYxTodf66aa8Qq+8DaVjQ7OB8++qbpeDf/7jtdlU?=
 =?us-ascii?Q?qNySwdgWDe+sB/GKLe0NmUuzYAKNJPoEcIcRXzmZ3il7L4jdHYbN/p+5d2s4?=
 =?us-ascii?Q?sdI3J+rtAxQty1XbOkddl5yEYgDEyY3F6ACzvWSq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:45:50.5268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee0734e-3107-40c4-e0f4-08de314ce7a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8362

Here are some patches to begin enabling SEV-TIO on AMD.

SEV-TIO allows guests to establish trust in a device that supports TEE
Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
then interact with the device via private memory.

In order to streamline upstreaming process, a common TSM infrastructure
is being developed in collaboration with Intel+ARM+RiscV. There is
Documentation/driver-api/pci/tsm.rst with proposed phases:
1. IDE: encrypt PCI, host only
2. TDISP: lock + accept flow, host and guest, interface report
3. Enable secure MMIO + DMA: IOMMUFD, KVM changes
4. Device attestation: certificates, measurements

This is phase1 == IDE only.

SEV TIO spec:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf

Acronyms:
TEE - Trusted Execution Environments, a concept of managing trust
between the host and devices
TSM - TEE Security Manager (TSM), an entity which ensures security on
the host
PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM
on AMD.
SEV TIO - the TIO protocol implemented by the PSP and used by the host
GHCB - guest/host communication block - a protocol for guest-to-host
communication via a shared page
TDISP - TEE Device Interface Security Protocol (PCIe).



Flow:
- Boot host OS, load CCP which registers itself as a TSM
- PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
  TDISP-capable devices
- Enable IDE via "echo tsm0 >
  /sys/bus/pci/devices/0000:e1:00.0/tsm/connect"
- observe "secure" in stream states in "lspci" for the rootport and endpoint

This is pushed out to
https://github.com/AMDESE/linux-kvm/commits/tsm-staging

The full "WIP" trees and configs are here:
https://github.com/AMDESE/AMDSEV/blob/tsm/stable-commits


The previous conversation is here:
https://lore.kernel.org/r/20251121080629.444992-1-aik@amd.com 
https://lore.kernel.org/r/20251111063819.4098701-1-aik@amd.com
https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com


This is based on sha1
f7ae6d4ec652 Dan Williams "PCI/TSM: Add 'dsm' and 'bound' attributes for dependent functions".


Please comment. Thanks.



Alexey Kardashevskiy (4):
  ccp: Make snp_reclaim_pages and __sev_do_cmd_locked public
  psp-sev: Assign numbers to all status codes and add new
  iommu/amd: Report SEV-TIO support
  crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)

 drivers/crypto/ccp/Kconfig          |   1 +
 drivers/crypto/ccp/Makefile         |   4 +
 drivers/crypto/ccp/sev-dev-tio.h    | 123 +++
 drivers/crypto/ccp/sev-dev.h        |  11 +
 drivers/iommu/amd/amd_iommu_types.h |   1 +
 include/linux/amd-iommu.h           |   2 +
 include/linux/psp-sev.h             |  17 +-
 include/uapi/linux/psp-sev.h        |  66 +-
 drivers/crypto/ccp/sev-dev-tio.c    | 864 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c    | 405 +++++++++
 drivers/crypto/ccp/sev-dev.c        |  62 +-
 drivers/iommu/amd/init.c            |   9 +
 12 files changed, 1529 insertions(+), 36 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
 create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c

-- 
2.51.1

