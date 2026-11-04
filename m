Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771169;
	b=rYTs+nKkXU58Fphq2ptSA+pHKpUTWzA+wmE1oTuWCdyT9CQ3PPzVIBs227nTcl4+I0js
	 Tw7nQQDVmdBnmpsrPAqkB1y8Lui2ikr6m8I+tVCpgmzN1TaEWKz/3GyE9lecFQCj6PkEw
	 5pHeCaS8fWJQiuMUnkxGzmZxpZwnEwZWf4QV3G1by2jU5CVHUJv76g3OBWzNLkAxw9Zr1
	 T5zL//RVJqmw6jgm1+zouG2l7SBQFxtFBBrYxHmF0s67Jtj/q9xVy+AqUg29gCUDXC5tz
	 qAiMGLgett4r1HwQu8RP0BTznMg5plxhOFkssdiIK9kgQjwrErJ/ACifzV8ld4WMJiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771169;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=tDXz8o87rociI+co17ndRSFwFgb91GAYh6Fzh96E9OU=;
	b=jOd1DMGD6ONiYxXYubr05g6CHvS6grOzrDCFBptorHfVF/99ZZMzQHFIjgbCYKTigQTe
	 PJzF+Kq5z+WIFJbBJxtwDmijMR8aI9uAh6opu97ucvq6FLin/JgMMuqIo5xGQlJCZzlpv
	 iMl2yJxPHgdt6fCVCGfBkIR0s4LjlBnPzFxNVi2b2DCjZ7uHgYLPJlCeKVCeGT1cA6LVn
	 cAgtlqL8I9VAa38onYuZmmpQPfWm3G3SpPqgpHiTR7B17EPbAxc2elNebClhA+DDSLQ9K
	 NYqtck+EuK/JNBdUAJN75azbvTblUoj+fC80SdCQT/sdTBgF0vE/i8+uXKcFHw0V6Wg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oqyivYOz;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UMbsgIHR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFE6606A329;
	Wed,  4 Nov 2026 05:46:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AFE6606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=oqyivYOz;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=UMbsgIHR
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S4J1771704;
	Tue, 3 Nov 2026 23:46:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=tDXz8o87rociI+co17ndRSFwFgb91GAYh6Fzh96E9
	OU=; b=oqyivYOz10sdCZ3gHFvxnSkmhYsKt2XfzUqNbnMiFrlBw6Kvu4rT18V/M
	d/sJF0N6j3nPqiT8Vj/OBSDOBdDdMsKUFmdMSKip+OYJ2XH5C5g4PyI/GlxIdi7H
	irT7DM8LfGTREJ7V5k0rqqbLeWLUSRghFLLUsjkmXrnf9noraa6BbapeUZoHfKfP
	UsqXV3fBBC6J57gHYAf+BxVt+6OxMJVijK78snA/9ZuszLB60aoqzxeXClInVQD+
	fgxtPBXfKsMmOEAzQjyB94qAhoQIjt1K55Nb69aXEVPoRR46zpjeY4BgypJNW3ix
	1Az1kCuY7YQBB8Kh7Xzl2ws+RJBaA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012032.outbound.protection.outlook.com [40.107.209.32])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25p9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:05 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVCb38yeE3iEjBKHkjuXmLrj98/csnx097BXW2mjKC5jLFThgix2GKh87aYejfNRxA+9q8KmzxQfvRsJtDg7IDHvHNjfeulkiALbk92U+z6GMSKZQPDrSpGflnRt1NyhNdM6sRJHlZsV2O5orf3vQz9auVMJYQvRlWwxq6a5SZHVgNc/A0hClPjkPBkb3vUYcxeRzw5CfnLQmq4jgpyAGsbloaQR6pf9/Ikq5iEWG8/X8TYLmVUO530L8jNuIu6n+xFbOAxLE9dQgT1bXDsB2hjK70YOn26l2DVMJ7QEwqkR/VTpDMq8SL+uRaZk2KQDSMiIxHi6uJjY09gzax6fxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDXz8o87rociI+co17ndRSFwFgb91GAYh6Fzh96E9OU=;
 b=T+bsqPtsER0efqxFoDhKBoMgiw3PM/8tVtMnpdK0c7A3f37Zm+Cp/zNJYfxugVS+2T41G4S9g9Hgs30extpeU4cypQWDZ4WPqajYkkbyQaX79rLr9nWb3xzYSnn0l+Iev5j5CrSbGCfsX2rNsyXabeNxxY20582kuDWhkXTQMpPhuJv4mNeLc5pN3qzYNfz0oSMxxc0/bJ7Ex3YTT4UYggJ71seQwyzRWEwvlgtWLCZIZUr8RX1EOmONrD1rNAWHU8OetLjqiwYqadogqp/BgzMLm32/IM5ccKZcaRvgmwG/ytPIGB+dfjs/bg2K4/LMS8jdDauORtbXS1QQedbORA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDXz8o87rociI+co17ndRSFwFgb91GAYh6Fzh96E9OU=;
 b=UMbsgIHRFtTMw4hds33Rjmvtz/3R5HEMv7HBEuNU+Z3x3AKdNOBIz4jYKz+VxtO9YI1iCus0uy1kMUYLrugHhX6ozRR2dn3Gs0k1MRoz3Oc3pYSYDJ783wD3S2eKDAvvTr8DFrejQbS7aKUYKlJU4inMU8AZQ5pzWCH1K2/8NhQ=
Received: from BN9PR03CA0858.namprd03.prod.outlook.com (2603:10b6:408:13d::23)
 by PH3PPF272D9E96C.namprd10.prod.outlook.com (2603:10b6:518:1::790) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 4 Nov
 2026 05:46:03 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:408:13d:cafe::9c) by BN9PR03CA0858.outlook.office365.com
 (2603:10b6:408:13d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:46:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:01 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:19 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:19 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:19 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxx521920;
	Tue, 3 Nov 2026 23:45:16 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:25 +0530
Subject: [PATCH v2 15/30] crypto: sa2ul - remove unused SC ID range
 tracking
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-15-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1894;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=u+sKmp7huZNPqwzmXY/4qtCyeGumY6nQzVgi62JLTrw=;
 b=MnOweoD9Iy33ulEgWrcTPmxtR6I/ZG877hXRy11Bz76E+CJjqnT3PLfxRuEFPGYRpDcT/KngG
 MKW77Wt1yasDRY+W0NWFH6+4TIBiUpmEPZ+/ef+JjBUIwDbf7NfhIb0
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|PH3PPF272D9E96C:EE_
X-MS-Office365-Filtering-Correlation-Id: 794f8b12-9dd8-4fd8-57a9-08df3a36e894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|261021121427099003|56012099006|10067099003|261021123027099003|261102123227099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	VRfeZE/bLm5Y4pMWM0fekwI2plG7s5m7EXR/r7A1SBOqRR1DZ2Dn83W221XqQQ1Wd+L0nHGLmlXG+6zuWfGehaNzpKdsUSPxUfOwIj/vUOiU8ZeoAn5o1EVOhoMcsCfjRPgPWDJZj08lvFAGRgrIGGIQKefP90G4rFF4mLmb4SCX0M3B5dGDOcXwljbB91kaicAPu+jS6g5aw3QL0UTOzqtudpGuTyxjAzv8uVE/MFNj5XpeI2uQWY40TiBC0yPbx6eJZyLCYLPlB8gxo5wTjFprzLLCsQu9ufNxiScj8GyLucAtEVeFF6gyVJmerLrMoDJaMwBWt+mqZkJQiPfKvyIedTBpxsZuSTWp2Fd3xa205ZQxbiWvS14Oztw0O+rNJlcMUQi9XrqlM29PPAc7eNkRy9wuXEmh79oBwbaE26qhy+Dos++TwT9PH5riDLPx+LHowDMmaBGevl+chmEibMfC4Jshrlxymi5qcrOb7arhRxdvXnpUDj0hVRC72/dlX9b00v+jTwzH5Qls0W8nUvFpNpbdtu8riUvevZiryQcpyh+mhoyxOviPG5QW/IEx8TO+z2dN/ww5KTURIDkP/avZzb/RdA8hBc0qzXWLnyJ+Vmdvjm5emogOkvx+cIBRpWZge0kr2sj56xu8q1xJexElCPnXxbqmQjJ/2TXXmv8rlXp9BVqFGO+qsbHLPlbCIM00wWSgYN7GX6IwrjlVRw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(261021121427099003)(56012099006)(10067099003)(261021123027099003)(261102123227099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gL0JdiJRjV2lSNLkJjergAp66XEsq6QiY5nD0NW7om3gaCMP4bUGjPs+mH1ZH67GoJss+qnFa/fq13IoWzdzXGOmbgUYK07YMMQpsiQUQrNMOJSNVAfcc8CkLW8MAtL4Ds/CKLC0lrWGemgLO2jz95PhP4/Ad7IThNrezDaAWiZJEIQ4tinnZCqP+sna0W6bTrbkuYkV24fV2466sLNGomgYJ3hesXYhU5krvUSmtpc5Nn7m+PI/ro9oVsis6DzuW8DsVLSKFYM1bOZlezQ775lrFbnwxwfB9Cb/NA1RjwK7LKmPl0NQnzp84hsZzNE3c937aVnZwjxrsVhdNECU+AMJoYJFTQDX18k5tSritWdRG1xkL3L52pdEHkRb+KsQCF34SdopfffVvBXdmkJKHCQRdZs5ZgkTjnujzf+i/X3V+tjiszmTPp7/1X1Kq65K
X-Exchange-RoutingPolicyChecked:
	4t0it1Psl9ndMb3HiA3rNnnWMOJ9RW8ndN1F5kv0fMAQN2f7vOx5yxQOz0A7uY8hlOKV9sILIsBXGyu9Bp8WbWqvInz+AtsdYUD0gFDVAqE/b1GZBM7OlxabFCtfRJ3PJi3sHtv3WUa6dQ3RwMV3r1RqPOK8HVbnQiwhU0q13vebVZ8yvT2QeANxCIcmyKSU6q1s7n75qYbr8G0fjfQvabhs//Q/6NC7+dCdNynheMU0hoGgdbrY55ZDHpOXd8V1CL5uG1cB9PyN8b1zPGABo2Ff8hI/Z6qfW6IT+nGqWnLo9n3we1HIksaP13otd1CMeqfkmmeq01vuIiFVUi2Kjw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:01.3405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 794f8b12-9dd8-4fd8-57a9-08df3a36e894
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF272D9E96C
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX6zfh/1zb+xVY
 yW8SpDbkxNifW8CpRvWiwDC+8sHh1AYytU8gY+8/RNak9gdwT31ZAow1T04NoWdFlJSplCv4uar
 MmcK+YORf2gzIXiWWtIr2YqKgGJBHZ0=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac69d cx=c_pps
 a=Eb813/LJkoRL1pr8t+D1ZA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=P3Vwhu2oc3E2_STrwkcA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX/vAZcCe82c7A
 DB5sv53ane52X3wkBIg03KhvdArgtdA0GOzr5Q0Cnn7/hanoIAUkEvqoNHWDSC7+R81bk65G1VB
 +3aDjvgDP/RiPUdaOWiqizmOIzezWalMQH21IvbH8sRFwjdLWfrMpVdPsq2Wtg0BHEXZpNaCOIg
 V0BEnBHkt6JPOdt+18dDZSVlRgJz+C7NLyg13j/xMhLhsPXEOTe1+QPJDWmSqbMQRcXIpHXS2SK
 1a1w/0YSaJJEI5y/ZGhoGOya40/ty9zivm9FdhNFPRnJTqhDlOJ8rsAS93F42GaFHS5bGPc1aNP
 MnXXkYEaZevAFFm97JYlZYqiCQLBvhTNzH6EMzAtzFtOtOuKEhrveI60ivmZdALb/z25A0Hr/7f
 jy+Kl79iEF77DMeK1Jr+QmAecw6fBhAIaLaWp9/rk8ui0WuY4KKQIbGmpc9ZaYFBlXiqtrWVSfJ
 EPBhzKuiPCmQ+cmJFlg==
X-Proofpoint-ORIG-GUID: VTyaO-3S50kP_FWLzLWNPha5NSHcxxZ5
X-Proofpoint-GUID: VTyaO-3S50kP_FWLzLWNPha5NSHcxxZ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Remove unused sc_id_start and sc_id_end fields from sa_dev_data.
These were intended for security context ID management but were
never used in the driver.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 4 ++--
 drivers/crypto/sa2ul.h | 4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 30ddefd4c0b5..022a95e40698 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -690,7 +690,7 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 {
 	unsigned long bn;
 
-	bn = ctx->sc_id - data->sc_id_start;
+	bn = ctx->sc_id;
 	spin_lock(&data->scid_lock);
 	__clear_bit(bn, data->ctx_bm);
 	data->sc_id--;
@@ -715,7 +715,7 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 	data->sc_id++;
 	spin_unlock(&data->scid_lock);
 
-	ctx->sc_id = (u16)(data->sc_id_start + bn);
+	ctx->sc_id = (u16)bn;
 
 	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
 	if (!ctx->sc) {
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index a717c5bcf061..0788d68bc30b 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -180,8 +180,6 @@ struct sa_match_data;
  * @sc_pool: security context pool
  * @dev: Device pointer
  * @scid_lock: secure context ID lock
- * @sc_id_start: starting index for SC ID
- * @sc_id_end: Ending index for SC ID
  * @sc_id: Security Context ID
  * @ctx_bm: Bitmap to keep track of Security context ID's
  * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
@@ -195,8 +193,6 @@ struct sa_crypto_data {
 	struct device *dev;
 	spinlock_t	scid_lock; /* lock for SC-ID allocation */
 	/* Security context data */
-	u16		sc_id_start;
-	u16		sc_id_end;
 	u16		sc_id;
 	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
 				BITS_PER_LONG)];

-- 
2.43.0

