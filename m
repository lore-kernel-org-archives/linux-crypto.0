Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471194;
	b=fscyB5i4NBlPjf9Y+AecMG778xeSTG23ziSJr+cjpWQI4zf1xwEWW0d7lYfdKk9OuC/E
	 93k99pWOusr0b3KfEanZ9vLhmzRJ91P+6NGXOJzXvSf9j+2qIzHed3jg4qCOm26zpCiYb
	 QKvzgC9g3i6LrOYsuVbfhGIUmQM96HrwvbDlByFBGNI64J/z+CIK3UreIvttpXXTXcEgX
	 WuPiAUutiPHdH9vT/NEHFUnSfXrfTCV0ElMbX30B9n9auiX5IV0m7Jl5CJEZBWSHflSm+
	 dB4t2WsSonf3fcVxgRgi2gEG+wNahHepM2KvP5VBWj0QpvdpOWtSiOL4gKr+CfxgeLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471194;
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
	bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
	b=mB3B528ctHd7vfo8d5z+NZIxtRyv8SojFLgvwbLTn67AoXEKHOGDIkQTCXEh+iNkmpfD
	 dwtqN+QIyR4q3Y2qzQ5Zv5ZVYyuFHnWb+Yl68tWmFVvV3jEMT9LQDV5MGkV+yLUvftsfA
	 +T+AyUEZJ+gePZ8D4PLgi+noJh5UZDKujLgrTkPjoNpEx+j0r/UXSW402vtyfpbj8Ivav
	 48eu00nozkRxApOTTI6aJDxgcDduty2dOiBg9MWNSqnamENldFX70iXWkw28FFjraZLtL
	 G9p7m0W0rYynbCJRgXuaMkwxrQ2U85rf6c9qukXur1oMvbk4dycDdIL+Om/Yjs2ilww==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=k+PK3eNu;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=KtSdFlco;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38EE60A5BDE;
	Thu, 12 Nov 2026 08:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B38EE60A5BDE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=k+PK3eNu;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=KtSdFlco
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5iqWE2297470;
	Thu, 12 Nov 2026 02:13:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHora
	Os=; b=k+PK3eNuMQSuenr7F4OCfqA6pkzcnk58xpp+KKifk+3BcZsUOFsTShCDN
	LwRAZTQLTGcBaoN7NYWor8Nc5dWgBYmrAQPcYVnEPSHmR4CD5KSWkGq6MyzPuYIu
	6RSQraBHmt7LtXBi/uRVQauY07XLWVQf4qocawEP4y8C2l1VnvoTMT+E7YeYXrs0
	pxwOgKO8RuVahL46/pNaCZaJcFspue5Q/tpYvyWN0sFeyjDNo8yf2vSd/IdVuKkq
	DUbjCY59p9Z5b61lCzX/zbFZLeRKJNZdaoQDVtf35Mw6ls0UERvpoIyIz2KgMv/x
	hPG1Pbgc26R5Dncbf44gTATYkxMug==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w3k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:11 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u80WQLEowMYE3aEfcDajcp3+WjpMjgeorCWVEQE3WtS06IMS6ijHmhd3Z+ZAg6KgqrRam6VHkswyQIcZkPbpb6Gn3zI/usT6erXXwTXVNZUyQqmhzSZcX7JQSi1x99MFP/eifSNhJJ4v8fZ3/WA5yZe57lCLBnrmMnrfjbcX4AFDEmz5b5EHrpwA7gj1W3rAwtILOqX7hXV47+Ft6a5qqszOwW2z6XVHn4108Ht20HgQUj6zRBN6mF+d5aDZaynMeyT7wrqO0iMMzca4xkEPsrbbk4PNCrmBnUXe5YUiXhgJyu4n+V4wAB6OLxyfhvmlK5ssUzoKsA21EEgeYAnkBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
 b=A8FWheLfQhB+yJIiYPGzEIKxuKdM0LZEvXb233B3+O4Ziryi7Dso3IZhk4wVLeIr/tenCDt1vFQe5wZeRBJhVficpjga3xiIDOyBiR2xi4Bl2yPsYODRYM4DrxWdbPgcZB1p8uHUbqw0sRJqh30MYGkbtfPEAxY4DEjRAboyM42tNMynFm/EADp2tcYEim01DUEZRz/aMmvTG6ejyHO6XyxRAO2ko+jgBLXdjRZPk1R69dZk6Egd4zpjEpWpqqPUusQ1haGjLptoRZFVBplrRc6I7lOuKeJaOg3hDDUXHw3pY/UmNjkc84yBgA/2+SnjefObzHZotecVYc96+cbiTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r48ZDfMr4bBbLUp/cVEnnzuwtseVrqZk+N3JXHoraOs=;
 b=KtSdFlcoFg8HnBxlUsTvuNS8S43/Xs5J3fK7kI1D2XrMc29N71z1DG7jv2V3mWPEOxI8giUiqq08LberIyx2hrBcts2w4Mk68qR9wz94Vbk0P732n8Ie6eo2DdXHtAvMgvbTywvmAqaXXeAqOGMAfLzYI4PY422usW5VXC+vKlg=
Received: from CH0PR03CA0224.namprd03.prod.outlook.com (2603:10b6:610:e7::19)
 by MW4PR10MB6511.namprd10.prod.outlook.com (2603:10b6:303:225::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 12 Nov
 2026 08:13:08 +0000
Received: from CH2PEPF000166BE.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::9c) by CH0PR03CA0224.outlook.office365.com
 (2603:10b6:610:e7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Thu, 12
 Nov 2026 08:13:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166BE.mail.protection.outlook.com (10.167.252.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:05 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:13:00 -0600
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:13:00 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:13:00 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CwnA472756;
	Thu, 12 Nov 2026 02:12:59 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Thu, 12 Nov 2026 13:42:03 +0530
Message-ID: <20261112081204.1146395-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BE:EE_|MW4PR10MB6511:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ffb1b10-e6a5-4cd1-925c-08df4094c76d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|22082099003|18002099003|10067099003|56012099006|261026121527099003|261009223027099003|261021123027099003|261102123227099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	eGna3eembQhi0ioqMLR1qWZf3A/qwlpx+7bvEhxxMMrY/QeMouRE5BWluTzPDhXRDypyq8XfLrzbh49VC7evVVjvSNbVCsNB3Psy/rgiT50aOHZDWnshddt2oPOzfa4d/+jAdlXncFN6nh0QkfS7SxZpr3LOY1TrNeutKGdD4M57el9pVUGxTA+hUVMkvvWoiq0J3tny8WRo4MDGDgs49ADFt/j3QnexE4w/2LKsKc7ZwyBckk45Nxxl7UhrMf09V8c/K7EL1WsraBMnferBnmMIvHYv8U+WdidJyEF6e1V0eE71UCPwIuAiDH5XA98TwxkOVJrd/9aqG5KJInypqOyjQI46SCDB7MPJV/W8lTNK4fRhTFsj49PGFEYnVsrKAZOq3RZdHsSmHe6mFg1sSFVnuRaZ+mtlie5MwiWd3z6+M3pngCmU/vaamg93du02Fni5kfZEKoUuhG1YlSv11OQkvoBC15xPlZG9/69pVLljng6vazHtI482+sN7ovWceX0X1iN8Txv9qYRHUlyKhVmt+BSagb0FiobCmiYyQd++28+5c+mHAZlSmjctoffyUzGHPRmq1sEO2c7kAI9+O8hyWXhbe8h6/n7TGPHwzkDnz61udlsmonR+hvEqyv0tFZLg+fjUIpaPBQpvLqsL23ZSL7yNJwHWyKNJcNkN3wqiXIrEp1S7gSIZXmTTVJPBXx2sO1cEDSdus6hWok9Kmg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006)(261026121527099003)(261009223027099003)(261021123027099003)(261102123227099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qD3zP84V24dg+rsQYXRJR+vc7bRLz+bI0I+4Bt7VYoqxZcJss6AoayoRFYTCZ45q7kSFutW/JqUO9/jfU8Bm30qY/LGlfSEqa2G5SWkn6Uc/XlUGOHvf5cJr56w4NepUbU0E39a7a0BDscoVpL8NWQM2cffOtNiSaNSasF4+LqsxU/FysNW2DbMta9+bOKT0dDMXlyqyyWBBzsUOm37zFD4J3TRmzVXcjMeilCkOJMZSRUfxndWeGpoqQQXUV3LBzIht6RuFlg6bbSq14LdeFd8dgFhyCe1/oup2H7bvNqR1MAuTm7eD8Xtap9DjCjpZe7O4zcwpfT3IirGZPS55LzBuvORHhBpQZBF4lbJn283CD6cuh3/fUfUcviA3UEAXL7x5UFdyXcMdAoAusD+EoZoYbFMItRuLY4E9L3M8KmUeDcqrAUTymbOc0wg9G71n
X-Exchange-RoutingPolicyChecked:
	qCUWe8MqDwjQrXEHJ40G7Jsn/LZ0gzomPTh3w94+JHS9sKjdRKRm9nLT/c7yhC+f4YPzpazQgOdLQ86tDaiHqC7UpEqohlaRCduh/zTN4HZMZMCzqwt8Xxdr9bDJWojaKPaJgV57kHP0e7Pfh6D2jkiJtA+qXbC+2Jelpj5MIpxiy63P/x9cdzJplYzuDA3fZ3l7xPnLr4FHNKhTCo5c09F4OzBhAxJAsnSPn3oUOybp/TyUU39EKuz5AiJsIeH2A4k+OlLpHHR0IiQTGDm1U4PhK+GMOKPbVZgUoFVE2haPjjiefxDFWNa7eFNYCjQnxePVOIZM3SM9Gq0fz2DQbA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:05.4092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffb1b10-e6a5-4cd1-925c-08df4094c76d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6511
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX17SAJOo3YhoM
 jLWnQhqk6p8Te9UjQJTYqCXcnSK2EEv55yXRZhs1fw/MhVc7c3RJOmFLdbxuKzrbp6fPTC7j3KL
 FSS5SU033i+iJ0W891m6/6HaGXkuuOY=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af57517 cx=c_pps
 a=1g1g+NiJF5nyOkqFb40SOQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=epFSbgyaDKMf97JQNz0A:9
X-Proofpoint-GUID: IJtsQnonOoj_FLEjKpSe0QRo8mvC5lV9
X-Proofpoint-ORIG-GUID: IJtsQnonOoj_FLEjKpSe0QRo8mvC5lV9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX+Crk+26domQX
 nTtF8/kd8CeWFLMTL1sqQP5ctjkietIR357WRw9gLu8tnepdkbCr6UfWzRmnczhsACyjmDR2m1p
 jK/rLI2fnhol1dhuVhwybFFjIfaCUlNK5YUWWQPcHTmAFOOnAIOtw9RFlByvlypzkpetRRDCeGW
 TkQWMtpbfzPLPKtxU5ZEmoY1N8QN1O+dGgm56ZBKqClGWm7DptDY3DkjS/QxKcAOMQaMzh7wBTX
 illHlr2f/8hkkHjkTEYM8OsWZnejX/8QOo6iD2ByhP3w79jiMia+QK3d/nSJwd/9ABZRKsYsw+Q
 TU9aAXd3sj4v9vR6AEoMPhxur1iDcWAtRX90tTKa32ET6AoQIm2MCCmqAkdIr0a69ci3mgR81GX
 5W65SqHoY6m6A5pdgD9J1dAkyqkyK5jIjXTX34VOoO4JIwZFuxSzn2lkPHO4AquW3mYqZomxZ/r
 jxyQTzcCtH4vXFtZZTg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

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

