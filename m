Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BE3448BB5;
	Fri, 18 Sep 2026 10:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727041; cv=fail; b=K9kykPWKuc3/Pi7p3HOs1u6DoeG5WCpTAThP4bIQp9yKxlKVlegwBjvAr5w8eLiVh83jHMylsebT08qYJQ+UOS/fNTg59a54eLbSfqI+yAx3adwEukg4DZGm6YcK6ujHS/11XdZanM99Gj7azyCgwSGBafHKLfMdqLQpf5PypEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727041; c=relaxed/simple;
	bh=S2P9kJ+e8z+mwpn+sIDz8GJO5D3GScPLrFqSFokuaSE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lb6q7MvjGYGwQCLsVc65/xw38Mgp7sfyi0jt5OGopCRgsg0BCRXLktbWCNih/Qvpz+oZ/xS7yCM3KdLfVfzIDp9gD14Dz2nwJUz3IAXu4szYRD6at6GIblGPo0RYnXFNMInO7fpWwT5BqlbzhRpRQp0DHuZ1SCmYoFVJ2PMMMMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=PERkrlLe; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=SWcce8CG; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="PERkrlLe";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="SWcce8CG"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9dBpu1233793;
	Fri, 18 Sep 2026 05:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=SA3piW2BGL/3tUuLE/A1ctAfNK9HBAJ88/AUdiIWB
	ic=; b=PERkrlLedBC7ZWc+lHLIHHJGa/XjdwOlyec874VoyKn3WGGa1RYRG+/Yw
	VTONPLVM8RrhDm/2Y82mcAMz8zU/Ww2iKqispKQBo3tVlfpfpUgfac9033BvkvkE
	kETgpUNykDLrb71Kc4FERvnOLPJ/7EOfM4uObFs6mzhWhktQ0KZal/IV64/yHs20
	vDOF7kICiphqenb7oeHsoBrBH/Up0acxraEHBLOWGN0PtE28XmzsYWTPLV6VCo4K
	nZlMxPZ5dZiZNO9hPH6s5i8XUM86DNAIB36sc2va01JzgVUHxHHyVUwxawnFiqr9
	Y++uXzWMfCEND9yjayKigOrcNraJA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07d6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:56 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XL1wzgfVTB7QA5Zwt7F7OPZ0I7SHKZaqkiWrC6N5lzzBm7KV9T0YeaU2upEoDMaYBgsFL2qYGV5LM7Ct8/PF89wHYpD1qX5SKdHRCLTj868e+3i0K39eF3sCdXY/f219X0M/ZucTm1ZS0wJFVI71/Y7higit+guXTZNPrbwJHnTrYUYajpN+9Kq/OYUYbWANe0w75pIftzhBXPmYUYwIGaOfQz5t3NH98DuBJVUBoP1VYhAoGMMSjBFfkRcTho+ZBOt+r7FqIUnXx3k03Yx8Rf8gN9YL1JURcj+DvhJ4IXNxRYhdE7oB6lYUct8MgwepusE4/8FjAjhqsfH9x75J6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SA3piW2BGL/3tUuLE/A1ctAfNK9HBAJ88/AUdiIWBic=;
 b=PdR4ONTwsG0ijkPiT+0ESs11JfGOXggG7Lf2W+NEWm9NhV4miAm+uHiPQjZnlJN4v9a2yWTdqnU6HquCiyUSHLZc+sFF4iRJsnCskBuriXApsvT1TvJFmUhMNJFcPMeMnfrMVbKTjEwsx7I4zha3QMcrVd5VNLh4RLJWeO1Yx5g/etSzBOywF98SUyYVoeUiPe8BskyNFtwaYRkqdghJpsRgU36sAsuKxwAyvzWM6Ba33q6g5GxmYCWVpYWVj81LxEjtkxpYK0jb7sQPMVsaDJBBHaByrM04WRjkmWYPP+6e8nfwUpputhSXbhIC0bhvnikPJs+xbGLU9OsDgeD0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA3piW2BGL/3tUuLE/A1ctAfNK9HBAJ88/AUdiIWBic=;
 b=SWcce8CGzxxgJcey5QK8elHoN8YHAilU8YcrYeHt8m0N7pP6SoEBq5UlnNE1b8lo9xcR2L/fCjLU9jmozOcI6xO7TeY+9PpWGXDaC3sOPxuGD+2y3Rq9ZI96+Wl8mkLXPAvo7u+obzOSrcnICQdHSB8Nb6B0F1xysJZcbgSE7Xc=
Received: from SA0PR11CA0014.namprd11.prod.outlook.com (2603:10b6:806:d3::19)
 by IA1PR10MB5923.namprd10.prod.outlook.com (2603:10b6:208:3d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Fri, 18 Sep
 2026 10:23:50 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:806:d3:cafe::17) by SA0PR11CA0014.outlook.office365.com
 (2603:10b6:806:d3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:48 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:07 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:06 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:06 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAN55O600253;
	Fri, 18 Sep 2026 05:23:05 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Fri, 18 Sep 2026 15:52:34 +0530
Message-ID: <20260918102245.2784000-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|IA1PR10MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: a9bc46c6-746e-42cb-2589-08df156eed9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RqG1pkn/rjiFFuQBIxqDqTK7uK+cF+VpsL6ctxjshw3jzsubY354lYDQQcN7hEZC0Pfqo+eV67hSdq3bvxFdhjWY25aDKoeztdz0NkXTDokm2rhA635BKI2A0u1T7IGfMTzIa+HUWrdao3aYQvvyswR6M4ZlRB0AHT71HLvYgBt2/gy4iplc2UGEPYUY9XbIBr/XfIWFFHCw1V2n3tuP9WJEkk2wbRpRehGPZosvlXY2FYGAiWEl65VjWS3UZoajhdwGUvWiueQUdIf1A2v+lk9t1YM0o3rNue4Ce4msVix/HsxtHi6gU36/Hw1LIUtomseuomwVJVKx+OtVZhVNex6n7/FFEtCadkDnfirdVx1zYjaXR1sGsMLe6/DygmayCQKHSGCO7pI29ObDoA8ftmvk1gSGz1NW33FPvgk9sjB9EhjX644t1dVbBCJ/2moyDAJenBPWU5R6KS/Abglk0jnynbQi+wxGvBxhjPE9d8a7vMOlrbIRoZgyi3yCZm7CZhjDX/2OQQvJTsvmdhjkVI3wUD9gcbjEk5MUPsAho2Rz6h+7MEqy52LWQDhG1ComPcD0r5o5kq3knlmec7zc+fwt91rsIPLusk7F8JHxWRH6ebzhj6hS8by9PlELbLuvaqiBhBDTR6m3qpsGwqW7jVaOI/s6tuQW3klOmpZ+hr4HDUhoMdirDm3TusWWRHIa0Lb2j9ur7t7JzXUxSxcXkQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cQlKbyxdJTXAHlNXT1hH+KL+mVwQNvUZKQEyNjf+6V6PiCaCEakmnLpfYMh2g2+BIsZccZF/Zi3F1qBwfy28b9DxMmRX7QiKxD4UCdF5NeaBsHbkC/VV/dYEQ1UC/R9c1YOu5vv6+cbDoOw6e4eyoudAgYvSxe38Wd6Htk9ZEqEEO65/8iy/LsMkv3WfKYZvOiy9lkh0zn5xd/0UBn3+ZDsWHKwAgMmrXlzWpPxX/mMxgM9GCVDSfGCwZ++tQvDRoY1JsCy/JYBZ+m5j8nJf6iNfxGnVL5MUyWP/THNaEaW9QDgxhSjNpJmq4sYYiPMR2OE4xSiPXhMa2CDNeOMdC6IGjrLgwoCO8IUHxRd8cE7A9mmEjTuLw3usI6Dn1E6cUiLdMXhzF7MfAZILHiDzifnuqZGNbNhdKAY/sf94MfFNpl6T2F1h6D8VHz+t9IME
X-Exchange-RoutingPolicyChecked:
	M3uCIdI7Nu5A3dm7+8qOT0sx10HkdZ+GCVMBW7ZNKy3XeIVKRCyQ1OLaSuQZrIdO5trxvu9vPuuCRnbOpbiNJFGR0ouTdhzqW4EpVNUB0WjbGQk7zwYcJ+esNvi4ZgQAGF79+rKpysjK5fmRqEf6QmW/jYGcIEInnXDrqukIgn0ZQGLeO+WuRcoeGesuPQYy6bFA31P0ET9fjlcGxGExlq4PXTykcDonA7OJDZewbWvuyflHiT+snqKB3xB/HriAs2m3U1X9/W1cVz1bzy2Y7OBPDHHAt7D362uyfKWRD71+rC/pnwOJOhTOeB7dhDzlvsU2yV1f/p/Pcu8pvnw4PQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:48.6380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9bc46c6-746e-42cb-2589-08df156eed9e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5923
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX9JFUyBMTELaf
 o+7hIPZ0laZ2s2JwSmwc9S9UPPjjh7p2uFm+EjvatPzv/M4N3xAnlvjYsy1lR6ZQ2Ze3qHWWVGo
 Q8IpmL6Ki3tDDmMa2xBvuITJqFduaI/xpOUEsSXvOGyGXSQVL2HD41A0WsXwn+2FsZmnEt/NvQt
 Iz2rJj7oecolUKC/jHrHkyManDiHZdrRg6wXhM5TuXI0ZwWrIAI01ILBTOnr0+94fEvBLxs2dLU
 FNRL5CiEbV88dAySs0rewOE2ul3WbxcwU6U16oKAwVw2txHtXb68A8/Qst/CjuyC85pc0/p8sGa
 j1yXBoRjkgYc63afovz8NCn6Zs9Yg4/dlulSWxprBbj5CPX1Gtygy6AUHLDnckA0QAmDIGJY184
 5mi+6k7Q8S1s6NRAGhhfBtUYjcXK2FNw6Zl4g0XAwrVF/s/u7xUn/bE4jQe2Y8xRBHmp4e8Yu4K
 UYEIbkFjem2XLTUdiXg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX2iD3w2sVXXUM
 35dYVfIdpjJFgvJFomSbrXOXqQ8J+AmwjesmCPstwdbFyBEzpPuoiiRTgjnyAKbDj8vp07Uv7cu
 qJAEUbKyovPIu3g1p41DNb9jnJXR++o=
X-Proofpoint-ORIG-GUID: 5t9TaTAE6JInnIy-IaiVLThjsGTlKFul
X-Proofpoint-GUID: 5t9TaTAE6JInnIy-IaiVLThjsGTlKFul
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad113c cx=c_pps
 a=cGIxddJ9FFYnYBVvYRB3uQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=i7zdQjoT4sji5VLZqVYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a refcnt to struct dthe_data, which atomically
counts the number of requests enqueued in the crypto engine queue which
reference the dthe_data object.

A waitqueue waits on this atomic counter to get back to zero in
dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 40 ++++++++++++++---
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++++--
 3 files changed, 134 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 4fdd24ee91637..6a8fbe67ef6cd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,12 +110,11 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
 	return 0;
@@ -124,20 +123,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -149,6 +147,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +224,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +336,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +519,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +555,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +588,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +611,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +723,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +746,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +766,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +873,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1144,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1152,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1207,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 2a3f5880cebd3..86aa99c28f1cd 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -32,22 +32,46 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		atomic_inc(&dev_data->req_refcnt);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	if (atomic_dec_and_test(&dev_data->req_refcnt))
+		wake_up(&dev_data->drain_wq);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -153,6 +177,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
+	atomic_set(&dev_data->req_refcnt, 0);
+	init_waitqueue_head(&dev_data->drain_wq);
+
 	platform_set_drvdata(pdev, dev_data);
 
 	spin_lock_bh(&dthe_dev_list.lock);
@@ -203,10 +230,13 @@ static void dthe_remove(struct platform_device *pdev)
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
+	wait_event(dev_data->drain_wq, !atomic_read(&dev_data->req_refcnt));
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..a827817e8119a 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,12 +18,14 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/scatterlist.h>
+#include <linux/wait.h>
 
 #define DTHE_REG_SIZE		4
 #define DTHE_DMA_TIMEOUT_MS	2000
@@ -53,6 +55,8 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @req_refcnt: Count of requests currently using this instance.
+ * @drain_wq: Waited on by dthe_remove() until @req_refcnt reaches zero.
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +68,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	atomic_t req_refcnt;
+	wait_queue_head_t drain_wq;
 };
 
 /**
@@ -78,7 +85,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +94,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +110,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

