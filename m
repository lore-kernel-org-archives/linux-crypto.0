Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471230;
	b=lafXdipsWTdyF9ztt8Fgb1kndIKoSDZJFiDn2vjmqInNwysB18V9tL49DJVXlDb1euGU
	 gjo5Omy9cOlZPg04xfJOd8XMcpERPd58oMbpGYLcWqlii5CzxyicVBFDXSsBT/4H71L23
	 a6T1U9rbNLa5higCiChzAsz4eOLJw6HFWN9KIHsMDFZj1YdRJb5ukKht8nJCW5SIM4oaM
	 pC0gFrPUrL+1wyeajuqNAG+mPk1N9qxuipgp/Ldpy10P/VRi07rA46CUfDJDtkTHrAjlz
	 bgqa/b7Esv3e1rVttVbRmyEasuNvEOlCPCMOZcTjce0rKkJmMVs+OLvl94APsdUE9vQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471230;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
	b=HVyus7m+6igQ9wEd0d/j8hcws1B6FF3wEtMDVa1FeHLu5hMwdX7fVYkG5S3sF0hFE4rI
	 Hy7I8uFVOu0yYzGiQSWuiYlFapnmJkMUs0lQd150239dR40tt3CqJUuzNsmdaNHRVAFAH
	 Qp1mpFjYkqYr6LmMbAapbIbz23eAliM2HN3EhKeWvM2IxDqhqFsSxiWNOj7j/cI+jYoP4
	 d72HqrCgd06Uh0g81IDA8BI/OOLFR1f01/zxctBL40iGEKmmzoO0QYqZBM/i/tYw7xnaZ
	 B+bJwWzLzemfdr7XRdSYc+Ph6/m/ucQZWMyXYILLQAr65Q8C49OPr23NrPWq4JQ2H6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=hl0yre5g;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UiHAGL1t;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B4A606A32E;
	Thu, 12 Nov 2026 08:13:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93B4A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=hl0yre5g;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UiHAGL1t
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC7sNPc3094976;
	Thu, 12 Nov 2026 02:13:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8
	R8=; b=hl0yre5gKiaaPVNDR6nWVXhG+LXnGIZRP4lgZNkJ+iK7CbCuswMEbA6qN
	M+XZebkUsa3/PhI1UnVzLL3AoI0/t1pahrtAWI+kh6UYyiquiIespoNTfcU9XN1t
	Kz51X9ZJf400XTTbA4DURqe8ghgAXUXlrox1gMa5jMrBNwd8PEAATOixKm/GJGcw
	2sEXYwmkhp2deH72iVEP5TH/oDKQkd6Qd71UjcUiDrPqrfjLj+OY9vEJOTUBL23K
	yXNTCwtV+gJGCzbgk4CCLd++awg9BT12AkQ3bG3GIBCq7A9yjilNscutX+yTF/dm
	9EqaAyxQYqKNDgMZDxKvLFyFSYr/A==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011012.outbound.protection.outlook.com [52.101.62.12])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hw4cy1vf4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:47 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIHnRuRU4PNNnIYxmH2UqkVA9GH2eQzG1HMHVRg3WD3pOy771wMC0n/7KlDz2SQju5nKLMup4o6cMxW14Guhq1Q28VH99ZP0Kmz8oIAhOR/Ohicgmwsl5eprTBQJ9c5LT5DAkTtFj+7kr6TnrHuiHWhaB0MfTfOGGQ4CJKdj3zdTkGhcTxQT6aix1Jf3B/zjqHh4zamSrzISEVoXb95GEKlezaUEg/5XYbqRpDR2/ja3WFhxKWAp7Rn12ArWXpXlEwM/Y73mJExeKE22/XY9Em3e6L8BoEntuRM0YP95REmG7/wR+g17ertayc4KN82IWjy4ISmXUYyG1OMQXuc5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
 b=JKJf2rpIpgMseEOwDEUkWbIjUug1+l24MXAsgrJZDRsh7oZq1ovHflwF+wi6cUeWqyP+f1V2LJZJc+V4zx86EwmoXDnlyJizW8K4gFsCLWGRh1nlQpEknu7FI3qWAPoeUbdOGJeMImU3YNVfGYeg3yaR0ED6/t1i8lqoYbCjxC1KTGQ+lrbQz9Q5waxTNuWWU9ZHlycZhcCqpMVtR916kav1EqNJQEbK5CgqP2aO1peF7zegRh4zFMDQDcufs7L8vGDGN37O0Ik/q68vYwpF8ZPTcjY611djibdfRsaH55xeA0H3qOGb5M31BCwSEK4F4BTJJeRAcJPJuzUwX0Lllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rx+aZLzbpRDhp4Y+vYYI1Ss24EDq53ECfB4mpbph8R8=;
 b=UiHAGL1tT/u3WJLWIG41zK6B5hf5cmvU2HYwu2MOMUPPjN/wnhdZnamYWbfKk166f34d4dg+EyhgQGkj7p6kKTH4Pvxqukrk3fDLMaMYO3cJ2T6l+VFZLsTNRw861zIleddsW3ALE6XzCsnO+J6hjgywq2aOrkWaw6Gc1r/bHXI=
Received: from BN9PR03CA0090.namprd03.prod.outlook.com (2603:10b6:408:fc::35)
 by LV3PR10MB8202.namprd10.prod.outlook.com (2603:10b6:408:28c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 12 Nov
 2026 08:13:07 +0000
Received: from LV8PEPF00000060.namprd02.prod.outlook.com
 (2603:10b6:408:fc:cafe::5) by BN9PR03CA0090.outlook.office365.com
 (2603:10b6:408:fc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Thu, 12
 Nov 2026 08:13:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000060.mail.protection.outlook.com (10.167.245.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:07 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:57 -0600
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:57 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CuPH472711;
	Thu, 12 Nov 2026 02:12:57 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Thu, 12 Nov 2026 13:42:02 +0530
Message-ID: <20261112081204.1146395-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000060:EE_|LV3PR10MB8202:EE_
X-MS-Office365-Filtering-Correlation-Id: b46d267b-7fdd-4a1a-aba7-08df4094c89c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|261021123027099003|261102123227099003|261021121427099003|56012099006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VHgXA+ESWrkf54fUoXbH2t0lAdYewOuVas/c1mCKABhxodz7peqQjldjTexaAWYop/3aer0Nqku3yYph6h8MKaeZYNNR3JV1BL9VgwtLGn6UIyCND52HCamNHH6ZbKvuXDCI9G743oreE54zpWso+ntx8rfJlE5Pc9fYGblxoxgdKImV7d7jMV93xOnK2yA+5+RcONquBcFFRArC5v2vrwTFcfgFUQ7qZpr0mTDKbdJtjZo2JdDrVuU5WcO2LPmYTwwoxK+KuIZrzFIlZlRbKawGZrtlUvzFehArLqlSHgknd8fmXI7WHPge+YU69GsUKuera+ox+eVOJDzF3mX/M0CVvtKpX382aP92nQ3SbMxJudHIqRKcgn7OZNp/LfF+lXy/GEi7UtJVeCaRPfBEjPjPy33mV4MO8Yhs5cUMUFeGuNB6FIobSc2k60RXfED3Fb97p7tSEZSoz3sU06OO6KlQrO57IOgfjwjMqYmWranYmmSvnpLfEfMQ/eunT8g051Eu6gcPGRDUWTwPxZCjJt3a2+EE6pSxNg1IEhEMyTcKmziXvdTLCBonvu6I0ge5RBnjusTr81yb/JctA20otTTDemZs824GhdBYe52s4XY5nM3cVSO2+7W58gk+2IHyGwcA7H4tBy9HmriRtzv2IFS1aC1hM76Q779yx9jm1vi41zAJYTZCqsfgVZuQH+o8w5mNvS7GDUZhzLFLacLhRg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(261021123027099003)(261102123227099003)(261021121427099003)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PudTg3neTtXVtMRXmXxqDTxL/oPZR/69dynbCzWrAsug3pMkppI8fkVjw7k6lczZEr0MXvLwfg6dVWgkKTTQ7B0fE7uycvP/6HYlnydspcs/EmRpzWinyDgQ8FuZP1H7DygBNh9KDursi8SxYNDyncejyKK6jxqCOGYWjj28ciKv8Mu3gg+JPBAaBXXt7AM65LyLVbUOIuif4/fID6bsdTbnYJWfw2nZOT7M42RFYmTqpPcux7tWU+0+prlWptbaiY1eTB+SK4564FJMQNvq4Y3ep+xfuNh+r7IGD7D8cX4+JJJv2JnCPnavpiDwInQxyB3nXzmrFysfFuNf3zrD/Ta8Rj+hO+j4Q0bhEUPDt7XmVW2b4BwDHAEoXfeYf6usRSPiQA6H+I7a6BdIVdLJ8WWVA1Vw56rAg1Q9/gVOcdIgUIqzwgeywDTI2zjkyUd0
X-Exchange-RoutingPolicyChecked:
	WEoWC0RCeZenxznqrfLLC7h+VvJqpZUYSbIS5TtGVTKYUoD/6qqqPRAiPI/0XpznZBogXGvBlxeHjIhQIN7uws/WRRpgAGvpNT12jjMthKwHyuyrOU8YfBCzScdNRF+8iW1AB4rd652t+KhnGv3fZLf9B3FtCKIxT9+Be+W9gc5jEO+RVV3izdYL9afSvWSuCdMD+dSVsmyG5DotZyJdxzWwtKc8peKP5wiygu1lFG94BQI8dV6oRoVYbvbw2qTPrWcHXTEhlRVJGCvejpJGb1oBJQf4ndPlXKKuQ1jWrd3Sme5DJTCwdBO+SfG9Xb+6gNLklmIIIw26eCj0+Gvv8w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:07.3725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b46d267b-7fdd-4a1a-aba7-08df4094c89c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000060.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8202
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX4ybl2T3K2Rd5
 KpQILCPoktg2D+MD2jklKvtgYecmeghZsEOZyNY2JCilGQfSRLnH79jEs/4zcBAjK0Vj6/IvSxK
 hwTu75qEBKKlvg+N7mZdYZZwObiLDfA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXzCD2uAKJ9XAA
 H9pDTszl4mig5+SvZjSjvwz8kccffXfbxZF4XOjk9F91XQKaJ/hn4uD2tJQJGHdE2rTn6tIuA8p
 5FIE3QsNPHgOWdsVbLA5O/+0uk7lZGNWojFuNgyOu/e9lkthLzDucfdrMX5VILg7eqoOITnuGII
 lG5+DWRj9aucPiMwl7OrNi16Gqpq4eRF/zdLLRfC+PqjD8wIyUtyDiAqa+DwdLbhOSDlH9QahTe
 TDuUnvsbT6otLI8SOd9p4hc25tvqRiMMhYp4ugdzNWwQHYl99d/ox/xaj4jbNd5DDWH8PX0q3c7
 HXeh3g0QuIEjI05nxtGuHyIR1ssY/WjCV6+XVRrI1ztsAfmBEPiWSY/xhuggW4i4eMJXMGUARjk
 eGmHHJr2G5Ks+0ev/YSgWV0XmshBQ/Ksmwdjufh5WQ5zi9fAhPYtqckRdmfUsZHUg0nSn2HGIPy
 n0LIUQAbTOeDMCQQ2CA==
X-Proofpoint-ORIG-GUID: SzrfiECxFvnRjuluiucv1UaJVk-jfpMH
X-Proofpoint-GUID: SzrfiECxFvnRjuluiucv1UaJVk-jfpMH
X-Authority-Analysis: v=2.4 cv=asYnmiZV c=1 sm=1 tr=0 ts=6af5753b cx=c_pps
 a=4YDC/s56AEiJKWlPnw2jOg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 220f08fd38977..89fec15c63bfa 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int len = req->cryptlen;
-	unsigned int pad_len = 0;
+	u64 len = req->cryptlen;
+	u64 pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *sg;
-- 
2.34.1

