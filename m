Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771151;
	b=N1ru+J6FFjDM9byDpQGUtb3OUnmESqyyWrAal3fEjjW0xch04HT5ADfkHovWVyAfzx5F
	 k0Ve8P1st+ytvkS9xYwDoEboI/Lz9df7IDytvhR1xPnFPy4/sY2q4x6AmBFLcK1QB31nd
	 f80zTo6oubEsvLwmPHuVeAAwOTOFsRdzPVlxgLy3xcB1xBdKB6M0pxtcHQxA+Yhm9DZbi
	 zlvtp7LGF+Q0SuvnxyXrCRR05zphKUXNxF63Cy/g7UQGn02RRW6bHuTn+HeZxsFC1Gsr6
	 jIHXzMaWjEK+jkUZsIJol2sJvk6baXemnbLwMeiMI/6zUUm5h2RK4zLJANMducLlKzA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771151;
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
	bh=1JufT7P3nEKgmSG2pJxK7o5t8n094HnIZZzJevnxcTI=;
	b=z8oS3+PpRZ2vMJAwGJOocVnN4ovafryB+XTkz5PNCmbVXqPFDTGVcDsD7Fqya7K7Pobn
	 Yo9N3dLhpUD1Aw+Wmbr3b5C+TKOqT8YmIYDUOwEYVaZ5I9ZWIXFex5qqKqhj6F0bBvbW9
	 8twGybdwEt87n+OkyZVyk6AH/XVuA4JuGyC1R0gULAq8VFJjP3p0tMhrS0Iwv/E4E0Ao7
	 97DILswMIM02IW1LsbwX3TbPPOyBF81cBdj1+E9haglQl/2AMseztXsebFSCjMe/Oqytw
	 xtAvoHJKuKpRVQSpYueQEYLOYSt9AIe+NmlSay6Ym8Ax6NUTUCA1Y03OZKGCrLf8ddg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VXjcKiRq;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=aCsHN3T3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FFD606A331;
	Wed,  4 Nov 2026 05:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06FFD606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=VXjcKiRq;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=aCsHN3T3
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5L81166992;
	Tue, 3 Nov 2026 23:45:47 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=1JufT7P3nEKgmSG2pJxK7o5t8n094HnIZZzJevnxc
	TI=; b=VXjcKiRqs9gKFsi77pHpwBiZKqqj0LmhL6Sk3aMwJRrbylCyXLhtAHFoC
	N97nFP14xcKK7olrSL0QBiBZiUNkAX+BFZ901GVArkdnb8U+kXZuBIGzsz9HHVdk
	Su+nkBDHjvRKi98XGAS8dMsxM5aaEkkCkntkJBYyvenK7dZL2V4cgm0wq4muOsx9
	pvY6J2Twow1bmdQkC3KwOK6ilnmNM7MaKwJ3+p5YaJf9tesPGnP6gbjVZuiQUib5
	swXOdOofy/KMpTSmmLhslnulGxqWpbbPkIfXMDetaSz+tjKK5hh5HgDgKOA9E1MM
	SlzSr9PVpXyrlNr2bfuBsBj7LQqmQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh22t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:46 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WO7S+TAB92wEqD2J1Xg4j8nCtZH6ln1oImUe3d2szRyB0Nmqr7KgUIUHLhY8Onvnim316vUu8klQaytOZb+oFA1OzqnibUHR/SS7kMUNFoe+BOoahsq7JbETT/bhjMzpDnse45zFcODx/j4UC6ciAu8rn8ZuMLnUvgtArQoP4p9zBmyUJLqSdPXPBxYGQXqv0fE22AOi7ZWxSA/IueC392+D4595fGn+7lskf4BPyykf5jcJzBgkd/vdaHle3R0n/hv+S3+TBaULhE04Z5pZqK0uOs/+0ATw8P2OdZd1bwmvM2y+Q0hUt18EbNekRZ1wdj+3GEUssoJiRTR5rsYTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JufT7P3nEKgmSG2pJxK7o5t8n094HnIZZzJevnxcTI=;
 b=FtMzPl4hpzzIV2rVJmTtmhSkytUMuXXQo3hbuXKmdPNbAeUOsPx+Jb/Oy7E/x271h6+gifn/BQ3IX7E9GvxGwrlpeOldEu9IIpGbr4MOwRjDzUHE6a0DtgrpQijYu1c1lARotbfK+k9YwgvksXnm4XjKN0EOUQHz0j/03fIGkYp7JlKaq9Xhj2BCGiJFZddkujw4Anj2umBJEAkX1vjw+bzwOXuCfLd4VJ0xdNTt8o/nE6FgEyKMrMNXBhBNPzgVsaWWGF/QI7ArZ9X2dM0DFFkfAjFYLo6b6whLxikZ9/ifohxd0IwXqbmx+QJU4HaOAXrhYxHy/TbAHoHXS5KZXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JufT7P3nEKgmSG2pJxK7o5t8n094HnIZZzJevnxcTI=;
 b=aCsHN3T3RRWhz5I5OYU/TjupQwqvvWzFO12C7AWHzCsJfRZqCQ2reJ3Zguxzi1CS4j7YfZOdMsTNT+fM7SlAiosrryqyNcC8GVsqrZvQCUhL1mKsUa/iFN3qClw6FhXLSk+bW1quAHITSzoQAhQm1ZRVVDf3m6VNAiPOzM/MPb8=
Received: from BY1P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::6)
 by SJ0PR10MB4816.namprd10.prod.outlook.com (2603:10b6:a03:2d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:44 +0000
Received: from CO1PEPF00018868.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::6) by BY1P220CA0017.outlook.office365.com
 (2603:10b6:a03:5c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:45:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00018868.mail.protection.outlook.com (10.167.249.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:42 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:05 -0600
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:04 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:04 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxt521920;
	Tue, 3 Nov 2026 23:45:01 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:21 +0530
Subject: [PATCH v2 11/30] crypto: sa2ul - keep the probe register mapping
 local
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-11-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=871;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=Nrc6gwltAWEoZ1EIo2eoBWsCcwgupRg/gsR312ePN/4=;
 b=opPxgwMoGF5J5sefaT6SKA3HJ96gwRDYWBgdhMDv9HDwDrCvfFKqA98CFhcEe2E8LStNYh6Y5
 yNi5mvnqLg4Dk8qcOikEYeU3CU067fdvNniZen7jI+37a1SJm5x4uCB
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018868:EE_|SJ0PR10MB4816:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c16ccd-0f0a-4132-28d6-08df3a36dd7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261021121427099003|261021123027099003|10067099003|22082099003|18002099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	6lifWsi99u1C+lRYuCulTBICrcOPBprmCqYV+VTCyEVB2TdNOQivVcB1LhjTnNvVMS+vqrlxXwQ1LmRtvW0Y8DaTiL4EZ7nq0ubh4MLvS6wPikWk13rVn0m2vT4TUNDidp6ND3DByrflzIuGpekcJyNN/+Jh67OtgB6OmkXbQ2zxpTY2IlfAh0A37ju15J3Gf0E0qKScwEq3HGgLLLI4jwPCyjS85Vzk8prRCrKbcDxuexkzgKzIXFNvyDtjC/xTy6V2rZkI1J0Qg0X7Zadqg70KW4oMsUroKAVBAsKzrluw3UoA3t0Si8nHDQMZopwcAfrQG36Tws8dj0YHwb226YIYfiBSBCnA1weQd+bQglStZRMwIwrBkLLg11/gjWbrI19E2vF42dlMlxyg4DsrztZnHLQ5JCwdEsuvdJQFHVIWEq5uvIwzJnWDyCvj1xo6lQiyWG578sobFgsMVd5QfHuBoLypynPXbrrNuZgS+eQ+vC6ua79m62ZB9ZoA6VY1IGnKvwnSCttPQjYf/h/zJ6H8P58QMYIcVqdgtggdGFc2KlhDJ/X/dpSE5IGYydYy4ukASXetD43w1ajmJE8mr7WSp67++KNYJBRESkRU3BZYGOLVrEJBbKe+Hwl5OZ51cMQ85hcLZGL8MAhvzPZaBN0vJQcurC6b2hnfKdk1sBxT1usRP7D9c5QumXDFrCEbRzAVKzYqXx8+hGlxRE9YTQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261021121427099003)(261021123027099003)(10067099003)(22082099003)(18002099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wqPwmGWVXgGua71fvlM+l14iNRcJRX4pyYkNfaQQsnPKaVndVFOwOyWsGJJCoILBX3CeIooJtwNyTcWTtKZqYIBrDFWYwW1s3oaUDp3LWvZeWO9ob3HeFWtBfFTUv3APpjGBneJ3RD9iwiilGEZvIr+IqYHHqNkoN9OMGMWHf1kiSF9riyAv0BluLPZX1tUfr9emDWbpwFVp1tB41vdtq6NFVnprVMYq+i9jacMCXoDqV5hy2QmC3sW143hIAEfzcsXK404M3VEdrDgFk4RV1N0zbByUYxpKmWlU9uUAreZ8moI3qqkyuEo1+R3LqKv5FxiN7YqfeN+xkIHBKmVJevZu0+6YDm0rzMHNTP7t7R5v1lbc+SqXH3p+yfthdd45T5Lp6CUwyvHululPtcGmMlnivlS+Ko5zC3GU4H7EcnTXdjaV8a1MOOmW6zVACMKt
X-Exchange-RoutingPolicyChecked:
	FRcXfCAzRxEJ/uR4sg+CfN/Lg2Orys2OM3cxKD8n74Vb2s7nsdM4ZX/E80ya5GbFOwh0rMXtx32j2qQlqBeiPrAeGZvkwEZqDvfhoH+kNhKVqP0qzEE481bKjhdJg3x0YJRaA8FDD5cId4C3fWkb20MAOqY9oIk2NQLG7W8bHN99OFOl6NrBlGlDotauc6Thzf6Gt4m4WySqcbpVOcZD4PCGlszALX8ULhLl6V6RDIrqG7/ncZba6nQtqyvOFQKBiCuM68vZ9SaS+ObruqXMNxgJBDf8ikX75HEDoJ9TmS8MDnVVbU5GCLx6hbvtIinrnn+qEK5J9wbzrDrqgoAlcg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:42.7337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c16ccd-0f0a-4132-28d6-08df3a36dd7f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018868.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4816
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX2vRf9hfqweWg
 Du/vOeA3t/FbHsz7F11HuuALQS6KIyHwPWZNBoEltpslRI6FrsAMDwcmZuvOQWAYszCZiOqr2sC
 9iJLgqGUDnSuC9DkdLwINmN/Nw3MSZA=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac68a cx=c_pps
 a=oTJwsqqp05Np5voO4IKyrw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=EmVS-y8iNVnk6QU_BcAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: UyBJ3ymvaIP1vYIXN3-xMOM6F9NuFODl
X-Proofpoint-ORIG-GUID: UyBJ3ymvaIP1vYIXN3-xMOM6F9NuFODl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX11mkQ8oXKETP
 +Xwgux9u3+90Fnsl7DdFMuA0RQbd/POdiE4XegS6BjdSF1j8j1H9ErZnYGG8jQgXGUHGfWcZUqB
 VScaG/gMwF3u8NWfeZB29lem7LmAJ5loB+gDeoH2+8k1zArQFhTr3vtlEl0pnNzmAOYajhEZgux
 Lbiiw2uVRE/5k2FrBS5yS0yXgf0+oBekdsusZxVIQ+FXCYzn+dNIGir3j+1QaRFbCBvjB0CgQ7g
 TFK38/rXUs7psZgHpzZMxIuGQKZAMclTQdq4HUJGJF5Fdj3n2a9r9cH3K6hKBLh5FegrULBTUYr
 45FtV20mF/yAXuksRzf1ADzR9sBy0A+o9+pwSMpgYsm4I87x0f8pDO72pq0KeLx6r8f+stp0u82
 g6r/t3H9fDCuHFfGEyHYEO7Iwnfs5AAAKtX32/CrvvGdRCTSChDDzPZx9ow6nRoORxyLouDoud3
 kkz918QstDUtBOBQKAg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

A static mapping pointer is shared by concurrent probe calls, which can
redirect register accesses to another device. Fix it even though there
aren't multiple devices getting probed today in Linux.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 8088eca84129..c0b1c7c5da7f 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2236,7 +2236,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct device_node *node = dev->of_node;
-	static void __iomem *saul_base;
+	void __iomem *saul_base;
 	struct sa_crypto_data *dev_data;
 	u32 status, val;
 	int ret;

-- 
2.43.0

