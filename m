Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B933BB48;
	Mon,  1 Dec 2025 04:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764565016; cv=fail; b=SshwxBsQJ97AAzo6nR9xpi1olfeDkymzi3RCIugS8Et5ejBE+ZuYbPgm/wNmdgKepT2LQwTGLyCylJWjL82mEzHdJh1OKTWZL+nhJ6m0z7jmW7mPFB00iE1r9/qpzAtqn7235piSteXwd4A2RbPuzKo1Fjjj7omZ3Ai/F5IyIAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764565016; c=relaxed/simple;
	bh=GwqrHZPjABuUNO1KG13964nJ6CKi4Yz1COBwmwvya+Q=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:CC:
	 References:From:In-Reply-To; b=T2DeVCt+D84YNFiCJBXUeq5ignwDb+uUmh7Qx5MS1LVFqR4IDFMHy/NXKQs33Tpd6QF24+IwJeIgcxcAasC/s7RQ26gMt8Sl1RapFX4Wb5czfY2VQ6QPj3LO8F4b8tF923wTLG2B4zq7rT50N0NLWveUfGgkzTMeCnQr8Ct1dSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hHX+/yry; arc=fail smtp.client-ip=52.101.85.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hHX+/yry"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X5LyIK0xhL9qNHDILWF7A+0clwGC9/6nKbRKGG3uNQTV6qlEh/v6bDZWNzy9i9wDULGusq6HrJvqUvEMvFmLq3u6O/gUMVd7dRVy7uxvQ59fVnPE9xhblTEQGxi1YFIHFQZFVRYVUyPfePZEspdd0+K2cb2D9yug2qQwFtbmB97bpnVHLicHwaic94SIS9EvnotcOo1moaEu5j5QQhLWb5iVUSMEYlq7f+scwxUVlw3Yr3pFZ8Nz3yPTWPal0+6cn4ugmPHiH96aSZ4g2G7Uqkjn31DRe0ihr9Vfje4lPQlzSlnhpv2xpRcK/6/m2Dk5XxSXk5+gHMpprJNMYs5Itg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlNnpTttk6XPxTNFHb8nfmGvIRQOA4c0qpFkOREcqpQ=;
 b=nCZ8JpF/8RoEYWiVM/nQ/naeFLuiGARlSnB7n+ZdRrzaq00irfM4qj0Y4syRpg1WK/AcWciFIIWjZyR1boQRiTWmJoQ5Ub3YItZU6DT5YIbk6rnqujKImlAvBsHf5cyjaYxdWDvNKQQVDVd1VEc1YqWSKzGwyCbUICR1sHixYHVd7VEt/w5k+OypqMxjmXQPiJgcGO8C3HGBM8YsHq6LXSkCp+gVuW+8SBvk/ADTntx1BIra2nRHye+NDuHg1Ty8QeU5tTGgPUEGQbeB9Ew9k3h8aA4GyynwFZOwYuDq/hlxae3uLHQYbHufrc5aE6IkiPvkFCdVVg/zAOc/vrSIDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlNnpTttk6XPxTNFHb8nfmGvIRQOA4c0qpFkOREcqpQ=;
 b=hHX+/yryv6eoSaU7UAMC78u9NOaUPMj5I+KIIMOiGCYxWymU+VUWZXqpCs8JPWxJ1oR9718LIJCQVqbpWKCtDYebOmWwmDeWDPGppJJWHUPk3QmA7E4a2qSX3GIj6p3l+kfFThgwjR/KRENjlB8Og2rjCAkdZrNIAcAGUB/44P4=
Received: from BN1PR14CA0020.namprd14.prod.outlook.com (2603:10b6:408:e3::25)
 by BN3PR12MB9569.namprd12.prod.outlook.com (2603:10b6:408:2ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 04:56:38 +0000
Received: from BN1PEPF00005FFE.namprd05.prod.outlook.com
 (2603:10b6:408:e3:cafe::7d) by BN1PR14CA0020.outlook.office365.com
 (2603:10b6:408:e3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 04:56:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00005FFE.mail.protection.outlook.com (10.167.243.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 04:56:38 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 30 Nov
 2025 22:56:38 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 30 Nov
 2025 22:56:36 -0600
Received: from [172.31.185.117] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 30 Nov 2025 20:56:29 -0800
Content-Type: multipart/mixed;
	boundary="------------BLLuAkKzZElrh17i1JLNc4sT"
Message-ID: <ffbe5f5f-48c6-42b0-9f62-36fb0a4f67ab@amd.com>
Date: Mon, 1 Dec 2025 10:26:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v2 5/5] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
To: Alexey Kardashevskiy <aik@amd.com>, <linux-kernel@vger.kernel.org>
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
	<amit.shah@amd.com>, Peter Gonda <pgonda@google.com>, <iommu@lists.linux.dev>
References: <20251121080629.444992-1-aik@amd.com>
 <20251121080629.444992-6-aik@amd.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20251121080629.444992-6-aik@amd.com>
Received-SPF: None (SATLEXMB03.amd.com: sraithal@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFE:EE_|BN3PR12MB9569:EE_
X-MS-Office365-Filtering-Correlation-Id: fd78ae2c-9d4a-42aa-48ad-08de3096030b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007|4053099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azJWTzNKMytrNEJzdlNTMzNNUFpaWWVJOWJPaFg2LzIrMnhTc1ZqYVgzUjZs?=
 =?utf-8?B?WjhiNjAvMjhqQmJteDE1d3NTeXlMdGRUQzhpZFlRRkh6RXZEaGswVElYSDVC?=
 =?utf-8?B?bCtqOGprSU1FSlFQMFZlZ21Ob2JBbjQxaktNN2pXb21NcTBvdUpXVDAwUFVC?=
 =?utf-8?B?NkpodWpJc2VkZGRDUkVqNGdQS3N3KzFycmxUa2pEU2grbFYzT0U3Q3VsNUcr?=
 =?utf-8?B?eEw3cXlCNXdVQ2tXTjhTL3J4TEkwUm5jTVNybE54K0RpbldnV3Z6bGpCWWZj?=
 =?utf-8?B?amZXNzg0djdRanJRdkxoUnFNZ1ZaWmtaNG54K2JIMXpkMGFYVkRGNXE3ZXJh?=
 =?utf-8?B?eHBqeFlVODgzYllGMEUrR2lNZmJEdFZ4UnVBTTd2Qlhxdk9BUG1oYWNSQUNJ?=
 =?utf-8?B?L0ZwUXdpSGZUZnczaXJaQXl6Q1FHVVFIR0RVRVlKK0pOY1lLTUs3dmFIQnpi?=
 =?utf-8?B?RHp6dlpJOS9FQkFqaVRtU1RIaldyb05NLys2WmdDejZMQmhEUGl4cUJLMTFL?=
 =?utf-8?B?bFJlUlcveGlzaU1rYWpmOHJadlk5VmZoU1ZzcTV6OC9uR0NZei9mUi9xYmF6?=
 =?utf-8?B?ekZ3YUd1bXRtYllDOURaczY4bnR5L2xadXlQV3hoNnczRnpzeTU2TzdRMDVP?=
 =?utf-8?B?dmNXYTVYS3oxWkJwSFJ5VWtuaHJWd2d5U1BoazJha0ZMZ2lSSmU3ejQ1UmU2?=
 =?utf-8?B?cGxZbXBpMElpS3l6NHVaN3lHazRyWDk3TjByQ0xGOUFEbmRGT1lCc2JPeDcz?=
 =?utf-8?B?dTdSZzJPcjlSdStDNTFDOFp3MDNNa0c0NGdLczMwdEVNT1ZNRmV3UHYyaWhr?=
 =?utf-8?B?SVVxOVA1WVduMjluRWFuQVZETnB2YmZsRTlZQUtqWjFpeTVFRG9WSEdsSDc3?=
 =?utf-8?B?NUpVbGFQaFFWQldvYjZaT1c2Nng0QzJ1UDZDamdPb3JuVXlVUlZ4UFRvd0ZJ?=
 =?utf-8?B?emlwU3NYNUFjT0pQL1RNZHJ4UVF3cXNWV3NSZGdDZTRZc0RnSnRjN1JEc01j?=
 =?utf-8?B?UkI4R0FrbW9GeDRwNnUycmZsZ0tzdWIyZjJGRllSczB1UWM4V2V4QkZPTjl3?=
 =?utf-8?B?RnhvcW1UbXh0aS9SRTkvV09vVjhaSFc2TUh3NjVWYSt2eG96cVY4eHQ1ekt2?=
 =?utf-8?B?elBrTjREWlRnNTE4b1RwTi8xY0Z5Wk11N3o1YTBzazYyRUw2R2x4dnAzdkVD?=
 =?utf-8?B?R3dBMTRlZnR6dlY4L0VVbFYySWlpUzlDZFNqWjdQYmdBa2MzaFV2VWhobmUv?=
 =?utf-8?B?dWZnWTRFSUp6VEVqNnFNd1ZEb2l0bWNzeENWb2hMZ1ZJais1dm1MdEprWjlX?=
 =?utf-8?B?YTR0WFBaa1dOWnc2UlhUaGFvSkdhbTJqUkFyWTM2UjJJVWxmdjlaR05TMXVZ?=
 =?utf-8?B?bkFRalZPNHNoMTdGNm9ZOW1Ha3QvQ0VUMFNadElHL3NjYXJRZkphVlBORnVl?=
 =?utf-8?B?bWpoeWk5Nm1tZG1yUHA0Tk5mcXpCcnN6bklndWY5L2RqVFV6bmR2TklHYTRD?=
 =?utf-8?B?QUNiNHBZclNVdHNKUHlnaHBwM2c2dGVmaDRETHFPbUFsYmNxb1NiZERBblll?=
 =?utf-8?B?cHpHdHBrZGovbWdiMGtWWVloeDZFS2Yxc3AzL2pvR0tnSUR6Wi8zd0xIR0Q1?=
 =?utf-8?B?elc4UlhlNmdMVUozR09YT21BVzkrVFFIcWRDMUU2RW05bkxFcTA0Z1FtWHZL?=
 =?utf-8?B?SnBtbHF1MXd2WHpVRVdPcTQwL1g4OFlaUnFxeTR1WFp2OVNKb1pPSnJvR2lo?=
 =?utf-8?B?K3NpYkcycEtiYXZlWm5sZDNRZnJwZlpDOU1xZEpVYUN2UHRnTlRqQ05XdjNR?=
 =?utf-8?B?NTBSZzlnM09vakFJSmw3ZzJpNEdjT0tPY2NCWkVxOG82WEVmTlZVZFh1aVcw?=
 =?utf-8?B?NXZ1dDR2amhuRGc2WWVwTHFOZGg1OUZOc1A2R0I4VVA2QmFDcDc4L0hRWExJ?=
 =?utf-8?B?WVdsR01SblFsN0ljNU5ieXFZMVhHV2lHa01nN0x1NnlQQ0hlaURkbkhBYTJB?=
 =?utf-8?B?VE9HQ0hiYTFMYkI5NVBVQUpEOXU2Qm11VkFBVy9xWDJLanNHNllYamsrVmtE?=
 =?utf-8?B?TkdYV2hVNUc2bHlWZmVXY2Vld0xIRzFtNG1XYnNJbVVaaXRuRkVMQkx0RTVF?=
 =?utf-8?Q?CMuQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007)(4053099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 04:56:38.7044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd78ae2c-9d4a-42aa-48ad-08de3096030b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9569

--------------BLLuAkKzZElrh17i1JLNc4sT
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit

Hello Alexey,

This patch, now part of linux-next[1], is breaking the build on the AMD 
platform with the attached kernel config.

Below is the build error:

..
In file included from drivers/crypto/ccp/sev-dev-tio.h:5,
                  from drivers/crypto/ccp/sev-dev.c:41:
./include/linux/pci-tsm.h: In function ‘is_pci_tsm_pf0’:
./include/linux/pci-tsm.h:152:27: error: ‘struct pci_dev’ has no member 
named ‘ide_cap’; did you mean ‘devcap’?
   152 |                 if (pdev->ide_cap || (pdev->devcap & 
PCI_EXP_DEVCAP_TEE))
       |                           ^~~~~~~
       |                           devcap
drivers/crypto/ccp/sev-dev.c: At top level:
drivers/crypto/ccp/sev-dev.c:1361:13: warning: ‘sev_tio_present’ defined 
but not used [-Wunused-function]
  1361 | static bool sev_tio_present(struct sev_device *sev)
       |             ^~~~~~~~~~~~~~~
make[5]: *** [scripts/Makefile.build:287: drivers/crypto/ccp/sev-dev.o] 
Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [scripts/Makefile.build:556: drivers/crypto/ccp] Error 2
make[3]: *** [scripts/Makefile.build:556: drivers/crypto] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:556: drivers] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/home/VT_BUILD/linux/Makefile:2054: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2
..



If the issue is fixed please add tag "Reported-by: Srikanth Aithal 
<Srikanth.Aithal@amd.com>"

[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=next-20251201 
[	next-20251201 (2c3d53debbcb99fac03e0b5ebeb1eb744ef1985e)]

On 11/21/2025 1:36 PM, Alexey Kardashevskiy wrote:
> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
> (Trust Domain In-Socket Protocol). This enables secure communication
> between trusted domains and PCIe devices through the PSP (Platform
> Security Processor).
> 
> The implementation includes:
> - Device Security Manager (DSM) operations for establishing secure links
> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
> - IDE (Integrity Data Encryption) stream management for secure PCIe
> 
> This module bridges the SEV firmware stack with the generic PCIe TSM
> framework.
> 
> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
> 
> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
> The CCP driver provides the interface to it and registers in the TSM
> subsystem.
> 
> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
> the data in the SEV-TIO-specific structs.
> 
> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> Changes:
> v2:
> * address bunch of comments from v1 (almost all)
> ---
>   drivers/crypto/ccp/Kconfig       |   1 +
>   drivers/crypto/ccp/Makefile      |   8 +
>   drivers/crypto/ccp/sev-dev-tio.h | 142 ++++
>   drivers/crypto/ccp/sev-dev.h     |   7 +
>   include/linux/psp-sev.h          |   7 +
>   drivers/crypto/ccp/sev-dev-tio.c | 863 ++++++++++++++++++++
>   drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>   drivers/crypto/ccp/sev-dev.c     |  48 +-
>   8 files changed, 1480 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f394e45e11ab..3e737d3e21c8 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -25,6 +25,7 @@ config CRYPTO_DEV_CCP_CRYPTO
>   	default m
>   	depends on CRYPTO_DEV_CCP_DD
>   	depends on CRYPTO_DEV_SP_CCP
> +	select PCI_TSM
>   	select CRYPTO_HASH
>   	select CRYPTO_SKCIPHER
>   	select CRYPTO_AUTHENC
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index a9626b30044a..839df68b70ff 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -16,6 +16,14 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                      hsti.o \
>                                      sfs.o
>   
> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),yy)
> +ccp-y += sev-dev-tsm.o sev-dev-tio.o
> +endif
> +
> +ifeq ($(CONFIG_CRYPTO_DEV_SP_PSP)$(CONFIG_PCI_TSM),my)
> +ccp-m += sev-dev-tsm.o sev-dev-tio.o
> +endif
> +
>   obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>   ccp-crypto-objs := ccp-crypto-main.o \
>   		   ccp-crypto-aes.o \
> diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
> new file mode 100644
> index 000000000000..7c42351210ef
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tio.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef __PSP_SEV_TIO_H__
> +#define __PSP_SEV_TIO_H__
> +
> +#include <linux/pci-tsm.h>
> +#include <linux/tsm.h>
> +#include <linux/pci-ide.h>
> +#include <uapi/linux/psp-sev.h>
> +
> +#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
> +
> +struct sla_addr_t {
> +	union {
> +		u64 sla;
> +		struct {
> +			u64 page_type:1;
> +			u64 page_size:1;
> +			u64 reserved1:10;
> +			u64 pfn:40;
> +			u64 reserved2:12;
> +		};
> +	};
> +} __packed;
> +
> +#define SEV_TIO_MAX_COMMAND_LENGTH	128
> +
> +/* SPDM control structure for DOE */
> +struct tsm_spdm {
> +	unsigned long req_len;
> +	void *req;
> +	unsigned long rsp_len;
> +	void *rsp;
> +};
> +
> +/* Describes TIO device */
> +struct tsm_dsm_tio {
> +	u8 cert_slot;
> +	struct sla_addr_t dev_ctx;
> +	struct sla_addr_t req;
> +	struct sla_addr_t resp;
> +	struct sla_addr_t scratch;
> +	struct sla_addr_t output;
> +	size_t output_len;
> +	size_t scratch_len;
> +	struct tsm_spdm spdm;
> +	struct sla_buffer_hdr *reqbuf; /* vmap'ed @req for DOE */
> +	struct sla_buffer_hdr *respbuf; /* vmap'ed @resp for DOE */
> +
> +	int cmd;
> +	int psp_ret;
> +	u8 cmd_data[SEV_TIO_MAX_COMMAND_LENGTH];
> +	void *data_pg; /* Data page for DEV_STATUS/TDI_STATUS/TDI_INFO/ASID_FENCE */
> +
> +#define TIO_IDE_MAX_TC	8
> +	struct pci_ide *ide[TIO_IDE_MAX_TC];
> +};
> +
> +/* Describes TSM structure for PF0 pointed by pci_dev->tsm */
> +struct tio_dsm {
> +	struct pci_tsm_pf0 tsm;
> +	struct tsm_dsm_tio data;
> +	struct sev_device *sev;
> +};
> +
> +/* Data object IDs */
> +#define SPDM_DOBJ_ID_NONE		0
> +#define SPDM_DOBJ_ID_REQ		1
> +#define SPDM_DOBJ_ID_RESP		2
> +
> +struct spdm_dobj_hdr {
> +	u32 id;     /* Data object type identifier */
> +	u32 length; /* Length of the data object, INCLUDING THIS HEADER */
> +	union {
> +		u16 ver; /* Version of the data object structure */
> +		struct {
> +			u8 minor;
> +			u8 major;
> +		} version;
> +	};
> +} __packed;
> +
> +/**
> + * struct sev_tio_status - TIO_STATUS command's info_paddr buffer
> + *
> + * @length: Length of this structure in bytes
> + * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
> + * @tio_init_done: Indicates TIO_INIT has been invoked
> + * @spdm_req_size_min: Minimum SPDM request buffer size in bytes
> + * @spdm_req_size_max: Maximum SPDM request buffer size in bytes
> + * @spdm_scratch_size_min: Minimum SPDM scratch buffer size in bytes
> + * @spdm_scratch_size_max: Maximum SPDM scratch buffer size in bytes
> + * @spdm_out_size_min: Minimum SPDM output buffer size in bytes
> + * @spdm_out_size_max: Maximum for the SPDM output buffer size in bytes
> + * @spdm_rsp_size_min: Minimum SPDM response buffer size in bytes
> + * @spdm_rsp_size_max: Maximum SPDM response buffer size in bytes
> + * @devctx_size: Size of a device context buffer in bytes
> + * @tdictx_size: Size of a TDI context buffer in bytes
> + * @tio_crypto_alg: TIO crypto algorithms supported
> + */
> +struct sev_tio_status {
> +	u32 length;
> +	union {
> +		u32 flags;
> +		struct {
> +			u32 tio_en:1;
> +			u32 tio_init_done:1;
> +		};
> +	};
> +	u32 spdm_req_size_min;
> +	u32 spdm_req_size_max;
> +	u32 spdm_scratch_size_min;
> +	u32 spdm_scratch_size_max;
> +	u32 spdm_out_size_min;
> +	u32 spdm_out_size_max;
> +	u32 spdm_rsp_size_min;
> +	u32 spdm_rsp_size_max;
> +	u32 devctx_size;
> +	u32 tdictx_size;
> +	u32 tio_crypto_alg;
> +	u8 reserved[12];
> +} __packed;
> +
> +int sev_tio_init_locked(void *tio_status_page);
> +int sev_tio_continue(struct tsm_dsm_tio *dev_data);
> +
> +int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id, u16 root_port_id,
> +		       u8 segment_id);
> +int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot);
> +int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
> +int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
> +
> +#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
> +
> +#if defined(CONFIG_PCI_TSM)
> +void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
> +void sev_tsm_uninit(struct sev_device *sev);
> +int sev_tio_cmd_buffer_len(int cmd);
> +#else
> +static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
> +#endif
> +
> +#endif	/* __PSP_SEV_TIO_H__ */
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index b9029506383f..dced4a8e9f01 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -34,6 +34,8 @@ struct sev_misc_dev {
>   	struct miscdevice misc;
>   };
>   
> +struct sev_tio_status;
> +
>   struct sev_device {
>   	struct device *dev;
>   	struct psp_device *psp;
> @@ -61,6 +63,11 @@ struct sev_device {
>   
>   	struct sev_user_data_snp_status snp_plat_status;
>   	struct snp_feature_info snp_feat_info_0;
> +
> +#if defined(CONFIG_PCI_TSM)
> +	struct tsm_dev *tsmdev;
> +	struct sev_tio_status *tio_status;
> +#endif
>   };
>   
>   int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index c0c817ca3615..cce864dbf281 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -109,6 +109,13 @@ enum sev_cmd {
>   	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
>   	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>   
> +	/* SEV-TIO commands */
> +	SEV_CMD_TIO_STATUS		= 0x0D0,
> +	SEV_CMD_TIO_INIT		= 0x0D1,
> +	SEV_CMD_TIO_DEV_CREATE		= 0x0D2,
> +	SEV_CMD_TIO_DEV_RECLAIM		= 0x0D3,
> +	SEV_CMD_TIO_DEV_CONNECT		= 0x0D4,
> +	SEV_CMD_TIO_DEV_DISCONNECT	= 0x0D5,
>   	SEV_CMD_MAX,
>   };
>   
> diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
> new file mode 100644
> index 000000000000..f7b2a515aae7
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tio.c
> @@ -0,0 +1,863 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +// Interface to PSP for CCP/SEV-TIO/SNP-VM
> +
> +#include <linux/pci.h>
> +#include <linux/tsm.h>
> +#include <linux/psp.h>
> +#include <linux/vmalloc.h>
> +#include <linux/bitfield.h>
> +#include <linux/pci-doe.h>
> +#include <asm/sev-common.h>
> +#include <asm/sev.h>
> +#include <asm/page.h>
> +#include "sev-dev.h"
> +#include "sev-dev-tio.h"
> +
> +#define to_tio_status(dev_data)	\
> +		(container_of((dev_data), struct tio_dsm, data)->sev->tio_status)
> +
> +#define SLA_PAGE_TYPE_DATA	0
> +#define SLA_PAGE_TYPE_SCATTER	1
> +#define SLA_PAGE_SIZE_4K	0
> +#define SLA_PAGE_SIZE_2M	1
> +#define SLA_SZ(s)		((s).page_size == SLA_PAGE_SIZE_2M ? SZ_2M : SZ_4K)
> +#define SLA_SCATTER_LEN(s)	(SLA_SZ(s) / sizeof(struct sla_addr_t))
> +#define SLA_EOL			((struct sla_addr_t) { .pfn = ((1UL << 40) - 1) })
> +#define SLA_NULL		((struct sla_addr_t) { 0 })
> +#define IS_SLA_NULL(s)		((s).sla == SLA_NULL.sla)
> +#define IS_SLA_EOL(s)		((s).sla == SLA_EOL.sla)
> +
> +static phys_addr_t sla_to_pa(struct sla_addr_t sla)
> +{
> +	u64 pfn = sla.pfn;
> +	u64 pa = pfn << PAGE_SHIFT;
> +
> +	return pa;
> +}
> +
> +static void *sla_to_va(struct sla_addr_t sla)
> +{
> +	void *va = __va(__sme_clr(sla_to_pa(sla)));
> +
> +	return va;
> +}
> +
> +#define sla_to_pfn(sla)		(__pa(sla_to_va(sla)) >> PAGE_SHIFT)
> +#define sla_to_page(sla)	virt_to_page(sla_to_va(sla))
> +
> +static struct sla_addr_t make_sla(struct page *pg, bool stp)
> +{
> +	u64 pa = __sme_set(page_to_phys(pg));
> +	struct sla_addr_t ret = {
> +		.pfn = pa >> PAGE_SHIFT,
> +		.page_size = SLA_PAGE_SIZE_4K, /* Do not do SLA_PAGE_SIZE_2M ATM */
> +		.page_type = stp ? SLA_PAGE_TYPE_SCATTER : SLA_PAGE_TYPE_DATA
> +	};
> +
> +	return ret;
> +}
> +
> +/* the BUFFER Structure */
> +#define SLA_BUFFER_FLAG_ENCRYPTION	BIT(0)
> +
> +/**
> + * struct sla_buffer_hdr - Scatter list address buffer header
> + *
> + * @capacity_sz: Total capacity of the buffer in bytes
> + * @payload_sz: Size of buffer payload in bytes, must be multiple of 32B
> + * @flags: Buffer flags (SLA_BUFFER_FLAG_ENCRYPTION: buffer is encrypted)
> + * @iv: Initialization vector used for encryption
> + * @authtag: Authentication tag for encrypted buffer
> + */
> +struct sla_buffer_hdr {
> +	u32 capacity_sz;
> +	u32 payload_sz; /* The size of BUFFER_PAYLOAD in bytes. Must be multiple of 32B */
> +	u32 flags;
> +	u8 reserved1[4];
> +	u8 iv[16];	/* IV used for the encryption of this buffer */
> +	u8 authtag[16]; /* Authentication tag for this buffer */
> +	u8 reserved2[16];
> +} __packed;
> +
> +enum spdm_data_type_t {
> +	DOBJ_DATA_TYPE_SPDM = 0x1,
> +	DOBJ_DATA_TYPE_SECURE_SPDM = 0x2,
> +};
> +
> +struct spdm_dobj_hdr_req {
> +	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_REQ */
> +	u8 data_type; /* spdm_data_type_t */
> +	u8 reserved2[5];
> +} __packed;
> +
> +struct spdm_dobj_hdr_resp {
> +	struct spdm_dobj_hdr hdr; /* hdr.id == SPDM_DOBJ_ID_RESP */
> +	u8 data_type; /* spdm_data_type_t */
> +	u8 reserved2[5];
> +} __packed;
> +
> +/* Defined in sev-dev-tio.h so sev-dev-tsm.c can read types of blobs */
> +struct spdm_dobj_hdr_cert;
> +struct spdm_dobj_hdr_meas;
> +struct spdm_dobj_hdr_report;
> +
> +/* Used in all SPDM-aware TIO commands */
> +struct spdm_ctrl {
> +	struct sla_addr_t req;
> +	struct sla_addr_t resp;
> +	struct sla_addr_t scratch;
> +	struct sla_addr_t output;
> +} __packed;
> +
> +static size_t sla_dobj_id_to_size(u8 id)
> +{
> +	size_t n;
> +
> +	BUILD_BUG_ON(sizeof(struct spdm_dobj_hdr_resp) != 0x10);
> +	switch (id) {
> +	case SPDM_DOBJ_ID_REQ:
> +		n = sizeof(struct spdm_dobj_hdr_req);
> +		break;
> +	case SPDM_DOBJ_ID_RESP:
> +		n = sizeof(struct spdm_dobj_hdr_resp);
> +		break;
> +	default:
> +		WARN_ON(1);
> +		n = 0;
> +		break;
> +	}
> +
> +	return n;
> +}
> +
> +#define SPDM_DOBJ_HDR_SIZE(hdr)		sla_dobj_id_to_size((hdr)->id)
> +#define SPDM_DOBJ_DATA(hdr)		((u8 *)(hdr) + SPDM_DOBJ_HDR_SIZE(hdr))
> +#define SPDM_DOBJ_LEN(hdr)		((hdr)->length - SPDM_DOBJ_HDR_SIZE(hdr))
> +
> +#define sla_to_dobj_resp_hdr(buf)	((struct spdm_dobj_hdr_resp *) \
> +					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_RESP))
> +#define sla_to_dobj_req_hdr(buf)	((struct spdm_dobj_hdr_req *) \
> +					sla_to_dobj_hdr_check((buf), SPDM_DOBJ_ID_REQ))
> +
> +static struct spdm_dobj_hdr *sla_to_dobj_hdr(struct sla_buffer_hdr *buf)
> +{
> +	if (!buf)
> +		return NULL;
> +
> +	return (struct spdm_dobj_hdr *) &buf[1];
> +}
> +
> +static struct spdm_dobj_hdr *sla_to_dobj_hdr_check(struct sla_buffer_hdr *buf, u32 check_dobjid)
> +{
> +	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
> +
> +	if (WARN_ON_ONCE(!hdr))
> +		return NULL;
> +
> +	if (hdr->id != check_dobjid) {
> +		pr_err("! ERROR: expected %d, found %d\n", check_dobjid, hdr->id);
> +		return NULL;
> +	}
> +
> +	return hdr;
> +}
> +
> +static void *sla_to_data(struct sla_buffer_hdr *buf, u32 dobjid)
> +{
> +	struct spdm_dobj_hdr *hdr = sla_to_dobj_hdr(buf);
> +
> +	if (WARN_ON_ONCE(dobjid != SPDM_DOBJ_ID_REQ && dobjid != SPDM_DOBJ_ID_RESP))
> +		return NULL;
> +
> +	if (!hdr)
> +		return NULL;
> +
> +	return (u8 *) hdr + sla_dobj_id_to_size(dobjid);
> +}
> +
> +/**
> + * struct sev_data_tio_status - SEV_CMD_TIO_STATUS command
> + *
> + * @length: Length of this command buffer in bytes
> + * @status_paddr: System physical address of the TIO_STATUS structure
> + */
> +struct sev_data_tio_status {
> +	u32 length;
> +	u8 reserved[4];
> +	u64 status_paddr;
> +} __packed;
> +
> +/* TIO_INIT */
> +struct sev_data_tio_init {
> +	u32 length;
> +	u8 reserved[12];
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_create - TIO_DEV_CREATE command
> + *
> + * @length: Length in bytes of this command buffer
> + * @dev_ctx_sla: Scatter list address pointing to a buffer to be used as a device context buffer
> + * @device_id: PCIe Routing Identifier of the device to connect to
> + * @root_port_id: PCIe Routing Identifier of the root port of the device
> + * @segment_id: PCIe Segment Identifier of the device to connect to
> + */
> +struct sev_data_tio_dev_create {
> +	u32 length;
> +	u8 reserved1[4];
> +	struct sla_addr_t dev_ctx_sla;
> +	u16 device_id;
> +	u16 root_port_id;
> +	u8 segment_id;
> +	u8 reserved2[11];
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_connect - TIO_DEV_CONNECT command
> + *
> + * @length: Length in bytes of this command buffer
> + * @spdm_ctrl: SPDM control structure defined in Section 5.1
> + * @dev_ctx_sla: Scatter list address of the device context buffer
> + * @tc_mask: Bitmask of the traffic classes to initialize for SEV-TIO usage.
> + *           Setting the kth bit of the TC_MASK to 1 indicates that the traffic
> + *           class k will be initialized
> + * @cert_slot: Slot number of the certificate requested for constructing the SPDM session
> + * @ide_stream_id: IDE stream IDs to be associated with this device.
> + *                 Valid only if corresponding bit in TC_MASK is set
> + */
> +struct sev_data_tio_dev_connect {
> +	u32 length;
> +	u8 reserved1[4];
> +	struct spdm_ctrl spdm_ctrl;
> +	u8 reserved2[8];
> +	struct sla_addr_t dev_ctx_sla;
> +	u8 tc_mask;
> +	u8 cert_slot;
> +	u8 reserved3[6];
> +	u8 ide_stream_id[8];
> +	u8 reserved4[8];
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_disconnect - TIO_DEV_DISCONNECT command
> + *
> + * @length: Length in bytes of this command buffer
> + * @flags: Command flags (TIO_DEV_DISCONNECT_FLAG_FORCE: force disconnect)
> + * @spdm_ctrl: SPDM control structure defined in Section 5.1
> + * @dev_ctx_sla: Scatter list address of the device context buffer
> + */
> +#define TIO_DEV_DISCONNECT_FLAG_FORCE	BIT(0)
> +
> +struct sev_data_tio_dev_disconnect {
> +	u32 length;
> +	u32 flags;
> +	struct spdm_ctrl spdm_ctrl;
> +	struct sla_addr_t dev_ctx_sla;
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_meas - TIO_DEV_MEASUREMENTS command
> + *
> + * @length: Length in bytes of this command buffer
> + * @flags: Command flags (TIO_DEV_MEAS_FLAG_RAW_BITSTREAM: request raw measurements)
> + * @spdm_ctrl: SPDM control structure defined in Section 5.1
> + * @dev_ctx_sla: Scatter list address of the device context buffer
> + * @meas_nonce: Nonce for measurement freshness verification
> + */
> +#define TIO_DEV_MEAS_FLAG_RAW_BITSTREAM	BIT(0)
> +
> +struct sev_data_tio_dev_meas {
> +	u32 length;
> +	u32 flags;
> +	struct spdm_ctrl spdm_ctrl;
> +	struct sla_addr_t dev_ctx_sla;
> +	u8 meas_nonce[32];
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_certs - TIO_DEV_CERTIFICATES command
> + *
> + * @length: Length in bytes of this command buffer
> + * @spdm_ctrl: SPDM control structure defined in Section 5.1
> + * @dev_ctx_sla: Scatter list address of the device context buffer
> + */
> +struct sev_data_tio_dev_certs {
> +	u32 length;
> +	u8 reserved[4];
> +	struct spdm_ctrl spdm_ctrl;
> +	struct sla_addr_t dev_ctx_sla;
> +} __packed;
> +
> +/**
> + * struct sev_data_tio_dev_reclaim - TIO_DEV_RECLAIM command
> + *
> + * @length: Length in bytes of this command buffer
> + * @dev_ctx_sla: Scatter list address of the device context buffer
> + *
> + * This command reclaims resources associated with a device context.
> + */
> +struct sev_data_tio_dev_reclaim {
> +	u32 length;
> +	u8 reserved[4];
> +	struct sla_addr_t dev_ctx_sla;
> +} __packed;
> +
> +static struct sla_buffer_hdr *sla_buffer_map(struct sla_addr_t sla)
> +{
> +	struct sla_buffer_hdr *buf;
> +
> +	BUILD_BUG_ON(sizeof(struct sla_buffer_hdr) != 0x40);
> +	if (IS_SLA_NULL(sla))
> +		return NULL;
> +
> +	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
> +		struct sla_addr_t *scatter = sla_to_va(sla);
> +		unsigned int i, npages = 0;
> +
> +		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
> +			if (WARN_ON_ONCE(SLA_SZ(scatter[i]) > SZ_4K))
> +				return NULL;
> +
> +			if (WARN_ON_ONCE(scatter[i].page_type == SLA_PAGE_TYPE_SCATTER))
> +				return NULL;
> +
> +			if (IS_SLA_EOL(scatter[i])) {
> +				npages = i;
> +				break;
> +			}
> +		}
> +		if (WARN_ON_ONCE(!npages))
> +			return NULL;
> +
> +		struct page **pp = kmalloc_array(npages, sizeof(pp[0]), GFP_KERNEL);
> +		if (!pp)
> +			return NULL;
> +
> +		for (i = 0; i < npages; ++i)
> +			pp[i] = sla_to_page(scatter[i]);
> +
> +		buf = vm_map_ram(pp, npages, 0);
> +		kfree(pp);
> +	} else {
> +		struct page *pg = sla_to_page(sla);
> +
> +		buf = vm_map_ram(&pg, 1, 0);
> +	}
> +
> +	return buf;
> +}
> +
> +static void sla_buffer_unmap(struct sla_addr_t sla, struct sla_buffer_hdr *buf)
> +{
> +	if (!buf)
> +		return;
> +
> +	if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
> +		struct sla_addr_t *scatter = sla_to_va(sla);
> +		unsigned int i, npages = 0;
> +
> +		for (i = 0; i < SLA_SCATTER_LEN(sla); ++i) {
> +			if (IS_SLA_EOL(scatter[i])) {
> +				npages = i;
> +				break;
> +			}
> +		}
> +		if (!npages)
> +			return;
> +
> +		vm_unmap_ram(buf, npages);
> +	} else {
> +		vm_unmap_ram(buf, 1);
> +	}
> +}
> +
> +static void dobj_response_init(struct sla_buffer_hdr *buf)
> +{
> +	struct spdm_dobj_hdr *dobj = sla_to_dobj_hdr(buf);
> +
> +	dobj->id = SPDM_DOBJ_ID_RESP;
> +	dobj->version.major = 0x1;
> +	dobj->version.minor = 0;
> +	dobj->length = 0;
> +	buf->payload_sz = sla_dobj_id_to_size(dobj->id) + dobj->length;
> +}
> +
> +static void sla_free(struct sla_addr_t sla, size_t len, bool firmware_state)
> +{
> +	unsigned int npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +	struct sla_addr_t *scatter = NULL;
> +	int ret = 0, i;
> +
> +	if (IS_SLA_NULL(sla))
> +		return;
> +
> +	if (firmware_state) {
> +		if (sla.page_type == SLA_PAGE_TYPE_SCATTER) {
> +			scatter = sla_to_va(sla);
> +
> +			for (i = 0; i < npages; ++i) {
> +				if (IS_SLA_EOL(scatter[i]))
> +					break;
> +
> +				ret = snp_reclaim_pages(sla_to_pa(scatter[i]), 1, false);
> +				if (ret)
> +					break;
> +			}
> +		} else {
> +			ret = snp_reclaim_pages(sla_to_pa(sla), 1, false);
> +		}
> +	}
> +
> +	if (WARN_ON(ret))
> +		return;
> +
> +	if (scatter) {
> +		for (i = 0; i < npages; ++i) {
> +			if (IS_SLA_EOL(scatter[i]))
> +				break;
> +			free_page((unsigned long)sla_to_va(scatter[i]));
> +		}
> +	}
> +
> +	free_page((unsigned long)sla_to_va(sla));
> +}
> +
> +static struct sla_addr_t sla_alloc(size_t len, bool firmware_state)
> +{
> +	unsigned long i, npages = PAGE_ALIGN(len) >> PAGE_SHIFT;
> +	struct sla_addr_t *scatter = NULL;
> +	struct sla_addr_t ret = SLA_NULL;
> +	struct sla_buffer_hdr *buf;
> +	struct page *pg;
> +
> +	if (npages == 0)
> +		return ret;
> +
> +	if (WARN_ON_ONCE(npages > ((PAGE_SIZE / sizeof(struct sla_addr_t)) + 1)))
> +		return ret;
> +
> +	BUILD_BUG_ON(PAGE_SIZE < SZ_4K);
> +
> +	if (npages > 1) {
> +		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +		if (!pg)
> +			return SLA_NULL;
> +
> +		ret = make_sla(pg, true);
> +		scatter = page_to_virt(pg);
> +		for (i = 0; i < npages; ++i) {
> +			pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +			if (!pg)
> +				goto no_reclaim_exit;
> +
> +			scatter[i] = make_sla(pg, false);
> +		}
> +		scatter[i] = SLA_EOL;
> +	} else {
> +		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +		if (!pg)
> +			return SLA_NULL;
> +
> +		ret = make_sla(pg, false);
> +	}
> +
> +	buf = sla_buffer_map(ret);
> +	if (!buf)
> +		goto no_reclaim_exit;
> +
> +	buf->capacity_sz = (npages << PAGE_SHIFT);
> +	sla_buffer_unmap(ret, buf);
> +
> +	if (firmware_state) {
> +		if (scatter) {
> +			for (i = 0; i < npages; ++i) {
> +				if (rmp_make_private(sla_to_pfn(scatter[i]), 0,
> +						     PG_LEVEL_4K, 0, true))
> +					goto free_exit;
> +			}
> +		} else {
> +			if (rmp_make_private(sla_to_pfn(ret), 0, PG_LEVEL_4K, 0, true))
> +				goto no_reclaim_exit;
> +		}
> +	}
> +
> +	return ret;
> +
> +no_reclaim_exit:
> +	firmware_state = false;
> +free_exit:
> +	sla_free(ret, len, firmware_state);
> +	return SLA_NULL;
> +}
> +
> +/* Expands a buffer, only firmware owned buffers allowed for now */
> +static int sla_expand(struct sla_addr_t *sla, size_t *len)
> +{
> +	struct sla_buffer_hdr *oldbuf = sla_buffer_map(*sla), *newbuf;
> +	struct sla_addr_t oldsla = *sla, newsla;
> +	size_t oldlen = *len, newlen;
> +
> +	if (!oldbuf)
> +		return -EFAULT;
> +
> +	newlen = oldbuf->capacity_sz;
> +	if (oldbuf->capacity_sz == oldlen) {
> +		/* This buffer does not require expansion, must be another buffer */
> +		sla_buffer_unmap(oldsla, oldbuf);
> +		return 1;
> +	}
> +
> +	pr_notice("Expanding BUFFER from %ld to %ld bytes\n", oldlen, newlen);
> +
> +	newsla = sla_alloc(newlen, true);
> +	if (IS_SLA_NULL(newsla))
> +		return -ENOMEM;
> +
> +	newbuf = sla_buffer_map(newsla);
> +	if (!newbuf) {
> +		sla_free(newsla, newlen, true);
> +		return -EFAULT;
> +	}
> +
> +	memcpy(newbuf, oldbuf, oldlen);
> +
> +	sla_buffer_unmap(newsla, newbuf);
> +	sla_free(oldsla, oldlen, true);
> +	*sla = newsla;
> +	*len = newlen;
> +
> +	return 0;
> +}
> +
> +static int sev_tio_do_cmd(int cmd, void *data, size_t data_len, int *psp_ret,
> +			  struct tsm_dsm_tio *dev_data)
> +{
> +	int rc;
> +
> +	*psp_ret = 0;
> +	rc = sev_do_cmd(cmd, data, psp_ret);
> +
> +	if (WARN_ON(!rc && *psp_ret == SEV_RET_SPDM_REQUEST))
> +		return -EIO;
> +
> +	if (rc == 0 && *psp_ret == SEV_RET_EXPAND_BUFFER_LENGTH_REQUEST) {
> +		int rc1, rc2;
> +
> +		rc1 = sla_expand(&dev_data->output, &dev_data->output_len);
> +		if (rc1 < 0)
> +			return rc1;
> +
> +		rc2 = sla_expand(&dev_data->scratch, &dev_data->scratch_len);
> +		if (rc2 < 0)
> +			return rc2;
> +
> +		if (!rc1 && !rc2)
> +			/* Neither buffer requires expansion, this is wrong */
> +			return -EFAULT;
> +
> +		*psp_ret = 0;
> +		rc = sev_do_cmd(cmd, data, psp_ret);
> +	}
> +
> +	if ((rc == 0 || rc == -EIO) && *psp_ret == SEV_RET_SPDM_REQUEST) {
> +		struct spdm_dobj_hdr_resp *resp_hdr;
> +		struct spdm_dobj_hdr_req *req_hdr;
> +		struct sev_tio_status *tio_status = to_tio_status(dev_data);
> +		size_t resp_len = tio_status->spdm_req_size_max -
> +			(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) + sizeof(struct sla_buffer_hdr));
> +
> +		if (!dev_data->cmd) {
> +			if (WARN_ON_ONCE(!data_len || (data_len != *(u32 *) data)))
> +				return -EINVAL;
> +			if (WARN_ON(data_len > sizeof(dev_data->cmd_data)))
> +				return -EFAULT;
> +			memcpy(dev_data->cmd_data, data, data_len);
> +			memset(&dev_data->cmd_data[data_len], 0xFF,
> +			       sizeof(dev_data->cmd_data) - data_len);
> +			dev_data->cmd = cmd;
> +		}
> +
> +		req_hdr = sla_to_dobj_req_hdr(dev_data->reqbuf);
> +		resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
> +		switch (req_hdr->data_type) {
> +		case DOBJ_DATA_TYPE_SPDM:
> +			rc = PCI_DOE_FEATURE_CMA;
> +			break;
> +		case DOBJ_DATA_TYPE_SECURE_SPDM:
> +			rc = PCI_DOE_FEATURE_SSESSION;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +		resp_hdr->data_type = req_hdr->data_type;
> +		dev_data->spdm.req_len = req_hdr->hdr.length -
> +			sla_dobj_id_to_size(SPDM_DOBJ_ID_REQ);
> +		dev_data->spdm.rsp_len = resp_len;
> +	} else if (dev_data && dev_data->cmd) {
> +		/* For either error or success just stop the bouncing */
> +		memset(dev_data->cmd_data, 0, sizeof(dev_data->cmd_data));
> +		dev_data->cmd = 0;
> +	}
> +
> +	return rc;
> +}
> +
> +int sev_tio_continue(struct tsm_dsm_tio *dev_data)
> +{
> +	struct spdm_dobj_hdr_resp *resp_hdr;
> +	int ret;
> +
> +	if (!dev_data || !dev_data->cmd)
> +		return -EINVAL;
> +
> +	resp_hdr = sla_to_dobj_resp_hdr(dev_data->respbuf);
> +	resp_hdr->hdr.length = ALIGN(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
> +				     dev_data->spdm.rsp_len, 32);
> +	dev_data->respbuf->payload_sz = resp_hdr->hdr.length;
> +
> +	ret = sev_tio_do_cmd(dev_data->cmd, dev_data->cmd_data, 0,
> +			     &dev_data->psp_ret, dev_data);
> +	if (ret)
> +		return ret;
> +
> +	if (dev_data->psp_ret != SEV_RET_SUCCESS)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static void spdm_ctrl_init(struct spdm_ctrl *ctrl, struct tsm_dsm_tio *dev_data)
> +{
> +	ctrl->req = dev_data->req;
> +	ctrl->resp = dev_data->resp;
> +	ctrl->scratch = dev_data->scratch;
> +	ctrl->output = dev_data->output;
> +}
> +
> +static void spdm_ctrl_free(struct tsm_dsm_tio *dev_data)
> +{
> +	struct sev_tio_status *tio_status = to_tio_status(dev_data);
> +	size_t len = tio_status->spdm_req_size_max -
> +		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
> +		 sizeof(struct sla_buffer_hdr));
> +	struct tsm_spdm *spdm = &dev_data->spdm;
> +
> +	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
> +	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
> +	spdm->rsp = NULL;
> +	spdm->req = NULL;
> +	sla_free(dev_data->req, len, true);
> +	sla_free(dev_data->resp, len, false);
> +	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
> +
> +	dev_data->req.sla = 0;
> +	dev_data->resp.sla = 0;
> +	dev_data->scratch.sla = 0;
> +	dev_data->respbuf = NULL;
> +	dev_data->reqbuf = NULL;
> +	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
> +}
> +
> +static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
> +{
> +	struct sev_tio_status *tio_status = to_tio_status(dev_data);
> +	struct tsm_spdm *spdm = &dev_data->spdm;
> +	int ret;
> +
> +	dev_data->req = sla_alloc(tio_status->spdm_req_size_max, true);
> +	dev_data->resp = sla_alloc(tio_status->spdm_req_size_max, false);
> +	dev_data->scratch_len = tio_status->spdm_scratch_size_max;
> +	dev_data->scratch = sla_alloc(dev_data->scratch_len, true);
> +	dev_data->output_len = tio_status->spdm_out_size_max;
> +	dev_data->output = sla_alloc(dev_data->output_len, true);
> +
> +	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
> +	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
> +		ret = -ENOMEM;
> +		goto free_spdm_exit;
> +	}
> +
> +	dev_data->reqbuf = sla_buffer_map(dev_data->req);
> +	dev_data->respbuf = sla_buffer_map(dev_data->resp);
> +	if (!dev_data->reqbuf || !dev_data->respbuf) {
> +		ret = -EFAULT;
> +		goto free_spdm_exit;
> +	}
> +
> +	spdm->req = sla_to_data(dev_data->reqbuf, SPDM_DOBJ_ID_REQ);
> +	spdm->rsp = sla_to_data(dev_data->respbuf, SPDM_DOBJ_ID_RESP);
> +	if (!spdm->req || !spdm->rsp) {
> +		ret = -EFAULT;
> +		goto free_spdm_exit;
> +	}
> +
> +	dobj_response_init(dev_data->respbuf);
> +
> +	return 0;
> +
> +free_spdm_exit:
> +	spdm_ctrl_free(dev_data);
> +	return ret;
> +}
> +
> +int sev_tio_init_locked(void *tio_status_page)
> +{
> +	struct sev_tio_status *tio_status = tio_status_page;
> +	struct sev_data_tio_status data_status = {
> +		.length = sizeof(data_status),
> +	};
> +	int ret, psp_ret;
> +
> +	data_status.status_paddr = __psp_pa(tio_status_page);
> +	ret = __sev_do_cmd_locked(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
> +	if (ret)
> +		return ret;
> +
> +	if (tio_status->length < offsetofend(struct sev_tio_status, tdictx_size) ||
> +	    tio_status->flags & 0xFFFFFF00)
> +		return -EFAULT;
> +
> +	if (!tio_status->tio_en && !tio_status->tio_init_done)
> +		return -ENOENT;
> +
> +	if (tio_status->tio_init_done)
> +		return -EBUSY;
> +
> +	struct sev_data_tio_init ti = { .length = sizeof(ti) };
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_TIO_INIT, &ti, &psp_ret);
> +	if (ret)
> +		return ret;
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_TIO_STATUS, &data_status, &psp_ret);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
> +		       u16 root_port_id, u8 segment_id)
> +{
> +	struct sev_tio_status *tio_status = to_tio_status(dev_data);
> +	struct sev_data_tio_dev_create create = {
> +		.length = sizeof(create),
> +		.device_id = device_id,
> +		.root_port_id = root_port_id,
> +		.segment_id = segment_id,
> +	};
> +	void *data_pg;
> +	int ret;
> +
> +	dev_data->dev_ctx = sla_alloc(tio_status->devctx_size, true);
> +	if (IS_SLA_NULL(dev_data->dev_ctx))
> +		return -ENOMEM;
> +
> +	data_pg = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> +	if (!data_pg) {
> +		ret = -ENOMEM;
> +		goto free_ctx_exit;
> +	}
> +
> +	create.dev_ctx_sla = dev_data->dev_ctx;
> +	ret = sev_do_cmd(SEV_CMD_TIO_DEV_CREATE, &create, &dev_data->psp_ret);
> +	if (ret)
> +		goto free_data_pg_exit;
> +
> +	dev_data->data_pg = data_pg;
> +
> +	return 0;
> +
> +free_data_pg_exit:
> +	snp_free_firmware_page(data_pg);
> +free_ctx_exit:
> +	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
> +	return ret;
> +}
> +
> +int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data)
> +{
> +	struct sev_tio_status *tio_status = to_tio_status(dev_data);
> +	struct sev_data_tio_dev_reclaim r = {
> +		.length = sizeof(r),
> +		.dev_ctx_sla = dev_data->dev_ctx,
> +	};
> +	int ret;
> +
> +	if (dev_data->data_pg) {
> +		snp_free_firmware_page(dev_data->data_pg);
> +		dev_data->data_pg = NULL;
> +	}
> +
> +	if (IS_SLA_NULL(dev_data->dev_ctx))
> +		return 0;
> +
> +	ret = sev_do_cmd(SEV_CMD_TIO_DEV_RECLAIM, &r, &dev_data->psp_ret);
> +
> +	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
> +	dev_data->dev_ctx = SLA_NULL;
> +
> +	spdm_ctrl_free(dev_data);
> +
> +	return ret;
> +}
> +
> +int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8 cert_slot)
> +{
> +	struct sev_data_tio_dev_connect connect = {
> +		.length = sizeof(connect),
> +		.tc_mask = tc_mask,
> +		.cert_slot = cert_slot,
> +		.dev_ctx_sla = dev_data->dev_ctx,
> +		.ide_stream_id = {
> +			ids[0], ids[1], ids[2], ids[3],
> +			ids[4], ids[5], ids[6], ids[7]
> +		},
> +	};
> +	int ret;
> +
> +	if (WARN_ON(IS_SLA_NULL(dev_data->dev_ctx)))
> +		return -EFAULT;
> +	if (!(tc_mask & 1))
> +		return -EINVAL;
> +
> +	ret = spdm_ctrl_alloc(dev_data);
> +	if (ret)
> +		return ret;
> +
> +	spdm_ctrl_init(&connect.spdm_ctrl, dev_data);
> +
> +	return sev_tio_do_cmd(SEV_CMD_TIO_DEV_CONNECT, &connect, sizeof(connect),
> +			      &dev_data->psp_ret, dev_data);
> +}
> +
> +int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force)
> +{
> +	struct sev_data_tio_dev_disconnect dc = {
> +		.length = sizeof(dc),
> +		.dev_ctx_sla = dev_data->dev_ctx,
> +		.flags = force ? TIO_DEV_DISCONNECT_FLAG_FORCE : 0,
> +	};
> +
> +	if (WARN_ON_ONCE(IS_SLA_NULL(dev_data->dev_ctx)))
> +		return -EFAULT;
> +
> +	spdm_ctrl_init(&dc.spdm_ctrl, dev_data);
> +
> +	return sev_tio_do_cmd(SEV_CMD_TIO_DEV_DISCONNECT, &dc, sizeof(dc),
> +			      &dev_data->psp_ret, dev_data);
> +}
> +
> +int sev_tio_cmd_buffer_len(int cmd)
> +{
> +	switch (cmd) {
> +	case SEV_CMD_TIO_STATUS:		return sizeof(struct sev_data_tio_status);
> +	case SEV_CMD_TIO_INIT:			return sizeof(struct sev_data_tio_init);
> +	case SEV_CMD_TIO_DEV_CREATE:		return sizeof(struct sev_data_tio_dev_create);
> +	case SEV_CMD_TIO_DEV_RECLAIM:		return sizeof(struct sev_data_tio_dev_reclaim);
> +	case SEV_CMD_TIO_DEV_CONNECT:		return sizeof(struct sev_data_tio_dev_connect);
> +	case SEV_CMD_TIO_DEV_DISCONNECT:	return sizeof(struct sev_data_tio_dev_disconnect);
> +	default:				return 0;
> +	}
> +}
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> new file mode 100644
> index 000000000000..ea29cd5d0ff9
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -0,0 +1,405 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +// Interface to CCP/SEV-TIO for generic PCIe TDISP module
> +
> +#include <linux/pci.h>
> +#include <linux/device.h>
> +#include <linux/tsm.h>
> +#include <linux/iommu.h>
> +#include <linux/pci-doe.h>
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +
> +#include <asm/sev-common.h>
> +#include <asm/sev.h>
> +
> +#include "psp-dev.h"
> +#include "sev-dev.h"
> +#include "sev-dev-tio.h"
> +
> +MODULE_IMPORT_NS("PCI_IDE");
> +
> +#define TIO_DEFAULT_NR_IDE_STREAMS	1
> +
> +static uint nr_ide_streams = TIO_DEFAULT_NR_IDE_STREAMS;
> +module_param_named(ide_nr, nr_ide_streams, uint, 0644);
> +MODULE_PARM_DESC(ide_nr, "Set the maximum number of IDE streams per PHB");
> +
> +#define dev_to_sp(dev)		((struct sp_device *)dev_get_drvdata(dev))
> +#define dev_to_psp(dev)		((struct psp_device *)(dev_to_sp(dev)->psp_data))
> +#define dev_to_sev(dev)		((struct sev_device *)(dev_to_psp(dev)->sev_data))
> +#define tsm_dev_to_sev(tsmdev)	dev_to_sev((tsmdev)->dev.parent)
> +
> +#define pdev_to_tio_dsm(pdev)	(container_of((pdev)->tsm, struct tio_dsm, tsm.base_tsm))
> +
> +static int sev_tio_spdm_cmd(struct tio_dsm *dsm, int ret)
> +{
> +	struct tsm_dsm_tio *dev_data = &dsm->data;
> +	struct tsm_spdm *spdm = &dev_data->spdm;
> +
> +	/* Check the main command handler response before entering the loop */
> +	if (ret == 0 && dev_data->psp_ret != SEV_RET_SUCCESS)
> +		return -EINVAL;
> +
> +	if (ret <= 0)
> +		return ret;
> +
> +	/* ret > 0 means "SPDM requested" */
> +	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
> +		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG, ret,
> +			      spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
> +		if (ret < 0)
> +			break;
> +
> +		WARN_ON_ONCE(ret == 0); /* The response should never be empty */
> +		spdm->rsp_len = ret;
> +		ret = sev_tio_continue(dev_data);
> +	}
> +
> +	return ret;
> +}
> +
> +static int stream_enable(struct pci_ide *ide)
> +{
> +	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
> +	int ret;
> +
> +	ret = pci_ide_stream_enable(rp, ide);
> +	if (ret)
> +		return ret;
> +
> +	ret = pci_ide_stream_enable(ide->pdev, ide);
> +	if (ret)
> +		pci_ide_stream_disable(rp, ide);
> +
> +	return ret;
> +}
> +
> +static int streams_enable(struct pci_ide **ide)
> +{
> +	int ret = 0;
> +
> +	for (int i = 0; i < TIO_IDE_MAX_TC; ++i) {
> +		if (ide[i]) {
> +			ret = stream_enable(ide[i]);
> +			if (ret)
> +				break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void stream_disable(struct pci_ide *ide)
> +{
> +	pci_ide_stream_disable(ide->pdev, ide);
> +	pci_ide_stream_disable(pcie_find_root_port(ide->pdev), ide);
> +}
> +
> +static void streams_disable(struct pci_ide **ide)
> +{
> +	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
> +		if (ide[i])
> +			stream_disable(ide[i]);
> +}
> +
> +static void stream_setup(struct pci_ide *ide)
> +{
> +	struct pci_dev *rp = pcie_find_root_port(ide->pdev);
> +
> +	ide->partner[PCI_IDE_EP].rid_start = 0;
> +	ide->partner[PCI_IDE_EP].rid_end = 0xffff;
> +	ide->partner[PCI_IDE_RP].rid_start = 0;
> +	ide->partner[PCI_IDE_RP].rid_end = 0xffff;
> +
> +	ide->pdev->ide_cfg = 0;
> +	ide->pdev->ide_tee_limit = 1;
> +	rp->ide_cfg = 1;
> +	rp->ide_tee_limit = 0;
> +
> +	pci_warn(ide->pdev, "Forcing CFG/TEE for %s", pci_name(rp));
> +	pci_ide_stream_setup(ide->pdev, ide);
> +	pci_ide_stream_setup(rp, ide);
> +}
> +
> +static u8 streams_setup(struct pci_ide **ide, u8 *ids)
> +{
> +	bool def = false;
> +	u8 tc_mask = 0;
> +	int i;
> +
> +	for (i = 0; i < TIO_IDE_MAX_TC; ++i) {
> +		if (!ide[i]) {
> +			ids[i] = 0xFF;
> +			continue;
> +		}
> +
> +		tc_mask |= BIT(i);
> +		ids[i] = ide[i]->stream_id;
> +
> +		if (!def) {
> +			struct pci_ide_partner *settings;
> +
> +			settings = pci_ide_to_settings(ide[i]->pdev, ide[i]);
> +			settings->default_stream = 1;
> +			def = true;
> +		}
> +
> +		stream_setup(ide[i]);
> +	}
> +
> +	return tc_mask;
> +}
> +
> +static int streams_register(struct pci_ide **ide)
> +{
> +	int ret = 0, i;
> +
> +	for (i = 0; i < TIO_IDE_MAX_TC; ++i) {
> +		if (ide[i]) {
> +			ret = pci_ide_stream_register(ide[i]);
> +			if (ret)
> +				break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void streams_unregister(struct pci_ide **ide)
> +{
> +	for (int i = 0; i < TIO_IDE_MAX_TC; ++i)
> +		if (ide[i])
> +			pci_ide_stream_unregister(ide[i]);
> +}
> +
> +static void stream_teardown(struct pci_ide *ide)
> +{
> +	pci_ide_stream_teardown(ide->pdev, ide);
> +	pci_ide_stream_teardown(pcie_find_root_port(ide->pdev), ide);
> +}
> +
> +static void streams_teardown(struct pci_ide **ide)
> +{
> +	for (int i = 0; i < TIO_IDE_MAX_TC; ++i) {
> +		if (ide[i]) {
> +			stream_teardown(ide[i]);
> +			pci_ide_stream_free(ide[i]);
> +			ide[i] = NULL;
> +		}
> +	}
> +}
> +
> +static int stream_alloc(struct pci_dev *pdev, struct pci_ide **ide,
> +			unsigned int tc)
> +{
> +	struct pci_dev *rp = pcie_find_root_port(pdev);
> +	struct pci_ide *ide1;
> +
> +	if (ide[tc]) {
> +		pci_err(pdev, "Stream for class=%d already registered", tc);
> +		return -EBUSY;
> +	}
> +
> +	/* FIXME: find a better way */
> +	if (nr_ide_streams != TIO_DEFAULT_NR_IDE_STREAMS)
> +		pci_notice(pdev, "Enable non-default %d streams", nr_ide_streams);
> +	pci_ide_set_nr_streams(to_pci_host_bridge(rp->bus->bridge), nr_ide_streams);
> +
> +	ide1 = pci_ide_stream_alloc(pdev);
> +	if (!ide1)
> +		return -EFAULT;
> +
> +	/* Blindly assign streamid=0 to TC=0, and so on */
> +	ide1->stream_id = tc;
> +
> +	ide[tc] = ide1;
> +
> +	return 0;
> +}
> +
> +static struct pci_tsm *tio_pf0_probe(struct pci_dev *pdev, struct sev_device *sev)
> +{
> +	struct tio_dsm *dsm __free(kfree) = kzalloc(sizeof(*dsm), GFP_KERNEL);
> +	int rc;
> +
> +	if (!dsm)
> +		return NULL;
> +
> +	rc = pci_tsm_pf0_constructor(pdev, &dsm->tsm, sev->tsmdev);
> +	if (rc)
> +		return NULL;
> +
> +	pci_dbg(pdev, "TSM enabled\n");
> +	dsm->sev = sev;
> +	return &no_free_ptr(dsm)->tsm.base_tsm;
> +}
> +
> +static struct pci_tsm *dsm_probe(struct tsm_dev *tsmdev, struct pci_dev *pdev)
> +{
> +	struct sev_device *sev = tsm_dev_to_sev(tsmdev);
> +
> +	if (is_pci_tsm_pf0(pdev))
> +		return tio_pf0_probe(pdev, sev);
> +	return 0;
> +}
> +
> +static void dsm_remove(struct pci_tsm *tsm)
> +{
> +	struct pci_dev *pdev = tsm->pdev;
> +
> +	pci_dbg(pdev, "TSM disabled\n");
> +
> +	if (is_pci_tsm_pf0(pdev)) {
> +		struct tio_dsm *dsm = container_of(tsm, struct tio_dsm, tsm.base_tsm);
> +
> +		pci_tsm_pf0_destructor(&dsm->tsm);
> +		kfree(dsm);
> +	}
> +}
> +
> +static int dsm_create(struct tio_dsm *dsm)
> +{
> +	struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
> +	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
> +	struct pci_dev *rootport = pcie_find_root_port(pdev);
> +	u16 device_id = pci_dev_id(pdev);
> +	u16 root_port_id;
> +	u32 lnkcap = 0;
> +
> +	if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
> +				  &lnkcap))
> +		return -ENODEV;
> +
> +	root_port_id = FIELD_GET(PCI_EXP_LNKCAP_PN, lnkcap);
> +
> +	return sev_tio_dev_create(&dsm->data, device_id, root_port_id, segment_id);
> +}
> +
> +static int dsm_connect(struct pci_dev *pdev)
> +{
> +	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
> +	struct tsm_dsm_tio *dev_data = &dsm->data;
> +	u8 ids[TIO_IDE_MAX_TC];
> +	u8 tc_mask;
> +	int ret;
> +
> +	if (pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
> +				 PCI_DOE_FEATURE_SSESSION) != dsm->tsm.doe_mb) {
> +		pci_err(pdev, "CMA DOE MB must support SSESSION\n");
> +		return -EFAULT;
> +	}
> +
> +	ret = stream_alloc(pdev, dev_data->ide, 0);
> +	if (ret)
> +		return ret;
> +
> +	ret = dsm_create(dsm);
> +	if (ret)
> +		goto ide_free_exit;
> +
> +	tc_mask = streams_setup(dev_data->ide, ids);
> +
> +	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
> +	ret = sev_tio_spdm_cmd(dsm, ret);
> +	if (ret)
> +		goto free_exit;
> +
> +	streams_enable(dev_data->ide);
> +
> +	ret = streams_register(dev_data->ide);
> +	if (ret)
> +		goto free_exit;
> +
> +	return 0;
> +
> +free_exit:
> +	sev_tio_dev_reclaim(dev_data);
> +
> +	streams_disable(dev_data->ide);
> +ide_free_exit:
> +
> +	streams_teardown(dev_data->ide);
> +
> +	return ret;
> +}
> +
> +static void dsm_disconnect(struct pci_dev *pdev)
> +{
> +	bool force = SYSTEM_HALT <= system_state && system_state <= SYSTEM_RESTART;
> +	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
> +	struct tsm_dsm_tio *dev_data = &dsm->data;
> +	int ret;
> +
> +	ret = sev_tio_dev_disconnect(dev_data, force);
> +	ret = sev_tio_spdm_cmd(dsm, ret);
> +	if (ret && !force) {
> +		ret = sev_tio_dev_disconnect(dev_data, true);
> +		sev_tio_spdm_cmd(dsm, ret);
> +	}
> +
> +	sev_tio_dev_reclaim(dev_data);
> +
> +	streams_disable(dev_data->ide);
> +	streams_unregister(dev_data->ide);
> +	streams_teardown(dev_data->ide);
> +}
> +
> +static struct pci_tsm_ops sev_tsm_ops = {
> +	.probe = dsm_probe,
> +	.remove = dsm_remove,
> +	.connect = dsm_connect,
> +	.disconnect = dsm_disconnect,
> +};
> +
> +void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page)
> +{
> +	struct sev_tio_status *t = kzalloc(sizeof(*t), GFP_KERNEL);
> +	struct tsm_dev *tsmdev;
> +	int ret;
> +
> +	WARN_ON(sev->tio_status);
> +
> +	if (!t)
> +		return;
> +
> +	ret = sev_tio_init_locked(tio_status_page);
> +	if (ret) {
> +		pr_warn("SEV-TIO STATUS failed with %d\n", ret);
> +		goto error_exit;
> +	}
> +
> +	tsmdev = tsm_register(sev->dev, &sev_tsm_ops);
> +	if (IS_ERR(tsmdev))
> +		goto error_exit;
> +
> +	memcpy(t, tio_status_page, sizeof(*t));
> +
> +	pr_notice("SEV-TIO status: EN=%d INIT_DONE=%d rq=%d..%d rs=%d..%d "
> +		  "scr=%d..%d out=%d..%d dev=%d tdi=%d algos=%x\n",
> +		  t->tio_en, t->tio_init_done,
> +		  t->spdm_req_size_min, t->spdm_req_size_max,
> +		  t->spdm_rsp_size_min, t->spdm_rsp_size_max,
> +		  t->spdm_scratch_size_min, t->spdm_scratch_size_max,
> +		  t->spdm_out_size_min, t->spdm_out_size_max,
> +		  t->devctx_size, t->tdictx_size,
> +		  t->tio_crypto_alg);
> +
> +	sev->tsmdev = tsmdev;
> +	sev->tio_status = t;
> +
> +	return;
> +
> +error_exit:
> +	kfree(t);
> +	pr_err("Failed to enable SEV-TIO: ret=%d en=%d initdone=%d SEV=%d\n",
> +	       ret, t->tio_en, t->tio_init_done, boot_cpu_has(X86_FEATURE_SEV));
> +}
> +
> +void sev_tsm_uninit(struct sev_device *sev)
> +{
> +	if (sev->tsmdev)
> +		tsm_unregister(sev->tsmdev);
> +
> +	sev->tsmdev = NULL;
> +}
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 2f1c9614d359..365867f381e9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -38,6 +38,7 @@
>   
>   #include "psp-dev.h"
>   #include "sev-dev.h"
> +#include "sev-dev-tio.h"
>   
>   #define DEVICE_NAME		"sev"
>   #define SEV_FW_FILE		"amd/sev.fw"
> @@ -75,6 +76,12 @@ static bool psp_init_on_probe = true;
>   module_param(psp_init_on_probe, bool, 0444);
>   MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>   
> +#if defined(CONFIG_PCI_TSM)
> +static bool sev_tio_enabled = true;
> +module_param_named(tio, sev_tio_enabled, bool, 0444);
> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
> +#endif
> +
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
> @@ -251,7 +258,7 @@ static int sev_cmd_buffer_len(int cmd)
>   	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>   	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>   	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> -	default:				return 0;
> +	default:				return sev_tio_cmd_buffer_len(cmd);
>   	}
>   
>   	return 0;
> @@ -1439,8 +1446,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>   		data.init_rmp = 1;
>   		data.list_paddr_en = 1;
>   		data.list_paddr = __psp_pa(snp_range_list);
> +
> +#if defined(CONFIG_PCI_TSM)
>   		data.tio_en = sev_tio_present(sev) &&
> +			sev_tio_enabled && psp_init_on_probe &&
>   			amd_iommu_sev_tio_supported();
> +		if (sev_tio_present(sev) && !psp_init_on_probe)
> +			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
> +#endif
>   		cmd = SEV_CMD_SNP_INIT_EX;
>   	} else {
>   		cmd = SEV_CMD_SNP_INIT;
> @@ -1487,6 +1500,24 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>   	atomic_notifier_chain_register(&panic_notifier_list,
>   				       &snp_panic_notifier);
>   
> +#if defined(CONFIG_PCI_TSM)
> +	if (data.tio_en) {
> +		/*
> +		 * This executes with the sev_cmd_mutex held so down the stack
> +		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
> +		 * unlikely) but will cause a deadlock.
> +		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
> +		 * for this one call here.
> +		 */
> +		void *tio_status = page_address(__snp_alloc_firmware_pages(
> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
> +
> +		if (tio_status) {
> +			sev_tsm_init_locked(sev, tio_status);
> +			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
> +		}
> +	}
> +#endif
>   	sev_es_tmr_size = SNP_TMR_SIZE;
>   
>   	return 0;
> @@ -2766,7 +2797,22 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>   
>   static void sev_firmware_shutdown(struct sev_device *sev)
>   {
> +#if defined(CONFIG_PCI_TSM)
> +	/*
> +	 * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
> +	 * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
> +	 */
> +	if (sev->tio_status)
> +		sev_tsm_uninit(sev);
> +#endif
> +
>   	mutex_lock(&sev_cmd_mutex);
> +
> +#if defined(CONFIG_PCI_TSM)
> +	kfree(sev->tio_status);
> +	sev->tio_status = NULL;
> +#endif
> +
>   	__sev_firmware_shutdown(sev, false);
>   	mutex_unlock(&sev_cmd_mutex);
>   }

--------------BLLuAkKzZElrh17i1JLNc4sT
Content-Type: text/plain; charset="UTF-8"; name="kconfig"
Content-Disposition: attachment; filename="kconfig"
Content-Transfer-Encoding: base64

IwojIEF1dG9tYXRpY2FsbHkgZ2VuZXJhdGVkIGZpbGU7IERPIE5PVCBFRElULgojIExpbnV4
L3g4NiA2LjE4LjAtcmM3IEtlcm5lbCBDb25maWd1cmF0aW9uCiMKQ09ORklHX0NDX1ZFUlNJ
T05fVEVYVD0iZ2NjIChVYnVudHUgMTMuMy4wLTZ1YnVudHUyfjI0LjA0KSAxMy4zLjAiCkNP
TkZJR19DQ19JU19HQ0M9eQpDT05GSUdfR0NDX1ZFUlNJT049MTMwMzAwCkNPTkZJR19DTEFO
R19WRVJTSU9OPTAKQ09ORklHX0FTX0lTX0dOVT15CkNPTkZJR19BU19WRVJTSU9OPTI0MjAw
CkNPTkZJR19MRF9JU19CRkQ9eQpDT05GSUdfTERfVkVSU0lPTj0yNDIwMApDT05GSUdfTExE
X1ZFUlNJT049MApDT05GSUdfUlVTVENfVkVSU0lPTj0xMDg5MDAKQ09ORklHX1JVU1RDX0xM
Vk1fVkVSU0lPTj0yMDAxMDcKQ09ORklHX0NDX0hBU19BU01fR09UT19PVVRQVVQ9eQpDT05G
SUdfQ0NfSEFTX0FTTV9HT1RPX1RJRURfT1VUUFVUPXkKQ09ORklHX1RPT0xTX1NVUFBPUlRf
UkVMUj15CkNPTkZJR19DQ19IQVNfQVNNX0lOTElORT15CkNPTkZJR19DQ19IQVNfQVNTVU1F
PXkKQ09ORklHX0NDX0hBU19OT19QUk9GSUxFX0ZOX0FUVFI9eQpDT05GSUdfTERfQ0FOX1VT
RV9LRUVQX0lOX09WRVJMQVk9eQpDT05GSUdfUlVTVENfSEFTX1NMSUNFX0FTX0ZMQVRURU5F
RD15CkNPTkZJR19SVVNUQ19IQVNfQ09FUkNFX1BPSU5URUU9eQpDT05GSUdfUlVTVENfSEFT
X1NQQU5fRklMRT15CkNPTkZJR19SVVNUQ19IQVNfVU5ORUNFU1NBUllfVFJBTlNNVVRFUz15
CkNPTkZJR19SVVNUQ19IQVNfRklMRV9XSVRIX05VTD15CkNPTkZJR19QQUhPTEVfVkVSU0lP
Tj0xMjIKQ09ORklHX0lSUV9XT1JLPXkKQ09ORklHX0JVSUxEVElNRV9UQUJMRV9TT1JUPXkK
Q09ORklHX1RIUkVBRF9JTkZPX0lOX1RBU0s9eQoKIwojIEdlbmVyYWwgc2V0dXAKIwpDT05G
SUdfSU5JVF9FTlZfQVJHX0xJTUlUPTMyCiMgQ09ORklHX0NPTVBJTEVfVEVTVCBpcyBub3Qg
c2V0CiMgQ09ORklHX1dFUlJPUiBpcyBub3Qgc2V0CkNPTkZJR19MT0NBTFZFUlNJT049IiIK
IyBDT05GSUdfTE9DQUxWRVJTSU9OX0FVVE8gaXMgbm90IHNldApDT05GSUdfQlVJTERfU0FM
VD0iIgpDT05GSUdfSEFWRV9LRVJORUxfR1pJUD15CkNPTkZJR19IQVZFX0tFUk5FTF9CWklQ
Mj15CkNPTkZJR19IQVZFX0tFUk5FTF9MWk1BPXkKQ09ORklHX0hBVkVfS0VSTkVMX1haPXkK
Q09ORklHX0hBVkVfS0VSTkVMX0xaTz15CkNPTkZJR19IQVZFX0tFUk5FTF9MWjQ9eQpDT05G
SUdfSEFWRV9LRVJORUxfWlNURD15CiMgQ09ORklHX0tFUk5FTF9HWklQIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VSTkVMX0JaSVAyIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xaTUEg
aXMgbm90IHNldAojIENPTkZJR19LRVJORUxfWFogaXMgbm90IHNldAojIENPTkZJR19LRVJO
RUxfTFpPIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VSTkVMX0xaNCBpcyBub3Qgc2V0CkNPTkZJ
R19LRVJORUxfWlNURD15CkNPTkZJR19ERUZBVUxUX0lOSVQ9IiIKQ09ORklHX0RFRkFVTFRf
SE9TVE5BTUU9Iihub25lKSIKQ09ORklHX1NZU1ZJUEM9eQpDT05GSUdfU1lTVklQQ19TWVND
VEw9eQpDT05GSUdfU1lTVklQQ19DT01QQVQ9eQpDT05GSUdfUE9TSVhfTVFVRVVFPXkKQ09O
RklHX1BPU0lYX01RVUVVRV9TWVNDVEw9eQpDT05GSUdfV0FUQ0hfUVVFVUU9eQpDT05GSUdf
Q1JPU1NfTUVNT1JZX0FUVEFDSD15CkNPTkZJR19BVURJVD15CkNPTkZJR19IQVZFX0FSQ0hf
QVVESVRTWVNDQUxMPXkKQ09ORklHX0FVRElUU1lTQ0FMTD15CgojCiMgSVJRIHN1YnN5c3Rl
bQojCkNPTkZJR19HRU5FUklDX0lSUV9QUk9CRT15CkNPTkZJR19HRU5FUklDX0lSUV9TSE9X
PXkKQ09ORklHX0dFTkVSSUNfSVJRX0VGRkVDVElWRV9BRkZfTUFTSz15CkNPTkZJR19HRU5F
UklDX1BFTkRJTkdfSVJRPXkKQ09ORklHX0dFTkVSSUNfSVJRX01JR1JBVElPTj15CkNPTkZJ
R19IQVJESVJRU19TV19SRVNFTkQ9eQpDT05GSUdfSVJRX0RPTUFJTj15CkNPTkZJR19JUlFf
RE9NQUlOX0hJRVJBUkNIWT15CkNPTkZJR19HRU5FUklDX01TSV9JUlE9eQpDT05GSUdfR0VO
RVJJQ19JUlFfTUFUUklYX0FMTE9DQVRPUj15CkNPTkZJR19HRU5FUklDX0lSUV9SRVNFUlZB
VElPTl9NT0RFPXkKQ09ORklHX0lSUV9GT1JDRURfVEhSRUFESU5HPXkKQ09ORklHX1NQQVJT
RV9JUlE9eQojIENPTkZJR19HRU5FUklDX0lSUV9ERUJVR0ZTIGlzIG5vdCBzZXQKIyBlbmQg
b2YgSVJRIHN1YnN5c3RlbQoKQ09ORklHX0NMT0NLU09VUkNFX1dBVENIRE9HPXkKQ09ORklH
X0FSQ0hfQ0xPQ0tTT1VSQ0VfSU5JVD15CkNPTkZJR19HRU5FUklDX1RJTUVfVlNZU0NBTEw9
eQpDT05GSUdfR0VORVJJQ19DTE9DS0VWRU5UUz15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZF
TlRTX0JST0FEQ0FTVD15CkNPTkZJR19HRU5FUklDX0NMT0NLRVZFTlRTX0JST0FEQ0FTVF9J
RExFPXkKQ09ORklHX0dFTkVSSUNfQ0xPQ0tFVkVOVFNfTUlOX0FESlVTVD15CkNPTkZJR19H
RU5FUklDX0NNT1NfVVBEQVRFPXkKQ09ORklHX0hBVkVfUE9TSVhfQ1BVX1RJTUVSU19UQVNL
X1dPUks9eQpDT05GSUdfUE9TSVhfQ1BVX1RJTUVSU19UQVNLX1dPUks9eQpDT05GSUdfQ09O
VEVYVF9UUkFDS0lORz15CkNPTkZJR19DT05URVhUX1RSQUNLSU5HX0lETEU9eQoKIwojIFRp
bWVycyBzdWJzeXN0ZW0KIwpDT05GSUdfVElDS19PTkVTSE9UPXkKQ09ORklHX05PX0haX0NP
TU1PTj15CiMgQ09ORklHX0haX1BFUklPRElDIGlzIG5vdCBzZXQKQ09ORklHX05PX0haX0lE
TEU9eQojIENPTkZJR19OT19IWl9GVUxMIGlzIG5vdCBzZXQKQ09ORklHX05PX0haPXkKQ09O
RklHX0hJR0hfUkVTX1RJTUVSUz15CkNPTkZJR19DTE9DS1NPVVJDRV9XQVRDSERPR19NQVhf
U0tFV19VUz0xMjUKIyBDT05GSUdfUE9TSVhfQVVYX0NMT0NLUyBpcyBub3Qgc2V0CiMgZW5k
IG9mIFRpbWVycyBzdWJzeXN0ZW0KCkNPTkZJR19CUEY9eQpDT05GSUdfSEFWRV9FQlBGX0pJ
VD15CkNPTkZJR19BUkNIX1dBTlRfREVGQVVMVF9CUEZfSklUPXkKCiMKIyBCUEYgc3Vic3lz
dGVtCiMKQ09ORklHX0JQRl9TWVNDQUxMPXkKQ09ORklHX0JQRl9KSVQ9eQpDT05GSUdfQlBG
X0pJVF9BTFdBWVNfT049eQpDT05GSUdfQlBGX0pJVF9ERUZBVUxUX09OPXkKQ09ORklHX0JQ
Rl9VTlBSSVZfREVGQVVMVF9PRkY9eQojIENPTkZJR19CUEZfUFJFTE9BRCBpcyBub3Qgc2V0
CkNPTkZJR19CUEZfTFNNPXkKIyBlbmQgb2YgQlBGIHN1YnN5c3RlbQoKQ09ORklHX1BSRUVN
UFRfQlVJTEQ9eQpDT05GSUdfQVJDSF9IQVNfUFJFRU1QVF9MQVpZPXkKIyBDT05GSUdfUFJF
RU1QVF9OT05FIGlzIG5vdCBzZXQKQ09ORklHX1BSRUVNUFRfVk9MVU5UQVJZPXkKIyBDT05G
SUdfUFJFRU1QVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BSRUVNUFRfTEFaWSBpcyBub3Qgc2V0
CiMgQ09ORklHX1BSRUVNUFRfUlQgaXMgbm90IHNldApDT05GSUdfUFJFRU1QVF9DT1VOVD15
CkNPTkZJR19QUkVFTVBUSU9OPXkKQ09ORklHX1BSRUVNUFRfRFlOQU1JQz15CkNPTkZJR19T
Q0hFRF9DT1JFPXkKCiMKIyBDUFUvVGFzayB0aW1lIGFuZCBzdGF0cyBhY2NvdW50aW5nCiMK
Q09ORklHX1RJQ0tfQ1BVX0FDQ09VTlRJTkc9eQojIENPTkZJR19WSVJUX0NQVV9BQ0NPVU5U
SU5HX0dFTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSUV9USU1FX0FDQ09VTlRJTkcgaXMgbm90
IHNldApDT05GSUdfQlNEX1BST0NFU1NfQUNDVD15CkNPTkZJR19CU0RfUFJPQ0VTU19BQ0NU
X1YzPXkKQ09ORklHX1RBU0tTVEFUUz15CkNPTkZJR19UQVNLX0RFTEFZX0FDQ1Q9eQpDT05G
SUdfVEFTS19YQUNDVD15CkNPTkZJR19UQVNLX0lPX0FDQ09VTlRJTkc9eQpDT05GSUdfUFNJ
PXkKIyBDT05GSUdfUFNJX0RFRkFVTFRfRElTQUJMRUQgaXMgbm90IHNldAojIGVuZCBvZiBD
UFUvVGFzayB0aW1lIGFuZCBzdGF0cyBhY2NvdW50aW5nCgpDT05GSUdfQ1BVX0lTT0xBVElP
Tj15CgojCiMgUkNVIFN1YnN5c3RlbQojCkNPTkZJR19UUkVFX1JDVT15CkNPTkZJR19QUkVF
TVBUX1JDVT15CiMgQ09ORklHX1JDVV9FWFBFUlQgaXMgbm90IHNldApDT05GSUdfVFJFRV9T
UkNVPXkKQ09ORklHX1RBU0tTX1JDVV9HRU5FUklDPXkKQ09ORklHX05FRURfVEFTS1NfUkNV
PXkKQ09ORklHX1RBU0tTX1JDVT15CkNPTkZJR19UQVNLU19SVURFX1JDVT15CkNPTkZJR19U
QVNLU19UUkFDRV9SQ1U9eQpDT05GSUdfUkNVX1NUQUxMX0NPTU1PTj15CkNPTkZJR19SQ1Vf
TkVFRF9TRUdDQkxJU1Q9eQojIGVuZCBvZiBSQ1UgU3Vic3lzdGVtCgpDT05GSUdfSUtDT05G
SUc9eQpDT05GSUdfSUtDT05GSUdfUFJPQz15CiMgQ09ORklHX0lLSEVBREVSUyBpcyBub3Qg
c2V0CkNPTkZJR19MT0dfQlVGX1NISUZUPTE4CkNPTkZJR19MT0dfQ1BVX01BWF9CVUZfU0hJ
RlQ9MTIKIyBDT05GSUdfUFJJTlRLX0lOREVYIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfVU5T
VEFCTEVfU0NIRURfQ0xPQ0s9eQoKIwojIFNjaGVkdWxlciBmZWF0dXJlcwojCkNPTkZJR19V
Q0xBTVBfVEFTSz15CkNPTkZJR19VQ0xBTVBfQlVDS0VUU19DT1VOVD01CiMgQ09ORklHX1ND
SEVEX1BST1hZX0VYRUMgaXMgbm90IHNldAojIGVuZCBvZiBTY2hlZHVsZXIgZmVhdHVyZXMK
CkNPTkZJR19BUkNIX1NVUFBPUlRTX05VTUFfQkFMQU5DSU5HPXkKQ09ORklHX0FSQ0hfV0FO
VF9CQVRDSEVEX1VOTUFQX1RMQl9GTFVTSD15CkNPTkZJR19DQ19IQVNfSU5UMTI4PXkKQ09O
RklHX0NDX0lNUExJQ0lUX0ZBTExUSFJPVUdIPSItV2ltcGxpY2l0LWZhbGx0aHJvdWdoPTUi
CkNPTkZJR19HQ0MxMF9OT19BUlJBWV9CT1VORFM9eQpDT05GSUdfQ0NfTk9fQVJSQVlfQk9V
TkRTPXkKQ09ORklHX0dDQ19OT19TVFJJTkdPUF9PVkVSRkxPVz15CkNPTkZJR19DQ19OT19T
VFJJTkdPUF9PVkVSRkxPVz15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0lOVDEyOD15CkNPTkZJ
R19OVU1BX0JBTEFOQ0lORz15CkNPTkZJR19OVU1BX0JBTEFOQ0lOR19ERUZBVUxUX0VOQUJM
RUQ9eQpDT05GSUdfU0xBQl9PQkpfRVhUPXkKQ09ORklHX0NHUk9VUFM9eQpDT05GSUdfUEFH
RV9DT1VOVEVSPXkKIyBDT05GSUdfQ0dST1VQX0ZBVk9SX0RZTk1PRFMgaXMgbm90IHNldApD
T05GSUdfTUVNQ0c9eQojIENPTkZJR19NRU1DR19WMSBpcyBub3Qgc2V0CkNPTkZJR19CTEtf
Q0dST1VQPXkKQ09ORklHX0NHUk9VUF9XUklURUJBQ0s9eQpDT05GSUdfQ0dST1VQX1NDSEVE
PXkKQ09ORklHX0dST1VQX1NDSEVEX1dFSUdIVD15CkNPTkZJR19HUk9VUF9TQ0hFRF9CQU5E
V0lEVEg9eQpDT05GSUdfRkFJUl9HUk9VUF9TQ0hFRD15CkNPTkZJR19DRlNfQkFORFdJRFRI
PXkKIyBDT05GSUdfUlRfR1JPVVBfU0NIRUQgaXMgbm90IHNldApDT05GSUdfU0NIRURfTU1f
Q0lEPXkKQ09ORklHX1VDTEFNUF9UQVNLX0dST1VQPXkKQ09ORklHX0NHUk9VUF9QSURTPXkK
Q09ORklHX0NHUk9VUF9SRE1BPXkKIyBDT05GSUdfQ0dST1VQX0RNRU0gaXMgbm90IHNldApD
T05GSUdfQ0dST1VQX0ZSRUVaRVI9eQpDT05GSUdfQ0dST1VQX0hVR0VUTEI9eQpDT05GSUdf
Q1BVU0VUUz15CiMgQ09ORklHX0NQVVNFVFNfVjEgaXMgbm90IHNldApDT05GSUdfQ0dST1VQ
X0RFVklDRT15CkNPTkZJR19DR1JPVVBfQ1BVQUNDVD15CkNPTkZJR19DR1JPVVBfUEVSRj15
CkNPTkZJR19DR1JPVVBfQlBGPXkKQ09ORklHX0NHUk9VUF9NSVNDPXkKIyBDT05GSUdfQ0dS
T1VQX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NPQ0tfQ0dST1VQX0RBVEE9eQpDT05GSUdf
TkFNRVNQQUNFUz15CkNPTkZJR19VVFNfTlM9eQpDT05GSUdfVElNRV9OUz15CkNPTkZJR19J
UENfTlM9eQpDT05GSUdfVVNFUl9OUz15CkNPTkZJR19QSURfTlM9eQpDT05GSUdfTkVUX05T
PXkKQ09ORklHX0NIRUNLUE9JTlRfUkVTVE9SRT15CkNPTkZJR19TQ0hFRF9BVVRPR1JPVVA9
eQpDT05GSUdfUkVMQVk9eQpDT05GSUdfQkxLX0RFVl9JTklUUkQ9eQpDT05GSUdfSU5JVFJB
TUZTX1NPVVJDRT0iIgpDT05GSUdfUkRfR1pJUD15CkNPTkZJR19SRF9CWklQMj15CkNPTkZJ
R19SRF9MWk1BPXkKQ09ORklHX1JEX1haPXkKQ09ORklHX1JEX0xaTz15CkNPTkZJR19SRF9M
WjQ9eQpDT05GSUdfUkRfWlNURD15CkNPTkZJR19CT09UX0NPTkZJRz15CiMgQ09ORklHX0JP
T1RfQ09ORklHX0ZPUkNFIGlzIG5vdCBzZXQKIyBDT05GSUdfQk9PVF9DT05GSUdfRU1CRUQg
aXMgbm90IHNldApDT05GSUdfQ01ETElORV9MT0dfV1JBUF9JREVBTF9MRU49MTAyMQpDT05G
SUdfSU5JVFJBTUZTX1BSRVNFUlZFX01USU1FPXkKQ09ORklHX0NDX09QVElNSVpFX0ZPUl9Q
RVJGT1JNQU5DRT15CiMgQ09ORklHX0NDX09QVElNSVpFX0ZPUl9TSVpFIGlzIG5vdCBzZXQK
Q09ORklHX0xEX09SUEhBTl9XQVJOPXkKQ09ORklHX0xEX09SUEhBTl9XQVJOX0xFVkVMPSJ3
YXJuIgpDT05GSUdfU1lTQ1RMPXkKQ09ORklHX0hBVkVfVUlEMTY9eQpDT05GSUdfU1lTQ1RM
X0VYQ0VQVElPTl9UUkFDRT15CkNPTkZJR19TWVNGU19TWVNDQUxMPXkKQ09ORklHX0hBVkVf
UENTUEtSX1BMQVRGT1JNPXkKQ09ORklHX0VYUEVSVD15CkNPTkZJR19VSUQxNj15CkNPTkZJ
R19NVUxUSVVTRVI9eQpDT05GSUdfU0dFVE1BU0tfU1lTQ0FMTD15CkNPTkZJR19GSEFORExF
PXkKQ09ORklHX1BPU0lYX1RJTUVSUz15CkNPTkZJR19QUklOVEs9eQpDT05GSUdfQlVHPXkK
Q09ORklHX0VMRl9DT1JFPXkKQ09ORklHX1BDU1BLUl9QTEFURk9STT15CiMgQ09ORklHX0JB
U0VfU01BTEwgaXMgbm90IHNldApDT05GSUdfRlVURVg9eQpDT05GSUdfRlVURVhfUEk9eQpD
T05GSUdfRlVURVhfUFJJVkFURV9IQVNIPXkKQ09ORklHX0ZVVEVYX01QT0w9eQpDT05GSUdf
RVBPTEw9eQpDT05GSUdfU0lHTkFMRkQ9eQpDT05GSUdfVElNRVJGRD15CkNPTkZJR19FVkVO
VEZEPXkKQ09ORklHX1NITUVNPXkKQ09ORklHX0FJTz15CkNPTkZJR19JT19VUklORz15CiMg
Q09ORklHX0lPX1VSSU5HX01PQ0tfRklMRSBpcyBub3Qgc2V0CkNPTkZJR19BRFZJU0VfU1lT
Q0FMTFM9eQpDT05GSUdfTUVNQkFSUklFUj15CkNPTkZJR19LQ01QPXkKQ09ORklHX1JTRVE9
eQojIENPTkZJR19SU0VRX1NUQVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfUlNFUV9ERUJVR19E
RUZBVUxUX0VOQUJMRSBpcyBub3Qgc2V0CkNPTkZJR19DQUNIRVNUQVRfU1lTQ0FMTD15CkNP
TkZJR19LQUxMU1lNUz15CiMgQ09ORklHX0tBTExTWU1TX1NFTEZURVNUIGlzIG5vdCBzZXQK
Q09ORklHX0tBTExTWU1TX0FMTD15CkNPTkZJR19BUkNIX0hBU19NRU1CQVJSSUVSX1NZTkNf
Q09SRT15CkNPTkZJR19BUkNIX1NVUFBPUlRTX01TRUFMX1NZU1RFTV9NQVBQSU5HUz15CkNP
TkZJR19IQVZFX1BFUkZfRVZFTlRTPXkKQ09ORklHX0dVRVNUX1BFUkZfRVZFTlRTPXkKCiMK
IyBLZXJuZWwgUGVyZm9ybWFuY2UgRXZlbnRzIEFuZCBDb3VudGVycwojCkNPTkZJR19QRVJG
X0VWRU5UUz15CiMgQ09ORklHX0RFQlVHX1BFUkZfVVNFX1ZNQUxMT0MgaXMgbm90IHNldAoj
IGVuZCBvZiBLZXJuZWwgUGVyZm9ybWFuY2UgRXZlbnRzIEFuZCBDb3VudGVycwoKQ09ORklH
X1NZU1RFTV9EQVRBX1ZFUklGSUNBVElPTj15CkNPTkZJR19QUk9GSUxJTkc9eQpDT05GSUdf
VFJBQ0VQT0lOVFM9eQoKIwojIEtleGVjIGFuZCBjcmFzaCBmZWF0dXJlcwojCkNPTkZJR19D
UkFTSF9SRVNFUlZFPXkKQ09ORklHX1ZNQ09SRV9JTkZPPXkKQ09ORklHX0tFWEVDX0NPUkU9
eQpDT05GSUdfSEFWRV9JTUFfS0VYRUM9eQpDT05GSUdfS0VYRUM9eQpDT05GSUdfS0VYRUNf
RklMRT15CkNPTkZJR19LRVhFQ19TSUc9eQojIENPTkZJR19LRVhFQ19TSUdfRk9SQ0UgaXMg
bm90IHNldApDT05GSUdfS0VYRUNfQlpJTUFHRV9WRVJJRllfU0lHPXkKQ09ORklHX0tFWEVD
X0pVTVA9eQpDT05GSUdfQ1JBU0hfRFVNUD15CkNPTkZJR19DUkFTSF9IT1RQTFVHPXkKQ09O
RklHX0NSQVNIX01BWF9NRU1PUllfUkFOR0VTPTgxOTIKIyBlbmQgb2YgS2V4ZWMgYW5kIGNy
YXNoIGZlYXR1cmVzCgojCiMgTGl2ZSBVcGRhdGUgYW5kIEtleGVjIEhhbmRPdmVyCiMKIyBD
T05GSUdfS0VYRUNfSEFORE9WRVIgaXMgbm90IHNldAojIGVuZCBvZiBMaXZlIFVwZGF0ZSBh
bmQgS2V4ZWMgSGFuZE92ZXIKIyBlbmQgb2YgR2VuZXJhbCBzZXR1cAoKQ09ORklHXzY0QklU
PXkKQ09ORklHX1g4Nl82ND15CkNPTkZJR19YODY9eQpDT05GSUdfSU5TVFJVQ1RJT05fREVD
T0RFUj15CkNPTkZJR19PVVRQVVRfRk9STUFUPSJlbGY2NC14ODYtNjQiCkNPTkZJR19MT0NL
REVQX1NVUFBPUlQ9eQpDT05GSUdfU1RBQ0tUUkFDRV9TVVBQT1JUPXkKQ09ORklHX01NVT15
CkNPTkZJR19BUkNIX01NQVBfUk5EX0JJVFNfTUlOPTI4CkNPTkZJR19BUkNIX01NQVBfUk5E
X0JJVFNfTUFYPTMyCkNPTkZJR19BUkNIX01NQVBfUk5EX0NPTVBBVF9CSVRTX01JTj04CkNP
TkZJR19BUkNIX01NQVBfUk5EX0NPTVBBVF9CSVRTX01BWD0xNgpDT05GSUdfR0VORVJJQ19J
U0FfRE1BPXkKQ09ORklHX0dFTkVSSUNfQlVHPXkKQ09ORklHX0dFTkVSSUNfQlVHX1JFTEFU
SVZFX1BPSU5URVJTPXkKQ09ORklHX0FSQ0hfTUFZX0hBVkVfUENfRkRDPXkKQ09ORklHX0dF
TkVSSUNfQ0FMSUJSQVRFX0RFTEFZPXkKQ09ORklHX0FSQ0hfSEFTX0NQVV9SRUxBWD15CkNP
TkZJR19BUkNIX0hJQkVSTkFUSU9OX1BPU1NJQkxFPXkKQ09ORklHX0FSQ0hfU1VTUEVORF9Q
T1NTSUJMRT15CkNPTkZJR19BVURJVF9BUkNIPXkKQ09ORklHX0hBVkVfSU5URUxfVFhUPXkK
Q09ORklHX0FSQ0hfU1VQUE9SVFNfVVBST0JFUz15CkNPTkZJR19GSVhfRUFSTFlDT05fTUVN
PXkKQ09ORklHX0RZTkFNSUNfUEhZU0lDQUxfTUFTSz15CkNPTkZJR19QR1RBQkxFX0xFVkVM
Uz01CgojCiMgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVzCiMKQ09ORklHX1NNUD15CkNP
TkZJR19YODZfWDJBUElDPXkKIyBDT05GSUdfQU1EX1NFQ1VSRV9BVklDIGlzIG5vdCBzZXQK
IyBDT05GSUdfWDg2X1BPU1RFRF9NU0kgaXMgbm90IHNldApDT05GSUdfWDg2X01QUEFSU0U9
eQpDT05GSUdfWDg2X0NQVV9SRVNDVFJMPXkKIyBDT05GSUdfWDg2X0ZSRUQgaXMgbm90IHNl
dApDT05GSUdfWDg2X0VYVEVOREVEX1BMQVRGT1JNPXkKQ09ORklHX1g4Nl9OVU1BQ0hJUD15
CiMgQ09ORklHX1g4Nl9WU01QIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9VVj15CiMgQ09ORklH
X1g4Nl9JTlRFTF9NSUQgaXMgbm90IHNldAojIENPTkZJR19YODZfR09MREZJU0ggaXMgbm90
IHNldApDT05GSUdfWDg2X0lOVEVMX0xQU1M9eQpDT05GSUdfWDg2X0FNRF9QTEFURk9STV9E
RVZJQ0U9eQpDT05GSUdfSU9TRl9NQkk9eQpDT05GSUdfSU9TRl9NQklfREVCVUc9eQpDT05G
SUdfWDg2X1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKQ09ORklHX1NDSEVEX09NSVRfRlJB
TUVfUE9JTlRFUj15CkNPTkZJR19IWVBFUlZJU09SX0dVRVNUPXkKQ09ORklHX1BBUkFWSVJU
PXkKQ09ORklHX1BBUkFWSVJUX1hYTD15CiMgQ09ORklHX1BBUkFWSVJUX0RFQlVHIGlzIG5v
dCBzZXQKQ09ORklHX1BBUkFWSVJUX1NQSU5MT0NLUz15CkNPTkZJR19YODZfSFZfQ0FMTEJB
Q0tfVkVDVE9SPXkKQ09ORklHX1hFTj15CkNPTkZJR19YRU5fUFY9eQpDT05GSUdfWEVOXzUx
MkdCPXkKQ09ORklHX1hFTl9QVl9TTVA9eQpDT05GSUdfWEVOX1BWX0RPTTA9eQpDT05GSUdf
WEVOX1BWSFZNPXkKQ09ORklHX1hFTl9QVkhWTV9TTVA9eQpDT05GSUdfWEVOX1BWSFZNX0dV
RVNUPXkKIyBDT05GSUdfWEVOX0RFQlVHX0ZTIGlzIG5vdCBzZXQKQ09ORklHX1hFTl9QVkg9
eQpDT05GSUdfWEVOX0RPTTA9eQpDT05GSUdfWEVOX1BWX01TUl9TQUZFPXkKQ09ORklHX0tW
TV9HVUVTVD15CkNPTkZJR19BUkNIX0NQVUlETEVfSEFMVFBPTEw9eQpDT05GSUdfUFZIPXkK
IyBDT05GSUdfUEFSQVZJUlRfVElNRV9BQ0NPVU5USU5HIGlzIG5vdCBzZXQKQ09ORklHX1BB
UkFWSVJUX0NMT0NLPXkKQ09ORklHX0pBSUxIT1VTRV9HVUVTVD15CkNPTkZJR19BQ1JOX0dV
RVNUPXkKIyBDT05GSUdfQkhZVkVfR1VFU1QgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9U
RFhfR1VFU1QgaXMgbm90IHNldApDT05GSUdfQ0NfSEFTX01BUkNIX05BVElWRT15CiMgQ09O
RklHX1g4Nl9OQVRJVkVfQ1BVIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9JTlRFUk5PREVfQ0FD
SEVfU0hJRlQ9NgpDT05GSUdfWDg2X0wxX0NBQ0hFX1NISUZUPTYKQ09ORklHX1g4Nl9UU0M9
eQpDT05GSUdfWDg2X0hBVkVfUEFFPXkKQ09ORklHX1g4Nl9DWDg9eQpDT05GSUdfWDg2X0NN
T1Y9eQpDT05GSUdfWDg2X01JTklNVU1fQ1BVX0ZBTUlMWT02NApDT05GSUdfWDg2X0RFQlVH
Q1RMTVNSPXkKQ09ORklHX0lBMzJfRkVBVF9DVEw9eQpDT05GSUdfWDg2X1ZNWF9GRUFUVVJF
X05BTUVTPXkKQ09ORklHX1BST0NFU1NPUl9TRUxFQ1Q9eQpDT05GSUdfQlJPQURDQVNUX1RM
Ql9GTFVTSD15CkNPTkZJR19DUFVfU1VQX0lOVEVMPXkKQ09ORklHX0NQVV9TVVBfQU1EPXkK
Q09ORklHX0NQVV9TVVBfSFlHT049eQpDT05GSUdfQ1BVX1NVUF9DRU5UQVVSPXkKQ09ORklH
X0NQVV9TVVBfWkhBT1hJTj15CkNPTkZJR19IUEVUX1RJTUVSPXkKQ09ORklHX0hQRVRfRU1V
TEFURV9SVEM9eQpDT05GSUdfRE1JPXkKQ09ORklHX0dBUlRfSU9NTVU9eQpDT05GSUdfQk9P
VF9WRVNBX1NVUFBPUlQ9eQpDT05GSUdfTUFYU01QPXkKQ09ORklHX05SX0NQVVNfUkFOR0Vf
QkVHSU49ODE5MgpDT05GSUdfTlJfQ1BVU19SQU5HRV9FTkQ9ODE5MgpDT05GSUdfTlJfQ1BV
U19ERUZBVUxUPTgxOTIKQ09ORklHX05SX0NQVVM9ODE5MgpDT05GSUdfU0NIRURfTUNfUFJJ
Tz15CkNPTkZJR19YODZfTE9DQUxfQVBJQz15CkNPTkZJR19BQ1BJX01BRFRfV0FLRVVQPXkK
Q09ORklHX1g4Nl9JT19BUElDPXkKQ09ORklHX1g4Nl9SRVJPVVRFX0ZPUl9CUk9LRU5fQk9P
VF9JUlFTPXkKQ09ORklHX1g4Nl9NQ0U9eQpDT05GSUdfWDg2X01DRUxPR19MRUdBQ1k9eQpD
T05GSUdfWDg2X01DRV9JTlRFTD15CkNPTkZJR19YODZfTUNFX0FNRD15CkNPTkZJR19YODZf
TUNFX1RIUkVTSE9MRD15CiMgQ09ORklHX1g4Nl9NQ0VfSU5KRUNUIGlzIG5vdCBzZXQKCiMK
IyBQZXJmb3JtYW5jZSBtb25pdG9yaW5nCiMKQ09ORklHX1BFUkZfRVZFTlRTX0lOVEVMX1VO
Q09SRT15CkNPTkZJR19QRVJGX0VWRU5UU19JTlRFTF9SQVBMPW0KIyBDT05GSUdfUEVSRl9F
VkVOVFNfSU5URUxfQ1NUQVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfUEVSRl9FVkVOVFNfQU1E
X1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfUEVSRl9FVkVOVFNfQU1EX1VOQ09SRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BFUkZfRVZFTlRTX0FNRF9CUlMgaXMgbm90IHNldAojIGVuZCBv
ZiBQZXJmb3JtYW5jZSBtb25pdG9yaW5nCgpDT05GSUdfWDg2XzE2QklUPXkKQ09ORklHX1g4
Nl9FU1BGSVg2ND15CkNPTkZJR19YODZfVlNZU0NBTExfRU1VTEFUSU9OPXkKQ09ORklHX1g4
Nl9JT1BMX0lPUEVSTT15CkNPTkZJR19NSUNST0NPREU9eQojIENPTkZJR19NSUNST0NPREVf
TEFURV9MT0FESU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlDUk9DT0RFX0RCRyBpcyBub3Qg
c2V0CkNPTkZJR19YODZfTVNSPW0KIyBDT05GSUdfWDg2X0NQVUlEIGlzIG5vdCBzZXQKQ09O
RklHX1g4Nl9ESVJFQ1RfR0JQQUdFUz15CiMgQ09ORklHX1g4Nl9DUEFfU1RBVElTVElDUyBp
cyBub3Qgc2V0CkNPTkZJR19YODZfTUVNX0VOQ1JZUFQ9eQpDT05GSUdfQU1EX01FTV9FTkNS
WVBUPXkKQ09ORklHX05VTUE9eQpDT05GSUdfQU1EX05VTUE9eQpDT05GSUdfWDg2XzY0X0FD
UElfTlVNQT15CkNPTkZJR19OT0RFU19TSElGVD0xMApDT05GSUdfQVJDSF9TUEFSU0VNRU1f
RU5BQkxFPXkKQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0RFRkFVTFQ9eQpDT05GSUdfQVJDSF9N
RU1PUllfUFJPQkU9eQpDT05GSUdfQVJDSF9QUk9DX0tDT1JFX1RFWFQ9eQpDT05GSUdfSUxM
RUdBTF9QT0lOVEVSX1ZBTFVFPTB4ZGVhZDAwMDAwMDAwMDAwMApDT05GSUdfWDg2X1BNRU1f
TEVHQUNZX0RFVklDRT15CkNPTkZJR19YODZfUE1FTV9MRUdBQ1k9eQpDT05GSUdfWDg2X0NI
RUNLX0JJT1NfQ09SUlVQVElPTj15CkNPTkZJR19YODZfQk9PVFBBUkFNX01FTU9SWV9DT1JS
VVBUSU9OX0NIRUNLPXkKQ09ORklHX01UUlI9eQpDT05GSUdfTVRSUl9TQU5JVElaRVI9eQpD
T05GSUdfTVRSUl9TQU5JVElaRVJfRU5BQkxFX0RFRkFVTFQ9MQpDT05GSUdfTVRSUl9TQU5J
VElaRVJfU1BBUkVfUkVHX05SX0RFRkFVTFQ9MQpDT05GSUdfWDg2X1BBVD15CkNPTkZJR19Y
ODZfVU1JUD15CkNPTkZJR19DQ19IQVNfSUJUPXkKQ09ORklHX1g4Nl9DRVQ9eQpDT05GSUdf
WDg2X0tFUk5FTF9JQlQ9eQpDT05GSUdfWDg2X0lOVEVMX01FTU9SWV9QUk9URUNUSU9OX0tF
WVM9eQpDT05GSUdfQVJDSF9QS0VZX0JJVFM9NApDT05GSUdfWDg2X0lOVEVMX1RTWF9NT0RF
X09GRj15CiMgQ09ORklHX1g4Nl9JTlRFTF9UU1hfTU9ERV9PTiBpcyBub3Qgc2V0CiMgQ09O
RklHX1g4Nl9JTlRFTF9UU1hfTU9ERV9BVVRPIGlzIG5vdCBzZXQKQ09ORklHX1g4Nl9TR1g9
eQojIENPTkZJR19YODZfVVNFUl9TSEFET1dfU1RBQ0sgaXMgbm90IHNldApDT05GSUdfRUZJ
PXkKQ09ORklHX0VGSV9TVFVCPXkKQ09ORklHX0VGSV9IQU5ET1ZFUl9QUk9UT0NPTD15CkNP
TkZJR19FRklfTUlYRUQ9eQpDT05GSUdfRUZJX1JVTlRJTUVfTUFQPXkKIyBDT05GSUdfSFpf
MTAwIGlzIG5vdCBzZXQKQ09ORklHX0haXzI1MD15CiMgQ09ORklHX0haXzMwMCBpcyBub3Qg
c2V0CiMgQ09ORklHX0haXzEwMDAgaXMgbm90IHNldApDT05GSUdfSFo9MjUwCkNPTkZJR19T
Q0hFRF9IUlRJQ0s9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19LRVhFQz15CkNPTkZJR19BUkNI
X1NVUFBPUlRTX0tFWEVDX0ZJTEU9eQpDT05GSUdfQVJDSF9TRUxFQ1RTX0tFWEVDX0ZJTEU9
eQpDT05GSUdfQVJDSF9TVVBQT1JUU19LRVhFQ19QVVJHQVRPUlk9eQpDT05GSUdfQVJDSF9T
VVBQT1JUU19LRVhFQ19TSUc9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19LRVhFQ19TSUdfRk9S
Q0U9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19LRVhFQ19CWklNQUdFX1ZFUklGWV9TSUc9eQpD
T05GSUdfQVJDSF9TVVBQT1JUU19LRVhFQ19KVU1QPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNf
S0VYRUNfSEFORE9WRVI9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19DUkFTSF9EVU1QPXkKQ09O
RklHX0FSQ0hfREVGQVVMVF9DUkFTSF9EVU1QPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfQ1JB
U0hfSE9UUExVRz15CkNPTkZJR19BUkNIX0hBU19HRU5FUklDX0NSQVNIS0VSTkVMX1JFU0VS
VkFUSU9OPXkKQ09ORklHX1BIWVNJQ0FMX1NUQVJUPTB4MTAwMDAwMApDT05GSUdfUkVMT0NB
VEFCTEU9eQpDT05GSUdfUkFORE9NSVpFX0JBU0U9eQpDT05GSUdfWDg2X05FRURfUkVMT0NT
PXkKQ09ORklHX1BIWVNJQ0FMX0FMSUdOPTB4MjAwMDAwCkNPTkZJR19SQU5ET01JWkVfTUVN
T1JZPXkKQ09ORklHX1JBTkRPTUlaRV9NRU1PUllfUEhZU0lDQUxfUEFERElORz0weGEKQ09O
RklHX0hPVFBMVUdfQ1BVPXkKIyBDT05GSUdfQ09NUEFUX1ZEU08gaXMgbm90IHNldApDT05G
SUdfTEVHQUNZX1ZTWVNDQUxMX1hPTkxZPXkKIyBDT05GSUdfTEVHQUNZX1ZTWVNDQUxMX05P
TkUgaXMgbm90IHNldAojIENPTkZJR19DTURMSU5FX0JPT0wgaXMgbm90IHNldApDT05GSUdf
TU9ESUZZX0xEVF9TWVNDQUxMPXkKIyBDT05GSUdfU1RSSUNUX1NJR0FMVFNUQUNLX1NJWkUg
aXMgbm90IHNldApDT05GSUdfSEFWRV9MSVZFUEFUQ0g9eQpDT05GSUdfTElWRVBBVENIPXkK
Q09ORklHX0hBVkVfS0xQX0JVSUxEPXkKQ09ORklHX0tMUF9CVUlMRD15CkNPTkZJR19YODZf
QlVTX0xPQ0tfREVURUNUPXkKIyBlbmQgb2YgUHJvY2Vzc29yIHR5cGUgYW5kIGZlYXR1cmVz
CgpDT05GSUdfQ0NfSEFTX05BTUVEX0FTPXkKQ09ORklHX0NDX0hBU19OQU1FRF9BU19GSVhF
RF9TQU5JVElaRVJTPXkKQ09ORklHX1VTRV9YODZfU0VHX1NVUFBPUlQ9eQpDT05GSUdfQ0Nf
SEFTX1NMUz15CkNPTkZJR19DQ19IQVNfUkVUVVJOX1RIVU5LPXkKQ09ORklHX0NDX0hBU19F
TlRSWV9QQURESU5HPXkKQ09ORklHX0ZVTkNUSU9OX1BBRERJTkdfQ0ZJPTExCkNPTkZJR19G
VU5DVElPTl9QQURESU5HX0JZVEVTPTE2CkNPTkZJR19DQUxMX1BBRERJTkc9eQpDT05GSUdf
SEFWRV9DQUxMX1RIVU5LUz15CkNPTkZJR19DQUxMX1RIVU5LUz15CkNPTkZJR19QUkVGSVhf
U1lNQk9MUz15CkNPTkZJR19DUFVfTUlUSUdBVElPTlM9eQpDT05GSUdfTUlUSUdBVElPTl9Q
QUdFX1RBQkxFX0lTT0xBVElPTj15CkNPTkZJR19NSVRJR0FUSU9OX1JFVFBPTElORT15CkNP
TkZJR19NSVRJR0FUSU9OX1JFVEhVTks9eQpDT05GSUdfTUlUSUdBVElPTl9VTlJFVF9FTlRS
WT15CkNPTkZJR19NSVRJR0FUSU9OX0NBTExfREVQVEhfVFJBQ0tJTkc9eQojIENPTkZJR19D
QUxMX1RIVU5LU19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19NSVRJR0FUSU9OX0lCUEJfRU5U
Ulk9eQpDT05GSUdfTUlUSUdBVElPTl9JQlJTX0VOVFJZPXkKQ09ORklHX01JVElHQVRJT05f
U1JTTz15CiMgQ09ORklHX01JVElHQVRJT05fU0xTIGlzIG5vdCBzZXQKQ09ORklHX01JVElH
QVRJT05fR0RTPXkKQ09ORklHX01JVElHQVRJT05fUkZEUz15CkNPTkZJR19NSVRJR0FUSU9O
X1NQRUNUUkVfQkhJPXkKQ09ORklHX01JVElHQVRJT05fTURTPXkKQ09ORklHX01JVElHQVRJ
T05fVEFBPXkKQ09ORklHX01JVElHQVRJT05fTU1JT19TVEFMRV9EQVRBPXkKQ09ORklHX01J
VElHQVRJT05fTDFURj15CkNPTkZJR19NSVRJR0FUSU9OX1JFVEJMRUVEPXkKQ09ORklHX01J
VElHQVRJT05fU1BFQ1RSRV9WMT15CkNPTkZJR19NSVRJR0FUSU9OX1NQRUNUUkVfVjI9eQpD
T05GSUdfTUlUSUdBVElPTl9TUkJEUz15CkNPTkZJR19NSVRJR0FUSU9OX1NTQj15CkNPTkZJ
R19NSVRJR0FUSU9OX0lUUz15CkNPTkZJR19NSVRJR0FUSU9OX1RTQT15CkNPTkZJR19NSVRJ
R0FUSU9OX1ZNU0NBUEU9eQpDT05GSUdfQVJDSF9IQVNfQUREX1BBR0VTPXkKCiMKIyBQb3dl
ciBtYW5hZ2VtZW50IGFuZCBBQ1BJIG9wdGlvbnMKIwpDT05GSUdfQVJDSF9ISUJFUk5BVElP
Tl9IRUFERVI9eQpDT05GSUdfU1VTUEVORD15CkNPTkZJR19TVVNQRU5EX0ZSRUVaRVI9eQoj
IENPTkZJR19TVVNQRU5EX1NLSVBfU1lOQyBpcyBub3Qgc2V0CkNPTkZJR19ISUJFUk5BVEVf
Q0FMTEJBQ0tTPXkKQ09ORklHX0hJQkVSTkFUSU9OPXkKQ09ORklHX0hJQkVSTkFUSU9OX1NO
QVBTSE9UX0RFVj15CkNPTkZJR19ISUJFUk5BVElPTl9DT01QX0xaTz15CkNPTkZJR19ISUJF
Uk5BVElPTl9ERUZfQ09NUD0ibHpvIgpDT05GSUdfUE1fU1REX1BBUlRJVElPTj0iIgpDT05G
SUdfUE1fU0xFRVA9eQpDT05GSUdfUE1fU0xFRVBfU01QPXkKIyBDT05GSUdfUE1fQVVUT1NM
RUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1fVVNFUlNQQUNFX0FVVE9TTEVFUCBpcyBub3Qg
c2V0CkNPTkZJR19QTV9XQUtFTE9DS1M9eQpDT05GSUdfUE1fV0FLRUxPQ0tTX0xJTUlUPTEw
MApDT05GSUdfUE1fV0FLRUxPQ0tTX0dDPXkKIyBDT05GSUdfUE1fUU9TX0NQVV9TWVNURU1f
V0FLRVVQIGlzIG5vdCBzZXQKQ09ORklHX1BNPXkKQ09ORklHX1BNX0RFQlVHPXkKQ09ORklH
X1BNX0FEVkFOQ0VEX0RFQlVHPXkKIyBDT05GSUdfUE1fVEVTVF9TVVNQRU5EIGlzIG5vdCBz
ZXQKQ09ORklHX1BNX1NMRUVQX0RFQlVHPXkKIyBDT05GSUdfRFBNX1dBVENIRE9HIGlzIG5v
dCBzZXQKQ09ORklHX1BNX1RSQUNFPXkKQ09ORklHX1BNX1RSQUNFX1JUQz15CkNPTkZJR19Q
TV9DTEs9eQpDT05GSUdfV1FfUE9XRVJfRUZGSUNJRU5UX0RFRkFVTFQ9eQpDT05GSUdfRU5F
UkdZX01PREVMPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfQUNQST15CkNPTkZJR19BQ1BJPXkK
Q09ORklHX0FDUElfTEVHQUNZX1RBQkxFU19MT09LVVA9eQpDT05GSUdfQVJDSF9NSUdIVF9I
QVZFX0FDUElfUERDPXkKQ09ORklHX0FDUElfU1lTVEVNX1BPV0VSX1NUQVRFU19TVVBQT1JU
PXkKQ09ORklHX0FDUElfVEhFUk1BTF9MSUI9eQpDT05GSUdfQUNQSV9ERUJVR0dFUj15CkNP
TkZJR19BQ1BJX0RFQlVHR0VSX1VTRVI9eQpDT05GSUdfQUNQSV9TUENSX1RBQkxFPXkKQ09O
RklHX0FDUElfRlBEVD15CkNPTkZJR19BQ1BJX0xQSVQ9eQpDT05GSUdfQUNQSV9TTEVFUD15
CkNPTkZJR19BQ1BJX1JFVl9PVkVSUklERV9QT1NTSUJMRT15CkNPTkZJR19BQ1BJX0VDPXkK
IyBDT05GSUdfQUNQSV9FQ19ERUJVR0ZTIGlzIG5vdCBzZXQKQ09ORklHX0FDUElfQUM9eQpD
T05GSUdfQUNQSV9CQVRURVJZPXkKQ09ORklHX0FDUElfQlVUVE9OPXkKIyBDT05GSUdfQUNQ
SV9WSURFTyBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX0ZBTj15CiMgQ09ORklHX0FDUElfVEFE
IGlzIG5vdCBzZXQKQ09ORklHX0FDUElfRE9DSz15CkNPTkZJR19BQ1BJX0NQVV9GUkVRX1BT
Uz15CkNPTkZJR19BQ1BJX1BST0NFU1NPUl9DU1RBVEU9eQpDT05GSUdfQUNQSV9QUk9DRVNT
T1JfSURMRT15CkNPTkZJR19BQ1BJX0NQUENfTElCPXkKQ09ORklHX0FDUElfUFJPQ0VTU09S
PXkKQ09ORklHX0FDUElfSVBNST1tCkNPTkZJR19BQ1BJX0hPVFBMVUdfQ1BVPXkKIyBDT05G
SUdfQUNQSV9QUk9DRVNTT1JfQUdHUkVHQVRPUiBpcyBub3Qgc2V0CkNPTkZJR19BQ1BJX1RI
RVJNQUw9eQpDT05GSUdfQUNQSV9QTEFURk9STV9QUk9GSUxFPW0KQ09ORklHX0FDUElfQ1VT
VE9NX0RTRFRfRklMRT0iIgpDT05GSUdfQVJDSF9IQVNfQUNQSV9UQUJMRV9VUEdSQURFPXkK
Q09ORklHX0FDUElfVEFCTEVfVVBHUkFERT15CkNPTkZJR19BQ1BJX0RFQlVHPXkKQ09ORklH
X0FDUElfUENJX1NMT1Q9eQpDT05GSUdfQUNQSV9DT05UQUlORVI9eQpDT05GSUdfQUNQSV9I
T1RQTFVHX01FTU9SWT15CkNPTkZJR19BQ1BJX0hPVFBMVUdfSU9BUElDPXkKIyBDT05GSUdf
QUNQSV9TQlMgaXMgbm90IHNldApDT05GSUdfQUNQSV9IRUQ9eQpDT05GSUdfQUNQSV9CR1JU
PXkKIyBDT05GSUdfQUNQSV9SRURVQ0VEX0hBUkRXQVJFX09OTFkgaXMgbm90IHNldAojIENP
TkZJR19BQ1BJX05GSVQgaXMgbm90IHNldApDT05GSUdfQUNQSV9OVU1BPXkKQ09ORklHX0FD
UElfSE1BVD15CkNPTkZJR19IQVZFX0FDUElfQVBFST15CkNPTkZJR19IQVZFX0FDUElfQVBF
SV9OTUk9eQpDT05GSUdfQUNQSV9BUEVJPXkKQ09ORklHX0FDUElfQVBFSV9HSEVTPXkKQ09O
RklHX0FDUElfQVBFSV9QQ0lFQUVSPXkKQ09ORklHX0FDUElfQVBFSV9NRU1PUllfRkFJTFVS
RT15CiMgQ09ORklHX0FDUElfQVBFSV9FSU5KIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNQSV9B
UEVJX0VSU1RfREVCVUcgaXMgbm90IHNldApDT05GSUdfQUNQSV9EUFRGPXkKIyBDT05GSUdf
RFBURl9QT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RQVEZfUENIX0ZJVlIgaXMgbm90IHNl
dApDT05GSUdfQUNQSV9XQVRDSERPRz15CiMgQ09ORklHX0FDUElfRVhUTE9HIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQUNQSV9DT05GSUdGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUEZS
VVQgaXMgbm90IHNldApDT05GSUdfQUNQSV9QQ0M9eQojIENPTkZJR19BQ1BJX0ZGSCBpcyBu
b3Qgc2V0CkNPTkZJR19BQ1BJX01SUk09eQpDT05GSUdfUE1JQ19PUFJFR0lPTj15CkNPTkZJ
R19CWVRDUkNfUE1JQ19PUFJFR0lPTj15CkNPTkZJR19DSFRDUkNfUE1JQ19PUFJFR0lPTj15
CkNPTkZJR19DSFRfV0NfUE1JQ19PUFJFR0lPTj15CkNPTkZJR19BQ1BJX1ZJT1Q9eQpDT05G
SUdfQUNQSV9QUk1UPXkKQ09ORklHX1g4Nl9QTV9USU1FUj15CgojCiMgQ1BVIEZyZXF1ZW5j
eSBzY2FsaW5nCiMKQ09ORklHX0NQVV9GUkVRPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9BVFRS
X1NFVD15CkNPTkZJR19DUFVfRlJFUV9HT1ZfQ09NTU9OPXkKQ09ORklHX0NQVV9GUkVRX1NU
QVQ9eQojIENPTkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9QRVJGT1JNQU5DRSBpcyBub3Qg
c2V0CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1BPV0VSU0FWRSBpcyBub3Qgc2V0
CiMgQ09ORklHX0NQVV9GUkVRX0RFRkFVTFRfR09WX1VTRVJTUEFDRSBpcyBub3Qgc2V0CkNP
TkZJR19DUFVfRlJFUV9ERUZBVUxUX0dPVl9TQ0hFRFVUSUw9eQpDT05GSUdfQ1BVX0ZSRVFf
R09WX1BFUkZPUk1BTkNFPXkKQ09ORklHX0NQVV9GUkVRX0dPVl9QT1dFUlNBVkU9eQpDT05G
SUdfQ1BVX0ZSRVFfR09WX1VTRVJTUEFDRT15CkNPTkZJR19DUFVfRlJFUV9HT1ZfT05ERU1B
TkQ9eQpDT05GSUdfQ1BVX0ZSRVFfR09WX0NPTlNFUlZBVElWRT15CkNPTkZJR19DUFVfRlJF
UV9HT1ZfU0NIRURVVElMPXkKCiMKIyBDUFUgZnJlcXVlbmN5IHNjYWxpbmcgZHJpdmVycwoj
CkNPTkZJR19YODZfSU5URUxfUFNUQVRFPXkKQ09ORklHX1g4Nl9QQ0NfQ1BVRlJFUT15CkNP
TkZJR19YODZfQU1EX1BTVEFURT15CkNPTkZJR19YODZfQU1EX1BTVEFURV9ERUZBVUxUX01P
REU9MwojIENPTkZJR19YODZfQU1EX1BTVEFURV9VVCBpcyBub3Qgc2V0CkNPTkZJR19YODZf
QUNQSV9DUFVGUkVRPXkKQ09ORklHX1g4Nl9BQ1BJX0NQVUZSRVFfQ1BCPXkKQ09ORklHX1g4
Nl9QT1dFUk5PV19LOD15CiMgQ09ORklHX1g4Nl9BTURfRlJFUV9TRU5TSVRJVklUWSBpcyBu
b3Qgc2V0CkNPTkZJR19YODZfU1BFRURTVEVQX0NFTlRSSU5PPXkKIyBDT05GSUdfWDg2X1A0
X0NMT0NLTU9EIGlzIG5vdCBzZXQKCiMKIyBzaGFyZWQgb3B0aW9ucwojCkNPTkZJR19DUFVG
UkVRX0FSQ0hfQ1VSX0ZSRVE9eQojIGVuZCBvZiBDUFUgRnJlcXVlbmN5IHNjYWxpbmcKCiMK
IyBDUFUgSWRsZQojCkNPTkZJR19DUFVfSURMRT15CkNPTkZJR19DUFVfSURMRV9HT1ZfTEFE
REVSPXkKQ09ORklHX0NQVV9JRExFX0dPVl9NRU5VPXkKQ09ORklHX0NQVV9JRExFX0dPVl9U
RU89eQpDT05GSUdfQ1BVX0lETEVfR09WX0hBTFRQT0xMPXkKIyBDT05GSUdfSEFMVFBPTExf
Q1BVSURMRSBpcyBub3Qgc2V0CiMgZW5kIG9mIENQVSBJZGxlCgpDT05GSUdfSU5URUxfSURM
RT15CiMgZW5kIG9mIFBvd2VyIG1hbmFnZW1lbnQgYW5kIEFDUEkgb3B0aW9ucwoKIwojIEJ1
cyBvcHRpb25zIChQQ0kgZXRjLikKIwpDT05GSUdfUENJX0RJUkVDVD15CkNPTkZJR19QQ0lf
TU1DT05GSUc9eQpDT05GSUdfUENJX1hFTj15CkNPTkZJR19NTUNPTkZfRkFNMTBIPXkKQ09O
RklHX0lTQV9CVVM9eQpDT05GSUdfSVNBX0RNQV9BUEk9eQpDT05GSUdfQU1EX05CPXkKQ09O
RklHX0FNRF9OT0RFPXkKIyBlbmQgb2YgQnVzIG9wdGlvbnMgKFBDSSBldGMuKQoKIwojIEJp
bmFyeSBFbXVsYXRpb25zCiMKQ09ORklHX0lBMzJfRU1VTEFUSU9OPXkKIyBDT05GSUdfSUEz
Ml9FTVVMQVRJT05fREVGQVVMVF9ESVNBQkxFRCBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9Y
MzJfQUJJIGlzIG5vdCBzZXQKQ09ORklHX0NPTVBBVF8zMj15CkNPTkZJR19DT01QQVQ9eQpD
T05GSUdfQ09NUEFUX0ZPUl9VNjRfQUxJR05NRU5UPXkKIyBlbmQgb2YgQmluYXJ5IEVtdWxh
dGlvbnMKCkNPTkZJR19LVk1fQ09NTU9OPXkKQ09ORklHX0hBVkVfS1ZNX1BGTkNBQ0hFPXkK
Q09ORklHX0hBVkVfS1ZNX0lSUUNISVA9eQpDT05GSUdfSEFWRV9LVk1fSVJRX1JPVVRJTkc9
eQpDT05GSUdfSEFWRV9LVk1fRElSVFlfUklORz15CkNPTkZJR19IQVZFX0tWTV9ESVJUWV9S
SU5HX1RTTz15CkNPTkZJR19IQVZFX0tWTV9ESVJUWV9SSU5HX0FDUV9SRUw9eQpDT05GSUdf
S1ZNX01NSU89eQpDT05GSUdfS1ZNX0FTWU5DX1BGPXkKQ09ORklHX0hBVkVfS1ZNX01TST15
CkNPTkZJR19IQVZFX0tWTV9SRUFET05MWV9NRU09eQpDT05GSUdfSEFWRV9LVk1fQ1BVX1JF
TEFYX0lOVEVSQ0VQVD15CkNPTkZJR19LVk1fVkZJTz15CkNPTkZJR19LVk1fR0VORVJJQ19E
SVJUWUxPR19SRUFEX1BST1RFQ1Q9eQpDT05GSUdfS1ZNX0dFTkVSSUNfUFJFX0ZBVUxUX01F
TU9SWT15CkNPTkZJR19LVk1fQ09NUEFUPXkKQ09ORklHX0hBVkVfS1ZNX0lSUV9CWVBBU1M9
eQpDT05GSUdfSEFWRV9LVk1fTk9fUE9MTD15CkNPTkZJR19WSVJUX1hGRVJfVE9fR1VFU1Rf
V09SSz15CkNPTkZJR19IQVZFX0tWTV9QTV9OT1RJRklFUj15CkNPTkZJR19LVk1fR0VORVJJ
Q19IQVJEV0FSRV9FTkFCTElORz15CkNPTkZJR19LVk1fR0VORVJJQ19NTVVfTk9USUZJRVI9
eQpDT05GSUdfS1ZNX0VMSURFX1RMQl9GTFVTSF9JRl9ZT1VORz15CkNPTkZJR19LVk1fTU1V
X0xPQ0tMRVNTX0FHSU5HPXkKQ09ORklHX0tWTV9HRU5FUklDX01FTU9SWV9BVFRSSUJVVEVT
PXkKQ09ORklHX0tWTV9HVUVTVF9NRU1GRD15CkNPTkZJR19IQVZFX0tWTV9BUkNIX0dNRU1f
UFJFUEFSRT15CkNPTkZJR19IQVZFX0tWTV9BUkNIX0dNRU1fSU5WQUxJREFURT15CkNPTkZJ
R19IQVZFX0tWTV9BUkNIX0dNRU1fUE9QVUxBVEU9eQpDT05GSUdfVklSVFVBTElaQVRJT049
eQpDT05GSUdfS1ZNX1g4Nj15CkNPTkZJR19LVk09eQpDT05GSUdfS1ZNX1dFUlJPUj15CiMg
Q09ORklHX0tWTV9TV19QUk9URUNURURfVk0gaXMgbm90IHNldAojIENPTkZJR19LVk1fSU5U
RUwgaXMgbm90IHNldApDT05GSUdfS1ZNX0FNRD1tCkNPTkZJR19LVk1fQU1EX1NFVj15CkNP
TkZJR19LVk1fSU9BUElDPXkKQ09ORklHX0tWTV9TTU09eQpDT05GSUdfS1ZNX0hZUEVSVj15
CkNPTkZJR19LVk1fWEVOPXkKIyBDT05GSUdfS1ZNX1BST1ZFX01NVSBpcyBub3Qgc2V0CkNP
TkZJR19LVk1fTUFYX05SX1ZDUFVTPTQwOTYKQ09ORklHX1g4Nl9SRVFVSVJFRF9GRUFUVVJF
X0FMV0FZUz15CkNPTkZJR19YODZfUkVRVUlSRURfRkVBVFVSRV9OT1BMPXkKQ09ORklHX1g4
Nl9SRVFVSVJFRF9GRUFUVVJFX0NYOD15CkNPTkZJR19YODZfUkVRVUlSRURfRkVBVFVSRV9D
TU9WPXkKQ09ORklHX1g4Nl9SRVFVSVJFRF9GRUFUVVJFX0NQVUlEPXkKQ09ORklHX1g4Nl9S
RVFVSVJFRF9GRUFUVVJFX0ZQVT15CkNPTkZJR19YODZfUkVRVUlSRURfRkVBVFVSRV9QQUU9
eQpDT05GSUdfWDg2X1JFUVVJUkVEX0ZFQVRVUkVfTVNSPXkKQ09ORklHX1g4Nl9SRVFVSVJF
RF9GRUFUVVJFX0ZYU1I9eQpDT05GSUdfWDg2X1JFUVVJUkVEX0ZFQVRVUkVfWE1NPXkKQ09O
RklHX1g4Nl9SRVFVSVJFRF9GRUFUVVJFX1hNTTI9eQpDT05GSUdfWDg2X1JFUVVJUkVEX0ZF
QVRVUkVfTE09eQpDT05GSUdfWDg2X0RJU0FCTEVEX0ZFQVRVUkVfVk1FPXkKQ09ORklHX1g4
Nl9ESVNBQkxFRF9GRUFUVVJFX0s2X01UUlI9eQpDT05GSUdfWDg2X0RJU0FCTEVEX0ZFQVRV
UkVfQ1lSSVhfQVJSPXkKQ09ORklHX1g4Nl9ESVNBQkxFRF9GRUFUVVJFX0NFTlRBVVJfTUNS
PXkKQ09ORklHX1g4Nl9ESVNBQkxFRF9GRUFUVVJFX0xBTT15CkNPTkZJR19YODZfRElTQUJM
RURfRkVBVFVSRV9URFhfR1VFU1Q9eQpDT05GSUdfWDg2X0RJU0FCTEVEX0ZFQVRVUkVfVVNF
Ul9TSFNUSz15CkNPTkZJR19YODZfRElTQUJMRURfRkVBVFVSRV9GUkVEPXkKQ09ORklHX0FT
X1dSVVNTPXkKQ09ORklHX0FSQ0hfQ09ORklHVVJFU19DUFVfTUlUSUdBVElPTlM9eQpDT05G
SUdfQVJDSF9IQVNfRE1BX09QUz15CgojCiMgR2VuZXJhbCBhcmNoaXRlY3R1cmUtZGVwZW5k
ZW50IG9wdGlvbnMKIwpDT05GSUdfSE9UUExVR19TTVQ9eQpDT05GSUdfQVJDSF9TVVBQT1JU
U19TQ0hFRF9TTVQ9eQpDT05GSUdfQVJDSF9TVVBQT1JUU19TQ0hFRF9DTFVTVEVSPXkKQ09O
RklHX0FSQ0hfU1VQUE9SVFNfU0NIRURfTUM9eQpDT05GSUdfU0NIRURfU01UPXkKQ09ORklH
X1NDSEVEX0NMVVNURVI9eQpDT05GSUdfU0NIRURfTUM9eQpDT05GSUdfSE9UUExVR19DT1JF
X1NZTkM9eQpDT05GSUdfSE9UUExVR19DT1JFX1NZTkNfREVBRD15CkNPTkZJR19IT1RQTFVH
X0NPUkVfU1lOQ19GVUxMPXkKQ09ORklHX0hPVFBMVUdfU1BMSVRfU1RBUlRVUD15CkNPTkZJ
R19IT1RQTFVHX1BBUkFMTEVMPXkKQ09ORklHX0dFTkVSSUNfSVJRX0VOVFJZPXkKQ09ORklH
X0dFTkVSSUNfU1lTQ0FMTD15CkNPTkZJR19HRU5FUklDX0VOVFJZPXkKQ09ORklHX0tQUk9C
RVM9eQpDT05GSUdfSlVNUF9MQUJFTD15CiMgQ09ORklHX1NUQVRJQ19LRVlTX1NFTEZURVNU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU1RBVElDX0NBTExfU0VMRlRFU1QgaXMgbm90IHNldApD
T05GSUdfT1BUUFJPQkVTPXkKQ09ORklHX0tQUk9CRVNfT05fRlRSQUNFPXkKQ09ORklHX1VQ
Uk9CRVM9eQpDT05GSUdfSEFWRV9FRkZJQ0lFTlRfVU5BTElHTkVEX0FDQ0VTUz15CkNPTkZJ
R19BUkNIX1VTRV9CVUlMVElOX0JTV0FQPXkKQ09ORklHX0tSRVRQUk9CRVM9eQpDT05GSUdf
S1JFVFBST0JFX09OX1JFVEhPT0s9eQpDT05GSUdfVVNFUl9SRVRVUk5fTk9USUZJRVI9eQpD
T05GSUdfSEFWRV9JT1JFTUFQX1BST1Q9eQpDT05GSUdfSEFWRV9LUFJPQkVTPXkKQ09ORklH
X0hBVkVfS1JFVFBST0JFUz15CkNPTkZJR19IQVZFX09QVFBST0JFUz15CkNPTkZJR19IQVZF
X0tQUk9CRVNfT05fRlRSQUNFPXkKQ09ORklHX0FSQ0hfQ09SUkVDVF9TVEFDS1RSQUNFX09O
X0tSRVRQUk9CRT15CkNPTkZJR19IQVZFX0ZVTkNUSU9OX0VSUk9SX0lOSkVDVElPTj15CkNP
TkZJR19IQVZFX05NST15CkNPTkZJR19UUkFDRV9JUlFGTEFHU19TVVBQT1JUPXkKQ09ORklH
X1RSQUNFX0lSUUZMQUdTX05NSV9TVVBQT1JUPXkKQ09ORklHX0hBVkVfQVJDSF9UUkFDRUhP
T0s9eQpDT05GSUdfSEFWRV9ETUFfQ09OVElHVU9VUz15CkNPTkZJR19HRU5FUklDX1NNUF9J
RExFX1RIUkVBRD15CkNPTkZJR19BUkNIX0hBU19GT1JUSUZZX1NPVVJDRT15CkNPTkZJR19B
UkNIX0hBU19TRVRfTUVNT1JZPXkKQ09ORklHX0FSQ0hfSEFTX1NFVF9ESVJFQ1RfTUFQPXkK
Q09ORklHX0FSQ0hfSEFTX0NQVV9GSU5BTElaRV9JTklUPXkKQ09ORklHX0FSQ0hfSEFTX0NQ
VV9QQVNJRD15CkNPTkZJR19IQVZFX0FSQ0hfVEhSRUFEX1NUUlVDVF9XSElURUxJU1Q9eQpD
T05GSUdfQVJDSF9XQU5UU19EWU5BTUlDX1RBU0tfU1RSVUNUPXkKQ09ORklHX0FSQ0hfV0FO
VFNfTk9fSU5TVFI9eQpDT05GSUdfSEFWRV9BU01fTU9EVkVSU0lPTlM9eQpDT05GSUdfSEFW
RV9SRUdTX0FORF9TVEFDS19BQ0NFU1NfQVBJPXkKQ09ORklHX0hBVkVfUlNFUT15CkNPTkZJ
R19IQVZFX1JVU1Q9eQpDT05GSUdfSEFWRV9GVU5DVElPTl9BUkdfQUNDRVNTX0FQST15CkNP
TkZJR19IQVZFX0hXX0JSRUFLUE9JTlQ9eQpDT05GSUdfSEFWRV9NSVhFRF9CUkVBS1BPSU5U
U19SRUdTPXkKQ09ORklHX0hBVkVfVVNFUl9SRVRVUk5fTk9USUZJRVI9eQpDT05GSUdfSEFW
RV9QRVJGX0VWRU5UU19OTUk9eQpDT05GSUdfSEFWRV9IQVJETE9DS1VQX0RFVEVDVE9SX1BF
UkY9eQpDT05GSUdfVU5XSU5EX1VTRVI9eQpDT05GSUdfSEFWRV9VTldJTkRfVVNFUl9GUD15
CkNPTkZJR19IQVZFX1BFUkZfUkVHUz15CkNPTkZJR19IQVZFX1BFUkZfVVNFUl9TVEFDS19E
VU1QPXkKQ09ORklHX0hBVkVfQVJDSF9KVU1QX0xBQkVMPXkKQ09ORklHX0hBVkVfQVJDSF9K
VU1QX0xBQkVMX1JFTEFUSVZFPXkKQ09ORklHX01NVV9HQVRIRVJfVEFCTEVfRlJFRT15CkNP
TkZJR19NTVVfR0FUSEVSX1JDVV9UQUJMRV9GUkVFPXkKQ09ORklHX01NVV9HQVRIRVJfTUVS
R0VfVk1BUz15CkNPTkZJR19BUkNIX1dBTlRfSVJRU19PRkZfQUNUSVZBVEVfTU09eQpDT05G
SUdfTU1VX0xBWllfVExCX1JFRkNPVU5UPXkKQ09ORklHX0FSQ0hfSEFWRV9OTUlfU0FGRV9D
TVBYQ0hHPXkKQ09ORklHX0FSQ0hfSEFWRV9FWFRSQV9FTEZfTk9URVM9eQpDT05GSUdfQVJD
SF9IQVNfTk1JX1NBRkVfVEhJU19DUFVfT1BTPXkKQ09ORklHX0hBVkVfQUxJR05FRF9TVFJV
Q1RfUEFHRT15CkNPTkZJR19IQVZFX0NNUFhDSEdfTE9DQUw9eQpDT05GSUdfSEFWRV9DTVBY
Q0hHX0RPVUJMRT15CkNPTkZJR19BUkNIX1dBTlRfQ09NUEFUX0lQQ19QQVJTRV9WRVJTSU9O
PXkKQ09ORklHX0FSQ0hfV0FOVF9PTERfQ09NUEFUX0lQQz15CkNPTkZJR19IQVZFX0FSQ0hf
U0VDQ09NUD15CkNPTkZJR19IQVZFX0FSQ0hfU0VDQ09NUF9GSUxURVI9eQpDT05GSUdfU0VD
Q09NUD15CkNPTkZJR19TRUNDT01QX0ZJTFRFUj15CiMgQ09ORklHX1NFQ0NPTVBfQ0FDSEVf
REVCVUcgaXMgbm90IHNldApDT05GSUdfSEFWRV9BUkNIX0tTVEFDS19FUkFTRT15CkNPTkZJ
R19IQVZFX1NUQUNLUFJPVEVDVE9SPXkKQ09ORklHX1NUQUNLUFJPVEVDVE9SPXkKQ09ORklH
X1NUQUNLUFJPVEVDVE9SX1NUUk9ORz15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0xUT19DTEFO
Rz15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0xUT19DTEFOR19USElOPXkKQ09ORklHX0xUT19O
T05FPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfQVVUT0ZET19DTEFORz15CkNPTkZJR19BUkNI
X1NVUFBPUlRTX1BST1BFTExFUl9DTEFORz15CkNPTkZJR19BUkNIX1NVUFBPUlRTX0NGST15
CkNPTkZJR19IQVZFX0FSQ0hfV0lUSElOX1NUQUNLX0ZSQU1FUz15CkNPTkZJR19IQVZFX0NP
TlRFWFRfVFJBQ0tJTkdfVVNFUj15CkNPTkZJR19IQVZFX0NPTlRFWFRfVFJBQ0tJTkdfVVNF
Ul9PRkZTVEFDSz15CkNPTkZJR19IQVZFX1ZJUlRfQ1BVX0FDQ09VTlRJTkdfR0VOPXkKQ09O
RklHX0hBVkVfSVJRX1RJTUVfQUNDT1VOVElORz15CkNPTkZJR19IQVZFX01PVkVfUFVEPXkK
Q09ORklHX0hBVkVfTU9WRV9QTUQ9eQpDT05GSUdfSEFWRV9BUkNIX1RSQU5TUEFSRU5UX0hV
R0VQQUdFPXkKQ09ORklHX0hBVkVfQVJDSF9UUkFOU1BBUkVOVF9IVUdFUEFHRV9QVUQ9eQpD
T05GSUdfSEFWRV9BUkNIX0hVR0VfVk1BUD15CkNPTkZJR19IQVZFX0FSQ0hfSFVHRV9WTUFM
TE9DPXkKQ09ORklHX0FSQ0hfV0FOVF9IVUdFX1BNRF9TSEFSRT15CkNPTkZJR19BUkNIX1dB
TlRfUE1EX01LV1JJVEU9eQpDT05GSUdfSEFWRV9BUkNIX1NPRlRfRElSVFk9eQpDT05GSUdf
SEFWRV9NT0RfQVJDSF9TUEVDSUZJQz15CkNPTkZJR19NT0RVTEVTX1VTRV9FTEZfUkVMQT15
CkNPTkZJR19BUkNIX0hBU19FWEVDTUVNX1JPWD15CkNPTkZJR19IQVZFX0lSUV9FWElUX09O
X0lSUV9TVEFDSz15CkNPTkZJR19IQVZFX1NPRlRJUlFfT05fT1dOX1NUQUNLPXkKQ09ORklH
X1NPRlRJUlFfT05fT1dOX1NUQUNLPXkKQ09ORklHX0FSQ0hfSEFTX0VMRl9SQU5ET01JWkU9
eQpDT05GSUdfSEFWRV9BUkNIX01NQVBfUk5EX0JJVFM9eQpDT05GSUdfSEFWRV9FWElUX1RI
UkVBRD15CkNPTkZJR19BUkNIX01NQVBfUk5EX0JJVFM9MjgKQ09ORklHX0hBVkVfQVJDSF9N
TUFQX1JORF9DT01QQVRfQklUUz15CkNPTkZJR19BUkNIX01NQVBfUk5EX0NPTVBBVF9CSVRT
PTgKQ09ORklHX0hBVkVfQVJDSF9DT01QQVRfTU1BUF9CQVNFUz15CkNPTkZJR19IQVZFX1BB
R0VfU0laRV80S0I9eQpDT05GSUdfUEFHRV9TSVpFXzRLQj15CkNPTkZJR19QQUdFX1NJWkVf
TEVTU19USEFOXzY0S0I9eQpDT05GSUdfUEFHRV9TSVpFX0xFU1NfVEhBTl8yNTZLQj15CkNP
TkZJR19QQUdFX1NISUZUPTEyCkNPTkZJR19IQVZFX09CSlRPT0w9eQpDT05GSUdfSEFWRV9K
VU1QX0xBQkVMX0hBQ0s9eQpDT05GSUdfSEFWRV9OT0lOU1RSX0hBQ0s9eQpDT05GSUdfSEFW
RV9OT0lOU1RSX1ZBTElEQVRJT049eQpDT05GSUdfSEFWRV9VQUNDRVNTX1ZBTElEQVRJT049
eQpDT05GSUdfSEFWRV9TVEFDS19WQUxJREFUSU9OPXkKQ09ORklHX0hBVkVfUkVMSUFCTEVf
U1RBQ0tUUkFDRT15CkNPTkZJR19PTERfU0lHU1VTUEVORDM9eQpDT05GSUdfQ09NUEFUX09M
RF9TSUdBQ1RJT049eQpDT05GSUdfQ09NUEFUXzMyQklUX1RJTUU9eQpDT05GSUdfQVJDSF9T
VVBQT1JUU19SVD15CkNPTkZJR19IQVZFX0FSQ0hfVk1BUF9TVEFDSz15CkNPTkZJR19WTUFQ
X1NUQUNLPXkKQ09ORklHX0hBVkVfQVJDSF9SQU5ET01JWkVfS1NUQUNLX09GRlNFVD15CkNP
TkZJR19SQU5ET01JWkVfS1NUQUNLX09GRlNFVD15CkNPTkZJR19SQU5ET01JWkVfS1NUQUNL
X09GRlNFVF9ERUZBVUxUPXkKQ09ORklHX0FSQ0hfSEFTX1NUUklDVF9LRVJORUxfUldYPXkK
Q09ORklHX1NUUklDVF9LRVJORUxfUldYPXkKQ09ORklHX0FSQ0hfSEFTX1NUUklDVF9NT0RV
TEVfUldYPXkKQ09ORklHX1NUUklDVF9NT0RVTEVfUldYPXkKQ09ORklHX0FSQ0hfSEFTX0NQ
VV9SRVNDVFJMPXkKQ09ORklHX0hBVkVfQVJDSF9QUkVMMzJfUkVMT0NBVElPTlM9eQpDT05G
SUdfQVJDSF9VU0VfTUVNUkVNQVBfUFJPVD15CiMgQ09ORklHX0xPQ0tfRVZFTlRfQ09VTlRT
IGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfSEFTX01FTV9FTkNSWVBUPXkKQ09ORklHX0FSQ0hf
SEFTX0NDX1BMQVRGT1JNPXkKQ09ORklHX0hBVkVfU1RBVElDX0NBTEw9eQpDT05GSUdfSEFW
RV9TVEFUSUNfQ0FMTF9JTkxJTkU9eQpDT05GSUdfSEFWRV9QUkVFTVBUX0RZTkFNSUM9eQpD
T05GSUdfSEFWRV9QUkVFTVBUX0RZTkFNSUNfQ0FMTD15CkNPTkZJR19BUkNIX1dBTlRfTERf
T1JQSEFOX1dBUk49eQpDT05GSUdfQVJDSF9TVVBQT1JUU19ERUJVR19QQUdFQUxMT0M9eQpD
T05GSUdfQVJDSF9TVVBQT1JUU19QQUdFX1RBQkxFX0NIRUNLPXkKQ09ORklHX0FSQ0hfSEFT
X0VMRkNPUkVfQ09NUEFUPXkKQ09ORklHX0FSQ0hfSEFTX1BBUkFOT0lEX0wxRF9GTFVTSD15
CkNPTkZJR19EWU5BTUlDX1NJR0ZSQU1FPXkKQ09ORklHX0hBVkVfQVJDSF9OT0RFX0RFVl9H
Uk9VUD15CkNPTkZJR19BUkNIX0hBU19IV19QVEVfWU9VTkc9eQpDT05GSUdfQVJDSF9IQVNf
Tk9OTEVBRl9QTURfWU9VTkc9eQpDT05GSUdfQVJDSF9IQVNfS0VSTkVMX0ZQVV9TVVBQT1JU
PXkKQ09ORklHX0FSQ0hfVk1MSU5VWF9ORUVEU19SRUxPQ1M9eQpDT05GSUdfSEFWRV9HRU5F
UklDX1RJRl9CSVRTPXkKCiMKIyBHQ09WLWJhc2VkIGtlcm5lbCBwcm9maWxpbmcKIwojIENP
TkZJR19HQ09WX0tFUk5FTCBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hBU19HQ09WX1BST0ZJ
TEVfQUxMPXkKIyBlbmQgb2YgR0NPVi1iYXNlZCBrZXJuZWwgcHJvZmlsaW5nCgpDT05GSUdf
SEFWRV9HQ0NfUExVR0lOUz15CkNPTkZJR19GVU5DVElPTl9BTElHTk1FTlRfNEI9eQpDT05G
SUdfRlVOQ1RJT05fQUxJR05NRU5UXzE2Qj15CkNPTkZJR19GVU5DVElPTl9BTElHTk1FTlQ9
MTYKQ09ORklHX0FSQ0hfSEFTX0NQVV9BVFRBQ0tfVkVDVE9SUz15CiMgZW5kIG9mIEdlbmVy
YWwgYXJjaGl0ZWN0dXJlLWRlcGVuZGVudCBvcHRpb25zCgpDT05GSUdfUlRfTVVURVhFUz15
CkNPTkZJR19NT0RVTEVfU0lHX0ZPUk1BVD15CkNPTkZJR19NT0RVTEVTPXkKIyBDT05GSUdf
TU9EVUxFX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9EVUxFX0ZPUkNFX0xPQUQgaXMg
bm90IHNldApDT05GSUdfTU9EVUxFX1VOTE9BRD15CiMgQ09ORklHX01PRFVMRV9GT1JDRV9V
TkxPQUQgaXMgbm90IHNldAojIENPTkZJR19NT0RVTEVfVU5MT0FEX1RBSU5UX1RSQUNLSU5H
IGlzIG5vdCBzZXQKQ09ORklHX01PRFZFUlNJT05TPXkKQ09ORklHX0dFTktTWU1TPXkKIyBD
T05GSUdfR0VORFdBUkZLU1lNUyBpcyBub3Qgc2V0CkNPTkZJR19BU01fTU9EVkVSU0lPTlM9
eQojIENPTkZJR19FWFRFTkRFRF9NT0RWRVJTSU9OUyBpcyBub3Qgc2V0CkNPTkZJR19CQVNJ
Q19NT0RWRVJTSU9OUz15CkNPTkZJR19NT0RVTEVfU1JDVkVSU0lPTl9BTEw9eQpDT05GSUdf
TU9EVUxFX1NJRz15CiMgQ09ORklHX01PRFVMRV9TSUdfRk9SQ0UgaXMgbm90IHNldApDT05G
SUdfTU9EVUxFX1NJR19BTEw9eQojIENPTkZJR19NT0RVTEVfU0lHX1NIQTEgaXMgbm90IHNl
dAojIENPTkZJR19NT0RVTEVfU0lHX1NIQTI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX01PRFVM
RV9TSUdfU0hBMzg0IGlzIG5vdCBzZXQKQ09ORklHX01PRFVMRV9TSUdfU0hBNTEyPXkKIyBD
T05GSUdfTU9EVUxFX1NJR19TSEEzXzI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX01PRFVMRV9T
SUdfU0hBM18zODQgaXMgbm90IHNldAojIENPTkZJR19NT0RVTEVfU0lHX1NIQTNfNTEyIGlz
IG5vdCBzZXQKQ09ORklHX01PRFVMRV9TSUdfSEFTSD0ic2hhNTEyIgojIENPTkZJR19NT0RV
TEVfQ09NUFJFU1MgaXMgbm90IHNldAojIENPTkZJR19NT0RVTEVfQUxMT1dfTUlTU0lOR19O
QU1FU1BBQ0VfSU1QT1JUUyBpcyBub3Qgc2V0CkNPTkZJR19NT0RQUk9CRV9QQVRIPSIvc2Jp
bi9tb2Rwcm9iZSIKIyBDT05GSUdfVFJJTV9VTlVTRURfS1NZTVMgaXMgbm90IHNldApDT05G
SUdfTU9EVUxFU19UUkVFX0xPT0tVUD15CkNPTkZJR19CTE9DSz15CkNPTkZJR19CTE9DS19M
RUdBQ1lfQVVUT0xPQUQ9eQpDT05GSUdfQkxLX1JRX0FMTE9DX1RJTUU9eQpDT05GSUdfQkxL
X0NHUk9VUF9SV1NUQVQ9eQpDT05GSUdfQkxLX0NHUk9VUF9QVU5UX0JJTz15CkNPTkZJR19C
TEtfREVWX0JTR19DT01NT049eQpDT05GSUdfQkxLX0RFVl9CU0dMSUI9eQpDT05GSUdfQkxL
X0RFVl9JTlRFR1JJVFk9eQpDT05GSUdfQkxLX0RFVl9XUklURV9NT1VOVEVEPXkKQ09ORklH
X0JMS19ERVZfWk9ORUQ9eQpDT05GSUdfQkxLX0RFVl9USFJPVFRMSU5HPXkKQ09ORklHX0JM
S19XQlQ9eQpDT05GSUdfQkxLX1dCVF9NUT15CiMgQ09ORklHX0JMS19DR1JPVVBfSU9MQVRF
TkNZIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0NHUk9VUF9GQ19BUFBJRCBpcyBub3Qgc2V0
CkNPTkZJR19CTEtfQ0dST1VQX0lPQ09TVD15CkNPTkZJR19CTEtfQ0dST1VQX0lPUFJJTz15
CkNPTkZJR19CTEtfREVCVUdfRlM9eQpDT05GSUdfQkxLX1NFRF9PUEFMPXkKQ09ORklHX0JM
S19JTkxJTkVfRU5DUllQVElPTj15CkNPTkZJR19CTEtfSU5MSU5FX0VOQ1JZUFRJT05fRkFM
TEJBQ0s9eQoKIwojIFBhcnRpdGlvbiBUeXBlcwojCkNPTkZJR19QQVJUSVRJT05fQURWQU5D
RUQ9eQojIENPTkZJR19BQ09STl9QQVJUSVRJT04gaXMgbm90IHNldApDT05GSUdfQUlYX1BB
UlRJVElPTj15CkNPTkZJR19PU0ZfUEFSVElUSU9OPXkKQ09ORklHX0FNSUdBX1BBUlRJVElP
Tj15CkNPTkZJR19BVEFSSV9QQVJUSVRJT049eQpDT05GSUdfTUFDX1BBUlRJVElPTj15CkNP
TkZJR19NU0RPU19QQVJUSVRJT049eQpDT05GSUdfQlNEX0RJU0tMQUJFTD15CkNPTkZJR19N
SU5JWF9TVUJQQVJUSVRJT049eQpDT05GSUdfU09MQVJJU19YODZfUEFSVElUSU9OPXkKQ09O
RklHX1VOSVhXQVJFX0RJU0tMQUJFTD15CkNPTkZJR19MRE1fUEFSVElUSU9OPXkKIyBDT05G
SUdfTERNX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX1NHSV9QQVJUSVRJT049eQpDT05GSUdf
VUxUUklYX1BBUlRJVElPTj15CkNPTkZJR19TVU5fUEFSVElUSU9OPXkKQ09ORklHX0tBUk1B
X1BBUlRJVElPTj15CkNPTkZJR19FRklfUEFSVElUSU9OPXkKQ09ORklHX1NZU1Y2OF9QQVJU
SVRJT049eQpDT05GSUdfQ01ETElORV9QQVJUSVRJT049eQojIGVuZCBvZiBQYXJ0aXRpb24g
VHlwZXMKCkNPTkZJR19CTEtfUE09eQpDT05GSUdfQkxPQ0tfSE9MREVSX0RFUFJFQ0FURUQ9
eQpDT05GSUdfQkxLX01RX1NUQUNLSU5HPXkKCiMKIyBJTyBTY2hlZHVsZXJzCiMKQ09ORklH
X01RX0lPU0NIRURfREVBRExJTkU9eQojIENPTkZJR19NUV9JT1NDSEVEX0tZQkVSIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU9TQ0hFRF9CRlEgaXMgbm90IHNldAojIGVuZCBvZiBJTyBTY2hl
ZHVsZXJzCgpDT05GSUdfUFJFRU1QVF9OT1RJRklFUlM9eQpDT05GSUdfUEFEQVRBPXkKQ09O
RklHX0FTTjE9eQpDT05GSUdfVU5JTkxJTkVfU1BJTl9VTkxPQ0s9eQpDT05GSUdfQVJDSF9T
VVBQT1JUU19BVE9NSUNfUk1XPXkKQ09ORklHX01VVEVYX1NQSU5fT05fT1dORVI9eQpDT05G
SUdfUldTRU1fU1BJTl9PTl9PV05FUj15CkNPTkZJR19MT0NLX1NQSU5fT05fT1dORVI9eQpD
T05GSUdfQVJDSF9VU0VfUVVFVUVEX1NQSU5MT0NLUz15CkNPTkZJR19RVUVVRURfU1BJTkxP
Q0tTPXkKQ09ORklHX0FSQ0hfVVNFX1FVRVVFRF9SV0xPQ0tTPXkKQ09ORklHX1FVRVVFRF9S
V0xPQ0tTPXkKQ09ORklHX0FSQ0hfSEFTX05PTl9PVkVSTEFQUElOR19BRERSRVNTX1NQQUNF
PXkKQ09ORklHX0FSQ0hfSEFTX1NZTkNfQ09SRV9CRUZPUkVfVVNFUk1PREU9eQpDT05GSUdf
QVJDSF9IQVNfU1lTQ0FMTF9XUkFQUEVSPXkKQ09ORklHX0ZSRUVaRVI9eQoKIwojIEV4ZWN1
dGFibGUgZmlsZSBmb3JtYXRzCiMKQ09ORklHX0JJTkZNVF9FTEY9eQpDT05GSUdfQ09NUEFU
X0JJTkZNVF9FTEY9eQpDT05GSUdfRUxGQ09SRT15CkNPTkZJR19DT1JFX0RVTVBfREVGQVVM
VF9FTEZfSEVBREVSUz15CkNPTkZJR19CSU5GTVRfU0NSSVBUPXkKIyBDT05GSUdfQklORk1U
X01JU0MgaXMgbm90IHNldApDT05GSUdfQ09SRURVTVA9eQojIGVuZCBvZiBFeGVjdXRhYmxl
IGZpbGUgZm9ybWF0cwoKIwojIE1lbW9yeSBNYW5hZ2VtZW50IG9wdGlvbnMKIwpDT05GSUdf
U1dBUD15CkNPTkZJR19aU1dBUD15CiMgQ09ORklHX1pTV0FQX0RFRkFVTFRfT04gaXMgbm90
IHNldAojIENPTkZJR19aU1dBUF9TSFJJTktFUl9ERUZBVUxUX09OIGlzIG5vdCBzZXQKIyBD
T05GSUdfWlNXQVBfQ09NUFJFU1NPUl9ERUZBVUxUX0RFRkxBVEUgaXMgbm90IHNldApDT05G
SUdfWlNXQVBfQ09NUFJFU1NPUl9ERUZBVUxUX0xaTz15CiMgQ09ORklHX1pTV0FQX0NPTVBS
RVNTT1JfREVGQVVMVF84NDIgaXMgbm90IHNldAojIENPTkZJR19aU1dBUF9DT01QUkVTU09S
X0RFRkFVTFRfTFo0IGlzIG5vdCBzZXQKIyBDT05GSUdfWlNXQVBfQ09NUFJFU1NPUl9ERUZB
VUxUX0xaNEhDIGlzIG5vdCBzZXQKIyBDT05GSUdfWlNXQVBfQ09NUFJFU1NPUl9ERUZBVUxU
X1pTVEQgaXMgbm90IHNldApDT05GSUdfWlNXQVBfQ09NUFJFU1NPUl9ERUZBVUxUPSJsem8i
CkNPTkZJR19aU01BTExPQz15CgojCiMgWnNtYWxsb2MgYWxsb2NhdG9yIG9wdGlvbnMKIwoK
IwojIFpzbWFsbG9jIGlzIGEgY29tbW9uIGJhY2tlbmQgYWxsb2NhdG9yIGZvciB6c3dhcCAm
IHpyYW0KIwojIENPTkZJR19aU01BTExPQ19TVEFUIGlzIG5vdCBzZXQKQ09ORklHX1pTTUFM
TE9DX0NIQUlOX1NJWkU9OAojIGVuZCBvZiBac21hbGxvYyBhbGxvY2F0b3Igb3B0aW9ucwoK
IwojIFNsYWIgYWxsb2NhdG9yIG9wdGlvbnMKIwpDT05GSUdfU0xVQj15CkNPTkZJR19LVkZS
RUVfUkNVX0JBVENIRUQ9eQojIENPTkZJR19TTFVCX1RJTlkgaXMgbm90IHNldApDT05GSUdf
U0xBQl9NRVJHRV9ERUZBVUxUPXkKQ09ORklHX1NMQUJfRlJFRUxJU1RfUkFORE9NPXkKQ09O
RklHX1NMQUJfRlJFRUxJU1RfSEFSREVORUQ9eQpDT05GSUdfU0xBQl9CVUNLRVRTPXkKIyBD
T05GSUdfU0xVQl9TVEFUUyBpcyBub3Qgc2V0CkNPTkZJR19TTFVCX0NQVV9QQVJUSUFMPXkK
IyBDT05GSUdfUkFORE9NX0tNQUxMT0NfQ0FDSEVTIGlzIG5vdCBzZXQKIyBlbmQgb2YgU2xh
YiBhbGxvY2F0b3Igb3B0aW9ucwoKQ09ORklHX1NIVUZGTEVfUEFHRV9BTExPQ0FUT1I9eQoj
IENPTkZJR19DT01QQVRfQlJLIGlzIG5vdCBzZXQKQ09ORklHX1NQQVJTRU1FTT15CkNPTkZJ
R19TUEFSU0VNRU1fRVhUUkVNRT15CkNPTkZJR19TUEFSU0VNRU1fVk1FTU1BUF9FTkFCTEU9
eQpDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9eQpDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVBf
UFJFSU5JVD15CkNPTkZJR19BUkNIX1dBTlRfT1BUSU1JWkVfREFYX1ZNRU1NQVA9eQpDT05G
SUdfQVJDSF9XQU5UX09QVElNSVpFX0hVR0VUTEJfVk1FTU1BUD15CkNPTkZJR19BUkNIX1dB
TlRfSFVHRVRMQl9WTUVNTUFQX1BSRUlOSVQ9eQpDT05GSUdfSEFWRV9HVVBfRkFTVD15CkNP
TkZJR19OVU1BX0tFRVBfTUVNSU5GTz15CkNPTkZJR19NRU1PUllfSVNPTEFUSU9OPXkKQ09O
RklHX0VYQ0xVU0lWRV9TWVNURU1fUkFNPXkKQ09ORklHX0hBVkVfQk9PVE1FTV9JTkZPX05P
REU9eQpDT05GSUdfQVJDSF9FTkFCTEVfTUVNT1JZX0hPVFBMVUc9eQpDT05GSUdfQVJDSF9F
TkFCTEVfTUVNT1JZX0hPVFJFTU9WRT15CkNPTkZJR19NRU1PUllfSE9UUExVRz15CkNPTkZJ
R19NSFBfREVGQVVMVF9PTkxJTkVfVFlQRV9PRkZMSU5FPXkKIyBDT05GSUdfTUhQX0RFRkFV
TFRfT05MSU5FX1RZUEVfT05MSU5FX0FVVE8gaXMgbm90IHNldAojIENPTkZJR19NSFBfREVG
QVVMVF9PTkxJTkVfVFlQRV9PTkxJTkVfS0VSTkVMIGlzIG5vdCBzZXQKIyBDT05GSUdfTUhQ
X0RFRkFVTFRfT05MSU5FX1RZUEVfT05MSU5FX01PVkFCTEUgaXMgbm90IHNldApDT05GSUdf
TUVNT1JZX0hPVFJFTU9WRT15CkNPTkZJR19NSFBfTUVNTUFQX09OX01FTU9SWT15CkNPTkZJ
R19BUkNIX01IUF9NRU1NQVBfT05fTUVNT1JZX0VOQUJMRT15CkNPTkZJR19TUExJVF9QVEVf
UFRMT0NLUz15CkNPTkZJR19BUkNIX0VOQUJMRV9TUExJVF9QTURfUFRMT0NLPXkKQ09ORklH
X1NQTElUX1BNRF9QVExPQ0tTPXkKQ09ORklHX01FTU9SWV9CQUxMT09OPXkKQ09ORklHX0JB
TExPT05fQ09NUEFDVElPTj15CkNPTkZJR19DT01QQUNUSU9OPXkKQ09ORklHX0NPTVBBQ1Rf
VU5FVklDVEFCTEVfREVGQVVMVD0xCkNPTkZJR19QQUdFX1JFUE9SVElORz15CkNPTkZJR19N
SUdSQVRJT049eQpDT05GSUdfREVWSUNFX01JR1JBVElPTj15CkNPTkZJR19BUkNIX0VOQUJM
RV9IVUdFUEFHRV9NSUdSQVRJT049eQpDT05GSUdfQVJDSF9FTkFCTEVfVEhQX01JR1JBVElP
Tj15CkNPTkZJR19DT05USUdfQUxMT0M9eQpDT05GSUdfUENQX0JBVENIX1NDQUxFX01BWD01
CkNPTkZJR19QSFlTX0FERFJfVF82NEJJVD15CkNPTkZJR19NTVVfTk9USUZJRVI9eQojIENP
TkZJR19LU00gaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9NTUFQX01JTl9BRERSPTY1NTM2
CkNPTkZJR19BUkNIX1NVUFBPUlRTX01FTU9SWV9GQUlMVVJFPXkKQ09ORklHX01FTU9SWV9G
QUlMVVJFPXkKIyBDT05GSUdfSFdQT0lTT05fSU5KRUNUIGlzIG5vdCBzZXQKQ09ORklHX0FS
Q0hfV0FOVF9HRU5FUkFMX0hVR0VUTEI9eQpDT05GSUdfQVJDSF9XQU5UU19USFBfU1dBUD15
CiMgQ09ORklHX1BFUlNJU1RFTlRfSFVHRV9aRVJPX0ZPTElPIGlzIG5vdCBzZXQKQ09ORklH
X01NX0lEPXkKQ09ORklHX1RSQU5TUEFSRU5UX0hVR0VQQUdFPXkKIyBDT05GSUdfVFJBTlNQ
QVJFTlRfSFVHRVBBR0VfQUxXQVlTIGlzIG5vdCBzZXQKQ09ORklHX1RSQU5TUEFSRU5UX0hV
R0VQQUdFX01BRFZJU0U9eQojIENPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRV9ORVZFUiBp
cyBub3Qgc2V0CkNPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRV9TSE1FTV9IVUdFX05FVkVS
PXkKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0VfU0hNRU1fSFVHRV9BTFdBWVMgaXMg
bm90IHNldAojIENPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRV9TSE1FTV9IVUdFX1dJVEhJ
Tl9TSVpFIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0VfU0hNRU1f
SFVHRV9BRFZJU0UgaXMgbm90IHNldApDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0VfVE1Q
RlNfSFVHRV9ORVZFUj15CiMgQ09ORklHX1RSQU5TUEFSRU5UX0hVR0VQQUdFX1RNUEZTX0hV
R0VfQUxXQVlTIGlzIG5vdCBzZXQKIyBDT05GSUdfVFJBTlNQQVJFTlRfSFVHRVBBR0VfVE1Q
RlNfSFVHRV9XSVRISU5fU0laRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQU5TUEFSRU5UX0hV
R0VQQUdFX1RNUEZTX0hVR0VfQURWSVNFIGlzIG5vdCBzZXQKQ09ORklHX1RIUF9TV0FQPXkK
IyBDT05GSUdfUkVBRF9PTkxZX1RIUF9GT1JfRlMgaXMgbm90IHNldAojIENPTkZJR19OT19Q
QUdFX01BUENPVU5UIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfTUFQQ09VTlQ9eQpDT05GSUdf
UEdUQUJMRV9IQVNfSFVHRV9MRUFWRVM9eQpDT05GSUdfSEFWRV9HSUdBTlRJQ19GT0xJT1M9
eQpDT05GSUdfQVNZTkNfS0VSTkVMX1BHVEFCTEVfRlJFRT15CkNPTkZJR19BUkNIX1NVUFBP
UlRTX0hVR0VfUEZOTUFQPXkKQ09ORklHX0FSQ0hfU1VQUE9SVFNfUE1EX1BGTk1BUD15CkNP
TkZJR19BUkNIX1NVUFBPUlRTX1BVRF9QRk5NQVA9eQpDT05GSUdfTkVFRF9QRVJfQ1BVX0VN
QkVEX0ZJUlNUX0NIVU5LPXkKQ09ORklHX05FRURfUEVSX0NQVV9QQUdFX0ZJUlNUX0NIVU5L
PXkKQ09ORklHX1VTRV9QRVJDUFVfTlVNQV9OT0RFX0lEPXkKQ09ORklHX0hBVkVfU0VUVVBf
UEVSX0NQVV9BUkVBPXkKIyBDT05GSUdfQ01BIGlzIG5vdCBzZXQKQ09ORklHX1BBR0VfQkxP
Q0tfTUFYX09SREVSPTEwCkNPTkZJR19NRU1fU09GVF9ESVJUWT15CkNPTkZJR19HRU5FUklD
X0VBUkxZX0lPUkVNQVA9eQojIENPTkZJR19ERUZFUlJFRF9TVFJVQ1RfUEFHRV9JTklUIGlz
IG5vdCBzZXQKQ09ORklHX1BBR0VfSURMRV9GTEFHPXkKQ09ORklHX0lETEVfUEFHRV9UUkFD
S0lORz15CkNPTkZJR19BUkNIX0hBU19DQUNIRV9MSU5FX1NJWkU9eQpDT05GSUdfQVJDSF9I
QVNfQ1VSUkVOVF9TVEFDS19QT0lOVEVSPXkKQ09ORklHX0FSQ0hfSEFTX1pPTkVfRE1BX1NF
VD15CkNPTkZJR19aT05FX0RNQT15CkNPTkZJR19aT05FX0RNQTMyPXkKQ09ORklHX1pPTkVf
REVWSUNFPXkKQ09ORklHX0dFVF9GUkVFX1JFR0lPTj15CkNPTkZJR19ERVZJQ0VfUFJJVkFU
RT15CkNPTkZJR19BUkNIX1VTRVNfSElHSF9WTUFfRkxBR1M9eQpDT05GSUdfQVJDSF9IQVNf
UEtFWVM9eQpDT05GSUdfQVJDSF9VU0VTX1BHX0FSQ0hfMj15CkNPTkZJR19WTV9FVkVOVF9D
T1VOVEVSUz15CiMgQ09ORklHX1BFUkNQVV9TVEFUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0dV
UF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BUE9PTF9URVNUIGlzIG5vdCBzZXQKQ09O
RklHX0FSQ0hfSEFTX1BURV9TUEVDSUFMPXkKQ09ORklHX01FTUZEX0NSRUFURT15CkNPTkZJ
R19TRUNSRVRNRU09eQpDT05GSUdfQU5PTl9WTUFfTkFNRT15CkNPTkZJR19IQVZFX0FSQ0hf
VVNFUkZBVUxURkRfV1A9eQpDT05GSUdfSEFWRV9BUkNIX1VTRVJGQVVMVEZEX01JTk9SPXkK
Q09ORklHX1VTRVJGQVVMVEZEPXkKQ09ORklHX1BURV9NQVJLRVJfVUZGRF9XUD15CiMgQ09O
RklHX0xSVV9HRU4gaXMgbm90IHNldApDT05GSUdfQVJDSF9TVVBQT1JUU19QRVJfVk1BX0xP
Q0s9eQpDT05GSUdfUEVSX1ZNQV9MT0NLPXkKQ09ORklHX0xPQ0tfTU1fQU5EX0ZJTkRfVk1B
PXkKQ09ORklHX0lPTU1VX01NX0RBVEE9eQpDT05GSUdfRVhFQ01FTT15CkNPTkZJR19OVU1B
X01FTUJMS1M9eQojIENPTkZJR19OVU1BX0VNVSBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX1NV
UFBPUlRTX1BUX1JFQ0xBSU09eQpDT05GSUdfUFRfUkVDTEFJTT15CgojCiMgRGF0YSBBY2Nl
c3MgTW9uaXRvcmluZwojCiMgQ09ORklHX0RBTU9OIGlzIG5vdCBzZXQKIyBlbmQgb2YgRGF0
YSBBY2Nlc3MgTW9uaXRvcmluZwojIGVuZCBvZiBNZW1vcnkgTWFuYWdlbWVudCBvcHRpb25z
CgpDT05GSUdfTkVUPXkKQ09ORklHX05FVF9JTkdSRVNTPXkKQ09ORklHX05FVF9FR1JFU1M9
eQpDT05GSUdfTkVUX1hHUkVTUz15CkNPTkZJR19TS0JfRVhURU5TSU9OUz15CkNPTkZJR19O
RVRfREVWTUVNPXkKQ09ORklHX05FVF9DUkMzMkM9eQoKIwojIE5ldHdvcmtpbmcgb3B0aW9u
cwojCkNPTkZJR19QQUNLRVQ9eQojIENPTkZJR19QQUNLRVRfRElBRyBpcyBub3Qgc2V0CiMg
Q09ORklHX0lORVRfUFNQIGlzIG5vdCBzZXQKQ09ORklHX1VOSVg9eQpDT05GSUdfQUZfVU5J
WF9PT0I9eQojIENPTkZJR19VTklYX0RJQUcgaXMgbm90IHNldAojIENPTkZJR19UTFMgaXMg
bm90IHNldAojIENPTkZJR19YRlJNX1VTRVIgaXMgbm90IHNldAojIENPTkZJR19ORVRfS0VZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfRElCUyBpcyBub3Qgc2V0CkNPTkZJR19YRFBfU09DS0VU
Uz15CiMgQ09ORklHX1hEUF9TT0NLRVRTX0RJQUcgaXMgbm90IHNldApDT05GSUdfTkVUX0hB
TkRTSEFLRT15CkNPTkZJR19JTkVUPXkKQ09ORklHX0lQX01VTFRJQ0FTVD15CkNPTkZJR19J
UF9BRFZBTkNFRF9ST1VURVI9eQpDT05GSUdfSVBfRklCX1RSSUVfU1RBVFM9eQpDT05GSUdf
SVBfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQX1JPVVRFX01VTFRJUEFUSD15CkNPTkZJ
R19JUF9ST1VURV9WRVJCT1NFPXkKQ09ORklHX0lQX1JPVVRFX0NMQVNTSUQ9eQojIENPTkZJ
R19JUF9QTlAgaXMgbm90IHNldAojIENPTkZJR19ORVRfSVBJUCBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9JUEdSRV9ERU1VWCBpcyBub3Qgc2V0CkNPTkZJR19JUF9NUk9VVEVfQ09NTU9O
PXkKQ09ORklHX0lQX01ST1VURT15CkNPTkZJR19JUF9NUk9VVEVfTVVMVElQTEVfVEFCTEVT
PXkKQ09ORklHX0lQX1BJTVNNX1YxPXkKQ09ORklHX0lQX1BJTVNNX1YyPXkKQ09ORklHX1NZ
Tl9DT09LSUVTPXkKIyBDT05GSUdfTkVUX0lQVlRJIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X0ZPVSBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfQUggaXMgbm90IHNldAojIENPTkZJR19J
TkVUX0VTUCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVRfSVBDT01QIGlzIG5vdCBzZXQKQ09O
RklHX0lORVRfVEFCTEVfUEVSVFVSQl9PUkRFUj0xNgojIENPTkZJR19JTkVUX0RJQUcgaXMg
bm90IHNldApDT05GSUdfVENQX0NPTkdfQURWQU5DRUQ9eQojIENPTkZJR19UQ1BfQ09OR19C
SUMgaXMgbm90IHNldApDT05GSUdfVENQX0NPTkdfQ1VCSUM9eQojIENPTkZJR19UQ1BfQ09O
R19XRVNUV09PRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX0hUQ1AgaXMgbm90IHNl
dAojIENPTkZJR19UQ1BfQ09OR19IU1RDUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9DT05H
X0hZQkxBIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQX0NPTkdfVkVHQVMgaXMgbm90IHNldAoj
IENPTkZJR19UQ1BfQ09OR19OViBpcyBub3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX1NDQUxB
QkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQX0NPTkdfTFAgaXMgbm90IHNldAojIENPTkZJ
R19UQ1BfQ09OR19WRU5PIGlzIG5vdCBzZXQKIyBDT05GSUdfVENQX0NPTkdfWUVBSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RDUF9DT05HX0lMTElOT0lTIGlzIG5vdCBzZXQKIyBDT05GSUdf
VENQX0NPTkdfRENUQ1AgaXMgbm90IHNldAojIENPTkZJR19UQ1BfQ09OR19DREcgaXMgbm90
IHNldAojIENPTkZJR19UQ1BfQ09OR19CQlIgaXMgbm90IHNldApDT05GSUdfREVGQVVMVF9D
VUJJQz15CiMgQ09ORklHX0RFRkFVTFRfUkVOTyBpcyBub3Qgc2V0CkNPTkZJR19ERUZBVUxU
X1RDUF9DT05HPSJjdWJpYyIKIyBDT05GSUdfVENQX0FPIGlzIG5vdCBzZXQKQ09ORklHX1RD
UF9NRDVTSUc9eQpDT05GSUdfSVBWNj15CkNPTkZJR19JUFY2X1JPVVRFUl9QUkVGPXkKQ09O
RklHX0lQVjZfUk9VVEVfSU5GTz15CiMgQ09ORklHX0lQVjZfT1BUSU1JU1RJQ19EQUQgaXMg
bm90IHNldAojIENPTkZJR19JTkVUNl9BSCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X0VT
UCBpcyBub3Qgc2V0CiMgQ09ORklHX0lORVQ2X0lQQ09NUCBpcyBub3Qgc2V0CiMgQ09ORklH
X0lQVjZfTUlQNiBpcyBub3Qgc2V0CiMgQ09ORklHX0lQVjZfSUxBIGlzIG5vdCBzZXQKIyBD
T05GSUdfSVBWNl9WVEkgaXMgbm90IHNldAojIENPTkZJR19JUFY2X1NJVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lQVjZfVFVOTkVMIGlzIG5vdCBzZXQKQ09ORklHX0lQVjZfTVVMVElQTEVf
VEFCTEVTPXkKQ09ORklHX0lQVjZfU1VCVFJFRVM9eQpDT05GSUdfSVBWNl9NUk9VVEU9eQpD
T05GSUdfSVBWNl9NUk9VVEVfTVVMVElQTEVfVEFCTEVTPXkKQ09ORklHX0lQVjZfUElNU01f
VjI9eQpDT05GSUdfSVBWNl9TRUc2X0xXVFVOTkVMPXkKQ09ORklHX0lQVjZfU0VHNl9ITUFD
PXkKQ09ORklHX0lQVjZfU0VHNl9CUEY9eQojIENPTkZJR19JUFY2X1JQTF9MV1RVTk5FTCBp
cyBub3Qgc2V0CkNPTkZJR19JUFY2X0lPQU02X0xXVFVOTkVMPXkKQ09ORklHX05FVExBQkVM
PXkKQ09ORklHX01QVENQPXkKQ09ORklHX01QVENQX0lQVjY9eQpDT05GSUdfTkVUV09SS19T
RUNNQVJLPXkKQ09ORklHX05FVF9QVFBfQ0xBU1NJRlk9eQpDT05GSUdfTkVUV09SS19QSFlf
VElNRVNUQU1QSU5HPXkKQ09ORklHX05FVEZJTFRFUj15CkNPTkZJR19ORVRGSUxURVJfQURW
QU5DRUQ9eQojIENPTkZJR19CUklER0VfTkVURklMVEVSIGlzIG5vdCBzZXQKCiMKIyBDb3Jl
IE5ldGZpbHRlciBDb25maWd1cmF0aW9uCiMKQ09ORklHX05FVEZJTFRFUl9JTkdSRVNTPXkK
Q09ORklHX05FVEZJTFRFUl9FR1JFU1M9eQpDT05GSUdfTkVURklMVEVSX1NLSVBfRUdSRVNT
PXkKQ09ORklHX05FVEZJTFRFUl9ORVRMSU5LPXkKQ09ORklHX05FVEZJTFRFUl9GQU1JTFlf
QlJJREdFPXkKQ09ORklHX05FVEZJTFRFUl9GQU1JTFlfQVJQPXkKQ09ORklHX05FVEZJTFRF
Ul9CUEZfTElOSz15CkNPTkZJR19ORVRGSUxURVJfTkVUTElOS19IT09LPXkKQ09ORklHX05F
VEZJTFRFUl9ORVRMSU5LX0FDQ1Q9eQpDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUU9
eQpDT05GSUdfTkVURklMVEVSX05FVExJTktfTE9HPXkKQ09ORklHX05FVEZJTFRFUl9ORVRM
SU5LX09TRj15CkNPTkZJR19ORl9DT05OVFJBQ0s9eQpDT05GSUdfTkZfTE9HX1NZU0xPRz15
CkNPTkZJR19ORVRGSUxURVJfQ09OTkNPVU5UPXkKQ09ORklHX05GX0NPTk5UUkFDS19NQVJL
PXkKQ09ORklHX05GX0NPTk5UUkFDS19TRUNNQVJLPXkKQ09ORklHX05GX0NPTk5UUkFDS19a
T05FUz15CiMgQ09ORklHX05GX0NPTk5UUkFDS19QUk9DRlMgaXMgbm90IHNldApDT05GSUdf
TkZfQ09OTlRSQUNLX0VWRU5UUz15CkNPTkZJR19ORl9DT05OVFJBQ0tfVElNRU9VVD15CkNP
TkZJR19ORl9DT05OVFJBQ0tfVElNRVNUQU1QPXkKQ09ORklHX05GX0NPTk5UUkFDS19MQUJF
TFM9eQpDT05GSUdfTkZfQ1RfUFJPVE9fR1JFPXkKQ09ORklHX05GX0NUX1BST1RPX1NDVFA9
eQpDT05GSUdfTkZfQ1RfUFJPVE9fVURQTElURT15CkNPTkZJR19ORl9DT05OVFJBQ0tfQU1B
TkRBPXkKQ09ORklHX05GX0NPTk5UUkFDS19GVFA9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0gz
MjM9eQpDT05GSUdfTkZfQ09OTlRSQUNLX0lSQz15CkNPTkZJR19ORl9DT05OVFJBQ0tfQlJP
QURDQVNUPXkKQ09ORklHX05GX0NPTk5UUkFDS19ORVRCSU9TX05TPXkKQ09ORklHX05GX0NP
Tk5UUkFDS19TTk1QPXkKQ09ORklHX05GX0NPTk5UUkFDS19QUFRQPXkKQ09ORklHX05GX0NP
Tk5UUkFDS19TQU5FPXkKQ09ORklHX05GX0NPTk5UUkFDS19TSVA9eQpDT05GSUdfTkZfQ09O
TlRSQUNLX1RGVFA9eQpDT05GSUdfTkZfQ1RfTkVUTElOSz15CkNPTkZJR19ORl9DVF9ORVRM
SU5LX1RJTUVPVVQ9eQpDT05GSUdfTkZfQ1RfTkVUTElOS19IRUxQRVI9eQpDT05GSUdfTkVU
RklMVEVSX05FVExJTktfR0xVRV9DVD15CkNPTkZJR19ORl9OQVQ9eQpDT05GSUdfTkZfTkFU
X0FNQU5EQT15CkNPTkZJR19ORl9OQVRfRlRQPXkKQ09ORklHX05GX05BVF9JUkM9eQpDT05G
SUdfTkZfTkFUX1NJUD15CkNPTkZJR19ORl9OQVRfVEZUUD15CkNPTkZJR19ORl9OQVRfUkVE
SVJFQ1Q9eQpDT05GSUdfTkZfTkFUX01BU1FVRVJBREU9eQpDT05GSUdfTkVURklMVEVSX1NZ
TlBST1hZPXkKQ09ORklHX05GX1RBQkxFUz15CkNPTkZJR19ORl9UQUJMRVNfSU5FVD15CkNP
TkZJR19ORl9UQUJMRVNfTkVUREVWPXkKQ09ORklHX05GVF9OVU1HRU49eQpDT05GSUdfTkZU
X0NUPXkKIyBDT05GSUdfTkZUX0VYVEhEUl9EQ0NQIGlzIG5vdCBzZXQKQ09ORklHX05GVF9G
TE9XX09GRkxPQUQ9eQpDT05GSUdfTkZUX0NPTk5MSU1JVD15CkNPTkZJR19ORlRfTE9HPXkK
Q09ORklHX05GVF9MSU1JVD15CkNPTkZJR19ORlRfTUFTUT15CkNPTkZJR19ORlRfUkVESVI9
eQpDT05GSUdfTkZUX05BVD15CkNPTkZJR19ORlRfVFVOTkVMPXkKQ09ORklHX05GVF9RVUVV
RT15CkNPTkZJR19ORlRfUVVPVEE9eQpDT05GSUdfTkZUX1JFSkVDVD15CkNPTkZJR19ORlRf
UkVKRUNUX0lORVQ9eQpDT05GSUdfTkZUX0NPTVBBVD15CkNPTkZJR19ORlRfSEFTSD15CkNP
TkZJR19ORlRfRklCPXkKQ09ORklHX05GVF9GSUJfSU5FVD15CkNPTkZJR19ORlRfU09DS0VU
PXkKQ09ORklHX05GVF9PU0Y9eQpDT05GSUdfTkZUX1RQUk9YWT15CkNPTkZJR19ORlRfU1lO
UFJPWFk9eQpDT05GSUdfTkZfRFVQX05FVERFVj15CkNPTkZJR19ORlRfRFVQX05FVERFVj15
CkNPTkZJR19ORlRfRldEX05FVERFVj15CkNPTkZJR19ORlRfRklCX05FVERFVj15CkNPTkZJ
R19ORlRfUkVKRUNUX05FVERFVj15CkNPTkZJR19ORl9GTE9XX1RBQkxFX0lORVQ9eQpDT05G
SUdfTkZfRkxPV19UQUJMRT15CiMgQ09ORklHX05GX0ZMT1dfVEFCTEVfUFJPQ0ZTIGlzIG5v
dCBzZXQKQ09ORklHX05FVEZJTFRFUl9YVEFCTEVTPXkKQ09ORklHX05FVEZJTFRFUl9YVEFC
TEVTX0NPTVBBVD15CiMgQ09ORklHX05FVEZJTFRFUl9YVEFCTEVTX0xFR0FDWSBpcyBub3Qg
c2V0CgojCiMgWHRhYmxlcyBjb21iaW5lZCBtb2R1bGVzCiMKQ09ORklHX05FVEZJTFRFUl9Y
VF9NQVJLPXkKQ09ORklHX05FVEZJTFRFUl9YVF9DT05OTUFSSz15CgojCiMgWHRhYmxlcyB0
YXJnZXRzCiMKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQVVESVQ9eQpDT05GSUdfTkVU
RklMVEVSX1hUX1RBUkdFVF9DSEVDS1NVTT1tCkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VU
X0NMQVNTSUZZPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfQ09OTk1BUks9eQpDT05G
SUdfTkVURklMVEVSX1hUX1RBUkdFVF9DT05OU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVJf
WFRfVEFSR0VUX0NUPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfRFNDUD1tCkNPTkZJ
R19ORVRGSUxURVJfWFRfVEFSR0VUX0hMPW0KQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRf
SE1BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9JRExFVElNRVI9eQpDT05GSUdf
TkVURklMVEVSX1hUX1RBUkdFVF9MRUQ9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9M
T0c9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9NQVJLPXkKQ09ORklHX05FVEZJTFRF
Ul9YVF9OQVQ9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9ORVRNQVA9eQpDT05GSUdf
TkVURklMVEVSX1hUX1RBUkdFVF9ORkxPRz15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VU
X05GUVVFVUU9eQpDT05GSUdfTkVURklMVEVSX1hUX1RBUkdFVF9SQVRFRVNUPXkKQ09ORklH
X05FVEZJTFRFUl9YVF9UQVJHRVRfUkVESVJFQ1Q9eQpDT05GSUdfTkVURklMVEVSX1hUX1RB
UkdFVF9NQVNRVUVSQURFPXkKQ09ORklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVEVFPXkKQ09O
RklHX05FVEZJTFRFUl9YVF9UQVJHRVRfVFBST1hZPW0KQ09ORklHX05FVEZJTFRFUl9YVF9U
QVJHRVRfU0VDTUFSSz15CkNPTkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RDUE1TUz15CkNP
TkZJR19ORVRGSUxURVJfWFRfVEFSR0VUX1RDUE9QVFNUUklQPW0KCiMKIyBYdGFibGVzIG1h
dGNoZXMKIwpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0FERFJUWVBFPXkKQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9CUEY9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NHUk9V
UD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ0xVU1RFUj15CkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfQ09NTUVOVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfQ09OTkJZ
VEVTPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9DT05OTEFCRUw9eQpDT05GSUdfTkVU
RklMVEVSX1hUX01BVENIX0NPTk5MSU1JVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
Q09OTk1BUks9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0NPTk5UUkFDSz15CkNPTkZJ
R19ORVRGSUxURVJfWFRfTUFUQ0hfQ1BVPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9E
Q0NQPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9ERVZHUk9VUD15CkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfRFNDUD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfRUNOPXkK
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9FU1A9eQpDT05GSUdfTkVURklMVEVSX1hUX01B
VENIX0hBU0hMSU1JVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfSEVMUEVSPXkKQ09O
RklHX05FVEZJTFRFUl9YVF9NQVRDSF9ITD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hf
SVBDT01QPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9JUFJBTkdFPXkKQ09ORklHX05F
VEZJTFRFUl9YVF9NQVRDSF9MMlRQPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9MRU5H
VEg9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX0xJTUlUPXkKQ09ORklHX05FVEZJTFRF
Ul9YVF9NQVRDSF9NQUM9eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX01BUks9eQpDT05G
SUdfTkVURklMVEVSX1hUX01BVENIX01VTFRJUE9SVD15CkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfTkZBQ0NUPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9PU0Y9eQpDT05GSUdf
TkVURklMVEVSX1hUX01BVENIX09XTkVSPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9Q
S1RUWVBFPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9RVU9UQT15CkNPTkZJR19ORVRG
SUxURVJfWFRfTUFUQ0hfUkFURUVTVD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfUkVB
TE09eQpDT05GSUdfTkVURklMVEVSX1hUX01BVENIX1JFQ0VOVD15CkNPTkZJR19ORVRGSUxU
RVJfWFRfTUFUQ0hfU0NUUD15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfU09DS0VUPXkK
Q09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9TVEFURT15CkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfU1RBVElTVElDPXkKQ09ORklHX05FVEZJTFRFUl9YVF9NQVRDSF9TVFJJTkc9eQpD
T05GSUdfTkVURklMVEVSX1hUX01BVENIX1RDUE1TUz15CkNPTkZJR19ORVRGSUxURVJfWFRf
TUFUQ0hfVElNRT15CkNPTkZJR19ORVRGSUxURVJfWFRfTUFUQ0hfVTMyPXkKIyBlbmQgb2Yg
Q29yZSBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgoKIyBDT05GSUdfSVBfU0VUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVBfVlMgaXMgbm90IHNldAoKIwojIElQOiBOZXRmaWx0ZXIgQ29uZmln
dXJhdGlvbgojCkNPTkZJR19ORl9ERUZSQUdfSVBWND15CkNPTkZJR19ORl9TT0NLRVRfSVBW
ND15CkNPTkZJR19ORl9UUFJPWFlfSVBWND15CkNPTkZJR19ORl9UQUJMRVNfSVBWND15CkNP
TkZJR19ORlRfUkVKRUNUX0lQVjQ9eQpDT05GSUdfTkZUX0RVUF9JUFY0PXkKQ09ORklHX05G
VF9GSUJfSVBWND15CkNPTkZJR19ORl9UQUJMRVNfQVJQPXkKQ09ORklHX05GX0RVUF9JUFY0
PXkKQ09ORklHX05GX0xPR19BUlA9eQpDT05GSUdfTkZfTE9HX0lQVjQ9eQpDT05GSUdfTkZf
UkVKRUNUX0lQVjQ9eQpDT05GSUdfTkZfTkFUX1NOTVBfQkFTSUM9eQpDT05GSUdfTkZfTkFU
X1BQVFA9eQpDT05GSUdfTkZfTkFUX0gzMjM9eQpDT05GSUdfSVBfTkZfSVBUQUJMRVM9eQpD
T05GSUdfSVBfTkZfTUFUQ0hfQUg9bQpDT05GSUdfSVBfTkZfTUFUQ0hfRUNOPW0KQ09ORklH
X0lQX05GX01BVENIX1JQRklMVEVSPW0KQ09ORklHX0lQX05GX01BVENIX1RUTD1tCkNPTkZJ
R19JUF9ORl9UQVJHRVRfUkVKRUNUPW0KQ09ORklHX0lQX05GX1RBUkdFVF9TWU5QUk9YWT1t
CkNPTkZJR19JUF9ORl9UQVJHRVRfRUNOPW0KQ09ORklHX05GVF9DT01QQVRfQVJQPXkKQ09O
RklHX0lQX05GX0FSUF9NQU5HTEU9bQojIGVuZCBvZiBJUDogTmV0ZmlsdGVyIENvbmZpZ3Vy
YXRpb24KCiMKIyBJUHY2OiBOZXRmaWx0ZXIgQ29uZmlndXJhdGlvbgojCkNPTkZJR19ORl9T
T0NLRVRfSVBWNj15CkNPTkZJR19ORl9UUFJPWFlfSVBWNj15CkNPTkZJR19ORl9UQUJMRVNf
SVBWNj15CkNPTkZJR19ORlRfUkVKRUNUX0lQVjY9eQpDT05GSUdfTkZUX0RVUF9JUFY2PXkK
Q09ORklHX05GVF9GSUJfSVBWNj15CkNPTkZJR19ORl9EVVBfSVBWNj15CkNPTkZJR19ORl9S
RUpFQ1RfSVBWNj15CkNPTkZJR19ORl9MT0dfSVBWNj15CkNPTkZJR19JUDZfTkZfSVBUQUJM
RVM9eQojIENPTkZJR19JUDZfTkZfTUFUQ0hfQUggaXMgbm90IHNldAojIENPTkZJR19JUDZf
TkZfTUFUQ0hfRVVJNjQgaXMgbm90IHNldAojIENPTkZJR19JUDZfTkZfTUFUQ0hfRlJBRyBp
cyBub3Qgc2V0CiMgQ09ORklHX0lQNl9ORl9NQVRDSF9PUFRTIGlzIG5vdCBzZXQKIyBDT05G
SUdfSVA2X05GX01BVENIX0hMIGlzIG5vdCBzZXQKIyBDT05GSUdfSVA2X05GX01BVENIX0lQ
VjZIRUFERVIgaXMgbm90IHNldAojIENPTkZJR19JUDZfTkZfTUFUQ0hfTUggaXMgbm90IHNl
dAojIENPTkZJR19JUDZfTkZfTUFUQ0hfUlBGSUxURVIgaXMgbm90IHNldAojIENPTkZJR19J
UDZfTkZfTUFUQ0hfUlQgaXMgbm90IHNldAojIENPTkZJR19JUDZfTkZfTUFUQ0hfU1JIIGlz
IG5vdCBzZXQKIyBDT05GSUdfSVA2X05GX1RBUkdFVF9SRUpFQ1QgaXMgbm90IHNldAojIENP
TkZJR19JUDZfTkZfVEFSR0VUX1NZTlBST1hZIGlzIG5vdCBzZXQKIyBDT05GSUdfSVA2X05G
X1RBUkdFVF9OUFQgaXMgbm90IHNldAojIGVuZCBvZiBJUHY2OiBOZXRmaWx0ZXIgQ29uZmln
dXJhdGlvbgoKQ09ORklHX05GX0RFRlJBR19JUFY2PXkKQ09ORklHX05GX1RBQkxFU19CUklE
R0U9eQpDT05GSUdfTkZUX0JSSURHRV9NRVRBPXkKQ09ORklHX05GVF9CUklER0VfUkVKRUNU
PXkKQ09ORklHX05GX0NPTk5UUkFDS19CUklER0U9eQpDT05GSUdfQlJJREdFX05GX0VCVEFC
TEVTPXkKIyBDT05GSUdfQlJJREdFX0VCVF84MDJfMyBpcyBub3Qgc2V0CiMgQ09ORklHX0JS
SURHRV9FQlRfQU1PTkcgaXMgbm90IHNldAojIENPTkZJR19CUklER0VfRUJUX0FSUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JSSURHRV9FQlRfSVAgaXMgbm90IHNldAojIENPTkZJR19CUklE
R0VfRUJUX0lQNiBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRV9FQlRfTElNSVQgaXMgbm90
IHNldAojIENPTkZJR19CUklER0VfRUJUX01BUksgaXMgbm90IHNldAojIENPTkZJR19CUklE
R0VfRUJUX1BLVFRZUEUgaXMgbm90IHNldAojIENPTkZJR19CUklER0VfRUJUX1NUUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JSSURHRV9FQlRfVkxBTiBpcyBub3Qgc2V0CiMgQ09ORklHX0JS
SURHRV9FQlRfQVJQUkVQTFkgaXMgbm90IHNldApDT05GSUdfQlJJREdFX0VCVF9ETkFUPXkK
IyBDT05GSUdfQlJJREdFX0VCVF9NQVJLX1QgaXMgbm90IHNldAojIENPTkZJR19CUklER0Vf
RUJUX1JFRElSRUNUIGlzIG5vdCBzZXQKQ09ORklHX0JSSURHRV9FQlRfU05BVD15CiMgQ09O
RklHX0JSSURHRV9FQlRfTE9HIGlzIG5vdCBzZXQKIyBDT05GSUdfQlJJREdFX0VCVF9ORkxP
RyBpcyBub3Qgc2V0CiMgQ09ORklHX0lQX1NDVFAgaXMgbm90IHNldAojIENPTkZJR19SRFMg
aXMgbm90IHNldAojIENPTkZJR19USVBDIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRNIGlzIG5v
dCBzZXQKIyBDT05GSUdfTDJUUCBpcyBub3Qgc2V0CkNPTkZJR19TVFA9eQpDT05GSUdfQlJJ
REdFPXkKQ09ORklHX0JSSURHRV9JR01QX1NOT09QSU5HPXkKIyBDT05GSUdfQlJJREdFX01S
UCBpcyBub3Qgc2V0CiMgQ09ORklHX0JSSURHRV9DRk0gaXMgbm90IHNldAojIENPTkZJR19O
RVRfRFNBIGlzIG5vdCBzZXQKIyBDT05GSUdfVkxBTl84MDIxUSBpcyBub3Qgc2V0CkNPTkZJ
R19MTEM9eQojIENPTkZJR19MTEMyIGlzIG5vdCBzZXQKIyBDT05GSUdfQVRBTEsgaXMgbm90
IHNldAojIENPTkZJR19YMjUgaXMgbm90IHNldAojIENPTkZJR19MQVBCIGlzIG5vdCBzZXQK
IyBDT05GSUdfUEhPTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfNkxPV1BBTiBpcyBub3Qgc2V0
CiMgQ09ORklHX0lFRUU4MDIxNTQgaXMgbm90IHNldApDT05GSUdfTkVUX1NDSEVEPXkKCiMK
IyBRdWV1ZWluZy9TY2hlZHVsaW5nCiMKIyBDT05GSUdfTkVUX1NDSF9IVEIgaXMgbm90IHNl
dAojIENPTkZJR19ORVRfU0NIX0hGU0MgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX1BS
SU8gaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX01VTFRJUSBpcyBub3Qgc2V0CiMgQ09O
RklHX05FVF9TQ0hfUkVEIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9TRkIgaXMgbm90
IHNldAojIENPTkZJR19ORVRfU0NIX1NGUSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hf
VEVRTCBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfVEJGIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkVUX1NDSF9DQlMgaXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX0VURiBpcyBub3Qg
c2V0CiMgQ09ORklHX05FVF9TQ0hfVEFQUklPIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1ND
SF9HUkVEIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9ORVRFTSBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVF9TQ0hfRFJSIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9NUVBSSU8g
aXMgbm90IHNldAojIENPTkZJR19ORVRfU0NIX1NLQlBSSU8gaXMgbm90IHNldAojIENPTkZJ
R19ORVRfU0NIX0NIT0tFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9RRlEgaXMgbm90
IHNldAojIENPTkZJR19ORVRfU0NIX0NPREVMIGlzIG5vdCBzZXQKQ09ORklHX05FVF9TQ0hf
RlFfQ09ERUw9bQojIENPTkZJR19ORVRfU0NIX0NBS0UgaXMgbm90IHNldAojIENPTkZJR19O
RVRfU0NIX0ZRIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9ISEYgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfU0NIX1BJRSBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfSU5HUkVT
UyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9TQ0hfUExVRyBpcyBub3Qgc2V0CiMgQ09ORklH
X05FVF9TQ0hfRVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX1NDSF9EVUFMUEkyIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkVUX1NDSF9ERUZBVUxUIGlzIG5vdCBzZXQKCiMKIyBDbGFzc2lm
aWNhdGlvbgojCkNPTkZJR19ORVRfQ0xTPXkKIyBDT05GSUdfTkVUX0NMU19CQVNJQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05FVF9DTFNfUk9VVEU0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkVU
X0NMU19GVyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9DTFNfVTMyIGlzIG5vdCBzZXQKIyBD
T05GSUdfTkVUX0NMU19GTE9XIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19DR1JPVVAg
aXMgbm90IHNldAojIENPTkZJR19ORVRfQ0xTX0JQRiBpcyBub3Qgc2V0CiMgQ09ORklHX05F
VF9DTFNfRkxPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0NMU19NQVRDSEFMTCBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfRU1BVENIPXkKQ09ORklHX05FVF9FTUFUQ0hfU1RBQ0s9MzIK
IyBDT05GSUdfTkVUX0VNQVRDSF9DTVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfRU1BVENI
X05CWVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0VNQVRDSF9VMzIgaXMgbm90IHNldAoj
IENPTkZJR19ORVRfRU1BVENIX01FVEEgaXMgbm90IHNldAojIENPTkZJR19ORVRfRU1BVENI
X1RFWFQgaXMgbm90IHNldAojIENPTkZJR19ORVRfRU1BVENIX0lQVCBpcyBub3Qgc2V0CkNP
TkZJR19ORVRfQ0xTX0FDVD15CiMgQ09ORklHX05FVF9BQ1RfUE9MSUNFIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkVUX0FDVF9HQUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9NSVJS
RUQgaXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX1NBTVBMRSBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfQUNUX05BVD15CiMgQ09ORklHX05FVF9BQ1RfUEVESVQgaXMgbm90IHNldAojIENP
TkZJR19ORVRfQUNUX1NJTVAgaXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX1NLQkVESVQg
aXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX0NTVU0gaXMgbm90IHNldAojIENPTkZJR19O
RVRfQUNUX01QTFMgaXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX1ZMQU4gaXMgbm90IHNl
dAojIENPTkZJR19ORVRfQUNUX0JQRiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9BQ1RfQ09O
Tk1BUksgaXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX0NUSU5GTyBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVF9BQ1RfU0tCTU9EIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9JRkUg
aXMgbm90IHNldAojIENPTkZJR19ORVRfQUNUX1RVTk5FTF9LRVkgaXMgbm90IHNldAojIENP
TkZJR19ORVRfQUNUX0NUIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUX0FDVF9HQVRFIGlzIG5v
dCBzZXQKQ09ORklHX05FVF9UQ19TS0JfRVhUPXkKQ09ORklHX05FVF9TQ0hfRklGTz15CkNP
TkZJR19EQ0I9eQpDT05GSUdfRE5TX1JFU09MVkVSPXkKIyBDT05GSUdfQkFUTUFOX0FEViBp
cyBub3Qgc2V0CiMgQ09ORklHX09QRU5WU1dJVENIIGlzIG5vdCBzZXQKIyBDT05GSUdfVlNP
Q0tFVFMgaXMgbm90IHNldAojIENPTkZJR19ORVRMSU5LX0RJQUcgaXMgbm90IHNldApDT05G
SUdfTVBMUz15CiMgQ09ORklHX05FVF9NUExTX0dTTyBpcyBub3Qgc2V0CiMgQ09ORklHX01Q
TFNfUk9VVElORyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9OU0ggaXMgbm90IHNldAojIENP
TkZJR19IU1IgaXMgbm90IHNldApDT05GSUdfTkVUX1NXSVRDSERFVj15CkNPTkZJR19ORVRf
TDNfTUFTVEVSX0RFVj15CiMgQ09ORklHX1FSVFIgaXMgbm90IHNldApDT05GSUdfTkVUX05D
U0k9eQpDT05GSUdfTkNTSV9PRU1fQ01EX0dFVF9NQUM9eQojIENPTkZJR19OQ1NJX09FTV9D
TURfS0VFUF9QSFkgaXMgbm90IHNldApDT05GSUdfUENQVV9ERVZfUkVGQ05UPXkKQ09ORklH
X01BWF9TS0JfRlJBR1M9MTcKQ09ORklHX1JQUz15CkNPTkZJR19SRlNfQUNDRUw9eQpDT05G
SUdfU09DS19SWF9RVUVVRV9NQVBQSU5HPXkKQ09ORklHX1hQUz15CkNPTkZJR19DR1JPVVBf
TkVUX1BSSU89eQpDT05GSUdfQ0dST1VQX05FVF9DTEFTU0lEPXkKQ09ORklHX05FVF9SWF9C
VVNZX1BPTEw9eQpDT05GSUdfQlFMPXkKQ09ORklHX0JQRl9TVFJFQU1fUEFSU0VSPXkKQ09O
RklHX05FVF9GTE9XX0xJTUlUPXkKCiMKIyBOZXR3b3JrIHRlc3RpbmcKIwojIENPTkZJR19O
RVRfUEtUR0VOIGlzIG5vdCBzZXQKQ09ORklHX05FVF9EUk9QX01PTklUT1I9eQojIGVuZCBv
ZiBOZXR3b3JrIHRlc3RpbmcKIyBlbmQgb2YgTmV0d29ya2luZyBvcHRpb25zCgpDT05GSUdf
SEFNUkFESU89eQoKIwojIFBhY2tldCBSYWRpbyBwcm90b2NvbHMKIwojIENPTkZJR19BWDI1
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FOIGlzIG5vdCBzZXQKIyBDT05GSUdfQlQgaXMgbm90
IHNldAojIENPTkZJR19BRl9SWFJQQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FGX0tDTSBpcyBu
b3Qgc2V0CkNPTkZJR19TVFJFQU1fUEFSU0VSPXkKQ09ORklHX01DVFA9eQpDT05GSUdfRklC
X1JVTEVTPXkKQ09ORklHX1dJUkVMRVNTPXkKIyBDT05GSUdfQ0ZHODAyMTEgaXMgbm90IHNl
dAoKIwojIENGRzgwMjExIG5lZWRzIHRvIGJlIGVuYWJsZWQgZm9yIE1BQzgwMjExCiMKQ09O
RklHX01BQzgwMjExX1NUQV9IQVNIX01BWF9TSVpFPTAKQ09ORklHX1JGS0lMTD15CkNPTkZJ
R19SRktJTExfTEVEUz15CkNPTkZJR19SRktJTExfSU5QVVQ9eQojIENPTkZJR19SRktJTExf
R1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF85UCBpcyBub3Qgc2V0CiMgQ09ORklHX0NB
SUYgaXMgbm90IHNldAojIENPTkZJR19DRVBIX0xJQiBpcyBub3Qgc2V0CiMgQ09ORklHX05G
QyBpcyBub3Qgc2V0CiMgQ09ORklHX1BTQU1QTEUgaXMgbm90IHNldAojIENPTkZJR19ORVRf
SUZFIGlzIG5vdCBzZXQKQ09ORklHX0xXVFVOTkVMPXkKQ09ORklHX0xXVFVOTkVMX0JQRj15
CkNPTkZJR19EU1RfQ0FDSEU9eQpDT05GSUdfTkVUX1NFTEZURVNUUz15CkNPTkZJR19ORVRf
U09DS19NU0c9eQpDT05GSUdfTkVUX0RFVkxJTks9eQpDT05GSUdfUEFHRV9QT09MPXkKQ09O
RklHX1BBR0VfUE9PTF9TVEFUUz15CkNPTkZJR19GQUlMT1ZFUj15CkNPTkZJR19FVEhUT09M
X05FVExJTks9eQoKIwojIERldmljZSBEcml2ZXJzCiMKQ09ORklHX0hBVkVfUENJPXkKQ09O
RklHX0dFTkVSSUNfUENJX0lPTUFQPXkKQ09ORklHX1BDST15CkNPTkZJR19QQ0lfRE9NQUlO
Uz15CkNPTkZJR19QQ0lFUE9SVEJVUz15CkNPTkZJR19IT1RQTFVHX1BDSV9QQ0lFPXkKQ09O
RklHX1BDSUVBRVI9eQojIENPTkZJR19QQ0lFQUVSX0lOSkVDVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BDSUVfRUNSQyBpcyBub3Qgc2V0CkNPTkZJR19QQ0lFQVNQTT15CkNPTkZJR19QQ0lF
QVNQTV9ERUZBVUxUPXkKIyBDT05GSUdfUENJRUFTUE1fUE9XRVJTQVZFIGlzIG5vdCBzZXQK
IyBDT05GSUdfUENJRUFTUE1fUE9XRVJfU1VQRVJTQVZFIGlzIG5vdCBzZXQKIyBDT05GSUdf
UENJRUFTUE1fUEVSRk9STUFOQ0UgaXMgbm90IHNldApDT05GSUdfUENJRV9QTUU9eQpDT05G
SUdfUENJRV9EUEM9eQpDT05GSUdfUENJRV9QVE09eQojIENPTkZJR19QQ0lFX0VEUiBpcyBu
b3Qgc2V0CkNPTkZJR19QQ0lfTVNJPXkKQ09ORklHX1BDSV9RVUlSS1M9eQojIENPTkZJR19Q
Q0lfREVCVUcgaXMgbm90IHNldApDT05GSUdfUENJX1JFQUxMT0NfRU5BQkxFX0FVVE89eQoj
IENPTkZJR19QQ0lfU1RVQiBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9QRl9TVFVCIGlzIG5v
dCBzZXQKIyBDT05GSUdfWEVOX1BDSURFVl9GUk9OVEVORCBpcyBub3Qgc2V0CkNPTkZJR19Q
Q0lfQVRTPXkKIyBDT05GSUdfUENJX1RTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSV9ET0Ug
aXMgbm90IHNldApDT05GSUdfUENJX0VDQU09eQpDT05GSUdfUENJX0xPQ0tMRVNTX0NPTkZJ
Rz15CkNPTkZJR19QQ0lfSU9WPXkKIyBDT05GSUdfUENJX05QRU0gaXMgbm90IHNldApDT05G
SUdfUENJX1BSST15CkNPTkZJR19QQ0lfUEFTSUQ9eQojIENPTkZJR19QQ0lFX1RQSCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BDSV9QMlBETUEgaXMgbm90IHNldApDT05GSUdfUENJX0xBQkVM
PXkKIyBDT05GSUdfUENJRV9CVVNfVFVORV9PRkYgaXMgbm90IHNldApDT05GSUdfUENJRV9C
VVNfREVGQVVMVD15CiMgQ09ORklHX1BDSUVfQlVTX1NBRkUgaXMgbm90IHNldAojIENPTkZJ
R19QQ0lFX0JVU19QRVJGT1JNQU5DRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BDSUVfQlVTX1BF
RVIyUEVFUiBpcyBub3Qgc2V0CkNPTkZJR19WR0FfQVJCPXkKQ09ORklHX1ZHQV9BUkJfTUFY
X0dQVVM9MTYKQ09ORklHX0hPVFBMVUdfUENJPXkKQ09ORklHX0hPVFBMVUdfUENJX0FDUEk9
eQojIENPTkZJR19IT1RQTFVHX1BDSV9BQ1BJX0lCTSBpcyBub3Qgc2V0CkNPTkZJR19IT1RQ
TFVHX1BDSV9DUENJPXkKIyBDT05GSUdfSE9UUExVR19QQ0lfQ1BDSV9aVDU1NTAgaXMgbm90
IHNldAojIENPTkZJR19IT1RQTFVHX1BDSV9DUENJX0dFTkVSSUMgaXMgbm90IHNldAojIENP
TkZJR19IT1RQTFVHX1BDSV9PQ1RFT05FUCBpcyBub3Qgc2V0CkNPTkZJR19IT1RQTFVHX1BD
SV9TSFBDPXkKCiMKIyBQQ0kgY29udHJvbGxlciBkcml2ZXJzCiMKQ09ORklHX1BDSV9IT1NU
X0NPTU1PTj15CiMgQ09ORklHX1ZNRCBpcyBub3Qgc2V0CgojCiMgQ2FkZW5jZS1iYXNlZCBQ
Q0llIGNvbnRyb2xsZXJzCiMKIyBlbmQgb2YgQ2FkZW5jZS1iYXNlZCBQQ0llIGNvbnRyb2xs
ZXJzCgojCiMgRGVzaWduV2FyZS1iYXNlZCBQQ0llIGNvbnRyb2xsZXJzCiMKQ09ORklHX1BD
SUVfRFc9eQojIENPTkZJR19QQ0lFX0RXX0RFQlVHRlMgaXMgbm90IHNldApDT05GSUdfUENJ
RV9EV19IT1NUPXkKQ09ORklHX1BDSUVfRFdfRVA9eQojIENPTkZJR19QQ0lfTUVTT04gaXMg
bm90IHNldApDT05GSUdfUENJRV9EV19QTEFUPXkKQ09ORklHX1BDSUVfRFdfUExBVF9IT1NU
PXkKQ09ORklHX1BDSUVfRFdfUExBVF9FUD15CiMgZW5kIG9mIERlc2lnbldhcmUtYmFzZWQg
UENJZSBjb250cm9sbGVycwoKIwojIE1vYml2ZWlsLWJhc2VkIFBDSWUgY29udHJvbGxlcnMK
IwojIGVuZCBvZiBNb2JpdmVpbC1iYXNlZCBQQ0llIGNvbnRyb2xsZXJzCgojCiMgUExEQS1i
YXNlZCBQQ0llIGNvbnRyb2xsZXJzCiMKIyBlbmQgb2YgUExEQS1iYXNlZCBQQ0llIGNvbnRy
b2xsZXJzCiMgZW5kIG9mIFBDSSBjb250cm9sbGVyIGRyaXZlcnMKCiMKIyBQQ0kgRW5kcG9p
bnQKIwpDT05GSUdfUENJX0VORFBPSU5UPXkKQ09ORklHX1BDSV9FTkRQT0lOVF9DT05GSUdG
Uz15CiMgQ09ORklHX1BDSV9FTkRQT0lOVF9NU0lfRE9PUkJFTEwgaXMgbm90IHNldAojIENP
TkZJR19QQ0lfRVBGX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19QQ0lfRVBGX05UQiBpcyBu
b3Qgc2V0CiMgZW5kIG9mIFBDSSBFbmRwb2ludAoKIwojIFBDSSBzd2l0Y2ggY29udHJvbGxl
ciBkcml2ZXJzCiMKIyBDT05GSUdfUENJX1NXX1NXSVRDSFRFQyBpcyBub3Qgc2V0CiMgZW5k
IG9mIFBDSSBzd2l0Y2ggY29udHJvbGxlciBkcml2ZXJzCgojIENPTkZJR19QQ0lfUFdSQ1RS
TF9TTE9UIGlzIG5vdCBzZXQKIyBDT05GSUdfUENJX1BXUkNUUkxfVEM5NTYzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQ1hMX0JVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1BDQ0FSRCBpcyBub3Qg
c2V0CkNPTkZJR19SQVBJRElPPXkKIyBDT05GSUdfUkFQSURJT19UU0k3MjEgaXMgbm90IHNl
dApDT05GSUdfUkFQSURJT19ESVNDX1RJTUVPVVQ9MzAKIyBDT05GSUdfUkFQSURJT19FTkFC
TEVfUlhfVFhfUE9SVFMgaXMgbm90IHNldApDT05GSUdfUkFQSURJT19ETUFfRU5HSU5FPXkK
IyBDT05GSUdfUkFQSURJT19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1JBUElESU9fRU5V
TV9CQVNJQyBpcyBub3Qgc2V0CiMgQ09ORklHX1JBUElESU9fQ0hNQU4gaXMgbm90IHNldAoj
IENPTkZJR19SQVBJRElPX01QT1JUX0NERVYgaXMgbm90IHNldAoKIwojIFJhcGlkSU8gU3dp
dGNoIGRyaXZlcnMKIwojIENPTkZJR19SQVBJRElPX0NQU19YWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1JBUElESU9fQ1BTX0dFTjIgaXMgbm90IHNldAojIENPTkZJR19SQVBJRElPX1JYU19H
RU4zIGlzIG5vdCBzZXQKIyBlbmQgb2YgUmFwaWRJTyBTd2l0Y2ggZHJpdmVycwoKQ09ORklH
X1BDMTA0PXkKCiMKIyBHZW5lcmljIERyaXZlciBPcHRpb25zCiMKQ09ORklHX0FVWElMSUFS
WV9CVVM9eQpDT05GSUdfVUVWRU5UX0hFTFBFUj15CkNPTkZJR19VRVZFTlRfSEVMUEVSX1BB
VEg9IiIKQ09ORklHX0RFVlRNUEZTPXkKQ09ORklHX0RFVlRNUEZTX01PVU5UPXkKIyBDT05G
SUdfREVWVE1QRlNfU0FGRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NUQU5EQUxPTkUgaXMgbm90
IHNldApDT05GSUdfUFJFVkVOVF9GSVJNV0FSRV9CVUlMRD15CgojCiMgRmlybXdhcmUgbG9h
ZGVyCiMKQ09ORklHX0ZXX0xPQURFUj15CkNPTkZJR19GV19MT0FERVJfREVCVUc9eQpDT05G
SUdfRldfTE9BREVSX1BBR0VEX0JVRj15CkNPTkZJR19GV19MT0FERVJfU1lTRlM9eQpDT05G
SUdfRVhUUkFfRklSTVdBUkU9IiIKQ09ORklHX0ZXX0xPQURFUl9VU0VSX0hFTFBFUj15CiMg
Q09ORklHX0ZXX0xPQURFUl9VU0VSX0hFTFBFUl9GQUxMQkFDSyBpcyBub3Qgc2V0CkNPTkZJ
R19GV19MT0FERVJfQ09NUFJFU1M9eQpDT05GSUdfRldfTE9BREVSX0NPTVBSRVNTX1haPXkK
IyBDT05GSUdfRldfTE9BREVSX0NPTVBSRVNTX1pTVEQgaXMgbm90IHNldApDT05GSUdfRldf
Q0FDSEU9eQojIENPTkZJR19GV19VUExPQUQgaXMgbm90IHNldAojIGVuZCBvZiBGaXJtd2Fy
ZSBsb2FkZXIKCkNPTkZJR19XQU5UX0RFVl9DT1JFRFVNUD15CkNPTkZJR19BTExPV19ERVZf
Q09SRURVTVA9eQpDT05GSUdfREVWX0NPUkVEVU1QPXkKIyBDT05GSUdfREVCVUdfRFJJVkVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfREVWUkVTIGlzIG5vdCBzZXQKIyBDT05GSUdf
REVCVUdfVEVTVF9EUklWRVJfUkVNT1ZFIGlzIG5vdCBzZXQKQ09ORklHX0hNRU1fUkVQT1JU
SU5HPXkKIyBDT05GSUdfVEVTVF9BU1lOQ19EUklWRVJfUFJPQkUgaXMgbm90IHNldApDT05G
SUdfU1lTX0hZUEVSVklTT1I9eQpDT05GSUdfR0VORVJJQ19DUFVfREVWSUNFUz15CkNPTkZJ
R19HRU5FUklDX0NQVV9BVVRPUFJPQkU9eQpDT05GSUdfR0VORVJJQ19DUFVfVlVMTkVSQUJJ
TElUSUVTPXkKQ09ORklHX1JFR01BUD15CkNPTkZJR19SRUdNQVBfSTJDPXkKQ09ORklHX1JF
R01BUF9TUEk9eQpDT05GSUdfUkVHTUFQX01NSU89eQpDT05GSUdfUkVHTUFQX0lSUT15CkNP
TkZJR19ETUFfU0hBUkVEX0JVRkZFUj15CiMgQ09ORklHX0RNQV9GRU5DRV9UUkFDRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZXX0RFVkxJTktfU1lOQ19TVEFURV9USU1FT1VUIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgR2VuZXJpYyBEcml2ZXIgT3B0aW9ucwoKIwojIEJ1cyBkZXZpY2VzCiMK
IyBDT05GSUdfTUhJX0JVUyBpcyBub3Qgc2V0CiMgQ09ORklHX01ISV9CVVNfRVAgaXMgbm90
IHNldAojIGVuZCBvZiBCdXMgZGV2aWNlcwoKQ09ORklHX0NPTk5FQ1RPUj15CkNPTkZJR19Q
Uk9DX0VWRU5UUz15CgojCiMgRmlybXdhcmUgRHJpdmVycwojCgojCiMgQVJNIFN5c3RlbSBD
b250cm9sIGFuZCBNYW5hZ2VtZW50IEludGVyZmFjZSBQcm90b2NvbAojCiMgZW5kIG9mIEFS
TSBTeXN0ZW0gQ29udHJvbCBhbmQgTWFuYWdlbWVudCBJbnRlcmZhY2UgUHJvdG9jb2wKCkNP
TkZJR19FREQ9eQpDT05GSUdfRUREX09GRj15CkNPTkZJR19GSVJNV0FSRV9NRU1NQVA9eQpD
T05GSUdfRE1JSUQ9eQojIENPTkZJR19ETUlfU1lTRlMgaXMgbm90IHNldApDT05GSUdfRE1J
X1NDQU5fTUFDSElORV9OT05fRUZJX0ZBTExCQUNLPXkKIyBDT05GSUdfSVNDU0lfSUJGVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZXX0NGR19TWVNGUyBpcyBub3Qgc2V0CkNPTkZJR19TWVNG
Qj15CiMgQ09ORklHX1NZU0ZCX1NJTVBMRUZCIGlzIG5vdCBzZXQKIyBDT05GSUdfR09PR0xF
X0ZJUk1XQVJFIGlzIG5vdCBzZXQKCiMKIyBFRkkgKEV4dGVuc2libGUgRmlybXdhcmUgSW50
ZXJmYWNlKSBTdXBwb3J0CiMKQ09ORklHX0VGSV9FU1JUPXkKQ09ORklHX0VGSV9WQVJTX1BT
VE9SRT1tCiMgQ09ORklHX0VGSV9WQVJTX1BTVE9SRV9ERUZBVUxUX0RJU0FCTEUgaXMgbm90
IHNldApDT05GSUdfRUZJX1NPRlRfUkVTRVJWRT15CkNPTkZJR19FRklfRFhFX01FTV9BVFRS
SUJVVEVTPXkKQ09ORklHX0VGSV9SVU5USU1FX1dSQVBQRVJTPXkKIyBDT05GSUdfRUZJX0JP
T1RMT0FERVJfQ09OVFJPTCBpcyBub3Qgc2V0CiMgQ09ORklHX0VGSV9DQVBTVUxFX0xPQURF
UiBpcyBub3Qgc2V0CiMgQ09ORklHX0VGSV9URVNUIGlzIG5vdCBzZXQKQ09ORklHX0VGSV9E
RVZfUEFUSF9QQVJTRVI9eQpDT05GSUdfQVBQTEVfUFJPUEVSVElFUz15CkNPTkZJR19SRVNF
VF9BVFRBQ0tfTUlUSUdBVElPTj15CkNPTkZJR19FRklfUkNJMl9UQUJMRT15CiMgQ09ORklH
X0VGSV9ESVNBQkxFX1BDSV9ETUEgaXMgbm90IHNldApDT05GSUdfRUZJX0VBUkxZQ09OPXkK
Q09ORklHX0VGSV9DVVNUT01fU1NEVF9PVkVSTEFZUz15CiMgQ09ORklHX0VGSV9ESVNBQkxF
X1JVTlRJTUUgaXMgbm90IHNldAojIENPTkZJR19FRklfQ09DT19TRUNSRVQgaXMgbm90IHNl
dAojIENPTkZJR19PVk1GX0RFQlVHX0xPRyBpcyBub3Qgc2V0CkNPTkZJR19VTkFDQ0VQVEVE
X01FTU9SWT15CkNPTkZJR19FRklfU0JBVF9GSUxFPSIiCiMgZW5kIG9mIEVGSSAoRXh0ZW5z
aWJsZSBGaXJtd2FyZSBJbnRlcmZhY2UpIFN1cHBvcnQKCkNPTkZJR19VRUZJX0NQRVI9eQpD
T05GSUdfVUVGSV9DUEVSX1g4Nj15CgojCiMgUXVhbGNvbW0gZmlybXdhcmUgZHJpdmVycwoj
CiMgZW5kIG9mIFF1YWxjb21tIGZpcm13YXJlIGRyaXZlcnMKCiMKIyBUZWdyYSBmaXJtd2Fy
ZSBkcml2ZXIKIwojIGVuZCBvZiBUZWdyYSBmaXJtd2FyZSBkcml2ZXIKIyBlbmQgb2YgRmly
bXdhcmUgRHJpdmVycwoKIyBDT05GSUdfRldDVEwgaXMgbm90IHNldAojIENPTkZJR19HTlNT
IGlzIG5vdCBzZXQKIyBDT05GSUdfTVREIGlzIG5vdCBzZXQKIyBDT05GSUdfT0YgaXMgbm90
IHNldApDT05GSUdfQVJDSF9NSUdIVF9IQVZFX1BDX1BBUlBPUlQ9eQojIENPTkZJR19QQVJQ
T1JUIGlzIG5vdCBzZXQKQ09ORklHX1BOUD15CiMgQ09ORklHX1BOUF9ERUJVR19NRVNTQUdF
UyBpcyBub3Qgc2V0CgojCiMgUHJvdG9jb2xzCiMKQ09ORklHX1BOUEFDUEk9eQpDT05GSUdf
QkxLX0RFVj15CiMgQ09ORklHX0JMS19ERVZfTlVMTF9CTEsgaXMgbm90IHNldAojIENPTkZJ
R19CTEtfREVWX0ZEIGlzIG5vdCBzZXQKQ09ORklHX0NEUk9NPXkKIyBDT05GSUdfQkxLX0RF
Vl9QQ0lFU1NEX01USVAzMlhYIGlzIG5vdCBzZXQKIyBDT05GSUdfWlJBTSBpcyBub3Qgc2V0
CkNPTkZJR19CTEtfREVWX0xPT1A9eQpDT05GSUdfQkxLX0RFVl9MT09QX01JTl9DT1VOVD04
CiMgQ09ORklHX0JMS19ERVZfRFJCRCBpcyBub3Qgc2V0CiMgQ09ORklHX0JMS19ERVZfTkJE
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl9SQU0gaXMgbm90IHNldAojIENPTkZJR19B
VEFfT1ZFUl9FVEggaXMgbm90IHNldApDT05GSUdfWEVOX0JMS0RFVl9GUk9OVEVORD15CiMg
Q09ORklHX1hFTl9CTEtERVZfQkFDS0VORCBpcyBub3Qgc2V0CkNPTkZJR19WSVJUSU9fQkxL
PXkKIyBDT05GSUdfQkxLX0RFVl9SQkQgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1VC
TEsgaXMgbm90IHNldAojIENPTkZJR19CTEtfREVWX1pPTkVEX0xPT1AgaXMgbm90IHNldAoK
IwojIE5WTUUgU3VwcG9ydAojCkNPTkZJR19OVk1FX0NPUkU9eQpDT05GSUdfQkxLX0RFVl9O
Vk1FPXkKIyBDT05GSUdfTlZNRV9NVUxUSVBBVEggaXMgbm90IHNldAojIENPTkZJR19OVk1F
X1ZFUkJPU0VfRVJST1JTIGlzIG5vdCBzZXQKQ09ORklHX05WTUVfSFdNT049eQpDT05GSUdf
TlZNRV9GQUJSSUNTPXkKQ09ORklHX05WTUVfRkM9eQpDT05GSUdfTlZNRV9UQ1A9eQojIENP
TkZJR19OVk1FX1RDUF9UTFMgaXMgbm90IHNldAojIENPTkZJR19OVk1FX0hPU1RfQVVUSCBp
cyBub3Qgc2V0CkNPTkZJR19OVk1FX1RBUkdFVD15CiMgQ09ORklHX05WTUVfVEFSR0VUX0RF
QlVHRlMgaXMgbm90IHNldApDT05GSUdfTlZNRV9UQVJHRVRfUEFTU1RIUlU9eQpDT05GSUdf
TlZNRV9UQVJHRVRfTE9PUD15CkNPTkZJR19OVk1FX1RBUkdFVF9GQz15CiMgQ09ORklHX05W
TUVfVEFSR0VUX0ZDTE9PUCBpcyBub3Qgc2V0CkNPTkZJR19OVk1FX1RBUkdFVF9UQ1A9eQoj
IENPTkZJR19OVk1FX1RBUkdFVF9UQ1BfVExTIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZNRV9U
QVJHRVRfQVVUSCBpcyBub3Qgc2V0CiMgQ09ORklHX05WTUVfVEFSR0VUX1BDSV9FUEYgaXMg
bm90IHNldAojIGVuZCBvZiBOVk1FIFN1cHBvcnQKCiMKIyBNaXNjIGRldmljZXMKIwojIENP
TkZJR19BRDUyNVhfRFBPVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RVTU1ZX0lSUSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lCTV9BU00gaXMgbm90IHNldAojIENPTkZJR19QSEFOVE9NIGlzIG5v
dCBzZXQKIyBDT05GSUdfUlBNQiBpcyBub3Qgc2V0CiMgQ09ORklHX1RJX0ZQQzIwMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RJRk1fQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX0lDUzkzMlM0
MDEgaXMgbm90IHNldAojIENPTkZJR19FTkNMT1NVUkVfU0VSVklDRVMgaXMgbm90IHNldAoj
IENPTkZJR19TR0lfWFAgaXMgbm90IHNldAojIENPTkZJR19IUF9JTE8gaXMgbm90IHNldAoj
IENPTkZJR19TR0lfR1JVIGlzIG5vdCBzZXQKIyBDT05GSUdfQVBEUzk4MDJBTFMgaXMgbm90
IHNldAojIENPTkZJR19JU0wyOTAwMyBpcyBub3Qgc2V0CiMgQ09ORklHX0lTTDI5MDIwIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UU0wyNTUwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19CSDE3NzAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FQRFM5OTBYIGlz
IG5vdCBzZXQKIyBDT05GSUdfSE1DNjM1MiBpcyBub3Qgc2V0CiMgQ09ORklHX0RTMTY4MiBp
cyBub3Qgc2V0CiMgQ09ORklHX0xBVFRJQ0VfRUNQM19DT05GSUcgaXMgbm90IHNldApDT05G
SUdfU1JBTT15CiMgQ09ORklHX0RXX1hEQVRBX1BDSUUgaXMgbm90IHNldAojIENPTkZJR19Q
Q0lfRU5EUE9JTlRfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1hJTElOWF9TREZFQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX05UU1lOQyBpcyBub3Qgc2V0CiMgQ09ORklHX05TTSBpcyBub3Qg
c2V0CiMgQ09ORklHX0MyUE9SVCBpcyBub3Qgc2V0CgojCiMgRUVQUk9NIHN1cHBvcnQKIwoj
IENPTkZJR19FRVBST01fQVQyNCBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV9BVDI1IGlz
IG5vdCBzZXQKIyBDT05GSUdfRUVQUk9NX01BWDY4NzUgaXMgbm90IHNldAojIENPTkZJR19F
RVBST01fOTNDWDYgaXMgbm90IHNldAojIENPTkZJR19FRVBST01fOTNYWDQ2IGlzIG5vdCBz
ZXQKIyBDT05GSUdfRUVQUk9NX0lEVF84OUhQRVNYIGlzIG5vdCBzZXQKIyBDT05GSUdfRUVQ
Uk9NX0VFMTAwNCBpcyBub3Qgc2V0CiMgQ09ORklHX0VFUFJPTV9NMjRMUiBpcyBub3Qgc2V0
CiMgZW5kIG9mIEVFUFJPTSBzdXBwb3J0CgojIENPTkZJR19DQjcxMF9DT1JFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19MSVMzX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0FMVEVS
QV9TVEFQTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX01FSSBpcyBub3Qgc2V0CiMgQ09O
RklHX1ZNV0FSRV9WTUNJIGlzIG5vdCBzZXQKIyBDT05GSUdfR0VOV1FFIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkNNX1ZLIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlTQ19BTENPUl9QQ0kgaXMg
bm90IHNldAojIENPTkZJR19NSVNDX1JUU1hfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlT
Q19SVFNYX1VTQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VBQ0NFIGlzIG5vdCBzZXQKQ09ORklH
X1BWUEFOSUM9eQojIENPTkZJR19QVlBBTklDX01NSU8gaXMgbm90IHNldAojIENPTkZJR19Q
VlBBTklDX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQX1BDSTFYWFhYIGlzIG5vdCBzZXQK
IyBDT05GSUdfS0VCQV9DUDUwMCBpcyBub3Qgc2V0CiMgZW5kIG9mIE1pc2MgZGV2aWNlcwoK
IwojIFNDU0kgZGV2aWNlIHN1cHBvcnQKIwpDT05GSUdfU0NTSV9NT0Q9eQpDT05GSUdfUkFJ
RF9BVFRSUz1tCkNPTkZJR19TQ1NJX0NPTU1PTj15CkNPTkZJR19TQ1NJPXkKQ09ORklHX1ND
U0lfRE1BPXkKQ09ORklHX1NDU0lfUFJPQ19GUz15CgojCiMgU0NTSSBzdXBwb3J0IHR5cGUg
KGRpc2ssIHRhcGUsIENELVJPTSkKIwpDT05GSUdfQkxLX0RFVl9TRD15CiMgQ09ORklHX0NI
Ul9ERVZfU1QgaXMgbm90IHNldApDT05GSUdfQkxLX0RFVl9TUj15CkNPTkZJR19DSFJfREVW
X1NHPXkKQ09ORklHX0JMS19ERVZfQlNHPXkKIyBDT05GSUdfQ0hSX0RFVl9TQ0ggaXMgbm90
IHNldApDT05GSUdfU0NTSV9DT05TVEFOVFM9eQpDT05GSUdfU0NTSV9MT0dHSU5HPXkKQ09O
RklHX1NDU0lfU0NBTl9BU1lOQz15CgojCiMgU0NTSSBUcmFuc3BvcnRzCiMKIyBDT05GSUdf
U0NTSV9TUElfQVRUUlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0ZDX0FUVFJTIGlzIG5v
dCBzZXQKIyBDT05GSUdfU0NTSV9JU0NTSV9BVFRSUyBpcyBub3Qgc2V0CkNPTkZJR19TQ1NJ
X1NBU19BVFRSUz1tCiMgQ09ORklHX1NDU0lfU0FTX0xJQlNBUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfU1JQX0FUVFJTIGlzIG5vdCBzZXQKIyBlbmQgb2YgU0NTSSBUcmFuc3BvcnRz
CgpDT05GSUdfU0NTSV9MT1dMRVZFTD15CiMgQ09ORklHX0lTQ1NJX1RDUCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lTQ1NJX0JPT1RfU1lTRlMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0NY
R0IzX0lTQ1NJIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9DWEdCNF9JU0NTSSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfQk5YMl9JU0NTSSBpcyBub3Qgc2V0CiMgQ09ORklHX0JFMklT
Q1NJIGlzIG5vdCBzZXQKIyBDT05GSUdfQkxLX0RFVl8zV19YWFhYX1JBSUQgaXMgbm90IHNl
dAojIENPTkZJR19TQ1NJX0hQU0EgaXMgbm90IHNldAojIENPTkZJR19TQ1NJXzNXXzlYWFgg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJXzNXX1NBUyBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
U0lfQUNBUkQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FBQ1JBSUQgaXMgbm90IHNldAoj
IENPTkZJR19TQ1NJX0FJQzdYWFggaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FJQzc5WFgg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FJQzk0WFggaXMgbm90IHNldAojIENPTkZJR19T
Q1NJX01WU0FTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9NVlVNSSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NDU0lfQURWQU5TWVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0FSQ01TUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfRVNBUzJSIGlzIG5vdCBzZXQKQ09ORklHX01FR0FS
QUlEX05FV0dFTj15CiMgQ09ORklHX01FR0FSQUlEX01NIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUVHQVJBSURfTEVHQUNZIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVHQVJBSURfU0FTIGlzIG5v
dCBzZXQKQ09ORklHX1NDU0lfTVBUM1NBUz1tCkNPTkZJR19TQ1NJX01QVDJTQVNfTUFYX1NH
RT0xMjgKQ09ORklHX1NDU0lfTVBUM1NBU19NQVhfU0dFPTEyOAojIENPTkZJR19TQ1NJX01Q
VDJTQVMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX01QSTNNUiBpcyBub3Qgc2V0CiMgQ09O
RklHX1NDU0lfU01BUlRQUUkgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0hQVElPUCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NDU0lfQlVTTE9HSUMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X01ZUkIgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX01ZUlMgaXMgbm90IHNldAojIENPTkZJ
R19WTVdBUkVfUFZTQ1NJIGlzIG5vdCBzZXQKIyBDT05GSUdfWEVOX1NDU0lfRlJPTlRFTkQg
aXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NOSUMgaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X0RNWDMxOTFEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9GRE9NQUlOX1BDSSBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfSVNDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfSVBTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JTklUSU8gaXMgbm90IHNldAojIENPTkZJR19TQ1NJ
X0lOSUExMDAgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1NURVggaXMgbm90IHNldAojIENP
TkZJR19TQ1NJX1NZTTUzQzhYWF8yIGlzIG5vdCBzZXQKIyBDT05GSUdfU0NTSV9JUFIgaXMg
bm90IHNldAojIENPTkZJR19TQ1NJX1FMT0dJQ18xMjgwIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0NTSV9RTEFfSVNDU0kgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX0RDMzk1eCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NDU0lfQU01M0M5NzQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1dE
NzE5WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NDU0lfREVCVUcgaXMgbm90IHNldAojIENPTkZJ
R19TQ1NJX1BNQ1JBSUQgaXMgbm90IHNldAojIENPTkZJR19TQ1NJX1BNODAwMSBpcyBub3Qg
c2V0CkNPTkZJR19TQ1NJX1ZJUlRJTz15CkNPTkZJR19TQ1NJX0RIPXkKQ09ORklHX1NDU0lf
REhfUkRBQz1tCiMgQ09ORklHX1NDU0lfREhfSFBfU1cgaXMgbm90IHNldApDT05GSUdfU0NT
SV9ESF9FTUM9bQpDT05GSUdfU0NTSV9ESF9BTFVBPW0KIyBlbmQgb2YgU0NTSSBkZXZpY2Ug
c3VwcG9ydAoKQ09ORklHX0FUQT15CkNPTkZJR19TQVRBX0hPU1Q9eQpDT05GSUdfUEFUQV9U
SU1JTkdTPXkKQ09ORklHX0FUQV9WRVJCT1NFX0VSUk9SPXkKQ09ORklHX0FUQV9GT1JDRT15
CkNPTkZJR19BVEFfQUNQST15CkNPTkZJR19TQVRBX1pQT0REPXkKQ09ORklHX1NBVEFfUE1Q
PXkKCiMKIyBDb250cm9sbGVycyB3aXRoIG5vbi1TRkYgbmF0aXZlIGludGVyZmFjZQojCkNP
TkZJR19TQVRBX0FIQ0k9bQpDT05GSUdfU0FUQV9NT0JJTEVfTFBNX1BPTElDWT0wCkNPTkZJ
R19TQVRBX0FIQ0lfUExBVEZPUk09bQojIENPTkZJR19BSENJX0RXQyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBVEFfSU5JQzE2MlggaXMgbm90IHNldApDT05GSUdfU0FUQV9BQ0FSRF9BSENJ
PW0KIyBDT05GSUdfU0FUQV9TSUwyNCBpcyBub3Qgc2V0CkNPTkZJR19BVEFfU0ZGPXkKCiMK
IyBTRkYgY29udHJvbGxlcnMgd2l0aCBjdXN0b20gRE1BIGludGVyZmFjZQojCiMgQ09ORklH
X1BEQ19BRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9RU1RPUiBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBVEFfU1g0IGlzIG5vdCBzZXQKQ09ORklHX0FUQV9CTURNQT15CgojCiMgU0FU
QSBTRkYgY29udHJvbGxlcnMgd2l0aCBCTURNQQojCkNPTkZJR19BVEFfUElJWD15CiMgQ09O
RklHX1NBVEFfRFdDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FUQV9NViBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBVEFfTlYgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1BST01JU0UgaXMgbm90
IHNldAojIENPTkZJR19TQVRBX1NJTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfU0lTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0FUQV9TVlcgaXMgbm90IHNldAojIENPTkZJR19TQVRBX1VM
SSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBVEFfVklBIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FU
QV9WSVRFU1NFIGlzIG5vdCBzZXQKCiMKIyBQQVRBIFNGRiBjb250cm9sbGVycyB3aXRoIEJN
RE1BCiMKIyBDT05GSUdfUEFUQV9BTEkgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0FNRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQVJUT1AgaXMgbm90IHNldAojIENPTkZJR19QQVRB
X0FUSUlYUCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfQVRQODY3WCBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfQ01ENjRYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9DWVBSRVNTIGlz
IG5vdCBzZXQKIyBDT05GSUdfUEFUQV9FRkFSIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9I
UFQzNjYgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0hQVDM3WCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfSFBUM1gyTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSFBUM1gzIGlzIG5v
dCBzZXQKIyBDT05GSUdfUEFUQV9JVDgyMTMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX0lU
ODIxWCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfSk1JQ1JPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX1BBVEFfTUFSVkVMTCBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfTkVUQ0VMTCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BBVEFfTklOSkEzMiBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
TlM4NzQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfT0xEUElJWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfT1BUSURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfUERDMjAyN1gg
aXMgbm90IHNldAojIENPTkZJR19QQVRBX1BEQ19PTEQgaXMgbm90IHNldAojIENPTkZJR19Q
QVRBX1JBRElTWVMgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JEQyBpcyBub3Qgc2V0CiMg
Q09ORklHX1BBVEFfU0NIIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9TRVJWRVJXT1JLUyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BBVEFfU0lMNjgwIGlzIG5vdCBzZXQKQ09ORklHX1BBVEFf
U0lTPXkKIyBDT05GSUdfUEFUQV9UT1NISUJBIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9U
UklGTEVYIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFUQV9WSUEgaXMgbm90IHNldAojIENPTkZJ
R19QQVRBX1dJTkJPTkQgaXMgbm90IHNldAoKIwojIFBJTy1vbmx5IFNGRiBjb250cm9sbGVy
cwojCiMgQ09ORklHX1BBVEFfQ01ENjQwX1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX1BBVEFf
TVBJSVggaXMgbm90IHNldAojIENPTkZJR19QQVRBX05TODc0MTAgaXMgbm90IHNldAojIENP
TkZJR19QQVRBX09QVEkgaXMgbm90IHNldAojIENPTkZJR19QQVRBX1JaMTAwMCBpcyBub3Qg
c2V0CgojCiMgR2VuZXJpYyBmYWxsYmFjayAvIGxlZ2FjeSBkcml2ZXJzCiMKIyBDT05GSUdf
UEFUQV9BQ1BJIGlzIG5vdCBzZXQKQ09ORklHX0FUQV9HRU5FUklDPXkKIyBDT05GSUdfUEFU
QV9MRUdBQ1kgaXMgbm90IHNldApDT05GSUdfTUQ9eQpDT05GSUdfQkxLX0RFVl9NRD15CkNP
TkZJR19NRF9CSVRNQVA9eQojIENPTkZJR19NRF9MTEJJVE1BUCBpcyBub3Qgc2V0CkNPTkZJ
R19NRF9BVVRPREVURUNUPXkKQ09ORklHX01EX0JJVE1BUF9GSUxFPXkKIyBDT05GSUdfTURf
TElORUFSIGlzIG5vdCBzZXQKQ09ORklHX01EX1JBSUQwPW0KQ09ORklHX01EX1JBSUQxPW0K
Q09ORklHX01EX1JBSUQxMD1tCkNPTkZJR19NRF9SQUlENDU2PW0KIyBDT05GSUdfQkNBQ0hF
IGlzIG5vdCBzZXQKQ09ORklHX0JMS19ERVZfRE1fQlVJTFRJTj15CkNPTkZJR19CTEtfREVW
X0RNPXkKIyBDT05GSUdfRE1fREVCVUcgaXMgbm90IHNldAojIENPTkZJR19ETV9VTlNUUklQ
RUQgaXMgbm90IHNldAojIENPTkZJR19ETV9DUllQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RN
X1NOQVBTSE9UIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fVEhJTl9QUk9WSVNJT05JTkcgaXMg
bm90IHNldAojIENPTkZJR19ETV9DQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1dSSVRF
Q0FDSEUgaXMgbm90IHNldAojIENPTkZJR19ETV9FQlMgaXMgbm90IHNldAojIENPTkZJR19E
TV9FUkEgaXMgbm90IHNldAojIENPTkZJR19ETV9DTE9ORSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RNX01JUlJPUiBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX1JBSUQgaXMgbm90IHNldAojIENP
TkZJR19ETV9aRVJPIGlzIG5vdCBzZXQKQ09ORklHX0RNX01VTFRJUEFUSD1tCiMgQ09ORklH
X0RNX01VTFRJUEFUSF9RTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX01VTFRJUEFUSF9TVCBp
cyBub3Qgc2V0CiMgQ09ORklHX0RNX01VTFRJUEFUSF9IU1QgaXMgbm90IHNldAojIENPTkZJ
R19ETV9NVUxUSVBBVEhfSU9BIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fREVMQVkgaXMgbm90
IHNldAojIENPTkZJR19ETV9EVVNUIGlzIG5vdCBzZXQKQ09ORklHX0RNX0lOSVQ9eQpDT05G
SUdfRE1fVUVWRU5UPXkKIyBDT05GSUdfRE1fRkxBS0VZIGlzIG5vdCBzZXQKIyBDT05GSUdf
RE1fVkVSSVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1fU1dJVENIIGlzIG5vdCBzZXQKIyBD
T05GSUdfRE1fTE9HX1dSSVRFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RNX0lOVEVHUklUWSBp
cyBub3Qgc2V0CiMgQ09ORklHX0RNX1pPTkVEIGlzIG5vdCBzZXQKQ09ORklHX0RNX0FVRElU
PXkKIyBDT05GSUdfRE1fVkRPIGlzIG5vdCBzZXQKIyBDT05GSUdfVEFSR0VUX0NPUkUgaXMg
bm90IHNldApDT05GSUdfRlVTSU9OPXkKIyBDT05GSUdfRlVTSU9OX1NQSSBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZVU0lPTl9TQVMgaXMgbm90IHNldApDT05GSUdfRlVTSU9OX01BWF9TR0U9
MTI4CkNPTkZJR19GVVNJT05fTE9HR0lORz15CgojCiMgSUVFRSAxMzk0IChGaXJlV2lyZSkg
c3VwcG9ydAojCiMgQ09ORklHX0ZJUkVXSVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfRklSRVdJ
UkVfTk9TWSBpcyBub3Qgc2V0CiMgZW5kIG9mIElFRUUgMTM5NCAoRmlyZVdpcmUpIHN1cHBv
cnQKCkNPTkZJR19NQUNJTlRPU0hfRFJJVkVSUz15CkNPTkZJR19NQUNfRU1VTU9VU0VCVE49
bQpDT05GSUdfTkVUREVWSUNFUz15CkNPTkZJR19ORVRfQ09SRT15CiMgQ09ORklHX0JPTkRJ
TkcgaXMgbm90IHNldAojIENPTkZJR19EVU1NWSBpcyBub3Qgc2V0CiMgQ09ORklHX1dJUkVH
VUFSRCBpcyBub3Qgc2V0CiMgQ09ORklHX09WUE4gaXMgbm90IHNldAojIENPTkZJR19FUVVB
TElaRVIgaXMgbm90IHNldApDT05GSUdfTkVUX0ZDPXkKIyBDT05GSUdfSUZCIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkVUX1RFQU0gaXMgbm90IHNldAojIENPTkZJR19NQUNWTEFOIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVBWTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfVlhMQU4gaXMgbm90
IHNldAojIENPTkZJR19HRU5FVkUgaXMgbm90IHNldAojIENPTkZJR19CQVJFVURQIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1RQIGlzIG5vdCBzZXQKIyBDT05GSUdfUEZDUCBpcyBub3Qgc2V0
CiMgQ09ORklHX0FNVCBpcyBub3Qgc2V0CiMgQ09ORklHX01BQ1NFQyBpcyBub3Qgc2V0CiMg
Q09ORklHX05FVENPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19SSU9ORVQgaXMgbm90IHNl
dApDT05GSUdfVFVOPXkKIyBDT05GSUdfVFVOX1ZORVRfQ1JPU1NfTEUgaXMgbm90IHNldAoj
IENPTkZJR19WRVRIIGlzIG5vdCBzZXQKQ09ORklHX1ZJUlRJT19ORVQ9eQojIENPTkZJR19O
TE1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVEtJVCBpcyBub3Qgc2V0CiMgQ09ORklHX05F
VF9WUkYgaXMgbm90IHNldAojIENPTkZJR19BUkNORVQgaXMgbm90IHNldApDT05GSUdfRVRI
RVJORVQ9eQpDT05GSUdfTkVUX1ZFTkRPUl8zQ09NPXkKIyBDT05GSUdfVk9SVEVYIGlzIG5v
dCBzZXQKIyBDT05GSUdfVFlQSE9PTiBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0FE
QVBURUM9eQojIENPTkZJR19BREFQVEVDX1NUQVJGSVJFIGlzIG5vdCBzZXQKQ09ORklHX05F
VF9WRU5ET1JfQUdFUkU9eQojIENPTkZJR19FVDEzMVggaXMgbm90IHNldApDT05GSUdfTkVU
X1ZFTkRPUl9BTEFDUklURUNIPXkKIyBDT05GSUdfU0xJQ09TUyBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfVkVORE9SX0FMVEVPTj15CiMgQ09ORklHX0FDRU5JQyBpcyBub3Qgc2V0CiMgQ09O
RklHX0FMVEVSQV9UU0UgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9BTUFaT049eQoj
IENPTkZJR19FTkFfRVRIRVJORVQgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9BTUQ9
eQojIENPTkZJR19BTUQ4MTExX0VUSCBpcyBub3Qgc2V0CiMgQ09ORklHX1BDTkVUMzIgaXMg
bm90IHNldAojIENPTkZJR19BTURfWEdCRSBpcyBub3Qgc2V0CiMgQ09ORklHX1BEU19DT1JF
IGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfQVFVQU5USUE9eQojIENPTkZJR19BUVRJ
T04gaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9BUkM9eQpDT05GSUdfTkVUX1ZFTkRP
Ul9BU0lYPXkKIyBDT05GSUdfU1BJX0FYODg3OTZDIGlzIG5vdCBzZXQKQ09ORklHX05FVF9W
RU5ET1JfQVRIRVJPUz15CiMgQ09ORklHX0FUTDIgaXMgbm90IHNldAojIENPTkZJR19BVEwx
IGlzIG5vdCBzZXQKIyBDT05GSUdfQVRMMUUgaXMgbm90IHNldAojIENPTkZJR19BVEwxQyBp
cyBub3Qgc2V0CiMgQ09ORklHX0FMWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NYX0VDQVQgaXMg
bm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9CUk9BRENPTT15CiMgQ09ORklHX0I0NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JDTUdFTkVUIGlzIG5vdCBzZXQKIyBDT05GSUdfQk5YMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NOSUMgaXMgbm90IHNldApDT05GSUdfVElHT04zPW0KQ09ORklH
X1RJR09OM19IV01PTj15CiMgQ09ORklHX0JOWDJYIGlzIG5vdCBzZXQKIyBDT05GSUdfU1lT
VEVNUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX0JOWFQgaXMgbm90IHNldAojIENPTkZJR19C
TkdFIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfQ0FERU5DRT15CiMgQ09ORklHX01B
Q0IgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9DQVZJVU09eQojIENPTkZJR19USFVO
REVSX05JQ19QRiBpcyBub3Qgc2V0CiMgQ09ORklHX1RIVU5ERVJfTklDX1ZGIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVEhVTkRFUl9OSUNfQkdYIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhVTkRF
Ul9OSUNfUkdYIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FWSVVNX1BUUCBpcyBub3Qgc2V0CiMg
Q09ORklHX0xJUVVJRElPIGlzIG5vdCBzZXQKIyBDT05GSUdfTElRVUlESU9fVkYgaXMgbm90
IHNldApDT05GSUdfTkVUX1ZFTkRPUl9DSEVMU0lPPXkKIyBDT05GSUdfQ0hFTFNJT19UMSBp
cyBub3Qgc2V0CiMgQ09ORklHX0NIRUxTSU9fVDMgaXMgbm90IHNldAojIENPTkZJR19DSEVM
U0lPX1Q0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hFTFNJT19UNFZGIGlzIG5vdCBzZXQKQ09O
RklHX05FVF9WRU5ET1JfQ0lTQ089eQojIENPTkZJR19FTklDIGlzIG5vdCBzZXQKQ09ORklH
X05FVF9WRU5ET1JfQ09SVElOQT15CkNPTkZJR19ORVRfVkVORE9SX0RBVklDT009eQojIENP
TkZJR19ETTkwNTEgaXMgbm90IHNldAojIENPTkZJR19ETkVUIGlzIG5vdCBzZXQKQ09ORklH
X05FVF9WRU5ET1JfREVDPXkKQ09ORklHX05FVF9UVUxJUD15CiMgQ09ORklHX0RFMjEwNFgg
aXMgbm90IHNldAojIENPTkZJR19UVUxJUCBpcyBub3Qgc2V0CiMgQ09ORklHX1dJTkJPTkRf
ODQwIGlzIG5vdCBzZXQKIyBDT05GSUdfRE05MTAyIGlzIG5vdCBzZXQKIyBDT05GSUdfVUxJ
NTI2WCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0RMSU5LPXkKIyBDT05GSUdfREwy
SyBpcyBub3Qgc2V0CiMgQ09ORklHX1NVTkRBTkNFIGlzIG5vdCBzZXQKQ09ORklHX05FVF9W
RU5ET1JfRU1VTEVYPXkKIyBDT05GSUdfQkUyTkVUIGlzIG5vdCBzZXQKQ09ORklHX05FVF9W
RU5ET1JfRU5HTEVERVI9eQojIENPTkZJR19UU05FUCBpcyBub3Qgc2V0CkNPTkZJR19ORVRf
VkVORE9SX0VaQ0hJUD15CkNPTkZJR19ORVRfVkVORE9SX0ZVTkdJQkxFPXkKIyBDT05GSUdf
RlVOX0VUSCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0dPT0dMRT15CiMgQ09ORklH
X0dWRSBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0hJU0lMSUNPTj15CiMgQ09ORklH
X0hJQk1DR0UgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9IVUFXRUk9eQojIENPTkZJ
R19ISU5JQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJTklDMyBpcyBub3Qgc2V0CkNPTkZJR19O
RVRfVkVORE9SX0k4MjVYWD15CkNPTkZJR19ORVRfVkVORE9SX0lOVEVMPXkKIyBDT05GSUdf
RTEwMCBpcyBub3Qgc2V0CkNPTkZJR19FMTAwMD1tCkNPTkZJR19FMTAwMEU9bQpDT05GSUdf
RTEwMDBFX0hXVFM9eQojIENPTkZJR19JR0IgaXMgbm90IHNldAojIENPTkZJR19JR0JWRiBp
cyBub3Qgc2V0CiMgQ09ORklHX0lYR0JFIGlzIG5vdCBzZXQKIyBDT05GSUdfSVhHQkVWRiBp
cyBub3Qgc2V0CiMgQ09ORklHX0k0MEUgaXMgbm90IHNldAojIENPTkZJR19JNDBFVkYgaXMg
bm90IHNldAojIENPTkZJR19JQ0UgaXMgbm90IHNldAojIENPTkZJR19GTTEwSyBpcyBub3Qg
c2V0CiMgQ09ORklHX0lHQyBpcyBub3Qgc2V0CiMgQ09ORklHX0lEUEYgaXMgbm90IHNldAoj
IENPTkZJR19KTUUgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9BREk9eQojIENPTkZJ
R19BRElOMTExMCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0xJVEVYPXkKQ09ORklH
X05FVF9WRU5ET1JfTUFSVkVMTD15CiMgQ09ORklHX01WTURJTyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NLR0UgaXMgbm90IHNldAojIENPTkZJR19TS1kyIGlzIG5vdCBzZXQKIyBDT05GSUdf
T0NURU9OX0VQIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NURU9OX0VQX1ZGIGlzIG5vdCBzZXQK
Q09ORklHX05FVF9WRU5ET1JfTUVMTEFOT1g9eQojIENPTkZJR19NTFg0X0VOIGlzIG5vdCBz
ZXQKQ09ORklHX01MWDVfQ09SRT1tCkNPTkZJR19NTFg1X0ZQR0E9eQpDT05GSUdfTUxYNV9D
T1JFX0VOPXkKQ09ORklHX01MWDVfRU5fQVJGUz15CkNPTkZJR19NTFg1X0VOX1JYTkZDPXkK
Q09ORklHX01MWDVfTVBGUz15CkNPTkZJR19NTFg1X0VTV0lUQ0g9eQpDT05GSUdfTUxYNV9C
UklER0U9eQpDT05GSUdfTUxYNV9DTFNfQUNUPXkKQ09ORklHX01MWDVfVENfU0FNUExFPXkK
Q09ORklHX01MWDVfQ09SRV9FTl9EQ0I9eQpDT05GSUdfTUxYNV9DT1JFX0lQT0lCPXkKQ09O
RklHX01MWDVfU1dfU1RFRVJJTkc9eQpDT05GSUdfTUxYNV9IV19TVEVFUklORz15CkNPTkZJ
R19NTFg1X1NGPXkKQ09ORklHX01MWDVfU0ZfTUFOQUdFUj15CiMgQ09ORklHX01MWDVfRFBM
TCBpcyBub3Qgc2V0CiMgQ09ORklHX01MWFNXX0NPUkUgaXMgbm90IHNldAojIENPTkZJR19N
TFhGVyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX01FVEE9eQojIENPTkZJR19GQk5J
QyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX01JQ1JFTD15CiMgQ09ORklHX0tTODg0
MiBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1MSBpcyBub3Qgc2V0CiMgQ09ORklHX0tTODg1
MV9NTEwgaXMgbm90IHNldAojIENPTkZJR19LU1o4ODRYX1BDSSBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfVkVORE9SX01JQ1JPQ0hJUD15CiMgQ09ORklHX0VOQzI4SjYwIGlzIG5vdCBzZXQK
IyBDT05GSUdfRU5DWDI0SjYwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0xBTjc0M1ggaXMgbm90
IHNldAojIENPTkZJR19MQU44NjVYIGlzIG5vdCBzZXQKIyBDT05GSUdfVkNBUCBpcyBub3Qg
c2V0CkNPTkZJR19ORVRfVkVORE9SX01JQ1JPU0VNST15CkNPTkZJR19ORVRfVkVORE9SX01J
Q1JPU09GVD15CkNPTkZJR19ORVRfVkVORE9SX01VQ1NFPXkKIyBDT05GSUdfTUdCRSBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX01ZUkk9eQojIENPTkZJR19NWVJJMTBHRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0ZFQUxOWCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX05J
PXkKIyBDT05GSUdfTklfWEdFX01BTkFHRU1FTlRfRU5FVCBpcyBub3Qgc2V0CkNPTkZJR19O
RVRfVkVORE9SX05BVFNFTUk9eQpDT05GSUdfTkFUU0VNST15CiMgQ09ORklHX05TODM4MjAg
aXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9ORVRFUklPTj15CiMgQ09ORklHX1MySU8g
aXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9ORVRST05PTUU9eQojIENPTkZJR19ORlAg
aXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl84MzkwPXkKIyBDT05GSUdfTkUyS19QQ0kg
aXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9OVklESUE9eQojIENPTkZJR19GT1JDRURF
VEggaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9PS0k9eQojIENPTkZJR19FVEhPQyBp
cyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1BBQ0tFVF9FTkdJTkVTPXkKIyBDT05GSUdf
SEFNQUNISSBpcyBub3Qgc2V0CiMgQ09ORklHX1lFTExPV0ZJTiBpcyBub3Qgc2V0CkNPTkZJ
R19ORVRfVkVORE9SX1BFTlNBTkRPPXkKIyBDT05GSUdfSU9OSUMgaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9RTE9HSUM9eQojIENPTkZJR19RTEEzWFhYIGlzIG5vdCBzZXQKIyBD
T05GSUdfUUxDTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfTkVUWEVOX05JQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1FFRCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX0JST0NBREU9eQoj
IENPTkZJR19CTkEgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9RVUFMQ09NTT15CiMg
Q09ORklHX1FDT01fRU1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX1JNTkVUIGlzIG5vdCBzZXQK
Q09ORklHX05FVF9WRU5ET1JfUkRDPXkKIyBDT05GSUdfUjYwNDAgaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9SRUFMVEVLPXkKIyBDT05GSUdfODEzOUNQIGlzIG5vdCBzZXQKIyBD
T05GSUdfODEzOVRPTyBpcyBub3Qgc2V0CiMgQ09ORklHX1I4MTY5IGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRBU0UgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9SRU5FU0FTPXkKQ09O
RklHX05FVF9WRU5ET1JfUk9DS0VSPXkKIyBDT05GSUdfUk9DS0VSIGlzIG5vdCBzZXQKQ09O
RklHX05FVF9WRU5ET1JfU0FNU1VORz15CiMgQ09ORklHX1NYR0JFX0VUSCBpcyBub3Qgc2V0
CkNPTkZJR19ORVRfVkVORE9SX1NFRVE9eQpDT05GSUdfTkVUX1ZFTkRPUl9TSUxBTj15CiMg
Q09ORklHX1NDOTIwMzEgaXMgbm90IHNldApDT05GSUdfTkVUX1ZFTkRPUl9TSVM9eQojIENP
TkZJR19TSVM5MDAgaXMgbm90IHNldAojIENPTkZJR19TSVMxOTAgaXMgbm90IHNldApDT05G
SUdfTkVUX1ZFTkRPUl9TT0xBUkZMQVJFPXkKIyBDT05GSUdfU0ZDIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0ZDX0ZBTENPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NGQ19TSUVOQSBpcyBub3Qg
c2V0CkNPTkZJR19ORVRfVkVORE9SX1NNU0M9eQojIENPTkZJR19FUElDMTAwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU01TQzkxMVggaXMgbm90IHNldAojIENPTkZJR19TTVNDOTQyMCBpcyBu
b3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1NPQ0lPTkVYVD15CkNPTkZJR19ORVRfVkVORE9S
X1NUTUlDUk89eQojIENPTkZJR19TVE1NQUNfRVRIIGlzIG5vdCBzZXQKQ09ORklHX05FVF9W
RU5ET1JfU1VOPXkKIyBDT05GSUdfSEFQUFlNRUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VO
R0VNIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0FTU0lOSSBpcyBub3Qgc2V0CiMgQ09ORklHX05J
VSBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1NZTk9QU1lTPXkKIyBDT05GSUdfRFdD
X1hMR01BQyBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1RFSFVUST15CiMgQ09ORklH
X1RFSFVUSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFSFVUSV9UTjQwIGlzIG5vdCBzZXQKQ09O
RklHX05FVF9WRU5ET1JfVEk9eQojIENPTkZJR19USV9DUFNXX1BIWV9TRUwgaXMgbm90IHNl
dAojIENPTkZJR19UTEFOIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfVkVSVEVYQ09N
PXkKIyBDT05GSUdfTVNFMTAyWCBpcyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1ZJQT15
CiMgQ09ORklHX1ZJQV9SSElORSBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJQV9WRUxPQ0lUWSBp
cyBub3Qgc2V0CkNPTkZJR19ORVRfVkVORE9SX1dBTkdYVU49eQojIENPTkZJR19OR0JFIGlz
IG5vdCBzZXQKIyBDT05GSUdfVFhHQkUgaXMgbm90IHNldAojIENPTkZJR19UWEdCRVZGIGlz
IG5vdCBzZXQKIyBDT05GSUdfTkdCRVZGIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1Jf
V0laTkVUPXkKIyBDT05GSUdfV0laTkVUX1c1MTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfV0la
TkVUX1c1MzAwIGlzIG5vdCBzZXQKQ09ORklHX05FVF9WRU5ET1JfWElMSU5YPXkKIyBDT05G
SUdfWElMSU5YX0VNQUNMSVRFIGlzIG5vdCBzZXQKIyBDT05GSUdfWElMSU5YX0xMX1RFTUFD
IGlzIG5vdCBzZXQKQ09ORklHX0ZEREk9eQojIENPTkZJR19ERUZYWCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NLRlAgaXMgbm90IHNldAojIENPTkZJR19ISVBQSSBpcyBub3Qgc2V0CkNPTkZJ
R19NRElPX0JVUz15CkNPTkZJR19QSFlMSUI9eQpDT05GSUdfU1dQSFk9eQpDT05GSUdfTEVE
X1RSSUdHRVJfUEhZPXkKQ09ORklHX0ZJWEVEX1BIWT15CgojCiMgTUlJIFBIWSBkZXZpY2Ug
ZHJpdmVycwojCiMgQ09ORklHX0FTMjFYWFhfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQUlS
X0VOODgxMUhfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQU1EX1BIWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FESU5fUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQURJTjExMDBfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfQVFVQU5USUFfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQVg4ODc5
NkJfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQlJPQURDT01fUEhZIGlzIG5vdCBzZXQKIyBD
T05GSUdfQkNNNTQxNDBfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQkNNN1hYWF9QSFkgaXMg
bm90IHNldApDT05GSUdfQkNNODQ4ODFfUEhZPXkKIyBDT05GSUdfQkNNODdYWF9QSFkgaXMg
bm90IHNldAojIENPTkZJR19DSUNBREFfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09SVElO
QV9QSFkgaXMgbm90IHNldAojIENPTkZJR19EQVZJQ09NX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lDUExVU19QSFkgaXMgbm90IHNldAojIENPTkZJR19MWFRfUEhZIGlzIG5vdCBzZXQK
IyBDT05GSUdfSU5URUxfWFdBWV9QSFkgaXMgbm90IHNldAojIENPTkZJR19MU0lfRVQxMDEx
Q19QSFkgaXMgbm90IHNldAojIENPTkZJR19NQVJWRUxMX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX01BUlZFTExfMTBHX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX01BUlZFTExfODhRMlhY
WF9QSFkgaXMgbm90IHNldAojIENPTkZJR19NQVJWRUxMXzg4WDIyMjJfUEhZIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTUFYTElORUFSX0dQSFkgaXMgbm90IHNldAojIENPTkZJR19NQVhMSU5F
QVJfODYxMTBfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVESUFURUtfR0VfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUlDUkVMX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX01JQ1JPQ0hJ
UF9UMVNfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTUlDUk9DSElQX1BIWSBpcyBub3Qgc2V0
CiMgQ09ORklHX01JQ1JPQ0hJUF9UMV9QSFkgaXMgbm90IHNldAojIENPTkZJR19NSUNST1NF
TUlfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9UT1JDT01NX1BIWSBpcyBub3Qgc2V0CkNP
TkZJR19OQVRJT05BTF9QSFk9eQojIENPTkZJR19OWFBfQ0JUWF9QSFkgaXMgbm90IHNldAoj
IENPTkZJR19OWFBfQzQ1X1RKQTExWFhfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTlhQX1RK
QTExWFhfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfTkNOMjYwMDBfUEhZIGlzIG5vdCBzZXQK
IyBDT05GSUdfQVQ4MDNYX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX1FDQTgzWFhfUEhZIGlz
IG5vdCBzZXQKIyBDT05GSUdfUUNBODA4WF9QSFkgaXMgbm90IHNldAojIENPTkZJR19RU0VN
SV9QSFkgaXMgbm90IHNldAojIENPTkZJR19SRUFMVEVLX1BIWSBpcyBub3Qgc2V0CiMgQ09O
RklHX1JFTkVTQVNfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfUk9DS0NISVBfUEhZIGlzIG5v
dCBzZXQKIyBDT05GSUdfU01TQ19QSFkgaXMgbm90IHNldAojIENPTkZJR19TVEUxMFhQIGlz
IG5vdCBzZXQKIyBDT05GSUdfVEVSQU5FVElDU19QSFkgaXMgbm90IHNldAojIENPTkZJR19E
UDgzODIyX1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RQODNUQzgxMV9QSFkgaXMgbm90IHNl
dAojIENPTkZJR19EUDgzODQ4X1BIWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RQODM4NjdfUEhZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfRFA4Mzg2OV9QSFkgaXMgbm90IHNldAojIENPTkZJR19E
UDgzVEQ1MTBfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfRFA4M1RHNzIwX1BIWSBpcyBub3Qg
c2V0CiMgQ09ORklHX1ZJVEVTU0VfUEhZIGlzIG5vdCBzZXQKIyBDT05GSUdfWElMSU5YX0dN
SUkyUkdNSUkgaXMgbm90IHNldAojIENPTkZJR19QU0VfQ09OVFJPTExFUiBpcyBub3Qgc2V0
CgojCiMgTUNUUCBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX01DVFBfU0VSSUFMIGlzIG5v
dCBzZXQKIyBDT05GSUdfTUNUUF9UUkFOU1BPUlRfVVNCIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
TUNUUCBEZXZpY2UgRHJpdmVycwoKQ09ORklHX0ZXTk9ERV9NRElPPXkKQ09ORklHX0FDUElf
TURJTz15CiMgQ09ORklHX01ESU9fQklUQkFORyBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9f
QkNNX1VOSU1BQyBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fTVZVU0IgaXMgbm90IHNldAoj
IENPTkZJR19NRElPX01TQ0NfTUlJTSBpcyBub3Qgc2V0CiMgQ09ORklHX01ESU9fVEhVTkRF
UiBpcyBub3Qgc2V0CgojCiMgTURJTyBNdWx0aXBsZXhlcnMKIwoKIwojIFBDUyBkZXZpY2Ug
ZHJpdmVycwojCiMgQ09ORklHX1BDU19YUENTIGlzIG5vdCBzZXQKIyBlbmQgb2YgUENTIGRl
dmljZSBkcml2ZXJzCgpDT05GSUdfUFBQPXkKIyBDT05GSUdfUFBQX0JTRENPTVAgaXMgbm90
IHNldAojIENPTkZJR19QUFBfREVGTEFURSBpcyBub3Qgc2V0CkNPTkZJR19QUFBfRklMVEVS
PXkKIyBDT05GSUdfUFBQX01QUEUgaXMgbm90IHNldApDT05GSUdfUFBQX01VTFRJTElOSz15
CiMgQ09ORklHX1BQUE9FIGlzIG5vdCBzZXQKQ09ORklHX1BQUE9FX0hBU0hfQklUUz00CiMg
Q09ORklHX1BQUF9BU1lOQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BQUF9TWU5DX1RUWSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NMSVAgaXMgbm90IHNldApDT05GSUdfU0xIQz15CiMgQ09ORklH
X1VTQl9ORVRfRFJJVkVSUyBpcyBub3Qgc2V0CkNPTkZJR19XTEFOPXkKQ09ORklHX1dMQU5f
VkVORE9SX0FETVRFSz15CkNPTkZJR19XTEFOX1ZFTkRPUl9BVEg9eQojIENPTkZJR19BVEhf
REVCVUcgaXMgbm90IHNldApDT05GSUdfQVRINUtfUENJPXkKQ09ORklHX1dMQU5fVkVORE9S
X0FUTUVMPXkKQ09ORklHX1dMQU5fVkVORE9SX0JST0FEQ09NPXkKQ09ORklHX1dMQU5fVkVO
RE9SX0lOVEVMPXkKQ09ORklHX1dMQU5fVkVORE9SX0lOVEVSU0lMPXkKQ09ORklHX1dMQU5f
VkVORE9SX01BUlZFTEw9eQpDT05GSUdfV0xBTl9WRU5ET1JfTUVESUFURUs9eQpDT05GSUdf
V0xBTl9WRU5ET1JfTUlDUk9DSElQPXkKQ09ORklHX1dMQU5fVkVORE9SX1BVUkVMSUZJPXkK
Q09ORklHX1dMQU5fVkVORE9SX1JBTElOSz15CkNPTkZJR19XTEFOX1ZFTkRPUl9SRUFMVEVL
PXkKQ09ORklHX1dMQU5fVkVORE9SX1JTST15CkNPTkZJR19XTEFOX1ZFTkRPUl9TSUxBQlM9
eQpDT05GSUdfV0xBTl9WRU5ET1JfU1Q9eQpDT05GSUdfV0xBTl9WRU5ET1JfVEk9eQpDT05G
SUdfV0xBTl9WRU5ET1JfWllEQVM9eQpDT05GSUdfV0xBTl9WRU5ET1JfUVVBTlRFTk5BPXkK
Q09ORklHX1dBTj15CiMgQ09ORklHX0hETEMgaXMgbm90IHNldAojIENPTkZJR19GUkFNRVIg
aXMgbm90IHNldAoKIwojIFdpcmVsZXNzIFdBTgojCkNPTkZJR19XV0FOPXkKQ09ORklHX1dX
QU5fREVCVUdGUz15CiMgQ09ORklHX1dXQU5fSFdTSU0gaXMgbm90IHNldAojIENPTkZJR19J
T1NNIGlzIG5vdCBzZXQKIyBDT05GSUdfTVRLX1Q3WFggaXMgbm90IHNldAojIGVuZCBvZiBX
aXJlbGVzcyBXQU4KCkNPTkZJR19YRU5fTkVUREVWX0ZST05URU5EPXkKIyBDT05GSUdfWEVO
X05FVERFVl9CQUNLRU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfVk1YTkVUMyBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZVSklUU1VfRVMgaXMgbm90IHNldAojIENPTkZJR19ORVRERVZTSU0gaXMg
bm90IHNldApDT05GSUdfTkVUX0ZBSUxPVkVSPXkKQ09ORklHX0lTRE49eQojIENPTkZJR19N
SVNETiBpcyBub3Qgc2V0CgojCiMgSW5wdXQgZGV2aWNlIHN1cHBvcnQKIwpDT05GSUdfSU5Q
VVQ9eQpDT05GSUdfSU5QVVRfTEVEUz1tCiMgQ09ORklHX0lOUFVUX0ZGX01FTUxFU1MgaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9TUEFSU0VLTUFQIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfTUFUUklYS01BUCBpcyBub3Qgc2V0CkNPTkZJR19JTlBVVF9WSVZBTERJRk1BUD15
CgojCiMgVXNlcmxhbmQgaW50ZXJmYWNlcwojCkNPTkZJR19JTlBVVF9NT1VTRURFVj15CkNP
TkZJR19JTlBVVF9NT1VTRURFVl9QU0FVWD15CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JF
RU5fWD0xMDI0CkNPTkZJR19JTlBVVF9NT1VTRURFVl9TQ1JFRU5fWT03NjgKQ09ORklHX0lO
UFVUX0pPWURFVj1tCkNPTkZJR19JTlBVVF9FVkRFVj15CgojCiMgSW5wdXQgRGV2aWNlIERy
aXZlcnMKIwpDT05GSUdfSU5QVVRfS0VZQk9BUkQ9eQojIENPTkZJR19LRVlCT0FSRF9BRFA1
NTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfQURQNTU4OCBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFWUJPQVJEX0FQUExFU1BJIGlzIG5vdCBzZXQKQ09ORklHX0tFWUJPQVJEX0FU
S0JEPXkKIyBDT05GSUdfS0VZQk9BUkRfUVQxMDUwIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZ
Qk9BUkRfUVQxMDcwIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfUVQyMTYwIGlzIG5v
dCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfRExJTktfRElSNjg1IGlzIG5vdCBzZXQKIyBDT05G
SUdfS0VZQk9BUkRfTEtLQkQgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9HUElPIGlz
IG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfR1BJT19QT0xMRUQgaXMgbm90IHNldAojIENP
TkZJR19LRVlCT0FSRF9UQ0E4NDE4IGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFU
UklYIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTE04MzIzIGlzIG5vdCBzZXQKIyBD
T05GSUdfS0VZQk9BUkRfTE04MzMzIGlzIG5vdCBzZXQKIyBDT05GSUdfS0VZQk9BUkRfTUFY
NzM1OSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX01QUjEyMSBpcyBub3Qgc2V0CiMg
Q09ORklHX0tFWUJPQVJEX05FV1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX09Q
RU5DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1BJTkVQSE9ORSBpcyBub3Qg
c2V0CiMgQ09ORklHX0tFWUJPQVJEX1NBTVNVTkcgaXMgbm90IHNldAojIENPTkZJR19LRVlC
T0FSRF9TVE9XQVdBWSBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1NVTktCRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX1RNMl9UT1VDSEtFWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0tFWUJPQVJEX1RXTDQwMzAgaXMgbm90IHNldAojIENPTkZJR19LRVlCT0FSRF9YVEtC
RCBpcyBub3Qgc2V0CiMgQ09ORklHX0tFWUJPQVJEX0NZUFJFU1NfU0YgaXMgbm90IHNldApD
T05GSUdfSU5QVVRfTU9VU0U9eQojIENPTkZJR19NT1VTRV9QUzIgaXMgbm90IHNldAojIENP
TkZJR19NT1VTRV9TRVJJQUwgaXMgbm90IHNldAojIENPTkZJR19NT1VTRV9BUFBMRVRPVUNI
IGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfQkNNNTk3NCBpcyBub3Qgc2V0CiMgQ09ORklH
X01PVVNFX0NZQVBBIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0VfRUxBTl9JMkMgaXMgbm90
IHNldAojIENPTkZJR19NT1VTRV9WU1hYWEFBIGlzIG5vdCBzZXQKIyBDT05GSUdfTU9VU0Vf
R1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX01PVVNFX1NZTkFQVElDU19JMkMgaXMgbm90IHNl
dAojIENPTkZJR19NT1VTRV9TWU5BUFRJQ1NfVVNCIGlzIG5vdCBzZXQKQ09ORklHX0lOUFVU
X0pPWVNUSUNLPXkKIyBDT05GSUdfSk9ZU1RJQ0tfQU5BTE9HIGlzIG5vdCBzZXQKIyBDT05G
SUdfSk9ZU1RJQ0tfQTNEIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfQURJIGlzIG5v
dCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfQ09CUkEgaXMgbm90IHNldAojIENPTkZJR19KT1lT
VElDS19HRjJLIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfR1JJUCBpcyBub3Qgc2V0
CiMgQ09ORklHX0pPWVNUSUNLX0dSSVBfTVAgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElD
S19HVUlMTEVNT1QgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19JTlRFUkFDVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1NJREVXSU5ERVIgaXMgbm90IHNldAojIENPTkZJ
R19KT1lTVElDS19UTURDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfSUZPUkNFIGlz
IG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfV0FSUklPUiBpcyBub3Qgc2V0CiMgQ09ORklH
X0pPWVNUSUNLX01BR0VMTEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfU1BBQ0VP
UkIgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElDS19TUEFDRUJBTEwgaXMgbm90IHNldAoj
IENPTkZJR19KT1lTVElDS19TVElOR0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tf
VFdJREpPWSBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1pIRU5IVUEgaXMgbm90IHNl
dAojIENPTkZJR19KT1lTVElDS19BUzUwMTEgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElD
S19KT1lEVU1QIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfWFBBRCBpcyBub3Qgc2V0
CiMgQ09ORklHX0pPWVNUSUNLX1BTWFBBRF9TUEkgaXMgbm90IHNldAojIENPTkZJR19KT1lT
VElDS19QWFJDIGlzIG5vdCBzZXQKIyBDT05GSUdfSk9ZU1RJQ0tfUVdJSUMgaXMgbm90IHNl
dAojIENPTkZJR19KT1lTVElDS19GU0lBNkIgaXMgbm90IHNldAojIENPTkZJR19KT1lTVElD
S19TRU5TRUhBVCBpcyBub3Qgc2V0CiMgQ09ORklHX0pPWVNUSUNLX1NFRVNBVyBpcyBub3Qg
c2V0CkNPTkZJR19JTlBVVF9UQUJMRVQ9eQojIENPTkZJR19UQUJMRVRfVVNCX0FDRUNBRCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9VU0JfQUlQVEVLIGlzIG5vdCBzZXQKIyBDT05G
SUdfVEFCTEVUX1VTQl9IQU5XQU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfVEFCTEVUX1VTQl9L
QlRBQiBpcyBub3Qgc2V0CiMgQ09ORklHX1RBQkxFVF9VU0JfUEVHQVNVUyBpcyBub3Qgc2V0
CiMgQ09ORklHX1RBQkxFVF9TRVJJQUxfV0FDT000IGlzIG5vdCBzZXQKQ09ORklHX0lOUFVU
X1RPVUNIU0NSRUVOPXkKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fODhQTTg2MFggaXMgbm90IHNl
dAojIENPTkZJR19UT1VDSFNDUkVFTl9BRFM3ODQ2IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9V
Q0hTQ1JFRU5fQUQ3ODc3IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQUQ3ODc5
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQVRNRUxfTVhUIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9VQ0hTQ1JFRU5fQVVPX1BJWENJUiBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX0JVMjEwMTMgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9CVTIx
MDI5IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ0hJUE9ORV9JQ044NTA1IGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fQ1k4Q1RNQTE0MCBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0NZOENUTUcxMTAgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9DWVRUU1BfQ09SRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0NZ
VFRTUDUgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9EQTkwMzQgaXMgbm90IHNl
dAojIENPTkZJR19UT1VDSFNDUkVFTl9EQTkwNTIgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9EWU5BUFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSEFNUFNI
SVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRUVUSSBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0VHQUxBWF9TRVJJQUwgaXMgbm90IHNldAojIENPTkZJR19U
T1VDSFNDUkVFTl9FWEMzMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fRlVK
SVRTVSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0dPT0RJWCBpcyBub3Qgc2V0
CiMgQ09ORklHX1RPVUNIU0NSRUVOX0dPT0RJWF9CRVJMSU5fSTJDIGlzIG5vdCBzZXQKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fR09PRElYX0JFUkxJTl9TUEkgaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9ISURFRVAgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9I
SU1BWF9IWDg1MlggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9IWUNPTl9IWTQ2
WFggaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9IWU5JVFJPTl9DU1RYWFggaXMg
bm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9IWU5JVFJPTl9DU1Q4MTZYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fSUxJMjEwWCBpcyBub3Qgc2V0CiMgQ09ORklHX1RP
VUNIU0NSRUVOX0lMSVRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1M2U1k3
NjEgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9HVU5aRSBpcyBub3Qgc2V0CiMg
Q09ORklHX1RPVUNIU0NSRUVOX0VLVEYyMTI3IGlzIG5vdCBzZXQKQ09ORklHX1RPVUNIU0NS
RUVOX0VMQU49eQojIENPTkZJR19UT1VDSFNDUkVFTl9FTE8gaXMgbm90IHNldAojIENPTkZJ
R19UT1VDSFNDUkVFTl9XQUNPTV9XODAwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX1dBQ09NX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX01BWDExODAx
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTU1TMTE0IGlzIG5vdCBzZXQKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fTUVMRkFTX01JUDQgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9NU0cyNjM4IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTVRPVUNI
IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fTk9WQVRFS19OVlRfVFMgaXMgbm90
IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9JTUFHSVMgaXMgbm90IHNldAojIENPTkZJR19U
T1VDSFNDUkVFTl9JTkVYSU8gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9QRU5N
T1VOVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0VEVF9GVDVYMDYgaXMgbm90
IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9UT1VDSFJJR0hUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVE9VQ0hTQ1JFRU5fVE9VQ0hXSU4gaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVF
Tl9QSVhDSVIgaXMgbm90IHNldAojIENPTkZJR19UT1VDSFNDUkVFTl9XRFQ4N1hYX0kyQyBp
cyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1dNODMxWCBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX1VTQl9DT01QT1NJVEUgaXMgbm90IHNldAojIENPTkZJR19UT1VD
SFNDUkVFTl9UT1VDSElUMjEzIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFND
X1NFUklPIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fVFNDMjAwNCBpcyBub3Qg
c2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RTQzIwMDUgaXMgbm90IHNldAojIENPTkZJR19U
T1VDSFNDUkVFTl9UU0MyMDA3IGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fUENB
UCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1JNX1RTIGlzIG5vdCBzZXQKIyBD
T05GSUdfVE9VQ0hTQ1JFRU5fU0lMRUFEIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fU0lTX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1NUMTIzMiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1NUTUZUUyBpcyBub3Qgc2V0CiMgQ09ORklH
X1RPVUNIU0NSRUVOX1NVUkZBQ0UzX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NS
RUVOX1NYODY1NCBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX1RQUzY1MDdYIGlz
IG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JFRU5fWkVUNjIyMyBpcyBub3Qgc2V0CiMgQ09O
RklHX1RPVUNIU0NSRUVOX1pGT1JDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVO
X1JPSE1fQlUyMTAyMyBpcyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lRUzVYWCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RPVUNIU0NSRUVOX0lRUzcyMTEgaXMgbm90IHNldAojIENP
TkZJR19UT1VDSFNDUkVFTl9aSU5JVElYIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9VQ0hTQ1JF
RU5fSElNQVhfSFg4MzExMkIgaXMgbm90IHNldApDT05GSUdfSU5QVVRfTUlTQz15CiMgQ09O
RklHX0lOUFVUXzg4UE04NjBYX09OS0VZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQUQ3
MTRYIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQVc4NjkyNyBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX0JNQTE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0UzWDBfQlVUVE9O
IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfUENTUEtSIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5QVVRfTUFYNzc2OTNfSEFQVElDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfTUFYODky
NV9PTktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX01BWDg5OTdfSEFQVElDIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5QVVRfTU1BODQ1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVU
X0FQQU5FTCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0dQSU9fQkVFUEVSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSU5QVVRfR1BJT19ERUNPREVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfR1BJT19WSUJSQSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0FUTEFTX0JUTlMgaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9BVElfUkVNT1RFMiBpcyBub3Qgc2V0CiMgQ09ORklH
X0lOUFVUX0tFWVNQQU5fUkVNT1RFIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfS1hUSjkg
aXMgbm90IHNldAojIENPTkZJR19JTlBVVF9QT1dFUk1BVEUgaXMgbm90IHNldAojIENPTkZJ
R19JTlBVVF9ZRUFMSU5LIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfQ00xMDkgaXMgbm90
IHNldAojIENPTkZJR19JTlBVVF9SRUdVTEFUT1JfSEFQVElDIGlzIG5vdCBzZXQKIyBDT05G
SUdfSU5QVVRfUkVUVV9QV1JCVVRUT04gaXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UV0w0
MDMwX1BXUkJVVFRPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1RXTDQwMzBfVklCUkEg
aXMgbm90IHNldAojIENPTkZJR19JTlBVVF9UV0w2MDQwX1ZJQlJBIGlzIG5vdCBzZXQKQ09O
RklHX0lOUFVUX1VJTlBVVD15CiMgQ09ORklHX0lOUFVUX1BBTE1BU19QV1JCVVRUT04gaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9QQ0Y4NTc0IGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfUFdNX0JFRVBFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BXTV9WSUJSQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOUFVUX0dQSU9fUk9UQVJZX0VOQ09ERVIgaXMgbm90IHNldAoj
IENPTkZJR19JTlBVVF9EQTcyODBfSEFQVElDUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVU
X0RBOTA1Ml9PTktFWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0RBOTA1NV9PTktFWSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0RBOTA2M19PTktFWSBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX1dNODMxWF9PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX1BDQVAgaXMg
bm90IHNldAojIENPTkZJR19JTlBVVF9BRFhMMzRYIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfSU1TX1BDVSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0lRUzI2OUEgaXMgbm90IHNl
dAojIENPTkZJR19JTlBVVF9JUVM2MjZBIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5QVVRfSVFT
NzIyMiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0NNQTMwMDAgaXMgbm90IHNldAojIENP
TkZJR19JTlBVVF9YRU5fS0JEREVWX0ZST05URU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5Q
VVRfSURFQVBBRF9TTElERUJBUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0RSVjI2MFhf
SEFQVElDUyBpcyBub3Qgc2V0CiMgQ09ORklHX0lOUFVUX0RSVjI2NjVfSEFQVElDUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOUFVUX0RSVjI2NjdfSEFQVElDUyBpcyBub3Qgc2V0CiMgQ09O
RklHX0lOUFVUX1JBVkVfU1BfUFdSQlVUVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUk1JNF9D
T1JFIGlzIG5vdCBzZXQKCiMKIyBIYXJkd2FyZSBJL08gcG9ydHMKIwpDT05GSUdfU0VSSU89
eQpDT05GSUdfQVJDSF9NSUdIVF9IQVZFX1BDX1NFUklPPXkKQ09ORklHX1NFUklPX0k4MDQy
PXkKIyBDT05GSUdfU0VSSU9fU0VSUE9SVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklPX0NU
ODJDNzEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fUENJUFMyIGlzIG5vdCBzZXQKQ09O
RklHX1NFUklPX0xJQlBTMj15CiMgQ09ORklHX1NFUklPX1JBVyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFUklPX0FMVEVSQV9QUzIgaXMgbm90IHNldAojIENPTkZJR19TRVJJT19QUzJNVUxU
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSU9fQVJDX1BTMiBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFUklPX0dQSU9fUFMyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNFUklPIGlzIG5vdCBzZXQK
IyBDT05GSUdfR0FNRVBPUlQgaXMgbm90IHNldAojIGVuZCBvZiBIYXJkd2FyZSBJL08gcG9y
dHMKIyBlbmQgb2YgSW5wdXQgZGV2aWNlIHN1cHBvcnQKCiMKIyBDaGFyYWN0ZXIgZGV2aWNl
cwojCkNPTkZJR19UVFk9eQpDT05GSUdfVlQ9eQpDT05GSUdfQ09OU09MRV9UUkFOU0xBVElP
TlM9eQpDT05GSUdfVlRfQ09OU09MRT15CkNPTkZJR19WVF9DT05TT0xFX1NMRUVQPXkKQ09O
RklHX1ZUX0hXX0NPTlNPTEVfQklORElORz15CkNPTkZJR19VTklYOThfUFRZUz15CkNPTkZJ
R19MRUdBQ1lfUFRZUz15CkNPTkZJR19MRUdBQ1lfUFRZX0NPVU5UPTAKQ09ORklHX0xFR0FD
WV9USU9DU1RJPXkKQ09ORklHX0xESVNDX0FVVE9MT0FEPXkKCiMKIyBTZXJpYWwgZHJpdmVy
cwojCkNPTkZJR19TRVJJQUxfRUFSTFlDT049eQpDT05GSUdfU0VSSUFMXzgyNTA9eQpDT05G
SUdfU0VSSUFMXzgyNTBfUE5QPXkKQ09ORklHX1NFUklBTF84MjUwXzE2NTUwQV9WQVJJQU5U
Uz15CkNPTkZJR19TRVJJQUxfODI1MF9GSU5URUs9eQpDT05GSUdfU0VSSUFMXzgyNTBfQ09O
U09MRT15CkNPTkZJR19TRVJJQUxfODI1MF9ETUE9eQpDT05GSUdfU0VSSUFMXzgyNTBfUENJ
TElCPXkKQ09ORklHX1NFUklBTF84MjUwX1BDST15CiMgQ09ORklHX1NFUklBTF84MjUwX0VY
QVIgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfODI1MF9NRU5fTUNCIGlzIG5vdCBzZXQK
Q09ORklHX1NFUklBTF84MjUwX05SX1VBUlRTPTQ4CkNPTkZJR19TRVJJQUxfODI1MF9SVU5U
SU1FX1VBUlRTPTMyCkNPTkZJR19TRVJJQUxfODI1MF9FWFRFTkRFRD15CkNPTkZJR19TRVJJ
QUxfODI1MF9NQU5ZX1BPUlRTPXkKIyBDT05GSUdfU0VSSUFMXzgyNTBfUENJMVhYWFggaXMg
bm90IHNldApDT05GSUdfU0VSSUFMXzgyNTBfU0hBUkVfSVJRPXkKIyBDT05GSUdfU0VSSUFM
XzgyNTBfREVURUNUX0lSUSBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfODI1MF9SU0E9eQoj
IENPTkZJR19TRVJJQUxfODI1MF9EVyBpcyBub3Qgc2V0CkNPTkZJR19TRVJJQUxfODI1MF9S
VDI4OFg9eQojIENPTkZJR19TRVJJQUxfODI1MF9MUFNTIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VSSUFMXzgyNTBfTUlEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMXzgyNTBfUEVSSUNP
TSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF84MjUwX05JIGlzIG5vdCBzZXQKCiMKIyBO
b24tODI1MCBzZXJpYWwgcG9ydCBzdXBwb3J0CiMKIyBDT05GSUdfU0VSSUFMX01BWDMxMDAg
aXMgbm90IHNldApDT05GSUdfU0VSSUFMX01BWDMxMFg9eQojIENPTkZJR19TRVJJQUxfVUFS
VExJVEUgaXMgbm90IHNldApDT05GSUdfU0VSSUFMX0NPUkU9eQpDT05GSUdfU0VSSUFMX0NP
UkVfQ09OU09MRT15CkNPTkZJR19DT05TT0xFX1BPTEw9eQojIENPTkZJR19TRVJJQUxfSlNN
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0xBTlRJUSBpcyBub3Qgc2V0CkNPTkZJR19T
RVJJQUxfU0NDTlhQPXkKQ09ORklHX1NFUklBTF9TQ0NOWFBfQ09OU09MRT15CiMgQ09ORklH
X1NFUklBTF9TQzE2SVM3WFggaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfQUxURVJBX0pU
QUdVQVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VSSUFMX0FMVEVSQV9VQVJUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VSSUFMX0FSQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFUklBTF9SUDIg
aXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfRlNMX0xQVUFSVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFUklBTF9GU0xfTElORkxFWFVBUlQgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxf
TUVOX1oxMzUgaXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfU1BSRCBpcyBub3Qgc2V0CiMg
ZW5kIG9mIFNlcmlhbCBkcml2ZXJzCgpDT05GSUdfU0VSSUFMX01DVFJMX0dQSU89eQpDT05G
SUdfU0VSSUFMX05PTlNUQU5EQVJEPXkKIyBDT05GSUdfTU9YQV9JTlRFTExJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX01PWEFfU01BUlRJTyBpcyBub3Qgc2V0CiMgQ09ORklHX05fSERMQyBp
cyBub3Qgc2V0CiMgQ09ORklHX05fR1NNIGlzIG5vdCBzZXQKIyBDT05GSUdfTk9aT01JIGlz
IG5vdCBzZXQKIyBDT05GSUdfTlVMTF9UVFkgaXMgbm90IHNldApDT05GSUdfSFZDX0RSSVZF
Uj15CkNPTkZJR19IVkNfSVJRPXkKQ09ORklHX0hWQ19YRU49eQpDT05GSUdfSFZDX1hFTl9G
Uk9OVEVORD15CkNPTkZJR19TRVJJQUxfREVWX0JVUz15CkNPTkZJR19TRVJJQUxfREVWX0NU
UkxfVFRZUE9SVD15CkNPTkZJR19UVFlfUFJJTlRLPXkKQ09ORklHX1RUWV9QUklOVEtfTEVW
RUw9NgpDT05GSUdfVklSVElPX0NPTlNPTEU9eQpDT05GSUdfSVBNSV9IQU5ETEVSPW0KQ09O
RklHX0lQTUlfRE1JX0RFQ09ERT15CkNPTkZJR19JUE1JX1BMQVRfREFUQT15CiMgQ09ORklH
X0lQTUlfUEFOSUNfRVZFTlQgaXMgbm90IHNldApDT05GSUdfSVBNSV9ERVZJQ0VfSU5URVJG
QUNFPW0KQ09ORklHX0lQTUlfU0k9bQpDT05GSUdfSVBNSV9TU0lGPW0KQ09ORklHX0lQTUlf
V0FUQ0hET0c9bQojIENPTkZJR19JUE1JX1BPV0VST0ZGIGlzIG5vdCBzZXQKQ09ORklHX0hX
X1JBTkRPTT15CiMgQ09ORklHX0hXX1JBTkRPTV9USU1FUklPTUVNIGlzIG5vdCBzZXQKIyBD
T05GSUdfSFdfUkFORE9NX0lOVEVMIGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX0FN
RCBpcyBub3Qgc2V0CiMgQ09ORklHX0hXX1JBTkRPTV9CQTQzMSBpcyBub3Qgc2V0CiMgQ09O
RklHX0hXX1JBTkRPTV9WSUEgaXMgbm90IHNldAojIENPTkZJR19IV19SQU5ET01fVklSVElP
IGlzIG5vdCBzZXQKIyBDT05GSUdfSFdfUkFORE9NX1hJUEhFUkEgaXMgbm90IHNldAojIENP
TkZJR19BUFBMSUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX01XQVZFIGlzIG5vdCBzZXQKQ09O
RklHX0RFVk1FTT15CiMgQ09ORklHX05WUkFNIGlzIG5vdCBzZXQKQ09ORklHX0RFVlBPUlQ9
eQpDT05GSUdfSFBFVD15CkNPTkZJR19IUEVUX01NQVA9eQpDT05GSUdfSFBFVF9NTUFQX0RF
RkFVTFQ9eQojIENPTkZJR19IQU5HQ0hFQ0tfVElNRVIgaXMgbm90IHNldAojIENPTkZJR19V
Vl9NTVRJTUVSIGlzIG5vdCBzZXQKQ09ORklHX1RDR19UUE09eQpDT05GSUdfVENHX1RQTTJf
SE1BQz15CkNPTkZJR19IV19SQU5ET01fVFBNPXkKQ09ORklHX1RDR19USVNfQ09SRT15CkNP
TkZJR19UQ0dfVElTPXkKIyBDT05GSUdfVENHX1RJU19TUEkgaXMgbm90IHNldAojIENPTkZJ
R19UQ0dfVElTX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RDR19USVNfSTJDX0NSNTAgaXMg
bm90IHNldAojIENPTkZJR19UQ0dfVElTX0kyQ19BVE1FTCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RDR19USVNfSTJDX0lORklORU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfVENHX1RJU19JMkNf
TlVWT1RPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1RDR19OU0MgaXMgbm90IHNldAojIENPTkZJ
R19UQ0dfQVRNRUwgaXMgbm90IHNldAojIENPTkZJR19UQ0dfSU5GSU5FT04gaXMgbm90IHNl
dAojIENPTkZJR19UQ0dfWEVOIGlzIG5vdCBzZXQKQ09ORklHX1RDR19DUkI9eQojIENPTkZJ
R19UQ0dfVlRQTV9QUk9YWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RDR19TVlNNIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVENHX1RJU19TVDMzWlAyNF9JMkMgaXMgbm90IHNldAojIENPTkZJR19U
Q0dfVElTX1NUMzNaUDI0X1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFTENMT0NLIGlzIG5v
dCBzZXQKIyBDT05GSUdfWElMTFlCVVMgaXMgbm90IHNldAojIENPTkZJR19YSUxMWVVTQiBp
cyBub3Qgc2V0CiMgZW5kIG9mIENoYXJhY3RlciBkZXZpY2VzCgojCiMgSTJDIHN1cHBvcnQK
IwpDT05GSUdfSTJDPXkKQ09ORklHX0FDUElfSTJDX09QUkVHSU9OPXkKQ09ORklHX0kyQ19C
T0FSRElORk89eQpDT05GSUdfSTJDX0NIQVJERVY9eQojIENPTkZJR19JMkNfTVVYIGlzIG5v
dCBzZXQKQ09ORklHX0kyQ19IRUxQRVJfQVVUTz15CkNPTkZJR19JMkNfU01CVVM9bQpDT05G
SUdfSTJDX0FMR09CSVQ9bQoKIwojIEkyQyBIYXJkd2FyZSBCdXMgc3VwcG9ydAojCgojCiMg
UEMgU01CdXMgaG9zdCBjb250cm9sbGVyIGRyaXZlcnMKIwojIENPTkZJR19JMkNfQUxJMTUz
NSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTEkxNTYzIGlzIG5vdCBzZXQKIyBDT05GSUdf
STJDX0FMSTE1WDMgaXMgbm90IHNldAojIENPTkZJR19JMkNfQU1ENzU2IGlzIG5vdCBzZXQK
IyBDT05GSUdfSTJDX0FNRDgxMTEgaXMgbm90IHNldAojIENPTkZJR19JMkNfQU1EX01QMiBp
cyBub3Qgc2V0CiMgQ09ORklHX0kyQ19BTURfQVNGIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJD
X0k4MDEgaXMgbm90IHNldAojIENPTkZJR19JMkNfSVNDSCBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19JU01UIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19QSUlYND1tCiMgQ09ORklHX0kyQ19D
SFRfV0MgaXMgbm90IHNldAojIENPTkZJR19JMkNfTkZPUkNFMiBpcyBub3Qgc2V0CiMgQ09O
RklHX0kyQ19OVklESUFfR1BVIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJUzU1OTUgaXMg
bm90IHNldAojIENPTkZJR19JMkNfU0lTNjMwIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1NJ
Uzk2WCBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19WSUEgaXMgbm90IHNldAojIENPTkZJR19J
MkNfVklBUFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX1pIQU9YSU4gaXMgbm90IHNldAoK
IwojIEFDUEkgZHJpdmVycwojCiMgQ09ORklHX0kyQ19TQ01JIGlzIG5vdCBzZXQKCiMKIyBJ
MkMgc3lzdGVtIGJ1cyBkcml2ZXJzIChtb3N0bHkgZW1iZWRkZWQgLyBzeXN0ZW0tb24tY2hp
cCkKIwojIENPTkZJR19JMkNfQ0JVU19HUElPIGlzIG5vdCBzZXQKQ09ORklHX0kyQ19ERVNJ
R05XQVJFX0NPUkU9eQojIENPTkZJR19JMkNfREVTSUdOV0FSRV9TTEFWRSBpcyBub3Qgc2V0
CkNPTkZJR19JMkNfREVTSUdOV0FSRV9QTEFURk9STT15CkNPTkZJR19JMkNfREVTSUdOV0FS
RV9CQVlUUkFJTD15CiMgQ09ORklHX0kyQ19ERVNJR05XQVJFX1BDSSBpcyBub3Qgc2V0CiMg
Q09ORklHX0kyQ19FTUVWMiBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19HUElPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSTJDX09DT1JFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19QQ0FfUExB
VEZPUk0gaXMgbm90IHNldAojIENPTkZJR19JMkNfU0lNVEVDIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX1hJTElOWCBpcyBub3Qgc2V0CgojCiMgRXh0ZXJuYWwgSTJDL1NNQnVzIGFkYXB0
ZXIgZHJpdmVycwojCiMgQ09ORklHX0kyQ19ESU9MQU5fVTJDIGlzIG5vdCBzZXQKIyBDT05G
SUdfSTJDX0NQMjYxNSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19QQ0kxWFhYWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0kyQ19ST0JPVEZVWlpfT1NJRiBpcyBub3Qgc2V0CiMgQ09ORklHX0ky
Q19UQU9TX0VWTSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19USU5ZX1VTQiBpcyBub3Qgc2V0
CgojCiMgT3RoZXIgSTJDL1NNQnVzIGJ1cyBkcml2ZXJzCiMKIyBDT05GSUdfSTJDX01MWENQ
TEQgaXMgbm90IHNldAojIENPTkZJR19JMkNfVklSVElPIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
STJDIEhhcmR3YXJlIEJ1cyBzdXBwb3J0CgojIENPTkZJR19JMkNfU1RVQiBpcyBub3Qgc2V0
CiMgQ09ORklHX0kyQ19TTEFWRSBpcyBub3Qgc2V0CiMgQ09ORklHX0kyQ19ERUJVR19DT1JF
IGlzIG5vdCBzZXQKIyBDT05GSUdfSTJDX0RFQlVHX0FMR08gaXMgbm90IHNldAojIENPTkZJ
R19JMkNfREVCVUdfQlVTIGlzIG5vdCBzZXQKIyBlbmQgb2YgSTJDIHN1cHBvcnQKCiMgQ09O
RklHX0kzQyBpcyBub3Qgc2V0CkNPTkZJR19TUEk9eQojIENPTkZJR19TUElfREVCVUcgaXMg
bm90IHNldApDT05GSUdfU1BJX01BU1RFUj15CkNPTkZJR19TUElfTUVNPXkKCiMKIyBTUEkg
TWFzdGVyIENvbnRyb2xsZXIgRHJpdmVycwojCiMgQ09ORklHX1NQSV9BTFRFUkEgaXMgbm90
IHNldAojIENPTkZJR19TUElfQVhJX1NQSV9FTkdJTkUgaXMgbm90IHNldAojIENPTkZJR19T
UElfQklUQkFORyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9DQURFTkNFIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1BJX0NIMzQxIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX0RFU0lHTldBUkUg
aXMgbm90IHNldAojIENPTkZJR19TUElfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9J
TlRFTF9QQ0kgaXMgbm90IHNldAojIENPTkZJR19TUElfSU5URUxfUExBVEZPUk0gaXMgbm90
IHNldAojIENPTkZJR19TUElfTUlDUk9DSElQX0NPUkVfUVNQSSBpcyBub3Qgc2V0CiMgQ09O
RklHX1NQSV9NSUNST0NISVBfQ09SRV9TUEkgaXMgbm90IHNldAojIENPTkZJR19TUElfTEFO
VElRX1NTQyBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9PQ19USU5ZIGlzIG5vdCBzZXQKIyBD
T05GSUdfU1BJX1BDSTFYWFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1BYQTJYWCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NQSV9TQzE4SVM2MDIgaXMgbm90IHNldAojIENPTkZJR19TUElf
U0lGSVZFIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX01YSUMgaXMgbm90IHNldAojIENPTkZJ
R19TUElfVklSVElPIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1hDT01NIGlzIG5vdCBzZXQK
IyBDT05GSUdfU1BJX1hJTElOWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NQSV9aWU5RTVBfR1FT
UEkgaXMgbm90IHNldAojIENPTkZJR19TUElfQU1EIGlzIG5vdCBzZXQKCiMKIyBTUEkgTXVs
dGlwbGV4ZXIgc3VwcG9ydAojCiMgQ09ORklHX1NQSV9NVVggaXMgbm90IHNldAoKIwojIFNQ
SSBQcm90b2NvbCBNYXN0ZXJzCiMKIyBDT05GSUdfU1BJX1NQSURFViBpcyBub3Qgc2V0CiMg
Q09ORklHX1NQSV9MT09QQkFDS19URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU1BJX1RMRTYy
WDAgaXMgbm90IHNldApDT05GSUdfU1BJX1NMQVZFPXkKIyBDT05GSUdfU1BJX1NMQVZFX1RJ
TUUgaXMgbm90IHNldAojIENPTkZJR19TUElfU0xBVkVfU1lTVEVNX0NPTlRST0wgaXMgbm90
IHNldApDT05GSUdfU1BJX0RZTkFNSUM9eQojIENPTkZJR19TUE1JIGlzIG5vdCBzZXQKIyBD
T05GSUdfSFNJIGlzIG5vdCBzZXQKQ09ORklHX1BQUz15CiMgQ09ORklHX1BQU19ERUJVRyBp
cyBub3Qgc2V0CgojCiMgUFBTIGNsaWVudHMgc3VwcG9ydAojCiMgQ09ORklHX1BQU19DTElF
TlRfS1RJTUVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUFBTX0NMSUVOVF9MRElTQyBpcyBub3Qg
c2V0CiMgQ09ORklHX1BQU19DTElFTlRfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX1BQU19H
RU5FUkFUT1IgaXMgbm90IHNldAoKIwojIFBUUCBjbG9jayBzdXBwb3J0CiMKQ09ORklHX1BU
UF8xNTg4X0NMT0NLPXkKQ09ORklHX1BUUF8xNTg4X0NMT0NLX09QVElPTkFMPXkKIyBDT05G
SUdfRFA4MzY0MF9QSFkgaXMgbm90IHNldAojIENPTkZJR19QVFBfMTU4OF9DTE9DS19JTkVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfUFRQXzE1ODhfQ0xPQ0tfS1ZNIGlzIG5vdCBzZXQKIyBD
T05GSUdfUFRQXzE1ODhfQ0xPQ0tfVk1DTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX1BUUF8x
NTg4X0NMT0NLX0lEVDgyUDMzIGlzIG5vdCBzZXQKIyBDT05GSUdfUFRQXzE1ODhfQ0xPQ0tf
SURUQ00gaXMgbm90IHNldAojIENPTkZJR19QVFBfMTU4OF9DTE9DS19GQzNXIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUFRQXzE1ODhfQ0xPQ0tfTU9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX1BU
UF8xNTg4X0NMT0NLX1ZNVyBpcyBub3Qgc2V0CiMgQ09ORklHX1BUUF9ORVRDX1Y0X1RJTUVS
IGlzIG5vdCBzZXQKIyBlbmQgb2YgUFRQIGNsb2NrIHN1cHBvcnQKCiMKIyBEUExMIGRldmlj
ZSBzdXBwb3J0CiMKIyBDT05GSUdfWkwzMDczWF9JMkMgaXMgbm90IHNldAojIENPTkZJR19a
TDMwNzNYX1NQSSBpcyBub3Qgc2V0CiMgZW5kIG9mIERQTEwgZGV2aWNlIHN1cHBvcnQKCkNP
TkZJR19QSU5DVFJMPXkKQ09ORklHX1BJTk1VWD15CkNPTkZJR19QSU5DT05GPXkKQ09ORklH
X0dFTkVSSUNfUElOQ09ORj15CiMgQ09ORklHX0RFQlVHX1BJTkNUUkwgaXMgbm90IHNldApD
T05GSUdfUElOQ1RSTF9BTUQ9eQojIENPTkZJR19QSU5DVFJMX0NZOEM5NVgwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUElOQ1RSTF9EQTkwNjIgaXMgbm90IHNldAojIENPTkZJR19QSU5DVFJM
X01DUDIzUzA4IGlzIG5vdCBzZXQKQ09ORklHX1BJTkNUUkxfU1gxNTBYPXkKCiMKIyBJbnRl
bCBwaW5jdHJsIGRyaXZlcnMKIwpDT05GSUdfUElOQ1RSTF9CQVlUUkFJTD15CkNPTkZJR19Q
SU5DVFJMX0NIRVJSWVZJRVc9eQojIENPTkZJR19QSU5DVFJMX0xZTlhQT0lOVCBpcyBub3Qg
c2V0CkNPTkZJR19QSU5DVFJMX0lOVEVMPXkKIyBDT05GSUdfUElOQ1RSTF9JTlRFTF9QTEFU
Rk9STSBpcyBub3Qgc2V0CiMgQ09ORklHX1BJTkNUUkxfQUxERVJMQUtFIGlzIG5vdCBzZXQK
IyBDT05GSUdfUElOQ1RSTF9CUk9YVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9D
QU5OT05MQUtFIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9DRURBUkZPUksgaXMgbm90
IHNldAojIENPTkZJR19QSU5DVFJMX0RFTlZFUlRPTiBpcyBub3Qgc2V0CiMgQ09ORklHX1BJ
TkNUUkxfRUxLSEFSVExBS0UgaXMgbm90IHNldAojIENPTkZJR19QSU5DVFJMX0VNTUlUU0JV
UkcgaXMgbm90IHNldAojIENPTkZJR19QSU5DVFJMX0dFTUlOSUxBS0UgaXMgbm90IHNldAoj
IENPTkZJR19QSU5DVFJMX0lDRUxBS0UgaXMgbm90IHNldAojIENPTkZJR19QSU5DVFJMX0pB
U1BFUkxBS0UgaXMgbm90IHNldAojIENPTkZJR19QSU5DVFJMX0xBS0VGSUVMRCBpcyBub3Qg
c2V0CiMgQ09ORklHX1BJTkNUUkxfTEVXSVNCVVJHIGlzIG5vdCBzZXQKIyBDT05GSUdfUElO
Q1RSTF9NRVRFT1JMQUtFIGlzIG5vdCBzZXQKIyBDT05GSUdfUElOQ1RSTF9NRVRFT1JQT0lO
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1BJTkNUUkxfU1VOUklTRVBPSU5UIGlzIG5vdCBzZXQK
IyBDT05GSUdfUElOQ1RSTF9USUdFUkxBS0UgaXMgbm90IHNldAojIGVuZCBvZiBJbnRlbCBw
aW5jdHJsIGRyaXZlcnMKCiMKIyBSZW5lc2FzIHBpbmN0cmwgZHJpdmVycwojCiMgZW5kIG9m
IFJlbmVzYXMgcGluY3RybCBkcml2ZXJzCgpDT05GSUdfR1BJT0xJQl9MRUdBQ1k9eQpDT05G
SUdfR1BJT0xJQj15CkNPTkZJR19HUElPTElCX0ZBU1RQQVRIX0xJTUlUPTUxMgpDT05GSUdf
R1BJT19BQ1BJPXkKQ09ORklHX0dQSU9MSUJfSVJRQ0hJUD15CiMgQ09ORklHX0RFQlVHX0dQ
SU8gaXMgbm90IHNldApDT05GSUdfR1BJT19TWVNGUz15CkNPTkZJR19HUElPX1NZU0ZTX0xF
R0FDWT15CkNPTkZJR19HUElPX0NERVY9eQojIENPTkZJR19HUElPX0NERVZfVjEgaXMgbm90
IHNldApDT05GSUdfR1BJT19HRU5FUklDPXkKCiMKIyBNZW1vcnkgbWFwcGVkIEdQSU8gZHJp
dmVycwojCiMgQ09ORklHX0dQSU9fQUxURVJBIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19B
TURQVCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fRFdBUEIgaXMgbm90IHNldApDT05GSUdf
R1BJT19HRU5FUklDX1BMQVRGT1JNPXkKIyBDT05GSUdfR1BJT19HUkFOSVRFUkFQSURTIGlz
IG5vdCBzZXQKIyBDT05GSUdfR1BJT19NQjg2UzdYIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJ
T19NRU5aMTI3IGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19QT0xBUkZJUkVfU09DIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19YSUxJTlggaXMgbm90IHNldAojIENPTkZJR19HUElPX0FN
RF9GQ0ggaXMgbm90IHNldAojIGVuZCBvZiBNZW1vcnkgbWFwcGVkIEdQSU8gZHJpdmVycwoK
IwojIFBvcnQtbWFwcGVkIEkvTyBHUElPIGRyaXZlcnMKIwojIENPTkZJR19HUElPX1ZYODU1
IGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT18xMDRfRElPXzQ4RSBpcyBub3Qgc2V0CiMgQ09O
RklHX0dQSU9fMTA0X0lESU9fMTYgaXMgbm90IHNldAojIENPTkZJR19HUElPXzEwNF9JRElf
NDggaXMgbm90IHNldAojIENPTkZJR19HUElPX0Y3MTg4WCBpcyBub3Qgc2V0CiMgQ09ORklH
X0dQSU9fR1BJT19NTSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fSVQ4NyBpcyBub3Qgc2V0
CiMgQ09ORklHX0dQSU9fU0NIMzExWCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fV0lOQk9O
RCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fV1MxNkM0OCBpcyBub3Qgc2V0CiMgZW5kIG9m
IFBvcnQtbWFwcGVkIEkvTyBHUElPIGRyaXZlcnMKCiMKIyBJMkMgR1BJTyBleHBhbmRlcnMK
IwojIENPTkZJR19HUElPX0ZYTDY0MDggaXMgbm90IHNldAojIENPTkZJR19HUElPX0RTNDUy
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUFYNzMwMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0dQSU9fTUFYNzMyWCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENBOTUzWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0dQSU9fUENBOTU3MCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENG
ODU3WCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fVFBJQzI4MTAgaXMgbm90IHNldAojIGVu
ZCBvZiBJMkMgR1BJTyBleHBhbmRlcnMKCiMKIyBNRkQgR1BJTyBleHBhbmRlcnMKIwojIENP
TkZJR19HUElPX0FEUDU1MjAgaXMgbm90IHNldApDT05GSUdfR1BJT19DUllTVEFMX0NPVkU9
eQojIENPTkZJR19HUElPX0RBOTA1MiBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fREE5MDU1
IGlzIG5vdCBzZXQKQ09ORklHX0dQSU9fUEFMTUFTPXkKQ09ORklHX0dQSU9fUkM1VDU4Mz15
CkNPTkZJR19HUElPX1RQUzY1ODZYPXkKQ09ORklHX0dQSU9fVFBTNjU5MTA9eQojIENPTkZJ
R19HUElPX1RQUzY1OTEyIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19UV0w0MDMwIGlzIG5v
dCBzZXQKIyBDT05GSUdfR1BJT19UV0w2MDQwIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19X
TTgzMVggaXMgbm90IHNldAojIENPTkZJR19HUElPX1dNODM1MCBpcyBub3Qgc2V0CiMgZW5k
IG9mIE1GRCBHUElPIGV4cGFuZGVycwoKIwojIFBDSSBHUElPIGV4cGFuZGVycwojCiMgQ09O
RklHX0dQSU9fQU1EODExMSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fQlQ4WFggaXMgbm90
IHNldAojIENPTkZJR19HUElPX01MX0lPSCBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fUENJ
X0lESU9fMTYgaXMgbm90IHNldAojIENPTkZJR19HUElPX1BDSUVfSURJT18yNCBpcyBub3Qg
c2V0CiMgQ09ORklHX0dQSU9fUkRDMzIxWCBpcyBub3Qgc2V0CiMgZW5kIG9mIFBDSSBHUElP
IGV4cGFuZGVycwoKIwojIFNQSSBHUElPIGV4cGFuZGVycwojCiMgQ09ORklHX0dQSU9fNzRY
MTY0IGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19NQVgzMTkxWCBpcyBub3Qgc2V0CiMgQ09O
RklHX0dQSU9fTUFYNzMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTUMzMzg4MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0dQSU9fUElTT1NSIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19Y
UkExNDAzIGlzIG5vdCBzZXQKIyBlbmQgb2YgU1BJIEdQSU8gZXhwYW5kZXJzCgojCiMgVVNC
IEdQSU8gZXhwYW5kZXJzCiMKIyBDT05GSUdfR1BJT19NUFNTRSBpcyBub3Qgc2V0CiMgZW5k
IG9mIFVTQiBHUElPIGV4cGFuZGVycwoKIwojIFZpcnR1YWwgR1BJTyBkcml2ZXJzCiMKIyBD
T05GSUdfR1BJT19BR0dSRUdBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJT19MQVRDSCBp
cyBub3Qgc2V0CiMgQ09ORklHX0dQSU9fTU9DS1VQIGlzIG5vdCBzZXQKIyBDT05GSUdfR1BJ
T19WSVJUSU8gaXMgbm90IHNldAojIENPTkZJR19HUElPX1NJTSBpcyBub3Qgc2V0CiMgZW5k
IG9mIFZpcnR1YWwgR1BJTyBkcml2ZXJzCgojCiMgR1BJTyBEZWJ1Z2dpbmcgdXRpbGl0aWVz
CiMKIyBDT05GSUdfR1BJT19TTE9QUFlfTE9HSUNfQU5BTFlaRVIgaXMgbm90IHNldAojIENP
TkZJR19HUElPX1ZJUlRVU0VSIGlzIG5vdCBzZXQKIyBlbmQgb2YgR1BJTyBEZWJ1Z2dpbmcg
dXRpbGl0aWVzCgojIENPTkZJR19XMSBpcyBub3Qgc2V0CkNPTkZJR19QT1dFUl9SRVNFVD15
CkNPTkZJR19QT1dFUl9SRVNFVF9SRVNUQVJUPXkKIyBDT05GSUdfUE9XRVJfU0VRVUVOQ0lO
RyBpcyBub3Qgc2V0CkNPTkZJR19QT1dFUl9TVVBQTFk9eQojIENPTkZJR19QT1dFUl9TVVBQ
TFlfREVCVUcgaXMgbm90IHNldApDT05GSUdfUE9XRVJfU1VQUExZX0hXTU9OPXkKIyBDT05G
SUdfSVA1WFhYX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfTUFYODkyNV9QT1dFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX1dNODMxWF9CQUNLVVAgaXMgbm90IHNldAojIENPTkZJR19XTTgz
MVhfUE9XRVIgaXMgbm90IHNldAojIENPTkZJR19XTTgzNTBfUE9XRVIgaXMgbm90IHNldAoj
IENPTkZJR19URVNUX1BPV0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV84OFBNODYw
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfQURQNTA2MSBpcyBub3Qgc2V0CiMgQ09O
RklHX0JBVFRFUllfQ0hBR0FMTCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfQ1cyMDE1
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9EUzI3ODAgaXMgbm90IHNldAojIENPTkZJ
R19CQVRURVJZX0RTMjc4MSBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfRFMyNzgyIGlz
IG5vdCBzZXQKIyBDT05GSUdfQkFUVEVSWV9TQU1TVU5HX1NESSBpcyBub3Qgc2V0CiMgQ09O
RklHX0JBVFRFUllfU0JTIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkdFUl9TQlMgaXMgbm90
IHNldAojIENPTkZJR19CQVRURVJZX0JRMjdYWFggaXMgbm90IHNldAojIENPTkZJR19CQVRU
RVJZX0RBOTAzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRFUllfREE5MDUyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfQkFUVEVSWV9NQVgxNzA0MiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBVFRF
UllfTUFYMTcyMFggaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX01BWDg5MDMgaXMgbm90
IHNldAojIENPTkZJR19DSEFSR0VSX0xQODcyNyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJH
RVJfR1BJTyBpcyBub3Qgc2V0CkNPTkZJR19DSEFSR0VSX01BTkFHRVI9eQojIENPTkZJR19D
SEFSR0VSX0xUMzY1MSBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfTFRDNDE2MkwgaXMg
bm90IHNldAojIENPTkZJR19DSEFSR0VSX01BWDE0NTc3IGlzIG5vdCBzZXQKIyBDT05GSUdf
Q0hBUkdFUl9NQVg3NzY5MyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfTUFYNzc5NzYg
aXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX01BWDg5NzEgaXMgbm90IHNldAojIENPTkZJ
R19DSEFSR0VSX0JRMjQxNVggaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0JRMjQxOTAg
aXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0JRMjQyNTcgaXMgbm90IHNldAojIENPTkZJ
R19DSEFSR0VSX0JRMjQ3MzUgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0JRMjUxNVgg
aXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0JRMjU4OTAgaXMgbm90IHNldAojIENPTkZJ
R19DSEFSR0VSX0JRMjU5ODAgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX0JRMjU2WFgg
aXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX1NNQjM0NyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NIQVJHRVJfVFBTNjUwOTAgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0dBVUdFX0xU
QzI5NDEgaXMgbm90IHNldAojIENPTkZJR19CQVRURVJZX0dPTERGSVNIIGlzIG5vdCBzZXQK
IyBDT05GSUdfQkFUVEVSWV9SVDUwMzMgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX1JU
OTQ1NSBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfUlQ5NDY3IGlzIG5vdCBzZXQKIyBD
T05GSUdfQ0hBUkdFUl9SVDk0NzEgaXMgbm90IHNldAojIENPTkZJR19DSEFSR0VSX1JUOTc1
NiBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJHRVJfQkQ5OTk1NCBpcyBub3Qgc2V0CiMgQ09O
RklHX0JBVFRFUllfVUczMTA1IGlzIG5vdCBzZXQKIyBDT05GSUdfRlVFTF9HQVVHRV9NTTgw
MTMgaXMgbm90IHNldApDT05GSUdfSFdNT049eQojIENPTkZJR19IV01PTl9ERUJVR19DSElQ
IGlzIG5vdCBzZXQKCiMKIyBOYXRpdmUgZHJpdmVycwojCiMgQ09ORklHX1NFTlNPUlNfQUJJ
VFVHVVJVIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BQklUVUdVUlUzIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19BRDczMTQgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X0FENzQxNCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQUQ3NDE4IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRE0xMDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
RE0xMDI2IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE0xMDI5IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRE0xMDMxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
RE0xMTc3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRE05MjQwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRFQ3MzEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
RFQ3NDEwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDExIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BRFQ3NDYyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19B
RFQ3NDcwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BRFQ3NDc1IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BSFQxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVFV
QUNPTVBVVEVSX0Q1TkVYVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVMzNzAgaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0FTQzc2MjEgaXMgbm90IHNldAojIENPTkZJR19T
RU5TT1JTX0FTVVNfUk9HX1JZVUpJTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQVhJ
X0ZBTl9DT05UUk9MIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19LOFRFTVAgaXMgbm90
IHNldApDT05GSUdfU0VOU09SU19LMTBURU1QPW0KIyBDT05GSUdfU0VOU09SU19GQU0xNUhf
UE9XRVIgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FQUExFU01DIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19BU0IxMDAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FU
WFAxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19DSElQQ0FQMiBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfQ09SU0FJUl9DUFJPIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19DT1JTQUlSX1BTVSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRFJJVkVURU1QIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19EUzYyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfRFMxNjIxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19ERUxMX1NNTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfREE5MDUyX0FEQyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfREE5MDU1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JNUtfQU1CIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19GNzE4MDVGIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19GNzE4ODJGRyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRjc1Mzc1UyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfRlNDSE1EIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19GVFNURVVUQVRFUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0lHQUJZ
VEVfV0FURVJGT1JDRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0w1MThTTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfR0w1MjBTTSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfR1BEIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19HNzYwQSBpcyBub3Qgc2V0
CiMgQ09ORklHX1NFTlNPUlNfRzc2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSElI
NjEzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSFMzMDAxIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19IVFUzMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSUJNQUVN
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JQk1QRVggaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0k1NTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19DT1JFVEVNUCBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSVNMMjgwMjIgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX0lUODcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0pDNDIgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1BPV0VSWiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfUE9XUjEyMjAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xFTk9WT19FQyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTElORUFHRSBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfTFRDMjk0NSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTFRDMjk0N19JMkMg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0xUQzI5NDdfU1BJIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEMyOTkwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEMy
OTkxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEMyOTkyIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEM0MTUxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0
MjE1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjIyIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEM0MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0
MjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MVEM0MjYxIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MVEM0MjgyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgx
MTExIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgxMjcgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX01BWDE2MDY1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgx
NjE5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgxNjY4IGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19NQVgxOTcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01BWDMx
NzIyIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NQVgzMTczMCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfTUFYMzE3NjAgaXMgbm90IHNldAojIENPTkZJR19NQVgzMTgyNyBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjYyMCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTUFYNjYyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjYzOSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYNjY1MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfTUFYNjY5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUFYMzE3OTAg
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01DMzRWUjUwMCBpcyBub3Qgc2V0CiMgQ09O
RklHX1NFTlNPUlNfTUNQMzAyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTUxYUkVH
X0ZBTiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVEM2NTQgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1RQUzIzODYxIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19NRU5G
MjFCTUNfSFdNT04gaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX01SNzUyMDMgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX0FEQ1hYIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19MTTYzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTcwIGlzIG5vdCBzZXQKIyBD
T05GSUdfU0VOU09SU19MTTczIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTc1IGlz
IG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTc3IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VO
U09SU19MTTc4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTgwIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MTTgzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTg1
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTg3IGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19MTTkwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTkyIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19MTTkzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19M
TTk1MjM0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19MTTk1MjQxIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19MTTk1MjQ1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19Q
Qzg3MzYwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19QQzg3NDI3IGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19OQ1Q2NjgzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19O
Q1Q2Nzc1IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19OQ1Q2Nzc1X0kyQyBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTkNUNzM2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTkNUNzgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfTkNUNzkwNCBpcyBub3Qg
c2V0CiMgQ09ORklHX1NFTlNPUlNfTlBDTTdYWCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfTlpYVF9LUkFLRU4yIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19OWlhUX0tSQUtF
TjMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX05aWFRfU01BUlQyIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19PQ0NfUDhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19QQ0Y4NTkxIGlzIG5vdCBzZXQKIyBDT05GSUdfUE1CVVMgaXMgbm90IHNldAojIENPTkZJ
R19TRU5TT1JTX1BUNTE2MUwgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1BXTV9GQU4g
aXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1NCVFNJIGlzIG5vdCBzZXQKIyBDT05GSUdf
U0VOU09SU19TSFQxNSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUMjEgaXMgbm90
IHNldAojIENPTkZJR19TRU5TT1JTX1NIVDN4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09S
U19TSFQ0eCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0hUQzEgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1NJUzU1OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0RN
RTE3MzcgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzE0MDMgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX0VNQzIxMDMgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VN
QzIzMDUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0VNQzZXMjAxIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19TTVNDNDdNMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
U01TQzQ3TTE5MiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU01TQzQ3QjM5NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU0NINTYyNyBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfU0NINTYzNiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU1RUUzc1MSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURDMTI4RDgxOCBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfQURTNzgyOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQURTNzg3MSBp
cyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfQU1DNjgyMSBpcyBub3Qgc2V0CiMgQ09ORklH
X1NFTlNPUlNfSU5BMjA5IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19JTkEyWFggaXMg
bm90IHNldAojIENPTkZJR19TRU5TT1JTX0lOQTIzOCBpcyBub3Qgc2V0CiMgQ09ORklHX1NF
TlNPUlNfSU5BMzIyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfU1BENTExOCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVEM3NCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNP
UlNfVEhNQzUwIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVAxMDIgaXMgbm90IHNl
dAojIENPTkZJR19TRU5TT1JTX1RNUDEwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNf
VE1QMTA4IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA0MDEgaXMgbm90IHNldAoj
IENPTkZJR19TRU5TT1JTX1RNUDQyMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVE1Q
NDY0IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19UTVA1MTMgaXMgbm90IHNldAojIENP
TkZJR19TRU5TT1JTX1RTQzE2NDEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZJQV9D
UFVURU1QIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19WSUE2ODZBIGlzIG5vdCBzZXQK
IyBDT05GSUdfU0VOU09SU19WVDEyMTEgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1ZU
ODIzMSBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzczRyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVzgzNzgxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgz
NzkxRCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNzkyRCBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVzgzNzkzIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19XODM3
OTUgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX1c4M0w3ODVUUyBpcyBub3Qgc2V0CiMg
Q09ORklHX1NFTlNPUlNfVzgzTDc4Nk5HIGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19X
ODM2MjdIRiBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfVzgzNjI3RUhGIGlzIG5vdCBz
ZXQKIyBDT05GSUdfU0VOU09SU19XTTgzMVggaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JT
X1dNODM1MCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfWEdFTkUgaXMgbm90IHNldAoK
IwojIEFDUEkgZHJpdmVycwojCkNPTkZJR19TRU5TT1JTX0FDUElfUE9XRVI9bQojIENPTkZJ
R19TRU5TT1JTX0FUSzAxMTAgaXMgbm90IHNldAojIENPTkZJR19TRU5TT1JTX0FTVVNfV01J
IGlzIG5vdCBzZXQKIyBDT05GSUdfU0VOU09SU19BU1VTX0VDIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0VOU09SU19IUF9XTUkgaXMgbm90IHNldApDT05GSUdfVEhFUk1BTD15CkNPTkZJR19U
SEVSTUFMX05FVExJTks9eQpDT05GSUdfVEhFUk1BTF9TVEFUSVNUSUNTPXkKIyBDT05GSUdf
VEhFUk1BTF9ERUJVR0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhFUk1BTF9DT1JFX1RFU1RJ
TkcgaXMgbm90IHNldApDT05GSUdfVEhFUk1BTF9FTUVSR0VOQ1lfUE9XRVJPRkZfREVMQVlf
TVM9MApDT05GSUdfVEhFUk1BTF9IV01PTj15CkNPTkZJR19USEVSTUFMX0RFRkFVTFRfR09W
X1NURVBfV0lTRT15CiMgQ09ORklHX1RIRVJNQUxfREVGQVVMVF9HT1ZfRkFJUl9TSEFSRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1RIRVJNQUxfREVGQVVMVF9HT1ZfVVNFUl9TUEFDRSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RIRVJNQUxfREVGQVVMVF9HT1ZfUE9XRVJfQUxMT0NBVE9SIGlz
IG5vdCBzZXQKIyBDT05GSUdfVEhFUk1BTF9ERUZBVUxUX0dPVl9CQU5HX0JBTkcgaXMgbm90
IHNldApDT05GSUdfVEhFUk1BTF9HT1ZfRkFJUl9TSEFSRT15CkNPTkZJR19USEVSTUFMX0dP
Vl9TVEVQX1dJU0U9eQpDT05GSUdfVEhFUk1BTF9HT1ZfQkFOR19CQU5HPXkKQ09ORklHX1RI
RVJNQUxfR09WX1VTRVJfU1BBQ0U9eQpDT05GSUdfVEhFUk1BTF9HT1ZfUE9XRVJfQUxMT0NB
VE9SPXkKQ09ORklHX0RFVkZSRVFfVEhFUk1BTD15CiMgQ09ORklHX1BDSUVfVEhFUk1BTCBp
cyBub3Qgc2V0CkNPTkZJR19USEVSTUFMX0VNVUxBVElPTj15CgojCiMgSW50ZWwgdGhlcm1h
bCBkcml2ZXJzCiMKIyBDT05GSUdfSU5URUxfUE9XRVJDTEFNUCBpcyBub3Qgc2V0CkNPTkZJ
R19YODZfVEhFUk1BTF9WRUNUT1I9eQojIENPTkZJR19YODZfUEtHX1RFTVBfVEhFUk1BTCBp
cyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX1NPQ19EVFNfVEhFUk1BTCBpcyBub3Qgc2V0Cgoj
CiMgQUNQSSBJTlQzNDBYIHRoZXJtYWwgZHJpdmVycwojCiMgQ09ORklHX0lOVDM0MFhfVEhF
Uk1BTCBpcyBub3Qgc2V0CiMgZW5kIG9mIEFDUEkgSU5UMzQwWCB0aGVybWFsIGRyaXZlcnMK
CiMgQ09ORklHX0lOVEVMX1BDSF9USEVSTUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxf
VENDX0NPT0xJTkcgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9IRklfVEhFUk1BTCBpcyBu
b3Qgc2V0CiMgZW5kIG9mIEludGVsIHRoZXJtYWwgZHJpdmVycwoKQ09ORklHX1dBVENIRE9H
PXkKQ09ORklHX1dBVENIRE9HX0NPUkU9eQojIENPTkZJR19XQVRDSERPR19OT1dBWU9VVCBp
cyBub3Qgc2V0CkNPTkZJR19XQVRDSERPR19IQU5ETEVfQk9PVF9FTkFCTEVEPXkKQ09ORklH
X1dBVENIRE9HX09QRU5fVElNRU9VVD0wCkNPTkZJR19XQVRDSERPR19TWVNGUz15CiMgQ09O
RklHX1dBVENIRE9HX0hSVElNRVJfUFJFVElNRU9VVCBpcyBub3Qgc2V0CgojCiMgV2F0Y2hk
b2cgUHJldGltZW91dCBHb3Zlcm5vcnMKIwpDT05GSUdfV0FUQ0hET0dfUFJFVElNRU9VVF9H
T1Y9eQpDT05GSUdfV0FUQ0hET0dfUFJFVElNRU9VVF9HT1ZfU0VMPW0KQ09ORklHX1dBVENI
RE9HX1BSRVRJTUVPVVRfR09WX05PT1A9eQpDT05GSUdfV0FUQ0hET0dfUFJFVElNRU9VVF9H
T1ZfUEFOSUM9eQpDT05GSUdfV0FUQ0hET0dfUFJFVElNRU9VVF9ERUZBVUxUX0dPVl9OT09Q
PXkKIyBDT05GSUdfV0FUQ0hET0dfUFJFVElNRU9VVF9ERUZBVUxUX0dPVl9QQU5JQyBpcyBu
b3Qgc2V0CgojCiMgV2F0Y2hkb2cgRGV2aWNlIERyaXZlcnMKIwpDT05GSUdfU09GVF9XQVRD
SERPRz15CkNPTkZJR19TT0ZUX1dBVENIRE9HX1BSRVRJTUVPVVQ9eQpDT05GSUdfREE5MDUy
X1dBVENIRE9HPXkKQ09ORklHX0RBOTA1NV9XQVRDSERPRz15CkNPTkZJR19EQTkwNjNfV0FU
Q0hET0c9eQpDT05GSUdfREE5MDYyX1dBVENIRE9HPXkKIyBDT05GSUdfTEVOT1ZPX1NFMTBf
V0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVOT1ZPX1NFMzBfV0RUIGlzIG5vdCBzZXQKQ09O
RklHX01FTkYyMUJNQ19XQVRDSERPRz15CkNPTkZJR19NRU5aMDY5X1dBVENIRE9HPXkKQ09O
RklHX1dEQVRfV0RUPXkKQ09ORklHX1dNODMxWF9XQVRDSERPRz15CkNPTkZJR19XTTgzNTBf
V0FUQ0hET0c9eQpDT05GSUdfWElMSU5YX1dBVENIRE9HPXkKQ09ORklHX1pJSVJBVkVfV0FU
Q0hET0c9eQpDT05GSUdfUkFWRV9TUF9XQVRDSERPRz15CiMgQ09ORklHX01MWF9XRFQgaXMg
bm90IHNldApDT05GSUdfQ0FERU5DRV9XQVRDSERPRz15CkNPTkZJR19EV19XQVRDSERPRz15
CkNPTkZJR19UV0w0MDMwX1dBVENIRE9HPXkKQ09ORklHX01BWDYzWFhfV0FUQ0hET0c9eQpD
T05GSUdfUkVUVV9XQVRDSERPRz15CiMgQ09ORklHX0FDUVVJUkVfV0RUIGlzIG5vdCBzZXQK
IyBDT05GSUdfQURWQU5URUNIX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FEVkFOVEVDSF9F
Q19XRFQgaXMgbm90IHNldAojIENPTkZJR19BTElNMTUzNV9XRFQgaXMgbm90IHNldAojIENP
TkZJR19BTElNNzEwMV9XRFQgaXMgbm90IHNldAojIENPTkZJR19FQkNfQzM4NF9XRFQgaXMg
bm90IHNldAojIENPTkZJR19FWEFSX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX0Y3MTgwOEVf
V0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfU1A1MTAwX1RDTyBpcyBub3Qgc2V0CkNPTkZJR19T
QkNfRklUUEMyX1dBVENIRE9HPXkKIyBDT05GSUdfRVVST1RFQ0hfV0RUIGlzIG5vdCBzZXQK
IyBDT05GSUdfSUI3MDBfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNQVNSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0FGRVJfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfSTYzMDBFU0JfV0RU
IGlzIG5vdCBzZXQKIyBDT05GSUdfSUU2WFhfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5U
RUxfT0NfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19JVENPX1dEVCBpcyBub3Qgc2V0
CiMgQ09ORklHX0lUODcxMkZfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfSVQ4N19XRFQgaXMg
bm90IHNldApDT05GSUdfSFBfV0FUQ0hET0c9eQpDT05GSUdfSFBXRFRfTk1JX0RFQ09ESU5H
PXkKIyBDT05GSUdfU0MxMjAwX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1BDODc0MTNfV0RU
IGlzIG5vdCBzZXQKIyBDT05GSUdfTlZfVENPIGlzIG5vdCBzZXQKIyBDT05GSUdfNjBYWF9X
RFQgaXMgbm90IHNldAojIENPTkZJR19TTVNDX1NDSDMxMVhfV0RUIGlzIG5vdCBzZXQKIyBD
T05GSUdfU01TQzM3Qjc4N19XRFQgaXMgbm90IHNldAojIENPTkZJR19UUU1YODZfV0RUIGlz
IG5vdCBzZXQKIyBDT05GSUdfVklBX1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4MzYyN0hG
X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX1c4Mzg3N0ZfV0RUIGlzIG5vdCBzZXQKIyBDT05G
SUdfVzgzOTc3Rl9XRFQgaXMgbm90IHNldAojIENPTkZJR19NQUNIWl9XRFQgaXMgbm90IHNl
dApDT05GSUdfU0JDX0VQWF9DM19XQVRDSERPRz15CiMgQ09ORklHX05JOTAzWF9XRFQgaXMg
bm90IHNldAojIENPTkZJR19OSUM3MDE4X1dEVCBpcyBub3Qgc2V0CiMgQ09ORklHX01FTl9B
MjFfV0RUIGlzIG5vdCBzZXQKIyBDT05GSUdfWEVOX1dEVCBpcyBub3Qgc2V0CgojCiMgUENJ
LWJhc2VkIFdhdGNoZG9nIENhcmRzCiMKQ09ORklHX1BDSVBDV0FUQ0hET0c9eQojIENPTkZJ
R19XRFRQQ0kgaXMgbm90IHNldAoKIwojIFVTQi1iYXNlZCBXYXRjaGRvZyBDYXJkcwojCkNP
TkZJR19VU0JQQ1dBVENIRE9HPXkKQ09ORklHX1NTQl9QT1NTSUJMRT15CiMgQ09ORklHX1NT
QiBpcyBub3Qgc2V0CkNPTkZJR19CQ01BX1BPU1NJQkxFPXkKIyBDT05GSUdfQkNNQSBpcyBu
b3Qgc2V0CgojCiMgTXVsdGlmdW5jdGlvbiBkZXZpY2UgZHJpdmVycwojCkNPTkZJR19NRkRf
Q09SRT15CkNPTkZJR19NRkRfQVMzNzExPXkKIyBDT05GSUdfTUZEX1NNUFJPIGlzIG5vdCBz
ZXQKQ09ORklHX1BNSUNfQURQNTUyMD15CkNPTkZJR19NRkRfQUFUMjg3MF9DT1JFPXkKIyBD
T05GSUdfTUZEX0JDTTU5MFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX0JEOTU3MU1XViBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF9BWFAyMFhfSTJDIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUZEX0NHQkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfQ1M0MEw1MF9JMkMgaXMgbm90IHNl
dAojIENPTkZJR19NRkRfQ1M0MEw1MF9TUEkgaXMgbm90IHNldAojIENPTkZJR19NRkRfQ1M0
Mkw0M19JMkMgaXMgbm90IHNldAojIENPTkZJR19NRkRfTUFERVJBIGlzIG5vdCBzZXQKQ09O
RklHX1BNSUNfREE5MDNYPXkKQ09ORklHX1BNSUNfREE5MDUyPXkKQ09ORklHX01GRF9EQTkw
NTJfU1BJPXkKQ09ORklHX01GRF9EQTkwNTJfSTJDPXkKQ09ORklHX01GRF9EQTkwNTU9eQpD
T05GSUdfTUZEX0RBOTA2Mj15CkNPTkZJR19NRkRfREE5MDYzPXkKIyBDT05GSUdfTUZEX0RB
OTE1MCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9ETE4yIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUZEX01DMTNYWFhfU1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX01DMTNYWFhfSTJDIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX01QMjYyOSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9J
TlRFTF9RVUFSS19JMkNfR1BJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0xQQ19JQ0ggaXMgbm90
IHNldAojIENPTkZJR19MUENfU0NIIGlzIG5vdCBzZXQKQ09ORklHX0lOVEVMX1NPQ19QTUlD
PXkKQ09ORklHX0lOVEVMX1NPQ19QTUlDX0NIVFdDPXkKIyBDT05GSUdfSU5URUxfU09DX1BN
SUNfQ0hURENfVEkgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9TT0NfUE1JQ19NUkZMRCBp
cyBub3Qgc2V0CiMgQ09ORklHX01GRF9JTlRFTF9MUFNTX0FDUEkgaXMgbm90IHNldAojIENP
TkZJR19NRkRfSU5URUxfTFBTU19QQ0kgaXMgbm90IHNldAojIENPTkZJR19NRkRfSU5URUxf
UE1DX0JYVCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9JUVM2MlggaXMgbm90IHNldAojIENP
TkZJR19NRkRfSkFOWl9DTU9ESU8gaXMgbm90IHNldAojIENPTkZJR19NRkRfS0VNUExEIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEXzg4UE04MDAgaXMgbm90IHNldAojIENPTkZJR19NRkRf
ODhQTTgwNSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfODhQTTg2MFg9eQojIENPTkZJR19NRkRf
TUFYNTk3MCBpcyBub3Qgc2V0CkNPTkZJR19NRkRfTUFYMTQ1Nzc9eQojIENPTkZJR19NRkRf
TUFYNzc1NDEgaXMgbm90IHNldApDT05GSUdfTUZEX01BWDc3NjkzPXkKIyBDT05GSUdfTUZE
X01BWDc3NzA1IGlzIG5vdCBzZXQKQ09ORklHX01GRF9NQVg3Nzg0Mz15CiMgQ09ORklHX01G
RF9NQVg4OTA3IGlzIG5vdCBzZXQKQ09ORklHX01GRF9NQVg4OTI1PXkKQ09ORklHX01GRF9N
QVg4OTk3PXkKQ09ORklHX01GRF9NQVg4OTk4PXkKIyBDT05GSUdfTUZEX01UNjM2MCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01GRF9NVDYzNzAgaXMgbm90IHNldAojIENPTkZJR19NRkRfTVQ2
Mzk3IGlzIG5vdCBzZXQKQ09ORklHX01GRF9NRU5GMjFCTUM9eQojIENPTkZJR19NRkRfTkNU
NjY5NCBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9PQ0VMT1QgaXMgbm90IHNldApDT05GSUdf
RVpYX1BDQVA9eQojIENPTkZJR19NRkRfVklQRVJCT0FSRCBpcyBub3Qgc2V0CkNPTkZJR19N
RkRfUkVUVT15CiMgQ09ORklHX01GRF9TWTc2MzZBIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
X1JEQzMyMVggaXMgbm90IHNldAojIENPTkZJR19NRkRfUlQ0ODMxIGlzIG5vdCBzZXQKIyBD
T05GSUdfTUZEX1JUNTAzMyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9SVDUxMjAgaXMgbm90
IHNldApDT05GSUdfTUZEX1JDNVQ1ODM9eQojIENPTkZJR19NRkRfU0k0NzZYX0NPUkUgaXMg
bm90IHNldAojIENPTkZJR19NRkRfU001MDEgaXMgbm90IHNldAojIENPTkZJR19NRkRfU0tZ
ODE0NTIgaXMgbm90IHNldApDT05GSUdfTUZEX1NZU0NPTj15CiMgQ09ORklHX01GRF9MUDM5
NDMgaXMgbm90IHNldApDT05GSUdfTUZEX0xQODc4OD15CiMgQ09ORklHX01GRF9USV9MTVUg
aXMgbm90IHNldAojIENPTkZJR19NRkRfQlEyNTdYWCBpcyBub3Qgc2V0CkNPTkZJR19NRkRf
UEFMTUFTPXkKIyBDT05GSUdfVFBTNjEwNVggaXMgbm90IHNldAojIENPTkZJR19UUFM2NTAx
MCBpcyBub3Qgc2V0CiMgQ09ORklHX1RQUzY1MDdYIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
X1RQUzY1MDg2IGlzIG5vdCBzZXQKQ09ORklHX01GRF9UUFM2NTA5MD15CiMgQ09ORklHX01G
RF9USV9MUDg3M1ggaXMgbm90IHNldApDT05GSUdfTUZEX1RQUzY1ODZYPXkKQ09ORklHX01G
RF9UUFM2NTkxMD15CkNPTkZJR19NRkRfVFBTNjU5MTI9eQpDT05GSUdfTUZEX1RQUzY1OTEy
X0kyQz15CkNPTkZJR19NRkRfVFBTNjU5MTJfU1BJPXkKIyBDT05GSUdfTUZEX1RQUzY1OTRf
STJDIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZEX1RQUzY1OTRfU1BJIGlzIG5vdCBzZXQKQ09O
RklHX1RXTDQwMzBfQ09SRT15CkNPTkZJR19NRkRfVFdMNDAzMF9BVURJTz15CkNPTkZJR19U
V0w2MDQwX0NPUkU9eQojIENPTkZJR19NRkRfTE0zNTMzIGlzIG5vdCBzZXQKIyBDT05GSUdf
TUZEX1RRTVg4NiBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9WWDg1NSBpcyBub3Qgc2V0CiMg
Q09ORklHX01GRF9BUklaT05BX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9BUklaT05B
X1NQSSBpcyBub3Qgc2V0CkNPTkZJR19NRkRfV004NDAwPXkKQ09ORklHX01GRF9XTTgzMVg9
eQpDT05GSUdfTUZEX1dNODMxWF9JMkM9eQpDT05GSUdfTUZEX1dNODMxWF9TUEk9eQpDT05G
SUdfTUZEX1dNODM1MD15CkNPTkZJR19NRkRfV004MzUwX0kyQz15CiMgQ09ORklHX01GRF9X
TTg5OTQgaXMgbm90IHNldAojIENPTkZJR19NRkRfQVRDMjYwWF9JMkMgaXMgbm90IHNldApD
T05GSUdfUkFWRV9TUF9DT1JFPXkKIyBDT05GSUdfTUZEX0lOVEVMX00xMF9CTUNfU1BJIGlz
IG5vdCBzZXQKIyBDT05GSUdfTUZEX1FOQVBfTUNVIGlzIG5vdCBzZXQKIyBDT05GSUdfTUZE
X1VQQk9BUkRfRlBHQSBpcyBub3Qgc2V0CiMgQ09ORklHX01GRF9NQVg3MzYwIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgTXVsdGlmdW5jdGlvbiBkZXZpY2UgZHJpdmVycwoKQ09ORklHX1JFR1VM
QVRPUj15CiMgQ09ORklHX1JFR1VMQVRPUl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1JF
R1VMQVRPUl9GSVhFRF9WT0xUQUdFIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1ZJ
UlRVQUxfQ09OU1VNRVIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVVNFUlNQQUNF
X0NPTlNVTUVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX05FVExJTktfRVZFTlRT
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SXzg4UEc4NlggaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfODhQTTg2MDcgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
QUNUODg2NSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9BRDUzOTggaXMgbm90IHNl
dAojIENPTkZJR19SRUdVTEFUT1JfQURQNTA1NSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VM
QVRPUl9BQVQyODcwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0FTMzcxMSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9BVzM3NTAzIGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX0RBOTAzWCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9EQTkwNTIg
aXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfREE5MDU1IGlzIG5vdCBzZXQKIyBDT05G
SUdfUkVHVUxBVE9SX0RBOTA2MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9EQTky
MTAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfREE5MjExIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX0ZBTjUzNTU1IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9S
X0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfSVNMOTMwNSBpcyBub3Qgc2V0
CiMgQ09ORklHX1JFR1VMQVRPUl9JU0w2MjcxQSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VM
QVRPUl9GUDk5MzEgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTFAzOTcxIGlzIG5v
dCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xQMzk3MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JF
R1VMQVRPUl9MUDg3MlggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTFA4NzU1IGlz
IG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xQODc4OCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFR1VMQVRPUl9MVEMzNTg5IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX0xUQzM2
NzYgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYMTQ1NzcgaXMgbm90IHNldAoj
IENPTkZJR19SRUdVTEFUT1JfTUFYMTU4NiBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRP
Ul9NQVg3NzUwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg3Nzg1NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4NjQ5IGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX01BWDg2NjAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfTUFYODg5
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4OTI1IGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX01BWDg5NTIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
TUFYODk5NyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NQVg4OTk4IGlzIG5vdCBz
ZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDIwMDg2IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVH
VUxBVE9SX01BWDIwNDExIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDc3Njkz
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX01BWDc3ODI2IGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX01BWDc3ODM4IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9S
X01QODg1OSBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9NVDYzMTEgaXMgbm90IHNl
dAojIENPTkZJR19SRUdVTEFUT1JfUEFMTUFTIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxB
VE9SX1BDQTk0NTAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfUEY5NDUzIGlzIG5v
dCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1BDQVAgaXMgbm90IHNldAojIENPTkZJR19SRUdV
TEFUT1JfUEYwOTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1BWODgwNjAgaXMg
bm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfUFY4ODA4MCBpcyBub3Qgc2V0CiMgQ09ORklH
X1JFR1VMQVRPUl9QVjg4MDkwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1BXTSBp
cyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SQUEyMTUzMDAgaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfUkM1VDU4MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9S
VDQ4MDEgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfUlQ0ODAzIGlzIG5vdCBzZXQK
IyBDT05GSUdfUkVHVUxBVE9SX1JUNTE5MEEgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFU
T1JfUlQ1NzM5IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUNTc1OSBpcyBub3Qg
c2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SVDYxNjAgaXMgbm90IHNldAojIENPTkZJR19SRUdV
TEFUT1JfUlQ2MTkwIGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUNjI0NSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SVFEyMTM0IGlzIG5vdCBzZXQKIyBDT05GSUdf
UkVHVUxBVE9SX1JUTVYyMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9SVFE2NzUy
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkVHVUxBVE9SX1JUUTIyMDggaXMgbm90IHNldAojIENP
TkZJR19SRUdVTEFUT1JfU0xHNTEwMDAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1Jf
VFBTNTE2MzIgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjIzNjAgaXMgbm90
IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUwMjMgaXMgbm90IHNldAojIENPTkZJR19S
RUdVTEFUT1JfVFBTNjUwN1ggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUw
OTAgaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjUxMzIgaXMgbm90IHNldAoj
IENPTkZJR19SRUdVTEFUT1JfVFBTNjUyNFggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFU
T1JfVFBTNjU4NlggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjU5MTAgaXMg
bm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfVFBTNjU5MTIgaXMgbm90IHNldAojIENPTkZJ
R19SRUdVTEFUT1JfVFdMNDAzMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFR1VMQVRPUl9XTTgz
MVggaXMgbm90IHNldAojIENPTkZJR19SRUdVTEFUT1JfV004MzUwIGlzIG5vdCBzZXQKIyBD
T05GSUdfUkVHVUxBVE9SX1dNODQwMCBpcyBub3Qgc2V0CkNPTkZJR19SQ19DT1JFPW0KQ09O
RklHX0xJUkM9eQojIENPTkZJR19SQ19NQVAgaXMgbm90IHNldApDT05GSUdfUkNfREVDT0RF
UlM9eQojIENPTkZJR19JUl9JTU9OX0RFQ09ERVIgaXMgbm90IHNldAojIENPTkZJR19JUl9K
VkNfREVDT0RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX01DRV9LQkRfREVDT0RFUiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lSX05FQ19ERUNPREVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJf
UkM1X0RFQ09ERVIgaXMgbm90IHNldAojIENPTkZJR19JUl9SQzZfREVDT0RFUiBpcyBub3Qg
c2V0CiMgQ09ORklHX0lSX1JDTU1fREVDT0RFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX1NB
TllPX0RFQ09ERVIgaXMgbm90IHNldAojIENPTkZJR19JUl9TSEFSUF9ERUNPREVSIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVJfU09OWV9ERUNPREVSIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJf
WE1QX0RFQ09ERVIgaXMgbm90IHNldApDT05GSUdfUkNfREVWSUNFUz15CiMgQ09ORklHX0lS
X0VORSBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX0ZJTlRFSyBpcyBub3Qgc2V0CiMgQ09ORklH
X0lSX0lHT1JQTFVHVVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJfSUdVQU5BIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSVJfSU1PTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX0lNT05fUkFXIGlz
IG5vdCBzZXQKIyBDT05GSUdfSVJfSVRFX0NJUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX01D
RVVTQiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX05VVk9UT04gaXMgbm90IHNldAojIENPTkZJ
R19JUl9SRURSQVQzIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJfU0VSSUFMIGlzIG5vdCBzZXQK
IyBDT05GSUdfSVJfU1RSRUFNWkFQIGlzIG5vdCBzZXQKIyBDT05GSUdfSVJfVE9ZIGlzIG5v
dCBzZXQKIyBDT05GSUdfSVJfVFRVU0JJUiBpcyBub3Qgc2V0CiMgQ09ORklHX0lSX1dJTkJP
TkRfQ0lSIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNfQVRJX1JFTU9URSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JDX0xPT1BCQUNLIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNfWEJPWF9EVkQgaXMg
bm90IHNldAoKIwojIENFQyBzdXBwb3J0CiMKQ09ORklHX01FRElBX0NFQ19TVVBQT1JUPXkK
IyBDT05GSUdfQ0VDX0NINzMyMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NFQ19OWFBfVERBOTk1
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NFQ19HUElPIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0VD
X1NFQ08gaXMgbm90IHNldAojIENPTkZJR19VU0JfUFVMU0U4X0NFQyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9SQUlOU0hBRE9XX0NFQyBpcyBub3Qgc2V0CiMgZW5kIG9mIENFQyBzdXBw
b3J0CgojIENPTkZJR19NRURJQV9TVVBQT1JUIGlzIG5vdCBzZXQKCiMKIyBHcmFwaGljcyBz
dXBwb3J0CiMKQ09ORklHX0FQRVJUVVJFX0hFTFBFUlM9eQpDT05GSUdfU0NSRUVOX0lORk89
eQpDT05GSUdfVklERU89eQpDT05GSUdfQVVYRElTUExBWT15CiMgQ09ORklHX0hENDQ3ODAg
aXMgbm90IHNldAojIENPTkZJR19MQ0QyUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NIQVJMQ0Rf
QkxfT0ZGIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0hBUkxDRF9CTF9PTiBpcyBub3Qgc2V0CkNP
TkZJR19DSEFSTENEX0JMX0ZMQVNIPXkKIyBDT05GSUdfSU1HX0FTQ0lJX0xDRCBpcyBub3Qg
c2V0CiMgQ09ORklHX0hUMTZLMzMgaXMgbm90IHNldAojIENPTkZJR19NQVg2OTU5IGlzIG5v
dCBzZXQKIyBDT05GSUdfU0VHX0xFRF9HUElPIGlzIG5vdCBzZXQKQ09ORklHX0FHUD15CkNP
TkZJR19BR1BfQU1ENjQ9eQpDT05GSUdfQUdQX0lOVEVMPXkKIyBDT05GSUdfQUdQX1NJUyBp
cyBub3Qgc2V0CkNPTkZJR19BR1BfVklBPXkKQ09ORklHX0lOVEVMX0dUVD15CkNPTkZJR19W
R0FfU1dJVENIRVJPTz15CkNPTkZJR19EUk09bQoKIwojIERSTSBkZWJ1Z2dpbmcgb3B0aW9u
cwojCiMgQ09ORklHX0RSTV9XRVJST1IgaXMgbm90IHNldAojIENPTkZJR19EUk1fREVCVUdf
TU0gaXMgbm90IHNldAojIGVuZCBvZiBEUk0gZGVidWdnaW5nIG9wdGlvbnMKCkNPTkZJR19E
Uk1fS01TX0hFTFBFUj1tCiMgQ09ORklHX0RSTV9QQU5JQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0RSTV9ERUJVR19EUF9NU1RfVE9QT0xPR1lfUkVGUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RS
TV9ERUJVR19NT0RFU0VUX0xPQ0sgaXMgbm90IHNldApDT05GSUdfRFJNX0NMSUVOVD15CkNP
TkZJR19EUk1fQ0xJRU5UX0xJQj1tCkNPTkZJR19EUk1fQ0xJRU5UX1NFTEVDVElPTj1tCkNP
TkZJR19EUk1fQ0xJRU5UX1NFVFVQPXkKCiMKIyBTdXBwb3J0ZWQgRFJNIGNsaWVudHMKIwpD
T05GSUdfRFJNX0ZCREVWX0VNVUxBVElPTj15CkNPTkZJR19EUk1fRkJERVZfT1ZFUkFMTE9D
PTEwMAojIENPTkZJR19EUk1fRkJERVZfTEVBS19QSFlTX1NNRU0gaXMgbm90IHNldAojIENP
TkZJR19EUk1fQ0xJRU5UX0xPRyBpcyBub3Qgc2V0CkNPTkZJR19EUk1fQ0xJRU5UX0RFRkFV
TFRfRkJERVY9eQpDT05GSUdfRFJNX0NMSUVOVF9ERUZBVUxUPSJmYmRldiIKIyBlbmQgb2Yg
U3VwcG9ydGVkIERSTSBjbGllbnRzCgpDT05GSUdfRFJNX0xPQURfRURJRF9GSVJNV0FSRT15
CkNPTkZJR19EUk1fR0VNX1NITUVNX0hFTFBFUj1tCgojCiMgRHJpdmVycyBmb3Igc3lzdGVt
IGZyYW1lYnVmZmVycwojCiMgQ09ORklHX0RSTV9FRklEUk0gaXMgbm90IHNldAojIENPTkZJ
R19EUk1fU0lNUExFRFJNIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZFU0FEUk0gaXMgbm90
IHNldAojIGVuZCBvZiBEcml2ZXJzIGZvciBzeXN0ZW0gZnJhbWVidWZmZXJzCgojCiMgQVJN
IGRldmljZXMKIwojIGVuZCBvZiBBUk0gZGV2aWNlcwoKIyBDT05GSUdfRFJNX1JBREVPTiBp
cyBub3Qgc2V0CiMgQ09ORklHX0RSTV9BTURHUFUgaXMgbm90IHNldAojIENPTkZJR19EUk1f
Tk9VVkVBVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9JOTE1IGlzIG5vdCBzZXQKIyBDT05G
SUdfRFJNX1hFIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZHRU0gaXMgbm90IHNldAojIENP
TkZJR19EUk1fVktNUyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9WTVdHRlggaXMgbm90IHNl
dAojIENPTkZJR19EUk1fR01BNTAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1VETCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0RSTV9BU1QgaXMgbm90IHNldApDT05GSUdfRFJNX01HQUcyMDA9
bQojIENPTkZJR19EUk1fUVhMIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZJUlRJT19HUFUg
aXMgbm90IHNldApDT05GSUdfRFJNX1BBTkVMPXkKCiMKIyBEaXNwbGF5IFBhbmVscwojCiMg
Q09ORklHX0RSTV9QQU5FTF9BVU9fQTAzMEpUTjAxIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJN
X1BBTkVMX0lMSVRFS19JTEk5MzQxIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1BBTkVMX09S
SVNFVEVDSF9PVEE1NjAxQSBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9QQU5FTF9XSURFQ0hJ
UFNfV1MyNDAxIGlzIG5vdCBzZXQKIyBlbmQgb2YgRGlzcGxheSBQYW5lbHMKCkNPTkZJR19E
Uk1fQlJJREdFPXkKQ09ORklHX0RSTV9QQU5FTF9CUklER0U9eQoKIwojIERpc3BsYXkgSW50
ZXJmYWNlIEJyaWRnZXMKIwojIENPTkZJR19EUk1fSTJDX05YUF9UREE5OThYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRFJNX0FOQUxPR0lYX0FOWDc4WFggaXMgbm90IHNldAojIGVuZCBvZiBE
aXNwbGF5IEludGVyZmFjZSBCcmlkZ2VzCgojIENPTkZJR19EUk1fRVROQVZJViBpcyBub3Qg
c2V0CiMgQ09ORklHX0RSTV9ISVNJX0hJQk1DIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX0FQ
UExFVEJEUk0gaXMgbm90IHNldAojIENPTkZJR19EUk1fQk9DSFMgaXMgbm90IHNldAojIENP
TkZJR19EUk1fQ0lSUlVTX1FFTVUgaXMgbm90IHNldAojIENPTkZJR19EUk1fR00xMlUzMjAg
aXMgbm90IHNldAojIENPTkZJR19EUk1fUEFORUxfTUlQSV9EQkkgaXMgbm90IHNldAojIENP
TkZJR19EUk1fUElYUEFQRVIgaXMgbm90IHNldAojIENPTkZJR19USU5ZRFJNX0hYODM1N0Qg
aXMgbm90IHNldAojIENPTkZJR19USU5ZRFJNX0lMSTkxNjMgaXMgbm90IHNldAojIENPTkZJ
R19USU5ZRFJNX0lMSTkyMjUgaXMgbm90IHNldAojIENPTkZJR19USU5ZRFJNX0lMSTkzNDEg
aXMgbm90IHNldAojIENPTkZJR19USU5ZRFJNX0lMSTk0ODYgaXMgbm90IHNldAojIENPTkZJ
R19USU5ZRFJNX01JMDI4M1FUIGlzIG5vdCBzZXQKIyBDT05GSUdfVElOWURSTV9SRVBBUEVS
IGlzIG5vdCBzZXQKIyBDT05GSUdfVElOWURSTV9TSEFSUF9NRU1PUlkgaXMgbm90IHNldAoj
IENPTkZJR19EUk1fWEVOX0ZST05URU5EIGlzIG5vdCBzZXQKIyBDT05GSUdfRFJNX1ZCT1hW
SURFTyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9HVUQgaXMgbm90IHNldAojIENPTkZJR19E
Uk1fU1Q3NTcxX0kyQyBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9TVDc1ODYgaXMgbm90IHNl
dAojIENPTkZJR19EUk1fU1Q3NzM1UiBpcyBub3Qgc2V0CiMgQ09ORklHX0RSTV9TU0QxMzBY
IGlzIG5vdCBzZXQKQ09ORklHX0RSTV9QQU5FTF9PUklFTlRBVElPTl9RVUlSS1M9eQoKIwoj
IEZyYW1lIGJ1ZmZlciBEZXZpY2VzCiMKQ09ORklHX0ZCPXkKIyBDT05GSUdfRkJfQ0lSUlVT
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUE0yIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQ1lC
RVIyMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVJDIGlzIG5vdCBzZXQKQ09ORklHX0ZC
X0FTSUxJQU5UPXkKQ09ORklHX0ZCX0lNU1RUPXkKIyBDT05GSUdfRkJfVkdBMTYgaXMgbm90
IHNldAojIENPTkZJR19GQl9VVkVTQSBpcyBub3Qgc2V0CkNPTkZJR19GQl9WRVNBPXkKQ09O
RklHX0ZCX0VGST15CiMgQ09ORklHX0ZCX040MTEgaXMgbm90IHNldAojIENPTkZJR19GQl9I
R0EgaXMgbm90IHNldAojIENPTkZJR19GQl9PUEVOQ09SRVMgaXMgbm90IHNldAojIENPTkZJ
R19GQl9TMUQxM1hYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX05WSURJQSBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZCX1JJVkEgaXMgbm90IHNldAojIENPTkZJR19GQl9JNzQwIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRkJfTUFUUk9YIGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUkFERU9OIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfQVRZMTI4IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfQVRZ
IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfUzMgaXMgbm90IHNldAojIENPTkZJR19GQl9TQVZB
R0UgaXMgbm90IHNldAojIENPTkZJR19GQl9TSVMgaXMgbm90IHNldAojIENPTkZJR19GQl9W
SUEgaXMgbm90IHNldAojIENPTkZJR19GQl9ORU9NQUdJQyBpcyBub3Qgc2V0CiMgQ09ORklH
X0ZCX0tZUk8gaXMgbm90IHNldAojIENPTkZJR19GQl8zREZYIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfVk9PRE9PMSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1ZUODYyMyBpcyBub3Qgc2V0
CiMgQ09ORklHX0ZCX1RSSURFTlQgaXMgbm90IHNldAojIENPTkZJR19GQl9BUksgaXMgbm90
IHNldAojIENPTkZJR19GQl9QTTMgaXMgbm90IHNldAojIENPTkZJR19GQl9DQVJNSU5FIGlz
IG5vdCBzZXQKIyBDT05GSUdfRkJfU01TQ1VGWCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX1VE
TCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZCX0lCTV9HWFQ0NTAwIGlzIG5vdCBzZXQKIyBDT05G
SUdfRkJfVklSVFVBTCBpcyBub3Qgc2V0CiMgQ09ORklHX1hFTl9GQkRFVl9GUk9OVEVORCBp
cyBub3Qgc2V0CiMgQ09ORklHX0ZCX01FVFJPTk9NRSBpcyBub3Qgc2V0CiMgQ09ORklHX0ZC
X01CODYyWFggaXMgbm90IHNldAojIENPTkZJR19GQl9TSU1QTEUgaXMgbm90IHNldAojIENP
TkZJR19GQl9TU0QxMzA3IGlzIG5vdCBzZXQKIyBDT05GSUdfRkJfU003MTIgaXMgbm90IHNl
dApDT05GSUdfRkJfQ09SRT15CkNPTkZJR19GQl9OT1RJRlk9eQpDT05GSUdfRkJfREVWSUNF
PXkKQ09ORklHX0ZCX0NGQl9GSUxMUkVDVD15CkNPTkZJR19GQl9DRkJfQ09QWUFSRUE9eQpD
T05GSUdfRkJfQ0ZCX0lNQUdFQkxJVD15CkNPTkZJR19GQl9TWVNfRklMTFJFQ1Q9eQpDT05G
SUdfRkJfU1lTX0NPUFlBUkVBPXkKQ09ORklHX0ZCX1NZU19JTUFHRUJMSVQ9eQojIENPTkZJ
R19GQl9GT1JFSUdOX0VORElBTiBpcyBub3Qgc2V0CkNPTkZJR19GQl9TWVNNRU1fRk9QUz15
CkNPTkZJR19GQl9ERUZFUlJFRF9JTz15CkNPTkZJR19GQl9JT01FTV9GT1BTPXkKQ09ORklH
X0ZCX0lPTUVNX0hFTFBFUlM9eQpDT05GSUdfRkJfU1lTTUVNX0hFTFBFUlM9eQpDT05GSUdf
RkJfU1lTTUVNX0hFTFBFUlNfREVGRVJSRUQ9eQpDT05GSUdfRkJfVElMRUJMSVRUSU5HPXkK
IyBlbmQgb2YgRnJhbWUgYnVmZmVyIERldmljZXMKCiMKIyBCYWNrbGlnaHQgJiBMQ0QgZGV2
aWNlIHN1cHBvcnQKIwojIENPTkZJR19MQ0RfQ0xBU1NfREVWSUNFIGlzIG5vdCBzZXQKQ09O
RklHX0JBQ0tMSUdIVF9DTEFTU19ERVZJQ0U9eQojIENPTkZJR19CQUNLTElHSFRfQVc5OTcw
NiBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9LVEQyNTMgaXMgbm90IHNldAojIENP
TkZJR19CQUNLTElHSFRfS1REMjgwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9L
VFo4ODY2IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX1BXTSBpcyBub3Qgc2V0CiMg
Q09ORklHX0JBQ0tMSUdIVF9EQTkwM1ggaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRf
REE5MDUyIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX01BWDg5MjUgaXMgbm90IHNl
dAojIENPTkZJR19CQUNLTElHSFRfQVBQTEUgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElH
SFRfUUNPTV9XTEVEIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX1NBSEFSQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9XTTgzMVggaXMgbm90IHNldAojIENPTkZJR19C
QUNLTElHSFRfQURQNTUyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9BRFA4ODYw
IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0FEUDg4NzAgaXMgbm90IHNldAojIENP
TkZJR19CQUNLTElHSFRfODhQTTg2MFggaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRf
QUFUMjg3MCBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tMSUdIVF9MTTM1MDkgaXMgbm90IHNl
dAojIENPTkZJR19CQUNLTElHSFRfTE0zNjMwQSBpcyBub3Qgc2V0CiMgQ09ORklHX0JBQ0tM
SUdIVF9MTTM2MzkgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTFA4NTVYIGlzIG5v
dCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX0xQODc4OCBpcyBub3Qgc2V0CiMgQ09ORklHX0JB
Q0tMSUdIVF9NUDMzMDlDIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS0xJR0hUX1BBTkRPUkEg
aXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQVMzNzExIGlzIG5vdCBzZXQKIyBDT05G
SUdfQkFDS0xJR0hUX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfTFY1MjA3
TFAgaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRfQkQ2MTA3IGlzIG5vdCBzZXQKIyBD
T05GSUdfQkFDS0xJR0hUX0FSQ1hDTk4gaXMgbm90IHNldAojIENPTkZJR19CQUNLTElHSFRf
UkFWRV9TUCBpcyBub3Qgc2V0CiMgZW5kIG9mIEJhY2tsaWdodCAmIExDRCBkZXZpY2Ugc3Vw
cG9ydAoKQ09ORklHX0hETUk9eQpDT05GSUdfRklSTVdBUkVfRURJRD15CgojCiMgQ29uc29s
ZSBkaXNwbGF5IGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX1ZHQV9DT05TT0xFPXkKQ09ORklH
X0RVTU1ZX0NPTlNPTEU9eQpDT05GSUdfRFVNTVlfQ09OU09MRV9DT0xVTU5TPTgwCkNPTkZJ
R19EVU1NWV9DT05TT0xFX1JPV1M9MjUKQ09ORklHX0ZSQU1FQlVGRkVSX0NPTlNPTEU9eQoj
IENPTkZJR19GUkFNRUJVRkZFUl9DT05TT0xFX0xFR0FDWV9BQ0NFTEVSQVRJT04gaXMgbm90
IHNldApDT05GSUdfRlJBTUVCVUZGRVJfQ09OU09MRV9ERVRFQ1RfUFJJTUFSWT15CkNPTkZJ
R19GUkFNRUJVRkZFUl9DT05TT0xFX1JPVEFUSU9OPXkKQ09ORklHX0ZSQU1FQlVGRkVSX0NP
TlNPTEVfREVGRVJSRURfVEFLRU9WRVI9eQojIGVuZCBvZiBDb25zb2xlIGRpc3BsYXkgZHJp
dmVyIHN1cHBvcnQKCiMgQ09ORklHX0xPR08gaXMgbm90IHNldAojIENPTkZJR19UUkFDRV9H
UFVfTUVNIGlzIG5vdCBzZXQKIyBlbmQgb2YgR3JhcGhpY3Mgc3VwcG9ydAoKIyBDT05GSUdf
RFJNX0FDQ0VMIGlzIG5vdCBzZXQKIyBDT05GSUdfU09VTkQgaXMgbm90IHNldApDT05GSUdf
SElEX1NVUFBPUlQ9eQpDT05GSUdfSElEPW0KQ09ORklHX0hJRF9CQVRURVJZX1NUUkVOR1RI
PXkKQ09ORklHX0hJRFJBVz15CiMgQ09ORklHX1VISUQgaXMgbm90IHNldApDT05GSUdfSElE
X0dFTkVSSUM9bQojIENPTkZJR19ISURfSEFQVElDIGlzIG5vdCBzZXQKCiMKIyBTcGVjaWFs
IEhJRCBkcml2ZXJzCiMKIyBDT05GSUdfSElEX0E0VEVDSCBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9BQ0NVVE9VQ0ggaXMgbm90IHNldAojIENPTkZJR19ISURfQUNSVVggaXMgbm90IHNl
dAojIENPTkZJR19ISURfQVBQTEUgaXMgbm90IHNldAojIENPTkZJR19ISURfQVBQTEVJUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9BUFBMRVRCX0JMIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX0FQUExFVEJfS0JEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0FTVVMgaXMgbm90IHNl
dAojIENPTkZJR19ISURfQVVSRUFMIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0JFTEtJTiBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9CRVRPUF9GRiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJ
RF9CSUdCRU5fRkYgaXMgbm90IHNldAojIENPTkZJR19ISURfQ0hFUlJZIGlzIG5vdCBzZXQK
IyBDT05GSUdfSElEX0NISUNPTlkgaXMgbm90IHNldAojIENPTkZJR19ISURfQ09SU0FJUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DT1VHQVIgaXMgbm90IHNldAojIENPTkZJR19ISURf
TUFDQUxMWSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DTUVESUEgaXMgbm90IHNldAojIENP
TkZJR19ISURfQ1AyMTEyIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0NSRUFUSVZFX1NCMDU0
MCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9DWVBSRVNTIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX0RSQUdPTlJJU0UgaXMgbm90IHNldAojIENPTkZJR19ISURfRU1TX0ZGIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0VMQU4gaXMgbm90IHNldAojIENPTkZJR19ISURfRUxFQ09NIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX0VMTyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9FVklT
SU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0VaS0VZIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX0ZUMjYwIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0dFTUJJUkQgaXMgbm90IHNldAoj
IENPTkZJR19ISURfR0ZSTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9HTE9SSU9VUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9IT0xURUsgaXMgbm90IHNldAojIENPTkZJR19ISURfR09P
RElYX1NQSSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9HT09HTEVfU1RBRElBX0ZGIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1ZJVkFMREkgaXMgbm90IHNldAojIENPTkZJR19ISURfR1Q2
ODNSIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0tFWVRPVUNIIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX0tZRSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9LWVNPTkEgaXMgbm90IHNldAoj
IENPTkZJR19ISURfVUNMT0dJQyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9XQUxUT1AgaXMg
bm90IHNldAojIENPTkZJR19ISURfVklFV1NPTklDIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1ZSQzIgaXMgbm90IHNldAojIENPTkZJR19ISURfWElBT01JIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX0dZUkFUSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0lDQURFIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0lURSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9KQUJSQSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hJRF9UV0lOSEFOIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX0tF
TlNJTkdUT04gaXMgbm90IHNldAojIENPTkZJR19ISURfTENQT1dFUiBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9MRUQgaXMgbm90IHNldAojIENPTkZJR19ISURfTEVOT1ZPIGlzIG5vdCBz
ZXQKIyBDT05GSUdfSElEX0xFVFNLRVRDSCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9NQUdJ
Q01PVVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX01BTFRST04gaXMgbm90IHNldAojIENP
TkZJR19ISURfTUFZRkxBU0ggaXMgbm90IHNldAojIENPTkZJR19ISURfTUVHQVdPUkxEX0ZG
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JFRFJBR09OIGlzIG5vdCBzZXQKIyBDT05GSUdf
SElEX01JQ1JPU09GVCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9NT05URVJFWSBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9NVUxUSVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX05J
TlRFTkRPIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX05USSBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9OVFJJRyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9PUlRFSyBpcyBub3Qgc2V0CiMg
Q09ORklHX0hJRF9QQU5USEVSTE9SRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QRU5NT1VO
VCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9QRVRBTFlOWCBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9QSUNPTENEIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1BMQU5UUk9OSUNTIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1BYUkMgaXMgbm90IHNldAojIENPTkZJR19ISURfUkFaRVIg
aXMgbm90IHNldAojIENPTkZJR19ISURfUFJJTUFYIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X1JFVFJPREUgaXMgbm90IHNldAojIENPTkZJR19ISURfUk9DQ0FUIGlzIG5vdCBzZXQKIyBD
T05GSUdfSElEX1NBSVRFSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TQU1TVU5HIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1NFTUlURUsgaXMgbm90IHNldAojIENPTkZJR19ISURfU0lH
TUFNSUNSTyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TT05ZIGlzIG5vdCBzZXQKIyBDT05G
SUdfSElEX1NQRUVETElOSyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9TVEVBTSBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9TVEVFTFNFUklFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9T
VU5QTFVTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1JNSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9HUkVFTkFTSUEgaXMgbm90IHNldAojIENPTkZJR19ISURfU01BUlRKT1lQTFVTIGlz
IG5vdCBzZXQKIyBDT05GSUdfSElEX1RJVk8gaXMgbm90IHNldAojIENPTkZJR19ISURfVE9Q
U0VFRCBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9UT1BSRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0hJRF9USElOR00gaXMgbm90IHNldAojIENPTkZJR19ISURfVEhSVVNUTUFTVEVSIGlzIG5v
dCBzZXQKIyBDT05GSUdfSElEX1VEUkFXX1BTMyBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9V
MkZaRVJPIGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1VOSVZFUlNBTF9QSURGRiBpcyBub3Qg
c2V0CiMgQ09ORklHX0hJRF9XQUNPTSBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9XSUlNT1RF
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElEX1dJTldJTkcgaXMgbm90IHNldAojIENPTkZJR19I
SURfWElOTU8gaXMgbm90IHNldAojIENPTkZJR19ISURfWkVST1BMVVMgaXMgbm90IHNldAoj
IENPTkZJR19ISURfWllEQUNST04gaXMgbm90IHNldAojIENPTkZJR19ISURfU0VOU09SX0hV
QiBpcyBub3Qgc2V0CiMgQ09ORklHX0hJRF9BTFBTIGlzIG5vdCBzZXQKIyBDT05GSUdfSElE
X01DUDIyMDAgaXMgbm90IHNldAojIENPTkZJR19ISURfTUNQMjIyMSBpcyBub3Qgc2V0CiMg
ZW5kIG9mIFNwZWNpYWwgSElEIGRyaXZlcnMKCiMKIyBISUQtQlBGIHN1cHBvcnQKIwojIENP
TkZJR19ISURfQlBGIGlzIG5vdCBzZXQKIyBlbmQgb2YgSElELUJQRiBzdXBwb3J0CgpDT05G
SUdfSTJDX0hJRD1tCiMgQ09ORklHX0kyQ19ISURfQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0kyQ19ISURfT0YgaXMgbm90IHNldAoKIwojIEludGVsIElTSCBISUQgc3VwcG9ydAojCiMg
Q09ORklHX0lOVEVMX0lTSF9ISUQgaXMgbm90IHNldAojIGVuZCBvZiBJbnRlbCBJU0ggSElE
IHN1cHBvcnQKCiMKIyBBTUQgU0ZIIEhJRCBTdXBwb3J0CiMKIyBDT05GSUdfQU1EX1NGSF9I
SUQgaXMgbm90IHNldAojIGVuZCBvZiBBTUQgU0ZIIEhJRCBTdXBwb3J0CgojCiMgSW50ZWwg
VEhDIEhJRCBTdXBwb3J0CiMKIyBDT05GSUdfSU5URUxfVEhDX0hJRCBpcyBub3Qgc2V0CiMg
ZW5kIG9mIEludGVsIFRIQyBISUQgU3VwcG9ydAoKIwojIFVTQiBISUQgc3VwcG9ydAojCkNP
TkZJR19VU0JfSElEPW0KQ09ORklHX0hJRF9QSUQ9eQpDT05GSUdfVVNCX0hJRERFVj15Cgoj
CiMgVVNCIEhJRCBCb290IFByb3RvY29sIGRyaXZlcnMKIwojIENPTkZJR19VU0JfS0JEIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX01PVVNFIGlzIG5vdCBzZXQKIyBlbmQgb2YgVVNCIEhJ
RCBCb290IFByb3RvY29sIGRyaXZlcnMKIyBlbmQgb2YgVVNCIEhJRCBzdXBwb3J0CgpDT05G
SUdfVVNCX09IQ0lfTElUVExFX0VORElBTj15CkNPTkZJR19VU0JfU1VQUE9SVD15CkNPTkZJ
R19VU0JfQ09NTU9OPXkKQ09ORklHX1VTQl9MRURfVFJJRz15CiMgQ09ORklHX1VTQl9VTFBJ
X0JVUyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9DT05OX0dQSU8gaXMgbm90IHNldApDT05G
SUdfVVNCX0FSQ0hfSEFTX0hDRD15CkNPTkZJR19VU0I9eQpDT05GSUdfVVNCX1BDST15CkNP
TkZJR19VU0JfUENJX0FNRD15CkNPTkZJR19VU0JfQU5OT1VOQ0VfTkVXX0RFVklDRVM9eQoK
IwojIE1pc2NlbGxhbmVvdXMgVVNCIG9wdGlvbnMKIwpDT05GSUdfVVNCX0RFRkFVTFRfUEVS
U0lTVD15CiMgQ09ORklHX1VTQl9GRVdfSU5JVF9SRVRSSUVTIGlzIG5vdCBzZXQKQ09ORklH
X1VTQl9EWU5BTUlDX01JTk9SUz15CiMgQ09ORklHX1VTQl9PVEcgaXMgbm90IHNldAojIENP
TkZJR19VU0JfT1RHX1BST0RVQ1RMSVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX09UR19E
SVNBQkxFX0VYVEVSTkFMX0hVQiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9MRURTX1RSSUdH
RVJfVVNCUE9SVCBpcyBub3Qgc2V0CkNPTkZJR19VU0JfQVVUT1NVU1BFTkRfREVMQVk9MgpD
T05GSUdfVVNCX0RFRkFVTFRfQVVUSE9SSVpBVElPTl9NT0RFPTEKIyBDT05GSUdfVVNCX01P
TiBpcyBub3Qgc2V0CgojCiMgVVNCIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05G
SUdfVVNCX0M2N1gwMF9IQ0QgaXMgbm90IHNldApDT05GSUdfVVNCX1hIQ0lfSENEPXkKQ09O
RklHX1VTQl9YSENJX0RCR0NBUD15CkNPTkZJR19VU0JfWEhDSV9QQ0k9eQpDT05GSUdfVVNC
X1hIQ0lfUENJX1JFTkVTQVM9bQojIENPTkZJR19VU0JfWEhDSV9QTEFURk9STSBpcyBub3Qg
c2V0CiMgQ09ORklHX1VTQl9YSENJX1NJREVCQU5EIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9F
SENJX0hDRD15CkNPTkZJR19VU0JfRUhDSV9ST09UX0hVQl9UVD15CkNPTkZJR19VU0JfRUhD
SV9UVF9ORVdTQ0hFRD15CkNPTkZJR19VU0JfRUhDSV9QQ0k9eQojIENPTkZJR19VU0JfRUhD
SV9GU0wgaXMgbm90IHNldApDT05GSUdfVVNCX0VIQ0lfSENEX1BMQVRGT1JNPXkKIyBDT05G
SUdfVVNCX09YVTIxMEhQX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU1AxMTZYX0hD
RCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NQVgzNDIxX0hDRCBpcyBub3Qgc2V0CkNPTkZJ
R19VU0JfT0hDSV9IQ0Q9eQpDT05GSUdfVVNCX09IQ0lfSENEX1BDST15CkNPTkZJR19VU0Jf
T0hDSV9IQ0RfUExBVEZPUk09eQpDT05GSUdfVVNCX1VIQ0lfSENEPXkKIyBDT05GSUdfVVNC
X1NMODExX0hDRCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9SOEE2NjU5N19IQ0QgaXMgbm90
IHNldAojIENPTkZJR19VU0JfSENEX1RFU1RfTU9ERSBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9YRU5fSENEIGlzIG5vdCBzZXQKCiMKIyBVU0IgRGV2aWNlIENsYXNzIGRyaXZlcnMKIwoj
IENPTkZJR19VU0JfQUNNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1BSSU5URVIgaXMgbm90
IHNldAojIENPTkZJR19VU0JfV0RNIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1RNQyBpcyBu
b3Qgc2V0CgojCiMgTk9URTogVVNCX1NUT1JBR0UgZGVwZW5kcyBvbiBTQ1NJIGJ1dCBCTEtf
REVWX1NEIG1heSBhbHNvIGJlIG5lZWRlZDsgc2VlIFVTQl9TVE9SQUdFIEhlbHAgZm9yIG1v
cmUgaW5mbwojCkNPTkZJR19VU0JfU1RPUkFHRT15CiMgQ09ORklHX1VTQl9TVE9SQUdFX0RF
QlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfUkVBTFRFSyBpcyBub3Qgc2V0
CiMgQ09ORklHX1VTQl9TVE9SQUdFX0RBVEFGQUIgaXMgbm90IHNldAojIENPTkZJR19VU0Jf
U1RPUkFHRV9GUkVFQ09NIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfSVNEMjAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfVVNCQVQgaXMgbm90IHNldAojIENP
TkZJR19VU0JfU1RPUkFHRV9TRERSMDkgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFH
RV9TRERSNTUgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9KVU1QU0hPVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1VTQl9TVE9SQUdFX0FMQVVEQSBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9TVE9SQUdFX09ORVRPVUNIIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0Vf
S0FSTUEgaXMgbm90IHNldAojIENPTkZJR19VU0JfU1RPUkFHRV9DWVBSRVNTX0FUQUNCIGlz
IG5vdCBzZXQKIyBDT05GSUdfVVNCX1NUT1JBR0VfRU5FX1VCNjI1MCBpcyBub3Qgc2V0CkNP
TkZJR19VU0JfVUFTPXkKCiMKIyBVU0IgSW1hZ2luZyBkZXZpY2VzCiMKIyBDT05GSUdfVVNC
X01EQzgwMCBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9NSUNST1RFSyBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQklQX0NPUkUgaXMgbm90IHNldAoKIwojIFVTQiBkdWFsLW1vZGUgY29udHJv
bGxlciBkcml2ZXJzCiMKIyBDT05GSUdfVVNCX0NETlNfU1VQUE9SVCBpcyBub3Qgc2V0CiMg
Q09ORklHX1VTQl9NVVNCX0hEUkMgaXMgbm90IHNldAojIENPTkZJR19VU0JfRFdDMyBpcyBu
b3Qgc2V0CkNPTkZJR19VU0JfRFdDMj15CkNPTkZJR19VU0JfRFdDMl9IT1NUPXkKCiMKIyBH
YWRnZXQvRHVhbC1yb2xlIG1vZGUgcmVxdWlyZXMgVVNCIEdhZGdldCBzdXBwb3J0IHRvIGJl
IGVuYWJsZWQKIwojIENPTkZJR19VU0JfRFdDMl9QQ0kgaXMgbm90IHNldAojIENPTkZJR19V
U0JfRFdDMl9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9EV0MyX1RSQUNLX01JU1NF
RF9TT0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NISVBJREVBIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX0lTUDE3NjAgaXMgbm90IHNldAoKIwojIFVTQiBwb3J0IGRyaXZlcnMKIwoj
IENPTkZJR19VU0JfU0VSSUFMIGlzIG5vdCBzZXQKCiMKIyBVU0IgTWlzY2VsbGFuZW91cyBk
cml2ZXJzCiMKIyBDT05GSUdfVVNCX0VNSTYyIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0VN
STI2IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FEVVRVWCBpcyBub3Qgc2V0CkNPTkZJR19V
U0JfU0VWU0VHPXkKIyBDT05GSUdfVVNCX0xFR09UT1dFUiBpcyBub3Qgc2V0CiMgQ09ORklH
X1VTQl9MQ0QgaXMgbm90IHNldAojIENPTkZJR19VU0JfQ1lQUkVTU19DWTdDNjMgaXMgbm90
IHNldAojIENPTkZJR19VU0JfQ1lUSEVSTSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JRE1P
VVNFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0FQUExFRElTUExBWSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FQUExFX01GSV9GQVNUQ0hBUkdFIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xK
Q0EgaXMgbm90IHNldAojIENPTkZJR19VU0JfVVNCSU8gaXMgbm90IHNldAojIENPTkZJR19V
U0JfU0lTVVNCVkdBIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0xEIGlzIG5vdCBzZXQKIyBD
T05GSUdfVVNCX1RSQU5DRVZJQlJBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lPV0FS
UklPUiBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdf
VVNCX0VIU0VUX1RFU1RfRklYVFVSRSBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9JU0lHSFRG
VyBpcyBub3Qgc2V0CiMgQ09ORklHX1VTQl9ZVVJFWCBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9FWlVTQl9GWDIgaXMgbm90IHNldAojIENPTkZJR19VU0JfSFVCX1VTQjI1MVhCIGlzIG5v
dCBzZXQKIyBDT05GSUdfVVNCX0hTSUNfVVNCMzUwMyBpcyBub3Qgc2V0CiMgQ09ORklHX1VT
Ql9IU0lDX1VTQjQ2MDQgaXMgbm90IHNldAojIENPTkZJR19VU0JfTElOS19MQVlFUl9URVNU
IGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0NIQU9TS0VZIGlzIG5vdCBzZXQKCiMKIyBVU0Ig
UGh5c2ljYWwgTGF5ZXIgZHJpdmVycwojCiMgQ09ORklHX05PUF9VU0JfWENFSVYgaXMgbm90
IHNldAojIENPTkZJR19VU0JfR1BJT19WQlVTIGlzIG5vdCBzZXQKIyBDT05GSUdfVEFIVk9f
VVNCIGlzIG5vdCBzZXQKIyBDT05GSUdfVVNCX0lTUDEzMDEgaXMgbm90IHNldAojIGVuZCBv
ZiBVU0IgUGh5c2ljYWwgTGF5ZXIgZHJpdmVycwoKIyBDT05GSUdfVVNCX0dBREdFVCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1RZUEVDIGlzIG5vdCBzZXQKQ09ORklHX1VTQl9ST0xFX1NXSVRD
SD15CiMgQ09ORklHX1VTQl9ST0xFU19JTlRFTF9YSENJIGlzIG5vdCBzZXQKQ09ORklHX01N
Qz15CiMgQ09ORklHX01NQ19CTE9DSyBpcyBub3Qgc2V0CiMgQ09ORklHX1NESU9fVUFSVCBp
cyBub3Qgc2V0CiMgQ09ORklHX01NQ19URVNUIGlzIG5vdCBzZXQKQ09ORklHX01NQ19DUllQ
VE89eQoKIwojIE1NQy9TRC9TRElPIEhvc3QgQ29udHJvbGxlciBEcml2ZXJzCiMKIyBDT05G
SUdfTU1DX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1NESENJIGlzIG5vdCBzZXQK
IyBDT05GSUdfTU1DX1dCU0QgaXMgbm90IHNldAojIENPTkZJR19NTUNfVElGTV9TRCBpcyBu
b3Qgc2V0CiMgQ09ORklHX01NQ19TUEkgaXMgbm90IHNldAojIENPTkZJR19NTUNfQ0I3MTAg
aXMgbm90IHNldAojIENPTkZJR19NTUNfVklBX1NETU1DIGlzIG5vdCBzZXQKIyBDT05GSUdf
TU1DX1ZVQjMwMCBpcyBub3Qgc2V0CiMgQ09ORklHX01NQ19VU0hDIGlzIG5vdCBzZXQKIyBD
T05GSUdfTU1DX1VTREhJNlJPTDAgaXMgbm90IHNldAojIENPTkZJR19NTUNfQ1FIQ0kgaXMg
bm90IHNldAojIENPTkZJR19NTUNfSFNRIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX1RPU0hJ
QkFfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTU1DX01USyBpcyBub3Qgc2V0CiMgQ09ORklH
X1NDU0lfVUZTSENEIGlzIG5vdCBzZXQKIyBDT05GSUdfTUVNU1RJQ0sgaXMgbm90IHNldApD
T05GSUdfTkVXX0xFRFM9eQpDT05GSUdfTEVEU19DTEFTUz15CiMgQ09ORklHX0xFRFNfQ0xB
U1NfRkxBU0ggaXMgbm90IHNldAojIENPTkZJR19MRURTX0NMQVNTX01VTFRJQ09MT1IgaXMg
bm90IHNldApDT05GSUdfTEVEU19CUklHSFRORVNTX0hXX0NIQU5HRUQ9eQoKIwojIExFRCBk
cml2ZXJzCiMKIyBDT05GSUdfTEVEU184OFBNODYwWCBpcyBub3Qgc2V0CiMgQ09ORklHX0xF
RFNfQVBVIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19BVzIwMFhYIGlzIG5vdCBzZXQKIyBD
T05GSUdfTEVEU19DSFRfV0NPVkUgaXMgbm90IHNldAojIENPTkZJR19MRURTX0xNMzUzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTE0zNTMyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVE
U19MTTM2NDIgaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk1MzIgaXMgbm90IHNldAoj
IENPTkZJR19MRURTX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19MRURTX0xQMzk0NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0xFRFNfTFAzOTUyIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19M
UDg3ODggaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk1NVggaXMgbm90IHNldAojIENP
TkZJR19MRURTX1BDQTk2M1ggaXMgbm90IHNldAojIENPTkZJR19MRURTX1BDQTk5NVggaXMg
bm90IHNldAojIENPTkZJR19MRURTX1dNODMxWF9TVEFUVVMgaXMgbm90IHNldAojIENPTkZJ
R19MRURTX1dNODM1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfREE5MDNYIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVEU19EQTkwNTIgaXMgbm90IHNldAojIENPTkZJR19MRURTX0RBQzEy
NFMwODUgaXMgbm90IHNldAojIENPTkZJR19MRURTX1BXTSBpcyBub3Qgc2V0CiMgQ09ORklH
X0xFRFNfUkVHVUxBVE9SIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19CRDI2MDZNVlYgaXMg
bm90IHNldAojIENPTkZJR19MRURTX0JEMjgwMiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNf
SU5URUxfU1M0MjAwIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MVDM1OTMgaXMgbm90IHNl
dAojIENPTkZJR19MRURTX0FEUDU1MjAgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RDQTY1
MDcgaXMgbm90IHNldAojIENPTkZJR19MRURTX1RMQzU5MVhYIGlzIG5vdCBzZXQKIyBDT05G
SUdfTEVEU19NQVg4OTk3IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19MTTM1NXggaXMgbm90
IHNldAojIENPTkZJR19MRURTX01FTkYyMUJNQyBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNf
SVMzMUZMMzE5WCBpcyBub3Qgc2V0CgojCiMgTEVEIGRyaXZlciBmb3IgYmxpbmsoMSkgVVNC
IFJHQiBMRUQgaXMgdW5kZXIgU3BlY2lhbCBISUQgZHJpdmVycyAoSElEX1RISU5HTSkKIwoj
IENPTkZJR19MRURTX0JMSU5LTSBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTUxYQ1BMRCBp
cyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfTUxYUkVHIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVE
U19VU0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19OSUM3OEJYIGlzIG5vdCBzZXQKIyBD
T05GSUdfTEVEU19TUElfQllURSBpcyBub3Qgc2V0CgojCiMgRmxhc2ggYW5kIFRvcmNoIExF
RCBkcml2ZXJzCiMKCiMKIyBSR0IgTEVEIGRyaXZlcnMKIwoKIwojIExFRCBUcmlnZ2Vycwoj
CkNPTkZJR19MRURTX1RSSUdHRVJTPXkKIyBDT05GSUdfTEVEU19UUklHR0VSX1RJTUVSIGlz
IG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX09ORVNIT1QgaXMgbm90IHNldApDT05G
SUdfTEVEU19UUklHR0VSX0RJU0s9eQojIENPTkZJR19MRURTX1RSSUdHRVJfSEVBUlRCRUFU
IGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX0JBQ0tMSUdIVCBpcyBub3Qgc2V0
CkNPTkZJR19MRURTX1RSSUdHRVJfQ1BVPXkKIyBDT05GSUdfTEVEU19UUklHR0VSX0FDVElW
SVRZIGlzIG5vdCBzZXQKIyBDT05GSUdfTEVEU19UUklHR0VSX0dQSU8gaXMgbm90IHNldAoj
IENPTkZJR19MRURTX1RSSUdHRVJfREVGQVVMVF9PTiBpcyBub3Qgc2V0CgojCiMgaXB0YWJs
ZXMgdHJpZ2dlciBpcyB1bmRlciBOZXRmaWx0ZXIgY29uZmlnIChMRUQgdGFyZ2V0KQojCiMg
Q09ORklHX0xFRFNfVFJJR0dFUl9UUkFOU0lFTlQgaXMgbm90IHNldAojIENPTkZJR19MRURT
X1RSSUdHRVJfQ0FNRVJBIGlzIG5vdCBzZXQKQ09ORklHX0xFRFNfVFJJR0dFUl9QQU5JQz15
CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9ORVRERVYgaXMgbm90IHNldAojIENPTkZJR19MRURT
X1RSSUdHRVJfUEFUVEVSTiBpcyBub3Qgc2V0CiMgQ09ORklHX0xFRFNfVFJJR0dFUl9UVFkg
aXMgbm90IHNldAojIENPTkZJR19MRURTX1RSSUdHRVJfSU5QVVRfRVZFTlRTIGlzIG5vdCBz
ZXQKCiMKIyBTaW1hdGljIExFRCBkcml2ZXJzCiMKIyBDT05GSUdfQUNDRVNTSUJJTElUWSBp
cyBub3Qgc2V0CiMgQ09ORklHX0lORklOSUJBTkQgaXMgbm90IHNldApDT05GSUdfRURBQ19B
VE9NSUNfU0NSVUI9eQpDT05GSUdfRURBQ19TVVBQT1JUPXkKQ09ORklHX0VEQUM9eQojIENP
TkZJR19FREFDX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0VEQUNfREVDT0RFX01DRT1tCkNP
TkZJR19FREFDX0dIRVM9eQojIENPTkZJR19FREFDX1NDUlVCIGlzIG5vdCBzZXQKIyBDT05G
SUdfRURBQ19FQ1MgaXMgbm90IHNldAojIENPTkZJR19FREFDX01FTV9SRVBBSVIgaXMgbm90
IHNldApDT05GSUdfRURBQ19BTUQ2ND1tCiMgQ09ORklHX0VEQUNfRTc1MlggaXMgbm90IHNl
dAojIENPTkZJR19FREFDX0k4Mjk3NVggaXMgbm90IHNldAojIENPTkZJR19FREFDX0kzMDAw
IGlzIG5vdCBzZXQKIyBDT05GSUdfRURBQ19JMzIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VE
QUNfSUUzMTIwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfWDM4IGlzIG5vdCBzZXQKIyBD
T05GSUdfRURBQ19JNTQwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfSTdDT1JFIGlzIG5v
dCBzZXQKIyBDT05GSUdfRURBQ19JNTEwMCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfSTcz
MDAgaXMgbm90IHNldAojIENPTkZJR19FREFDX1NCUklER0UgaXMgbm90IHNldAojIENPTkZJ
R19FREFDX1NLWCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfSTEwTk0gaXMgbm90IHNldAoj
IENPTkZJR19FREFDX0lNSCBpcyBub3Qgc2V0CiMgQ09ORklHX0VEQUNfUE5EMiBpcyBub3Qg
c2V0CiMgQ09ORklHX0VEQUNfSUdFTjYgaXMgbm90IHNldApDT05GSUdfUlRDX0xJQj15CkNP
TkZJR19SVENfTUMxNDY4MThfTElCPXkKQ09ORklHX1JUQ19DTEFTUz15CkNPTkZJR19SVENf
SENUT1NZUz15CkNPTkZJR19SVENfSENUT1NZU19ERVZJQ0U9InJ0YzAiCkNPTkZJR19SVENf
U1lTVE9IQz15CkNPTkZJR19SVENfU1lTVE9IQ19ERVZJQ0U9InJ0YzAiCiMgQ09ORklHX1JU
Q19ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19SVENfTlZNRU09eQoKIwojIFJUQyBpbnRlcmZh
Y2VzCiMKQ09ORklHX1JUQ19JTlRGX1NZU0ZTPXkKQ09ORklHX1JUQ19JTlRGX1BST0M9eQpD
T05GSUdfUlRDX0lOVEZfREVWPXkKIyBDT05GSUdfUlRDX0lOVEZfREVWX1VJRV9FTVVMIGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9URVNUIGlzIG5vdCBzZXQKCiMKIyBJMkMgUlRD
IGRyaXZlcnMKIwojIENPTkZJR19SVENfRFJWXzg4UE04NjBYIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9BQkI1WkVTMyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfQUJFT1o5
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9BQlg4MFggaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RTMTMwNyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzc0IGlz
IG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE2NzIgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX0xQODc4OCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYNjkwMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYODkyNSBpcyBub3Qgc2V0CiMgQ09ORklHX1JU
Q19EUlZfTUFYODk5OCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYODk5NyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfTUFYMzEzMzUgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX05WSURJQV9WUlMxMCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlM1QzM3
MiBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfSVNMMTIwOCBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfSVNMMTIwMjIgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1gxMjA1
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4NTIzIGlzIG5vdCBzZXQKIyBDT05G
SUdfUlRDX0RSVl9QQ0Y4NTM2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU2
MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUENGODU4MyBpcyBub3Qgc2V0CiMgQ09O
RklHX1JUQ19EUlZfTTQxVDgwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9CUTMySyBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUEFMTUFTIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9UUFM2NTg2WCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfVFBTNjU5MTAg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JDNVQ1ODMgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX1MzNTM5MEEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0ZNMzEzMCBp
cyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4MDEwIGlzIG5vdCBzZXQKIyBDT05GSUdf
UlRDX0RSVl9SWDgxMTEgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JYODU4MSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlg4MDI1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9FTTMwMjcgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1JWMzAyOCBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfUlYzMDMyIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9SVjg4MDMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX1NEMjQwNUFMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUlRDX0RSVl9TRDMwNzggaXMgbm90IHNldAoKIwojIFNQSSBSVEMgZHJp
dmVycwojCiMgQ09ORklHX1JUQ19EUlZfTTQxVDkzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRD
X0RSVl9NNDFUOTQgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTMwMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1JUQ19EUlZfRFMxMzA1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RS
Vl9EUzEzNDMgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTM0NyBpcyBub3Qgc2V0
CiMgQ09ORklHX1JUQ19EUlZfRFMxMzkwIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9N
QVg2OTE2IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SOTcwMSBpcyBub3Qgc2V0CiMg
Q09ORklHX1JUQ19EUlZfUlg0NTgxIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9SUzVD
MzQ4IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NQVg2OTAyIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9QQ0YyMTIzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NQ1A3
OTUgaXMgbm90IHNldApDT05GSUdfUlRDX0kyQ19BTkRfU1BJPXkKCiMKIyBTUEkgYW5kIEky
QyBSVEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZfRFMzMjMyIGlzIG5vdCBzZXQKIyBD
T05GSUdfUlRDX0RSVl9QQ0YyMTI3IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9QQ0Y4
NTA2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfUlYzMDI5QzIgaXMgbm90IHNldAoj
IENPTkZJR19SVENfRFJWX1JYNjExMCBpcyBub3Qgc2V0CgojCiMgUGxhdGZvcm0gUlRDIGRy
aXZlcnMKIwpDT05GSUdfUlRDX0RSVl9DTU9TPXkKIyBDT05GSUdfUlRDX0RSVl9EUzEyODYg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0RTMTUxMSBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfRFMxNTUzIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE2ODVfRkFN
SUxZIGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EUzE3NDIgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX0RTMjQwNCBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfREE5MDUy
IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9EQTkwNTUgaXMgbm90IHNldAojIENPTkZJ
R19SVENfRFJWX0RBOTA2MyBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfU1RLMTdUQTgg
aXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX000OFQ4NiBpcyBub3Qgc2V0CiMgQ09ORklH
X1JUQ19EUlZfTTQ4VDM1IGlzIG5vdCBzZXQKIyBDT05GSUdfUlRDX0RSVl9NNDhUNTkgaXMg
bm90IHNldAojIENPTkZJR19SVENfRFJWX01TTTYyNDIgaXMgbm90IHNldAojIENPTkZJR19S
VENfRFJWX1JQNUMwMSBpcyBub3Qgc2V0CiMgQ09ORklHX1JUQ19EUlZfV004MzFYIGlzIG5v
dCBzZXQKIyBDT05GSUdfUlRDX0RSVl9XTTgzNTAgaXMgbm90IHNldAoKIwojIG9uLUNQVSBS
VEMgZHJpdmVycwojCiMgQ09ORklHX1JUQ19EUlZfRlRSVEMwMTAgaXMgbm90IHNldAojIENP
TkZJR19SVENfRFJWX1BDQVAgaXMgbm90IHNldAojIENPTkZJR19SVENfRFJWX0dPTERGSVNI
IGlzIG5vdCBzZXQKCiMKIyBISUQgU2Vuc29yIFJUQyBkcml2ZXJzCiMKQ09ORklHX0RNQURF
VklDRVM9eQojIENPTkZJR19ETUFERVZJQ0VTX0RFQlVHIGlzIG5vdCBzZXQKCiMKIyBETUEg
RGV2aWNlcwojCkNPTkZJR19ETUFfRU5HSU5FPXkKQ09ORklHX0RNQV9WSVJUVUFMX0NIQU5O
RUxTPXkKQ09ORklHX0RNQV9BQ1BJPXkKIyBDT05GSUdfQUxURVJBX01TR0RNQSBpcyBub3Qg
c2V0CiMgQ09ORklHX0lOVEVMX0lETUE2NCBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX0lE
WEQgaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9JRFhEX0NPTVBBVCBpcyBub3Qgc2V0CiMg
Q09ORklHX0lOVEVMX0lPQVRETUEgaXMgbm90IHNldAojIENPTkZJR19QTFhfRE1BIGlzIG5v
dCBzZXQKIyBDT05GSUdfWElMSU5YX0RNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1hJTElOWF9Y
RE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfQU1EX0FFNERNQSBpcyBub3Qgc2V0CkNPTkZJR19B
TURfUFRETUE9bQojIENPTkZJR19BTURfUURNQSBpcyBub3Qgc2V0CiMgQ09ORklHX1FDT01f
SElETUFfTUdNVCBpcyBub3Qgc2V0CiMgQ09ORklHX1FDT01fSElETUEgaXMgbm90IHNldAoj
IENPTkZJR19EV19ETUFDIGlzIG5vdCBzZXQKIyBDT05GSUdfRFdfRE1BQ19QQ0kgaXMgbm90
IHNldAojIENPTkZJR19EV19FRE1BIGlzIG5vdCBzZXQKIyBDT05GSUdfU0ZfUERNQSBpcyBu
b3Qgc2V0CkNPTkZJR19JTlRFTF9MRE1BPXkKCiMKIyBETUEgQ2xpZW50cwojCkNPTkZJR19B
U1lOQ19UWF9ETUE9eQojIENPTkZJR19ETUFURVNUIGlzIG5vdCBzZXQKCiMKIyBETUFCVUYg
b3B0aW9ucwojCkNPTkZJR19TWU5DX0ZJTEU9eQpDT05GSUdfU1dfU1lOQz15CkNPTkZJR19V
RE1BQlVGPXkKIyBDT05GSUdfRE1BQlVGX01PVkVfTk9USUZZIGlzIG5vdCBzZXQKIyBDT05G
SUdfRE1BQlVGX0RFQlVHIGlzIG5vdCBzZXQKIyBDT05GSUdfRE1BQlVGX1NFTEZURVNUUyBp
cyBub3Qgc2V0CkNPTkZJR19ETUFCVUZfSEVBUFM9eQojIENPTkZJR19ETUFCVUZfU1lTRlNf
U1RBVFMgaXMgbm90IHNldApDT05GSUdfRE1BQlVGX0hFQVBTX1NZU1RFTT15CiMgZW5kIG9m
IERNQUJVRiBvcHRpb25zCgojIENPTkZJR19VSU8gaXMgbm90IHNldApDT05GSUdfVkZJTz15
CkNPTkZJR19WRklPX0dST1VQPXkKQ09ORklHX1ZGSU9fQ09OVEFJTkVSPXkKQ09ORklHX1ZG
SU9fSU9NTVVfVFlQRTE9eQpDT05GSUdfVkZJT19OT0lPTU1VPXkKQ09ORklHX1ZGSU9fVklS
UUZEPXkKIyBDT05GSUdfVkZJT19ERUJVR0ZTIGlzIG5vdCBzZXQKCiMKIyBWRklPIHN1cHBv
cnQgZm9yIFBDSSBkZXZpY2VzCiMKQ09ORklHX1ZGSU9fUENJX0NPUkU9eQpDT05GSUdfVkZJ
T19QQ0lfSU5UWD15CkNPTkZJR19WRklPX1BDST15CkNPTkZJR19WRklPX1BDSV9WR0E9eQpD
T05GSUdfVkZJT19QQ0lfSUdEPXkKIyBDT05GSUdfTUxYNV9WRklPX1BDSSBpcyBub3Qgc2V0
CiMgQ09ORklHX1ZJUlRJT19WRklPX1BDSSBpcyBub3Qgc2V0CiMgZW5kIG9mIFZGSU8gc3Vw
cG9ydCBmb3IgUENJIGRldmljZXMKCkNPTkZJR19JUlFfQllQQVNTX01BTkFHRVI9eQpDT05G
SUdfVklSVF9EUklWRVJTPXkKQ09ORklHX1ZNR0VOSUQ9eQojIENPTkZJR19WQk9YR1VFU1Qg
aXMgbm90IHNldAojIENPTkZJR19OSVRST19FTkNMQVZFUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0FDUk5fSFNNIGlzIG5vdCBzZXQKIyBDT05GSUdfRUZJX1NFQ1JFVCBpcyBub3Qgc2V0CkNP
TkZJR19TRVZfR1VFU1Q9bQpDT05GSUdfVFNNX0dVRVNUPXkKQ09ORklHX1RTTV9SRVBPUlRT
PW0KQ09ORklHX1ZJUlRJT19BTkNIT1I9eQpDT05GSUdfVklSVElPPXkKQ09ORklHX1ZJUlRJ
T19QQ0lfTElCPXkKQ09ORklHX1ZJUlRJT19QQ0lfTElCX0xFR0FDWT15CkNPTkZJR19WSVJU
SU9fTUVOVT15CkNPTkZJR19WSVJUSU9fUENJPXkKQ09ORklHX1ZJUlRJT19QQ0lfQURNSU5f
TEVHQUNZPXkKQ09ORklHX1ZJUlRJT19QQ0lfTEVHQUNZPXkKIyBDT05GSUdfVklSVElPX1BN
RU0gaXMgbm90IHNldApDT05GSUdfVklSVElPX0JBTExPT049eQojIENPTkZJR19WSVJUSU9f
TUVNIGlzIG5vdCBzZXQKIyBDT05GSUdfVklSVElPX0lOUFVUIGlzIG5vdCBzZXQKQ09ORklH
X1ZJUlRJT19NTUlPPXkKQ09ORklHX1ZJUlRJT19NTUlPX0NNRExJTkVfREVWSUNFUz15CiMg
Q09ORklHX1ZJUlRJT19ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRJT19SVEMgaXMg
bm90IHNldAojIENPTkZJR19WRFBBIGlzIG5vdCBzZXQKQ09ORklHX1ZIT1NUX0lPVExCPXkK
Q09ORklHX1ZIT1NUX1RBU0s9eQpDT05GSUdfVkhPU1Q9eQpDT05GSUdfVkhPU1RfTUVOVT15
CkNPTkZJR19WSE9TVF9ORVQ9eQojIENPTkZJR19WSE9TVF9DUk9TU19FTkRJQU5fTEVHQUNZ
IGlzIG5vdCBzZXQKQ09ORklHX1ZIT1NUX0VOQUJMRV9GT1JLX09XTkVSX0NPTlRST0w9eQoK
IwojIE1pY3Jvc29mdCBIeXBlci1WIGd1ZXN0IHN1cHBvcnQKIwojIENPTkZJR19IWVBFUlYg
aXMgbm90IHNldAojIGVuZCBvZiBNaWNyb3NvZnQgSHlwZXItViBndWVzdCBzdXBwb3J0Cgoj
CiMgWGVuIGRyaXZlciBzdXBwb3J0CiMKQ09ORklHX1hFTl9CQUxMT09OPXkKQ09ORklHX1hF
Tl9CQUxMT09OX01FTU9SWV9IT1RQTFVHPXkKQ09ORklHX1hFTl9NRU1PUllfSE9UUExVR19M
SU1JVD01MTIKQ09ORklHX1hFTl9TQ1JVQl9QQUdFU19ERUZBVUxUPXkKIyBDT05GSUdfWEVO
X0RFVl9FVlRDSE4gaXMgbm90IHNldApDT05GSUdfWEVOX0JBQ0tFTkQ9eQojIENPTkZJR19Y
RU5GUyBpcyBub3Qgc2V0CkNPTkZJR19YRU5fU1lTX0hZUEVSVklTT1I9eQpDT05GSUdfWEVO
X1hFTkJVU19GUk9OVEVORD15CiMgQ09ORklHX1hFTl9HTlRERVYgaXMgbm90IHNldAojIENP
TkZJR19YRU5fR1JBTlRfREVWX0FMTE9DIGlzIG5vdCBzZXQKQ09ORklHX1hFTl9HUkFOVF9E
TUFfQUxMT0M9eQpDT05GSUdfU1dJT1RMQl9YRU49eQojIENPTkZJR19YRU5fUENJREVWX0JB
Q0tFTkQgaXMgbm90IHNldAojIENPTkZJR19YRU5fUFZDQUxMU19GUk9OVEVORCBpcyBub3Qg
c2V0CiMgQ09ORklHX1hFTl9QVkNBTExTX0JBQ0tFTkQgaXMgbm90IHNldAojIENPTkZJR19Y
RU5fUFJJVkNNRCBpcyBub3Qgc2V0CkNPTkZJR19YRU5fQUNQSV9QUk9DRVNTT1I9eQpDT05G
SUdfWEVOX01DRV9MT0c9eQpDT05GSUdfWEVOX0hBVkVfUFZNTVU9eQpDT05GSUdfWEVOX0VG
ST15CkNPTkZJR19YRU5fQVVUT19YTEFURT15CkNPTkZJR19YRU5fQUNQST15CkNPTkZJR19Y
RU5fSEFWRV9WUE1VPXkKQ09ORklHX1hFTl9VTlBPUFVMQVRFRF9BTExPQz15CiMgQ09ORklH
X1hFTl9WSVJUSU8gaXMgbm90IHNldAojIGVuZCBvZiBYZW4gZHJpdmVyIHN1cHBvcnQKCiMg
Q09ORklHX0dSRVlCVVMgaXMgbm90IHNldApDT05GSUdfQ09NRURJPXkKIyBDT05GSUdfQ09N
RURJX0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9ERUZBVUxUX0JVRl9TSVpFX0tC
PTIwNDgKQ09ORklHX0NPTUVESV9ERUZBVUxUX0JVRl9NQVhTSVpFX0tCPTIwNDgwCiMgQ09O
RklHX0NPTUVESV9NSVNDX0RSSVZFUlMgaXMgbm90IHNldAojIENPTkZJR19DT01FRElfSVNB
X0RSSVZFUlMgaXMgbm90IHNldApDT05GSUdfQ09NRURJX1BDSV9EUklWRVJTPXkKIyBDT05G
SUdfQ09NRURJXzgyNTVfUENJIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9BRERJX1dBVENI
RE9HPXkKIyBDT05GSUdfQ09NRURJX0FERElfQVBDSV8xMDMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ09NRURJX0FERElfQVBDSV8xNTAwIGlzIG5vdCBzZXQKQ09ORklHX0NPTUVESV9BRERJ
X0FQQ0lfMTUxNj15CkNPTkZJR19DT01FRElfQURESV9BUENJXzE1NjQ9eQojIENPTkZJR19D
T01FRElfQURESV9BUENJXzE2WFggaXMgbm90IHNldApDT05GSUdfQ09NRURJX0FERElfQVBD
SV8yMDMyPXkKQ09ORklHX0NPTUVESV9BRERJX0FQQ0lfMjIwMD15CiMgQ09ORklHX0NPTUVE
SV9BRERJX0FQQ0lfMzEyMCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRERJX0FQQ0lf
MzUwMSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRERJX0FQQ0lfM1hYWCBpcyBub3Qg
c2V0CiMgQ09ORklHX0NPTUVESV9BRExfUENJNjIwOCBpcyBub3Qgc2V0CiMgQ09ORklHX0NP
TUVESV9BRExfUENJNzI1MCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRExfUENJN1gz
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRExfUENJODE2NCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NPTUVESV9BRExfUENJOTExMSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9B
RExfUENJOTExOCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRFZfUENJMTcxMCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRFZfUENJMTcyMCBpcyBub3Qgc2V0CiMgQ09ORklH
X0NPTUVESV9BRFZfUENJMTcyMyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRFZfUENJ
MTcyNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BRFZfUENJMTc2MCBpcyBub3Qgc2V0
CiMgQ09ORklHX0NPTUVESV9BRFZfUENJX0RJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVE
SV9BTVBMQ19ESU8yMDBfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX0FNUExDX1BD
MjM2X1BDSSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9BTVBMQ19QQzI2M19QQ0kgaXMg
bm90IHNldAojIENPTkZJR19DT01FRElfQU1QTENfUENJMjI0IGlzIG5vdCBzZXQKIyBDT05G
SUdfQ09NRURJX0FNUExDX1BDSTIzMCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9DT05U
RUNfUENJX0RJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9EQVMwOF9QQ0kgaXMgbm90
IHNldAojIENPTkZJR19DT01FRElfRFQzMDAwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJ
X0RZTkFfUENJMTBYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9HU0NfSFBESSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NPTUVESV9NRjZYNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVE
SV9JQ1BfTVVMVEkgaXMgbm90IHNldAojIENPTkZJR19DT01FRElfREFRQk9BUkQyMDAwIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX0pSM19QQ0kgaXMgbm90IHNldAojIENPTkZJR19D
T01FRElfS0VfQ09VTlRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9DQl9QQ0lEQVM2
NCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9DQl9QQ0lEQVMgaXMgbm90IHNldAojIENP
TkZJR19DT01FRElfQ0JfUENJRERBIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX0NCX1BD
SU1EQVMgaXMgbm90IHNldAojIENPTkZJR19DT01FRElfQ0JfUENJTUREQSBpcyBub3Qgc2V0
CiMgQ09ORklHX0NPTUVESV9NRTQwMDAgaXMgbm90IHNldAojIENPTkZJR19DT01FRElfTUVf
REFRIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX05JXzY1MjcgaXMgbm90IHNldAojIENP
TkZJR19DT01FRElfTklfNjVYWCBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9OSV82NjBY
IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX05JXzY3MFggaXMgbm90IHNldAojIENPTkZJ
R19DT01FRElfTklfTEFCUENfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX05JX1BD
SURJTyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9OSV9QQ0lNSU8gaXMgbm90IHNldAoj
IENPTkZJR19DT01FRElfUlRENTIwIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX1M2MjYg
aXMgbm90IHNldAojIENPTkZJR19DT01FRElfVVNCX0RSSVZFUlMgaXMgbm90IHNldAojIENP
TkZJR19DT01FRElfODI1NV9TQSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTUVESV9LQ09NRURJ
TElCIGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NRURJX1RFU1RTIGlzIG5vdCBzZXQKIyBDT05G
SUdfR1BJQiBpcyBub3Qgc2V0CkNPTkZJR19TVEFHSU5HPXkKIyBDT05GSUdfRkJfU003NTAg
aXMgbm90IHNldApDT05GSUdfU1RBR0lOR19NRURJQT15CiMgQ09ORklHX0ZCX1RGVCBpcyBu
b3Qgc2V0CkNPTkZJR19WTUVfQlVTPXkKCiMKIyBWTUUgQnJpZGdlIERyaXZlcnMKIwojIENP
TkZJR19WTUVfVFNJMTQ4IGlzIG5vdCBzZXQKIyBDT05GSUdfVk1FX0ZBS0UgaXMgbm90IHNl
dAoKIwojIFZNRSBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX1ZNRV9VU0VSIGlzIG5vdCBz
ZXQKIyBDT05GSUdfR09MREZJU0ggaXMgbm90IHNldApDT05GSUdfQ0hST01FX1BMQVRGT1JN
Uz15CiMgQ09ORklHX0NIUk9NRU9TX0FDUEkgaXMgbm90IHNldAojIENPTkZJR19DSFJPTUVP
U19MQVBUT1AgaXMgbm90IHNldAojIENPTkZJR19DSFJPTUVPU19QU1RPUkUgaXMgbm90IHNl
dAojIENPTkZJR19DSFJPTUVPU19UQk1DIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JPU19FQyBp
cyBub3Qgc2V0CiMgQ09ORklHX0NST1NfS0JEX0xFRF9CQUNLTElHSFQgaXMgbm90IHNldAoj
IENPTkZJR19DUk9TX0hQU19JMkMgaXMgbm90IHNldAojIENPTkZJR19DSFJPTUVPU19QUklW
QUNZX1NDUkVFTiBpcyBub3Qgc2V0CkNPTkZJR19NRUxMQU5PWF9QTEFURk9STT15CiMgQ09O
RklHX01MWF9QTEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklHX01MWFJFR19EUFUgaXMgbm90
IHNldAojIENPTkZJR19NTFhSRUdfSE9UUExVRyBpcyBub3Qgc2V0CiMgQ09ORklHX01MWFJF
R19JTyBpcyBub3Qgc2V0CiMgQ09ORklHX01MWFJFR19MQyBpcyBub3Qgc2V0CiMgQ09ORklH
X05WU1dfU04yMjAxIGlzIG5vdCBzZXQKQ09ORklHX1NVUkZBQ0VfUExBVEZPUk1TPXkKIyBD
T05GSUdfU1VSRkFDRTNfV01JIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VSRkFDRV8zX1BPV0VS
X09QUkVHSU9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VSRkFDRV9HUEUgaXMgbm90IHNldAoj
IENPTkZJR19TVVJGQUNFX0hPVFBMVUcgaXMgbm90IHNldAojIENPTkZJR19TVVJGQUNFX1BS
TzNfQlVUVE9OIGlzIG5vdCBzZXQKIyBDT05GSUdfU1VSRkFDRV9BR0dSRUdBVE9SIGlzIG5v
dCBzZXQKQ09ORklHX1g4Nl9QTEFURk9STV9ERVZJQ0VTPXkKQ09ORklHX1dNSV9CTU9GPW0K
IyBDT05GSUdfSFVBV0VJX1dNSSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QTEFURk9STV9E
UklWRVJTX1VOSVdJTEwgaXMgbm90IHNldAojIENPTkZJR19VVl9TWVNGUyBpcyBub3Qgc2V0
CiMgQ09ORklHX01YTV9XTUkgaXMgbm90IHNldAojIENPTkZJR19YSUFPTUlfV01JIGlzIG5v
dCBzZXQKIyBDT05GSUdfUkVETUlfV01JIGlzIG5vdCBzZXQKIyBDT05GSUdfR0lHQUJZVEVf
V01JIGlzIG5vdCBzZXQKIyBDT05GSUdfQUNFUkhERiBpcyBub3Qgc2V0CiMgQ09ORklHX0FD
RVJfV0lSRUxFU1MgaXMgbm90IHNldAojIENPTkZJR19BQ0VSX1dNSSBpcyBub3Qgc2V0Cgoj
CiMgQU1EIEhTTVAgRHJpdmVyCiMKIyBDT05GSUdfQU1EX0hTTVBfQUNQSSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FNRF9IU01QX1BMQVQgaXMgbm90IHNldAojIGVuZCBvZiBBTUQgSFNNUCBE
cml2ZXIKCiMgQ09ORklHX0FNRF9QTUMgaXMgbm90IHNldAojIENPTkZJR19BTURfSEZJIGlz
IG5vdCBzZXQKIyBDT05GSUdfQU1EXzNEX1ZDQUNIRSBpcyBub3Qgc2V0CiMgQ09ORklHX0FN
RF9XQlJGIGlzIG5vdCBzZXQKIyBDT05GSUdfQU1EX0lTUF9QTEFURk9STSBpcyBub3Qgc2V0
CiMgQ09ORklHX0FEVl9TV0JVVFRPTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FQUExFX0dNVVgg
aXMgbm90IHNldAojIENPTkZJR19BU1VTX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX0FT
VVNfV0lSRUxFU1MgaXMgbm90IHNldAojIENPTkZJR19BU1VTX1dNSSBpcyBub3Qgc2V0CiMg
Q09ORklHX0FTVVNfVEYxMDNDX0RPQ0sgaXMgbm90IHNldAojIENPTkZJR19BWUFORU9fRUMg
aXMgbm90IHNldAojIENPTkZJR19FRUVQQ19MQVBUT1AgaXMgbm90IHNldApDT05GSUdfWDg2
X1BMQVRGT1JNX0RSSVZFUlNfREVMTD15CiMgQ09ORklHX0FMSUVOV0FSRV9XTUkgaXMgbm90
IHNldApDT05GSUdfRENEQkFTPW0KIyBDT05GSUdfREVMTF9MQVBUT1AgaXMgbm90IHNldAoj
IENPTkZJR19ERUxMX1JCVSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFTExfUkJUTiBpcyBub3Qg
c2V0CkNPTkZJR19ERUxMX1BDPW0KQ09ORklHX0RFTExfU01CSU9TPW0KQ09ORklHX0RFTExf
U01CSU9TX1dNST15CkNPTkZJR19ERUxMX1NNQklPU19TTU09eQojIENPTkZJR19ERUxMX1NN
Tzg4MDAgaXMgbm90IHNldAojIENPTkZJR19ERUxMX1dNSSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFTExfV01JX0FJTyBpcyBub3Qgc2V0CkNPTkZJR19ERUxMX1dNSV9ERVNDUklQVE9SPW0K
Q09ORklHX0RFTExfV01JX0REVj1tCiMgQ09ORklHX0RFTExfV01JX0xFRCBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFTExfV01JX1NZU01BTiBpcyBub3Qgc2V0CiMgQ09ORklHX0FNSUxPX1JG
S0lMTCBpcyBub3Qgc2V0CiMgQ09ORklHX0ZVSklUU1VfTEFQVE9QIGlzIG5vdCBzZXQKIyBD
T05GSUdfRlVKSVRTVV9UQUJMRVQgaXMgbm90IHNldAojIENPTkZJR19HUERfUE9DS0VUX0ZB
TiBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9QTEFURk9STV9EUklWRVJTX0hQIGlzIG5vdCBz
ZXQKIyBDT05GSUdfV0lSRUxFU1NfSE9US0VZIGlzIG5vdCBzZXQKIyBDT05GSUdfSUJNX1JU
TCBpcyBub3Qgc2V0CiMgQ09ORklHX1NFTlNPUlNfSERBUFMgaXMgbm90IHNldAojIENPTkZJ
R19JTlRFTF9BVE9NSVNQMl9QTSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX0lGUyBpcyBu
b3Qgc2V0CiMgQ09ORklHX0lOVEVMX1NBUl9JTlQxMDkyIGlzIG5vdCBzZXQKIyBDT05GSUdf
SU5URUxfU0tMX0lOVDM0NzIgaXMgbm90IHNldAoKIwojIEludGVsIFNwZWVkIFNlbGVjdCBU
ZWNobm9sb2d5IGludGVyZmFjZSBzdXBwb3J0CiMKIyBDT05GSUdfSU5URUxfU1BFRURfU0VM
RUNUX0lOVEVSRkFDRSBpcyBub3Qgc2V0CiMgZW5kIG9mIEludGVsIFNwZWVkIFNlbGVjdCBU
ZWNobm9sb2d5IGludGVyZmFjZSBzdXBwb3J0CgojIENPTkZJR19JTlRFTF9XTUlfU0JMX0ZX
X1VQREFURSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX1dNSV9USFVOREVSQk9MVCBpcyBu
b3Qgc2V0CgojCiMgSW50ZWwgVW5jb3JlIEZyZXF1ZW5jeSBDb250cm9sCiMKIyBDT05GSUdf
SU5URUxfVU5DT1JFX0ZSRVFfQ09OVFJPTCBpcyBub3Qgc2V0CiMgZW5kIG9mIEludGVsIFVu
Y29yZSBGcmVxdWVuY3kgQ29udHJvbAoKIyBDT05GSUdfSU5URUxfSElEX0VWRU5UIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5URUxfVkJUTiBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX0VI
TF9QU0VfSU8gaXMgbm90IHNldAojIENPTkZJR19JTlRFTF9JTlQwMDAyX1ZHUElPIGlzIG5v
dCBzZXQKIyBDT05GSUdfSU5URUxfT0FLVFJBSUwgaXMgbm90IHNldAojIENPTkZJR19JTlRF
TF9CWVRDUkNfUFdSU1JDIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxfUFVOSVRfSVBDIGlz
IG5vdCBzZXQKIyBDT05GSUdfSU5URUxfUlNUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxf
U01BUlRDT05ORUNUIGlzIG5vdCBzZXQKQ09ORklHX0lOVEVMX1RVUkJPX01BWF8zPXkKIyBD
T05GSUdfSU5URUxfVlNFQyBpcyBub3Qgc2V0CiMgQ09ORklHX0lERUFQQURfTEFQVE9QIGlz
IG5vdCBzZXQKIyBDT05GSUdfTEVOT1ZPX1dNSV9IT1RLRVlfVVRJTElUSUVTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTEVOT1ZPX1dNSV9DQU1FUkEgaXMgbm90IHNldAojIENPTkZJR19USElO
S1BBRF9BQ1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfVEhJTktQQURfTE1JIGlzIG5vdCBzZXQK
IyBDT05GSUdfWU9HQUJPT0sgaXMgbm90IHNldAojIENPTkZJR19ZVDJfMTM4MCBpcyBub3Qg
c2V0CiMgQ09ORklHX0xFTk9WT19XTUlfR0FNRVpPTkUgaXMgbm90IHNldAojIENPTkZJR19M
RU5PVk9fV01JX1RVTklORyBpcyBub3Qgc2V0CiMgQ09ORklHX0FDUElfUVVJQ0tTVEFSVCBp
cyBub3Qgc2V0CiMgQ09ORklHX01FRUdPUEFEX0FOWDc0MjggaXMgbm90IHNldAojIENPTkZJ
R19NU0lfRUMgaXMgbm90IHNldAojIENPTkZJR19NU0lfTEFQVE9QIGlzIG5vdCBzZXQKIyBD
T05GSUdfTVNJX1dNSSBpcyBub3Qgc2V0CiMgQ09ORklHX01TSV9XTUlfUExBVEZPUk0gaXMg
bm90IHNldAojIENPTkZJR19QQ0VOR0lORVNfQVBVMiBpcyBub3Qgc2V0CiMgQ09ORklHX1BP
UlRXRUxMX0VDIGlzIG5vdCBzZXQKIyBDT05GSUdfQkFSQ09fUDUwX0dQSU8gaXMgbm90IHNl
dAojIENPTkZJR19TQU1TVU5HX0dBTEFYWUJPT0sgaXMgbm90IHNldAojIENPTkZJR19TQU1T
VU5HX0xBUFRPUCBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVNVTkdfUTEwIGlzIG5vdCBzZXQK
IyBDT05GSUdfVE9TSElCQV9CVF9SRktJTEwgaXMgbm90IHNldAojIENPTkZJR19UT1NISUJB
X0hBUFMgaXMgbm90IHNldAojIENPTkZJR19UT1NISUJBX1dNSSBpcyBub3Qgc2V0CiMgQ09O
RklHX0FDUElfQ01QQyBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTVBBTF9MQVBUT1AgaXMgbm90
IHNldAojIENPTkZJR19MR19MQVBUT1AgaXMgbm90IHNldAojIENPTkZJR19QQU5BU09OSUNf
TEFQVE9QIGlzIG5vdCBzZXQKIyBDT05GSUdfU09OWV9MQVBUT1AgaXMgbm90IHNldAojIENP
TkZJR19TWVNURU03Nl9BQ1BJIGlzIG5vdCBzZXQKIyBDT05GSUdfVE9QU1RBUl9MQVBUT1Ag
aXMgbm90IHNldAojIENPTkZJR19TRVJJQUxfTVVMVElfSU5TVEFOVElBVEUgaXMgbm90IHNl
dAojIENPTkZJR19JTlNQVVJfUExBVEZPUk1fUFJPRklMRSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RBU0hBUk9fQUNQSSBpcyBub3Qgc2V0CiMgQ09ORklHX1g4Nl9BTkRST0lEX1RBQkxFVFMg
aXMgbm90IHNldAojIENPTkZJR19JTlRFTF9JUFMgaXMgbm90IHNldApDT05GSUdfSU5URUxf
U0NVX0lQQz15CkNPTkZJR19JTlRFTF9TQ1U9eQpDT05GSUdfSU5URUxfU0NVX1BDST15CiMg
Q09ORklHX0lOVEVMX1NDVV9QTEFURk9STSBpcyBub3Qgc2V0CiMgQ09ORklHX0lOVEVMX1ND
VV9JUENfVVRJTCBpcyBub3Qgc2V0CiMgQ09ORklHX1NJRU1FTlNfU0lNQVRJQ19JUEMgaXMg
bm90IHNldAojIENPTkZJR19XSU5NQVRFX0ZNMDdfS0VZUyBpcyBub3Qgc2V0CiMgQ09ORklH
X09YUF9FQyBpcyBub3Qgc2V0CiMgQ09ORklHX1RVWEVET19OQjA0X1dNSV9BQiBpcyBub3Qg
c2V0CkNPTkZJR19BQ1BJX1dNST1tCiMgQ09ORklHX0FDUElfV01JX0xFR0FDWV9ERVZJQ0Vf
TkFNRVMgaXMgbm90IHNldApDT05GSUdfSEFWRV9DTEs9eQpDT05GSUdfSEFWRV9DTEtfUFJF
UEFSRT15CkNPTkZJR19DT01NT05fQ0xLPXkKIyBDT05GSUdfQ09NTU9OX0NMS19XTTgzMVgg
aXMgbm90IHNldAojIENPTkZJR19MTUswNDgzMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1P
Tl9DTEtfTUFYOTQ4NSBpcyBub3Qgc2V0CiMgQ09ORklHX0NPTU1PTl9DTEtfU0k1MzQxIGlz
IG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19TSTUzNTEgaXMgbm90IHNldAojIENPTkZJ
R19DT01NT05fQ0xLX1NJNTQ0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19DRENF
NzA2IGlzIG5vdCBzZXQKIyBDT05GSUdfQ09NTU9OX0NMS19DUzIwMDBfQ1AgaXMgbm90IHNl
dAojIENPTkZJR19DTEtfVFdMIGlzIG5vdCBzZXQKIyBDT05GSUdfQ0xLX1RXTDYwNDAgaXMg
bm90IHNldAojIENPTkZJR19DT01NT05fQ0xLX1BBTE1BUyBpcyBub3Qgc2V0CiMgQ09ORklH
X0NPTU1PTl9DTEtfUFdNIGlzIG5vdCBzZXQKIyBDT05GSUdfWElMSU5YX1ZDVSBpcyBub3Qg
c2V0CkNPTkZJR19IV1NQSU5MT0NLPXkKCiMKIyBDbG9jayBTb3VyY2UgZHJpdmVycwojCkNP
TkZJR19DTEtFVlRfSTgyNTM9eQpDT05GSUdfSTgyNTNfTE9DSz15CkNPTkZJR19DTEtCTERf
STgyNTM9eQojIGVuZCBvZiBDbG9jayBTb3VyY2UgZHJpdmVycwoKQ09ORklHX01BSUxCT1g9
eQpDT05GSUdfUENDPXkKIyBDT05GSUdfQUxURVJBX01CT1ggaXMgbm90IHNldApDT05GSUdf
SU9NTVVfSU9WQT15CkNPTkZJR19JT01NVV9BUEk9eQpDT05GSUdfSU9NTVVfU1VQUE9SVD15
CgojCiMgR2VuZXJpYyBJT01NVSBQYWdldGFibGUgU3VwcG9ydAojCiMgZW5kIG9mIEdlbmVy
aWMgSU9NTVUgUGFnZXRhYmxlIFN1cHBvcnQKCiMgQ09ORklHX0lPTU1VX0RFQlVHRlMgaXMg
bm90IHNldAojIENPTkZJR19JT01NVV9ERUZBVUxUX0RNQV9TVFJJQ1QgaXMgbm90IHNldApD
T05GSUdfSU9NTVVfREVGQVVMVF9ETUFfTEFaWT15CiMgQ09ORklHX0lPTU1VX0RFRkFVTFRf
UEFTU1RIUk9VR0ggaXMgbm90IHNldApDT05GSUdfSU9NTVVfRE1BPXkKQ09ORklHX0lPTU1V
X1NWQT15CkNPTkZJR19JT01NVV9JT1BGPXkKQ09ORklHX0FNRF9JT01NVT15CkNPTkZJR19E
TUFSX1RBQkxFPXkKQ09ORklHX0lOVEVMX0lPTU1VPXkKQ09ORklHX0lOVEVMX0lPTU1VX1NW
TT15CkNPTkZJR19JTlRFTF9JT01NVV9ERUZBVUxUX09OPXkKQ09ORklHX0lOVEVMX0lPTU1V
X1NDQUxBQkxFX01PREVfREVGQVVMVF9PTj15CkNPTkZJR19JTlRFTF9JT01NVV9QRVJGX0VW
RU5UUz15CiMgQ09ORklHX0lPTU1VRkQgaXMgbm90IHNldApDT05GSUdfSVJRX1JFTUFQPXkK
Q09ORklHX1ZJUlRJT19JT01NVT15CkNPTkZJR19HRU5FUklDX1BUPXkKIyBDT05GSUdfREVC
VUdfR0VORVJJQ19QVCBpcyBub3Qgc2V0CkNPTkZJR19JT01NVV9QVD15CkNPTkZJR19JT01N
VV9QVF9BTURWMT15CkNPTkZJR19JT01NVV9QVF9WVERTUz15CkNPTkZJR19JT01NVV9QVF9Y
ODZfNjQ9eQoKIwojIFJlbW90ZXByb2MgZHJpdmVycwojCkNPTkZJR19SRU1PVEVQUk9DPXkK
Q09ORklHX1JFTU9URVBST0NfQ0RFVj15CiMgZW5kIG9mIFJlbW90ZXByb2MgZHJpdmVycwoK
IwojIFJwbXNnIGRyaXZlcnMKIwojIENPTkZJR19SUE1TR19RQ09NX0dMSU5LX1JQTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX1JQTVNHX1ZJUlRJTyBpcyBub3Qgc2V0CiMgZW5kIG9mIFJwbXNn
IGRyaXZlcnMKCiMKIyBTT0MgKFN5c3RlbSBPbiBDaGlwKSBzcGVjaWZpYyBEcml2ZXJzCiMK
CiMKIyBBbWxvZ2ljIFNvQyBkcml2ZXJzCiMKIyBlbmQgb2YgQW1sb2dpYyBTb0MgZHJpdmVy
cwoKIwojIEJyb2FkY29tIFNvQyBkcml2ZXJzCiMKIyBlbmQgb2YgQnJvYWRjb20gU29DIGRy
aXZlcnMKCiMKIyBOWFAvRnJlZXNjYWxlIFFvcklRIFNvQyBkcml2ZXJzCiMKIyBlbmQgb2Yg
TlhQL0ZyZWVzY2FsZSBRb3JJUSBTb0MgZHJpdmVycwoKIwojIGZ1aml0c3UgU29DIGRyaXZl
cnMKIwojIGVuZCBvZiBmdWppdHN1IFNvQyBkcml2ZXJzCgojCiMgaS5NWCBTb0MgZHJpdmVy
cwojCiMgZW5kIG9mIGkuTVggU29DIGRyaXZlcnMKCiMKIyBFbmFibGUgTGl0ZVggU29DIEJ1
aWxkZXIgc3BlY2lmaWMgZHJpdmVycwojCiMgZW5kIG9mIEVuYWJsZSBMaXRlWCBTb0MgQnVp
bGRlciBzcGVjaWZpYyBkcml2ZXJzCgojIENPTkZJR19XUENNNDUwX1NPQyBpcyBub3Qgc2V0
CgojCiMgUXVhbGNvbW0gU29DIGRyaXZlcnMKIwojIGVuZCBvZiBRdWFsY29tbSBTb0MgZHJp
dmVycwoKQ09ORklHX1NPQ19UST15CgojCiMgWGlsaW54IFNvQyBkcml2ZXJzCiMKIyBlbmQg
b2YgWGlsaW54IFNvQyBkcml2ZXJzCiMgZW5kIG9mIFNPQyAoU3lzdGVtIE9uIENoaXApIHNw
ZWNpZmljIERyaXZlcnMKCiMKIyBQTSBEb21haW5zCiMKCiMKIyBBbWxvZ2ljIFBNIERvbWFp
bnMKIwojIGVuZCBvZiBBbWxvZ2ljIFBNIERvbWFpbnMKCiMKIyBCcm9hZGNvbSBQTSBEb21h
aW5zCiMKIyBlbmQgb2YgQnJvYWRjb20gUE0gRG9tYWlucwoKIwojIGkuTVggUE0gRG9tYWlu
cwojCiMgZW5kIG9mIGkuTVggUE0gRG9tYWlucwoKIwojIFF1YWxjb21tIFBNIERvbWFpbnMK
IwojIGVuZCBvZiBRdWFsY29tbSBQTSBEb21haW5zCiMgZW5kIG9mIFBNIERvbWFpbnMKCkNP
TkZJR19QTV9ERVZGUkVRPXkKCiMKIyBERVZGUkVRIEdvdmVybm9ycwojCkNPTkZJR19ERVZG
UkVRX0dPVl9TSU1QTEVfT05ERU1BTkQ9eQpDT05GSUdfREVWRlJFUV9HT1ZfUEVSRk9STUFO
Q0U9eQpDT05GSUdfREVWRlJFUV9HT1ZfUE9XRVJTQVZFPXkKQ09ORklHX0RFVkZSRVFfR09W
X1VTRVJTUEFDRT15CkNPTkZJR19ERVZGUkVRX0dPVl9QQVNTSVZFPXkKCiMKIyBERVZGUkVR
IERyaXZlcnMKIwpDT05GSUdfUE1fREVWRlJFUV9FVkVOVD15CkNPTkZJR19FWFRDT049eQoK
IwojIEV4dGNvbiBEZXZpY2UgRHJpdmVycwojCiMgQ09ORklHX0VYVENPTl9GU0E5NDgwIGlz
IG5vdCBzZXQKIyBDT05GSUdfRVhUQ09OX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19FWFRD
T05fSU5URUxfSU5UMzQ5NiBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVENPTl9JTlRFTF9DSFRf
V0MgaXMgbm90IHNldAojIENPTkZJR19FWFRDT05fTEM4MjQyMDZYQSBpcyBub3Qgc2V0CiMg
Q09ORklHX0VYVENPTl9NQVgxNDU3NyBpcyBub3Qgc2V0CiMgQ09ORklHX0VYVENPTl9NQVgz
MzU1IGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUQ09OX01BWDc3NjkzIGlzIG5vdCBzZXQKIyBD
T05GSUdfRVhUQ09OX01BWDc3ODQzIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUQ09OX01BWDg5
OTcgaXMgbm90IHNldAojIENPTkZJR19FWFRDT05fTUFYMTQ1MjYgaXMgbm90IHNldAojIENP
TkZJR19FWFRDT05fUEFMTUFTIGlzIG5vdCBzZXQKIyBDT05GSUdfRVhUQ09OX1BUTjUxNTAg
aXMgbm90IHNldAojIENPTkZJR19FWFRDT05fUlQ4OTczQSBpcyBub3Qgc2V0CiMgQ09ORklH
X0VYVENPTl9TTTU1MDIgaXMgbm90IHNldAojIENPTkZJR19FWFRDT05fVVNCX0dQSU8gaXMg
bm90IHNldApDT05GSUdfTUVNT1JZPXkKIyBDT05GSUdfSUlPIGlzIG5vdCBzZXQKIyBDT05G
SUdfTlRCIGlzIG5vdCBzZXQKQ09ORklHX1BXTT15CiMgQ09ORklHX1BXTV9ERUJVRyBpcyBu
b3Qgc2V0CiMgQ09ORklHX1BXTV9QUk9WSURFX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19Q
V01fQ0xLIGlzIG5vdCBzZXQKQ09ORklHX1BXTV9DUkM9eQojIENPTkZJR19QV01fRFdDIGlz
IG5vdCBzZXQKIyBDT05GSUdfUFdNX0dQSU8gaXMgbm90IHNldApDT05GSUdfUFdNX0xQU1M9
eQpDT05GSUdfUFdNX0xQU1NfUENJPXkKQ09ORklHX1BXTV9MUFNTX1BMQVRGT1JNPXkKIyBD
T05GSUdfUFdNX1BDQTk2ODUgaXMgbm90IHNldAojIENPTkZJR19QV01fVFdMIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUFdNX1RXTF9MRUQgaXMgbm90IHNldAoKIwojIElSUSBjaGlwIHN1cHBv
cnQKIwpDT05GSUdfSVJRX01TSV9MSUI9eQojIGVuZCBvZiBJUlEgY2hpcCBzdXBwb3J0Cgoj
IENPTkZJR19JUEFDS19CVVMgaXMgbm90IHNldApDT05GSUdfUkVTRVRfQ09OVFJPTExFUj15
CiMgQ09ORklHX1JFU0VUX0dQSU8gaXMgbm90IHNldAojIENPTkZJR19SRVNFVF9TSU1QTEUg
aXMgbm90IHNldAojIENPTkZJR19SRVNFVF9USV9TWVNDT04gaXMgbm90IHNldAojIENPTkZJ
R19SRVNFVF9USV9UUFMzODBYIGlzIG5vdCBzZXQKCiMKIyBQSFkgU3Vic3lzdGVtCiMKQ09O
RklHX0dFTkVSSUNfUEhZPXkKIyBDT05GSUdfVVNCX0xHTV9QSFkgaXMgbm90IHNldAojIENP
TkZJR19QSFlfQ0FOX1RSQU5TQ0VJVkVSIGlzIG5vdCBzZXQKCiMKIyBQSFkgZHJpdmVycyBm
b3IgQnJvYWRjb20gcGxhdGZvcm1zCiMKIyBDT05GSUdfQkNNX0tPTkFfVVNCMl9QSFkgaXMg
bm90IHNldAojIGVuZCBvZiBQSFkgZHJpdmVycyBmb3IgQnJvYWRjb20gcGxhdGZvcm1zCgoj
IENPTkZJR19QSFlfUFhBXzI4Tk1fSFNJQyBpcyBub3Qgc2V0CiMgQ09ORklHX1BIWV9QWEFf
MjhOTV9VU0IyIGlzIG5vdCBzZXQKIyBDT05GSUdfUEhZX1NBTVNVTkdfVVNCMiBpcyBub3Qg
c2V0CiMgQ09ORklHX1BIWV9JTlRFTF9MR01fRU1NQyBpcyBub3Qgc2V0CiMgZW5kIG9mIFBI
WSBTdWJzeXN0ZW0KCkNPTkZJR19QT1dFUkNBUD15CkNPTkZJR19JTlRFTF9SQVBMX0NPUkU9
bQpDT05GSUdfSU5URUxfUkFQTD1tCkNPTkZJR19JRExFX0lOSkVDVD15CkNPTkZJR19NQ0I9
eQojIENPTkZJR19NQ0JfUENJIGlzIG5vdCBzZXQKIyBDT05GSUdfTUNCX0xQQyBpcyBub3Qg
c2V0CgojCiMgUGVyZm9ybWFuY2UgbW9uaXRvciBzdXBwb3J0CiMKIyBDT05GSUdfRFdDX1BD
SUVfUE1VIGlzIG5vdCBzZXQKIyBlbmQgb2YgUGVyZm9ybWFuY2UgbW9uaXRvciBzdXBwb3J0
CgpDT05GSUdfUkFTPXkKQ09ORklHX1JBU19DRUM9eQojIENPTkZJR19SQVNfQ0VDX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX0FNRF9BVEw9bQpDT05GSUdfQU1EX0FUTF9QUk09eQpDT05G
SUdfUkFTX0ZNUE09bQojIENPTkZJR19VU0I0IGlzIG5vdCBzZXQKCiMKIyBBbmRyb2lkCiMK
IyBDT05GSUdfQU5EUk9JRF9CSU5ERVJfSVBDIGlzIG5vdCBzZXQKIyBlbmQgb2YgQW5kcm9p
ZAoKQ09ORklHX0xJQk5WRElNTT15CiMgQ09ORklHX0JMS19ERVZfUE1FTSBpcyBub3Qgc2V0
CkNPTkZJR19ORF9DTEFJTT15CkNPTkZJR19CVFQ9eQpDT05GSUdfTlZESU1NX1BGTj15CkNP
TkZJR19OVkRJTU1fREFYPXkKQ09ORklHX1JBTURBWD15CkNPTkZJR19OVkRJTU1fS0VZUz15
CiMgQ09ORklHX05WRElNTV9TRUNVUklUWV9URVNUIGlzIG5vdCBzZXQKQ09ORklHX0RBWD15
CiMgQ09ORklHX0RFVl9EQVggaXMgbm90IHNldAojIENPTkZJR19ERVZfREFYX0hNRU0gaXMg
bm90IHNldApDT05GSUdfTlZNRU09eQpDT05GSUdfTlZNRU1fU1lTRlM9eQojIENPTkZJR19O
Vk1FTV9MQVlPVVRTIGlzIG5vdCBzZXQKIyBDT05GSUdfTlZNRU1fUkFWRV9TUF9FRVBST00g
aXMgbm90IHNldApDT05GSUdfTlZNRU1fUk1FTT15CgojCiMgSFcgdHJhY2luZyBzdXBwb3J0
CiMKIyBDT05GSUdfU1RNIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URUxfVEggaXMgbm90IHNl
dAojIGVuZCBvZiBIVyB0cmFjaW5nIHN1cHBvcnQKCiMgQ09ORklHX0ZQR0EgaXMgbm90IHNl
dAojIENPTkZJR19URUUgaXMgbm90IHNldApDT05GSUdfUE1fT1BQPXkKIyBDT05GSUdfU0lP
WCBpcyBub3Qgc2V0CiMgQ09ORklHX1NMSU1CVVMgaXMgbm90IHNldApDT05GSUdfSU5URVJD
T05ORUNUPXkKIyBDT05GSUdfQ09VTlRFUiBpcyBub3Qgc2V0CiMgQ09ORklHX01PU1QgaXMg
bm90IHNldAojIENPTkZJR19QRUNJIGlzIG5vdCBzZXQKIyBDT05GSUdfSFRFIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgRGV2aWNlIERyaXZlcnMKCiMKIyBGaWxlIHN5c3RlbXMKIwpDT05GSUdf
RENBQ0hFX1dPUkRfQUNDRVNTPXkKQ09ORklHX1ZBTElEQVRFX0ZTX1BBUlNFUj15CkNPTkZJ
R19GU19JT01BUD15CkNPTkZJR19GU19TVEFDSz15CkNPTkZJR19CVUZGRVJfSEVBRD15CkNP
TkZJR19MRUdBQ1lfRElSRUNUX0lPPXkKIyBDT05GSUdfRVhUMl9GUyBpcyBub3Qgc2V0CkNP
TkZJR19FWFQ0X0ZTPXkKQ09ORklHX0VYVDRfVVNFX0ZPUl9FWFQyPXkKQ09ORklHX0VYVDRf
RlNfUE9TSVhfQUNMPXkKQ09ORklHX0VYVDRfRlNfU0VDVVJJVFk9eQojIENPTkZJR19FWFQ0
X0RFQlVHIGlzIG5vdCBzZXQKQ09ORklHX0pCRDI9eQojIENPTkZJR19KQkQyX0RFQlVHIGlz
IG5vdCBzZXQKQ09ORklHX0ZTX01CQ0FDSEU9eQpDT05GSUdfSkZTX0ZTPW0KQ09ORklHX0pG
U19QT1NJWF9BQ0w9eQpDT05GSUdfSkZTX1NFQ1VSSVRZPXkKIyBDT05GSUdfSkZTX0RFQlVH
IGlzIG5vdCBzZXQKQ09ORklHX0pGU19TVEFUSVNUSUNTPXkKQ09ORklHX1hGU19GUz1tCkNP
TkZJR19YRlNfU1VQUE9SVF9WND15CkNPTkZJR19YRlNfU1VQUE9SVF9BU0NJSV9DST15CkNP
TkZJR19YRlNfUVVPVEE9eQpDT05GSUdfWEZTX1BPU0lYX0FDTD15CkNPTkZJR19YRlNfUlQ9
eQojIENPTkZJR19YRlNfT05MSU5FX1NDUlVCIGlzIG5vdCBzZXQKIyBDT05GSUdfWEZTX1dB
Uk4gaXMgbm90IHNldAojIENPTkZJR19YRlNfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19H
RlMyX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfT0NGUzJfRlMgaXMgbm90IHNldApDT05GSUdf
QlRSRlNfRlM9bQpDT05GSUdfQlRSRlNfRlNfUE9TSVhfQUNMPXkKIyBDT05GSUdfQlRSRlNf
RlNfUlVOX1NBTklUWV9URVNUUyBpcyBub3Qgc2V0CiMgQ09ORklHX0JUUkZTX0RFQlVHIGlz
IG5vdCBzZXQKIyBDT05GSUdfQlRSRlNfQVNTRVJUIGlzIG5vdCBzZXQKIyBDT05GSUdfQlRS
RlNfRVhQRVJJTUVOVEFMIGlzIG5vdCBzZXQKIyBDT05GSUdfTklMRlMyX0ZTIGlzIG5vdCBz
ZXQKIyBDT05GSUdfRjJGU19GUyBpcyBub3Qgc2V0CiMgQ09ORklHX1pPTkVGU19GUyBpcyBu
b3Qgc2V0CkNPTkZJR19GU19EQVg9eQpDT05GSUdfRlNfREFYX1BNRD15CkNPTkZJR19GU19Q
T1NJWF9BQ0w9eQpDT05GSUdfRVhQT1JURlM9eQpDT05GSUdfRVhQT1JURlNfQkxPQ0tfT1BT
PXkKQ09ORklHX0ZJTEVfTE9DS0lORz15CkNPTkZJR19GU19FTkNSWVBUSU9OPXkKQ09ORklH
X0ZTX0VOQ1JZUFRJT05fQUxHUz15CkNPTkZJR19GU19FTkNSWVBUSU9OX0lOTElORV9DUllQ
VD15CkNPTkZJR19GU19WRVJJVFk9eQpDT05GSUdfRlNfVkVSSVRZX0JVSUxUSU5fU0lHTkFU
VVJFUz15CkNPTkZJR19GU05PVElGWT15CkNPTkZJR19ETk9USUZZPXkKQ09ORklHX0lOT1RJ
RllfVVNFUj15CkNPTkZJR19GQU5PVElGWT15CkNPTkZJR19GQU5PVElGWV9BQ0NFU1NfUEVS
TUlTU0lPTlM9eQpDT05GSUdfUVVPVEE9eQpDT05GSUdfUVVPVEFfTkVUTElOS19JTlRFUkZB
Q0U9eQojIENPTkZJR19RVU9UQV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1FGTVRfVjEg
aXMgbm90IHNldAojIENPTkZJR19RRk1UX1YyIGlzIG5vdCBzZXQKQ09ORklHX1FVT1RBQ1RM
PXkKQ09ORklHX0FVVE9GU19GUz1tCkNPTkZJR19GVVNFX0ZTPXkKIyBDT05GSUdfQ1VTRSBp
cyBub3Qgc2V0CiMgQ09ORklHX1ZJUlRJT19GUyBpcyBub3Qgc2V0CkNPTkZJR19GVVNFX1BB
U1NUSFJPVUdIPXkKQ09ORklHX0ZVU0VfSU9fVVJJTkc9eQojIENPTkZJR19PVkVSTEFZX0ZT
IGlzIG5vdCBzZXQKCiMKIyBDYWNoZXMKIwojIGVuZCBvZiBDYWNoZXMKCiMKIyBDRC1ST00v
RFZEIEZpbGVzeXN0ZW1zCiMKIyBDT05GSUdfSVNPOTY2MF9GUyBpcyBub3Qgc2V0CiMgQ09O
RklHX1VERl9GUyBpcyBub3Qgc2V0CiMgZW5kIG9mIENELVJPTS9EVkQgRmlsZXN5c3RlbXMK
CiMKIyBET1MvRkFUL0VYRkFUL05UIEZpbGVzeXN0ZW1zCiMKQ09ORklHX0ZBVF9GUz15CkNP
TkZJR19NU0RPU19GUz1tCkNPTkZJR19WRkFUX0ZTPXkKQ09ORklHX0ZBVF9ERUZBVUxUX0NP
REVQQUdFPTQzNwpDT05GSUdfRkFUX0RFRkFVTFRfSU9DSEFSU0VUPSJpc284ODU5LTEiCiMg
Q09ORklHX0ZBVF9ERUZBVUxUX1VURjggaXMgbm90IHNldAojIENPTkZJR19FWEZBVF9GUyBp
cyBub3Qgc2V0CiMgQ09ORklHX05URlMzX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfTlRGU19G
UyBpcyBub3Qgc2V0CiMgZW5kIG9mIERPUy9GQVQvRVhGQVQvTlQgRmlsZXN5c3RlbXMKCiMK
IyBQc2V1ZG8gZmlsZXN5c3RlbXMKIwpDT05GSUdfUFJPQ19GUz15CkNPTkZJR19QUk9DX0tD
T1JFPXkKQ09ORklHX1BST0NfVk1DT1JFPXkKQ09ORklHX1BST0NfVk1DT1JFX0RFVklDRV9E
VU1QPXkKQ09ORklHX1BST0NfU1lTQ1RMPXkKQ09ORklHX1BST0NfUEFHRV9NT05JVE9SPXkK
Q09ORklHX1BST0NfQ0hJTERSRU49eQpDT05GSUdfUFJPQ19QSURfQVJDSF9TVEFUVVM9eQpD
T05GSUdfUFJPQ19DUFVfUkVTQ1RSTD15CkNPTkZJR19LRVJORlM9eQpDT05GSUdfU1lTRlM9
eQpDT05GSUdfVE1QRlM9eQpDT05GSUdfVE1QRlNfUE9TSVhfQUNMPXkKQ09ORklHX1RNUEZT
X1hBVFRSPXkKQ09ORklHX1RNUEZTX0lOT0RFNjQ9eQojIENPTkZJR19UTVBGU19RVU9UQSBp
cyBub3Qgc2V0CkNPTkZJR19BUkNIX1NVUFBPUlRTX0hVR0VUTEJGUz15CkNPTkZJR19IVUdF
VExCRlM9eQojIENPTkZJR19IVUdFVExCX1BBR0VfT1BUSU1JWkVfVk1FTU1BUF9ERUZBVUxU
X09OIGlzIG5vdCBzZXQKQ09ORklHX0hVR0VUTEJfUEFHRT15CkNPTkZJR19IVUdFVExCX1BB
R0VfT1BUSU1JWkVfVk1FTU1BUD15CkNPTkZJR19IVUdFVExCX1BNRF9QQUdFX1RBQkxFX1NI
QVJJTkc9eQpDT05GSUdfQVJDSF9IQVNfR0lHQU5USUNfUEFHRT15CkNPTkZJR19DT05GSUdG
U19GUz15CkNPTkZJR19FRklWQVJfRlM9eQojIGVuZCBvZiBQc2V1ZG8gZmlsZXN5c3RlbXMK
CkNPTkZJR19NSVNDX0ZJTEVTWVNURU1TPXkKIyBDT05GSUdfT1JBTkdFRlNfRlMgaXMgbm90
IHNldAojIENPTkZJR19BREZTX0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfQUZGU19GUyBpcyBu
b3Qgc2V0CkNPTkZJR19FQ1JZUFRfRlM9eQpDT05GSUdfRUNSWVBUX0ZTX01FU1NBR0lORz15
CkNPTkZJR19IRlNfRlM9bQpDT05GSUdfSEZTUExVU19GUz1tCiMgQ09ORklHX0JFRlNfRlMg
aXMgbm90IHNldAojIENPTkZJR19CRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19FRlNfRlMg
aXMgbm90IHNldAojIENPTkZJR19DUkFNRlMgaXMgbm90IHNldApDT05GSUdfU1FVQVNIRlM9
eQojIENPTkZJR19TUVVBU0hGU19GSUxFX0NBQ0hFIGlzIG5vdCBzZXQKQ09ORklHX1NRVUFT
SEZTX0ZJTEVfRElSRUNUPXkKQ09ORklHX1NRVUFTSEZTX0RFQ09NUF9TSU5HTEU9eQojIENP
TkZJR19TUVVBU0hGU19DSE9JQ0VfREVDT01QX0JZX01PVU5UIGlzIG5vdCBzZXQKQ09ORklH
X1NRVUFTSEZTX0NPTVBJTEVfREVDT01QX1NJTkdMRT15CiMgQ09ORklHX1NRVUFTSEZTX0NP
TVBJTEVfREVDT01QX01VTFRJIGlzIG5vdCBzZXQKIyBDT05GSUdfU1FVQVNIRlNfQ09NUElM
RV9ERUNPTVBfTVVMVElfUEVSQ1BVIGlzIG5vdCBzZXQKQ09ORklHX1NRVUFTSEZTX1hBVFRS
PXkKIyBDT05GSUdfU1FVQVNIRlNfQ09NUF9DQUNIRV9GVUxMIGlzIG5vdCBzZXQKQ09ORklH
X1NRVUFTSEZTX1pMSUI9eQpDT05GSUdfU1FVQVNIRlNfTFo0PXkKQ09ORklHX1NRVUFTSEZT
X0xaTz15CkNPTkZJR19TUVVBU0hGU19YWj15CkNPTkZJR19TUVVBU0hGU19aU1REPXkKIyBD
T05GSUdfU1FVQVNIRlNfNEtfREVWQkxLX1NJWkUgaXMgbm90IHNldAojIENPTkZJR19TUVVB
U0hGU19FTUJFRERFRCBpcyBub3Qgc2V0CkNPTkZJR19TUVVBU0hGU19GUkFHTUVOVF9DQUNI
RV9TSVpFPTMKIyBDT05GSUdfVlhGU19GUyBpcyBub3Qgc2V0CkNPTkZJR19NSU5JWF9GUz1t
CiMgQ09ORklHX09NRlNfRlMgaXMgbm90IHNldAojIENPTkZJR19IUEZTX0ZTIGlzIG5vdCBz
ZXQKQ09ORklHX1FOWDRGU19GUz1tCiMgQ09ORklHX1FOWDZGU19GUyBpcyBub3Qgc2V0CkNP
TkZJR19SRVNDVFJMX0ZTPXkKQ09ORklHX1JFU0NUUkxfRlNfUFNFVURPX0xPQ0s9eQojIENP
TkZJR19ST01GU19GUyBpcyBub3Qgc2V0CkNPTkZJR19QU1RPUkU9eQpDT05GSUdfUFNUT1JF
X0RFRkFVTFRfS01TR19CWVRFUz0xMDI0MApDT05GSUdfUFNUT1JFX0NPTVBSRVNTPXkKIyBD
T05GSUdfUFNUT1JFX0NPTlNPTEUgaXMgbm90IHNldAojIENPTkZJR19QU1RPUkVfUE1TRyBp
cyBub3Qgc2V0CiMgQ09ORklHX1BTVE9SRV9GVFJBQ0UgaXMgbm90IHNldAojIENPTkZJR19Q
U1RPUkVfUkFNIGlzIG5vdCBzZXQKIyBDT05GSUdfUFNUT1JFX0JMSyBpcyBub3Qgc2V0CkNP
TkZJR19VRlNfRlM9bQojIENPTkZJR19VRlNfRlNfV1JJVEUgaXMgbm90IHNldAojIENPTkZJ
R19VRlNfREVCVUcgaXMgbm90IHNldAojIENPTkZJR19FUk9GU19GUyBpcyBub3Qgc2V0CkNP
TkZJR19ORVRXT1JLX0ZJTEVTWVNURU1TPXkKIyBDT05GSUdfTkZTX0ZTIGlzIG5vdCBzZXQK
IyBDT05GSUdfTkZTRCBpcyBub3Qgc2V0CiMgQ09ORklHX0NFUEhfRlMgaXMgbm90IHNldAoj
IENPTkZJR19DSUZTIGlzIG5vdCBzZXQKIyBDT05GSUdfU01CX1NFUlZFUiBpcyBub3Qgc2V0
CiMgQ09ORklHX0NPREFfRlMgaXMgbm90IHNldAojIENPTkZJR19BRlNfRlMgaXMgbm90IHNl
dApDT05GSUdfTkxTPXkKQ09ORklHX05MU19ERUZBVUxUPSJ1dGY4IgpDT05GSUdfTkxTX0NP
REVQQUdFXzQzNz15CiMgQ09ORklHX05MU19DT0RFUEFHRV83MzcgaXMgbm90IHNldAojIENP
TkZJR19OTFNfQ09ERVBBR0VfNzc1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQQUdF
Xzg1MCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NTIgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfQ09ERVBBR0VfODU1IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NPREVQ
QUdFXzg1NyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjAgaXMgbm90IHNl
dAojIENPTkZJR19OTFNfQ09ERVBBR0VfODYxIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0NP
REVQQUdFXzg2MiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjMgaXMgbm90
IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY0IGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X0NPREVQQUdFXzg2NSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84NjYgaXMg
bm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfODY5IGlzIG5vdCBzZXQKIyBDT05GSUdf
TkxTX0NPREVQQUdFXzkzNiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV85NTAg
aXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0VfOTMyIGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzk0OSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19DT0RFUEFHRV84
NzQgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV84IGlzIG5vdCBzZXQKIyBDT05G
SUdfTkxTX0NPREVQQUdFXzEyNTAgaXMgbm90IHNldAojIENPTkZJR19OTFNfQ09ERVBBR0Vf
MTI1MSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19BU0NJSSBpcyBub3Qgc2V0CkNPTkZJR19O
TFNfSVNPODg1OV8xPW0KIyBDT05GSUdfTkxTX0lTTzg4NTlfMiBpcyBub3Qgc2V0CiMgQ09O
RklHX05MU19JU084ODU5XzMgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV80IGlz
IG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfNSBpcyBub3Qgc2V0CiMgQ09ORklHX05M
U19JU084ODU5XzYgaXMgbm90IHNldAojIENPTkZJR19OTFNfSVNPODg1OV83IGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfOSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19JU084
ODU5XzEzIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX0lTTzg4NTlfMTQgaXMgbm90IHNldAoj
IENPTkZJR19OTFNfSVNPODg1OV8xNSBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19LT0k4X1Ig
aXMgbm90IHNldAojIENPTkZJR19OTFNfS09JOF9VIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxT
X01BQ19ST01BTiBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNfQ0VMVElDIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX01BQ19DRU5URVVSTyBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19N
QUNfQ1JPQVRJQU4gaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX0NZUklMTElDIGlzIG5v
dCBzZXQKIyBDT05GSUdfTkxTX01BQ19HQUVMSUMgaXMgbm90IHNldAojIENPTkZJR19OTFNf
TUFDX0dSRUVLIGlzIG5vdCBzZXQKIyBDT05GSUdfTkxTX01BQ19JQ0VMQU5EIGlzIG5vdCBz
ZXQKIyBDT05GSUdfTkxTX01BQ19JTlVJVCBpcyBub3Qgc2V0CiMgQ09ORklHX05MU19NQUNf
Uk9NQU5JQU4gaXMgbm90IHNldAojIENPTkZJR19OTFNfTUFDX1RVUktJU0ggaXMgbm90IHNl
dApDT05GSUdfTkxTX1VURjg9bQpDT05GSUdfTkxTX1VDUzJfVVRJTFM9bQojIENPTkZJR19E
TE0gaXMgbm90IHNldApDT05GSUdfVU5JQ09ERT15CkNPTkZJR19JT19XUT15CiMgZW5kIG9m
IEZpbGUgc3lzdGVtcwoKIwojIFNlY3VyaXR5IG9wdGlvbnMKIwpDT05GSUdfS0VZUz15CkNP
TkZJR19LRVlTX1JFUVVFU1RfQ0FDSEU9eQpDT05GSUdfUEVSU0lTVEVOVF9LRVlSSU5HUz15
CiMgQ09ORklHX0JJR19LRVlTIGlzIG5vdCBzZXQKQ09ORklHX1RSVVNURURfS0VZUz15CkNP
TkZJR19IQVZFX1RSVVNURURfS0VZUz15CkNPTkZJR19UUlVTVEVEX0tFWVNfVFBNPXkKQ09O
RklHX0VOQ1JZUFRFRF9LRVlTPXkKIyBDT05GSUdfVVNFUl9ERUNSWVBURURfREFUQSBpcyBu
b3Qgc2V0CkNPTkZJR19LRVlfREhfT1BFUkFUSU9OUz15CkNPTkZJR19LRVlfTk9USUZJQ0FU
SU9OUz15CkNPTkZJR19TRUNVUklUWV9ETUVTR19SRVNUUklDVD15CkNPTkZJR19QUk9DX01F
TV9BTFdBWVNfRk9SQ0U9eQojIENPTkZJR19QUk9DX01FTV9GT1JDRV9QVFJBQ0UgaXMgbm90
IHNldAojIENPTkZJR19QUk9DX01FTV9OT19GT1JDRSBpcyBub3Qgc2V0CkNPTkZJR19TRUNV
UklUWT15CkNPTkZJR19IQVNfU0VDVVJJVFlfQVVESVQ9eQpDT05GSUdfU0VDVVJJVFlGUz15
CkNPTkZJR19TRUNVUklUWV9ORVRXT1JLPXkKQ09ORklHX1NFQ1VSSVRZX1BBVEg9eQpDT05G
SUdfSU5URUxfVFhUPXkKQ09ORklHX0xTTV9NTUFQX01JTl9BRERSPTAKIyBDT05GSUdfU1RB
VElDX1VTRVJNT0RFSEVMUEVSIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVg9
eQpDT05GSUdfU0VDVVJJVFlfU0VMSU5VWF9CT09UUEFSQU09eQpDT05GSUdfU0VDVVJJVFlf
U0VMSU5VWF9ERVZFTE9QPXkKQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfQVZDX1NUQVRTPXkK
Q09ORklHX1NFQ1VSSVRZX1NFTElOVVhfU0lEVEFCX0hBU0hfQklUUz05CkNPTkZJR19TRUNV
UklUWV9TRUxJTlVYX1NJRDJTVFJfQ0FDSEVfU0laRT0yNTYKQ09ORklHX1NFQ1VSSVRZX1NF
TElOVVhfQVZDX0hBU0hfQklUUz05CiMgQ09ORklHX1NFQ1VSSVRZX1NFTElOVVhfREVCVUcg
aXMgbm90IHNldApDT05GSUdfU0VDVVJJVFlfU01BQ0s9eQojIENPTkZJR19TRUNVUklUWV9T
TUFDS19CUklOR1VQIGlzIG5vdCBzZXQKQ09ORklHX1NFQ1VSSVRZX1NNQUNLX05FVEZJTFRF
Uj15CkNPTkZJR19TRUNVUklUWV9TTUFDS19BUFBFTkRfU0lHTkFMUz15CkNPTkZJR19TRUNV
UklUWV9UT01PWU89eQpDT05GSUdfU0VDVVJJVFlfVE9NT1lPX01BWF9BQ0NFUFRfRU5UUlk9
MjA0OApDT05GSUdfU0VDVVJJVFlfVE9NT1lPX01BWF9BVURJVF9MT0c9MTAyNAojIENPTkZJ
R19TRUNVUklUWV9UT01PWU9fT01JVF9VU0VSU1BBQ0VfTE9BREVSIGlzIG5vdCBzZXQKQ09O
RklHX1NFQ1VSSVRZX1RPTU9ZT19QT0xJQ1lfTE9BREVSPSIvc2Jpbi90b21veW8taW5pdCIK
Q09ORklHX1NFQ1VSSVRZX1RPTU9ZT19BQ1RJVkFUSU9OX1RSSUdHRVI9Ii9zYmluL2luaXQi
CiMgQ09ORklHX1NFQ1VSSVRZX1RPTU9ZT19JTlNFQ1VSRV9CVUlMVElOX1NFVFRJTkcgaXMg
bm90IHNldApDT05GSUdfU0VDVVJJVFlfQVBQQVJNT1I9eQojIENPTkZJR19TRUNVUklUWV9B
UFBBUk1PUl9ERUJVRyBpcyBub3Qgc2V0CkNPTkZJR19TRUNVUklUWV9BUFBBUk1PUl9JTlRS
T1NQRUNUX1BPTElDWT15CkNPTkZJR19TRUNVUklUWV9BUFBBUk1PUl9IQVNIPXkKQ09ORklH
X1NFQ1VSSVRZX0FQUEFSTU9SX0hBU0hfREVGQVVMVD15CkNPTkZJR19TRUNVUklUWV9BUFBB
Uk1PUl9FWFBPUlRfQklOQVJZPXkKQ09ORklHX1NFQ1VSSVRZX0FQUEFSTU9SX1BBUkFOT0lE
X0xPQUQ9eQojIENPTkZJR19TRUNVUklUWV9MT0FEUElOIGlzIG5vdCBzZXQKQ09ORklHX1NF
Q1VSSVRZX1lBTUE9eQpDT05GSUdfU0VDVVJJVFlfU0FGRVNFVElEPXkKQ09ORklHX1NFQ1VS
SVRZX0xPQ0tET1dOX0xTTT15CkNPTkZJR19TRUNVUklUWV9MT0NLRE9XTl9MU01fRUFSTFk9
eQpDT05GSUdfTE9DS19ET1dOX0tFUk5FTF9GT1JDRV9OT05FPXkKIyBDT05GSUdfTE9DS19E
T1dOX0tFUk5FTF9GT1JDRV9JTlRFR1JJVFkgaXMgbm90IHNldAojIENPTkZJR19MT0NLX0RP
V05fS0VSTkVMX0ZPUkNFX0NPTkZJREVOVElBTElUWSBpcyBub3Qgc2V0CkNPTkZJR19TRUNV
UklUWV9MQU5ETE9DSz15CiMgQ09ORklHX1NFQ1VSSVRZX0lQRSBpcyBub3Qgc2V0CkNPTkZJ
R19JTlRFR1JJVFk9eQpDT05GSUdfSU5URUdSSVRZX1NJR05BVFVSRT15CkNPTkZJR19JTlRF
R1JJVFlfQVNZTU1FVFJJQ19LRVlTPXkKQ09ORklHX0lOVEVHUklUWV9UUlVTVEVEX0tFWVJJ
Tkc9eQpDT05GSUdfSU5URUdSSVRZX1BMQVRGT1JNX0tFWVJJTkc9eQojIENPTkZJR19JTlRF
R1JJVFlfTUFDSElORV9LRVlSSU5HIGlzIG5vdCBzZXQKQ09ORklHX0xPQURfVUVGSV9LRVlT
PXkKQ09ORklHX0lOVEVHUklUWV9BVURJVD15CkNPTkZJR19JTUE9eQojIENPTkZJR19JTUFf
S0VYRUMgaXMgbm90IHNldApDT05GSUdfSU1BX01FQVNVUkVfUENSX0lEWD0xMApDT05GSUdf
SU1BX0xTTV9SVUxFUz15CkNPTkZJR19JTUFfTkdfVEVNUExBVEU9eQojIENPTkZJR19JTUFf
U0lHX1RFTVBMQVRFIGlzIG5vdCBzZXQKQ09ORklHX0lNQV9ERUZBVUxUX1RFTVBMQVRFPSJp
bWEtbmciCkNPTkZJR19JTUFfREVGQVVMVF9IQVNIX1NIQTE9eQojIENPTkZJR19JTUFfREVG
QVVMVF9IQVNIX1NIQTI1NiBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQV9ERUZBVUxUX0hBU0hf
U0hBNTEyIGlzIG5vdCBzZXQKQ09ORklHX0lNQV9ERUZBVUxUX0hBU0g9InNoYTEiCiMgQ09O
RklHX0lNQV9XUklURV9QT0xJQ1kgaXMgbm90IHNldAojIENPTkZJR19JTUFfUkVBRF9QT0xJ
Q1kgaXMgbm90IHNldApDT05GSUdfSU1BX0FQUFJBSVNFPXkKIyBDT05GSUdfSU1BX0FSQ0hf
UE9MSUNZIGlzIG5vdCBzZXQKIyBDT05GSUdfSU1BX0FQUFJBSVNFX0JVSUxEX1BPTElDWSBp
cyBub3Qgc2V0CkNPTkZJR19JTUFfQVBQUkFJU0VfQk9PVFBBUkFNPXkKQ09ORklHX0lNQV9B
UFBSQUlTRV9NT0RTSUc9eQojIENPTkZJR19JTUFfS0VZUklOR1NfUEVSTUlUX1NJR05FRF9C
WV9CVUlMVElOX09SX1NFQ09OREFSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQV9CTEFDS0xJ
U1RfS0VZUklORyBpcyBub3Qgc2V0CiMgQ09ORklHX0lNQV9MT0FEX1g1MDkgaXMgbm90IHNl
dApDT05GSUdfSU1BX01FQVNVUkVfQVNZTU1FVFJJQ19LRVlTPXkKQ09ORklHX0lNQV9RVUVV
RV9FQVJMWV9CT09UX0tFWVM9eQojIENPTkZJR19JTUFfU0VDVVJFX0FORF9PUl9UUlVTVEVE
X0JPT1QgaXMgbm90IHNldAojIENPTkZJR19JTUFfRElTQUJMRV9IVEFCTEUgaXMgbm90IHNl
dApDT05GSUdfRVZNPXkKQ09ORklHX0VWTV9BVFRSX0ZTVVVJRD15CkNPTkZJR19FVk1fRVhU
UkFfU01BQ0tfWEFUVFJTPXkKQ09ORklHX0VWTV9BRERfWEFUVFJTPXkKIyBDT05GSUdfRVZN
X0xPQURfWDUwOSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU0VMSU5V
WCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFRkFVTFRfU0VDVVJJVFlfU01BQ0sgaXMgbm90IHNl
dAojIENPTkZJR19ERUZBVUxUX1NFQ1VSSVRZX1RPTU9ZTyBpcyBub3Qgc2V0CkNPTkZJR19E
RUZBVUxUX1NFQ1VSSVRZX0FQUEFSTU9SPXkKIyBDT05GSUdfREVGQVVMVF9TRUNVUklUWV9E
QUMgaXMgbm90IHNldApDT05GSUdfTFNNPSJsYW5kbG9jayxsb2NrZG93bix5YW1hLGludGVn
cml0eSxhcHBhcm1vciIKCiMKIyBLZXJuZWwgaGFyZGVuaW5nIG9wdGlvbnMKIwoKIwojIE1l
bW9yeSBpbml0aWFsaXphdGlvbgojCkNPTkZJR19DQ19IQVNfQVVUT19WQVJfSU5JVF9QQVRU
RVJOPXkKQ09ORklHX0NDX0hBU19BVVRPX1ZBUl9JTklUX1pFUk9fQkFSRT15CkNPTkZJR19D
Q19IQVNfQVVUT19WQVJfSU5JVF9aRVJPPXkKQ09ORklHX0lOSVRfU1RBQ0tfTk9ORT15CiMg
Q09ORklHX0lOSVRfU1RBQ0tfQUxMX1BBVFRFUk4gaXMgbm90IHNldAojIENPTkZJR19JTklU
X1NUQUNLX0FMTF9aRVJPIGlzIG5vdCBzZXQKQ09ORklHX0lOSVRfT05fQUxMT0NfREVGQVVM
VF9PTj15CiMgQ09ORklHX0lOSVRfT05fRlJFRV9ERUZBVUxUX09OIGlzIG5vdCBzZXQKQ09O
RklHX0NDX0hBU19aRVJPX0NBTExfVVNFRF9SRUdTPXkKIyBDT05GSUdfWkVST19DQUxMX1VT
RURfUkVHUyBpcyBub3Qgc2V0CiMgZW5kIG9mIE1lbW9yeSBpbml0aWFsaXphdGlvbgoKIwoj
IEJvdW5kcyBjaGVja2luZwojCkNPTkZJR19GT1JUSUZZX1NPVVJDRT15CkNPTkZJR19IQVJE
RU5FRF9VU0VSQ09QWT15CkNPTkZJR19IQVJERU5FRF9VU0VSQ09QWV9ERUZBVUxUX09OPXkK
IyBlbmQgb2YgQm91bmRzIGNoZWNraW5nCgojCiMgSGFyZGVuaW5nIG9mIGtlcm5lbCBkYXRh
IHN0cnVjdHVyZXMKIwojIENPTkZJR19MSVNUX0hBUkRFTkVEIGlzIG5vdCBzZXQKIyBDT05G
SUdfQlVHX09OX0RBVEFfQ09SUlVQVElPTiBpcyBub3Qgc2V0CiMgZW5kIG9mIEhhcmRlbmlu
ZyBvZiBrZXJuZWwgZGF0YSBzdHJ1Y3R1cmVzCgpDT05GSUdfUkFORFNUUlVDVF9OT05FPXkK
IyBlbmQgb2YgS2VybmVsIGhhcmRlbmluZyBvcHRpb25zCiMgZW5kIG9mIFNlY3VyaXR5IG9w
dGlvbnMKCkNPTkZJR19YT1JfQkxPQ0tTPW0KQ09ORklHX0FTWU5DX0NPUkU9bQpDT05GSUdf
QVNZTkNfTUVNQ1BZPW0KQ09ORklHX0FTWU5DX1hPUj1tCkNPTkZJR19BU1lOQ19QUT1tCkNP
TkZJR19BU1lOQ19SQUlENl9SRUNPVj1tCkNPTkZJR19DUllQVE89eQoKIwojIENyeXB0byBj
b3JlIG9yIGhlbHBlcgojCkNPTkZJR19DUllQVE9fQUxHQVBJPXkKQ09ORklHX0NSWVBUT19B
TEdBUEkyPXkKQ09ORklHX0NSWVBUT19BRUFEPXkKQ09ORklHX0NSWVBUT19BRUFEMj15CkNP
TkZJR19DUllQVE9fU0lHPXkKQ09ORklHX0NSWVBUT19TSUcyPXkKQ09ORklHX0NSWVBUT19T
S0NJUEhFUj15CkNPTkZJR19DUllQVE9fU0tDSVBIRVIyPXkKQ09ORklHX0NSWVBUT19IQVNI
PXkKQ09ORklHX0NSWVBUT19IQVNIMj15CkNPTkZJR19DUllQVE9fUk5HPXkKQ09ORklHX0NS
WVBUT19STkcyPXkKQ09ORklHX0NSWVBUT19STkdfREVGQVVMVD15CkNPTkZJR19DUllQVE9f
QUtDSVBIRVIyPXkKQ09ORklHX0NSWVBUT19BS0NJUEhFUj15CkNPTkZJR19DUllQVE9fS1BQ
Mj15CkNPTkZJR19DUllQVE9fS1BQPXkKQ09ORklHX0NSWVBUT19BQ09NUDI9eQpDT05GSUdf
Q1JZUFRPX01BTkFHRVI9eQpDT05GSUdfQ1JZUFRPX01BTkFHRVIyPXkKIyBDT05GSUdfQ1JZ
UFRPX1VTRVIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU0VMRlRFU1RTIGlzIG5vdCBz
ZXQKQ09ORklHX0NSWVBUT19OVUxMPXkKIyBDT05GSUdfQ1JZUFRPX1BDUllQVCBpcyBub3Qg
c2V0CkNPTkZJR19DUllQVE9fQ1JZUFREPW0KQ09ORklHX0NSWVBUT19BVVRIRU5DPW0KIyBD
T05GSUdfQ1JZUFRPX0tSQjVFTkMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQkVOQ0hN
QVJLIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ3J5cHRvIGNvcmUgb3IgaGVscGVyCgojCiMgUHVi
bGljLWtleSBjcnlwdG9ncmFwaHkKIwpDT05GSUdfQ1JZUFRPX1JTQT15CkNPTkZJR19DUllQ
VE9fREg9eQojIENPTkZJR19DUllQVE9fREhfUkZDNzkxOV9HUk9VUFMgaXMgbm90IHNldApD
T05GSUdfQ1JZUFRPX0VDQz15CkNPTkZJR19DUllQVE9fRUNESD15CiMgQ09ORklHX0NSWVBU
T19FQ0RTQSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19FQ1JEU0EgaXMgbm90IHNldAoj
IGVuZCBvZiBQdWJsaWMta2V5IGNyeXB0b2dyYXBoeQoKIwojIEJsb2NrIGNpcGhlcnMKIwpD
T05GSUdfQ1JZUFRPX0FFUz15CiMgQ09ORklHX0NSWVBUT19BRVNfVEkgaXMgbm90IHNldAoj
IENPTkZJR19DUllQVE9fQVJJQSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19CTE9XRklT
SCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DQU1FTExJQSBpcyBub3Qgc2V0CiMgQ09O
RklHX0NSWVBUT19DQVNUNSBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DQVNUNiBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19ERVMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
RkNSWVBUIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUlBFTlQgaXMgbm90IHNldApD
T05GSUdfQ1JZUFRPX1NNND1tCkNPTkZJR19DUllQVE9fU000X0dFTkVSSUM9bQojIENPTkZJ
R19DUllQVE9fVFdPRklTSCBpcyBub3Qgc2V0CiMgZW5kIG9mIEJsb2NrIGNpcGhlcnMKCiMK
IyBMZW5ndGgtcHJlc2VydmluZyBjaXBoZXJzIGFuZCBtb2RlcwojCiMgQ09ORklHX0NSWVBU
T19BRElBTlRVTSBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fQ0hBQ0hBMjA9bQpDT05GSUdf
Q1JZUFRPX0NCQz15CkNPTkZJR19DUllQVE9fQ1RSPXkKQ09ORklHX0NSWVBUT19DVFM9eQpD
T05GSUdfQ1JZUFRPX0VDQj15CiMgQ09ORklHX0NSWVBUT19IQ1RSMiBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19MUlcgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fUENCQyBpcyBu
b3Qgc2V0CkNPTkZJR19DUllQVE9fWFRTPXkKIyBlbmQgb2YgTGVuZ3RoLXByZXNlcnZpbmcg
Y2lwaGVycyBhbmQgbW9kZXMKCiMKIyBBRUFEIChhdXRoZW50aWNhdGVkIGVuY3J5cHRpb24g
d2l0aCBhc3NvY2lhdGVkIGRhdGEpIGNpcGhlcnMKIwojIENPTkZJR19DUllQVE9fQUVHSVMx
MjggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fQ0hBQ0hBMjBQT0xZMTMwNSBpcyBub3Qg
c2V0CkNPTkZJR19DUllQVE9fQ0NNPW0KQ09ORklHX0NSWVBUT19HQ009eQpDT05GSUdfQ1JZ
UFRPX0dFTklWPXkKQ09ORklHX0NSWVBUT19TRVFJVj15CiMgQ09ORklHX0NSWVBUT19FQ0hB
SU5JViBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19FU1NJViBpcyBub3Qgc2V0CiMgZW5k
IG9mIEFFQUQgKGF1dGhlbnRpY2F0ZWQgZW5jcnlwdGlvbiB3aXRoIGFzc29jaWF0ZWQgZGF0
YSkgY2lwaGVycwoKIwojIEhhc2hlcywgZGlnZXN0cywgYW5kIE1BQ3MKIwpDT05GSUdfQ1JZ
UFRPX0JMQUtFMkI9bQpDT05GSUdfQ1JZUFRPX0NNQUM9bQpDT05GSUdfQ1JZUFRPX0dIQVNI
PXkKQ09ORklHX0NSWVBUT19ITUFDPXkKIyBDT05GSUdfQ1JZUFRPX01ENCBpcyBub3Qgc2V0
CkNPTkZJR19DUllQVE9fTUQ1PXkKQ09ORklHX0NSWVBUT19NSUNIQUVMX01JQz1tCiMgQ09O
RklHX0NSWVBUT19STUQxNjAgaXMgbm90IHNldApDT05GSUdfQ1JZUFRPX1NIQTE9eQpDT05G
SUdfQ1JZUFRPX1NIQTI1Nj15CkNPTkZJR19DUllQVE9fU0hBNTEyPXkKQ09ORklHX0NSWVBU
T19TSEEzPXkKIyBDT05GSUdfQ1JZUFRPX1NNM19HRU5FUklDIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX1NUUkVFQk9HIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1dQNTEyIGlz
IG5vdCBzZXQKQ09ORklHX0NSWVBUT19YQ0JDPW0KQ09ORklHX0NSWVBUT19YWEhBU0g9bQoj
IGVuZCBvZiBIYXNoZXMsIGRpZ2VzdHMsIGFuZCBNQUNzCgojCiMgQ1JDcyAoY3ljbGljIHJl
ZHVuZGFuY3kgY2hlY2tzKQojCkNPTkZJR19DUllQVE9fQ1JDMzJDPXkKIyBDT05GSUdfQ1JZ
UFRPX0NSQzMyIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ1JDcyAoY3ljbGljIHJlZHVuZGFuY3kg
Y2hlY2tzKQoKIwojIENvbXByZXNzaW9uCiMKQ09ORklHX0NSWVBUT19ERUZMQVRFPXkKQ09O
RklHX0NSWVBUT19MWk89eQojIENPTkZJR19DUllQVE9fODQyIGlzIG5vdCBzZXQKIyBDT05G
SUdfQ1JZUFRPX0xaNCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19MWjRIQyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19aU1REIGlzIG5vdCBzZXQKIyBlbmQgb2YgQ29tcHJlc3Np
b24KCiMKIyBSYW5kb20gbnVtYmVyIGdlbmVyYXRpb24KIwpDT05GSUdfQ1JZUFRPX0RSQkdf
TUVOVT15CkNPTkZJR19DUllQVE9fRFJCR19ITUFDPXkKQ09ORklHX0NSWVBUT19EUkJHX0hB
U0g9eQpDT05GSUdfQ1JZUFRPX0RSQkdfQ1RSPXkKQ09ORklHX0NSWVBUT19EUkJHPXkKQ09O
RklHX0NSWVBUT19KSVRURVJFTlRST1BZPXkKQ09ORklHX0NSWVBUT19KSVRURVJFTlRST1BZ
X01FTU9SWV9CTE9DS1M9NjQKQ09ORklHX0NSWVBUT19KSVRURVJFTlRST1BZX01FTU9SWV9C
TE9DS1NJWkU9MzIKQ09ORklHX0NSWVBUT19KSVRURVJFTlRST1BZX09TUj0xCkNPTkZJR19D
UllQVE9fS0RGODAwMTA4X0NUUj15CkNPTkZJR19DUllQVE9fREY4MDA5MEE9eQojIGVuZCBv
ZiBSYW5kb20gbnVtYmVyIGdlbmVyYXRpb24KCiMKIyBVc2Vyc3BhY2UgaW50ZXJmYWNlCiMK
IyBDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX0hBU0ggaXMgbm90IHNldAojIENPTkZJR19DUllQ
VE9fVVNFUl9BUElfU0tDSVBIRVIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fVVNFUl9B
UElfUk5HIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1VTRVJfQVBJX0FFQUQgaXMgbm90
IHNldAojIGVuZCBvZiBVc2Vyc3BhY2UgaW50ZXJmYWNlCgojCiMgQWNjZWxlcmF0ZWQgQ3J5
cHRvZ3JhcGhpYyBBbGdvcml0aG1zIGZvciBDUFUgKHg4NikKIwpDT05GSUdfQ1JZUFRPX0FF
U19OSV9JTlRFTD1tCiMgQ09ORklHX0NSWVBUT19CTE9XRklTSF9YODZfNjQgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fQ0FNRUxMSUFfWDg2XzY0IGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX0NBTUVMTElBX0FFU05JX0FWWF9YODZfNjQgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fQ0FNRUxMSUFfQUVTTklfQVZYMl9YODZfNjQgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fQ0FTVDVfQVZYX1g4Nl82NCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19DQVNU
Nl9BVlhfWDg2XzY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0RFUzNfRURFX1g4Nl82
NCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19TRVJQRU5UX1NTRTJfWDg2XzY0IGlzIG5v
dCBzZXQKIyBDT05GSUdfQ1JZUFRPX1NFUlBFTlRfQVZYX1g4Nl82NCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19TRVJQRU5UX0FWWDJfWDg2XzY0IGlzIG5vdCBzZXQKIyBDT05GSUdf
Q1JZUFRPX1NNNF9BRVNOSV9BVlhfWDg2XzY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRP
X1NNNF9BRVNOSV9BVlgyX1g4Nl82NCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UV09G
SVNIX1g4Nl82NCBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19UV09GSVNIX1g4Nl82NF8z
V0FZIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX1RXT0ZJU0hfQVZYX1g4Nl82NCBpcyBu
b3Qgc2V0CiMgQ09ORklHX0NSWVBUT19BUklBX0FFU05JX0FWWF9YODZfNjQgaXMgbm90IHNl
dAojIENPTkZJR19DUllQVE9fQVJJQV9BRVNOSV9BVlgyX1g4Nl82NCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19BUklBX0dGTklfQVZYNTEyX1g4Nl82NCBpcyBub3Qgc2V0CiMgQ09O
RklHX0NSWVBUT19BRUdJUzEyOF9BRVNOSV9TU0UyIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZ
UFRPX05IUE9MWTEzMDVfU1NFMiBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19OSFBPTFkx
MzA1X0FWWDIgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fU00zX0FWWF9YODZfNjQgaXMg
bm90IHNldApDT05GSUdfQ1JZUFRPX0dIQVNIX0NMTVVMX05JX0lOVEVMPW0KIyBlbmQgb2Yg
QWNjZWxlcmF0ZWQgQ3J5cHRvZ3JhcGhpYyBBbGdvcml0aG1zIGZvciBDUFUgKHg4NikKCkNP
TkZJR19DUllQVE9fSFc9eQpDT05GSUdfQ1JZUFRPX0RFVl9QQURMT0NLPXkKIyBDT05GSUdf
Q1JZUFRPX0RFVl9QQURMT0NLX0FFUyBpcyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19ERVZf
UEFETE9DS19TSEEgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX0FUTUVMX0VDQyBp
cyBub3Qgc2V0CiMgQ09ORklHX0NSWVBUT19ERVZfQVRNRUxfU0hBMjA0QSBpcyBub3Qgc2V0
CkNPTkZJR19DUllQVE9fREVWX0NDUD15CkNPTkZJR19DUllQVE9fREVWX0NDUF9ERD1tCkNP
TkZJR19DUllQVE9fREVWX1NQX0NDUD15CiMgQ09ORklHX0NSWVBUT19ERVZfQ0NQX0NSWVBU
TyBpcyBub3Qgc2V0CkNPTkZJR19DUllQVE9fREVWX1NQX1BTUD15CiMgQ09ORklHX0NSWVBU
T19ERVZfQ0NQX0RFQlVHRlMgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX05JVFJP
WF9DTk41NVhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0RFVl9RQVRfREg4OTV4Q0Mg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX1FBVF9DM1hYWCBpcyBub3Qgc2V0CiMg
Q09ORklHX0NSWVBUT19ERVZfUUFUX0M2MlggaXMgbm90IHNldAojIENPTkZJR19DUllQVE9f
REVWX1FBVF80WFhYIGlzIG5vdCBzZXQKIyBDT05GSUdfQ1JZUFRPX0RFVl9RQVRfNDIwWFgg
aXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX1FBVF82WFhYIGlzIG5vdCBzZXQKIyBD
T05GSUdfQ1JZUFRPX0RFVl9RQVRfREg4OTV4Q0NWRiBpcyBub3Qgc2V0CiMgQ09ORklHX0NS
WVBUT19ERVZfUUFUX0MzWFhYVkYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX1FB
VF9DNjJYVkYgaXMgbm90IHNldAojIENPTkZJR19DUllQVE9fREVWX1ZJUlRJTyBpcyBub3Qg
c2V0CiMgQ09ORklHX0NSWVBUT19ERVZfU0FGRVhDRUwgaXMgbm90IHNldAojIENPTkZJR19D
UllQVE9fREVWX0FNTE9HSUNfR1hMIGlzIG5vdCBzZXQKQ09ORklHX0FTWU1NRVRSSUNfS0VZ
X1RZUEU9eQpDT05GSUdfQVNZTU1FVFJJQ19QVUJMSUNfS0VZX1NVQlRZUEU9eQpDT05GSUdf
WDUwOV9DRVJUSUZJQ0FURV9QQVJTRVI9eQojIENPTkZJR19QS0NTOF9QUklWQVRFX0tFWV9Q
QVJTRVIgaXMgbm90IHNldApDT05GSUdfUEtDUzdfTUVTU0FHRV9QQVJTRVI9eQojIENPTkZJ
R19QS0NTN19URVNUX0tFWSBpcyBub3Qgc2V0CkNPTkZJR19TSUdORURfUEVfRklMRV9WRVJJ
RklDQVRJT049eQojIENPTkZJR19GSVBTX1NJR05BVFVSRV9TRUxGVEVTVCBpcyBub3Qgc2V0
CgojCiMgQ2VydGlmaWNhdGVzIGZvciBzaWduYXR1cmUgY2hlY2tpbmcKIwpDT05GSUdfTU9E
VUxFX1NJR19LRVk9ImNlcnRzL3NpZ25pbmdfa2V5LnBlbSIKQ09ORklHX01PRFVMRV9TSUdf
S0VZX1RZUEVfUlNBPXkKIyBDT05GSUdfTU9EVUxFX1NJR19LRVlfVFlQRV9FQ0RTQSBpcyBu
b3Qgc2V0CkNPTkZJR19TWVNURU1fVFJVU1RFRF9LRVlSSU5HPXkKQ09ORklHX1NZU1RFTV9U
UlVTVEVEX0tFWVM9IiIKQ09ORklHX1NZU1RFTV9FWFRSQV9DRVJUSUZJQ0FURT15CkNPTkZJ
R19TWVNURU1fRVhUUkFfQ0VSVElGSUNBVEVfU0laRT00MDk2CkNPTkZJR19TRUNPTkRBUllf
VFJVU1RFRF9LRVlSSU5HPXkKIyBDT05GSUdfU0VDT05EQVJZX1RSVVNURURfS0VZUklOR19T
SUdORURfQllfQlVJTFRJTiBpcyBub3Qgc2V0CkNPTkZJR19TWVNURU1fQkxBQ0tMSVNUX0tF
WVJJTkc9eQpDT05GSUdfU1lTVEVNX0JMQUNLTElTVF9IQVNIX0xJU1Q9IiIKIyBDT05GSUdf
U1lTVEVNX1JFVk9DQVRJT05fTElTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZU1RFTV9CTEFD
S0xJU1RfQVVUSF9VUERBVEUgaXMgbm90IHNldAojIGVuZCBvZiBDZXJ0aWZpY2F0ZXMgZm9y
IHNpZ25hdHVyZSBjaGVja2luZwoKIyBDT05GSUdfQ1JZUFRPX0tSQjUgaXMgbm90IHNldApD
T05GSUdfQklOQVJZX1BSSU5URj15CgojCiMgTGlicmFyeSByb3V0aW5lcwojCkNPTkZJR19S
QUlENl9QUT1tCkNPTkZJR19SQUlENl9QUV9CRU5DSE1BUks9eQpDT05GSUdfTElORUFSX1JB
TkdFUz15CkNPTkZJR19QQUNLSU5HPXkKQ09ORklHX0JJVFJFVkVSU0U9eQpDT05GSUdfR0VO
RVJJQ19TVFJOQ1BZX0ZST01fVVNFUj15CkNPTkZJR19HRU5FUklDX1NUUk5MRU5fVVNFUj15
CkNPTkZJR19HRU5FUklDX05FVF9VVElMUz15CiMgQ09ORklHX0NPUkRJQyBpcyBub3Qgc2V0
CiMgQ09ORklHX1BSSU1FX05VTUJFUlMgaXMgbm90IHNldApDT05GSUdfUkFUSU9OQUw9eQpD
T05GSUdfR0VORVJJQ19JT01BUD15CkNPTkZJR19BUkNIX1VTRV9DTVBYQ0hHX0xPQ0tSRUY9
eQpDT05GSUdfQVJDSF9IQVNfRkFTVF9NVUxUSVBMSUVSPXkKQ09ORklHX0FSQ0hfVVNFX1NZ
TV9BTk5PVEFUSU9OUz15CkNPTkZJR19DUkMxNj15CkNPTkZJR19DUkNfQ0NJVFQ9eQpDT05G
SUdfQ1JDX0lUVV9UPXkKQ09ORklHX0NSQ19UMTBESUY9eQpDT05GSUdfQ1JDX1QxMERJRl9B
UkNIPXkKQ09ORklHX0NSQzMyPXkKQ09ORklHX0NSQzMyX0FSQ0g9eQpDT05GSUdfQ1JDNjQ9
eQpDT05GSUdfQ1JDNjRfQVJDSD15CkNPTkZJR19DUkNfT1BUSU1JWkFUSU9OUz15CgojCiMg
Q3J5cHRvIGxpYnJhcnkgcm91dGluZXMKIwpDT05GSUdfQ1JZUFRPX0hBU0hfSU5GTz15CkNP
TkZJR19DUllQVE9fTElCX1VUSUxTPXkKQ09ORklHX0NSWVBUT19MSUJfQUVTPXkKQ09ORklH
X0NSWVBUT19MSUJfQUVTQ0ZCPXkKQ09ORklHX0NSWVBUT19MSUJfQUVTR0NNPXkKQ09ORklH
X0NSWVBUT19MSUJfR0YxMjhNVUw9eQpDT05GSUdfQ1JZUFRPX0xJQl9CTEFLRTJCPW0KQ09O
RklHX0NSWVBUT19MSUJfQkxBS0UyU19BUkNIPXkKQ09ORklHX0NSWVBUT19MSUJfQ0hBQ0hB
PW0KQ09ORklHX0NSWVBUT19MSUJfQ0hBQ0hBX0FSQ0g9eQpDT05GSUdfQ1JZUFRPX0xJQl9N
RDU9eQpDT05GSUdfQ1JZUFRPX0xJQl9QT0xZMTMwNV9SU0laRT0xMQpDT05GSUdfQ1JZUFRP
X0xJQl9TSEExPXkKQ09ORklHX0NSWVBUT19MSUJfU0hBMV9BUkNIPXkKQ09ORklHX0NSWVBU
T19MSUJfU0hBMjU2PXkKQ09ORklHX0NSWVBUT19MSUJfU0hBMjU2X0FSQ0g9eQpDT05GSUdf
Q1JZUFRPX0xJQl9TSEE1MTI9eQpDT05GSUdfQ1JZUFRPX0xJQl9TSEE1MTJfQVJDSD15CkNP
TkZJR19DUllQVE9fTElCX1NIQTM9eQojIGVuZCBvZiBDcnlwdG8gbGlicmFyeSByb3V0aW5l
cwoKQ09ORklHX1hYSEFTSD15CiMgQ09ORklHX1JBTkRPTTMyX1NFTEZURVNUIGlzIG5vdCBz
ZXQKQ09ORklHX1pMSUJfSU5GTEFURT15CkNPTkZJR19aTElCX0RFRkxBVEU9eQpDT05GSUdf
TFpPX0NPTVBSRVNTPXkKQ09ORklHX0xaT19ERUNPTVBSRVNTPXkKQ09ORklHX0xaNF9ERUNP
TVBSRVNTPXkKQ09ORklHX1pTVERfQ09NTU9OPXkKQ09ORklHX1pTVERfQ09NUFJFU1M9eQpD
T05GSUdfWlNURF9ERUNPTVBSRVNTPXkKQ09ORklHX1haX0RFQz15CkNPTkZJR19YWl9ERUNf
WDg2PXkKQ09ORklHX1haX0RFQ19QT1dFUlBDPXkKQ09ORklHX1haX0RFQ19BUk09eQpDT05G
SUdfWFpfREVDX0FSTVRIVU1CPXkKQ09ORklHX1haX0RFQ19BUk02ND15CkNPTkZJR19YWl9E
RUNfU1BBUkM9eQpDT05GSUdfWFpfREVDX1JJU0NWPXkKQ09ORklHX1haX0RFQ19NSUNST0xa
TUE9eQpDT05GSUdfWFpfREVDX0JDSj15CiMgQ09ORklHX1haX0RFQ19URVNUIGlzIG5vdCBz
ZXQKQ09ORklHX0RFQ09NUFJFU1NfR1pJUD15CkNPTkZJR19ERUNPTVBSRVNTX0JaSVAyPXkK
Q09ORklHX0RFQ09NUFJFU1NfTFpNQT15CkNPTkZJR19ERUNPTVBSRVNTX1haPXkKQ09ORklH
X0RFQ09NUFJFU1NfTFpPPXkKQ09ORklHX0RFQ09NUFJFU1NfTFo0PXkKQ09ORklHX0RFQ09N
UFJFU1NfWlNURD15CkNPTkZJR19HRU5FUklDX0FMTE9DQVRPUj15CkNPTkZJR19URVhUU0VB
UkNIPXkKQ09ORklHX1RFWFRTRUFSQ0hfS01QPXkKQ09ORklHX1RFWFRTRUFSQ0hfQk09eQpD
T05GSUdfVEVYVFNFQVJDSF9GU009eQpDT05GSUdfSU5URVJWQUxfVFJFRT15CkNPTkZJR19Y
QVJSQVlfTVVMVEk9eQpDT05GSUdfQVNTT0NJQVRJVkVfQVJSQVk9eQpDT05GSUdfSEFTX0lP
TUVNPXkKQ09ORklHX0hBU19JT1BPUlQ9eQpDT05GSUdfSEFTX0lPUE9SVF9NQVA9eQpDT05G
SUdfSEFTX0RNQT15CkNPTkZJR19ETUFfT1BTX0hFTFBFUlM9eQpDT05GSUdfTkVFRF9TR19E
TUFfRkxBR1M9eQpDT05GSUdfTkVFRF9TR19ETUFfTEVOR1RIPXkKQ09ORklHX05FRURfRE1B
X01BUF9TVEFURT15CkNPTkZJR19BUkNIX0RNQV9BRERSX1RfNjRCSVQ9eQpDT05GSUdfQVJD
SF9IQVNfRk9SQ0VfRE1BX1VORU5DUllQVEVEPXkKQ09ORklHX1NXSU9UTEI9eQojIENPTkZJ
R19TV0lPVExCX0RZTkFNSUMgaXMgbm90IHNldApDT05GSUdfRE1BX05FRURfU1lOQz15CkNP
TkZJR19ETUFfQ09IRVJFTlRfUE9PTD15CiMgQ09ORklHX0RNQV9BUElfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19ETUFfTUFQX0JFTkNITUFSSyBpcyBub3Qgc2V0CkNPTkZJR19TR0xf
QUxMT0M9eQpDT05GSUdfSU9NTVVfSEVMUEVSPXkKQ09ORklHX0NQVU1BU0tfT0ZGU1RBQ0s9
eQpDT05GSUdfQ1BVX1JNQVA9eQpDT05GSUdfRFFMPXkKQ09ORklHX0dMT0I9eQojIENPTkZJ
R19HTE9CX1NFTEZURVNUIGlzIG5vdCBzZXQKQ09ORklHX05MQVRUUj15CkNPTkZJR19DTFpf
VEFCPXkKQ09ORklHX0lSUV9QT0xMPXkKQ09ORklHX01QSUxJQj15CkNPTkZJR19TSUdOQVRV
UkU9eQpDT05GSUdfRElNTElCPXkKQ09ORklHX09JRF9SRUdJU1RSWT15CkNPTkZJR19VQ1My
X1NUUklORz15CkNPTkZJR19IQVZFX0dFTkVSSUNfVkRTTz15CkNPTkZJR19HRU5FUklDX0dF
VFRJTUVPRkRBWT15CkNPTkZJR19HRU5FUklDX1ZEU09fT1ZFUkZMT1dfUFJPVEVDVD15CkNP
TkZJR19WRFNPX0dFVFJBTkRPTT15CkNPTkZJR19GT05UX1NVUFBPUlQ9eQpDT05GSUdfRk9O
VFM9eQpDT05GSUdfRk9OVF84eDg9eQpDT05GSUdfRk9OVF84eDE2PXkKIyBDT05GSUdfRk9O
VF82eDExIGlzIG5vdCBzZXQKIyBDT05GSUdfRk9OVF83eDE0IGlzIG5vdCBzZXQKIyBDT05G
SUdfRk9OVF9QRUFSTF84eDggaXMgbm90IHNldApDT05GSUdfRk9OVF9BQ09STl84eDg9eQoj
IENPTkZJR19GT05UX01JTklfNHg2IGlzIG5vdCBzZXQKQ09ORklHX0ZPTlRfNngxMD15CiMg
Q09ORklHX0ZPTlRfMTB4MTggaXMgbm90IHNldAojIENPTkZJR19GT05UX1NVTjh4MTYgaXMg
bm90IHNldAojIENPTkZJR19GT05UX1NVTjEyeDIyIGlzIG5vdCBzZXQKQ09ORklHX0ZPTlRf
VEVSMTZ4MzI9eQojIENPTkZJR19GT05UXzZ4OCBpcyBub3Qgc2V0CkNPTkZJR19TR19QT09M
PXkKQ09ORklHX0FSQ0hfSEFTX1BNRU1fQVBJPXkKQ09ORklHX01FTVJFR0lPTj15CkNPTkZJ
R19BUkNIX0hBU19DUFVfQ0FDSEVfSU5WQUxJREFURV9NRU1SRUdJT049eQpDT05GSUdfQVJD
SF9IQVNfVUFDQ0VTU19GTFVTSENBQ0hFPXkKQ09ORklHX0FSQ0hfSEFTX0NPUFlfTUM9eQpD
T05GSUdfQVJDSF9TVEFDS1dBTEs9eQpDT05GSUdfU1RBQ0tERVBPVD15CkNPTkZJR19TVEFD
S0RFUE9UX01BWF9GUkFNRVM9NjQKQ09ORklHX1NCSVRNQVA9eQojIENPTkZJR19MV1FfVEVT
VCBpcyBub3Qgc2V0CiMgZW5kIG9mIExpYnJhcnkgcm91dGluZXMKCkNPTkZJR19BU04xX0VO
Q09ERVI9eQpDT05GSUdfRklSTVdBUkVfVEFCTEU9eQpDT05GSUdfVU5JT05fRklORD15Cgoj
CiMgS2VybmVsIGhhY2tpbmcKIwoKIwojIHByaW50ayBhbmQgZG1lc2cgb3B0aW9ucwojCkNP
TkZJR19QUklOVEtfVElNRT15CiMgQ09ORklHX1BSSU5US19DQUxMRVIgaXMgbm90IHNldAoj
IENPTkZJR19TVEFDS1RSQUNFX0JVSUxEX0lEIGlzIG5vdCBzZXQKQ09ORklHX0NPTlNPTEVf
TE9HTEVWRUxfREVGQVVMVD03CkNPTkZJR19DT05TT0xFX0xPR0xFVkVMX1FVSUVUPTQKQ09O
RklHX01FU1NBR0VfTE9HTEVWRUxfREVGQVVMVD00CkNPTkZJR19CT09UX1BSSU5US19ERUxB
WT15CkNPTkZJR19EWU5BTUlDX0RFQlVHPXkKQ09ORklHX0RZTkFNSUNfREVCVUdfQ09SRT15
CkNPTkZJR19TWU1CT0xJQ19FUlJOQU1FPXkKQ09ORklHX0RFQlVHX0JVR1ZFUkJPU0U9eQoj
IENPTkZJR19ERUJVR19CVUdWRVJCT1NFX0RFVEFJTEVEIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
cHJpbnRrIGFuZCBkbWVzZyBvcHRpb25zCgpDT05GSUdfREVCVUdfS0VSTkVMPXkKQ09ORklH
X0RFQlVHX01JU0M9eQoKIwojIENvbXBpbGUtdGltZSBjaGVja3MgYW5kIGNvbXBpbGVyIG9w
dGlvbnMKIwpDT05GSUdfREVCVUdfSU5GTz15CkNPTkZJR19BU19IQVNfTk9OX0NPTlNUX1VM
RUIxMjg9eQojIENPTkZJR19ERUJVR19JTkZPX05PTkUgaXMgbm90IHNldAojIENPTkZJR19E
RUJVR19JTkZPX0RXQVJGX1RPT0xDSEFJTl9ERUZBVUxUIGlzIG5vdCBzZXQKQ09ORklHX0RF
QlVHX0lORk9fRFdBUkY0PXkKIyBDT05GSUdfREVCVUdfSU5GT19EV0FSRjUgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19JTkZPX1JFRFVDRUQgaXMgbm90IHNldApDT05GSUdfREVCVUdf
SU5GT19DT01QUkVTU0VEX05PTkU9eQojIENPTkZJR19ERUJVR19JTkZPX0NPTVBSRVNTRURf
WkxJQiBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX0lORk9fQ09NUFJFU1NFRF9aU1REIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfSU5GT19TUExJVCBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFQlVHX0lORk9fQlRGIGlzIG5vdCBzZXQKQ09ORklHX1BBSE9MRV9IQVNfU1BMSVRfQlRG
PXkKQ09ORklHX0dEQl9TQ1JJUFRTPXkKQ09ORklHX0ZSQU1FX1dBUk49MTAyNAojIENPTkZJ
R19TVFJJUF9BU01fU1lNUyBpcyBub3Qgc2V0CiMgQ09ORklHX1JFQURBQkxFX0FTTSBpcyBu
b3Qgc2V0CiMgQ09ORklHX0hFQURFUlNfSU5TVEFMTCBpcyBub3Qgc2V0CiMgQ09ORklHX0RF
QlVHX1NFQ1RJT05fTUlTTUFUQ0ggaXMgbm90IHNldApDT05GSUdfU0VDVElPTl9NSVNNQVRD
SF9XQVJOX09OTFk9eQojIENPTkZJR19ERUJVR19GT1JDRV9GVU5DVElPTl9BTElHTl82NEIg
aXMgbm90IHNldApDT05GSUdfQVJDSF9XQU5UX0ZSQU1FX1BPSU5URVJTPXkKQ09ORklHX0ZS
QU1FX1BPSU5URVI9eQpDT05GSUdfT0JKVE9PTD15CiMgQ09ORklHX09CSlRPT0xfV0VSUk9S
IGlzIG5vdCBzZXQKQ09ORklHX1NUQUNLX1ZBTElEQVRJT049eQpDT05GSUdfVk1MSU5VWF9N
QVA9eQojIENPTkZJR19CVUlMVElOX01PRFVMRV9SQU5HRVMgaXMgbm90IHNldAojIENPTkZJ
R19ERUJVR19GT1JDRV9XRUFLX1BFUl9DUFUgaXMgbm90IHNldAojIGVuZCBvZiBDb21waWxl
LXRpbWUgY2hlY2tzIGFuZCBjb21waWxlciBvcHRpb25zCgojCiMgR2VuZXJpYyBLZXJuZWwg
RGVidWdnaW5nIEluc3RydW1lbnRzCiMKQ09ORklHX01BR0lDX1NZU1JRPXkKQ09ORklHX01B
R0lDX1NZU1JRX0RFRkFVTFRfRU5BQkxFPTB4MDFiNgpDT05GSUdfTUFHSUNfU1lTUlFfU0VS
SUFMPXkKQ09ORklHX01BR0lDX1NZU1JRX1NFUklBTF9TRVFVRU5DRT0iIgpDT05GSUdfREVC
VUdfRlM9eQpDT05GSUdfREVCVUdfRlNfQUxMT1dfQUxMPXkKIyBDT05GSUdfREVCVUdfRlNf
QUxMT1dfTk9ORSBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfS0dEQj15CkNPTkZJR19L
R0RCPXkKQ09ORklHX0tHREJfSE9OT1VSX0JMT0NLTElTVD15CkNPTkZJR19LR0RCX1NFUklB
TF9DT05TT0xFPXkKIyBDT05GSUdfS0dEQl9URVNUUyBpcyBub3Qgc2V0CkNPTkZJR19LR0RC
X0xPV19MRVZFTF9UUkFQPXkKQ09ORklHX0tHREJfS0RCPXkKQ09ORklHX0tEQl9ERUZBVUxU
X0VOQUJMRT0weDEKQ09ORklHX0tEQl9LRVlCT0FSRD15CkNPTkZJR19LREJfQ09OVElOVUVf
Q0FUQVNUUk9QSElDPTAKQ09ORklHX0FSQ0hfSEFTX0VBUkxZX0RFQlVHPXkKQ09ORklHX0FS
Q0hfSEFTX1VCU0FOPXkKQ09ORklHX1VCU0FOPXkKIyBDT05GSUdfVUJTQU5fVFJBUCBpcyBu
b3Qgc2V0CkNPTkZJR19DQ19IQVNfVUJTQU5fQk9VTkRTX1NUUklDVD15CkNPTkZJR19VQlNB
Tl9CT1VORFM9eQpDT05GSUdfVUJTQU5fQk9VTkRTX1NUUklDVD15CkNPTkZJR19VQlNBTl9T
SElGVD15CiMgQ09ORklHX1VCU0FOX0RJVl9aRVJPIGlzIG5vdCBzZXQKQ09ORklHX1VCU0FO
X0JPT0w9eQpDT05GSUdfVUJTQU5fRU5VTT15CiMgQ09ORklHX1VCU0FOX0FMSUdOTUVOVCBp
cyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfVUJTQU4gaXMgbm90IHNldApDT05GSUdfSEFWRV9B
UkNIX0tDU0FOPXkKQ09ORklHX0hBVkVfS0NTQU5fQ09NUElMRVI9eQojIENPTkZJR19LQ1NB
TiBpcyBub3Qgc2V0CiMgZW5kIG9mIEdlbmVyaWMgS2VybmVsIERlYnVnZ2luZyBJbnN0cnVt
ZW50cwoKIwojIE5ldHdvcmtpbmcgRGVidWdnaW5nCiMKIyBDT05GSUdfTkVUX0RFVl9SRUZD
TlRfVFJBQ0tFUiBpcyBub3Qgc2V0CiMgQ09ORklHX05FVF9OU19SRUZDTlRfVFJBQ0tFUiBp
cyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX05FVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVH
X05FVF9TTUFMTF9SVE5MIGlzIG5vdCBzZXQKIyBlbmQgb2YgTmV0d29ya2luZyBEZWJ1Z2dp
bmcKCiMKIyBNZW1vcnkgRGVidWdnaW5nCiMKIyBDT05GSUdfUEFHRV9FWFRFTlNJT04gaXMg
bm90IHNldAojIENPTkZJR19ERUJVR19QQUdFQUxMT0MgaXMgbm90IHNldApDT05GSUdfU0xV
Ql9ERUJVRz15CiMgQ09ORklHX1NMVUJfREVCVUdfT04gaXMgbm90IHNldAojIENPTkZJR19Q
QUdFX09XTkVSIGlzIG5vdCBzZXQKIyBDT05GSUdfUEFHRV9UQUJMRV9DSEVDSyBpcyBub3Qg
c2V0CkNPTkZJR19QQUdFX1BPSVNPTklORz15CiMgQ09ORklHX0RFQlVHX1BBR0VfUkVGIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfUk9EQVRBX1RFU1QgaXMgbm90IHNldApDT05GSUdf
QVJDSF9IQVNfREVCVUdfV1g9eQpDT05GSUdfREVCVUdfV1g9eQpDT05GSUdfQVJDSF9IQVNf
UFREVU1QPXkKQ09ORklHX1BURFVNUD15CiMgQ09ORklHX1BURFVNUF9ERUJVR0ZTIGlzIG5v
dCBzZXQKQ09ORklHX0hBVkVfREVCVUdfS01FTUxFQUs9eQojIENPTkZJR19ERUJVR19LTUVN
TEVBSyBpcyBub3Qgc2V0CiMgQ09ORklHX1BFUl9WTUFfTE9DS19TVEFUUyBpcyBub3Qgc2V0
CiMgQ09ORklHX0RFQlVHX09CSkVDVFMgaXMgbm90IHNldAojIENPTkZJR19TSFJJTktFUl9E
RUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1NUQUNLX1VTQUdFIGlzIG5vdCBzZXQK
Q09ORklHX1NDSEVEX1NUQUNLX0VORF9DSEVDSz15CkNPTkZJR19BUkNIX0hBU19ERUJVR19W
TV9QR1RBQkxFPXkKIyBDT05GSUdfREVCVUdfVkZTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfVk0gaXMgbm90IHNldAojIENPTkZJR19ERUJVR19WTV9QR1RBQkxFIGlzIG5vdCBzZXQK
Q09ORklHX0FSQ0hfSEFTX0RFQlVHX1ZJUlRVQUw9eQojIENPTkZJR19ERUJVR19WSVJUVUFM
IGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTUVNT1JZX0lOSVQgaXMgbm90IHNldAojIENP
TkZJR19ERUJVR19QRVJfQ1BVX01BUFMgaXMgbm90IHNldAojIENPTkZJR19NRU1fQUxMT0Nf
UFJPRklMSU5HIGlzIG5vdCBzZXQKQ09ORklHX0hBVkVfQVJDSF9LQVNBTj15CkNPTkZJR19I
QVZFX0FSQ0hfS0FTQU5fVk1BTExPQz15CkNPTkZJR19DQ19IQVNfS0FTQU5fR0VORVJJQz15
CkNPTkZJR19DQ19IQVNfV09SS0lOR19OT1NBTklUSVpFX0FERFJFU1M9eQojIENPTkZJR19L
QVNBTiBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0FSQ0hfS0ZFTkNFPXkKQ09ORklHX0tGRU5D
RT15CkNPTkZJR19LRkVOQ0VfU0FNUExFX0lOVEVSVkFMPTAKQ09ORklHX0tGRU5DRV9OVU1f
T0JKRUNUUz0yNTUKIyBDT05GSUdfS0ZFTkNFX0RFRkVSUkFCTEUgaXMgbm90IHNldAojIENP
TkZJR19LRkVOQ0VfU1RBVElDX0tFWVMgaXMgbm90IHNldApDT05GSUdfS0ZFTkNFX1NUUkVT
U19URVNUX0ZBVUxUUz0wCkNPTkZJR19IQVZFX0FSQ0hfS01TQU49eQojIGVuZCBvZiBNZW1v
cnkgRGVidWdnaW5nCgojIENPTkZJR19ERUJVR19TSElSUSBpcyBub3Qgc2V0CgojCiMgRGVi
dWcgT29wcywgTG9ja3VwcyBhbmQgSGFuZ3MKIwojIENPTkZJR19QQU5JQ19PTl9PT1BTIGlz
IG5vdCBzZXQKQ09ORklHX1BBTklDX1RJTUVPVVQ9MApDT05GSUdfTE9DS1VQX0RFVEVDVE9S
PXkKQ09ORklHX1NPRlRMT0NLVVBfREVURUNUT1I9eQojIENPTkZJR19CT09UUEFSQU1fU09G
VExPQ0tVUF9QQU5JQyBpcyBub3Qgc2V0CkNPTkZJR19IQVZFX0hBUkRMT0NLVVBfREVURUNU
T1JfQlVERFk9eQpDT05GSUdfSEFSRExPQ0tVUF9ERVRFQ1RPUj15CiMgQ09ORklHX0hBUkRM
T0NLVVBfREVURUNUT1JfUFJFRkVSX0JVRERZIGlzIG5vdCBzZXQKQ09ORklHX0hBUkRMT0NL
VVBfREVURUNUT1JfUEVSRj15CiMgQ09ORklHX0hBUkRMT0NLVVBfREVURUNUT1JfQlVERFkg
aXMgbm90IHNldAojIENPTkZJR19IQVJETE9DS1VQX0RFVEVDVE9SX0FSQ0ggaXMgbm90IHNl
dApDT05GSUdfSEFSRExPQ0tVUF9ERVRFQ1RPUl9DT1VOVFNfSFJUSU1FUj15CkNPTkZJR19I
QVJETE9DS1VQX0NIRUNLX1RJTUVTVEFNUD15CiMgQ09ORklHX0JPT1RQQVJBTV9IQVJETE9D
S1VQX1BBTklDIGlzIG5vdCBzZXQKQ09ORklHX0RFVEVDVF9IVU5HX1RBU0s9eQpDT05GSUdf
REVGQVVMVF9IVU5HX1RBU0tfVElNRU9VVD0xMjAKQ09ORklHX0JPT1RQQVJBTV9IVU5HX1RB
U0tfUEFOSUM9MApDT05GSUdfREVURUNUX0hVTkdfVEFTS19CTE9DS0VSPXkKIyBDT05GSUdf
V1FfV0FUQ0hET0cgaXMgbm90IHNldAojIENPTkZJR19XUV9DUFVfSU5URU5TSVZFX1JFUE9S
VCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfTE9DS1VQIGlzIG5vdCBzZXQKIyBlbmQgb2Yg
RGVidWcgT29wcywgTG9ja3VwcyBhbmQgSGFuZ3MKCiMKIyBTY2hlZHVsZXIgRGVidWdnaW5n
CiMKQ09ORklHX1NDSEVEX0lORk89eQpDT05GSUdfU0NIRURTVEFUUz15CiMgZW5kIG9mIFNj
aGVkdWxlciBEZWJ1Z2dpbmcKCiMgQ09ORklHX0RFQlVHX1BSRUVNUFQgaXMgbm90IHNldAoK
IwojIExvY2sgRGVidWdnaW5nIChzcGlubG9ja3MsIG11dGV4ZXMsIGV0Yy4uLikKIwpDT05G
SUdfTE9DS19ERUJVR0dJTkdfU1VQUE9SVD15CiMgQ09ORklHX1BST1ZFX0xPQ0tJTkcgaXMg
bm90IHNldAojIENPTkZJR19MT0NLX1NUQVQgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19S
VF9NVVRFWEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU1BJTkxPQ0sgaXMgbm90IHNl
dAojIENPTkZJR19ERUJVR19NVVRFWEVTIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfV1df
TVVURVhfU0xPV1BBVEggaXMgbm90IHNldAojIENPTkZJR19ERUJVR19SV1NFTVMgaXMgbm90
IHNldAojIENPTkZJR19ERUJVR19MT0NLX0FMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfQVRPTUlDX1NMRUVQIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdfTE9DS0lOR19BUElf
U0VMRlRFU1RTIGlzIG5vdCBzZXQKIyBDT05GSUdfTE9DS19UT1JUVVJFX1RFU1QgaXMgbm90
IHNldAojIENPTkZJR19XV19NVVRFWF9TRUxGVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1ND
Rl9UT1JUVVJFX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19DU0RfTE9DS19XQUlUX0RFQlVH
IGlzIG5vdCBzZXQKIyBlbmQgb2YgTG9jayBEZWJ1Z2dpbmcgKHNwaW5sb2NrcywgbXV0ZXhl
cywgZXRjLi4uKQoKIyBDT05GSUdfTk1JX0NIRUNLX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklH
X0RFQlVHX0lSUUZMQUdTIGlzIG5vdCBzZXQKQ09ORklHX1NUQUNLVFJBQ0U9eQojIENPTkZJ
R19XQVJOX0FMTF9VTlNFRURFRF9SQU5ET00gaXMgbm90IHNldAojIENPTkZJR19ERUJVR19L
T0JKRUNUIGlzIG5vdCBzZXQKCiMKIyBEZWJ1ZyBrZXJuZWwgZGF0YSBzdHJ1Y3R1cmVzCiMK
IyBDT05GSUdfREVCVUdfTElTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX1BMSVNUIGlz
IG5vdCBzZXQKIyBDT05GSUdfREVCVUdfU0cgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19O
T1RJRklFUlMgaXMgbm90IHNldAojIENPTkZJR19ERUJVR19NQVBMRV9UUkVFIGlzIG5vdCBz
ZXQKIyBlbmQgb2YgRGVidWcga2VybmVsIGRhdGEgc3RydWN0dXJlcwoKIwojIFJDVSBEZWJ1
Z2dpbmcKIwojIENPTkZJR19SQ1VfU0NBTEVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JD
VV9UT1JUVVJFX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19SQ1VfUkVGX1NDQUxFX1RFU1Qg
aXMgbm90IHNldApDT05GSUdfUkNVX0NQVV9TVEFMTF9USU1FT1VUPTYwCkNPTkZJR19SQ1Vf
RVhQX0NQVV9TVEFMTF9USU1FT1VUPTAKIyBDT05GSUdfUkNVX0NQVV9TVEFMTF9DUFVUSU1F
IGlzIG5vdCBzZXQKIyBDT05GSUdfUkNVX1RSQUNFIGlzIG5vdCBzZXQKIyBDT05GSUdfUkNV
X0VRU19ERUJVRyBpcyBub3Qgc2V0CiMgZW5kIG9mIFJDVSBEZWJ1Z2dpbmcKCiMgQ09ORklH
X0RFQlVHX1dRX0ZPUkNFX1JSX0NQVSBpcyBub3Qgc2V0CiMgQ09ORklHX0NQVV9IT1RQTFVH
X1NUQVRFX0NPTlRST0wgaXMgbm90IHNldAojIENPTkZJR19MQVRFTkNZVE9QIGlzIG5vdCBz
ZXQKIyBDT05GSUdfREVCVUdfQ0dST1VQX1JFRiBpcyBub3Qgc2V0CkNPTkZJR19VU0VSX1NU
QUNLVFJBQ0VfU1VQUE9SVD15CkNPTkZJR19OT1BfVFJBQ0VSPXkKQ09ORklHX0hBVkVfUkVU
SE9PSz15CkNPTkZJR19SRVRIT09LPXkKQ09ORklHX0hBVkVfRlVOQ1RJT05fVFJBQ0VSPXkK
Q09ORklHX0hBVkVfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKQ09ORklHX0hBVkVfRlVOQ1RJ
T05fR1JBUEhfRlJFR1M9eQpDT05GSUdfSEFWRV9GVFJBQ0VfR1JBUEhfRlVOQz15CkNPTkZJ
R19IQVZFX0RZTkFNSUNfRlRSQUNFPXkKQ09ORklHX0hBVkVfRFlOQU1JQ19GVFJBQ0VfV0lU
SF9SRUdTPXkKQ09ORklHX0hBVkVfRFlOQU1JQ19GVFJBQ0VfV0lUSF9ESVJFQ1RfQ0FMTFM9
eQpDT05GSUdfSEFWRV9EWU5BTUlDX0ZUUkFDRV9XSVRIX0FSR1M9eQpDT05GSUdfSEFWRV9G
VFJBQ0VfUkVHU19IQVZJTkdfUFRfUkVHUz15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNF
X05PX1BBVENIQUJMRT15CkNPTkZJR19IQVZFX0RZTkFNSUNfRlRSQUNFX1dJVEhfSk1QPXkK
Q09ORklHX0hBVkVfU1lTQ0FMTF9UUkFDRVBPSU5UUz15CkNPTkZJR19IQVZFX0ZFTlRSWT15
CkNPTkZJR19IQVZFX09CSlRPT0xfTUNPVU5UPXkKQ09ORklHX0hBVkVfT0JKVE9PTF9OT1Bf
TUNPVU5UPXkKQ09ORklHX0hBVkVfQ19SRUNPUkRNQ09VTlQ9eQpDT05GSUdfSEFWRV9CVUlM
RFRJTUVfTUNPVU5UX1NPUlQ9eQpDT05GSUdfQlVJTERUSU1FX01DT1VOVF9TT1JUPXkKQ09O
RklHX1RSQUNFUl9NQVhfVFJBQ0U9eQpDT05GSUdfVFJBQ0VfQ0xPQ0s9eQpDT05GSUdfUklO
R19CVUZGRVI9eQpDT05GSUdfRVZFTlRfVFJBQ0lORz15CkNPTkZJR19DT05URVhUX1NXSVRD
SF9UUkFDRVI9eQpDT05GSUdfVFJBQ0lORz15CkNPTkZJR19HRU5FUklDX1RSQUNFUj15CkNP
TkZJR19UUkFDSU5HX1NVUFBPUlQ9eQpDT05GSUdfRlRSQUNFPXkKQ09ORklHX1RSQUNFRlNf
QVVUT01PVU5UX0RFUFJFQ0FURUQ9eQpDT05GSUdfQk9PVFRJTUVfVFJBQ0lORz15CkNPTkZJ
R19GVU5DVElPTl9UUkFDRVI9eQpDT05GSUdfRlVOQ1RJT05fR1JBUEhfVFJBQ0VSPXkKIyBD
T05GSUdfRlVOQ1RJT05fR1JBUEhfUkVUVkFMIGlzIG5vdCBzZXQKIyBDT05GSUdfRlVOQ1RJ
T05fR1JBUEhfUkVUQUREUiBpcyBub3Qgc2V0CkNPTkZJR19EWU5BTUlDX0ZUUkFDRT15CkNP
TkZJR19EWU5BTUlDX0ZUUkFDRV9XSVRIX1JFR1M9eQpDT05GSUdfRFlOQU1JQ19GVFJBQ0Vf
V0lUSF9ESVJFQ1RfQ0FMTFM9eQpDT05GSUdfRFlOQU1JQ19GVFJBQ0VfV0lUSF9BUkdTPXkK
Q09ORklHX0RZTkFNSUNfRlRSQUNFX1dJVEhfSk1QPXkKIyBDT05GSUdfRlVOQ1RJT05fU0VM
Rl9UUkFDSU5HIGlzIG5vdCBzZXQKIyBDT05GSUdfRlBST0JFIGlzIG5vdCBzZXQKQ09ORklH
X0ZVTkNUSU9OX1BST0ZJTEVSPXkKQ09ORklHX1NUQUNLX1RSQUNFUj15CiMgQ09ORklHX0lS
UVNPRkZfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJFRU1QVF9UUkFDRVIgaXMgbm90
IHNldApDT05GSUdfU0NIRURfVFJBQ0VSPXkKQ09ORklHX0hXTEFUX1RSQUNFUj15CiMgQ09O
RklHX09TTk9JU0VfVFJBQ0VSIGlzIG5vdCBzZXQKIyBDT05GSUdfVElNRVJMQVRfVFJBQ0VS
IGlzIG5vdCBzZXQKQ09ORklHX01NSU9UUkFDRT15CkNPTkZJR19GVFJBQ0VfU1lTQ0FMTFM9
eQpDT05GSUdfVFJBQ0VfU1lTQ0FMTF9CVUZfU0laRV9ERUZBVUxUPTYzCkNPTkZJR19UUkFD
RVJfU05BUFNIT1Q9eQojIENPTkZJR19UUkFDRVJfU05BUFNIT1RfUEVSX0NQVV9TV0FQIGlz
IG5vdCBzZXQKQ09ORklHX0JSQU5DSF9QUk9GSUxFX05PTkU9eQojIENPTkZJR19QUk9GSUxF
X0FOTk9UQVRFRF9CUkFOQ0hFUyBpcyBub3Qgc2V0CkNPTkZJR19CTEtfREVWX0lPX1RSQUNF
PXkKQ09ORklHX0tQUk9CRV9FVkVOVFM9eQojIENPTkZJR19LUFJPQkVfRVZFTlRTX09OX05P
VFJBQ0UgaXMgbm90IHNldApDT05GSUdfVVBST0JFX0VWRU5UUz15CkNPTkZJR19FUFJPQkVf
RVZFTlRTPXkKQ09ORklHX0JQRl9FVkVOVFM9eQpDT05GSUdfRFlOQU1JQ19FVkVOVFM9eQpD
T05GSUdfUFJPQkVfRVZFTlRTPXkKQ09ORklHX0JQRl9LUFJPQkVfT1ZFUlJJREU9eQpDT05G
SUdfRlRSQUNFX01DT1VOVF9VU0VfQ0M9eQpDT05GSUdfVFJBQ0lOR19NQVA9eQpDT05GSUdf
U1lOVEhfRVZFTlRTPXkKIyBDT05GSUdfVVNFUl9FVkVOVFMgaXMgbm90IHNldApDT05GSUdf
SElTVF9UUklHR0VSUz15CkNPTkZJR19UUkFDRV9FVkVOVF9JTkpFQ1Q9eQojIENPTkZJR19U
UkFDRVBPSU5UX0JFTkNITUFSSyBpcyBub3Qgc2V0CiMgQ09ORklHX1JJTkdfQlVGRkVSX0JF
TkNITUFSSyBpcyBub3Qgc2V0CiMgQ09ORklHX1RSQUNFX0VWQUxfTUFQX0ZJTEUgaXMgbm90
IHNldAojIENPTkZJR19GVFJBQ0VfUkVDT1JEX1JFQ1VSU0lPTiBpcyBub3Qgc2V0CiMgQ09O
RklHX0ZUUkFDRV9WQUxJREFURV9SQ1VfSVNfV0FUQ0hJTkcgaXMgbm90IHNldAojIENPTkZJ
R19GVFJBQ0VfU1RBUlRVUF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfRlRSQUNFX1NPUlRf
U1RBUlRVUF9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUklOR19CVUZGRVJfU1RBUlRVUF9U
RVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfUklOR19CVUZGRVJfVkFMSURBVEVfVElNRV9ERUxU
QVMgaXMgbm90IHNldAojIENPTkZJR19NTUlPVFJBQ0VfVEVTVCBpcyBub3Qgc2V0CiMgQ09O
RklHX1BSRUVNUFRJUlFfREVMQVlfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1NZTlRIX0VW
RU5UX0dFTl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfS1BST0JFX0VWRU5UX0dFTl9URVNU
IGlzIG5vdCBzZXQKIyBDT05GSUdfSElTVF9UUklHR0VSU19ERUJVRyBpcyBub3Qgc2V0CiMg
Q09ORklHX1JWIGlzIG5vdCBzZXQKIyBDT05GSUdfUFJPVklERV9PSENJMTM5NF9ETUFfSU5J
VCBpcyBub3Qgc2V0CkNPTkZJR19TQU1QTEVTPXkKIyBDT05GSUdfU0FNUExFX1RSQUNFX0VW
RU5UUyBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRV9UUkFDRV9DVVNUT01fRVZFTlRTIGlz
IG5vdCBzZXQKIyBDT05GSUdfU0FNUExFX1RSQUNFX1BSSU5USyBpcyBub3Qgc2V0CiMgQ09O
RklHX1NBTVBMRV9GVFJBQ0VfRElSRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNUExFX0ZU
UkFDRV9ESVJFQ1RfTVVMVEkgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVfRlRSQUNFX09Q
UyBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRV9UUkFDRV9BUlJBWSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBTVBMRV9LT0JKRUNUIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNUExFX0tQUk9C
RVMgaXMgbm90IHNldAojIENPTkZJR19TQU1QTEVfSFdfQlJFQUtQT0lOVCBpcyBub3Qgc2V0
CiMgQ09ORklHX1NBTVBMRV9LRklGTyBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRV9LREIg
aXMgbm90IHNldAojIENPTkZJR19TQU1QTEVfTElWRVBBVENIIGlzIG5vdCBzZXQKIyBDT05G
SUdfU0FNUExFX0NPTkZJR0ZTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNUExFX1RTTV9NUiBp
cyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRV9WRklPX01ERVZfTVRUWSBpcyBub3Qgc2V0CiMg
Q09ORklHX1NBTVBMRV9WRklPX01ERVZfTURQWSBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBM
RV9WRklPX01ERVZfTURQWV9GQiBpcyBub3Qgc2V0CiMgQ09ORklHX1NBTVBMRV9WRklPX01E
RVZfTUJPQ0hTIGlzIG5vdCBzZXQKIyBDT05GSUdfU0FNUExFX0hVTkdfVEFTSyBpcyBub3Qg
c2V0CgojCiMgREFNT04gU2FtcGxlcwojCiMgZW5kIG9mIERBTU9OIFNhbXBsZXMKCkNPTkZJ
R19IQVZFX1NBTVBMRV9GVFJBQ0VfRElSRUNUPXkKQ09ORklHX0hBVkVfU0FNUExFX0ZUUkFD
RV9ESVJFQ1RfTVVMVEk9eQpDT05GSUdfQVJDSF9IQVNfREVWTUVNX0lTX0FMTE9XRUQ9eQpD
T05GSUdfU1RSSUNUX0RFVk1FTT15CiMgQ09ORklHX0lPX1NUUklDVF9ERVZNRU0gaXMgbm90
IHNldAoKIwojIHg4NiBEZWJ1Z2dpbmcKIwpDT05GSUdfRUFSTFlfUFJJTlRLX1VTQj15CiMg
Q09ORklHX1g4Nl9WRVJCT1NFX0JPT1RVUCBpcyBub3Qgc2V0CkNPTkZJR19FQVJMWV9QUklO
VEs9eQpDT05GSUdfRUFSTFlfUFJJTlRLX0RCR1A9eQpDT05GSUdfRUFSTFlfUFJJTlRLX1VT
Ql9YREJDPXkKIyBDT05GSUdfRUZJX1BHVF9EVU1QIGlzIG5vdCBzZXQKIyBDT05GSUdfREVC
VUdfVExCRkxVU0ggaXMgbm90IHNldAojIENPTkZJR19JT01NVV9ERUJVRyBpcyBub3Qgc2V0
CkNPTkZJR19IQVZFX01NSU9UUkFDRV9TVVBQT1JUPXkKIyBDT05GSUdfWDg2X0RFQ09ERVJf
U0VMRlRFU1QgaXMgbm90IHNldAojIENPTkZJR19JT19ERUxBWV8wWDgwIGlzIG5vdCBzZXQK
Q09ORklHX0lPX0RFTEFZXzBYRUQ9eQojIENPTkZJR19JT19ERUxBWV9VREVMQVkgaXMgbm90
IHNldAojIENPTkZJR19JT19ERUxBWV9OT05FIGlzIG5vdCBzZXQKIyBDT05GSUdfREVCVUdf
Qk9PVF9QQVJBTVMgaXMgbm90IHNldAojIENPTkZJR19DUEFfREVCVUcgaXMgbm90IHNldAoj
IENPTkZJR19ERUJVR19FTlRSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0RFQlVHX05NSV9TRUxG
VEVTVCBpcyBub3Qgc2V0CkNPTkZJR19YODZfREVCVUdfRlBVPXkKIyBDT05GSUdfUFVOSVRf
QVRPTV9ERUJVRyBpcyBub3Qgc2V0CiMgQ09ORklHX1VOV0lOREVSX09SQyBpcyBub3Qgc2V0
CkNPTkZJR19VTldJTkRFUl9GUkFNRV9QT0lOVEVSPXkKIyBlbmQgb2YgeDg2IERlYnVnZ2lu
ZwoKIwojIEtlcm5lbCBUZXN0aW5nIGFuZCBDb3ZlcmFnZQojCiMgQ09ORklHX0tVTklUIGlz
IG5vdCBzZXQKIyBDT05GSUdfTk9USUZJRVJfRVJST1JfSU5KRUNUSU9OIGlzIG5vdCBzZXQK
Q09ORklHX0ZVTkNUSU9OX0VSUk9SX0lOSkVDVElPTj15CiMgQ09ORklHX0ZBVUxUX0lOSkVD
VElPTiBpcyBub3Qgc2V0CkNPTkZJR19BUkNIX0hBU19LQ09WPXkKIyBDT05GSUdfS0NPViBp
cyBub3Qgc2V0CkNPTkZJR19SVU5USU1FX1RFU1RJTkdfTUVOVT15CiMgQ09ORklHX1RFU1Rf
REhSWSBpcyBub3Qgc2V0CiMgQ09ORklHX0xLRFRNIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVT
VF9NSU5fSEVBUCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfRElWNjQgaXMgbm90IHNldAoj
IENPTkZJR19URVNUX01VTERJVjY0IGlzIG5vdCBzZXQKIyBDT05GSUdfQkFDS1RSQUNFX1NF
TEZfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfUkVGX1RSQUNLRVIgaXMgbm90IHNl
dAojIENPTkZJR19SQlRSRUVfVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX1JFRURfU09MT01P
Tl9URVNUIGlzIG5vdCBzZXQKIyBDT05GSUdfSU5URVJWQUxfVFJFRV9URVNUIGlzIG5vdCBz
ZXQKIyBDT05GSUdfUEVSQ1BVX1RFU1QgaXMgbm90IHNldAojIENPTkZJR19BVE9NSUM2NF9T
RUxGVEVTVCBpcyBub3Qgc2V0CiMgQ09ORklHX0FTWU5DX1JBSUQ2X1RFU1QgaXMgbm90IHNl
dAojIENPTkZJR19URVNUX0hFWERVTVAgaXMgbm90IHNldAojIENPTkZJR19URVNUX0tTVFJU
T1ggaXMgbm90IHNldAojIENPTkZJR19URVNUX0JJVE1BUCBpcyBub3Qgc2V0CiMgQ09ORklH
X1RFU1RfVVVJRCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfWEFSUkFZIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEVTVF9NQVBMRV9UUkVFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9SSEFT
SFRBQkxFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9JREEgaXMgbm90IHNldAojIENPTkZJ
R19URVNUX0xLTSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfQklUT1BTIGlzIG5vdCBzZXQK
IyBDT05GSUdfVEVTVF9WTUFMTE9DIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9CUEYgaXMg
bm90IHNldAojIENPTkZJR19GSU5EX0JJVF9CRU5DSE1BUksgaXMgbm90IHNldAojIENPTkZJ
R19URVNUX0ZJUk1XQVJFIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9TWVNDVEwgaXMgbm90
IHNldAojIENPTkZJR19URVNUX1VERUxBWSBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfU1RB
VElDX0tFWVMgaXMgbm90IHNldAojIENPTkZJR19URVNUX0RZTkFNSUNfREVCVUcgaXMgbm90
IHNldAojIENPTkZJR19URVNUX0tNT0QgaXMgbm90IHNldAojIENPTkZJR19URVNUX0tBTExT
WU1TIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9NRU1DQVRfUCBpcyBub3Qgc2V0CiMgQ09O
RklHX1RFU1RfTUVNSU5JVCBpcyBub3Qgc2V0CiMgQ09ORklHX1RFU1RfSE1NIGlzIG5vdCBz
ZXQKIyBDT05GSUdfVEVTVF9GUkVFX1BBR0VTIGlzIG5vdCBzZXQKIyBDT05GSUdfVEVTVF9G
UFUgaXMgbm90IHNldAojIENPTkZJR19URVNUX0NMT0NLU09VUkNFX1dBVENIRE9HIGlzIG5v
dCBzZXQKIyBDT05GSUdfVEVTVF9PQkpQT09MIGlzIG5vdCBzZXQKQ09ORklHX0FSQ0hfVVNF
X01FTVRFU1Q9eQpDT05GSUdfTUVNVEVTVD15CiMgZW5kIG9mIEtlcm5lbCBUZXN0aW5nIGFu
ZCBDb3ZlcmFnZQoKIwojIFJ1c3QgaGFja2luZwojCiMgZW5kIG9mIFJ1c3QgaGFja2luZwoj
IGVuZCBvZiBLZXJuZWwgaGFja2luZwoKQ09ORklHX0lPX1VSSU5HX1pDUlg9eQo=

--------------BLLuAkKzZElrh17i1JLNc4sT--
