Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063437;
	b=3keNcjQ1ZamzeH12mZ5CRMEWFgESNo6rvv9g4dbuBpKuu1fDMZxeUU0zQwvSzBDm2XJf
	 GaMe18OyDpbO3ij1A2HPEirD0kXp8uuSRG5nI/pBobV6N9U7lvKD+LeiXaJ5wvx051Efm
	 Zyt6acfvDf0CehrTh0YkwtGr3e7px60NbtSOgmHgeqR0T6ddE5uUV29y2ARD2iV2VrMNi
	 2GsnOboIYw8iatq7Cdq7bC376BVeqHZnpqTyRcb/fUeSe+VxAO17rRWs7Fn5/e5MLnnZb
	 Ep46EDM38MDFEUU1DJrT3BYEtG24ItLNyg29u93bAfIgko8Ml7/4OOKxBduZPIpulig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063437;
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
	bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
	b=U4ykL7jZNskA5yKyRuyYk4cZahQsz8zkKRKKliqciwOq482bTydG9CkhryarMIE0diIP
	 hbytSwg/hCexHtpFIG0ICea6kjWPZFVonuK+KFAOeBnOiruozgUq3C3zzvY4mWdRk62yC
	 O0JUIIleQWthvD8aquAQmyBtiHvpEeCe9IrqKTkwsYyJ/bh/VHcouTmLAYqV/gkT3PmNb
	 KQ7CbZwBfS+EhVqVgtfxrqfAUKtxHk+CxShqiml67GzL7gmZRWTjpfxOqYewALWVzqf1m
	 b7bZrZJ2SkwLlvmVqriDEiam8/DoCZmNNDlrK3JTxi22bHd7tPMZLJmctLDWj8lhu1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VZ5KwJeb;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=AOsCt+9u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2CF6082BDA;
	Sat,  7 Nov 2026 14:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C2CF6082BDA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VZ5KwJeb;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=AOsCt+9u
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bvwkb2002478;
	Sat, 7 Nov 2026 08:57:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=VZ5KwJeb1TLXjneSiK0hk3u35vAPucItEdG6J/2d7ZZRwu+KDxGcSq0Yf
	QFmOvjzTO3QzJGxQaGAVgT0u25x26CMdaG/u1uIYyPPPjpiMg9/doeBLPdJMPCZL
	2Un5Lc+P9KRtODeQIsLiI3Vn+l+5QGp8RfxozVNlLb+JHn4uPXgt86MduedojWbM
	e4EHlA3IlNwHDnBt+tcxhNeMrG4g233hhiikSJza5LZpfnx97db97Pe7TxNpPjdL
	eePHuILLzD5zZIAU47YPVE+DiPKU/y2RQfK4ZqaK5Uu867GWW/hlF4zN3Ta7lM2A
	a0umMqksTG482GkKHkwQb2Wv0VALw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyy3rf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:13 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iElX/pnwaXMYNYp+nRF1Pb3o9S0HHvMkUNE0VcwSFvVMkLkwywUTwduBpTlAINxnQbbqHpJael/OtbrBinSKHMNVtusyY8AKDEbSCCeWAftVs6Wf5larj4GrNNTwCYZGQ0xe4BNJrxG1E+GSaScZdx9yN+gpVjzsF2dOzgcKxaUrVWcyKAXixKNMkoYsVAOOXjVtFXHgRwI20zsFMmtz8XVNjPONAvtVv3/kk7hDJAY41aAvXRN5s7383IAvFYVWcVOF4jBZVazXp+k19vbusk9j8ocTUZb0E+ZI1boBEgJSY4twBwEmqOSwZjuoB5hyWFdSlJAy5iyzjzkb7y1r4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=nIqIUqYCvEeeXM89qafnnxUEM/qV6eMm+5sSUUkvTk53EdwBSdpTyT5wbGIGaW1N4q5ZJ2GMfSyR98efsl0KQuIRXwbrwUUfQVETv8+23UuroBzextb521PGNBunXRdjl3kEKAcjLSUeGpcuRI8AQ/gES6najNTjw4erGlSx23eqjpkfFp03H20GnHjI0rdDnhPFBO3l8CTMyDLE6i1GGBpB3glWaRtjveByoVnfQx37tmudeze+LiMv9GiJYyhGKujn8coUW3DPAlGW50KmuHeYJmqGJqQ3XKa4KSQdynaQDLfCmHzyNmNjpZgzmWO3Noi6g5ASd+ZW2plYlfO9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=AOsCt+9uYKfoJDJrfgvP1j0Md6WTTA74P8z+fVTIW5y5n6fbSnQhtINlKSwlB/5ZISpeYy5h7LwS6byxqy/BC4J5n4Tr53ULfjxksZw4N7mLiWAhulL6jMNqGd4gp+GWt4ful7554JDmfpT0q2MkhDCrHMugOfU64zGFTZJJDqk=
Received: from CH0P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::30)
 by DM6PR10MB4363.namprd10.prod.outlook.com (2603:10b6:5:21e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:57:11 +0000
Received: from BN2PEPF000055DB.namprd21.prod.outlook.com
 (2603:10b6:610:ef:cafe::95) by CH0P220CA0018.outlook.office365.com
 (2603:10b6:610:ef::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DB.mail.protection.outlook.com (10.167.245.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:57:10 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:05 -0600
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:05 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:05 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Ev4a6190900;
	Sat, 7 Nov 2026 08:57:05 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Sat, 7 Nov 2026 20:26:13 +0530
Message-ID: <20261107145618.2349562-11-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DB:EE_|DM6PR10MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c1c7ed7-dfa5-435a-3e1f-08df3cdf6692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|56012099006|261021121427099003|261102123227099003|261022105027099003|261009223027099003|261028144727099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/mPr11TAo4IelEYJ9q++YpIWm1jDG7zf23xMsGCQ9d+CdLy7LrRegSMk9jHxjGawkxD1FOahZbgTeTPZLIyvhn7mpOW9usouEq5uIXcocesxhff4MCaieaYIWp6FKJVG1vxBZI5spMwlARt041dKqACd8JoSP2UcEBxwpR4anWLMA/OC+Fyd+RMiI89asuAszSdWWewMAHYhwpFQdao+mzv40mRgR/hvn7VbmCsvGZFQHS5ecffvFiYQCwE0V5JAWStuxeEVs4MkWorYsW6wd7gYzTJbmL8r58tlyGrGqB1Trd1MYb2aqoLLUJIPREMuZFkYNYd4qTfkSnX3CRmnf4boXs19dXuWby4s2B+q/dggA6RYY74XWAz7XCP6EsinXNPNR0PpKUZfOvuTMvx8o8uUMP+7GN79bdZZ9l1TmmIG92is7liXHZ0KrfG49c2iVkRuunO1Nig9bx84HYv1nx3Kwe/3CXWiuOSrJzEmiLI/cCmYYsYdoQsJ2dyW4+nu1eh+nEJzQGYAbsOkubUFELWWSIxQOervPf8bJD7+DTlzwjL/sEJAAmJ1kxx7BpU0RREn/E7SxEyODQTQVX1lJACNNVU2LT4aP0RVbcB0u5sOx4V0PmrEFWwVn74pVU9EE/daHdOow2Sysi8FPPzlJxS9ZWMNL66GAYt9aycj0/WgxVJ/Au4odNbd4qTgajdnue+BqK765wPEwiaBsWxHeQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(56012099006)(261021121427099003)(261102123227099003)(261022105027099003)(261009223027099003)(261028144727099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mUgwVTvL19TwC6Vsrj0XFVZpA+T2jNYcxILcrKsTWq+6BDwq7E2LqvRHuSwG1zLgBUOY5QPHoTZjnXg3ihLD03ub1vLWG7MDZ58oDl3yJ6GYMvNHByAp1OUn8dEDGLgWvpIiuiy/K0A3BXpAi1I5OXzazdEeZlKhYHElYTfN+SOSTWSEW9mCwMYeytTjK3LlMaREoYi3N8WE+XNNOdgWHLOmGadNf9HFVB+b+CeuW7XXGLRj+MLgg3ieAvdwtBBslmPgcpsBH9x0xGJG9jZdgSCyV38TYSVcloax7AGYUlvUKTyHuRJmUN8ImJ5G/oQEiIm4bVbk4zX55QjuWtDC4fhJc7yTht8cbDxudLvLKOkQQPFHw1JrGFtFnBQVz+0Op3cJ7h1GlHC1mUy6eUstly29uBiwVpsJC//e2m78MMe6fcHc/w80E10UfDtc/VCv
X-Exchange-RoutingPolicyChecked:
	wBP/ZINrlbKDR6/MPPQV0bTFBl9fscsypaiDVQujatZzcYzRDoFQqNvZZkwmUTHUimslwIgNFRKGkEoTX5x3IArvEKtO7C9OGiebYEO+ZL7HYFs0M1K+2sShGupS/o7Sa0IflDtC02jUvqnbRWAFOGbG++k+sZwaHXCZC8bXgW3IzNf7IQqrjcW4vqDYAx2eUQ6z44hyamz0VPyr3Y/C2BfJUtixWSI0q/UFjL57L86nF9ufXiPKij1WWbT3gydFfVHaZNOFHOQEGndJsIdOVJW3jldzdYWcdq45BxLZAWFIRxGkNupYgws9vxCjmYWiOhsNSVXn/mrDZu4tJl0SGQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:10.4944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1c7ed7-dfa5-435a-3e1f-08df3cdf6692
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DB.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4363
X-Proofpoint-GUID: fTAcwT9Q9l4FYZj2EQ8Wajw0OAlA8TxF
X-Proofpoint-ORIG-GUID: fTAcwT9Q9l4FYZj2EQ8Wajw0OAlA8TxF
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX49wgVvZhGM1/
 EEV7GjLfVr/nui49pHdW8rUQ/Udx/7y0TdkHwKLrnHjS2d5NtluJ7zupiLh3ZfeXPc3gxxsVY7V
 78hIfsyduIT6HWPFXZIydlp460TU+dc=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef3c49 cx=c_pps
 a=QA4htdGqYz999Ta5EyqdmA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX5Lt0ftWcoYsB
 N4mbgziX4BKJ+px7mbBwKe+opk+D+wkFYovx65uUj2pWsWxaL/nsE8zbhyjEY23Bc1ZKdVEImMD
 JdJvz3BW1ejA9Jjad+AN7iyWXFqzupFsxasBuDTm1pqTaFHE7xzDFhsZt9nH3GyWEuWfImq7/Ei
 piLhHtoq9MAjlAtFuO0UEtEoHSR+H4ZHoKERjameZwr340mC2twNNOkZ8qF2r9E3BKtUlV4yAw9
 VfTuvX3TFSKmrDVT52kHTZI7ynaDlsLr9qWNi22F0xL2/KWeCcx5bzWup/Xtd9/Ehrf8k42r+BM
 XvgWRcl6EbxlipCv/i1ZDoSNqSHYp2WPAdh71tiVnmGXezJH2gT9kHLcb2Ts9eetKEmEs7BL3mK
 0Jl8Tu+bTYIBLQDVckgay5A0BN6oEPAALUwePUJMKX5F+HnEO9rQP0B6GxW4/AIKH8pNA46cbzr
 gI3/bBR1ALTNHIZnWSQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

