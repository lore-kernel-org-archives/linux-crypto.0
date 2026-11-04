Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771178;
	b=e8jKevYmndcjyVETH53GTUfY8Mfjw+PbtRxOmqZZmA5NvY5UpCaEG14QEGbIvynDsNP8
	 ozMcUS/NR+CIhfsoIWF5NXiEB7LJSbhLAVIQZ5vEgKe3NXliwIDKY80Y0iOklU+L002Kx
	 sc0U7KeAZiskTyfncpcuTJcAEo4Hk9w12eBPqI+rbLp1sY0tQBze4VfutL8gPthKd6awx
	 s0NKK+XHR75joyTGGEte0C8oEG2DTTfDwLTKA3j0CeawXQ7Zw3caMMBrZAAAbJrJnmWVg
	 9rhezOA32opT3Ad3dPWtrYWfQ6oz/K6nkgds8Xxiq1rmvHrjlT0bLcqTN4XTOSoI3kg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771178;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ljh/JL3mnOUqTWTnQjINtqX9t4GdBuW8tD+0T8NXclc=;
	b=AprSjKExyUa388bC0fHbtPtA/19LTpbB8i6CptN+NLZmvfuZ/FMuLBzkkhSi5bpoU0e7
	 x+vBxEc336yLWGgXTm32GD2f1d593ivYFBMlRAkZB14Exbz8XE1K20OhCxOBplLdJ7Ysg
	 neTBCJa+DYI5et04PVQ35HG1CxoidO4JmghAuqz9kDI3DPeOwcpvlJM5XsvjRjpiN6bVC
	 gJbn2HYmMAHXG8mWWva6mnt5MpuDq8bHjdjLkfflnmyGKiPy71NG+A8+PpIwyLVE+tppK
	 4Wjoq1uosJ3KWeOJPqNea6JQ6L5h/TLd9kcVEjwTkkMy4KG2CgpnrO7tkaR/yun77/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=eWgjhQiK;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=EABMW0bJ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A15606D80D;
	Wed,  4 Nov 2026 05:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90A15606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=eWgjhQiK;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=EABMW0bJ
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S1nu769906;
	Tue, 3 Nov 2026 23:46:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ljh/JL3mnOUqTWTnQjINtqX9t4GdBuW8tD+0T8NXc
	lc=; b=eWgjhQiKdJP5v2at8jrMt+W4NLVxoa1Aaue8EsiWel4CQ3mfnfewxZcnM
	0EDP6Arb7IQWRx2Y4kM6fO6dzMok7VxKT3GIfBdQWBk2lyYAfIZzsFZc8rwb+qiC
	qiTrs9nDTD6XBF2ja6ek7GUorlGm5m4wns7kburVMlPs1JcYSfAPVbUBkoiK3C/6
	kP9IL5SiNMKn/g8eP8SNcdLN3EHMYhLGhSjsqKUYCOUvTCfBKKainGrh6twSEaZq
	r7sR02y420sKSaVImWBLIWAUdKbDh/jHoUL5r3r0iSoq/1ENs7ESKoISG3K+kvJU
	H2Hd3tPbB6LU2dzMDKwqHw8bULSJA==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25pt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:14 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvVPMcIgo5OhZoI43MFEdyHerm4kJDxHOQWyZFfDUfsg/PHpljBKFIucj1oF9F/ncJajMPzNQhrEkQWV4AEJ0tMryFh0KFx6bU6JBCQeriHHOZwPwV9YYfAtzSjb4PZXxOWWvHjY/ZGN18iMXxMpx3GR1HFb/rL1jc9g+gz0NJclfqJ39rSuZI/2YbkkY5F9S7VU49jpgnAr0GvM7Ewz8AxBP5gvK7LMhx8ssRgwO2tAgf19z9Az0ImtiSZ0c9milVFokplvqiruds/nQQprzl8rjq+H4thiVQMSk3LBedhoIN1eiQgYdC+x2vGtXiFN6TOqjumgrYwrZkVt35KvMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljh/JL3mnOUqTWTnQjINtqX9t4GdBuW8tD+0T8NXclc=;
 b=LlC0Q86rVeRfnNmIVw+fDHDPi/OhyWDiynhm3j5OGQVQbkRi9CQaWOepB7qy2a5OYb02fbi7VXieUTqQ7o+cJ7tTq10upXRYNB277pYlQIOulvpWLLKax++M3pcQ+ENVFRrgq9dUVd3et5QMEgOC7yOqWL2D98XcA4TZI24yWhox0K+J6fMyD6hG7RhCFrcpzrn7yxIbIZKcf1xPGQoJKaC2tkQesk6d1IR5EAXhZm2YKcBNRIvpaHv3rRwJyjXhhX8t/iZ17mfaGw1Aj0xPi2HSrrHCdmY33a9pCgA8k/XybM9RFcoSFY0dpF6jJozqF8GjheQZmZYnT08BX/t1sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljh/JL3mnOUqTWTnQjINtqX9t4GdBuW8tD+0T8NXclc=;
 b=EABMW0bJheKTZ+72YMfBAwsybffcHXzqycfohXmAUyneOg630ZJUpARYIQVCyrSio1LRHss4GS8bx7rCBuLZbE2Zb1RQqFTVLjACYLllptVz7Q7OMnf1BdRXau4Ltez0Qeb88UcxYhYH0hmkVu3BwiS70BemHdp3j+ayo/D5heA=
Received: from MW4PR04CA0312.namprd04.prod.outlook.com (2603:10b6:303:82::17)
 by CH3PR10MB7332.namprd10.prod.outlook.com (2603:10b6:610:130::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:46:10 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:303:82:cafe::72) by MW4PR04CA0312.outlook.office365.com
 (2603:10b6:303:82::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:09 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:47 -0600
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:47 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:47 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ07521920;
	Tue, 3 Nov 2026 23:45:44 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:33 +0530
Subject: [PATCH v2 23/30] crypto: sa2ul - propagate DMA transfer errors
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-23-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=4713;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=pMNkuMBcXZn0xoUGCBt75Ao/Kyy66PYz2l/x8dxCZNs=;
 b=BdVbQ0m9LDjcwJjQ+7c05/CT77dGuExS46C9wG9FedBkZXJzJz61xMaJvTAby8MXpN8+9WBku
 z0Lfx2/NACaCotZsbr+7R20p8h9OnDWQMoX6IXte1obJCq0m+W59Twx
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|CH3PR10MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d4151d-7e3f-430e-f652-08df3a36ed79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261009223027099003|261022075727099003|261026140227099003|10067099003|261102123227099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	BJVSHwQzMgnLtRJDd9GTOhPsGMIfDtQyg5C5/M0JPNyT4vrdU4mbKzuqTDcawYa5RoqBPSausz9y0lxV4/o4pf5zPO6c1Bygf4aJ0uY8vbuf4T4dbrRTaHKGiun/LsflPsIMOY44DbSHT7eJTuV5zQJ6dhKK/SfMYWKlIkKoJ25Ncve6qy+Ndp9IfDrDTpgZQf7y9REl+YfYcSd5c2F85A3rFxqVOO3jSU7BMJv/PmAhpY8Y5nZPv8dW/4PHyVZbiEWtK4Lt13YInbJzWWIxepuYKzr5MouADK6KoexXNCn5NBkA/yvzzDZCa9Ig97ZxAbeIofe/HsnW87u5pQOvjP5MLKoBn1LBtK2ObODdIMjJtxg2DJS6+3AtONikAea8Yyje6yecJzNhuARCRSIELeR67LC39c21A4DEQVMt/YEbFyEZkEcBKIpbbAaZURVrgUnwnMWtNaTWg3XaGYw3zpPChWL1l95PGcUX+pJWepYBSIz9Xj/9vPDytZYgTWYVCb1GjQj7MwEzKe/lg9eFODW7zyRB4CxloryysixRKtwO3QM1YY6SCuWUPDhuF5hmgo/7r0lR3mq7pE3j5cQ2QATmSifxJEArAzAdy6kV3ulmngnmYNxsilrBq7+OlJynC+qe7iFbUOahtP/JXzhmQq6or0CxDQh1kr+Rc0phU5x1gzN7BMaotV/ypUBT8ZyNK8o5YCNznhvZRWEiP03MnQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261009223027099003)(261022075727099003)(261026140227099003)(10067099003)(261102123227099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rCQ2/ia1OhlAMaUUdiGoLRMugGWnjh6o9z3TqUNtQKacSgxPwuAWJhHPEba7CJdao7wtcB/ptk4jHJc9jeznuGlHKe5DeEtImqVyIngSoSrUR6GsfD9HdkdcolmeSm6FxxbM8/+779lEPn1gA2ZWgoGHx185Oy0polVLvSgc8LaVJZ8k5acpnS7xERi8WU8MlUVSYPjfckpSdGzUWdiiTZbzkf5gxiqri9KjDbcRTpTBS67Sju3Q40ZCtmsCASHDneITY9Vw0+H8fY7V8VmnHPkt4cwKckj7vsvHcFzIPMV9AO5hwN40+z4u+s8Q1vmegm6bTxbLLu1Xdgubog4IQNIXyuqIL5pP4j0F1zr5WCJ8Heprz1typc3TEJpg8l3GCp4NX0bZDJmrBn8nrUr3M0LeNBlKn2cJdJxgTakjCMVvQFhLn2ZfGCOjptr45GgJ
X-Exchange-RoutingPolicyChecked:
	f2tF2vM3qA/8TSAVCU/6QSFmh+om737Yx1Ldr/FTj4C+DkVxJrDNU/AhHCMNqVKK4dt8Tdt1oWXcWAiBaapmt0SoQSmX5ily9QAwb7a080C7K5vCCkaA6xrMYJ4tVjWXln4TIKQA+LPsoyAXq2WjibXGM97YUAfGq/c5nlEw9l6YgoAoMmBZ5E6nglp+9OiwytvMAwsLAFZabC7CrkSXUot1M6/rviptqSVQxy635GjBH/s8wIc9wUqTkKd8DduHeiItcA4tFWc+3tVYyki4P8K43iNjNrQDGeQIaD13Uikg8EHQpwIJzWieVxL1Z6sO7ckRRqUhg75XY1IXs1MLEA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:09.5398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d4151d-7e3f-430e-f652-08df3a36ed79
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7332
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX+Nev8nOy9yxT
 2GMw0YuMZt2yoXe/Y9et+Tc8ljR2Zq1KzRqd3VSG32x2Y96kOD4EZKNpwxecOhMDNpaRhXf0eBe
 LHVF+9iG9gRrZ6thzxIE6EOMKA7u1ug=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6a6 cx=c_pps
 a=NwWuzY5ekLRC++Nx77IK4w==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=mgCP53XaKREKiEuWi3wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX6867b9ELZHjQ
 g9O+Z1QjChYJ+0GxiOqohzeOHl5qKCq7N919WZblQ9jqaCf0g8ItjNxYcYz0k8SZ3X5n0d9BvyY
 /KT/a69vgVQBN497iW1Z+uOY8JAuQQ4etbmr04ry3HM8I41HXkL48n3Uj1Fd5ql5+liR1QZ9lZG
 HzZ7cPk0dqPF/ebuFXGTrOlFlvNNRL4On5a1IqmHLRAeqCha8sPfOrfN3olyCH8IGLjATs6l5kE
 +LHrSLN9qn/P3LX9daaYOyzdVyW3R2B6Ap+A2zefO/ip7XbgRxit963MpnFU+im/m72UA2jBZMp
 YkobvAZI3EJhhKYu87LmawcjrGg1dlDw2hUorTG6TWy0QtQ1sQz1bDkQjJzUsACRTudhF3eUeMN
 ERCFUXXPcqnC5OG5CgffT7MCEpCCQoRXlCkHxRopIOBl3qR1v970EZk+4PRICaboZFg/Whzz+p6
 LVbUTcV5pfYlIivHUPQ==
X-Proofpoint-ORIG-GUID: ZnGI83-qnzO0LrBMJpTwgZgi2uVgFnvo
X-Proofpoint-GUID: ZnGI83-qnzO0LrBMJpTwgZgi2uVgFnvo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

DMA completion callbacks discard the transfer result and process output
metadata even when a transfer fails. This can report failed cipher or
hash requests as successful, or an AEAD transfer failure as a bad tag.

Use result-aware callbacks and return -EIO for failed or incomplete
transfers. Skip IV, digest and tag processing on error while preserving
DMA cleanup and completing each request once.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index b33fac66c93f..18a69c890ee2 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -199,7 +199,7 @@ struct sa_rx_data {
  * @enc: true if this is an encode request
  * @src: source data
  * @dst: destination data
- * @callback: DMA callback for the request
+ * @callback: DMA callback receiving the transfer result
  * @mdata_size: metadata size passed to DMA
  */
 struct sa_req {
@@ -216,7 +216,7 @@ struct sa_req {
 	bool enc;
 	struct scatterlist *src;
 	struct scatterlist *dst;
-	dma_async_tx_callback callback;
+	dma_async_tx_callback_result callback;
 	u16 mdata_size;
 };
 
@@ -951,19 +951,21 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 	kfree(rxd);
 }
 
-static void sa_aes_dma_in_callback(void *data)
+static void sa_aes_dma_in_callback(void *data,
+				   const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
 	struct skcipher_request *req;
 	u8 *result;
 	__be32 *mdptr;
 	size_t ml, pl;
+	int err = dma_result->result == DMA_TRANS_NOERROR && !dma_result->residue ? 0 : -EIO;
 	int i;
 
 	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct skcipher_request, base);
 
-	if (req->iv) {
+	if (!err && req->iv) {
 		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
 							       &ml);
 		result = req->iv;
@@ -975,7 +977,7 @@ static void sa_aes_dma_in_callback(void *data)
 
 	sa_free_sa_rx_data(rxd);
 
-	skcipher_request_complete(req, 0);
+	skcipher_request_complete(req, err);
 }
 
 static void
@@ -1179,7 +1181,7 @@ static int sa_run(struct sa_req *req)
 	rxd->enc = req->enc;
 	rxd->iv_idx = req->ctx->iv_idx;
 	rxd->enc_iv_size = cmdl_upd_info.enc_iv.size;
-	rxd->tx_in->callback = req->callback;
+	rxd->tx_in->callback_result = req->callback;
 	rxd->tx_in->callback_param = rxd;
 
 	tx_out = dmaengine_prep_slave_sg(pdata->dma_tx, src,
@@ -1274,7 +1276,8 @@ static int sa_decrypt(struct skcipher_request *req)
 	return sa_cipher_run(req, req->iv, 0);
 }
 
-static void sa_sha_dma_in_callback(void *data)
+static void sa_sha_dma_in_callback(void *data,
+				   const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
 	struct ahash_request *req;
@@ -1284,9 +1287,12 @@ static void sa_sha_dma_in_callback(void *data)
 	size_t ml, pl;
 	u32 *result;
 	__be32 *mdptr;
+	int err = dma_result->result == DMA_TRANS_NOERROR && !dma_result->residue ? 0 : -EIO;
 
 	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct ahash_request, base);
+	if (err)
+		goto out;
 	tfm = crypto_ahash_reqtfm(req);
 	authsize = crypto_ahash_digestsize(tfm);
 
@@ -1296,9 +1302,10 @@ static void sa_sha_dma_in_callback(void *data)
 	for (i = 0; i < (authsize / 4); i++)
 		result[i] = be32_to_cpu(mdptr[i + 4]);
 
+out:
 	sa_free_sa_rx_data(rxd);
 
-	ahash_request_complete(req, 0);
+	ahash_request_complete(req, err);
 }
 
 static int zero_message_process(struct ahash_request *req)
@@ -1584,7 +1591,8 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 		sa_free_ctx_info(&ctx->enc, data);
 }
 
-static void sa_aead_dma_in_callback(void *data)
+static void sa_aead_dma_in_callback(void *data,
+				    const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
 	struct aead_request *req;
@@ -1594,11 +1602,13 @@ static void sa_aead_dma_in_callback(void *data)
 	u8 auth_tag[SA_MAX_AUTH_TAG_SZ];
 	size_t pl, ml;
 	int i;
-	int err = 0;
+	int err = dma_result->result == DMA_TRANS_NOERROR && !dma_result->residue ? 0 : -EIO;
 	u32 *mdptr;
 
 	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct aead_request, base);
+	if (err)
+		goto out;
 	tfm = crypto_aead_reqtfm(req);
 	start = req->assoclen + req->cryptlen;
 	authsize = crypto_aead_authsize(tfm);
@@ -1618,6 +1628,7 @@ static void sa_aead_dma_in_callback(void *data)
 		err = crypto_memneq(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
+out:
 	sa_free_sa_rx_data(rxd);
 
 	aead_request_complete(req, err);

-- 
2.43.0

