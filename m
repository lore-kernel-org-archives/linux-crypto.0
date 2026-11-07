Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067660;
	b=ee+xq8BKgDbP0bmYS61hfcUYK5S2jNmM3BSOuTWgi7PKC5WN/DYqUAq7LKD9bPJDs99W
	 OJMAwactfPZPfKoj2vTdlzzKWJFGVwH7+OVfi70n19oJJ6m3ugxK4E+lh3qyE5OlyXNAw
	 rXDWkoJ6zz4z3Mzh6YXnStc25yJLcuJ/SoPKsJ0tvwHkRbH4DzaebmC61GcNtbI7PJvJD
	 h2larIbCPhnaRQ31o084d47L6UBdegcit21rgoP37mbrUh/fanM0jUCQUqF+rzy9f80YB
	 Ph5K6/C0Wm+ZzDQi3uYadpkoRWMkN/rCrqKNVJpLsSWqzwmT9Fx01MxStp0DlP8zYMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067660;
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
	bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
	b=r0kHqem1hz/2BZ2laiEWRqjZdMVg6uYxsxrLVOL4dBpA+4Y3BxqNry/8EJEg0P6L1vna
	 WBOO6dmWhajo89xpxTe2wMb3XF5eH5AMXnK8hmc30bq6fwMQLp1Xitsm1YjyMwWbWVVuQ
	 A8rvIpZRrzpNtextBanVsrfWjVEyrAxy8Yi2Jo5jm1YKnHF0kQHg1NNPcXK3IQHrfRyrY
	 YVzi+jzT2t7vbdLSruQSETjhMHsVAzJXbNFDcoGvzpBfRGRaosMgZPT52g1lNyMUF8Nzl
	 jbEclB4ulNvZDnOQ11fjhcPsen7l3y0ef95lhZ7jgPUfukPx823oOcKdX2vWXQLZzzA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=fREQ5AMq;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=N2qK0Znk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4B606A326;
	Sat,  7 Nov 2026 16:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77F4B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=fREQ5AMq;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=N2qK0Znk
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7F01A52335416;
	Sat, 7 Nov 2026 10:07:37 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8
	R8=; b=fREQ5AMqNnBzb5Os1v29lzanUihZP9bo6sh3NFs0blgRzzHMAURNRLBye
	Uv1ApsEibN83OdOVHiuM+HBg0bkjpDY98/9gJUQy/EwydrGMDjM9cGE5odll0Oml
	kgnaEw1YTX+7sjdEKMES56Ga/3vcTOPfH7bpDzHqXzTZtPOgMTLbVf0yan9WT+Om
	K/j33OsPKXb6bJLQRtiN81z+e+itJFHIkEfRyPz1wEfD480OB28sob5dvBQEQH5t
	D5P5QJ4ryfUiSaWCCNS4oXGJA0IPnAGnOt9krwXshHjzF+I9aqwUkKxOSxOwVYW9
	JtZ+606Xy2ET5LKF/rrBpoO0mRluA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydvt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:36 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PsmoCkRR7y9BERvY9Q0EiF/OhtipkASy5v9bEZ4QoVkaQqGV1r4+2Cti+W4viOYqHEHEAmqB9uENNjUcrJlLezHFutGpq5Ouo2kKxQgvipzBVL1/SxdtkfZjYPNtATgna5ZLvOHaErMr0E8fGOPk1YuJlXZI5xiovbLDsGfCyuFzH3HPzTjT8Rq+GpTy40wj+mkt81ZS8ihBpPXQl+YMV2yihSxAA+Lp2cHgpZpi6mIInsk7YrViO5cqoKsLGCh73/BjNiYMcUGFQpZCcAZL8EiC8BiqKD1sNaEWeLQkOgvjGDL7K0/Kr2528Ge2dgoByb5yB3wZcf76fdgQPu5Tng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
 b=X8k8vgnEg7fAT1hdHvou97lPy1Fy3RXuqsfxHBLY4kw6oFWk/kB2Co1FgTZnVuxFunRa2QBGCdLk+2/diiyEr5ySR92FuuAFuok2NmlsQKGGcgbFpIYjkrtoHqicRq5minA2PMrAUJVQDW31WKyMRb2fIk/ZfQq87GPXikG4ALsPi6YRgA7FP7EYr27ui+PfPVKZ2K4My0xeH7iM/sPA4LPBRX9itXnl0EiAJqHW0PYHJkOhpCrTtOahDf3JpCsQXo+DnTYzMAreBskcrScq+fYMTyVG1N5tmLkf0KZzlKNhijCH+3GEApBqHmlmrvO3B7zqEVKWU1cfHbOZ6K88vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
 b=N2qK0ZnkjsHyjYfSCQU0Uwni9ATugV/veT896ZoF3lhrw+Jx6q9GtbY6MZgZPmixWGg4XjulsyD00OStwgxCpA9Mgo1q8FdePsmAwixsOCKcb+MtFjgdYMYu31egO1qUegEwfV09wm+gWfDtDG4kiIJJUYiyh0wH9upHBZ0t3PM=
Received: from BN9PR03CA0863.namprd03.prod.outlook.com (2603:10b6:408:13d::28)
 by IA0PR10MB7624.namprd10.prod.outlook.com (2603:10b6:208:491::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 16:07:33 +0000
Received: from MN7PEPF00000150.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::33) by BN9PR03CA0863.outlook.office365.com
 (2603:10b6:408:13d::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 MN7PEPF00000150.mail.protection.outlook.com (10.167.254.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:32 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:24 -0600
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:24 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:24 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7NBa3460249;
	Sat, 7 Nov 2026 10:07:24 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Sat, 7 Nov 2026 21:36:29 +0530
Message-ID: <20261107160631.2592763-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF00000150:EE_|IA0PR10MB7624:EE_
X-MS-Office365-Filtering-Correlation-Id: 86da9e6b-ef2b-4253-fb17-08df3ce93b59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|10067099003|56012099006|261009223027099003|261102123227099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	VnRRumUmWQw204AMrtARcgfC/iwGOgClKH3kCdQScyHDqUTQKcBr0EqHtavzI68jM7fvvgC21E0aqN3XZty1pxc+1tyFo8gmmOIY0vIfZW8wy8NqRlcQ4UVRvy1EBP6zLJolI/AB6xjiyl1F4T3y1x/0FXj2mbM2GUxrwNo5zMWAzroHH4g8yYcSPamonAvTeFchfYRFAEiNRfxOJtYfszk1P5HwOlef75rM9hWQAVKIo9Bn8LtnvfC3cNDJZl1gXXlutRiStBous2ogSPjrmc2jy4CcmPnl35GUyVBBww1zpBIUt6WQYVEsbimZ/gZc5ERW20al/wdUIC3ddr9LlP4dm+G/Itsh0k/pxW+iol0oplvw7oLo2LrPMwed84XSvKjAUMbrCmzLbK8PgwziO2YaFp+JefF4+/2SUi5cu/MUFKt46ps2ldIBALBPPxedaCB4RpkHcQIpjp5y8R22hrW/zjGwPl2AyPcp8Sy8PRuW3Gkp3KKTDokzYh4T5cRz1g9+BqE/1jSbnUnNJms7Q461L/ySR31pzKKsHzx1DYaFD7YB/yjvQLvbzUoPC3eX3S6Gn3qAF24iplc428XaeXSba0OGZNBgA5iVfY1JrXKBcFl+4HsaGIdKzXubK5YH+7O3SsHF2VN0VLFn0p4j8sooNuAU9qWTKnOwgoNFcsVMjIcgzEkgqa4k9pz9ruf0C8FFmiOF9vPcu+Ils7ErPw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006)(261009223027099003)(261102123227099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YSpqI3BZmxiWMRnHyGIoLiM7JVsjykh7r6a4IpMqPEXpkK8XQP1IQLhMnd+zng5Zy16j2FH6NWt8vkdo5EvPUsT4Q5jgEOKfG1Ek3HfwijgPGwuKbya+6kbfLxXfGZORKOJqpF5fi1BQk57o+c5JQgW82TrofNn6KJ3RrCqOi2Hpt8ku8+KuNYyr4JT0J86gdvLU4b5YPNj/oVA72LTEHeFKSwFCs/N19sAt1OM0hsEfqOIVtkmkyFUIA7IYi4OPqYJzehf9GUv4apdrnLqV7qV1D1uBEpMaf3yqMPRyxV4sdVcHYspRUmgcytcOV+nqVx8gz+3Y4a6Qvcz/3/kC09KtaNAygQLea9SDPZJyby/RtsubUs79qFIMNuq5TqeXtDOh+o2N/KCFTCQUm9VDz1B34yHMxevUXGz9B1F8zyfY5bDmWYylq3lV/VOFuz43
X-Exchange-RoutingPolicyChecked:
	q8Fgo1P9783yIiS5w9vfOVxp5uqguurwOrbZrwJYn9dr7ToNQMiOB1gVusGnqUGwtMjVTmgScJWj1x0RYou5NEB6ml1t/FiwDX9jy0LfWL52EoPSUDY1yUiVB/ewCBeCHee/FhYgkc14l+7F5BEUqkEzScdcz1MlAyXcMD+skz3BbKOHYURoMv7qnuDvh64XKwCtL5qZ8huRIcYkSfJ1echPiM4XCXtDKR+bLTNWtMZHMS3ABGk/ZcWfx1fpb/S/bRQoDDDJie2UA2QI8a9UzlrzQoWTjIO830GupN6n4JtNKbRGFnOi32ZxjcogoqJC/tKMRov+ng7F/iW9Ir3VHw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:32.9624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86da9e6b-ef2b-4253-fb17-08df3ce93b59
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF00000150.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7624
X-Proofpoint-GUID: rwLE7ZJYPUQk1aXI0T9NNt7SVkyDldkO
X-Proofpoint-ORIG-GUID: rwLE7ZJYPUQk1aXI0T9NNt7SVkyDldkO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX1bpcPQ9jtZ8k
 fBKyM+3QSEL3YtkBPnM+C0yo40IXW6b3L2GSOri274b8F/SkDRD20u4ZssPIG9z5DLbl/Mcdqb4
 xkgqppC1U2deZmBhOtfXYoUbG9dgh1E=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cc8 cx=c_pps
 a=zYHeo5UF1QI7fA+G+QDVSw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX4LB+74FkfZ3H
 LoFDZRpJQF7huDkWOpHFMOK/xhJrRBK1adJY63ov275XMopvVVBAi9PcXFtjAZ+sV+CW1qZtmFr
 jc/8F2Qv3gq+zdH2eISIaAwMnqRNnAwkg3+/ERiqUcFwOmQtUS7T7Jxmh4nA9T1NqW6OzCCh71i
 XvgGLIKcnwGLlq3xfpUp2ip+88oqhkaVGwye0DLE1FnU248NVlTB46sBlAoGawADymeSI3SzdzS
 ZAFsTmetT2AUjTC2udeo1a3IdgHicff2XMb0iv4xrbXBJIdvCTtO6pSPWXyPYTYCwPPyZUTzpr4
 frvgPB19s1MoLRuYqR9OLJ4ro1/3o7R4BrpbvGNI3qxHmk2KtPNeAmcwyq9Tx/2lZpobIt7Ujrh
 QvOsRyB5nJMqsWnq5EylB6cGkjzkSyUg/z+cIp5SC4ijBLV8EyiANDUwO2OGN3rlHKI24w6jPWt
 +nrXOrjs4TrJZtvsRlg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 220f08fd38977..89fec15c63bfa 100644
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

