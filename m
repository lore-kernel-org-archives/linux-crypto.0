Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471197;
	b=AgojW8RcYq4PNmZ0/g4a2R7PIFY0dzYLlES/CJgSOODx1UuyYdZGe7Wqo1MsuHx/K/2d
	 OeDxf1C+bD+BTUAJsovo0k9A6jDRfhiHQKQlSNqTI66FXgCGXIJzbf4T+DdZKGynpGntw
	 rAPQac7yp0pZAxbi2pF2fSjmywIk5gS5Gv9w/9ugMf1EgU7aS/da4CRR+1aiswZjZYSWc
	 4EHMI+YbQGufCXth6gZGI9Rsa5a7YkqR8yr45+CtLIyUHjz0V5CZJj0nXExbvGyUmB5zH
	 VojQaGePc7VDIuaDrTREq61hMnfuFDsu+Kf6BdPt8k4Mif+dsSrWKhXF5elSi9XkoNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471197;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
	b=LtQPf8Ropn+8/kwSqz8JGDAMvARZrC/oIy//O0iIEv0BHR1Aehtr+K9Zt2Mkwl5fOcWV
	 +dT7vgQ4HRxtSTWPOpU3GZ3RGy4/MV2dBRA01NiK4Irv0V0e238ez8L9ZD4qHYqKCGz0w
	 9EUY7jdlk0pCsgcA8XDCZ3Qk09UwafbUizQNp1+vkPrtVTrStKuwmTKLrWkaW7N2+9ElN
	 uVA5NaiMeeNssRxu/+7puUo15NZBHJxeG5fP1MFJGEt99T9CYTK8N0X4Es+FWI+sH9fRa
	 YgNVUBdnkzklGN92jlMxn/+LK51vgflO6UHUFt/F1BiFZ5nNZzH3zURLt3a8K/YRdVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oaE2gx1k;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=COIxXpWK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1460A6F54;
	Thu, 12 Nov 2026 08:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0C1460A6F54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oaE2gx1k;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=COIxXpWK
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5is9A2297511;
	Thu, 12 Nov 2026 02:13:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUO
	Ro=; b=oaE2gx1kjKf+VdDpy5FmqQZ0eSoyB2+zeLpdiCddUx3LsTspDLQTKcA6d
	MxXgo8zi9WHC3NJlViX5QhjjxZ72Cm6r95yZNnUL5BrEx8VAYg8cGQivc7BzHBi+
	qFbOY3UYffFY0FMijliEua7Ld8VW7ZU4jEd2mFhFAxCDOeWnxll6GT2ShnUFh94z
	F0/cu6xMYsbUWNcZ1B3W2OT8eZUyn6Xd32050jOExUuNKErZ5ca8mbtibQ3cGN1V
	23qIhgzRJUoT3gGPmU2Hm07X1jx74OIPF5sNrUuLJ5rgFaTaZ7qWE4f5mQH6mzLa
	uXelpyx3nFrK79Wm5zHtFihkspVfA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w3v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:14 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ilzM8qkjsWogqkX5LRvoZJGdHjB5QCknCuD5IX6MLEsQ/oMbfeiy1x6R4zCA3pBpv9Nktn38SDn5Te+DVSPiGo51sirMfQ5wcRYV5rNKYC072iZdVN5Ft4sUScFLR5ige8ODknXP71akOV44MbdrKNpNetpS2G+DnF7/gbqbAmzN+YFhrkaWVqb3yY6Nv+goP/jhSwY++1N3aHPXlsQMfwSEdTRLpmUqcGHnf4+haZJydKYKYDjdgqQGjm1NXxLaVco5TzcSQm8JohzvxNr0vjadPJy8ZRDsdIiWRID0RXMXNA00sYjXZZoAoozP8I8XrdcLWbNpGN50M788mxITXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
 b=d97poCbg33hXK5buzU3vdZ5/g1s/WWXlba+HzewKfEM9h0zFef7wAScuokMyuPdfD/jSPn2gEj6dzJZboYqqaSS/AnMiIKWfOPUYZnwnnYyJEgXLNn0urYTYaO7saTS/pr8A3fJFypzRe0drlN0RpJVQ+7FZVMcAltUzfan5osop4n4LNi1j582QMCet5gc28GVp6irMufkyS1tQPlSt9K+s8OugL0fspptpi/mN/mRhD+GiRP0G0raqZLcTByaOhVUNgs79W3fqnzIWUYpd+Nt1hS2OliSeDNFF7ei7rwHyOJBtONNUZQE7H8jsqrLO/SlwXV5oGnUHBOrJ7K6S6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
 b=COIxXpWK5MqfkIdU0uvwbv6TXhF1bfLOvn/v+1Zc3hI8cpMfMe5YT6EbJMUAFQjRoYg6DNIfaxvIYGUuG3mjBQm3xt8mDSeO64r7wXAgW9h9pZLs0buQ/H4tju0y+KtcIoU2KWbh7QSoSZ48o62nqu6tATbg79TmAhCbA1A9reI=
Received: from CH5PR04CA0007.namprd04.prod.outlook.com (2603:10b6:610:1f4::7)
 by BLAPR10MB5138.namprd10.prod.outlook.com (2603:10b6:208:322::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 08:13:09 +0000
Received: from CH2PEPF000166C5.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::4) by CH5PR04CA0007.outlook.office365.com
 (2603:10b6:610:1f4::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF000166C5.mail.protection.outlook.com (10.167.244.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:09 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:34 -0600
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:34 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:34 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CWO1472329;
	Thu, 12 Nov 2026 02:12:33 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Thu, 12 Nov 2026 13:41:53 +0530
Message-ID: <20261112081204.1146395-6-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C5:EE_|BLAPR10MB5138:EE_
X-MS-Office365-Filtering-Correlation-Id: 4185c95d-3a70-4357-2bd5-08df4094c996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|6133799003|22082099003|261009223027099003|18002099003|261022115727099003|261022075727099003|261021130227099003|261022113327099003|261022105027099003|261021121427099003|261021135927099003|261026130827099003|261102123227099003|261028144727099003|261026135527099003|261026121527099003|261026140227099003|261021133027099003|261021123027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qkqVLrgz8SiD4FAmPPhlzLtwv9UBhbwyYjRgXa1yQgJsV52I2sYfFiHYYcJLNsdzYEV855VliaOXiuwWeZ2+setVSrXsspIiv0+K0Yvmg8oEREisPPUsAsUdOH/q7xo3k6crqfyZpbO/Xl+rGCRW7wcxy2fTtwS2v0Upun16k8iBqnK58osvk4Q5VkIcuRIey2W0gA6pOC2WS3GyPlSaCGM15donpj3jVYtVuu1elpRpjNKconFtO8RSf3kHw1vXwtFwuoJVTj0roaHMW/4GsKqSvQ4qwfAHIT4OHXQ6B18YXLmyaooneWv7lUWMCOeAoh4DhYCyZK1jd5P4Qd2BYfLoaIPd0HA2BSEDXpCZ+509vdqsv9k6bL0FRh9/S2iLekTT7mLm8oj5NWCBDSGw+1sqtCaVjdUK++ORCFVjX9jpzEy+w+V6emsHAb7z/Z8oLhtPTbJGAlTD3hhGnkVY/x7HKTLisgzuzMrwV/5Un1zvm5NP0j8kJMlOM655IDe0eOrodrddaFkpzjPseygVn9oDdeuGqq8nMgbxd8FPf8m53/kT2sMg543FI8txFfhrlCABn3F1inoWC3w/5Lvm9e0mqs8rDTw8d6NamKJhgF50rwqmwDff6Nk9mGvdDpH1LTzWc1cHqtp3tSsuJhlCJsvj7ItKAgiFBeYHXY+H4FFdY83T9kyZr8SNcA2Vz1vRGDDDTlPd5vnnqhnaxrpWZw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(6133799003)(22082099003)(261009223027099003)(18002099003)(261022115727099003)(261022075727099003)(261021130227099003)(261022113327099003)(261022105027099003)(261021121427099003)(261021135927099003)(261026130827099003)(261102123227099003)(261028144727099003)(261026135527099003)(261026121527099003)(261026140227099003)(261021133027099003)(261021123027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ibV9FHCWLim/m7+IFG6NcyfJ5SqiU/hSmc8xMeTrtzNsogRKuJ/JQV3riWD321ODMC2zvjNeAlA4ey8rfuvkbRo0llMb4aS00u/9ny36OpnA3ncSjKM5TyYQBhoKeFQIKETtoBYST62ljvRWOP2+Q0Pb5G+OgFlMpOV8EWKKkcAgNcunJpUjugpgmQcV9tL9GqFy6qLLw1b0OxRj4n8SilQYOF2ir7thzb6eA3C5X3ZPcjabscshqeW6ETFEDjr8yLQ2/h2KiSQDbFwI4H0PgjP6YWziqSps8HRse03q27T85z4X4r1MAabfgP4vL8xtG9K0k9MAAOidOnfS2nBeCHMr3noYG272rqUz1MyjREm/5yZjRsokghdJ1dLrLoOdpGae1bSBRxrykaDCHXY9kzkj1wIakEX54wZLI0hFYf/VcI4cbTArZHbrtpx2/jIi
X-Exchange-RoutingPolicyChecked:
	JSvnZsjCCHWjYKNIBnpfoXgnjLnqQajcH+vxXdeFChSQh5Nn2pnft42mCWjFJycCjp2ohQS+I8vsIFn7l9pLnHHInrB7rVIGj/ogojoc8t2uz4CYvLAEqXwThcXtHThOoJ4FpbXpctIbozU5PaaWDV5bJDNeK+rDWzB6PNRxEMe+UUmttt8Rxu/PGbX6UKgyjU6n33QWPw94pGBSYjH3U+BrPbE6giW39wYRpc4I/LtjJfqNaAVYUnsneODOpb+/DjiMPcMPtSTqKofLK5AZV6vbphBADJ3phUkfuZl5HWHKjs4tXz1uMRf2CI3p1OPcU8ztvl1ssG8ED31X0UpFog==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:09.0266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4185c95d-3a70-4357-2bd5-08df4094c996
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5138
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX2taE4FkiSiMI
 /ZQX7vB6H4JkLa1H308qZvKG6DFhgx/ycjpBWLx9mTZyjq5381ZMW7LDx60gIEuEEm57e6ZZzHJ
 xUjfUpX58+PonPzhW3W2zQkEf6ahmuw=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af5751a cx=c_pps
 a=HD3DV6xNHsutM5VcLnEsTw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=J8wK4BBRFcl5aWuvIT0A:9
X-Proofpoint-GUID: IzeVAhrzCAO-1x9iG6FzHqgiOTsvyUCu
X-Proofpoint-ORIG-GUID: IzeVAhrzCAO-1x9iG6FzHqgiOTsvyUCu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXzKCCWWFzzFnW
 va1fq95lNGNvxjS2yVMn517U9+8LUG7iTFD3zqRJyjoPt5gJ8gnwIB+s9YjVYnofFP5aH3Rc5sm
 NwERlMQycNXmjg9TNQbP6txht0NPqJkC3de8Ve79tFozP972q4jpi7eh/Jb40UBBgFjBKExpxEL
 4hrESlmdnaV4ECQ9kHw05HXe+sNG7RMBfLwk9ZaF8BqFWrF1tboC7FOP8dNWEucRIa0BwXxsCPy
 gGkg4AsIrlt7RrnVkAOZO0rtdWMXHRdchlIAfNu7Rzpkj+70vGygzmhjNvWNK/g1N+Dltinf8Zg
 LI+JoDFC7KOer82TgPMcGJ9wo1eO+Hi/8kIlcn3CWaFgrn9DCztN8DSmZEBxUd3Ziwzf0KZtsrW
 iZZbVWOFvQHaMUwRdJfbylS4Prd1W5On2hbPGkvMTjUn73+U2EpTMzmC7j0vgLYvB7RIBDB6W7U
 wjN+JNgxmPlVO6TbdCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

AES functions were using src and dst scatterlists directly provided by
the request. This is problematic as it is not guaranteed that the input
scatterlist is exactly the length reqired. This problem was seen in
IPSec use case when the kernel provides the scatterlist which contains
space for plaintext/ciphertext and TAG.

The problem comes when the scatterlist is mapped and sent via DMA. The
K3 UDMA sends/waits for the amount of data equal to the length of
scatterlist mapped. So when the last mapped nent contains some extra
length, the DMA keeps waiting for the extra data and eventually times
out and crashes.

Mitigate this by copying the nents to a local scatterlist, copying only
exactly cryptlen of data. Note that this does not copy the whole data,
but rather only the scatterlist mapping. So it is not as penalising on
performance.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 147 +++++++++++++++------------------
 1 file changed, 68 insertions(+), 79 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 75361afa1b3f3..b801f9fdcb87b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -108,20 +108,6 @@ enum aes_ctrl_mode_masks {
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->dev = dthe_get_dev();
-	if (!ctx->dev)
-		return -ENODEV;
-
-	ctx->keylen = 0;
-	ctx->skcipher_fb = NULL;
-
-	return 0;
-}
-
-static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
@@ -147,8 +133,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (ctx->skcipher_fb)
-		crypto_free_sync_skcipher(ctx->skcipher_fb);
+	crypto_free_sync_skcipher(ctx->skcipher_fb);
 	dthe_put_dev(ctx->dev);
 }
 
@@ -156,19 +141,24 @@ static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
-		return -EINVAL;
-
 	ctx->keylen = keylen;
 	memcpy(ctx->key, key, keylen);
 
-	return 0;
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
 
 static int dthe_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_ECB;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -178,6 +168,9 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_CBC;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -186,24 +179,19 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret = dthe_aes_setkey(tfm, key, keylen);
 
-	if (ret)
-		return ret;
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_CTR;
 
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
-
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	return dthe_aes_setkey(tfm, key, keylen);
 }
 
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != 2 * AES_KEYSIZE_128 &&
 	    keylen != 2 * AES_KEYSIZE_192 &&
@@ -211,15 +199,12 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_XTS;
-	ctx->keylen = keylen / 2;
-	memcpy(ctx->key, key, keylen);
-
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
+	ret = dthe_aes_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
 
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	ctx->keylen = keylen / 2;
+	return 0;
 }
 
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
@@ -342,8 +327,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
+	unsigned int pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
+	struct scatterlist *sg;
 
 	int src_nents = sg_nents_for_len(src, len);
 	int dst_nents = sg_nents_for_len(dst, len);
@@ -386,38 +373,38 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	 * We need to handle the padding in the driver.
 	 */
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
-		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
-		u8 *pad_buf = rctx->padding;
-		struct scatterlist *sg;
-
-		len += pad_size;
+		pad_len = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		len += pad_len;
 		src_nents++;
 		dst_nents++;
+	}
 
-		src = kmalloc_objs(*src, src_nents, GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_objs(*src, src_nents, GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_objs(*dst, dst_nents, GFP_ATOMIC);
-			if (!dst) {
-				ret = -ENOMEM;
-				goto aes_ctr_dst_alloc_err;
-			}
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, req->cryptlen);
+	if (pad_len > 0) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, rctx->padding, pad_len);
+	}
 
-			sg_init_table(dst, dst_nents);
-			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-			sg_set_buf(sg, pad_buf, pad_size);
-		} else {
-			dst = src;
+	if (diff_dst) {
+		dst = kmalloc_objs(*dst, dst_nents, GFP_ATOMIC);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto aes_dst_alloc_err;
 		}
+
+		sg_init_table(dst, dst_nents);
+		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+		if (pad_len > 0)
+			sg_set_buf(sg, rctx->padding, pad_len);
+	} else {
+		dst = src;
 	}
 
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
@@ -504,19 +491,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
 		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		if (diff_dst)
-			kfree(dst);
-aes_ctr_dst_alloc_err:
-		kfree(src);
-aes_ctr_src_alloc_err:
-		/*
-		 * Fallback to software if ENOMEM
-		 */
-		if (ret == -ENOMEM)
-			ret = dthe_aes_do_fallback(req);
-	}
+	if (diff_dst)
+		kfree(dst);
+
+aes_dst_alloc_err:
+	kfree(src);
+aes_src_alloc_err:
+	/*
+	 * Fallback to software if ENOMEM
+	 */
+	if (ret == -ENOMEM)
+		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
@@ -1254,7 +1241,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1278,7 +1266,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1288,7 +1277,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ctr_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
@@ -1313,7 +1302,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CTR AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
-- 
2.34.1

