Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D93F4B0CA0;
	Fri, 16 Oct 2026 12:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154803; cv=fail; b=LaFGjpmvgP/KUtHSBeqiDBTfu9nqpEV16vIOa6ogXJfK80wk7ZdIZUR1ICkjuD600zIhgTostfoJU0KuouZC+Cc2sbMomp8y7JZfMD8Lk0JadNgZapmfiMs7q68czEjvlyXl9PcX/p57d7O+dVxoDJx/EquxGbMJ8hGQRfI2ME0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154803; c=relaxed/simple;
	bh=oQcv2pfVE0dbAsyh89q3x8jqUOr6UhAZWgfc3GjJRdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIABBIDPpQPoWM9wjHb04XQqaubWRB83Ajv5IfzNxvKq0hxxf5eQOoD7llUVKppplQl4+MRmsxa+rDhPwGppv5mGE7t7CSlvQDnN1DjQukYcIJpzTIMPBWlk5/In+cJ3oUEOsK1/wbNJOvf1KqE/PC5Uq3jPV5jc6yL57LbEn/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Nr5sYKkx; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=R9XBrwZl; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Nr5sYKkx";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="R9XBrwZl"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACpvV559807;
	Fri, 16 Oct 2026 07:46:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=Nr5sYKkxzyneabO8eZRpjapVTrIZ0bkTyAAyss8M4Kmlqf+ClHoWXCFNd
	pnCjcRuI9Pwu36EICHqqUEHeHag5WFx+/kah5blCw50y/S45V0sZK3b30tjodhK+
	pfe2EuBhsa28GqiWCawTIk18GC2gIeIy2DslgVZj4VykTzC/47G4XDwYgcV5XJgL
	EZN0MhckY8AJgH8ljy8NMYLN6gd3qbHHUgIHkl0P8yVoKssYc+EAi1r5oakeIW7+
	K13qztS/00Cqa/EPEylidgqaZkw5pMUjKHTq6tmPsFBS34B3xgUg0LJSbBfVIWgz
	ySuwMv+zCCqKdOXeBqBRUsJTPlVng==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010051.outbound.protection.outlook.com [52.101.201.51])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8sk9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w5ZRxcws9StKX9nI8kVZpBWu87ShBi9bjb4jIvNHLqZ1m6U+jIkOnPeEzcYuHzYRrPGGUYxaRUmIj0KXX0xwIasYUmG4rHhSXeb2/Zl6eCUey8vB2NJDorQlK1/a0i7B/9IhfH0oOe9ozbW+3JsMuo5OPlK/LhIUzAqgIjyWGqK9tz7Zn3ORphJ2qqtPaIH03LcMztqcAlZvOHpk+kUcb5ga7lj2Vydy0BSwJ9sqQ2rbP6sj4c+nZX3jq3LkmFOSCyUoaZUicgDnfKawnZBBEDhmZMdpiQ5zCjJAKOArXnl3vBryL84QA5dwCaqwzuVx3169NXCcvXe3fyS9vS53dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=Qziod7TKEYhly70E9omYKOFqhPqPS1GdfMD1K+SdvJ3QESXIvwuOy96+fxsf4X+ajqOFK7kcXOrxRTjJXNjdH03SfUxivExjx6SJonZmehXQHBuy2ASMBAkgGy160cOmVFTLT3cb+lJ3M9C6jOjNgIhlynk+Fly94jRDA/SQUsPuwXhH81uFzLejA+oi2I6coMzmnBYKwjAEtvqyTzW0e4PK7LlRDpTPGYobvipivcUcuCWLSYw5s6oDOIe4cOQX4HlknziQFYC7chMD/2LwwS2/M+VaIGMbj7523h484FJ2n6f3as5z6zD6oy25al+krzzFH6rIJUNXV3gHV+tXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=R9XBrwZlnePe8SWfRjeFGcxxPs4mIRA4rFk3NWP5Z61i4xO5edOel+YuqnxxbakBhtRCBoJ01hDqFtxjsafd8y881gErN1sZcTlgj+6myShl6OjtQ9RUsNQ7P3eVc7N/SYcMpGq6tw1qF+MbPAQsZ3J0yiiKBkgjujxsWKjcHj8=
Received: from BY5PR03CA0007.namprd03.prod.outlook.com (2603:10b6:a03:1e0::17)
 by FT1PR10MB890726.namprd10.prod.outlook.com (2603:10b6:170:37::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 12:46:33 +0000
Received: from CO1PEPF00018861.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::95) by BY5PR03CA0007.outlook.office365.com
 (2603:10b6:a03:1e0::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Fri,
 16 Oct 2026 12:46:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00018861.mail.protection.outlook.com (10.167.249.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:30 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:50 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:50 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:50 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjnaL2531850;
	Fri, 16 Oct 2026 07:45:50 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Fri, 16 Oct 2026 18:14:55 +0530
Message-ID: <20261016124456.1802080-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00018861:EE_|FT1PR10MB890726:EE_
X-MS-Office365-Filtering-Correlation-Id: 6afc30d6-dce8-40a2-72cc-08df2b8380c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|1800799024|10067099003|18002099003|22082099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xm4uybzU6LGACF2H18pZC8mwhhm4D3wwqoSSaU1wwRC3ZU1TWW4eff1fKqV23ijSbozCcFTgsVCtdaVn/Fb5AewPOecgkVggCw+dh5wVoalEfc9qm1NbizBII1x7IKCkiZm7rVOyt35pJV/imAARNXaVDVS++A/vK55+Ovb7SkC4CTcLWng+yZi5jRT4zP0grS86Z2NCO85YsmtZLPoT/1ONsTOEKhaIB4GEsVA/yaw41zAqhzNXzFYhMcyucPZJnJdikNbENdC73ENDDl1ZSUkxO1ov8XVcp7d9dQapmFSb7ap4Q0ptr6yzwwcnEf8qPCK+btLmbD4EWz8sFlYjxM40gixLTNDHhXY/Rbew6rZM2+FbKR/Hc1/CweivqT1om5RVu2JfWzb8n8HzuLM2mG6aVceaWMI8hZyNvv72a6R7lrB5HMQVzQQ5YN9zTXMAO8nALOMyWkJmB8vWh8qJlrS/p1gQENzoR5AY1jH64Mbwr88rEeIVtF9JqCfubODRhpMc3fMRU40GMKM7qVBPmqI7FbJqwtm5A5+XYFJVJ9bifSHoVb6/Ka43OJd4p0Yua5NxEvjl51Y3QtXzu+R+Gbj4tHHhi8CpmsaLy8WGFRDbdbg90VsL/IcxLK1XtQkGmcDsX68WWMaA8v8KTaEiiv869ValIFnxI/cBCCuBsQLcienlAvgAZdY8wAjFN/Q/6x2ieCWjel+x25hDbl69yA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(1800799024)(10067099003)(18002099003)(22082099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fJB0yoz/JMmuVbnbGRh36iRkIWCMVD169ZJKmy9ueGPjmBzTRcoelX/39FD6xd8J19/9e1+PQjE6UE/y2A9JH37Tc3UgmJCWtiXourmR9bvDP1LYBI/y8OJ0L0zNp/xBv+RqGWYdyXfsWXW6qpcLO6L1zWLX6L+l2cwJ7Gs0EoSj6VecGhoc2jQxgC0jLtYFv7DYbiNoAzWeLhB/88KrmX4t50RZldbGqhZs8DhYqxc+LTRb0DoZCIaARMtl5l9p2xqCwVgAYMGffyrA7sMt7qprXOaUeR/46jvpXRDNvuPnzifeKKuT7OV2WXRZVAv0LFx7PoaYhKVrFNZw+QkM7GPuGrW54lhVC8Y3Cb/tPHnG4xKh/NehAR2vd1wVN/CMhrAlkkxu2nwEeTFXAY9McRBGhblV5Ify+6pPP2p7MdEPF2KFi29SVnu6LWsOL7e4
X-Exchange-RoutingPolicyChecked:
	X0Hoi/uq2QmgSpgurBXhZP2uiTiS0s4fZDcvPYWhHt0rzNH5xu0f55nLDiaa/h+hB3OjxklU/EUhTFclYRId6yq4CGnnookzvYI6uNcTA6zTZTHxnNgI2aQ4Q9oyEjWzt9xIma1spIXRIXzlBCnHjsVSHxckzirBS03GcBsIXZACdrYywJhmGlAkGIUZm9+rt9kJXaPRw25hv3RnXJKsYfMrfo1BuIKIhPIiVbksMs6a3vCO7DEvmRpdwKWFfYbAu8kZq2zkDhKt8m0EO/uXcMzaaaBSQ+soY8vJU3VlHiEBqDB0wNZOm21QqACDbQyP7a8vXxUnGB+38PTHkJGtSQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:30.9455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afc30d6-dce8-40a2-72cc-08df2b8380c1
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018861.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR10MB890726
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfXzPGJRWBBVGcE
 ZLKX7jnAlKOzn1L/nYZqVT+uU1HyI9/Ep0v5NBLQ8T6x8VhMvsxYYsPvoD7InzB+1E5E2dWXUOL
 mvBtTEYv65WBPI4V1Aol4/mhs6iShAg=
X-Proofpoint-ORIG-GUID: J3oWIMNWjNkZJrUEsqOZf7kiDynxhcKq
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad21cad cx=c_pps
 a=f0OpuPnQRmDrWRgsA3vZMw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX5So2JYrf46YV
 jQ8mDwB1FpYh6dLfQyfvMjXzz4MdnmgyFiBzIsFtlfP5gBEJObS/gkeZaJqutLNiOlhDn/x894g
 R/Ae7bDVe8HZvnwUIDin+DoYDUAa6igGaSuIYzqnNInN3N8tTDxQ/z6YueovHUy/Uboh2Cuo56b
 0j/WLp/yp2I2XEA/57bEgcLRSyV6wvXbVWaXOULW6UXUiSv5xJ8cfPgEQq61Rzw1wxHC3HUe49o
 Dom/q3MAee9Q0gRpZeX8CVzBShungSCVKH7dm4o+qg0l2nU8Qkc4raHKE27yF0sffWVkb0ZWdri
 FjvJTJkWCZDZGhGvNB9xzyfq6lhhheqTz3zpdKXg3zRL5Mrm8TeaLulyz3eHDsoGjJpA4Fztqs9
 6qKpXU5VKj6vxCmAbhcxMUSivmHnPLX4ShbycNcBfgSsOFOzDjtEMTp3zZR0fT3YgRXkjKBo+GK
 thLLl/wmUe//s3DpknA==
X-Proofpoint-GUID: J3oWIMNWjNkZJrUEsqOZf7kiDynxhcKq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 657653d6c62f8..e141ab8980000 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
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

