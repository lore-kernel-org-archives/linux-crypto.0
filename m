Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EFD47D473;
	Tue, 15 Sep 2026 09:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466174; cv=fail; b=JWQt7rX9RSXTGI7QG+P7YLyjLG2Zuwg4PLuSGH1ypvVtME7OKtC/2d2beVDUtekABjpG18NH2DANEBoX+p/xNtHaVgBpbDHYFLL4qjpdDyGWtZu91JADpNU88o9eqpavaBimobONXGSH3G95ixV9EEw1KP4ofEfRi1ulnWQ3QTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466174; c=relaxed/simple;
	bh=+itU1zoEDblt4BeOHHLj6FPDb3FT0saSeGIkQ62EVh4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=DzpzC23yWkUUA4xniETRriMS3aefisIJaW+r9IeEkZJz65sbBm33o1D3TeyGsxzXv3Lwqn6vq6zPfnMmGAySdR9+gjZEA8nHMVaCkbJEUpJQ89/PmPBa75h1In2kXOV53gWQdQWbwRRYb+dyIKOZv0moF8gUbQMqbj7boMugakk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=o4xPEE5G; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=WUWQR+dD; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="o4xPEE5G";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="WUWQR+dD"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9esbd3889298;
	Tue, 15 Sep 2026 04:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=L0ZmU+v6fEYxeuTXwR3Xj8jsgCDa72UDoo98cqKF9
	Ro=; b=o4xPEE5GS3OJrVIc0YxJKp+dAPXBIElC+Sw4dsPVxoZ2KqbyTy+i0szdw
	fNYmjaaXXBaVPe9IvneHBOfv9q7RIZtm2DfI3zQU2G635qZ97eTRKvctWkQdgBRD
	WnSpUx1QQutou/zXmMMuMYc9Wyi87a7kbRAGve5Fbzzj4Lr9ITny4ZY4OCFUQgwP
	Fd0tmTpuPcEFFNUYyeGvc9lsLtf6o4zTEzjVXgToXHp49/60KDsrSd2+OCg/Js6x
	E8FC2eHljjrKF+jY7lT59QVJcXqxv6/tizWtHhes5qhX0w7AIOxBZogpfL1eWcE7
	NujGYlHR0ZbNyeF7nWJurLpMWCyhA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gppxsm9f2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:08 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OJfFwXxJIWnGfmdV1cE8nMuP5fXLFmImOW0ewatr5Xc/5cIQP4huyS3gRSIaxnTekMUuPxcDxb3sxNd19AXNI2rgnEFH5SfnX+LsN92Brbeo9vKfBJKhEh6aj/awUGtEgu+2e5F76Yp9Nfc5nhusQA9VIL2ml/0ICTRDL/y+OpxsR2AdqvdjITdGcMv7Ya/s0PijBhE9Prr5VbaT2Xx8f2WWgZqQc6gmZ7XVe3ZlYYS9ADFGs3N8TYrjgDDKQcBVRLLidASmeHErnVGI9PulYSpkonmnVxF1t8wGHfCq+Ttad7rF58EuA63/ja/7YYQTsFFM1/YO8WBMJS69d7BqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0ZmU+v6fEYxeuTXwR3Xj8jsgCDa72UDoo98cqKF9Ro=;
 b=LsqpXLmfWt9I0jcjoc8L1Bzf64i2poMIeKp2oAulomebDyPxVMMyE3SjaUEB9HUt3xGGQ2IaFg4uVoHirA3Wi9xMPTTDRERhPtLo6V1spkNuF74tM/GSdFPQtQmOWtdiUPazzu57yjkBh7FE6F9zGLL+V5PVB0l/TCQ2HdCIGqARmcInHfRSlwrzgOYJv7T6xpJnvQQIq89lBrWcCs5OciA+3kQlOuxVnfkDIrq6yOfmXuHyI44F5j2K+0UUbAW0MYdJCUNRTqYQW4oeWUJH6L1DZ1yivMkUApKu2VjbZqspWftxm5pC3MORKhYogbptnYGiJ+Kui8w94/alWUDH7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0ZmU+v6fEYxeuTXwR3Xj8jsgCDa72UDoo98cqKF9Ro=;
 b=WUWQR+dDZmwHAQJrocPy/fAjENVvG1q/EjPgHsZ8vgCmCTb61E+V6TCIS+XkIczNxdCS00RvVibygYLPHYpVGjIh9i+Uh5C0mPsupXmPlqMWXLz/GvhhXkAcQ1/gATzxX2y+pWZSCrw/Fn2bdZpwD+/Re+0LIcvMP758sCg3feg=
Received: from SJ2P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::19)
 by SA1PR10MB7853.namprd10.prod.outlook.com (2603:10b6:806:3ac::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:02 +0000
Received: from MWH0EPF000C6187.namprd02.prod.outlook.com
 (2603:10b6:a03:5da:cafe::67) by SJ2P220CA0006.outlook.office365.com
 (2603:10b6:a03:5da::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6187.mail.protection.outlook.com (10.167.249.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:01 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:19 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:19 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7p3000901;
	Tue, 15 Sep 2026 04:55:16 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:07 +0530
Subject: [PATCH 01/30] crypto: sa2ul - remove dead code
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-1-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1849;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=+itU1zoEDblt4BeOHHLj6FPDb3FT0saSeGIkQ62EVh4=;
 b=1lZ8r46PEmSthrL8EO0qvWW1P7TdcYirME8U0YySUDDjId3hPR5LHcwOTBABNPwV5cVuqIl4k
 VhYeB9epK9MAVx8qcHo9KszDxmI1C/jpwLc9lEauYEB9BNeGtTBfYIA
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6187:EE_|SA1PR10MB7853:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c52e2f7-90f0-4393-fed2-08df130f8c7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	FrpEyHFCNivwvdIT40PJwaAqqySkxeOXVtz7NsVPV4UywyuwTyNS9uXDnjmcX4UKO2cszl2Nfzp0E6a97fimgtnsbkyewc0oOrLoDjUbWh7IxlxgZpe/t1c8QuiEOphttbrdyNGk1K4Sc4dqOhfoPdYiJ7Yd3xLkNJr0hyCQPRf+sjG5xiJFgkR7pDhMeHYUfken6KktYL6BUv8cJPrfGEHlHVf/7S11Ie6J/OPE9BDkjLLInQ7t7ECCpehoHfa44IQAm9vTAiZlBZq2kJm9HB8mkf2jvobkpMWmidOz5ukKUq7kBH4wDKs2veInCIF+LH3091lwfcgg3gSgFOma9Qr63KdHUFPfOFd9HerLF8mNUKFpWMPlBpHMiMe1d83NXl0HCr4WIEVKFA11oMyt7k17QXbqiyu6WeWN0RRRweknqBu99NWNTjRR15wpX0jA1D1SLTf0lSpyNXlQLHgGI8cW/ImOu8mGknM6usDuCCbsj/37IUA9LMCPpFFwPSduTPuZqmEqn+skBHSRJ4SdMrSLNIoMSeXUOM93JUvqjYfV+f7Irjb8g24zp6itQY8Pvh9Z8tL8tveM2U7BRo/C8D3rgLwDSuW0+VRUw2O/JflbIegSSrz2psVTSb0PimJ2ab85edFZi6doMcLzb+WPI50vuuVV82vXqcJprqjJsbry1TG2vwX8AKv08MgihAdHCYkrN4b6zw0deC0VSyL8+g==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XNbf+YnevXjmbORc3gplxzDtb1U33VNvPYCWN0qP6E9uzFw86uacW1cI95wPm7A0E2ZJ8aFSVjb59+C82YlInkQ1Ro2bdw3q7RY38EZwAx1yMdtobNmg5mHBHv/zd8UaZht6ulFQ4cV4/4D+LUI4XtqHFPu8ocspFrGwSmej2kjLx2dguvtA3sZ0ZM5o0Cog5p1psYp2T7RG3p8eGB6RloMiIeIQIh6VSksOGFG8q8pl+ip0IGp8qTVhsA3vG4HCifvAGPiR8xQmyviX2824+RNznqD/75edMMX9rsDAE9yRr7yL0MQPh9EBhuEn/NPYoLRevcUGO6u6Z9KWXcmCE3O7XgmdA23913WToIKMhtwS0Ee4e5NVaoIQlBETxdpzPU1ZWHCN6DmmE8iKc2NQdIM3gYjajwrWH9Q3y6mIQdDjrDQ9qs7xo40qvZNR30ZG
X-Exchange-RoutingPolicyChecked:
	tzKo0ipdPzDykCfqRkQWPRCSNWxXPT52VHmCLL8M1yRbzbXjEtuolKAMD2PLz/XOKPGz2ICz5HyaNkniVHyzfg136ww3VXJiv0pFwOS6gCuxwBBj7DAe/I6pje2gKv4oWPa33IyhuWuUfIfzzzOm/DgFI3bzoQooPsLwMBW7J43bBLH6Fp5G2NjE0Teuj18oNwfrFbHFO7ktCP7Y7CIjYBho5AbcmRpfuVDRq2aRKwG+yS/l3k+5KEph3TMXujKU+n5Rp753307APXAwBwGT2HhQwhNcELJbh44iULGrqf8a72KXAw1Grsp3AurKOjybMcqKyyQlkOAgAG8r1dZ/Vw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:01.1172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c52e2f7-90f0-4393-fed2-08df130f8c7d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7853
X-Proofpoint-GUID: KOrSCsyK9pcfdui8JLTjFhSsg0TvsqIq
X-Proofpoint-ORIG-GUID: KOrSCsyK9pcfdui8JLTjFhSsg0TvsqIq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX7jW+mitkqxfj
 XHl0Cv0lhh8YZSXxlZPReDLQlzuY9PjWxQIRZUs1LJns0fX3w9fFP2A4RttsL7+b86XZoQYmOyc
 qBoiMLJr5LLoDSAqe9F3f9FlzkBfY4UDABSZJryXi3RAK4tuwaGSgpgavpfpAUQKrYY1kUY+48H
 mQ68CKhI6ad+bHRBKjOCae5pokEQVUqSxeFF5YDZbyKnjbdhm/iVsgYgRqfrU0a/pooPj2mPn53
 91noDRdcdGJDVX/ezA2KDnviMKfM92JvZFPkTuEbDmBg1kqzMU/jgmmT1BxNWzqli0FoFhxCqk5
 NFlpHEJaqCAbPC1XLc7q21Pwr0hABKoCpBxhzJW/jobsf/mbOnPYHSi4Yb4PZ1UEwMTyYrYetNl
 //7H+o6dWH+zqwyE62EbQC6EEeriztzxovTqmrGlNViozuwVmM5fEmmQoOxwW4JyeU3pb16ZyuD
 nhyXmnd0arSfTRk1jjw==
X-Authority-Analysis: v=2.4 cv=bYP+w+PB c=1 sm=1 tr=0 ts=6aa91638 cx=c_pps
 a=8g4i1X1tkAMDiabECo8pFg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=tq7M4MuTrJI18TnFGxsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX/OXana9qPEKc
 IVe6TuGgAru0Hw6M5X/yZZJ0z5tRXnOkF3puR6ucK7p13Dva4AfZHSFniYke3K/dGhFRzv+Yalp
 hsNVGg/Z4ivIJkvExbY2boOWLIJ2cRY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The following codepath is not used at all as SA_CMDL_UPD_AUTH_IV and
SA_CMDL_UPD_AUX_KEY are never set. Remove it.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 0dce2b98886a..f7e4f58c02c2 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -41,8 +41,6 @@
 #define SA_CMDL_UPD_ENC         0x0001
 #define SA_CMDL_UPD_AUTH        0x0002
 #define SA_CMDL_UPD_ENC_IV      0x0004
-#define SA_CMDL_UPD_AUTH_IV     0x0008
-#define SA_CMDL_UPD_AUX_KEY     0x0010
 
 #define SA_AUTH_SUBKEY_LEN	16
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
@@ -551,17 +549,6 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 	}
 }
 
-static inline void sa_copy_iv(__be32 *out, const u8 *iv, bool size16)
-{
-	int j;
-
-	for (j = 0; j < ((size16) ? 4 : 2); j++) {
-		*out = cpu_to_be32(*((u32 *)iv));
-		iv += 4;
-		out++;
-	}
-}
-
 /* Format general command label */
 static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
 			      struct sa_cmdl_upd_info *upd_info)
@@ -670,17 +657,6 @@ static inline void sa_update_cmdl(struct sa_req *req, u32 *cmdl,
 		cmdl[upd_info->auth_offset.index] |=
 			FIELD_PREP(SA_CMDL_SOP_BYPASS_LEN_MASK,
 				   req->auth_offset);
-		if (upd_info->flags & SA_CMDL_UPD_AUTH_IV) {
-			sa_copy_iv((void *)&cmdl[upd_info->auth_iv.index],
-				   req->auth_iv,
-				   (upd_info->auth_iv.size > 8));
-		}
-		if (upd_info->flags & SA_CMDL_UPD_AUX_KEY) {
-			int offset = (req->auth_size & 0xF) ? 4 : 0;
-
-			memcpy(&cmdl[upd_info->aux_key_info.index],
-			       &upd_info->aux_key[offset], 16);
-		}
 	}
 }
 

-- 
2.43.0

