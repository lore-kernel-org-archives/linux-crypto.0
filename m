Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067671;
	b=hsJc1sm5UJHc7+134vJzCJFlbcnTvpfX+pRI1grDqRvnqNy3u4lD5MZZpfUx/FLJ7Tw9
	 e6cezK7yyHurR/STo57i6GZEp3U0lP6gcgvVAXpv7WohVMgYIaYBkRhI07e+If+YOwtkF
	 z9ArZA0tBSLekopLC8wuARKOcAHpzbo8qNv2zcw55Pj+FYxY+Immm4sd9GNNErU/EmuM5
	 nZTU98jxXQWcvjf1zpRBGkoM50JxidV7yB8/L32s3V31IuHuGhuIcgi+0ix5r91OznWF5
	 j7t5MBSnjc1r23ALkSqqeO191f2kY8n67HqmPGnFDygn8iOB7Njgj9RGG3WdNqxMQqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067671;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
	b=l6aLNVN6GCtrokVSsQHxctSGBK7dpEOJf5qdfxeKcRz6e+xgj5bLToc3IQVaQS1q417C
	 TS6wpzT2ls716J6LBgT0fS4TdCXhEy3E+KxvxWuhGmE9eTHuRsj0CW4xvyTNNXpXhF0QQ
	 LpZfkheIQ7KNAaZRFcydfQxml0eoRSPc7zUd8AbAnK+2fuN+it+pPDv2J8jAFOfbEryXS
	 mFMmKRcSE04SprHcGnLracnueEEyybkSkJoKV6plQhpeVr/3ST3W5wPbpAaLo1/7mL7y3
	 mRCkh2cLilkHAaVGGC4f/LTPXHUinxUaTlzO3vyOM+TFCRx0LLNjpwqAv1VV7myZ81A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=pmtD1m0Z;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="Z5R/UpnM";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E6B606EEB4;
	Sat,  7 Nov 2026 16:07:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51E6B606EEB4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=pmtD1m0Z;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Z5R/UpnM
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExtsC2334848;
	Sat, 7 Nov 2026 10:07:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDls
	Xk=; b=pmtD1m0ZKLfBOGnSgBC/x2rMmzFJf4KehuwBVtDCHTg0DF9kX4eaHt9UT
	L+vbbcdVRaQ6eIrDPe8gNiqO6UGz+st8yX485vqLz0KixSst2z2j1lcT6L5+8kwr
	zJs2tyMMkm5v+K5Mu8xlsAZMmDsAPoNMr7h+3/QP+gESj9MpDpa4b6OkcvKAfNMD
	aRsLmg9cJrsB1cHLo2h9ClZ3RqKUF8gEuzcCwGNb4DdXyvu40+zX9zPOuYnudV/B
	WzdraTeOvDCUDO9mBA4XiPc4vCxTIoHAwKRUm+8rDHOvS2qiKmn9g+6PzNgrE/Cg
	Xf+G3w6IGM8OznqKWxQjGRjbHk45Q==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013053.outbound.protection.outlook.com [40.93.196.53])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydwg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:48 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXnTZ08h5XdyUDShwBsah4SMh5i9TbRKVeNMqYiPNi8gZ5W9jpOpxJ5RbYImbwlTHLWeHmm/8JOtR+B5Nk7TzrZ6OhPQ/nKwVCduwonw3k8H38Ltw7dOWjvBDDNiLj97L/jBx3bEed5TMJSuYvEtJrkXv2Y3Ajxcf0TnnGO244tUAHPLE9j47X7a/T5eMgwfe699w6L06aro4/lvkGtLC/B9Yo8KxkXg7kT2+CLhUVntGh18qvsbR3sbjwfoMOZiFe6CHKAzu55r+k+2su2Ds9xMT23mi98mAvzdEy2lmPk/FduDUQ4nTmxmbOfg8KWs3aJvZHltEJAAeth78is2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
 b=UQFi5mGvTJHJijy+7UNZt45NoRJpQtqLCTM8zsMz72FEEGe6OcSKBnztnW42JsleCMr0AaKp3UebW/KLkHSzE8cJq2bQQRiwWuZZSQ1UcZT5q+t7wz32q6tvCNwAX1Dq+p40/m48ikME1ZeCqwzUTUz5dYUDyb5a8EoceXhy53VxVA6DLPuPx05WX/oAySc3KmcFnriyA7CsfPOvaSwXGkjnxgJthuaXM9xdVs3ZjGjaoK7Z0w7XM3Siwx17iO32RQn6bSwxf1d3Rz32r0+P9IxCJMnqjDOoPKF/+QW4+fkj6MzlvdSHyV769Tw5/JjMleWvklgDa8ExH4v86mp19Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOdUUE7n7jgN7EXFwQ2/FB0odBNA35lFrZiArfDlsXk=;
 b=Z5R/UpnMT1WFLlZx61R43thRl5y87kIIQxA4GonyFb/K7UkQ2YfTlQ2kqbLVTWKlOUpqUkhT6dTeuytZ7hQORwyc/GuEXDz3yuow96ZavyfJFXi2SkFb1u2PIUPzo3s5s0SLhDYF7G5P2qCpuLZ44D4mVK6izEvHrElw2EKSB4Q=
Received: from CY8PR12CA0007.namprd12.prod.outlook.com (2603:10b6:930:4e::9)
 by SJ0PR10MB998056.namprd10.prod.outlook.com (2603:10b6:a03:40d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:45 +0000
Received: from CY7PEPF000000F4.namprd05.prod.outlook.com
 (2603:10b6:930:4e:cafe::4d) by CY8PR12CA0007.outlook.office365.com
 (2603:10b6:930:4e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY7PEPF000000F4.mail.protection.outlook.com (10.167.247.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:42 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:16 -0600
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:16 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:16 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7Feg3460093;
	Sat, 7 Nov 2026 10:07:15 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Sat, 7 Nov 2026 21:36:26 +0530
Message-ID: <20261107160631.2592763-12-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107160631.2592763-1-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F4:EE_|SJ0PR10MB998056:EE_
X-MS-Office365-Filtering-Correlation-Id: b93329fe-25f5-4e96-446d-08df3ce94105
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|22082099003|10067099003|261028144727099003|261102123227099003|261022105027099003|56012099006|261021123027099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	OIqpxm/cdvrdhcLA3Xae8pu+l9ivR3Sqr6mG7CrcAX2MY2Fpj1pPU0wykp05ubuFJJrcuDNnbpuNkiJvlIvDEN9dJziAc/o6x5IUXvBaN4nUakNjvAwor4O85d6TygAhNiXTXj1eW7+KYGcTTfxWx1rObpit0tcvQUqseVPh048EHzbIvCuJOiKdRRpRkf2avuQpUqM969RMjzC1QjqrKP89+WU2AiHSiglz7C8ChdhHlWuKXaEwv3BpKqf54vBD68jyc0LW52IhmKk/mDRaV+WrM+rVFkRfhcnY0Zqb+Rj9IJNHKI8XyAT1bYpq1Y0PnCve1L9hTQMZohknR42dg5EzpTlhALoXRewyjitmjirrHuCqUwaHLE8QdnQ9403l6hBRXN6OaLyWum1rmmpzmIigwcx2niihiwTtP31NvD45U9GPqPqnvkKUL3xu9AeinYs/bclytboUONgKD6nzTmMk3u1WVETKEPHekYrtN74VihVoaAeuijSdeoiQqpsGmxOzxAH9GyNDAb4j7+/UbrZifiOD8obbfydGreGjreqAswmNGsHUA9CU9b+QwvbSkseCyx2Hbe/aDMdOsIZaS5RMPMJNtGtSjFWJYR6n8pzaJTn1nB/g0C6XgU6uNlQnDDbXdIDvGPhEycK996HUGWOmXUEi5BDcGVqVYGGj7dRXwt+09ASaqRaVDf221mvUDcAKNYQ9J7p2I+j2juiwcw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(22082099003)(10067099003)(261028144727099003)(261102123227099003)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	D+13HGsebQ8Qwsyj1V56z53o5E5/1z7+vjzdkr83qREsOXt7sYSiPcAZxB4hci6moDYB0Nuiz+xlookjbfn0tbY2rEEv/D8v0dXY1YvH9a90PfFgxBMDJuQIaqaaJDUKE3/5UNRKoovqVXHlRMJvkmj3x2Rxv3/kCqoUOjWSi3YoOIl8Lz0IJ1iT6kFyibKPgqdPAGWxiFH7g2xSpOey5uDl4TDkjQB/rgn2dbFwAkyu3fF07Suqc5EmAjFjz2ER4NMO1UeJB9L3t+bgJXk4IIYtHc5d23EEHqkXwRfmxnCb06gQWlLwru8itjWzbLaZx1veKpexk+LmmV8t+k7qGX6uqq1ZaSMZ6vD8k/DSDH/Ukwg7bio2KICw6ppn04/KniOvz8+4eaBiEKdXTYnlvYmVCpqpBmAIZMr+0l+nD9jD1QK8tkc8ADSEVa/++e61
X-Exchange-RoutingPolicyChecked:
	aeWO2jMZxMc8B34IXZCJCqLvy2xX6BRKRE3MnywFUZeAxwsR6O+NJSq+G4GHt7mqYP5gvHQwFAsgdQWfIz+KcWPemcPqsDfW4yOq9PW5IM05OdeyAjWrys84EJhwi0Pv7iFqLIxCOtmkC7lrjQP8nipwkxKsHPjaC1ZLeUUWiJh3lR8M+txaVNzHNnHqMcot85LFVF1P72yz86S4VxYehqj1Pnzir3lZ5EvGZeAR9sovjIx5O3MoYGSvdXLhAjWUmBIH8JBLzhKTGkfeDonEmMzM8fb6LaBPM9XR3AEgo6oUZP9M3/OU8frFWbdPJo9TPyoomWtEAz3pHeKlk10+Tw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:42.5450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b93329fe-25f5-4e96-446d-08df3ce94105
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB998056
X-Proofpoint-GUID: 44qFhGIiniELZhHHS4FIEshqzuZQ1avK
X-Proofpoint-ORIG-GUID: 44qFhGIiniELZhHHS4FIEshqzuZQ1avK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfXzTQe68+YQQ7z
 8jFi7wQHPYZOvIxi3PUk5amSHbQQybjxmBAq362sSWSSA6K4QistuglPu7tK8X6JAy+lUIGALgN
 hAsXOrfkphgHrEG0+FGoVDp2pkkDt6o=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cd4 cx=c_pps
 a=5zjvB78PlnLPEzvzEo0MXg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfXyhLCjclgq/Om
 9az/jozJYR9OIlO1F6GDG89xqfRwEPLVoEL0TA3Mfk7akhTAwlh4zAlC1d+W96CLWvgiWAUPkE9
 ZW9xQepXulwPkXWhuitTL4eI3OIn01qrnI8cm5PHxQ4PqIqKylpSTOShtclOnMySCV8sCb3qEzb
 kz9MmRjcHzCCe1yoZL7HzorEfagK455skECP5O8xb6ASrIhs0Pz+UVqSNFKYcUw/yPh6mSXieBs
 5vFd99QioQ0kuhdkIttiFwNa+FOi9OkZiy3376ybXEMt97rz1Z4rPwU5WuNiS2fmR0nbYDEz7M2
 AvcoIw1cXfUyQzi5Fy/yfZ1Cmqo1KGp+vC6rwB3IrMg+Qe878EEmDTYAd7HHmt1iOdcyVrjfOfA
 Jjv5KM7jI6MAko1m6vTa68V+RXsTo2uNIZwrSmPvZn9ObY9jrpqDXLVDqt6vsMeU1XRE9EXzHuW
 9uIvGN9CFl16Kyxi9Ig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

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
index ed79b873b463d..f1f12126382aa 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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

