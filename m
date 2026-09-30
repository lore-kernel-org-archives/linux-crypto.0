Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E48A4CDDC1;
	Wed, 30 Sep 2026 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767615; cv=fail; b=FEivQQp4aDSq0sKCoVgXpMfnBsDfvUzBERB/Y9j2pBfn+HSt8ADfWf6o8cWiOUQkxJkMFkcSdRgS2SlZ6feWsYrqM994Hn4R/Aw7XoI/dOX//EKZfc2syieWkOS1oyEKUnnwEfpkcKmaHLnSKQAwppQ4uDiau/ts6qZEplxxqLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767615; c=relaxed/simple;
	bh=xVSQS6p4jUtic3JSFUxPRRv00zrfweSXDgPsiIvTgNc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTsP/Sm96RNMdh2cMtyS0SD13g6IrsfgVBNGYM8Re+8+7ZXBEcDgFWybAMbdZPudXMIdLIfb6lxVKetuoy2VyCeDcNmhbDvnCQnHwiI2F0XDmhzaJ/QM6HEmBCEDsxsfy9d5CNW60nDG1f3DIPVsV0XnNGXg1oLRXm4+ost5lLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QaeQIyQP; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=QmBq1uR5; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QaeQIyQP";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="QmBq1uR5"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB68VF3214248;
	Wed, 30 Sep 2026 06:26:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuP
	SE=; b=QaeQIyQPQAU6VYkfgVN0nLm4jee8yq9/Rj6aORCrNHwEGF22D4EBW973N
	yv+gRn/izmBQiidN/1YgJY7UvgnOKdvGGPIwS/6c1Po37d2JIJnuEGBKWaqO2RNv
	vRsmid4fwGsWWDLRhRytoe6Ex2w97N/zl4toGOz1kxM8YPNYqyFRpEvP572xhrYo
	JuspZURWjZl0zxj+3jQol0TIAZ0wJ+UipKXCSibfENZF7P9HXgOGAQ4sRFyRbPNf
	AG96vAvZwPIyB0QSEL4k8Neao1fWww2Jb9X3gYhgWTMjePp0ag9sndir68eVA8yj
	LwMrgGpeC9t/+BTws7Em//vp6R1+A==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010041.outbound.protection.outlook.com [40.93.198.41])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv8q51-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:41 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5EPWGGhQdGBg1gTVN7ij0MVUs/iPYU56G+glV066gcOA6u+2bhI3nFRaOAXU6OjH2/Ns2g2L8Qyz2lnNBNleWCx8Z8CvlToHqhdq5L3BphRSd2ujPOyH3VgMZJ4fRrN/v3WS/ukvd4j3VaDeXpTcc3/cF+kLNwicIQhAo4COq5j1q0aPkuurH/O3zjxXXvJSjyvBTK04Y7HuyoEKcRh058fGp1a8zmNAbD4pr2m+x3b6nFIldWkqCKM3m/MCqIkc3qIJY2LgxaXhnzcOKFyTgHlmsMgM3n/XZXF6WmiO1Ag6c8rhebEsO4lDeQFM6js8YnqzbybSTGGTp9zZwfELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=g9exfEYyGjkYwN+Mo2xay4kTEiosomNa+n5y9olApKAu1yepSkQSyEOZY26THHKAEVRw/scjYdcH+Nh98PEmk6YQIXtaR7wqhTjPyR6fYwalEmlsyYpe+SfyhJ0QcYOdv1eo+6WNejWFXURtRwyBeSy0W7p3a+UqQnKJf7z5m8ScrBbKHcQIZGwYm5mEX1aPUQdPzhX5oy3r2UjBFKiRObxT2i4m7Mtpo7q+ff0Es1FY1HJoq9Nvy2Reqo5x1OiokqT0QCVHB+Nj9KJSlhpvjnLCCvo4GmpES0b4FP03OVRfikO/o2ayhvSL1B+jCq93bPTm3bUb9hlIG5yHPYZoYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=QmBq1uR5AU0Ty+F7dwhY6xm8PXBAul67AxG2SSUZCBwUktdcgNav1C+zIJFZd7jS8HVKi2U4dHyWnl6WoRpWhtdhA/EvjIFFhSe5erAFJLbTdxUTQsKGbtU6EPjxsmT/lCt79PPMaNDQfpLKhHPahcPepSSwbuAdoTvESpfp6I4=
Received: from CH0PR13CA0058.namprd13.prod.outlook.com (2603:10b6:610:b2::33)
 by SJ0PR10MB6325.namprd10.prod.outlook.com (2603:10b6:a03:44a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 11:26:38 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::84) by CH0PR13CA0058.outlook.office365.com
 (2603:10b6:610:b2::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:26:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:36 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:02 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:02 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:02 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQ0T23969705;
	Wed, 30 Sep 2026 06:26:01 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Wed, 30 Sep 2026 16:55:25 +0530
Message-ID: <20260930112533.1593952-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|SJ0PR10MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: c2efa01c-78b8-47bc-1745-08df1ee5b095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	56Z3D6XBAep9mxxi5j0RGQIBHwk6pXb6PAwG2DqO3+cP87lPmWGAf5EeNdE3l5conGEdlZx8Gw3Izr4UhUNhxejhPVB00f/QaWJ8gxzl87oJw6aE9nXW9Gu15NGYWmwZpynO1XtaKdvSuXD3JhXO8hDzQf6WYOZ3UA398uKuoKs48yvjcoXIekGSukVaR1OXL6MhubrvDNm4cJwLbwbmFrGQO9Y/aTtN2uMC9Ln6dMs5vuejyx737UfDjcPdh6GgNwcWwsfuwGHE46LTsQ404F1ID/xyAs6V8nUman9OKX06H93+nTxw5NPEqjKzo13CejbGnX5ZglJ5oKp3lL+2YlYPexgJb8pezFTuLBteLuQBqGveWQucvp+UWoAicr/rLUBUco8LS90oDdkhK3tlbggpYQw5spOSoh3nuOLsVHn+XwX2ifrRM4bM0CSKtgCzx9K+eKpsEU3vZVLPb93uB47H5kqumIOjuqx0Y8QK69ZUctcSftE/POT0MdPXqAzXhZTmIqviGhYXzoH8NGn5ccHK/JS0U51Ec9fe3p6onhdF9+c5y5H+yNbj6wpsEYNuD7qBdAOzUSThzhaxNHDpS8qN7sKz1JjUGebwy+k92cgpvTlfde6YAqf0EAjVRM8cUeUN3Hze3TKtWGyPnyKXhA/LXOSuYNCo4pBHYJXtGIPK8YKKdnKP7K25BAowLVa3qEBf+a3+rmK6Yvdq3OZhug==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PWETx2NUohL/6zDNsCNGkHvVYfzY8+1ZauFJBcCnz3lsp3HjcEXd0lgEHr4Lfw/8OeblXgBNW7+42z/3LIvSqiY/SEzlszQB1e5e9Yf+8AZEk1KPJG0zV7psNzEwHzoHAUVMHEm7LECOGEu5ijNPKnuSJm/iJji/w/kiGIHkkMGQM5u+9jTOV2mow6ptgAcX3YgHYt/2zR1DQxcBWyoTPf092aXu74vdu6TD/NVWQuDc3VkLHm+0EQfD+zv1jS6hFSqMmYHv3JUc8XfpZdSR8xGgKlpLlzYr4pNAIK639IEJSUSMk5BEqFE0l0dum2H/BG9eLKsp+Z+dPJ6aLRdgyI6a5C9zjNaUlVq0zCmN1Ip0/WxzoWr+vguwGjIzegclMGPoVR5DnpYysvcD1nfEgGvqEqT795Wu1EDgS+XcxThSDjNI9msqfj8jpBLLVPcb
X-Exchange-RoutingPolicyChecked:
	YlYb8k/CAF4LUt8nakZYtIoCR/a6kphJO9vsPFHN8ZafceXm9n45I6wiuxhiBrbyyVNHna1c5dccySp/h+QDBmtlRrl0U50bQzfnlOkFkGfGh7k9JUnIxGKjz6yd9p85/VEmggzBxEvp8cLxPV/YPNlhRrPHgqk+gAJlNJvVao6zc78u89/75PgSHL3FtiX/86DGMGHaWNV89twPa4Z27M/rXizyjjxkr7b5ZTBHDV6GN+/fbmxwP4iPqCd/dy3oeoO6r7ijbPd3crDmgSbhaEWSzqNT0LOayOngF+VcZ/X4mvf+wnqtPH4Bf9xjpDedDOIguiZRt8f3QMRCHPpERg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:36.7907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2efa01c-78b8-47bc-1745-08df1ee5b095
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6325
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2+EHJoRY4THc
 QFpT95qEoUXagpc1ZWjynnutJIt7g0a2pb0s2YFVHo6Cui81aFgP8iyXnjZijzIPyriwYFkd+Lw
 Je5NWs9eAToXqRNJjZeNeMw/ZCJ3vXA=
X-Proofpoint-GUID: Oop1pB0ZhYnVVPrK7L-5lpt5uMQ7IFhU
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abcf1f1 cx=c_pps
 a=GhmKEtzeB3JP3t09wzqP+g==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-ORIG-GUID: Oop1pB0ZhYnVVPrK7L-5lpt5uMQ7IFhU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX1xzR5Mw4GoNA
 hnjr1+whEULWWi33KiAQfQU1zDj++IYRo6DHCZnSz/i3y7dPWlfz4BCVvEic/jMqV8nfT1V+S1y
 PiQQ2B84p43VPVTXgH6yZRYWLUvxNQaBDGU5nfmxPBIFCcY7DTAX53J/O3Ql6a6Vvu+G32RPK8D
 QKEN7tMRXZAG/ALNzOUGZ/4zPZytcUMQYSvasLrp9cMzIoJE/0nfwKoQtcEMwvZWzwvuCGSj0th
 ASC+YczvH7I76lMAeH3aI3yjq/oAB9xeC5eRjcfSCfh8Th94GAAb4OvPDi9Q3eDMa0KRUUXEiYV
 XpKQfh6E46mbq6SccepvThN/SiUqaPbvhmz+M/OjdN/QL7j0kr7FqFPti/1vebsmLuEsZwS065h
 q/OwWuadHEqMRy1Y/WGiA62UPPY1mau3ubKGgsDrRdon1HbDYuIorkUfrCjb7U1nQ39Js0btGVF
 s3Vup+lfsQU1PkFLt3g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 5be1bcaeee5ed..83d964e884086 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index e2600447f217a..f6e02f33ef106 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -109,15 +109,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

