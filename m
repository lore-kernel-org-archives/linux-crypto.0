Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771195;
	b=rWbTBsWON5FxWm7bjzAcdl9n+l0o4kE3uDzAXX8NIBUE0GGBMHTMu2CP6IWXq1fcZkeK
	 6we54rdOeOCTyRhufA95DzPxn6wiVWBtiZMhwE1gTMANwX9xfa5xb20b1kvJoqTaRZkOu
	 ZrhbzU+Ma2f64poHZF4Q9BnXH1wy0O5wMw5/TgOOrlPIpO5aP3efRxwwOXa6uvw9LhjN7
	 nom7t1pkNOwoU+ZSSRlCNOhJ8k4yP1vJky/0ZQ8Kc5Qm61a6xZ0lldwX+JYjmDZ1mk35q
	 sn5AgH2t9wg45MkALKu4aeJXEaIvNsv9aibUI59g2RBsBdyL04uY1ZUuPPuW0mK2Jcw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771195;
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
	bh=TEV2sZme1tZ7v9+Ejdw8yHoRR6vumNhaE4UjYv3F67Y=;
	b=gnDAlyTGXqFmvCJWp9IRW+c+fJm4jypMoKis7lMjtB1yN1yf/SDcMAt9KDbFAKRXnM31
	 F5Rr5+vXJFl3BeMSM/KxQyVqsXCpydMzehBXkaVGgTXrK6Ei/K4rnmEsh83XKU7F2XVt/
	 hUkHdE5G4SMrqRmemTlGIu2dA0mAJupcInAqIGE2cgeuMRxdz0yruhWWmGeopIZOkDS6l
	 VWj2sbjPXY2pYypyatiFs2tNGbZjksn4i+uESlebilG5HfB0hPZHP8kkffe7OKF/Kwalz
	 PKMt43kc3ZwJcITORwi6HZ38vm0DVQjeFR0MYuXZFKI7MvxOS7gfXr5p3CluP3dslVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=P8ghSaQz;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kFuVkyW2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760F4606D81E;
	Wed,  4 Nov 2026 05:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 760F4606D81E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=P8ghSaQz;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kFuVkyW2
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40SUHf772278;
	Tue, 3 Nov 2026 23:46:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=TEV2sZme1tZ7v9+Ejdw8yHoRR6vumNhaE4UjYv3F6
	7Y=; b=P8ghSaQzX+1ZaTahds7K5OnZ5keMi23n9vDN2tvUXMS9qT77r3r/ASlEM
	3UaTSNSV8sNCcb7thsTB41ALIBA6+LH0+Gc0RqK32zGDeJEqcd1LIOjhqmr2Bzcz
	mxTubizUj1gll0mqLxqdYsRPsh+uzQwy0rdyYxbrLMuQlQZv9UOCM5Mq48jKBHhg
	98p7GWEKVYI+xea9FOgab/yUz4vWcriM1aTdknbocm7yfKF4iGUGQAkCx2KM/36Z
	Hm788BY7gt/gMfsxlOTrG/HQIURzA8cHLI9v2cTDo3pMZpPze+ncl53VavpPlZYx
	NHShAH0iTOquo/TyBQ4mhEHGZ3kKw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010043.outbound.protection.outlook.com [52.101.193.43])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25r5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:30 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaVDYKW/kwESzxB4ZwV+sZnopv1LRf/6IJOc49cnfnEKEfUg9bdEFKeheBiQQAhLuVINb9m1sAZ8PH6O7aM6napP4Eh8ARN9iRP9000INKhXbKZbot4235v89GcdIAtnM1DAkG9EmjENDNhmfNoY2RFVANC2yvC+pI//3Uet7sMwBJIDlvpd/dq312cdwcgG00MX1AYgs7Tq/puu26WSdC/lL8TGIHi6X8iZT1rtQK8LnJ65Ch45JK8DeFXf4XFw/iEFeuY2cP2zysHvhzciag9/6RWyy3V5cZafwq9NWYbicA1WuPp4MvTCOlNqtYLyCCfpuTvubbeqAeGaJTzw4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TEV2sZme1tZ7v9+Ejdw8yHoRR6vumNhaE4UjYv3F67Y=;
 b=xw77uXoGknsyn4z0bd/aAunGNytDrr1jCoue4dmQtgqNRt8gShDYFmXPeG+vb6DP2cTxySppHDV5fj9ofuumgz+j07ZMtECT/i4aToQYuYqiUk1e2EGj9Dz95EDvBkS1Wu6NYPF0D4MZA2b1WpNrEx5gF7MkWX87XIb0i3VP3be+A8N9XRVjucrIBf4m0W1uGbEHaee1U7ipePr9ue96/BMV1G51XeNCfJd40n/IxsjmeQkcGTCRSBFpv9aLhqHuUoXUFvfLR480pqDjr2o8umkSKDPa12B6MqM9e0Wn07vseoRmTQXzlbM5u/XdegiVQ6KDNntJ+OgbnOyeTGVhkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TEV2sZme1tZ7v9+Ejdw8yHoRR6vumNhaE4UjYv3F67Y=;
 b=kFuVkyW24lGnksdBLj+KOLpBTI8STwmytwqR2ms7p4kpbLPBYUVJ4kx29mwmGAq7Wf8JkjCKoc4szqLutKqXxo/VlROlr2R2vO4t5hrzay5K6L+Q2zP0HGn+2YeL7bWIfd/9nfnbJZu17jLN0sqDmFZQ3jf2Fql3gY8MuYF6gm0=
Received: from CH0P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::24)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:24 +0000
Received: from BN3PEPF0000B36F.namprd21.prod.outlook.com
 (2603:10b6:610:ef:cafe::7d) by CH0P220CA0022.outlook.office365.com
 (2603:10b6:610:ef::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN3PEPF0000B36F.mail.protection.outlook.com (10.167.243.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Wed, 4 Nov 2026 05:46:23 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:06 -0600
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:05 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:46:05 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ0C521920;
	Tue, 3 Nov 2026 23:46:01 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:38 +0530
Subject: [PATCH v2 28/30] crypto: sa2ul - route requests through
 crypto_engine
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-28-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=34036;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=DyBYP95tKK8AcG+3hjDNPjIjx1EWRJz8T/IVwi9a+nI=;
 b=u/gjsd3LvPoUUNpgtqIreZ8hWRnEHNrSHdX+BPGcM/GeG0x3d7dJFdeCWAZ8Fmy7eWlt9i3KP
 WpUo+qb4L8yA7CHLbsvplwtbUjBIuZjd7c1N6nsEI5kSdIq8X6vnxKF
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36F:EE_|PH0PR10MB4469:EE_
X-MS-Office365-Filtering-Correlation-Id: cca017b8-051d-412d-b730-08df3a36f5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261102123227099003|5023799004|56012099006|261021123027099003|261022075727099003|261009223027099003|261021121427099003|261022105027099003|261028144727099003|261026140227099003|261026121527099003|261102130727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	QqMjXp2MM0JFjiFgNqJKbe9whBux/rdqkkYMvQOVGDRHvCS/gTygh3nxY+uXRqQnJL45wdLob2zSksmwUefjuMKDt+JE45xpGfg46jUS2LTeYO+BqGyUu4pSoQFa9Kyi4OTNHzajhN+2i3Gw/4jHZlxPfUUic33uRpwCouUv24E5GxZ4o+BgRjswowrcWAwbvqVnvXmBQH1jMCpAlVit7zFjdRjsswDMDP/c7F5eMMFpjNE3Ksb61K34gzzCrmSSY+MVvFeVqUdTKtdwV3Hqrr5+UVZtFECh3PYnGdGih/5T7OSOkeU9OmLH5+t73gBrtJMTVOzw7VVac/OCB+ljRQrHxoUACFBqxWoTTuYIqCla5Z17kDjdazkVvnDIOvK3USGGWjtEGK1aHvsWIN+dgTKwMupVqEB0K9yPIYtm4UDz5JTnYxkkvqpLr4uoGkokUSgzKxSJOAFsCvVFQabfU94Ah/fiGFxHZWrGySHK9j8dE00CDUA+Dbs1FLuJsDsAtVMX7EJMFch4hcyrdgvwEOmNNEEEISx/c8AyZoP8gNeFCXI/fLxjMmWX91tujN7JhveQIhyd8uKdHLDCqWUmbghpvYH5gbyRnVqFCjaC3HVbVSzJ+fVQeTt7QvKeXxAu6UMWle4S0q7sJAIU5JgnPu+c0g+y9i5/MvXySpfJkQwBUwoLzUK0y0Qd+B+QIFAgCRzp/U5VQZE4TO1jZiBcAA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261102123227099003)(5023799004)(56012099006)(261021123027099003)(261022075727099003)(261009223027099003)(261021121427099003)(261022105027099003)(261028144727099003)(261026140227099003)(261026121527099003)(261102130727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AdrC3mMRErt+3mDq3CCVfKc85ylBZA414nmZE055WyKlB0HFWLp8GLmvDT3YpbRuVFzLH+3rdYlsPOO38si5hvnvgJLMhPgA6CxCX74Mbu/BVm9s1ogeRIgKUhAzAuVjYbURLoibEEgqnt9g4MYVwM+AK5prfq5DJ1Mk1qtXCoHKODP7Vlg4Z14bB1nGgNsP3NUooVumvZVm1qCTyrAPtabkXdXoU4POdsQxZQbt4hQxPJYMBwsMyzf4cpv6Igq7BpMGXkJtLfPpUggdC30BNwSmQ87ppJo1qTlWFacTaRtNIsJ1GghrUgmgLclrUuOT/9KhfFAMj9tKdfxHgW0UEhY+OEshgndGkUBGbahxvv1nWeRMLlev/qd/Y7D0+j+/8qesEfRhR5fvgYmTej9Ve/MJmOyqsAgns2kQfkbCosXSgVky+PWHbhqG8oIzy482
X-Exchange-RoutingPolicyChecked:
	MwiNgNIXnBg3/8PMtmGczGXD/baY7ayZQIUHkGUh186m9VuZUURYidRG8NovauxZboBUpuHMNgghR6lhxwnibcW1CsLGFvPXlVwU2rDIZfo0rwLqIWF74rB//4ttj5nhBFK73/z7Bnb7mNuWyiDmpy3LwdPLOyOxRI97Pw0Iqugslyaw40uCAcDNE+25ZxXoSK84mtCXHej02YkkH4cNB2AojxXYFzQN3O3id7HzYk/dzxv4dw3OOiv6HMIXkqb7qn8F9YMIL1i1+oRxyyWGwxLqJu3b9jyHOpSCyyrcBxDJJrneNSwoi9ALBnRGx0/NY9P+uCMbVCah+hDD9NHzsQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:23.5891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cca017b8-051d-412d-b730-08df3a36f5d6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXyPX6HbDegTXk
 CJUxaQ2DuG+ha17XTZzrk2bKL5qisB2qzUaosm154VAUnBBRXUJsj5/XXRBd+Mz+e0q/23BIzvB
 +hiEZwqCh5D+LtFtM29fkd/bs0duyIU=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6b6 cx=c_pps
 a=91GdPAjHHMbPGBWG17ie4w==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=EML02J9yeizTb0Ax-wEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX3xjV/oi3nlrp
 nJHaor7NhoDS20yMGH0BHTqk3potWzWIrnmEJWC8fCvorVsj7ri2Vb56SHImVycgfIGlN3WWlX6
 PytBKc6lAwkfKF/J29avKHjCtds+MMdLLgQB+BlZMMkywRP+oBdUKF7v9R9zS3RLtI9C/c1jVaz
 pn9yqyr+3Ynsi5OXLFRzB4bWxOFax0dXLbtKTXIpv4ZLnrckPiiR5cBZXnt8Gjk17xP6MvXIjHT
 8GvvxLp3SmSVw6OBa/W9+CwOyxhnuZBAtzqMp9D8WrS8ZSxScf/UQ28B7K29W1JTJzx6N/4aBIn
 RL0+4rYJ3Fo2qV9r+DRpUbXokRQ70dlk8wyNQbyZPaTsmd0LYIap5kjy2qIAHZLD3wcKoW7X0qd
 b0i772JWM1oiOr8Ui9v8POyKX3UU5huq7QLJSwZTHaceVnaHzDIePbuQ+A3nq7XDPjz2cZpwbZl
 yZdM3DEd5puMMJBSYBA==
X-Proofpoint-ORIG-GUID: dwimvHioG0gW33uDYuo1Xoxr7NWN_-V9
X-Proofpoint-GUID: dwimvHioG0gW33uDYuo1Xoxr7NWN_-V9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Use crypto_engine to queue skcipher, ahash and AEAD requests and
process them in a sleepable context. Keep the cipher and AEAD operation
direction in each request context until submission.

Allocate and start the engine during probe, and release it on teardown.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/Kconfig |   1 +
 drivers/crypto/sa2ul.c | 646 ++++++++++++++++++++++++++++++++-----------------
 drivers/crypto/sa2ul.h |  28 +++
 3 files changed, 454 insertions(+), 221 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0189dfdcbbe1..c9596f0c9087 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -816,6 +816,7 @@ config CRYPTO_DEV_SA2UL
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
 	select CRYPTO_DES
+	select CRYPTO_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 19caaa41ba03..5716b44afaeb 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
@@ -22,6 +23,7 @@
 #include <linux/pm_runtime.h>
 
 #include <crypto/aes.h>
+#include <crypto/algapi.h>
 #include <crypto/authenc.h>
 #include <crypto/utils.h>
 #include <crypto/des.h>
@@ -31,6 +33,7 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <crypto/engine.h>
 
 #include "sa2ul.h"
 
@@ -143,9 +146,9 @@ struct algo_data {
 struct sa_alg_tmpl {
 	u32 type;		/* CRYPTO_ALG_TYPE from <linux/crypto.h> */
 	union {
-		struct skcipher_alg skcipher;
-		struct ahash_alg ahash;
-		struct aead_alg aead;
+		struct skcipher_engine_alg skcipher;
+		struct ahash_engine_alg ahash;
+		struct aead_engine_alg aead;
 	} alg;
 	bool registered;
 };
@@ -169,6 +172,7 @@ struct sa_mapped_sg {
  * struct sa_rx_data: RX Packet miscellaneous data place holder
  * @req: crypto request data pointer
  * @ddev: pointer to the DMA device
+ * @pdata: owning SA device
  * @tx_in: dma_async_tx_descriptor pointer for rx channel
  * @mapped_sg: Information on tx (0) and rx (1) scatterlist DMA mapping
  * @enc: Flag indicating either encryption or decryption
@@ -178,6 +182,7 @@ struct sa_mapped_sg {
 struct sa_rx_data {
 	void *req;
 	struct device *ddev;
+	struct sa_crypto_data *pdata;
 	struct dma_async_tx_descriptor *tx_in;
 	struct sa_mapped_sg mapped_sg[2];
 	u8 enc;
@@ -955,6 +960,8 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 {
 	int i;
 
+	rxd->pdata->rxd = NULL;
+
 	for (i = 0; i < ARRAY_SIZE(rxd->mapped_sg); i++) {
 		struct sa_mapped_sg *mapped_sg = &rxd->mapped_sg[i];
 
@@ -968,10 +975,29 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 	kfree(rxd);
 }
 
+static struct crypto_async_request *sa_cancel_dma(struct sa_crypto_data *data)
+{
+	struct crypto_async_request *req = NULL;
+
+	dmaengine_terminate_sync(data->dma_tx);
+	dmaengine_terminate_sync(data->dma_rx1);
+	dmaengine_terminate_sync(data->dma_rx2);
+
+	/* Termination does not invoke callbacks for the discarded descriptors. */
+	if (data->rxd) {
+		req = data->rxd->req;
+		sa_sync_from_device(data->rxd);
+		sa_free_sa_rx_data(data->rxd);
+	}
+
+	return req;
+}
+
 static void sa_aes_dma_in_callback(void *data,
 				   const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct skcipher_request *req;
 	u8 *result;
 	__be32 *mdptr;
@@ -994,7 +1020,7 @@ static void sa_aes_dma_in_callback(void *data,
 
 	sa_free_sa_rx_data(rxd);
 
-	skcipher_request_complete(req, err);
+	crypto_finalize_skcipher_request(pdata->engine, req, err);
 }
 
 static int
@@ -1041,6 +1067,7 @@ static int sa_run(struct sa_req *req)
 	rxd = kzalloc_obj(*rxd, gfp_flags);
 	if (!rxd)
 		return -ENOMEM;
+	rxd->pdata = pdata;
 
 	if (req->src != req->dst) {
 		diff_dst = true;
@@ -1218,6 +1245,7 @@ static int sa_run(struct sa_req *req)
 	dmaengine_submit(tx_out);
 	dmaengine_submit(rxd->tx_in);
 
+	pdata->rxd = rxd;
 	dma_async_issue_pending(dma_rx);
 	dma_async_issue_pending(pdata->dma_tx);
 
@@ -1229,12 +1257,77 @@ static int sa_run(struct sa_req *req)
 	return ret;
 }
 
-static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
+static void sa_complete_req(struct crypto_engine *engine,
+			    struct crypto_async_request *req, int err)
+{
+	struct skcipher_request *skreq;
+
+	local_bh_disable();
+	switch (crypto_tfm_alg_type(req->tfm)) {
+	case CRYPTO_ALG_TYPE_SKCIPHER:
+		skreq = container_of(req, struct skcipher_request, base);
+		crypto_finalize_skcipher_request(engine, skreq, err);
+		break;
+	case CRYPTO_ALG_TYPE_AHASH:
+		crypto_finalize_hash_request(engine,
+					     container_of(req, struct ahash_request, base),
+					     err);
+		break;
+	case CRYPTO_ALG_TYPE_AEAD:
+		crypto_finalize_aead_request(engine,
+					     container_of(req, struct aead_request, base),
+					     err);
+		break;
+	}
+	local_bh_enable();
+}
+
+static int sa_run_one(struct sa_req *req)
+{
+	struct sa_crypto_data *data = req->ctx->dev_data;
+	int ret;
+
+	mutex_lock(&data->dma_lock);
+	ret = READ_ONCE(data->stopping) ? -ESHUTDOWN : sa_run(req);
+	mutex_unlock(&data->dma_lock);
+	if (ret == -EINPROGRESS)
+		return 0;
+
+	/* Finalize setup failures here so the engine can dequeue another request. */
+	sa_complete_req(data->engine, req->base, ret);
+
+	/* The request was completed above; do not let the engine complete it again. */
+	return 0;
+}
+
+static void sa_stop_engine(struct sa_crypto_data *data)
+{
+	struct crypto_async_request *req;
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->request_lock, flags);
+	WRITE_ONCE(data->stopping, true);
+	spin_unlock_irqrestore(&data->request_lock, flags);
+
+	/* Wait for setup, then stop DMA and synchronize its completion callbacks. */
+	mutex_lock(&data->dma_lock);
+	req = sa_cancel_dma(data);
+	mutex_unlock(&data->dma_lock);
+	if (req)
+		sa_complete_req(data->engine, req, -ESHUTDOWN);
+
+	/* Queued requests now fail in sa_run_one() without submitting DMA. */
+	crypto_engine_exit(data->engine);
+}
+
+static int sa_cipher_run(struct skcipher_request *req, int enc)
 {
 	struct sa_tfm_ctx *ctx =
 	    crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct crypto_alg *alg = req->base.tfm->__crt_alg;
-	struct sa_req sa_req = { 0 };
+	struct sa_cipher_req_ctx *rctx = skcipher_request_ctx(req);
+	unsigned long flags;
+	int ret;
 
 	if (!req->cryptlen)
 		return 0;
@@ -1258,34 +1351,51 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 		return ret;
 	}
 
+	rctx->enc = enc;
+
+	spin_lock_irqsave(&ctx->dev_data->request_lock, flags);
+	ret = ctx->dev_data->stopping ? -ESHUTDOWN :
+		crypto_transfer_skcipher_request_to_engine(ctx->dev_data->engine, req);
+	spin_unlock_irqrestore(&ctx->dev_data->request_lock, flags);
+	return ret;
+}
+
+static int sa_cipher_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
+	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
+	struct sa_cipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct sa_req sa_req = { 0 };
+
 	sa_req.size = req->cryptlen;
 	sa_req.enc_size = req->cryptlen;
 	sa_req.src = req->src;
 	sa_req.dst = req->dst;
-	sa_req.enc_iv = iv;
+	sa_req.enc_iv = req->iv;
 	sa_req.type = CRYPTO_ALG_TYPE_SKCIPHER;
-	sa_req.enc = enc;
+	sa_req.enc = rctx->enc;
 	sa_req.callback = sa_aes_dma_in_callback;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 static int sa_encrypt(struct skcipher_request *req)
 {
-	return sa_cipher_run(req, req->iv, 1);
+	return sa_cipher_run(req, 1);
 }
 
 static int sa_decrypt(struct skcipher_request *req)
 {
-	return sa_cipher_run(req, req->iv, 0);
+	return sa_cipher_run(req, 0);
 }
 
 static void sa_sha_dma_in_callback(void *data,
 				   const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
 	unsigned int authsize;
@@ -1311,7 +1421,7 @@ static void sa_sha_dma_in_callback(void *data,
 out:
 	sa_free_sa_rx_data(rxd);
 
-	ahash_request_complete(req, err);
+	crypto_finalize_hash_request(pdata->engine, req, err);
 }
 
 static int zero_message_process(struct ahash_request *req)
@@ -1340,8 +1450,9 @@ static int sa_sha_run(struct ahash_request *req)
 {
 	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct sa_sha_req_ctx *rctx = ahash_request_ctx(req);
-	struct sa_req sa_req = { 0 };
 	size_t auth_len;
+	unsigned long flags;
+	int ret;
 
 	auth_len = req->nbytes;
 
@@ -1363,8 +1474,21 @@ static int sa_sha_run(struct ahash_request *req)
 		return ret;
 	}
 
-	sa_req.size = auth_len;
-	sa_req.auth_size = auth_len;
+	spin_lock_irqsave(&ctx->dev_data->request_lock, flags);
+	ret = ctx->dev_data->stopping ? -ESHUTDOWN :
+		crypto_transfer_hash_request_to_engine(ctx->dev_data->engine, req);
+	spin_unlock_irqrestore(&ctx->dev_data->request_lock, flags);
+	return ret;
+}
+
+static int sa_sha_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	struct sa_req sa_req = { 0 };
+
+	sa_req.size = req->nbytes;
+	sa_req.auth_size = req->nbytes;
 	sa_req.src = req->src;
 	sa_req.dst = req->src;
 	sa_req.enc = true;
@@ -1373,7 +1497,7 @@ static int sa_sha_run(struct ahash_request *req)
 	sa_req.ctx = ctx;
 	sa_req.base = &req->base;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
@@ -1595,6 +1719,7 @@ static void sa_aead_dma_in_callback(void *data,
 				    const struct dmaengine_result *dma_result)
 {
 	struct sa_rx_data *rxd = data;
+	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct aead_request *req;
 	struct crypto_aead *tfm;
 	unsigned int start;
@@ -1631,7 +1756,7 @@ static void sa_aead_dma_in_callback(void *data,
 out:
 	sa_free_sa_rx_data(rxd);
 
-	aead_request_complete(req, err);
+	crypto_finalize_aead_request(pdata->engine, req, err);
 }
 
 static int sa_aead_init_tfm(struct crypto_aead *tfm, const char *fallback)
@@ -1800,12 +1925,14 @@ static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
 	return sa_aead_setkey(authenc, key, keylen, &ad);
 }
 
-static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
+static int sa_aead_run(struct aead_request *req, int enc)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct sa_req sa_req = { 0 };
+	struct sa_aead_req_ctx *rctx = aead_request_ctx(req);
 	size_t auth_size, enc_size;
+	unsigned long flags;
+	int ret;
 
 	enc_size = req->cryptlen;
 	auth_size = req->assoclen + req->cryptlen;
@@ -1833,271 +1960,330 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 		return ret;
 	}
 
+	rctx->enc = enc;
+
+	spin_lock_irqsave(&ctx->dev_data->request_lock, flags);
+	ret = ctx->dev_data->stopping ? -ESHUTDOWN :
+		crypto_transfer_aead_request_to_engine(ctx->dev_data->engine, req);
+	spin_unlock_irqrestore(&ctx->dev_data->request_lock, flags);
+	return ret;
+}
+
+static int sa_aead_do_one_req(struct crypto_engine *engine, void *areq)
+{
+	struct aead_request *req = container_of(areq, struct aead_request, base);
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
+	struct sa_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct sa_req sa_req = { 0 };
+	size_t auth_size, enc_size;
+
+	enc_size = req->cryptlen;
+	auth_size = req->assoclen + req->cryptlen;
+
+	if (!rctx->enc) {
+		enc_size -= crypto_aead_authsize(tfm);
+		auth_size -= crypto_aead_authsize(tfm);
+	}
+
 	sa_req.enc_offset = req->assoclen;
 	sa_req.enc_size = enc_size;
 	sa_req.auth_size = auth_size;
 	sa_req.size = auth_size;
-	sa_req.enc_iv = iv;
+	sa_req.enc_iv = req->iv;
 	sa_req.type = CRYPTO_ALG_TYPE_AEAD;
-	sa_req.enc = enc;
+	sa_req.enc = rctx->enc;
 	sa_req.callback = sa_aead_dma_in_callback;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 	sa_req.src = req->src;
 	sa_req.dst = req->dst;
 
-	return sa_run(&sa_req);
+	return sa_run_one(&sa_req);
 }
 
 /* AEAD algorithm encrypt interface function */
 static int sa_aead_encrypt(struct aead_request *req)
 {
-	return sa_aead_run(req, req->iv, 1);
+	return sa_aead_run(req, 1);
 }
 
 /* AEAD algorithm decrypt interface function */
 static int sa_aead_decrypt(struct aead_request *req)
 {
-	return sa_aead_run(req, req->iv, 0);
+	return sa_aead_run(req, 0);
 }
 
 static struct sa_alg_tmpl sa_algs[] = {
 	[SA_ALG_CBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "cbc(aes)",
-			.base.cra_driver_name	= "cbc-aes-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= AES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_init_tfm,
-			.exit			= sa_cipher_exit_tfm,
-			.min_keysize		= AES_MIN_KEY_SIZE,
-			.max_keysize		= AES_MAX_KEY_SIZE,
-			.ivsize			= AES_BLOCK_SIZE,
-			.setkey			= sa_aes_cbc_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "cbc(aes)",
+				.base.cra_driver_name	= "cbc-aes-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= AES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_reqsize	= sizeof(struct sa_cipher_req_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_init_tfm,
+				.exit			= sa_cipher_exit_tfm,
+				.min_keysize		= AES_MIN_KEY_SIZE,
+				.max_keysize		= AES_MAX_KEY_SIZE,
+				.ivsize			= AES_BLOCK_SIZE,
+				.setkey			= sa_aes_cbc_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_EBC_AES] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "ecb(aes)",
-			.base.cra_driver_name	= "ecb-aes-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= AES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_init_tfm,
-			.exit			= sa_cipher_exit_tfm,
-			.min_keysize		= AES_MIN_KEY_SIZE,
-			.max_keysize		= AES_MAX_KEY_SIZE,
-			.setkey			= sa_aes_ecb_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "ecb(aes)",
+				.base.cra_driver_name	= "ecb-aes-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= AES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_reqsize	= sizeof(struct sa_cipher_req_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_init_tfm,
+				.exit			= sa_cipher_exit_tfm,
+				.min_keysize		= AES_MIN_KEY_SIZE,
+				.max_keysize		= AES_MAX_KEY_SIZE,
+				.setkey			= sa_aes_ecb_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_CBC_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "cbc(des3_ede)",
-			.base.cra_driver_name	= "cbc-des3-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= DES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_init_tfm,
-			.exit			= sa_cipher_exit_tfm,
-			.min_keysize		= 3 * DES_KEY_SIZE,
-			.max_keysize		= 3 * DES_KEY_SIZE,
-			.ivsize			= DES_BLOCK_SIZE,
-			.setkey			= sa_3des_cbc_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "cbc(des3_ede)",
+				.base.cra_driver_name	= "cbc-des3-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= DES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_reqsize	= sizeof(struct sa_cipher_req_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_init_tfm,
+				.exit			= sa_cipher_exit_tfm,
+				.min_keysize		= 3 * DES_KEY_SIZE,
+				.max_keysize		= 3 * DES_KEY_SIZE,
+				.ivsize			= DES_BLOCK_SIZE,
+				.setkey			= sa_3des_cbc_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_ECB_DES3] = {
 		.type = CRYPTO_ALG_TYPE_SKCIPHER,
 		.alg.skcipher = {
-			.base.cra_name		= "ecb(des3_ede)",
-			.base.cra_driver_name	= "ecb-des3-sa2ul",
-			.base.cra_priority	= 30000,
-			.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_NEED_FALLBACK,
-			.base.cra_blocksize	= DES_BLOCK_SIZE,
-			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_init_tfm,
-			.exit			= sa_cipher_exit_tfm,
-			.min_keysize		= 3 * DES_KEY_SIZE,
-			.max_keysize		= 3 * DES_KEY_SIZE,
-			.setkey			= sa_3des_ecb_setkey,
-			.encrypt		= sa_encrypt,
-			.decrypt		= sa_decrypt,
+			.base = {
+				.base.cra_name		= "ecb(des3_ede)",
+				.base.cra_driver_name	= "ecb-des3-sa2ul",
+				.base.cra_priority	= 30000,
+				.base.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_NEED_FALLBACK,
+				.base.cra_blocksize	= DES_BLOCK_SIZE,
+				.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.base.cra_reqsize	= sizeof(struct sa_cipher_req_ctx),
+				.base.cra_module	= THIS_MODULE,
+				.init			= sa_cipher_init_tfm,
+				.exit			= sa_cipher_exit_tfm,
+				.min_keysize		= 3 * DES_KEY_SIZE,
+				.max_keysize		= 3 * DES_KEY_SIZE,
+				.setkey			= sa_3des_ecb_setkey,
+				.encrypt		= sa_encrypt,
+				.decrypt		= sa_decrypt,
+			},
+			.op.do_one_request = sa_cipher_do_one_req,
 		}
 	},
 	[SA_ALG_SHA1] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha1",
-				.cra_driver_name	= "sha1-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA1_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
-						  MAX_SYNC_HASH_REQSIZE,
-				.cra_module	= THIS_MODULE,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha1",
+					.cra_driver_name	= "sha1-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA1_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+							  MAX_SYNC_HASH_REQSIZE,
+					.cra_module	= THIS_MODULE,
+				},
+				.halg.digestsize	= SHA1_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha1_state),
+				.init_tfm		= sa_sha1_init_tfm,
+				.exit_tfm		= sa_sha_exit_tfm,
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA1_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha1_state),
-			.init_tfm		= sa_sha1_init_tfm,
-			.exit_tfm		= sa_sha_exit_tfm,
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_SHA256] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha256",
-				.cra_driver_name	= "sha256-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA256_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
-						  MAX_SYNC_HASH_REQSIZE,
-				.cra_module	= THIS_MODULE,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha256",
+					.cra_driver_name	= "sha256-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA256_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+							  MAX_SYNC_HASH_REQSIZE,
+					.cra_module	= THIS_MODULE,
+				},
+				.halg.digestsize	= SHA256_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha256_state),
+				.init_tfm		= sa_sha256_init_tfm,
+				.exit_tfm		= sa_sha_exit_tfm,
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA256_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha256_state),
-			.init_tfm		= sa_sha256_init_tfm,
-			.exit_tfm		= sa_sha_exit_tfm,
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_SHA512] = {
 		.type = CRYPTO_ALG_TYPE_AHASH,
 		.alg.ahash = {
-			.halg.base = {
-				.cra_name	= "sha512",
-				.cra_driver_name	= "sha512-sa2ul",
-				.cra_priority	= 400,
-				.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
-						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY |
-						  CRYPTO_ALG_NEED_FALLBACK,
-				.cra_blocksize	= SHA512_BLOCK_SIZE,
-				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
-				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
-						  MAX_SYNC_HASH_REQSIZE,
-				.cra_module	= THIS_MODULE,
+			.base = {
+				.halg.base = {
+					.cra_name	= "sha512",
+					.cra_driver_name	= "sha512-sa2ul",
+					.cra_priority	= 400,
+					.cra_flags	= CRYPTO_ALG_TYPE_AHASH |
+							  CRYPTO_ALG_ASYNC |
+							  CRYPTO_ALG_KERN_DRIVER_ONLY |
+							  CRYPTO_ALG_NEED_FALLBACK,
+					.cra_blocksize	= SHA512_BLOCK_SIZE,
+					.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+					.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+							  MAX_SYNC_HASH_REQSIZE,
+					.cra_module	= THIS_MODULE,
+				},
+				.halg.digestsize	= SHA512_DIGEST_SIZE,
+				.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
+							  sizeof(struct sha512_state),
+				.init_tfm		= sa_sha512_init_tfm,
+				.exit_tfm		= sa_sha_exit_tfm,
+				.init			= sa_sha_init,
+				.update			= sa_sha_update,
+				.final			= sa_sha_final,
+				.finup			= sa_sha_finup,
+				.digest			= sa_sha_run,
+				.export			= sa_sha_export,
+				.import			= sa_sha_import,
 			},
-			.halg.digestsize	= SHA512_DIGEST_SIZE,
-			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
-						  sizeof(struct sha512_state),
-			.init_tfm		= sa_sha512_init_tfm,
-			.exit_tfm		= sa_sha_exit_tfm,
-			.init			= sa_sha_init,
-			.update			= sa_sha_update,
-			.final			= sa_sha_final,
-			.finup			= sa_sha_finup,
-			.digest			= sa_sha_run,
-			.export			= sa_sha_export,
-			.import			= sa_sha_import,
+			.op.do_one_request = sa_sha_do_one_req,
 		},
 	},
 	[SA_ALG_AUTHENC_SHA1_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name =
-					"authenc(hmac(sha1),cbc(aes))-sa2ul",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_KERN_DRIVER_ONLY |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
-				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_priority = 3000,
+				.base = {
+					.cra_name = "authenc(hmac(sha1),cbc(aes))",
+					.cra_driver_name =
+						"authenc(hmac(sha1),cbc(aes))-sa2ul",
+					.cra_blocksize = AES_BLOCK_SIZE,
+					.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+					.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+					.cra_reqsize = sizeof(struct sa_aead_req_ctx),
+					.cra_module = THIS_MODULE,
+					.cra_priority = 3000,
+				},
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA1_DIGEST_SIZE,
+
+				.init = sa_aead_sha1_init_tfm,
+				.exit = sa_aead_exit_tfm,
+				.setkey = sa_aead_cbc_sha1_setkey,
+				.setauthsize = sa_aead_setauthsize,
+				.encrypt = sa_aead_encrypt,
+				.decrypt = sa_aead_decrypt,
 			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-
-			.init = sa_aead_sha1_init_tfm,
-			.exit = sa_aead_exit_tfm,
-			.setkey = sa_aead_cbc_sha1_setkey,
-			.setauthsize = sa_aead_setauthsize,
-			.encrypt = sa_aead_encrypt,
-			.decrypt = sa_aead_decrypt,
+			.op.do_one_request = sa_aead_do_one_req,
 		},
 	},
 	[SA_ALG_AUTHENC_SHA256_AES] = {
 		.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
 			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name =
-					"authenc(hmac(sha256),cbc(aes))-sa2ul",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
-					CRYPTO_ALG_KERN_DRIVER_ONLY |
-					CRYPTO_ALG_ASYNC |
-					CRYPTO_ALG_NEED_FALLBACK,
-				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
-				.cra_module = THIS_MODULE,
-				.cra_alignmask = 0,
-				.cra_priority = 3000,
+				.base = {
+					.cra_name = "authenc(hmac(sha256),cbc(aes))",
+					.cra_driver_name =
+						"authenc(hmac(sha256),cbc(aes))-sa2ul",
+					.cra_blocksize = AES_BLOCK_SIZE,
+					.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+						CRYPTO_ALG_KERN_DRIVER_ONLY |
+						CRYPTO_ALG_ASYNC |
+						CRYPTO_ALG_NEED_FALLBACK,
+					.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+					.cra_reqsize = sizeof(struct sa_aead_req_ctx),
+					.cra_module = THIS_MODULE,
+					.cra_alignmask = 0,
+					.cra_priority = 3000,
+				},
+				.ivsize = AES_BLOCK_SIZE,
+				.maxauthsize = SHA256_DIGEST_SIZE,
+
+				.init = sa_aead_sha256_init_tfm,
+				.exit = sa_aead_exit_tfm,
+				.setkey = sa_aead_cbc_sha256_setkey,
+				.setauthsize = sa_aead_setauthsize,
+				.encrypt = sa_aead_encrypt,
+				.decrypt = sa_aead_decrypt,
 			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-
-			.init = sa_aead_sha256_init_tfm,
-			.exit = sa_aead_exit_tfm,
-			.setkey = sa_aead_cbc_sha256_setkey,
-			.setauthsize = sa_aead_setauthsize,
-			.encrypt = sa_aead_encrypt,
-			.decrypt = sa_aead_decrypt,
+			.op.do_one_request = sa_aead_do_one_req,
 		},
 	},
 };
@@ -2118,14 +2304,14 @@ static void sa_register_algos(struct sa_crypto_data *dev_data)
 
 		type = sa_algs[i].type;
 		if (type == CRYPTO_ALG_TYPE_SKCIPHER) {
-			alg_name = sa_algs[i].alg.skcipher.base.cra_name;
-			err = crypto_register_skcipher(&sa_algs[i].alg.skcipher);
+			alg_name = sa_algs[i].alg.skcipher.base.base.cra_name;
+			err = crypto_engine_register_skcipher(&sa_algs[i].alg.skcipher);
 		} else if (type == CRYPTO_ALG_TYPE_AHASH) {
-			alg_name = sa_algs[i].alg.ahash.halg.base.cra_name;
-			err = crypto_register_ahash(&sa_algs[i].alg.ahash);
+			alg_name = sa_algs[i].alg.ahash.base.halg.base.cra_name;
+			err = crypto_engine_register_ahash(&sa_algs[i].alg.ahash);
 		} else if (type == CRYPTO_ALG_TYPE_AEAD) {
-			alg_name = sa_algs[i].alg.aead.base.cra_name;
-			err = crypto_register_aead(&sa_algs[i].alg.aead);
+			alg_name = sa_algs[i].alg.aead.base.base.cra_name;
+			err = crypto_engine_register_aead(&sa_algs[i].alg.aead);
 		} else {
 			dev_err(dev,
 				"un-supported crypto algorithm (%d)",
@@ -2151,11 +2337,11 @@ static void sa_unregister_algos(const struct device *dev)
 		if (!sa_algs[i].registered)
 			continue;
 		if (type == CRYPTO_ALG_TYPE_SKCIPHER)
-			crypto_unregister_skcipher(&sa_algs[i].alg.skcipher);
+			crypto_engine_unregister_skcipher(&sa_algs[i].alg.skcipher);
 		else if (type == CRYPTO_ALG_TYPE_AHASH)
-			crypto_unregister_ahash(&sa_algs[i].alg.ahash);
+			crypto_engine_unregister_ahash(&sa_algs[i].alg.ahash);
 		else if (type == CRYPTO_ALG_TYPE_AEAD)
-			crypto_unregister_aead(&sa_algs[i].alg.aead);
+			crypto_engine_unregister_aead(&sa_algs[i].alg.aead);
 
 		sa_algs[i].registered = false;
 	}
@@ -2331,6 +2517,18 @@ static int sa_ul_probe(struct platform_device *pdev)
 	if (ret)
 		goto destroy_dma_pool;
 
+	spin_lock_init(&dev_data->request_lock);
+	mutex_init(&dev_data->dma_lock);
+	dev_data->engine = crypto_engine_alloc_init(dev, 0);
+	if (!dev_data->engine) {
+		ret = -ENOMEM;
+		goto release_dma;
+	}
+
+	ret = crypto_engine_start(dev_data->engine);
+	if (ret)
+		goto free_engine;
+
 	spin_lock_init(&dev_data->scid_lock);
 
 	val = SA_EEC_ENCSS_EN | SA_EEC_AUTHSS_EN | SA_EEC_CTXCACH_EN |
@@ -2345,15 +2543,19 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret)
-		goto release_dma;
+		goto unregister_algos;
 
 	device_for_each_child(dev, dev, sa_link_child);
 
 	return 0;
 
-release_dma:
+unregister_algos:
 	sa_unregister_algos(dev);
 
+free_engine:
+	sa_stop_engine(dev_data);
+
+release_dma:
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
@@ -2376,6 +2578,8 @@ static void sa_ul_remove(struct platform_device *pdev)
 
 	sa_unregister_algos(&pdev->dev);
 
+	sa_stop_engine(dev_data);
+
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
 	dma_release_channel(dev_data->dma_tx);
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 5152c497858f..510a9fc4ab62 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -15,6 +15,7 @@
 #include <crypto/aes.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <linux/mutex.h>
 
 #define SA_ENGINE_STATUS		0x0008
 #define SA_ENGINE_ENABLE_CONTROL	0x1000
@@ -146,6 +147,7 @@ struct sa_tfm_ctx;
 #define SA_UNSAFE_DATA_SZ_MAX	255
 
 struct sa_match_data;
+struct sa_rx_data;
 
 /**
  * struct sa_crypto_data - Crypto driver instance data
@@ -159,6 +161,11 @@ struct sa_match_data;
  * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
  * @dma_rx2: Pointer to DMA rx channel for sizes > 256 Bytes
  * @dma_tx: Pointer to DMA TX channel
+ * @engine: crypto_engine instance for this device
+ * @rxd: DMA state for the active engine request
+ * @request_lock: protects request admission against teardown
+ * @dma_lock: serializes DMA setup against cancellation
+ * @stopping: reject hardware requests during teardown
  */
 struct sa_crypto_data {
 	const struct sa_match_data *match_data;
@@ -173,6 +180,11 @@ struct sa_crypto_data {
 	struct dma_chan		*dma_rx1;
 	struct dma_chan		*dma_rx2;
 	struct dma_chan		*dma_tx;
+	struct crypto_engine	*engine;
+	struct sa_rx_data	*rxd;
+	spinlock_t		request_lock; /* request admission */
+	struct mutex		dma_lock; /* DMA setup and cancellation */
+	bool			stopping;
 };
 
 /**
@@ -256,6 +268,22 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
+/**
+ * struct sa_cipher_req_ctx: Structure used for skcipher request
+ * @enc: True if this request is an encrypt operation
+ */
+struct sa_cipher_req_ctx {
+	bool enc;
+};
+
+/**
+ * struct sa_aead_req_ctx: Structure used for aead request
+ * @enc: True if this request is an encrypt operation
+ */
+struct sa_aead_req_ctx {
+	bool enc;
+};
+
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

