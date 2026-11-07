Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063542;
	b=RzJLDyAhvyRciTJvVowH2Gf5YN7T8PXomo9ZbITk6zNSU4Uabb6obzWzjRGYQIi/NR5B
	 BNy1+ES+UcIV2IvNGorUV98AAsYkXDg4LdvfHO9B1n8L/ZzEbY8PRYIZ4TmasGFGablza
	 2TtEesqKuoV10xOUK6bcfrC0+7aunsTmDZs4dlC6JJcI1YaCcVzG9xNIf6Wt1wsRS8zrN
	 ZXtfFXk6VWnp5cm20AyQJtCWpdfqA0M97aQn+oHTbyPRescGqU0qehjorFijjiDYYwWMa
	 j7VPiok8nlOEuEYdST2SOKZRYdasQCxa+PunELFi+IbjgMSQhtNEZZXA5WY13cCuPag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063542;
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
	bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
	b=abuKMiml7fp+JbPStJe0pdkBJwEBPZQL3GDGgNFH3q2alapoMruMBXC0V0UhdOxrU2uK
	 uJ4xX7kDFR2XKSk/bYGFWbwdukuBGXl0EujzHJysIw++pCPkURNRFRGBUGjup5pgVu+sl
	 uoZkkHdXk5it7Y6VZdH8lMRx20G2diD24qZ8tbdrX5RomdHjG6z7CTwTb+jcMT2xldtv3
	 QelOmFG0YNf2U7Fm6seFQgpvUO+DP9bHdD3kmlfHP+3hZU9bzU9BqBxCn+jD1KO7Xe3j/
	 75FlfxGqfID7HA19HNUE6fhBycPwp9sQTmaCgfsvKEe7YL+fWrP73xYPv/Wp+FvEkSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XlVWG36v;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=iiqrl5QP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F2606D802;
	Sat,  7 Nov 2026 14:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A2F2606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XlVWG36v;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=iiqrl5QP
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwUkp2005520;
	Sat, 7 Nov 2026 08:58:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdam
	Sw=; b=XlVWG36vPYxl82lh8c/47QqaoizuI7GZlFJbAcoIB6l/fkNyuegfbFNR2
	9fnKZdxreYXkNxXE3m2LlZ6N/036itP9XjRS4BBMzghEcORBL25k5ePEHSVGmL28
	qiigu0fqhx60HW7UAjptEbRgMU7pQx8/0yxGT3Nex0xQRrmhZB7+CDhi1bjjCpBv
	HLTIepm72RWwfTJY0T1VwMZK4kNA8ZUA/uDk5v//qJG2qsYo5dIdJY8Hlxtov9NG
	PmcFLSEs6PKKmp+A0sec2IXOd9sceDCZPgP1PDNGZ5lyn2AQvMbQscui6CzCGz77
	DdIFDHkSDoM5Memy1QSwNsombDcYQ==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3x8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:58:58 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYx4636nmJtM5fx1OoulTFGLuCIhYAVmAqgoZC9GWwfHTdJQjSU6DiOt1MXlAWBFMMOFZ0Rbjgu0Rx2uOJ5FFMI+cRQgB1jwJKgMG62UHIZ411Qe3cO1n/WEZybCdS4ygxJXplkqGRgybnhDwhTqnBGdTK4NvyajeNRJ2JvfavEzFUTDU3AVCd4PMeeyEH0rzvy9af0wlC56elRfhS4cPA6wFZUZq8xcjH7oDg3WQGOW8/rtEG4CziWFonF0Ulpw0Cv3A2Bw2rhwUwPYsY92zQqJKQz+v31zwoXpQLhH0/mNW4jPSZ7q4PJllAibMCJzekjuCSzKlyw8q3Up1rGgTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=OeR5ErrUOCKlrKpt0kZCOo3QnLdUkCdFb4bgSJRQkoI+wh6Ul4WYmjVLu1bClIf1oGtVlQdsseHzhQOUM+4fVuSWDULczID48FWym/kVNpe4Z0jbDkF3v0sM7k8sb+hdj51pd7rJVtqcFMMdPsOkennR7YVKz8UBdacyUHO7g3zW55etuMpVGUX1U/sh63OB75Loh8jwr2VpZIqev8dtuGSh2OGhkjp03uJfQ15LK2dcsrDe6qf30USIlw3O10Xr23uFyjnZmoinIWHfj8EmPPQZrD59qApH1eIdlfBgVQcDz/fMUnntD62qpqHL6ShBKD9gcmV3ycUHwvlogvepCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=iiqrl5QPklWw0NgFOlf+52lSMxO46w9cxpdrtQUNfM393aF/og5XsgqNbW3robUo7fFi1Gsy0UrUryOyhXv57Kte2+lSgK3AxtmmJS9IUItJbD4zVCXiW83dpP79Np9CcsErlInrXhpjhKUVp1sdlJa2QRuS4C3dpiDPFJ5Yhg8=
Received: from BN9PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:fb::10)
 by SJ2PR10MB7826.namprd10.prod.outlook.com (2603:10b6:a03:56b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:56:52 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::30) by BN9PR03CA0035.outlook.office365.com
 (2603:10b6:408:fb::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:56:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:56:49 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:44 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:44 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:44 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EuhKF190523;
	Sat, 7 Nov 2026 08:56:43 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Sat, 7 Nov 2026 20:26:05 +0530
Message-ID: <20261107145618.2349562-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|SJ2PR10MB7826:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d74696a-226a-4c49-d54e-08df3cdf5a2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|261021123027099003|261021121427099003|56012099006|261022105027099003|261009223027099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Sbe04XN52wCu9p3QxqjT1z/01RBT+y00Hu3zbigiz9WUB7lPn2l3tz7VLEQuohGUH3zMOhtVr++BdbTzURt4VkXqbp/0XXu8TXVJFnl/pWsHe3A9pAeKTzLHA67ufB1IswQIsoAu2rYfkR677IEi2gNoITqfPTQCas5XQ63WtuMwTsDFlbHF0Ha9Pm90X8fLDu8WIU7+lDsYFoV0fj+3rIFDua4IxxB9Zz3PgYO4pfcoe33CCgXy3Xf6q1zvA5o+XaS36+fN++x8P8LJ4SHfvj9QyTnuW7K7O1srWxOM7Ho6qjmfgD9DygqykYoCbM4zBESwLgorDDRfO20ScqM2mHdlG1rTC8/JT8dcF6DgkY9TIL5cf9uxz0CV83nHVEqmdgIUbvej1V4hcdyaBCE8tAWPIQNygozqSyqluTx42/xBgTgMEsT+21xSxxiNl2J9tb5lZ7YtgZxrWUz4D3HG9sHMZTkfmHuUzX+ofbg2kWkxP3/0BiYXis6eTGwGXnLkMo8h6KM8sHBf71kXHJZbGE9Xu88DtN8zk1rY6qoLUGzxhOvjMPKy0LzU5s0g/nFKwZESQ3fCXyFqpku6duPjTtBsyaeXHWtBrTDPhqnjkDWneZHrlDpJz3tAkQvXLfp9+l56nTrpqfha+1RV+A8FRbJU56+U0p6Wzn4pMegHcxFqWw/78I8gt3aj/PWRCYvNEf9J0kw0IpmIdfzAKvQC6Q==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(261021123027099003)(261021121427099003)(56012099006)(261022105027099003)(261009223027099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nn0KATmw8BdS3VZqM5Vy0FTgPLDHAyJv7bPGHOaJtkBwtQ0k5R65ex5eqd1Oauwt2FCpY0jFibXtDwy5AbL2hxW0mFSWmLC+RVb7vekHfMGDTPPAhsncXUksk4wj8vtNwzaHelaM6hZ7geJzFuUDyGwVVA1O3Tmos6xHPBiV8zfUJe7r2uOV162gOk6n37mGPHx8QWLNuoAsGA9axNIoIdkH6tKZsb/aQlk9o9PNmmOmXFcYfbf8cpvF0cccLDASERQ0TUBXH7oeF+rfAaGdKcXUC2SrwLBYusAys1fOSQM2PX9ggoEoAppWs/2g0S9xsboZ4vI7HLhVe3NPDMrNL7g/LQjpHLXUZl4OHMx00kYZ8E5Qe66pX4QvdQWrgZMpBXm+5XS1X8kNLOFqTLH2QonDGUCBtxKh1vh6PM5cTsWoEEDOnXPR3nVA7G2afnRo
X-Exchange-RoutingPolicyChecked:
	wLDFeoEDtRB4ul6Zb6gVAM9CUNA7aCLXhDmB12NfwH2yiJYmBDGfBa+M8Urr9h4EdElvmJy9+IXr1TiOq9z4ZT2XPZAMEfK4+Ir4nERwMZxeFcuWUSmbqk6iyvlGz6Tti5MkbnzU/YTICY9S12wJo8rzUDKrGYkAydhbFBXeA9WnSbHRKMu80JK/6OKhu11b5PPUdxSEprX/piJLkhIjZgHZrxN/AwV2L84bbGRMCF0NjuMfahzYnyDAOrDnVpw9gu2fA47hyeLycItEBbtKKFY6xQ9Ay6thHrDIegI30IfFDuwgi9GCOOi01+Fmk2HZlWR+Ap0ay62FELT2qGi38Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:56:49.6919
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d74696a-226a-4c49-d54e-08df3cdf5a2c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7826
X-Proofpoint-GUID: _qmLpONjv8pGbQsQpav1BZrmTysZOM04
X-Proofpoint-ORIG-GUID: _qmLpONjv8pGbQsQpav1BZrmTysZOM04
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX8t2OlSeAyhmR
 blulIH+rZOuX69ZWg5SF24rJcBfk5Rd6MMVpCTKdQGWclWhlTGbG+l0oSiuAwRkjxDpX3Jwlqx9
 BYp/apyrNZxcduux2XqQ9mNUVParPxQ=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3cb2 cx=c_pps
 a=e6K3ZeJSw2wYQu/wAm/p+g==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=XwTwKUqyhKWgmV1Ix0UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXyT2UClgugcqY
 rO3KgcK/1dd+xuyr6rfN0hIDnWNJO5tK8IQJYnfgRU5Ez7nkeFlqPx7UWfiCSXs6cu+mODe10qk
 U69eHms0JKao+y5a7wJ77VIh6SFrQdftbaHfdCLd4/UuvK6JfRbnh8LNKsmtdtunyZr2i5yqvw+
 zw2dBZakMIjZOm3HaWNwa4BpAlCNevT1x8/alNak/iGeUl+cnq1W0g4c+fy2aQPiDGXCDBP2FHU
 6XWGAn9czErBGJT94v9N8AZz0RGhRVjRd2FAwWaO8Cw3vZMO6swf8AZvTWI4AGAj3x4LYLFN2/y
 f0zBLWKmW/DnIZSy4c2bkiv36UNumsODz933F44ZRcNkwdLG3Kqxfxirx/hpzmyQxO/vpaktTv1
 ck70h7fukuNkW4zr5Y039FGBV4EnzZ73G0X+ks2eBnOWJxsfQHonpD5BNz0Yw+aMz25aeVknat/
 CHjEhPnp5g2W13gRnzw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

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

