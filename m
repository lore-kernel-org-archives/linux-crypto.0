Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3E53FF1;
	Tue,  2 Dec 2025 02:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764643613; cv=fail; b=OMdz8ADztwahKeKvUkOwjThcYerytcJ5ipKFn+3VLw6CBiFj78Y6Lz1U4Q8efYhlBSVjrJQvORklaS+KvV3lUjQOaYo8j4+DKb49/akeDG6+/5m1hSM//ESSZEMVfhj7kceUkduuBCMoHYxQ4qcG3TBT1tneM0+QtzrustnxvRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764643613; c=relaxed/simple;
	bh=LC3AOYgG/ZxfT4TmIcusg6VkAbeGtR3QcpofLW92YJQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ki5GqWQD6ojDJ4fb9B66yqo6Fk4d59yOlxa59QPYJKIOb12Il/e/Q1rvFRZo3Vsju4Wy3/isFSf1zHSL/q0T45CAs24+dNF7OrMTK1yqQE7dW34EhlOlJIZ+9ZOuqG/vTNvU93UeFX8IJtIaGJqR832S6M1buBqNxkxxOp43KJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vwl4O4e9; arc=fail smtp.client-ip=40.107.200.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vwl4O4e9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tg+dwgJVY2nsN6pHq4625H6vWjOfgxhhumRafx534e9JKAFMq/ZXRRfrVkCv3MZKZiJLLocXSAujmNxfoPn+gKrorot86ZVzL/gtjHV5BKKWdI0bGZIWo5iJB9YAzrvYQa2lmUYyPVqE3kI4NkoRotUll/7iUq5eDLE3K+Rdwl+5RQ6TzkY31LfNqDeyMJtQB24kGqRS6k6rGicDQ5jSCwUSWtnwqu4P5n9wNI30YyUMsfkkCGCD24Huf6cUtIv4Ou1aqem11TWmb1UkJTyqmHZozsGyu2yemJRZXcai31M/0IC7arp8gu1LYK+OaGzpnZ5EQzh5ehu3SCy6N7BpgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zLRGocYr7kC8D5uzAB9zq1UjLdvfbyGkEFiNr7flw0k=;
 b=Voj4gAy6IM4hH/RH8OFYUUx9UIq/IW5jKnjWOVCOZBQUDWAh7qKLsVjStPjat/fx353FXGjLWZ0hh5XHMQEw//71HyNqvrwwBLp/Bj0++XG4L+BQMsvmqBex041ByreST8zD2Vf6wU1xGAIxaMpVylFHm0sq9pq0Pbs3MmlZCCNbdQ7f8bv3PZQg4xU5q1tJ+8l2hj5rZaVzRyiQx0S9mCXL3LEx/JCJ1+MApq6iUnWTooYtXnXBtBNSWAGBXRqa7Lq89ofJcX79CUmIuXUnQ8cG6BhNxYqNy1VBFtIkNBGEadYTGiBolZv2ehGaNoN+tX41bomiFr8lZt7s+RrlvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zLRGocYr7kC8D5uzAB9zq1UjLdvfbyGkEFiNr7flw0k=;
 b=vwl4O4e92zpgIuIG0xkh4XMTOFuzpEA3r3Hz9PtZipjjeWzg6g5ms5T8gF1p4ghcpK3fknTdm/MnAsFDAnBzGm8Px40Ss3vIEBl8tZjZ5quW9f/KSEqBZOYCQyeiqN8Itq4hrgNpixmErAlDqyhxoI0UBgOo6Nbgl4qYA6VEMJU=
Received: from SJ0PR05CA0013.namprd05.prod.outlook.com (2603:10b6:a03:33b::18)
 by DM4PR12MB6110.namprd12.prod.outlook.com (2603:10b6:8:ad::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.17; Tue, 2 Dec 2025 02:46:47 +0000
Received: from SJ5PEPF000001EC.namprd05.prod.outlook.com
 (2603:10b6:a03:33b:cafe::e4) by SJ0PR05CA0013.outlook.office365.com
 (2603:10b6:a03:33b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Tue, 2
 Dec 2025 02:46:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001EC.mail.protection.outlook.com (10.167.242.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Tue, 2 Dec 2025 02:46:46 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 20:46:32 -0600
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
Subject: [PATCH kernel v3 2/4] psp-sev: Assign numbers to all status codes and add new
Date: Tue, 2 Dec 2025 13:44:47 +1100
Message-ID: <20251202024449.542361-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EC:EE_|DM4PR12MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: d26a9c0c-6e2c-4b89-6f13-08de314d0944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GNmHk0VyOefebGb4018Io347R89HUAceW92itne7g5NszS7g7EiNPPljO3O4?=
 =?us-ascii?Q?JEMMG3sRnxayhWqO+S4188XafnxADnOBEZqjNGGSz8iBJTEl5S6U3ZTzBnxy?=
 =?us-ascii?Q?hTI2EinMth3FRq2uEYVwQ0YVHIZKG3NyLp7nTaaGzB+DFfx4zEW5PD63iKJs?=
 =?us-ascii?Q?pblZ8qqkaUYCtUqZhrwAiFGWWaB28OGZv7NGDgn7bhtmtx7fvUHTWci+SlY3?=
 =?us-ascii?Q?BX5yVEYLMA1qHLJIEneFvdkKDhVsTZTU1RMIw1PP3y0OTsxABtgia5cKxlLA?=
 =?us-ascii?Q?d3a4PHwn165fWV/wovuKzMYJRwA2r+2fSUJkgtKAQseM9ruyjJeMW4m+lXvW?=
 =?us-ascii?Q?9Uns4iQF20coE1EYCMfgI0+Ih/d3ut+UoMhqO8MMaWs39uPp1WSJET2qoQMc?=
 =?us-ascii?Q?M8N/+AumE4PMtfqaqMnuPQRNKniiD6LVTkt+G9cI43JJ/0EPx3kpr/MY9JOx?=
 =?us-ascii?Q?CJNbi+rAYrUf6CIcmzo+d1g3aEJRJCAdIMWP6G2lzQTJ0amNPpBvLobuivQl?=
 =?us-ascii?Q?ja7QJ+rSdy+3Mwv7N9xHmEzIZVcjqTUzzZYVxkoDejJf2GXSXkQn212QUr6+?=
 =?us-ascii?Q?YruO/Tx/CTQreAAzgVPwOAy4/DW5NO8wWyqeI/QXF8TOsGKrhj5baDnrd8CO?=
 =?us-ascii?Q?Kw9yk184+mQ3BBiKJgDz2nPin0D+DCHlFq12yo5jzSKBc3Mx8K0+dBek0lGZ?=
 =?us-ascii?Q?Sr9e0TE0zGeqFDiNy70nQpQ+xjX+H/RUoautBl6+OHM48pR+uhYDrvX/CozQ?=
 =?us-ascii?Q?unlANIfgYCyoqWbLdvwOF9nNoOVS/CNKgsZzivABL33uXGdiH1B0t9fH7e6H?=
 =?us-ascii?Q?69ZbBmLehb32UYENp8BLUeU4dLCgJO0ZlolNo5oze0CXe1bOc7CotH81A2Xv?=
 =?us-ascii?Q?lbosj6dy9WjsfTVexnKxEwR3nMUE3HcroZxdNo4Yn3Ajy5m8i4AqH9+w99rh?=
 =?us-ascii?Q?0FSw3F1UIbfEO48M7p/GJrl9vHRS6VMB+Vr0rq29S585/ifMBzMI1++CRMwm?=
 =?us-ascii?Q?AmDI6vkwAeHTZ4S9U8PZswLmjMAar/IMn01bOxFhOm3wF/Nni7HIsuAODJhd?=
 =?us-ascii?Q?0ByHwKU+ngW98pOmy+XcvNltaklzbB39M4z8fxLISqqZ2kgQJdA3dm1j+oo7?=
 =?us-ascii?Q?muFcraD1+8cB9uhF3UY4itcxG0jq7qnP+vGcQGaG3kwuQDjbD4BwwRn4bjc9?=
 =?us-ascii?Q?K0g1xjPh/3PnIWpYBZALwngMjUDIMErcewByDW+RNp8ogu06GUPrFaYix0G+?=
 =?us-ascii?Q?Azdrw4j5X4DNU8vKHOrd1XQBWnMG4y6Xv4K4neQL+LcafKJssaaD+mRHf70h?=
 =?us-ascii?Q?B7gIp9yBMMfdyqMWZjttXnN5Ev522aF8ZE+0CB2qg+krtgjbwkZ5oPjqmco4?=
 =?us-ascii?Q?2j+0p3Qc5HCpxIaNzIN0k83oYPxrMj6Bob0v+pb8hSMgaC0/q7FB9t4/+kWQ?=
 =?us-ascii?Q?iESr0Bp302hN5NGQuIy9qKHmKmDNU1fV2BcjHEbpgdQipUe7Vaao6Lb8YiMs?=
 =?us-ascii?Q?SyjrHcp/t8g9iraxnAkP4CXJ2+e5mZXpGfNA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 02:46:46.9578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d26a9c0c-6e2c-4b89-6f13-08de314d0944
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6110

Make the definitions explicit. Add some more new codes.

The following patches will be using SPDM_REQUEST and
EXPAND_BUFFER_LENGTH_REQUEST, others are useful for the PSP FW
diagnostics.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Link: https://patch.msgid.link/20251121080629.444992-3-aik@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/uapi/linux/psp-sev.h | 66 ++++++++++++--------
 1 file changed, 41 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index c2fd324623c4..2b5b042eb73b 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -47,32 +47,32 @@ typedef enum {
 	 * with possible values from the specification.
 	 */
 	SEV_RET_NO_FW_CALL = -1,
-	SEV_RET_SUCCESS = 0,
-	SEV_RET_INVALID_PLATFORM_STATE,
-	SEV_RET_INVALID_GUEST_STATE,
-	SEV_RET_INAVLID_CONFIG,
+	SEV_RET_SUCCESS                    = 0,
+	SEV_RET_INVALID_PLATFORM_STATE     = 0x0001,
+	SEV_RET_INVALID_GUEST_STATE        = 0x0002,
+	SEV_RET_INAVLID_CONFIG             = 0x0003,
 	SEV_RET_INVALID_CONFIG = SEV_RET_INAVLID_CONFIG,
-	SEV_RET_INVALID_LEN,
-	SEV_RET_ALREADY_OWNED,
-	SEV_RET_INVALID_CERTIFICATE,
-	SEV_RET_POLICY_FAILURE,
-	SEV_RET_INACTIVE,
-	SEV_RET_INVALID_ADDRESS,
-	SEV_RET_BAD_SIGNATURE,
-	SEV_RET_BAD_MEASUREMENT,
-	SEV_RET_ASID_OWNED,
-	SEV_RET_INVALID_ASID,
-	SEV_RET_WBINVD_REQUIRED,
-	SEV_RET_DFFLUSH_REQUIRED,
-	SEV_RET_INVALID_GUEST,
-	SEV_RET_INVALID_COMMAND,
-	SEV_RET_ACTIVE,
-	SEV_RET_HWSEV_RET_PLATFORM,
-	SEV_RET_HWSEV_RET_UNSAFE,
-	SEV_RET_UNSUPPORTED,
-	SEV_RET_INVALID_PARAM,
-	SEV_RET_RESOURCE_LIMIT,
-	SEV_RET_SECURE_DATA_INVALID,
+	SEV_RET_INVALID_LEN                = 0x0004,
+	SEV_RET_ALREADY_OWNED              = 0x0005,
+	SEV_RET_INVALID_CERTIFICATE        = 0x0006,
+	SEV_RET_POLICY_FAILURE             = 0x0007,
+	SEV_RET_INACTIVE                   = 0x0008,
+	SEV_RET_INVALID_ADDRESS            = 0x0009,
+	SEV_RET_BAD_SIGNATURE              = 0x000A,
+	SEV_RET_BAD_MEASUREMENT            = 0x000B,
+	SEV_RET_ASID_OWNED                 = 0x000C,
+	SEV_RET_INVALID_ASID               = 0x000D,
+	SEV_RET_WBINVD_REQUIRED            = 0x000E,
+	SEV_RET_DFFLUSH_REQUIRED           = 0x000F,
+	SEV_RET_INVALID_GUEST              = 0x0010,
+	SEV_RET_INVALID_COMMAND            = 0x0011,
+	SEV_RET_ACTIVE                     = 0x0012,
+	SEV_RET_HWSEV_RET_PLATFORM         = 0x0013,
+	SEV_RET_HWSEV_RET_UNSAFE           = 0x0014,
+	SEV_RET_UNSUPPORTED                = 0x0015,
+	SEV_RET_INVALID_PARAM              = 0x0016,
+	SEV_RET_RESOURCE_LIMIT             = 0x0017,
+	SEV_RET_SECURE_DATA_INVALID        = 0x0018,
 	SEV_RET_INVALID_PAGE_SIZE          = 0x0019,
 	SEV_RET_INVALID_PAGE_STATE         = 0x001A,
 	SEV_RET_INVALID_MDATA_ENTRY        = 0x001B,
@@ -87,6 +87,22 @@ typedef enum {
 	SEV_RET_RESTORE_REQUIRED           = 0x0025,
 	SEV_RET_RMP_INITIALIZATION_FAILED  = 0x0026,
 	SEV_RET_INVALID_KEY                = 0x0027,
+	SEV_RET_SHUTDOWN_INCOMPLETE        = 0x0028,
+	SEV_RET_INCORRECT_BUFFER_LENGTH	   = 0x0030,
+	SEV_RET_EXPAND_BUFFER_LENGTH_REQUEST = 0x0031,
+	SEV_RET_SPDM_REQUEST               = 0x0032,
+	SEV_RET_SPDM_ERROR                 = 0x0033,
+	SEV_RET_SEV_STATUS_ERR_IN_DEV_CONN = 0x0035,
+	SEV_RET_SEV_STATUS_INVALID_DEV_CTX = 0x0036,
+	SEV_RET_SEV_STATUS_INVALID_TDI_CTX = 0x0037,
+	SEV_RET_SEV_STATUS_INVALID_TDI     = 0x0038,
+	SEV_RET_SEV_STATUS_RECLAIM_REQUIRED = 0x0039,
+	SEV_RET_IN_USE                     = 0x003A,
+	SEV_RET_SEV_STATUS_INVALID_DEV_STATE = 0x003B,
+	SEV_RET_SEV_STATUS_INVALID_TDI_STATE = 0x003C,
+	SEV_RET_SEV_STATUS_DEV_CERT_CHANGED = 0x003D,
+	SEV_RET_SEV_STATUS_RESYNC_REQ      = 0x003E,
+	SEV_RET_SEV_STATUS_RESPONSE_TOO_LARGE = 0x003F,
 	SEV_RET_MAX,
 } sev_ret_code;
 
-- 
2.51.1

