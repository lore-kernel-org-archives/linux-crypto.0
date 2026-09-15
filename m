Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563AE48097D;
	Tue, 15 Sep 2026 09:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466225; cv=fail; b=hYQ0+2eQNf8iZ1Du4darGB6WuRlY0esYuYZkZ+ZMgOreOlqhY74aIpt1q06i+wqa8FVWkW9UqHjijZ4NpmT8FVRGG/PtIQL2PLDIh0GstA29Bzj8bLeaucPMnc3PzzoCkKdpxhNAk5Yb5O5ezy8voCGhAjYZBmxlkVIV4Xt2uyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466225; c=relaxed/simple;
	bh=gJRHm+l+PovcyNHXjfMAO7cE0Xy3l7kOdG6zKHpQwcU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=H7wGCgCFpxRi0sX2lCHZ7P/80oNEDOCz3Ia9dwDBeFfmt50wK/2j2kLg6ib2KtouDE8alkXk2V8oESH8VmBt2qfHx6J3Hh45AleiqbT0JWtVvtj+qNXCPeQ9iyeM1GSug0zP/TIBd9cQpHT+eYyxo+BXL+vKdnoEhLnP4Gd36Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Y6b+3eDE; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KyWTHpTD; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Y6b+3eDE";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KyWTHpTD"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9ejRb1480545;
	Tue, 15 Sep 2026 04:56:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ywuciZr0VaixwqTyLbk4oAHUaPLNNq0WqLMLxZVut
	Mc=; b=Y6b+3eDEVoBCcOVE00nfM7UdyDdsjJyy+HvfZYykn2EDpkUFwT03lJnX5
	H0gWr5DwRLD1SkELZSNS24Y7OPWSIpmOzSO+jhoFcYW5fVil3U5u+Rj8QfNbfHNU
	2roe/UBlBwIXzV5JfAeZ5MnzVyQoGwX1HF9IHp9ne6M3IfFudmb2nk35N3Awe3dQ
	l+eyc5wGmD6Ic3/g1zZ2t/1uAQCglVCqTHenNRVfFOOHfPSJ0ulM9BH7Jx06HE0C
	Qrzg5zsEZDfeE29302qpthBgb4Q5Euq3X9E90j120Qx5uDIyBwYCMZFYMWjE3T6Z
	boeXhn17l+sGsQs0xxs4ADGpr+GnA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j3h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:54 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEjyGv+t9bfxbaoRqYoL3ZI+SnNbYH7TgwcUHE4OacRMpBKShX4aPc95AMls0j3uDUQ3yAdv1BFaCpzqFFUcq+1DCmo5qx5IU40RqnIzRIPmEDNquSUfgrQFKW8PiRUw3nMRV783WTwdO+MnA+DpnB2A3kwVkGjRhCZS+O31nS3TO1uW3+NEZJyLagRVPh4NuGkYP9HrJBQjlzzb4fa285uF8l+ZXVy4Mlxu4z5rGST5QrM4m6KAxdESCA2UOXzs48giYqU5wO6R3YTCqXNaPyzPiXpO6TzGfKf5PxrHO0xWsgmowiZJIIU+2V/edcv8/g9a1ryJ0jIFsI7zMKq5LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywuciZr0VaixwqTyLbk4oAHUaPLNNq0WqLMLxZVutMc=;
 b=ZSidKoIE8RxTLXBRgrAUuLpgvdqJc/MM/zPOkbTNeJaZpsqqL/FlzIQLAk5bOED3CajFfPnzvRmla6Kdmg50MWZB6h/FsqCXdoHfEaaRZX2kW+5czUoTjA5hQhNEl6x88UKzvkEFj7AE1iklcFk1wclzR4+qYoHmf1Bf65N1UZj0jsLx700DGeV8TBiLL+KUlncii621TJxrKrMkwY4NgKjWakX5Ze+ceJvB4qnWeheXttPcFL1xPQzXFy85MR0jQn/zllhtY1qRhBIoFAKJJ+k+2WjdOzRF2YyUKHC1enLQxiFaBvF99gdj1DNwxTU3UvkHO835jXSBeF9cfDTN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywuciZr0VaixwqTyLbk4oAHUaPLNNq0WqLMLxZVutMc=;
 b=KyWTHpTDQ1oV5gnDYOfJStWU8h5Y/H0M2Xb3cKJDhD8bOFlCwDWs5dDCUyjS4hT3M4/ld7z3J3D4KkdU7QAuHAwRrHnQogT20QhWNUkBXDUxlGbhkINbJkUpmKVu233XatY53eXh0a6YEGxoY+yUX5wD1TeGOZjgL5MOYYD/2MI=
Received: from BN9PR03CA0786.namprd03.prod.outlook.com (2603:10b6:408:13f::11)
 by BN0PR10MB5014.namprd10.prod.outlook.com (2603:10b6:408:115::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:51 +0000
Received: from LV8PEPF00000067.namprd03.prod.outlook.com
 (2603:10b6:408:13f:cafe::af) by BN9PR03CA0786.outlook.office365.com
 (2603:10b6:408:13f::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000067.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:51 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:43 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:43 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:43 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8H3000901;
	Tue, 15 Sep 2026 04:56:40 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:33 +0530
Subject: [PATCH 27/30] crypto: sa2ul - change dma_alloc_pool to mempool
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-27-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=4723;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=gJRHm+l+PovcyNHXjfMAO7cE0Xy3l7kOdG6zKHpQwcU=;
 b=c8sU5p73w/vQO3ZhEJLroa3wW96sssyFMGR2P55Ru234Pc2i+fQT7gJypkarWcXcA8rZooJFC
 8rn+BYJveDWBimM5gBBhBj4qdEZeXkpEWCmAzsyNb9KH8dTF/2B/l7m
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000067:EE_|BN0PR10MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 20388b43-c16d-4909-cb01-08df130faa56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	JyKjmc30MsW6V67j8Uf+nMreDjQ+WeAQ33jNlipSTpoKmJuNdKN5n5AO9aJuipIOHz+wfIwFW/CK6z8c76wAVx27V4LYOXaH2TSPgXVWmhQz5zvyb8XK4+bC7cQDoqKSfhb78wX9wFDqn/iUxjAGjYAhjFyhsYXam1/yyeHOB2q8bXKwzCQ8p7LWJwmW9Ql9HI6iwF41OXQ3GnAhBOy9lUPvzR1iz61e8GalBNrH+ov9UswQ4s7sJOcLlE2z+RPfBTmnhqYcXfAt+6Mdf3KcEhxbCyBOrv7FFRia78xKrGinipno07j4gUMJwTUT42gRGr/GFf/FWbG09pKj1UCG7eCJyMJp8e5FyEb54AVmgezC27jk1nlnVsrhkAcF/cjOobMyW9HG75qDRGTnrh5zCWkCYEN62k4/MjPaEavSxncMR/Da4aNKY2wE/T5bBRtCQVJPuNGG2Ry6k1Y0Jm9uZFw/lhwQ968IOpPX77Dqboe1ZSDMwit7a7gFMdBJbEsc9dt8R5kLUse0f+DX4MV9hEtnyduPhrHkM2S+ZicnvFeaF04vxdPvV3qsnSzBLx66Imlw2sm0lZOL0RA0b115ylWUTObt6iRg5q0S2YlSplVrUQfiDq1IxvyivB0s8sVM1XQ5YsZQb58NIbVigU5KNi52GAwR2FVo/eh0eGgqW85VXfLtH2LWMo89j5lG8Um32QrW0QEbdOyzP5k+oEZc8g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZkrnfW5hA98K5mBWjf4aZeh9bc+X/KM1zrlVjgKduY/j79HkPlpfPvQ8kFOew0OgMb/wKmMAPPIVzrwLv2CsBM/wDyiAQbCXwOd0g3ZdnLicamzmLXdKW9kHAMlHxzpvcPRaE7sXfzXlWSvHDQ8taMaUSmu6tgqEVrbMahA0749oS65yz316qdlVQ2l/mOSgM95+eE3snMndxUEGX/TsW2kqPrfF/HHDXOVaSQvbqfBxuFDNZHpnnwMWXJvQcC/ya9jQXoA1FsSXr7Ew7dTCFpD+R8a8s7h9w2HNR1S7GBBHntXfsZfeYE3xLlwDZwSyNZZCt9HxDvVXZWf6oju/Tqxgqzj/i5lE85FBrA83yYnRzg5sVTC8lUPjFqfQlKrLAdntjtvOxqUX268DHyey01IwsTf4FB7fhWY1nFeVhUCC/96PSWk1fCkCEbloZv1A
X-Exchange-RoutingPolicyChecked:
	AFJAvDHws4M+BZPdSZfdw4o7+iYKYAc4d+kuuLOF/7ZmBh2xNwPYoQN+fykxib1+VmyVBGqYMi2DCkj9z1S7adZ8nyRrGj5XPz1DvVCmTinUFq/Ch33fHrRjwHeXYC0VsNfou6zrT6iTNQWKwzr8QWULPBvkPY77qN1DJqoRXU2yZoU2hNpSCYsA6uCVkq9Ok44Ck6nHoen1LGC2ndoOlxj1C9zj6seYTdNJIeCNfLnhR67nMwFoizdVcbgmYxDLHERG7AGVa7HN5eAvWbzLQ3Jvu6Vr1aPhi9+emoZbAOzVGFfswd4buf0JSW+aaB1V3HDN75yvLf8ElYnvEALbaA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:51.1972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20388b43-c16d-4909-cb01-08df130faa56
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000067.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5014
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX34JeSbSMXkwn
 vANt1eT6PXZfi+kdprJ3usGyOThpKMUhjTtODUSipRSXLwDK/riGQSV6v6caVOxGxvsJRyn/9pq
 pL7RT5I1zzadryBWw9b+yK4roUzkRhbQek92dYtaxUZDtzma3yZfoJ62eeSkE5fbsI1K18T2rRt
 SpefEQ49WFE2j6QX1+hRID98JJ8xJp/Mn/0FatF1Vq3YK5Qx4dS1SZkjfvq5A9X1sIXvJM/WNQd
 P4iz29yXJ89vuZexB4nMDZc2MBMEit8LvgQmhPfLJlucu6ff/OiRKZ45EZKQNS6i/CWgaGpaRzk
 sPvlnuq1H5svPQcR44qUQDHkQGPdCc/K0eAr3sGy8o4o5C5iIgF07zcDO3zcR8G/OKlSQHzC6Rx
 NLizc6hiPHLTBkNHVxR5xfhZEkqwibL5hFWr6OL3xghT+iu0wCuLz+TNW6cWwp5zbBZTz9PsQPT
 L9NxFdQ0ZnD3gKPjcag==
X-Proofpoint-ORIG-GUID: _FnCsZZ21bLZCi2KSWtLQRETn3VqjEIa
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91666 cx=c_pps
 a=yZuzC5SkKTYVmguxKPWuow==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=cC7ItFaxPISbhmCCHF8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: _FnCsZZ21bLZCi2KSWtLQRETn3VqjEIa
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX3oot/aO089qf
 wXAJX5fzmDjl3Z1IFAtekCiiJUK9Dyid6HWbfomE1Bvx/bOd9lnG3MqokG5fV2gWDfDR9qYjp7X
 KXwB4DNDFMvzUtJ8n4MmNLrsy6Rgru8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The SA2UL engine is a DMA master, so any memory it accesses must either
be allocated coherent or be explicitly synced with the CPU cache around
each access.

The security context buffer is currently allocated from a DMA pool via
dma_pool_alloc(), which assumes a coherent memory which is untrue at a
bus level for many of our SoCs. This causes any fetch issues from SA2UL
to end up getting some stale or unsynced data causing failures for any
crypto operations.

To remove this, allocate the security context from a kmalloc-backed
mempool instead. Since this memory is now ordinary cacheable kernel
memory, explicitly call dma_map_single()/dma_unmap_single() for DMA
related operations.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 23 +++++++++++++++++------
 drivers/crypto/sa2ul.h |  2 +-
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index df905b391339..cadc8db14bbb 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -14,6 +14,7 @@
 #include <linux/dmapool.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
+#include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
@@ -741,6 +742,9 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	       const u8 *auth_key, u16 auth_key_sz,
 	       struct algo_data *ad, u8 enc, u32 *swinfo)
 {
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+	struct device *dev = &data->pdev->dev;
+
 	int enc_sc_offset = 0;
 	int auth_sc_offset = 0;
 	u8 *sc_buf = ctx->sc;
@@ -802,6 +806,12 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	/* swizzle the security context */
 	sa_swiz_128(sc_buf, SA_CTX_MAX_SZ);
 
+	ctx->sc_phys = dma_map_single(dev, ctx->sc, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, ctx->sc_phys)) {
+		mempool_free(ctx->sc, data->sc_pool);
+		return -ENOMEM;
+	}
+
 	sa_set_swinfo(first_engine, ctx->sc_id, ctx->sc_phys, 1, 0,
 		      SA_SW_INFO_FLAG_EVICT, ad->hash_size, swinfo);
 
@@ -814,6 +824,7 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 			     struct sa_crypto_data *data)
 {
+	struct device *dev = &data->pdev->dev;
 	unsigned long bn;
 
 	bn = ctx->sc_id;
@@ -824,7 +835,8 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 
 	if (ctx->sc) {
 		memzero_explicit(ctx->sc, SA_CTX_MAX_SZ);
-		dma_pool_free(data->sc_pool, ctx->sc, ctx->sc_phys);
+		dma_unmap_single(dev, ctx->sc_phys, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
+		mempool_free(ctx->sc, data->sc_pool);
 		ctx->sc = NULL;
 	}
 }
@@ -843,7 +855,7 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 
 	ctx->sc_id = (u16)bn;
 
-	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
+	ctx->sc = mempool_alloc(data->sc_pool, GFP_KERNEL);
 	if (!ctx->sc) {
 		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
 		err = -ENOMEM;
@@ -2244,8 +2256,7 @@ static int sa_init_mem(struct sa_crypto_data *dev_data)
 {
 	struct device *dev = &dev_data->pdev->dev;
 	/* Setup dma pool for security context buffers */
-	dev_data->sc_pool = dma_pool_create("keystone-sc", dev,
-					    SA_CTX_MAX_SZ, 64, 0);
+	dev_data->sc_pool = mempool_create_kmalloc_pool(64, SA_CTX_MAX_SZ);
 	if (!dev_data->sc_pool) {
 		dev_err(dev, "Failed to create dma pool");
 		return -ENOMEM;
@@ -2439,7 +2450,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_tx);
 
 destroy_dma_pool:
-	dma_pool_destroy(dev_data->sc_pool);
+	mempool_destroy(dev_data->sc_pool);
 
 disable_pm:
 	pm_runtime_put_sync(dev);
@@ -2460,7 +2471,7 @@ static void sa_ul_remove(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
 
-	dma_pool_destroy(dev_data->sc_pool);
+	mempool_destroy(dev_data->sc_pool);
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index fbea98981f10..7ca385e908cc 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -163,7 +163,7 @@ struct sa_match_data;
 struct sa_crypto_data {
 	const struct sa_match_data *match_data;
 	struct platform_device	*pdev;
-	struct dma_pool		*sc_pool;
+	mempool_t		*sc_pool;
 	struct device *dev;
 	spinlock_t	scid_lock; /* lock for SC-ID allocation */
 	/* Security context data */

-- 
2.43.0

