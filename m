Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063481;
	b=tXxXEwZPU9ZPm9yiWP9BOOcgL30VDFkRZBVl5anhTVolkIRdalt4EWb1eAwmfVEsAYYe
	 jFjs3i6g47Ow8yk24NsKITSMxgPOrN0ZLG4tyC/WlGw+EUEVpQ+GkAGiYR0o15Jsr4hTl
	 YrZaPKh/wMpg5Miva9T7HPX6CxVwYQ84Ww8OKKNyy71beY6i0ispCH0AYz5++LmUdfRNN
	 +GnrQII5/lZUkQfVTvD3KMZWM+8qo5oeGNLdxvnw0Xt6675BdgAOjFz4r5CycKUb6l9xm
	 yLtLxqEW9ATmFt+fz16CAMHF85npC0AS6MrzXorE0YPd03hos7Qbm2i8pTW7cUnukYg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063481;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
	b=RZOWqurVZ30p6GxjbAKBDAHx9cQsbCSdPQAXWZhqkyXKOmirGmQV1aIPnT0NUvUwZePa
	 BTN5oOaqmDvbff4wNtEFihxSEWuxoQ7wJitMqxxz6vxuOfxptC4Ua65t/6l/Oj7Rv1M8i
	 Frf85qFaRqKSbQAj2iG5d5WU3cxOb9E5M8UUTT1gBUopPSy8YmE9iXAosHKTcleQWycq2
	 VTcTjykM+86Mf0dGO7fB06t7OpYHqKWJK+lU9DECDwVzI7N1MoAUlSNHdJFjXqUrFUDnu
	 aI9txQng5o7iQTux7FkTO8ZjFUPpOHDFoEL8ivJ9+sgksNZE39uJvY5nXX2kOWwV7Fg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=WZeygLCG;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Oe0PLiMj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62FD606A9CF;
	Sat,  7 Nov 2026 14:58:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B62FD606A9CF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=WZeygLCG;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Oe0PLiMj
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bx6811610348;
	Sat, 7 Nov 2026 08:57:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=WZeygLCG9hwYJhQMiuEmv068m1lh1emNSQmAJ2gHUJ3sxyFR7fe24KFX8
	kHrOkf33GUPZOU+WWLHlJjl+hakIoQ003Xdy4lphA/L0cRxY6hFhuf6bkTYk4RC5
	1Yw8KceGRKSfKSGoQUoUjFTzhpZO/ORLxar0+207J/4ATgnFbZ9aGZXyE/avcwen
	mWW/xaPoJVs9pPl5CibpYN439+w+Ibv0L8rrp25EIXcGxgFOunO+JYK0KhyvVkKi
	612imlJUBSjaViVUS7fL+rThrPnb1AbexwOc3bInYPs6vdQ5X0eZkje8IK9Mn/fm
	QdFbJBiXYAUFtbEzVU6O7sp22U8xQ==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0wqs09v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:51 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LR1QEpocn95l+rBSrkRUsDV02hEWrLVvd1CTHx6eSVYA/6eh8vtORFraDSRKyIi+/ZmLyYym6CAhA8umroDu3QTboo+Bg7vx8GCVdoFpcOSDl2fjOXzFZtnXtv5MJc7cDqakIh3f3hfRT4bT8KYuLaKTn3EZzlQsaegZv9Gbt+jovt03tQWNP/wp6/0PrarPFuX0n2ryE0La5jA+jsuHbEcICEg5RumU8OWxEqmcjWCc4ZTSs43a3IFW8aEBq6I8ruGWpFshfK5pY6Hdc7UWSUfyOC/Ub5Ep2cPMRN/J5R5LndHc9d9/pCf+VxKgISIk5EwWyjaQvvYcI+gY3xaUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=FEfULG20pX2VVait5cHkbsplqVT5Bfa1FtPE/DbimrJWVBxNOFImqfVVBrQv1TSVRzkTfef3P6pHkrZiflr1R39/Qm/rj5/cknbcnAGGm4DaatzKhSnpQkKcstY6cSlQ3gPDHi4au/v2KpSalWJhp9FOWucSwvN6tWD16aeEdrLWfj4CZeYNamhznWAJaB1V7v2JUUt07U/VNUKFhnp3K/wEcxSyKSlx0DvNoPxwJGnIJm+AJclSBLFq3k+9P+9VnFKlj8bIvnw+S05OpeTTVSJ06hbi0UapuezaJDWcppEAghxE/A2aIhhkkDXvD5ggNNlpgUeyKWm7n6gDoexyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=Oe0PLiMjw3segjkYjNST1OLX/GNIV7EMqNSqxQ6UVf1ZX7jOSkQAHv+XacTUcYhlU5lBJFZoS49+tGMVGYnEGG13a/59qr6nJ/7rgnLduEyH+DY1jjyABhbEdCn8AEWXQzak8kQFs8RFIu+Df6Mo1rquGSak/X6wAGGJk/HSAwg=
Received: from CH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::9) by
 CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.11; Sat, 7 Nov 2026 14:57:05 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:610:ef:cafe::40) by CH0P220CA0013.outlook.office365.com
 (2603:10b6:610:ef::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:57:04 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:03 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:03 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:03 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Ev19X3373820;
	Sat, 7 Nov 2026 08:57:02 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Sat, 7 Nov 2026 20:26:12 +0530
Message-ID: <20261107145618.2349562-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 28fe2152-2fcd-47d1-53b0-08df3cdf62ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|22082099003|18002099003|10067099003|56012099006|261026140227099003|261102123227099003|261022105027099003|261021121427099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	ujUEH85KS8qTCQfGMiPHGUAwcEcPjgmdS127VIyTr1OOnPg7ifwkE5/lxo/YUm/fSmmaQod0x2kKjea9sFmS6lVEcrgDa4aI8tSVxorjmyoau4V1qEDNJsT7D/Xf0I5VDReb9RaN6jJRQbJPEdYT/aNtxwDOCqPIBG8YD12O7MVWOXr+ecNxf2RZv48nEDxxh5DNweHlXO61phRaf08rcHvxLTze+H37Vo6vJcGGjr0Tyr1ZsFW2y5N8OV6tD4rqapEQXZt2pJk+yY3cClvd7AQGcnuZ1teu6W+MTSl4rAiH1o8vFruoqK2dAdtL/swwbMTU4bg13IXHheqqGsjFnhTpkptxSxEovPNtgbTrah4HWALbbfEqCb2BDNoio5pOsRUhAoZT5Gt5FQU7nWg1GthUV9iywTlUjecESp315TsRPH2gGlbqSteVPJNiKAOeGVpg+piDZlNlHOp/txBH++wq3rftVesbTQ6/6+ohsu8bo26Zm+jtiz7KFnFc6sTevI2xKMAlG3nc5s/1qxOb4Zb1ycrbPY17Hq6Kcd554uLjHv/h4bvCeIQf6qTEQncSJ8fzsDwNZGztp61m932m50kmyYO5EaA9TYqiWAPbI67fBdkdErB64Ywx7vYKBFuVLClEX3daV4tLXjecMk04OMrDHrYx56cSidr8FZZ02CtZ79pOhm7GuscYeQZnvNkMCINxGnJrao+nrzoYwawfkA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006)(261026140227099003)(261102123227099003)(261022105027099003)(261021121427099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	U2gFw7uPurdHjhMrhgh1y8JqQdPZ6w5ubhS794ACTifkUDAzFZtg8tA8Sv4w0JjPYzzuWIFQ0BLxhqEkIsb944P3vuwWKWNqJCRdo64wUKap3ezgzLeyPj6+bs75zAF5Mm4hl1NKY8qU20/02qFWBJ4HoHoXvsqmfawRpktiQri/kQdwgM6EQx/5DJt3qS7X+PZET9/C+i6TETwHnfJIJw/2Z9Z+Gu3ErRCNkyYZzMSlluTvHq7B3uDx3WpM2LF3bUl9EEcNGkJuNj6xb6QWX3BN/7iQm/NvguIMRtSsnFsjABCQM/zwCPk5/Wt1uKV0//PR1tDfVy3XN6uYcbxi5Z1bMdbcBZ3yU5hXnb4zcfNvjFF730/lGzaA7Yp75iLF2/cYMcde41I/8wlLfXvt5YxMNYtzFYZS8xMdi7eyE3TNoop+yYSEhfYLVxayQjaY
X-Exchange-RoutingPolicyChecked:
	hQSvg8cQRk3BhwqKzKUK5U/daBJ59hhYgufISJe+xCGOPL9vsZWzV+2/nF8apnirmHkR10oej+9Jxx7qN255D55+8hiRQMqpImPfr2reijTbb3eLWzav8w1cl85I1gnNkXglOUQZX3C/SlF2peLylVCU95251PbeRETepdWaU9N2+OJQr1MC2NXxZvp22US16kJrQbyeJwMVO3S44Nl78bkdunHJokjWLjFkx5CoMuJF2nQjtIiEZyo81YPXNfD/khftEmoUnseB4Xj//fKH4IBMrXmjq08XggfKW3ji/FAJsH1TWbUX3beAPX3NI8WnQBJPU+RLa85sCGdV/Wi5EA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:04.3831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fe2152-2fcd-47d1-53b0-08df3cdf62ee
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Authority-Analysis: v=2.4 cv=H/hOUOYi c=1 sm=1 tr=0 ts=6aef3c6f cx=c_pps
 a=QuE5qaevU/mtxJv9VH5uOg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX5iFDHX8obBay
 v6o0SXvZti2wq9vXwfNBzPY+DgX5XeQZDvdZ1xcHzt4GQPnWj8jAGwxX+IYM+ZSbUI4vp+Uu8uY
 2wJX8glrf6sXh4MeIFWX4caglmv19E+SpIe618PQ0eEMDqP0WoJDvg00xEQu7qf4CfJEZP1QCLJ
 WzVdKppoSrGfxFR7rCzuUzXTVdcQJZTnYbF1I+zbDZ5IR3TXJBeXXYJUIC3CQK0AXGy5ioKbEil
 eLDJCMhh+FgwjBe8QGCMDZTyQG2PSxNv+c9+6TjrP9LaHK5wotE5Jc+H0BtZufJoSyHh+qf1mpg
 i8btbjOJHLcK8UdEYiP2ahrbJ2BtIDTzokfQ8dfNDioN5rHxJ8to9V0hubd6bEZf0LlMjGJUZrz
 XluwTZbkAOGcif0MSaBOXMOdW082kdkwVyAqR+dilcsOPznFOA8sDEgFiVkM3PRJjvo4Dugg2Yd
 KRV4QAnat54XWVl+2JQ==
X-Proofpoint-ORIG-GUID: rbvcBpFUFW0bQcR5btuoo1DJmrVwg4gl
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXxzZN4/NctLoU
 3qhctwH129/2gk6TQhCxpiAIXYDlrFELAGfiqybBmLslgy3hnfVLSGPDmrx9nooPVj89YbNvtAJ
 HEK92h6rZQHqNia/gqJFLQ/BcikKGTQ=
X-Proofpoint-GUID: rbvcBpFUFW0bQcR5btuoo1DJmrVwg4gl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AEAD
driver.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 0447144b77ffe..d75b074ca1e39 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -643,6 +643,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -699,6 +701,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -758,6 +764,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -779,6 +787,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -975,6 +985,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0) {
 		/* Map AAD for TX only */
 		aad_nents = sg_nents_for_len(aad_sg, assoclen);
+		if (aad_nents < 0) {
+			ret = aad_nents;
+			goto aead_dma_map_aad_err;
+		}
 		aad_mapped_nents = dma_map_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 		if (aad_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map AAD for TX\n");
@@ -996,6 +1010,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (cryptlen != 0) {
 		/* Map ciphertext src for TX (BIDIRECTIONAL if in-place) */
 		src_nents = sg_nents_for_len(src, cryptlen);
+		if (src_nents < 0) {
+			ret = src_nents;
+			goto aead_dma_prep_aad_err;
+		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
@@ -1016,6 +1034,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		/* Map ciphertext dst for RX (only if separate dst) */
 		if (diff_dst) {
 			dst_nents = sg_nents_for_len(dst, cryptlen);
+			if (dst_nents < 0) {
+				ret = dst_nents;
+				goto aead_dma_prep_src_err;
+			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
-- 
2.34.1

