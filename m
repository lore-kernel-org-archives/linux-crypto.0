Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9413834F49F;
	Thu, 27 Aug 2026 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837067; cv=fail; b=c60DnHTrykIYs/lliDKXf12vNLlCcXO0DpeIBMu3TUInk9vvSFs2afVkIH0BRfBkxDJOXsFXWd6tIwA8kvCXMzOm8UwwNRcuMwzn6Ph9SgNPBw9B+QR7o7g3s2/9D0B/SdS0DIihtaZnsb01klthnwzeqXHxgMAi1Ww5iCICa4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837067; c=relaxed/simple;
	bh=NduprVZn6wgOkyKQIQV0q07lxKi+rgX0yR7H7LNM5Gw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tq1Px+Od8dNXPge8xmXOE9PvqgseBDhOKXJ8vbNQMczLVfmp2mPDeOgrVhIdl8Trt0CIeMH+XEpwNFXFuwrVbgP42+bmK9D+SMjBkT57ygFFkUOksMJVtlGxiNhQEhFbGRkvg4/BTffs1cIahhQxGbIpPNtGD/w64meeOOMAc28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SF04Ds7Q; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=TxzC0kvy; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SF04Ds7Q";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="TxzC0kvy"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67RCA9Qv2915293;
	Thu, 27 Aug 2026 08:24:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=BZfGaRICbUgpq6No8cR0RHUKYNyu2R7EIt/5uF3Hr
	PA=; b=SF04Ds7Qdlu+hP8V9SLibHvet9gLkRfweZtJ3x/3GPlQqUYLRugxutPu2
	iEzs49oIc0zYJmpsxsVhHD8AhW9jBEg8tnSQYJWoLWkfGYVjGkqC/vbSeG8j7PgX
	UOy47+xa58nJdxYr100buB0UFqonV6d6zFA39uEnd6Dhe0whIoPzv5fzaxK2RlBG
	uKzryiMSyEzk8sA0Twv2AX6sD27eJl2/vHR8K+OlVToIjb13wgge7/6SRQGxrx0O
	SWZCeH6pQLKUyroBge5f1aa56M4Giu3LywJRZnjtcHeWJsWj2InVKz6KjgzLa3M1
	iIiaLz2pfxL/9pz0Z2ue4vgeiuq6A==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gahg39dbk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:11 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypP19HW7KV2FSRFDc7Yhy7ErKr6sk2rguxb61OwpkaPvtrUbHXHiCNoomQB+YqryxkI28EVZZg0Lu+M5+1WTWBUJrpMBlmAmpPj9/Nql1y4NEwbyCUJktlmIvcCU7n7kQoHNGr4Dg7yYL6jE4DijWXyH4qGxiLonEVUAahIE6Mflpawu96PCbXIcSFN1akjtFmhKA1EpBLO86buXGcckyHk3U6N7JWOomexPCL634LdAUACwpUyfE24BlAIwBQKbNJ9Y/AYiy5Oo0N3Pj+qEjBz6CV9Rgb8uUGcfBc4HvFusDlhhw92zXgi+gkfMNS3htRagzKhGlKaR+lj7FVsFWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZfGaRICbUgpq6No8cR0RHUKYNyu2R7EIt/5uF3HrPA=;
 b=mjKyMl/80ff4mNa1vOkYnZx+W1GQFarm9mWEalEDj/5u7Pat0aEDqt1iSbadgalileWR6HhWLQtHmeGBOxqavWu7MU/dw+CDbDUdUcP4rpbbCj2zEJr3S1t0kh1nykbTpxX3ZLgpgqahrwLfDQUPBDexG+wbNMr2XWgR/HuNgQUhGQXet5U+CBbnCi3G8Qp6JNNWuTuNJV4jNLB8JPDvq6/3VglReGvnx05pc78Ems5xZ3hmio+lEfBrkyDrLq41hjW6vsXZ24odqTd1PCnRSMHvrbYTPuIlbfHeDyDcunl0uohp/yqMhzNHGNnVNcp1DcRxLDi6Kd6FTDI0gZRLpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZfGaRICbUgpq6No8cR0RHUKYNyu2R7EIt/5uF3HrPA=;
 b=TxzC0kvylKdmwIat1Gpw5bdXQFvU6NIESJA2tbAn1Xb88wXk+rLk0lzj1f2KwQswNXrZLBehwq8EgUdSQP4To/GiQREk8/NnAvLZUmCsWr81R1T/FrgJFN4TplH/AahjawRY7hMUnHV5R64flUeKFm2QFlaiDTXCERr4DvIfkgs=
Received: from PH7P220CA0097.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::15)
 by SJ0PR10MB4750.namprd10.prod.outlook.com (2603:10b6:a03:2d5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.8; Thu, 27 Aug
 2026 13:24:07 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:510:32d:cafe::d) by PH7P220CA0097.outlook.office365.com
 (2603:10b6:510:32d::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:06 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:44 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:44 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:44 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNhIs894221;
	Thu, 27 Aug 2026 08:23:43 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/7] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Thu, 27 Aug 2026 18:53:16 +0530
Message-ID: <20260827132318.613876-6-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|SJ0PR10MB4750:EE_
X-MS-Office365-Filtering-Correlation-Id: 8225ff8d-f165-41b3-8b5d-08df043e7879
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|30052699003|376014|23010399003|82310400026|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5ewebvn8Iy1Sk3par5rb043T6a+jV/UsMQXClpg4vBoLJFuciyxMbkSqaICb4Z716or46HFVMPaNIFwf4XO7wLhEGMB2kO3/CBC154trAZ5B6yOMj2SrgAhoORGrW+/BN1OhRcH0msdi4H7p5s6Rq5OIii0okIMXxLrQRcWXkoW12QiBG4qtRQxLIITNZpcI+tT8CQd3v0LYy2/LqK/diVLg0d9t8YQ33HGiQFJVmomVWB3LuCWNNVsy7FfldNYGAvtukcq0VsWIEIq0OS5HRE5svHBus9osVy48AGn85FPQO5yCXt0o0idxppPbrZtIwkl49ex68VllLE2ZsWRXGWfmM2bTRlSUmION6fiideO/uig9nYZGZ6x4DVIrG+N3MufCcVWNt4vYd7GpJ0EJZ1KH4zcWVN7wMpe4zNElvIVTlqoo9sQZ1pty2uVb2UbMM9ZYgE9BwOv7I+skJ4CiO6U7mKVMdwkjLV8sSUD4OhJDvAMbEPEbtrl3Dyn7gMSZiFjX59VFrpzwBmOSuBtubbDXOYc+bs3AoAqb56rzp3UJ6XgxQ/EKL9F3BowZiKZ1u3jdy66ruO9TOCG6m3RwmcenUZrR53CmTo/+U4H1DCHZy1qjAD0ZC5byYqtb2y0OuIvck0XHsGUym45dh3wCVCgcLLGWxYqxdQsWc9FJziWZaPGyB7+bshh81w3Mt9tuQYXcBkh6AHUlREs0HPGjiw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(30052699003)(376014)(23010399003)(82310400026)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sG2fHfY8E2c8lgONYuk5SHT4eJ314AnpetVSkYNxfupzNhHEZFGZeFbR4MYMpZfjc5y+HZNlD+lCsEg112+UnJYw8Ee/lnlz64wxfLIS6wg3plir6u/dvAgvY6Kab+T8T5+Y0o/RuCrsYztw9/Stw/A5N0S9ERd1G1QTVFEYsW1pJGweJPKVAjHIkHkFqMn3Wv1560sOdjy/nwDqHBW+P/M7va+V9b3dzeL1jq42HPW/tp5NLnceCliLbMo7OqVuNqH5FnaOJ5yzTdLaZtVmeJbM+M38lqdXfGhQROyj/eCt8wr8p+Ru9rPdJIBMn3rOzKPBNvDDGlHoZptPEv6JLLVYHH1fpGdVaLUCwGXP+v7sxptK5fLfPtlEmCmqiFswjkWZss9GGNc5vSrxcHVNVHbGKDEBOiJEMZDmpoFh3NOFo5NDYKXNWP5RhF/NWpY3
X-Exchange-RoutingPolicyChecked:
	ormmLlK/XiPBmwDCzBg93jdnfhelqNLroTTzRc0snmv+Zs1OucfUGKPO2ZC6vmBO67GzudWOaJSx6aPIy2Er8jXF31qaiEoptn8z9mKH4de5CXEK3r/1u9lCXs/qCzonBnaMA5vaGX7pD2c9dfaEohuxhNmbqjfOXZINnL0WR/cE7Kz/Ou7rDTF9uGWY61WKPWdmWnRzh5jQOPsf/iYJZhcr8bpg4kNBhpsSaiW4oA4goJ/wMRZpkrn+LhldSIqh0U7m2nvMAQkLxtQFPuTtXMZC33rMGiTGydgsoPgsDHvzHIXbCherMmVWJjXDf/f7LqEXFN4X6Fm+RjWWYh9Fsg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:06.5065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8225ff8d-f165-41b3-8b5d-08df043e7879
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4750
X-Proofpoint-GUID: UAzGGrFzZsU6ZDaJCwjFxWt0xF984Olk
X-Authority-Analysis: v=2.4 cv=M4597Sws c=1 sm=1 tr=0 ts=6a903a7b cx=c_pps
 a=vcXwJhCbSog8BousImPcCw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=2APMjrMfoq02II8ecpEA:9
X-Proofpoint-ORIG-GUID: UAzGGrFzZsU6ZDaJCwjFxWt0xF984Olk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX7Nm2xRmNAHsG
 ssgchNbLuAhYqv/mnk226DQolGD5qRWJy4GOBYSBUttGeicl0GvRdx1MQAxPgIsssmQyiNNFYm/
 vZ66gmR0m1sjdwFVaXzu2gnUoacz18TlDXVpl7x72jQvOTDh90/QRrhkORfwHL91kfmGVRKntVY
 ujr9poZaRqrP7t6EAqpa8DU6TF1Zma/kotaAr71Q9HmJZ3lfAaI4U9P/rGOD9NDiT2+IWw28lVo
 Nxo4Y+7Oh7hXVRg+627qG73++HJHmpF6wuoqhxbIz2hI7UWfHecF7rBsyFrzg3lE+LB8wAAWE9+
 cmpWTGaF2ZgY4z8UALDt1xLHSFGSHzJX6ZJqkzyO1TKSV0LWaBETNud+YLDbWPBNAo+g+U4REP2
 TWQsbcKkks3pcYnzn2p9h0cu94KKYetwNnmB1lsZCYm3X2FTeq4FfjYFxgkY9e0HYc/ehpsof8o
 W3+tqbwQZhL8QMEGFow==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX0IxbyKfygrg4
 VLLLTIrYuJGOHVXAWJSWXvqgEvO7BpQf/oXHhN/G20E48QPdMeqJSum1sPEF+88q33m/wilQKiP
 FLGCOcMovcz71tIobSks43A5BtqEeME=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270112

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Add a refcnt to struct dthe_data, incrementing it atomically in
*_init_tfm() and decrementing atomically in *_exit_tfm().

dthe_remove() now polls this count, with a bounded timeout, so tfms
allocated before removal have a chance to be freed first. If the timeout
expires, it warns and proceeds anyway rather than blocking removal
indefinitely.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    |  4 ++++
 drivers/crypto/ti/dthev2-common.c | 22 +++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.h |  5 +++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 8998e02b0e86e..8ef54dacf63f2 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -124,6 +124,7 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(ctx->skcipher_fb)) {
 		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -135,6 +136,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -577,6 +579,7 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 	if (IS_ERR(ctx->aead_fb)) {
 		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -588,6 +591,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx);
 }
 
 /**
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 8628187a32e18..c5bb7fe7f9876 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -27,6 +27,10 @@
 
 #define DRIVER_NAME	"dthev2"
 
+/* Interval and timeout for polling dthe_data::refcnt on removal */
+#define DTHE_REFCNT_POLL_INTERVAL_US	20000
+#define DTHE_REFCNT_POLL_TIMEOUT_US	1000000
+
 static struct dthe_list dthe_dev_list = {
 	.dev_list = LIST_HEAD_INIT(dthe_dev_list.dev_list),
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
@@ -41,13 +45,21 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		atomic_inc(&dev_data->refcnt);
+	}
 	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+void dthe_put_dev(struct dthe_tfm_ctx *ctx)
+{
+	atomic_dec(&ctx->dev_data->refcnt);
+	ctx->dev_data = NULL;
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -200,6 +212,7 @@ static int dthe_probe(struct platform_device *pdev)
 static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
+	int refcnt, ret;
 
 	spin_lock(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
@@ -207,6 +220,13 @@ static void dthe_remove(struct platform_device *pdev)
 
 	dthe_unregister_algs();
 
+	ret = readx_poll_timeout(atomic_read, &dev_data->refcnt, refcnt, !refcnt,
+				 DTHE_REFCNT_POLL_INTERVAL_US, DTHE_REFCNT_POLL_TIMEOUT_US);
+	if (ret)
+		dev_warn(dev_data->dev,
+			 "removing with %d transform context(s) still active\n",
+			 refcnt);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..c4adeb34b14f3 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +54,7 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @refcnt: Count of transform contexts currently holding a reference to this instance
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +66,8 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	atomic_t refcnt;
 };
 
 /**
@@ -113,6 +117,7 @@ struct dthe_aes_req_ctx {
 /* Struct definitions end */
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+void dthe_put_dev(struct dthe_tfm_ctx *ctx);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

