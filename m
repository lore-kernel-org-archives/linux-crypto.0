Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063421;
	b=38eizOgpDDxvT2mxVKSy4nHCyQUcKtid2dbcO58lnKCa6y+gDtkjgqDnBmSvw4vAqWrL
	 Geuem9o854GX5IlKRRhoItQ4cBv3/FtIHyjIPgFOhSu7Aduf9hrrlZ9MejzFEdCm7akzq
	 8Lf4IH6IYoh0GNq3uF9eXds65wcWFaQaN+dbE9xl62N6uGy6bJzZv2pJkt/SbFZY+IMrG
	 M4xUrohiuH3Lrw7DsChCvkmgMamF3RwOJr74Zpd9ftwvqqm0NIo5ikX65BqpuRlqaYDIL
	 zzAYssxe1l9F7v0p2PQpA7/HpaCJT+wNXO1/EONIo0a0kNPkBrA6davgZ7qkCzD+MXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063421;
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
	bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
	b=YXQhefOvfo8lev//VuZeaGP5kOYII5JBnXgxDAXtksSl3vwyDjb0PM7MShRsYEwjcHY/
	 xQN3g457XgXmZGa8YuPv76ceqAengtlBV+8RMa6BitmeBBteDxdLQ2vIAtfNtAn8vVKKT
	 +sOveOZL7Ln8jHMmsIw2buyMeXncAjKIr6d2Uh5RhoNRtmc4XZhUnYVOlXeFaCfmUOa8T
	 ekvr9dt/mr4o3GOBdoq6HZQiWopqdOCxnIph/YGgLDLkFe72iFTUsIRF3VTtrHdqk26tz
	 00slJ+GSqC5Uk/HIPfsqXwBrgKQEL1hbg3ooAb8n9bhUmc0q8W5OKFB9iXKSTd/7RQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UX1S3qqK;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=WouaSfVb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770C8606D80B;
	Sat,  7 Nov 2026 14:57:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 770C8606D80B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UX1S3qqK;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=WouaSfVb
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwIOJ2005258;
	Sat, 7 Nov 2026 08:56:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=UX1S3qqKqAd0VqC4kvbPBtgAcwkAHldFkinNG6zMPlxU6SM9Qzph3+tS6
	xM+pIj60Pfc0rupJabmHKAMqsUEQAOlz9Yr2RGzMiLaPWtLemCFn3egP6jA5p5pO
	AXdtKLL+TxdIdXAT7qpQy212WrU78iE4ceE3TNK+NS0a6kjg+WxY80PYObetKY5R
	KdZeWwANdQpSTqrQjPzShTid/KjLjZYmJl/W7ahMrdtB71SfMjFCNAFQPoMEIW1z
	PoFqQ0GYbQNrqIRCmluijjsFlAuUiVzRBg6SeIEqNMxE19GZdHEHv7BcTmGn3+8r
	nIrr9RZvRGlX81aVVzxRqGkrVL1ug==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011043.outbound.protection.outlook.com [52.101.57.43])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3pw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:56:48 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vBLe8vEySPcCrCLzBuojVeZvBCgNqvtvMX/T0OaBpESbNgm5agfJqyrKFcVAxMVSYKo9+UKH09ZY36i35NJQL6qle2HVy0yUs/Wq4PKS0wxtiivB4Grc5IzYQT68Lb05vAC4bd8SLaJeHFuH0QBAM1SeBfTIblx8ITD7nyIyq18FZpJWj/BbsKTEFGKZBIcCmFMlWT6l8cPHhFDMECX5AVKxQ9W8h46sbaFIpCaLP8PFOJpKdsrK3+EpkmKsrwuT09perqkB/CylPymLP01bSFnH+K5UfRG8LTvL5gNgIW0i3nqwyC+yZR+L1KYEXpDEMqSKkzIPtMCWogFxObBuWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=XUuRMmko8pcH8cky0UazJC21qxEgd5F0l9DZQBpb4Q34BVBi9r2TPuWI6EfKmXSXBw2pe9ZbwMmZPfcc4Wh0ighq5RZm+ENnNTuyX0tx8Kge8uYUwk5cHw6PTw5Kh+6jv34KG4hulKMUxEd5RsJP8x96pUSn9NbvABJ5RJV2tShQQiUp7cy/4V17NyBq8OMbMsX8uKFT36n1cA+lK13Zn/sSbP/qTrZ15Aeo1j0mvtpv6liH+bvPvc+I5PcCg+81YgBGY/muOJJKCAE3k6L2Wh3OlLhXrO727EMz9R4s4Cz9jVIqKk3G7G1EThQXTfMRCGZrYutj0dXifRx7pTbRlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=WouaSfVbtKRFPipHyZ/RCEiUVidGyu2uauEdxwiu+L+blI/0NI+R2z7xUo8bT8dDKa7XEZMrL2BiLgu7/rOfHg1bEexnkIE5bWZ0vnLnkvS1ymw3LDhM/rsqOdSvpa1tHCM9G6t/edxZHH8uIUAe8SZN9TU2dq7KkLoseg9IioA=
Received: from BN9PR03CA0774.namprd03.prod.outlook.com (2603:10b6:408:13a::29)
 by MW4PR10MB5775.namprd10.prod.outlook.com (2603:10b6:303:18f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 14:56:44 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:13a:cafe::7f) by BN9PR03CA0774.outlook.office365.com
 (2603:10b6:408:13a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:56:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:56:42 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:42 -0600
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:42 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:42 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Eue8U190494;
	Sat, 7 Nov 2026 08:56:41 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Sat, 7 Nov 2026 20:26:04 +0530
Message-ID: <20261107145618.2349562-2-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|MW4PR10MB5775:EE_
X-MS-Office365-Filtering-Correlation-Id: 45838f6f-e12c-4a40-dbad-08df3cdf55e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|23010399003|22082099003|10067099003|18002099003|13003099007|261028144727099003|56012099006|261021121427099003|261102123227099003|261021123027099003|261026140227099003|261009223027099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	M/ZwQGqiXUJtsmQFfxiILMz6GhdCmnEgh1Lhn8Su93aRwyIDJHOSGgPq3Az1pVroEVJ7V8/Wj1ZDTbWVWzUpE90gmN37zZ3U+vzekywQqQQzyMkK21otVlWkDZUmTb8Bsom5Xau9I4rmv9ENUpd5mX2A18yTsCrbKH4nGwR1wOxpE5OViem8ckbVrc5NUCYVDejj1Gxk64QNZ411WDmXVO6VjL0rZdV9woDX8PXsbyom726A+VMOfGj0t6Dk+kPHsVWu7uQ79DzpQROnhE5kIhjz64h02dVjwU1D5TqnGuywuMJFd+x5EEKo8kYzd2x/CPbwkiEC+KT41w/zlpPhS5ePqzsxnxGVPSBR0dmW43WF6PNzc6aIllndjNpdYSGuDoj3kfJnrCob0mMW0t6n6ATFG74ZWbbBWZb3tBs8ug0rttR+V4QqDKVL0AmW0Sx6uLNFavxBrlK/KnOskcw2HDlcRAO/Dhe4TqgtDemzPWDd5STsbGNSrXo1A6T5k2Y41XkdHNkH7AWEtaoDsRIkqG5tPdLRd4HmPTwyiLZGbr7mkUnWKNyVtddIgB9hlHmm0Dh/XE4oMe+2kjjw9KPSSjtqvfltr1G+pNniseSVTmSt5CNcEdHhsvts8s7V4cpE4BQSZXdnnQlAIcVdghMs/A==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(22082099003)(10067099003)(18002099003)(13003099007)(261028144727099003)(56012099006)(261021121427099003)(261102123227099003)(261021123027099003)(261026140227099003)(261009223027099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qs5GOSWpUgQWDcnOhYJmR5bXt3J5ko93m2rN0T6sNsDxJsoz8oUboxfELSdTr3cZLKcaQSUQnUwKiHGJ3eS9flcaeTzc2daGAjtjYm157YHeH5utrq3hnjlz0Y0X9uJ8/Z5UKOEBamN38BQkzgqoFxbuw35rmAczwdVTyaEtDhPOZ7GsOLUtqUUqbn8Jug+o1G7b4YXApru4YVS65CMIunvi1tZRVwk4dH9/L3RftMESWX6NuYVwPWK9O0WJYNLWzfrm/YZu5tMJFz8+vjeW988datnumPtuRyZ3P/wrS14d3xwjbllF8b3q5d+rXaWd8K1WFl43Iy62qFhEVg37UJykzc5cSb5Qmkikgv0gxNex/pduD+XBC+pif3FSkxhl/Qsmnl+XXHQmrtDxJ80/RrYncWU6z8A1Hah10kCA9FoiOjBTZJS3KejtRvmwY8rc
X-Exchange-RoutingPolicyChecked:
	VwZVFnX15ktq02stq9IIh9cj349YXVX/eGcLUlu/m2BuaZWQFJ0W/Wbx22ARpZppGt0cJ0vYaFaifOOdK3E5bqUDJSvR8euz65uyoEIeb933KrNfp6fbaib4JQJbqpS9Ek2jEhW6dMy1vH0meQ+DAlQ08jGbLAYF98e4c7foqTsrlDYn52wJck9dePQFDVotV29cjJbTxMU/XpdtH5KoDdfWY9TkN4ooZCw2n0kCcYqkmQTsoKijlNewVrna2eB1ZQ9w00gwZAXCm4lpdLOHplx7sIYWrfXj2/cJP6EIvMNYyFETVDcXMXA7iWyUH97JYb/FJXtkJw06Ko2gd4cHQA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:56:42.5044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45838f6f-e12c-4a40-dbad-08df3cdf55e2
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5775
X-Proofpoint-GUID: o7QjY-r57rqQ8rHNiX3M9E_yvwpFofpF
X-Proofpoint-ORIG-GUID: o7QjY-r57rqQ8rHNiX3M9E_yvwpFofpF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX323lbhYYDqZd
 vGC2duycovbnjc4Z6SeduYHhpgwxtCf2IZlR7Qf46Sj3Pt+qzTermqkDhjZqvH7bbmppBt2KCDL
 XtaD21zcBXUfSZufUJ3AcPZ88VSZpyg=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3c30 cx=c_pps
 a=OVDEU4yRZFO0l3mlJ/t01g==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX1L5Xc5dE9+UU
 vu/xOjw1wEZAKQm5vBjgREhbjGOTyn0ciYWUgTW9caVlyNORN+Ef6RMvmfrunph3reR9ENgsFFh
 QfVcdQeKUbiWjSdcD5sqK3T/bshBixOdHgdurJz/CDyirmc36rN+F6MxXcwPbrEP3Fl4W8sKogy
 Yb7Ja4n4rRxJF139JAXvSKJlugP9Auy4o7si8qz33Ud8A+6i4a1+lNx6rImuY7CYX/uXzrLw959
 Kb22YQTzYrAU9hscmI1MSnwaIXLyrg2AVANwYMKZJ5iyjV6WhB+d2By34Bi1sPdqhCpmD4S8SeB
 oSpYqM74P6LWBQkOw9hcJ3IoiQ/1yxSKbL2ot0lkMWKOkNDRdKZhoUIuNSj99voAirVD5LZ0DWL
 hUjNVkebUbc4HSqDDBMOkUtQctZ/d5V39heR8gr/1RawpAvrjOIGeD3qQevJXlkbArlW+2dZdOr
 IuxWxE0K/vE5OvTGOXQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

