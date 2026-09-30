Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC1849BD86;
	Wed, 30 Sep 2026 11:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767597; cv=fail; b=YVRSdObo4mzI3H9N62eZdCtKNsbYJ29MDDcPtFo+Chy70UYIrPq3CVbcAPA1OCp8JImFrAjce2Hij7aerfljVmb/F3vTgAH0FoNLo+mGvLKndDnkRSRydCIg48r5oJKVxFCdDZX0gWociS8qKoJusu9B2mw7T4TDCuByCy8Vrek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767597; c=relaxed/simple;
	bh=ydLNRxLvYGSWFwpMrzwTXE7dxZ6FLYE1vlENpnSMGuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pzGanWvlZMt7UYNUlcmeSiP8Ibu6Iy74Qb+FSKQphS31rK8QrNnC3nstweWQ90ASUqNCbl5LS5CDSa9sG2bhbCTUQt1YCWrgJ0oZIBVxxFPRiPlp+wxAqJsY7bRwLb0kSobBHP7o2Bgd9mT7TOirViBI2tGJm35p8dORDzpg5jc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=g7wHpP8K; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=KUOghsb5; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="g7wHpP8K";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="KUOghsb5"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5pFi3552705;
	Wed, 30 Sep 2026 06:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=hUpfPf+9sd3vXEiW1tnbFNVrpX4MM2SbfOaNaQ83s
	lw=; b=g7wHpP8Ke2lEKY2ErWz2zxs8tGY3O4F91JKpjkSV2JUMEQWwYGLMkYZWC
	clFDMpP498WnBTyKpyZpOr0tAQxWvxil4ldRvuodw/pBwmNZemk725OwDPidwB7w
	NaU1Sk0j7242XUdtmopojhgYquA/BDTGwYJgX2Cj9W+tmFdO1O6NSEdjr5L5764E
	nPtqgRgDkfuRggkEF7b6zUu7nbeK/7Zc0vlNmyMweAv13HAt/Udfuaer0oov4TBJ
	tAVatuO8wsurHywtqTtxfwhziSp791Ga01MXZWd5b/GpM8c0vqF60hzQtUkW4bL4
	elYXZsb2dttL0Ynhm3IEp7qabIYXA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010068.outbound.protection.outlook.com [52.101.193.68])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s208gb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Utnr9MsJsUyD55SoJF/e8YMxTuE5l97oUVpMf7QlIRH+w9dT60y/st+0WCPzkr+hEBk2uVVJZXEbqvbtdsnz4s4DTQvInBiKsOBen1HngRYiecCDwHinyyZF4kbSIKd1TUXBI0jPRtHGKUAv7PLZY8ZcdSX5mDwdEgKPEqqt+auMbG4UhQ/2RSKNGylB/p567JXqnmIfp7JQSqBnaUSwYXGt8KvYM6LHJEOnsqS4ptwq1Ya+H4kIrZmhu9vIHVKAxySwXk/xm3hTqew8iItl324PsSLAiz4uZeypPM8k58ZxGCm9vkAtpxFP97EXJAslugPoLRYI4B/ola/5RUPHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUpfPf+9sd3vXEiW1tnbFNVrpX4MM2SbfOaNaQ83slw=;
 b=wx8gLYez78No1HIXVuS73VnCX7rMhzzavworBK00/ofNcD+Znz2Q8xhrVcQU8rql5jBQr7cGZH+CJn86GssXUA0pLwNbBteb3zEzeLJk/bJuVnDJUMfs9q0/8akm3zMSbqf5BJ8XZue1W6pnqR5YiXsT35KG5cRCHOTiNkMowEfjcEwKa6yt6j0/kTp8LPXQXdgRlRCQL1Vv6KE++Viqkd1HF2Ydg9zg7Tv2A5KYTwy9dTxtUhIGEde7JgHzOhTfLoYDH39UgBbeE6TbQTUqrh8Gb57roEvurzDy5i1/QKSuhmZ54iyAzY90GBw22xk8eilPLiW3AnLMXP5UILzKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUpfPf+9sd3vXEiW1tnbFNVrpX4MM2SbfOaNaQ83slw=;
 b=KUOghsb5p7RUjzZpzKpwUBaasJjA5zqCSHDBoLA/csl2b+PBmR8q/M+a1PhoEsS9Mc4Wr+zP9P+Pyv+7d4uACS/CjrmvYeqloxikOf6KVBeMSL5Mu/MhwBHwj7pmuCrHP6C0kWteBALhvI1x5e7HDXKzTDdW2VbOwCwhsQvCsaU=
Received: from BN9PR03CA0269.namprd03.prod.outlook.com (2603:10b6:408:ff::34)
 by MW4PR10MB6488.namprd10.prod.outlook.com (2603:10b6:303:219::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 11:26:23 +0000
Received: from LV8PEPF00000065.namprd03.prod.outlook.com
 (2603:10b6:408:ff:cafe::78) by BN9PR03CA0269.outlook.office365.com
 (2603:10b6:408:ff::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:26:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 LV8PEPF00000065.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:22 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:54 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:54 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:25:54 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBPqU53969473;
	Wed, 30 Sep 2026 06:25:53 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Wed, 30 Sep 2026 16:55:22 +0530
Message-ID: <20260930112533.1593952-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000065:EE_|MW4PR10MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ace4d17-a767-4425-768f-08df1ee5a7ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	1WGqZVMIgkfQ0mDmPRf0hqepG5rwv27AF/8eiS0fZYw6jE0M9ffnHL3g2ngQv9iii7shEcxIzFoI2NUQ+L0PV9H78LDoEN7nf25pVEMAcd1hFNbkUkWVBloQ6CqrrsNnj6jzatao6SthYyYmIPGcwDvlMoKym6sANBZydZYaAhLVJC8u3IVt0SxxGynaCB8KZ03mU+H3h6ChplhNoIHWoGv8ZrZovx+YSEFDuMEdmwJwU1h+b2D/aNo0ObSvI03lqxUFD1+KPrOb4bBnDxJhoE7vioem1U7zKeEVygBk2Ohns8xEAXgRiMtQkBmAwtb7FIbIE+jAO0upduRaOVFiGZnfMSBeLSE4z7wxEBQ2oTtu1/+ZDhFevonsJwkNcJ9YL+klGLXd+lxppZIq2AbDRmQ9LnrMVSsTFvBEKPEZ3cnRKlObl/ktmsz8WoCPj/YVivApqTXJlQAhMNC16rrRq4NSqO+80jjR8S4Sg+FfqmVeNUDUnPyPtNxnjMM+6uQFY/BorCPRq7HIzj4Z4tnw8Tzmo1QAqJEUnE3OHzDBXCKDJTQZokzlwnnaiIgX3zV6SF+AG6muY2QRvOSy0NqxTe3ql+HrDbd38Jgo1gNBp3zSyDzBS4GmgtDspbg3V8buj8mb6B8/maqPTYe/YlwSuYJbFFV5H2eXxHi2mFFGGDy9Z9dF98EJK3kZIhMWGwls/slCO54NJnxf5DA0uPYZHw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Elzp8qGXzm6yPjEVjM4Me7f54OnjZMNiedqV0jOtjw8oVjz7C8QGg1qKUAOvrnR9XNu8RT4T9Z3l8zD25he8/oU7i8+ACVKILLiR/z678L3GUQSp3HBCSoMDxlQ0A0ujT6DKgn9b6hcwTAmVjE/HQU23svEMkOSbMpJvOIwDeiiw6q5PtPPlJ8VIaoWE1qHcKGBvIA+Je5wLK4ZmZj6aF64lYWXh2iwDZAMvpisRhx1yFIppXsoWZbD3toNkCWZsMeQYvWH86FMwmsS3fo+Ht/ebDb0zrVdw2yBD1kRUhuO59Rxnk+8qPmQwYIHfgfT0VsJCjDVTwc4gFWhH1p3hXUZbFaejTKx7+6I8HWYGc1KWgTTWQkXDndoDUHwkd7ulJrfuV/YWnD+F8GUaAJk8/VYvUIS6rvjBmajcDfG2hRog0XwjeS4nTd06qC2Vf2K0
X-Exchange-RoutingPolicyChecked:
	aci1MBLl0V0OGckfZSu3X06mSowD7alwu0L7gSAAtl8/yOvHJqWeNhy/5t3B4NQGoJDM0V7KmXCrpNV6/UUDG17O93xS+RoCaNCOdt07qeUv/QKAkXXP58Ke6NQHwWTy+izbUfl4xzOnMz7sOMxdKKZvmVKeHFfepTKVrLkg5LD3OWtF0/667LZDQUGI6xc5ihbfBhTy4QGkmt9wNmuP+EKHHqaHjgBgNP2Hc1BUv2HrzilWsrE5KdqdN2RF0tYSbPM+mP/VzdaKsME8yUo5kigQ+uxG55c2vKroS7GbWJ3wnw+NggRyhoIcq3kuwg1WotXYSWKdXdGzu1lDEJB81g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:22.2553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ace4d17-a767-4425-768f-08df1ee5a7ee
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000065.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6488
X-Proofpoint-GUID: RWfBloXt_0b_4nfPU0wIX2p1EldgdeR0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2WCThIG7VxG8
 kNZoENNh7DFIYGW4q3E8HE00O6FyEI8qIA6RBP334YZUb36jvoqg7ZZX/EeecAdbqIRgrMGmyqK
 0zXhBmnrT+bsb8+uwh458eEFlrLDsVBLzKXk8G5vJvBlJiOF5mliUWt76EZXB723MVFzNVa3Glz
 Z2HIEOFC4G71hUaxNOHYWUN+BOPEN7eYHFZ/M4U3OEGntsSjsHhEhwJupDMPXNhZ83nl8iuqodl
 7tSfUU+oxW/pvhaQkBNtRTO4lVLthjpdE0PcW5GY64OKMQo43iV0PEbHfbxSJ02p8Bnt2TUnGNp
 ecEXc3GP0a4jBOYEh3kjUwuvm/MJm//t7R0CYhlLjiKhklS4tJG+9ULtrf5AAeVIjG+y/8gZoNk
 uj5VbUK8sYb7+GffjWlhNep8emxtOVTLkYobaY7njHiA8k/7RcItUgCIJwSr2q/aHwzfs4KLfGv
 IderOOf7iJ/Ktr9S7/Q==
X-Proofpoint-ORIG-GUID: RWfBloXt_0b_4nfPU0wIX2p1EldgdeR0
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abcf1e6 cx=c_pps
 a=k/S6D1Pxv1bk3xTbD0KMJg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=dKsnx4Lp07fcoO5uZ_cA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX0grCYruijek5
 35DxFZAM1Fvd+IVilkT50O89/DR10VLosmMA4+UqZ6skI2yz8zojqfdyTYnqNJKZioSAA8913tR
 UbV6lAWdBARZDOb5dmbpm/oIXdjeFok=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a refcnt to struct dthe_data, which atomically
counts the number of requests enqueued in the crypto engine queue which
reference the dthe_data object.

A waitqueue waits on this atomic counter to get back to zero in
dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 41 ++++++++++++++---
 drivers/crypto/ti/dthev2-common.h | 53 ++++++++++++++++++++--
 3 files changed, 136 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 4fdd24ee91637..6a8fbe67ef6cd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,12 +110,11 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
 	return 0;
@@ -124,20 +123,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -149,6 +147,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +224,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +336,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +519,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +555,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +588,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +611,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +723,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +746,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +766,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +873,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1144,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1152,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1207,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index b8b02b82317b8..ffcbf00eaaeda 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -31,22 +31,46 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data && !atomic_fetch_inc(&dev_data->req_refcnt))
+		reinit_completion(&dev_data->drain_compl);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	if (atomic_dec_and_test(&dev_data->req_refcnt))
+		complete(&dev_data->drain_compl);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -152,6 +176,10 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
+	atomic_set(&dev_data->req_refcnt, 0);
+	init_completion(&dev_data->drain_compl);
+	complete(&dev_data->drain_compl);
+
 	platform_set_drvdata(pdev, dev_data);
 
 	spin_lock_bh(&dthe_dev_list.lock);
@@ -202,10 +230,13 @@ static void dthe_remove(struct platform_device *pdev)
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
+	wait_for_completion(&dev_data->drain_compl);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..0e2f5bc07afe1 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,8 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/atomic.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +55,9 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @req_refcnt: Count of requests currently using this instance.
+ * @drain_compl: Completed whenever @req_refcnt drops to zero; waited on by
+ *		 dthe_remove().
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +69,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	atomic_t req_refcnt;
+	struct completion drain_compl;
 };
 
 /**
@@ -78,7 +86,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +95,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +111,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

