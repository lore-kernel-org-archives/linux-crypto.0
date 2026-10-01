Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164024BE44B;
	Thu,  1 Oct 2026 08:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844854; cv=fail; b=RkYH3i9X/MO0muzseIOfvmUuFqZENUPMbCtNbk/HWYkUe548PRfyVGew8QlvGOCZeoTfriEJQxR5ap7OxVqFpBc5LODWRLpmeUeW7hExtXfGU+/DW18kWJf9yEKAZM3frG1YzG6rNke3mORT0jwXUb+6ApoNDMv1SMQHAChI5dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844854; c=relaxed/simple;
	bh=lCNQzFK9UJ37Sea3gL7rPWFDv6GNWE/ObV3aC8JhLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8ucdimCiRQlThuiGpYH0krOk88nic3jmOdT01G3/j8CaS/WFK0vHA4k5Mj9unXte0rwIA/RN59jRqHpMWPyUjt9H8b3TChU2DhtQ8zKwaYH3T0Dcp6D97iynTnViiZ6c6ESI8zu09Hm96s+AHVwrTo0r6dyQd5ZKxBs66tOu5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=TD3gIpsj; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=h7ZeNSSZ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="TD3gIpsj";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="h7ZeNSSZ"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69187Sj61207696;
	Thu, 1 Oct 2026 03:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=TD3gIpsjXXw487R3j/TK5bW762H/bgRZiBbCXXZjsiodncfXVCLn24RBo
	iIzUqCMCK/yxHlT0ByXbL6VVwl0kldz6UvZ5JOIgjGqF/yVs4KdynOnzgh/9YbSe
	B9wT18QvZfR+tPnCfTfBmT7A0f1mZa00e2eeQ+J+tYjn7J4mqMXJbC/ttryVyu7T
	f6dlWMSFEsY+JNNxGkljC4GlyCiID6uq9IAvtG7IAyhXwMpOhqeHXgfjwRqJOdky
	u2Qmg/b0qXH+a2zayYmU3J+qv2kweWWhe4OjbEiwRq61i5Kw9lCHsMUBkv4OFa94
	FO3m9BwpDwbmVsk7ymYkcgDnIVn0w==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h1kqyg910-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:54:10 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pV2/Gom12Yi3al3obJRBwJJZgmXARI8jJQY23epl74xpvWGvP8QXeBkdXOU0hAXsC2FqW6uHkXIPSEjiDrcynQ6wbUdpAYvHR/UOCdNajHOm1jtPC6/KU2q8zu3WxDym6nl4i6mSvSXNv9nAfyX910hJyUgqqo3RjciyvwtzAygfJBbpOs5A/G5Q8cNKUpvpDV+Bf+oLCrygnf3w0FsTYjBe6A0IjaZCkON+ixMLUu+JNWwsT6jVOTtTSFc3AzyA2J4Y3MMvfg0J6b9923y1o9JxWwGfODR6Gtl1xCiWaaHpxzuOOVdBgJqGTFkvOr1sojEODPwYhn1w3FRGX9Eklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=j0RSKMPvWtogjie9KrKFdnbq19MH7GdZKnhGfnmgCafqWxPHerjaRuxSOie6NZx2AC3WwSGqQOSO8u4L5voTMxRRcBh0EmXDabeZ2aMIfQuSF1a+rBLg/MTmKH+lJUcoVuodCoV0YzcKw2w0UVjnN+/m5ElIQWFei8UYf2ikxKEfyedKbR8hPjzSGNL2xCVlU7BndbfJLaQtKlpAont3PgCd1VtzZq8brN5ERghBi+fnLiHjGMM5U1Hh+7Dpx+s9wQJgZ/SoI12pFbVNfOl5PMjoQpYJidF9C0vrvisGXV4/ITcxuqmukTJ4zvGNLM/DSZH09/zu/A9IOBC+tHgzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=h7ZeNSSZpva7hzHF/IdbpejI/lArzqLhzNffVtHdcrVgRZu2XXn3Sm8SzqbdA5369ZHWirdMKdQ4+6CHqwQ/THRQrx0rM6RIsD22+ZmlYWgMY+28wZUidmvhOzWey2AIll8LKKtssrNXBeYm0rsBKKjRdprDHub5pmm8OjQ0CrM=
Received: from BN1PR10CA0025.namprd10.prod.outlook.com (2603:10b6:408:e0::30)
 by SA1PR10MB6591.namprd10.prod.outlook.com (2603:10b6:806:2bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Thu, 1 Oct 2026
 08:54:01 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:e0:cafe::82) by BN1PR10CA0025.outlook.office365.com
 (2603:10b6:408:e0::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:54:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:59 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:19 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:19 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rIE8648784;
	Thu, 1 Oct 2026 03:53:19 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Thu, 1 Oct 2026 14:22:42 +0530
Message-ID: <20261001085245.2922974-13-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|SA1PR10MB6591:EE_
X-MS-Office365-Filtering-Correlation-Id: 07eef067-0f4d-4df7-3394-08df1f9988e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ARNIlVeboKLcWCgoL89W2KnezRwASL4DD53Do/4KJ42JmDw7BBs3a6T9GL70Mod4Iii09ckSC8gb2nUJK7Rv/yEgYgUkuU2RApckdN3M40vOGgl3iEm8vEWr9XWu5K1uXWiLGtzResIb690Wn9frwP0JzNJbesgDPFFKhISGQt5WSTlR610VCB1wv+bJ3OF27ZnHOp0Qyn9mxryXTV2si/QMzl4NDnyUs/JLn1rt+PrwDaRR40aO9pmtCFkQkkW8IDcU7OKkO/KMYhwRwSpgKLznqAnmTtuOQFQA5XGmSi/HsEFi1Kmv23jwNxfKePc5o/bIfs5j9pvF4gaSbrzu7S3fvslEFO0dRF3LYQ5m3SYLsznZB7uMrkmHfFK51HH0RghNvrhWn59awkh2RweQwd0nI4Hcf/BIYf8G3Bb+ka+6YPY3uUUhU3zA/cT+wnhY/j4qnQB812ZJPA7kvfuVwX3KSUmNDfDjelEGMgI8R3XmBZ3vvBTj5gFIkIK88vsORg/Z7BYH8Z9gmFKTgf/8KI0XpN1XkmWz1jq8t6VyX9203biRrCttR+LnQQbT4ryW5NeOYOsLpXYWbDbZKt0+u8tYTykAJ9zaHyF6w45FisfBVcpek3RDonAQRf5Wkzyxpne+M3zrxtjb/co/VjArcftzYxME0abYnPSC4kBncqda2n8arClp8eYxDl/ZAbOcgqsFFsrM1M5RTbl3IRoO8Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9fBuwt22U2h2OfrbzJK46iJsEkKdHQuiSzwKLhnIsWdknC8C9o2nFiwGOtXbkS6qZt0sncfWPR3lBaV0KYacVGSrTPz4b6j6AiqO83d1zzVhKmSz3pUwM6XXTree0zBncXER/8Vi/eyedY4FUdd7phch+g+8NYdZt457HxWd1D8ofyH3L0R/2v5n850DedDLrsUh6RlZyC34YDZaRuBllJLOYeee5ns1HWmql7zVd+kcZMEbHBrgveuiWIb+sU9QfYPX0wosrSq0JlaeKX7TsaDEqO+lOvgAPnJ6cTD3qI3ijPolmsRobyZ9QJ+SDJpeo+yMwgKqy8TYP2XlTTnp1Wiovz2RQbo0lz47lN8j3FFFUuTNjOF4M4TyFGP1f/F6D2vPPkxvrWcmZ1x6WjBwQkVTGJV4Az0jiwRWEynhW4xe9umvwJNocrCvNqNnXPvj
X-Exchange-RoutingPolicyChecked:
	RR8E5NzystJwYqZ1v2XWbp4JVd++JfsuqRf9jgRPUEIvsBnr2cEtoKDrNHgwiYzAldxU/I/MO7/4QRKpPRy2P8wrIArjjomnvu+3JkApP8oelwP7lDM1FipuUbtpDS5s9WkXyHj4iJDPGUEPDQiaM4KVXwxYh3okSxSZUPIk6ttT1jeLApFh4gXVwDpVChhVDNOfXpr4BYTf+o6BOMVMtUnsw8/cC1q2KyxL6fBn6WOmT5pFc3IP64qRqW6Xm37Z7+YBJbOFhk4+A5K6VDErFQaNuwdIRBswx00Dcx15wmZhulKvS/kAWVw7wC6aCf8ZMdevn/VkZDflFkhGAnY1oA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:59.6200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07eef067-0f4d-4df7-3394-08df1f9988e9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6591
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXzRFEnSTShZK1
 k+iIt6Y6pN5wWCzpqbInSqU9fbMMT276UHsMYutXCTdbNC6qEQnN+WYLKQHcwy9M+wgh0OeBTUy
 7/DkZP2taoOK99sITvIFg1oEm8jUJLE=
X-Authority-Analysis: v=2.4 cv=a6alZkSF c=1 sm=1 tr=0 ts=6abe1fb3 cx=c_pps
 a=ouBVT1c3MJkzDXWVqRnxag==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX6AqtV+vQiu41
 ehh5gR5uZqi8Xs6ax8OiTQFZNH8KIlTrROqmYuB9/yM9FpmS9V49AQ4QeqEmRO0l+bg8GfyxFs+
 +8tYbmxGB/dMQRN8t44zfLKjvbRBXutddvBb9K+w/AodITPO/5oeBgNrkj6uSLrtZa2vFXshfJD
 i1JzWeGWS/fHA7uZDs0o1VFY6sNmrAV680CzcCfR8/F6KASUi9KiJveIu4FBRSGPebANRbRZN/U
 Hq89Zysynz/FxoDsWjywpkhBOcl2al6NlpUiTuun4V0VXSFvQvcgkTAISdZlxD7HQsbXKSpWb2C
 qpoiMo2PHPmqugXIoXIoNoJ5bUJlL8bnM1xTSPteIAe8QR5O3MTNM/GJ2BGDvjXd3q3wWDLCs22
 vE4vA99teEsO4Qlw6EBe21ndmpQTPdhcI40Ea5Aexcjc0x1b/TVFQQ78K/aezpBoiMDWLiDQ+VY
 U0Y4CK7qLSYDQMkUHWw==
X-Proofpoint-ORIG-GUID: zG39VnGVN_UWFCM6Eh0279Q9HyJLoE9b
X-Proofpoint-GUID: zG39VnGVN_UWFCM6Eh0279Q9HyJLoE9b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010035

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

