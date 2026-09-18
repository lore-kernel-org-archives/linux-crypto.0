Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277254E4C2E;
	Fri, 18 Sep 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727032; cv=fail; b=RLwS5JK+8E0VNc1WjSPOkdCZf3rFpUDflqrqfbsblU15B9mHagV/Y4eJI/eKCQ+uqeN7f3rMtGm1hiA7PpSnFsuIthgMGuAzJ4DfPamwQd49TXR2K0obNvgqFUU16ts9Xtf207svB7zCgBRnoX4svZTJ82i579khF2ePpO4f0bI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727032; c=relaxed/simple;
	bh=OuWkyrSAYLpUMGWtwqp0QtAQW2fMadEqcmQ2cP2XYgA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzRL4IP80z+ozyo1bioKxa2P9lS0HJETJgA7BrdxvhqvveZT99bZh4aDmxKOhRafo2M53Qp9VQrj5Ry9bSvyTwOHvwONoSGEYabz2Wqq4ydlwmHa/MqWYB0Pn2NleiFZUvEtpMMcBshJSvFWB0/WC+qawa8W1JxUchlfcTup7B4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=EDahSSj8; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=sd9if7J9; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="EDahSSj8";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="sd9if7J9"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9dBpt1233793;
	Fri, 18 Sep 2026 05:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tE
	ug=; b=EDahSSj8EMhL4KaROVt7z5s/FBULZTVSa6jtwfvC3VUMLtuJqH90yKp1z
	nzqjGhWSPnpueIvRyQKfI81J98CT+Pu+7dzSJAE/YiQf4i/AJ4Vj5vVJUu0NiEYJ
	CEglxwTeLSsrBcz0C7UpXQ3OWpCL4ccyWoNdGppREdOvpAOGZqqqeH0A1bcS/E0E
	ZC51OLDb7TeXM7k14Hkh3VWeFNy4MDf2n/JjSrTnuaO60hzYMGf5J5kjLMYtEhcx
	FeXCAlHMkb+LRN/kwyZSHcmDnvHZc7S0qmu3ffben4vKZ0enfK3PIONHhiwgh/xg
	moAmWY2JHQgVqJYwfS7/GJ50UzMjQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012060.outbound.protection.outlook.com [52.101.53.60])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07c5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i3M+vK79Xv9VA1BgPo4UhFEX0VdHpc4rTevQRp7VyelxR5zwTP4oNQLafbliGq95zpS2a7c+7rg6Y2p5WdtyKAG3qzMBxkNCvFQqPfiU3rgaZ+t86t9JfV9BRNMg6Cr4cP8yUgna+5mpvXp9OqgdcAZd8enrHjZKRh8Eshp9ocm/+ZaUfYY0Stmbx8FAcDTz8k38rCAwh4qJJOhwtCOwW1wSQQSfMc525aar5T7Gs+y+tYVCYotEamCQD0B3rx0YkUeO08xKuZFtqgVf4VjEcvKp6/mbJ0jTHqi6doU0eFNRrL6FG6y6FRDVCn15weeaZHRB0TTnE1OHk7U4ynQJBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=wd7aTuBLal1UBhGCCXPtxHtu0cvnFSIkRKIRNp+mTJH3R3qPUsWeTEP9x8/4gI7EoJQS4Cm3vRyaaf9Pb2a0u/WqU+SPYt04EbGqWx0qmjQ954JgTMb1iJJseuCIJXsvkVyKV3bkP5UypnSIXAz+NpWIeHimsl+NNhOdbn79ADTKm/7hG5K/yEgXEzAHlYp3+bdUXo5S5F2qNcPYu/xg9aQL5gVLeXPl1lEGN04bsyl9psu4l2fvNFzPz14cV31yoE1HFFYLWPOyuYu82oPktSSDXHKHC8NYuN9dD+azjrdl33hhOJ22Kszrs0s2XmNx+P/DaCL9n6bW7ZbDvQ9D1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZD+OiTUMOfEPNZVRM9b0rd42p1/v7GDAJbNfg0tEug=;
 b=sd9if7J9dwIZ24V/YrvqeZm9cOeM2PsHO7rOmqt5wDcyqdi2WLTMRcTw1CtbA3nDeKikKRrOQSumOrySR8H4jvAZ3kFAJf2H2DksiGPNk961U90ErSif9V53i/WiUse9ZuOPCyf4izrDFybtDKBcP9mahDRNgEECY1EE9iphdxY=
Received: from BN0PR04CA0084.namprd04.prod.outlook.com (2603:10b6:408:ea::29)
 by MW4PR10MB6418.namprd10.prod.outlook.com (2603:10b6:303:1e8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Fri, 18 Sep
 2026 10:23:43 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::67) by BN0PR04CA0084.outlook.office365.com
 (2603:10b6:408:ea::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:42 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:24 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:24 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:24 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANM6x1534760;
	Fri, 18 Sep 2026 05:23:23 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Fri, 18 Sep 2026 15:52:41 +0530
Message-ID: <20260918102245.2784000-12-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|MW4PR10MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 61115e70-e035-4cd5-c76a-08df156eea49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|82310400026|10067099003|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	iyuTbiQ0GO7Orz1KdHoqWEnMfOKt75+gjIYFoYT5ar2a1zsvZ3hDRKo8UvVYXRjXdl1InD5eFaTGqZWst73hcCu5IL2rKK/3UigP8itSQ/uAXInSk3laC+236tQuJHpEc0MJlwOoZOXqj46nDqPsA3AHwkUoOIaZT53oVHEbmue4fwzzUQUyDMHcZ+uEjSuF7Nqpty+Lb5O0VG2N0424p2zMlkJWty1XUTGqcVp/TnxV16WQTAL/nztqopke1iqY7FQ9IGaJL0bIqQgyN46uKDNyKWIE4kOBw7sLukko7TdwQXPBktmFg4TpEX5sXtLFcllca865nP49GQ7oCSQ2k8M3GNuZULdPqJQ9ZyrEzmP7bQYrIcGGu+0lSxZAYcDKvSrzzhdhjcri4WW/e3RVByjf9+AH5FAoPpLBlCEE6J1FoW/wcKZEu1AoSQ//Qpb210nGBEyVJU/V1c4bNsl9GDCZquWkQ9WtX+1mUj6yAa87SrnZAhTq1T9d21U5BOIhzSeA6yAU/+i6cIk8A903PSB1pQRdQH/G10+t97H8xZCA1TklfgxbegJslbK2KmWtB4LUZVOFjySInlDDIVEdLao6GH/WQ+bL2KcJ91gkta0j4URV2IHEbBdxwM31DZi92/DsVdT4w1huyQ6SR1/2PAm3PElFawkp/zgDdbY0mIxCTxnT69V3s9Ia46/3PeijosWRgNLxqxkJrMcDidlY8w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(82310400026)(10067099003)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YmocAYeQDOoHXfuI1mBpFvFFpZrCh5dYgqkq5GgVpBliWc+OH1dSgXwVF3iqVoBWSatHh7CUlqwFB/LGoVuUSV+0Ct2EZ4DPB5kVD7/PTT1EbkmdbFS2kix4QzyieknpWfnwcZjFBxet26TNTNJpnELc0nEZULiCBY+SpPNRxqg36wkR/OsdizMfxQRPr+M1FHkqE39F9IgqOeTW0ToDashA2+N+jkUTIl+XAmHUnXM/9CdS/n5qbddU01xJzimjAZWB6rOAI8A+iU2h+lcZQJDZ+ojjpmYs3wG+RJ4+EOnzUb5yXAtKVpoXxe50NdijZXvNY+lMRN0xeybgCoBn/qnm8OT9bujEicrMawL3NuiJBLZpdFr9D5ncI5l02MK8m+XF4NT8tbAfP3dDn65ZC4KtOwiyi/CgbwRzDrSWWBMghaUBVsNQckgfp7G+ky0C
X-Exchange-RoutingPolicyChecked:
	CHjOq8T9R+JvPngB2J6p5APr2SWeJ9v5QnrRS7Ti2K6gi4RBc1dZqsPiLX6fdrbQMhhi/DN2O3NwEEpjzKzuOjJMPFCfB7dXF4hHHEP9haT9anbWE0wZDLSWIvEzh/qS+6x0r53g4nt61qS1CLasBLU2w7uqxjAUmQr9c3UJsmUGFeJ4NPrjz6ftJhQMqBUqaKnLCoQdr3uBrzSYDRb4UOfIZH+uGE003YysUI9LFiu4RQkSO41C6AQLfA2EnRPesWrCiqOZvVw7Ax7KCCyEB15bvOdtPrUhNYhdjX1nz/heB1J7alRq8sYSCjBTX/+Ge9nvkl+R8jHuZRpvaOHIcw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:42.9967
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61115e70-e035-4cd5-c76a-08df156eea49
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6418
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX6Mz3f8QYvjq4
 1vyj/Oe7zcDF/sOTJrI7XBAzq7R3t5JwxePNo2CDMh+v/6b3cKttqZi8uk6IBKVPg0rVPBQLRqd
 o20/wGwd76npyCirv3JmYIfqd8uttVSxlTdxU0LRaLOAdaq9bmTj8jPx7uTuYQcW1VEmxKv5Dtc
 TujzuQhtKHvZyGaRFM9OGgGCw4XyX79XDLlzZglb6MxYSOUgwnIusduq6X1V3J9HK8XBfQd++ET
 Bxx7tm3ZrHikLFtSJ7ytNflks0cLoZKeZUnwEcT9vf9Ph1UIleFC6AEq4cIXJEIDtGbwv8ulRSW
 6CgYKFP4xaGEtq9TA0rP7uhl/gyMQ2qpTiRozrazk/tMWMMay4gR+ghu5TTWQQ3yF7xdRfvPLb+
 X23pTi+Yu+G9lDr6H2HzPbireVmaxHHdj4ieVSHQv5DcVI3ey5R24E/NIGu5YuRmaCsKLybbqPz
 1jdC3+fmCF1XQ7fVY+w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX0PO4fk/iRPA+
 FWIu1khq1IvzykE1DzYttXPSVj4DlhW+BWp+2RtVKxSJ71p1lGp2WNbnOryemhiu1cMApSyYnSn
 Vua8If38JWeKGBpoqgZdu3/7Wvb1gng=
X-Proofpoint-ORIG-GUID: BJJwQ8NfRcQ-nlEuZoHMRUEao6T8vQgQ
X-Proofpoint-GUID: BJJwQ8NfRcQ-nlEuZoHMRUEao6T8vQgQ
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad1134 cx=c_pps
 a=yaJUXpcFNTkE3gTvo4ZtIQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

