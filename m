Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4087947FAE3;
	Fri, 16 Oct 2026 11:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151370; cv=fail; b=thODUG68/zYS071qv5D+oyLZ6ir9kudeHdUECmzZPleMauEGOxmSwtgRsCmSgPCbNP4l610i7U1fIbG5PoCvb+FJBZ5ZUkBvrvjmDNKTezjcLqO7i23iJk8FRSAIMYnEftagG32RJbvpofznVgUaIEhDqU0IyIk6HNmj13ySDUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151370; c=relaxed/simple;
	bh=lCNQzFK9UJ37Sea3gL7rPWFDv6GNWE/ObV3aC8JhLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iy5WJuqcy1tCDovuT9TKGpOT/Iy/97Ms6gA/jOycH318SyIp0aVaTpY0rOhLE4pU9jgaDLhTB2cb9md62z8ybdt1SOKO4jKhR9ixMPTE9w2BiiYulWwEJtja6DYJf1HBzlFwk0+ceDpO/ynbLnGykDyn5cMt521Br1FMpdruJgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=eL1C9O/K; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=a9MDdt5r; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="eL1C9O/K";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="a9MDdt5r"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACtPU559831;
	Fri, 16 Oct 2026 06:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=eL1C9O/Kwpo8ZEIxTwmmIznx5S8e7sINuMz6/FmDrwhwg8XqX0rqbp2Rf
	oVGUzUcvggumPJA/3iVz/tRGb56eUwGxWQdPEw9Gd/iYrkbxJ+ICv23Ngps9Vexc
	Vg/5G1ZfYy/U3YrEkwQt9RNAP+uoO1FEPvEXvY3QhKQbk0kO0zvYdDGlV8IX0qo7
	KhwgM3QlF1hNGmfgS7pKuLEglGmHSQYJt9xMymoV7N8ttO+b8foxlz+Re7I6stz3
	FuDNYGoOJZINfrWaroEjARwSmeJvlWSmV1j+mKUpzN/g5OKkwR8D4WvIgmR2jhdA
	q/GSZUmz+AeGGnbBExL/6pJ6Pe46A==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010033.outbound.protection.outlook.com [52.101.201.33])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8gw5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:25 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNHFvUtqVEchamfgqUFY9tIYHKYF5itMTAPBJHGAwxyu8ULZPs3GFLwYUaNPv0ySugjB5+EbsNoKUFJZomdMoydy+POi40SfjpewMHg+bjuv4/d6fNwwIRwtn7iwH5Z1KLWseDMxNhSz3qNT+g7bTs7tribOUQnBZFd6C9toIf12V3lE58dKlrWqc+cxkLKTrj/xoXZFEU9DzJn19dV6Ai8+o0MybbV1aZaYmF3e5zrMxLN91no+hOuKcCQGqK8+C6Ka3UUTlkBIcdRdfgodWI7lRCTEhW6U184neTsg80WFHSSEMXfQsVms6p7HJmcFk2EWiKOV5iuu/a8cABPsbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=PudioTZtDtLV6n7CZMBYujpMT9Zjz8J07eL3WokRRoDJvqmkfzNiqPEvvXiPUHFXpxKUlgLyiSFfkn/iN8A4EZdt1fB+jV5sQlNrZwC3iJXbAPaOVT1GM2hhppvHzUJeaBYG0wnuoO3bZSxvdX9hvf5uUPdal1sY4JtdLTOMx/38sLxnr/II7OJ+mBABqihrxPBI8O/YV5IUzVeM57KWKvvESXa5MEoilviGMuiBQSBL8D56bqHuxSUUkG5inRKWOHlpMf7LZz5/8+no7qbAjzJbawXz3NJ7CEhDSaak6O0XqJ+EtIIT3vcg+ClZBd1dPEfIq+ayfIJLW2v39YvBLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=a9MDdt5rocgv/xiRz5bPQ1pxsDEd8gDCl+eXeKs8C+lCXDHNSeFN5CZz3O6iXjbO9wuIYbykzKSOyMjc0ogQSQsKOA6hchYMGPKxbYO+QUxhSiLSw+jmEw60giZ+Mf6RTX45zUCWI2mMcSlq2r7YEXzG8z1Of1Bd0sI0qIPhaSQ=
Received: from BL1P221CA0034.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::18)
 by DM3PPFFE6A35993.namprd10.prod.outlook.com (2603:10b6:f:fc00::c5b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 11:49:20 +0000
Received: from IA0PEPF00000045.namprd04.prod.outlook.com
 (2603:10b6:208:5b5:cafe::5) by BL1P221CA0034.outlook.office365.com
 (2603:10b6:208:5b5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:49:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 IA0PEPF00000045.mail.protection.outlook.com (10.167.249.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:18 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:53 -0500
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:53 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:53 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmqvv2451748;
	Fri, 16 Oct 2026 06:48:53 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Fri, 16 Oct 2026 17:18:03 +0530
Message-ID: <20261016114806.1749515-13-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF00000045:EE_|DM3PPFFE6A35993:EE_
X-MS-Office365-Filtering-Correlation-Id: bb60d6a1-cf3b-4205-da6b-08df2b7b8311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|10067099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1Ns8KglEqT457wslfBkVWcxVBL97VuaYnRxVxHfcNWDFC/F6ssYfGwADcx0eZ/dcojCQPVId/Bdxk142haxquDY9SrRRX/315rn73u4sxEkluGS8O8JcU4iPFPBQynMW3bGuUTZkphwYc7XAtH2+WsW35STJiZ82yhoEBD48xrS/hCnV97wuhh3WeVCekaHerQlq6HYH1duxtLNPzFmOO1Yo2sMLSbG5SojNKErKQ+qdLgQKL8uH1BN3n3a34TQub5woO06IZ8xtHv+q/n0p5a4YR4yCK/o1DtBvH1hOdHdSAyq2JzpO/C8ZSDvO1JutOYeuYl1OWyH49fs9IlSFhCnzAUWCwutCpmK1mOkPOJmdpTQrhoPeGuMsRXIlUvkJkYDza6GZ30wBIeY8/4uK7k+p3NsU2HtknFG2qXO7J7CczOpDEe6MSclqQuiQWIVn3f5eoOjwXvAHX6HHUilYJisPYNMIoLSrCCJUTe/3bnOpOs2WsXNzxu4oIpCwAMbt9GDEOEFyhp75Jx/fhwmcW/hqPTqz38sfoCHD9aiP1+bjo8nafcvNh8M4RW/dPb5J4/Yq0IQ0h97GZE21O9p2kZD3InBUIebL6mOG5WSSZqk9p+Id3C9ujUgxQxAqamO2EQiEVrGh+OgsjRUwaXYizCrnSJRNVtWNHTc1pyVk4VOyrjnllJ83MYRtGwEOxNdeEx7TB9AAqQQTRAMEViUHZQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(10067099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fylzsMnWcSNXlcAfad5JgCT+FOcvP5UXGP6MIkA+iPBm2M2OaN7Q7UYSQZPQnSTE+L0QA+4nBuBukXlGS33Lzy66/nyMh5Vj11Pf85qE1YL82lw6hz30q0zzJ/Dv7iwu9h7SYMjE4oZGXaaqRRfJIBWwcUYkoqRN9+o3hHaX0sGe6XJk5upyGWnC3Oye5N5xQANnFa00XMS0+rV/K5dxbFel7R5Tsm2XCIewFsyXzSQCPYuEKbA5cFX4xV7KglYRI0b9RhTOooX22qgycWv6ZHIV86shN0G+bXy/ZKYGcGHgd1JuJJVF4AKtTWW8FXZM4fVII3lVdewrrBLaT8UywbUsBmTqhZnZuXBle8HEM9PEcNwGa3QCxjasBbsiazUi9EgNYgUruz/KW+z0C+v9wWpu9mfS2K+zV+yY9Eq3P1qif4KdHQ4/LjAnaP36D1x3
X-Exchange-RoutingPolicyChecked:
	oczpqpCzMWCYuy6BB7C2oepq0ZyiPjahqGa8nz3Ao9fBfjOJBtoqC/SiwRoicuW/sNkq35EckNW4SCxff/jHpGSfe9SrAutWCQRtYs4dvhpKJCeIKpQ14pi2Rg7j4Sa/cW86aDPDbgQXKcjtiPtmkGeRdZ2hFuzwWtjaCW4Ic2l3c4c6BNLtfUYlvUeDkwR70atKucek7Z+FkwiO2aiU7jvApmtcyxaW4DhNai+CCypTIpzvve4z+mcG9q5C0oz0rKb/Svz3eM8ZKWY+GDgDcQJUrCzQyZQsyTQku5GHDBjNkdXtFFQxZn/KAo37xccSnuySkW/n+C7vw+KOvn07EQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:18.8636
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb60d6a1-cf3b-4205-da6b-08df2b7b8311
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000045.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFFE6A35993
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX4zkYtYaeW7KG
 nK5+uWg7SCqL1AwOvWXStCt7KRBEM9rqxTlCTa+KQypQvxnpAs9Vxe1pmCACkAE0jvRXbwHIgTc
 axLWFpoYj6QJuEAN310z/ImKz6GK34k=
X-Proofpoint-ORIG-GUID: 6kRoEgg0xk3Fs-USvGNKKdTrtq4_He_e
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad20f45 cx=c_pps
 a=EZwmcie8zcfNvCQIxZ7BwQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX0P101ylXf0as
 52m8tX+pSlrJCOItC/9IIQgxyRguHvT0XuGB/TNEib61aBV9aNaHTCtyNZ3bDj4CzqQFZvjQB3u
 jyIpyGkFQ4kI8xR4q+cN69NtvucpNWvsOQewW+e+jb3uukKS2D7l+4SK0/f7Lyle70IfJk0PewR
 K14uXSrH6rjszr7yifCJYOi01OeBKyrV6Kkg3Zq0PEQ+6ZJEzkVAY/zQBAQttUhUWAJEaWzW5hT
 zZl0i4swVcJ86Z2jAst62SgAKLhPf7wbnBOB7UCvnnF+MbNTjCFRMq6Uw8q51CtCgjOIOoGee4n
 UZ2rwKHUsQnRln4K0krCXUjh2aik2THcAE9r7c6FcC8EAPPY3R100UR0o+Qe0cHfWiTNPTdhEgo
 mZP2MIjbxWYt+8sDDLfrzKA101I0VVaaylme7ach1CGycaESkrUwJWWSCOsQ6Un1gmyfoqXq/Bu
 xJ3T52f6Rl6khDRdhIg==
X-Proofpoint-GUID: 6kRoEgg0xk3Fs-USvGNKKdTrtq4_He_e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ea6e3b246ed1b..bd26c3f438e34 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

