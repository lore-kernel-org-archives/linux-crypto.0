Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D83E31578E;
	Thu, 27 Aug 2026 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837071; cv=fail; b=W++8j350eLfFiQIxpW4X0FoJ894zDdc6lCu7QlnExJeIlHjp/hs2eW794pWGqZsAO7awpX2gTNHwy/ZV0l1LjzN13C6pN/AoZs7IGqRlOYro+q1X5Zt0Vt5iwgwtIYRdCTaXnl4F5J4qtSn+EvQWQaOOt8b5HFHOVS39Z08eIDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837071; c=relaxed/simple;
	bh=3l+N7VRjb7sCYwjUPdOx+NEFhmC5BVJCOEULINgQzmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=luCATyhDvHvGfX3zffAQWFZvXUTuCaHiH6XEqTSQ/NiScPqOT8V4STjapgdw6s/m329cTmAwRrhr8z/P+eDrh+Kxh9ezBO9g6NHxLmjZZm6f5uPfHuyLVAUSH27PoEeYeiy37LBkOx3upizv2vLqT+o5pVoFHhJ3xoddtOXOZ0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=S9yD8cLU; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Z/ii0Na7; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="S9yD8cLU";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Z/ii0Na7"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67RCA9Qw2915293;
	Thu, 27 Aug 2026 08:24:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87
	no=; b=S9yD8cLUsIuuIHTsix+SQfarXqjg7DFF1oQXpoEM55Eur/GFSHfQHw60m
	ZSqzRTFXeFVhp5uAFh9mK9rDpWRRBMFUyGTeooCloia5BkeqQyfakdmQekNoPKTk
	rbMgY1mH+SkvdStJMq7ZGsnFk/0H6V8VHjya9C427gEMKalKlFbyPwsOBLhlgNbK
	L4WZOcLWUchQBeSKwojQunqyC8IsW9VLQdzZGT0ja1P0n8byZO9d+aPMpbkcmZF/
	4H12WxPE9/6ZxwgNnFciNl+7mODY9kQUTOS86prfc4ZLYemkKInsrr3O6E92Pan0
	BssDu12hPQdw5CNJtrWuHpVxcaSXw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gahg39dbp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:12 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xU7MyBgLyBN02enBW5KuHUzSd8NbYnEDPOwKGEIEIL4+QwfeSJr7kfnyRqMI7cHnVItbq6hcTJkp8IUztBNlMaKdjlxbgeGKcKtCGVyhWrAuZdb57tGxAU0zyIBgT65dMwrOGUiYqrScNb0OmEf+kKfxeZNLcSj/S+cbwKJp2S8eSYivpHB1GizOCeEHBR7oUnf5LhDSyv2XuJ6LnAWnfmC2+u4vseV8x2JAUO4ww3qROVbX4PBreo8V6eOr845pQJrgYDZX9pxTA6OJ4GetLeuy68q0I8k1GaQQItxcjnTjAyZkIvElwF1o0kT71tSDS0p2VwGcT8kyaJW1VJ60Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=xyYg6Y8YQfvkei3fbc1GvGp125dxAh+BzlCLaecSRrEAxT0w8WBX85zz63BQ9o+bUl6cGt2zN2bO0XOs3c7xClIjM/Te9BbiupXzH/z1Iyp3C3dQFS2OJtwe2abQMKk8+6cgOVr8ELV3LWgHVuNzEeJJkT0Ms5HyHFjomtcTzq0f4knC7DML/e/uejLzM9t1s20EL1QFunfQY6Ufys2+RW606q07swC12upXEPpG1eFeZj9SJs65wpWIEPc/+62iyDUlm4ikB93Dot9/4rItMX2FuDS+rWIU+QLP7YYpnc7u+hqx//M+dcAUXzrfwZm770IaI0KlCofLruelJiXevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=Z/ii0Na7sqRCOVibf9YwVmstFfUQc/adZNyOegTNb9PBqjwZeIOK1zqwSbwt0rl7aBlc0rKz8wqkKHf2/N06TFwur2a8zc9Xa0jkMLsDv1uENYOYhcE/c4YTL8JBWZ7e0qNxXXQJ5UvoHLuhja+OYW0CULNlLZGKqLi8FD2dJpI=
Received: from CH2PR10CA0021.namprd10.prod.outlook.com (2603:10b6:610:4c::31)
 by MW5PR10MB5827.namprd10.prod.outlook.com (2603:10b6:303:19c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Thu, 27 Aug
 2026 13:24:09 +0000
Received: from CH3PEPF00000015.namprd21.prod.outlook.com
 (2603:10b6:610:4c:cafe::18) by CH2PR10CA0021.outlook.office365.com
 (2603:10b6:610:4c::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH3PEPF00000015.mail.protection.outlook.com (10.167.244.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Thu, 27 Aug 2026 13:24:07 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:33 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:33 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:33 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNWWX893893;
	Thu, 27 Aug 2026 08:23:32 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/7] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 27 Aug 2026 18:53:12 +0530
Message-ID: <20260827132318.613876-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827132318.613876-1-t-pratham@ti.com>
References: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000015:EE_|MW5PR10MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e39bb92-c3ce-4e92-543a-08df043e7928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|376014|23010399003|18002099003|22082099003|13003099007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	2Jg9NBAw1We/oGtp0MdMrRI9iKxtPHVrxLxULBuGPIAiN7KT6WMindH0lDhYC84OXZSxSTabfAouvfk/Ra5rrV78AqFGLpHddrhcyWJgaA/VHhyojb7SMPLbSenr6gqwg2LMiGuuei8FXcbutckZfg+v6EOQrh6loMio8Ps95hcl9B6iOeU8U3CwEpQnEHauFjIGDdNBafQ45RL56wWQQAkhTK1aOIIRucOSn+U6Bvp66DaKJfq0GSvBMqAq/qajSL6iIw/BU1fev6jEIkr/tNhle5FTQ1Jb/WQppgrpVZgJBi58wly0Csvr73cgQTm3JkT+iaRnRtUm2eeNg6gj5jl+D2NKkUTG9kYmmgQ60R6k0Z87gkeLKD3kSh/t6yDQ++qVLNSTyf/fAn+zaQVdjRGYJb4habRkGG6GBe/xcZUPBQqqc8UGMMqbyK3AuOP3UxFD0wr2oi5xoFWkaKh8po/b9CCZb5MD8vGDlHa01Xo/3niqyzVJA95lI57i8PbPDmNVVQZ+7o7dTvDGCdEejsZH9udwa1JJWLckcu6a2+9thNjzDL4bdZWaQnzf1atBHhsZsuUiF+hUehUBGoUyrvS5rM8BQPrml9OA4E1cLfeJydVQReragGa3SbS3RR+ijb0Nmx17QbHwlcDi+6mIKg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(376014)(23010399003)(18002099003)(22082099003)(13003099007)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4BCl4FpzEjxkY6rYCN1fY76yEsWmIqtOX3UJjkCxMwqSe1N8fsXzkmqS11SoHHgvlkSk4iUrkbW9TJEJiLQHmU8E0e+N3GvZ6k/QRI97b6Mx2/CoWHoHxCYhSyi8XQcynix9vK8WyZv1l4MWUIXLGKltIAuaIJaYLwcr3FRS5sG4ySM5EyKAxrl41/p3xwsJUCN/yJp6fYoxUePtPJredIJfEGw9m6Tn7ucIlnCQnXl56f96JDZ2UkXBDp7fSXPmeM0TI1714wLyo2BkVlHC2/vsvUYvphuEuCT8riZ0TL2ezFTNJcCmMqml499QErOq15Jj6M9BSf8aizZrm/WpmvoGSNDgRSz4azYDi3AgtgIRSRV61NBZQgzZ48aGMyq2cA9ahdQzYyDuHON/bhOCfZmRctJk+S65+FokuvPyTnCm9YEwo1sDRiHC/3V+579F
X-Exchange-RoutingPolicyChecked:
	wFX/UUjEVqE2wlaQEFU1eIofHFuWUsLkawZ2CSx0ZzOjypZi8Gcy33wgRccqxyyeij/Rx/VYXRuHKneoZogVSkyK5bN6yHgGC26suB9CpBmOhbvRv03yrws4icWDsBHtRBAbXWq2eCjtOWCE4ofhdpvimb8LCjGHKMHxUIIXHIODOKEOF/EAQ1DySQ1nLOno3SqXk3G0paS3fhQb5ee9uAYL2bpgOMuodIMSy4AErWIIv9chMS8PGUoay6HV5vRfG9TWU38A6lUeAk40hC8xKEmbePMRyj2QCH9FQhb1liLNEGX192NR6/XkNPzodZ6Xqbm6WxJIsTOe0LlnrPredw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:07.6117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e39bb92-c3ce-4e92-543a-08df043e7928
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000015.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5827
X-Proofpoint-GUID: XHiO88QpRq6Cw0tTKboz7WNNjEVzJ8oM
X-Authority-Analysis: v=2.4 cv=M4597Sws c=1 sm=1 tr=0 ts=6a903a7c cx=c_pps
 a=nwluK1hbAjewvkLeLlmlZw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-ORIG-GUID: XHiO88QpRq6Cw0tTKboz7WNNjEVzJ8oM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX1x6PR3vCNz4h
 KBzLK9BMdKoU5ZztBl8DWjBerH/ZPwyM3xGqQDh0tUcmU8mc6n2Xh9T7zSVDow7oRk48aPl4ESK
 /SryqrpN8XcYX9Y/llY/tu03i9/YXQGoljlvBre54+s8CVEPIWTY0D+6FoXi0yo0asygs+psvnX
 Uipa2uFY+gAiYaPCE5+gr/lLoiLv89IXMhB91xQSRjv6LNvJxqYhnvNHqeHl654QSv2QAie0kX6
 5hSTzuzW/BP8613wwf9f5V20lTZp1MXARq+eTPe6ER2vV2cXW6gx06D+nb/9/nvgk8qbj5+9tQy
 zMWnpXGyVqal9qzVfekgyGsIRh4BbKkSvNAqqPpwhU0L+YQSn6yaly/UBTtSiu1+YuAMjtVPaM9
 pXaqTODIWyq+IokAu+PO8NcdNGJYA9E3LwFVDr32Pvr4/a9drB9Y1vA3WL0rL4agOgqobGYreX7
 msotYCgcz6OnKVLEO7A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXx7OgckkccpRB
 v7VY7j0yfpPLAYT7Hvaki94OgnAVAgZsHBW2mlTNaKnyFd9HIVlHwYRVLa+XmZB3Qr9A25pvSXH
 g0WAZBEKLApgKNiqHN+81qtDj2mUpGc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270112

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a2ad79bec105a..cc02449382673 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -40,7 +40,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

