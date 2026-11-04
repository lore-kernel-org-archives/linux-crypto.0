Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771199;
	b=qESuEZgSgoQMgpRDnDttidMk7t0FIDXmaqPe6qnRucLSYaWM6MiWUW6KPIxou1inUbFW
	 qjFxrwFUM+9g7LXU5qt+6Z4cfXc+gW1xfWGsjzSrTgSH9xUK9FVmuChJP2PAjfpX4b7kq
	 azyL+DrFqTy/E+EerXadetRmmt8LOzdMp5Ahzyrl6jS85qzxCh/9DJBb2HtzWQ0kasHUS
	 UQ6oKG4OPhZmWPbEiR9ATbVzks9/CLVJpSX2aikmBoIjBGEIleARJjhC8srIkdi/BapxP
	 XcBHxzL2vkXptrmgzBBq38HpVIgks9tCqDyFJ3lAzjeomi2ZlJZfuZ0N1Teog2cn0Rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771199;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Subject:Date:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:CC:X-Mailer:X-Developer-Signature:
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
	bh=d7xhpQol5b4rVwLL4GfV6htprqMo/52KI2tMTLIuxn8=;
	b=nYDWsOushnrtISsazzLlJ5sF1BAzt/ZkEgL8Uw+Oyp7AkS3UV7NZ4fDQhDC5EgVptZpK
	 UELRu0XmKZDScqvzu6XMUy1vAjk0Jo3QllpLOM+mIDLdoWZaF549yLW/pDIjBd6jz955U
	 bervwyUb4gbnq5ZW13ln+RrEwE2HSjy4TTn8y0ZU1SbpuVsD/g76s97c9iPm8niniybiA
	 Ftxaby2gq9ZIZZjWFyO2asMWOBamop8i9HFJwC+7H3OeRGvWxitf/fPzDjNN11lCtW97W
	 48NBk019yjx6NDvJ+alx21o3HpbbhzWUM48v+6D9NbkMehMh209JzWQxfTfC8CuGPyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oSgr4zho;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="ni/BHy4Y";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D06606D80D;
	Wed,  4 Nov 2026 05:46:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84D06606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oSgr4zho;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ni/BHy4Y
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S0Mg2587506;
	Tue, 3 Nov 2026 23:46:35 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=d7xhpQol5b4rV
	wLL4GfV6htprqMo/52KI2tMTLIuxn8=; b=oSgr4zhoE75xaDLJiRuyEeaP20Qdn
	yONjSKys1vFnp611KiUGRugHpl2z5AepHUlLZ32rILYgQWeBEDgO+6oFp5JcUd6e
	1+5sgmqvqfD8SBJQDDvA1ouWcQWL7wlROVLeyF/JfRTJr4lteIsM6jdPbXlU0kgr
	smpWMFZopaPLl+bfHOgeF05tKBtMK70Oes+JKYhbltis33kAY5Y+mQPWZGNdScV2
	vFrxgdCGZ0GA/IGDRrOYMjMSlw1x4inUx5ElooQD4DO8tPDBQ6c+bQ0x7UTTdeKc
	wDAVJCrujloFp7PqWB6Yb6JQeMqoVTtj09Q6cUN1ouTb7QmJAItkCWs9w==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xmv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:35 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3OSKLX300uLFzbAe64cnBz0noH5jpvPsTqODjzx4Unp2+XWM33196C2LLh1/VxSmLdKQfiulTty+cQNsfhpohUB+SNVmL1dxhT2CIDJXUWxxAlDlhoVdAtcjV4hn/7uPxHf9Om/JJVOAJ3Mikd2vP4K3Mhe5TL/2yLC0aN6NFJAu+UbbV30CWoJDVUq012id/pDJVO6tdy8wgb8I2ouzdZyShwGFeq/3/q58J/ZNZbiBuqLEyOYkoUZUBIuKFOFbL8wBRWAVTANx5eUXr5/smCSEQi5VNiNEI87qmuYy9CyNdHE/uyY2gh7X9kBS88MpdPl5wswEAsGAtIoNYEREA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7xhpQol5b4rVwLL4GfV6htprqMo/52KI2tMTLIuxn8=;
 b=prLF3aKL3NZu2INCFE36oAI1D7vRNmh/BJ+AFETqGY1bvJuut88cZi6R0XKG9z5b+IEs4/aikghwMmJ022Tn56ZkDGQ3AKk8UBUcWvsLk/0evYxlqrAjyQKkj/e5QkePvcX36/JLcwmBZPxU5Ar+wU+4Ow7S83F8oHxSQJpaZ/CNxAOe5OuN5Z6Cu30bliK/yF+kZQMlT1W/GX6gD0F7ZE3IwbD7PL7FcegU5cagG979k4O3Ag4/vSEBk9Ktmm3NdtIQ1Aav/LeVoprSHhBKVoYSIp9hs8rZk3aldHFViPgDwziywY6tuK8MUiqfWfq14F5+iVSwlD5q2IooIDon+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7xhpQol5b4rVwLL4GfV6htprqMo/52KI2tMTLIuxn8=;
 b=ni/BHy4YqpUK4t4OxUIxdpiQxBao3FU8L/cXSVxO2aKSZB4QIEKnb/vQISC5QqihOe+p0vEDrvUKaDm8wLa/ppZ1waG9L3baf44h7DP+wQhZJPFRH1RmaGOmqohSr3pAwlF2n61KEkVAdZhD6pbeZPz1lAur6akwyiR8Jjtsjmo=
Received: from BN9PR03CA0098.namprd03.prod.outlook.com (2603:10b6:408:fd::13)
 by SABPR10MB997892.namprd10.prod.outlook.com (2603:10b6:806:4f0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Wed, 4 Nov
 2026 05:44:57 +0000
Received: from BN2PEPF000044A7.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::6e) by BN9PR03CA0098.outlook.office365.com
 (2603:10b6:408:fd::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:44:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A7.mail.protection.outlook.com (10.167.243.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:44:55 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:23 -0600
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:22 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:22 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxi521920;
	Tue, 3 Nov 2026 23:44:19 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH v2 00/30] Clean and improve SA2UL driver
Date: Wed, 4 Nov 2026 11:14:10 +0530
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
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
X-B4-Tracking: v=1; b=H4sIACrG6moC/32Nyw6CMBBFf4XM2jFtbXm48j8Mi1JGmYRXWiAa0
 n+38AEuz0nuuTsE8kwB7tkOnjYOPI0J1CUD19nxTchtYlBCGSlFjo3GdQ6LJztgsGrt0fVkx3V
 GR6VptXAFNSWk/ezpxZ+z/awTdxyWyX/Pq00e9qjmopLmT3WTKNAUtrlpqgqZq8fCVzcNUMcYf
 1BJe3q/AAAA
X-Change-ID: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=3964;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=KeON8uYX5lB9b/hT95sRI/k6djYtGPdwchx91eL+Fe4=;
 b=nrZWbEO3FcUAQwGosPTMFsAG1dT5kYGArAQjbl/JcRrdrcvo1Nj5SkyK3NMwTb5UXvJvI61se
 dIV2FfRl1UdB4wPqoqnpOjVJnKbls0e6jhoANppsd/9LZIXIZVoDoK6
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A7:EE_|SABPR10MB997892:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe92c70-b057-4475-09a7-08df3a36c158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|23010399003|1800799024|261026140227099003|18002099003|6133799003|261028144727099003|10067099003|13003099007|261102123227099003|56012099006|261021121427099003|261022075727099003|261009223027099003|261021123027099003|261026121527099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	nrOaTdtuXhpUIYeDY6xoMn32MrQRnMM+/wQXOcYbtclc6d+I/qnV2usGuouf31/UVnYN37HgEg8aw9lGQ1LztHP1rnlSU0SooeArnMJgECa6xcDUOrqrMnfuU8PHlCC1TX5C83cqQpDxWXKmFB0Xa1i9gvwnzMrt2P8lXlelLU/NzmI0lwt6m/beuyGprmSMiTYUdLL+Am3nHHD8umODV8dETmd1SasIIvmV3U8giqtNuW0tCVhPDwDELy9g3MFBg/rkUbtap2j7fTwbWYpHPxuhsuJuq7i0WVB+2YYqraftfTm//tnRBu9dkrJa6U53mLa1NcZtWEcOnvWGwJRnzWPZzx1v0S7LPtAXeJrgQuFl7Y3/irxK1zo2sVQ8LCbvQdZumgCB/zmstRjYpkc4Qul7tpPzJEI6smoEIfRcuOK1I9HLtEFe9E2Bjt0SVlm0aWz4YzjwIjvQpaTyOT2CMaiedq+lEufi+uFCZu0GgHYlAZkALHw9HeoQw7qLR0Mt7+roPbeyYP3PddPIAs4m+xFa5KrBIJgQCetFUDZBrRbwafY/DxtLw7L6pDHrGjpPLkn2W8Vf0WSFwfEmdVC8zOpAnm8q0MuPInasNWI/IFp2DSgcm7SmXuVWY5l7dkgHeQkYJB5f/skkq+j9Pz5SmA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(23010399003)(1800799024)(261026140227099003)(18002099003)(6133799003)(261028144727099003)(10067099003)(13003099007)(261102123227099003)(56012099006)(261021121427099003)(261022075727099003)(261009223027099003)(261021123027099003)(261026121527099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0TkvPUwB4m8ynVHauW9oSxERtDPVPVKgCIl+/v6uhhudp42LJbcswbC/fbbOIofO+yWSLjqdhwhKaDBMcLkTC2ki7veCGInWmDh7FivvWp4G1qgxB2TtFuPQyxNGtwRroi6CJjBRTEymUDpzeaLE3R3LDvG+0C3GKXSGYJpmrK++/wGyZnSPhu7eA802WVwn2R8JFh22w+iOPADh1RqzMmw6hEOp9fwQrhQyBz0fNClz80q/14s7pBLqP3PIfavSJeCN89oSpO/JmazoK1YFPWlws+Qkf9zjfCPPMAGlNixgUximykKSyxBxAFdjTVs/74uKm/t12c2I4fXJ6GOSFxQlGGaTQOGNeDNWmmKPmP5MwN1I6krL6wj/ns+aYe8l3rVyKFvwR467J1faEu8iUsIxBmcIwAZ1tsVgRzXChmwNIA22n7IVnMsRtJfM3uqm
X-Exchange-RoutingPolicyChecked:
	eQwsNY+/2sKjftkjWE+Iqm1qjoeAm6MDukriiG//aOn8nKJUdzQm4SjOZafgzbenSRbGmUiDss7tyNUqy80LcWy9If+g+BKg4J/QhR8P4jtSKG0pqzg3OdLxHfBK3LmbZXZelcBIxv1f+0HJFxPpRsRWvcXGmczldenQPHEfzwpOjDKzpYyIV9X8mqRkUms3rKhXRbNNOggFoQK8kfayrRnkLtQTf+YGy9w9gdezyYHoYfV7+AscfPRX/27cgqnZ48B1C/nhzQ2zA4TEpWjDIYzryVQGHvYmLsDZty7UcKYjF3DumY2vCrLYCl/hTit/9mx3vOvxjKRR/yNfphs4Cg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:44:55.5208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe92c70-b057-4475-09a7-08df3a36c158
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SABPR10MB997892
X-Proofpoint-GUID: F0xLrKYFYWCJxh_eKqSdlWKb8ExRGAio
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac6bb cx=c_pps
 a=0/xasGIuH+87ciDr1HSmcQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8
 a=c92rfblmAAAA:8 a=XfyYwj4SglJYBKMoMXUA:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: F0xLrKYFYWCJxh_eKqSdlWKb8ExRGAio
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX/37q6aJ/5j3S
 4ZT5q4LAMvRjguHygOi0j8Gm/8dpltoAJcm3ab/D5BekB5qKLLG3+JeV9a/PBekPlyaihucu7GY
 3fmFibT/Zi/iAuC/0iZJNLxrFzxtxmc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXwtzomcKlUJJ/
 T5yqI6mxu/6kOPrlogYoMdA/A9kPfyuVkvBthmELTIvZ/M5/vbyjO4VaDQjYdrNceksJ4TrYlHY
 9RtdhNrtAjjbYgNfjPJYR3Pvo4aK3jz3oak1IJ6tqdYx1NNNPbl3ZK789nF7euO7n99ZmfN9nMS
 aAn9a6RnhkVh4KUirJ58nrVUya7w12M0L9DJkHVt07/f5zIiyTFwik/V/DK20rImyWiLlQL1vHL
 ST0q0szttAvLvBF8VObu6wUhT71910c34uywT70juiH9T3VkldrfWTlMzNVnVGSbNVdCJPy8wij
 CexMMmu4a7BcW8LXcBZxE/AowtmW7xqE27tNSlGyZzX77yO4DaXYyrezDX/xxgDcps97fdqqVgc
 G6ipQBIGypBG4MtWDWdvk6yj+z+rsZrhnxi/W4llIPac8IavxU2o9AbpIazkqiahAvDhEXWrgOt
 8uP3hudhrFd/5xVdMZA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

The following series focuses on some cleanups to the sa2ul driver, it
starts with very trivial cleanups then goes to fix some bigger cleanups
and migration to crypto_engine which help fix the broader race condition
problems with the driver, thereafter it adds the support for AES CM as
per SAxUL 3.1 IP. KASAN is also run alongside to fix the issues caught
by them.

https://gist.github.com/manorit2001/0c005603f1a2da0e82c760e209ab0c4a

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
Changes in v2:

* Sashiko (visible web review)
- Improve some commit descriptions
- Map contexts at allocation and remove the redundant mempool
  allocation check
- Prime AES-CM before registering algorithms; fail probe if
  priming fails
- Wipe the temporary AES-CM round key

* Sashiko (API-only concerns) [0]
- Make the probe register mapping local
- Validate context IDs and AES keys
- Check scatterlist errors and handle unaligned IVs
- Synchronize DMA using the recorded mapping direction

* Pratham
- Use fixed hash/skcipher request sizes 
- Migrate to init_tfm/exit_tfm

* Self
- Rebase onto linux-next
    - Remove Assisted-by tags
    - Drop few patches that are irrelevant after rebase
    - Remove redundant algorithm IDs while preserving digest sizes

- Remove unused SA_MAX_AUX_DATA_WORDS
- Preserve full authentication-key lengths
- Propagate DMA completion errors in a separate fix
- Unwind fallback transforms and security contexts on init failure
- Stop the engine and quiesce DMA once before teardown

Link to v1: https://lore.kernel.org/all/20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com

[0] https://sashiko.dev/api/patchset?id=20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162%40ti.com

---
Manorit Chawdhry (30):
      crypto: sa2ul - remove dead code
      crypto: sa2ul - remove totally unused structure fields
      crypto: sa2ul - remove unused fields from sa_cmdl_cfg
      crypto: sa2ul - remove unused context fields
      crypto: sa2ul - remove unused macro definitions
      crypto: sa2ul - remove unused base register pointer
      crypto: sa2ul - remove unused includes and defines
      crypto: sa2ul - remove unused line
      crypto: sa2ul - remove redundant sa_sha_digest() wrapper
      crypto: sa2ul - fix struct documentation for match_data
      crypto: sa2ul - keep the probe register mapping local
      crypto: sa2ul - zero out security context on free
      crypto: sa2ul - preserve full authentication key lengths
      crypto: sa2ul - validate AES key sizes before indexing
      crypto: sa2ul - remove unused SC ID range tracking
      crypto: sa2ul - copy command-label inputs locally
      crypto: sa2ul - consolidate encryption offset definitions
      crypto: sa2ul - handle unaligned IV buffers
      crypto: sa2ul - remove redundant algorithm ID fields
      crypto: sa2ul - handle transform initialization failures
      crypto: sa2ul - reject exhausted context IDs
      crypto: sa2ul - validate scatterlist setup and unwind DMA mappings
      crypto: sa2ul - propagate DMA transfer errors
      crypto: sa2ul - calculate DMA metadata length from the command label
      crypto: sa2ul - correct scatterlist DMA ownership transitions
      crypto: sa2ul - use a mempool for security contexts
      crypto: sa2ul - use synchronous fallbacks and fixed request sizes
      crypto: sa2ul - route requests through crypto_engine
      crypto: sa2ul - report SA engine hardware revision
      crypto: sa2ul - add SA3UL_CM AES support

 drivers/crypto/Kconfig |    1 +
 drivers/crypto/sa2ul.c | 1265 +++++++++++++++++++++++++++++++-----------------
 drivers/crypto/sa2ul.h |  172 ++-----
 3 files changed, 854 insertions(+), 584 deletions(-)
---
base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
change-id: 20251106-b4-upstream-sa2ul-cleanup-ce85d40c7eb8

Best regards,
--  
Manorit Chawdhry <m-chawdhry@ti.com>

