Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771194;
	b=Qh7ye22y87NZD6eYNtCIKqVTQxDs/d1AG/QxBv67h1INnLfEQfaMI58zZoGaAlNxoT88
	 eE6BZcTcXRa5Pl7Jw8cGA4eqwJMvMvdcm95sz8QMMxaS/WHD6j8Nr3RH1rnBF6/vKYmxl
	 Z25igXKd8Mptfl8jXU7FAbXAQKb1dWj4FubhztbjfxtFhabdINQv663IoPe40iKIrJ9UB
	 Zmh+G42rADK5GzEsmL21zBwJmoBhQXNGKD6tqR+uJZl3daHXblQiAJdUqjy5wYsIqGnrB
	 VMUuWwFk8CyG2OAjwE8E5EluQ/yBHrQ5zzzG0+/M+nIlhob+bchoJqQWTFJChTEG3HA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771194;
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
	bh=r9rWKWiGuOzLmc5IC1igEY+aiq9otVL3meWiP1Kgq68=;
	b=0M6vXuY0uPvT0u1X+3sg9E1d0XvaAwOgOPNksppLfBo4IChmZSniallMtZYicDD6VUaa
	 H6FmT5upwjX50hFpIGMPgeZc4xwOBA+qvl7B7S+fdK3ufVT9+5o0mD8T4+C4ovP3TprJI
	 tcqUSrcE5cCIaQnwQ/nOyRpvGuD5jHLfZcxfAri/5ggOzLLngKlO+8kbO5DYxq3odBbMU
	 M3FcjBW2Y6pmNT7BA0ZiTq7slCif47px+w1V6mTfAs0pdu1d2az8QAp8t+ayDrVKGn4Mo
	 IyXoaFSMAY5OIOA6ahN89DkeQkBS2hbTXyVaSbYloZDHKJJJrqfVUQpcLKKqRJjbkGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lghbjNfw;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="BiT/IEEz";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1E1606A33B;
	Wed,  4 Nov 2026 05:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E1E1606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lghbjNfw;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=BiT/IEEz
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S4J5771704;
	Tue, 3 Nov 2026 23:46:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r9rWKWiGuOzLmc5IC1igEY+aiq9otVL3meWiP1Kgq
	68=; b=lghbjNfwqG1tpxkyurjlLv2ttt7jy7zaCi1qIl1S+ppclwUJQNjH6dIj7
	/ilqjw/qK3WIG7lHGKm8xXXqQizDYMyBDz8GWMZn3KfFQE0S2KaI7umwg8mHI81o
	h6L845N5x0q2HaWxkeGDFGAS/qHl4ntDspwX3zQc5ms5kqYb3xHrL1DsGQggyjIg
	TtKgNJD/gR0zWpjxNHsMNdy01sGMKV9/y6KrEO/8ujL1M9e/qTsHzWYMyGHDIg6f
	0bAu4Qc7KiXzVeXucqlNdr6D+vYkNnD2UeYtmrrm5jP+Nb8L1qdzZxcSPLxCwwqH
	8TTiIpIVW8Tc67csgRbaLwLoJbvsA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25r7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:30 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=scBvwkgGDCaDMnm7tWM4IK7xJjZErfCf2S2/t7TxWIqO3hSoUYsh37x8SjBjM629dyg5j46SPNJ8PcJa+mA3DNl0+wcH+DQ9EGy9N1ktzvats4eLG2Zs5lEZtD1UHOowUSoGv+7fdu6xTkHPrPAQ2M82W4kOk5lFVIzJsGOCl0SZUhpke5d7n4Z3adT7iiH5lYMVAWnnzcIBtBf4y8RlFQSDZNtyel2tUBQAJ2nRltnzRVLsaFo+sQMqVP4jVVcOv77eEnC3FvoCpqgRYcVvAHZscN3l+VLne4Otkf3MKnMzZxo0vOccLxn9Gx6KSwFEyskZ6ixWW/+lnxVAMbtZuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9rWKWiGuOzLmc5IC1igEY+aiq9otVL3meWiP1Kgq68=;
 b=SNtrZI+hpnA6j7TUXogTLfKEF9z1QVIVKghWl4khT9f2+IRMbj0Wb+aHblFsqaKdvUiGIqbHQEBqPnVCo8YX6AR1aStVj1dq0+3PXqUFOdieklfDa2/cKKVZf5YT2TGzv1p5too8W9EOP6ewAo0qAW/rZPC2Ga/Ugj755kBF/zLxJSEIQu1yl7aC41H6gKvVtHrHeO+Q2lWRlp2y5W2FSwJ0/TxgYkukrAgzzVhADYSBWGeF20w51tYXt6x3ZTdcn9HsmXvCYYbJSkbmYcdgT2c0m/+2ZKsA/qDDyNyXT635etRJD2t1tsU9We+U90hnvGSAbbmQY4eY1hJhOOo5Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9rWKWiGuOzLmc5IC1igEY+aiq9otVL3meWiP1Kgq68=;
 b=BiT/IEEzQtaqjjHglUScNVO8sphcUW7EL0DmvCn9o9LRTZgsTDVBYLDRZIMEYoeR6HPZUpeQISLz+j/t1g8bvRmez+Y/LFC5t8CMX0SMLgPzDJok2ZqVRkknSvo2gBngn+wt8wOqOVv0oVU29/x98CgEu9+CQT2M7UTK8zk5upM=
Received: from SJ0PR13CA0204.namprd13.prod.outlook.com (2603:10b6:a03:2c3::29)
 by DSWPR10MB997824.namprd10.prod.outlook.com (2603:10b6:8:36e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:27 +0000
Received: from CO1PEPF0001886A.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::81) by SJ0PR13CA0204.outlook.office365.com
 (2603:10b6:a03:2c3::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:46:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF0001886A.mail.protection.outlook.com (10.167.249.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:25 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:40 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:40 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:40 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ05521920;
	Tue, 3 Nov 2026 23:45:37 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:31 +0530
Subject: [PATCH v2 21/30] crypto: sa2ul - reject exhausted context IDs
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-21-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=973;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=EKqA0YtP8wUAGC09a3UQ5JzjLRv1XvU2zAnlhsj2VKQ=;
 b=JJcDO7suhcOpQiVpfUlsUv6LVVw5iISDh4Sh8u13ZIf57GgcGdQFBteYL3246v1nt2eiTYYL9
 IUkw3fRue1qDGvLrrsBhj+hQuP13fLzxrrkfMc0DJTPxDV9I5ciUrSi
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001886A:EE_|DSWPR10MB997824:EE_
X-MS-Office365-Filtering-Correlation-Id: 049982d3-30be-4baa-fc1b-08df3a36f726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|10067099003|18002099003|22082099003|261102123227099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XHyGVRvuNUQGo3uMhpoWDgzPYtPeR5Avb4OjY8fmF+tcOKVMUzGYDkI4Q9IWQEEQOUf+uVYG2XAJDaGqw11JSRQF3jWzH1a/ids1cKihoeDn1+wf+urm2KSyl9SrqL58BQHcmbkzCjG7nkI2VYTZpGgwuuJFqfm3S+2z5HFqPFvlqRYn+NCYEW+vWK3JKvpDe2hTJrZGhZYx8jSLlR15h4xYEMhSXeleVRHJua5vb4FrknHzVCFX6yYW5EJoHX6DtDunOVbB4/cSYOaBKL76Sk9JOM6w6hdi3NsQ13tvQfbGorRphFPkWXZ2rslspy8fnyyFxwUDW32pIh3I0eHyxbav1fXHAr6WPscgJrh8rJ4jS1QK/pdvAVqmQnUEESUfSuAhwYB2wF6yR3dplIc4UeaZr7dgS0V8jvWSyFLh7c2z+zYr2gqAq/6Yg3AgQjDLml5M/Q/dcDHkONyvi3s+CvKDDXw2ToNeoBw/3IXC9zFcNun7xcWk5FqQ40Lni7uVZXC3fG2drgAE7mKHvCiHfJZE1gIrukIC6Z9A6pK//wQbf8f8JemjP3pk/u5Rct2Clh3qMwGlMU1kPGqhqxy4Ig5E813J8uz+aVa8cgCS/bGtbXt/EhQq1f4gFe9aNfE9Dqp8ucV5QEwUbZ9vVRL7Y9Y8XemFPAPUzdPgm3lLpFS1kR8idCj/OqkqefrTBNlBpfNBYd0MwRU19aXydv6Jeg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(10067099003)(18002099003)(22082099003)(261102123227099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EzdT75krPnmGq3AN0jTyzw7KZxG2pAXtk0pO3l/cAxvEk2gIaPOHH9ZcWBIi9dGm6upamn9V4hx4KRJePc+BYC+q0IDENAS3R7Jz16U5NeGe4XrFXH5LflkdPHXuw5rdb3W7YUAN8tKlEsywrVSaf95MBu8fus60f2qqKoJZ4gMpxpSDCum1RRoDdOQ4AdcAbYixx/5QIvE9NiMQjuCOCPIDPp0XpWi90w9sisZRHihjj9ZqcLrDppVEtt75ALyiTy9qr6x0+ACbNvgw9whhCqzNfpg90uNs0U7A1pZt/zOlUzFj4UpEiTiFxW++ygC/FeBSTs+lB0FGnqErplsDFMYEbglv1FZhqsoDaubcUQiR+VS3O6lmHn+jVFDa92XhKHLJLZLqhZZbC9qoTJYhofWNoKjFyNmjNuParxkSlXP3sOiBZIK9ipeWrQRPR1+N
X-Exchange-RoutingPolicyChecked:
	yuXgDvt/2yqQ4gW4Kx+1cbbqq+i0mxQ7wWq7gmkkHH5P+3P90W53Wt1s1c0fqjNL5exkp/AZ1pQIU3JxvxZ9ZcaBqfteLuNN7LTSF6HEFaeWmknI/Z/ua1nAdU2jGn5nHSTrGMc+ivUuGsU0RE2ZbI7x8JzMk9apRkhcUxFoK9M9tvuQs4TAzdrwUUDBQ62t25zlXzfnDjw5XqgM2dBfj4o5+qd61D3z6DE1bj2vWHsD7670JL1zMug9mFCnhkVxjST3r7V6OwNe2vFjMVGkTPFpHkZ9SYk7zGoRGWzyUnmIKg5M/TVmSWRh/eBxJrOTuAUpFa3Pdd3SQmjr+LE6pw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:25.7810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 049982d3-30be-4baa-fc1b-08df3a36f726
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001886A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR10MB997824
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX0Aaj8LnN1891
 TPrD3en036UR9O6HOSe37s3ZVLMXvJidxZVrz1s+niTvqxtj61Z0zbkR/csGEyQJHY1S4WqNYdQ
 5sRXdoLWYUh54ujtEE1TtvK1ru+ANkE=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6b6 cx=c_pps
 a=Lj9o+5Kg1g76LDS8oSCIAA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=lBXPsmTavv2EAntjX_YA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX72HYS8O9rofw
 E6bYoLcOr8+Q65OLsLeT7p8wzPJtlBPh0Sdl7SJL6Foh0A/aTaLPCTPsTzcuk8TDPBLpJGStxX/
 NhAZ9Br03mCSxae5o2jcT54sglzaYoK4HSIdsQW2Vf+SuBDIu4zmp/w6EX3C5Mbe1KtxaXBW4Sl
 eO6mtesk65ZSvBd+0yc8JwTtilw0yiuP87PByOlApmn209F4Oo9FxHhKUtfgbDT5QFWGdttX2U2
 kLgqchD5acZVjgBpcj2kuYQu0IUfMP4WGCNXj28e6BLD8cZJ8Lp/A8FhXjVuISZ1g0EpQzT+2NE
 li9NFDLQqA8YsSXN8tEf+ETH/MKDgodg3PJc2r6/rjeIcL+iBc+uUse9LBvN6OYr8+sGkN25Iz6
 c55SrxkHYdG5IOoe6mCpupfz75m8D/K9ANlEr2BPi2jc1ScJ1qWIXBA4hUjzyGscSoEbKW52hJK
 O9QC9yAhlW4XF7CqT1g==
X-Proofpoint-ORIG-GUID: mrO_hhZSpn35RZhRU3gFmWxnvMtJZfM2
X-Proofpoint-GUID: mrO_hhZSpn35RZhRU3gFmWxnvMtJZfM2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

When every security-context ID is allocated, the bitmap search returns
SA_MAX_NUM_CTX. Setting that out-of-range bit can corrupt adjacent state
in the device structure. Reject allocation while still holding the lock
so no bitmap or context count is changed.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index ead12f77ff67..2964aa44d50e 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -717,6 +717,10 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 
 	spin_lock(&data->scid_lock);
 	bn = find_first_zero_bit(data->ctx_bm, SA_MAX_NUM_CTX);
+	if (bn >= SA_MAX_NUM_CTX) {
+		spin_unlock(&data->scid_lock);
+		return -ENOSPC;
+	}
 	__set_bit(bn, data->ctx_bm);
 	data->sc_id++;
 	spin_unlock(&data->scid_lock);

-- 
2.43.0

