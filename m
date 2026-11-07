Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067663;
	b=n4o7RDJAM4DeQCKGgLxuxxanMAAfkF+291KGXEIP2cCWsfHkvjd1UTZJF7mIgAlvpM/B
	 DI6d+wLEEyO7TGt1be/NEvml5hsY3kDR1qD+WzfMaioq7gJegHBsIq3PkDHEViLQro80l
	 jl700oRWWpZYjVknAIPwLBJe+6209dyzl1JSn4VxzD8Wiyc3O5G9j7AwaIoa5UKvOW5vy
	 W/vpYlv8ZV0A/eTZGolHmZOGl3RNkbLxWtlKVcGRbFplZtOKfxkH0daSIX0UlTHoHuChO
	 XuKAWoznu/pTkoZsitV99rLNesxfGbSFqmGXpLEeofQkvXWF+CZCk2S1obn6TQMFwTQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067663;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
	b=kliTW3Yczrwp9mipumqfCfGOf5GbWSiiTihNh4TIUiCcBypy3HDiQGPkSGRixDgeEokp
	 fJjmKJt6fjC+SygTeEU/AwUZMe10SHgcgsjQA16dgf96x7GJP5d4BMjqU7zosa/riPgS0
	 LM9b/MC7g+S89a8KFcah6IoVlNsnqQAFdOtDHr/duHLhchK964DXP7c+jFQCZP+maKAQa
	 EL3KrvJpeaUwRBG+3TllO5Xfc0OvO9aMkq+yavFm4KZNuJuQVg45+QvyHzBm6AJcAxVII
	 yB8bYZKwkVF+AUAxkgFrOzdNLKVnVx/64MBpor6MeYblOzeXks/ivLDYAwqSzNxE+tA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iUhaEvVq;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=sJVOepyi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977EF606D833;
	Sat,  7 Nov 2026 16:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 977EF606D833
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=iUhaEvVq;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=sJVOepyi
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExpXF3866365;
	Sat, 7 Nov 2026 10:07:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rd
	Fc=; b=iUhaEvVql8+IXoLGoKTsy1C5Xtav0oG+Dsl5UeNr9S1XUfdjLX1odYwXg
	vsEjRuyBfZ3beRbE6HH/d3wgTplJlNwWH22KpjQqMoqXJmmES3CTsXr9Jem+bZPV
	cQ+NHYgZYZDYKCZy6WuScNZKzKMmdvZL3W6DR3kDrdp95iZV4mkBls2XRN0942Rw
	zuHtzLc1Kc/OdnDbeZZI14A+ublLjpxFTD8gdJ7Gezsf2GAvmYGrY6Ntv60n5mHZ
	sLA4xbiQgmONFm9TfpMW49z3i6SYhSv45KibDByS4HjhKwCd7wtYGeo5LX3Xh7D/
	zpHq+tW/UX8C2SR4rmAz356pqvAJw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010047.outbound.protection.outlook.com [52.101.193.47])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmj07j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:40 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlA/2VGZ1hIaznpluL1COAbSPkOax4kFMK71IimzjDCOyyiuSal4Mbliqw1eKCpqzHMf5qjifUNcXHUf8zYFSAwXULURc9DKAKI6MaP8bna8ycICHO/yBJHoc8cHw/9bLaKjM8X4JuAKOJpo0mYTsx5wMfJOSijDL38nFw3mWzeDC8sFEAxcwftHRpJeSFFiHb4roIlUVpTSZBHlAAzidjRo1akuRvvAGLov6pDULK4A9Xg8HOoBsiy8cROXZA1ya/8f84KfE0TCp9BMcuZKs96R0NxANU4u7vZFf7v0NyxzKQzyrCoDHbtIdlzgCC2F7gmjPQla22UYbyUEVjiclw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
 b=SE3jEYgO3EgNWQVAa3ZdfMm8sL6lBNzrS1pVQLYxOHleimnvKm7RQdAkUwouYXniAHU/pezBL7qn3ajMel5VrCXIozfRJPnSmSUTsknL2ojwZ2mkQNnIU0u1Mt7Jl8Omxg6q5ocI4qXH3r69JfGrpLTtlWRQvrd5F3XL/YHKgcoC/TSs32Ql8dyK3lFheNiTGRQ2V0gK1Y8ArfjUL/Hwdk9SnU3P/WyqAI2mKE2jCWCfGP95IIqAHsmht9v/f3YUx5mTFWInKfHS0qTlWypQ8l/HsBGlT11e9X8JJPMzgRhAl57sPR8oXPGE6zeWfUb6j5kxEJ2LX3bIp4/H65TOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
 b=sJVOepyisA5SQ6NtViq7KSULuBZ7/d4JuNVBTXXvfHIWhQF/NT2dWp81xXei0IxR8O2jOYIP0hzT0ZPpMnCXk+BA3UIthWyufYlohFvPHnr97/bexcJ+27Did+zdOOBrjDarTtVUW7hurZDVW1xyPaI/tuGO/n5wHHN8yj6hKqE=
Received: from CY8PR10CA0037.namprd10.prod.outlook.com (2603:10b6:930:4b::9)
 by BN0PR10MB4918.namprd10.prod.outlook.com (2603:10b6:408:12e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 16:07:38 +0000
Received: from CY7PEPF000000F2.namprd05.prod.outlook.com
 (2603:10b6:930:4b:cafe::3e) by CY8PR10CA0037.outlook.office365.com
 (2603:10b6:930:4b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:38 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY7PEPF000000F2.mail.protection.outlook.com (10.167.247.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:37 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:09 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:08 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:08 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G77fL277218;
	Sat, 7 Nov 2026 10:07:07 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Sat, 7 Nov 2026 21:36:23 +0530
Message-ID: <20261107160631.2592763-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107160631.2592763-1-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F2:EE_|BN0PR10MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: b48ecca3-6c50-47d7-8fa1-08df3ce93e30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|1800799024|23010399003|261026121527099003|261009223027099003|261102123227099003|261021121427099003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Iw88mV4AOP8zPUOk/YedWvjun31mE/lb923yytMhsCSkqLScbzCKHK0OSYTjewSzfSPoMYuMn4WAuo9ZW+kEUWv2YDgqoH3XUl9TXe6PrO/ulqEh8VaMVv5at/62bOneLr4WzrXk+MjPAWQkwJT5x/hfMsXAX8Gc2kczp9cK4eGq/hX/ytOyfrXSv819ty/YTrGZxPLfCZeIG++8cBPhyL+ZY3Y+NvCSUtFWMTiHbUFGcybSGBrBkMzTnKAJPyFqdlTNLUUvDbca9/OZEGtFKT5AKJA/F4B1SNX5revT8+H/WfpVrpiMP75piZ73yEsZuFRi5KmKbolxkAz7y/WkGsAQOuBUePGZl1YhvzsqtdUpVRN8Sfcovy6AiAQURXuhXAe/cnM1E+l9GUe/+hWMkcXEhOMRK7e98BW2W3wCoIO14rOfdFAweobALEU9PuFmJbHEaSSBvOvhjftj+CXhAHbwzr14zICqSC615moi1s0905ILNHNhPPbw1yvqCh7xYvpvu+H1pp2zp8iFgK9NwnD3GxDyfcv7zdarms0dkwKFnppX62Mi085RyFozbBe897fr+WOzhGjmwMH9B7pyIEe+38I4le2MHE3RlCiwyeRLkOclIcYcGkxBM8YXeZ0wGQ41KQ6kCykytRnB7fxtP3t6dTHsSofiWzC6YkkI4EHpcp7qfoJJY2l0xpQxQmg+REye5pngpfAujSCydklmeA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(261026121527099003)(261009223027099003)(261102123227099003)(261021121427099003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bZBFmmsrO1B2ZnsRAwhAvcv97aJGP5xemq0tFTzjVbfQp8STy/tYpPVBxYaQeVbvQQ5vhyfw6+5uN/vW4zQeqHw3ZVQBYzaTGAdo42C18aoaWNZIWqHN4B7DyQGnsx2gQvuKqA+oUZEKKzFrHT89tAY9rYB0aQ6pIbGlb8mT7xhiBL7BIdmApHqF93miAW9DzCnNxGvNPt+5CjDnKLpjx7T/IWIHosyIZinFCHc7PKa3TMbj38IJ+CEz3g8ISvZ9qqMy0xg5dyZnq6vFFdFOcgQruwR4+0fb/axwzvTbv8PqjRi7/PgnNe1PeyDpSqgESA7l2iSBuPHaAHF+cCVHYYpJXMwcuJ9Vr1aCTvVEp66KUBu8pWt7/jBhGM8u0a7eAKc1NEIDvOgpSkl5bqixmwRCpUs7GqyBOfOXy+QTi6kGOTqgrOFRVPI3gJjq0V0+
X-Exchange-RoutingPolicyChecked:
	isASiAMkfwLcoqbN35o3xJV6MyjYp5NR/e34+XA11JCZfcHTyAmenGdDw0dujUl9tFdilKwbcSDvTq0061L09jaIYVH/5yqSx4XruKs3fLCS2QKqD/XFrsc8suEowfJvJ3UJuerZmtnlucDbT/mu1CIN7PXPSPW5JoBhDqBTmGp17Oh039BXPyii50BkzoMW6p7W8eisrx0U8Ao4oKoc4N+eMcVOrwYmcqfdEyPelvTRQg+ZnfRq9Hl1v4uuP+ERca7m9ISvarMoG9IYYjvwVXnjvIZcL230T6JQOp3gE8JXtjZgfXU63mQg7nR8/nOqcpOHNVKF1wu5BssnzcEJjg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:37.7493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b48ecca3-6c50-47d7-8fa1-08df3ce93e30
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4918
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef4ccc cx=c_pps
 a=vP0OKLXe+mBq485nSWAwQg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX3J8d7S2BgQOz
 vTKTwPefFR7dHLpWUeXQeM4moKcTvCYG/snQ3XZEjnoiBnQH3yIJLCXI4zYRNEu1g6yAxlo5rl1
 JjurQJoKofGJ/UZYMEJTXz18F5bCLtmTc2PcDQAYyu1T9Mv+IkqXN+eomxHwl8XUdUaEmkMMPVu
 e/HxOjb5lVPhOjranBUSYvw57BnWRJPZbI+Szwjde3HjGMf3S2GJKdRfYJFcejBvJ38WDotpUXI
 vmsi3M2p7qCzsN4FE6QtLt+JU5eV7aWCJ1Pz9sV6A8EKOvb3rR4mnDYhFjL3aAxJX8wW1ZrUmho
 3RfzMkTTbDgUFC5ffD/238QFaCykGOKTU7bW9YshFp1osHPbryOxEIPiI+dRDMB3sP/Pcr4zN2s
 qzNfWlTTYezWwopbFvp17LUZYWuxmZuUPXoEBQPVWuLlCqdN4zpFr8rifN9EK+ZZvpv8CE7MlmO
 iXT1JyuLPkE/iV7K/0g==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfXwSzsY2lyU9jk
 S9/a8fRwOO0SzwLeD7QcOOPEy32y8x7Z+ri34tRNsXSvgb9yc8wlm2wkAFFlAg5uQgNssbPuwmN
 YhFGFbRl0N8FBFsgG/9sqHn0v1t55tQ=
X-Proofpoint-ORIG-GUID: I2He3XpHl60vytPGNahS-R3Rhb-jCqX7
X-Proofpoint-GUID: I2He3XpHl60vytPGNahS-R3Rhb-jCqX7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070064

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ef053264a5541..beaaca862f39d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

