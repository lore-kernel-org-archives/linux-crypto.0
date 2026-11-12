Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471185;
	b=4Kb/CsNsbzqWtUPe9s0QN24RTZA4tjYJMJ/ytNqV4yYIPJKaN2ubef6f5odOPzjUwIOG
	 ekqJiiI2yiJzWX54XyZbvftm+kKvxYgIkDw8Mi0/8BeunQo2i40im7lpIQ4LMiC28qT5U
	 vvrmvTcLT39FF+uCy7nxsv+kWQw0wl6KTR7LKbcKGCkJu21acUNYpox23i1tCIWqAETUG
	 j/ip+UkDETSW8+lxfvOCiOYJ23gwiXLbX1ZxMoMfEdYD89XuS4V+J75gfQQ1DGpe8z44S
	 E0gbZGIudn0xSsVXpeyCT6Imv5760BqREWcsjzcS9f8VwXPMNlSuVh8XgXVqMZSICVw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471185;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
	b=VIJuxCX6YA0aDAytppWizKeF1GOOWby0BPYQgcweMAXv18Ol1IFQBgi67wA2a9m16v37
	 vWdYdSeJs/Mj4bEitquw6q4lPAO9MOiHPcHsSoYK8Hb01OCiijTuut2EUoqSKiwd6xOqM
	 EnXZkRhUndVlm+aArUeXlq8Y4ZwZejBrpNxRoFqcvhWxtSx6ELh5UaRDlNTJqKUfg6hnS
	 W2+bRjkwlYmA8duIWr+pRLDUJgwcyPu83Gm18jOk2gYaMvOqB5qBFstZUNSXQ4QBS+okp
	 6MzWvdDIrB3UWPSYxAbGS/NfptFK8/+Z1EDlnQ9zodjlyepRBtvZ0T5neAZBGjXBRDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=GsHOZ3Ay;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=g+RcRudt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4279360A2629;
	Thu, 12 Nov 2026 08:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4279360A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=GsHOZ3Ay;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=g+RcRudt
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7oP8l2308560;
	Thu, 12 Nov 2026 02:13:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5t
	zg=; b=GsHOZ3Ay2ElpUng1DadBRLW3YPsRiwEWBsuMz7qmEL9HxFKXmoyY7j1+x
	Ydh2IlPyANzwxD5vtslVEHmTtwUgxW/B6yTpD8JFglQMWrqb1IDEgAMwIOsgH56d
	KOazHGuNR/AQ4Nl2EvkK0VvzXJf4LJBnH1ZEAllr8PTmgdYIXYXzJA4wBFAbEsSG
	eoWVj2dUc/9850j9IyCGgQVC1WH7MWb7i5plWS+KLdJce/inIMg8qt1GhvVlNSKW
	cS9yMJ9Mde3egFI1K4szCMhRl8HINaSGXs9PbbpMKob4ZDsLFu4fxOstt0PAmX+W
	QAaKHZIjWfXmi+D2JhgARX/H/YJeA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hvvr6vfea-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:01 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MZ/jyuW+d1Pe2G9A74Q8/IM4UdUTsC10OAWFI3Z3AmGB7ZevRHB+5Xw4Z2jnwrlO5bhjVl0dzUSgn4rf26rucaD7GwpgOQ8CVLe9y1ZCukBzCaru/4KEU2SXtlm/A40OPChGcMh+uCnC+k/yJu0d+GjWFug7ayin+npTNStTWlXJViDRIa7dHKOK3vGCEPcl/snb9oEx8xw0LWP9ziWa6q5hfxZ/ElXmTulIBCwSAJthoFdJyC9+nARt+jHvMQ+oRqzqFvwgDYMITLkJewdg2FRI7Y0Xg1TWK5O0ojqXpNIkidxC+NO2nJHmXuwvdLLo+fPsfW1ZcbQxhJnR47yj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=nzKHiZQUgRokNkRviDNrSdgZmEEUfdtUAczzOsA6ZgRCiGybWG5SOrrlOdzkb+JkUZiFJo1ekCq6hmKETTP3z0fQM31UnPyiqA9nZaBYN/DQhvIF9irtnw2veq9IfBDKIhRtCiuoR1g8dJyR/KC0XTumnFrBkMZeS8lAv4O/phemBvWg/FOPGJw6YOMRbbKa/yqtXkho9qJdU69p5XQkk3rXk2NxU9dBESB0r7uLO5RCgWyAy31BaOUw5YJL449f0PIaTHiCdVURAJxL3LDr69uhJQYQjZ8KYM6JhWx25rmKyPEBJ3X7o3uYuSMAed73sRpUzmJV5xz79e9p3uZ32g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdr1sxsSWfErkbdpkpjqc22HIHrIyzwqIDBJo0L5tzg=;
 b=g+RcRudtr3jdJj+tzuwwG40bipAod2qGrEhVkWP27YRPD6L/aZxhoMMWG3sHMsseS6P6bY3CTskSR5Wues88N/fkrzk1/3kB4jNZRvBa8RtBSyrJ2mgZPD8CaUiZHI3/OZ63INjMLZWCWgUAEVTEFcAS0/iZA+xebXIzswjD6+4=
Received: from CYXPR02CA0078.namprd02.prod.outlook.com (2603:10b6:930:ce::16)
 by PH3PPF7FF16ABD6.namprd10.prod.outlook.com (2603:10b6:518:1::7b0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 12 Nov
 2026 08:12:59 +0000
Received: from SN1PEPF000397B4.namprd05.prod.outlook.com
 (2603:10b6:930:ce:cafe::78) by CYXPR02CA0078.outlook.office365.com
 (2603:10b6:930:ce::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397B4.mail.protection.outlook.com (10.167.248.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:58 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:28 -0600
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:28 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:28 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CQiR472233;
	Thu, 12 Nov 2026 02:12:27 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 12 Nov 2026 13:41:51 +0530
Message-ID: <20261112081204.1146395-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B4:EE_|PH3PPF7FF16ABD6:EE_
X-MS-Office365-Filtering-Correlation-Id: 94067256-de17-4698-35b0-08df4094c307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|376014|82310400026|261021121427099003|261022105027099003|261021123027099003|261026140227099003|56012099006|261102123227099003|261028144727099003|10067099003|18002099003|261009223027099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HOXsiceC3klFeo8D+T5qB57kZSLiQn6LHegoiy4x0rV7m6c68iGKcEG7dr8mjyGT/dknSD7MnsuR1n1ZCxBTdI93UiMqV1xrZ47XH+X2NoSf/HmNs7s5eotfTpJRrP0sTVy7K7Sljzjn4jYA0U0KYeSEpl/9FGnQHFj3W8hW6Zz/C5cv7AbvR4Zwkr6nXhK85Gy1mzh9DlKIjGmxjrIuVb11QEwQwy2NP3clVhOkPOULeXjMCfWZMPy7JNLD3dDCq0sDYd4dMh42cgUkCABPXOf+MRxoc4Ls9oShS5QDq/neFGEToBB4sM8ocgF3oynBc6RcQU9arBnhJGkXlb+h1TNPsbNhwAlQjcwpGKzJvK84jfsEl1cpYuGNmcFsUFfd+7xRoyTwFZ90O705Hy+gYB/Yc6nD1ydoWPwSZmT/XwcXS8461R1qiodZBqYCYU5w2++Dkuwi44EkWmEXHwIE9okNKKxNRhGAOmw7L+If3CMQBD0o2FQxdvGmMiKXTnkPUV7mHiiYdcWAggcos5YSyJwfrPldc0V6480ZC6KvA/H5J0yjP9LsKKK8xtlWEmp+8vaox4I4qpTxbT99A2E9UcKUjQ2d8GaJyXQ/mz8EmYGWs9SLs7mT4gpnNI/Yg8QlnIY/Ycto6UhKGrd4ycjxK4TBrymKQaxaeXw7kLimHwB9GzIF/ABnge/Iz6q75um2CIVf2uUAimJn7MSzIs+qIA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(376014)(82310400026)(261021121427099003)(261022105027099003)(261021123027099003)(261026140227099003)(56012099006)(261102123227099003)(261028144727099003)(10067099003)(18002099003)(261009223027099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uKQkmpualgSfIol+aLRU5AKKg35fUHWlodLb9l1LJRkfPbwJAONKweTdV//kuy/NL6TLOWLHg0KX8Ew032zms2qBmG7n54W8fxRT+ZR1M+leKAnrVe/oaO2x9ScFY+/Gy1aqlHhIG431AsUCFb+UPIBP5ZvqpvJVK9Dgo87BJRAT3QHPluP9KdvICx2aNjAyJ9wKMKRQiBfvFpCMVo1E/Op7UTkLvy8NneWoTh29JSFKqTL6TynNlbOp4j3Zrv3Ti43/PLC0HB1xnhGTwi2WgzYHnuagECU7gD+HPwc5UONKCTYjvXl3MTEzOa1MZFRGKY0vwGDOh4Z+KUe+jO4gkgXkZktL4bHWoo+FJKO3Nm6dZ7IFC5BjnAiPHPpbM2/U4jKNGBJ3OdpE7gJjeoUg9rl/Nu0ftTK8fR030Y5mWhlbcfIDEtISzfW5HATScUoy
X-Exchange-RoutingPolicyChecked:
	WH52z61PPeVC07/6YCKQi6c4xoD3QJz7p6e/Xv/zZnSLIRDLYBANpkmkS88IOfaS97G8aMmM+L41NWprrSbfrKr+Z+3M79uD89LhH49r7NAFHSHoJgPsznfblwEURSlVSeKV4WaAj0HRR96VmjSGSvUrPFFAaPT3nz1gsaDyaLkHTN8Q+hOHV//eaelWTrvhe2HzWNFoTTsp8yX90VwdIn0rO1xmnroLu/a7sK1y+QCQ0oDiaOCKYLj4KBrbpZbW7dQZARCJTz1bKA//8OYU7cUt36rKLtnrbBmJ7pmbm62sX9i5LBw46J4BHpkSUmwjMHWSP8rWBMNklZKdnl+cZQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:58.0574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94067256-de17-4698-35b0-08df4094c307
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF7FF16ABD6
X-Proofpoint-ORIG-GUID: vgiiKQT8e5WSN_DCOtkuIoK8Gq8s1YiO
X-Proofpoint-GUID: vgiiKQT8e5WSN_DCOtkuIoK8Gq8s1YiO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXxAmpaToYHMFw
 FJLAevYu6KNg/Kwfmnvo8gq4NrzjpZkmS08rnm1sa9UDfCOelhdLAdIpkC99KN1h/fTnY+x5hPz
 NywOpz/+DKEc+BmGNf6gjPDDpBXNqsJAmU9lq7O6p1ZPpFupHFH+uuGZrvqUrcPW4aAdLcnID2f
 OTOt9KajCt0KABGqAyZSM3nt4l6pI8jAxWFGVANKxKNaPFbyQsKfVFH8GpSAZxuEAOGIsKxDmvS
 3jUV/dMYetRBYDi7J6hELW8KZeQ2zePSnr5YwTzVCXUda1nRK38OkqlsxFXChljmT40MQheXorJ
 w8rfYZK8x5kANmhkDZife0S2na0TM7mGEs7xZ+sQzLBPArYfzoNBoD78VC9HZbiIFE8CbY9trbb
 D/IA3lu4Ut91luNEP6xu2RUI4VInP2egQSBLYKK6WDyAtAS0dMqsb0tzj9q4qnGh+2iCeXQYtFy
 8LzATtugbtN5g/PDwiQ==
X-Authority-Analysis: v=2.4 cv=MpLHeGae c=1 sm=1 tr=0 ts=6af5750d cx=c_pps
 a=5+b0Cb5m1vs/r/JsbObUdA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/EUiSB7oaytz
 NqmF8zVx21j/GCHbdBERewpO2jj43ZAzfyF3rmSUbZ5q+9NMoqwJh5SpKwsJzUTyGs+2UBhBvvx
 Zx5EdHgFqPCPFvavaua3EM8k70XJLoI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

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

