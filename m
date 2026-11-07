Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067629;
	b=a9IpUh8yZXiuAbNRmRy5K2TqICGaKQvBOBBwOPhe52XcGySYWUgQNhdJk8vFCNPyAJoK
	 XoukIkZYlQWDVR+USS61tZBR2yC6VQkV8tzp9r8xlfveL3o6JgnX43hzT648cwE4E8lCB
	 lffSauOMwqrODq8w1IejQtf0qmrkv8lU71OBaVIzHIkugUe2BAEdmKpwcV5JR88Uscv2F
	 OyXBpyLDMJpL3ntLs80KeJ3FfnZ1Q4QT/8MZ6wvs79zbGMdh1mbUZw2F+OEYdXG5x9CfO
	 UbQRHyJa1RWKgyYsCTzkX2oYaByiwrIe2VMLDOPP2STQryklLscfFBRN5q5kbCzxRXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067629;
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
	bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
	b=05J7WldIj/TldKqTb8sLqNLJ8zDPLUI1zyaEQA57K5MqFWiZWWcPOgdyoTDpb2T6XdQD
	 e2X88VE7feEO7orwuPJDVL/UwEA48xBEweXHlZEkRqWad3Cje0jC8BFM6AEHbobQTRjZX
	 T0WDVLWZad1ZVIRzQFAtMZSGIa4vco0XND+q+7G2u1Lsmc4nWucxqMv7RNWwJX65HLGcn
	 6louraRSxqe6XoZqRPYcyePsO1a5iyAxJ3kNSFK7PS4u4cGKoPnZO7IgW+YszS+GEosnp
	 0kF1FnrghsFJRdWTdzhd7WRVLqLUuFtbZ/caX+orgzFUZr6HS1g0mcs7sY6qIXI1SSw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=EFHAyB1y;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=CWcHbIoe;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C3F606A32D;
	Sat,  7 Nov 2026 16:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1C3F606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=EFHAyB1y;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=CWcHbIoe
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExqOb3866418;
	Sat, 7 Nov 2026 10:07:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdam
	Sw=; b=EFHAyB1yPbLFyu4NzLMe9/YohfADAU/lwOLzlRPyUG7ZVp8OecO8/wQdM
	X0ng9BBPj4xz+L4yTHCLbesjDWDWo2woZByAgXbojtsqUEB9GX2uT6qO/LMcWvqt
	8zGD8BBv6RmiqZCE4/UMUS0Jh5BO0+1JZ8/tMoc9FJS8Msz5S3XgT6N1RT+RE0nF
	GKp4Qf2LodVw8d8O1XFRHAUub+xjkGHcTH0fA3NzJJv8SSEIZawx2lX6kX4lieri
	SljMu+nH6WyRLSKMd9uyHKhp9JHsKzZJ7dS/IWJsQwVZTlZZ6CTsAoUfzSgJHNOs
	Bm2KKj/DZ5SRB30DR5tghbKX+H5NQ==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010070.outbound.protection.outlook.com [52.101.201.70])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmj058-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:04 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWSeQ2TmFghdN/kIJMzXWAU1/EYejCYbxaslJ9O/op1PjzVbNaVQdtjmxe0uDQ066qR+vruOVkRX9QlOIWCRGwqw+O7GqbSt9Axun6LxSYUBfMsUSDpgqFzy6r7YDQ0dm7hrQYGFXIoD99gROfarGdRPwq+KjoYCcGj/vNadjj0tXDu0Ux55gMfF6QC6k4nzjQxt9wSABsVeco8tkTGN1wMGOObXvr7sQvu/bxiRA3XeofHoUP+t8IXV8tMBqDls5wwwLXLW6+x8Jla1R12xLByTqPy9Ylz9/bPHeEMqRNeu89TTauEMRnNIZtD/AoZtx2hMc+M5Q+4wVEN0km97iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=LfThNhVwcPzLVFctguN/T+3lIiOp9RwV8O0WZoB8kJet5g76Ucu0GKl4OKeb498SnY+gGLd8rqkj5kjRub62YWYyqK+Vb3JGkrQNQeGGMJYGtepf2xdrZ+raFuxJQcKaSEdfPXs3jKHpObPF3tgWcheuL0U1EF6ucqw7R+skjdF/SYm+6EfeC+xsQXj+4Z/mmlL+uq5eztqvpSEY7Hj+hb5qoSGrpBe2UhPwQ14Ixc890COwtrzAKtlb9HBY9WauaMG0TIhHSVQmB+CKqlxk/l3gWm6bzWkg7ZuLr/MiwRuzDI/TmplbR3iGVNR5bidWUFgzZrDLTdPcamVAajKw0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=CWcHbIoe0VaDBCzTqZyBuhUxLBZgBqyWotuUMNbzJCZAYLwwP36v6IhRj9ktvSnsxQ2sMvHmNA7TzT/W2QEUIfMrPsRpmQKtxflnviUEPAlD22RrVmwNu5Ev76bXOA75pcMJCIbl2UhpVedq6NF10C3nlYcpnURsxxVC2l/S930=
Received: from BN9PR03CA0849.namprd03.prod.outlook.com (2603:10b6:408:13d::14)
 by CH0PR10MB4905.namprd10.prod.outlook.com (2603:10b6:610:ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Sat, 7 Nov 2026
 16:07:00 +0000
Received: from MN7PEPF0000014D.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::7c) by BN9PR03CA0849.outlook.office365.com
 (2603:10b6:408:13d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 MN7PEPF0000014D.mail.protection.outlook.com (10.167.254.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:06:59 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:52 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:52 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:06:52 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6oJM3459524;
	Sat, 7 Nov 2026 10:06:51 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Sat, 7 Nov 2026 21:36:17 +0530
Message-ID: <20261107160631.2592763-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014D:EE_|CH0PR10MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: f926ce34-c4db-4f59-c2d7-08df3ce92740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|261026140227099003|56012099006|261021121427099003|261026121527099003|261022105027099003|261021123027099003|261009223027099003|261028144727099003|261102123227099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Jg7AwllmA+TbuH2rj/lEKCiE9f9uDuwZ5En1rjX3m9xh2ToBK4dQO+T+xtqGkPUvi6SxfncYwcFrq2qJlMQQrbnYQnhH555TyTr5f6y/QvyGTb92wdKjA77PBfG1DCw5plmWhvwfuneW2HnVXHu0Wi9VvNtHCe5czP0ewv9GvOPdXe2VbXXcs9KG1MBMDFOCSQDFrcNH6TZLK8fs8XT7O48jHX16XVmUViX9dM3DI+1YCKDjE+3jjoxBZqk1u9WTtOf+9s/+kh6rhM3s4cqSsUyEZJ9Qjo0ZX4xQZiW72FmeDY+V2PbqYHBfYAPyxd8LNZoLZq8tYPbxxzjufruKYRBk+eYexem2oJ2ri7j2n+q0oUwZOCLh25KATuQUSOJLk0x6d9c4V0Hbbv2O/FYNfZfevcyavIMeLg0FQkKS6RafjJWb4By3A/LC4mwVY1v597Y9/D0BMJUCKDpoep5oUwzKx8YGbH3e1riUuCAXH9w2YyX3VOgCgoQZbZtPmDvMGBN9+GIHnEZOcfk2aTSW329+6trEOouZ8skDkksC1SoRY+YkCMETT9MoSUZ0854gMLevOGmoHELQ7mjvc3bfo0sjNYb+l8UV/VNsnJL4NTfFNBlNSMuDJS+Br5HYmjwCerIBomuC9x1m9ge+/tizfC7H8LZzt/JGLCQxSUuYSVLLWDQcOMYZfEy+BGNRtB9eFOgIeXu/4jvmvXpOiMZdJQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(261026140227099003)(56012099006)(261021121427099003)(261026121527099003)(261022105027099003)(261021123027099003)(261009223027099003)(261028144727099003)(261102123227099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tNk4WwXjX87AmhnScnk1F4kgcLG8nQQe2UIiK5/2nlvE3iL0nGEPMT9uboki2iCuIfO9dexTFXJmyo5kW6b4yH0o6lLJt7TH6VHksIie8cRQc/NJoyNQX6FAk8mezveaaTrk6TlzSPvkXNDvBOgB+KoixIzJAQGbaZL4QM2W1LDiFMBHABy6p9rJpSeopOQNJbLpQ4lC5quAuLB/EB/rTAEk9Egb95WryUzT7fcjsRe2PxgrX8P2q5Obqkr3llvNluE016/3ugCcq5ncta9oHQoAp6IgqOwVSF57moY+nieYlPvsoUw3IU1jNtZJ8wfKcJZvFbzVXQhN9Xjxlyl/9nrr86MJlT+T6ZDmP601V7NFQO4TF91sr+tTfWqK6//UUpJXOliMf/rV6y4mjuiWDm19lKJsREu20Utnq29/hAGKVE7vuNPGDTnPEDh4Pb7g
X-Exchange-RoutingPolicyChecked:
	wMQLDhLUxRxHWxeieINKtQcEleqfQ6/XrtpfFl5QEglKTgfq+eTq/loQmQrooUNqrccScuXWNSzdqjBHgNzOhhtY0g9kjWpbHwLozivatWteoMPthf1FpbnZtqu81wjmU9qicLx9Kcz86+a/rPQC9CqhEO5lc4H0kSWKMH2lAfCnyxrYYrbraSIeGRmiKnQOlX6C4AKjSewCioDpg0iVqDCzLgV3PUNeDTL7iAUsT6wX3rbAqT4KRHv+AfUGgP7EZ27hIp6ftZ7/QiHI5W8YcfJQWtcpdIohn4qTc3GhiLIQg47WZPMWB7LfSBVI5alw9qLGpEeJvHA6IUevI/lXsA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:06:59.2342
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f926ce34-c4db-4f59-c2d7-08df3ce92740
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4905
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef4ca8 cx=c_pps
 a=RGUNHxVObgwraRyadLFC+w==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=XwTwKUqyhKWgmV1Ix0UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX+HpQOAwLOyAH
 Pll/RbooYlV2Vnmb/LdYXppGuBtY680o4cLZXLwCEftCOfigH2S4OSEQK9xYGto2/GhVBlOsL+/
 pJbaJvU6TSaWM4+FHg4wsMq6jVAxHickmoo7HbODvCry9fGe1DZjJ6QFIHZ5DgJH4qT2mkn2MJZ
 +Ll9ZgUDVEsSGi12EYCWb7XOgQvCMgB5XZSkPw4D86iA5Lq/DmGztgG1g3TtZdKHUXhsTedceaG
 CQi9dycQf2B0P9I4RefDJPoQpZ6VW4AUJTtW1PVAdwPqD8/IYE8OTGQp4lXFmUagRrV1Qw3H7iG
 4dnQxaiNiITmZscTdUwz0ztAOsnBA18UBDKV8afjiFooDyFOSCKiNlPcUMSZe8CTBql+XiIG3UI
 hLG1tWW6KDnH8NxNboWqP/5xAjA65bIjLsALtdI5tX8BnE9CS1bWJL4aJKBI5EwkxU6buSpL6cU
 wXxk0zq2Exp82C57FRg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX8Gq9WEzglOgh
 XZO4NtwMMI7XQGY5MU4tBplm0xHFgW/aga3US7BBrAcqJJm3bhOzcyH9Qw4klTwOsC9DbICRGev
 FuDsz3ARj07dAxTH3ZrNHZKkqYvJmec=
X-Proofpoint-ORIG-GUID: 2_uw-cO7mNX0t-Gw1gQU5PGcT2c3LxDo
X-Proofpoint-GUID: 2_uw-cO7mNX0t-Gw1gQU5PGcT2c3LxDo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

While we're here, also change the order in probe to add device to the
global list after all the fields in the dev_data are initialized. So
that a concurrent TFM allocation does not occur and try to fetch
uninitialized fields.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cb4b8b38a5ec8..a7d3831f2f9cb 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -152,15 +152,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
-	platform_set_drvdata(pdev, dev_data);
-
-	spin_lock(&dthe_dev_list.lock);
-	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
-
 	ret = dthe_dma_init(dev_data);
 	if (ret)
-		goto probe_dma_err;
+		return ret;
 
 	dev_data->engine = crypto_engine_alloc_init(dev, 1);
 	if (!dev_data->engine) {
@@ -174,24 +168,29 @@ static int dthe_probe(struct platform_device *pdev)
 		goto probe_engine_start_err;
 	}
 
+	spin_lock_bh(&dthe_dev_list.lock);
+	platform_set_drvdata(pdev, dev_data);
+	list_add(&dev_data->list, &dthe_dev_list.dev_list);
+	spin_unlock_bh(&dthe_dev_list.lock);
+
 	ret = dthe_register_algs();
 	if (ret) {
 		dev_err(dev, "Failed to register algs\n");
-		goto probe_engine_start_err;
+		goto probe_register_algs_err;
 	}
 
 	return 0;
 
+probe_register_algs_err:
+	spin_lock_bh(&dthe_dev_list.lock);
+	list_del(&dev_data->list);
+	spin_unlock_bh(&dthe_dev_list.lock);
 probe_engine_start_err:
 	crypto_engine_exit(dev_data->engine);
 probe_engine_err:
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
 	dma_release_channel(dev_data->dma_sha_tx);
-probe_dma_err:
-	spin_lock(&dthe_dev_list.lock);
-	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
 
 	return ret;
 }
@@ -200,9 +199,9 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
-- 
2.34.1

