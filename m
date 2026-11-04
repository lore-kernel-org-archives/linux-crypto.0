Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771169;
	b=ppvY/L8BZimXMTcCVGu2aZeg78gwS96P88RAUe38Ylcx5n9pUdDDSdqQCblchRlrauJG
	 JSeFVHbZ9pNSFnft/iAjm3aFFRPL7/EwjhFsNhnKSdp8xuvRhJvsqnZsBq4x891SNj5sX
	 jhaKrIBy6Y/Wcdfp8uFNF1w5j0F9pAbqxANI6mmViEgW7D5tcU4BZd5j0ZOZRS5qeZoBV
	 jBBmejKWgd+r7GXBKxhdkHtsmVD0AOJuobY0IY7fcE0JrAK3dNf3Sqm8pW7Gc++Et/RxW
	 JOkDbltIiAnEheWo0RZccS8m5iJZvjOmrptxidI0SAFrZv8D3H1WhxTs41mSKvkc8ow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771169;
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
	bh=Iwj/ORi3UItkdXRJOJ/WffdcniZsVlExwC4C9WqzZy0=;
	b=4miLfw5djR4vpNLQrUnZWxjas3lYQ/8GC9woS7qu1XUzFhtZ6noczylynnHvh4FQXvuS
	 kwoNN7vgIlxk7+dg2srKgfnppzcYUx1d5WZeRqqwFy63nDvxR3Z/AiyfUBJGDrRhfmlhz
	 QWSn249RdlqahZxjLSNieWrESCq32W2/vtKcNRX53uq/ra8ktKIPSBNNPiOA3c1Me1faC
	 GrLzz5j+OXMyl+dXB5UN4Ydd5mcDBzOsa1OpxT69qtWu6jnhKAEbNWj4JRzw9OUbW/7Yj
	 8czZ7T9g5jYLG8cnWAW+Fq1f1waYMh+B+2BPDFVDLRT+hzCFMJS537Uy8u1+5uLnUeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Y7rJCoSY;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=OuCwnp3C;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146C1606D803;
	Wed,  4 Nov 2026 05:46:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 146C1606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Y7rJCoSY;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=OuCwnp3C
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5H31166989;
	Tue, 3 Nov 2026 23:46:05 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Iwj/ORi3UItkdXRJOJ/WffdcniZsVlExwC4C9WqzZ
	y0=; b=Y7rJCoSYGauOMHYIFR1vT1M9Grur1fobLuj0g41t4M7ZtwAxLly7DUo3k
	PmmUhcVZ+gpc0PWIGKTB0WdiXzJoT9oL3sLHz1BvSTrKcASm+bda1kUq9gxOnapw
	kN3eDJIR7A2C9LCuB5U4MqouPT43GY963PQI2UsiZnvI0GgD80P0O+8h8W79v7+5
	sEn+wNb5wcLOFGJixRYQCW1+F23QAgIo8JHlbyChqDEevuw87I/jt9dgCIs22VRg
	yT7dhfefRbiO+O9zAHI8qv0+VfGIxrSbaDOr9zroxfJMNjSJBvVJIbxkET3VKZN2
	6umXS3a5kdH4Udm9Dtj2bLN/8fy0w==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010012.outbound.protection.outlook.com [52.101.85.12])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh246-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:04 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ykZ4mKiScw7Nuc2MwRG1iKAEUFK9/q/vIiLILyiyNksJDv39w8vPuTdqLqENgEFLKe9Uk1NPc27xn5SWoXh6fVCchBEBCI5tRrmjKvbn3zTQgE3QQgg85JfG18MoGwCTS5ACSJhNc/tQA8qp6fJb8NVDy0ljsnxteJNFScvlQ0ba1Knd1DXZ25CpW4ifLKaK0FinzIttJFe8CnYICFgPkk6j5SvyNU85bF7EbkTfH7uUAZaJzFPYJcixXP4KHHbKcJGKdeFp9u8SgktHzeWO6P0/B9hc7B7Ae4yxwq8rDcZzBy1PhgS71xtTadOFwIhV95crONtD8W5bGiYtHyugIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iwj/ORi3UItkdXRJOJ/WffdcniZsVlExwC4C9WqzZy0=;
 b=jTgRlKygqyv1KdMKvZdNj9JMbYLM5eeVBbtPQJDGnyFzpkbxiDU2x3iWoYE+NRMHAGUgxtGKB4772tgOxhkTjfgqEnDFpO39/VjX0CnHsUekBBUuGouP48TynVALLuOF0ghqy4Gpvo509KK92FFleGG0vPGbiq2G12bq/OGlHsplgMK1GHejdWVXQgXp1GAV236DDGFrz3PjIM7N9Etda/MXbB+B3Kd5rfHnH4GhxvmqB+K1hjxxeKNPiLzlQICYqwK05nrzgAW4B70w8Ug8x2wEXBzMOyYdt+nq+bwhbnSD4QbclPMc83G14DNHYzuptRfiNa+RD+P/pQMY8GF67w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwj/ORi3UItkdXRJOJ/WffdcniZsVlExwC4C9WqzZy0=;
 b=OuCwnp3CYOoCwTguQqkVaWQrJDf+usHXl7iwMt1VJHP7dueI6IsttO7qYhgFvdL75P6ZB4Rhjq95lncgWpGUeFjSRKSO88067dENAe2u8QAD54pWuVy+lkbQW4TjV/kgjhSblTv7uTf/6rJxnWzpVMbVJcTzu9X4NeXd6S4pZZg=
Received: from PH8PR07CA0027.namprd07.prod.outlook.com (2603:10b6:510:2cf::25)
 by DS4PPF441C8563C.namprd10.prod.outlook.com (2603:10b6:f:fc00::d1a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:46:01 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:510:2cf:cafe::1f) by PH8PR07CA0027.outlook.office365.com
 (2603:10b6:510:2cf::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:00 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:37 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:37 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:37 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ04521920;
	Tue, 3 Nov 2026 23:45:33 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:30 +0530
Subject: [PATCH v2 20/30] crypto: sa2ul - handle transform initialization
 failures
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-20-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=5339;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=y4eOO0+vJM3TQAlXjk3t+5KUqIAps8uPYhT4XUuEvzQ=;
 b=WrL3aqQ5IiMvEJ11t+F926K3GZYCkR4K/TbSt8qefYA+9iVQ1LpH+XkDAUbCtuf4mzRMfd98o
 Ks17hmRWJ9lACkvDNE59AfP2kBl+5BnhAI0tdU2hKFvLgvGKCCDi6Fc
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|DS4PPF441C8563C:EE_
X-MS-Office365-Filtering-Correlation-Id: 936e8008-46ac-4cfc-f79d-08df3a36e82d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|6133799003|10067099003|22082099003|18002099003|261102123227099003|261026140227099003|261021121427099003|261028144727099003|261026121527099003|261022105027099003|261009223027099003|261021123027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xJBsxaLs2UqOA1lINW008V/73hsnCUqiJp1mYO/hCDFURwHBlAHBLL/+f7XdSB8/XbLA2TwDeWxM1RWGn3vYINICc8tVEvklJEWYo7yS2OfR1vGUM+dHPxtatvmKk6It4eWXtu18VariFSe1Ga7fPh+SpAfzFIofZzQRIUznmCF5UwYlBSbVJDTm5ah3yEOvUQY0FXiXG1u1+RwaqGq4Jl9NmVk13ti2d3cbde/1dAG+aVHavhBOyjrin9EaHpOTs7oE4wQgZ2gZv80Mo4gcpQRAF+PG7V1IHhH4b+BOk1vAyyMc5d42UsLfhegZ7LQ2MVlKDpkmvM/wCRNnZaXQ+4Y6UFR2Ssjzhs6BWcBTFdj93bWZDDh/dECYm2kDH0VTPj9nbI1GTt/M2OPyeGBAm4geN2jTlzYkAYMgNE/AOQrRZzhVisSHJJ4B/o6WxOXhpV2ionwCgSRiwXIpxzc8FPXKx9sqidic74nONdX/vZotkpdkVxTLqYhED4F2x3FpoRKVaJGtMr5nRF8EHYN68pH3kpVXtP5ag9JIue80Mixgxmun2tTg6Iwgk84+2UCZTKLgBeEohdeaZgVTtrcri//t/StNbAqNspMYBNRS8JaxAcl6rU3zQrJa6BAVKJioyosd+kVDuJbNlZrVEjGkslkdwbgEF/fvAq+wCSjaYKeXb/G2KF3yXDGTLfU+lHUWn4pkQoWOh97rCobSk4gTAA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(261102123227099003)(261026140227099003)(261021121427099003)(261028144727099003)(261026121527099003)(261022105027099003)(261009223027099003)(261021123027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hHaYOTxEUUOfo5ubvqryTGeKFC36VY7NPavhkooDbB4CB8kdk1r4jpk+MOhvMNHpsj7Yia3STQ+6jQH99DYan0+ddc1Y0+Wk/w2p/MjpCgPENi0wWHt/ILi++msl5yaevcJ+lsP4UYMIh4SbOAyQcAyOdRfs4rG9N9LX4PccgQwc7u3qGBoB3qp4/EUCb/l/L7DRaEcXM3qliYnL9OYz3eRav14PeTex8ypixjlYh6d2OJCHoqHxLkVhDR0UodalT6CwHaKzuxWuAxIEk478xAFQG1ZJGh0CT9bDS4a8fwQ8gfpELfSCeC9kKAejHtYNASzqqBRIfIniDeoJbTZ24SKd6N/OZY4xYO7MbSlJd7+uJuP6Ca37DxIHz0aia1pAsJtBYKoplVL+L0A8iPdzJme5NRp3cahXIAGTAViTxfud2Kwog3NaI9hb3PXtFMbs
X-Exchange-RoutingPolicyChecked:
	mM2p2BMXfrlLrq4PiHSPO/1leTjgbbQQfCQrY498Ts1USywLupEiTAYhA43rNPVcCegNY5X2StkmaRYWljhNMCTBqbx4awY3Fv1SYMK4z22n6BX+U6F1My7BhK3x0vhPSXKp4ZUeCCSW5D9X9Jt0wdVC0l9/RnwC5QEAMsZhXJHvjlDQirwIgN0hoLkd4rvICFUcHdU2FK4rNEYQQo++DBBLg9kYYigg0XCmnUWpfbmI//lhz90sh4G4encHvGqmWxQqGF/6F/VqfSvvl0vok9QeZVOdcZJ0iw0KU6oqA/VlUBHzH1JmRjB4xPFXiVysA0teLCFyeKp7C31+tSrWFQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:00.6536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 936e8008-46ac-4cfc-f79d-08df3a36e82d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF441C8563C
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXxsGqcxO3Gmw8
 aeOvZjZOpAhaatzMrCPnKTO27I+l9Wme6/FkAob6HaPQK/bO6gbbomu5edksjLwKMCIrB1Ekzov
 5V21kVf2p+ertUQCkNGXqnYCmRquZU8=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac69c cx=c_pps
 a=cX17BFbqy3c2X70AxBoB8A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=IH2a9-vTckOhb-b398EA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EVQhtFEmhn1lXc6tFXdO-xyDgPRtsPxm
X-Proofpoint-ORIG-GUID: EVQhtFEmhn1lXc6tFXdO-xyDgPRtsPxm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXxDsE0N1/IMaz
 RnxwPlmuwDULw1tALbgAntRfxokzKfFP/ppvhFZl2sCAtKgy8ez7j53KSOb7bUIzkKOGxvr3jIZ
 CHc5Nrd3NPXYm23PY4Ohw8+ux0wAs91Zx3LkVAm3poRnlf/5Nsx+stvZ5dGoFbTge+8P4b/VULq
 3iWUtgX2+AUj7ye50DjT+1e4DRT3wipJ4I63bETaojsvi4OIlhHgVnEJMYTSjcooJLDAJW/efx5
 VoySBbsMBGZr4xMxFiFZwMXSmnE+t1oiaDByEWRNzgTK90hTsmv8bzgjml6uxeo8DohCLpXXU7n
 8cx1gqG/LEl6Pd4bILn4IoZCRY5YeQvrCpNu39l4mC92buyX2M2wT48X15DcaufCAiR1EtNhnbh
 appzI1+eW+CbMB1hhF/Es4k0yDT38hozHHxFjqcwLZNvqbtK5BxDGDkyGgkya65ZeIu3hjYOq8d
 tqTZhP8439Y72bVblFw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Stop initialization when security-context or fallback allocation fails,
and propagate hash setup errors instead of exposing a partial transform.

Unwind acquired fallback transforms and security contexts in reverse
order. Release the hash context on fallback allocation failure, and use
the hash teardown path when command-label setup fails.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: 2dc53d004745 ("crypto: sa2ul - add sha1/sha256/sha512 support")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 70 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 36f1d13dfe91..ead12f77ff67 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -771,16 +771,14 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	if (ret)
 		return ret;
 	ret = sa_init_ctx_info(&ctx->dec, data);
-	if (ret) {
-		sa_free_ctx_info(&ctx->enc, data);
-		return ret;
-	}
+	if (ret)
+		goto ctx_dec_err;
 
 	child = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
-
 	if (IS_ERR(child)) {
 		dev_err(sa_k3_dev, "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(child);
+		ret = PTR_ERR(child);
+		goto alloc_err;
 	}
 
 	ctx->fallback.skcipher = child;
@@ -791,6 +789,11 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 	return 0;
+alloc_err:
+	sa_free_ctx_info(&ctx->dec, data);
+ctx_dec_err:
+	sa_free_ctx_info(&ctx->enc, data);
+	return ret;
 }
 
 static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
@@ -1407,7 +1410,9 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		if (IS_ERR(ctx->fallback.ahash)) {
 			dev_err(ctx->dev_data->dev,
 				"Could not load fallback driver\n");
-			return PTR_ERR(ctx->fallback.ahash);
+			ret = PTR_ERR(ctx->fallback.ahash);
+			ctx->fallback.ahash = NULL;
+			goto err_free_ctx;
 		}
 	}
 
@@ -1420,8 +1425,14 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 				 crypto_ahash_reqsize(ctx->fallback.ahash));
 
 	return 0;
+
+err_free_ctx:
+	sa_free_ctx_info(&ctx->enc, data);
+	return ret;
 }
 
+static void sa_sha_cra_exit(struct crypto_tfm *tfm);
+
 static int sa_sha_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -1494,45 +1505,60 @@ static int sa_sha1_cra_init(struct crypto_tfm *tfm)
 {
 	struct algo_data ad = { 0 };
 	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret = 0;
 
-	sa_sha_cra_init_alg(tfm, "sha1");
+	ret = sa_sha_cra_init_alg(tfm, "sha1");
+	if (ret)
+		return ret;
 
 	ad.hash_size = SHA1_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA1;
 
-	sa_sha_setup(ctx, &ad);
+	ret = sa_sha_setup(ctx, &ad);
+	if (ret)
+		sa_sha_cra_exit(tfm);
 
-	return 0;
+	return ret;
 }
 
 static int sa_sha256_cra_init(struct crypto_tfm *tfm)
 {
 	struct algo_data ad = { 0 };
 	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret = 0;
 
-	sa_sha_cra_init_alg(tfm, "sha256");
+	ret = sa_sha_cra_init_alg(tfm, "sha256");
+	if (ret)
+		return ret;
 
 	ad.hash_size = SHA256_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA256;
 
-	sa_sha_setup(ctx, &ad);
+	ret = sa_sha_setup(ctx, &ad);
+	if (ret)
+		sa_sha_cra_exit(tfm);
 
-	return 0;
+	return ret;
 }
 
 static int sa_sha512_cra_init(struct crypto_tfm *tfm)
 {
 	struct algo_data ad = { 0 };
 	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	int ret = 0;
 
-	sa_sha_cra_init_alg(tfm, "sha512");
+	ret = sa_sha_cra_init_alg(tfm, "sha512");
+	if (ret)
+		return ret;
 
 	ad.hash_size = SHA512_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA512;
 
-	sa_sha_setup(ctx, &ad);
+	ret = sa_sha_setup(ctx, &ad);
+	if (ret)
+		sa_sha_cra_exit(tfm);
 
-	return 0;
+	return ret;
 }
 
 static void sa_sha_cra_exit(struct crypto_tfm *tfm)
@@ -1544,10 +1570,10 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
+	crypto_free_ahash(ctx->fallback.ahash);
+
 	if (crypto_tfm_alg_type(tfm) == CRYPTO_ALG_TYPE_AHASH)
 		sa_free_ctx_info(&ctx->enc, data);
-
-	crypto_free_ahash(ctx->fallback.ahash);
 }
 
 static void sa_aead_dma_in_callback(void *data)
@@ -1612,12 +1638,12 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 
 	ret = sa_init_ctx_info(&ctx->enc, data);
 	if (ret)
-		return ret;
+		goto err_free_fallback;
 
 	ret = sa_init_ctx_info(&ctx->dec, data);
 	if (ret) {
 		sa_free_ctx_info(&ctx->enc, data);
-		return ret;
+		goto err_free_fallback;
 	}
 
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
@@ -1625,6 +1651,10 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
 	return ret;
+
+err_free_fallback:
+	crypto_free_aead(ctx->fallback.aead);
+	return ret;
 }
 
 static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)

-- 
2.43.0

