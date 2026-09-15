Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DD8490C02;
	Tue, 15 Sep 2026 09:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466204; cv=fail; b=AQX4D+710TU8SDnZ3+U8zKUna6M3N3MCPBV86f5qv01j0QR0SuhzPp8jWL7tYnzjGoq2Dm5SMt5BYLKAtdiD9bkyVptIttVpbtwGEEbifXSY32NBsj8b6OAGB6qHmoH5KdZDHJiOgYqpEd6dxy12MbFnJTziHax7tqCk6I8PK9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466204; c=relaxed/simple;
	bh=h0WywXGimDevL3nyU3/YU6gAZ6oBfYPKruZ3WjoSuQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=OJ9EFBYRxafpVtFTeQSw1IF/2GCz5fCRhalfxE8EgIFcAOZ8pwBIzd9fqXEYxyDTqoDW+/qkS3pmBEFOqxNXKTQY4mbb4axxfVa6ZhD/le+e781M5SF9sKf87yO0e3tsgNrPeRc+GTZEVIgLB7wk9s5c67vXwu2EQQ93DiWTgnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=nCkXa9wL; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=G/N/R6Px; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="nCkXa9wL";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="G/N/R6Px"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fB7g3810880;
	Tue, 15 Sep 2026 04:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=LjQM2xNtey5RHPjupIRuYvHxEi5D7bQMDIQ0/DFoy
	Yk=; b=nCkXa9wLphK3o0VEmPRz7TX5gGq/emQ3TkFXmvf1bgBuEQjs3GbUlIeSe
	fmK8ERufCztRX2kgNj1tPOWWZnCgPDbXamhH7DuNKb5bDCtoRBsZVHMDxTYbPUBd
	4CKO74fjzw3xDydgwlSzW3BmrTPjG2j7jvl8Uz1TDvHegPTbl21sUDgwE4rrqg6f
	J0EGUmaWHsTVC6Vp7QDvDhpSlv2k41ohU66eHTlzpuflz/XvPz3ZynZY1digml6I
	lOVagAFtk2o7zTUBB/wNKq0BHSHMFrwkbaxDakRrq4EcUoKMlCuUhSQKC4+tvF8a
	AUXGZPhhc63yEhw0muMFZY/aiLQvA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011035.outbound.protection.outlook.com [52.101.52.35])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9xq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:36 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qDFk++H4sa0D3y9hA9AQUl+QgOHPJ/Hb3FA38GYE9sGr3w7GmRnKuiHHZVOtNtegXp73SdJxLSvxYpj7yjM6qBCQA71g53QboDvE0L/7IOh195egUvCXVSfwRcHU/1sLeMvdXzLxcKA/p043UatQqYC1hjxRrq/gh6PR5nGpD1pjK0WqD+65KlTq6JtAhWJdtoDBZPVUl8hNyxwaOQ1zrBN054tae5y3S7W7pz759qpXFONrr4Fk693gHpmKeAgyHJAENHm6FSvLeu6+BqiT4Q5RB1fAcmsrYb/4CCltA16B83FjiMvLrZkQhAdK9BuQLIkG0XTUiIGsBmFvM5R8PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjQM2xNtey5RHPjupIRuYvHxEi5D7bQMDIQ0/DFoyYk=;
 b=fWyW85Io6ZhUHUqmZFZlX7u6AM8JZ01m1jFjcZbxXjqnbGqMoHkDeXPp7VfQ5EZ5foRHZH7WPoqFYbk4SHSl/oe2pnCmm1pZmf9g/3ZuX87ekuqJwPtXPOQ0W62IFam6Tt++veUOs0X+2ciAJ7p8tZoaAnQlSDdYgbWR3nqBNjyOy624vrhT/0wTtni5KDx2sIcFe3xWzuzLtO5rY2dpPFDZ3Taz6kbqyC41H32eBp3P9V4TtTrEKBKTN20jqdFYsYwA3uDHexJ9wOXNwDvTixC7Yzom9x9UNRM/fDHVq9lsYUTtMQLuYlvS7GdLu9SCQ0e+g1dTqHtnYFaTSpQFIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjQM2xNtey5RHPjupIRuYvHxEi5D7bQMDIQ0/DFoyYk=;
 b=G/N/R6PxEkVGmBQeYLjPY80FIyG+92hRSLdWm9/1sOJo9HJk8qSyO+6OoE18pJSphKKR8fvUnxfg93R/gbkLR8kLe8dIprePE1FlgtYvm0P4r4YjqNSsq7KTPVp8oPEQqJOp5Wha/29XbhYN/vRVB2jk644FyuBkF9XyOSBY1Wg=
Received: from BN9PR03CA0221.namprd03.prod.outlook.com (2603:10b6:408:f8::16)
 by DM3PPFBBE6F5DB9.namprd10.prod.outlook.com (2603:10b6:f:fc00::c45) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:29 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:f8:cafe::32) by BN9PR03CA0221.outlook.office365.com
 (2603:10b6:408:f8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:29 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:14 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:14 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:14 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB883000901;
	Tue, 15 Sep 2026 04:56:11 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:24 +0530
Subject: [PATCH 18/30] crypto: sa2ul - fix DMA mapping leak in sa_run()
 error paths
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-18-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1457;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=h0WywXGimDevL3nyU3/YU6gAZ6oBfYPKruZ3WjoSuQo=;
 b=/m/fv3ZOs3REGTtKov0pxeL7Alwr6rTpYpjoEFi7QBMQhF41Xtb1jJ2mmjuXHiq+ZoUcX1n0p
 MTWKEg6Fm1sBXHJWqiMLCOY6to5o1pwUwS2Uaw2mDwbz6ZGbuvxWBYO
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|DM3PPFBBE6F5DB9:EE_
X-MS-Office365-Filtering-Correlation-Id: 89f798c0-1748-4e5e-3a1c-08df130f9d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BnNzFvdGdxbh5aMRov/EfTew884xSTcHSZZ1b1pT83tAEFnXigEoygTCiCy7wC/AZUXYVXxTTVTLAQjhAJjuozcOKOp7R9mHdbWbv5uuVezFzKjDaK6ORmkWwUF3rAOoQWcFFarpKp4/2FzhJa4hT/SDqkQxnhhw3d+q0IO2gTNkyTacwWjY0oe9YkdB9SjuPC0qobONU/LVjDCVufL8XBnU4dEBMdpxC1KOgUSxP8qiVCB4HTDqVYRDBroPw1YcuEKbO+pc6wGNg7wu6AHctysLJNwabUjVGY/SUkFSclcAjrNB4X0lSQZdyG1jBjFCxGA9/s+I1lM41FXfyI4GfD2K40bk9MTcPbS05jFVXTwej3tCjKBtLNRstFmCYT7SD2roa6RjDo7oCrl4YrP6Z9RwVhAF79x0VPvLhhPU6wTXLORegBiAccesPb5lrQlIGdDi7EtNrsLKoG6HfxIAEjnVTYzFt0dmKytpgsKrsqRIDLdrKkx6f8VrKXfVbeKWwFveajKKmi4jVOh78380sgSZtEofDU8H5Fzah6wIxjPhLxLU+iDUQ4zLLueDgRa17cLDnJs9cEvK/Ra7zvO8CqIlCroOeX8PZc8XKKkDKbWZHU8Sb1EwdsnRiikMHxqWiY2HsqB627b4pP+Zgk3VjkFLzFaL5EavyKgJg+9V41tkouow3LzrCGefiomnY90yIwD4/rx1236htLPwbRz+6Q==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NkFqlLm3eiMpHV0nkufc4XFo+XSAmEbRgpBvkDRZL/0JScP9arU/9iyMBpiEyVLOb+CV4CsJIGr1Yts9yz+R8nwCokk6swZFanAxVScKtjXX8iL0XKWZITbvG6lq7TRiahMXw/quljIi4JpY8UofT9soTXYoqMDcdkkiixmiL9L0GE+KGIhB7ahmIMjp2ZCBTpsUBDrkUIFHW8gwRP9+UzYwUyjpA6ojqbcVudWvgv8nucuekEOFQMjsc8fOgfagAzqeGRoPhfDx9d3NysDcIQ3RQ03GfxUbhK/rzFMR90QDirtMbi5u9hVpur2mTWiuE+AYCl7p6S70uCgMHHkZivylpe321SFl6Gpn/v7x+J4FTEj70AMfx6Opr5dGP+KgqCJq3jpRdZBBRaT1iM0VXjigttsIysmBs0usSalgxZnBFs0etktVda/AHdyaciLu
X-Exchange-RoutingPolicyChecked:
	Hi0WxIux1VF56gZZZCNfOD23iilKSGTl3ufp9Li9wW/ThK/3yZrZCRXs8snqvrJTdsCArf0H81xqmmIxPWH+e8lTQmYZfjS+y7M/scFeQGcFIDwJzUjg+NoTuAu3RvaENKUxokA3k8LqgXDGm8+mSosSrqcEiyKFWeUvcx3EKJ3YoU3jEDc+blU6txU2BJY2Sf3h1DlM6CQZwgHTkFyshop/Ik/+73sSXt5xSgKnQLlBdz+cP4mN85xIUkrR68k8Aidyox9S2vInDQGNIg5B5WYf/hUtAWVRUAIkWez9mnl3Dg/5eygwOH3ebQvrnFwpinWDeQ2WDjdjJGg8gLXj8g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:29.5077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89f798c0-1748-4e5e-3a1c-08df130f9d6c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFBBE6F5DB9
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa91654 cx=c_pps
 a=2EogD3SZGC0twO92opjmhQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=_O0z_oWXeRW8WQ6wGaAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mPiGiPQyCYTOzdhixSHCbSftMtXw3Fj_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX/Al31vMZI6im
 rnivseCmZx2rmGaMbQjE6DZ2R3jgs5oD6byepD/rARhXerInpvrIDy1h2SxH79a7Fy0WFdcCUnv
 P0HQUhkxr6K84NhV0599Dq/Cy1ZIMFzmq4736sVAO4L8/oPjS6ba0+eZSUM2cPVYpJTtj/0vyWl
 zYB+00AT2q4Qxirg5SSfGCTmmLM8KR7eGD/5KGFcjiadxfZ15SJRhd3sI1VQJF9DaOH4+kN5xOw
 9b+SOMVc+a0jcZjUxXdJ2hsHoLiPr5DgxNImhMao49hUCfaYOaZsbqD2/B3aKiKLA1keyMNIEhk
 1ZB68aO8Wqa91KCG7ljKRMPzTBi/Y+Aap+vN5IxibCCH45AknEP4UVPIqJmKwCV+rmVT1pV30UB
 M7aXIu2fnT9ugOgRi1hODdRjfjRr2VzFe34QmSPMIER9k2Xzm6z1Drdf8qHWCEhAn+f0PT7s+dF
 VfQ96QNzsO+NkV3cMzA==
X-Proofpoint-ORIG-GUID: mPiGiPQyCYTOzdhixSHCbSftMtXw3Fj_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX/mC2jWcaZbUX
 0lb5E0tzecFZgxd00Gaw1pkhFKGFl8aaiep/r6wYSjO1fSIuXNEXkIcWC7DLHYoZLc8e0NEFcTk
 qRuUSRWkHgiCapJaASA/xDLugtpA9fc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

In sa_run(), when dma_map_sgtable() fails, the code was using kfree(rxd)
directly instead of sa_free_sa_rx_data(rxd). This is problematic because
if an earlier DMA mapping succeeded, it won't be unmapped, leading to a
DMA resource leak.

The sa_free_sa_rx_data() function properly checks the mapped flag and
unmaps any successfully mapped buffers before freeing the rxd structure.

Replace kfree(rxd) with sa_free_sa_rx_data(rxd) in both early error
paths
to ensure proper cleanup of any partial DMA mappings.

Fixes: 854b77371998 ("crypto: sa2ul - Fix memory leak of rxd")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index dcddb81dc842..cc9f2881efda 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1131,7 +1131,7 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.orig_nents = src_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
 		if (ret) {
-			kfree(rxd);
+			sa_free_sa_rx_data(rxd);
 			return ret;
 		}
 
@@ -1142,7 +1142,7 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.orig_nents = sg_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
 		if (ret) {
-			kfree(rxd);
+			sa_free_sa_rx_data(rxd);
 			return ret;
 		}
 

-- 
2.43.0

