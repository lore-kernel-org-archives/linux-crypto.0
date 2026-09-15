Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148E947DF97;
	Tue, 15 Sep 2026 09:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466255; cv=fail; b=AjUCsOofBRqMrXB2yZ6/l49Q2OmElQkQhK7APnsJ6HRPn2J/gzxZFE/6XKmT9NxihDPD6vBXz06h9VKUPXxFduKBNmP8V3NuOaOMqxrdrfE2uM1jt4RgpAi0r6ofpH8gvqymQxr6SbpJnEjVxUxDzCTHiLN6lAyYJP5jP7lwuSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466255; c=relaxed/simple;
	bh=Co40b5y5PFO0m5hwueQ++uDe8w3o13WGlqq4nue966c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=seFPjzStG1M1BS/14iMFYDq5pz8GmYW635LS4C356FsqJjLCC4ieZp8dvZulPHSylaT7lb+PSDV7xTYi4ezlGm+LmTPzr15Hqn3nGppquBHDksMj9EqP9IIp2HBn9esnxe9ib6VY4c3eiE0fPREwGFK5RAnoM7VTwBoyPV+wPYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=I7rT+b7a; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=fxZTXg+T; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="I7rT+b7a";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fxZTXg+T"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fQTf4098406;
	Tue, 15 Sep 2026 04:57:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Vl5Pbjq0urGlWkTO4hAkMBUKaXvHbYKLLOVLaEKB9
	8c=; b=I7rT+b7ax6Vee58TBP6ftK5J6yb5+DfdoOnHgPuBAbTdT6XHMSEI0288R
	axgV5HtVvMsWpQDf7nrlulOE8r7ZjsAzB/Z/7M8yfKo+4fT3x35LKI334Q8LHbsu
	OSnbRH2WCTK8SwkPaatsJioPjTpZX6j+fWuWa8CtnZyACEYDNZ+cffDZ5Sv4MpuF
	oQegrUWKggSS2sWq6amz4HB5lK6KwkL5S6qYDadcBDYFzCQkSv6DsLlNKLAwDTMH
	uXVyIADIwPLOy5Pj/71Yg8fquXOL4Z4A4J4Dlc5qmrlSrCDW2GIPnv5McR6Ez3kb
	Bgp3LuvBcO4GaojFUWj6gTfKnT+bA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakpc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2IuwawDQbeqyFZuyOBMaKzllunamLiyIzOWdMg2Y1q/X47ZRvQ3rsNXzkDoa7Cqf2eMhF8jY5vhARcKDpN0wOhP9f98qvVLyiGKCJnMeTICaWQHpPOGbXl/HutrCRuMzMcDgkwRDVOK2gaVSY7PF0v2r+CYnar4R+c7xcusUUs2YtI0pb2q7xe5LTa5/RDVYx55fhQXqyHY6qMQNzUduBH9GqReh9qN3FSIgEW5SilBWJzs4JuSMter1Az4YqiEUfN6r/UVpsPxt9B/qzog6/VOcN3JJ7qjwgB0ANx0QHf70G88Gml+Lrn5nmFRqyB06xRyMmAvJiSOXKWM5U805g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl5Pbjq0urGlWkTO4hAkMBUKaXvHbYKLLOVLaEKB98c=;
 b=hXbZn2mN+GKx3id6LVVfnDRRo0jkU7YpAO8qbtvJS0XBkKOiWC1u1ZbFD5oAZsKoEV4iCu+xW13mBq5BfaiXv0ANQtcA+jQkJaGYXiqtPk3iWlowFYit3vuB5y07jvapQ0JkZ3lMofqsovOw6jRMwJVH2gQc85KnUSx71y4pzaoAyan3QJnFUqZT79pcEVfDm61AS6n4qqu7lwZF5gzIpAXAJRElwiXQzR4IlKbHHI6uXOYAdZOsQ8BhkiTqQ9S3h2igZlSstBJlFqTs1Asfy4lwIdwB0W5wj9nE8qc7B5TzipqxFrwkT8j9Odt0iMvQiLneu+zNyRhht3tesKFZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl5Pbjq0urGlWkTO4hAkMBUKaXvHbYKLLOVLaEKB98c=;
 b=fxZTXg+T2L0aejwNUYng/wZpBVpNcbQZUJxwKKDvKxgckIg8GIHudEti98JQzFwTm+08MpjpSFRZE7OxuOIzC0eyzbB6z3iy5oUFsRlyhaZyqApYWGGW4Pmodf7832qFneA8/wLiB5H5azAastR5BREUp8juXCALsUS0w2hYVbA=
Received: from SJ2P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::14)
 by DS4PPF509E676A9.namprd10.prod.outlook.com (2603:10b6:f:fc00::d1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:57:26 +0000
Received: from MWH0EPF000C6187.namprd02.prod.outlook.com
 (2603:10b6:a03:5da:cafe::2e) by SJ2P220CA0014.outlook.office365.com
 (2603:10b6:a03:5da::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6187.mail.protection.outlook.com (10.167.249.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:24 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:40 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:40 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:40 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8G3000901;
	Tue, 15 Sep 2026 04:56:37 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:32 +0530
Subject: [PATCH 26/30] crypto: sa2ul - use correct DMA direction in
 sa_sync_from_device
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-26-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1174;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=Co40b5y5PFO0m5hwueQ++uDe8w3o13WGlqq4nue966c=;
 b=A0JM6fY9ADbHEd81xuFCiSUygLBQDX6ZS71cKFnDPBbB+Y4HSdodHzBonhBh/booq9ku/Gy9M
 0RAzMm1acdLC+rJYoxS62Js+RnwcAcUWC3bQBGoAUXTfz/0C6ZUnxST
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6187:EE_|DS4PPF509E676A9:EE_
X-MS-Office365-Filtering-Correlation-Id: ebc75f79-03db-4dd3-4b1a-08df130fbe62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hWm4OcvPfF86UTd0ClO3LauVz/ZBHxYQKL2bAwOYoa0Orq2zCjxzrnuKvMgZPPj/FsecaWyI+isgxUE/DUWa2B+R5IG0U5XWgSgvzt8EEkzmhfG0YwXhKAzp1Gwh3tyN+vtA1QUIbmSLxl5y7VNTUVsAJJ3TlZVJq3OH1hRI6eV7EeJNU1YTa8viAQrMI5+2ekUWhXs8LcdDi42V71a/SnPPP9LAIyVK+EBciVf60+8rYVJGl+8ijAQdSaRGdJONZvpCbIlXoCoNqJH0NFhrmHX9wJVAAe2ZL/9KPG6DN7vFruND7rWBUAA0pxexuCwGrw51dnWKfL6x/cwZbQ/4vOv2bvv5lMhbFoFM0TDvmGT+yc9To9ObIREcz8R25rDRp5HLcS/kwb3oN7iDTUfU5FEhWUq/pOCSeQ6F/FjxcMXDqQFX3y9ZhMKG2sDBWG7YSdl8hjys75J/7EokiI3lVQTHDSpU4PHsU7aulmyWVhl9zS8sndYOtnKafKQkSslu0sudZjVYl1S7pWVXdZi6rPp2CZ2I+4+yQM3g6qFwxygs0JdmEd7WUKxWOb2Wfj9Pxh29M1+XLQbmTbwP347eX6qKnMQu5ulND1SFHNOMYku8jYl6cq3ADgNjwR2romRTk9qiQ8Xiwy8/0sY58e91vFJMOcfvsSwOhbLZvFUM9w1cJM4Yq7fw5mRbS2MfO3pWet24s3GbWMF65TtR8+d0Wg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Xukga2QbxYWlaeFZkVTqK6a3n4lgkqJFCWRPy2fS2ZpCa8tTMSX57TTzxcuWsZPxDZtIYdBu7GYOEW+w6aYn9lLDGZS/oQtkBLyw8b6QG6MDpaAJe7B9vX+WQEywc72A7lUdIY7hI0MV1SzywJKXc3uZph8fvEA11J2QJ+Vaxw/Fg4jbS2PLuFvxFlgwI9KQJi8k82hncSqjVdXsRLmwh1ndYY0+4PkkaDNOKtyoGWhrfanlEaRBkFSo6VsTZz9MWe4WOsSlxRVB8B12fYNCCkkN3yubMuLOa57C4jbM5ouEJi+zXDyhq5YalEVujq54CS4UKSpeek2x81TH52QIuceciE9pEJX1+q9pXocN6IeGkCbTl1+bH1mMvPNlJrB1tI8ZjRHGng89W/BErWABqNzd8aDH3k+MYdBSh0vHFMpKcm4AJB2fRvkovhd1YYii
X-Exchange-RoutingPolicyChecked:
	DXqEVF8UUNvIiAip+pGMXvlXupzIOJrzXWkvKX5HrNxkk4bBYnTPR409/gouBhRTNR9qyYJyoKCx+aMblRwLYKfruhIMPtvD+VIZmRkRUNkHcwLgSyXTwr1ssd05XJY1utZ2S7CDXj04Kl/+7a858B9hBtQ6qO5SwplYTAQduUQ30pQLQurcbryFC9BqhEfBdlJGp5fKZIptq4eastewO5vPEAq36qgIQdHSRV6bwh0MWHMytv6Qx0suewWlVPrGkQRWmCvEnOUOZKycvs1pkda6C5yNTFgoQKd2Y0zAFLIAKMR68XvSUrLHqdqLU9NSQACYrq3//yaFhMBORmdv9A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:24.8147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc75f79-03db-4dd3-4b1a-08df130fbe62
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF509E676A9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX8Xbl8SIdZQNd
 yes27vQCP4/4jvEtHRHszgz1u/9KDg8Gy7nryGxYVCgcgvLZUbz3ergBJ/Wei/xFbgDGjXy3FpJ
 JSfc/y8B+r6pzgByl0j6zfdfsY1rK4Y=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91689 cx=c_pps
 a=cGIxddJ9FFYnYBVvYRB3uQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=Vir26vXXUzd-kgAFZqQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ioOY0-MAfOfesB1shft2pUdGlio3ZXM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+oAPx6wYBrLa
 jtIZ8dVTi3BquCgmzyTThWyQtvS7DI9H4/+emkP7C3iyhwSMlO+DXR4f8IkECtmvXfVzRhsWjtU
 0ylsZJXIaycEAqfzhQD+fNu8WPXLm6knteCKmdRTPKyiqg86/Zc03emwvq055uk50z0ZWyZi/M5
 XiwRTLGjzxKvQMkkUgPNVAZW55UmE6J0eMmYTKI/aTQG9yDWmVd8SUFV8Uqk5bxnJ6BC1VSUn41
 HCVXNWPoRmb4/hRgBfb8L/bhgIvyPRm71h6uE2LZNwL7D0Db4SjXwoMf5MBU3gDJcid0tQvBGyX
 dcDX1baVV40yOQk15FxZov1yYlPNI8lPikIiB+JBwzM5rxbbUvrlIhh6YBKFFpmxrTgSccO4WyX
 wBr0lH/zwKlGGOhfSVvtLwShS26/q583ocAa7ZyfAn/1ZpDRuHcnPyRXvFtQ55vx5lhL5RlGdru
 ZRmHLV0yNHM3oT+pLeQ==
X-Proofpoint-GUID: ioOY0-MAfOfesB1shft2pUdGlio3ZXM9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Use correct DMA direction during sa_sync_from_device for proper
cache coherency handling.

Fixes: 00c9211f60db ("crypto: sa2ul - Fix DMA mapping API usage")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5e0ef12eb02b..df905b391339 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1041,13 +1041,17 @@ static int sa_3des_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static void sa_sync_from_device(struct sa_rx_data *rxd)
 {
 	struct sg_table *sgt;
+	u32 dir;
 
-	if (rxd->mapped_sg[0].dir == DMA_BIDIRECTIONAL)
+	if (rxd->mapped_sg[0].dir == DMA_BIDIRECTIONAL) {
 		sgt = &rxd->mapped_sg[0].sgt;
-	else
+		dir = rxd->mapped_sg[0].dir;
+	} else {
 		sgt = &rxd->mapped_sg[1].sgt;
+		dir = rxd->mapped_sg[1].dir;
+	}
 
-	dma_sync_sgtable_for_cpu(rxd->ddev, sgt, DMA_FROM_DEVICE);
+	dma_sync_sgtable_for_cpu(rxd->ddev, sgt, dir);
 }
 
 static void sa_free_sa_rx_data(struct sa_rx_data *rxd)

-- 
2.43.0

