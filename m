Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D84E781F;
	Wed, 30 Sep 2026 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773229; cv=fail; b=IYe1XvfhPMCg6N3G9xjfM+hPu2fO8g4F/BTnN6ANfhk6jn+TdapjcB+Jii3qmKVhikEFgCJVFmV3jSyXW/S7Bpw9zyAlESSNoqoPNiGRhhVJFaZJFuwOVq+uj2Bw6zKJ/HKTKtkDwHWGBgBrguc2/15UtKkVi+ssYmi9LhsiZxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773229; c=relaxed/simple;
	bh=xVSQS6p4jUtic3JSFUxPRRv00zrfweSXDgPsiIvTgNc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8zzj2eEULSl7OCAjAtv8HurIhs6P1/ZJzz1rFTQNLo5bbOelHbLhKVS1sselCMsB5S9fZl5sSErUV9AysuR7Mzv/vVrTueVgSsDaUr35cLx/2K2twsELbjyMbjmxFnT6VxhLtHSF6Kj2U/idDLxHkOuLUFXpTw0MEf95UXF/io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ZkQTTJ7Q; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=b0b8L4Md; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ZkQTTJ7Q";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="b0b8L4Md"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5ZWj2989807;
	Wed, 30 Sep 2026 08:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuP
	SE=; b=ZkQTTJ7QoLGaU/rb/Q9q0Yop9bwYtROfJQE4z8hYt71cVVEDLN2csl5/j
	P1VKVdHjAVH8yvWI4f7MHags4jEA02cp88x9OcftdmIFQXHGOe4c1EoToLQT50/T
	l5O1DRPQpYOZomL2qAoeEDx9vkMuuAbwIhbb+jVE/wEw37Nw8x1039u4Aldzta0/
	CetBbJ3ZuyzEpM9Mxr7QfbHPa2HuWNrUpHrHUwxZliBOD79P4ZLFqjrOZPx4YSc+
	E8+4ch7XwZvQTXIIi0gMtYXg76pRKiDaij+/BTmqJ5R6qagvY+rzwGAH7E6o2zw3
	GPpHjx8NmfsQ8qX1X6uc6f26LRimg==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011015.outbound.protection.outlook.com [52.101.57.15])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h10t1rq2g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:12 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+dg2aAB+VjgNprWvN1UOqb611G6jBXs3utLm3FMUm1aj9vLQsZAJpa8AXL/n0xs1D14ItX/vVDljZQpoDMBKlf70taPftWGCwrNBeXsB+0P2wo4uvmYVmSJzTctsTkhb3l2D2PYC83uGPx4QaMVnj81vsZ0n3SiY/EglC/kAB0iu0iK6kpjna/jef1FsH70DrmNUGkzY3XYYRzwfF/23ENH8IddNr9coAcZUWLUmkqA34cupsAuiFj53AF0Rm/NUi4zY6lu3K1bTagq5+ZlJYw0BCAfolfoTf2Ia/ObIyFr+wudgtRaZT7rpUzwiZM8ykTCuRtjDRTdZDSFD/YQhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=drmgRS0Zit9LnR8CEdPFa79ZBbetFHs0XDdBz/mGGTpv7If41FVTsPkmZjRM9GdlvmcL/rIwr+rdXBXOEDnxSXDo1UGLa54Ozz0iPkHojTnQArFz71As2pwS7M4QltDi/GZSpmc3eUFrNU83oaujI/XR56Fgfoj1TfvV9RO76PwcQ7xrAUoumkYO55cdLsLmWpb9odsLYOlmPLNpDxe+wppsqIVSh9+hO6Tk8hVSYzKPIcER3VVP/NodQ2Jo/Ik+BD5xkUqbMcOKM5oK4YzFv746tj7qaj4qw1nZvcTdz+PA6n3S8C+KJMNKtFNv5B4id0y4wTtH25yJfU2oNYXs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=801DxRBXzmhveIqwdJYn+q5sZVjlgAABeWzo5AvuPSE=;
 b=b0b8L4Md96rxb7pZHVIX60uaiJdGWuDMpqSndxljZP8YhLnNoQNM72nXuGANykCZlxchXiLD8sbdUO+qU8CCY43vYiVY84kDgwp6zUEoFuubQydeOb4/aeIjKNbGjYnap+Z2YDgqOLp26LpHpV1A97SQyhDJ7sUDhWSXqP8sal0=
Received: from BN0PR04CA0122.namprd04.prod.outlook.com (2603:10b6:408:ed::7)
 by CY5PR10MB6167.namprd10.prod.outlook.com (2603:10b6:930:31::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 13:00:09 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::93) by BN0PR04CA0122.outlook.office365.com
 (2603:10b6:408:ed::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 13:00:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:08 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:26 -0500
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:26 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:26 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxO5N3153906;
	Wed, 30 Sep 2026 07:59:25 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Wed, 30 Sep 2026 18:28:51 +0530
Message-ID: <20260930125859.1749849-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|CY5PR10MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: 391c33f8-33ef-4254-1d9d-08df1ef2c142
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sAQzvU00h+VUeD3qCQwOyBVZYdOYTzpTZmG6OjIa88dGlHf8/zIUU11aufmtpDUp85IwAC1JaB4AUGQv8+BbgF1xurIAp+6vkgx57rVI1ye1Z8BMd4HGYZduh75KYdR1BnzrB8J2qKfaV7PZcQJSCYNrbzsyOYXVCDxfdvuvSe4LbwnSMEUKqaAFuLok8mRrNNREMbsHFfPq41pO8dSnyFTqrkl7eR+03OQwaZ/3Gdl6b/nJ3PGVrYoZ9gE2G4eIGSxC1RfHA5SOKu5rMj0eOVdmJro9PIWerDf3u3hnHzc01mNEiaH76u0EUX9Qqi3At1v0OwMo1rFjswyMcKsDPrQf/LZxK+KdD7w1KbT4uz9xi4RtjiqrhR12fiF5J9PRpoO1QAS/MUBm0SHF4mg9noqE4M0oNftBVpc3DT3/+PCwZ0WwJ0iIYMrJsGQc9Q/cUBKuthUaGEgy3ynIeziq6S4EC9VvIfkuxhv/xNA5Ul64QEiRpUZsHQdEqbzneEVPCQG0n9bllTgqEqlpCE7liUI6u5irgoCRg343AZdr5pztIotHeCAQ2RBwA6lRV3v/l7R+d5I3ffKiwkpgDqXDzwQXOR6+U23nk7fWq5fwUWRNcFj6YoRsbBDuZoXv+5tgy4BWZ6cmcxp7P5UKZDZ+vkTYshTk9fvxKM+mue6FRGoEDz9Talmp0tMf0twchvEBq8MU2LGcq1WXzn7xgP8fxQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZbJskaQ0MIs21z+dFbjBuKPvlPY3de/YeDtvmqgOpgZQdAV20dhkPZfu5/8ggs2rfNEz3xBMnIz/uvvLzf7HdkcROTYIZE/OrK7Vf8m4N2YHSvm3Qxd7Zt50VD27x2YjnGVyUq+fUalZUmHD60Pp04actBKtpI+EPrFleGgDxxT83MbQ860Ligzg5zpi8QK46pnz5GbmSRxn/2IQWZI7DgzKfmRmmSWBicWyu9TLzqa5zhm+i5kbP0wcNH0mCSHoT+0B2MVHCvF6qMDIRCwfcQq0+mx+CG+F07Wqhj06o2623PR8uBSY5MCg/rKMTmBQyo6vQ2u3C6N5PDYyuE/juS94F+9cSOpuRoUsug8SsQMgMiGE84Qwlv/rTyXT2GUB3dohKjCN2spGmreVx2o5yaFidGx9djelfsDsX2oF2WUe+wEYmxxcn19neR6s5Jnq
X-Exchange-RoutingPolicyChecked:
	M/Ut6fX15aRtc7ZCHAwWb3LVaFHJLXPicbmfLhNNE/rsRqVuqlA5wVzpkss4OPQjV1iKDipBIxJeYqxb3y8UAhk5nlAPyf0Qq4qzUZGmtH6eP7nN9ZFjFEjV5+u9hym4WS4WycUF5BTOO5I9Kqw15B28lUbmQgmzpswYZpkeMgrjA5/7s1Z6hh9kjk0arm0VgpwR/djYLSnIVH6zQW1BJJ2IAVUkI3oqH1UyO7m45TPXvFMoETIxLbtyMCIUbZOlfdpADV8PvZK9z0YCzd22jEr74h0KQ/GpyY2IQTFrNvagm8i6/9Tl31oVpFvlkhgG+nd+ZTQtZ7DAeC+sRnft/g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:08.1956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 391c33f8-33ef-4254-1d9d-08df1ef2c142
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6167
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXwhB1jcXmz1++
 6q5p2RuL5N5FLXVrW20gZGcokF0TxYiUgiiPQXafbl80MxC8kdat0JGfXKxP0Om8EQoZrLkmB9I
 Q8Os3pq6c6HwctAEHuJBliIR4lBP9Ek=
X-Proofpoint-ORIG-GUID: b508Qni5fKvgwgFvI2u0aew3zhuUPJP5
X-Authority-Analysis: v=2.4 cv=C7R8WgP+ c=1 sm=1 tr=0 ts=6abd07dc cx=c_pps
 a=WZnQmSLi22PDpTVDJlFiDQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-GUID: b508Qni5fKvgwgFvI2u0aew3zhuUPJP5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXxEg7mabWv7mV
 6QC8FhQsWlVyxAMHnMq/UU3LG2hxeZifui0VMiFX+q1pRW+K22V+Lb12LUeOE0mn1IHVyDgsOn2
 kO5HaUmBskrU5uUqcEWKIWT55N1XGkFCXbswPheVnOqv9hefIMCEwezLD9JCXCl8UNt4/9rygb+
 /pYuimW5hs2e5KdoUlP7W4tHRYz/bPgJNGOTHBuppXyXQX6SrF9P6uU3+YxgNujieLa+baJFMbp
 ThORox53ie9x0ajFvcvaHg41LCsUUWldBslTlatv91WOskz2+YqfxR9qtKtMvrBJ5ea3g+8B2iW
 WOJWY1gZTMcs0m6e99gvMWRkrs809A0qSL9po+AzIYS+2vUD5X1ef4Yg6eTvpmha+hle4mwwvHb
 Fg1ChFuSweyAvlTv+Rv87jl6lC0+jdTne7fK+sK7KE6NTLTJafIcALkGSR48PRAB3h0psJm6wGb
 /Vp4IuwwqQPdAVK5NKA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 5be1bcaeee5ed..83d964e884086 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index e2600447f217a..f6e02f33ef106 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -109,15 +109,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

