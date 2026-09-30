Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E594BD0FB;
	Wed, 30 Sep 2026 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767624; cv=fail; b=p1PNEyzx6vLDgtWEPMdWOxhc7Epagi/a7qhkny3fnBOE2TvIsQZW56FczuyLpTm2SlPb4zg9wRqL3IbHmiHdpekYk0gHYaImjn0hJ1vnGRF7FyHydDL2YeNe+2CoJNOEhNVyRiyEv0FVw85KjLG2pGMAfmh81igwGdfWomWBI8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767624; c=relaxed/simple;
	bh=MzuPGd7CtTyEUkT4iY/z7NasQEtGNPf4RFeoIlailh0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAC1Ioxyng336xSMF3r4Jrf/+/OqSL22JXpKdwUT3Gyq27MgVZW+dMuRot8/NI0caaDpmWtgd3cTL9bnDVy/3++0hN+qcgKBrA1hUiLF5LoDkMpyBDav7xkdlnc22w+Fz+ftcnxhtoJSKS8BhZ7xrNYrkgOtvj9VIPCeOZEdmbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hx1551PO; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=emJ4Od9m; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hx1551PO";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="emJ4Od9m"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5pFm3552705;
	Wed, 30 Sep 2026 06:26:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jG
	vA=; b=hx1551PO1CMiZmbZq7xAu/fmJOv2iWYYbOUQG4zpyrtoHu4mXUizwPwuQ
	xkn9jcwYGC1ZlzUaIp9ZuN1eUZOZNoi1CGfqj7fJGpSP3n4eoeuFbIdyInC/F9Rm
	VGScq/f+tZbKIsbebtHnZftdrxFUaKPR4WLJiOOfyk3HCdlkGFI1RIeATYqYt1L5
	S5Bdwm+qh0zOljhA4ppKqkv1CWeKApk+l9pvPglGyjRcjGbBX5XqY6VjFpbqN526
	DngGl1+pT8ll6HrU5Fw+1KsggzCfsns6I6e7/hRVmwlSVe5pAXWDsmSs6weaXHIl
	lnFFxtyQ9WGf+BlJFL404+/LtmUsg==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s208jn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:59 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QaHYHbGWE0KnXVTlbHbG+Ghqr90J4XX11QXK8CeYqHvaPO2eMdReqpgZxA7HsAIb97OpeYe8IXLTuIqOZtltCbH7sAA7u1CKQ/m98Fb6CTobc/Un3s0Ju0syhj052h6huKUc2KV8Wlqx+m4hh3BjbqEqz3D5/kCxfNlD9sqei3q9t87ghRUjeiR1RHp+tewRnhQI6DEiGOgJwvsF9sW9xtQRQLZkjyLneemuk2V6iFSOYLbW90ESy9k9Qus8BsVGbNYbnWCV2BnZWgL+1xliKzMJNXKGGQxGAwEcdskOPwZ7WNaxgFtpXqZgIXlm8z+DThaTHi6PPLbjxPjXcJ2DtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=AgqwknwjOhgJ/UwjHSM3S0KIZPT8rq1jzdcCZ22Rpaia0kDi39o191j9V9HNhq70mXVlYtgMqzCuVQeATkw8eblwUSi/V6YzkJnhhC58NlU0mo4dWCfDlxPaC3K+WBuh8SgjAz6ra0pzcBbnV5L4w3TDct4EMdLcXnSn3j3BzbwEzZOLh3wr5SO43eyA3LnKpb7Fgv+mRIKARouPpEqgotJD7ccsDbFFtnTCqaI2KKbOoXFVY9EKHqJu2SWq99BCedBf5tk6lZO2ME6ZP3TB42qHkSBnIIzbyIIIJp0ODGumYPR6vxjjyNNSJ+6MMlvNuaPBZPeEmSosTn+Ke1XGuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0bYOZqo3sutisalqPSgov/smSOlio/s829GS9jGvA=;
 b=emJ4Od9mENwBvx7Zm+2MPMA2bDOTCkMbrBjU4XcC08gKqIm1Db4ByWWkTZhNnkGtGCPRU24UEZ+mfGzJdh9ZUQ4qxSdv/W1JgJbjQgb5dj6FBpEZwzOyLIPNE9sVhBM169JeDsHWrwq0gqPeSwyg9uOMlUBNjk43H3zaThNHU74=
Received: from CH0PR13CA0057.namprd13.prod.outlook.com (2603:10b6:610:b2::32)
 by DS0PR10MB7247.namprd10.prod.outlook.com (2603:10b6:8:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:26:55 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::7d) by CH0PR13CA0057.outlook.office365.com
 (2603:10b6:610:b2::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:26:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:53 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:17 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:17 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:17 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQFd63025609;
	Wed, 30 Sep 2026 06:26:16 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Wed, 30 Sep 2026 16:55:31 +0530
Message-ID: <20260930112533.1593952-14-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|DS0PR10MB7247:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f63d3f9-1def-4dee-f98c-08df1ee5bab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Xk0VLcDTNKd2irTcUWJ62wltjeKpJa7NgwEPM2zWWAIjQJwesY+h8tBB/4iBBBFcbXRB95IoFBH9vEQPYKKL7J/4hwCAyi4Z4Fspm2E0S6hyf6NlRqtK7CZobeCB6JCRnU5NBUnUmP+eqNRMjGuH1DWIGcGJd1lIN7m2jI8rWsfqu4Ip/gVx9r03pSkWxiDFmEvPZceAMKQyHXdMIvTRcD5sL/LfJmX9yUPXbHfh+IPtG9rz2RbzY5aszsFPWQVv5RZC7m8VBkAG66CjdOYVTgd8rk4w4r/LaCgJptqgknb3crD5JCBkjyHtYOuAdwOmto8tfwqwD2CW5j1kfF6j8XJEvtRHcA38lz6qgaBvgDXBf5eEMWbNrxX1yK7cBGvrc/cznDH+a78acGEaVKQMMnDjcX+5WAp6sEmmPm/8h4Id4PEV/IF7q7HKMxXEXW/HgrzB0DQG4XQ+gy7daYfOJ0QD87yQFAEJZyMSwGMFvqnq2n4FGTXjw+B/y5sMRmukAT3YBWaR7Z4kZFh7zas2tBsLaYtrqtlh3vRo+9vdml3Ftxz3hb3dfsGNQy1JFpHpJwVWyWB2c8z95pbmlJYplK/bzOXUdRDaQuNyBU/PhrkshAssZQmcMjSneKaSGyQABzMzGcDfKOhQz4kyEbdyKBORlX8X9DYXkCWCn8VahbqUNBDW7DOhru+bXiPAe/18FbU85RSlUpC8Z30pZm4iMQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qpNMZ584PfRvlUkxNQkPWleiyaIE3Oa2gajph3pOyr/6w66jsSr/Mq8cswLSqdF8KxfeA/8JnWIHXAW9J6xdWUClVZgGGfC3nT+KWJYN5gKSzZ8yw0OS1craS90ygY8OHAR6Lx/HocQ3O7zkHI+MypT5Ei+3FXza8xxBS0rNIZqr1yilwoYH/Mu3KRce+9Q0cmHBIk1wzy21qcuwir36qj+Xjh9pdRr+nIEmVI0fOHAnskNNFxzSafpSfKA+UT8Dgin2F+IStEUXu+gLGvMSkQgXqp2ZGU1XS1g0hDSNlMc7GCj5PfnlIbl3oJMUqxKrlUvKWqZscvgKUBfIfLf7Cm4ce1v++GgwKec0CI8570YMMITijeNB/YAQe/bSRTcX5qmhJkufxQk7NMFkqMkOLG10+wmsurS1srxzkMkH+737waF58agjWBRgClm8rY0r
X-Exchange-RoutingPolicyChecked:
	z/kszhsaddrwmLZZsc7orNkxXvAbpLZLH+PU6WL7GUN9qaYa00fTZ10bW5+7vaC+8CASEZic1A1t+WdK278kJwfVSGUbFfhRCxWUCGrv5sg8ZdGtwtS2E4Ot2SIkxAWGx6PB7hDdJX79A2/xJuu/FqJNK1IgM+58l3jFJaiE7JxH4KMnc6dsV+B4x3crD7sou91dUdHD32XXhZHRp8gEHvzjx92r7fRg1SZZMvzPYOZOhyFM9uoI1B2aPnbcUBtiNRlx5K/xNYIjmHm9EYnHhe00ZjeSHpR8HZlCWR6M4057WrPmM49dRM8OpTvYebs26u6ViF6PP32Wy5X60jfLRA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:53.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f63d3f9-1def-4dee-f98c-08df1ee5bab4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7247
X-Proofpoint-GUID: KxdcYlr6pH3LzNn-p3t8iM-yxTysTA12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX/BI0/bKTDGv8
 qlQHBkOllHfHdXoW52iSQ0Au5ZmY1KEu6m2jZ2GI7RnliQiaXbdc6N6rNflfEdA97Bdg1bjsDMD
 yt6BQH4WHj3B8sUXUzy8uyrBY8qxHf/+G/nRJH1umntx948wKtX5L6J42l1CN+8TchpXdNUwC9Y
 rD/PvFnW17NZJEu+72Q0teOi+97NbIKJ2m7m3Ab0S6cPQNSdhSqylyETai0lX6K4QpuahdqgHIy
 A8vWE7psoHEaKmFVQBR2QkBdMAh09x0QwFVzd9XxzQ323tpGvUDa0w87+txyVbs/ZyZT7yhPMwC
 XV5Q1Oa30Lb1L0MQk1C7Uy/kKNx53gPGvPqmwyPMtWyDKhL7gIPV7aQzIHG6LIgGIjzIfWYxhUy
 /YUp74m4KYzQQDBeibmS4dsHQaZDnk58X4PWLh6GYt6Y1aY3pvCCghClCDrkbVTGH3wz0cdGdqn
 oWm7UptU1pF94c5udKw==
X-Proofpoint-ORIG-GUID: KxdcYlr6pH3LzNn-p3t8iM-yxTysTA12
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abcf203 cx=c_pps
 a=fUX3CcU6CI0WA5Nw0mDYKQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2RMUx0Al74/u
 lks9DKV6n19j0RaUtZxCfwfdLWKPTFwRHg9UNU4P44TIlPL4EbZfZLzpS2UjP5U9eGvQrWOAb4k
 gnZEKNLAoMJig+NTIw/9HgvbYTlr+s4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

There are two issues wrt tag operations (tag read/write in AEAD
algorithms) pointed out by Sashiko:
1. dma_sync_sg_for_cpu() before tag operations always uses rx_dev. But
   dst is mapped with tx_dev in case of inline operations. This is
   "technically" a no-issue right now as both devices use different
   channels from the same dma device. But it is nice to be correct.
2. dma_unmap_sg() is being called after tag operations. But between
   them, there is no synchronisation step. So tag operations writing TAG
   into the dst scatterlist could in theory be lost in the cache
   invalidation done as part of unmapping scatterlists.

Now, in the current code, we can correct both of these with some
conditional logic and repeating the sync (this time with
sync_for_device). However, it felt more elegant to move the TAG
operations to occur after all the scatterlists are unmapped. This
ensures all buffers are properly synced as well as avoids unnecessary
repeated syncing of caches.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index bd26c3f438e34..657653d6c62f8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -915,6 +915,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1138,15 +1139,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		ret = 0;
 	}
 
-	if (cryptlen != 0)
-		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
-
-	if (rctx->enc)
-		err = dthe_aead_enc_get_tag(req);
-	else
-		err = dthe_aead_dec_verify_tag(req);
-
-	ret = (ret) ? ret : err;
+	/*
+	 * Need to read TAG registers if data is submitted, even in case
+	 * of DMA timeout, to clear the hardware states
+	 */
+	do_tag_ops = true;
 
 aead_dma_prep_dst_err:
 	if (diff_dst && cryptlen != 0)
@@ -1162,6 +1159,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 
+	/* Do tag ops after scatterlist unmapping syncs caches */
+	if (do_tag_ops) {
+		if (rctx->enc)
+			err = dthe_aead_enc_get_tag(req);
+		else
+			err = dthe_aead_dec_verify_tag(req);
+
+		ret = (ret) ? ret : err;
+	}
+
 aead_dma_map_aad_err:
 	if (diff_dst && cryptlen != 0)
 		kfree(dst);
-- 
2.34.1

