Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067667;
	b=YJgToIglM9avP41cWvguvIrfrksfREPgoC7PtyfpOyGxVSv89TgNed0TWubZtbUXMWOw
	 b6tfJjK6IJown74MYbxWt1HxoDNxXfjQecnWnWvw34dtpkTBp2wqX7iDIScirwv56LOZ5
	 Otl3mlFGJ2f2fNoZpfhB8fduhGxk6jYAsjVvYf8V4X63hVL61iRo4rLkPB3xv83axAMem
	 1WKU9GMhbQs3gU23+K3N6JBodU5No5okpXFFS0m6wjENWt3uw3uLyNBNVuk1Nz+OvVUB8
	 ySHWYSDm70VlwS+ysG49vMmSJmLWkAQlukKowQcycdwY/T4eWA78UD0smTOxQqd5PFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067667;
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
	bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
	b=ZK5bv22dGbEytfnnsBeKkYA1up8+6Y04lr90Rlv6uCUOYEz4mAXZuwdxXM4X3+JU/pKB
	 Y3i+zCOYOFz+fxWMzsX7p69ReO5fyfmhokI5W88qxwG1D4sveJa2a9k0mRS/85ncKMy/u
	 RLqTiwQV8bWmtJPbo1n9lx2bw4JxBSACBuSZnRUnZor00IHr4b3eVxGsCHyR2EdtMlc10
	 ow7SMDGrrgb18D39APxQJIrhALx2lSdx4j0WnOmvrj1a+KhpxiXElVRZQ1BzGg6cyy76i
	 3oHdhb3SUle6Yb4djJqEioHGYk+3vjowMzBRRTyBsueMh93OrqfX18brzx0xOJ+SDoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=TFlzB0+o;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=WfVQw2P7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D253F606EE94;
	Sat,  7 Nov 2026 16:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D253F606EE94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=TFlzB0+o;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=WfVQw2P7
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7F01A72335416;
	Sat, 7 Nov 2026 10:07:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7
	kc=; b=TFlzB0+oPyka0yH8EDRT9BQGb91U1e70GRiXBfVjlTXMds74rudrfsyNK
	MFc9LAPv5S9sy6xMc3u6/uaaYPtXV+dww+7UbEK+dkDnVZDLGttzuYfItw3FBbcY
	CwLN2rcsaNmPyoweiuclbYRRVbhxLuRon8xbi+rA/4kq57eJIiG+eAoWtTYE2yDo
	0V9qy+//k8R79SHshGqDodlu4qmgBIoNyTOw2M2rqz+IKsnrWyJAvF6D2Mr6cAVN
	cybhaU5aYu8Woyi5nMcB4MGFk4o8/WW0R/lCpZSG40JaAW2HkbBkBQHfDaeixid7
	V/tlGm1WzZI+VEGOiSsFMMVq7Jd9A==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydwb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:44 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XApJo5+QKN7BQ6fAdDlTnY5PhZzIf58ESJrKqINTQ4Cyx5phr70xZLTgji1qoOI82QWSPB0Z0vsTIFuQuLcklUYr17GDHENPQC/ojD1QKXbtp5QKqEGVbjwyk+20jnGnnqUN+ZVoXUXgxlrxb0EUDRcSWn0BVolpDtmFvF4WMw5J3v3nJcWHku4HA+IMkUmXrI3V3OHcArsEPvdqi+HrUWHJFeU6ZykkwVK+RlKNV6HfJv7EA/dEobfZEtQ3jvUAFJJqjWrzXsXB3kelhRl3orQL0Nm3nYXClhAQ2OM4YoodU2MRAGaOF7oMIes9eDbmzZ9KKbU3GYwTlhDm1NVF5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
 b=vgDZthE4ncn0OBuD+yudkONGcXR4KIzh4cGeL7BtxTeMktpoYZIEzEabKPI7t6A7Fb3v/VbcFQDrG6haWT0C9uOSZ1aqHnegnI1eMOIh3HsYCYCAiT0I97FiGLStn+3TvkYhb7HNqWBqt8+wDiSzLss8N3vC4bjudQb18BBU1QL3YB9FdlDWh4waK4scV6JRT9zxXF+Ya9opT8XWYi3RL+yMlTrikavI7TA+qeJUK6eDHpKB77AbPlkS1TGgo8wiXQ8zZO/fmsaj7j+TBSKerpEar8lRjSlrISxk+01LQMjhbGwwlvzmHomxutTD+4/ZWpGd6WZzV0vcOfFWvoohqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
 b=WfVQw2P76ZYwuY2u7I1Zj8vjomKfm/zUV+0tGmydJn2ZEpAL8fehGMHk4/DPCrhITascq59/RgTYoFONRcqW7QXA3uCDSAwOkFeBeUA39l0SbXmhdtsdEXfmlCkVE5PxDchN+rpx8pTs1XcFQ/4iP6TIkt3RKs2FrD0+e37onkw=
Received: from CH0PR04CA0101.namprd04.prod.outlook.com (2603:10b6:610:75::16)
 by SA1PR10MB6519.namprd10.prod.outlook.com (2603:10b6:806:2b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:39 +0000
Received: from BL2PEPF000352CA.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::14) by CH0PR04CA0101.outlook.office365.com
 (2603:10b6:610:75::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352CA.mail.protection.outlook.com (10.167.249.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:38 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:06 -0600
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:06 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:06 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G74Ef277152;
	Sat, 7 Nov 2026 10:07:05 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Sat, 7 Nov 2026 21:36:22 +0530
Message-ID: <20261107160631.2592763-8-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CA:EE_|SA1PR10MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 393289b7-a65f-4963-4573-08df3ce93e6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|56012099006|261021123027099003|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ls+PkLrtUTHPNG/E2w+f670Rot21XZIOUQqJPEPklOk4cH5f6oPYYMy+j4wVDOQRAhOGqOkQkVLiwByjHpC1qkb8YLzvRCnC2WA89n+xFtg0o7/Iz0UObbdViPhJV8aOz9UFesxiLYQx7cm4TjaB1YXl7Gn+Bel8/4QPRtxfSTNARs4ftcNKmDCOwgtdAwQRvymmB84wrt9khziYTdMZEpuvNxQftCUyP7LAUxaYhgfT8eO7eVxj9w7CdTAtnGIimiUciFZjyx42KhGWbpzOvKaqcK8nByi6OorGop/YeXaJcqCyaqMjHN0Gl4zmGlXD/0mlBpNf0ZUK6GvmV4Cb4tBrR2Dj6Y92eBUjJQl1FKod/3FxR/SW4ITeWA6vC9xTlHyXG5/o81kMBfByTMJ3t2ipS6ktnwELE5863JYEMgs1JRuMRXPw2N1iWgtll2HmIxwz1Io9XiHWa+gbIBRqkOmvVu7nZVMiFhLjNlONKZPC7z9Aod3hFWUNn8TVU1EAQdJUTL6fDYZsQcNy39v63niKO/15Dmx3fpEa0Wga4fM7IES9Evn/xYfanUH94bYheeyDZfVZxD0n7hNZ5YGGRri2raKOfnLkr7bGkPcoSAk+c9SL4sTIeVKIvsOvQPgBmUXpI9YEn0raHXtkrfqdDRhXwfC7wkrdfKoubvbAA2Hsple1nJaVTXplgFquSJHLBvTfC8WqbPMMK+fGHR+eXw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bKC3TfT4yhDTU/7xUu8wpCvfpRFr7PwsjG4zV4wPia4QqHC8LFRzEepZlZ7wM35q4zZqhAGFcMncZjp6HiT3ptMVsmYyTk6XdHptqRvWtH5P0CAyTZqUoSu7W5tkjf00Z4Ht/z5YCYNAVfGexnUoSyM6lvqjZSCuUZ6XJUlBnXEjYgRqGNHbDnX5Mt2a+mNSsbOXOwA7jhUSQE9wCZYLCagqdYcC0MskzlZxct8LHuBziJf36pA40INh68T8wIWbQmWeTkFev6JycYn+NP8+mFG3zzcuUQDVh3BstoTkuiurxTn8OvDGG85w2V3YKcUTexQnlP2X3e9+xZr8d93O8HwOpF/4S7BaM74ZOln5+8m4ufOP2OOkMXischoIFybz9SDyCAyrWBDicEU/VEihJgTF0LIAVIzGpx0KGtmQ2ibolmr+/MAxKVQVnN9Eosjz
X-Exchange-RoutingPolicyChecked:
	3g8h1tqhzLHwyIuDb887kcg/Yi+OWm2O7KUxmfG1ksDxoZ6kCA3yaiChWMwKKCUhz+6kLzMSO1FY5i/ypLsWrMDeG1X1gTDXeVk12/NKysvYvvHqRLFMlsBqysGxMwxeMi6Vwtv4ADe2vlEKPlrV5gtG37FwFm6kUWkz3hnUJTTbGL0j4ydVNQX4Tu/lFmxxxOf6v5MXt+OmjD9EFQ1zASTuWP4JlXAUMGwrNR5rtqB5vFsTgLOYrIjG1DY0DSXPFGiJSdp5HyRtQi5zE1KkB+i0gxZA+2u2vMpQEdiHSiFtr19JMFO1fukLCwWcWHfFqqPt62Dlze5hPdnFU1lBBw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:38.1279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 393289b7-a65f-4963-4573-08df3ce93e6a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6519
X-Proofpoint-GUID: hLUT9Khs2gW8yoEgSkbH9Zob-Y5YJivY
X-Proofpoint-ORIG-GUID: hLUT9Khs2gW8yoEgSkbH9Zob-Y5YJivY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX1AFL+Sf/k+o7
 Diw1oddH9N24l64cBZrPeFY/fzEJVY/nR2GGqYwtz16/ZHUXz6k4g6yjpAIaC59sitrLAxRmPCK
 MTX5+8nEJ6p9s6o/MAM3oNS/h7qpUb8=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cd0 cx=c_pps
 a=aFbGVCYh9COm6MyaDWiF6Q==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX4M7IhxmCjgNq
 RrdUZ1SdALv2543AJPL6EpO2g7z/ITMtYnzoe0DI52R02j8snO03qAuCh5xhRNBGJqXeyjiT7bD
 LvptU7ozHd6qa2oVkMxZzUJgPzwBWHFzG26uhHIRWxWS9SVNTQ+8eMSmub9fvUTt+v8ehnhOR7l
 Gr9vn4qHejHHRvr25nAiP40yO8XeKs6NuQRpliUFQsSscRdIquXtSlkT5xI4GTvri89TKQwzMDU
 zywx++E/6hqVg37v0AZXHx4+pW1tzzXXgX7m7xrn7hnmdSE5yjdH7c5O/WzD+EjayyDTGse/z8P
 2Ff6ctmxrnJPyrz2HrVPhFki5J5M5oSWubeJ2QmnOshoBsygthXzAsiLl56M31uRnxb6T14fOR/
 IVr9wPqzotZq6AivyYfOTezhJKxnbwaaPHkWsHAC+RtmbVZ2yxgEmOPMlfDHeY42vMqdl2pENEE
 2BrvTib+32zoYr9LzqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 1a37150496ae8..ef053264a5541 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index cc20538ad6f36..f1b0396b322a0 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -108,15 +108,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

