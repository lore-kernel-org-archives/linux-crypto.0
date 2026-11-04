Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771136;
	b=sIs0dXDZd5d6CoSn9B3crY044NCfyX0YnMZ8bGh1pzhO2bWHyN3iUCDHyGknFnfBnGyf
	 4vgfRq7HSg41nbPC0asSbpEzRhTrO+gvVJpuVGFtaSB2saxBFUqk33955p1TwsePCAJdK
	 T3ACVUoow0sjQ/4FIvpRlmIk5jVT9o9mUi7+XMvzhsWv6PxK33ORQKLcvIrt74oSPLJSg
	 dMi1yOmlMQYJCymqXpz86xgaBQycKWfkqxhpC2EvK3BcbEl3B4SFwsbJfiWOCqHaZFuEl
	 h46eONjIiVH9p6+71e3duzXIdeO/m8kycokiABmxGJWZqx+WYtF+xJCgc8WjlrKgaDg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771136;
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
	bh=eXSam22LqPRXt8mVoSM3waqR/y0aClqbZ+/xB1oqhFE=;
	b=4BWlq3n29zV/2Hjp9bwOpC5Ap03Fh1c286Edo/FlKOUcziUeO5RskfqM8v+ngf6Ocmc5
	 jqjydAyN+dQiCvWcNCPjWvdiHfhwv9wGBx5/vbY4Kc9pvJ1xL08k4D8BAnNnxeWpsuCw2
	 CYFbbVu3I4qnDpqVMAYYUUv4kh2JHSCqFKU4vDjUWNZMjSGBZePHOUz8P23+PyxU55gNg
	 v20CCmcJoDTCmnD4YzDgPDOX8BR9UF7i81TrOwD5K0cwlBs82ZLRoXZiVbcLttsIrtn3L
	 E6T3dplefWCs8X1WOKhUvI61DUWv5GQCWJB8tx222NGKy4woIEBUUexwIkeMrG8VlKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iIrQBiW6;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=JAU++qoA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78845606A326;
	Wed,  4 Nov 2026 05:45:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78845606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iIrQBiW6;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=JAU++qoA
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TOFu601514;
	Tue, 3 Nov 2026 23:45:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=eXSam22LqPRXt8mVoSM3waqR/y0aClqbZ+/xB1oqh
	FE=; b=iIrQBiW61TvdTMhdevAG8ztb7dNqa6tv9rhSs5C5YgDNlSN+yUGQgL447
	ZkBJPPM/7GLN4/fqf0SujwDv7f4lYCCGexCw3k8WOKd0MBkQFvfjRpwUsjfJ2GzH
	lWGzT2v/BoYPDolqdstjNxyPweVvQSBqxnQsF1mv5BdDuoix/KjIz4wpIghH37H0
	qExEQCiFOTMSZXaK2HdTTbldCIHV299aONGZinUy44SK/zO8y0RNgernlFc3nEUP
	CHrdQG8QdVRANbFqoqan6PvXkyTIukTC/cDUjYZvqsWTmvB6NLpoekcCGv7WX2T5
	t/NfdAn8I/zTwtFZHXpsBgmJP5MKg==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013044.outbound.protection.outlook.com [40.107.201.44])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tn9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:31 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAn7y3V3nez94nYWPbRf3SwqwRq2M1T4w6YT/UHxyoCjJzhq2WOsJbtxkCouojgxvCCjP3BM6dK4umOIRHy4wzYVFM9Fb0bplsHnqTAgMXVDk6GOwmZua4Ku8lg1hBXQzd2VNO2rful7uN85Msptd/d4uZZVSyCrHJoQrJA5lSxfA94dI20qWQPwVmw66VLInFnCxk6viQoHoyRs8V3dO5XthCVhXpr5vk71lWbV4Q0q9AQSQ1DwBUR7+B6yQVdHa/SHW0rkV/31iU2yec4okcuCh7OLkLLQQPtvN0fnm/saFFFWv+zu95q0r9U36T9gO8aaLSXM5BTkXeEqTniKdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXSam22LqPRXt8mVoSM3waqR/y0aClqbZ+/xB1oqhFE=;
 b=g32Dwq9tZt01axtFS0r2o4P49KDe93dB5OhyYdjboT3jR/qnZWiQfUhC9316RNMuidkNEZ0GMLBy9vMkD1vEA11POoww/DgK+Ul990GchoD4e99rkgMtecXCXADP6LCn7sv1ZYwKCi+sQ6lzLmNC/M6Ri/Ke3cvVi26zmyfPRo8J+8AzFCv4C6Px3M0f/hUlTaEFzlb4ZMNM0KjaHTafVRGFTX7vIjDibiyZX+fujQbfRXdlVknQgc606p9JD9fZx7aWFtTZJnmGCuIqTqq+8dO9IktWzFZEDHCHa/RbDtpECcE+7EI/PRiM10GmNfRwA2eUHDG/i4a4ForQ17djRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eXSam22LqPRXt8mVoSM3waqR/y0aClqbZ+/xB1oqhFE=;
 b=JAU++qoAyDKnkn/Tr7B8vWQk2N6/02g8vfhWUUzqTE1asTzxZKsuevWtBLWkMvnYeW/lAmPrh+LeyHMMeDVe9QsDC4KA+x8xeGns0gRebxQisVREd3BorfYspk1+tsYjQLeMREza7NQizkH/nYjw+qT3dsaYTnxs7bPLoOZZsJU=
Received: from BN9PR03CA0108.namprd03.prod.outlook.com (2603:10b6:408:fd::23)
 by CH3PR10MB7140.namprd10.prod.outlook.com (2603:10b6:610:123::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:27 +0000
Received: from BN2PEPF000044A7.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::3e) by BN9PR03CA0108.outlook.office365.com
 (2603:10b6:408:fd::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:45:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A7.mail.protection.outlook.com (10.167.243.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:25 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:58 -0600
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:57 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxr521920;
	Tue, 3 Nov 2026 23:44:54 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:19 +0530
Subject: [PATCH v2 09/30] crypto: sa2ul - remove redundant sa_sha_digest()
 wrapper
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-9-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1587;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=raOnnd7WE/NcAuclBHMAWzRM4vscFSTo2gL+FBGXLEs=;
 b=SUjVDnYBMmUq7bcEEa/TT8+ycfvh+/3sWVrHxNl5WpftskaPDmGsYZzs/aRtQ8VCq9FirbAi2
 3sP/Y4hW1GIAM2hlnhQKY5BTGz1k8a6QglfUVyH6l2mwmOonaou48Xg
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A7:EE_|CH3PR10MB7140:EE_
X-MS-Office365-Filtering-Correlation-Id: 19aa88c0-e55f-4719-7dd7-08df3a36d351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|261026121527099003|261021123027099003|10067099003|261021121427099003|18002099003|261102123227099003|22082099003|56012099006|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	gkC0qaUR4wuTu/hly4W1pGJTObAChEqwHSQ2oF6XeKWXSPBPzxqlGwh7DFIqD0za0svQNRQbLfTu5Lg/OK4qpvA4JIjHFQEojm+UMjTUJxPc3VFP1BdbW6urMLAEBD/UlsHUv0Jt/KV25UlFWdBzufBd6Ysda9Qpgr8giT0FT9X0N2eodyMG4WGGS+UnMZcDXdu5TqW9ur2ycPU6WdTE3lutG1bJmeT8AEO/HxESN3ckGIio1mp6drFh/lAtG4wwZqBdZ+Uhx3xks2wvPKMhzPm245EF2SgsMd4QSuZT0ZwD7k8sM+EFSSdKJm/Yhn2xAhvwDK7aXnF8gO8NN4VVLRmuLucOhr5J/tdQA5QdffqGqxHPwPHF2/nnrVOGvO5lNnwPP2LLj1RhXD6IU2O2mehOIbbrKBrVcYYl+Om14PYlR06dO12jS+AXdMY9Y4m7uZOxK2dd9zRTjArC3huNGaResYFEExFgRSjZV6KtBST8BD3EAI7xiUQ/7BLV2/By9PGKgwD3Rl3G2jvB6Jq44wGxKhsWXFCk2v3OEwOibNuxLjyGiRmPgupZ/+76joAdBk+UPIZ7n5k+v9z5brCHspi4Qm6lYDF7Os3/kok65O11Md17Fn0STEYSiCgZ55R9gwsOX4FWiThhYKUcsqCiyuiBdY0lvPs87laZR2o0HRZBGq0pQE/KZCTbCuYsWFK4rPDS31AFnWVn00RJt9KDpw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(261026121527099003)(261021123027099003)(10067099003)(261021121427099003)(18002099003)(261102123227099003)(22082099003)(56012099006)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	l8grhBrOEz6f22l/TqbOtybx6AEmahuQNIjqHcOi+ruTir2MdrkwkWpTchf0wyHmO32sUiLxCPWD+X+LOwqceBbAMGJREcAcAou7aLQFW1LEpNWEk9QpVNwDT49/zB+idysYkdrQdltbIgkf5qgoHpi3XUS/l2dwIWefiS+zZW01+XE86BJIxhh5eGA5FdICSGQnVBnrl3YQ9d+7sfAmLKcbNCE1M0OtnfiovnAO+eWrjPmKvDEe2aXuE6f+DdD94M3oPVoY+jciJVJbQ/t0CLTucM84WnDjQ4KoAwG1jNGaruPtI8JGVmgPAt5DRLnjioWiT3EV3EQi+S0vOYELfx0nVrPpS9zCj6Fq3LiH/GbciT0aKJyHnevFntGrxg2czrI/fMH7/UfwDYVWFIEsPuBLdo1dASwisyMwIjOCwbfT99MzzcM0H4JR/oyNULq2
X-Exchange-RoutingPolicyChecked:
	3e05I2d3ZwzR6KsxvbkAeGj1rGmzRdS1WVAFr1CYywcAKeOGvw3OlRWNiv83fUJGbZDAdjXV0NbVMKKQmblBHQQ2TdCjEWaeO2sXFZZK5URiH+zQ47PYKJTkOW2+rRq78ZmqzCzvQyjcTsmepFMLoP7l61SpR5IiGEb8Qdfbf8FhArqupEkDn5mtBVxO/C3YPjC6nod5ODUXKrEqYidyGKb1xWxawxql+SdGkohHgSAy+6bk41nMzsopxm3lkzIdgsdDn7Ndvw+ahcl7qUEUsr1Hkq0jZYqrT0Rx/er7gxzLhj2/zz8SV5dx4lKLD6pDa28vgFlqK4YRKCuEjfRSGw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:25.6513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19aa88c0-e55f-4719-7dd7-08df3a36d351
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX0xNC8r1g3YQQ
 ugkm7xWManCSr9T1E63FVmYji6AmU1AxEHhv25/4P7sVVk5yp1U1QlU45vyFDiz8QcpDtp9JWkw
 4mxSuZQT/FReUVln7Zi2HRaCYPEqO8EXSGV9tcMNfHg2A6D/KyKwbSKTiEXHNqae7e9usZvyA/X
 1zbmCNPlip6geVWxbM0TqtDquKs2M0sbO0UxuJ4iYBC3PlNNpToE82NEOTPEdskh/h3mLC8SZcw
 wMgt/+W1DwSWgqEwshy8xzX7UpuuvJINy791Bud/wPb84MxEQtsTVHDBtw1Z4UkBhqwW3WKU7XA
 PNbl2+Vjc5HvRuRr+u/JRtz4XBq53kQxfzU4m3LhL8K3/0+AFZfCb2cEH4ctRtHXTSzCaQSnSG1
 p+4NgCYRNUsaslMJCu2xF7L6TBJ2vk47dQphTBw8CyMhrVOzuWkvdrWVzAwuRNuqFFQyZwwoIxt
 GMZRp38vhZVP23y03Fw==
X-Proofpoint-GUID: XPsE6ZpGvc6Lie_Y92OoxtopQKnJZhBo
X-Proofpoint-ORIG-GUID: XPsE6ZpGvc6Lie_Y92OoxtopQKnJZhBo
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac67b cx=c_pps
 a=skQXzUdJ1yZbsxdDph07EQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=cMfzeC3mFewOuh9jzn0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX9hB85zTJM4u9
 nXLF8SFpWoAtCnmjidkxlHwqsLBwH/b/qT6b6kB/X6hSHy7NJpFqrSdxO4cvczlvIENj7Sy3lgD
 k8OTRm40BrzjS1trUWfws3YXU1uBUxw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

sa_sha_digest() only calls sa_sha_run(). Use sa_sha_run() directly.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 2936f411454a..8088eca84129 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1413,11 +1413,6 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	return 0;
 }
 
-static int sa_sha_digest(struct ahash_request *req)
-{
-	return sa_sha_run(req);
-}
-
 static int sa_sha_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -1930,7 +1925,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},
@@ -1959,7 +1954,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},
@@ -1988,7 +1983,7 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
 			.finup			= sa_sha_finup,
-			.digest			= sa_sha_digest,
+			.digest			= sa_sha_run,
 			.export			= sa_sha_export,
 			.import			= sa_sha_import,
 		},

-- 
2.43.0

