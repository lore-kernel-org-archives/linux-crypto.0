Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063475;
	b=sCIuc87/WlFfF6CXKmnRFcR5u2YlvzkYL0ZhukWJg1MY3ADzNQrkedAzOHzK+noayt62
	 f8S7MHH2/32FFnPz+vGBh6QDS5ZdVzWNCii9ZLXrj+uB5nnhCyLXReVQYQGBbkb+ODPzi
	 jeFvmHaIQ4YPr8JsRIHdBl/oDXi8Omc8p1044O6l2zHjuEL9uTZHr1WBJkHhwd7yQa462
	 m/aDG84+qrC75C9gr8I6PyNBibWvMD9Ra03iu5sbgFm25cKU7HVULgmMrVv5tKQBEbTE/
	 GmRQkmgO0hwUQhyb4cxE/2Oceh+G88OpRLjL0tevAKY3pk33Oz61MXwmnfhaWbqyzwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063475;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9Y4=;
	b=vjli2rkQLFoE/3YdLfjxY91KgRUKCEHuIPuC1BSHKrC6D75yW/fJKS/t/bMRirtYdJlf
	 P4xWOMUpYukkgnReAzYP+yVJ7UFsG7WL0tfW/f3d+3PSFyg25x5Rb5xJVJaj71rd0i0J5
	 nEpv0VluvbNFaRpqzMR2KBHdWidSpmBCI+K6go1e65/gje+pPVmkojpeFEZCgb57k0XhX
	 lDdnWSxVQjPk03j16mcVULIxvDP94vntJhApJ3I9SAcelWcG9J63Aqdvyruk71A7R4WO4
	 54LNjbuBm2PWPrdRzgA37fXKVcnEtE3UhBhZ+8JuSMteKnZfzYrz6E8Spd8bx3L9VOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XyaVj8nD;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Gra9WgML;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F917606D82D;
	Sat,  7 Nov 2026 14:57:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F917606D82D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XyaVj8nD;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Gra9WgML
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bx8Kg1610421;
	Sat, 7 Nov 2026 08:57:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9
	Y4=; b=XyaVj8nD55sSWqmbaV7MrQH5TrjSL98wKpVcyge48MIEoBYp4e5qPXCqJ
	gMLJaexZfQv+xY9USg3vZnzoMXEYB5AO8YtLvGCGR3k+HIqc1CFqBevFAsk3Gh9t
	aH5ZacqHtVobjJ1Nh2p1GDQmJj0FwLWn9JAMl3NcFOmiBmky9C0DaLeXmkZSgzSP
	twjCw5S7P92A6apIh2+sZnCMSuH6HeUz6l4J6bx0LHoCFZbsFFQHHiy4EiuyjRmy
	5J/eayGxtdOb9M7RtQkYhkoofN18h8jfAg76w/ucsmHKrwvCtyD0Om3DkcLyL4Oz
	v/xAwflpTEfF4JCFT/Rhe0qg6OZyQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0wqs09u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:49 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZaS+rCIhr7/lNlb0nwkBOPnbSmYrrrBaUB+KTTxCsK98ZINrjSz0aNe//qZv8kAbBdcJt03IQFx6THhwmeDNOcvXKMFTYc3VeDsGRevFr4R3A4Laf3YyQRG8ZHgUVHEzGLE2G0vR/XL74epJW6zfAaa3Ce01nlojC6Rm7lVMtedW0wc6F34Jg7mayXEKKKKK9WziWKF0kn2U05Yx9oht6zmBmyjATGZ33YE34OB0fyWiZsg9oYGdHbsWxkDYa5/77XDhgI8VoAPSoZlUkFFcXoWOIKopLq7H6JoFTZzenkkEU/YOhVC3kPyLSPrMq3wZp0U89dJnZXBcclBjtsFyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9Y4=;
 b=baIP/PN9M7rCxhqykAQL7KCQ23WMNbJ/JSEfm43pXyOkkMi3uYiGlta6zWpvrzG6J2s5QUjbPscZ49WWG359CPD1cTGa4xErQS45OJyu/ZBVroltHRynqEE8zo7b105OlGZBP7qeFB6sZ0rRLaWYb8rMPbXKppDhYpMnX+wmCmgIQmgK0LnLbkKmdppLxdg90UAv3/z3+rdOTcd6My/pWK/NIo9lcegC9rsVrBQXO6+gNGdEVhKNtvYsn/Bohz+X7/BWHcBuiR5IxJE0z3l4Vh1/r+M8QZAfNgxrt6GCmJ7btq2IxCjJIRDVRzhjnLcRVs8GuHhaNGypvcdZBum5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9Y4=;
 b=Gra9WgMLAXpQFFF4kz0f4y2y0NrVW3IBZJXtTdIPmc7dt8DLqHAiKunWmwB1JALfDie0UJVz8kDToUguxWPGxTAGZT6U80e8NELIw67rE3xdKujkcrkJs6q7IjUdU1kbMCI/zhc2jcmweL72QF6atu57soFRaGb4EEr9SdTj90c=
Received: from MW4PR04CA0316.namprd04.prod.outlook.com (2603:10b6:303:82::21)
 by CH4PR10MB8050.namprd10.prod.outlook.com (2603:10b6:610:236::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Sat, 7 Nov 2026
 14:57:21 +0000
Received: from PH4PEPF0000B60E.namprd21.prod.outlook.com
 (2603:10b6:303:82:cafe::f) by MW4PR04CA0316.outlook.office365.com
 (2603:10b6:303:82::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 PH4PEPF0000B60E.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.0 via Frontend Transport; Sat, 7 Nov 2026 14:57:20 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:55 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:55 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:55 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EusDG3373732;
	Sat, 7 Nov 2026 08:56:54 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Sat, 7 Nov 2026 20:26:09 +0530
Message-ID: <20261107145618.2349562-7-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60E:EE_|CH4PR10MB8050:EE_
X-MS-Office365-Filtering-Correlation-Id: b4e7a306-7a3d-4a9c-83d1-08df3cdf6c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|22082099003|18002099003|10067099003|56012099006|261009223027099003|261102123227099003|261026121527099003|261022075727099003|261028144727099003|261026140227099003|261022105027099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	Jf9acFq+5N0W2jS54FFvtHgG4hZzuXRASHnuqHuwmmCY25ybXyd6r62x1BIl5qp/Ax7hII/5WR7rRaJqv/hK2qWSpx80H8dSQQlTlBGxfkYpuhs7stQcOBWDBuqRFh1ILx7JxNOP5QJ+fKKShNTX/V3fESZRAKcGac+Sn/M5Lbbunn0Z1qahMuTseak4RSmqeBBMr2ib9CHmk4sr2qmSQnCByQm6/a0a+mFDjIom5V8uAy2H5M+sxjRf2N/XIACQyOg61s0PFOE35Qdr9jJf/6h5q0/mrHYTc685qGyqfsJYToCJ3NffyBFmCaRj3aDswjqS6WJ8XaHccVhAfwchKBYdbewGZRRdU/JgyEdk407RF8mmDHE6vEccIHl3qElOL7d+Gvf6fawa02XeqfInCLYtFRcCVMplASz+GqyOzkppCeRQorPJuSunVh2qG/82+KHxGW1UtY6yhzMGiSApgQmM/PxMt7ytUOuP3STZ36QKmiHRTrjcnasDpU35AG/7wFIWCMd8AfIR494txeruzjbOirJNPc4J0gGaPgMXmnKeO6zwKGGdw5YahAwjLjFKzqY3jtpjoHIort4vCCdPWjCYpJPjbeOpa1JrFpsy5BdoMerztmZ2QZIfvUFm7jZ7JkgFjyU4uxM4RGqfzL6hQofNmdcj59dpNPMLWu+ukkmBJzXl128MOHo7xX1PFxLYZuGPx3CgkMcwJuJP6l3IGA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006)(261009223027099003)(261102123227099003)(261026121527099003)(261022075727099003)(261028144727099003)(261026140227099003)(261022105027099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3sFMmaE+AEt9ftE07Dxnxh+hXn00DnRxMzLKLCxwE9LtzUtsIWsRLtG7uD1eFAaZzWuxNhVY/sZRmpUeDX4JZdcbHfd8HIQ2q0gmia36zeOTDOYoOnT+pj7ZqWtPlEmAKqHg2CKxe0xZlEZhHTJZffTbSztBNntgaYYkHbV3kTHhMK0dW4hC6M6FtnuGwDc6f3u0CaRDkMW/ThGu9rCyYhnJKN1qtAgIuTk7He1/GKqM7H2f5MHh82lHIeiX3faPBxOwZrpG01LwSm+NzpzoRDlJ4wecA2Vznz1br2oIVHrLikSPHk94TlDZ+4OG7Epigcvb/Yn51wB8734tjyT1sBhEhGBmAVvcBrrd1e9FZWLr2CwLSci5WEUsID+aI2IuUPq7nhAnpLuOFGU8knXPup8JBNLQG62cFUyQRylrMUpvbOrb4r9DIGk5p4TJZ1Yp
X-Exchange-RoutingPolicyChecked:
	luzsu6r/Oi6977dMFfJ2lUU/IarPpl/vqITrvaPfOOSV3SBUW2CC7iV6HuwgvgOuOUGAumFl8Nc/DK28Z83wtrxIosF+Oom/aRNIbC1Nhh8ZZI91ITNM1hkXeB+RkqwwRJ6QEyEa5ByVlOyDru3JJWR4yvCi81mTwy+vdI5WaokhahLOhXzCUN7IuhChHoSeVn5q/fxPFoSXSHsMoADeJSDJFMqYVjKgM1iCSgOHZaFwNy8sfw0v79ujMq9MMOpQist0ZbYOO353khmpL2mrE0BQHUcLZOR0JUAA7pZ0WFdb3LJrzVSI3D+13Jx1wqht5Ifjbw53iRdYXall29EjWg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:20.0182
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e7a306-7a3d-4a9c-83d1-08df3cdf6c3c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8050
X-Authority-Analysis: v=2.4 cv=H/hOUOYi c=1 sm=1 tr=0 ts=6aef3c6d cx=c_pps
 a=KPt2yGXPmw0TDFl7M7pFkw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXz5Xn8NfLba4b
 NVv92BEUP5aXmFdptZgmUjGhU8fQMZRGT5RZ92rBss1vIj7U9zZMeNGwJxmYGMghALtu0Lxfzc5
 SC/T4RmjQ+EssXm2XLFcj46ZalgGnb/Ux1WExXB4lSi5oLo4auRCK2Dc6A9nMp4JvdDq7RQpGEb
 uUMwEUFyzCMX8p5K+n+2E9WtVKNCN+CyaD75DnnvIHJRHBDSHV3ak7adQQ8k6bepj6jThuob6qD
 81dbL4qe3qSY8Qa2vGeGs9aGiD+4+HKCmDhyyA9bY1RBOkzq/Q4BA3hPIWw5w9gIZMknHzMLgbw
 hNh6JUT5jVxKUaKheKwX69KSnyJtrVsgFsyhsVRE71uQhZLacIX167kjejGwvAPw0biqXO37eyI
 hzFBSfyG1gitFjjaujnTZF00JbWPNlwufZq8mq+bmy57V1h408fCo3Noo/zrxGcR2qcGh1gcQC7
 wSMHjJt48jgZ9XCxc4g==
X-Proofpoint-ORIG-GUID: 7Ok2n_apgWSn2H6Q_LcijqSRGsril8lB
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX8MvwFucL1WsK
 c8KqGYXVuFp/5ShGyfdYu9H1IIL63CZQWZMhkHaLh2SHqYD0H3cWrBbd1a3yLc7D+mjV0Rfgc/X
 krRoHtDu7Awwr1LJgjDRf38MlVEj/DI=
X-Proofpoint-GUID: 7Ok2n_apgWSn2H6Q_LcijqSRGsril8lB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

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
index 03a0b426041ac..cc20538ad6f36 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
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

