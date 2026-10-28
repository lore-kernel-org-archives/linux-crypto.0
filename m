Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793170615;
	b=R5AjF4xU+RvKtoMP+XhMAHwz+38S5RKYo9tnOv2Yc1GYQHis7izljlORQAt1JxbWhGM3
	 NalmdubOqR4r6jMF+SSuSiwjxUYNL2/DvyQ7sm5z8KnRxo841q0itA2lYF8GtRHW5N4kb
	 ibPro+MQr9DCqFiPL/Iqxu9M9CzF0PY5gQaFTjM19Tbgth7Uo3inEXRw+AJz9LEB3EFEw
	 DV3oLpWFmQMuN+3rCUy6gImJVg7EVR03VPxWq4jqbP8vp02dvlLsdBLMIX6iWytbucpuF
	 ChKIhaKh9IZ87nKUT9HS1pmwQ0hnKd/vbvBAg+3BC97v017T/NfmLrWENfK3DvtKV3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793170615;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:CC:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=gVELale0ZgRNJ16as8p5MTFw4YHkth6XjxDH997hhjg=;
	b=sYuo87ife8xF8DLp1LMCIoICCRReuvVWYi4DlNdW7vPE/RRc4a8vmqzNjeWCf3bagsHI
	 b+MwHkg+CpdRI55Iu92wyyLtewZQG8mOEq+tPg0awPN+pepTBqehmDmHOZ604PojyBh6p
	 H/mkxyy2t3jhotGX78AEDVYetuwT+/xrvVf50cjoA7FKoOOazdyJdoH7d9bb1k4Y+O/dP
	 0MpQNubRjPE728S1qvqOFHDBtx1SFD66GPswoNTxVTHkbMZKplxE6T4LXi/GWKs0SqRDu
	 veQW2DjRYh3neHbwzjY/Y7cAR0KAZw3CtCnekdyf9PKbMVvwY4i6OjQgCeCzwqNnzPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=SLQxmA4i;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Pcd1pj7w;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE43606A31A;
	Wed, 28 Oct 2026 06:56:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EE43606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=SLQxmA4i;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Pcd1pj7w
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4RmrB2580294;
	Wed, 28 Oct 2026 01:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=gVELale0ZgRNJ16as8p5MTFw4YHkth6XjxDH997hh
	jg=; b=SLQxmA4i5lrJvJEUll5B+TXj7WI7P8PqcVE14TIofVBPPFFRmpnjADewC
	+TX4L4sPJ2irHgP65a5UrayHC+fViAr5YIbM4TBhkjuMqfUT6e0ZVReiMwbxUNbJ
	lTavXShyR01NrkQ478hw3/m10yD2gNER9VPI0N/c3Kc1e30wubO8X0pBKq4uBygH
	sufUQSFuQE7juQZOXnFWpuZAniM76I/caasmFPqnVRUcWadoB5UKh+oxSfp5Tf1p
	4MkoOHjzIiRd08zJ5tCFyqcYpe+uBDK/FdltT55STcvgIvVHxKWIxm0e2yR9DaJA
	yg+nNRlUYCd5+s1sU1Akm+dOcdvrA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011007.outbound.protection.outlook.com [40.107.208.7])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hk4f5tm56-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 01:56:46 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaYGYQ9clHcxgtwrV6upTYq8cLlbYOwHGyYzJ47ooe3CFQxf+/pUiCzVdVhkH9YsAAObwQYIQqEG/QHtuTyzXEaQe2UbRYJphRpLh8UlLBxMYnwaSfWzPWTqRYgayWWFVk8nGD+RlHFgC6VZpjuuo+Qp7XslMhOHgC/efgBeIAB0SabUtQTBr5iwVJV4SRla7cFkqU/kJiFKuhqdzDedo4Vp9rna9ZBbehVc+0wjARSmHfAkAOXEDyryTGMXvbI03yWnkY+9dZImW3148dxq4o0r5fkwZ9bt39Z/S6Ij7iTi3KWsav5N3KFeHAqQNgIlSJWSV8+ouPMOTuOUQRPg8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVELale0ZgRNJ16as8p5MTFw4YHkth6XjxDH997hhjg=;
 b=elIa1qY7DoHjCKRM/4c8J+OfygICooHzN5I6KZCRCIPThgHvZ9JLQ7QaWQM6k0JUdxQcWNNZgmeDzDKk5lLaZ7S+GqCYzZynAEM6/lkCGgjZiOP+jxxo1JjqQPNUxUZkkP9BhtpAezyubVTHVKiX31YBbD/GWijusRZPGDzv39QGLQirLaQNtqXWx8yuKRstAXvi/BIfpbEyy/C+mwKHNgWcWGZz+2BN4VawQVWbZKBYfbNjls3YSTzPf+RJ/gTH2cvA7qRqicUl4sdDgMQmsbUo68v3KM7pU+p662mRmWutTJzRP73QM6krE0EfSUuqBpipPUEA7reZq69iVIG4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gmail.com smtp.mailfrom=ti.com; dmarc=pass
 (p=quarantine sp=none pct=100) action=none header.from=ti.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVELale0ZgRNJ16as8p5MTFw4YHkth6XjxDH997hhjg=;
 b=Pcd1pj7wNV/gkcTw2B5GIahNM7IzLL+0Hu/obKgBjX2GvcWyshIyvZ81zEgZMudz2T6NZzRZRWxrdX73RS/F8DJ0E0aK0pFPiUGfJ0Bn0mx2cdRuL6T7jciK/VRr7J3uuZ3i/h5k0g9dTKSopF0ME+4FX0eZAAbI2QTer8I7NE8=
Received: from PH8PR02CA0021.namprd02.prod.outlook.com (2603:10b6:510:2d0::28)
 by BLAPR10MB4897.namprd10.prod.outlook.com (2603:10b6:208:30f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Wed, 28 Oct
 2026 06:56:43 +0000
Received: from CY6PEPF0000004B.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::a8) by PH8PR02CA0021.outlook.office365.com
 (2603:10b6:510:2d0::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Wed,
 28 Oct 2026 06:56:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY6PEPF0000004B.mail.protection.outlook.com (10.167.247.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.4 via Frontend Transport; Wed, 28 Oct 2026 06:56:41 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 01:56:05 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 28 Oct
 2026 01:56:04 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 28 Oct 2026 01:56:04 -0500
Received: from [10.24.53.205] (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69S6u2nD3479548;
	Wed, 28 Oct 2026 01:56:03 -0500
Message-ID: <e9e36645-51c3-4099-9c5f-063224b479d0@ti.com>
Date: Wed, 28 Oct 2026 12:26:02 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ti - dthev2: fix empty-list wild pointer in
 dthe_get_dev()
To: Li Ximo <lixicaicai@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Wang
 Haoran" <haoranwangsec@gmail.com>
References: <20261028040319.171479-1-lixicaicai@gmail.com>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <20261028040319.171479-1-lixicaicai@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY6PEPF0000004B:EE_|BLAPR10MB4897:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c3f29ee-6f7a-4a2b-6d8e-08df34c09f1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|82310400026|1800799024|22082099003|18002099003|261026140227099003|13003099007|56012099006|261022075727099003|10067099003|261021121427099003|261021123027099003|261022105027099003|261009223027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	vYbgtMM+iBrJG4TZAZp9MNLizkdlDiYFwfRIfzM8bB317vA3Da117hg4FCgiERscl2SBGAHa757VKV7POo9Q2HPJKXErQyLyGuy+i9noXoz33W/nqy+Kv66ProSuIBzl3+0YCCNIkgRPhKUvtwAWPqdtv7/02bXPRBfxRGDmT8ZrfMnsITTm7JGzuo9lOAderkxl9MpvKexocky1NCbnj9dREYWUV4cAx7x76TWZiMufHfL3/DDW14Q6ullPc46EY9REUBRaO24PMx9BV/OODSpDLk7Cp/Bo8Z6cCJNOje+WmpW43veXOQVkz9zwpc9JocpeX+0SHOlQ/aH8gAPK1/a2RsBQYDUQaV+ZznoCTIOxaz7Y2y38d8r+5HNGOWfd/oVmtiUSFSnkjSMMCK6wZenFcBPDwpplKmWQqJk5XeZvuBQpMBN2yCTv3Tmo28wekdZGL2m6CoKZxtrLW3aC77ZYmavUbqbVQRLirZmb18rr97qSfnSkinKY2f/+EmAw/4UWJnfirbMqY2woUU7i9tuajJh0gJwLE6sRiMDPtWJSchitN8MOx4SnE/qEjW9IV1cDOXrSr7f1yBFHy4j7FYdDTjfchH1N4ZADft0QmtIilvGydG9VFiVGnVv/Ml1F+Tcmjfu3BMwQNJH3HYEbugONwmvI55RL7eluhWP9xuY=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(82310400026)(1800799024)(22082099003)(18002099003)(261026140227099003)(13003099007)(56012099006)(261022075727099003)(10067099003)(261021121427099003)(261021123027099003)(261022105027099003)(261009223027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZNZ4EOnXLNetigaMaTqsVQLZ6WLsoFpfuIwJZxuF3MCfF96tsGn0rHS5FJH2yAmqg4aWLS2j0D92PmD2pzZ2JWIEiXy0dO6uHYmKeAlVeLqDaRB3OIpK3Ca6cuax/yn52nObUjob6k0itms4P9KvF4aJdiFuMXeWHOTEqML3sZeMPKIYL6rV3/EISX0mnCQOiMjI9h7B1cvHg4zIQXOskN/1TMkfBvPbfCWWcL+9zuTi3fg56QeCjinhj+0qHztZHfTKT8v5YVAf0wNhJO0oACL1KI1So1LYGpS37nZF+N3r/HOWUgjVBBkbwmTkFAfcAPJ4xZN0f9pfZ8aW5MZTVfhBkSz8OTQ51pnEyEDIrw2sYMtF3rs3mzwnvqSq4GsctIE3m7aikfQqedPOSSuJIL8wUpi/HEwEXRQ3Fmm0BQERxvQv6Jw+TcrD2KjwcUV0
X-Exchange-RoutingPolicyChecked:
	Ur1kKu+S8U7kcdtG6ljFoCsjiPMQ0klFLCTiknBjmwIKqcoppR0adttVliJNS2Ni/tucAYQvrz2HyjiNRLqjJUpZ6LOhiRxxhPHHRnAjldqkcPjhggg8cd/JP25VhquJAW2m1dEAr8DL8H08BnY65XQjFI3G5saJ0gK/f54Dj8AWBqIUyEjSaSE1fgUDYDBAyfBFilGqJOdiEpKuVOQTnPYpuJijoC7/R221g6D46E2bcUNOJNzne15NVoQOq1UL5GPs24KqVZYLZM+mSkhwhFE7gFlIRXevr5muv4qb0PmtcnmD6B+D/cSuaRsQoDe1ON3orrYN8bmcqTliSXsf4w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 06:56:41.6775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3f29ee-6f7a-4a2b-6d8e-08df34c09f1b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY6PEPF0000004B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4897
X-Proofpoint-GUID: Gws5YdJlcf6SqZwspyv_mUfN9u0JYpku
X-Authority-Analysis: v=2.4 cv=S+VMU4sP c=1 sm=1 tr=0 ts=6ae19cae cx=c_pps
 a=n/3lZCR83+ZXmFnVV+4wNg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=pGLkceISAAAA:8
 a=ZRs6d9Ez9DY8IbQvA3kA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDAyNyBTYWx0ZWRfX/isvk2+FFLC4
 DqD7gyeO2+Qp/ZZ1kmx4XB59n0ZIwPkYdKZyYWEoXHK08c6PlAKwT7bfexkD0YCW1fMakictWEQ
 0tMVrzTDciA6qjZ1Rr2YSBRKq5w/Lmo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDAyNyBTYWx0ZWRfX71DP0mcWZe4Q
 0YqhWCBCBVkaJinEGKsfoirvZfZ1nXJytLLdtVK26RaU3hrWg/bVJuIikN9HJ57fW/7T3ZKZTz0
 hmchuXY38pcW12TVSMLYg9wahhbqt9TC3j+AONuRLVlg1oDbU/1pj3x4tWsbpQjKgQnTpcTTRYT
 tqzDmGbci6a07676Pg0iOLcksjRCPCaDszDaaQx9MRfcpqfmZ8jApunnAL9rEP7oqSvJ74gyjN6
 ZBmAu4a1nELupxqwyl82jiBJcuSpIlqIM01PLRtgVhHUlaiTkXXeUFCcVZuDFFutsqn5Jl3naPC
 zI0y/LcmMrjBd67bpb1tbhNEhlmdf8Kk2ATCc86g+rWDEgRKSgUypjQbz3DKyFCUAHn/9WtTS7l
 Gvn8G6TbsYUrWmQIymCeOLKXBrcUiw5XZMrHlGSa6sY/VvtV1YS7r6+DKhspim1SwKXW7OwbP10
 uoKq0V4GznaZAtPL4Yg==
X-Proofpoint-ORIG-GUID: Gws5YdJlcf6SqZwspyv_mUfN9u0JYpku
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610280027

On 10/28/26 09:33, Li Ximo wrote:
> From: Wang Haoran <haoranwangsec@gmail.com>
> 
> While auditing list_first_entry() users we found that dthe_get_dev()
> calls list_first_entry() on the global dthe_dev_list.dev_list without
> checking whether the list is empty. list_first_entry() never returns
> NULL: on an empty list head->next == head, so container_of() produces
> a bogus non-NULL pointer into the static dthe_dev_list structure. The
> existing "if (dev_data)" check is therefore dead code - it can never
> be false - and list_move_tail(&dev_data->list, ...) then reads and
> writes through that wild pointer, corrupting the list head, after
> which callers use the bogus pointer for engine/MMIO accesses.
> 
> The empty list is reachable because dthe_remove() removes the device
> from the list (list_del) before unregistering the crypto algorithms
> (dthe_unregister_algs). On single-device SoCs the list is empty from
> that point on, while the algorithms remain registered, so a new
> tfm (ctx->dev_data not yet cached) can still reach dthe_get_dev() and
> perform the lookup on the empty list. K3 DTHE is a platform device, so
> unbind/remove is enough to open this window.
> 
> Fix this with two changes: switch dthe_get_dev() to
> list_first_entry_or_null(), which makes the existing NULL check
> effective and returns NULL when no device is registered; and reorder
> dthe_remove() to unregister the algorithms before removing the device
> from the list, mirroring the probe order (list_add before
> dthe_register_algs) and preventing new requests from being dispatched
> once the device is gone. This was found by code audit; we do not have
> K3 hardware to reproduce it.
> 
> Note that the nine dthe_get_dev() call sites in dthev2-aes.c do not
> check for a NULL return. With the remove() reordering the empty-list
> window is closed, so the NULL return is purely defensive; adding NULL
> checks to the callers may nevertheless be a worthwhile follow-up.
> 
> Reported-by: Wang Haoran <haoranwangsec@gmail.com>
> Reported-by: Li Ximo <lixicaicai@gmail.com>
> Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
> ---

Hi Wang

Thanks for the patch. However, this fix is already in works in this series:

[PATCH v10 00/15] Fix several issues in DTHEv2 driver
https://lore.kernel.org/all/20261016124456.1802080-1-t-pratham@ti.com/

Specifically this is the patch:
https://lore.kernel.org/all/20261016124456.1802080-2-t-pratham@ti.com/

-- 
Regards
T Pratham <t-pratham@ti.com>
