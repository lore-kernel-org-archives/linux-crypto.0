Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771110;
	b=uOvWPQlvQbMD52INcXpXYLThx0kEnFOyU8g9LV2LVVu2h2xIaOp4hbrnPGeOMhelRrqi
	 +7J43QOLVVUTYZDhZLhrpUpWa/KO7biE27BVgmxDjW+J2peS4KvlMDSVYE25ifuLKMB19
	 zDybyLdqVyA3ondj0z1Y3dFhE7weeFg6O6uUngfLOboP7U3r9zvK/zuaPlyeRrnjmILV4
	 xMz7h3iWVdreIghsleCjC/sgP2r1zjJXpEHIKjDuARA18kSdNgtINOj5D0WljCX4UReYg
	 PG/DRjnOP9QUIw8c2by7D8G0CYmzW6UTINdnpbEWdokkIcYcc6eBeTXTXQc8HM/Ga/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771110;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=cJvm8JWidgGpzLr4WmyJllhBirn0YXyszmRmBKILe/4=;
	b=eLrhDej/wwa+CHw6rXH2E0qflza5PEX/5TtyCo3onRV6Ffi2GNMWNdU2m20ACTByGn2L
	 HmvCAEhlxFDgjLE5QSTQjTDwoKLLhx5GuM0kmXqiUZ07ZJi4U+8M5TC2xqBJtU7fr03jC
	 Z0WImz9mtWD+MoBCV5dGH6G6eEeppeOum/j75thDqciBq/FXwE2im5N1gkBn3ueiSq8D5
	 yKiNgCQZpER3R59Pp2MQNCvoFtNC/MzWuRtwes+WC30xtOlhp2c9fBHmgrPiL2ZkTG2zA
	 gmWe3FBAQa3u3Bdr9m6ULdL8VPb42PW94mY1BGlV5qzl57+pl8Y90vIQ0TcqcgQ3aRQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=mt4Um2EG;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=etRaf7m1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBE1606D80D;
	Wed,  4 Nov 2026 05:45:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1DBE1606D80D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=mt4Um2EG;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=etRaf7m1
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5xs1166998;
	Tue, 3 Nov 2026 23:45:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=cJvm8JWidgGpzLr4WmyJllhBirn0YXyszmRmBKILe
	/4=; b=mt4Um2EGmEnUvoVyrtq3NAmMWy7JkXMhF2BQGjcqKA59REJ+IPKQ+GWaP
	q5t+brWZ0oC5IIVuOlgMzA5YZjdeqBoz2MN/OCufzBli9+BEipyMwFwMnIb7QCwB
	7CblO+Q7t/JPDe0GBY0pQn7gVZ5uD1erPMIu05F/7gcOpnSqTxkRFsVjlf8qQH4k
	VuGCfYb+d21tY40rPbJCgnew9w/BCp62o873CniasNoqsuX4hkoTNQXQAd76UtrF
	/oqmiux/bAUriJiuxaJlbmge6VEqAdknh8/MuZKqD4W/OX1XjP26dRGNTR2EqPvs
	X3pNhynfOluALzmJO4EX66ov26xvA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh1yu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:06 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhjoRevzDfIRpTGFLxdq9W55+3XWQdy/M7DGByUXNIkdpG5r1yedsUtR2F28tEE2B+jskMf8e28rxhMspWnsJC1PIzNhUBhvtTcNmDBWINpcY1x2HNIoTaqBm3lqw9+pAIW/5ug7oQNh1aesHKjcuAOWrIjogrEPrdgDML3QJ3A5Q7LNTWcZjbDLotGaMiQy8/uGLRxpik8vMFNsYjkWF36ltrcJJ6HOQIwqQxcI1kfzMN7Mc+OtbCZy0RGN4r/6SRNSoXs5saVkyn66rOgXRv+Pmwul0xYRwplO1qrGNIdTneVz1SxPAeou4eQQ2EILu445TbxUy6O3TBrh+uefXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJvm8JWidgGpzLr4WmyJllhBirn0YXyszmRmBKILe/4=;
 b=icYWPS+62TPiZiyYaprfpiskTNrjUozRj+e8F+/UZ7ZI+Z4LV8LoPWHl9zlWmB2DeplxUGMj4rqG+1hMLZxezBzyKXJo05bH+f3y5UhjFNNa6Wm+//wbltetnYHCBFCSy4EDXM4wpV4WBCtZovVuvjKK8PgOBuoqfFQd1U+hyJc/a0mrat70uJQEBriWStBPQgNAVERV7dnfDugNpjHGZ4Uns0sdmx9KkDdX4G5kGlQedxE0RdpnW2zpJuFE32CgWkr/qDhkXVcKofXHpduoFbWCMxa74Nb4S9iD42REOIdAvnqqWZYepT6qqp7URwykzEtaxYAQq+dJohLRVZoM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJvm8JWidgGpzLr4WmyJllhBirn0YXyszmRmBKILe/4=;
 b=etRaf7m1ZwSaocKmykBqhCW4d5fY/nfVyD21kEYs+1/wEhQrbw2JJgKQU0hdDLKq0yNE5atlVqksYbXO/MuJN1F1xzF7/f907t5zpBDd3qBtdU4MHlHIskzOQz/Aq66MlcyKwcdbG7ffLgA2ttEdSgEpp7fpkgicA/BK2tm/ff0=
Received: from BN0PR08CA0022.namprd08.prod.outlook.com (2603:10b6:408:142::7)
 by MW5PR10MB5850.namprd10.prod.outlook.com (2603:10b6:303:190::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:45:03 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::92) by BN0PR08CA0022.outlook.office365.com
 (2603:10b6:408:142::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:45:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:00 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:30 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:29 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:29 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxk521920;
	Tue, 3 Nov 2026 23:44:26 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:12 +0530
Subject: [PATCH v2 02/30] crypto: sa2ul - remove totally unused structure
 fields
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-2-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=2824;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=GiifFH9w+4G5odExPICRBTlURAqui5uu/8wm4UH+vEE=;
 b=lF1rURBHl9AA7w6bJoI14x1muai1fkI/YfKka2J0JeM5uczj23kj+I6xC0ZdaAmQmBfX/mz0j
 WZ24ynU3xK8A/AiQLDOyqhN9PwGMmDWwOo5sMa6kuzdo3fLZuL3rR2V
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|MW5PR10MB5850:EE_
X-MS-Office365-Filtering-Correlation-Id: 22bd245d-4594-4091-e729-08df3a36c43f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|6133799003|18002099003|10067099003|22082099003|3023799007|56012099006|261022105027099003|261021123027099003|261028144727099003|261102123227099003|261022075727099003|261021121427099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	gWTXRk8OegOiNQVIM1/pjF7s6QoRn/39lgBkhDF6FYn+s0Hcbb0SXCiLcFMJS30gr0K7wi4hs92hGsTsogA0iC/xWFwelS+k9YtXaUgP5YG+pgg7bDSwYga2UiUm2CGVxzbWEgx4veWylJPOtnGJd2Yv1CCQ5cWEZKG5SRID/96l4V5skZZB5YP6PAd1S4VCoMEksfYT6BTj/eCosETLWvDfH32szMms0TYbf7FKg0XCYx2Tr4MPAZVfpDbx9g3LMhW4RSX2TMBOTHpPb/9hsJKdQbnL+bW/lKLtg1N1H7Y48q9dhAjedYRZAmJeLRztFnIzHXROzw22XTaTztUuOefyAXyTs79yVIy7ICsqRRCMxbbFc6T6S5+GUshMP122UGqbmHbGSzI4ZLz76DU6UzJd81SffUTcCRfnYC3vRRBEeROM0nnmWaiuBt9Ch0Th6SQymDO+uLUUSse2UhLuBLnCpd8ZOkZDnV7rdxLrvOBfTZ1O2tbTXnhtrmxbFNOlaBFzJ5J9h2n6gw48N9OtkyOkyWLUiss0MldivTtp0KocZk7xdzWQFuuwOgmekoLZyWCLbsKwoth9ChvOSJAbnPlRj+ivOLcVogbdL79faubhAwobEy1dbe4qtSye80R4bIJD1S2V7QYz5/6Y+EHWFeQo8zBro0hCE5Fnzoui4C0ILlbmzWM9mNKQDDwHhCUAjGi9R6pJvpEl8c1Kt8u2/Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(6133799003)(18002099003)(10067099003)(22082099003)(3023799007)(56012099006)(261022105027099003)(261021123027099003)(261028144727099003)(261102123227099003)(261022075727099003)(261021121427099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BAw17Pqqi1p5ANmmQGCChPkMm4/WY68fA770AMJ9epv6NCjpQhlOPNOscEgDUNfETFWpSLMWJ8AZqqudgbR4gV4YENbbHq9fOA1cCEsct54e4gvJejMAlq3ZVqsL70W/zxH9/d36j+RNucd/WaoP1IQIE2dKiHJRlZDrNT9ovSaFdFwXzfu6KFQHwW8oprC3x/NeLz1rjxaXNfqcPVx8VWK5nsbYDN90lsi9Jll0umxK/fjAmNDCR8sa9/X3v5tCbFypHO9L4z6JnEB0s4lUjOnQ3yT9I1fdjOxZVfJHePocOed43T8qm0YOHiotQOi0yODO9ffe9+D2Xi+2g5jm56SRO/50H1h4pbEWw8Ui15ba7vj/3aQZ2eca2Ct5mn1l7W3n8kDboeICUxa0E1tGFhtjWaMUUduDYREK7dOyVbx0e6M2+HcIPmRAdltkWLGN
X-Exchange-RoutingPolicyChecked:
	nlsffPPp8V0wPBroO6OvpcHqEVoRJ6a1zgLk/3FkJhziVcfFVMbjbnxZAVh8FcG4sHzreVUsQdo5nat5c2x+r5TziM7953ENhlabEGvS3+xjV6+OaXzZ1t9JW5Z3iPuUMMzFrjh3mledUr7rGnAiNCkPb0fmedKrpZQaN6YPtrRGDelBoN1Bi217DD6HeROfFM4R+TanSVxOTCELjq6/b94+GwvGwEDMsFGsnRmkdykKWsrP2QiDmMdgbZxR7wavvdXqzO2psykXSossbjO9odQCORyl92/oUVw6iQRmh/Im3AhGcIVYAyhgGGAPHH/A+GM9dPHvWv+jALeFpGDNvw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:00.3877
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22bd245d-4594-4091-e729-08df3a36c43f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5850
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX2xGxQggmCpE0
 UQMGIEGLRh+h+qCsql2D3xe5EDhMAUZhKyHysmtR6MTrQLDMQ/QiyRmLrk2dfWHbgUBqOOvS5ja
 gc8XGIDY5SLsj+05qZFXZLz19O5BG7I=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac662 cx=c_pps
 a=HW5a8e7WWDX24nvVw4Uo9w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=BM87suR-6GYCUzP0VmcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZhHBOwpZ-Jgm5MYLjtlWhHtUDkDT7tRX
X-Proofpoint-ORIG-GUID: ZhHBOwpZ-Jgm5MYLjtlWhHtUDkDT7tRX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX40ALRl2XW3FN
 tvoQAFTh+mpLJ3oomqQQ17Uri3/57jMZILPnQQ52Fb2NbYqTztoj/Cpe+BkShmcZ9qdXeKnYPoG
 nTH0Aqx0iUZStLvQNomrck9eRg2I5mjnVUDlUNjnLLrl1MXZ//EejkfSXnRTvqkpwKYenq/ntjc
 MaQA3AZbNAAUBv477/RR6N1EqJHfUS7EtW68x4m8fGAKuBJkfaMjR9cIkc0tez8BEEWqdpMdVIF
 zz2BCMAjzbm6bxvrRbc2org/K57Vm/H36F4sCU+7coCepgB90FbzPkrAHLpWRflPsS3Fj16+iFt
 LtSB0y4B9So4t/NFZGlJmM4kldfAO4UZDxzOQe0fbPt5Hd0PwxXN9yFhkhHOnpadoBguhMFRRDH
 D3/S7qr6VQZ3Y4uHvNUfjYEVKjmi1N8RG7/78dtvOnFoLTG54V+379Itb+Yx3qnnJHwXt0O9xjr
 Dty11W3drguhaWGdSFQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

The following have never been used in code. Remove them.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.h | 46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 211ef4e40f22..dad60aa77d1a 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -222,43 +222,24 @@ struct sa_cmdl_param_info {
 	u16	size;
 };
 
-/* Maximum length of Auxiliary data in 32bit words */
-#define SA_MAX_AUX_DATA_WORDS	8
-
 /**
  * struct sa_cmdl_upd_info: Command label updation info
  * @flags: flags in command label
  * @submode: Encryption submodes
  * @enc_size: Size of first pass encryption size
- * @enc_size2: Size of second pass encryption size
  * @enc_offset: Encryption payload offset in the packet
  * @enc_iv: Encryption initialization vector for pass2
- * @enc_iv2: Encryption initialization vector for pass2
- * @aad: Associated data
- * @payload: Payload info
  * @auth_size: Authentication size for pass 1
- * @auth_size2: Authentication size for pass 2
  * @auth_offset: Authentication payload offset
- * @auth_iv: Authentication initialization vector
- * @aux_key_info: Authentication aux key information
- * @aux_key: Aux key for authentication
  */
 struct sa_cmdl_upd_info {
 	u16	flags;
 	u16	submode;
 	struct sa_cmdl_param_info	enc_size;
-	struct sa_cmdl_param_info	enc_size2;
 	struct sa_cmdl_param_info	enc_offset;
 	struct sa_cmdl_param_info	enc_iv;
-	struct sa_cmdl_param_info	enc_iv2;
-	struct sa_cmdl_param_info	aad;
-	struct sa_cmdl_param_info	payload;
 	struct sa_cmdl_param_info	auth_size;
-	struct sa_cmdl_param_info	auth_size2;
 	struct sa_cmdl_param_info	auth_offset;
-	struct sa_cmdl_param_info	auth_iv;
-	struct sa_cmdl_param_info	aux_key_info;
-	u32				aux_key[SA_MAX_AUX_DATA_WORDS];
 };
 
 /*
@@ -330,13 +311,6 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
-enum sa_submode {
-	SA_MODE_GEN = 0,
-	SA_MODE_CCM,
-	SA_MODE_GCM,
-	SA_MODE_GMAC
-};
-
 /* Encryption algorithms */
 enum sa_ealg_id {
 	SA_EALG_ID_NONE = 0,        /* No encryption */
@@ -371,26 +345,6 @@ enum sa_aalg_id {
 	SA_AALG_ID_AES_XCBC       /* AES Extended Cipher Block Chaining */
 };
 
-/*
- * Mode control engine algorithms used to index the
- * mode control instruction tables
- */
-enum sa_eng_algo_id {
-	SA_ENG_ALGO_ECB = 0,
-	SA_ENG_ALGO_CBC,
-	SA_ENG_ALGO_CFB,
-	SA_ENG_ALGO_OFB,
-	SA_ENG_ALGO_CTR,
-	SA_ENG_ALGO_F8,
-	SA_ENG_ALGO_F8F9,
-	SA_ENG_ALGO_GCM,
-	SA_ENG_ALGO_GMAC,
-	SA_ENG_ALGO_CCM,
-	SA_ENG_ALGO_CMAC,
-	SA_ENG_ALGO_CBCMAC,
-	SA_NUM_ENG_ALGOS
-};
-
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

