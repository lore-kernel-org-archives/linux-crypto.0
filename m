Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067671;
	b=j7F687soYren+1iwcOqGlONGxQoMWZBrUttZxX1DiTnGpd5tySft0jRRMsEvF/s63uyF
	 c9kIIuKGURu01WniXDA4zZoZH4zItm3f4+wcX5PkWbdBH3XsPd4TMxgvHmIP5myMUT46L
	 C4tu65VyZ1i/uzvzGjp2eDYbX3YItiktDbcGXGe2yGIjaNZiGFX/IhBmXGJ2htbhUpf1R
	 mk3qgjyEJ1hD8Vx5jT+Ep2KCsCnfY0qWhkmQV1FqkkeV+mh4O7W4Ya3UwIFPOU/zj9X00
	 BjfsltxF4qjXoPUeG4UKCXzgAW2m0OmDt07z0POPRsbLD/lM4uD8ebWcsCVpY1J+SjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067671;
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
	bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
	b=PWKkca5TrXPVuvbud0dEj4VGmoDlvbuaRU6brPoYXy7LyJSaeFGRAMXepydmCuGpauJ7
	 VlITLAdSngO3Qyk7xj5fxeRFCNVrU5EO00lMqxOyMFzv9ioUTM/VfDQ3oxqHT+3qMmvMH
	 rdvw18jKzbZC5vO7s8rxdYZJoUK4LAH2v40/fxlQPDZxD8wdaiymsnqqTmZoIV+Q/C87o
	 vmEEkcSEhe7Y0yipw1LUIfXjzOWr4R4zb3gKBVDnha6RtXwTOwW4BZ044pYU8D/xrVfsq
	 gjbgSWZ/U8Qx2ttSbhVSRvSkQGn7H/rNe0ZgSpyjII5ao2LiVISUc3vOR+Jfyu8tZgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=eF6Zqx5F;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kbnnMF8f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15310606D826;
	Sat,  7 Nov 2026 16:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15310606D826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=eF6Zqx5F;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=kbnnMF8f
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Exg2C2334662;
	Sat, 7 Nov 2026 10:07:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wU
	JI=; b=eF6Zqx5Fog8ZQ/l+xSM97qwMFwReG01NypI+yPPpBTrklmMm7cJZ8GChl
	IBpS1CG83uGWY2BKfBCEsD+G1ye9Hze/RGrYu7OM5TNzTK49++Uo9QmiNkAf/5m2
	kYRggI4FM0ovXpWfWNc0hUns7O3El5deV9tuEuwZvxf6tGEgYjjnrQXrn9ISxuEC
	68qFLf27a2JPEt1ZtTIiZUBWqSLIwAnnTnS27FQxGPBXn2aNkHdmB/4NR6mPSF6e
	bABOXQpRu+foGcWsVozNEwechWkCc5xhdaT783xSEA61hWcO6lMoXUS2phToVZ0M
	lQBc8NjxfcvED0eSpxbp11NGFHn7w==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydwk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:49 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkSD20jL1QRMEYObUxpzQkPAg2VJzqWWAJ2YsxBdBUQbc9Isn0V9/Dbzv0eUHvLLMbTbsBUdVfn8OMxP2Q3q6yqlOM1EcJKZD2OVujcYCwDI8WgTi2gUW/1xUXbMdqLTZWXt88BB2V/MkkWLtKCMLwvJ2R5anCjeH/x7N+MbTXGLD9KBYVglUCoNKltQtJfZNs5eZheSFreuyKFjGxfH4m/EdSY/HCmTzHmuLDKRfo0wS2kqCk6qs3GctHgTkpxCg6HZGnSYs9EbVni1fz3Qz5VaGR9jOsUTwHhLy1NjP7Z5/X4mfeiFSnV2h0GZe+GnSUi7zloUKqRik7+q/PsSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
 b=YlZQrxbiU/8ktP5I5yLU4HtDPqlBgOtcYEQ/ZNBetjrpdgT/6uIFq4jUX22htCaIBFn6YUyW0gvor9jPIq/BaHGIfnC04jiJ1et7zOi6zkWVNQ8eScHdwTQlrANZJoGLeZvL2Bccs0uGyw88YLfMt3tnR3f0WEOWUOw572fBA++f1aKwWYu757dsewHmC8BnftXeVBwmOhCXoNt9Bn9wzuxjfb8Eq98CUd/w3MJt2XatwxS+PAjEM1MwLWa3y634cPRtZMIdGE0SzfUXU1DgjOcA+nNZfKfwlA6772zdRxbQBogEFpfT1P1x6/GeS+zVgAs+FxqZRdYXVzFa3q468g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3h6/V7dtPpMqbupHYL5Bwzhb+ItUeqmXAAKF+1wUJI=;
 b=kbnnMF8feHxnS6T7pXg6CUARj8thLiQw650gSlg22+BCpsEM7ueQZc2WYf/g6Fdkpd58VRYG+EtAxr8oRsICNI7v/rTDYi8WFxbK7LRhLhqLMf/xWDdesnlV/QMb2x5O0cevIXz0G1kRGcs3Rrh7LbjloLDcPFUmQXwwe/QXkok=
Received: from CH0PR03CA0249.namprd03.prod.outlook.com (2603:10b6:610:e5::14)
 by DS0PR10MB8006.namprd10.prod.outlook.com (2603:10b6:8:1f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:46 +0000
Received: from BL2PEPF000352D0.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::a3) by CH0PR03CA0249.outlook.office365.com
 (2603:10b6:610:e5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352D0.mail.protection.outlook.com (10.167.249.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:44 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:14 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:14 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:14 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7CsN3460036;
	Sat, 7 Nov 2026 10:07:12 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Sat, 7 Nov 2026 21:36:25 +0530
Message-ID: <20261107160631.2592763-11-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D0:EE_|DS0PR10MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c857a54-8368-4e2e-b1c9-08df3ce94284
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|261026140227099003|261021121427099003|261022105027099003|261102123227099003|261009223027099003|261028144727099003|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	InQ4lhXFC+Wu1rj3oCpsUIe8bUUPqRBZXayKsqZBFU3nkPPxYXZccQShrTxqqGWE/hg1QT9qpmkiAY8PJhLaGzw4KwRwlCO7/Q06Ihe24a6JTOqqmPgy5BLbS7M3IeO+ebWNnrn+n38ChWDXegwlU3nHVNNCNTuHh96c23P3VyyWxCvBGNQUTzLcoUhiTi4zQQm/3iNeUn6twbu0ikEk7h4WAYVunc1Y4a74+GOijHGT/1KleEf+2GZ8tcvNYbDonS22/BZ23DgA800yRXtvXhELW3FLe2kSsH3wO2TfHI71nJUyj0ENfB3XPGoh+aJ6z6YBJcQxw3s1/A2JOogrJd3vL9XhUGGphxJWnddGkfz1IfVor/O2EeIAxU/MDC0qfUwcXPrKK5q49u1sEFtraD1tWI4ZXuuP9FdfbHqcmr+kYoEUggnxapw/vOzYGPcQV34rrNQ0/bBi0/fbOpGRqV5HTJ3OqruCYnGvjkZWcP5jOc4Kjlz0iGz0q91QuczGBb6WbB151N/gogcncXhptEhq4uZM14F6MF+HJ7RErS9N/eJFOymB3dZpvoUO/K9vCVWUlua1A0XO3RFsvLLcELn0Tu5ki1uNJJwlLLTF8oAdWSI/OprqjgaYuug6nnepuJAQfTHPbWvRX7Px1sqA9Lks5CfijgOOuIukvkUdGc8Oz3TsSjSW3wn0IuUyuCjEgWvgeLVvghnz5DlnRCxs0A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(261026140227099003)(261021121427099003)(261022105027099003)(261102123227099003)(261009223027099003)(261028144727099003)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hLRJe3kdvi0sqv9Tn70sjYbdClvqEP5rdbl/QoneAhxT0VEoanLjDTwobiOtlsy4L27F2WdaFv0FeTFZ80wZBw4TFqJwHEogX0tMZo1KRVDxuyF+kxz5jnNqm9xOIifkSziP9HutLXkkJEoiRXRai5FGqb6k6r/N/W/rVKsCXadg7jpgx4lNtJCRTAc5P1PCiqt8CfRgDwocMjtQ40FuYcwoIrVyeK9O1B+psp5UFjXsxDQX5J9Z3SI1cg+/xHoWlzDbAhiFjF/M5NVeEFtv0vbmckkEzaLbm5kMf0RpQX3rQvwHl8JVO1hugNOZaIfA3LDLkZio56yYVq+2CrQBpAEgY2uh1uIc40Px1+54Pg+EhdigqVNNtZ3CuyfQFbdnvb6mwv/aurhrTY3MdSjL91LCZzCCfR94yMOzM85ur5Muxkbz8hd2Nc6EqsrabR9H
X-Exchange-RoutingPolicyChecked:
	oTppHT7cbSXSgwYGzP/JktYyWLGLOcYWvLUCTV6SEx97VFYqu2LUUAZl/97quv2p4VP2R1F8kY+X1QnxWWJ45OLdlXv3kWaI9LgV9DgAcBxMI6gkjf/xKRy3PXnQzSYccjt3gKp1tmMCJaNNTDBq0IjQGCn9LSIEXiDjFrUhK+g788dn+DWKctChqU2e9XCKNN8DU+sIGmdAL4HsojJosxS3r38KMLHiE7NCz6og11Vx9P0hMOMp9cDQ+JWHBFNVGkBlDA9YuqeXSN6uyHObbRsUT9ZyoNvx7acwlg7KsZVXiHo6RbXTqGzLgjdPIsiVd9ZTT/MVL3mJ7vKzIdvAPw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:44.9742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c857a54-8368-4e2e-b1c9-08df3ce94284
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8006
X-Proofpoint-GUID: Yjyiw31DKoc0JYKrq-5zdX7aV9UEXbUx
X-Proofpoint-ORIG-GUID: Yjyiw31DKoc0JYKrq-5zdX7aV9UEXbUx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX9TmdtwBqtOQe
 aPWTQYHAsvKBzraeEIAtPvhScDgkNglPn045oNTOJL5BHKx4DIudg485Yqpg3wgk2U1gjmtVxqP
 iQKm2hOmryl19CXew+R4w5KB8ZDtPpI=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cd5 cx=c_pps
 a=C5fyF0bn1LKt8LWMWUNbGg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfXyTLIyP0Seevm
 bmw3ZPpU5x4G8Seo5utWp/Q8sHVydAsuuRg6JTPtCa3TXvG3JJUGsSHWGBTf1LB+XDjB+EqNez0
 am8J//pMK/xSZJUPG4wkXFacBVnEsGuOJmT/9OKh957Ir/TbyzqOgiSUXIAQCjr9R0yONK99FXY
 dn20K2WHoa4Kyo7HzuQU46NByIDz732PYhm2aUAf7TdVUIilE4Ef4c+g1P5du708GiQsjo9iowb
 XIlgoHUAKk8r75f+tdZWAG7WZ1Qy8zjQRaWPJCzjdUVxlshICGCA+JmF15SN3KPODrezMSl0KCo
 egXPSZ9iYrb2n0PyUJ+mUbUcIE2+us1Xh15j/q9ilTUACXmWIJtzJfm/8lArbpPY0tjuIeUsjh3
 MKUNqW7T7AraXcUQAQN+UmMcQ61HhAslwmtk4md6g1utV5vJkVXY303LC10Pwrpt6YnEO9Y1M2u
 /JT9JFnGJ9oPJZI4uKQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 38278ad42f904..ed79b873b463d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

