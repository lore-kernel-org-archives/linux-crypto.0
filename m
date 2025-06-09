Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B513A27F166;
	Mon,  9 Jun 2025 04:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444710; cv=fail; b=bGYOySbNvOWlnEfIM0h683N5H2b9ekiT9Buzoz405o61o+bHUWu08LCYxvPxCvNKvEMCR761SmaS2ippL3jtLFXxOSKI0bi/Y1UMDvu83N9hKw9vhmEgSCQTec8ZmXhwNPeeMgFRirQRLDrOSlAwYNwpOLlLgmN84hNOYSUuafw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444710; c=relaxed/simple;
	bh=CF7fhwE5HjwVMZ7sdD4qmwvuIiCG8Aogj94nQ7IzrGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s6BIY6S0BEErYm7Sd/r4FXbUUB2AZmrnIK1kh2vjQbUu0ZarTB3XGW4vt2BzVqjNhjgU0j1rkgeozHejeifQ1N/AnT7Dn/M38cf3tKSxtW0OtWzt6fsNxiUu4hT5aIWP5nxsHbe4TspjLz0DJbdjSOUVnbyFu8+Outs5ip3iaJk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=093Lv2NS; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="093Lv2NS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RkL34o5X7RXCGCAEAIsvd6c4MMuBQoM7g+fLnnoG4QFtAX2Oajml/c0LGUPbv+FtsGu1UTUqAiQZ4cJ9wVGBcpfajAdo161NxX0yOZgAeoKSq6Uy/Aq+wrBxn48vOQns4GlRtij6UyQ/KERMB7nnhH0N2wb8kc7BQyHnCuiTGPL+nqU7V9MGKhkQi8R6cHkmAvP8SZeMfgP4LHgMheerLLa6002HGwUxhYJ0C6L8rjdw6mVGrIYvSv8pvBbhg0CRgKgoIMOum0OItw3yApzJkK290EDY8+3k3gBYqD6AC+tCo3jFKXZShxz5SN6nWURL/YnREVKeqmwYrjVtnC5HeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6DFzQU6Fzm83VtVBnD1KMNhwIcXZ32Qbj1a+LA5OiZQ=;
 b=bVlMrIdkN9viYEShv6xrz+SRi99NrPfV2xQug3Eoncgl80tchKlnzUxKMq72r8jn7mpgFN/El9XAD3iEl+5oeb8/TbIk/rga1yxUjrOjnQTiUKj8Krh8XGdWSwhbpsFDXBkJUVRUHw3DdoBXY4jUCfB1ct7NAs7Oh/Z7fLMnAUpM6lkWOV6yIsRxUWQsDMhQoh7h1WuuzNA65IdU97F3/dAk3JYfpbJ68wQrQnq0xHbCgJ4XHryZjVmFm+j4TvOzTTlTc0Q5bCVfQx5oWP6NKCiasOwe9GRkhPtr6yQB9IZlIyBf4okmp7h1eU2D9LPxhHlLZ6O0jPafIm0Mk3TiWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DFzQU6Fzm83VtVBnD1KMNhwIcXZ32Qbj1a+LA5OiZQ=;
 b=093Lv2NSvTIwBaWvCOtSWTjN1/DOIMxPXxNkoCT+Y3VmyouXV6ho2J0y3lEaV5NmJdn6ywWPpqk8rBsH+nn52DdowqEurDYgNhBtpw+Uq0OtIpqoTVGnPF6ejI8hUyNs3bS/Maa3XreWgjYovAD5ixP+C6ZgRr4LoLMwAXFD7gs=
Received: from CY5PR19CA0065.namprd19.prod.outlook.com (2603:10b6:930:69::13)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Mon, 9 Jun
 2025 04:51:43 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:930:69:cafe::77) by CY5PR19CA0065.outlook.office365.com
 (2603:10b6:930:69::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 04:51:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:42 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:41 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:41 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:38 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 6/6] crypto: xilinx: Use min_t macro to compare value
Date: Mon, 9 Jun 2025 10:21:10 +0530
Message-ID: <20250609045110.1786634-7-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609045110.1786634-1-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b7078c8-7b5b-43b6-170c-08dda7115402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ufZIYwOhyXLeTyzvFg1KKLE0DQw0+r2wFRh9oDw96LCEB/JNoAFoJnzGvVWM?=
 =?us-ascii?Q?ClEHJ0+cmSQiD1vR/eli56DONYde4C7SihKFfN3upJgxx1uDq1ANGD1WTm1X?=
 =?us-ascii?Q?PoemfmTNHSQXKQT4++WpwMuon0OnNZm3jQ6qJUlMHssYSqgH+EnRaoLDdq4M?=
 =?us-ascii?Q?6MrkR4MOQNA7jv5y0fSEfVmmxhh4A+I+KxliMIzn2ZFFqSspGcn3+U9s9tiQ?=
 =?us-ascii?Q?qYQc3kpmPVE1i50EEoHLDOacmldLSbDuXXM6gLMzzh5tBCFBr3FeHZlL33r2?=
 =?us-ascii?Q?kfWR2lEzPtk8UNU7+cIDRfa7d5iH8W0alujS0UO1nRnSEh1NEKRHln7e5Xxr?=
 =?us-ascii?Q?exZ18zvmjaptTbopYVOAR+KluQo4rqAK25Muvq0lvypg2so9SxkIjtoMmCM8?=
 =?us-ascii?Q?H4RgiZ64giNACLvJVrsx6tQgP7a2usvIz7P6XcfTgU++q7AXt98Gw7r8jo0U?=
 =?us-ascii?Q?7SAYY5HCybjzynH/JhMX4f1a7NkMXE86YGoO82lDzUxl64xLrwUEuwYpbhiI?=
 =?us-ascii?Q?5+6tiCM2HY1723m5Nj6SbyCQEgmkGxIztokSTLP6fsm6Rv37uJUk7SHosfO4?=
 =?us-ascii?Q?7u4Dv8CgRj+DaGqZ2PFYiKDU5xsWDlV3W+UOpNp3Uv+VOBLKkmwwxuJFUKta?=
 =?us-ascii?Q?euJj7LSED/eUn8m+V+YmyeTrEZ3FYmga/hnzKkjVCdMvLaXRVdrY62/k4pyo?=
 =?us-ascii?Q?zg4+eovBbXQ1w/22xfUn2NLaX0DPJeheFGovBcXb1ubyvqdAFkuFBU/olkF9?=
 =?us-ascii?Q?KAUwTYaj9tU9yTZngalVw3iaZGSiCU5i0fuYtz5rxi/IkjwxZs1ZNVTVUQRf?=
 =?us-ascii?Q?2HbDrPKVB6I6y7D5jls6ws5OeUtSdOflLM6u/zeB6l5n861h1RJjsFGcpr7K?=
 =?us-ascii?Q?QTU6f9dSW75PpIeWPpjg3uZmhefczGAzRfqHwproB32uOq1g4CTDmoGO1qsd?=
 =?us-ascii?Q?pkP8Q4NoWC0ah0/c9gI0xr+cGE9rCZV3XB3YN2Usn4K1iDTZ+jLuZvn8ccqa?=
 =?us-ascii?Q?L6wHNp3+UOrrTPSD24CVkNb5c76A8UKxOVACA2odIvSunAgdjrDHcw//i4JP?=
 =?us-ascii?Q?hMplN/EYo4buNqdyigtwhQqSUOPQzU4qTECB0j87YK/SLJPZLImzQ1IDqHk6?=
 =?us-ascii?Q?GYc0UQoettJ4vVCa3jgJ6TvkDXJC9ljS08rmo0EVl4COaUuMQ/8XMNEhiN9E?=
 =?us-ascii?Q?nTZhemxnL9wQ06p4bAKoTY7MNRosTmK79+ENpxTx5mQ22lq2WoUH+VnfFXAl?=
 =?us-ascii?Q?fRXNyA8T6VmAjlT6knn7A7aj+G6SzknuuNGoxbxma4ISx09PvrXLjvNOle59?=
 =?us-ascii?Q?HvXdq2CN0JW2BbGYc+7QntaNNQ7sIxV8/YNZ4RpmFMU6h/Cu2A+46KR+Ue0l?=
 =?us-ascii?Q?+T0M2wXklQf1+c08xyGqUP618HrMECgUmVYslIKOQxrEdLqopSvtIZcNv0Ng?=
 =?us-ascii?Q?5/TJj5xYWX0Ju/1QSocGSWBdH3nrtmzD7k+hREGnXmsWn/Gdnt7+EI+v7fuF?=
 =?us-ascii?Q?bBi3AWTbHWf9L+lGaOz2Bp78DhzQ0nhI4dNVARO6EoODcomD1t56nmXD8Q?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:42.1143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b7078c8-7b5b-43b6-170c-08dda7115402
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493

Fix signedness error reported by kernel test robot.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505310740.bRheYmxs-lkp@intel.com/
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/xilinx-trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index 8ec0f83b53f1..4edcaf911475 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -304,8 +304,8 @@ static int xtrng_hwrng_trng_read(struct hwrng *hwrng, void *data, size_t max, bo
 		if (ret < 0)
 			break;
 
-		memcpy(data + i, buf, min(ret, (max - i)));
-		i += min(ret, (max - i));
+		memcpy(data + i, buf, min_t(int, ret, (max - i)));
+		i += min_t(int, ret, (max - i));
 	}
 	mutex_unlock(&rng->lock);
 
-- 
2.34.1

