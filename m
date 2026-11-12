Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471178;
	b=1A4EhrL0l6t5Q0JEvm013KwyoVUejKOSIMqBAkpcKrLgGNPMBbFhLAK4Lg445Lf+rQ/Z
	 SZe8LNcqUd6hGaUgYNZNoIB14AdxLfN4eEEgNResZuH4H28VGLcjttPbpshhxKBEa+iIn
	 60qi0fAk4EGTJSafnJFaWjrCO8z7AXq3AigHUllPOhFmk7kMQZ24SKViwdAML+X6pQHjP
	 rv+VXHZaxLiF8nhrX0sVokranXtC6SYwxhzWNv8Zm2jNMzvTXFWscxfNxonFIhArLhUCg
	 te2mrWhQWvYiI4t3X4rdzE69aZfkPT5FkGAvOcSi/m2MM5Ip+QejK5w/SjVngta/2Ag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471178;
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
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
	b=28ETo2sOIM9ucxvYIjPRgtvgEXARxO6hNgM6AEe608jeQ9E1uw6VID1unc1XnknWNedw
	 S1TBmyRyiJRmxyZKw6nxM9yOZoyeKN8oG/EODMqav9DcuBbAHC1fmjVsGU8KQ/TUfqfyc
	 hvNge0sE2JZgm+k/NzSVdSxMzYfPHrK7SNcEL/1jlsq8H7k3BvyP2gCcMzgBoVsMA4HlD
	 1rgUPMD3huu9PHjESRHiddUbSjSiM/Z67RB3YikBpEX6sdNgrQMssjimEvFi4dYUym4Fx
	 bGY4/j3pkDdOu9VDfJZ3p2vwDw23dkf8KlMrmujNJDc1csMPTTsYzh6i6M9V+B59LKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=NJ+ErW2q;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=RfV+ONJ0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DB2606A894;
	Thu, 12 Nov 2026 08:12:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60DB2606A894
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=NJ+ErW2q;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=RfV+ONJ0
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7N4tH2098012;
	Thu, 12 Nov 2026 02:12:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckh
	oA=; b=NJ+ErW2qvSIUsGIFxuP1rpvAPF7UCUrDHFskt1cxf0iMSWRq8tTSgItlg
	dPOIij+CqMRPQWB5YXieYMyffFtxRecHtq5Hu8CAmyWUWTX2EO8gjsIapBaDRlNd
	IoipITptfEviQDoTwdROBb1q0DhaVqO6AlDVpIgLm9XRw5t+PKsCCnNRTFiq2f5Q
	FHUbfGA10WX/ZFbUZ58A2AXwX+IR2VP8WjqOspQQeeHfvN5XoqgGkFsGps0pKcog
	yQfnta8x7HHoBcGaYW973Jt9/+IunpxXSjl0nCd1+Sr6NZflVtYSwnAl05ynzMES
	3jAVF1hTZuHt/NC03VdvkFLzmMLIA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012026.outbound.protection.outlook.com [40.107.209.26])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hw915g8ng-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:12:52 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pDH5J3baJzrNCQsDjbPtJgbjCfALTB4KZRrgGvyRz1eDX2ry4eYukjFxIlrbbG3nnei9hiR04gtaOSWq07jFht5ceqJUyseOFwIB2qRoy8V7K2We7rskEi9KZhkZQnoO+uUY1zY/8rVKDFt1ihvj0j7AoVt2qOzc8IaBDFkStVv2kgoWx5GM5liZd2RJKMTZywvBUtTdAdQQAkgSXlXrYd8y4Krd2Sc9WQI28o/I/0XLQ3rOPhxG+E00dxxpj5Zhe2me+P6iH0db/9RQEV2b0s2NKV/S1YeGKEXEy8IxR9hyNG4eo2JW6nr9KPHlMRVcEWjtRGIflzKXo0gph3lEgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
 b=tIkF65s0oA/do7ejaXfSLxBCjHtVlrsybsn3Hp/tAq7KA2UIECWswIgWbPYeR+QhhIUDbnZEgZ+aHpuURpKFI4XrIU+vPR/ngcXOyEdXmT0zXlU67mecaLkPqrkWQ15sAfSMPZgf0IdaYEb4I/AMQvYbEOGlPFjHKh8R2p9IKEzffoyQxNi7UCEsNNaSYzew9PyNHIOrc4aDKJ4erLo87gt5MA5cNze1/8xq5C8/0s9A/GnIxdCLvI3F0rRzsNNx/owNkt90n0Yi/tY7WgWw1DyceF6QiZHZ+2j+EBpunz6869XvwMkAh6CXivqQF2tMSQ5+tFDf1rnJOSAv+b0Nww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
 b=RfV+ONJ0SNg8+iyc+pPk84HNVLY6P4JoXDC5XggTUbbOX0R3M1gwIzUWA1eqY+oie+DgjditIV4hpDesTdGeXIRA4hkdLprlXcZiDXqpi/VponaZRMSmorsQ0UyrArChYpE3MXaVNJO2cJr83v71rkn+QEf3cO5a2uSo6QiD+u8=
Received: from CH5PR03CA0004.namprd03.prod.outlook.com (2603:10b6:610:1f1::6)
 by DM6PR10MB4233.namprd10.prod.outlook.com (2603:10b6:5:213::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Thu, 12 Nov
 2026 08:12:48 +0000
Received: from CH2PEPF000166BA.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::12) by CH5PR03CA0004.outlook.office365.com
 (2603:10b6:610:1f1::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166BA.mail.protection.outlook.com (10.167.252.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:47 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:37 -0600
Received: from DLEE211.ent.ti.com (157.170.170.113) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:37 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:37 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CZZb472378;
	Thu, 12 Nov 2026 02:12:36 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Thu, 12 Nov 2026 13:41:54 +0530
Message-ID: <20261112081204.1146395-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BA:EE_|DM6PR10MB4233:EE_
X-MS-Office365-Filtering-Correlation-Id: 93f1d99a-6961-4f82-b1a0-08df4094bc98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|56012099006|261021123027099003|10067099003|261009223027099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|261022105027099003|261102123227099003|261022075727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	XbwbFUGEgK7S9kPY1rNbN7JWe+COW3KRmQMHm+fbP7FDJx43gX9w35mQ9HnGq5r79rDOzPciJ8dmN9b2Nuo6Y0T1u7wy2La3rrbjUrbhyEmIISAWt45swu1LseXe17kst5Xt7Od31UFZAF3IybfJY64X9y7/xHm1d/cgzqvwxpI5NyM52sYuMfGl7VFM829bC9JSvBKtQRqsqJ/5yIoXQvqikJbj4kcvczIHsK41pSu7OEXCJkHr5Uc2ATrTt1AWnXEyvGZVcLMoZLMK/0g1daIIS7k5zzYesyPlj5Q+i4qpKv9iRNdfrRuowitClHBKAbLPcdtm3q6Mk0erUbFYuqqNUeoI7PdM4fJ+fN015sCV2XC8bzb8gBJJcEUFBc5rP4MmJWJ7IqcXOl7lCDadzJDnDcjxQbDpvIehAfTRAOGkvtQpBhk7Ucxhcd8h60Vl34k/+m6wlR85J77vjT3MYMy3ntAz5bxzcCEvZqv6cgmU6swjBCZQdGLPtoQZkz1vSWInA+FtiBB1Hpnj2TwMk2k76T4gA85ti2+qrrV8CdZkGuxN46ZD79M4NWQGbZZub0WP9oz2Q94BDfTI1BsMbxGGKYE7ahc+3lW4pBfiPbbOdcPcY8WIeotDtQrTpiXkkEFDw3v2K/fGjGRfL0U6BHDa7p7liinvti6RRZBpy9YFU/vSfVDI4TUFiMU4nmJcCRhkjqa2Lm443Nt5cyE+0w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(56012099006)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(261102123227099003)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Unn2AKKRLUGsCCqMU3Hs72lGbttHYHi88K630x363WS9rq6DHM06X3dhVOZVB2Yys/ju96ocjXc+JULcvpi0px1e99eyggkLanB9NMDNm4tzXJ2yzTuYkd4dwI8Vdmeqoe+59hcznHnFHN4UYQ0YnjwpHdER52CP341LaXVshxKUUjEqk7OuQywXTu7r4suRXFTwIfFBwTnUbyc3sXuWNMtD1SlpqLCri0U8hg/y0XVCdwW2B4B+vnahqLfJKImeZ3fClHMHsdmwNhtdyMPpkTxJIWeI7Si1ri/NihKWoC9NTh2a3cg7pdsagMBn6f33tRutISQQUL6hJ8qhdllJT7YWo5Eoxa3rIA5Z7IJZ9LFdlPYP8ZgIu3qJTWWnG1Yze4MsuQlj4930fdD0VWG+/b5b+k+10XRBlxyIwwSLa/RSN22+gIYiNZGtAl+jLGgQ
X-Exchange-RoutingPolicyChecked:
	bJrNWK2MFkVapCdgG1mCksZVClw3XLdyM7f3ulgpK8PU1yZ1r1zc9fbbCksb4iZh68zB3JVv7EwFt9O7p8Pp9kdjq28W8xxAhMveFawUuK70rtOIhc7oXuxza8XtlhG0bjtBUTi/Wy9+ve8BlCoLCNxLFuGNJto2/M5nf66pq80aTBWd5ZDFJcJd5OGdc5Oal0R1/bubgW6XxGFl96ujJCE7sA9rWLEe0OuJ9CE/uezSmqz0fo6WBM1NKwxIxiUj966ngHIRZzVEZ3LUwbHcw7Q4LVdHj5OCcMPqR2OhJlePbfF1qCjJAba8StysB7sM+H3yOXn4G5jp3qUbBNPW3Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:47.2461
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f1d99a-6961-4f82-b1a0-08df4094bc98
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4233
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXzH1HgVeL6Ezs
 bMCDnFF+6ei58OySngRs5xpscRwEoHmM4gitDsIWtcYYroXHEg5WlAkZQWPGtkQw/RYLzedeT1S
 MJ+jBkD+nnJF+Pa/oIWRNWxe255/fao=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX1Lio4nHhndgO
 TnXDGnzDX7LFDKtqWwGu89GTeN58rH0EewEN4AswYypwOBm4qAqVM6qcN/6iZuPlP6GCn8gX9e3
 L71Vgm0MGunZh3z7wEvXInDI93usAgdVXxvDKzs4S52stX1BKhO3GNQG8DAXcQ81x4MdnKQxD32
 Nm1URbCjiZ2q+r5ClS6+Ms2HhKcgSqEGHSes3zr18wa42lJ56B9AXGM78+gOIeauwObNsYm4mZG
 Zgz9macTxz1Bq3YybgUEEa0E++99czfuZkIjqE/RMJ8xbIJ32DCZ4z7yvYe+QXYO412tUVq4VfL
 45KFMSj+u0lvMtMmsFkLC+o6oV/nHQiXV+rnY0W29yidmLoQABcHVs7F4mRsrth6iAgWanTGLqE
 Txy0fHs8guSx088QC/JaIw/Ti9f6Gu7RTk9+hwrpY/L9/Ky/erpA/9ZJtEKwdCq84cKkyaNj0bW
 IlXYaoZNYrVrNX/3wsg==
X-Authority-Analysis: v=2.4 cv=a8WlZkSF c=1 sm=1 tr=0 ts=6af57505 cx=c_pps
 a=dFgZiZMTwE2p932uIRmjvg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-GUID: amTBhCSRRiTqAlnmqTPaD3hL34Us25Ko
X-Proofpoint-ORIG-GUID: amTBhCSRRiTqAlnmqTPaD3hL34Us25Ko
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 phishscore=0
 clxscore=1015 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem. Add DMA padding to reqctx and use
req_ctx_dma helpers instead of req_ctx.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 46 +++++++++++++++++--------------
 drivers/crypto/ti/dthev2-common.h |  2 ++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index b801f9fdcb87b..1a37150496ae8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -298,7 +298,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 static int dthe_aes_do_fallback(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
 
@@ -314,7 +314,7 @@ static int dthe_aes_do_fallback(struct skcipher_request *req)
 static void dthe_aes_dma_in_callback(void *data)
 {
 	struct skcipher_request *req = (struct skcipher_request *)data;
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -323,7 +323,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
@@ -515,7 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	int ret;
@@ -560,7 +560,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aes_crypt(req);
@@ -568,7 +568,7 @@ static int dthe_aes_encrypt(struct skcipher_request *req)
 
 static int dthe_aes_decrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aes_crypt(req);
@@ -735,7 +735,7 @@ static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
@@ -755,7 +755,7 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
@@ -836,7 +836,7 @@ static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 static int dthe_aead_do_fallback(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
 
@@ -852,7 +852,7 @@ static int dthe_aead_do_fallback(struct aead_request *req)
 static void dthe_aead_dma_in_callback(void *data)
 {
 	struct aead_request *req = (struct aead_request *)data;
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -861,7 +861,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
@@ -1140,7 +1140,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
@@ -1212,7 +1212,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 
 static int dthe_aead_encrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aead_crypt(req);
@@ -1220,7 +1220,7 @@ static int dthe_aead_encrypt(struct aead_request *req)
 
 static int dthe_aead_decrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aead_crypt(req);
@@ -1246,7 +1246,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1271,7 +1272,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1296,7 +1298,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1321,7 +1324,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1349,7 +1353,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
@@ -1374,7 +1379,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 03a0b426041ac..cc20538ad6f36 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

