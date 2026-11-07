Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794067757;
	b=pbJ7y2hsSKyNVt8hh80+6iegYQv3B0tw09aRILw6rV0OWNhqWCifRWedJPFSvrRKQ/7Z
	 iMQShqhDbElIP87Zzfb2AAcqYgTVb/fTBdUW0hHsmDad6IjptFW9hRDUHNjzx1Gm+YaYW
	 1OyUB5EvM5mShxmqDw3ofw5O3EKty15x+gtRPiQaOR9E59t4yc3hvRuzdbiXnriB/O2Yk
	 nPJlJ+g/fJ0IgXLma357pJ3nGlDXrbhuR+ohaX8WgTTue8dWYmVDg65GR4Hc03g8FWtb0
	 +JtgVvJmL80qEAbi+NrInZWUP/RUzV3es7V5RQMT+eWKgJH/sOuVhPbKg4HHEsQ97rw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067757;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=KPgAIJHbLUbW4uNWjmwhPSZ6Xg20LL5oWdfdcXg7XVw=;
	b=il18s+vXdlXB2kx7L5Lm+R0R7dS0yfqnvSR3jcC4X09ZlOKBpk5Y8XoV0gvjWa+vPYTz
	 0X8Fihts4GOHTkeViI6C/tF0Vt6Qoq3ng7Z2gnunJo241VMzttlXYuLnbnjhKkIB1rU41
	 aOe0aFx67ksPNpr2g+DNC11P84QuiuKV6ykoVg55BBFxf0KETS80nOOCs7CvZ3XSBNcEz
	 egqlcGeLiossZMnZkhf05D6PoZeW5vwvWCoNBy4RUcoLow4R+CPc+pYqa6saCcXoBAaBC
	 cHXDf4VJ2W3uQ/WVgPpJSueyUItdwXSj4wtBlouvsR0AiTdzI+Sq+JpupTasKO+t5Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VG00dMKm;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=cBkcYo2f;
	arc=fail smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674576082BF5;
	Sat,  7 Nov 2026 16:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 674576082BF5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VG00dMKm;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=cBkcYo2f
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7F08VZ1939647;
	Sat, 7 Nov 2026 10:09:11 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=KPgAIJHbLUbW4uNWjmwhPSZ6Xg20LL5oWdfdcXg7X
	Vw=; b=VG00dMKmWE3IriRPcK0jeXOUPXUickvDlUersTLl+EBUGuZ874S1Xpf/4
	Ty4egFvOsE5/e6a1pwoqRaCWUmjjtNwFXWGflXrGaWeCUpjiI/PTZ8wrwiKly4IR
	gmVihECWFHsFpAQpvyp7CQ4MY35bBZdaEFVzzI6uu69IKuTl9TZIF6VKYkWYDLJG
	Ec/VXluzluYxeCLHbzxTtC23GnlVsRS9jA4X2duympAhcDJax/Otlbv0OtqpBP3G
	4zJNJ89tCR5XlhSBoMboeNQTVILFi/DF7eTLRaZoZwbXg8Xy7NYJ3x/xLCn+Ykkz
	iXbZW4HJqdSELn+CyQVF8OQvace9w==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012007.outbound.protection.outlook.com [52.101.53.7])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0wqsaat-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:09:11 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cWjEDLp6RW2HLJORLWWPLtv5r1apG98rJnNSSmoqDKNprRHNNgB1ivIRmusJ5SIvYTJfsAgwNf3icsBAZX6zWsK46litOJ5FSCELNmoqPdoU4YaBlS7D8qANRNhE1ZuUA36HlHmO5YOhwbLA5ZgK7bDEQje7GJrBP6gk4H7/2VpuNxYxdG2zOoCtsg8zglqiP8jKJBeFigs56jMijJbSotlxUQ0un5qNMg6fGpMj2ul0N/aZJ1FQHXYeEo1Cskee80fLzOr6lUsw6jA3z2V1zDNigZrLFX4skgllj759BMBZEYsQ5frLYEwCCchAPabdJvl2nmuFjQGrTXD1FCaN6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPgAIJHbLUbW4uNWjmwhPSZ6Xg20LL5oWdfdcXg7XVw=;
 b=w0gaER4NcuXUwTd3BbSg9zDdaPhbwVgAJPZa7+FS0X+7p2ZTt0omdOyI92aiU5sNxPUBb6f/7y+afbc1bCkh7UbIMxHozlt5rg/+P5/90Q/H6egPx1DRMCJKEqiEG392F0puU44gmP6kUC9XScSCq0pCzRN3vqId6Fp0H8r/iE8zEeeXzJMH6K7aHooH1uKkc/jD+JgVhgBSj2ZzteSm0zxHOpR+XbMdxR91pERAdlz+UngUcqtldz8am3LcHZ32jw+elwf1tfmOmDUT+WzhV8VWm+sRYukh+uTFg7f8czwvOmI94HPT4YgctapsGL6dulufXzy045daZiHgb7/EUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPgAIJHbLUbW4uNWjmwhPSZ6Xg20LL5oWdfdcXg7XVw=;
 b=cBkcYo2fWF2mKjhVwjw4G8oV0hxU/7Tx2Z4oxRD6yA69OKAA9zfN8A1Yc0BjEoQe24NqE2jQi1QNXs1mVTGj39eVNd8ZDoKDUq3BFaYcqAW2VspZ9cPm2lrqlmWZjIU+OtRKUAxyRAnJAOoPxPMo7SWvNzw6mIFvSY1wOS2ZNd4=
Received: from CH2PR14CA0041.namprd14.prod.outlook.com (2603:10b6:610:56::21)
 by IA6PR10MB997587.namprd10.prod.outlook.com (2603:10b6:208:5e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 16:07:07 +0000
Received: from CH1PEPF0005BD5C.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::17) by CH2PR14CA0041.outlook.office365.com
 (2603:10b6:610:56::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:06 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH1PEPF0005BD5C.mail.protection.outlook.com (10.167.244.245) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Sat, 7 Nov 2026 16:07:06 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:58 -0600
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:58 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:06:58 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6uVD276961;
	Sat, 7 Nov 2026 10:06:57 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Sat, 7 Nov 2026 21:36:19 +0530
Message-ID: <20261107160631.2592763-5-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5C:EE_|IA6PR10MB997587:EE_
X-MS-Office365-Filtering-Correlation-Id: 6436f0f5-ce7f-4bff-8c13-08df3ce92bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|376014|82310400026|6133799003|18002099003|56012099006|261022105027099003|261021121427099003|261028144727099003|261009223027099003|261026140227099003|261026121527099003|22082099003|261102123227099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cufhXeY660o8+/Bf+HXSD5lV8jouv+BxM+543TFPrnIGiEKTvk4ql1kLbGTRIFScnJ31Olc2t3TIj31Ao7zB9FfJ5U2dwilKaM4Gvg2IkKSvq3Fu6ORksP+hf027urEMkCAS4JkrOLoK96L4BZXDgc9KXADti1tfH/lorRIcv0bCHoaIjyBKCenspUcPXJyC6BVj2ExLdvbkRRMKXPEjnZ72WOYT3GBsgzxo6AspEg7UVfc1z8BhhB/s4p/UhoBEqrvMaj33ciKUdRNrTaQlNiP3/RPkZdqWbAB/bagXFn3BLITfjvhXnuyHhfBeB5ir6NEfUtErJ4bFYPpyYoY87uIU9c+v4hBuOdA9An8uEVW7DbzZFKY8QMS+G+2dQt/mwUAONULQGaNzR/8OGK/P8/Lbag+uR9a39cuo9++4yUv9lIiBxPsuEnM4C8B84YIGv6ybwGXF2AKQXFU3Y6cueHoF65YuOfwnzgW74zK8qJkfUlgw+8DCeYl4jx3uxlAc/D31K4us6Un+gaGIKezhC0vGwDdjtOPPitXFUsXcyrriHCtVb7MER3bghV2sOGnzaLYN7qIPNp9r/u9J4ftWgLdeGdTiRRBlFpEp1N5EEorLTC0sZenbbATZUhZwSKBvXafjFqJ4dMT6FPsQ16zFHMruYyF0lonHSl3/x08gDYZy3wyUB0CXtL5E1Lqb1Y3phyWv1eOmHgx7R0HOx9AtXg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(376014)(82310400026)(6133799003)(18002099003)(56012099006)(261022105027099003)(261021121427099003)(261028144727099003)(261009223027099003)(261026140227099003)(261026121527099003)(22082099003)(261102123227099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vgzE7JiGsZ1/QOcIkhhOo23Dq7ZWOrwkeYmckrHQ4M1vwVYD68wcUVrL/8qhR1r2z7T9H62nz1fCjP5IGrtNbdhCZc7vGrE3BrIAVSXECgL5S3KhT1xzQxbfXqF3zBDBkPMBDqIlalbvQZblZo7CSnw56mT1uOfJgUBtOOW/JyDBj/cukmNxy3ytjq/dltFpohBkdTQG6Hr3j64aXUlWZ7f8XWr7QQM+7x4QLqrxR8JGDZJT+k0jLMvnviLAa1ADH+5oVLV3gS1j3mc3QaYrWNvlRpvcZOLnQzAzjqNgcewwNYjfYxFTihRePCZ6DsRv8CRpJW7gV++/el717NunE6smX+qDFuymvH2dp48ESOEjbw5ckti4GO8Gfwa0NjQF+MFSrXRUDpGD9nnNokHMDRjWPmrWDoJB52s0jxnYdy2QveJ6qGkuja32zQt/M0g9
X-Exchange-RoutingPolicyChecked:
	GQ/kp/E628P9jxdZb/VBE0C5revP32hu2rzuVWlna7agGExyI3OC8TXj7IWfrEMh81UGQJqrRjbvFqsGJyLOTz1yTZQg40xel0Y0sj7arSd4mI9zRh1Y+SRWKiIu+8faWcmojP152DF4kb3wkAlQM4HZPOJIGFd+Wqgnt4mim542YssbRQbVA3zU31IVv9Ef8k+aoOHhZ6JvL7rPfKURswA2e6tbAbe8BJ/k/tqhT4mFxa3//PiigVPviRPvYDzl5wjzjaUmD/sQ5YmLjsngs319H2WISQq/QJl6gWJE1oPxGlStsM9jgXwoT0GK0PHymCVF8KPnLkUo2W7EPxPs3A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:06.8807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6436f0f5-ce7f-4bff-8c13-08df3ce92bcc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997587
X-Authority-Analysis: v=2.4 cv=H/hOUOYi c=1 sm=1 tr=0 ts=6aef4d27 cx=c_pps
 a=OViojaO3c1oaidwcGWKC2A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=0ECTI8PlQN0MObDprVQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX79klB393Fg65
 2d9me63EMQuDjfJ4+F6mpk5yJYSF/RUWKXDwzCyxFjkvGnGvDVqAEO2ASwfG9mKgIiZMgmvp/HA
 nEDlC+qj5RdwJlcQkKj2TMLrttkDAq/3EIWmJM+6knUoZyQBdKFTc8PxkeMChloCLSnu6jnWqjL
 e0z3MBdOAuYc3Y9NNZWzewcOx8aXAFaVv97Rz/A8gQbUlrRQW4kIkbYhz9nn72Xdg8jxxmM92PI
 xPZoFJxTJ8RtPukH53q+kIPzSzytJro/FfD25fiLg4CNJlgBX3L5iU95yDsfF9nhZcCAX64I/nW
 AK9KKaDmvXbp+eLQR/Qth+mckPVBDuqcorcCht4zgCTdieGa0p2ubrNp93g7otQIftgxwIg58Lc
 HV/4iRJvlVGtaii5UO6iAvOmepMbTipN+trlUqrX7e8Qlfb0ly2kgVL6JiatGAxZ+TQCWyZkc+M
 lFM1iZC++cXfzOlcxFQ==
X-Proofpoint-ORIG-GUID: dprbls9CPp73lYGJb8v9F4oLSDFP3AL5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfXwpHsLz57Rv9V
 QQqbEp6ovw8FzemlBSidt5A+As4JNSj8OPa1pbN2fEAUzDEUDS+XCZV/MfceX3ZDFaM3CvhYUXH
 wAnVAqmsWj642pngQD2Ef/lVeX55yL4=
X-Proofpoint-GUID: dprbls9CPp73lYGJb8v9F4oLSDFP3AL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070064

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a kref refcnt to struct dthe_data, which
maintains a count of number of requests enqueued in the crypto engine
queue which reference the dthe_data object.

On reaching zero, this counter triggers a completion which is waited on
in dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 80 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 50 +++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++--
 3 files changed, 149 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index dfb26be6d20ac..75361afa1b3f3 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,13 +110,13 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
+	ctx->skcipher_fb = NULL;
 
 	return 0;
 }
@@ -124,20 +124,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -148,7 +147,9 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	if (ctx->skcipher_fb)
+		crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +226,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +338,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +521,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +557,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +590,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +613,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +725,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +748,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +768,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +875,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1146,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1154,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1209,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
@@ -1214,6 +1242,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1236,6 +1265,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 911e6bbe4d241..cd4626ed4c39a 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -31,22 +31,54 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		kref_get(&dev_data->refcnt);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+static void dthe_release_drvdata(struct kref *kref)
+{
+	struct dthe_data *dev_data = container_of(kref, struct dthe_data, refcnt);
+
+	complete(&dev_data->drain_compl);
+}
+
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	spin_lock_bh(&dthe_dev_list.lock);
+	kref_put(&dev_data->refcnt, dthe_release_drvdata);
+	spin_unlock_bh(&dthe_dev_list.lock);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -152,6 +184,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
+	kref_init(&dev_data->refcnt);
+	init_completion(&dev_data->drain_compl);
+
 	ret = dthe_dma_init(dev_data);
 	if (ret)
 		return ret;
@@ -184,6 +219,7 @@ static int dthe_probe(struct platform_device *pdev)
 probe_register_algs_err:
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 probe_engine_start_err:
 	crypto_engine_exit(dev_data->engine);
@@ -201,10 +237,14 @@ static void dthe_remove(struct platform_device *pdev)
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
+	dthe_put_drvdata(dev_data);
+	wait_for_completion(&dev_data->drain_compl);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..03a0b426041ac 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +54,9 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @refcnt: Count of requests currently using this instance.
+ * @drain_compl: Completed whenever @refcnt drops to zero; waited on by
+ *		 dthe_remove().
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +68,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	struct kref refcnt;
+	struct completion drain_compl;
 };
 
 /**
@@ -78,7 +85,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +94,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +110,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

