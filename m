Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1FF47ECFE;
	Tue, 15 Sep 2026 09:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466161; cv=fail; b=FbFhFKy7Gi/tZCdwOC82LcDu7hB9xddA36j+m3eb6cY4nxdSHXwtvl1VmjFm/wAgrErU40GuHORoQ/GfneLrhkXVImkSjWnfOKoPZ0fHiEM72u8nOLZANnw2yThjam03F9cy7PBtPy3qxlKXKD4D+N/KH5GjWLcP1UGneVuE9EU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466161; c=relaxed/simple;
	bh=KnkPKMAyjq2bR6cmRQloZFb0uvKnPoxSF4KsztwSNLY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=HBPnKHwCedUxEchlob/mtnXJau65rVquLH78wV8/X7wBSCeDp3fhqW1I0+5dRfUw3jsp1Xz87ycldRGJ2g6iH70ayr5ApHpeo3b4dME5Mel3bUBPdNiph6d7XkH2CCxl/BSS3Ax37cQa6SYa8B4NhWILvSbHwJIJ/oExMxT1WsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=UmGaARqc; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KD6JYSXv; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="UmGaARqc";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KD6JYSXv"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9etXH3889353;
	Tue, 15 Sep 2026 04:55:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=fb8wyf/18tssSNzOAPMIsBnpi/X7UN2LaPte23nvB
	14=; b=UmGaARqcb55ex7e2KM0j62vjMT+iXx4WQojAZSNeF7PR5BKcd+AnQ3g15
	0lv+EvKOMjOt/ULEE/py14c1GpdeHnb9JeBtb/WscFfzlefGepg+0PQs9qhOPLXX
	kbC6td0Qq8k6cOHpCoPs+qftC4Jk3qVRrZL4SP2lcVj1xnSfdPXixLaCW4GTT0m/
	fU1y58HiFunZkCoGlXRXu7bCYPUVahwqt8uUo/YEvnSy9oHcu2bxC+C2OKWLoyjv
	5vLjilN/iIbkxdwBbo8TQWs5WJNBv/BPL9eIIu3bStY9jiVmXhRNvyzYkNx4kPv/
	lEe9kK9tbFM9KdhxBTMeuQkwwt3oQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gppxsm9eg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:55:53 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/KHC83DiXu3vzrQhNP7QifzstWsJ/cDpfmn/y87rKpBFpk5j6OjG81XpJXoNd+aS+Tq9XpgqKX/0dLgMNbIvqnciONTrVahV3B0BXfmyAYP3AzVB9/ZOPhVP/Vqkx574lmHWAhWDdn9+0sQd6ZYXT4AiWZQWmzzv9c5ZGPiyEdu8L/i0hA+ysCElGbJZSEsN0kGkQ/tuDvitmS2j1Mmof7qW34DEXQtDHIuPrQCDnLrJYNm0koWg53t3HBmBSh/giyNUk6ud9o8/EMLnlSBuD9FwItufWKbXfbMXBYHOwMZXKWky9s8VtvAAEvy9voU/Pns0aUvt3U1NjElKwYPeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb8wyf/18tssSNzOAPMIsBnpi/X7UN2LaPte23nvB14=;
 b=MC0ERPNJwjwKEDdda2pwmUk8d1Lcj61ZKtkxqm06ct9AlCgx+eRphpY+7/6ppbX+ineJZ5UZm3cWG+3je0HssKWtR0m0ku9dcXqFcsivHh2wCMJCiRltWmMfdPhd4iQdTIgHFjwSGdcPefIh33PmC1eSXugSxwoqyEB7UQASViuJ+qH1UHk5cxOTVDfDrC+/Dlbby5TnRvevztM0AWa1hF/Sg/Q5V/J8GiFo/Q6NGCeLCN7kjZz9ZZWMZiec7rHU/ifDBSPFCwKNTA9mHMVUvtBCk7zItREOOZ8rsgdcLCZo9/9AQuhRR8w88TK58Y2aAJ7GhBBI6qAXFvGeoF+7vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb8wyf/18tssSNzOAPMIsBnpi/X7UN2LaPte23nvB14=;
 b=KD6JYSXvKqckol610oNrYj+hf19HmGPapPkaVOyHeIDU0mOo3j0FjkAeojl0RX3Q/ZW0/O0KKwQGfj/hqzOp4JwlRkH3Xu2h9N+7ZC6zwf8YkyyjklrkThfL4JIL4wIPCmFkdQPrcdnqO9L9zK2wbrXj/4n+cgYxFfUhufB90Js=
Received: from BN9PR03CA0553.namprd03.prod.outlook.com (2603:10b6:408:138::18)
 by CY8PR10MB6514.namprd10.prod.outlook.com (2603:10b6:930:5e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:55:50 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::10) by BN9PR03CA0553.outlook.office365.com
 (2603:10b6:408:138::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.10 via Frontend Transport; Tue,
 15 Sep 2026 09:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:55:50 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:35 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:35 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:35 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7u3000901;
	Tue, 15 Sep 2026 04:55:32 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:12 +0530
Subject: [PATCH 06/30] crypto: sa2ul - remove unused macro definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-6-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1126;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=KnkPKMAyjq2bR6cmRQloZFb0uvKnPoxSF4KsztwSNLY=;
 b=smY/zG90CLDwf/97BUaipVhviBYNOXUnl0fccTfcHrcf7WSVtieGVurZZv18r/pEAyKyA6zoP
 fd9Evph7PRjBh/k35JVR4P13MzbFtEz34N3+69J7ukMMOTziUDxw6lO
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|CY8PR10MB6514:EE_
X-MS-Office365-Filtering-Correlation-Id: 2804e1cb-ee42-40b3-00b8-08df130f8604
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|1800799024|10067099003|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eap6sgLJAEoUPWtG0zsWQxSMajgMTJFH8heALCTWTIJKfOtB/ePnCZ9/ryFvRdzBz0YWZmlgGW58Cft8cuI9GnOkF75nEDswq2NOkvNsCjrqh2HiLE0dQSTFeKKfeqbUD4YwAsdFTcdslfUV5xVQ3vWQy/DgBlhyVhOE+RueIpVG14gBq0D37Rk60UAXl4X3V8svCpSVpbMvb/LbvqxJNqonQkBFam2yVoCaF4fJYr8bklB1lMgrW2skuEhkdjRrhF3YEV5lSPog3pE5wVnc0d7/9wJ3eQhvvMP5hZYRQG+DH9bWvZLnz2updoNbzSOo8c+OSLjx5dRx4Fi08ed29zn+6iNMT+kN0b3A4c/UG4Ed2v4jBNZcgdGLfqFIgOF46GjQpTuzJwxKrGwA0pn9RNRudqT68k6V1aS8lRbvJ47K8v7mC+45MUyyBUqquL0Fc/IGRllN0gefF3OkFKYHiJg8sTuyNujIKJY+an+QfoDas5bGqU8hwCSqL7JRNyJtxYHtgm951G8FK64APXAdFxbIXDmyBV7p6636ei18yx+axAqUuoEkxhbRlMeEIwXOhWXn1xAKe2uzFDDk4m8LqM7UEDyaIwP0lHVm/OGddPjErleTHsId3cQzdiJJApZs7otL73EkAz1xAlQkev+Vd+eazYhcNclRvDYxqZ+sA1oeeT3+MRzuWImsiSlUtujG37I9SMsepmoEXbVIMCnBwA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(1800799024)(10067099003)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nv42sE8AXOp4DLX2AluPZ1ockgDRsKrx4RW0LFs4BjL4s/rLhsr9a3cnTjUQmAgjxr2b87JKdD4nRBNl9BANf/Hab95zZEbCPvxzg4tti4lGw8DvsuW+KxkCcRpp7zsZXOMzFgpCW5zT+COPELa/WQTAkW7we789W03EFvE8DDdTPvFVcP+2c6USJYsxSJv/ODKr7kk/krG7JbPFFaZ2dv5Xz0XRVjvSnoEna+6erqbDXEmouddVxtIYhzqscegor6OhgP3SQjZoQwtLBvPsjg3CZiTq7s6ixbs54Jh6WWhZ4Sh+TBCRvdcCXQ9L+hgtq9Qk4RgwJHHm2PFXUH1xgcSMls73Mb3dFYC5vi6n4hkCiVZ0SECFooYLPJjY94ZQpc82EMoZLnNBuNP0UiRCTTIcjNKcj1JDSL7J4xC6mNdb+Vwcz9GPJhZPLvfT4uRd
X-Exchange-RoutingPolicyChecked:
	IP7DebumZSQndGOJcRiOTvlNcDf7Ujy5aUIzhLdZYrdvHGYE54C5gtgQd6djejovlzkcrZACWnF9dNfx17I62JYiqy1OjfKvlWQOMCeHvvMG/2i0cUBkEACZDdELxpJdGlCzqx7ptakm+/LCevgrlT7ueW3UDG2aI9oZgMWtZLmg0N0QdMfWThe1KBWm9c7xyn4dj0vVBn93nBSK+vzNvDiZ6FrYc2+Bwaa5YvxBca9/89lGWECchenWk5lxnOStNyKV94AjDzXKcBbBY2UVmmGyifGHOkiCDoe0jwWYvi3x4iWteuX9A2bqbOK3mNqvHFx0phb6oPUQI4wKWjDtAg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:55:50.2528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2804e1cb-ee42-40b3-00b8-08df130f8604
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6514
X-Proofpoint-GUID: isKS_Y4xexiDCYbrv6--bqO4Ys_-DRPd
X-Proofpoint-ORIG-GUID: isKS_Y4xexiDCYbrv6--bqO4Ys_-DRPd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX5+rvJhJ5dWsT
 9ZEMzhhiA9vXUxorJRlsbc9GMiEMo/KA7IzG8CTyMeu6ejvk0AwfBwbOo+eACHTcAGjFt/6PYqN
 LLYouc6178suAVhT4sj9l/FO79/mDHwh6uEmY8dpqi4nGBpTz4yWxqGi3EnK0ACU7pHzCuoO/yW
 VOpGtLOkfCYJxHzjxJ4cv+cw1I0mNYSvOb+/5QNdMkka1HCbrqQg24ytmxc+TTnayxbQhS8Mn+r
 nBHgL1Kwl94Ljv05QlIKW0cox5IXd85HW0gbe8IkaszU2WjyNJOohN+hUjdJOMQvwZf/DJBvh52
 nTMIcbheesZEY85+wAl1QB1QrsBjLR80YvztG7xJ0pSC+SoaG/6OfNzZljsAiEGpEDJ6EiPvfxI
 RZ16w+nr7qyKyHhufFr3ti6NmQXp7sTUmBhUnzixpYmthhx5ow5vL37TCeBimjD6XoVSXJbwb53
 EZW+FKOo7RLHVOySJvQ==
X-Authority-Analysis: v=2.4 cv=bYP+w+PB c=1 sm=1 tr=0 ts=6aa91629 cx=c_pps
 a=j7tsCyGgeYHcZD8MHzM6Gw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=nOuOkeuyneYG-oPHXcEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+poloP+c2fC9
 9TA+ZJKg/RofkstQQ1HyHubxnUeBllyUeRTkN0RstlUGkyNYQ+YrQF7MLZjOd8sjO1O3m7r93Wr
 hcooaM2XVIE9ax1T7Zao80uAklbEvs8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Remove unused macro definitions for auth functions (SA_MK_U32_AUTH,
SA_AUTHSW_VALID, SA_AUTHSW_*, SA_AUTH_OP_*) and related constants.
These macros were defined but never used.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 drivers/crypto/sa2ul.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index b36437d76891..09cefd766c95 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -42,7 +42,6 @@
 #define SA_CMDL_UPD_AUTH        0x0002
 #define SA_CMDL_UPD_ENC_IV      0x0004
 
-#define SA_AUTH_SUBKEY_LEN	16
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
 #define SA_CMDL_SOP_BYPASS_LEN_MASK	0xFF000000
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index f29e0b9ac82f..0aa6a36c0f20 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -46,7 +46,6 @@ struct sa_tfm_ctx;
 
 /* Number of 32 bit words in PS data  */
 #define SA_DMA_NUM_PS_WORDS     16
-#define NKEY_SZ			3
 #define MCI_SZ			27
 
 /*

-- 
2.43.0

