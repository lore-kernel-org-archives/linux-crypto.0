Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75C7483BC8;
	Tue, 15 Sep 2026 09:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466191; cv=fail; b=uOR5HIlb/ImuvrXrxAwxtb4u4dajuczSOgituUmaA6Ol8Z4PcmaNAPFMq/KP+N3nU4xQcuST34MS8INVQVF037wpgfK9OaNEmcNaM4UOxFvLPmYn/lIkaIgF9GkIlh3I0qEvbqLGhnCcEVWKJwmGEaVLhPiBD6gFn4r+9kWEqdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466191; c=relaxed/simple;
	bh=U0FOGrMlGFAZT4TKiZLTMpmME/UnVJHZYZaCVn/3oyo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ZsROC1v3UmwziJB1S+2AkvyucavawsQBNMwT/twAAc2WFte7xomOTQEJKMrDnVn3eAtHA495O0Wam7RK75ICmJg2iVuXvYtETROtQv7cUmGD+HF+Ty9J33wM66AE8z9g1tdYTn9TDimsg819B05zNF7QF/hXLPCHypsSS9iEDrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=cU5gooiv; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OF0wyuyv; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="cU5gooiv";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OF0wyuyv"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fQTX4098406;
	Tue, 15 Sep 2026 04:56:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=8m2H1rJlypLZ8RTLhY4pDM7SPUOIp+qt43ev4/tz0
	kE=; b=cU5gooivf+kUicB87oBFccZ20zM4B2KBFqmh9lDxFxwCRpzOTnc7shG1D
	qU+STH9Fd0LuFm++smihOwsz6314mGF2t8X19A/SW7gy+0UvETRrFrUY1Z49NmgY
	2RsHR12OJQYCXs1mo45wb65tTNRkAT1pN6cn/QxZDklHX/cATbrYcNihHjQP7Giq
	WaXAYgMrUfyy9z/BOc0qv3Tjrep6jAHH3Xi54rrU4KA0IceFRWK1vrYjR/M+SLwI
	KRrW77Hb8UtAiWemh0vj5Ex55uBeb/LyHBDYZVcfMrCeRWUyRrv81WdNlLMSzgEF
	C3wCI0I54mcZfHp7CsguGTLY2ZaCw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012063.outbound.protection.outlook.com [52.101.48.63])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakgy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:24 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PnkNHnyiehx16hfijnB4jphcMNnhoddGKmV8C4qGeSMULNZiaklg1+0T5GO+2UTd/LmOSmNuC2sS7CjUhgLtSjkDk/UG5FRYSjnawPtfP/GiAx+3m3hNeHgs9MfLx+8+hRuUPprP4NNU7qix/OZ/AOoq1NNxD+0D6lncC0zyNpaYYoGRB7qj5dadLgBPqXyPFOLt7ME4UqDy9iMfVY5HMRBFka4psmroNoFerTn4PnpFl0V0cNMcevdixjYFgOUKb5A0uDB+6jpsSoieeeho954JST9OYuPCBxa3+k8MUDVj5PjAhpeTZqU0rs0EQcbAXvWUkqA1kKF6HdjRXlogpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8m2H1rJlypLZ8RTLhY4pDM7SPUOIp+qt43ev4/tz0kE=;
 b=I4wmDDV6K3QlZDTvvOnBMeWyUYJE+OkKrzm8xLU/ufkZEYs/cVVKVGISpQepw2CRXGtgnogFqYnO5UPSCUnmu8vwtJNhZfzNRNrmKO22iyq09WG+2IuYspoqkucq7xs2f/5aGFF9+OT/Yp3K8sZcm1qCdh/MSjolxbCpqgqF5wqSJVIn8fTHiqGf/BZM64xVFA5PHOyI9MFcB/2tR/U0zMLeHzT9/pMFOQ/SoNWhMMpJb958DTfXf6/LgLwpBY5bgp3IjE5deWe+R5Z7V0vGIwF6UgoY2S5G+vP2X4yAxNzsD2TSDH5KgoUkhxHzPLANCMZRjyXCxzQuudDNs3VsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m2H1rJlypLZ8RTLhY4pDM7SPUOIp+qt43ev4/tz0kE=;
 b=OF0wyuyvpuRJzQDOG6/1m1RJD0/DKEQCJK0ygoiDr1RUKvQDdlDmfCm+NKw3cDzWEfHAKyclgVS9OS77hqutpVtELLIZIm0rSdJDqwfK3EjhKg+JS1tN1upn2SbBzZqO0u6Hj8OcEWh4zRisWxsdL2cRiSM4EtuzSOYjagTOevM=
Received: from CH5PR04CA0002.namprd04.prod.outlook.com (2603:10b6:610:1f4::20)
 by DS7PR10MB5973.namprd10.prod.outlook.com (2603:10b6:8:9f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:20 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:610:1f4:cafe::9c) by CH5PR04CA0002.outlook.office365.com
 (2603:10b6:610:1f4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:56:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:20 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:04 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:04 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:04 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB853000901;
	Tue, 15 Sep 2026 04:56:01 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:21 +0530
Subject: [PATCH 15/30] crypto: sa2ul - fix context release on errors
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-15-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1469;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=U0FOGrMlGFAZT4TKiZLTMpmME/UnVJHZYZaCVn/3oyo=;
 b=TLEqfn+/wS+5B0Rx/YKpuk2SgHQzNZoUSqdssNvWkL3GfSfgCRQQ9npSZTg0L0Wx2UCdNRoTo
 kC5905vN289BvxbYLtLxxIBEKaU8ekO3ZQI/v7GnB4RT1IbDU1cQ/Ei
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|DS7PR10MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: 68446338-cd71-4860-8502-08df130f9807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZhQKHCzEdpqP6yIzDp2hUWcJYd8QputBvDWpeOEX6eMv1UtbaSP5D1JlDALVspvUA9n/aMP5dDAtZeGaX/EeXulUaS6h0CRWKqpn60GaL9UfIu35FMRpfvgUxErybCmg6+ux2KA9DuT8LqdLUUvTYDUaRrGTK0BtYc76KtrsSG4bcTqj2Pt/JeLNCeNKeDr831Z3O6V22zD2RDgVY1/+2HxiDOblEHVvRgqpGfO437T8K8y9yYYgCFl1f/CDtz4c78tN8R/ZcQiuyi+NEVfLWuw/CnTYNGxqsQuwhJuy9oBXoUDrrvFWAWgSUDY65xKpUS2Xz9xDHAs+r//jyAX6A5zmYOsu+Ripyw1CgNH78juxsKntWmUTXxuB9FHYkV0iAnGkUo61DwEtZlTYOOPrq0DGBTIRV3/WnxqWMEMO0Zza3TtdOk+fqjWfqpZ1lSLVTlo+JSjFGbHBqaci/YWaNKflArvok6xnuqPsKHX/HCEpFgzT6xICjlBmZgzawEqKIadUf2W08EGOqfm+TwpLDAOSkrd1NTZTrtC0XR/YrdwjqEo8l+SuW7IFa5pkhqjjHdAVUmz5zHL3gf5wSFtKRuPO0C/bQNN60R4RsAhFI6qSWAxxPv6Qia9NIXjO/871AmoGe4ECntKZMpYGKyWzwGxDJ/OPHnutcgiFVYPk8TehNGSaq1KwV+FptISR+0ldjk+E8urs78Isx3D9lc/Ywg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZKd8emZKhXX3TrxPBaQsijJM+tdpO/HfSCMNORzXKtjrY83Agh0LeWGrnjcKT9gS0RIavgrnMihO97KUlhSnTAIXPSVGhoxgctI4v6SU1h+UPzfI79LA3a6HI1k1uRRq9sCXiElNMA1QjOf4HK6jpdEr07Xc/aBq/PCMKj4Z/a23pElt+x2LvK89g0kCEWmE0G7ghc1o9VsQLX3LaEBGUx+U0kIwbqMzdTtGKn5eCdHMTErn2R06612r/2bY1dc7epb+o2ge0pvJMh99pGf6q71bpaunYQk4Rm9b/0ujzxigXt9Cy2d8j/0w3MAxjXMOzmQcdBGu8vKUh7qaBAdDBtbCmYe/yciC1eoidRxF/YRC+KGtFDsnNjJgZoNN0I/Xr9gOiP0EWl+3XYJ6RvbGdmObfcop2b31Ox6pmNvaEdn8mvcsdoyNV1Jm4OdlKCCU
X-Exchange-RoutingPolicyChecked:
	Q6FWOqPTIERGxiM+QDndz9ER2lHA9jrZ5PQewZQmS46mQ4fQh3wi+iufAWx3nLjARUSd9WhbigvqSjWF9eOpY2p+iHmFGqY1+f4WaYKxbJRCyfJ8k+7KVIoGnsC/19w1DdJQIF01v0jBdEjD+rXFUOts/UWcJqztGOfUGa9EPjXjQ04MyUOWH5HGmwe7bp1GksMIqcZ1bT2bpeAPD6+UrT3/f1gEIj2mUlX+j5KpQwwaFqRMoywxiVKCYGCmANmFRhTYpZqMAc/Spu9R0TapLjTiV3obQlz+aB2nzFm1QcO5e570znK/WgfKCqapVlwG6Z+1L3KYCzilD/gyQSggew==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:20.4603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68446338-cd71-4860-8502-08df130f9807
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5973
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX5m+gVRfrPBmH
 Gy4gIIbx+dMa8xQu2k7houDIQ38KVPX/AhGJS6FEsQ4CF69zFlCL2PvfuTuN5eVtEuZDfN8lYZd
 H80jrQVD8qgA4PQoc6Q54ZkWLlfyLa4=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91648 cx=c_pps
 a=m+Y8nsmXU8Fd5URmI4pqsQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=rbbrXJFpQEzXrE5zXqEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Cf6j-NEJMsl8d0PEw24sgVT1hYwz39z7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX5xEdhJxsQrr1
 oKSd23OO211M5isFmLYmWFG8jx1mV4wef/HFISSgvUdMkKcCnuC8Y2ktxoOtBTwB2zcWWgBpvlR
 aeeV/R4CRo9l9xOR3NrYxz2hnZl2Q8qD7+lZErHbC9SeLtz992j90n/svySWgTES+pxmMOZjMsZ
 saTTv1P5EF+BzQxVnIV41eFV8cKn0ohV5qtoI3rPSdgjwF3Yb0xS03wQfETJ0iwMnz6/GGfW4ud
 QaEnLfiD/NqoMpXOXG4K+VTx5Fr98HOSZSLA3HOJIc8GYW9aCIY7y6KiKF5y7rl1uKd9/DWMHNA
 jSvdvd5uJ/YMAFCmXq3eoWJTt3dBy4WGo7iIPuENh/pZIjqkGqz8DFSftnRp7Vz4Swdih6ZPnl0
 MZXbgunb2edBeNcTfcQaqDp7pghunIntUqtcRoUuHulyek3RQX6fdpPTIAiLxliIgWW4aC1jKYR
 kwWguoBQowa+LFq5KvQ==
X-Proofpoint-GUID: Cf6j-NEJMsl8d0PEw24sgVT1hYwz39z7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Fix security context cleanup in error paths to prevent memory
leaks when crypto operations fail.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 7ec048136114..cd80a2dabc99 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -826,16 +826,14 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	if (ret)
 		return ret;
 	ret = sa_init_ctx_info(&ctx->dec, data);
-	if (ret) {
-		sa_free_ctx_info(&ctx->enc, data);
-		return ret;
-	}
+	if (ret)
+		goto ctx_dec_err;
 
 	child = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
-
 	if (IS_ERR(child)) {
 		dev_err(sa_k3_dev, "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(child);
+		ret = PTR_ERR(child);
+		goto alloc_err;
 	}
 
 	ctx->fallback.skcipher = child;
@@ -846,6 +844,11 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 	return 0;
+alloc_err:
+	sa_free_ctx_info(&ctx->dec, data);
+ctx_dec_err:
+	sa_free_ctx_info(&ctx->enc, data);
+	return ret;
 }
 
 static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,

-- 
2.43.0

