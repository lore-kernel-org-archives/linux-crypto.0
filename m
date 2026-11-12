Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471203;
	b=k2ofEfOs4z2cRF1Zpljw53Kjika6oWeB7Sk5nzALPIwXJFcTKH3yiC7poCsh8fB06qfK
	 lgE4uIK+1Nk4mf+ICA0HC+irLz6d0L0Et/e6aW0eL4AmW5FrctMGTHttYaiIXAWLIc8DH
	 jcfTFDRgHL0xOLC+zm72+s1JgCGf+HMdza4GeCpf6TCU4zW0WPy+Xv2SnL1pm1cIkKvbC
	 23Ie4Vk5C3TcvChLGqbjLOeT/9vxwFI/gOdOzc38DAsLk7sACEjflTdkivNpTR4Ze8y/E
	 jiGnLFuFKbMKy+06z6qS9v5489GzCJcO1q32znj03sIUi4lUMRjQTMJLkxWbCdsdIQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471203;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
	b=KVXES0hXTZ8cFljkdys/uEfmzx5dhXHNeWOx3KYsNrXlsG38odc98qit+DydI/No3hbu
	 8WPLCErQowJ5Ue8wwqXARpy6y+qv+p+4hHT0hxY69S70or4OMlwOFUc449SHbasM5TZPN
	 fLWa/TvaencaeRa0iGx5aYeDYcg3qI1S34ygQepOapUnZ6b6x5ghPee/OZTX6tS7U6131
	 x5cV/vyY3CRhtu3aCqrZOwu72BX1wHF/6yrtVSLfEMpH4Odx/7tM+/OEU01mX7Cg4DYas
	 Agb8Hmol5+Peq1m+L2+iLYsNMmQYOsOpnl3oaUTVpu6m+nSE0E3rjeFagc9LmSqV6BA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XR0ErNOW;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="hD3K/HLU";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0721960A6F72;
	Thu, 12 Nov 2026 08:13:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0721960A6F72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=XR0ErNOW;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=hD3K/HLU
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5j2Cd2297762;
	Thu, 12 Nov 2026 02:13:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssW
	Y8=; b=XR0ErNOWgQtvTo4zGH1q3CDRVFmjr6XQ9dh8WXRGfbj0bpwjxZrgMGBVi
	86nsmA80K6JfOJILg4mDDedwhZ6CPEmTFiX5fcWzvfPToqVcLkx5FyxqaCa97VDz
	MUbsowM3Fskzi5DWGUD9XkyfyUJnz3FkvYRxrLblVqGjWMZw04AWsYb6YTpwc/rg
	5wmUhrviMwYJ4ywx8i0PcupMV2E/NNjaTf4IeygU7lzKxPlOeVpwgKLnHh8hLOsF
	gBzkOoz/vl7mmLc1F2w9Nt5QEeYky+/SBYZn96QMRt1gwkoPQ17Y5ExTIDXZdGQ0
	zJpx0vRzm8WBVkYgsoi+XkkpeC13A==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010033.outbound.protection.outlook.com [52.101.85.33])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w4u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:20 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bVgKazVTfCq41fa6nWi7SF9eFOER2vFKPIHPpL5AseyAWyc/6s288Dba8KXhu1DsI+eXGilwF4nWAOGhnBUhDEH032QxB0BWSxqKMGFr8o6v0mUZoxyS4/SKTZNFZrixuhqS33Z6GmbcUFTCwyFD31fI5mvqw/7qT+bwa6zgiZtE93BpnWCbnPL1eZSDPfRj8tHni+ITGFpSCVc035rhOV61aSMmUqoQ2VjpI9hd7tA/fmGppvlVgZmPqvRMJPyFT0+sUfqI2HAFzF5P0AD5B+AhEY12jZpniyclhgORUfwu4GTkH69l85FbqrWBSR9Pa8aINYp8u29tol9uQoLCKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
 b=f/JIY+lZqdNZXlMP5BslMc050USwAllxecmZlYSU+Z/1b3rz51AgxnmLKc7SnOpE8nLN3dw3l5ElaVsafRVKmgw7i41npPPdz6HYGFY9E0hi64EP1gsy891LiEu8NcVHL9u3Drj/LJmx+YCfsNpRapSLq29V/yE0pRV5B+eBkDHohyZvlPEIe38F8sB2shQZ3J3ymN5TLMVgJdoX2qqmMOtt1yLRUBJb35hGXnJlunkQ2yG7BYzKMcFW3JodnGFFHBLakfn0yZus2Y+etwo8KHay/Xnhw5voaRhmqGb59HunQ9vuNBBWCacO+iPb7EfzAsdJB2ZqNusft+8vtFZbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
 b=hD3K/HLUrwestzY7XTTMA5h2m5TNiKJtNJbhOJvydXkccNOPitSAj5cTN9mO3C3RG7kfI7EaxZhitcwsXU22pony1rBSw/KaDT000QlmsGo4XwK35SveA4n7mhuUUi5qVKIsM0RH5EkGzf7zng4s+qx0qNR/kjrfslSwUy89lHY=
Received: from CYXP220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:ee::6) by
 BY5PR10MB4353.namprd10.prod.outlook.com (2603:10b6:a03:201::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.8; Thu, 12 Nov 2026 08:13:19 +0000
Received: from SN1PEPF000397AF.namprd05.prod.outlook.com
 (2603:10b6:930:ee:cafe::2d) by CYXP220CA0012.outlook.office365.com
 (2603:10b6:930:ee::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397AF.mail.protection.outlook.com (10.167.248.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:18 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:45 -0600
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:45 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:45 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8ChAi1456052;
	Thu, 12 Nov 2026 02:12:44 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Thu, 12 Nov 2026 13:41:57 +0530
Message-ID: <20261112081204.1146395-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AF:EE_|BY5PR10MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: aa3472f8-d9b2-4e05-4425-08df4094cf04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|56012099006|18002099003|22082099003|261009223027099003|261026140227099003|261022105027099003|261021121427099003|261102123227099003|10067099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	L/zrwlia9CeGH7oFfHgq04MIbc9MWWI0ltJ8TbeHRptNEIogqpx7ATjmX/d7eje7tS7gGuFM+dcN4py179CNp/sptTdEpFsHCsr7YsDe/2U3zR3TNmkkIF7fDuMe4jturL7n6zCcQq+3d0U2z2JXadimCGNgD0uUwMlxqHkzvXIine6qo8qmfWiIznYV27TSK3PA7+z28h3uwxU8h9lNksVnm1tJszmEWAGp8XxGL0jjgDw/pCv2ZU0L+F6HNwf0bcIKjCINhHuWY7cMW2YQzNXCTBzQfu7MpwZXq3VZf1HLE8ayVcgvDYH3mWNppSu9qKt1y/xU6taeB1SPUuOa1+1wJN5qiacnLf/xhRifqyBvraAJJOdB1nJlAuDaFMAdmn9B70Lhu6VslXX07tJh5A2CkoifSAcOBsdt1rW3kpG1EOH3j71sKZaN/sY5WEQl0cwBMzffB41gk2txpzp8QFPsyUlrdxKw3wkT2iuhu450fPsFKpBa5CjHqGAdl0tXQdt+sZI6ffmOk3lv+7jFa+NFEtLHi2Ff+ZR7zWE5FylWxpFIr6OK5oI6nz3wBstRPss7xFoLfaLFbThszlGCM3Tybu6a/z10P5lKAwqu9t1r74D+1NI/c4J96RrsIDhXvmWc63gHX0KCoE2ZR2mW5x+a252bVozwB/hfUtUKNZo8BpC9tZAF/6tKMJHN/axuJonsZoOVmBmxXV0KESexWA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(56012099006)(18002099003)(22082099003)(261009223027099003)(261026140227099003)(261022105027099003)(261021121427099003)(261102123227099003)(10067099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DheGp9Up8fTzG3ZJZgSk9zOry88/sP/bJ0GUFIBfPOI033G42ot+lIQQZs35vZvq+oPBzaR24oE9AytiyS7W+xst7k2UdxOmponQJh7IjtlzI9Fzsvpp8oRzRaaMkiTOpHCRd4n5Hgou5suyD2IKhl1s5orrS4+ML//leVoEv5VmvHa5KkHyx+KqXvWVxFofHIOOlAWqOJ1GiDgMvJkZWBcWQJ1vh6rOZ7jC0bexf0jqIgc2f0clmQIl5FWhgtx0tGlyFr5Vyul3ZfkkMkfB0wzQrQ7lnPIH7EnsS/2RIqDE8w1AVNT/sIatTAVGeQMQhE6lMufTLrzQTLSs87P9VkEpfEcCKZfCJ2mt7ZgHyUiPMf+FxcXUm4i5yDGBJKPjDrXkuAFKZB7cUP/kFun4O/9C15GNJPRtuxWrgfftR+Aywnmq8KVkxjQwHIIFOD9X
X-Exchange-RoutingPolicyChecked:
	PqqigfTkt4xqG6n0P6vPEYr7KOWC0ybjikpYSU3ZDaro9TylusCEtjJmWG2C6ndPUOG238lEJHUTX3ujMX/7AsEjg3JXT1KQS2wjCpV32Mg/Eug9Lsna13YKekQjBRyObrxB3q6OjXP1JC5bloxpYdDDCl5sc4AWxcEU3/v1jyxTV4lVWxUKlDDgUvBf1Zb6MxtUA6T3Kol3HpiSTSsdM51jveyxY37Qvgbs50JWhwZBi0pq7RTUFARNfD9+DY1B8sYQmY9CSbfHtXuwnW9DyTPCHezZiIyil+DasDOShOY0mAlIxfrac7H3zwPVMXdekxskePHWdYc1K0za3Uu4GA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:18.1662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa3472f8-d9b2-4e05-4425-08df4094cf04
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4353
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX3Lb8f/EohcyW
 9MQEQ8UMeuvnhyd5FTEWp3AW/zxGQ9pYk9u61+1GNu/+a9sFgpmxXacXQMmKdoiYR4CZqpAySNj
 7ydNNpGdRJ5A49dL0pw0TQF8cgoiFX8=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af57520 cx=c_pps
 a=+v7uXpzEFv5PX1YPhMLqHw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-GUID: nm_JgmlHO8foZIOB9zQofNteOYz8ZeFf
X-Proofpoint-ORIG-GUID: nm_JgmlHO8foZIOB9zQofNteOYz8ZeFf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX8d8PCLLzOiPh
 YKH+1xH4Grq47SLDhFQZ73Da24kvNKnygUTcdhN8S8WlmFEkI5qJfWC+spyno9JaHJGHIkj3wPB
 I4bc2CPUPGBDYDw+9oqRdqcTIi/Uja2pWxx87hHv/hwfPoyPMUr0Hkp1tA5QRJsOMLpoBttxOop
 qQAGDZeg/2KZGqZsHdpF9mf+v39PLK3Zb2BNfPrl445pfdP2lM+QRADtGatMTew4FHffwUpOjNR
 kbgT6Tn0zmMQvncaq9K/mbzAmhQzw2xWJ0BSRx5wSS+MYC+Vteu3XFQpWxiz+RqccLMnrkhRnvp
 ykA7T06BuBCSRYRfVT43tatWvT9xkEV0GcA0XcpG+s8Ae7KQUTnad4cA/bqQiWxDrtuGmvWOGK+
 JiyenG4pK9818DWYI1BYeBjeYXGqK5uvkMendpu5XaX0oeHbbI3ZoFkNg6fAvr0S2YnWWXklOeK
 Duy9hrLVv+XAX/45+fA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

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
index beaaca862f39d..38278ad42f904 100644
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

