Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771121;
	b=VmbdxDEXoqfUXZafJhsp0axTUvL24OdiBxnR8HPgi95eg6iFZpR3PAF1XpqTaDgCNJ4w
	 Dfh7cKkz7EhB33UGjckTpTYNyL1AnmXFUNHvgob2hqYfcX8HU7MVffqpL09CJumMbLB/W
	 67VV/6sbbB94GFdn9JlZNlR+x1kFFNS1Zd/Jyen1F0TVneX6zKkXWpRNeRO/8is88lL9Y
	 SZjj7e+Evy1esjnMLZU8QQ+8AEUeJ6vuh532WaprKKIog9Aa/X44mc1mBtFI4kCyN+/L1
	 ioLhENmlI4RlDh6bcE7IHZnIWR26R27R9dJL3l3zsaomw8LKhF0ZXaOa/93WLC9n9dQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771121;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=zGSr7FwUIM6j9Y6hhD6tENn0/DPdzWzvb7F1L4qkb3E=;
	b=tEBYBHLZ1GqW8nX3FTDrE2LCrESyCIthTGSlexa8rKIMDpW/9HOhRTI6SyfrADYc/hA8
	 yzEJSr7gegxFFXI0ieOrwAQMEtiEpgDwXZor12Z4iOqNu01FleRIuK+CCAWqbqTFUKuXx
	 BICPp+CGzje4cvXqUR40jbcPOpDyKkkNPqfwL4rxw2AnLBgSLox70ZL8kazbUGn1lSFiU
	 tf/K73lgZd5PBn+WiP/3PR0yTMM/cJMmjp6ty5TmWOTGQYIRMCfHJ5DDoorIsvXs7+bob
	 hFSHAQebPUAUPQar4CKhiQppup6nAyRRN10dMhTPTq0Q5qX/iQDkOXobpw6jrbkUBXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KHtgJ8So;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ltKWAJhS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9B3606A31B;
	Wed,  4 Nov 2026 05:45:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F9B3606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KHtgJ8So;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ltKWAJhS
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TKs3601412;
	Tue, 3 Nov 2026 23:45:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=zGSr7FwUIM6j9Y6hhD6tENn0/DPdzWzvb7F1L4qkb
	3E=; b=KHtgJ8So0+oph2C7Pf1BiSM9Mj8m96tGCGDNS/C6aKf7s8OyjbSWGf5QD
	v3PcXxE/yg8YW41GCToPUL0RjHgYyXXuxLkDvfkrSlwtPmrGFuytntBIzeOSi8YE
	Pj3Gn3Sjc7z+5U5EbR3crcCCjd7woOj5Ms7xOZAZnqBc42tVnYQXGXZdF6r3Jm11
	EUm3pkqpHQqKf9ynYo4d2H+ulIbBMerHGEwE/u1SH6YV1VNuLey9L+uVwEJWsOZV
	H6HXWnXBZd32fbjsRfgU+qJRRdr/M68HasZ0yU9AEIU6cMOzsRbVKhGr/v/CvIt4
	udmxpF2F7RQkUZ1slk2StCIE7twcQ==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012048.outbound.protection.outlook.com [40.107.200.48])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tkt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:16 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlQ43nhMILN7D7YMPMUQXczXImgR5laS3Hv8AZrf9L7ReIvkaA3vUaBU2bprFJCXCJ5cbA3LoUQWCgckMfzifU1AX077cYWemlLxoGarvsC5g5cSZkFEpqoMbTlTMfkU5p68b9jEmOwrM9jhFF5D535BdAdu4aK4VAk7jQXHlQuGo486SEm32fomXCj7SBMIqWIBZdnXdgDcCyFzF9ku08KMeRBJHLpRgdQco/kkXwPzGr/1rfqKdFKRdxUm0897Oj7Q8sk5DhbeDEgNH66NxwwtqDoYHAsnHPlrJ7TOjqUETYAiHPGSg7xIoKUs4D4dfVzf7US0LSQXvP1L00z+Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGSr7FwUIM6j9Y6hhD6tENn0/DPdzWzvb7F1L4qkb3E=;
 b=M1fTc2u9DUiLHKBCtHT2NzQzKmIr2/h368oHxxM0U5qD656VN7IhrnwnoYdsR97dgTe8qLBXxsLNLvJdJyWSldr9AIPe0XXVI4Aj/B7Sg4DrkYz8vEyTMucehQSMWR/RtjKQClCsymzB1hiPo65vJJl5mbHW1gegPxbf4utweSDoyBZTLehoDItHhDSECj0v6tSx6McHi7FNsgxn/+ImkLW3DrjfETJf2js7gndp0heGRVkcmaww9U1KGKiGfxvCqJIkQJtPp/wlQ8YpA35qpu1tpIcM8EgSi39vtVAUAeCYQP+JhV+CcIpeS77zaCUcXdtaeDUOJOH81FAaeWFesA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGSr7FwUIM6j9Y6hhD6tENn0/DPdzWzvb7F1L4qkb3E=;
 b=ltKWAJhSbG0mpEMNqYK/WmcLsHx3V5CqNETzTQpwzswZs9LEG5mMpERObZhsan9KkaeTbQ13TofiYkPhS22XRtyWp2HGrVeBUGlzBx89oh7DSqhNGMxT7htz4w0unM42QiCK0yZErvqyVX07xs3iPf+gZDUa/Bcg8nKYLbKaO90=
Received: from BN9PR03CA0101.namprd03.prod.outlook.com (2603:10b6:408:fd::16)
 by IA1PR10MB7213.namprd10.prod.outlook.com (2603:10b6:208:3f2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:14 +0000
Received: from BN2PEPF000044A7.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::b) by BN9PR03CA0101.outlook.office365.com
 (2603:10b6:408:fd::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.10 via Frontend Transport; Wed, 4
 Nov 2026 05:45:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A7.mail.protection.outlook.com (10.167.243.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:12 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:38 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:38 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:38 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxm521920;
	Tue, 3 Nov 2026 23:44:33 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:14 +0530
Subject: [PATCH v2 04/30] crypto: sa2ul - remove unused context fields
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-4-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=966;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=Mxx6CdyatZJBffB2RvRHlPDRdDkCkrBdkFMJGRJhAZ8=;
 b=w+3Cv+yrJFMN1MWa9K3QRWsx3bF0J05P30CNNdOUDuOZEv1+T+FdCl4EQnM4S5CHYGnooyrD1
 IJ0y+xXeLj1AAhHSaOlUE4gKkhkfwS97RQKR7zenXUVVThc2oa/tCNo
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A7:EE_|IA1PR10MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: edd01f11-f8fa-40ad-401e-08df3a36cba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261102123227099003|56012099006|261021121427099003|261026121527099003|261021123027099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	uE3SrBWONBaIqoWQTkABFYgh7R45OhhODuyPAWEQQGyBAuCv9oYDKQ7mFw7pVgHr9c09a96O4Sugy+sKfId0Ibw39soXtkMjxxJRcBqIACdfKUew7TIizuqTN/rSzYAS76mAHOEP1STO4RJGjYvP2WvinebJ7uhps3iVqp3QqApIDtiyGlR8X7kH/gDBOj7XlKEKGVkbC7XtDEL4AVuqDc4pPAZXItaGgPtpp0NRsYEVLJUE/JbcEHOMHJ76jMXw1rXl8p0ONcvUyZiE+9jAFycalY02WnTYDy52N1+ASUC8v/u9/ckI5un7HIIE+E20N/LnUvniowparTICTY0h51XpTYPO5onlRHQBiNb20NKtc90nW+hqXAtWr/ChObaPf4sefeHdDmaaOE7aFAO2Bylr8QgBPqigqozF1QEoOO1+k9crQ0dezs6qVCv8Vy1t1v/a80cbw9IK8nVq7e8+Du7q8gh8K0naymqkq72jIN0na4rUCkVVqnZoj0sUSprCMHE+N7QSrnyHKVlsc8PXdcdIPvzqBQPKPEI8lOYzPdVpOSFQRsdCKr2sGpONxeIxko7sgS9tzsXjQH6m33GAKMxI92gpOcZBnWqla8RDUBxLO6hgw6Skee6kZhIjQl4yCYTWPWUfhgsBTaeXF1PtEOYhtfRwsN2vEsACsQOATJHc1G9AfbDq0pE3tnNKy0wJ57lQnH7ha9cTdPcd4+mz2Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261102123227099003)(56012099006)(261021121427099003)(261026121527099003)(261021123027099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hzMFhZYe+W8O6R91pLfv0N7rIIjXwGhVpsTwG6oB+nd2jzh13ATIEPIM7CY2m6/GjEOcN0M86yJ058ybSgjGmE3zxKmPynHavXxd6WV5xPXSMDjSOhKgoUjB7dXUESyvh7q0Oml1DxW75oBSlre0oLr7tGWUtZ6gAdD0WDl2rBYED9T7SvcJCGsVyMFuEa134dWJ98ASCzBYo5DG/q8lFX6C7ndbq1R9STPKE2CS8oWW60n6YrL6F0LhlmO99atpvqDMFmHfUP+EkXv9SvvBztpnMbdsTZjeH8/bwGz2UFjC7IkKivo7bSOwler6rdVIZ/ZV/PRTPPD9iGbXtkHQuH2sPerg5/Pql0Y3ysqv76Nq2VHNt84fbqMtdRIl8AYssfx6A5XAHDWprK4JkktQDr5qiQcsFW3+uvZBc6itKJZa36HGjKb1cAL/aAuZNNdP
X-Exchange-RoutingPolicyChecked:
	f1PAy9K0aYg4bSDPsapENIpwsMaaijMcLqsPABad4jE7OV5lFM2mHxZ7tPO1lk6ChsjnvomqUY3orchA/CNaGHFoqyt7yr5weVt5znqC7Xgrfbo7SD0RUIxZdkwZ7g+olDGZ/5tdUFO8iUp+O9mHS2hSVpJ3nPmBKueBCqiEjrtZ+Ecrgr5PnGJ4jfBnl+zLoQEtjYX/KmcohKlBQ6jt+uL3zzrfVIs3jm/r4sJxDSEV8PdMQ9C6xDh/U1jyWIDxIfVP9gwlo8aPyjYbMBaOoXNUKoihAueQ1ocuJHqi+XYUh0q0ByFwvxoX6Me5hVku4CKO5U9gB3suDacJFagUCg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:12.7929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edd01f11-f8fa-40ad-401e-08df3a36cba5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7213
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX9qtxCWIgTIq8
 nMG5dl+X3vyTAGmUxv5nTcUILUpbkjeNpeWJVHtmX1BS4niyKCmlGHNYTz+HEb6xlLWAITin2Yd
 lGPg2aoasgkH4nlGjRoURZ9FKaWepWCUuk/TPS/SmmMCQ/HcDj/n8cYw/lW64g4i1pOuljYstKe
 JybuSCKPLVRqiGDLhnerMPCbaFdsy2jxsTnJzf0niDesKq93wNddqfDwdORpbnEU9hdDlycaO6f
 cR1uuwLwSxA/IKSMZqsFuy4o+xVnnqkOhNJOji5rdQL3vsG1tncwrr7K08eOAVqtkllM4VSAMlC
 et4JibC0o0TcAOV1ir86GKtdq3viYwBxuounpOBEMRGUlQQXxnlkpYLGAqiDRuWmLZBXUazWFO7
 k93fzuUX6Y07tJdl5WvY7ZYwabtLzxqEcio7lF9qLtCNHHCaTeageEOrSTsSmp/OrBnsPpMZMti
 jNoT18TT9qv52t00B9g==
X-Proofpoint-GUID: Ug5SijME-4IpWC11HVERlBBu9HxSzEow
X-Proofpoint-ORIG-GUID: Ug5SijME-4IpWC11HVERlBBu9HxSzEow
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac66c cx=c_pps
 a=JJStoDgKLvGmSPu1zToK9A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=f35DKimDB13UGyxuG9AA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXwEd33lwnliNx
 KIJKUECYk9qpSF81XDUGv1A4Cn7S3jDQ/g68LeK6GKeO2K6EPxbiDC/SH94rosNCzxPVeNPtErY
 VlY08zUF0d1hCgMbNSOLjADCy6dBh5E=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Remove unused context fields, their assignments and kernel-doc.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index dad60aa77d1a..ebaf10cd7dd4 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -279,18 +279,14 @@ struct sa_ctx_info {
  * @dev_data: struct sa_crypto_data pointer
  * @enc: struct sa_ctx_info for encryption
  * @dec: struct sa_ctx_info for decryption
- * @keylen: encrption/decryption keylength
  * @iv_idx: Initialization vector index
- * @key: encryption key
  * @fallback: SW fallback algorithm
  */
 struct sa_tfm_ctx {
 	struct sa_crypto_data *dev_data;
 	struct sa_ctx_info enc;
 	struct sa_ctx_info dec;
-	int keylen;
 	int iv_idx;
-	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
 	/* for fallback */
 	union {
 		struct crypto_skcipher		*skcipher;

-- 
2.43.0

