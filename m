Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9D525A6C;
	Thu, 10 Sep 2026 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063094; cv=fail; b=Eca0Vm+JNZsRyjQL930q48P8CgiFr2pvjNjtyE80TfYnSxMtCmKyaeeJevJ7AkvVuNxeDJ3bjSv6F6vwF/1LYO9wP/iAevFtDYvc333c2EoVuOU5DZ4m0LO8dhrFJ3Wl/i3uV8fp2+BLEalzsG45RfKFedoFfecwYn2GhpWBhUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063094; c=relaxed/simple;
	bh=Xj5n2GVqsJvcefGEwXsaxhsOWs63LUfndOX4wp+k6c4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaJRQmNCdQ7gKkKaaBGakOLiLB2HMdYJQGeWewoGcsN4csNSHKaGX9CVLL4Mmtp4UslPm/m9d3rCaAZ8yHFQYEek9ZpUEpxeFC0DsoX9EknQ94VIcZ64Wt0LRDjaUSNx4n7ly5UHy+yz3n9bijgw5QCUjEq5MFuwjDWmEntyevY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=G+Jlsce3; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Pls2wD5C; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="G+Jlsce3";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Pls2wD5C"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGGFgD3546631;
	Thu, 10 Sep 2026 12:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29Sv
	MM=; b=G+Jlsce3aqdGPhXDhDjDC1Y9kTS7MnNm+4Mf9VNWqX89fPt5YOGi0hM7b
	m+ba57zn6BvXVkhFxWFJZM9jAzTCp1WFW64V+l9KjQsRUj5287+F5pueBF0BNlw+
	5uOkBTfwpt7OBY+qgIWSUNE5Kn613bQ31SDV2ataqZRACh60Vv1Zp57eVsju5Yu9
	VZWaD8d16zUpOMej+ZgAfcy91V78A+O+CsKcdgLRzQxUadzEwrrKOvJKmQyAcUqU
	i1y4aztKoOvZy1ofN2j0OXYAyKQya4wj5wPjBg4JuP+G63ziSwcxiKbCUSfszLKD
	rKhEH92Zow2MzoSNFznKyrIZJlWjQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013002.outbound.protection.outlook.com [40.93.201.2])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyx20nbc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:58:09 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoC17BtsmYQe2mwJELmipoVAzVwN1QJtTXXj7G55Q4PSmybKaKKIVU5qZm0woa+VuLElCTGyLGSxaz+yBn7P+9lCpyNKRVAAz32eEwCK+Geahq5SW1gcj5vnqSpJHKRfd8C0X5QZVv5HvlpLSYsq8tunZQheBrfySuk1aZ4QuLxvBe7MQOZIzZDxcsO8GvgIRkjZFT9/uClIq5+fTymq+w0JFNilKu/Pzs6ljCRS/mvBUq0oQRjC2vffPMGmtB6nD1NFdVKlulUnYuoDpe8PQMv0xR2Q7qqAbkTDsh3UJo+oiaJV8Q3BfSkmsc7sTVRbgC7gi9fyXq0qtBF3MOfquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29SvMM=;
 b=wRmUQmcchb92PfAYn4FKw7Alu2ialQxoriN2BqnSgfq2mRVb4ER4nZhnfF+UyDdwGsAr9yOJUMA9N4dQ1FHj2EojIOpXbqVhZfToZd2wDesZT9zdkQFsZFOyMiWFlkBxSFob6ryWrDqYq/J0ZksvXISbxYisZ+fblCEu7WFws0y1CAsgHCq8XYJU0IYsn0i+tw/MWMKcJprU4yxadyrjsp1WrjddQ2VHf0uikz4bY7wYBEpS76W2bAZl9TOT0MKTt7/KwknxkYiYzATDoNyqd0xb5Yh+xBtWLcjJ8sHFCWJSH1nsgPGMYwiD1QKhNrm+jWLv2zZanXvTZ794D8Yh4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FYCkMb8oUWMLmdB4yXRpk+rbOGGjOkqEpnuQX29SvMM=;
 b=Pls2wD5C3iaHpURjakoAR4B7UmaTlIqulyQnt0b/qUbz5j+koccGUIQ2l5GPmh7XY9sC7XMcMKhjzNJgIPZkLb22LLhd/AfbIRZCx7dcxLhuQnwG3Zru1ptCS3idbjbLEm+lUGxeSa1ppfM2QMgGQ9/C4qk9y6yQ3V6u9kks/VQ=
Received: from MW4PR03CA0065.namprd03.prod.outlook.com (2603:10b6:303:b6::10)
 by CY5PR10MB6093.namprd10.prod.outlook.com (2603:10b6:930:3a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:58:04 +0000
Received: from CO1PEPF00012E82.namprd03.prod.outlook.com
 (2603:10b6:303:b6:cafe::37) by MW4PR03CA0065.outlook.office365.com
 (2603:10b6:303:b6::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:58:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00012E82.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:58:03 +0000
Received: from DFLE209.ent.ti.com (10.64.6.67) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:08 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:08 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:57:08 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHv7WS2794038;
	Thu, 10 Sep 2026 12:57:08 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Thu, 10 Sep 2026 23:26:18 +0530
Message-ID: <20260910175619.2122149-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E82:EE_|CY5PR10MB6093:EE_
X-MS-Office365-Filtering-Correlation-Id: 578c19c1-fc53-42fd-7fec-08df0f650f80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	SWPWVFcLsdUHJJePMpjKWTFApviAaRcJoRBtErp0mks3YOy5kEscNqgVhR7AGuHymuAgwpH+5KDqFan0DoMXHcUAdsKca/sfzN/2uD19qeaPnb+f8+Xl1a0Mwrgw9WI1RKDfVbM8w012fkWMjk1cVepFGWZ9eJmfAKW8YqaKUAC5RMxrhTzrjm9UeABPyl31logoa6aNP1bCw96RUa1xX9VJJrBzzGO5k8/sZSZ9twkqNmWBr8t5ROY4zGgg5QiDO9GOrwx3iKGdphOnVzqnKwiIkEq8t9G+XfkluO1hHOoJrZbmco4l4g7jc5yRi0AudnzXeQ5XGE4bDDvKKhbL6ddDCEP89WoNO6QMOlBG/8vWluQUeHkpN01iqNs9NG7PHEBvpZfRrjnQ0r9NwAq74NEeLr9G/iCSHjXBA7e4znGwYfiY74TgwKdQczFyumMEbtJ8liNB9KggsvAT4x+pvPfVvazPht7zm9NYroHByxwGF99N5fv8fx3S8Q1FOqzephIJvL3mHQcOYe4QoEwArvSLRqgWKA8pl4crpUbcAprlupYN+OtiXJ4g+K9Kuum3ZFaq/fOzTRCsXvGul/keYsZ88pviecZLX7VLI4uUrbOJ1s0xbVjjLOn30EuQfQxdIEMlWhnw5rbrreZZi4EFFaHPGACSp9Y9cP/iOWCEM7HIfkTtg4G7LdcFCeDXwKhsuqPCodS7XebCWzRjFvJJCw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	duq335/WxjVcrI76RLkbSm2UAJcIA2KZFDDe0BbUX6r0Q8VPOZlR1iVcXmWUKgtoKN0oLe1HCuMOrT80e5Kyd9ofJCR7VrliIl8Zs9O1eVTR8m/+m+IxL3XaNopdSIXfiZ0GHbQ9Zt23sHEBc2qX7kt5yDFvlnfN/yLiL+QYwKRticlB9yeD35PUut7PjQxfj5MCUqNMHV0jG4jhkve0ros0MpUCaS4gtmuGmg1aFrqXxvwJqlN6ueYuJ5WKaSLy/FQUH7bFbYmP5mX4YTUv3UU0ZylFSYAR8g+dogspm8xBCwTVXBKyeJ7DSvgGplArch2Z9OQEOtHpjuYg+pN8nbDu+tHLv4DyQJl1he10lIlAmSyEHIHyJYJRpruWnbXPRwGcuDthOT9EwdcFid/zWl8aUI9nZ93xFwHNfKlf/fG9cefNuDVv0wTZR4W9wIFp
X-Exchange-RoutingPolicyChecked:
	MQ6F/AJKzsMx4xfGaXR/3KR9V22FjjK81GNs2hfgy1BmVMzC3ZlqZuSWa9qElcci59pTVFARuCi/AUAsYwFnT8o7eJzUfNYdiG4JFd01RxQ9NYIaWVhgmg/KnItVXI1XFrxLUm7+3qoHcz+3tR+t23eUAm93VQNZq3mOuhJb5L1tq23XjSIK+vR0YyMzpIzQ5g101jd9YpsXBq3M4gizzT7+7LEfWsbh0mqFgpxzGfKnolD3QCibB/U3/moZnHTOENBg+DrqozIlFEhBdsplMzusuecePh1pgmTYVUbZzfJvBZPKQxzf54IUpdto7Yn/2C5OksfnYAYcxuMKGUiL7Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:58:03.4671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 578c19c1-fc53-42fd-7fec-08df0f650f80
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E82.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6093
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX+LxjczI1DH6q
 SRpqjCCBGrn6R4nhv0ohvTy4v1s9HRRk7YnZrlGCoXkELUVTG24m7YPkMoV50NbKl/WqbmcuqEb
 u9E9yiAMo+4G08J94gL6wk1CuwuyrvY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX8geTzU3fWtJO
 sL2IHWFkmASFEaS0jCWOcxoOTyvS9QG3K1oLYf/9b+d15mY7tmcF5ndMjnKksl6uk7XZR/9bz2S
 Fayh8LIaE55vzEJKnGB4h1MBNM0nITaqjYIfPBSgzbzYo0XHD4ej8vfLwv8wAQto3ShqK15tU1W
 UB9JzhkmmdBUbOJjxkx/7f4Tcav6otS4+NevLMIny9tv2VfN3DWxVjbT1al4zg5gchEKhIl36VO
 O3pvN/202IEhuIB4rQevWeoOjK4JxDibvuOgnhn0tS8HkPgiHsWuLnvipm7upEBqVRaMHyKYCFk
 8z0M72hZ64Rp5AL58ew1rtVUJKz6s2fjacijdgoAbAHyhbwvqiDmt57RidXL/oBgUIJPD5A20va
 jrKDYqvt1naiYbb3LFYYcAyZoAGASAxZ9Jl2mHUymjls6U33XuS07eJIZye3WuG1e1+QM3xzJgv
 MlFykcmv+DXro7PHgDQ==
X-Proofpoint-ORIG-GUID: 63D2gxNp5e_txOo1mMGfXOsiv8SEXems
X-Proofpoint-GUID: 63D2gxNp5e_txOo1mMGfXOsiv8SEXems
X-Authority-Analysis: v=2.4 cv=UJ5Ijyfy c=1 sm=1 tr=0 ts=6aa2efb1 cx=c_pps
 a=IyT5loBvHZYA5YPQi3EYsQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 150ba73776aa9..9b982ca4a7730 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int len = req->cryptlen;
-	unsigned int pad_len = 0;
+	u64 len = req->cryptlen;
+	u64 pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *sg;
-- 
2.34.1

