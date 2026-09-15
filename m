Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC6047F76C;
	Tue, 15 Sep 2026 09:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466264; cv=fail; b=puTx2fizrypwd5UI+REaCLIJP+5C+vNqdi64+jxJrGVVKCMsDcJbzISVzLdUlS0wr5LmAm0dZdH+H5tpwnTZlMPo3WT6VzU/wtlK/Q5rxWUw7HeU/pBcEJ2sQNNiTp3oDTSkiGVAly5K7xN/XD55plFEIBjgpCPKp+HcepT9jgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466264; c=relaxed/simple;
	bh=dMSxjxHR/7YuWvuj/LVD/Vh9LGwxrYaNLr2mJKjCNLY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=tw4ZpArmElCkrsf/AJytQaoty2+o+IkOFQQq9h0UL70SstYH3hbUUjyZEIYuyh+AKncXOBzInchCxQq2C/ZUdYAOz8IQ+B5XV9Zv6YcEOlMeHzONx9vIyWf8t4hOLGxT+N3KsKp6yDZQ/9OFd0RH7LsLPIyB3+2cE/KelcjJpDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=aXG9KWmu; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=pe1QH89H; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="aXG9KWmu";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pe1QH89H"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fL3V4098131;
	Tue, 15 Sep 2026 04:57:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=1NPZv2ynQoSxCoBUM8nVsLcEB7z87UOn8mW1xRp3A
	bc=; b=aXG9KWmudKjMGCHJHKpjK5E8NT9iLKerP7nihbDA8la6yrVd4MSdgS0Vq
	CuAquNoAjTk7uwuHw9+0WZXEG13WtpsOFr8MjJ3PDm9DlRDCWk+HDJlA+EuhsOnK
	RQtnMQSEOkKb02UeD5jPFx2H4ibi/7hx2UECZL1qVC1qGxuOrAZZcEpDP3AlR8v+
	KymWxjhuoCvqO9IeIIMCZSUoevV6VHWp9oq+CxfLIHCu9YAQIII2TU6zamBHSJ3l
	vmrSZIPHHjnT2nX+UizTcHzVZsG0nz0pPuFC+ra/EN1C24lN+EfUscLfUzZl9ihU
	jiO5lks2fN7UNw1Xe7g2WUE8EwfMw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012058.outbound.protection.outlook.com [52.101.43.58])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakq4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:38 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hhY/TN/Gp5Ri3yO+4xpTOs5lbllNN3Bzg5tuFFZEj7CwhY9U2jyzKf++4BMdn1vI3ejCI2eEyqfU6bYyN1UlaPYU5SIyTLGGZodi82G2L7Zih9KH1/Ye5iDPxUYUtQTKkJpXhqsZpY3F8Y2YAImryu7jOvX8VAbtCco7YKHGhHwWlgPXhnwHMp3mca5bFhSMpOd4tbSEEYQS/gI3aP0L8KF4pALYDfVQvIWvYM4KurKt800wkgwgxTu8cOQ5n0lhoQnSs8Wb+6IHL2CXPxID6vfbceRPsF6V7HiXMvhmBPo/AAv1w1St7LIDJvSl/KXzq2FOguYhCwBI9pZYZ0+HAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NPZv2ynQoSxCoBUM8nVsLcEB7z87UOn8mW1xRp3Abc=;
 b=UI0YJkHprvqvJf2jMt9iMtO40RLT+qBxYZk+v/J9f+B0h76pcv9glLSqfLaGbeG812fJSEUgQU+RCoy8p3XOSr09TfuW7Hi5CI1n/XCSjRPsZKVVimFtyMCKX1IifI5y/Slj8xo49Hmgs6lJlkI00mH2bmaiNqZXyxeQK0ZPGx2F91TSg2AVNW0cocbXgT3/GoWimi8KDXXkwvmQETMISxUfc/QiM6NCKVOMtHjIL4RBZxhgwDDg/cQ+A3TZxGJTcxThmSji+OjL8TLoXNJvCh2NL/qIgqZ82f+5caNGL6Ob3YzAWs3q/CTphrf+tLUbIptPmmdsJYVhh8aRD4sURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NPZv2ynQoSxCoBUM8nVsLcEB7z87UOn8mW1xRp3Abc=;
 b=pe1QH89H+1iydLWrzhX4LXsHOO9qiGTgvf4KK1ybTMVY7Zn/ZSfmn21Fjwy0VjMHLL1znpY742rrPmXPzj8nGJxeXWdBybkZA3sYEtJrvdoHIV5YkK4noa3lwCJwfZFmI1KpAVjsWd6xn+A0yzzG8+zR/meZnbsYEogHqHwGHqk=
Received: from CH0PR03CA0044.namprd03.prod.outlook.com (2603:10b6:610:b3::19)
 by AT6PR10MB987455.namprd10.prod.outlook.com (2603:10b6:170:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:57:36 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:b3:cafe::a7) by CH0PR03CA0044.outlook.office365.com
 (2603:10b6:610:b3::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:34 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:53 -0500
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:53 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:53 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8K3000901;
	Tue, 15 Sep 2026 04:56:50 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:36 +0530
Subject: [PATCH 30/30] crypto: sa2ul - add AES-CM (SA3UL_CM) TRNG priming
 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-30-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=6421;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=dMSxjxHR/7YuWvuj/LVD/Vh9LGwxrYaNLr2mJKjCNLY=;
 b=wORxmUukgnlIjzpM9sOk8NiKdMLvGb2uMeAartv0wa2EMtKLdcEdb+ABOpHCtxzRQc3LuLsdT
 Y2Ti9ua6T2wBmlWjURmYvo1HQbLP+ukPt9ZcQly8FkHfjnL+GQkwDTj
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|AT6PR10MB987455:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa73b7e-5e93-4289-002d-08df130fc418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	uCMekEpAvhZo2ieXqbKr+IQTCqwazIAxYhMtU57hHn1gdHPszmWYIGwty7OaD/4phO7WvIp+0klA14Dyltho4RjYL5ap5e1UQAm+4Qa4U7W39oewXDhC7vNFTjxNsO7m1CGXYqBqq1taH/3UzjdBGb4h/K70SKio+gmpWxlCa9s/PsTscq7tT7Sgi/Bn7gVAjs1982Tpw7w2Ig5z4E9SU4XIxl0MBpRUuxXFhb4NXqGnAw4W5PgeowF2kPLm0DC5NZsHNh9naZbD+8OYUpC12BTts2JLjaw2zXL/BUY8rUJtGcWSw3ay+ufCbZQaIoyEEiQfTa5dy451CLIgFNHM5uiB/e1w3sdm6y8PZIpXuuE7jgVfaNq+ZVkywtL19/jKrokstpyNm44OaQ8GYzfzK7qP74xcjNQ+wXybxZgcQlBpnLu58yqU7ZRCn+shLPPYexQvi2nUWWaaa6i27TZE5OIorQbXwZonpPnOvK9MF3vsp0OaU6JeN98kbvzoUicZjmEHVomj78W+z+Tpxs263oKLxLeUgs17Dl+2TpkvkkbAMCorcRFHIC0a+JYmBsKVTeWGQDzO7ANa4wWXVR1uNkcrwe7mSjePCfJLIgGKB4BZybpi17tf2M1a9rM6QTh3jAQ9bbsJLqnuVmyyUpIrL+4nKCtSjwSmTFjsqQa9ol9OYg+BYWqe6D/Ufwm/r1N0eLmigqX3Q/zfGOs9rACWxg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	v5lPDQXttDzDzweicHwlIF4VpxOwDZ3Go+beoxu3lCBlv7bfpA1lijn7V9JiKHcpCvBpd5Jshl5/8gXU3ctQYB62qfvAtGjqgn3rauzitxRBpYir7ZbAnYj+dZiGqLDYo5O9nvJZdztvg+reOMv8xoci//IBSopFheUS6MVwJwuXnOPC/qXfRQfOuoLJf0kwCD73xpb1IRr6C5l46KGSyhSdYABDijDyveH2cpDuxDb+nueKuGTGF9wc280IwpIHNmMoAquK3bC6+5kGkBYK5jJiXj9qRh9K7+k5Ij5uTSCIvTu9MtIu8ApCg/WZgWgkxZbY9I6llP5tEUu5FBs8rRnRr62qL3/HOXPMWfxKRZHxQN40YHE1lq3EyqdXmZMTieiewJxeRPyV1WDEvRCqKqWSl6aMkSyISx6YONnmZ8nInfRcDqFpY2c+bas2p9Sd
X-Exchange-RoutingPolicyChecked:
	TCAZbzZ7ZOG8rdHWjvAIQ5dl42BJ/nPmKjkESwuuarPTm2KhkKXshj22lNnpvzc450Wj1t6V1FWnELbMoCnsePakjBPgDfvfihAGugnHGMNNqwLnAmtdlUMtlY15CrmcX9wj+zN++PUeJbVKOoLEhArj1KBve4rkBn0nEVzCsZlTm10dj8STWe7y5C+7uPV3+/wwn+U4T9T7Mzr0j11lq8c9ZtpTxO6dh92pZwttax8eTsLNCclqCk8egmaYMozgbFOsxwtUXsixN0CY55pUzdtahyK+KGCMEzQkm4uIQx6XdeGdTbzF443LP1fjcvcjaaOFS38b9Sc6AKbH7YNLDA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:34.4325
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa73b7e-5e93-4289-002d-08df130fc418
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR10MB987455
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX0ptMvj8pdi2h
 X20zDAkwewczSukfbb56xi+YWB9OgxoRrsOFMy5GKHV3PjnuieYL5d0wmAmwYTXGH1ca3CAL8vk
 BNB0gy6hWDWUhS+4Sa+ssZx2/W7M5z8=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91692 cx=c_pps
 a=8P36fUQdMjs6HQlwNDQNwg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=BTFW9V_9Xv1Ih9i2t_oA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ynOMSo9XE4OEmxyNGckrl2AbBvdISBod
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX9oy6uR/Ab72R
 9LzCLKAjU5xjmyHj1IsXX5hfmePEfdybQkSYkH5JpavnrA7wrMEKYCHIqABJ53hWwfXlkVWoSmn
 WGz883/Rr18j3ZvUboCWWy35Qg38UfjVq5aZVNKtNdA5ZSspebIElDLIKG5OWG4NnTwiQWEI8pa
 sWptCyupF8N1EuAgwXmRF0FvHcJdUlu8u+OggX27a6vaJIhPDW3Yez/s4mwAHCsCco0Qgg4YfJ9
 tLYfyBkvAtZXBBo2RyHypOswN8et7dONsI9yAQlqJo49Ltrvsdl2yhSf+nyyvlPZTsBCDyBitVA
 KduzbSnjAjT3y87jldProfYelp/C2CSQyrNvyXGV6lAfJSiOrQS8JqbB4wGeXSC0FuC1b6kbEtl
 tb28u7a34K6WMv094tV+zmuZ887FHxaeZ9UrkAIojLz3eiGpBQIx7ozO8YIt4vuyaBmA+iZTaIE
 yXF4JDbnK1Gb7L4ntbQ==
X-Proofpoint-GUID: ynOMSo9XE4OEmxyNGckrl2AbBvdISBod
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The SA3UL_CM hardware variant (rev 3.1) requires an extra AES key
schedule round (round 15) for AES-256 decryption, and needs a
one-time TRNG-seeded AES-ECB priming operation after every power-up
before its side-channel countermeasures are considered active.

Add aes_cm detection in sa_ul_probe() based on the SA revision
register, compute the extra round-15 key material into a local
array (crypto_aes_ctx.key_enc[] only holds 60 words for rounds 0-14,
so round 15 cannot be written into it directly), and add
sa_aes_cm_trng_prime() which runs a throwaway ecb(aes) encrypt with a
random key and random plaintext through the driver's own registered
transform to satisfy the priming requirement.

Assisted-by: Sisyphus:claude-sonnet-5
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/sa2ul.h |   2 +
 2 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9c4748110eef..ccc402bade2d 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
+#include <linux/random.h>
 
 #include <crypto/aes.h>
 #include <crypto/authenc.h>
@@ -500,11 +501,22 @@ static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	return ret;
 }
 
+/* SubWord using kernel AES S-box */
+static inline u32 sa_aes_subword(u32 w)
+{
+	return (u32)crypto_aes_sbox[w & 0xff] |
+	       ((u32)crypto_aes_sbox[(w >> 8) & 0xff] << 8) |
+	       ((u32)crypto_aes_sbox[(w >> 16) & 0xff] << 16) |
+	       ((u32)crypto_aes_sbox[(w >> 24) & 0xff] << 24);
+}
+
 /* Derive the inverse key used in AES-CBC decryption operation */
-static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
+static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz,
+				 bool aes_cm)
 {
 	struct crypto_aes_ctx ctx __cleanup(aes_zeroize_ctx);
 	int key_pos;
+	u32 round15[4];
 
 	if (aes_expandkey(&ctx, key, key_sz)) {
 		dev_err(sa_k3_dev, "%s: bad key len(%d)\n", __func__, key_sz);
@@ -517,6 +529,23 @@ static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 		ctx.key_enc[53] = ctx.key_enc[52] ^ ctx.key_enc[47];
 	}
 
+	/*
+	 * SA3UL CM hardware variant needs an extra round 15 for AES-256.
+	 * ctx.key_enc[] only holds 60 words (rounds 0-14), so round 15 is
+	 * computed into a local array instead of writing past its end.
+	 */
+	if (key_sz == AES_KEYSIZE_256 && aes_cm) {
+		round15[0] = sa_aes_subword(ctx.key_enc[59]) ^ ctx.key_enc[52];
+		round15[1] = round15[0] ^ ctx.key_enc[53];
+		round15[2] = round15[1] ^ ctx.key_enc[54];
+		round15[3] = round15[2] ^ ctx.key_enc[55];
+
+		/* Decrypt key = round14 || round15 */
+		memcpy(inv_key, &ctx.key_enc[56], 16);
+		memcpy(inv_key + 16, round15, 16);
+		return 0;
+	}
+
 	/* Based crypto_aes_expand_key logic */
 	switch (key_sz) {
 	case AES_KEYSIZE_128:
@@ -556,7 +585,10 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 
 	/* For AES-CBC decryption get the inverse key */
 	if (ad->inv_key && !enc) {
-		if (sa_aes_inv_key(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz))
+		struct sa_crypto_data *dev_data = dev_get_drvdata(sa_k3_dev);
+		bool aes_cm = dev_data ? dev_data->aes_cm : false;
+
+		if (sa_aes_inv_key(&sc_buf[SC_ENC_KEY_OFFSET], key, key_sz, aes_cm))
 			return -EINVAL;
 	/* For all other cases: key is used */
 	} else {
@@ -2459,6 +2491,63 @@ static const struct of_device_id of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_match);
 
+/*
+ * SA3UL_CM (aes_cm) requires a one-time TRNG-seeded AES-ECB priming
+ * operation after every power-up/reset before its side-channel
+ * countermeasures are considered active. This reuses the driver's own
+ * registered ecb(aes) transform with a throwaway random key/plaintext.
+ */
+static int sa_aes_cm_trng_prime(struct sa_crypto_data *dev_data)
+{
+	struct crypto_skcipher *tfm;
+	struct skcipher_request *req;
+	struct crypto_wait wait;
+	u8 key[AES_KEYSIZE_128];
+	u8 *pt;
+	struct scatterlist sg;
+	int ret;
+
+	pt = kmalloc(AES_BLOCK_SIZE, GFP_KERNEL);
+	if (!pt)
+		return -ENOMEM;
+
+	get_random_bytes(key, sizeof(key));
+	get_random_bytes(pt, AES_BLOCK_SIZE);
+
+	tfm = crypto_alloc_skcipher("ecb-aes-sa2ul", 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out_zero;
+	}
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto free_tfm;
+	}
+
+	ret = crypto_skcipher_setkey(tfm, key, sizeof(key));
+	if (ret)
+		goto free_req;
+
+	sg_init_one(&sg, pt, AES_BLOCK_SIZE);
+	crypto_init_wait(&wait);
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
+				      crypto_req_done, &wait);
+	skcipher_request_set_crypt(req, &sg, &sg, AES_BLOCK_SIZE, NULL);
+
+	ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+
+free_req:
+	skcipher_request_free(req);
+free_tfm:
+	crypto_free_skcipher(tfm);
+out_zero:
+	memzero_explicit(key, sizeof(key));
+	kfree(pt);
+	return ret;
+}
+
 static int sa_ul_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -2499,6 +2588,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	major = FIELD_GET(SA_REVISION_MAJOR_MASK, rev);
 	minor = FIELD_GET(SA_REVISION_MINOR_MASK, rev);
 	dev_info(dev, "SAxUL_VERSION: %u.%u\n", major, minor);
+	dev_data->aes_cm = (major == 3 && minor == 1);
 
 	ret = sa_init_mem(dev_data);
 	if (ret)
@@ -2530,6 +2620,12 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	sa_register_algos(dev_data);
 
+	if (dev_data->aes_cm) {
+		ret = sa_aes_cm_trng_prime(dev_data);
+		if (ret)
+			dev_warn(dev, "aes_cm TRNG priming failed: %d\n", ret);
+	}
+
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret)
 		goto unregister_algos;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index c5e73ed14f44..045fedda90c9 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -184,6 +184,8 @@ struct sa_crypto_data {
 	struct dma_chan		*dma_rx2;
 	struct dma_chan		*dma_tx;
 	struct crypto_engine	*engine;
+	/* true if HW is SA3UL_CM (SA_REVISION major=3 minor=1) */
+	bool aes_cm;
 };
 
 /**

-- 
2.43.0

