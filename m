Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771181;
	b=jpoUvSGIZYJ8uNcJYd5PWzj7JpTxPcl0z4A73HSy7LuR1PY9M8wckkIuKLDC0HQJlDIq
	 EAc8wbBye7HEj4tf9tg/K+WmCUnFVCUElBgq+Lf5Q3yEK3B4Z0XDwzIbivHcj8Q5QbcQZ
	 yQYUzKq2n1VtdPS+pACocP3D/4bG54ChLaiHRCwkqqskRLt2NU0zYbu4GB8sUI46TLDO2
	 /4vwI6Su4GyhTehaCEoZ/mI97Mx0y4Wsi+EGWbwUC580plchIOz1+kUM6rX0hLBe+bgHr
	 D+xOOLRt/kpw0nShqrUy56XPfOOqde5SDg3YimiVI/4JHk1XpfvmTfbAzt7VpYYcgPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771181;
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
	bh=0EjpJ7hrTaNynuR7K6vvark6d08NFRRSw+f8js1MREY=;
	b=OPHh9H9IbeKYR6Muyc/aGX2BAb05trLsDk2BmWTM9vRxYQwxuCq1lPkeCLJpuophC3Fi
	 Tt2b8bzszdOjx8gPdbqiPQy7zvAOqVPSCczlP6KjiCNMXvHtGa/5knZYNA027xZ4no6yx
	 jdQQgCTw+0DXyAHHxQtsqCndyuT1qo+MVqn8F7+urqfOPcmiqYaB3Jjz9qvO8HVdhZaT5
	 B+RRAaj5LnqQQJW/vUPLFu7Mx38uxnK5/Cd2OFErGK5ROCChBNxjSuUMaK3DlLtkfJnsl
	 WyXQP3NHInwggv+gDFv8pVcc8NSpZzJbIjASiPLqvxZd1BAm3dDgHzyxec9XUoZ5DPQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nW1KgFok;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="R/4XM7/4";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08AF606A328;
	Wed,  4 Nov 2026 05:46:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B08AF606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nW1KgFok;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=R/4XM7/4
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40SVko772298;
	Tue, 3 Nov 2026 23:46:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0EjpJ7hrTaNynuR7K6vvark6d08NFRRSw+f8js1MR
	EY=; b=nW1KgFok9MJMVVE4bVyGApENwkVuAE4eW0QsOuiQPjPHxCGChy+JKRr2z
	8ooroK/BZcUmEr7rFdlKnx+/JjW55+Yj+ur8h60AVgQNi5oPlUyIVP8eEvO8/Md6
	rzhyv/4wo8xhcB/vHiJ9I0OwajI4hA2Caqhw2rjcshy+4x3Tt4QvrBIBgS1CpMTv
	iv0pisFuZFk0UKzBZ8ofkQnNstoi2p+S8OI380ZV+/6O/+EvPLqAp/stM/CAo/5d
	1Y8/4UQTRJxCM/eoecW6YrQtmAAhmV0r7sF6XPJHL/fHT8PJM0RumLiS9p0kArXE
	FkrVBqN47YQllxbt1u+RusRgRxu8Q==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25q2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:17 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+9roqi2JkzCwajgX0RGCZBKHIoCwhIs3Bg83YPdNfK7cg909dRjpQ0n0HLZ4Av/Gk0ojvUrV2OJU1Gyr6CjisaEFEPzdmDLNEtCtOPXlXYYQwF6Fg7+ZeCRdKZWZ65hGQvlBSrizNUO9Sp5jXUsFXQSSRT9jpt365kiwZ2vs9L2HQG+YpKl85abaRO+uMpRHDKA0y7fHtAL6tvVCVPDpLQP8pGjPHPvuQ++xO19/ozqRRSZeOVd3b/4+Z1vNpgY/LvSJrc0YwRGIu4oIKCgLrWr9SeaAO28nBK1m5ZRxVzaCFqsVwdJIplfEQ8vyRyHWwm1tSZa4FTWyKdFdSMiew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EjpJ7hrTaNynuR7K6vvark6d08NFRRSw+f8js1MREY=;
 b=AQCSHxEkaYPabGh8Hi8kdLBcuqmUsKZHysgTVrOvgO+5my+OgSdFdKvzsEa/0F/uPubjoT9NDnpGNtgxK3BkGtvIueqZnYEh+UIW8XjOT2Ne/pPp1Kk87x6qpTeHnzaz9hHreX5XA/R0xPZNGLKZFxn/CO05JK4xZPlnbdCis2fQ0NnMbuvPpuA2MJJsWAZ71OFbEfElrwtJ3FZJiD/OWVICOAhFYUt+9vp00ngICqviYkDsetMtx5oM4csQVVQ2DkbfnqgXpGbcj+Aos8k4h9pnwwif5ZmgflwcsBcyuURx5exJJISiSmeKveww/lliAFGDyiuKDraXUEAWIC5MSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EjpJ7hrTaNynuR7K6vvark6d08NFRRSw+f8js1MREY=;
 b=R/4XM7/4k/NKOoaoawyDkuD5qsSMdbQx6qpOilndmvU1fM9BgDfbEM0iJxjBqkc6m/j21ADctlQRN6+qj0J6s6SCrIPdGzXzt3sR8zic9Nh2ljHMGaNMBp+tOrL1PNjT69yMnu2fB1GrCJOVyUkZ0keiu2Mepu5ky7IwlOdwW64=
Received: from SJ0PR13CA0205.namprd13.prod.outlook.com (2603:10b6:a03:2c3::30)
 by DS0PR10MB6103.namprd10.prod.outlook.com (2603:10b6:8:c8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.8; Wed, 4 Nov 2026 05:46:15 +0000
Received: from CO1PEPF0001886A.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::8e) by SJ0PR13CA0205.outlook.office365.com
 (2603:10b6:a03:2c3::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF0001886A.mail.protection.outlook.com (10.167.249.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:13 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:30 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:30 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:30 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ02521920;
	Tue, 3 Nov 2026 23:45:27 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:28 +0530
Subject: [PATCH v2 18/30] crypto: sa2ul - handle unaligned IV buffers
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-18-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=2070;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=j0+sMSUprhP7Ppt0f/WiYm7DRovwQ+6PuYeum+aeXRQ=;
 b=oyNjYgpAEHLBuYS/OTas5ZH7RWfBX0FwjgdDVL9gDziynpdhFshrL71D1B5rNgK94FET2EmJn
 UGkq02OmZnEBJNwno3pO0505wgvalE1TD+8uExQOSWEydYjGixitsVh
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001886A:EE_|DS0PR10MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: 552e158b-6f7f-48b5-9805-08df3a36effa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261102123227099003|56012099006|261021123027099003|261022075727099003|261009223027099003|261021121427099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tYk8F3ByxESuTrV9qNZVZUnsNCizJhzFxvNbCbjAZCCn1RXRl3+5oyhzru60LpIEdXXnUtCWC8KeMrKdO28UFJs8I4Kt/lNiuCzzqwL3MAu3VxaCoplbWccZ2NL4gwHZfADUsik8j/YA7rV6vxJm8toayQqYtihzjxCB2h6JLWXVm4OhSW0MjeJMtYW8rfxHbHMgbZpi/ohUMwGW/EYfZ6SfQqhXTt7FHCvOQRv1+aqtA0ea/RrCKMzp+yyqyrm2k9su30Z/C3qLLIBxXUSfMIFsO+8kS6dJ2a4WcbxPe1uYZWX1HYDmhG//v3GUfXxzSoEBdqVOkdOWccoWjWhQ75jQPeiI0mrdSh0KKf6/RgouECuWCTRIZrdJWhP6NAg/dTzBCW6ylBt+NoPK0dDwf54+7IgmsG3+JiCpn+shkGSHjuxt7GpxJHLg2QdHhvnHb7clx6rbA6s9E74WlvjQdusEBot6LT7Bpe5EW6HkihN1/GR8rk/gnwbaqVaIWE8wY+5ItSYBodEyXYezbllAYC2NCtak+jVFmxlqgBc9dHRvgYHmJNNfOm3UIasrGS0vnX68BHEFl3Lci63jgiCNOT0Ax8tgRBuBeI0EJghCmnHb2l46LOgc5Aqc+RbemFNl2B+rKgWpeoUES9nn3ZZmIrarGriCFJuKmpIIRJXoto0YYsJGgE3aIqoIHkCbGHTLeyaZYrbwA6WZBoITGMenQQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261102123227099003)(56012099006)(261021123027099003)(261022075727099003)(261009223027099003)(261021121427099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zNEuPwVMte8aLROsy6IfYngSBfkuPFiOGOClDk1zRSpVBYQZKylZajsqlE17qqh6rATqBKt7LlW6GSYq01AeK5EOovC2KiFb+myPtN7vqPlHZVY+f83nTOBmS4qE8+JakGPVNGK+GFLMFJoUx9gHkSII/WnN2x1L1cyIKWD3y3cUkKkSlVa2IysHsZf5qsLCaNtfyaLJnUWXy1ccO/9cEXD0A6b8CR2WJDa+NHmkQOWTyWRNJp4V7Ypn03h5v1lyWcY46xBmG697S4oorXgrCrVw9ipsMaAU0wPz7IUJgDs2sHpf9xA85A5ojOU9OUJKE8KSjn1pWB1KoLuAZpOkG6XoHf1isoPfmOfAodHewMnwJPN7Ig+6B6H9B7JxQ+33XIGqdbiihCYyPUXV/f9IB3C1PAmbEYLnCyJyrvcFdNdSmwx1K9Kyt+oFD/++y47e
X-Exchange-RoutingPolicyChecked:
	uoGP/6/xhA38gmd4lACDu1DSqktrG61CLhfOvd/5f3JkTheduCmQ7nS9Tl0LcYiPu1XlAi7Lw/u/N3gYImfthd0zuQvcRaVwEFBFAUjJoQS3YzPh+v8jqlTtjmsLnDdrrD8i+l3xip5cJMZC3EHikS2Ua7EBL8UOe46Iv2ULisHQvJRyuYulDIovkiecXc24KbFIvXk3kgNwX5XEQ8h/3jf95+jaeIaQR8H1PTGHgofT98Ztc9LsQxAmzJuWophYZ2iPdZ+dUNO1sIvd4lDkfeOMOGQfJBUu4T8L3fyWKhMvVbio2f2uOxBD/zCTTfptfda4YG7pT8TRBCEEFWFPRg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:13.7429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 552e158b-6f7f-48b5-9805-08df3a36effa
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001886A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6103
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX1gDKefoQU9/T
 8OGpeWKXfVauNCCY03ATpvw4lLvCYwign8u8NKJP/ceOW2dX5buRiybEBODua8T6p+4aVgt8ohM
 WP1EG8XuQ/OHFUHCN73bYERW2vRcayM=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6a9 cx=c_pps
 a=e6K3ZeJSw2wYQu/wAm/p+g==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=EUCicXn60Vb949Nj52kA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX12MGCnHNYxta
 +ty/sW++/RuzcxzaoD3N+dmMLvh71rPQUK/HFCbgQJlxuNMJfX8phl0C/W0t3U8Z3S3tZP45liS
 pyEVavr7APpqmrpuvdtlc6VxF/Goc5MZIoeFFX7NDmDx+S0PP9TAc3IkYAli3xwILpOknzWvJsG
 AJeWywZiY+dSpeDe2dToqT64b32tMgivucBAKJXTcD64d/1aKWDzw7lJINlPiGQ00IyFu1L+Phh
 Rnw38/SZKIGICM9zoEWRntHW/jYBi7AMUamV7LYgT7f7vEUZNZkFe3ILCeVq1TIXuOjxpabzeyc
 nw2+h069SPRSLMQf771VzVBg2r0dainU2+JgDBzxJR6D6nPTVM2Ka4UmXAdKaxQgQZcDb5FZEZg
 4++8rPKFL3Ci5GFsa25Mqp08/jGGuBzTzhHmgg49NrQLUKgDxMiIo0VNp26ly7W+FEo4OFeeSXe
 DFCoqE1zJv/2rMEYHwA==
X-Proofpoint-ORIG-GUID: QXsv1X5HnD_gF4xZEEDw4fX6ckrrvj1t
X-Proofpoint-GUID: QXsv1X5HnD_gF4xZEEDw4fX6ckrrvj1t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Request IV buffers need not be word aligned. Use unaligned accesses
when formatting and returning IV words, preserving their byte order
without risking alignment faults.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index dac0f8a147e2..2c1d51b1cb88 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -14,6 +14,7 @@
 #include <linux/dmapool.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/unaligned.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -579,11 +580,11 @@ static inline void sa_update_cmdl(struct sa_req *req, u32 *cmdl,
 
 		if (likely(upd_info->flags & SA_CMDL_UPD_ENC_IV)) {
 			__be32 *data = (__be32 *)&cmdl[upd_info->enc_iv.index];
-			u32 *enc_iv = (u32 *)req->enc_iv;
+			const u8 *enc_iv = req->enc_iv;
 
 			for (j = 0; i < upd_info->enc_iv.size; i += 4, j++) {
-				data[j] = cpu_to_be32(*enc_iv);
-				enc_iv++;
+				data[j] = cpu_to_be32(get_unaligned((const u32 *)enc_iv));
+				enc_iv += sizeof(u32);
 			}
 		}
 	}
@@ -957,7 +958,7 @@ static void sa_aes_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = data;
 	struct skcipher_request *req;
-	u32 *result;
+	u8 *result;
 	__be32 *mdptr;
 	size_t ml, pl;
 	int i;
@@ -968,10 +969,11 @@ static void sa_aes_dma_in_callback(void *data)
 	if (req->iv) {
 		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
 							       &ml);
-		result = (u32 *)req->iv;
+		result = req->iv;
 
 		for (i = 0; i < (rxd->enc_iv_size / 4); i++)
-			result[i] = be32_to_cpu(mdptr[i + rxd->iv_idx]);
+			put_unaligned(be32_to_cpu(mdptr[i + rxd->iv_idx]),
+				      (u32 *)(result + i * sizeof(u32)));
 	}
 
 	sa_free_sa_rx_data(rxd);

-- 
2.43.0

