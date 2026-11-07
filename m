Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063469;
	b=epOi9P/Ym2k1HsjSUPS5Lf4XIEMZR7LY567esBvN8UyTK1dilPrqc4ULSFROvB1ojZuD
	 fOlkHeiBC2p6xEyDGQjXgC0eeK7h8WoB/lf5+DY3Z9Rop/H3p8wRT5Aq0b35HKfQ9Xv8B
	 e5tAK6uZCguRViojBEr3IzAj0c0KOZ0HwnKZzp9SKpvrBDSZzgZn3gHd/Q9Vq2xLybTt+
	 Ipy7g2TEC2GZ48npf4P8o6Pmfgn4j65P7JwnDrOKP1Upvav5ZEF5hBOKt8z1eVse1/bVe
	 y/gJ2KMHbsYCB+mlOrP1IE1fNRjNZLfmDlz9DjwS/nKiJ89Fg6YXfnr/uoRQjfCLSGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063469;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
	b=n7VRSzf2QATijm7RqfldrS9CCoO88LUEylWeJlyqR9FiweIqchIBYerdAAhmFX8tfdw4
	 YOst/o9DDSqTyRXd9f/TzLmxUnTwCiTIbSEYIw6JxLCvtvB4hsFOFczZqM8iQ1avy5u6/
	 bckhwlRVoRb+6RJsHtSjW2XNSTWCXoM0QcyyqpBS9If+MHXER+MVqUvVDMqit7jUAfbmb
	 iqdXQwuyyBzra6wsrG26d5zFmWUIpdQ4Qlq3pEqHm8mAQSd0e8+/XAbL2ir5+PkzLbC/6
	 GyW2pGFdM76i0v94/TJ/jAKokKk5uStHkLvmvXJoxsEItaxCvhgwnat97Zk2F8S+V7Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nVQSo8g4;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=jwkqWzYR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A26606A32C;
	Sat,  7 Nov 2026 14:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80A26606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nVQSo8g4;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=jwkqWzYR
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BvvaX3543981;
	Sat, 7 Nov 2026 08:57:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=nVQSo8g47BZsdNYtC5s6tItuFAsIK1bqcrW3tAnQ04YLM5l/bqdsjJOXH
	+IGk9Vqk7daNkLKwMg9w+O1WCo2DBX0Urb1TSaXqttX3xIPf4+EXJsfJETPyjyhn
	bT84DhwbRaTg8ATXMOoI0RzafEEhUh03Q6WEcGoGPSEuPjI31cbQYoXCMQsPF5K+
	5zE367sFcd29vJmWky5ymUfZP8vBoSHwogkg1LolHPUu8eG7JlktOLCCqknKWSeR
	dxgiQy+eBfjlDjurzxmw1Hgh9nF+kWWU7poquN2YhfcOHxMJPNxzSqcyEo+LJc68
	AX9eANqoGcXBcnbxEoWUHpfP3yTbg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013048.outbound.protection.outlook.com [40.93.196.48])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmhppw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:47 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NUKLCJbAsYoZHfv9GK3x1Vbm1aQKfi+OVfLOju5MeHroN7DussXgdjFk2U6vZkb2BO39D0xQaxlXpcuglFI+tteMS9OxW/NSBJiTzAYwP6XY2yeDYQkRR8+JAPbA8b0B+Aq1jmCIlI7ywtMVe+VmqEKPrSFf4B/MfoIqshoKo6znO2Uhp2vKx61F+PEHYJzLTkEpUfUTRLDCCgipblfgNi61yMegYbBh9k7zN5vhyiDD7UReoYqRaxibC5T3IvclnS6gksEKnEmsuCAVIYkCLsCvp4sPNU2c/Yrec84Xj/Pg4M1rkXSduQGhPSDZqEP1F8KK1wN3AYy6ssLvofCnyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=MrlaxZv79sUYnljPFd/fqpW3GTPGLNO0EqPqvCuAPTPW4xr2CJq08HoZm0lW6uvDOyLcUBkNGmRzLv5MknGG+6wdN8XoBX9dj7Y8ho+GJQE6OPOMFcb+6rEMZtMrBo1haokgsaEnMg3tWvgnN+xznEBOE92moPieurCdz4B9EGjH3xIRH9ovfmHVIrc3xmm/K0xH2j5eCr+Nmw/ABuj+XhdlyLz5gk7e0vKmMh1PH+1xyDkSrSrp3I07MBqL5OqeqJLrZxBBtJfYEpohnByLqCZU87y7OhWjJ3+igVjxMwLLJUAnAjmM5nip1jy5INPHC29ZNmMQqNcopWRjqDoRSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=jwkqWzYRiZFMFkxwiCCryf54PTqSltCrrzidlUJL/EnM1tScjdyiiKvrtZ8Kj2wQuw1V24UMS+W/+1r1A/Cmqu5AX8UnyjvIPPUNUKf45qee9MwdJ6+J/tQN0WuhRWERRBdDJK/tv9aHHvtKoqFf8vQiKMhko2f/s9Dp0NO4qAg=
Received: from BY3PR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:39b::19)
 by CH0PR10MB4954.namprd10.prod.outlook.com (2603:10b6:610:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 14:57:45 +0000
Received: from PH4PEPF0000B60C.namprd21.prod.outlook.com
 (2603:10b6:a03:39b:cafe::1d) by BY3PR05CA0044.outlook.office365.com
 (2603:10b6:a03:39b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Sat, 7
 Nov 2026 14:57:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 PH4PEPF0000B60C.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:57:42 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:13 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:13 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:13 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EvB8n191056;
	Sat, 7 Nov 2026 08:57:12 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Sat, 7 Nov 2026 20:26:16 +0530
Message-ID: <20261107145618.2349562-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60C:EE_|CH0PR10MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be2f806-6c96-4784-cb73-08df3cdf7983
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|261021135927099003|261026121527099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	dv3eoWiwND8gGh5R62I2ekNkZCG5C0HsB0rZXYYDP8tW7Ew1bCWXTVqY0ddKBnVmmPZLhc7CDogJM77+qmh20GJ16GsnQNNlglBpAymKF9ermx0UFscFWSrNVTZXakZRSyrD/j+gDcCwJ1SKKZEbB7UPQVtI3zvI7/hIAIM2KXhmx0ev19n2oXsjyjccKIAn2F6D3Czq3TE4Yw43qQ1j5bGv9I+uhTvgi/ysyEbgfMx0i2lP8HATuDBLLNcQ6s13a/5njRNAI7Rby8W42C8OtQVQwV6pmuoVeYRjwJizkC8DFRMJ1A1/bwAja+w76BN7MB1HcRvDp9yOd3nOIMa5voQOfLCIGLaUipZDtDP+q4I4bch8tPYL/F2BZJfws4Vl8y/K4wuvgdGWAOoZ+BA8WeZbWqnQfuHYM4exmOI/bcWaj2/YQ/Ho3sJdPBBBNsqxaBESEhcq6i6BVP+jhDHahM75W88JqvVRD8DVhY+GkTQzibqewyQpxjNnJoYUUgGEri67IezM8IrKO5DzYK/tIeT9XjWE4/XpWBqkIPd6bGDMRMxhSS+boPnkhC4aiqyPlrdK/3WWJgAfDJoSMnAzKKd/f1d9L3wfzxq6u/AVSkRKtKBU0ienxUuKUuDAh45hbus+1pSv9puqQDSSgh7nadKcNKoTKUuWGOTYbqcfWe8AmIGcvMhFwbKcNXWi8GKoLTlejaJS/63cGorn2MEN0Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(261021135927099003)(261026121527099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+QFDefYn4iMycKJrQqnjJHLgl8T6SW6n1STb9+UQson5l/q67SgwM3zyfGiQZCHEjtPUnLl5WiKUtZc0YsxLbq0JrjMr3OeT4PB/zWWBBRgxzvJyXx/412G4yDpIgywDapDP0a9HuVBp89jVFCHu9pUvLGZvkXWI7xWvXh2ieeOgyoLadlEudPRyfIr8L5Ctx+3PfAD6OxIOVE/ubCdbyX/evH2qPTZB3mnFd15ioyNX1ggmA1VSxJ/mR3Iu4P2ILRXfbCGjMbgn5itm4UsYTevCkGpb7OqdOtcM8ipO06EOogNRpWAsv4ZCZALz38NIE2P75nE+Fg7qSDGLQVKPCKDdUdz/49a98UCo6CLT42pqNAFeL2dshYKIHxhKmnZ1KFaYUP8hM2oheUv1CsSZuKxvz16aiJFcUr2WDHQ1QwN2g15IkwmGZL1cyT4z8SAg
X-Exchange-RoutingPolicyChecked:
	e5PA7D1x/KMhnfY03IVHCSN9AEG1y/XavR5EHhq0RuttRB4+I86M/UJHibxdJnYcB14UnbtSfDuByy04BmI/RD3gBpv64ijItyaXSVVi29Y4Sx5EjV0KGfxlTCTTGlHakTmhQyMBbTR0wCnTEDHXDl9skA9AiHLuW7pWPhAqIGRZLwumfOmqV1P5CQS3sufLlxI2jz9eNOhjqrKyulH6zH7J0Hd7DRXD7V6UFc7FFUQsdDdzkdtJcw8eg/FzAoHbJy+ab6m7Tg1j8E8bLDH05j4UL1mfx0MSb+uE/Lw18UlccdK2vdx79K5ipLdEKp0fG8h4VaF4Exhv3DzYneMjCg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:42.2888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be2f806-6c96-4784-cb73-08df3cdf7983
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4954
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef3c6b cx=c_pps
 a=BzYQZFXHgS3DonsPiq/7CA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX1frLFMIYPaRt
 CQmsbYGOdSA/4cInRwd29SIrVvHwNyDYTmgMkK87+F6TsdN11TCbxwtQYc6fqNKwt1UKAMI6lHD
 Kkwfkuu6wlFj4TRg6Zi2jONrY9/BLF4MOaclbmb1iNZnta2mTd3FR+dlUiDl1LKbCIbbtaJYtsZ
 ccjH+s1VcKR4dagYwx3hbnzjksK5hz+qGubspyMQ2FihFQvbXsC45dpxSn8A3Ht5SZ6ZrTgiOH9
 o9RgJcSqvkkXJmiVhRsf2kjkCiArXoYYXfW4a2wnW0wyrjiFDbEHlgOK8GphQyWN7y7HVx40OO6
 D5IE9/X3TPi6my9LAi2dlNrEz93XN5tDOJLxKgPiSpi0MzFavLbP5LTS5+BjpuBA96tJqwxuj7S
 96W/3STFPLlVUdUcHzXmHsKDZWW0YdcJHJ2sN96Yg8MJuIEG78L6SXKrHZtKlphWM5S1PQWQPwM
 Zn8g00RaRHYi8cp00OQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX769dxDnV7vz5
 +8udF89fH9wuk4DsuPR/tGfEU4ZuOFOBhUcl+ev6lYT7cowXb5sZ7Mi6JyaZ/Ys7N6JHr1NDff6
 5yz5XkvbSRVtKHOz/nhhn2lOSjntUNk=
X-Proofpoint-ORIG-GUID: -qBTjD_9OXHTPaBthhgg23XyoPjR0pq9
X-Proofpoint-GUID: -qBTjD_9OXHTPaBthhgg23XyoPjR0pq9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

There are two issues wrt tag operations (tag read/write in AEAD
algorithms) pointed out by Sashiko:
1. dma_sync_sg_for_cpu() before tag operations always uses rx_dev. But
   dst is mapped with tx_dev in case of inline operations. This is
   "technically" a no-issue right now as both devices use different
   channels from the same dma device. But it is nice to be correct.
2. dma_unmap_sg() is being called after tag operations. But between
   them, there is no synchronisation step. So tag operations writing TAG
   into the dst scatterlist could in theory be lost in the cache
   invalidation done as part of unmapping scatterlists.

Now, in the current code, we can correct both of these with some
conditional logic and repeating the sync (this time with
sync_for_device). However, it felt more elegant to move the TAG
operations to occur after all the scatterlists are unmapped. This
ensures all buffers are properly synced as well as avoids unnecessary
repeated syncing of caches.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index bd26c3f438e34..657653d6c62f8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -915,6 +915,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1138,15 +1139,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		ret = 0;
 	}
 
-	if (cryptlen != 0)
-		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
-
-	if (rctx->enc)
-		err = dthe_aead_enc_get_tag(req);
-	else
-		err = dthe_aead_dec_verify_tag(req);
-
-	ret = (ret) ? ret : err;
+	/*
+	 * Need to read TAG registers if data is submitted, even in case
+	 * of DMA timeout, to clear the hardware states
+	 */
+	do_tag_ops = true;
 
 aead_dma_prep_dst_err:
 	if (diff_dst && cryptlen != 0)
@@ -1162,6 +1159,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 
+	/* Do tag ops after scatterlist unmapping syncs caches */
+	if (do_tag_ops) {
+		if (rctx->enc)
+			err = dthe_aead_enc_get_tag(req);
+		else
+			err = dthe_aead_dec_verify_tag(req);
+
+		ret = (ret) ? ret : err;
+	}
+
 aead_dma_map_aad_err:
 	if (diff_dst && cryptlen != 0)
 		kfree(dst);
-- 
2.34.1

