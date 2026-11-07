Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063444;
	b=3eB3eZ3GSE0YNiRqMfX53Hgyf6utRzp4H44mJughc3+13JzWKEcPo78tjXbpeNpygiCB
	 ddc33sFQGFXsXqqpUvYH19AOn+vJyoRXl7Wuu7vD41F8AhNVNTg8OTaajLIjDjff9yuKm
	 xhMcCY2Sr5Njmm7SRBFWN1Ox/m1t0QVTkd/kukaq5bCNDN2n3pTszj1V6E4cgGAhMSHEC
	 f/4N9WVOhhBBNeEb3BkFBImoLI+5qjuhK25+3mSzVAJnSY6F2+7+zOHCPsVDFKbGheQUI
	 iPXnsvuOw38WPlNcxPu+xuHbqkHZl12Z8JscD5d29gFC47AJvvZRcC+yz6tJPPbS8lA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063444;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
	b=Bsqr7wdEx6OFLgh7xeEcBsCR0B2B+it5M5YFY2N511uDE7hLfRMFWd6m0axtvl3R5U8k
	 bdT1w+pGz6GioTcaacmMoof1pjSWacdofCd+7ASadeRorXAH4zlk7F/lixKfhouErEvf5
	 eBvVYwesbziSZwLXu3CEDrVN1VIgxIH1o88SiZy4LGBtTpZnZSzyvA4Qo4rtbSk7bVCG1
	 Vw9DLqz2susziRIiFQndnCLPWX9BzFimjebEb9neim/uxL0yYtkQmSz6kH8wNOUgzbm8c
	 GQBjpDzxGjo6ftsebtiZrLgE14QATlR9dC34eccBTgAoL2BzEEaHX3JC1Eu1xxqZS8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=EwgStnJL;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=koMMrHvF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516760A260C;
	Sat,  7 Nov 2026 14:57:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8516760A260C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=EwgStnJL;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=koMMrHvF
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bw50d3544217;
	Sat, 7 Nov 2026 08:57:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5t
	zg=; b=EwgStnJLm7yrVAhgAsih0bkzQE1tCe69xX8eDADKA5bkgoYyFpKcsSH8h
	FG4BJQdhgtdOToT3Cae7L3wkFtho13xCyJN2PyVvDyPejXTqbUTiIloRRGl6Rajr
	qhu/6/uLhtvgIa26vkbUnrxZfa8pzqs73vTjxBhP5uERgKmwDoCRqcYA29L5i8o8
	F5gAm37LaIuXuOeM84Mt1Mf8us2wBawFZEilZJvgL2bPMrX0zcQSOjDIaePCQEKX
	6+vqs5wwNKaVqBAuVCJVRTJ2K0BNOdXuBJcQvwhDlGBg/KXfTUWJYVyrbWkOgfH7
	U0E78dKISBNxdQVzzUYgDoxJGl0Kw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010037.outbound.protection.outlook.com [40.93.198.37])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmhpn4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:21 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R28S6Gdzr/nXfi1g7qRcFH2ibUKbJJMt+FfsroEp6iyu4CbYL3B2YzMkNSTzOB7zxOZPfOOPVVDgEfUkvDVYIHidSWfzuHeZH0jjIUfZXeSfOqsYd+yN0HMiM0vYnDkw+YzdV+9eKsMJtZtMzFGq7cwDA27FWoatYjSsk+Efu1sFVn/E/pQdj2eIGDFfeEubUdJmO8fgbPlKudS620YZci9UwELNGFygsgVtZ9IW63rxAz4/bw02Qpl/ujVmPCgQGQMIA6H7D3xngzs0hqUOFcL8kajM/+B/JAKm9Rzvm5R/cBwjGIjih+lzOWSc84Z2iGpTpAjsPbu2hM+4Zxm7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=NwvacezNoFrKaGudSNmQIfyuzlMztlpcHyGztG10lG30dQ/dRgXU28Qlc6MiObiJWI4taq6Iz/qtMr3CcKFq+MOxFTRazzqif0lbizypX1WPB+CPdrmvBgjQrgC7tv/YwrDrCLvt27JH2E0F8wSRadz/23gzYJHVBI7FgxPj7bVE7sXxiBQ0lKM2vdHAtgFCyzRV+OZPGzvP457PNZeO/dae3iG14Kqwk0cW3bTFbaWqtwkF3Lcv1iHbOyZoRK+7MSe/fizYPFMZZJpX2lP7SaWTo+7eq24xqh5Vn7cceyZ8N1aaFbrQk5Khc/WFvSMORjaHJwQFvNiRd3J0zBSgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=koMMrHvFiOAo2i5uQ+6MJsxiGKkOcp0eMyzQquYDXVqvPsC2HHwOhOW39oNYcs2CIy+SqVidE58CRE7THbF1w+EcWillWTYl/LPGQIcv07hv40Zuy7Mjdo38XZiWBcAt9NrLl5HzZ2AAKWpgdyZAK8qP4Lec9VEBHxYz7M3jaTg=
Received: from BY3PR05CA0052.namprd05.prod.outlook.com (2603:10b6:a03:39b::27)
 by DM4PR10MB7401.namprd10.prod.outlook.com (2603:10b6:8:188::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Sat, 7 Nov 2026
 14:57:17 +0000
Received: from PH4PEPF0000B60C.namprd21.prod.outlook.com
 (2603:10b6:a03:39b:cafe::7) by BY3PR05CA0052.outlook.office365.com
 (2603:10b6:a03:39b::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Sat, 7
 Nov 2026 14:57:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 PH4PEPF0000B60C.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:57:15 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:47 -0600
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:47 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:47 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EujhT190565;
	Sat, 7 Nov 2026 08:56:46 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Sat, 7 Nov 2026 20:26:06 +0530
Message-ID: <20261107145618.2349562-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60C:EE_|DM4PR10MB7401:EE_
X-MS-Office365-Filtering-Correlation-Id: ca0b590e-24c7-481a-eee6-08df3cdf6969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|261102123227099003|261022105027099003|56012099006|261021121427099003|261026140227099003|261009223027099003|261021123027099003|261028144727099003|6133799003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iTVC1hS2jJSIhVwclEHRnnUUJBy2GbyqzyR8kCwy2AgyzHZSRBPbbdZxKc5P7H8gGiH/9P0TPgIrHrnywhiWGTchTU+9Gj6/Kx4LWCUy5YSQfC3vCShaUEIi8CtjX+ZfU6Ha+AA+QbfjVKzNSZwDwBh3RmUtz2ofZAtR4zD5umpfztowiAh29a0na5ZCEM2kXRwnSXR2nU7KYB5dy2JyKavRoI/OzvVJ7KN9stYm6rSRoApI2lmY3C3h8hH5nPaiOCbMLgmn3zQcZA8S8+N9adpub7mFSDbJM+bgJXGAB9B1pf/aqcWt2TMabATsEvkWlM9NQXkpMQhkccZWK+1vKJYIBkCsjJJiSW52Gzdc/LV1NnapUnQNyp9yxGatrfwpMaVu+4S9z1Yh7IAz9BZfldgSzPs/n9qCA/QKprJI3mwlmklgPy8QZTPFiqr22AZvQ6L3Chh0+hqHj3Od/Ijo/E6JdYmdpQ1Qg2JXAfUFnHSC1PGADAtY+/PhylorVA3z4SGK4ymmMQQ4QHhCrLjW6ITEOSbgkpCumVdi6xnHYQFxMjNuLYgi+Cr5/1IUsA6P+Ez+VUe+1FGN3kiLF38xqL6BVqe7oJvVrTEjwmT7FXKEvl/jVHtVK7oavl29bbXrK6ItJopsoI+qH6lnoKbo66M2pQQkvBa2ERvaJO2DREkvCOxdBU41wt9kRmJm4YCGA/PINyUqGK2HP86V26xjqw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(261102123227099003)(261022105027099003)(56012099006)(261021121427099003)(261026140227099003)(261009223027099003)(261021123027099003)(261028144727099003)(6133799003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ykzWnq4Nn7tAmgcRJ6GtHr8rg09Nqz+TNjonl22Req12TLm3cOCIuI64RfYrVLyVo+vEhQlZag69cWk746Z7bqZGM9xf66nmTy2I1jHSHNkq39MdGvcyF5l4V9o0yyj8CbVhlOmWpaoY/f3b7xgAMjRzsJWonVAmDiYfbumNR8Sqbq9NfAR92mdMycsNz6mW/Oer7FM897qjV7xAqJAJ6+ZWlc/+e5XGykH1PpKfEo/ravh2aV59rSxmVTg2+bUhBORh8p6XZw60hnp941tMKY294LNMtxcKwklFaZ4slAd64LWKlbWcyK4ONsyKEpAHvgmLaypCBHSFKpki5JkwUPoVa9RScHdH6WWDBtCNZ/0eVom+ZrAjH6Z51rI4We+fGRDij9PJVCBWBPtHcIHfSBM0zX0me4TCnMxmYQJGArm5dgXFhRJXv82XVW6zqkv9
X-Exchange-RoutingPolicyChecked:
	o7YkJr0Y3c11OidK5po5KQpHmrXPQYp9RARUMVNbG1uIzQ+JmdI/SE6V3/UkaVXtzZJNi89mhzkAAkQaqfBLVB6/0lHLRB9rfWhiBLm06jlI6G+kafrqmfulk5kd9gcyHYMA2xyAhB8pA8wD7ryU8uYLtp9tiBj4JLP90+hZQg4+5opuPrjyJ+YtHFcOp5WXo7M7nY2Lji+vw61w+JS5Qh9Plse0o/bqwCoJzuiYoLymA396MvJvPYG+fPSG9P5ivH3O+8AN8SF5KSXmKFNtNcO3oZ630oPReaDYoTt9l0RzXnBOsaJ/6Mgb+1FrN1muA4CuWCivxXROnZEzfFrYug==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:15.2797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca0b590e-24c7-481a-eee6-08df3cdf6969
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7401
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef3c51 cx=c_pps
 a=HozCXiP24e1PxqS5ATOdRg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX9zSHWt1jh1zU
 6s2deZ3DqJ36n0IQ96bnzE6RBLBe4GAT5wUPQ5mblJ/8N9Xv3BH1Caw/8rFIU1lLFn73/1GfNWC
 wIi22lB+TYbWNoc+LaOOtmuxKKzwFlbj9DlbWBMLVa3ImV0gRrKAgkPt49eGmejvtAXhZ1hfS2j
 KEKoGeR6J1gMMf4Iub/p+rOs4X/9KW/TAsXtTWvcM6PTtXQxMHTNaD7E4ojB8UHum3LWnvUz7E5
 FvZUGmjwe+tILuOLW1jV4zhBACHI6saIPjxeO/l7ZrypIivMJe+80OjkwQncg8i8gu2mZytqgI8
 orgGix5tXwUztnWptkOYugpFTlUxy38A2ME5QZH2uPPcokH8nFEKZbAw+rmPsAUIbziQPx4cGts
 iGBz0iiKi28lfPaj9rQfcOgnb0mm8Mk/HWZKsiSxhF7QWWgS4iizYd/i57fxrJSPKpJMR+TBX9z
 ne8mEozy73axi5PUnTg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX/6qpPe2lGdtX
 srhNK2RqakpcueRNJO0B5QJ+R8cTgyeBGVs0Nx5DcTEfjiru2L4ClHyjNUw0xexE0SrXoc5Z/8q
 2AvtZCOlazn0bLttaFqrl2sXVVfWDZM=
X-Proofpoint-ORIG-GUID: K4LvZePKGcNdg3_czrsnbZPDpV4o_Xaz
X-Proofpoint-GUID: K4LvZePKGcNdg3_czrsnbZPDpV4o_Xaz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a7d3831f2f9cb..911e6bbe4d241 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -49,7 +49,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -58,7 +58,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

