Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771081;
	b=AE1q7nBpba9NqmGfscRLF+pWPU/07lE9RnhYd3orXnKlVnwA5sJyRrSH7s9Ey+RiAM/6
	 x7u2zmCT+Yi5WtT9n2xWkM0SIgkyLG7/r9/xeOmmz8dfGWkWGLlvnY5p+J9ytYygM9q/d
	 jEJm0Bl+KDoAvVpaR4Ue72n4rN7q+yW2IXVEPmVCDDTR0XyqyCHqDKwLKCiYjQlebhiOL
	 AEOCJ3xl+SSNai5pY0kTrHnyILzDQ3PA01Nxg2ZCMkomGKv8CLi8MjWQZFaUCRhRCBkmv
	 PIxz83hTGnZeQeRT3QD4sLnUwlvIZ9mKyr7ncta545dkwDnPW63xhb7KjxDSYRPHDzw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771081;
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
	bh=/F0+BwlqCecgnDE0mcAev3c5HMvgIc4d8qFFlGyhwHQ=;
	b=DJ8944zOIjm2ybGZ5SSAeDym9lv2unFhYIV6ypjKUqe5grbq0DKM/xrELs7IzwdvCuxV
	 QjjuNuSyCdKgWYAaG1+uEapi/PE5WRm1sB1qggyqzSW2tcymZriscz5yd3krjPC+WwtBa
	 9xN3l0Bvd3E/NJ2O3JefrAUs4mraXb3ICOuHF/VawSZUFvEX5B2wZVzlSLM4K4HoWCJN6
	 tARTbzsAEykUouqGi5xVy7X7JV72oSPSEkJOVneV078Gm9MU0VpDeZV/9Aob+Eu1hhTlm
	 2ufoXE7S5VAV6srLdLBu/wYCphRTyg58hUN6hylzDiAZmWDEz/beO0roxgBl+uIjaqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iIK7gSWT;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=i+twmrug;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD6606A31B;
	Wed,  4 Nov 2026 05:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDCD6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iIK7gSWT;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=i+twmrug
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S1jQ2587743;
	Tue, 3 Nov 2026 23:44:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=/F0+BwlqCecgnDE0mcAev3c5HMvgIc4d8qFFlGyhw
	HQ=; b=iIK7gSWTIzr+b2KQJYWy4LC9CDYfiJrQJ1thy1Yfo4KH4fuvt6fPmeo59
	8C791i5pugODTJwexetn/o+Sd2gieumLLW63bL/a8qoRX14jIifPMQZY33/jUpBA
	50gdfaufQQVaybBou3R/VFPu8MLdP0NPJmlbravpU7Xq1/lVCWg1hMHKNRhhmIRX
	Xg3QG3jiVFMqgl5APxMJDtF3dBzCVRlBvVkp+4vy102+Rsk4eoWZfjXBKzBLNxpz
	JxxGucNtbREES8fkqy38s3o5T0A5Vo9MDdd7XtNERH/ndLzTLx16MmliHxAdo5d3
	RYrYQAAH2fK8hygnvDrT7oV9Yn1Cw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xch-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:44:30 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ev4JhQ1/kp3L8O1k4/8UwsThGQjULKP97XHkEhjO/svJrSUNRT22arD6kTiPYTRrUCQ+EtZ0Q/F1In48Vbnj/gVuIQf7YXn4mKa6XLTyfa/lIcAJcRBeU17Up3MXKMYeQONvwCDOqRJzISf/ylgK53XKfTMFjTCQpC043Lunq0ivHNSfeYXKYiFQhCHyl+wLxgnrUim7aW84LQM/1cMDSTaZJR9sEdpCqGLgYkfRLAjhMs/5qnI8mxYfzow//+YDyHQD0D+tn5ldWeykvO5P8VPzrQb289M+1WXh5d6YWwhfNrTyBhyVgsVcWxrMm2IcaGl+Y0yAoloxIPqik6IoaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/F0+BwlqCecgnDE0mcAev3c5HMvgIc4d8qFFlGyhwHQ=;
 b=GVvOZezjTUae48c+lxO0i0LedZzfBBMXQ8K1IajEN1yQ1eidURwoDHmMEEWpl0aAliVcgWJ/aJP6UAS3/ZfMZhgyFFilDITaU7gabwSyalvZSQIG9kEje3XdGld9iiqqL4FTToRffnHB5Q2t0zjklaEkeNlcIImtuoAzhYv6QcUj+4XBRWrkrW15KsoQQiiLhzecjmABz2N/Ebv6omf9f7b5VPqbKW3iWunP7RuV+ks8RSMvdHZQvJ7E9ZPCYp+IY1qL8pKYzhnIXGwXZCOzVzkNeEDmjNLtvZxGvLSvjKkr2b7O6OLzPkgKqM+TjJZq2zYUjOFmR0u/+XS0u5b2cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F0+BwlqCecgnDE0mcAev3c5HMvgIc4d8qFFlGyhwHQ=;
 b=i+twmrug8vI/6b5WHsaB/G8d1ITL9a4nvLoI03accTy1RW+we2g8WXooWLeGq9JT+Fkrw4zh/HtQ1trpklAva6dNmE4th48SnNYa+MXqJEbpSZ6Cj9+Y6BlhQ9qjwFHgqSHgKUGDk4g393QVqh2Yq9Q06cLW7cN9rQGZKaeK7nA=
Received: from CH5P223CA0009.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::7)
 by SN7PR10MB7002.namprd10.prod.outlook.com (2603:10b6:806:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:44:28 +0000
Received: from CH1PEPF0005BD5B.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::13) by CH5P223CA0009.outlook.office365.com
 (2603:10b6:610:1f3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:44:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH1PEPF0005BD5B.mail.protection.outlook.com (10.167.244.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:44:27 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:26 -0600
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:26 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:26 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxj521920;
	Tue, 3 Nov 2026 23:44:23 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:11 +0530
Subject: [PATCH v2 01/30] crypto: sa2ul - remove dead code
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-1-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1810;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=QS8JguzQelfbDfBbMTUpcVivdIsTzDBBuaq2EuNuOpY=;
 b=JdR1KYODc+K3vddxTEsBj2eYiZsQmerULfR9rvsGvfyME8L5dtVhPEfsTA+nO2EGKeM3Ulenl
 hka9ushzx2KAQFEMq5kR33X5jLX9dj0af0DDgmGPG9FdFL/BohNyQQX
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5B:EE_|SN7PR10MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: e6fd8a46-6840-4169-34bd-08df3a36b0a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|261026135527099003|261026140227099003|261021133027099003|261021135927099003|261021130227099003|56012099006|261009223027099003|261028144727099003|261026121527099003|261022075727099003|261022115727099003|261026130827099003|261022105027099003|261021121427099003|261022113327099003|261021123027099003|10067099003|18002099003|261102123227099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rUBspCoPNc/GcZJzik2LZvTwfUSs/mLM/+ANatvfZJaxfCzNNzX8IU7PKwFuyorlL2Rv7WnpjrU5PqFO0dAeC2fBYBLYYwmegv1QRVtVb3+ajdB/QFeh6ipkPaDAMK4J1TiT4J8m3Suurma25csdAixDRJ2nNKcxaQli0YohYKMZDUYTP9KBNrT3YwA0wnEcOm0/LyWN1KNV7Qh3C0hCKY2l7vPHZ+dpvY9lG5ZQV0tv/O2wJYnLqmjo8L2ApsAw0ym7qh0pR80HnscYKHBYkQoyd+ugiveK6xIoyPvlaCzSWUa/tcEWXENc6eLyA2UEHBhRECXeeojBTDkjoFWbUv+ItyxRWXfkcSt9xc92OEpZ3VNXwgYMLmF/9ZJpLSYv+lUxpQVPHYOuvJI+ChWu99RUkH1BihwATRMM4q3lgO1Jp1c3zSH4jl3I0IkNpc7k2AaYPGmIBzwTt7u2wkXD9jzpuUtq9mTjZAO6HFBipu27IJUaB89ekbPQ3KRCCrxG1jIPV7CQZbBYOzFwGuXLjzKL3Xs2E+T6D6qqhf41mkvGfxvfUpzWqrBRozJCs3my0G1K8HU32aBJf0nyGzCozlePJ2lpWKRvmhRhx6YykEuZ0/YBcgU/KDRCow9LPWMKgYJGj3BcUTuoAYMEi+hXaiHXp4pcVlL6veA/c1Zp5OcSnHxy2h1ZGWXH1MHJ8UFET1x68hw1JeWO11Ln4KjcVQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(261026135527099003)(261026140227099003)(261021133027099003)(261021135927099003)(261021130227099003)(56012099006)(261009223027099003)(261028144727099003)(261026121527099003)(261022075727099003)(261022115727099003)(261026130827099003)(261022105027099003)(261021121427099003)(261022113327099003)(261021123027099003)(10067099003)(18002099003)(261102123227099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VpnuuakXJ3SpkC7JcGjJAWlixM4jIXi7F8J65cp0ATuGWOwNfKi4qQddrMMwyvfYH6eU1UbMLCMzEAWU1Qi7pFkBZiI2+ry2EnDFylTFfFuSLfPOyXdbPyVPRSX/JmgbScgTBZoCOjgQIvfkY0sTaPjchB39LYk1IzFw9mRXlGOFMLZlOmNu+KaXVGma9zARuvM3H1yTzlDw6INrxQHRiJ3she5/vo6dV2PtlJ9lMEHZN0f9x0bgUCVMI3iYuYDnqneh/w5sPiNyfFZFWC1qbuyNJItmoWy1dMELv+GsdVwBfP+7VEWZnyaxUGGKzGZwgpIXMu1fPOKanfdKJqG5JTsDEPEzYNOpFyTLqGM2IyuvTLjoWAnmrN/kD9X0jsQnv2Dc/q+EUsdNWEt1v9R+T9Om2z/CG8Yzjq0xVWBDnG3hKHIfkl0LBoQ4HuSE/yvP
X-Exchange-RoutingPolicyChecked:
	mPK0+qH6EZ6TV3SXp7N78/979wQxRuKu5p+HIeHBt70y3hGktn0Vhrul7oKX5Oes0qCK4Dd3zk8s+aQ5Q3OqCmM96R76/ii0+0gyACTzxyzEz+IFAlXIMApalpLtAwCtYjItEVFstgiZB1WGvRsCLQ/nqnWgo7WTsLTChHPJb68dLJP6F4SzZHDQcrD4gmf4I2iYeUpi24VvDDxrOFz9Dhni+GbBpWbEPTafrd2Rmc6WMSDNDIjG3Xugn/PGKpDPOBTCbakZfukMfCHmUSjxH2XrvKMtDLccdsOOAYVCPwi404EwgWUe5qK7gncO663AqlSzKc79QQOsxDQ5Myh48g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:44:27.5191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fd8a46-6840-4169-34bd-08df3a36b0a4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7002
X-Proofpoint-GUID: YXDog0h5KD_s6CQUTehItBpYFq0HU8Qj
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac63e cx=c_pps
 a=z9epfWMNo9LgPPq3nTJR4w==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=zA-ofNOz59X0hDzS4igA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: YXDog0h5KD_s6CQUTehItBpYFq0HU8Qj
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX127mEH/h2hKL
 +ol1MGc+tEHAuLj02cbOxfgm7Zuu0cx4EbHYGAvD/CkHluYBn641TQXAqgjKWSePwEsdwoW2oTn
 LFKeqcAYjSuIPf9nA2271c8kh48ZwjQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXzWnGXqdoiXkc
 iM/YVu3zpIo4EtHF/J4imMso6Mpahi7BSWHYRtK3QVvg/8DLZpVwjB6FcJF3EfipUiDSLTo+46R
 j2NN4yrAA1ernAo7Ri/s14mjkxkXQiq3x39E6HQ2quNIxoWioTE4phuWZKGwLjHp/NoBE0RB3Ns
 OO9kO+MOy5WZISovU8ZnYW5GZBlxNZz8MQdNy55PRJbPFdimF3Sr0vyQrMJ/lpyIePhP9KOlheK
 yUW5WKUSpV5HS7Ytrcdh5s/XU7xaKYSNQL/e6um25mkgUL3XZZGlDu1SiN3tNd/YuPpJLy/Kr0L
 B0ZsMiT0kejIAFbR4C+v86UssHHoOS9os7sVf4Nu3E9fkhiYPsjhx66Lo3ubT8uHehAtYW7ltxy
 3QiPcpJTldLACpKamJlkSvhqrSPKro7rX9ObHwdRippP1g/+ijUkVlCtg6FIPs3q+/2C5LpnWfk
 GBkuShsnLzw9jDmM5tA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

The following code path is not used at all, as SA_CMDL_UPD_AUTH_IV and
SA_CMDL_UPD_AUX_KEY are never set. Remove it.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 4557eae94164..5b43b0c63722 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -41,8 +41,6 @@
 #define SA_CMDL_UPD_ENC         0x0001
 #define SA_CMDL_UPD_AUTH        0x0002
 #define SA_CMDL_UPD_ENC_IV      0x0004
-#define SA_CMDL_UPD_AUTH_IV     0x0008
-#define SA_CMDL_UPD_AUX_KEY     0x0010
 
 #define SA_AUTH_SUBKEY_LEN	16
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
@@ -496,17 +494,6 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 	}
 }
 
-static inline void sa_copy_iv(__be32 *out, const u8 *iv, bool size16)
-{
-	int j;
-
-	for (j = 0; j < ((size16) ? 4 : 2); j++) {
-		*out = cpu_to_be32(*((u32 *)iv));
-		iv += 4;
-		out++;
-	}
-}
-
 /* Format general command label */
 static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
 			      struct sa_cmdl_upd_info *upd_info)
@@ -615,17 +602,6 @@ static inline void sa_update_cmdl(struct sa_req *req, u32 *cmdl,
 		cmdl[upd_info->auth_offset.index] |=
 			FIELD_PREP(SA_CMDL_SOP_BYPASS_LEN_MASK,
 				   req->auth_offset);
-		if (upd_info->flags & SA_CMDL_UPD_AUTH_IV) {
-			sa_copy_iv((void *)&cmdl[upd_info->auth_iv.index],
-				   req->auth_iv,
-				   (upd_info->auth_iv.size > 8));
-		}
-		if (upd_info->flags & SA_CMDL_UPD_AUX_KEY) {
-			int offset = (req->auth_size & 0xF) ? 4 : 0;
-
-			memcpy(&cmdl[upd_info->aux_key_info.index],
-			       &upd_info->aux_key[offset], 16);
-		}
 	}
 }
 

-- 
2.43.0

