Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063426;
	b=5iMwvvCasDM9+zxJlgxB5smAZw5ODt8s7E8s2P3liBz6xMus0qVDQm/sFPXMWvxQ9klu
	 6o8HeJLH5YIh16Q9Zo/+j6OHEDglN37lbEH6GzVXnxfgHnpIC4J0u5rXuDNsgz3jIpJzf
	 c6s3HnE9tLyA89Uswcmy3Mylu8KvgBAPIw0gTf697cWRLCRljksJVfde10UElFPi67R6i
	 ip71I6hVyyx2/GXgQRDBCRnU0l8VzcssOA5D6P7MgCQE8qHUbGfuCXlLZcHpfgBbstrZz
	 O1FZNM6oxsXKf/mDfdF+jxTGiWLssWY6edeX1PrBdEHhhTQeSZm8VedQ0pzaOZQurPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063426;
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
	bh=yLU0xKUT5KLuROIBRaBVF6kDiqov2C6ASWAPLVZDS/c=;
	b=VXKWaoVW2WJazy7uWd2eV3du5ePlkNydaLxRvfm3va1KmAHYQPVnd33URWoY5dTSoVbl
	 FJWT6DO4HJp14HGho+wGehdIjelv5QcTXPdMa25pi88dQVnwdIo1278EnpsU+J98mGZuM
	 WLC7DvqEERdXNYsSDPaKzk4AJgT/2Fe5k9l8X7wJk3z38ONdq5J1fNW+zp8PcSiawcQB0
	 kllA55ZjEazylux3RpW3gTU0b9cNJOGPokzyE0X8tGpvHrhIjED+Ypn78srEnyhO6mNCj
	 1Y6ggYAKQLEvQA7XE4jepdQ6PlO9/qhHdkRtCuPQMMFMGtCHsyCVDCrPSG6c4eYjInA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=AqNq8kBc;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=IvXBV+cj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15C2606D811;
	Sat,  7 Nov 2026 14:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C15C2606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=AqNq8kBc;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=IvXBV+cj
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwRSd2005485;
	Sat, 7 Nov 2026 08:57:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=yLU0xKUT5KLuROIBRaBVF6kDiqov2C6ASWAPLVZDS
	/c=; b=AqNq8kBcRy8JMqvRWzjAwca/fiFdtykcyj90wRFAp7JBXqaV8x4OjGRKC
	7qbEANssx8oHnn1YR4PZi2Nzjk1pmiAO0i3IGEJdAdzhwOswnVlbx0OFWX7M8BTP
	+t/trCZexPs3pI5o37TktLuYKS2gR3qbUIrdJKyFfRXy38D8vrOCDJGqgUWd/l/p
	xN9d+4SRafZai633oHiAB5FkwEAo1Qvls3GoNL45x0OSbOAkSBk8Ji/pscYOUGyH
	MIHrTgbe4qGvLYX/FtM2HHJxagzCI0XNnPJa39lYFyJX2lNFQagtGFhvLw1+pqDL
	s2C5iKylDk7zLDbTE6hLz96D4ebkg==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3qy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:02 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTrmewQjMhFhGhp1ZVHCoqB9TsSoLJUVds50jqzgUOrRy9nOiuRXH6ppj6bTxxNfWBDGP75TKVqotfK7sj5MdRTRnOKxY3egB/NgNcYUgI1Uq6lCt9MHZE4oCJBWs8P7EiHNhpr/LW40genl3nTQfcUF49OjWPVPuKvhj4jMx2TpbWSIhhrlmqOXQ+TNTo9wt38iTkd1N3arobkr7bghma/zVnjOL2zAeIKmxaiD1t/+s20gKW3VfJs1LJU5KjVFjFmBK6OBSts+lCmD2HA/OTT4f3AmCSVwlWXc+uK19cTcIKvtKaXZMd1RlAhOzEPM9zHgZ/3lSHS9UiXRiv8veA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLU0xKUT5KLuROIBRaBVF6kDiqov2C6ASWAPLVZDS/c=;
 b=rkPUyVb99DJ7GaUrS/Dbdb86h/cGB6fsiBqTLNL1F0w6PdViB7h5VTITAcedjb56TYcEwT/x4mjeHY2BsYjHYJ6r8L6kOWgQ+Tv9uboITu8CZrWeLywKutTZy6DSQY+XNvCCSQEnTF6ozNimPbhs7GUdMwoKMhxnFJ3lbVS+UY+WiGGZMIx1edsgYijX+DDLL6xt77554y6yYgrP6V71HkIjxDFGlWjvRLCVdaI6Kqr+V6ER2sNKKR22FhJ2dBHh8Ow/C6d8QfzYbyRI3dwInmn3ocg/gWwY599kwUswosg28rG2u4CbzZcv5hN0bIpC6GFZwAHI3VfL49met/jTpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLU0xKUT5KLuROIBRaBVF6kDiqov2C6ASWAPLVZDS/c=;
 b=IvXBV+cjQPtITUGlN0yGWL0SJq+y2zFssX6/IoXnhvaPfysM8ufnNTFs8DYKANFEXCaVVsbNd4fwmOqjnhIP+P8t6Meg3AdB1uOW9AGS8J0mnmqQJGuITLB6iEXo8TSWz4IG9Q1xlPulVjVgTvhKniuN2lyx9X2nxIGf2v1acRk=
Received: from BN9PR03CA0047.namprd03.prod.outlook.com (2603:10b6:408:fb::22)
 by SJ0PR10MB6349.namprd10.prod.outlook.com (2603:10b6:a03:477::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Sat, 7 Nov 2026
 14:56:56 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::72) by BN9PR03CA0047.outlook.office365.com
 (2603:10b6:408:fb::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:56:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:56:56 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:53 -0600
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:53 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:52 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EupWN3373686;
	Sat, 7 Nov 2026 08:56:52 -0600
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
Subject: [PATCH v11 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Sat, 7 Nov 2026 20:26:08 +0530
Message-ID: <20261107145618.2349562-6-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|SJ0PR10MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: d3a521af-205a-4ec1-65df-08df3cdf5dfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|6133799003|10067099003|22082099003|18002099003|261022115727099003|261022105027099003|261021121427099003|56012099006|261021130227099003|261021123027099003|261022075727099003|261026135527099003|261028144727099003|261026130827099003|261102123227099003|261026140227099003|261009223027099003|261021135927099003|261021133027099003|261026121527099003|261022113327099003;
X-Microsoft-Antispam-Message-Info:
	s+1hW+BjkdFvcQ44OQoQms4vlqmKCkV7S0c45q+n1UJOVh0UYxcowIp8IWpTiwiv9TqFizyRDH74u+D6Z8ZwQpFXnTj2ZjAY85DNAZ9plrYEmm3P1acAh4YM75/rJs5yvyGPsyJjghnFE3ZQ/XOnc2y5o2qhRS5dclNKvhjZPIuvWYp0uoZH1Ti+jGHW1uTdp1qnGisAwncDM9ipU/15Jh4G8Hqmz/ng0D60YozNOqgQvmbbX92qxVzmwfwSzkUn6wlhkukI7DpmPjqPu2lEPOSmqIZflln2HwIW9hdRxr3+3VR6nZYNHKCxv0NSWajCzBFHMw3TJr5ycSzv4GlUvYknKa85ctv+1uepzYybi6oUX6zGnK5kdrUrFUQL7eqmQQ5aRhuQIxcZJgqLUitjeIFQlB7rln1G/ITaG1opyERLtlCNyrV3KVBu4eeK74VOFDOX3ilTueGExr22CPann5HhCgE0ENjbktXFn0IjGUD4qcgisoF6kUdjnyEC3lkPscNMHMQa2Xtf3HJx56rMQuy7XEtU4U1OHM8mgIll+3PBh3vKLhrtZcuPPXjHMCi9pMwWjieoClrS+RJnB9zdqu1YIniUna5VFKugpfAHyftna3e4Vv8atP8yXcqk0szgUIEhGdCri/1XvJ0Ui9uDTSX+HZdrMQ4ToeiKILPIFv+YZ+QLjSwXb1SWsUoBJyHS6Zjp+4GnSQew/V8Y6OoQdQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(261022115727099003)(261022105027099003)(261021121427099003)(56012099006)(261021130227099003)(261021123027099003)(261022075727099003)(261026135527099003)(261028144727099003)(261026130827099003)(261102123227099003)(261026140227099003)(261009223027099003)(261021135927099003)(261021133027099003)(261026121527099003)(261022113327099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dBF30bXKG6+9xBq2TNEuADEtkq7UGo7KiWr3OVF/iu5WO0E1Dj1otjOzNlmITkNcmNe6ip//05mMAFafDdso7ymXTTGK4+4G3QaLn6LHwDt9yZmQA8g8nIO29bchlgFAb2bXNXruiOUOdju7O0wdeFyOUYJ8jch0SxXwK84SdT2OT1YFf0Nw6z7OzIOGpMeddrT86lO61NqXZpnazvXB6oJJVvbKojeP1tXjT4cvJafodJJQATg6QkXqjpbSMc7whDT/oCzpAJ29vbyUv54BN2LIgRIH1lAy+lThvnynB+rwKlxS4N8jhF2O8ocXzc4Vvf5hZXE6lQtNhqHinP6LWyXnB/dc7/brW4+JIwFiMKZX9DvoHfH71D/sXzbeU8Q3heHgsgECEkziiybqJGCpf/8JR74zDO61+J9WEbiN7+WY39axXWyUdIsnNmJjGjgv
X-Exchange-RoutingPolicyChecked:
	WpxQQ71BkiFjU7xT74rCRrIi0ammpO56uPN0vwPgluJbfNJrAvi644l4yrTSkwgWotnUxyV32Ct20ApY8U5GfJzyEmh7REzKz8fLlDX7czzeimG3mSTo02oBY4XzRoRVVSjeUUL3xpqrBSugw4AZ2Ndtsq8rWNTXmLRn61cTxnxqD6JcfSzrrzgzPYRyIusoi9f38L0LrFHcjBJEZW+ctv1RVPUCZY0eudnhfAfyGtzlcT/lklcIaArVDjgE+Sb8/XG6OXKdnT0r7loLOJC+xscJUGxKceOdWP/HlzVhTmdXR0uF8XVggQtoppIGwqOFzpO6KFvKNsFwukzd7y8Ogw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:56:56.1038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3a521af-205a-4ec1-65df-08df3cdf5dfe
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6349
X-Proofpoint-GUID: ycueSrhmqkbxTZGHTbvsx2V_8JxgOXSR
X-Proofpoint-ORIG-GUID: ycueSrhmqkbxTZGHTbvsx2V_8JxgOXSR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX+MYks2kTtEot
 nMoQdgRnNYVgji4veavRVL181RShsrcTdM/DfZSKfxiX2c4TbWmEi3mTJVv/4ckgOUpDcOlI0gN
 0dHCJxjoXDm4Ty5qH49WVP70CtgKEeQ=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3c3e cx=c_pps
 a=V3ntuBz9Vw3KuD7vyzUphg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=J8wK4BBRFcl5aWuvIT0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX1+SMgCOa+sFy
 YVX1ARobDoXKM28+t/KkIbs+BcbHLQhtQoE0vNmi48VRGwHkQk3DvHlc6Wo/Akn8kdLeLJ5FzP+
 FWBncHxJygh1m8iNMH6QndcFdauszwDBRQ/lAtFDdrH3UW1zqFg4b4fyU7sR7lWcx9Re4G7dte2
 E2T4ze8yDsD6wqXaElpzgkULIKrB5Hp85G9d/dsvFVatTS1mao3nJGZB+4WHH9ia0HxFieTM2L+
 QqNS5wHnHD1EzzQjEptVRcSDJpwN5jZ74neGToQQ6p30nzQevTIAX5dHX6Ctnn6uAzONk7dC5NO
 YbhDnfXuvDx5mqIpu0rWHDgkVIvcbHQrDFQiBfBC93ORKLnsKmhNB8HihOgftxoXeyg+1h+s5xa
 +dLVtm13jhH0IwGq5DVpQdPhkUd21PHGv4F5sa02rA0XRUjfRUX7MarUfraoh7D1N/Vk3uGFNxE
 J1a8FLkad6JF/CPyQQA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

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
index 44b1cf431939b..be7ec62ab2513 100644
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
 
-		src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
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
+		dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
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

