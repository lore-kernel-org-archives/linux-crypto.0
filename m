Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758AC4C650B;
	Wed, 30 Sep 2026 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767616; cv=fail; b=X4+MDcJzkXcqvxkrLa1eqGs3trFooFA/icDruWGsf/ePULJX/DiICYmx9rJEbfZ+11QvFRMqRD4VYAdvkUTgcC/AJMVL3XouYjDj0d+MbPZQXemuZzGQ3r15uSenWcRQF4E2okP6zrTkuwzz7i0bMzWrBTJRNrSZkk3GJGRIeL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767616; c=relaxed/simple;
	bh=8VrYPsT2wAEHmqwJVZKMssc8/7YEcili9xvl2vVGykM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoQ/tpim/xPymnu7QLxGVwzv8FysEgnCMTSd1rMOKQKaq3cnfSBuOuQu5hUPM+CdXY+y8T9iAODqpnusZ1Y+ekkb/BdpSnko0N7hSRFrWvluP9sN+jk+A+KDjUxXgAxMlNqcNJI5BgyD3ZN2Jo/j15zAo7vWvZXmozCaqZ98rvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ahqSm8HG; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=TyneO/jN; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ahqSm8HG";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="TyneO/jN"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB69GQ3214260;
	Wed, 30 Sep 2026 06:26:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s
	64=; b=ahqSm8HGNFRn0wkFWHaYt6odN1Cbe/+bjihmygm6taQSE/92ykxq927Zf
	PEQCC7dN8N1HGU1oirNLK0LAIhclv2RLRjisIM467kT9PuNA9hxj9oOwcPiMJ+nU
	rzMlCxVEtL91Ig7D9mYtTbPBcthC6Y48Zf+dBJd1Rd9k3ZLc6VW3k+d6OfVOpNcf
	GMVvSH92+l//RCTpar+iRs5ozsn7hN4kNuUmy0X6tet48u+WCIaipr1d1o4Y11LC
	i4WAJZv9KFkFV6R2GnWpq/QkNPKT2Au9EGjVeZWSkdr8g2JkbnaIMzaHHsFiFTjD
	6IlqLotzqcA64E0DY4PvVHA2cGrDw==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011067.outbound.protection.outlook.com [52.101.62.67])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv8q5j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:48 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b9n4qAEMHGkyS9F4uZIup/0S+1PKhlnV6XQTUMlQwmOaD6nUdfr0HdrXtyK4DIBeMbMgbzHjFCOcmzPKRFYltaXhXt+VNN6J6emTu731NGBGrOnQe7LMUmELBLcptd6X4CP+pPyglELb2WdY71EJ/PzTqET1ZpxZ5fM7PysZK/YPjhQCXqLwyO8VZNiUWH55qrYDIktdZi775vpc0bkP7U5HEs8D5jK5JUKQSzpq46qMIsgIXFGhx0JLoXYaEUXOKNa7rXm71mQRp9stBN9Y1Vw/d+Vet5C9UB87VZhq0EXR8jR1OaQrzKrJW9lprqDgz9eP83ut9zXV7r+J9XC78g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=KVKMKejvsP9Zur+wzHigGEv88rQrNAoWFyQhLbSEzJgTWJEEEFqyMjr+koY/8Z9DBCLeD3U6xsj79GGRaf0Ej6+UxdSKHRRZUz387sm9NQ3+k7/Hw7HzkmwJcvPISn2qJZPkQ/DmA5YESB5VfLjOdbfhJocFeMLem4RBIsakXwM8lrrIjY9/9bvs2iTBMGA09O+kmLG60+KV5xNNWfeyENecM7tg/sFcAziHJPqUUTMMjFLRKB1DT2c1FZth1ZDe9+1Nx3C18BNpUM2KfOxL8dAWBdKYYebWDAe3H739kP3JLEVxlV8skzYEMt/0M0PLG6zZqgCy/jhn3KvaNKEqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=TyneO/jNf53BjjDNXMFksIvlY4fOzGjyabOZ94rHrRUzUNuXRscu259B8WXKERAF/h8Xpn+8KTsVUivBRW5m/SWBkx9P4HnQ0ulCV8Rm0mMCinfDJjlKDk7y2hBNkwiLgI4ERFdA5V6IzGfZsgrftJriTAZgNPPFFF5WGBnlvMA=
Received: from BN9P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::33)
 by LV3PR10MB8202.namprd10.prod.outlook.com (2603:10b6:408:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 11:26:06 +0000
Received: from LV8PEPF0000005A.namprd02.prod.outlook.com
 (2603:10b6:408:10b:cafe::a3) by BN9P223CA0028.outlook.office365.com
 (2603:10b6:408:10b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 11:26:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000005A.mail.protection.outlook.com (10.167.245.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:05 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:59 -0500
Received: from DLEE203.ent.ti.com (157.170.170.78) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:59 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:25:59 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBPwXn3025206;
	Wed, 30 Sep 2026 06:25:58 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Wed, 30 Sep 2026 16:55:24 +0530
Message-ID: <20260930112533.1593952-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005A:EE_|LV3PR10MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9d5a01-d7d6-4da9-2d13-08df1ee59df0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZVdaURk3xGCCN/37ePs9+7v6BajuY6fVzbbCwxyB3QIml9gLRgfoABMk9RF2saTRBsG7YnNJCZ7xeiZLxK17nlEVAubOMDPC1m0I4F7MsaB3uThcfnlyiVdBPmpR20/VQ4xDQRr0RPeiisFarYsmY6eLi3tVDNG30Y/GCsmgAfHyU3qp5lnVk445td+ly3cjMLg1325cTOwV9o9+90ZV6gAgyVQDtQDDKX0CD1WVepfnj+qO+Y/WFXB0a658T95baKcbIz+VIYuMqrMfhN0Owwuqv/ceQuILz3ujs66ETW29rir21TZBA+9NB+NdBXAsFgrZLTGFIoGHa2ko3aWOyVFUTgnZMNrrbpxdnIEvAQJ7wNbRqWUL9nflnlWekLPfKjLTsE89RVe+r9qAXEPVnUHTCxKjN6MOfeFqoMt7bt2AjEIGbOChFKlCv9Eq8BDOiwm/729l5jAugOe1sPasXydxbk2Id0YEgYmJNlyL5caN8ItU5FcJm90Wm/qsNWDvwdKbbLnzLU5m7E8YHrEDGW+f5o3fdQ9XNDvnviK+ygdf+ANb0AxMHU+fLu9ysD/AvojMxomm7sTe9NMwnCDfbM4RULBpZlViUDVD4TglozYs2Hisd5EQUjzVULK8wNbwTIeDmiRPya9fljJ8w1KcRIruEXwRypORrDykR1vUE1/ejneSuuAmoFiaiuJzr+OeNf1EY1dppjFCPD5TYqQJpg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T7riz+v7pwvtFsIQzApl3Gt5cE9Xy0Yo+wrrOMlja0ONr+p5ScdGnNSXYP1045IkphXLEN4fT5w0GXWEDx7hQU+ydJGgpoOB7yrabs1pFqA77nhtK7FRkJUkk2ZYD8s1DjpUIhydqp1geUcsAzLlASvrxknecjPLZ2tPwjbyTYK1UqeiU1S/SGNq69b1wHl0PgDlVIsh2L3+LW9X/28vciszym2Xhzyxv8vygk3wxQZvyZ3lHQlg52+uwSw5snQliTyDzx1isvZts64dTZvPkPCFQKE31s9VvydfQgSG/prC6K4aL/qKDQFSg4uvG9w7bUZu1beJ7Ug2RHvqGnJzhw3RX1vSXPttt5qO3F3AqpzHz+1Ldq/kY8Iw3h/A2h7zbhTORlg45F0bRoMplLpiWLZmyBDeSB+F/E1aqVRk20WQb0uLnqL94u6CzNwwpdGH
X-Exchange-RoutingPolicyChecked:
	UakMKZieMKt6xnMhYy8PVMwF4zs5q4HbQGVum4wqmbAHZOswHEFG/Uop9wI6hetulzvKF0MxLPSi4Obb9IIg3iGwSuAAGV9k5TQ/qz6kMGiN98ywxjargcVSFmJwmVpIdYuKYfZZigXkB/+lg9nwGuOyUD9l41MBSWEui1tuR65KZLcMtBBV3P1Chf372VnKAnhJIZchwktpO0/qyGGHMouM62LCkXjGew/YO9MhEcof8z8D6iHMRlSJsf+4o4tqWl9vfcM9p+aOal1Jj78M93ZhQoG/ais7sAJsEWiCHW7VpBqggnl+Z5987q6vcU9SMQcW7HVcqjh2KVD2JmtphQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:05.4790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9d5a01-d7d6-4da9-2d13-08df1ee59df0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8202
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX81kk8n1dIy9B
 0b2z4VTbN9vHZILArHi4GkMT5w6sEU9EIkU7M6ijrD/HWH15ygIs+1H/CUli1aA0ShK/0BiGjf2
 WJTh/VvKnzBXDSrSWrWmwOfGqPv29bk=
X-Proofpoint-GUID: ADRXyJyCp2IftJbH-kMdelr6IPp2SK1J
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abcf1f8 cx=c_pps
 a=GcdpE1at2Es8HfJfZlkF2Q==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-ORIG-GUID: ADRXyJyCp2IftJbH-kMdelr6IPp2SK1J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX4DCHrCaa/j4b
 RzZ3p7MR7Em/nIpI/GbXF6Jq7COHVgU4CkcSy8pC3nND9coQHaUd/Qu6btvnWzmvHg/tilMj7iN
 XUr/ZcCIJtbX/6ofksJu97MXQaPdH+qu0azphZJGPnZ8ROckkWU4OPGgUDnA0VOG06Onvx/1gWI
 uiwtkpW86/ch8gG6b7ksZ2VnpFA7spEYqSvbAy3HqDx8v1moQtBEF5UN0rpR+Ski4GwPx5CSKjM
 w9+qRcqxOxtped13z96voFORwICtaqcELlN7p6mUK9rOk3zUpEzNhzJnkwe5qp1NAhaPcm40MaB
 Zo89GAFK/bFI57oHqD86yQfaoA/MKP0agKWPmTEIJidI6imxYqwWL+7rwXGMYemtPit2yeQAARl
 pBPs9CN4J2THugT3MVNV0whu39x3dO3TU6ZBsylERhE2bgCzFyc5vbCA2bFSKI2EkJDi5tyMBb2
 7YN7IuuS95XX8oWAMQg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

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

