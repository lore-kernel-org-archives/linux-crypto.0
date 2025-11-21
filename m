Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F442F8BCD;
	Fri, 21 Nov 2025 08:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763712481; cv=fail; b=UkxPYYWORT3FbleX9W8MlpYPLfcS+SEyKyYTaz8s3kCkJdkpwUCwBREwzEoIjeSSC85AE69VmObAYgbKHMbYdN/dpKDIsQN/D+rUrZCQfZDdfGoBPnparfN8dWOTbv5jJgcPYkRgHeu34RvYy16UTNzTkIEgOlyIx7qMrvrLJCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763712481; c=relaxed/simple;
	bh=mtbj9BcCXZ+HbP0JZoZMpEx/k3RYiOl2HMocVlkDQKA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+2alfXA3IgVpU4Lrwn3tWR+vKzPEPYoLWUCGjsDyRn4Hqktbw3+lturSYCerQZ4501gyn6cXdsQ5feeqtT124nzL5ihJ7vRKYP2e44uN3QlmMgxvhn8QCtz8GTtvlNbOLHOzSC0qF4urfuNxVIrb5VjWKBFGc4T23lWQPvQXEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Te/qqWEy; arc=fail smtp.client-ip=40.107.200.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Te/qqWEy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QTlkKcqnuOmcKFCufIeqkNINfqKR5yqGOfwHMjXMM0l0VU3LchC7GpA03+tpQITl1yesAIIfjWFTSy1rwZfzdD+G8mRm0H6Sc2SHkDS2oHjQafMnLzzwgXzDbb8rV37zLFiNu3PXRcOHs4Fhlocktxt96MZFTGn55/TElTN5EFU6nbJvy4X08y5HWS8Rdu19UCEBoLAyH+DIzvKanDBwBASbzW8mHM9+SBemJs8YpRB+owBF3Xq0yPyx5toJsiOol97gW1ujI3ZmBf+qCtHoUv/gC197ZNM8an1hRHTJ7IMrvtDbKAhWq6l1BE94vzJLInQC3OLK+6LGq2ivKrut7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LlyfLyyyH0IEfszPb4PAEgt3/VBclYGV/TLxzpIQq4=;
 b=dhwjQ7WCr33Ovfop4vw53BdFoEb90hXnNp460QaAiE1PM0OHo0Zh9grnu8Q2Syjlb0Kla03ur8ljszomsKROvxRquLI6+n/tyQ3zveID0faNeKHo9KWh8InZyw3MTcWoY1/kp24MdL4s2N6o1g2/2sm6wrkwY6Ib3yUcmx1VxfCLgMjxC884exEVVZuI9zz1/D3yoTVHJN8VkfpTIW+G2oz3d0koSQeODmjFu8PAwjZVvVULszQTIExWqLKAl9E/uWmkue1cGZKfEsEyfRchJFo88yR+tJY8HA7buOd7WWlGeAQWCJVTcxJNx9N2xHH/puY+SksyTahnEaDNCPdnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LlyfLyyyH0IEfszPb4PAEgt3/VBclYGV/TLxzpIQq4=;
 b=Te/qqWEykdJydBI+QWfu1lKSH6XPtF+RkVIWNGsyHCP6xSWrOXpB7i1FkgwgWWf3RlpNVZ3EZm7WndqM1eMWBj3lDLuNrODper9XhZp1XZV0FVcLWRet5hLGvlSea2ARrPNtEB7z/3j8oJAI7hofqj6ku/SXQ1zAcPZy9IWV94U=
Received: from CY8PR19CA0044.namprd19.prod.outlook.com (2603:10b6:930:6::13)
 by CY5PR12MB6645.namprd12.prod.outlook.com (2603:10b6:930:42::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 08:07:52 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:930:6:cafe::94) by CY8PR19CA0044.outlook.office365.com
 (2603:10b6:930:6::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:07:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:07:52 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:07:40 -0800
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
Subject: [PATCH kernel v2 2/5] psp-sev: Assign numbers to all status codes and add new
Date: Fri, 21 Nov 2025 19:06:26 +1100
Message-ID: <20251121080629.444992-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|CY5PR12MB6645:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8a701a-782c-45f1-df7b-08de28d511f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iL39OT1iwzXzUI33EjTdpGgyNpt2o0fFC4h9a8zzvspHFjydadAlGglPW+B9?=
 =?us-ascii?Q?wHTOD1z6RRHLyU3l0cnEW2XMpHyKBnfrc77Mrmo5v/Jcb7Qk77ckCmlhUmIY?=
 =?us-ascii?Q?FRqyThgLVeYANntXapneaqRO8XvePbtwaBqRVl6Qd4Ul3pjQyMo9k9+oU2aZ?=
 =?us-ascii?Q?FT7If9WpRmZLM4wc82pokk1bw4k487uf9/ZXGj7X5lOm73Pry8MHcHt8r/XV?=
 =?us-ascii?Q?XCCYQPvejp8B9DVhy5XYSIkI8PJZN2umZCa2U9kAwstOLgCFNroC5GbKnVln?=
 =?us-ascii?Q?h16SySd3T0TSfCVuoQYOo7DvcylHLggbgzUeLfmWUG3uEb96PMOk+qOq194j?=
 =?us-ascii?Q?i49qBpiXAkYQxmi48p4t1AnrPiFZrWEfUHIzdcKnCnMZ+GL1G9akmKaC3Fuk?=
 =?us-ascii?Q?YW/jzk/AKxLzV2JxAbeOvyJ5qxx/b9HZZZZPnLqvx2j3eDQifrrjZA0E56Hm?=
 =?us-ascii?Q?gnLbjjhHFHCqsaremL9ffJ7w01bisGo1/KUyx3kipMTizQ1Do9bhlJjkPnsr?=
 =?us-ascii?Q?nhJ7P3iBCEXuE/lfIyDCRBJKzK6B7vNEoEgGxq6gGR46doDuFSJTtYPGWqeH?=
 =?us-ascii?Q?76IzI0NklpzFuJXhP0Rh0tM+5yaR5SZ+8ECuxfrqSAHvG/YyGLho4fQYVsnf?=
 =?us-ascii?Q?3yNq5fwBPMxsd8BeN4Xj0CY6fDDJ28RZTK4luJkybK/g3EIcqAI/HC9kS1L8?=
 =?us-ascii?Q?lHglCvNKMSvmzXNUQ21PIV23epE9+ViLFywqpsYNEW2mJbweEof7l9nMWI1B?=
 =?us-ascii?Q?aZgxlAQ+vgng+U26FWfq33HvVPMvTbvuznjIyARYwALfE+gKRQHZWGHiT9Q2?=
 =?us-ascii?Q?EAY25d5luhVP9HShaiO7QGl9+zHVEpIMrcbXmTtlCrn5DCYuVp0szEzzW03x?=
 =?us-ascii?Q?60umpkhU2IqhEOwExt2qpuBMr+BUxh1rsFoAptY5nykgP0c3UW3HFHnAW+lM?=
 =?us-ascii?Q?WKw/HHIIqzSKyur8Vz1VWg5izhZCcwWUYurOIzRq8lVePekZSTCx18u4t+L2?=
 =?us-ascii?Q?KiW8wMaqyCbLfrWC/6P6G9Z7gsuIEaiDeXCP6SqVFD4k7ZSrRnbl9wPnmMdJ?=
 =?us-ascii?Q?qn6IKEJu8OAFOhvf8vCFgDIJdOBngAbkQVxkWG9VVrv2bhbhXQKxDTvpz34M?=
 =?us-ascii?Q?gjZWmKsGJ1irKpT2cAHx7C5w9Pv8EEehaRPeG+wXqpGZWZ0SP68wlCvvmDkA?=
 =?us-ascii?Q?FDHvp+cJ+vam4wWEVP8nT0bfxLz0j3MYuU7r8IeWGZYb/OCSDz8w3Nj6h7iK?=
 =?us-ascii?Q?9i2EqG4uVieyhElF8kD6EZBqMS3k1vgj5ImRgKS3lnL1G3PK1Mszo6DrwFVN?=
 =?us-ascii?Q?wyoKY6Rwbl3K5qlDq6/R2guNmH+BzsS533IJ6YuDGSG6/Ynck4FhSJwtLr6T?=
 =?us-ascii?Q?CRGqL5waJbj50tWtvUcitvf8PcyzVJ+uh2EAMqEre/7he5Cuba15X9I8hbwA?=
 =?us-ascii?Q?U/ZpTSwlm70pEolF7A7zwqfa/kEV8gMoRYU2EIJuqEkpeaMlH4qbkdBUG8ZW?=
 =?us-ascii?Q?QFoPhLOdjKuCRbqwWPN0d5AJvA5NOOyALB4UDgVjkCxwbyJR33MS64yB9xvL?=
 =?us-ascii?Q?a9JzwJLhBDybJtD2KEA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:07:52.6775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8a701a-782c-45f1-df7b-08de28d511f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6645

Make the definitions explicit. Add some more new codes.

The following patches will be using SPDM_REQUEST and
EXPAND_BUFFER_LENGTH_REQUEST, others are useful for the PSP FW
diagnostics.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
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

