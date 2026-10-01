Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAAA4C10C6;
	Thu,  1 Oct 2026 08:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844833; cv=fail; b=B2l5+3AUNF51LNFyL0bZ4qEVCvt6uEjWN7v/TzQvaZ9+2d/SbR8k6tNpRVQQitClhTqkDB6BA0RhH0x2atcbV4930pgAoA5eNmizBIBulIiCgf0KiQaq4Z2WZrSzWZaJK3L+FRZ4GRbWlDdUwMOOTX85SMWZzPBjLe6OlFu22gQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844833; c=relaxed/simple;
	bh=8VrYPsT2wAEHmqwJVZKMssc8/7YEcili9xvl2vVGykM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kwivj+ytv6OTzzf7cTIC35yLM/Bx+Wi/bKVBXASseJ1J/ytqXcOHPiWudjqmX/iksJTrKqAC/FRIBLyOg7D36wbAPtHAqOGbUh/GncHWDPnOOAW69meaOBPUJH2lL4+SRWQCs8Mt+5Kw+CNp0CBzSJ9v+49gq3zMEzTQMcYGwUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=iNGjZSbV; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=IcIixJAT; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="iNGjZSbV";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="IcIixJAT"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691711DO1294630;
	Thu, 1 Oct 2026 03:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s
	64=; b=iNGjZSbV3yJdoN+Dz5A9j8HwGlu28xkuOjDN0g/nve1KR7eAKRKbI+Tr8
	3UBn5Pw1I6e64iEBSEBA7xWfdMG/BfodIvUrn3DMc0JK4lgyCGFmmuG+4ZZfUPH3
	UhJOLHWuuTyT4uNfdQbo+2pS2mY6u/92wYUKgDnYIjDts8DRZmwsYfrxeL2Q75Ek
	umNXDq5qV673nRA6PEUZmHQlxoP6tfR9EE9rDUkdaWC1NtaFrJUHgBYn5nrAKMzI
	oiHM2M1Hr+d+IUqRQbFU7jqHt1wyg6M40F0Lx0tQnufLJ62a/KtpaLtlPu24YcQe
	gtXk9FdtjMnmGoj134XYe7k2mvy+Q==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011021.outbound.protection.outlook.com [52.101.57.21])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t3s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:47 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PouEbS1y1nINA+GFeN5EPBWP4gKV6dlMaovyh2EK3GT9HGfS5ikAUSLqpZm47vcBdQ92YKz/neowNRzZqHLODJFBAuvO/NaZg0LmG6+RclPtfLafvMh9/+Fy1AbS0g7InPqLXjE3c7Ll4jiksq6cJKZF+fh4lEfH5dHVodc9Ay7tANNfUVB9I0UJFj5xi0GdrprhZDxA0e06FjmMe7gr/UgJzggwgrQZtJwQiGCIgNk06wCn62IuEqwsK7FDPSwZMp0ZErN/4lEUuAiiOy/ilhW8N2VNuHMGZMruhP7QXz2qBJfhgRx9zEvO0Us2exqU4j3L9QoESrYKz95hekCJBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=MuFmhW1g/C3uH9QCeCwuLbAzrCPdWAc+wPtl8kFrb8yxqYi+5hNMlz8Fs64F5VEgi8DC8AT8kUi7sBuWgFF1b/HEbEMXmIN1q/2Yc+fNE4GzmXuBqn2Xf9lPzItphDD9EhDpT+XHxKZruqo8sGfxkDFPedyQgq/wjSnT8xDVJbyNhal6hi3jfE0DXk+qe5IdruCDKXWiV9s5QasIxITsTskoV+I0NQQL01RxmxFLrDzf8v8Fox/tuKzhaDaxtw+NYEYg5o6PthyjAh/kj2uSuqUWL2cQZQeR2e2+6iMLQvg0Y+go1Kpy+52QijzQ/9T5NuIjI3r3Yb21X7HJDdEtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=IcIixJATmBtnYUcaJarfpJ0OBfYo1UrnsaaQiU57hY1d5UitvpnzHPov+qsSBPi49RSTatEqfk1NytvyQEPQld1s7SjVT8ffoHcf9vT18T5ssDAhPrWaaenMzArU1yR6OtcFhH9pZ5yEkq8oyjwDTOdvuot8mVPZblCpD29rDyY=
Received: from CH0PR03CA0261.namprd03.prod.outlook.com (2603:10b6:610:e5::26)
 by PH8PR10MB998089.namprd10.prod.outlook.com (2603:10b6:510:40c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 08:53:44 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::8) by CH0PR03CA0261.outlook.office365.com
 (2603:10b6:610:e5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:42 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:05 -0500
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:05 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:05 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918r4cf648360;
	Thu, 1 Oct 2026 03:53:04 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Thu, 1 Oct 2026 14:22:36 +0530
Message-ID: <20261001085245.2922974-7-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|PH8PR10MB998089:EE_
X-MS-Office365-Filtering-Correlation-Id: 19311b96-b591-4de2-41f8-08df1f997ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0kSawMfdiBC7q0g3/09DCyTbpqL04GMsRspgpw//vg8/qYbamXQbCSzK2SWOCOJgT10+AKGNrPNmRYOdmSszF2bMGBu4BVQfRhw7rVuqTtdn3lzY8Q6SwHSNaFKtpvIAdHPHZm2yHUgDP3fFo2KO++kvGKEVyT0tIjWOarYTT4AxhyCoWeCi9HpAw3Mj0XAmFhTCmMpoST/sGKp7QlqrdBM5PE1f2rzvhHl6svZOxM5NauZandAH2ns0a1U4cv9Wi8PvhjFZ4Q1we1/ou9uYtbdGx5q6HFVw13AGk9zxc1dEa6LQj3vYzMHu+Dn3+QSbhyyf7FoZiKc7Vqm5Sh6btjmudYf8QygnKiCZ6Lu4ZfSauj4wvMxXk/Bx7VV//4IQ7EjfP0O4BvoOScZ+CrspIGHwJXFBr746skOoFXbUz64KCK3ljU75Dv7llwyQoraIZcEokwFq3W5K5PdcbP1v53aqVyhSYFkOYQlPEMx9BZvf+nUngnV3I3hy1hiHvaOC6hUZUuaMMJow1IiN+57AphnJCcgOClSOmOpzNw1KP6HlX3UuCZBrkWlRYsPvhY9zkzMEtyYL/teL5MrKQqzSbhyikevcr4h/pcxVesqag8YizsMtWdSEHqKPkodmJQ7vpZ2SSloENuh5UL+B3/z1gdh85Ral43BlF274stiWt4RENM5Y/Pt5LH2EyCqon63WWJVsC3MQOHN5EDu8f/PO8Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WHmz6Seg1nvp3Lmi5C4yHfLStgBmb6ApMHcwt1bY5bD+33Q05xvGd9WnYJ3DKNiUtLTmOCK7VS6xIYIBqhIPuuvdPa+rwSJoshz5xtzHt4UlC0ISU9fBqHC7nvw925Dj4oPBPH1I9tu9GCgCvpk8/upaNWjR6rWh806w/vl/FLjsQ2+/tuTOemIsVYyRJcNYcdl74qveKO7r3N56U31FkK9YYG2wf+MfVEEUipoSVFNkcy4ZA7bgYL1L97K8FjTJTHD7DcmN5W0pBsX8CHKbWRC1Qv+WkuHLOYrME8+3jwfTfsnWWSqh1iLjGS1H4WUaD4pPB74fUtpV4TaE+7YmfuuV7g1OWX15XjHC2FXIyFGKh0/8gEWO77iWQcoFDSaaf7kRl3YEgVLjIyntwSEINoDJ01EUCSL9HZyQ/bJqOPdVMHznAmwT1qEwkhI9HL+g
X-Exchange-RoutingPolicyChecked:
	odlLOX24Zjy/Mw4KgJEH+/7AB0ArwMYQatHYtLAulTlE2WwYsqtxwRYV0P1cbwpt45KAQzjNksH9qCUXePTqrZABU7p1P+wZhpsJOqyZSnsU1hSrmHEhUvRwH2GmF3+mdmtv2FkkaNhqaOLB5Xa05gwEyiFn8Q3J8ksRxaNhDrSc8voxRbRlZ+2+bFV1tqqQDY3uE07PKZOFWzSZ1In3tvTVgF8jNJjo/ap/xGxIlwGRLBTLQIIQZ2cT+XQHencs5kjkOS5fsQqT9g3oXDTuRKLRdpMuQRPl6nyQwmUxOYe57ZK4V3LBnZA9YquYGtyPextjLh9X3GgEfPaMyU70cw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:42.8095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19311b96-b591-4de2-41f8-08df1f997ee4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB998089
X-Proofpoint-GUID: r0LwiEaDPucxEOl9SRYoRqCjWfNkvGLc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX/H2ODfHhbGXm
 sLy4AVCJkHoIZ4a0gIYAefH9u5dt9n/KCj8LUr0orxPWK1pW6JMKqzwQGOn3aPTrWz4Lbv78Mvq
 cbAm4oE9ryqaWjxZReiKBqKWcJUtn5NRVKXUBA2ULr8hfzANRBqSwz84zJMozy92DkJ7KokO11o
 1cEAbJTqMAgtHYhYevTAGM250eDlQExKcp74Q4DDXOlpZ9DxKgUACJ9eaaOXkGcHM8za78l9wjg
 bi8a5Ij8iyxlMfp/goQI6TOtWZAoBqFoP8WtM1hsRqPDkAQEXi/rkFX1vGzC8jobjZhmVrA3NnS
 A3OtOm9liWEfO5iw6G6pF4WUIP7ZHpcv96yfbnliP0P9V6lQuZ5IwvzGmOhShhOh5pYYYxRHUXX
 rpK2OyRwZixAROyMMA5ESdAUEWMwnwL6m4GY93zVLV7JAAZq45LuJVytRQCErTmocD6t8dkh6Hf
 WfjK/4L/zjK8aTCmJXQ==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1f9b cx=c_pps
 a=UGDxSQ6JIm3CXF+tY3HRSA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-ORIG-GUID: r0LwiEaDPucxEOl9SRYoRqCjWfNkvGLc
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX9hy/RILVqXpx
 51WjTCQ3WvZKnP9TfcYjQWagYJZxa0LXSSc/UDXomrE0WhinXHy+t9m7hiswWwiyT47cCMiej6o
 c0RxLfm+sfO8/JKHtgOBZhpf5NUb0wY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem. Add DMA padding to reqctx and use
req_ctx_dma helpers instead of req_ctx.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 46 +++++++++++++++++--------------
 drivers/crypto/ti/dthev2-common.h |  2 ++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index be7ec62ab2513..5be1bcaeee5ed 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -298,7 +298,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 static int dthe_aes_do_fallback(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
 
@@ -314,7 +314,7 @@ static int dthe_aes_do_fallback(struct skcipher_request *req)
 static void dthe_aes_dma_in_callback(void *data)
 {
 	struct skcipher_request *req = (struct skcipher_request *)data;
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -323,7 +323,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
@@ -515,7 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	int ret;
@@ -560,7 +560,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aes_crypt(req);
@@ -568,7 +568,7 @@ static int dthe_aes_encrypt(struct skcipher_request *req)
 
 static int dthe_aes_decrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aes_crypt(req);
@@ -735,7 +735,7 @@ static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
@@ -755,7 +755,7 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
@@ -836,7 +836,7 @@ static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 static int dthe_aead_do_fallback(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
 
@@ -852,7 +852,7 @@ static int dthe_aead_do_fallback(struct aead_request *req)
 static void dthe_aead_dma_in_callback(void *data)
 {
 	struct aead_request *req = (struct aead_request *)data;
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -861,7 +861,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
@@ -1140,7 +1140,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
@@ -1212,7 +1212,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 
 static int dthe_aead_encrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aead_crypt(req);
@@ -1220,7 +1220,7 @@ static int dthe_aead_encrypt(struct aead_request *req)
 
 static int dthe_aead_decrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aead_crypt(req);
@@ -1246,7 +1246,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1271,7 +1272,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1296,7 +1298,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1321,7 +1324,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1349,7 +1353,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
@@ -1374,7 +1379,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 0e2f5bc07afe1..e2600447f217a 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -115,7 +115,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

