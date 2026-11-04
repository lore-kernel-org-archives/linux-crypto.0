Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771251;
	b=lUlwhBxynJLmTr0FO235mtQFdxc39ZieGO4KwJAEAL6a92v0LtJchDYruol159f+rSr0
	 WBa9d0bIZAhubJzfWeqddAe3Wbmt4YoiCG+UTi/Vyf4NALwcG47T2Vt30DUfDLqqgFMO/
	 GFx+dnvquad01uA2JZKfZf8vcRPQBNXStLHzoR6Ne69WP0E8MGjcr1cjTr8q7jTys+pUT
	 wImMiooxhOXQeyO9kODy/qM4syFIMBMBIdczV6GMVno1OR00PnmMz34hWaD82cL7lRZtZ
	 iCeMjRwviEz2uTTlFU3XqBPV6VRISVh1Bll2zZteurcqVuCPGqUhxBaa5c1NLeG0xvw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771251;
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
	bh=6biiLd3Vrz+a0hw5ztbnG0bx1TJV67R7mKyb5M6+zZg=;
	b=cRq/JwbMy8TyecK2XzubJWn39czPv5hqgeoD6oxF53gRbD9C+f85JzzT6TM6TVOND/lE
	 Le4z60CkERKhjScjeA70JwENI1XQ8Suchp/5l+4c5BA0OG232ln1p6JYIGRp70sT7aXRS
	 ju33gBbPNyVfBTkbF7UjevY6SxHbOThINIZGMQLikLV8XocR2JY5x+PHw1Q516yf2D+7W
	 Wgs84vNoMY+cZlwHqawdWMm8gqItTBFU3ltIg0PeA3RJ6MRaFl0elflTJITnyYt/MMZXj
	 WigTQsN5g6OVaMlOx8I/WZv/SgoruYFvAqvmgM+dxbhsUalnykNyr4nTKkvRqIC73Zw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LwVYHgiX;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kAEF4PhH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E5C606A31B;
	Wed,  4 Nov 2026 05:47:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29E5C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LwVYHgiX;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kAEF4PhH
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40SEg3771942;
	Tue, 3 Nov 2026 23:47:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=6biiLd3Vrz+a0hw5ztbnG0bx1TJV67R7mKyb5M6+z
	Zg=; b=LwVYHgiX00mN0KZONFwL1kY3SmzOHwC+0h/EiRxcOSsu1JBJHeAUWGarl
	rB/bZZU0kOfUvL730U/lu6qx3JSSoPt9q87W/M56BKQRgst/Rf3fM+l744DQfkp+
	e/YiZMjmSbEFOEP9RV5jKfioyTrO7GzwMZcQPo1OnijTUpQZwwyKd/8Ze9mCLJYc
	hrz197usRlYJpd4Oz8e7N2s4jref9etGkuWaou53D+DfeJ7uOXMLLzySnyYiwR/A
	k/fljckF5r+64YElsg702Q0a6Gi5Rwkg+Cs8B+L+c356olFen6QzHNBrPMcIkq7l
	WL/WJcHlmIcIpVmI61tH8Vi9702HQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010019.outbound.protection.outlook.com [52.101.61.19])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25x4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:47:26 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fd/EzK9nZn1BXZL9OyyykbijXpgehwiGas76WJCmWd1bTPgiY5QbWO0vW9Y3dSTUaMXM1+STGbvDh9FZp+Gbe0iYfxZBJadsbLj12nR40IaU6bLOWu6JaOMEG+CcDm8rHi95bmG3+0RBZooFP4AMltWIJ1nyAJhBME3/baCHFa30FUvW635xXBYnwD4qr62CRhkNjoajdtQrUgDXXCy9MCFOr+0Fwz9Kb8efRPr16sxN+WUnPeMY8EZiVNF0fhqewj9721DVxkxfa3Js9h5X2W7rv1vvTx8v7W2dLTLRS0kshjeLq3156zvUVpIMSNCVCV+tsKlFCpDwaIWkKLJFxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6biiLd3Vrz+a0hw5ztbnG0bx1TJV67R7mKyb5M6+zZg=;
 b=Pl2PhqGFxI/amrEu6/nkC6CgBCnparG+DgYmJjJE6/Ee+vGdj5dJ87x+BlAdsgYeu6LCnjHzQlF0sr8w+I9/tZSW0eOeZiRznIPBLoTIyJUZx78gGtfjWPfLxEw7MBi60On/fJT8gyrn0E4jocDih5pO6xjQJve9k2iXncTbe4hvT99iC+9oLMBKeOkOghZ5bjXOLuf6R0m2ZhCHWC6x7iklKsWTFnFKmLERrFLuxQnq4qraPWPJkr3wzn7bS1shGPMXIDpmKZq3R8e0hMS74VQNzsnkI2Nu/zqRZ5AAn55DXc2H2bYJNxvXGBy5OetPnxaGsHrK+7m/xVaRWXt7qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6biiLd3Vrz+a0hw5ztbnG0bx1TJV67R7mKyb5M6+zZg=;
 b=kAEF4PhHPnnshCMvC+ngCYOIqOXWA3ZA1KggdH67s5gJyIHpBnM6KAZHJaJZCtl/LEGixqWvlhTKCy5+PofDnSa0qwjZLnwp03QGvBYMPEhHGc1MvACnPEV4iJ3YHkKWirnQ8Lx2Q54ft6mxQOF/R5iuc52L7Z2lDmgXfe6T5IQ=
Received: from BN9PR03CA0863.namprd03.prod.outlook.com (2603:10b6:408:13d::28)
 by MN2PR10MB4221.namprd10.prod.outlook.com (2603:10b6:208:1d7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:38 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::37) by BN9PR03CA0863.outlook.office365.com
 (2603:10b6:408:13d::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:36 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:57 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:57 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ0A521920;
	Tue, 3 Nov 2026 23:45:54 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:36 +0530
Subject: [PATCH v2 26/30] crypto: sa2ul - use a mempool for security
 contexts
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-26-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=5523;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=JESMq105eD6Vn7njV69LlV6Yb93JEk6UcGdtmfSHykM=;
 b=JU9l2Ay5lv0qwa73OaY2/ZAi9/cfgRuV58Jrsanp7V1OlNidyMDwouVi6UEbmuYyY+7//iVnT
 d90K8f9huAcBAT2yYezRgTweL5VbAo/O3y6ZSqQBSPKs4/K7xa7r/yp
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|MN2PR10MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: ad726918-a8da-4c04-a344-08df3a36fdb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|56012099006|261022105027099003|261009223027099003|261102123227099003|261021121427099003|261022075727099003|261021123027099003|261026140227099003|261028144727099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ruwtU3tPzU/6GANXPR7Q7UkQrLce49A7DBJwboRHusZqaWXLd9GIuURO5f3p5/OJDO7v98MIaZoE5n7GXQtg0PrjOkRrLLsItVatnhIxLrxQkekgSMmNgCamJinKldoim2rU7raCPCxxZkFzyIuXjP1pl45JhnaqWByxP9V/knw8+cMS9X2uzJR6M2FBzBMp4SaGoPt5VDjgo5hW9T1UkjJUo+ycm2zcUbJWq2eC/tHgahjI8LjhYi9eEXXHjwYTSuQ5NoBv5HU77e/IZdzEvd5+Ao9Bby7LWiJhtExK+AaZ+CRLCNcC78kN82hPMjbWKOfzrw+W/tl6qx18SILh8bLv8rv5WYLcYsYOHJdSihy3I6/YsCAjwYiNFXVxXQLa/MRhQiXkeKRMpAEVU/eCayLe66/HBJGws6wugckOS3WlCSGf2Xy4p2X8r0HtJbr25NPGe6SSb5L9gKsNbiteAVDaRVKjQNxqNrMwK/DNadxra//fPSRMjUZhbdyqG/b4kI3Bfaqn7pbL6TIShpBeSxY4aVs0xvUig8TeJuT516dUbQ6l2D27r9u/MALdbnnxrBPdeCfOODMBbl737onpMvCP3KoU1xZ+VsokqB6Ui4pWkeRSVeZcNodXEImUIZRj3BU32cE0w4gZB02JqaegcornAIpCRiUJCLOUe9JBkuxA6BcmjqPZb114MO7C0sQDm6P+rAO/fSEDdz/l6Ll4JA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(56012099006)(261022105027099003)(261009223027099003)(261102123227099003)(261021121427099003)(261022075727099003)(261021123027099003)(261026140227099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5Hxu2WH6sLiMQq90oshVK2g9sAqDqWY1OJqFQzImiGzTUID97BGSFjMzEvkZ5TJh3f/qdarllfWijqSI0eg9EaRTlwqb0Y+vFQrKw40xhvNr6ja0l5K4d3kKBKVHqyp8d1FOALPWz61QUmPCtJe83xEASSLOzO39ggyt2u0aGsy7HleJGxc9wXaBfSO2MkJWg5/FO/Q1Zj6y2Lq/qwmJekONk4gxXv8rqg3cC8EpUe8uacXTCYGEfFcQnfuUVGoHbulk5LOlQK1rBJK2OlsU0An3WcNmSW/dqMPFfexrZXa1Ptkkb63CvSu+83PeFJmT7GSaknxiK8a9uf136XNevnl53bjV3DNPbHUz6lrwcZKWTx7cKQd5JMMmhsnyQunAUuJ2uZ0anxblKJjnlBhduW4EzVs/FC8wWTT5Oyi9fYEDR+vsgn3mK3qszb4j+MQI
X-Exchange-RoutingPolicyChecked:
	AlSnzNZjIliYNuRY8h3Yah2V/KO0uSP4t1s80XrfhO28zFOjNwzBUWwhIgY+XX4SEql9ZibmUZA/eam8PT9aMubEUT3N7rI3QPPuEbCT21kDkEuvqEqZFQHkbfGceZ4pumk67jlj6Wi6nl6jGQ8AHYOlEnWAbTbIDMDssVjUoehf6kkU16tVPJdD2bmnaOKXjy9TbIqk6wAZrAqVd0LTwSzleOwz0yet1HSPBzBxG/g4zvY6oT98/pDqsjB9VZrkNXrn4NRgNI+ziqSs5RMrnVrZXjIEgr4fhtO2RNa1wiAk9ZTvXNbcHDtqvVlRLgZr1SCSjl4p3ZX71UASo3+lUg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:36.7918
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad726918-a8da-4c04-a344-08df3a36fdb5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4221
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX2fxaha6BlXHB
 6dLdZpf3AJFv3d4k/rIj3T7RZESs6pgbh2a4jB/BYlqkdbKgN2u64okC1u9UJD+0046KKaYLcZd
 Z9edpFX31Vw+13Sl8Fytb9QMzPiN/8E=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6ee cx=c_pps
 a=qaVWFsimjkZEOBPZqvUH6w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=AaOIfPvHkMQY4tXpMe4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXxm6UDGImclHu
 87s6BVF07GpkDra8bqn6qSSIhDZMLUkno2oKgLF+X5RyjxxLqEPd1HKwpsY5vFurv9BK7OlGdrq
 O2oIRN4fD4yObcO4N8WAILoTU9VGQRG5reSCrzDHsiPcOg7yobxrENLiLwadOIZuzZKfaQjAPB0
 9jE/eKTek6SrMnn/WlZFAbeQMdv2pue1p9ukDMCZyr5metUf2AJuzf0TVjVZvUsjlAr6Dm3gBBS
 lmcf//JywOwvMUwwo+eCP7N6PFm5yK0C+lHfGzVSq+oyX5AHccnrWy9aQPbO5O/raV6Ulv18bFB
 hENeip8I4o7REjLbaqVOxLoaVzTZ49Kr25bV3fuZ08PyEq6EPmTHNjSlkPVg7c+Wrpkewyn9xoh
 bhElt/Ty2gWRq98litY57AtUD5qzaf4940FlfFppinyi56uqXLnMnM/7cAANCjP45widdTmA6Tl
 q3ZNuX4KOCThmMjv+Sg==
X-Proofpoint-ORIG-GUID: 1zAI7MVxUBzwEuWF6xSYLHuenO4fX9UX
X-Proofpoint-GUID: 1zAI7MVxUBzwEuWF6xSYLHuenO4fX9UX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

The SA2UL engine is a DMA master, so any memory it accesses must either
be allocated coherent or be explicitly synced with the CPU cache around
each access.

The security context buffer is currently allocated from a DMA pool via
dma_pool_alloc(), which assumes coherent memory, which is untrue at a
bus level for many of our SoCs. This causes any fetch issues from SA2UL
to end up getting some stale or unsynced data, causing failures for any
crypto operations.

To remove this, allocate the security context from a kmalloc-backed
mempool instead. Since this memory is now ordinary cacheable kernel
memory, explicitly call dma_map_single()/dma_unmap_single() for
DMA-related operations.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 36 +++++++++++++++++++++++++-----------
 drivers/crypto/sa2ul.h |  2 +-
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index d4c0e5b836ac..ae3889695dfe 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -13,6 +13,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/kernel.h>
+#include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/unaligned.h>
 #include <linux/of.h>
@@ -629,12 +630,16 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	       const u8 *auth_key, unsigned int auth_key_sz,
 	       struct algo_data *ad, u8 enc, u32 *swinfo)
 {
+	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
+	struct device *dev = &data->pdev->dev;
+
 	int enc_sc_offset = 0;
 	int auth_sc_offset = 0;
 	u8 *sc_buf = ctx->sc;
 	u16 sc_id = ctx->sc_id;
 	u8 first_engine = 0;
 
+	dma_sync_single_for_cpu(dev, ctx->sc_phys, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
 	memzero_explicit(sc_buf, SA_CTX_MAX_SZ);
 
 	if (ad->auth_eng.eng_id) {
@@ -682,11 +687,13 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	/* swizzle the security context */
 	sa_swiz_128(sc_buf, SA_CTX_MAX_SZ);
 
+	sa_dump_sc(sc_buf, ctx->sc_phys);
+
+	dma_sync_single_for_device(dev, ctx->sc_phys, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
+
 	sa_set_swinfo(first_engine, ctx->sc_id, ctx->sc_phys, 1, 0,
 		      SA_SW_INFO_FLAG_EVICT, roundup(ad->hash_size, 8), swinfo);
 
-	sa_dump_sc(sc_buf, ctx->sc_phys);
-
 	return 0;
 }
 
@@ -694,6 +701,7 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 			     struct sa_crypto_data *data)
 {
+	struct device *dev = &data->pdev->dev;
 	unsigned long bn;
 
 	bn = ctx->sc_id;
@@ -703,8 +711,9 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 	spin_unlock(&data->scid_lock);
 
 	if (ctx->sc) {
+		dma_unmap_single(dev, ctx->sc_phys, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
 		memzero_explicit(ctx->sc, SA_CTX_MAX_SZ);
-		dma_pool_free(data->sc_pool, ctx->sc, ctx->sc_phys);
+		mempool_free(ctx->sc, data->sc_pool);
 		ctx->sc = NULL;
 	}
 }
@@ -713,7 +722,8 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 			    struct sa_crypto_data *data)
 {
 	unsigned long bn;
-	int err;
+	int err = 0;
+	struct device *dev = &data->pdev->dev;
 
 	spin_lock(&data->scid_lock);
 	bn = find_first_zero_bit(data->ctx_bm, SA_MAX_NUM_CTX);
@@ -726,10 +736,15 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 	spin_unlock(&data->scid_lock);
 
 	ctx->sc_id = (u16)bn;
+	ctx->sc_phys = 0;
 
-	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
-	if (!ctx->sc) {
-		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
+	ctx->sc = mempool_alloc(data->sc_pool, GFP_KERNEL);
+
+	ctx->sc_phys = dma_map_single(dev, ctx->sc, SA_CTX_MAX_SZ, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(dev, ctx->sc_phys)) {
+		dev_err(dev, "Failed to map SC DMA\n");
+		mempool_free(ctx->sc, data->sc_pool);
+		ctx->sc = NULL;
 		err = -ENOMEM;
 		goto scid_rollback;
 	}
@@ -2153,8 +2168,7 @@ static int sa_init_mem(struct sa_crypto_data *dev_data)
 {
 	struct device *dev = &dev_data->pdev->dev;
 	/* Setup dma pool for security context buffers */
-	dev_data->sc_pool = dma_pool_create("keystone-sc", dev,
-					    SA_CTX_MAX_SZ, 64, 0);
+	dev_data->sc_pool = mempool_create_kmalloc_pool(64, SA_CTX_MAX_SZ);
 	if (!dev_data->sc_pool) {
 		dev_err(dev, "Failed to create dma pool");
 		return -ENOMEM;
@@ -2348,7 +2362,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_tx);
 
 destroy_dma_pool:
-	dma_pool_destroy(dev_data->sc_pool);
+	mempool_destroy(dev_data->sc_pool);
 
 disable_pm:
 	pm_runtime_put_sync(dev);
@@ -2369,7 +2383,7 @@ static void sa_ul_remove(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
 
-	dma_pool_destroy(dev_data->sc_pool);
+	mempool_destroy(dev_data->sc_pool);
 
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 67bc722a1170..775f3939be68 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -163,7 +163,7 @@ struct sa_match_data;
 struct sa_crypto_data {
 	const struct sa_match_data *match_data;
 	struct platform_device	*pdev;
-	struct dma_pool		*sc_pool;
+	mempool_t		*sc_pool;
 	struct device *dev;
 	spinlock_t	scid_lock; /* lock for SC-ID allocation */
 	/* Security context data */

-- 
2.43.0

