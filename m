Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5C92BE658;
	Fri, 21 Nov 2025 08:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712423; cv=fail; b=KVI8fFxyN/EcsEy+QL9jiHNWoyMYt2A3p892j/AePSo8MpNHfKkNd/gCR3ZfT4inhyZN0jvYgWc6Eg2dzcKAno6QKVV9SKcHVO0gJGPDFBzD8vgh1W+Vej98G66T26DPS5CmGoEN51mfRXqbblkI7hVwGMnylqnO+JXCxx1dTJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712423; c=relaxed/simple;
	bh=OOayL5LvvL4oyS7/KTGhxj/sdXojndOjNe1RpGiPbs0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hxQH8gB6RxfZfzIAV5fZkKCP9eHdWjr5MWgqPAGu/t1KzTBqbTZVX591F1c0x6SFaOfiZt7LK4PJgcRR2aJstJzJL/jNFYnWGVn+YK/qDhd/8DIqUDh40ZP0PTvL0PbGHmciOWA1OVqw2vvtieAaOSE6+CXrH9SLVmUmiJasm7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l6zacElR; arc=fail smtp.client-ip=52.101.48.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l6zacElR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBPYQy778zaKtsHKjmHjlhs/ynsFZrGvxkODIPb13IBpXdTdIgCHMgtxVYsb3j60WyNl/lv4Ee1MGZjy2dD6hh032FV1c7BknSLK8epsK04UPK8WdGxwdKjcrJ2CI6ImicwPvt7pGyewRbS9LXuOeCBRjCvMhZjSXFKud5vlq7m1UuY+gPPxCNCKmyjcnB6NhemdF4LjOqYNMAtcQnSv7hDT4lddiSjKGkpgdDo9AG99+T/vmTP+jrtljMK+cY7KiGXoCgYKsY2r/Et0RitBkjwYtvQzEXwfOwUzbveh3tnAhxk/kWXeo4fd/tAfHnBAnpP4MxLSY4C1qdvC2vFJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/ts9VdaRvG9tneJXL99BO2H+NG/ouq8x07uERq2QHs=;
 b=sQC2eYgVCcE5qv9Ns2/i2KKMCajfnV5xy8uDft2PTqu8yXfTCloTBDty3s41cs9QqHpPhMTukI7ybIqEnrhep+Pedt6+QdsSre2hXonT6p13Kq0ZgGQMVvaQTxw1b94jllxDjgd4lW5zZFhD0uc7qqLe4xR8LW79T1tyi7KXOkExJgvJ91mYsoVfSR4fuvizP6eorzJgUeR0NLL1YlxoBwQFVEyH3xDiGo1mhq9yFryQx0SKvztz9R0BjxcQXnhqjoPT0oKzMPZLW1uz5RAlidnCFnewhxfnYr1xyMwTPLUE1598USHivFBYdyDE5G8UyRdTiv0FS3GKm3Ge8TXnpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O/ts9VdaRvG9tneJXL99BO2H+NG/ouq8x07uERq2QHs=;
 b=l6zacElRRSV32cr001HA0H8qSe1xBxk36hmCJkse7ScACy5ssD3038TzsV6I8Y+yvBHVfJJ3tQoDX7ENMYM3CsVbJrMEwXyN4jRd3u1i3eUyF2ulkrwAmoUC48k72aWmnPWpjWhdpw6/uol6L4wYgKvg/iGsMN/HhcfArstViEE=
Received: from DS7PR03CA0077.namprd03.prod.outlook.com (2603:10b6:5:3bb::22)
 by SA1PR12MB7366.namprd12.prod.outlook.com (2603:10b6:806:2b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 21 Nov
 2025 08:06:54 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:5:3bb:cafe::d0) by DS7PR03CA0077.outlook.office365.com
 (2603:10b6:5:3bb::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.11 via Frontend Transport; Fri,
 21 Nov 2025 08:06:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:06:53 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:06:41 -0800
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
Subject: [PATCH kernel v2 0/5] PCI/TSM: Enabling core infrastructure on
Date: Fri, 21 Nov 2025 19:06:24 +1100
Message-ID: <20251121080629.444992-1-aik@amd.com>
X-Mailer: git-send-email 2.51.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|SA1PR12MB7366:EE_
X-MS-Office365-Filtering-Correlation-Id: bfea9e16-b6da-41c5-c14b-08de28d4eee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DcjAG0ayNmzjfNMrX8AiSbS9M2zlaOpgELCOCj1oMDWgnMYOGu+elwiWr0kb?=
 =?us-ascii?Q?v1hEAcXhgqpVfsy0baQIg0XaaiUo5oJljKPTZpOZF2ojaTu0jTSLOBFETi5g?=
 =?us-ascii?Q?ZFW/4bIZNC8Wm/iWZK8yL9Q3tw2aioTPYT9/cSNk0wRf0CEzejjBqhx7lqsz?=
 =?us-ascii?Q?qTeqpjJxVt8CLYq50GjDe3G1SkkIrhOsrhAIDiBG4SQlrZexmHUu2bfREdOn?=
 =?us-ascii?Q?wEl1gwK9T77paB4xe6yKK4gH7cfgW+gHTvDNd0jHHpc1dSxU5FuxlAK0S/Tk?=
 =?us-ascii?Q?VuVLDq+e5y56eMgWOZS1y1y3HzSCZVkyHnMwN3y4ONe2nlFYS89RAyRCH3Do?=
 =?us-ascii?Q?QNUc6wGRL7m/KBGULD5ArdhVG0doAI92XPjS6MAzk1uQCuGLxRfP+NKWTuTz?=
 =?us-ascii?Q?gZ1GaubOo5v0FH31QcgE3SZ0BsvooD2Iq8whUv9Ut4m/94bS2FWU5rv1Dnq0?=
 =?us-ascii?Q?Dsya8F53Y38WldH2mxjl+wWPJeHIfBI9ajGEbn1C8ju+RZK9FWkov5yiUXQu?=
 =?us-ascii?Q?H3gBcBY1DZ+PM8+ViG27NH2F1tsUrTKUB7MJzjYrAKDElThYbiU/lL21wz2W?=
 =?us-ascii?Q?cwJOY5pFhIul5Ozln7cVZYUvYSCL7kEInlneGqpZCh5g4wXjK1Upp6bRLfqy?=
 =?us-ascii?Q?mguixQqg76Sw5QHaL4UpUiJ8ANsklAenJFmhVdTJ88Yl7u3SNJnK7zrYu5eh?=
 =?us-ascii?Q?6Y9YJBLh2tQxI+ae5KpCJ57C9DCkNYQogsUHGXIBpdyWzILyd5IzRp3EvAg9?=
 =?us-ascii?Q?7DpBQ84Lvs48ipWDsJyobCUAe4LClAqogYXqUYKKBHfexEjukBG4HibArxrO?=
 =?us-ascii?Q?Z3kZ8MXD/wUwFsfZMSaqma/3SKPCTKtBzLO31FIPwbakXAbGHcdC0DC4xjbq?=
 =?us-ascii?Q?DWGA6XeQi/yLEUWMpn4wFAoLMR/QIrhVaqQR6NqIQ4UWlcYjHOT3dzA1WZcy?=
 =?us-ascii?Q?HACk62V8u6MotGLeXheaN4/+RbPInDghPxz2waw4o0D2boEPHsHcdY0skd4J?=
 =?us-ascii?Q?uFLaqUfHOFmle9HT4kpaerHdKV2614sIz8LUg5N/jAQw1NgK+Mit2/2hRGfc?=
 =?us-ascii?Q?HIceW02ZjOZXei89A6DynEoZQf3xpSg00vXzuJrIxcGHpdwKcyT4HTiL4H5g?=
 =?us-ascii?Q?OUgR5jLlxekStVPeFT+xASs3A4N2mTFFMti8d3LVo/uzD90rhdAAUo7eTfdm?=
 =?us-ascii?Q?lXxfncFu2QHHH3I4rF9JvQdwUaN8pH4cdOz0fv1LVYjeOY7LCS+C3JgxPKF/?=
 =?us-ascii?Q?LgtUAKevUZX9t7+0wu9D9KXrlL4OS/GWQIjvwo4ztyh1XRrBFrVo9nEtKcdB?=
 =?us-ascii?Q?76LxH+lurIYhMThLGNYLVmKm53cRQHDYpbTHOTGoA4WF/CYhJj9grz3xXGuq?=
 =?us-ascii?Q?MYxY2v5TFf9gsB4hjVwEg3BXpwXrCcZRkKeL6NRmYc3MBEjXS+8qIRC2QzEv?=
 =?us-ascii?Q?MiNGLlWdsz0EduyGMKvSSnuWyPxK/hBnSKbLm2viMOWO2sY/a6UKsaGm4H5p?=
 =?us-ascii?Q?mOgVwbjyEmXh/SK+mA47AuEpV2NMe5lh4L+tZLUnyqFIGqO+CXnf6diOH6ht?=
 =?us-ascii?Q?k2zziziYXjnZsX0T0OJ7KkzxWh14OBy39e2JrJsf?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:06:53.8294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfea9e16-b6da-41c5-c14b-08de28d4eee2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7366

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
https://lore.kernel.org/r/20251111063819.4098701-1-aik@amd.com
https://lore.kernel.org/r/20250218111017.491719-1-aik@amd.com

This is based on sha1
f7ae6d4ec652 Dan Williams "PCI/TSM: Add 'dsm' and 'bound' attributes for dependent functions".

Please comment. Thanks.



Alexey Kardashevskiy (5):
  ccp: Make snp_reclaim_pages and __sev_do_cmd_locked public
  psp-sev: Assign numbers to all status codes and add new
  iommu/amd: Report SEV-TIO support
  crypto: ccp: Enable SEV-TIO feature in the PSP when supported
  crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)

 drivers/crypto/ccp/Kconfig          |   1 +
 drivers/crypto/ccp/Makefile         |   8 +
 drivers/crypto/ccp/sev-dev-tio.h    | 142 ++++
 drivers/crypto/ccp/sev-dev.h        |   9 +
 drivers/iommu/amd/amd_iommu_types.h |   1 +
 include/linux/amd-iommu.h           |   2 +
 include/linux/psp-sev.h             |  17 +-
 include/uapi/linux/psp-sev.h        |  66 +-
 drivers/crypto/ccp/sev-dev-tio.c    | 863 ++++++++++++++++++++
 drivers/crypto/ccp/sev-dev-tsm.c    | 405 +++++++++
 drivers/crypto/ccp/sev-dev.c        |  69 +-
 drivers/iommu/amd/init.c            |   9 +
 12 files changed, 1556 insertions(+), 36 deletions(-)
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.h
 create mode 100644 drivers/crypto/ccp/sev-dev-tio.c
 create mode 100644 drivers/crypto/ccp/sev-dev-tsm.c

-- 
2.51.1

