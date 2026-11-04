Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771173;
	b=lkBjnlucuxEY0hOL1IvU7WB8ogQ+P9Cq4E84exS6Gus5HXe/jupYxVqfjAJJIYCBOhb+
	 RBpD4iRus1XmK4UgqFBiIA/ig+s5gQTsyC7Ha6a3jw2EN0zsyeZq93KnC++YwMaG/00dt
	 Yga7nwWij+O2cGhS/tt04PGr0lttOHuSGrtqzwmkyXiEFEg19vxMBqPkp8OTtbsrFO8KK
	 oJg51ln3rmkweT7qxdMlQqVQl1FFI8xszV2KEsVbwIfGzxy2VbM9hnORssZoUyYHbWn+A
	 2ar5magIFVIW7PndNsNbnSyeutc6mBPCoNzgpYj9nCmHzB+IH79GMLAPcO2yZfGC2/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771173;
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
	bh=BRnR6IJzzZo2hPzkViJ5fDiOi53UaeGq9jZZ97rImKQ=;
	b=ZwuYn0pa0WipbCHcu/c8Pu8ae14Oxp/+B0hJm6h4F7wxm33LZxfq8PZNfh+SvAkrm1YT
	 zffnbBkY0u0SQx8riGtESqASGi3LtrJDT+B7NgrE1JTxjNErQjgKS4mm2DiRZBSiUifk7
	 bRlJOiYYy6+uppdbJLBvvqVewKltO+GCIu4+pmbwv41XbUjhOv/2Ea8aWXFXV9MKRjiGw
	 x9Sf4xAB4iC8X2EAB+6GuKe+dsjob9524/suEBPWgN0x2+s4V20NTzd5/BG2GhZHyDl/5
	 o/tX9k60+GNHq1Mg0jv31bHnBTl+85J2h1WZT9t+58oyZzgQ7YN3/qJc5IwKDIsV39g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KtvTFFvI;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Ae6dvx7A;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF316606D818;
	Wed,  4 Nov 2026 05:46:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF316606D818
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KtvTFFvI;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Ae6dvx7A
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40STu8772193;
	Tue, 3 Nov 2026 23:46:10 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=BRnR6IJzzZo2hPzkViJ5fDiOi53UaeGq9jZZ97rIm
	KQ=; b=KtvTFFvIkWyGhHdLINd/ZfKXh9twm7SeFeOPhMoioSyxccxNoLrB4j1PC
	spkNxWzeoEx/BOAzYZ54Xyj8+rJISznPGayv7yPyhvYDfxP4MkYpe0O7+cIktFte
	gwmcPMKzgidBKagqemrRflQibAO4fJQm/5mJGpuAFiotj67BIs3QOw9VNorQxMGS
	bRqqefUrHt5rugHaV/OYyb/Xy34kbyfrbJShIiwBCRnHKAG/4UB+oB/dj6+Xj83M
	qAdVI7FmFMzAq7YXG9TsS07nP+ji54ODNlJfmaAaGRTDRJEBAUKc7WmSa7Ac40kV
	n9AYZqx8CCRkEooJ05GkR3MYOeRKw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25pj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:09 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAWJd43RnXKj8QOGcpi4CXjJ/J+X0Gt9/yeC4rCf3cYT5Lj6fdDt09oeDVjTSQRP2y45gQ2bHWkZf/5bHg5+5+fml75e5CtCxZ7qAWZI227BfS5agzbFkrYc74TYlk/hVg+snQ4/0YuktY0LTStIaOWmLTzxnHjlg8V35ISg7zRsGKzSxNDjwFISJ3T9JHx0swA+9NJC5ylTKwahQSa4w8haWR3WPa45O4+QeqYTilJMFZ+6hsET+KS11Z1TZS9acnhu0+Njz+2TBb1yiiuW5Qj6CTxEQWd/9FONG8LgU9BPh9y/fIWIRYMOc4ZogvoG74BDVLC6PEMk7W9E4IG89A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BRnR6IJzzZo2hPzkViJ5fDiOi53UaeGq9jZZ97rImKQ=;
 b=s9D2XLb1VMh/MYlPrj77ZJutcaeGioQgaNj0XgeuU9wX36PBh6p4d+gvRbKJzr5BQlGFMhcO0bSyOGNII9J+d6kUJAeoWdEpUoaq4ilmS3CNRP8PGj8iud252EQkuekzhBUGY07zAfr617IQX/4lz4WJa0WeaqdTFBhaUJqVH1W/poLHCJ8NNz0eXMRYNJgZMF2wwToNk27YKi9EfE79veEhKwKL8KA5vvQLb2aOvjSq9JdW8qgQq5t6YLZzxXA4OmfoUj/0G1sD+de1ZqG1FPV75j/wjlhbpDdnDwnXQbCgsu4K/VEMHFdV0Ut6p5r6v6fVJQ4PTNcsdYW4emmqLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRnR6IJzzZo2hPzkViJ5fDiOi53UaeGq9jZZ97rImKQ=;
 b=Ae6dvx7A2JiWHdRJHrZaXTHaI0KXH84rMiiEioSi8F/R2GlzyDRBuUwgvkoqNq5th3bVkUcsQsBthCGEIk3NK/bEqtZG45xshGN22nk26eSS0OX2Uc4xPZelLV8L0M0HATn7L0GbSrlCqhQHXS4oyr150Slxvtg3LzFH6Y2S7Q0=
Received: from BY3PR03CA0011.namprd03.prod.outlook.com (2603:10b6:a03:39a::16)
 by CH4PR10MB781280.namprd10.prod.outlook.com (2603:10b6:610:512::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 05:46:07 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:39a:cafe::9b) by BY3PR03CA0011.outlook.office365.com
 (2603:10b6:a03:39a::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:46:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:06 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:44 -0600
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:44 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:44 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ06521920;
	Tue, 3 Nov 2026 23:45:41 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:32 +0530
Subject: [PATCH v2 22/30] crypto: sa2ul - validate scatterlist setup and
 unwind DMA mappings
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-22-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=2701;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=0vjYnsiQTMloqcJ/inMzUmoMtCefr+M9vEZ+YGwDxaA=;
 b=fnn129XsZN+SISjHNyYbU+usRxVFsaVUN7y86Qo6SpTj/fV/K59mwlzrfkDyvwfXutJ61BQX/
 2vVfi8a9CTtDE3xxw2qsWLyVxuk/Y6kHlolqc4bHbI6Ypu86x4If0YD
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|CH4PR10MB781280:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b5b7b3-9a5a-4aff-07b9-08df3a36eb84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261022105027099003|261026121527099003|261028144727099003|261026140227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q9q89J6fTDqlaaJCziKAsweCNRDNxS+LpOZkMCl6dw8sTkEdkEea7o6HPArXl433pDVwO5h0xvzxqzXElmuFt3AxC9+Ir87cIpi1lyLcPPKtqBai61rO6idZRqEB5yUClfHQ60mExKqUlgJJkaxA+OU+mbsHtHFHcDRA3TBXi7f5yMR0feU3mNeU2rjY+Zl7ypngI74kohJ/cCXHun9o15T7ZHD0PtDGirvmJnhOCRZGIu7NLgwCTsYVRYEOpKb55My7ns2yLiTGcjomZYoseYayxtRVHSj+GZ/SuXwwGxVoSqp4jw7BP1N3HK8Vrhz7CWcVCi4BcltaDAT2xBKkDqrE4419T4nrOEpm9aUDBxoF6iQGQpFFl79Xib/TIKIhJA07h9+27yTSTOa+lYn9GpPXqbJevlbM+l/3tsYLvK6GfXYuIAphrUd2xcrn6zICfHQ0ILaCm3ri4dYI0kyzPqaRTjv2joBs6EmYOBX44z/5cwXAbOu+CdyqY40MoYbLL8LONQRpi6O3j1+zkGRCiRJovQQcgnzeGrhQ1m7uWBu65HRBIzM4U/A6O/KPK2gltaEWkIZKLpDs6UK7NVycq1k4ueWV0am7gkWbobnI4MUU5CcwHmEEU2E8IMGGvbO87SGDINnlt6BV3u3EykHVKc8OUbPWP63rf+DrdopIibbzJMo5dBtzP111w81U4aAdQ9WOMXNcSlYZxpzIUziLrw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261022105027099003)(261026121527099003)(261028144727099003)(261026140227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H5ZuQbamLdlYvQHsSIX7fJl5a4RJOUemGog+Thg2vruKMsce3B2PyLtiG+zQsMm0IxFj9Loik4Ef3wPg4Des6KL/DgTnyFxwMxwfPQoftPl6kXIzBEBckrG9vpZgqjSSM2AdfhLx4FSFgg6gTK1+NYgge2nKoarYN2pYgl4BdnCbQ6cMS555S9OXTo0ya5OvJYy9+5uF6rurmh4Is8a/pnhTSFkdbHSBAnghCSe2Oz1+YJPYEdtL6CxQschVHvB2Vcsf/RJjmYcWn98h8b0/KMEJ9JDNbrZIaIHmvdVNIrx+I7ah88VVDGjuxG5FFP0UYF8p3mYJUv2TWj1bpuA8W44HIACsktUCOLBCuxQnyxPYw9g/YGHN1LiqTw9Ysd9e9PfRnmyDTYPI5soT+yKhYXF/wAOBsWWqpMuPNJ20KgAUJE1jc2ArsUOC3hjO2meW
X-Exchange-RoutingPolicyChecked:
	pRlyVK2L+AhHH9KgpIe2zArPNSb+BFQOT52JP4aIYQupFKgmY3+lFgNKjkzuFrvg7pkO6QGI1D0gb9kDXRnIBsLGcEvviN8SQpfO4JUYrPXQ1TyljJwMC6Lrbmj1tCjZRs+76c0xN8hYp9E/Vwx1vuZcA6zAQedDrvy8lvm4Q1jrkrdUCgXPahRqkUjEOFgZFdtUGI2TS4dVI9+VxdmABAtGQ8QzISeW93UVYCCaCv1kV9vwDt+t3Ugw8BwD/mIBtceCEo7FnuuiZ+2NdO79aBt2+gJMgTxLfjNulKd6lYV9P5mZOJo9u4bSSWzpwSRYxQLrBzIPptLSonvf9+C9EA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:06.2545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b5b7b3-9a5a-4aff-07b9-08df3a36eb84
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB781280
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX9SUxOegmTpqt
 2p2J611HHjZbtZ4ehAZcd6zAg0gzaBz9zkvKgCwmHZ8H+6ubYuITsRXiZYOU2nzEH0e76AIqEfu
 9fBvaV3s8556bb4/DpYBKTPfTXEm9zU=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6a1 cx=c_pps
 a=P3qATxxxYOxA1bnNUqDMzg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=TRi9WvQs3auZSyPd90oA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX+TWGKYwDTIAI
 Uie9AJ0EuJMJmCeA/nuawdy/0h62yNt9L1XM4zlFcDXPt5f8voomK846hJhDPlbHBKXmSrBda8v
 ZYBKgTyV3meEMbjdj8FqpnV6A3cpZJmj2tS7qb2OL1iscMsEZseFWvuVBzxKNgp3VEAMkV3i34q
 lGWUHxz5mYituYg2dg0hAsWaSRe4ycobQwZupAK9ycQbDhtmotr0f7hqMhwJ3Rdrtq1jm3DFlZs
 XaTqq81n6k6XmORaOexnt7oAmx/T3d/G5+Fkx6fQSWni0nHJ7Jlg/w4YrifCiBvDZHu2Qq7a4YA
 WLR4Vti8ooCKYtAKH2fFhtWztAzP3cGW34qiRnE7LxFUa0IIPYzPfM26zFtOY66LnCkZswMSsIG
 KhPBa3LZRQvrZB3KYHSpoGVi47V9YhsLDLRf2EJZotuQC+NrrYx97lVYSNzL3FmHSbmug96/QOP
 H2BocngV26fR8OlrUIQ==
X-Proofpoint-ORIG-GUID: P3D3TEX_xfQ5YecQJKMZl58YaPdP2oMI
X-Proofpoint-GUID: P3D3TEX_xfQ5YecQJKMZl58YaPdP2oMI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Do not continue with an unsplit scatterlist or pass invalid entry counts
to the DMA API when request preparation fails. Check source and
destination lengths before mapping, stop on split failures, and route
partial setup through common cleanup so all mappings and split lists are
released before returning an error.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 2964aa44d50e..b33fac66c93f 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1071,6 +1071,10 @@ static int sa_run(struct sa_req *req)
 	 */
 	src = req->src;
 	sg_nents = sg_nents_for_len(src, req->size);
+	if (sg_nents < 0) {
+		ret = sg_nents;
+		goto err_cleanup;
+	}
 
 	split_size = req->size;
 
@@ -1086,7 +1090,7 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.orig_nents = src_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
 		if (ret) {
-			kfree(rxd);
+			sa_free_sa_rx_data(rxd);
 			return ret;
 		}
 
@@ -1097,7 +1101,7 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->sgt.orig_nents = sg_nents;
 		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
 		if (ret) {
-			kfree(rxd);
+			sa_free_sa_rx_data(rxd);
 			return ret;
 		}
 
@@ -1106,12 +1110,10 @@ static int sa_run(struct sa_req *req)
 
 		ret = sg_split(mapped_sg->sgt.sgl, mapped_sg->sgt.nents, 0, 1,
 			       &split_size, &src, &src_nents, gfp_flags);
-		if (ret) {
-			src_nents = mapped_sg->sgt.nents;
-			src = mapped_sg->sgt.sgl;
-		} else {
-			mapped_sg->split_sg = src;
-		}
+		if (ret)
+			goto err_cleanup;
+
+		mapped_sg->split_sg = src;
 	}
 
 	dma_sync_sgtable_for_device(ddev, &mapped_sg->sgt, DMA_TO_DEVICE);
@@ -1121,6 +1123,10 @@ static int sa_run(struct sa_req *req)
 		dst = src;
 	} else {
 		dst_nents = sg_nents_for_len(req->dst, req->size);
+		if (dst_nents < 0) {
+			ret = dst_nents;
+			goto err_cleanup;
+		}
 		mapped_sg = &rxd->mapped_sg[1];
 
 		if (dst_nents == 1 && split_size <= req->dst->length) {
@@ -1153,12 +1159,10 @@ static int sa_run(struct sa_req *req)
 			ret = sg_split(mapped_sg->sgt.sgl, mapped_sg->sgt.nents,
 				       0, 1, &split_size, &dst, &dst_nents,
 				       gfp_flags);
-			if (ret) {
-				dst_nents = mapped_sg->sgt.nents;
-				dst = mapped_sg->sgt.sgl;
-			} else {
-				mapped_sg->split_sg = dst;
-			}
+			if (ret)
+				goto err_cleanup;
+
+			mapped_sg->split_sg = dst;
 		}
 	}
 

-- 
2.43.0

