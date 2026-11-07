Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063450;
	b=OLv6+4ddf/9nJha0as2zp5uHVjg91jj4zwzhjvoDaGOdFE4SYk4PIa00jLDmuTv6YJRu
	 FoiGy5VILHByvWRq0Iidd0Pdqjjqhk29x/hZk18y5j8yJ02RJk7Xwg0vzrUdmKdljlHoN
	 jKzevanSPqq2Q9LWZymZdI9G+dt/1O9MJ7NQFOzMbpZg6bG2NLXsO4M6WYEMNawoXyzBO
	 nRCvIZRiZua7EewlIg6v0YNWe9zpsWCCcd/H+b3eCoDRM2HqlhANghgaZyKrHpne0gokM
	 WJJtAcKXFOZQPwWONvMkdIcCIqsXy6G9ccXONCIjlDjEBtphvjMFS3sbTXf4SKQVx5w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063450;
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
	bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
	b=LHapFp6muqWKHRE7wi8WxlTGHRS+EXT5bhq3qkMdccadtIZQ7WPNjkX4Lr7a/P0MlkoA
	 67K19hRCfTSiDpdQ6r5PdYxUrfJN0XTlSPQlcZyDDCywIOXRw/eggulTYH6kPOHnI1PmH
	 VLkD6tWnR/TyAfSmHe4jNXHy/wmvVcDhfQC7BWUcLRZ3SAGBoC8iOOCk+az6AuUVgsOoa
	 qU/yrIvdoh2pB0bUivuCZdPNbPdqLiFwkVZk9Vqv35dQ/mTU81W0a42Ji8OvXyrtvDe1U
	 1GGnFQA4yOInXVICXMcPlHc2g8zeklqdh66U2jAKbq7VBTrOVOJiaoSrJ0EYd0RwQTg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=j+cHChRO;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=r78keI6m;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0E606A332;
	Sat,  7 Nov 2026 14:57:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06F0E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=j+cHChRO;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=r78keI6m
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwUkY2005520;
	Sat, 7 Nov 2026 08:57:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2H
	V8=; b=j+cHChRODj/ydkmdNSG0KkLQA0y8c4M+hdsb+BUuifUFmSXLkc4ifYNni
	eBBwok4t70ySFJCXS0rXzs0XtvInk70NMylvH5wLlsIzjru9aF0nMUKy5K+qhD9h
	FSfCZsOXh7BebXueTu9bW5GPburzI3OTFqmlw7E7/buyiSVgPNM1WCFi60wfKZtq
	Ah/MyYmdhaBIyk+oc7yqDbLJCmVQY+yOyZMXzYiSHZ+SUuXyp2BvrAylf0lFRMWp
	EPJaoTPhuCiEGQgzCfszrNzeB2CbvasGWosmz5VP9T/2/sDcmIJ8XhS8FSdvxXzT
	d4v/gW/i1786xUA0XMg+YBzPf2dIg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012048.outbound.protection.outlook.com [52.101.48.48])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3sa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:27 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d/dzeSB7qJH3FqzgSukM0vXQ6PjY41k3ir/HHad/XgYmWCyI56Lgdck4rJhiEnkXRym6Mx7ejFbX5OiGhQM23XMCpu97k1Q8L8u5HvxCwpogA5BXyAY3t+ofuEUfSodCwfupGJigMRTN5ZHJj3RgIRUWkx3YGZm1CckB9D0qVW+ho1sTTIuWRjPYNiDm5QDSRytwooUEaCdmlwGxndnC4K0yfJgYJXJGMUTzRSgJ4gxG99mwm4WGHiOAEiYQqpGiAp3CBM54BP79OX25rtGejIu6f4gslYPx5K79Az/L5ZHCm0G6FZl+cCKu+fIZeVZWn4NFcvBHtHrtXrrMHr3E1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=CRGqtnHSbqyfGuEsfWjoawMA0z4VDvv2wR66O/6DEukK/8JuGc5oVcvfdL4LVFMGnSBrXqJyGgyNvel/9RwNfa///prjcHbE12XBm90T7BoD84G8WDX2gexuo7623tq9Xd5qFi+qNFQuPq0pPK0+X1ylXUdqS52g02EI/juiypjrLgW25efqFxB5Gh7D1/QsZU3Azzb4NfSDisAPD70/rgsR1zUjgvM9kG+GiIS8rdTS+RH98vGwofw9HipsJ+HGc7HSJUVUBK70cdqlHNyK9r8eN42l6MmOGH5MOsq4qdFOpf2tbjnaPVCsokASzIIlJ+uodQ45w2GEGn1mwsg/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUlfrUMQ2lKjrS0XdcJrf5fmWf74rYC27gyny+W2HV8=;
 b=r78keI6mkZjRm+PcJbLrk33RwYh17L5LMOKhX9yB1Eapl1lHbhMg4T/QbJsTWVC9HSQX/7RZGAf+sm5QFjoIpx+26QSWLSOe/rEgvIkIPJtKgBT/O76uHQoka3/uxAkJp2sDARyaZqPjsRgPe9rMw7HhV+S/5jouh8fwwE5Fkn8=
Received: from PH8P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:345::19)
 by DS7PR10MB4989.namprd10.prod.outlook.com (2603:10b6:5:3a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:57:23 +0000
Received: from BY1PEPF00026958.namprd05.prod.outlook.com
 (2603:10b6:510:345:cafe::a5) by PH8P220CA0012.outlook.office365.com
 (2603:10b6:510:345::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BY1PEPF00026958.mail.protection.outlook.com (10.167.244.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:57:22 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:58 -0600
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:58 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:58 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Euuxi190719;
	Sat, 7 Nov 2026 08:56:57 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Sat, 7 Nov 2026 20:26:10 +0530
Message-ID: <20261107145618.2349562-8-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026958:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: d660fd21-ed27-4649-e8b5-08df3cdf6d91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|261022105027099003|56012099006|261021123027099003|261021121427099003|261009223027099003|261026140227099003|261102123227099003|261028144727099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ptYFwCDFeUYVHzWVNZwYE5JcTuc72US/hvE84jB1kzqwHhJK7Kq2+Xj+TA19X50Qhnkzioy8TYI9RGRXzQ/9RR5cpau7mFQ8TDUzWD3UXzBRdSmRZ54lcIwHC612iD51+jkjI2zMrRtHgCRuESVBgLFuf2a7rxvECfjTbWZX5yy9QTBTQA0jnZ1IjOgbiWzL/kf6z+hLuqD5fkzkCq3b2UP5rGNiVLz1CcG9tgMmUxUUHGJvGUgWVjLVF2u30DVTjDKariNqZ3xCozxY0gF8jwRsT5UzJQm7OojcOYZ09EPyIMeaHB7ULuzPKp/IA/wXWd7Nn75YFl3oB+zquzL6ZX6M+fLFNrArT3vcwGw3gogwOTnfXG+8hdFy9pRLzisbl2d9m5gIQXON3irpqiGLKvbnjJ+c1o5cQuExqJnq2KI/8Q5h2uBZpxplx7oofaBanUj7S0vAs4U+LflKen69DrMiHNk1eVxEwtIsA9sCXFTBnZYmi2CqQGmOxrq278lQQUksJV1y3I7tVA9P+tgfFRPtKDkxXdvd7WiroadRPc+/KdptkQhBTa7UadXVUwuh2yBAPwgODIs8rpdqoju6cOz8MTeO6Ehl3e12YgT/x+c3MV24+p+NCP45A3i209YKvT0MLNVYOYLEhfHnEOJZEitP5Mx5u66CskvWcOzk/WHIKd28hoKmx6YmaGeB1EkW2IlaCMaA0QO2Swyl3KNDng==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261026140227099003)(261102123227099003)(261028144727099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xWoF7yZ5cHmsmst5XCx6jsSHvrwPAut4OVDbZu22t5KNp8PPTdjlO7AZuwtHnCcyL+4YN59xu+YSQW17YWM90BKAlu+oEgA+Reo+nqOfQSTFF7kiRfhAihp0efDBklhzBunDN3Km+OwMDrhC8Hs58HgUPtR1H9H4beMrPePA741PYoMInYD8mAwYGz/+Ealdz4Ppgjz4zJ4iO7aPqXC62NiqGfwK986scKWiUDbKjvx9N2Si7Iq84EmDXBNl1iYLoZePfk57IK45pEwi+8JhO/oLISuBToA7ge+kA2ivjxiSvtpBv5ct5SB73ASRIqEaFF9Ni0jz8YPAGVfDXJdq+TLQO1rt58tAB5P/vzTvoxPwVQJAFRu9qd4vvm5jkawUd7DJxhP/iIVCENof/ciFAXOyJf9Cq8ErHAC19E2RdpSaEcO+wT0BW7Dny18KTnl4
X-Exchange-RoutingPolicyChecked:
	LlLVryjnpsJLNTAEeWf1yBSyKysr0rKf1+0eT9yP9wPEkOooqZbF/va95g0MTCdEl853VoaMw5TFAKPb0aUP+8IX7QlKiPO8H5n7jQ5VRK/ljRT3YXKy13XQ0Wgm28AeabNMVoq5OVQ9pwS3BRMjBnPhAU3q47f1AByPuupGE54Qshd64aF/HtBkzu11qkXGUSMGZpjz7ymRptw+vHPM9/JOJAlySQiOpfpppJsD84UrrLVWdkMV6YK/EbdN/bkpxXcOzMTzvjhtN+qbyaNQ1g2tXwNMUo8Bin39497LQ/DQqmmlmTokLvXcfHVoLEugab2cGc+iYhAVKcd1NUOGug==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:22.2295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d660fd21-ed27-4649-e8b5-08df3cdf6d91
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026958.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Proofpoint-GUID: KTSXj29Ik07jK7t3QtlYHkj41ac5unXV
X-Proofpoint-ORIG-GUID: KTSXj29Ik07jK7t3QtlYHkj41ac5unXV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX5jAc3a9hpNUG
 6mwdTUibdlb7CCHMNDKaq5l9AdiYhyHbRpxFd9t4rac7e8APXGQrNsAfWGPhgmca2GPGxbi3K1b
 dnoua0lz5wSjjKlVJfQ5v4Fk0SylVG4=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3c57 cx=c_pps
 a=51LUNg6eRAGyxmNGkw1ZTQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX/Vrj7EFkh5Pk
 mY6LL87tVWlEizwtbNHP0oPNIYGUpXxgtLDQnDbcJrOOhTngZBQNv9zO9lhLsp7QF4B4gK7TixV
 ZeWkKeNHTCyQqSta1djXrJiejQzP+iG4HIWo0jZ6pJjuPhe3xDBlyWjtMJOuSqKCZhtAZxmpstq
 QsZwMTlCAxTu+qi5EAaf65vcLpn8IPoOtA7KD89zOyefL55sg8q2N+AY7sEqhfg8DSJq6IkxQG+
 8wqLqPTn5D0mM9Fn6ihGrPsb6GC6bRMsDnVpIOJZ9V33OixTUO30ESXmF27SNJ6fiyxGk3IZ8Vw
 9rZrsf/KfbIHPxH+RyDp834YsqRQwvl5PRBZdP7v3n3EYfWgoEpknAJtL+xNShUjYEiSs40N/OC
 xrKj/wTnbUdFxY3UbJJiPh1jtyXLr9/+LDhAP3XBIhWzuDL5al7CyufbHGfLKrqMuy7uEy6EDAK
 I1BafZaUG0mfQhU4L7Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

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
index 5be1bcaeee5ed..83d964e884086 100644
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

