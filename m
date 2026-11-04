Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771104;
	b=22RVy6eoyUS1FO2FqVcwawVT7evs598AWEqL++UBWc9Ndh1FaSc6FbqjnvwZX1Zn64Au
	 xpZDHEZqsCjlXk1OrMY2oe/pwo7vCVOaYyFYNfa2u3Mmx2PwHVBktObmKJHPggaSyAWC5
	 AmAe4KTt2y3vwPsOCtAFT+s60v3CGh8E+ooDFWAd0nDUKW3fhSlNLxeG168Uo9N7DNcFq
	 Jxe6JPoTB8ifUo4Us9MUZP7PsUfLVt62Ol2Ppnjkj/E4hRanHYNbLiQsw9aOunuzEqs45
	 G2TdaEzbiO1EdZK7Z2C0LHcB8LdhKgKrHgt3hQS2XJabM2f+7vBjKX0xpXKNZplWtFw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771104;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=V8jCc0H8DqNv33HahP8W7SrEMuX/A7BQ+cnAsZpi3p8=;
	b=V+HGD4Ncx32PYanB4OZSPlZfKXj68S82FvRxODXz1rcA1S0Bo4k9gCy93TmNSSI5YKgV
	 uUPQ18zmNG6DfYRQsnBwQMOqf0bWF5ghq16kl02Jf7+JcUHRFnwOE4yMDi2IVdLUQaIST
	 YbQ9HbRiOfWd1x8q/yKy5Pvrqyc1NeAWRcZ5haqbS2LKvJ2qG345y4oBgKTaw17kpYQpy
	 Y+V0ABvZrI3V1giqsLSKuUFCcdJ4WcL2FQdCEK9SlEj4apAUkYp2r0Y/WuFYx/gphqL04
	 2JZoYM0Mt2fFVKZjWf45wGzA3BZAJTuxhYZG3CnIyLZQEDNy//T57k/VeZ5G7pAdMLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=pMhQPjcV;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=lsuE03Y7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44511606A32E;
	Wed,  4 Nov 2026 05:45:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44511606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=pMhQPjcV;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=lsuE03Y7
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5xq1166998;
	Tue, 3 Nov 2026 23:44:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=V8jCc0H8DqNv33HahP8W7SrEMuX/A7BQ+cnAsZpi3
	p8=; b=pMhQPjcVGkWe2RLLlrJIUHjd+L+TVcE8X71/clXsp4tqw5fdUb6Iwj51I
	OGA5qIg1x5SzM9p+5HgIgSweZSzUfF5ZIUrFJkypdQDE29RrmPX3OAmLG2nhtM9U
	C0EnVr3nSgHCo9Gw8ShfGxQjDu1BKYB3QiepCEaPj6NSn0oyqDXhc+lIvIcylvnO
	on/8XZGkX3e5jAlEsrAnMmhazaq40C/9iAmuG7EDNd3hYMZZvBdAJgKpe+5ZIsBk
	Aqocx3K/l5tM41UnGRpkA8ua7xrfm8NpgyurEu1wPDbMpvihPy0pGTQT9IjK+R/O
	1eSkFA4bGJhCinVFZ7Woivze07xHA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010043.outbound.protection.outlook.com [52.101.201.43])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh1y8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:44:59 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2FHb3eyxPbSuVR1wIU7mcOVRSNz6a0nYJyvP6izB/9WkXbZI6kXHA0XBPSqgsrA9d7SMvIEA2Jxuq9R+1uuG0FBE6EV/rS62u2M36XTcSjfdQVVnrIMsJfnH94TKigEbdsZoAPDFUXOPByiXcrCOPlweJZxMsTccMyI/5olTS+ZPO2XVnnjWITfSk3j504J9XegCKA+jDTlQpxPGPkPbNxFTNNQerpKjsrOjBxj8xNWVOQ5vumiHDX6v/GaA1wpbcDUprRoDT85+kgLclKudqhxNwcqzjQ/TDAnu8O+g83hfioIo4Gso7qEddbUJKbhhpTThICPdUKh1vDehR6Uvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8jCc0H8DqNv33HahP8W7SrEMuX/A7BQ+cnAsZpi3p8=;
 b=fSxKEV9fmHtV4QKEx8gSchfV+PMnSxEQoRQ+QdNvX0pvP2+wjTs5fr+Ovbyf3/O+MFWFY4hgmy3irU54/jxFUb3EKUfBjtv6k1AQeo02lmHctPL+D0EW/NAtVwfijijmCEhp7OsqW2cbv4QJE/aOUdbI3/KPcu70KxyMlfths55jDpfDVMQyJJ2LPrz/7pCDOGuNXQYV7oF+XHhorxFZx/olGCqYNtBcnKg9etLSadwyEjhJl6NGACKjJCf08NlCZj+l1cYWHUfR7dtwsd1ZxoXippJLhHI4e0L6eFgJEyxXyjq/zTqCZY6cxL8jXwD8cmXLthCxUpHjEI5VgRJa5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8jCc0H8DqNv33HahP8W7SrEMuX/A7BQ+cnAsZpi3p8=;
 b=lsuE03Y7I3oSVhEurHnJSNM45jTEgHIxslW9S25WVrWf0N7v3fSYsJohsus1ufAfz2BQP7Ih2rubqhPe/665fSYhLN101NtHm8KbJxMSY8aY+c1YEdIOTzqposQ9jK/fUfeug3Kic/PnOcRAUgIGLBhu2oakhRH2KdVXSyukBiQ=
Received: from CH5PR02CA0017.namprd02.prod.outlook.com (2603:10b6:610:1ed::19)
 by PH0PR10MB5754.namprd10.prod.outlook.com (2603:10b6:510:148::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:44:56 +0000
Received: from CH1PEPF0005BD60.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::6c) by CH5PR02CA0017.outlook.office365.com
 (2603:10b6:610:1ed::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:44:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH1PEPF0005BD60.mail.protection.outlook.com (10.167.244.249) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:44:55 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:54 -0600
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:54 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:54 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxq521920;
	Tue, 3 Nov 2026 23:44:51 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:18 +0530
Subject: [PATCH v2 08/30] crypto: sa2ul - remove unused line
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-8-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=640;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=SiuabiWLAVnijU51zV57kHGkeTqmltuCx3ECTXwm2/E=;
 b=zb/FX8bZnSQowMB4vRCATz6U9Lp9DV4mBYb4aBFnx7ulTmRzOaovdeSkTG5EYpRDSVII+fVOy
 9otGvLMTvMdDv//X4RW+fVmzllPnk2PJpJcxk2Hs0WhJddkUTXIUUON
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD60:EE_|PH0PR10MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed1d29f-512f-4d72-10cb-08df3a36c119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|261021123027099003|261021121427099003|261009223027099003|10067099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	fIXMkWEWr8vyfc8QD5SO612c4JC1+t7QVAuAZT5LvIZtKzsd/Nl8Pfo6MvRYbpQdDO6UUIj0re6qGXeuAd900dR1EY8j2PybTegyK7i7bu4ZbTwPNeTQ9EXKiBu7x+gj6kq4P+Oqes+AKbBWJPT+Sq0yJt7qRCSyIXNuLdH6IiEnf+fx9mF9vuazDNpNSEdpojNbnCWucEvYEq5DCu3y2x3jZ6ndYmM2yNYzCHaM9Zv2BGXxRuDpOqsGzAJqA1ZiXp40CI2f4OcIuHDxI/pATaAJ94gXT/AgRDEmADaf8WNmmwpLrooY9eguSGDzIv2Ub0PAyPX/vZPy8hL4yMjnPAbLA9n/0PVIhZuTGSph2S4smSkX/2v9RcFasYXjwUxvXDTwY2edTSonJNNtzPV9PHooWwCTlMW5yNqvojA0AuA3Fzijy0bppUsV+YkTKdubF5eezNsb1OFYBLc22YYjHIPAr5uXf0jBmLJ04Uv5R10V3FP0QCGoQIMYIQR7HktoD68SIGzNRqKUvhM/2/6M971IhBku9BjWs2IKKoknfE92WMX/mLt4koQeS8p1gcbyB71lv9mntLQeAvhiQJQxcqit0VZg0PvlNoODaSYtWtjYVuSPQ2B4Yf8VCMNmvDjZHXq08l5wdxSA2PQBHRko4EDAkXQV5ERwqwPd9LhPwkDmOZrR8e8gRJPt+1PeAoTJVO519rjBZd6oVkGpBHFS+Q==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(10067099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EH6TdoLqBKxmctphCHBIN1nMzB8FpeEt0U1hXIVBZXUnhifzN7i39aOmEIPSLo5assUpnHm6XxpJj1gFSxwokfDQC677G0hUYd7KLPufaG9V+JM1UNZEdGy7hDGnPYgD9iafIZ7cWMiwWSeQrtZ6hos7m//k0VcEmgkgbwkxOYJDU9yngD6RGSWPTQoU8JWi8g9QRMYmxD6UDjT5rGd+tvKnvMGLEqbAT9y5Vx/YlNaQ2hatH13P23GpbLm6ub/Aj5l6RoiiMiU21ENaTaSwoLliew6cpQWz6Y+OeHMAH93k3Pj0Lw+4QoThKPlRBaRWAv0Af9oAsoMPtM7eYjQaHFjBUl+CVlfSegVu82wRnbVCE7hsu4TDS/WllHSjCYjYNh5mFmRB71J8XrkkzQL9T8X3/mPTyBTPiZbuilk3JIgWV3urkDLGhQGdwbO786Xz
X-Exchange-RoutingPolicyChecked:
	FMN8Brf0myEYb+nc9saoz85Poz44qHqy1QsjA+PqX2syVZY/zBR0wJolcD8M1hQx24G8ulPjc9Ux3G4srW7j9cTqnLFhY840y5LA/MV4/sewMdtChcd8iHaSy1uyebuUU7OSUg0D1VMV4y4APqZNn/VcTmJwGKFK0NBMhNZHBh1ulJeI8wQ6SdTsqymH6wxBh9BOEJwjRH6l1th++JUN19AeRHtQR+QbRCvIVdWKPmkRTrSIRtNjaFu/pJPV27azyoLkf2vcNoAXwSNNvXarILScrWYjziLQHj6wMrRy4fQIQeWl+hM9oyeYdVByJNvzHADIZM9NxxVvwNtev9+/MQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:44:55.1265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed1d29f-512f-4d72-10cb-08df3a36c119
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD60.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5754
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX5LQrR+Xg4tqy
 Tt85c4pqBK6s+6xs6NcqMTLXoarkh590tfZA72x+lLluaLJxrxUKjKTnnnLWhA88KwkdMbUx7JA
 jGsnDauXBLpEML4K4fzbbKsi0s4txoA=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac65b cx=c_pps
 a=MXKEcm+r4KK8PT7sjGsI9w==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=FzaBtKGL2EelwbVhT7gA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Qx1JOQbDsZEhW2ApJlRD9ZZHVF2qVEqK
X-Proofpoint-ORIG-GUID: Qx1JOQbDsZEhW2ApJlRD9ZZHVF2qVEqK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXw8i42pKznDz2
 v9xfFOSBYoDF+78h+F2X5oeNuzKomUKZ4uRFD9O+eLas5o1Vna0l9bE6vYGVcqG5cfJPiN9fQ7h
 OVdRDcIHDoqUZ8YLNWoOfdpwOsvdZPKfPKIBr9HdUEKeTA6mUClMjSTxes/5jD6hM8WTS1bZBSD
 OBOzrcrC/ytrSitSnZbYbdixOMmbrgrbqrfk516/TKo6LkIPcQCJE9gi8tsZ561kMr3gKsrea6w
 2W2+MS2AhDN20o4BhbUL3X+rkoL6x00ZCpkeN1P1dDWNCORzN6johopw/zg3wCt8/A/KbmtaaIs
 VQTiXVErOeXjiRwo4UD73CztVNSOYMetzqob8unoWf2huQPY79uyAaoYd5yeQ0EAml9NEATSmyb
 7PB5U5jR+opdiFjutIGBmm5fOS/lyrH7TGsDSZRKqoDzmkm9tFJ6dkHZ+R3+DCiAR4YYkGC8a7W
 cxSGbJCGkjYNqC+zKng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Remove an unused line from the driver.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index e1e537de2d16..2936f411454a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1181,7 +1181,6 @@ static int sa_run(struct sa_req *req)
 				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
 			   sa_ctx->epib);
 
-	ml = sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS * sizeof(u32));
 	dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
 
 	dmaengine_submit(tx_out);

-- 
2.43.0

