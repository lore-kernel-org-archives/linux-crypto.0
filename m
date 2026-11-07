Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067661;
	b=IScmy3XK4TJMhJDEbG18ROoHOE2j17l3THbWmFCNW1iV/aA2ZJcPEAoONpeWjPUEuJQd
	 kUs46PzgcX6pE/1ROWZXrDOghihlsDWFivhFj4cE2clrEOO9ZC1rvkx4HRI7LVlqbeQn2
	 7C4ihV2rSIQBgX7c4mYnTZNgwlwEqJgmTuJw01f9yCZUe1koTxpDJm6XFTraWDI7Un+lW
	 kcC52VZIPINOW6OUQVNNPYQJZLKLZjO9p5NYvt0FDGnNbMzVD94XVLa2PRnbBrbBG32Wy
	 9LhzpVgUPR0GGJhCVHc0F0ktDdVK+9fhyCWrHHACz+gkjOm25V3uQ/1rwEcwYH2HAIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067661;
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
	bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
	b=IxcjJPee/47ACLPLbUoTXF6Gfiv3JvkRCMv5wm0Wtcg0lbAm0gp7uI+b0EcJe0kWjrzH
	 E+LsV8/mM55iGKw0sDNmID+JWsyNThkWeNSA6aDunyvEOOU+P/meU26MP6Hpsx968pWrm
	 wnGGhbJVhHKFhlU11z0/AUHuP27j7YE3NaMNyw6eYCAdzfBRzdEoS8MeB124VYGKPTtO0
	 YPcpp+48JZzRbE0B1KN9Xa8XNpRwo+xGcQG5LTpmtsBQMQkxR+YteMDzYIKyE5kB3tIQY
	 Ju+qT3TW7wsmJwlLu7NxpAU6TDU1pv10dwN6CHqRBZ4LtO94fmnuJKa6M53nbQsEpKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VGY+xk16;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=aVGhspi8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F5606A332;
	Sat,  7 Nov 2026 16:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 993F5606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VGY+xk16;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=aVGhspi8
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Exts82334848;
	Sat, 7 Nov 2026 10:07:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHora
	Os=; b=VGY+xk16oJz90V+1eOUvGWZrVd1sDHsUHJdr65XMndzRkESYP3izKhAxn
	0GewslgupqVn67RuCTS/uihsF/cWxX0YUL9B9ZoZz6x5x6Y33f8inNYU/9eF/gPW
	ZvF42S9+u35tlSK1xL/y48Zw//cjwbEOXmoHl8fK9C8cKlXHbBCBNI6BGcipgIgj
	nH1JSaab33cAFJ+5eQlMDS86B3Ly8MoPfhcbOiiglQY4MTmKMqTJsVKavARr5WJi
	a/IyjwNF8H3i9Qsa0oF/ljZt0h9hgqYNXXUl1h3mhXEhixkjdFL881t8IFe3WFmi
	lq22hpMqCUTXWqtBPU2jDuSxvKKxg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydw0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:38 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tZ1KU/4lV30ov0sVkvaIvpJcGuYuYO6MyYWzoR37+1OKW3WwXiGqLjtVA4zYaGjEpLkxvimqlnBEsTa8mx4D5Dn03lgmOEiS+2vcAhGLAFpp5hB9Hw/9eDUMMaCPvaO9NRJc1yo3PAnZ26GdvIBHovDCPa0+5Khy0W7ZW6om3hwZXBiQ/H9QFo7wTKmjMYRL5ZLGLwjwaK5F09xMRzCFC73BQu/G8AU68ZRrF3LTjsYWpZE/1XOFdWsc4bUbHY/nXjor6zjbDuJrbqA/rJvGLP7vm9z2I9tKU2zzQnbgxgLeGhR87YfJFRxpcxtQvVhcBLaFdIyxLGwwV+HyTrPpTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
 b=QTjH+cCLa+1DjeAJK+n2yl7NAg/g663ZQ/SWSo7oZvx7yaLq9vOWnhm2WDRST5tW4VHflzqt5y+b9HZhaxnusI+PCOopErbmPatEjL4rjNLYNb8piWR2ofAiHox/jNo4iREGzyo/w3gnRhZOSRpiRFBv/kChU1JcdEGk7zenP1t7fdVy/1K5Wm3T6TutHCqRS/rTS4IcSSZt0kk+EinMuuDk+NAHh693R5Vwj305m9NvHbSfL0FKzFq+5zwcXB9Nkw5KSDjjZalF4fuZZCUb/akpkVcT+VITaPPCf6W4PIhfKz1jShHtzgz7ox/Ik05eH/7ns2Mf9r9KLUMZBnHfrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
 b=aVGhspi850JJ8Hpqk7BGMXU1JGO7gu/OLp31UEfj3bKUzy3nQjnq5XaHQbY3R9sDHm6JFrAb6A5R4jDAiZ0mNMBivhv4Ow35sALDtTvFZJq2ctzaUmQB5qgOPAXpmp87yoREr1ktIyXS76uMD+eZdG22R7Apq4d4O6WlUJ3kqEs=
Received: from CH2PR14CA0042.namprd14.prod.outlook.com (2603:10b6:610:56::22)
 by SN7PR10MB7103.namprd10.prod.outlook.com (2603:10b6:806:32b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Sat, 7 Nov
 2026 16:07:36 +0000
Received: from CH1PEPF0005BD5C.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::95) by CH2PR14CA0042.outlook.office365.com
 (2603:10b6:610:56::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH1PEPF0005BD5C.mail.protection.outlook.com (10.167.244.245) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Sat, 7 Nov 2026 16:07:35 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:27 -0600
Received: from DLEE206.ent.ti.com (157.170.170.90) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:27 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:27 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7PFq277574;
	Sat, 7 Nov 2026 10:07:26 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Sat, 7 Nov 2026 21:36:30 +0530
Message-ID: <20261107160631.2592763-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5C:EE_|SN7PR10MB7103:EE_
X-MS-Office365-Filtering-Correlation-Id: 429d1d23-59f4-4d7b-3200-08df3ce93cea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|261021123027099003|261021121427099003|261009223027099003|261026121527099003|18002099003|22082099003|261102123227099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	y2Aefr591otFJ86mJEJ2zqdmLdpu3twV9xEy4HVMVP1Ro/hpDw7nDP607AMKkZXNdJXMHyTEOZZ2+ViK7ktTqs0NXH4U8YwI3qhXd0vMboL76W8cOQSbKE1feErXa2B5mIgyUtzz9ixHZ3nAJmaEa/j//iVtU+IUpM+vfLQOFr4+YCwkxU7Cl9ar1f1z+3pdpgFuI7M5C+SxlHnNXX+O6F9Sw/8+n5hDfXJ51s/al8yOsoYKsNnIB8dJJfQBFHCtQJb4BDbr2TMhhAmcvnz2J6BWd7GdP381oGEYqcbBujzv0AcQ1xdaCuvgiPQXWB4I/K48ZXJh988Yir8w1HUaEhcAmDfugLCdghMD8jkAtY8iAmju17BNz/Thw2MyzAlEWmlXdas8dVe+7ZuV5pDnXuBCl5cAyxcKR9RF+H1cKmc9BLpIwuSZdc54y/mBcRugnKKFcTBWgN8iotk/aidi0g2btnUKyQITHat8XOdnWdIJuqH8MokRmUlEKUhYhC6NbDpScmCK//7ITHKvmF56Ayr1okUHDPpEkzrZUzroMEM93+mu4XYDZPi9xT7kh39vikRo8ZIdZf5vhb4EKE8KA/LQ9kSDsOAFRMrY4QRlmErizk7TJcZySz8BZwliJUylA2/FjRxbmaDOp9SFj57n9jP0mJm58AV869Pgk12kz4vGTH/afuFEG4s0a85SKEqqvEGiYOpIXcH085hyWr3DOw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(261021123027099003)(261021121427099003)(261009223027099003)(261026121527099003)(18002099003)(22082099003)(261102123227099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0ZNhDr14UEfGWTo+Q8nLPeSGCXW7X/yPrNCAUkwLHJh0wHfr90/wtr+1GcsA43RdILtklIvR/rf1cB7259eBzNPYF7p4YryAxuY0ofgXx3LN+3OQcBwpU3fvDwQmDzwp1xgWVFD2QYZVm7jq4oFNKXjwDmvcGxVW8qTJT4DFS71Nq6sBQLTaLapalZKTN9PvSA+YS/qdcvEUxi7pY1dGQ6P4BmpFZPbqJVceBV/VQg29OAt9ROtTQ7WThWxqcsYQuFR/CCuwyo84CmCHfHaiiPLxUvjgBnm/XoiVj93K2QOsHJw1RmvXBYjj5N9I+sI1sgl46rLzNWbHNFiKCFXkOXAIa28/fCiDfbYkB+fpcIxKw5Sr3ChxQvy6MIh+3QDtvAK2WlCZCRS3p+SC9AGTbT8mqFAoHy9GBhUmCSbDoGjRojhTt4WJiPCjCKRyYHjR
X-Exchange-RoutingPolicyChecked:
	lZS/3QDDyOmHz4fvgozUUpmyAIYVnL2M8HeeZJNuAMzz3PEGXIOvGs+XXqducouBDv3xTJ8+sW6p9oe/sB2xbQ1wuySmx3d6KQW72vzWDyToZ67sKDP/aqP50jqu5ZlK7ultSJ5icpx5EzpRQYSn4bEGn3mX4dMSjLQSsdmBmPTDU1Yf5xY/5NKxf7B46GqRScXSdZkEragytbedFAxzsEo8EG24/8ZBZ0now7Y9SmUF85oYDvbWkYAW0MXcrg78JGC7QHAtnNzCkFOIFAPy+Lqehl2R0+pXq0pKwasP0LhFYMAPr+9rzo+EWwfgeLF14L3VLPkHYU3tvXUHsneoeA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:35.5959
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 429d1d23-59f4-4d7b-3200-08df3ce93cea
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7103
X-Proofpoint-GUID: x7ITH7KxjnEOqSX09I6_qQAfzZtNNE7t
X-Proofpoint-ORIG-GUID: x7ITH7KxjnEOqSX09I6_qQAfzZtNNE7t
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX0CouVQG4cuwh
 qid0ZJwh1ov0MLj0RPHpoSS6UhIsQpHFFhPCbPJKnAhbuzWVRwQDX7fbIliKfTmXVUnvM7LPMIK
 960L+T1fuvhpU6BYjl4obhNIe1fx0xs=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cca cx=c_pps
 a=IWYRGtMsEs392uQhKf0YYg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=epFSbgyaDKMf97JQNz0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX14/+0Rq0Xs3I
 3Jw7B8r0MA8IDDPRKgxxrfA9Wuku489/LiVeekNgwPe+TbLfVQEkp5EGv0Vbnb+YlF0K9wSvlzl
 kkZJme49XAP3J6RYFot2yTCN1nr1Zr6KTOs1ZK2eXB4l0tZXc1l7326W5JD1/8t/1CZXCZrKsek
 SvtDmgTep1JO4LQISUollvWtXLeqFtynXIR39mTwnFSRhOvmdWyjulx7ko7THzsvyicQwoEziOE
 3pSMGL5CmIDcVtaRv1NfX+5OBKpCQbMh6tOqF3ndC0Q4p8J92m956NGG/lX1pBvv9h2faOkmwB+
 MCkOPaspSm5k5deogzYCr8yOkp03cuCeKqEmz7l0aS4P5KkxGy+BHj1N64s44IpSVhnoxXjgcjG
 4PMjpFQg9/yKLDfsY8bjWsfT7Zz86a1E1FsDgK8UmP9RQzmoUGJXjcVDmd7HiPj+6ZEuUXlW1tV
 oRgIZJrOZkXJcch6D6A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Change assoclen, cryptlen, authsize from unsigned int to u64 to avoid
overflow when they are added (in TAG offset and padding length
calculation)

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 38 ++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 89fec15c63bfa..65f4a8648b968 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -758,6 +758,9 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -765,12 +768,17 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	nents = sg_nents_for_len(req->dst, cryptlen + assoclen + authsize);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
-			     req->assoclen + req->cryptlen);
+	/*
+	 * DTHEv2 is supported on ARM64 K3 SoCs. The off_t skip argument in
+	 * sg_pcopy_*() hence is 64-bit and the sum assoclen + cryptlen
+	 * does not overflow.
+	 */
+	sg_pcopy_from_buffer(req->dst, nents, tag, authsize,
+			     assoclen + cryptlen);
 
 	return 0;
 }
@@ -781,6 +789,9 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -788,14 +799,19 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	nents = sg_nents_for_len(req->src, assoclen + cryptlen);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
-			   req->assoclen + req->cryptlen - ctx->authsize);
+	/*
+	 * DTHEv2 is supported on ARM64 K3 SoCs. The off_t skip argument in
+	 * sg_pcopy_*() hence is 64-bit and the sum assoclen + cryptlen
+	 * does not overflow.
+	 */
+	sg_pcopy_to_buffer(req->src, nents, tag_in, authsize,
+			   assoclen + cryptlen - authsize);
 
-	if (crypto_memneq(tag_in, tag_out, ctx->authsize))
+	if (crypto_memneq(tag_in, tag_out, authsize))
 		return -EBADMSG;
 	else
 		return 0;
@@ -889,10 +905,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int cryptlen = req->cryptlen;
-	unsigned int assoclen = req->assoclen;
-	unsigned int authsize = ctx->authsize;
-	unsigned int unpadded_cryptlen;
+	u64 cryptlen = req->cryptlen;
+	u64 assoclen = req->assoclen;
+	u64 authsize = ctx->authsize;
+	u64 unpadded_cryptlen;
 	struct scatterlist *src = NULL;
 	struct scatterlist *dst = NULL;
 	struct scatterlist *aad_sg = NULL;
-- 
2.34.1

