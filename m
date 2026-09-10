Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFD5569F04;
	Thu, 10 Sep 2026 17:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063072; cv=fail; b=gd0dr6xnJbQ6i1+6kgmP/stUK+1aLFZ1jD6Q06woRqs1tI2qlSh13b6kvl+iOtsaIQoar0w1BEM5aOxctP+OMRawvQjEJzndqsSslqbWCcESeeK7i1omkGliHbiRW4/NO5lLVC9t84QMVbSxi/Nu5ZAuoXk2TiHmnMhuNuD/h58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063072; c=relaxed/simple;
	bh=OuWkyrSAYLpUMGWtwqp0QtAQW2fMadEqcmQ2cP2XYgA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tuCPmOe25fQ5hK1LwYGuKfOUIwdZxeoIO/Or37xh2izFYppsmW0PLYoDEuT47RHeonkpbzSQq9Z0sXGuugHpf3VpTUCyri6oUBwhinT+uQTh1q0tATVO6sZjzvtZ1+oDgerZvcRjuwQPpe3OH8GctiE4kcALsBuQ3L+yOLkkcnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=e7L4TRXA; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=F97mU0tj; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="e7L4TRXA";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="F97mU0tj"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGEbaa3808450;
	Thu, 10 Sep 2026 12:57:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tE
	ug=; b=e7L4TRXArqAgR+uoMG1YLZg5Bsk/T0Z6sKCHciokHo0trnTWPe5cC09KC
	K1xR5iD08o0SYPwBrdEPKEX/Egy9x0WsgKiJMFQPnyL1amDkj5eGdsbgsvH01XK+
	3cKDu/UPlrcq0baox2lEgYgn2Czx2z0Y2qsD18K5qd5OaJbmNk/AzqF6b5evytxa
	SltS5DSD2nqccB+OkGMsnJTNOcX5rfg/xOmhaODurQoOQkcpf3gfZXxqN0eMXyQf
	kyXbh3cw2iaTtaj+ezNAX7N2g9qIVlz/ZWFZBPFlzBTcRgNFG+1QVbfu8H4NA4xI
	8QK0Mf7hXL5cdBU2y318M61GHvDwQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013044.outbound.protection.outlook.com [40.107.201.44])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyw9gp4t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WqnjL0RH30Mhm1DN2yqwR6HXDFMxAkQ2lt+EMRTqKUP9/Th/jTxNDaREHl6vGLphPChcMrFm+l34PIlsukWJMVd3RFkSAAXgOYBFCLZzFQGMfGCgWvtp68NGe14hf4+/uPqit2mUkNXGyPoWmQy0nMiq8jDoGk7n5NFtHPo6aZk6M97BLkBM3kZ/BtSYNTVuOYtodVPJl5HpQ4TaNiBQkGtXw7atlUTy1gx8QPjY2pG1+b/tTPmAm+pkqQXnbMqB+kUWvO3T+gKXWn2GoR4WZfoUWtyAVp88qQCwNJiUfxjQUWNrh55GjANrjHy+RUGkm2gEV+XnngDPQeFSyRQgDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=E8ZMCFQiCaBC6N+qpfVFL+Qhp3YtatxMW4mUq1DyyL5ikV5SyQ+1WddRo1eG1LP4UySfHM4e5YihwhHw5esy+/5D8cZl0vN0vZzOWsmfUZgnMWIHHRUUloNyCMTjkzBT58u/dDw9q0ZNS8ELQVoHSkbnGUUH3SIRwDhulxYBafbzziHSdyVm7CejHMxxWuL7rd34MGReT6rztcSj+dD5YFV+SiaR1+zIyhbQT7h/rX064jhEiAPDjof+TD0dKhPLeayc1Yh4cOp4lARWxADxva51A+UscHvvqUggfffoLzn20N1e9kWqgJGHHrvKpTyovAePQSfJdZ4vJhs4DhaWPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=F97mU0tjiESsOKcAmSvprg1P+NMlfEQCqLfGwj89/zTLx350VK8vNW5hbp8X+pODFpntkb3NYSNBo1Xgev2QgEBgunKbDg+qCaPciUuQ8RlaONOiGK2lvg8X+WXP2zn1Q1kFgQ0OGzBsYhWik1Db/GI6Qd5MWqOkUgcmslPv1Bg=
Received: from CH0PR07CA0018.namprd07.prod.outlook.com (2603:10b6:610:32::23)
 by IA0PR10MB6793.namprd10.prod.outlook.com (2603:10b6:208:43b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:57:38 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::97) by CH0PR07CA0018.outlook.office365.com
 (2603:10b6:610:32::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:36 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:01 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:01 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:57:01 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHv0Ti2793863;
	Thu, 10 Sep 2026 12:57:01 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Thu, 10 Sep 2026 23:26:15 +0530
Message-ID: <20260910175619.2122149-12-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|IA0PR10MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: adf34b42-9121-4f45-7f70-08df0f64ff86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	+slTOL1zeoKpZn22cQcf6rHAdS0SMSrVKdisLnQkRqS4hWcoYfVx3TF07kqiSqVqcU6Ux1FckKlNMD2Emo5vp/rp+f8IDheOnx64iCGxbctlUCIPe6IHADgN3498cRZ1BQIkJEzzHn5BKbu3jhCLWCKqlXZypheI0yBDIqLB07IeZoxkv7JFuNOivwvKvR8nYV02DsjVUp63Mrs63fucJ1QLfATCeu5KvDN+zixPaXuUYW93Q2Yl8B+0wjW+IFLzfDxGa7GO5LR/JUePPJ1/noAsE5d+PfXJ+5MZ2nsi+DCmp8geIJ9gyNv4ZMdlrkIu3tnvaZt/wpfjNI6yvmKVRTumsP1B3GJ5dC1of90zPeuneBglRYr5sipVU793TQw/e8g6Wl12DiJ+U6zgLW+nvwRYzYK2jL93YOL7jbEie6UegbHkw9puR9ZZEncXzVslzHLCmU7R7cMQ6eNcaTXR2tQAO8x0OdM8jcwfmDHPeMTD4gNxiTbOfwbGERoE6hCTM5yD+FLA0ucLA/QdReZruXWmK1BTZDCzJnguij2wY6Mvn8ZcZ6JKF6H1khz/OaZ0WGg2q9dKlHz++t3QMI0VbC9AP4j7fqXvGBPCb+AWgVbUPCE7Te9mv/NJfM719S/O2sYiqgWcvdFRoGamXqyZ6sY/BQFTGNbxVN1v4TPnXdwoNyAa+C5+ApD2vdkDOH+rxmGWmcVK2ieSCXxt1/zzbQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MYLF9crGAFTZcABEsTGhVOcFH42L38QzJe46KVNzS3W9aqXL4EdkgXg/Xxy+4FYsEz1oTkOjIhSoftxJyiueqmHL1gjKtJalqaLy+5hhrFnGw13XyB8bRffRjcKPZ8dYpyFUwGaKRW9vVRgDe0YUFSV1q/uyGJCnML1qlw8qLzZHoS9lp97IacGAPYFPzWWaauom6UxEb/hKIFJKgEGNOeN2RHKpcVEVfGJe9tdcBaFIaPXmCNavwqkTI08Uhmu7wcNs8yiF4CiinQ/rlCrWE0n1iLHRQQGNJhB5gCb3G8qxMO9S29Ta26fGi57bP8OATzkSMfrJMZDjpznXUkLLvwN9GGbIVUX3+7kM/GeAtAb2otdhVd4Y1hWTTPzPeVo7JpADrv8zVjFcuD4KyT+CyzoQRHJ7R885uemRZesdUBVjpaZgY6XZFYWhMDuLqmqW
X-Exchange-RoutingPolicyChecked:
	unOCzR/pFQFJ4VfrgEgGZf6pKzueAvlU9jVb7IF0+WXt2Twt+/Ia5z27LKxArJE378mbV0CSwHirNUPv1lv6RcEsXZG/fVlXxZD4GZHjiXDjAY7CQAACtloytFokf60tzfeZ6J/1DWhXsE6UpUauHNHJTcEDxIetzhjt6lV3nW/w3s0NO9cELOlYUAWAbH3vYG7NBpefZV569IyOu+g/wB7l+nGqa6bVGlGFIwc9FmdAUyBz6qkYpqh3hYI+Ms7EHiec9y5qaImUx4SPyDXBjzJRtLw7HWRtNbhxEw8fL5b36Xo8az8E5uT4OrPwaquP5vV6jGhRNbr26/+4WfpTjA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:36.7044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adf34b42-9121-4f45-7f70-08df0f64ff86
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6793
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX1RXe8Qb6nwzx
 n0dx4m2++bWcSXz1wC6qyW/kF1FuuWQ4cOjK6o9eqIVCaPoZ8aMuZKxFp9qXWWkKgZ5dV/PBKxm
 U5mzsFYWC33E6dJZnWj/F1mouWNTYuc=
X-Authority-Analysis: v=2.4 cv=ON6yTiaB c=1 sm=1 tr=0 ts=6aa2ef98 cx=c_pps
 a=skQXzUdJ1yZbsxdDph07EQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-GUID: 9U_fWK6DFubD91lBWCtFOWnGRsyDogcK
X-Proofpoint-ORIG-GUID: 9U_fWK6DFubD91lBWCtFOWnGRsyDogcK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX2D8Kb7lE1TKz
 u/MZzuerrG77/2mnY9jBKqlHJMJmOmAHWB8O656CTRHHc/IYuqFNW7GnTjOSTKiUCIjUW4rdIox
 CKc9zEfHHAqNpq2exbbaYuJ+SoCahABvxJuCSkaUW2+YWmYrm9AzZ925kZakyjlfHHZjSVP8+6C
 7zUMwfItwI4LmvlqIVhWPnttBzZI4LszBeuX4j30DnbPyD1FjlaUP9dPOimGNFKD43arlLLSmka
 yTEy+MJ9AxEpZCe+FoqbXtwy8RIhzpDMXfiAdBOm75h6q3mmw/n+F0i5+TsHshCo7vBEV2cfRQR
 WDqAtnV+M0XKovdURm22HDGzEFLIMbHLvRPHQmyWqPRAhQfKRfBzof+zkCaTlcm0iPLi5G1NMIg
 p0ddSXpLiV8j1vf+O+Jj89RIn3IS3PnTvJ/85EfGrY4uZI4TF4pS2UyT0ByfrLp1fJxlZ2Kol0b
 tDFR9hpXE0PeyB22geg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 10073bbeca113..a034c1c8f20ed 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -912,6 +912,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1012,13 +1013,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1028,6 +1031,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1036,12 +1040,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1056,6 +1062,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1145,6 +1152,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

