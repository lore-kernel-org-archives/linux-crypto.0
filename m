Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793771182;
	b=pLwr0K1JIHHdZw7nT2+rHchkoUgcC+eEkvPh4gzz/6zACBwIPNFymSFPahRo3uHDhsNB
	 VUKCsKMlE6ftzWAytMmOtvt58hWrgyLeokvKbUA5Lf5O6BMkeUjFIWLaZaxHRmTj56kQx
	 hbS27losvJ4yvqUEjzYewh/HeHQ619WWbkwaoe2bkM/lSiaS7sem3BzzrPOYLQkFFATLw
	 KYL/SItsL1D8OUazyhtJvth8oIJfuKOdYurbZ+ACpOlq+DtVlCYxbpNfbscnRZ7FuYFf2
	 91KhR4YL14Cv4dOxPh6l+ZfkflXlI5bc46J2D+r5hvBmoPYZLPLBBoRds029MR5b+nQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771182;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Gua4xIjXuvkUQCMS1QSBSTZ9g0Yj0x8YhlXA8yWDh14=;
	b=3lTpSjgp6+USv6t5cOtb8qZ42GwS2TylTLJzswT0pBodAx261z7OT+kgdUGLMpYa+Xyl
	 V+KR0s5owL1wETSXwwChBceUv9TkxMBnQrxQw4LJ1nTnQkeHllk0rTi5ydYJfRfoAn0gX
	 T/n9QkEk2rB8un+Z2nvdFMHwzT4C97lIqjONngUsP66M6OjgYUsBwkyUbgNA2Z++lqVmz
	 urFc4FmxlAfQ6ZL+WB1rEFW9+syFJiUZNHVJV05sfvaexlyumfPn2UV0h7BXcaSWvSSD3
	 nKUpxYM8nsK29znXg0dNtERwGs/i1P5BFQf1NGx6JIsOZ8Brkn5oRETcJmMJ3TlsF2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lw2Uk1l+;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UKX1q9Cm;
	arc=fail smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84729606A33D;
	Wed,  4 Nov 2026 05:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84729606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lw2Uk1l+;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UKX1q9Cm
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S0Me2587506;
	Tue, 3 Nov 2026 23:46:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Gua4xIjXuvkUQCMS1QSBSTZ9g0Yj0x8YhlXA8yWDh
	14=; b=lw2Uk1l+wbu8QplJFf+pxLhPL3OTRnn2ADc7GNU/jhgyqSvcWbl6xyMZE
	aGKk1bnwF6R8glLlyU0r/MZSLm6rqVcUyMNrrVA7D9x+DqfQpwKOvR2GU7zwjwrW
	Dctwuf2lVD769WmCPu2axT7VBZmojUMouZMRJF6DPgs30OiLYp3W7PE4dh+AG20v
	rlYDciG3r6RF2YLNWG/fhsRcwUpgFaip10zVo6+uShLQ37m2fvsveBxI72rFMKQE
	P4ncE5zPisP3AtxgZ89NsFusTUKPepRtxNq3HmVdr4T/qjnx+RNOa/vviIoLt2oo
	kySSVGSBFQ7AnhZXtC66ipmTbUajg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010066.outbound.protection.outlook.com [52.101.201.66])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xkr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:18 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgKN0XapkAdeAsv6CZJduv7G+CPsxuV9/Ot5jXF+0n3xUcyU6ku9sdZddxUGszG7f7wrnde0qJmA5HcNq+zvDK6D82TLXAKGVsFd29XeS0B3xoceSQTP5iwXlDOZ7si0K0030DmGbxuovhAtWLqEeIBCUfk7wZtzo7rFoA/o0E49hkS1AKmvFNE+RvcJD/FDelzgSkJ9qwTV3H7cAR1PII9A2fqrh3l/HYpgp3LiKbDmeeyZKEvKdpOtzQS/7iMjTNDo3MDoLazdngrYU1fbcYOZDZpjfzu2wXYPhZYr3QryXMB+MGZ7tG/uPn0L/JsEvRkh04oMlvkh5++Iy8mOUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gua4xIjXuvkUQCMS1QSBSTZ9g0Yj0x8YhlXA8yWDh14=;
 b=xZWvcwNB1bo0lU8FiC3jBFSiFSxB4ce++piUBscU4IK2yTCrn12Vs3oS4gmtXvWR0ibXtLhLxkho4cM4AQcKXrLeNrAbvdErjlob4X03iR4A1xBznzkEQPjr3clVG59kDoDwIoKLubm3oF7xb5XWEEE8s0J18oHQey3KpMZVuI1F8wE+HIKwutU+qApfYEnjZ9WnZwBdLPYxs7IElynrxUoNZQ8071MrYrBCUcohGks4mdus/ySAlKgkmTB4IykTCRbahd4MuqRffhB2bO49hkb7c29T9f4G2ih1Kkc64YCxbPJAfwYAZ0JPBZAafDXxJEU40aBTHzpFRkldVlxDlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gua4xIjXuvkUQCMS1QSBSTZ9g0Yj0x8YhlXA8yWDh14=;
 b=UKX1q9CmTmRt8sAJc5LjMgzZvC07GqqbSpnZJgYCdsFVWabjBPtjhK0GTWxeMLE+1hfbAihg7f3HMTKVLiWfkMAyqsJ+ShD/QGfB/lzq51DkFKnBCEWie5H8ljhg4WumMe3dnajbLRPuYH6a/OUK6nvjZ7WvtIpgT3PBPjmx1IM=
Received: from BN9PR03CA0848.namprd03.prod.outlook.com (2603:10b6:408:13d::13)
 by DM4PR10MB7527.namprd10.prod.outlook.com (2603:10b6:8:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:14 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::14) by BN9PR03CA0848.outlook.office365.com
 (2603:10b6:408:13d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Wed, 4
 Nov 2026 05:46:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:12 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:33 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:33 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:33 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ03521920;
	Tue, 3 Nov 2026 23:45:30 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:29 +0530
Subject: [PATCH v2 19/30] crypto: sa2ul - remove redundant algorithm ID
 fields
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-19-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=8480;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=PXvXR4IYCQnouIsnZPx58nCLdXsMz88tlqAWfJNd++c=;
 b=XwaRQA77HpunLGJx+80NGj/FWxa9J4ikTH4P30AKV3AsYB3Zj/98NA5D/k729HJ54/Yh1dlHS
 1kq81EYnjMZDQja82gjrBx1i461Hl7pLcXWP1PoJ9qHJFfHX4gWp1Gm
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|DM4PR10MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 494ad7c4-dfee-4870-38b0-08df3a36ef24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|6133799003|10067099003|22082099003|18002099003|3023799007|56012099006|261022105027099003|261021121427099003|261102123227099003|261021123027099003|261028144727099003|261022075727099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	NiYMirSVIFYWjrVEVUh9ZV4CVpAx6VDq2oKWsz0qkERmcYtJ+QTZJE6Kn73HVegFtrBrT6YuRbn1D8y42OxXGTzRUnuOqZCpEWVm6tqP7E+7XSbm8iIC+/MQCwoH3HURuU5lXyXpf0SnC/XucyrfZ1AE6QRFWWLRr9N/OVz/NkKmlOcBotmCR+OGhY2khFBC3RlrNq5dykC9xSK9Oia74gB6/+fJng+0wodxtCYnG/RDkrTTPPQ0LU0rD1fUC4cfDtJ5WJkezxctYszUXBT9kMSrDR7dn+qjSS2CrLm11qnxfXZJlxjQDgzqYOx2uB0NCHhoALOYEISJ4Trd2Z9KEmnNVPFYG2vxcRsadPd6M7u5ci6/kpte2qJPscRBU/1PQ/uaLACjVX2g7LeUIimKLzJGVPtSOyCj+eI+VFEwJhOqS7TmjDTK0uzSaDQPQylN/lP+OUBxINE8ttmkF+gd9F0pF2Po5DJIzznip3pvgjhSLCRwCL2mGkabjaJMjVle2jAK2uQaU0UxFJKkS9duvrg20RKaCtwhUcyL1fYQJ+ymE2M6kYktNwW4UzG8pZmqincl1/2ANIE6UR7xq142YE6HjoiV0X3lezixSTJ36/l48TfWlk/YTaadWJ3m6BgRJmgA5/wrycVpc34nTFXv6gMu+Sw5V8XiZnJtJEAwj9uxE9mPVVf/tDYqk48pB9uSm1kYgJ0uy1WsmhWzpkTZNQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(6133799003)(10067099003)(22082099003)(18002099003)(3023799007)(56012099006)(261022105027099003)(261021121427099003)(261102123227099003)(261021123027099003)(261028144727099003)(261022075727099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	A42jQjV9VuH4pzFbnf9bT3cjOUkDYRJj3v80AqfCy62VDRlgoUrzCB0yOlaJmTHA/0gvAhgCp/Q6xblR3YiR0LFlDERVaIW/rUW0vkjVu2GAL6DKD5LXBS25zV3WebEzEFeaKgLOodOY7KfByU7qXJEVGY4slwrApPywA61gJC0rC5NWhm1bhrMz/MOnVVyaPVw7gMQqdRhYO2QU8AzNapiwvxccVpDVS2noui1OfHn56wGNwe8xz+n+nK1qjCWJHco78vMGDI35SjOic2HNnZQIcV0FufRl8WhCrmFcKpWCRzdy/PoMXDP3SczY8wW6iartJmjvOg9NucnPFac6/nqMGkCavGwEO53b14QXi8LPqO+u5JG8G8fDN5bK4bzIlFNOlQTPv5ke1QXTgDHODjLIcQKtfq+q+m0sU08DGhM0Bb1eJO5BWJrtHbHYtv4/
X-Exchange-RoutingPolicyChecked:
	ZYkkrOR519c2hVnqEYaK423gCLuJ9zOJR1NYmeyG6McdqHkMw7DnwPt4CYy9PaSB+BixO0tXwNp82XqMF8o2abzW2LZxP5WZ3u8FhKUShjWNbJsW3ibc4EPKFtpGPWY6DE+7NyM9i1DjbcQxEQvhP1PNYdFtENVgHexyoQW89n88oARJwu9riuZ1oAwYsLXExK7xxEu+wyDL3okItYit6FuvFi7j1UgSfZ2NQbAJ4euOz94JX2k5lFhTeDfSkQM4YciBe+ycYydg/VdxPsoYZaFNQ1U+3/zdhtQ5WqJJPes8muAeJM3wmZbrt+yEMA3xwAp7ZZRCdLsnFOCldgbp6Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:12.3433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 494ad7c4-dfee-4870-38b0-08df3a36ef24
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7527
X-Proofpoint-GUID: eouyZckEfMPjMMYAK3lfwKaQUS_opYNC
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac6aa cx=c_pps
 a=sAaYeWWHS4LdRs88aTULxQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=DQxZnFX1stb8967Vh34A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: eouyZckEfMPjMMYAK3lfwKaQUS_opYNC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX+RIkpOScnc3d
 rnCAr1XNVjQJs4wk+lPExcL6zGrbmdtvnMN2vwqxSmEZ6eO0ra9k0c0nH/Dr7gTH1hDBS4r/632
 trJj0/fZe3r0PIcG3XuQS61WSvfMkfc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX6ZMaguYzS4lC
 n5GAkt2HUFva2PD8VLX1fAv5luBjPFGOg+q6hxrCnNdVLR/p/AQKRdXNszM3NvDsSmSF+HTZ8Yu
 Lql3qEQMlXGAvQcEmLPrZGsx7NzqTZfIz/C2Ms4hdqT9r+TwEdqgNpbSjWDKzgPw1AqjZ+CeSMW
 o2T+eDJQMD+VwO8U3I2PgqIxyfORUj45T1TLPjxgzFTIAKhCNs6DwjyztUNcrO6fJoOcVpoUubD
 +iyRu/7NiLVC0BKFqbcqflchLtZAG6C92PUjpWWysI8osGoEAtQlysNPdYnuPT/kxar1dCeYhs5
 V2FHAHOZUm8iPzRDS/PElWn/W5RF1N3+t9feVVWI+xc/50FswxyC0A4nypEvmYuq9KQWcginvd1
 FDWG/oL1NhxA5a7iCaCVohiolUvMRGIhxGg2ZbyAOYeJUc8EDv1Y1JOWiBeV2NQv/x52d8Fr6iT
 wXiIv6tR3QLwII28Jqw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Use the full digest size to select HMAC-SHA1 or HMAC-SHA256 when
preparing ipad and opad. The size is already populated for the SHA and
AEAD paths, so a separate software algorithm ID is unnecessary.

Keep the digest size unchanged during context setup and round only the
hardware egress length, so SHA1 still selects its 20-byte digest after
both encryption and decryption contexts are prepared.

The encryption algorithm ID and command-label algorithm field are unused,
so remove them and their assignments along with the legacy authentication
and encryption ID enums.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 32 ++++++--------------------------
 drivers/crypto/sa2ul.h | 34 ----------------------------------
 2 files changed, 6 insertions(+), 60 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 2c1d51b1cb88..36f1d13dfe91 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -95,14 +95,12 @@ static struct device *sa_k3_dev;
 
 /**
  * struct sa_cmdl_cfg - Command label configuration descriptor
- * @aalg: authentication algorithm ID
  * @enc_eng_id: Encryption Engine ID supported by the SA hardware
  * @auth_eng_id: Authentication Engine ID
  * @iv_size: Initialization Vector size
  * @enc: True, if this is an encode request
  */
 struct sa_cmdl_cfg {
-	int aalg;
 	u8 enc_eng_id;
 	u8 auth_eng_id;
 	u8 iv_size;
@@ -117,8 +115,6 @@ struct sa_cmdl_cfg {
  * @hash_size: Size of digest
  * @iv_idx: iv index in psdata
  * @iv_out_size: iv out size
- * @ealg_id: Encryption Algorithm ID
- * @aalg_id: Authentication algorithm ID
  * @mci_enc: Mode Control Instruction for Encryption algorithm
  * @mci_dec: Mode Control Instruction for Decryption
  * @inv_key: Whether the encryption algorithm demands key inversion
@@ -131,8 +127,6 @@ struct algo_data {
 	u8 hash_size;
 	u8 iv_idx;
 	u8 iv_out_size;
-	u8 ealg_id;
-	u8 aalg_id;
 	u8 *mci_enc;
 	u8 *mci_dec;
 	bool inv_key;
@@ -377,15 +371,15 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 		struct hmac_sha256_key sha256;
 	} k;
 
-	switch (data->aalg_id) {
-	case SA_AALG_ID_HMAC_SHA1:
+	switch (data->hash_size) {
+	case SHA1_DIGEST_SIZE:
 		hmac_sha1_preparekey(&k.sha1, key, key_sz);
 		cpu_to_be32_array(ipad, k.sha1.istate.h,
 				  ARRAY_SIZE(k.sha1.istate.h));
 		cpu_to_be32_array(opad, k.sha1.ostate.h,
 				  ARRAY_SIZE(k.sha1.ostate.h));
 		break;
-	case SA_AALG_ID_HMAC_SHA2_256:
+	case SHA256_DIGEST_SIZE:
 		hmac_sha256_preparekey(&k.sha256, key, key_sz);
 		cpu_to_be32_array(ipad, k.sha256.key.istate.h,
 				  ARRAY_SIZE(k.sha256.key.istate.h));
@@ -393,8 +387,8 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 				  ARRAY_SIZE(k.sha256.key.ostate.h));
 		break;
 	default:
-		dev_err(sa_k3_dev, "%s: bad aalg_id=%d\n", __func__,
-			data->aalg_id);
+		dev_err(sa_k3_dev, "%s: bad hash_size=%u\n", __func__,
+			data->hash_size);
 		return;
 	}
 
@@ -654,7 +648,6 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 		sc_buf[1] = SA_SCCTL_FE_AUTH_ENC;
 		if (!ad->hash_size)
 			return -EINVAL;
-		ad->hash_size = roundup(ad->hash_size, 8);
 
 	} else if (ad->enc_eng.eng_id && !ad->auth_eng.eng_id) {
 		enc_sc_offset = SA_CTX_PHP_PE_CTX_SZ;
@@ -690,7 +683,7 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	sa_swiz_128(sc_buf, SA_CTX_MAX_SZ);
 
 	sa_set_swinfo(first_engine, ctx->sc_id, ctx->sc_phys, 1, 0,
-		      SA_SW_INFO_FLAG_EVICT, ad->hash_size, swinfo);
+		      SA_SW_INFO_FLAG_EVICT, roundup(ad->hash_size, 8), swinfo);
 
 	sa_dump_sc(sc_buf, ctx->sc_phys);
 
@@ -875,7 +868,6 @@ static int sa_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	ad.mci_enc = mci_cbc_enc_array[key_idx];
 	ad.mci_dec = mci_cbc_dec_array[key_idx];
 	ad.inv_key = true;
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
 	ad.iv_idx = 4;
 	ad.iv_out_size = 16;
 
@@ -895,7 +887,6 @@ static int sa_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	ad.mci_enc = mci_ecb_enc_array[key_idx];
 	ad.mci_dec = mci_ecb_dec_array[key_idx];
 	ad.inv_key = true;
-	ad.ealg_id = SA_EALG_ID_AES_ECB;
 
 	return sa_cipher_setkey(tfm, key, keylen, &ad);
 }
@@ -907,7 +898,6 @@ static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	ad.mci_enc = mci_cbc_3des_enc_array;
 	ad.mci_dec = mci_cbc_3des_dec_array;
-	ad.ealg_id = SA_EALG_ID_3DES_CBC;
 	ad.iv_idx = 6;
 	ad.iv_out_size = 8;
 
@@ -1373,7 +1363,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	ad->auth_eng.sc_size = SA_CTX_AUTH_TYPE2_SZ;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.aalg = ad->aalg_id;
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = 0;
@@ -1508,7 +1497,6 @@ static int sa_sha1_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha1");
 
-	ad.aalg_id = SA_AALG_ID_SHA1;
 	ad.hash_size = SHA1_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA1;
 
@@ -1524,7 +1512,6 @@ static int sa_sha256_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha256");
 
-	ad.aalg_id = SA_AALG_ID_SHA2_256;
 	ad.hash_size = SHA256_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA256;
 
@@ -1540,7 +1527,6 @@ static int sa_sha512_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha512");
 
-	ad.aalg_id = SA_AALG_ID_SHA2_512;
 	ad.hash_size = SHA512_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA512;
 
@@ -1692,11 +1678,9 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	ad->mci_dec = mci_cbc_dec_no_iv_array[key_idx];
 	ad->inv_key = true;
 	ad->keyed_mac = true;
-	ad->ealg_id = SA_EALG_ID_AES_CBC;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.enc = true;
-	cfg.aalg = ad->aalg_id;
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = crypto_aead_ivsize(authenc);
@@ -1750,8 +1734,6 @@ static int sa_aead_cbc_sha1_setkey(struct crypto_aead *authenc,
 {
 	struct algo_data ad = { 0 };
 
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
-	ad.aalg_id = SA_AALG_ID_HMAC_SHA1;
 	ad.hash_size = SHA1_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA1;
 
@@ -1763,8 +1745,6 @@ static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
 {
 	struct algo_data ad = { 0 };
 
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
-	ad.aalg_id = SA_AALG_ID_HMAC_SHA2_256;
 	ad.hash_size = SHA256_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA256;
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index ecd8f09faf59..ea86199b6231 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -277,40 +277,6 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
-/* Encryption algorithms */
-enum sa_ealg_id {
-	SA_EALG_ID_NONE = 0,        /* No encryption */
-	SA_EALG_ID_NULL,            /* NULL encryption */
-	SA_EALG_ID_AES_CTR,         /* AES Counter mode */
-	SA_EALG_ID_AES_F8,          /* AES F8 mode */
-	SA_EALG_ID_AES_CBC,         /* AES CBC mode */
-	SA_EALG_ID_DES_CBC,         /* DES CBC mode */
-	SA_EALG_ID_3DES_CBC,        /* 3DES CBC mode */
-	SA_EALG_ID_CCM,             /* Counter with CBC-MAC mode */
-	SA_EALG_ID_GCM,             /* Galois Counter mode */
-	SA_EALG_ID_AES_ECB,
-	SA_EALG_ID_LAST
-};
-
-/* Authentication algorithms */
-enum sa_aalg_id {
-	SA_AALG_ID_NONE = 0,      /* No Authentication  */
-	SA_AALG_ID_NULL = SA_EALG_ID_LAST, /* NULL Authentication  */
-	SA_AALG_ID_MD5,           /* MD5 mode */
-	SA_AALG_ID_SHA1,          /* SHA1 mode */
-	SA_AALG_ID_SHA2_224,      /* 224-bit SHA2 mode */
-	SA_AALG_ID_SHA2_256,      /* 256-bit SHA2 mode */
-	SA_AALG_ID_SHA2_512,      /* 512-bit SHA2 mode */
-	SA_AALG_ID_HMAC_MD5,      /* HMAC with MD5 mode */
-	SA_AALG_ID_HMAC_SHA1,     /* HMAC with SHA1 mode */
-	SA_AALG_ID_HMAC_SHA2_224, /* HMAC with 224-bit SHA2 mode */
-	SA_AALG_ID_HMAC_SHA2_256, /* HMAC with 256-bit SHA2 mode */
-	SA_AALG_ID_GMAC,          /* Galois Message Auth. Code mode */
-	SA_AALG_ID_CMAC,          /* Cipher-based Mes. Auth. Code mode */
-	SA_AALG_ID_CBC_MAC,       /* Cipher Block Chaining */
-	SA_AALG_ID_AES_XCBC       /* AES Extended Cipher Block Chaining */
-};
-
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

