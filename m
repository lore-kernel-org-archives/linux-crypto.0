Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771139;
	b=u6x/U3wGQCy5Ea1m0awEwuuRTacvJ0WnDZQgvUGO9a0KQA2o5ztOuIDAJJ1gp9bNPTfh
	 R7nzS0YulOkzzcv35oea+MBNV25U+pHC5wmjiDiD80ndHB+NdWr3oFffXkWiGrikRaENh
	 quCFLpeIUiNIjuN4dwJksWAFqGQeo3kbR87W0cRjyNtZqQ35THcrSE47EB4tKKrw+4KRB
	 gcSWgIyDgLf7QaM8DUSKEPe21KgKY0nrxAvdKeT41G7OZ/RgSvxRL2pSF02s42OzOpBju
	 Mo8XAQbOwdx3SqMwTb7OrIpYVq9lfKD68jrZVpyT2UvpeDBSQIjKYQPuxky0baRpMow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771139;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=FgO8z2WtDJWsF1EpFz7fI3enCl6w3Ypg9fbBrmMKYaI=;
	b=ByaANumFnXF/UwFqpDxGcC3qZcyKvi9yIXo6/9aIwko/jvhK/bBU26iH6R5z03NCinbJ
	 AhdQziSRx5QuPSXEWSntbsf29QVZvIItRnlb/xWVkVOWZtIgo87objt3R1Q0Q/8x3U0Wv
	 yFvaz6qdqJHIc9HBDCmCUnsGp3wDEWkAj0wID+RmJd6TmBjNGCr/6FEdHPsr+5b+yI+mD
	 zueKrEhzOWo+MO2q5OprNc8b9lB5O8zBgGlZl+YNjk/YI7WeTkFOJKGr63jHpKa9JXUM8
	 fYRnsTCgwZUA/oR+aevcp1Bkw0c07J0hLCoy/EDsj4CT1lZp1CVzjXbaiAW8gy7ex7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LbIGqaDI;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=D4r1HEby;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6368F606A33C;
	Wed,  4 Nov 2026 05:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6368F606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LbIGqaDI;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=D4r1HEby
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TOFs601514;
	Tue, 3 Nov 2026 23:45:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=FgO8z2WtDJWsF1EpFz7fI3enCl6w3Ypg9fbBrmMKY
	aI=; b=LbIGqaDImfYJLUBNl8zpoYJJZ6km+KJWqO3Xj4nLyegeyp3t4Ey+gs73f
	RzdwW2SiyUYHWoSJ/JIkszHWI7IVwoT8kW0UMW+IU7bbcItr0RKNO/01F4XZD4BR
	cJOpobfa1aHcnf1uD66zjscFxzGnsUBCNYP9Hb06SwmguIBLPwccvERSJ4AjU7u4
	Z/eJqs1PY6xIjw4KsVnyU7+NZUXOQspe0z3HyLa4LOfm5Tm+VGs0NVrrbNimZtx6
	0gAQI3h/13/4N47/2wHDFdIL4uQd8Z2exq7HfpNqR7E8tWlUUtwpNRlclT8bhVYl
	QeaPWDjTInDk9+HXFVlSlcQ/YeWkQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tn0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:28 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=majCGjlxQKswbgdkEXuOEqsPlOb2CEcSK/fydq6GsHelXRBCIuyByKNvPRO7XkDhNUX1g2qZrPUlO8unEtbi3qsoqk/ZVKLKwh+cGcF9z/LwK8JTPiH8SuvYbgCEaAUdyVzAyZmDlmzQ6c+Y4NGnpgvx8DbGvmUGeoz0HwnDmDaB84Biwz2kQPTkXP4axkt3x+rknQeuOiExJTqtQTTq4clQDb82Qrp94Srm3x1AxEq09DELh84+L6pGkqot8iDOl7wTbLXnOk1QQi4ackVT9w+RFuqLUZQgr4G7v2kLRVJTOcjgB1JN8ft1Qp8f0rtLLj1oHM3DV/JxZ77X6Wf1XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgO8z2WtDJWsF1EpFz7fI3enCl6w3Ypg9fbBrmMKYaI=;
 b=pE1G6AI/sSY7Uzh/R9UXy0BYFg4Wjw6ozVkVdDo2mbMskN3lquEV67yTFKFvGnWetHFOKNnTy9a7uewISpXALpPn9Ph81QO76wsqljw4PsQSOh8MRed57Ueul8s0DBzzf/O9ZeTTqxiDHNy6HfZNvCHZGc8IWTyfVvl2TMyHxIxkVvcN7efDNoRoNyrexzNYij72TKzINhGjNwLSbGzsvzkFZqM+AvmNV0GtieEvrAhB9MOO9kbG3kqU1YHoiZ+kVmd81cFI9sZGhHF5UIedg42t/X6haoNFKhUbYgjNzmJJrrDQrfW0dF4znM1J9X2zUv1G9ucAcLmZYVgeml0Kfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgO8z2WtDJWsF1EpFz7fI3enCl6w3Ypg9fbBrmMKYaI=;
 b=D4r1HEbyHiQhvhHuHS9ICODoMtsUhc82973VelSRe22hBH3dXe2u3IV/80p13KMvVrADEYOWpYgW3YJWdYaWziN/6Vv+vtocNHHNXy9IlxLBHTst+QwTUnPqllpxkdkwsjzL8qmDZTyTVk4ABCM8Dxf2XAPkkstJp1QEcc3hzo0=
Received: from BN1PR12CA0004.namprd12.prod.outlook.com (2603:10b6:408:e1::9)
 by SJ0PR10MB4768.namprd10.prod.outlook.com (2603:10b6:a03:2d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:24 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::56) by BN1PR12CA0004.outlook.office365.com
 (2603:10b6:408:e1::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:45:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:21 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:51 -0600
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:51 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:51 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxp521920;
	Tue, 3 Nov 2026 23:44:48 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:17 +0530
Subject: [PATCH v2 07/30] crypto: sa2ul - remove unused includes and
 defines
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-7-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=4016;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=UgEoQFYQS2gsVzSEH1A98gemSi7QgEjdMOXmHmig4ew=;
 b=CnaL3zg60a5b6rMeqZs872yT5pz9nDoj4zf2PrW+UqMgOQVKFoKs+BgxIWtidawBPUrkl9EPB
 8w3p+vE5HmRBao+4mqlYXtFLev1gSPy8gR/MfYdFi7LURIdy4oF9BeO
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|SJ0PR10MB4768:EE_
X-MS-Office365-Filtering-Correlation-Id: 196cfcdf-1b97-40f4-4977-08df3a36d115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|56012099006|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261026140227099003|10067099003|261102123227099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Omww71Nkn2mJe8NQiw1YVb8hMyuMEcigYREhkvA3YZrYLaDpAqBzAs2ve+qYNPa7fvw9q/s8mpBKjaeYNSYqX89pjE6aXtvZBEO4Oz0CVVBefMYK9zA16uKAykVvjh/M8fQ9DT3GrOp3T9/6Er2tz87lbDmNc3UaCgck0p/Jk8YE//7tdqof30MluMLmgrLvNkZyocbHw67Ua5fNRNrOX0Gh7IGyWUsVUEetlP3x56a1KRFMNGpeKeZUO+NNIccGLtXfuQinSapRCP7Y+LnNAoPV2h5rpnVz/6rIs42nZtL9f9Wo/vK85SMxteHdbx5c6EJXC4CdOmHibRAOGWzp0MenXftxAKyURgq5FWie+iFPSdCCSxMAA5dKPLOwBztUbUUfyPSWRsOOsZ4cJ6dZ1PCWIoOUBXlp/MisHzlm4BZE1P8QWUTl4xTW3/1PfvBKk/0nQNOibbAWXerO4kpu970t601RMJmlXNSN3Ivv9COkCXRyGxsFzn9n7HW6Zn2HHgrOWR0SANkACnaxDVHrfFAE2+ZuCaXshoRigU3DDXquaGli1Y+lQdZHrVcdrh1g5H3EAttuebOiaRiebqz3O2CkYIDNzOCabtvJ4eCi8ayXumLPgXObGDqHm8sIXjtk7M2eRNhz14EQvYhyWrxL0hLz+7sPdnvg5C7izjH0pJ6BRqH4Zi6tUXGhHe+R3Tq//rWPL+T19iK5ucavNEEs7Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261026140227099003)(10067099003)(261102123227099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9Mk7M7SoyOJtV8OvpkGMvKIO0VatcVHaX3jS2lvXEDXCazty6i6GIYqUY9SOLicBJ1t6los/BcMF4P9s3VSA72kp/UiE81Ib78JdqrWyF1bXmhplGYlZBCHNhKJK2japMby3TTn/3jYo0kS6lMcHACYMlDoTxKDXWM0jzfJVraEuUpNzXMqysOHTkjRnh6Qzi9XUvv7avE4Wuh9LPbordTcdDV+n/LCpDzXxHA067dwjmqbXiaiVtFsSCQ8x63yqiQXl8w9rq071ogAcdHUkR0j4INZrd/HbtKaAFuMPi3lo5E21nODwsspvU3wnlaryinZTp2/Y5D15qvRYu84YmBVaJzrTMKpkKxSiq5avdOEEkD8fhoYF8sFLtjzg3d8NAKb1o9rhXF/StRxcqbKgF5VqPR3jpDQOIt6Nlb6C0D4QZwMqC1PYitFkEuEHbbxv
X-Exchange-RoutingPolicyChecked:
	HFu9Zf9BTMffRdHLqepMeDAfMNWnIIOKFCcyQlXo1geiwygW1AStWhS6t3zvwsHocPh38TkBNiDD26H49iCnTDi6ZyW5y4XPTHrvskp3+kABkoxC5t/x2fhck6Qd6ZwV+2HC4SwVBPq3NIpO7+u5jBAubRT57QXtcjX9Vx0xVqobos/cEztML3T8R1DsNwepXAoktnk0BgUEPndSPK+CPQR+NcGDu7GOSEEFBpFp9aVG4G90ugZ4tNwqKpAA/oKeUxgSkoRMnnHD1T6KG4uMPQBuo2sgtpvPQUqmPKv+xN9L8lw0b7e4hDlIFwn4V4AF7wHgH/gp3WPB68UZg6Gxbg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:21.8505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 196cfcdf-1b97-40f4-4977-08df3a36d115
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4768
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX/L2sjNkNnWI0
 Ys4dF8QOAJWoQm2eAOS8r5KGkTiQyJX8LKjmQpuGrjhPyKTKRDGmXk/w8+AlPQp7Q+DmV3SzyHg
 EsAFBlc06oqDmEE0wSKN++VrjvjIbmlZI8+4NtRctu8pqfdWGR6IJsO1wFiFLoPNv+w/RkHyrIj
 VqEMyvI1nS2ewnjqH2JRMC5RPEMx+5ejLmlP1HAfpRCww9axfN61XZrktZ5sDmcgvIryec2BXca
 c0YvyiRXu71+o/vlGGztFzCTUcpZVaCxPehtTQ5rhWDscbh36EFG8icqcA1XO5AZN0+8/Zoqj4/
 rSibYuhVsijJOd00octTSfvlUAM4UdFrF/YLMjXhROqf0QBF2+p/pEnweDpXQKdaBpXT6OVj0GS
 OBcupDIdoEPHY+etZNNZ7eelkRwJ+SozJ0/oWkZCt2hLfA+76q6e8NVCSO9WCW0L4RBZGHO49oz
 mQap9lmTmhz5exmu6Sg==
X-Proofpoint-GUID: hY10YpaAP-vZzsBxszyEPcxGL8ptauS5
X-Proofpoint-ORIG-GUID: hY10YpaAP-vZzsBxszyEPcxGL8ptauS5
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac678 cx=c_pps
 a=RM5EPw/H4l4S9ahloXzS7w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=fif3uKSR09q_RPwJq1YA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXxEyD1PASAm0b
 otXWEP7kwKgsBz9r0EadohtK4NAK81AqMoVhEOV2JqHN55MnuXOmlpczzZ83P7kAwdXzuXwDjR4
 DvbVzHd8G5pTxKHo+5tZJB+aT4Fg1JA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Remove unused includes and define statements that are not
referenced anywhere in the driver.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 13 -------------
 drivers/crypto/sa2ul.h | 10 ----------
 2 files changed, 23 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 98075f9ffeb2..e1e537de2d16 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -9,7 +9,6 @@
  *		Tero Kristo
  */
 #include <linux/bitfield.h>
-#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -58,14 +57,6 @@
 #define SA_SW2_EGRESS_LENGTH		0xFF000000
 #define SA_BASIC_HASH		0x10
 
-#define SHA256_DIGEST_WORDS    8
-/* Make 32-bit word from 4 bytes */
-#define SA_MK_U32(b0, b1, b2, b3) (((b0) << 24) | ((b1) << 16) | \
-				   ((b2) << 8) | (b3))
-
-/* size of SCCTL structure in bytes */
-#define SA_SCCTL_SZ 16
-
 /* Max Authentication tag size */
 #define SA_MAX_AUTH_TAG_SZ 64
 
@@ -188,14 +179,12 @@ struct sa_rx_data {
 
 /**
  * struct sa_req: SA request definition
- * @dev: device for the request
  * @size: total data to the xmitted via DMA
  * @enc_offset: offset of cipher data
  * @enc_size: data to be passed to cipher engine
  * @enc_iv: cipher IV
  * @auth_offset: offset of the authentication data
  * @auth_size: size of the authentication data
- * @auth_iv: authentication IV
  * @type: algorithm type for the request
  * @cmdl: command label pointer
  * @base: pointer to the base request
@@ -207,14 +196,12 @@ struct sa_rx_data {
  * @mdata_size: metadata size passed to DMA
  */
 struct sa_req {
-	struct device *dev;
 	u16 size;
 	u8 enc_offset;
 	u16 enc_size;
 	u8 *enc_iv;
 	u8 auth_offset;
 	u16 auth_size;
-	u8 *auth_iv;
 	u32 type;
 	u32 *cmdl;
 	struct crypto_async_request *base;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 6d5a3e65dae7..eedfad49793b 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -184,7 +184,6 @@ struct sa_match_data;
  * @sc_id_end: Ending index for SC ID
  * @sc_id: Security Context ID
  * @ctx_bm: Bitmap to keep track of Security context ID's
- * @ctx: SA tfm context pointer
  * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
  * @dma_rx2: Pointer to DMA rx channel for sizes > 256 Bytes
  * @dma_tx: Pointer to DMA TX channel
@@ -201,7 +200,6 @@ struct sa_crypto_data {
 	u16		sc_id;
 	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
 				BITS_PER_LONG)];
-	struct sa_tfm_ctx	*ctx;
 	struct dma_chan		*dma_rx1;
 	struct dma_chan		*dma_rx2;
 	struct dma_chan		*dma_tx;
@@ -210,19 +208,16 @@ struct sa_crypto_data {
 /**
  * struct sa_cmdl_param_info: Command label parameters info
  * @index: Index of the parameter in the command label format
- * @offset: the offset of the parameter
  * @size: Size of the parameter
  */
 struct sa_cmdl_param_info {
 	u16	index;
-	u16	offset;
 	u16	size;
 };
 
 /**
  * struct sa_cmdl_upd_info: Command label updation info
  * @flags: flags in command label
- * @submode: Encryption submodes
  * @enc_size: Size of first pass encryption size
  * @enc_offset: Encryption payload offset in the packet
  * @enc_iv: Encryption initialization vector for pass2
@@ -231,7 +226,6 @@ struct sa_cmdl_param_info {
  */
 struct sa_cmdl_upd_info {
 	u16	flags;
-	u16	submode;
 	struct sa_cmdl_param_info	enc_size;
 	struct sa_cmdl_param_info	enc_offset;
 	struct sa_cmdl_param_info	enc_iv;
@@ -294,13 +288,9 @@ struct sa_tfm_ctx {
 
 /**
  * struct sa_sha_req_ctx: Structure used for sha request
- * @dev_data: struct sa_crypto_data pointer
- * @cmdl: Complete command label with psdata and epib included
  * @fallback_req: SW fallback request container
  */
 struct sa_sha_req_ctx {
-	struct sa_crypto_data	*dev_data;
-	u32			cmdl[SA_MAX_CMDL_WORDS + SA_PSDATA_CTX_WORDS];
 	struct ahash_request	fallback_req;
 };
 

-- 
2.43.0

