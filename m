Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA294A6890;
	Fri, 16 Oct 2026 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154819; cv=fail; b=Oy/XVRhQE2ujWBigFGfL4rzN/PqnhpaEMP/0xRhXiVE9szJKG6EaWlAOtvDDdtiUsKMkCrSNlPnHFw6Tm5IEPEfK7widCKXbjArHKRbLLpA3jxCo7SLep7LJh5cwmOKbaXI7+e4y5biEfRhawFkMeMaHEt6jiKwsZt6U4flwcJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154819; c=relaxed/simple;
	bh=oEievuPIK77sfBoMZW0FxLpzHM0QEpV0zn6Xmu5kz+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejOW5pAr3KYJKMh2ZX6ljGrViIMWGEltWEtZvjLeYoDTCKxiFc84N7wRKgNQUhewVMO1TATKiG+sV3SLbzD1dx6cZNoa6pIJDbS19ZkwmcmnK3MTGKCj3iHaDE0GVOuvrDS5kBu+xXWTG/rXKdb2KYQ0M9umSa0KX+zCo+g7+9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=pBct+Dn/; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=VI3rXtxv; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="pBct+Dn/";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="VI3rXtxv"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GACibs3703875;
	Fri, 16 Oct 2026 07:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=pBct+Dn/Xqa1VbLxuEJKGvuRqA+NSToYJUVfk5P0dY0sYdLFjGC08auy2
	cvLRVQ1AJKYml3p55flo163nlOzuERGvXmjtEbkcurVJ6630GjN/S62jP71VfnY6
	rrasIv5RgHJnfo7FIAM6Siebd9s7cN4FhY881wN5hpROwko+D88Vh2You8/iLwQg
	v2ZSNy1PmJ6NuG4YBdvdlM0zYYyd9XKC+tdH6QW4e1k+snuvPAt9OCMa9drkFhzo
	n0NlOUGz9c5562A1sSKXH1S0Lu/3FNj5hqOCG2ZZVGDxDINM657fI56LDqfXNJ4G
	XkHg4f8UpC2yUXlpU3FHBhrJI+T9Q==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010067.outbound.protection.outlook.com [52.101.61.67])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8tbp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:55 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TWpbMMj5qDIVB+aAjb5dwN5yzZfcW2LcYkqy+4hJ2idG4MxHU82rTl+YSKWbTn1982jHJ13pdG+zoEGsQXZH4L5+6sWIQ6NQS97YPdVy7pCY3WIaDlXWfh/smj0ugvUXcqJOtNGmJIJpJq7ju1wQPkMPKZfbpqpq1K+xBL5jlN3XBHncoGV/692wpOU7djwyKFmhlM0o36wF0cTmScbPaWnCFCsxdiKqagjhLXlx3eb6kSzaTbPbxD0sOnkfs1Cy9SP/tx1GPvgbj+/laBZGHP9DNKK4MmnpG2zp4tdztjaARas86kYFEe3M3B7VnxgNrxoJdGaCQsCJWBYaUZiG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=repLzCg/Y+5lEuUKCWsKQ2w9V22OntVXGOrqPTas/ta3+jFikKQ2Iv/Ed1zlVDwlihHrnyI9cRHSqR0BSfVAYSpQfiV9OGRuLPWfB+xZcC4q+kt8Un6MkZljjb48HviBvnaOtd2D7WHQMaMYB3dDCSGtil4yIEZicyq1VlHy4MMAWhaJTfHh6NTMt0/KBstJFuwk50x4YnnuWFl5eLY/EK0AzItNOZUTQVhE7bgf3UFIJQ9tRQnUhFsw2EngagVt9EDWXh+dbmzDneBkAKVLhV1s9TQJfUQ0Ububwrk2b+TEONX/c2kd/0yqLEXO/ry7WrpslA6vIfsAO2BrDXQvHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=VI3rXtxvJdONacBXErBsNqI7ATUdrb+83ZQbaJQIl78lNF/zghMY689+hAm/PBT2QbyPsT5sw4bybZOVkhLhleIxn3hWOGheXx/NMIhwxkvMnM8WU527fCkuzKuul9FIhYhTnwQN5SqvgqPnlHWGDTsk6STo+/O8C5mIZueijaY=
Received: from BY5PR03CA0030.namprd03.prod.outlook.com (2603:10b6:a03:1e0::40)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Fri, 16 Oct
 2026 12:46:26 +0000
Received: from CO1PEPF00018861.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::38) by BY5PR03CA0030.outlook.office365.com
 (2603:10b6:a03:1e0::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 12:46:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00018861.mail.protection.outlook.com (10.167.249.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:24 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:37 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:36 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:36 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjZR91587989;
	Fri, 16 Oct 2026 07:45:36 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Fri, 16 Oct 2026 18:14:49 +0530
Message-ID: <20261016124456.1802080-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00018861:EE_|SA2PR10MB4811:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f3182d-c788-4328-a621-08df2b837ce1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|23010399003|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eulCjFZLPsY7kwXqfs0viclFn04t5Qr7W0Z71s0uh9DAtvmx6jzCStPCT/1DrTmT9NYkglCHYrR33nZ73JowXanEu2QyYLNqtpveLg3ljwzZjOWtDDXzhplBg3vjbLXq2EsmHO6dcwCX2Y+723XSHbnleOWoGOLFeUtVetwdyKU5l+e+lpeKrap+zne/pkZOC4Z3oTaIEfwYXCMMtkxtg83jBXWmuK1TP4r8xrTCvYTYLt2IDEbjTnKgXan9LUdCtPiXIf89DtK0HOHvwrGSfTyZANbGFg5eSO/l0YVoCE3DS34vvUfp3TdVKtprvQosU0m3mp1xvL/85puMxXxddy28wVWt+KkyM0Y6OIGXJvqiBbWz5u9Qed6C7Uy6Ez/UN58pbqIFK7G5Q6MJ02RvYQf3pXQqs0Cd+GeFjOWqwCr3JKZAXxesAq2R4Ie8W93URMuTu/0kOiXXsM1fjo6o60cYQ22RcP1zBER0efdapcMOl15+qGGj8Xa+EhiDEoe95EYrg/TnifUqbOyWaYl+I8bhViHT6VrTnaYBuzbFzpVo6VXVz+JOBiB00D8YBnRRMpa76obkTKkqiT6L0QnHdRy7xMeuMEeLZcosfNl1pifld9koK0duXe/fBEcyxJthJnkIaszfeg+wj8YkRn8rjrDWd4ezY/rgx0XeGaD7PIdYD8FUUGEoRVUC4Bec/YIiOGkcCI4NslisMgukVrz5jw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(23010399003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	avPoR6tBDF3RA6xUBnmZQZvhlRqZ1BqR0/9gHcODNKM8XJoS91aM5BoDbs2X6mHwpj4WfbXfyY3ejNV9MzgdA1JtlEZMYQx9dS6OVacg9T6h5nCVqFK6nheKi3Q0in6gLqKySyyEwGfNlcgLCYb0Hww8wdgWIuwzl+QxrLSAq9TEx2oHX+bDmkyWO/eg9bRELQh+GYYG4cZU7Y7m6q7X1fiCzSugA6EqUQFDA+7dfkdmnCGiAIWbuUB21lzyYH8uukguVgiph/yy3cenWvz+GOVK/3msCOqjHyKtWVPJkwWFmzcfg6DK94ByrZR0/r4j0rSxnVzevXl7Oy50IIwGuD7j3rx4/PsIm1SpDGNF8gD26Fa35fUd/m6VwC132ZPjgpk0opwR5E81oQ7EXXqDUZDAA6P3D9AZugCETuBXKXwXQUl0MYmRR2Leu/9JG8FK
X-Exchange-RoutingPolicyChecked:
	MJngAVr+docOGpMYNPGKtu8FMHoslro+wXBoBDS+3DMXfoZDFvy/c8FY5/SovqCJHE/+AwseAuQm44R5GoKH8SYJa3pfMlSPD+lUs8irzvA/dOa+ogQUphBDwdtRpfHfviu9YMvT7QxH4EvCMBGTC8d1cAE9yJGiVHkYn8+dNMNJoFaQUbh742vEKZgw1zmBziilqI3yzlpQ4OqNgC4FIBBLZN6K95ogy3i9aJqCAT9F7K5IOepAXG/EwqjaYa8i5mf1rn4knrp92uZZqC8+w/DlPYXRPiKfnkqsb+EoKPdh4nOM7ZmvpipSKh0RugK0UtFy9L5eBYMcTBuQ+rVnXQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:24.4483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f3182d-c788-4328-a621-08df2b837ce1
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018861.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-GUID: aRiU7vOg7pLj3dPAKiBQqdlYWK8S6SgA
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad21cbf cx=c_pps
 a=5QB7A90Jg1Mn+JdiV6um6w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX5tHybUy5i9AE
 hbcbzfGJisLi0xaEpzMnkcYs16yB1VUf990LwuVUEAlhZla/7Rs4a6q+eGy2MNIPCf+9TZ+/riQ
 ja7AHFpn2etl8CVXI0ZTT7b/YnanyimlJX6/UIjuhR71jayrRXsfbm6aQA10QfBMJclTTCZ35T+
 aK4ZPtYdwyS7aKqpyor3ZgDQrScLYUPkipPyyv0qgfHVzOFNLlVRkUUdebioJulSfNtFOXiIVTX
 3Cp/Bn17X09EHrPsGdi7zYcURhnUFzqdSh7Sia4fgRJcJqEwaW0YnG334B+PatYo3K4YBzq5y2o
 8GCNtQsgP/fHHG3mQW0qyzdVvw7C1EdOE1QcDrA9MdhzebeQn/jb0fBlNg+avB4dKttqTFcI8Qj
 oI/PqG/wx0SNYdoKO+KTG3W5pfSlX1pBHdNQSiyloU44dv/I0liAonLwdbX0N+2GscsN6SO3PI+
 6XMNCffAMurXmMj9e5Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX4zay92HPd4cF
 scDcOxkKoEkccvtk+Y3+AAj6s9DnFSOsYURoriEnGpx9BO3DIK5s1QDaeS8KdYPjWp3lHZ9a2ZG
 9xCZjXBfHUw2TmmBw8UC6KGDVBDDLJU=
X-Proofpoint-ORIG-GUID: aRiU7vOg7pLj3dPAKiBQqdlYWK8S6SgA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 83d964e884086..0447144b77ffe 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

