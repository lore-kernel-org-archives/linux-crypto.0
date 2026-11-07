Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067648;
	b=gYtDyykEkzaAVImLZ8/ThZ35h/1mf4oQV7mOd6cokxoG+KwiRtXjBCgIYYs/XRyLx3i7
	 0EIwvCVT1t2xgHz6RwuDub4LbZXi4oyfbQOJv63+Fe+c1SVrcY3/mCe98xuq06WAdAq6v
	 1sBweXFKPWpHyFSwjoxcORpBTTQP4r5o7fcH2q9MmVyqmM+qgXbiIaNDEzV/XsMcEH2hj
	 6bFBCyGXX6bCuUP/DTiM92TDpC0Mel1VUnd4sMt+vT3aJLY/VsqZe9UkfOqriAQl2l07R
	 K6ZAP+2i6VBgQUGXNW/dN+x6SjguDtcDItTDTcLSu5I8oLS50WoofdD91cmeB+zvN7w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067648;
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
	bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
	b=EfJhYXsKjp+cW5aWQmBnDKBdS9z46LecPg/sf2RVcwSIXXCluNlE1fiyYAlhaKRATz8h
	 4xv07ZrgLPRSUqApnZ2yXx6oQTQjJjh0IWz6pPYinnKQ0lb46M1Up5pUCpAnlYt8rekqD
	 q7aQRu8me+/yrdI/hfcDKQGile67LM0jDtHHAGUbURItzPTdAv9cCFYfNrCE8hO8/QWTA
	 XxPBjU18FAoeQp8ut2F9VxdzCR71V9Kpk+5iZYB954AlXD8akSHYGZLT5wb2jsp213sOy
	 uOjvQ17wPPEAeZJmUu7Ailn90RZmDFxXGbhK0r1X2h+N44owrNP66L6TpTCtupsI/yQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=aMkKvzhL;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=hQi0gE1Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79A3606A32C;
	Sat,  7 Nov 2026 16:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D79A3606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=aMkKvzhL;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=hQi0gE1Q
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExnW43866358;
	Sat, 7 Nov 2026 10:07:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGU
	nA=; b=aMkKvzhLkWNUQEkNHDyFE+uOQAiTPCH+AuuMCxL2ObeZ/EWIjkyGstT4c
	ad+5626LLPgJ3d3vrDtXKJKxRq53M00oYrAcwCDqmPVK2YjgduMJni10WUzJtVtF
	TkFz/jKKVsnpDu+AuuBvdMSp1SRGNxnB6A4HPX3LutZhONrj/lhAmhtKib2Ev7Ym
	5EItDInNCNMODNDpn8ip0+YH/WGcfln+MvqTVFORxFqMzFXgQle9TRVEoe1+qVBe
	SlPm3OnZe2wlbPcho6n+wyzq6Tfd7D0G5K/MMbBpnxQKglYWyg04inna+NE+96vm
	hsbXitfG1bc9PWHs5tnpLvljCZrZA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmj06h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:21 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyEEVo+OUsdKQ1WzyCYNWjZC65LIsJUz5f1F6N5fbb5fvJeDSHEY4No/DPZ3Sj1aOeBY6L/ipQAxTvZjQVQ5j5lD3/lepNZ864DlvkuKR7tgOWKQPjwdzpI1RCRAOGJ6ItBPiQlL4wlaqS6HTnT9WuM0PKxOo2CFEI4OK0NQYrTR+ztY1LfvXBdymEzrE+r2+OMDLL1/3rtIFFUPKpVgUddsJnNQXwuOiEO2/iUO+24orVywb7mITfxEiFbI0w/krzUEI/s46YSQBS1FGaZiQMpLPkCTOaan3n5ulreNTBRGRbbJlsg5lrZieaRrfTbwqH0Rxb1wONdlHvA3cWcRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
 b=KzLDQansvOhUCzJaPj0JarPMevlJPGIu+TegmQNeZ241VmsV26nme1feq6L9MfSqCx7M+hG/UL0/PzhKEZKDI3m8cjLELUmcibp6ZQX1TcpZrhEJGwp3BDD4lUC7ZhLj2Pt6zFuA6K5styE7eRgAw+axlwOPGAh0ACz0AezA5OFiJYNqZB8iFDfn20VYUww1EyDQbR4jCTbsXtbvqgq0GAJAOzw2K2YRXIr8VVzJYms30m2YZBz06/xHy1taBVfuzU6OZj0OltW/KwvMLKphJPYPjpO9IAM/VbTJumUASUVc9QhKcXezVsWgW6ffeyunjMACcO7ufjXuYn/gA14NGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
 b=hQi0gE1Q7nl5xIYTQP8GmPR/VWOT4VkdptV8m5Tddv31hHv8VWqx+6HoSsTn7eqT0mHa327sKztM2XOHKYVX2zzoHxICzCsKLYYCoV7ovCr0JnqR5yHg3laC6v9cCkyfiU7ci0Pbd38wlbG2lLrTfM48gDRp+B6cpdqSqohXdqI=
Received: from CH0PR04CA0117.namprd04.prod.outlook.com (2603:10b6:610:75::32)
 by IA1PR10MB5897.namprd10.prod.outlook.com (2603:10b6:208:3d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:19 +0000
Received: from BL2PEPF000352CA.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::3b) by CH0PR04CA0117.outlook.office365.com
 (2603:10b6:610:75::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352CA.mail.protection.outlook.com (10.167.249.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:17 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:50 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:49 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:06:49 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6mMk3459484;
	Sat, 7 Nov 2026 10:06:49 -0600
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
Subject: [PATCH v12 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Sat, 7 Nov 2026 21:36:16 +0530
Message-ID: <20261107160631.2592763-2-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CA:EE_|IA1PR10MB5897:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f6b2b53-f1e8-4d4c-8b74-08df3ce9324f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|82310400026|56012099006|261026140227099003|261021123027099003|261009223027099003|261102123227099003|261021121427099003|261022105027099003|261028144727099003|10067099003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	cx9TQlHBkvUmUW9YauRxGvvWC1kaVfWT7ExjzlbcRMiKdv+D71UkSG3QNOGcL0mZDxYyVRA2bUTDxLTQ9h2j6v+71t3OkUJlQjKmj+98vwckyXEQUopoVJQsFdFItYqPTxdIRUJu3SnN0YmY9rGZilEmriBvqfxzE6bmk0g5f4ojd2/OmCyquzlmXWZyuPpaF+6AiVyX0xqKCFLkuccSTp6SF/dOh45lccRWDmsQa8X20eu90KIZcJSso/INXdsB0ZrEF7MyVgGz93rH1QQmLP7nyQda4/fPN3Cm4yyjhvFLCkbQd19yWOverjEx/kpci/JAfoRGPXX56uUSRmoNfg52BjQe01ai+XpOtCGPBFSk1Nwky6brEBoMvRwLHY3az+jCzvolO+pteetIkxLSB32LJCQGE/z/9lvIJ26dS3yqC57O/eUPHwaTcQG9NVME2whF/UyDVY91ZxitDXgJdjnXIdb2QGQzGL7mrxv2e6TcqP2N0w7qfsUbIxhCHSP1Webpt1a5WDgjiEwkPoxbYHM0GU7IrFltPgwSHmnk248NAJIJCfjaPRMElrfkolBAF3rQXNjcuvAkOajwQakbXpushlz9caS+/JckG0cjR1L/a6nZJ1seDmhIJHHmYS8c4VPLxCVakux00Zj+JtS/Ypq3cqc+MKl6MwfHCpuFRfY=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(56012099006)(261026140227099003)(261021123027099003)(261009223027099003)(261102123227099003)(261021121427099003)(261022105027099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vRdbnkuzijxIKpOC8xjxti+1etqKGff+khWqhOtuonzKBP5GTocZXJgYKvgyB+9uhM5GznyyWBAmBHcUtJlCL2DOTwTU7qbWmnScPOgXzLe7dQkU2zpI+DpPpzsa84yMHfVy1qsxiKFRehnvxdLMa88necOlDNrNafRlHCJbBScPA3daAS1U0G9EmyMIi+RjjG/WYgxaAdnWwA+cxzmaTbrppp6WJWGkUzQvL6hfZZsEXvt+VvUh8HQIGwTaaDoMjp+jyMgBtLQ/FkOIU2eOUbwaEGKk7KDUqULhZ2BchpHRPzHsB+OudasvIqL5MoUbppQm+YJYkMvYhl6pizUdyz3dASqWzBAD82cbDe15UCWw4t+QKLoTSOumxi27WZzEGUZyPXGAa2f51nXT9dbK+GhaLMS7VTUEoK+ObocQVIB4/vw94cGwubpMlStzPz/3
X-Exchange-RoutingPolicyChecked:
	E2nYKLe5k7WYqpQTv9Jj5F9v8pew+bISh//GkKE5aSp90zNQYJgczAlKMCjYv13Pi4Pu6gSAG7bap37FMNsBXT0NR3EXISv1hJ9IkNHgWO02NnTDlAfxs/hd+4/ZW18wQEWb5a6FxQVi4+rVDjzZ80gNolfpWHQ0g00V6gQ2d09p9Xi7zTHXv0Za1vAzf8bkeyW+cdBxfk5hs9sMHuOeH0T2ea8rqHC9yyobQfDAZSYoIWVhyXBUGBpIa4A4tePK9/PlT00imm93942LO3f7XZ6xQkxMdZAjb+6HdRnv/IdDHUpAo8LtayygPcI3/BOEIKzrYPc3GvqSMKFoy2mxcw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:17.8273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f6b2b53-f1e8-4d4c-8b74-08df3ce9324f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5897
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef4cb9 cx=c_pps
 a=xsj2MuQvL1s4LVRwU0hgyg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX/V1RvM11hASA
 gc4GjcbkyXw7mQYQMP05Wuklm/0PjLRN/3n0mpbtCZL+Q1qUTWgM+W3XQw+nIBFfLiYwzSjZ2/K
 rwZXGvJh9kjK8FvJIQERrIp0kwikmxa+E6+IWOlCxCZGbFNx27e7i5W1tISxZjWMiMYBqxnBjKU
 m54yBzEgolDfiSgTg7P8iw2wLKB2w/luOzGxNeLZuhzdUBVkKqwXu0GNjF3rYCQRtE4yJ+SdOT9
 FmEl7gdCl4jE66LYeCynx6gt2wTL0475lnkB2yzwyUlJwOWahGuIgvLHYmqlYL92SJkO+Irfqzb
 +227WEbtw4pRGqLdCO8GQNXKhNvhc29iT+MfCmRHSxCGp1UVVDgZmBIdDouSvk9X9ijRUgkxuoW
 mb23kETx6M5H3+sGmYr60uc77ExzgIftn4RpkEGRzXbiBR/b/cD+O/A71M8ZpFVtHlS5IGYM4cM
 ckUYCMc9eKqBj5hs0Ww==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX03vuE96f6KfK
 087eWkduvguspGz2go2+EdloT5FSGFbvfvYpA+m7MS+ivaviLs/uK0vjHyLQHLN71OI5VanoIEY
 Ro/YhOQkfqG+XtWM2oOE4SOO2i3toyE=
X-Proofpoint-ORIG-GUID: vHXe9PNoMZXeHRiXx4IupaTkqWYZENps
X-Proofpoint-GUID: vHXe9PNoMZXeHRiXx4IupaTkqWYZENps
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

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
index a3c069ca2baf2..dfb26be6d20ac 100644
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

