Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063465;
	b=i4xMjg2DQc2/eV1VUIKHwWXfIOQN1DbRqRAm+yGCOmqLk+OnHh9diU8Zfev2WMBUyUal
	 vfQlM9LMch/96U8zoFkHvMqeHmO4RlIcxAZlEufdoopvESV0kBFyImOx0T1icu0h70e5l
	 14cMqqlHIBJ3Z4W7eFxs2k3E4WJET7cLRUNE0vUPwtm1exeucNSIUzbBx0baixTJmWiFu
	 KNYqkaWAj6p/HWMF5h8DR++OEbnfisZ6MzCCbpa9DkKlxO/kTXeLF5E7aMTf0WKmvzL7l
	 vHq/jFI7GfTBiP3pyJKMNc67zBsbYWfET/00QR29Zx9pvG7bGHlsTL05cHM88fGbfaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063465;
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
	bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
	b=Y0eiHqVx8IijWPGiQTbYzU4CgrwomEYNDKO0pvTO6F9b1AZyGxm7hf3DuP22lHqwDvBX
	 waIn4oaIcgpBorehfcm5vGBEi8t46pfdk3vTUtg0HHCGtXKPz9Mi2H8vAoqRrr0rA5JU9
	 ILdWb5j8+pD6pGVcj6yPz5pXB9lVlhlwq4+RbgIf5e01Yul/qoJ+46UfATUAwVjDkiZDM
	 fvm41Is3qamA9cnp6ReD3nDe3jKEw8Z62kTV7pOJ3NTvpUx1hYbIPnZEhu67EZO6w8tNI
	 E3refyOvnynvRKgZH2cu8zFWN8/2rIB1vonFno6GWWim2yeEzo8jB7391AGKFl69AEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="j/IO59F8";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=f9kSVLo9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B26082BED;
	Sat,  7 Nov 2026 14:57:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E05B26082BED
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=j/IO59F8;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=f9kSVLo9
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwUke2005520;
	Sat, 7 Nov 2026 08:57:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=j/IO59F8dqUmkBCTw3BAG1cKTCB2T5Mwm+I9Mo8ZjLcaNWaQ8keTuSoqW
	BARJrzbvODka6+vsPTep+OcdNahaohs7i2Q9tyvPlW/+daq2a7isJ30Ir08gTXXo
	kk4OVBsOcSA9PZgNOlXiHaD+Pd2Bg+8PIXEWcui1ZB8v1eq+3FPAaz+OvwovcETP
	Il87L8fUPgZNNYNjMLqZeQHsW7GXnJ/iwW7/CvqLvVh1gRdL/OTxgVP/zrBIyHe4
	RnWHlaM/yvGU6nANA22KJeNJWvaR1+v/wj9HJF0kVfNtjI8+FwiXyMBwViZxq42c
	4iQATbjkeA4cCyy8mUkd+QxIpGvUA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3t5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:42 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJ5Ajoxqra766mUbLieYZJFFXwW4ORN+oj0nPO4i2z9j0vTxMQOBvOBAgIw1x9SqY6ZQeYN4Q0gcydqBN36juypvAwTLLmXCQ39s6eR6IzsZRCtP82ROwQRmmnVtRK6AtntEXUtvfLt98EMQNPH1fhos93rMRPsvFZeFKauA6vYyu5BIuekcnEs1hdm1pec0aN62dPT5+GOg4y8o9r4jP0bi7xn/9AufVLgINhENffyk0Ux0wuDpF5gs+BbQaPD+kFsfwBN7jHIlXurxK8vgJMp6xgFRTrSwGiwz5ef/97D+HaSj2qZyw7tZkFEpTZFjFQoXHjNBSv2A/ySqUrJeuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=Ss/T92cNaVXQN0rXWL4llbmzb48LlmRSYiBP5h94QJY05Ak3xw+zK5v+oQgHqxJQcvIxWHzIksOKIrz9S04+icV8EM2tmGN0HQLHXVLaYKwQQjBxeplERXzMze+T9t43RqBPwE8KZdDGAvVu8weBnGQ/K6qEFl2E9miINHqPb85NB73UioHd6Bz+W8dkwCv6R1z3m/8FE9zXHQ7ljHFaz3UyVmtv194Cni59xj0RoF/rkS5mx8bLNCEWKMQUQGjpp+OVxXVPMZASoYwQ4ZEJgxlVrWbsqWzi755f7Yyw388o1BCk4FWg0Td6ZQg+eeKf99gKQtyg0AAysMWU/Z7Ihw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=f9kSVLo9rYT1TwFPt4Z9bnabifd5p6VCzsjkfMPxuh8tsZAYkCgTOZfa28EowAeGgJLf9X4KgBbFxl3YEHjRVCQ2JChhdjXRljkxBGTf3NbtXazLLyI3TWAbcgh2veRtKdCuLsDSFgfw+yLfZrDvQ49HXc/Kh0OMReDDRNutayE=
Received: from SJ0PR03CA0286.namprd03.prod.outlook.com (2603:10b6:a03:39e::21)
 by BL3PR10MB6257.namprd10.prod.outlook.com (2603:10b6:208:38c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Sat, 7 Nov
 2026 14:57:36 +0000
Received: from BY1PEPF00026959.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::38) by SJ0PR03CA0286.outlook.office365.com
 (2603:10b6:a03:39e::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BY1PEPF00026959.mail.protection.outlook.com (10.167.244.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:57:34 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:10 -0600
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:10 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:10 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Ev97r3374056;
	Sat, 7 Nov 2026 08:57:09 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Sat, 7 Nov 2026 20:26:15 +0530
Message-ID: <20261107145618.2349562-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026959:EE_|BL3PR10MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: ceda4e0d-28d1-469b-2d19-08df3cdf74d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|261026140227099003|22082099003|18002099003|10067099003|261102123227099003|261028144727099003|56012099006|261022075727099003|261021121427099003|261022105027099003|261009223027099003|261021123027099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	KiRxEqrBD6s8PRIrR80IcPTXAZt7EQMZvrrRC+OaZDzMk4gsJgu6KF3bfXEiy0ePQav4U+AAoY7pgNQuj22uAbE269e1GY+0WkeoyXo6pgEDJFOJb+NOkJMF5j/fpzrTFwZhN3fLDciJHKlLEPM4hBsDsrQA6My7fkDufQS7zykkyf9A5qhD60OeH/SdpHJ2SeqZctsgjEHHyScf5LI+dMqkQPbaicn85TKrWPULq3tQQavcyHo8SNQSmy71646T5A9lauJHs3DKMLv8yLsAeh6GTULkT8O2qs1j9j6r41cMyQzbPMUvg8W3HpeVo+pIk8zyXns9XbYTGd2uBgnntOpb0VeHHCJ+QEO9CZQyirIJGwK3kYqvU4BWGgwdplkvQcqLH4ZlK9C8EIVbiNLIkFkglBxAoTFRF+9RuVXA+1QFMNBhEBkrtdH8Sl54voJlw13/3xeFfZJx9fDyRppbU7TNY6Z0JXS89aVulmU78s6OdVWnXfN8mC6inWKLYobzJgRvbz9RLvfpYfSQ1b9TGTJLJ47Qi6OqyxxTHnbBkb51ms3m1i/Yj2FvwaMHfHWxyMbDrNM4axTunLR+HSjVqFbhozl4iSUoct9JoyNc0/AZXKCCp16ulg+SASIMdIq6HwetogCCXVKmw2X2P+zNXpFzbqvNDs7QcfqH4V5md+vYRZwX7xl5ZAqwCAY2JZfA0pf7qC33b3oUFvXme+z1YA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(261026140227099003)(22082099003)(18002099003)(10067099003)(261102123227099003)(261028144727099003)(56012099006)(261022075727099003)(261021121427099003)(261022105027099003)(261009223027099003)(261021123027099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CczAEX7nky8yOJdlnJDWJcgBs96f8U7q5AgZhZQw60RpCymKKn/emIrj5u7ltYqtfc6TRSwy1u/vjAJHP0prhPYE24pWAWXbdTDnYTF5Xpe1AZCJYBbhDD/ZsRh2SXlqmJv7/ts/dN9mEKhrJQkc7ci1tmacytU5F3CLIyOPOXCtQ499PkmNMsmF2J/0YepjYRG7wV3YTijO8ZbGOKE6FyZ5zXuLIY5S+Nz790QzuUm22ohSbAYqM0p9sN52+Ia7rp8OkQNZnogGAqNjmfYRfDYHf4fsEwgK8KhozJg71QOuoQW0oPKpXUWmAWPUcbg75rILSlrRLnGvOqU6Jr0TqmVw04YYDwUhVcrkXeAaaGlfYV0gDdLQwy7egHZyfaOv4ATfTlNdFj878C7ncOPY9l3Tea3cWUXTa40KnioyILbpmbYbyS4jy+tgWKidLtwq
X-Exchange-RoutingPolicyChecked:
	4seCOMeOTwsaO0xg5z2Q03jzrRpTDI11X/YcxwjqTApC4nOJJDymrnlZmS/2tJgj/N7tB51VIJNLhbFy+gAtu0awJx7kbU5GMp/suHZnoL4EbOolLwFq/RGLtHiGwK42ZiWZ1s1sUC+X0xYPplIdxqPRzl1JE1uVRiz4NZ2tw/SG1PPryu/qqJsOpr/8OCZKbrdt9z7Uj04eBBh2xuXSq++NIANcTSdRopEKoOBvwQ7ELf44OWql9VnLaAZVhGFGzRaDLDASvbHY6vDnUY4ho+T49UCYm3ha1CcyTkxITG9i1wWRkzvbjIclGhjT7bO1Qwsqp/slUrEzdpxkKXGYlw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:34.3936
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ceda4e0d-28d1-469b-2d19-08df3cdf74d3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026959.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6257
X-Proofpoint-GUID: DtO5gYaaTW1xm64kn2NXLaIkFeYMfVTE
X-Proofpoint-ORIG-GUID: DtO5gYaaTW1xm64kn2NXLaIkFeYMfVTE
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXy28UGYop+GoZ
 qLtqaKq1nbXRnAKHQVdeXwBOWMTxkcjWJ1ayiDUuoJLxPL4s0Ovb88XVngDCXIsycbIhzovRF50
 ua9cx0oJrmoOhy42QaTM2fVNli7og8I=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3c66 cx=c_pps
 a=vtur6dA+JiXx+GD1nKNobw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX618JtnJz8bri
 Mx2AqitV1x7J1fvJeh0nDdXwnfudPq4YBuPpZBkirl9NrpsyBObhMGnlwLnZdSsAa1zm11cA1YZ
 1uCPMOPvjVn2FVSXCHyy00+/XAYzi8dUZXZk3MEVE99+NrGzRMa7Jjs5kiw8TJUFKtpzMLkKP5s
 jEojgdofcTXaYJ+GVFfukYVwl7ifGW7M+ErMz3ZB/lvYfFi5HdBznI7hwKZ/QgOOxwN+uYnnbBK
 dKMtX/Y7IEYZZaUXBjyFb9Xmi0gO+QN9sVzvT/6BPIdyeuWAcnSn+GIR2KgCrrmmCfh8J1bc2M5
 GuwX6REEPB6diCWOHALWvE2c074Q86/fLRz1+f2bzSJXc7ORmoVO/iQIzzud0uu4O2Fppu+gbBt
 Jv60l9yJFr8WIQWaFsgVRCzJ3CyLUOft8EA7KgYnY3HZ3126vL6HshbixLz1V6eq2RlLSzA6Fye
 w0apaDHRPe82yuyD9Ig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ea6e3b246ed1b..bd26c3f438e34 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

