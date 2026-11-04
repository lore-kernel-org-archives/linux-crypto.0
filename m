Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771100;
	b=i8xhAKhsWc442JeV2DDUqpYRoOTGo6Qqtm19d6gmjrTWhZh4Rj4Bl2x0n/D79aDmzNNM
	 RBANopzdwjipGkqz2HkcrwSy1K5sL5/B6SK10WsCUqYDCkRMaNSxw5eSZ9tBRAOAiIYPT
	 LPIcJnyg/GCV/Mck0JY5YV2pJ41afzFmE7mT5amxuRKdb+DtZn0BcMJWFC9Iz2XHx9zGe
	 MZgaUR9ANaOP90SlJjGENt1y+gYBZa0xLvPmK5R82yKf/T8z0hwuWVPMk9HTgpadOCAuB
	 DTuHVvCuvK/0N1mZG6dx1iXWIyzceMeTGtcWrYiaKJiAG6iOEeUZRCKqIt0SD/tFZ5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771100;
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
	bh=Qns60Ga4ErS7AqRWnnzeu1BU646xneQn0sdwcShn6yU=;
	b=aOb0ZaeDIryTZTRzrs1MgBWS6ECgNQtAeDCFLVKEpXBw9VYaoFf+G25wTNcp8QI76i+z
	 vxOzL4xaLU5WmSpTz+J9yHw5BKSpUNJUHlYjM54Yc8y0vqo1R1Ug64a1ko2NPdEX9ZTRe
	 es0SC2v+kDyEWIvuc7RGi1DBceMduVdd3m9eQu2fihZQHT15R3e5Llqjag6qt+ReXG8bn
	 y67cMyjaLAAj9xhPS8tKL0YkTgCasIPBdKUY4A+m9xlGXKT+F+ZaZpiHhkwj6slzAO1Dp
	 MF2h9rbja9/BJV6tgkm2kcMCmACfW/PjXr9g35dtG9VeUBDUMQgEBIgN8ewrGq7fupg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=TpaDtxGI;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=QU6OWsyk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F80606A31B;
	Wed,  4 Nov 2026 05:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F80606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=TpaDtxGI;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=QU6OWsyk
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5xl1166998;
	Tue, 3 Nov 2026 23:44:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Qns60Ga4ErS7AqRWnnzeu1BU646xneQn0sdwcShn6
	yU=; b=TpaDtxGIkeu+FeeJXF4QwogSaXM/DLpJh8O+kJXEKqxo+/HVbYhtChN6p
	hXMydt/MMKgzII99nNGD2PzomQhg9dZbiAWueKhFnbO+OxkoW+uTCE/dOM8NYCxk
	ieNEtDqAIctYUEfftRyfBR8E9KHGPk3OiVp7TzR1PWHQ1CzwHb47+h7oeMOf5XD2
	bFwPtVjFAjuxJmdSVi9fghkJf6Q3ECHVwwY8P3R4r/K+LL0bxDJNQYGibUOw9NGN
	zEYfurE++3B1vN1BAbsHxZZnEM9HrvLk7Dz0tOXNSUYXrc1tOwvc7dzoyTzxF4OP
	FwOBAVx/htGtKtDRRWhKhHMl5w1tg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh1x8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:44:48 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZOy/OzpY/JWXIcujty6glsgeHVBLIpWDgBqSVT6URPtWnNxFx3zSgeree0e8SMF5mzDT/Wpu+YAP0rFbaZfJj5OViV3cksxltKAptslzOAZjLVq44rg8ZFsSak0ZcYnNH0aZTWSTq0dha6f6XBDv6LIWj7j7ls5fem3ZcaFs8QpOkkH9zQhzplP2lOQ3D8exBHgv3aiFcZ4LczYsaRMwgYxJ3lU83SwhIzhH/Zt0e2FaGaBoc1m/X8P2nuMsyKtOQYRqVjDKOpgYA3yMPUtWNzwihyZ9vnmWRN/38Ar+Ea1J8hb9kWO8suo31NYUzC1qgvSKpqJ0fc4RPgOTIxqJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qns60Ga4ErS7AqRWnnzeu1BU646xneQn0sdwcShn6yU=;
 b=Pj52FprxaN3z6GrDHI7p0qee1YIoPSPmHfoIXe47rp1HPcNO6qUwGj6H3WUlvPEIefEdNv1kkFxh5e+ERWIEcPYpv6yxj2pAHOhQ/O2l0jjLThRCqYNVC41/jQV9v/iphyW2aQ5IOp7XoRWKmHp+QylsYHkE+bCEEQCn5fS7k1dmjX3Zokk839PNDfBfg2cU0yNecEv3SFS5c/D+8u++ZOWeNak1/npDRIPs3OmXRgxeLDh1pS6zAqywhRuhCgEDnCEoerA4/n5lEj3uTxUPzL3C7qZjtzynhg/4c04cBTexkX6n/5qMtxkrZA7+hwew4J5tPTWyliDGiwVG8zyZ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qns60Ga4ErS7AqRWnnzeu1BU646xneQn0sdwcShn6yU=;
 b=QU6OWsykcsVG7EtzpaUl0QldA7Z7VVFIG3xfyfXutnOD5m9V4ASwNa09HGzo3xBflbqjKzVJjW8DhBhxVzebdNVsbr43VZuikVpgSidX1ZB48L8l7M39LtdnuMrdd0gQABGaYNtfn2m0L4/crln2E1SKaBwVpZomP3SdvqhBIQE=
Received: from CH5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:610:1f1::8)
 by PH0PR10MB7028.namprd10.prod.outlook.com (2603:10b6:510:281::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:44:45 +0000
Received: from CH1PEPF0005BD61.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::1f) by CH5PR03CA0022.outlook.office365.com
 (2603:10b6:610:1f1::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:44:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH1PEPF0005BD61.mail.protection.outlook.com (10.167.244.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:44:44 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:44 -0600
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:43 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:43 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxn521920;
	Tue, 3 Nov 2026 23:44:39 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:15 +0530
Subject: [PATCH v2 05/30] crypto: sa2ul - remove unused macro definitions
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-5-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=976;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=Qt6RjBnr5CF7xjR5YUEQcJauDqIuw9dVSmw6uUvbAaM=;
 b=/dQtU1Ol+3l4USPa1HtMhZIbXpJYit7hRiMYjiTX2/XsPKQKNvefSiJh4quwnm7nOrmJKFDSu
 hYoGTwaYNh3Dv4ORVzxjlsKZ2epXF5JtHjvtTm7nIx6Ks+9KPyUbvrw
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD61:EE_|PH0PR10MB7028:EE_
X-MS-Office365-Filtering-Correlation-Id: a685f70f-9db7-4a22-31b5-08df3a36bac9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|82310400026|36860700016|261021123027099003|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	m+xHeqJaIt5ODifeSHB1GKvy9LWBk4IlVjidq1mlWhvnOTx1upsi/j/gBldGNNeAwq3yKJuoBWlcmJbb2zZ5g79VXvLI5kVOHUQVd115ZHPmBOUTjIdFn7VzCJlvlrmjeUFYan8eb2KHQFbi5kyNiU2PGixKR1sh97Sgh4f0gO94O0v/V9YGjbB2OGwJqRNQlrDbZ6rbqM5zNqzq/vfTsIlqNVQ1HnLpEhSKm7kT+sbipdFER/gX5UpAJNkTzkJVevMA8R7msJmMlHQaKoZdsbAWb8XQ1CfzdOMoeJUmzAfn7BeOmtxRJ3iKSoCVYfnKwoWZ4BKW8OlAoLQV0nBwaGhEN8zRqPiqjwFv3KFHBdZkpL8DLbxVjSat5JMQ5tJsv5AtlxpMhfBR8Z+u9rKgjuwCFg7MiWQpI5Q8WwgK2fZArCmiGgcaoSdC1yAoz/o5gWDKzDZwi21QGyyWfOYYaXeiNcxO4uIk5NfPGuU0aoJhLbeD6Y6EJDcpLek6rJB/GDcFtGELiA5AUHJFpaJZIYBqdBfekaipXFCuIUBIbrNOPWlnbLvysl7uCC5Skd1sP+uZMR0odmNIqhv9HB3EOaXT3euNzEfgbU1OtW3hr8ft5sPdKjepAvStSdSRpzELeevT1izFX/36miWLenjHFc0y8BLlZqdEGsqpfYUXY1/wJr5RNIVhT8xAMO9Kw8r+Ecty/pA0rnNmFPf367pjXg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(82310400026)(36860700016)(261021123027099003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BiZcC0z9lB7EpM0lGO0uPe+fnViA+epQFHNu9IsL7/wC3prnX42YYEgruXymIb6PDz7pbHE9CA8cqh7Jnjtclv+YvWk07xzCNDtPdf09f7jSuVl+e6bF4fqLel4ZFIvWasLhddeEdGpZfPUPHHasCt0z6JIzhT4a+f58LMfw1LjW+XsG9/rcslgnZgmQM6eICuARhZj5FV7ujuKdx31J0F5Dva05/sP9NBBqlueU5exf0Wt1UxCIZalIJcV39InVtGZ3nM4DiRNjxN/BUekF0dJznBST1s3LRw9utRGFrdzfse1qKhEop93Fzg+j99gwCNCfqsMJikdI9W6yx03UwWzw/lAPvcZKz+F1Y1+z/CtQ7Un0QQbjweGvOt8+pyOF86TXyVtuF3ipL8JKT+b87hlk6FhmMbZZIiA3oMTmGWkN/MfXEf0AHyQohum5ZRyk
X-Exchange-RoutingPolicyChecked:
	GQ+ojzqa1ZwtFNtK9NROt91LXwjPDGtVzY1eUc+Oeew1pWnilT4Av3JUvGbZ9vW0M0ceJQC578ClUooYvw8k5+Y5tASWIvWwveyFUuawiK5LTxZ9JjAWJZ3g0xSSMa85EiSa3C9jmEUV2Q18TKXGW4pOGEcPT15t3Qp755/HoyZLtQm9QUK6eOQNjmLJBUwfWkX5BhEnX8FjqPEZctHaURmaNFKiAE3HrGbxuee47yXBLhOF0gDfc9+AN3BKw6Kfwh0Wt7L2upC7qZ7/xQl8+kkThb4hJ0yo7c9sxds8gF//JAMhi16G7+6Z5szCaeFHoQEkGLnHQe4Fk25/9QrARg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:44:44.5358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a685f70f-9db7-4a22-31b5-08df3a36bac9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD61.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7028
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX5jS7Tjjm0OAt
 S8gA9lIfRz8BGpp/bJUtG7QCdUoWdEQL5foa8Lp8WWSiCvL2ZSf/x414odS4JEybUlST5/GLlfj
 h/2mPG+/R/nFUiRC6FJdUuwAY3Z4EQU=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac650 cx=c_pps
 a=Yf+1g9CPtaneS6NJHGTLjg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=S8DdzQo7xCx1W45tbRoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: NzLjmbDZ5ivD8Q2XY8My1SmqSwwjr_WX
X-Proofpoint-ORIG-GUID: NzLjmbDZ5ivD8Q2XY8My1SmqSwwjr_WX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXz4ERVoqM1G4j
 TXuSuWqTde14i0dYbtzxeRhkFqOEV+fmFVPz6OwxmqV51nR1TLFMN5ky8sQcs2Dsv66S79AooWW
 ZU9OfZ5t3eXJqqAOS/WNc7G85/6IKM7G4pu2KNkQao3NunSYYnP6/lLKtN4OaucmUxzY+RDiFWe
 fbRMHrLTk1hlTx3ztSLAjtdCq3FHBpWOHadOXWQ+3l1RKASNnjhJuTH4VxJwuY8u79NLZyxvkYe
 EhgvwLlQCgfe4PAHQSPqk0z0VNZ81aJ7vtmADFjEUxFlGeBR/KQ2wZYrWsrk25dKt++bV6L9tuR
 C1sviEcJVmsNPDUAS9afXl8wSEHve0J3FfyQAEzYaN5/m/GbIpx38N1J/3H0oTAszWXRjXmwwx6
 6CnSHNmIwx4uayULKcZBClMinzaxg2/EXI2F84raLh7qD8dtUd9MMzLlwuIbvqgrH1rSWm5vlda
 J0qwOQKyaQn9wJG4wrA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

SA_AUTH_SUBKEY_LEN and NKEY_SZ have no users. Remove the definitions.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 drivers/crypto/sa2ul.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 93c57758f107..3bf46a8b0621 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -42,7 +42,6 @@
 #define SA_CMDL_UPD_AUTH        0x0002
 #define SA_CMDL_UPD_ENC_IV      0x0004
 
-#define SA_AUTH_SUBKEY_LEN	16
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
 #define SA_CMDL_SOP_BYPASS_LEN_MASK	0xFF000000
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index ebaf10cd7dd4..223ea5290fd2 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -46,7 +46,6 @@ struct sa_tfm_ctx;
 
 /* Number of 32 bit words in PS data  */
 #define SA_DMA_NUM_PS_WORDS     16
-#define NKEY_SZ			3
 #define MCI_SZ			27
 
 /*

-- 
2.43.0

