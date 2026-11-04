Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771114;
	b=ISJ/JDwQoyebOHwnlnK1jX3/R397+wRoxYjug95XpGQbG7qhXRySIsUaPUQVAw/ZNjn0
	 B82Kxb0YMbqxVjKIT8SupbTu6f/n7Yp473OJ/jZNEGQx12u2GgLEAVYFgbnIdePml33pt
	 KzLiNxM1QcARq/A16JBSj+Tw0B7DoaNI8khZ/LXmmmGTDm/oaNfAvSypkqDTJ4EwoWRrb
	 y/K9Dch87s8jvFpz8nElKtn/rGeiCRpy5FjgBz2+skbeFDaPNP6kRqp5xoRld+MEK6LB5
	 Ujbm4uffFnRvW/VvIvY33zmeEoVB8sudLePnzVH8vFz+nJlNqpG7GALDYJC9qIo4d7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771114;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=FAXGdCYQp9eSpveWtiQaxYzpcGKubpc+RBDxS9edSHM=;
	b=ti5pwlyLSSFieq1ePiQgI3Grp6ux4NMcoNDyeXeVxEk1rldxswMIuLgKSi0TptNjVb/S
	 5QU715b6CW38k3KviRpwGBpLXZmrT2Ndt3TGG3q8BSmf7jxc9jZMU3gI5DXfliAwdKk4r
	 U60h0/hJ3Fx15WF0PzaY03/IINUBrbrhCXGZJDwIBEkaeupdiQhVtGBcpsxV070I3QA+Z
	 DF4O1HqZDT2fO3qooDp5H90tncPB375dnQ8ghjCWfp8C+63ynabwaRkQKLpEyKs7v1Jx7
	 vhuvrRrniTQRwYw0ipznuDKq04nnESnQMpnpybHqwRf5HjOyjGi51IIcd/ejmUGjXZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=JQm3XcnE;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pEjcDuAy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C60606A336;
	Wed,  4 Nov 2026 05:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83C60606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=JQm3XcnE;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pEjcDuAy
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S0MU2587506;
	Tue, 3 Nov 2026 23:45:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=FAXGdCYQp9eSpveWtiQaxYzpcGKubpc+RBDxS9edS
	HM=; b=JQm3XcnE3k/QCt2u0JiA+97eVzD/dtWwztmAGKQ+22tcqebr/qb5nc0GR
	ygech4Ceny5juOVQ7oXrjASNOS1dz61VFVlJX4ECmtHIHPzSt1IRfg2tLspn2/AF
	QyVWFt3D/GU1OB8y61CndThJaH7LL2p5mQI3qhCUefogP+5C+qAcL8jV/eTD2/PC
	JwbNRPUAw7r1TQ0jpllVrD96f9lz1m40Jo2e0QuxlldO7RMsi114i52rtehKytB5
	0wqMqAoJLgy6rcZBbq+FTGghwejgdQK6z6Ba6S6qTIJk1PYCrg8/qXfcXLolBYOj
	yVPXQ/RNy2jP4PnmDsHhQ19HaTOPw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011055.outbound.protection.outlook.com [40.93.194.55])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xf9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:10 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hKpCYT9fDN875J8xhdamxol2zNx0ej/mP2Xi7XZYHBsLxT8kRoGMWkj5n7BactQQZl5Y0EP+0s5slZrv485pOt5ishfHugGzHnsTuaHurHZHsD4Ho58ENiTdHoEUGEmCGmJoUmi0cL24qqQLLV9qDqrGaW8f5IIMlFBXWlj8zpxQ6i8H4Cs6mVNrZmDvLb7A9mpiIocgd/30EK5IA/NpPaptZlQ/JHcR1ZLKHr3sX4UyjS1Lz/kuEom2ksczvAOrwx+nPcHgYOucAGM4ttUpatWPOZTt4s/vZT0LVNoHGy5Ah2Y2bembX0hmmIjUwgGW9x3hbMcGMTmcpQdm468pXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAXGdCYQp9eSpveWtiQaxYzpcGKubpc+RBDxS9edSHM=;
 b=GuRSDQm22RggcSJ8zA1BKzJRksc7JlXeVjBMOPcVRq1sjP/VSPj5/HYEc8fiEeFcZnXHzxITJllTvxVSVzZgOMRHSBELi3HXwn+12xcBxU4OKzjEp+RWiTUkA7pNIsKTDHpUDmj/YrBbFgrAy+kI4+oHcZvDzUhsmQny4LEE8HKZXJaV8V4vXWP4abkjiZ6KFKPVHuuwTar4Wy6N4/QPRcAlRQuZ/I34iPYaweKpKsGO30ZvHy7b685Y/TjZaQXcMhc66kXmDMSwIfhaUa5PsCdd/Kj+VnibH8ae2MJL1kh08JU3/Y0UeANzQa+cEjUqq61UiOWHl+aiype87CFuIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAXGdCYQp9eSpveWtiQaxYzpcGKubpc+RBDxS9edSHM=;
 b=pEjcDuAymHUfIE1w8VwI4KeTfhSCuqvleTxjju8ciouNzL92tLgpD5XU01uZBRC7PI2UhFi83dE/aysNXwONvPWvTbGLbBRPbdOSDl7eXGrj9NScCbohIRJVBgpkF5VSIj/MPf9wZN4IS6hi0zK+mADYjMMGtH5sk7TMHHVHIo0=
Received: from BN1PR12CA0008.namprd12.prod.outlook.com (2603:10b6:408:e1::13)
 by CY8PR10MB7315.namprd10.prod.outlook.com (2603:10b6:930:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:04 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::70) by BN1PR12CA0008.outlook.office365.com
 (2603:10b6:408:e1::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:45:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:02 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:33 -0600
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:33 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:33 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxl521920;
	Tue, 3 Nov 2026 23:44:30 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:13 +0530
Subject: [PATCH v2 03/30] crypto: sa2ul - remove unused fields from
 sa_cmdl_cfg
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-3-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1629;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=pIDuyaVmuvESlbbrkyRgbxxRQ/ODbO3cbn2Zvz8a6Pw=;
 b=doF5fO/Qm5p7udjTES7lVva6gegMr9iaOtr6p5vX4ni8ptISJAX7Xa3/wsi8O91g7hjzrv+3G
 rh/cvApq9jDCmhKwycBACdxhTc+COS3HpB7le0F7YJI3Gv1PwYu+skb
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|CY8PR10MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e033845-316d-4221-5660-08df3a36c5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|261021123027099003|261021121427099003|56012099006|10067099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	AB4KXMuKaNMfBbNUhqaQfbos57/RRP8Ov09C4pjAJeQ9mqOxkE3Mjs9q8iqhOSbY2NcFdIPe3oM84cu/gXb3vhrJj4b09FW2GGRjTWuYgSvE7ryq32jaBRn+knjINUNJqD0Jjd0i6Lq9SeZPhKEp46U5WCeg2i98rOnV1rlp9TRBwRLNUgrA0epkLmrqhH9koN9R6j+lageLeoE4zZpIlbsIfHvs3ti5sGHk5jlnTlyi5ez4o1a4GhMWDsAzI2Vtfvv9sms+rCgXb7Q8w8QEl8RX5BeapbdRwz5C+I/wfuOq7fVzFluo2Exwh6sQxs1N1kLVZ5A+Z6T4J7KTcrYbG+3URiyWpQJRS/d9BW7w4fkGJnjxFly98CmDyvu2zxxDkRKV/pygaYe8wMhwNO7aZAJDFONp6elRA5bHn13gQK1YBQZyVOJxsaAz+WGVURqASMJp63hHSVWQBWAPJVyucfSQLcPy08VtYA/q9IK+B9gabzbvOJU3BzIeK0LkzGsVH8O8hVI+GWqm6gXKYD54lD9PV0XNTve37nUPUwTWwjrGxYQo0ANEK0uYleIkafpRX+Tn0gcewBbGy6RdcotfR+VtHhRGNEHZzuZCUnNLwuSQprSe6O3I9EJLpeZl9m7+zSoM2Cr4lzlETlcrpC1VDzGuzBYt9i8TcJgLH7oCc81s48M8ZxKYuhxZEe3991EcYJW+oZOTkSaVhwi7kGOoFg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(261021123027099003)(261021121427099003)(56012099006)(10067099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xTwg2y+FNMhI1A//JCc2KbRCCVaFoxfubAEX1dmHSO8Z88IQe+Iv+fM1cej/ZX0Rtgvo4Ur0t8dFN+Gci8kDuVFcp9al5O7XlSDfN7rQM6JFdGRIe2Mx8fJcp/wMDAHNeByZg/gVeu39chwKIGH7pQyS0AJwYe5otscjdv+rrZI3DfLZNhBl4LlwNFIHg1QTtzdo2jrk8ZYCu37+RKWtBiWhSzFKnDSKHBUEO8RVV9hnAnsWHtzXymKzHNAcwsXSg2zAglPAqpJ9c+qtoRvA0qliecBfC9A7+xkhxMKMIRM985j2QccO1hrlUeBucDq2KFiajZHfwTGej1vQCy26OlKqBcMLTRpIm3jWFq75Hvme5Dl1uH8euzdPTcbsMT9TjzQwYOiSDXbHZpSL2+7v7MbsWtGMKL9QJxrNfj1CF+hPJ6ObhY3jpAb4078JOkf2
X-Exchange-RoutingPolicyChecked:
	b8WXV5tqvEro3ucKRYrsYnE2PMSlRMpkpz9o+3b5yjxzPyKKBQnTIZMIM6Lw88x2a7PX/K80Y41RJjYHmYi5AnXxdNuyxbUBEOVW4+JPJiFucmDHDbOgGcSilOemVeHHJL26WK2Ba19w1/ZSRDfzcvuIO5btuJel9lIF8Pb75pBUH3DaRUCvhrPxExloGSm09euoVRSfai8EvnSux6FaoYF/f22csfmx3rsnGgHweFOVS9CaDCdFkPHs9/P7JKbpoT01c40Hh9iD2dGBBEz5RiQm0PRMNVktnTDWdo05alHh3YrhNMLGaEZQMF6+QCnNjThvsuSCsfMWTRpMpU7/rw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:02.9153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e033845-316d-4221-5660-08df3a36c5c3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7315
X-Proofpoint-GUID: Tc4BPxGCWlZxw6E8LXln5zgujn1zygcn
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac666 cx=c_pps
 a=Ba9BPv0Mt2atAB5a3SkMeQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=XzX7fSRrjmGy88MpiZ0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Tc4BPxGCWlZxw6E8LXln5zgujn1zygcn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXztdSrVVUSa/W
 4/NDjpyM38OpcJT+fWlqoFm/tziP7uAwDbPX0LFZ3dNVByOm7lKsKW2Dj+/oRdsK7RpqKofer1B
 ptBI3AFaX0MCfKW5MKM8zDmKVi0nYZA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX0nHddaHxOenu
 Sq5vFDTSaMVfdCbNwp1tqZ9Ro1jCZC9cRPUGpYOZjvPmOeFpcqE97wJQZ+rhgoTacLdIikB6qCm
 Mdm7QHPyo9Av67xbSxn0vpVou2IHoMG6q9R+yLOyWhTiFoCgzfhwVfsCDEo98HpHybPmZr4+V2U
 u4ZOWOswiU739UoI0GqYTICgh7hUx7PndktB2LDd0SQM8NbxE8jmoYovChENiJ/3JCviaQSlPs+
 h6AnEpT/uN9vYvYtzl6j8ox8uLCQcT8goiLF9f04ZfzFOAtSAfYQjefRNpWLVWwkiV7Of0lpJNm
 11JpK5K6sA3pTrm5fp2RhlB5khH+6oJY7Hji1bsyGIfgPLThHoZCfHSKbeOfs7pejkLfgZCv4CO
 DdwMPpsYhck2RcvhmrkN5P3UU5fovfcJucgw2uvLvmsFkd4oM7zvRwyf+wmWiWorK/XKegIE35M
 JOAZI4oA3yCVTrIioaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

These are assigned but never used. Remove them.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5b43b0c63722..93c57758f107 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -96,8 +96,6 @@ static struct device *sa_k3_dev;
  * @enc_eng_id: Encryption Engine ID supported by the SA hardware
  * @auth_eng_id: Authentication Engine ID
  * @iv_size: Initialization Vector size
- * @akey: Authentication key
- * @akey_len: Authentication key length
  * @enc: True, if this is an encode request
  */
 struct sa_cmdl_cfg {
@@ -105,8 +103,6 @@ struct sa_cmdl_cfg {
 	u8 enc_eng_id;
 	u8 auth_eng_id;
 	u8 iv_size;
-	const u8 *akey;
-	u16 akey_len;
 	bool enc;
 };
 
@@ -1376,8 +1372,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = 0;
-	cfg.akey = NULL;
-	cfg.akey_len = 0;
 
 	ctx->dev_data = dev_get_drvdata(sa_k3_dev);
 	/* Setup Encryption Security Context & Command label template */
@@ -1703,8 +1697,6 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = crypto_aead_ivsize(authenc);
-	cfg.akey = keys.authkey;
-	cfg.akey_len = keys.authkeylen;
 
 	/* Setup Encryption Security Context & Command label template */
 	if (sa_init_sc(&ctx->enc, ctx->dev_data->match_data, keys.enckey,

-- 
2.43.0

