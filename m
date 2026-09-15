Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6D486647;
	Tue, 15 Sep 2026 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466199; cv=fail; b=mTqYUX1VotcLS9cI2EIl4n0Q1t1tQD3hABl5BvpscDopXf2oae2j+WHNIAVjCBRxelkO9M5k5bGZ6Iyim1j/pUceAqVch055hqzOZ10GysoNmsDyPq3eo8lB0exEMtJ1izvZ77D4Mx4TaMXh1hO5L1iZiy1M93SdtZ42pEjWvzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466199; c=relaxed/simple;
	bh=rT3SC/hCXL7KlyVJ01lf9BiHNu59V5uYF3pCMmVTNJA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=cBEkIElIkbhaBJJQsmvlWZk67eAb1oPNvw0EFbrCdsx75LJz5jUhaag2x++RmJZb+KfkIMIKuU3BDxLWdrGXnPIZubJAFsXfy1E0buY64qlT5cqgZ1ZPZ3VWdMeO0wjRisdOiFHGQCmJcgrokmmc20KSbfFoNrELNx/iSQI93Gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=G6tsRzmZ; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=nHK2ZV9W; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="G6tsRzmZ";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nHK2ZV9W"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9eksg1480570;
	Tue, 15 Sep 2026 04:56:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=FNsE+Cx7gDJmVML3m/K7srnVVdFVYpjmpzAoYV0w8
	ig=; b=G6tsRzmZ1rQIiy68L+7B8ypLeLy+bAkNAYtFUit1g8RZ7F3/7L1SjciaK
	8S95TOJ9qRaxVPnq73xhqSZ0k7fWKaMkXzSF5taeDHyfaRAiYrUNvH5KJTjg5TYF
	U9G1cV6YsdBTYpwWr4olJiHwian1AD6xWsveNqyjYHXX223fvjeq3VPNk/kRYj+O
	wRX+UsjqQXBIa+Jzr55pFow195lRmt256C24Mc7U/0Le2p9iE+HvkaoWu2s/QTEe
	LAqj2NToiJYm/wXEhCxRtR0Aw6F4mGXutaAQZLYAwRmYtvwxVIczMG3i4XfD/KbD
	/wZ8qCI/9xRrqH15d1nJOXfxYr6+g==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j1v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:32 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rf+dkjkAFMkEXBWBhJBxPbpkMp0UFvLcrN3kKnHcpNfa8NubT6aRaG/za7nQVjYk8GhgqZajBQBnC3HSs23jxb1t98nflD0++Q+jfc3FS58sCmKoTPSwsv4KLxxWLOcmJinlDF37QIG+QaN4u5ADth87Z0WRx7Vcbh6MwoU6mrF/yCKydGtXA92X/6/dNr5ShpiBoyWaz5And8KpjveWxf/I90F1nvVYd+ipFva+K8SVfJlsVLFS3PDNHUVJNn9qWghKLjehMs62213zXLQbmQGv5xi7GA+ckKF6J24RjRjKmeoj2/ODl12Scjjq6bM+SrlSOIFeIdn0KSherrNyLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNsE+Cx7gDJmVML3m/K7srnVVdFVYpjmpzAoYV0w8ig=;
 b=pNN5ha1pvJhq6baWj6tWu1LEAK/DpEc6kOCG4mG7JA6ZNCVCPekaxaGYcy9szTX4aC1IawFivgeqfrXzEF6Fmyr/GC68lcIHcaprHIKpFnuflLKpvcAWBtE7Jf3qKSDC2Lf518iBfXg4yt1jlD16HfzWzlh8e8KL7nrxJBqfbscmvw5b+u68jITY1XlnIOk2g32yq3I1l4WmXuJqHpS2AWMQ6Zg5K1qMIdSjgOCuEAx6zMrPgGNW/2L10EGaLHEbKMkxJbpeYvyJIALZVJI7l8pdyf/kUQTZmQnxQx3qRrTtRzVu2P+sw73gyD4/GUypZrXrt0KyxwLEntN5zb631g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNsE+Cx7gDJmVML3m/K7srnVVdFVYpjmpzAoYV0w8ig=;
 b=nHK2ZV9WgEYqNExbRVmresYL4KiEqKHkod1Pq7gSGw3fYsJGZWjVs/Y5VLHSPcP6i0sZuyFRVxjL5xmW36lglfLO+NpUZbkKDJyvSij4LJhB+5BtW6TJ279JGaymKMeSr3xwQ2xOgMVFwJ1VjM+eNdv5VMrjeW+HYSjgbrSuyQQ=
Received: from BN0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:408:e7::26)
 by CY8PR10MB6491.namprd10.prod.outlook.com (2603:10b6:930:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:26 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:e7:cafe::6e) by BN0PR03CA0051.outlook.office365.com
 (2603:10b6:408:e7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:26 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:08 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:08 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:08 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB863000901;
	Tue, 15 Sep 2026 04:56:05 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:22 +0530
Subject: [PATCH 16/30] crypto: sa2ul - fix resource leak of sha in
 init_alg() error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-16-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=845;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=rT3SC/hCXL7KlyVJ01lf9BiHNu59V5uYF3pCMmVTNJA=;
 b=UoaTyq9mkbRxt6ALDt0LYX7k7SNvTLcshnpbB5EQGehyDUOr/j0ewDB4Y1o62p4i30cQIaIZz
 z0Zo68BjSaLCMg66tveFNu1LfA93/TBjm5Jn01EN9aRxDCTuWnfHvoX
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|CY8PR10MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: dc7b014f-5918-417c-68dd-08df130f9b7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pIc0tjAQi5+cBnsFNrr3Cz+w1L3sdgcXZxPJ2t5iuA7EeqEGV6l9+yrWHFok9lvaUNDHEUPFKCrsitmcO86p0nSOBiwbM5BMc3zFoG/dwMdACdjL3PDezSF66/1k5VI3yZkXuBR7KKXo1ur/DqQn6Onja8p77H4BPbvIU6TsbzvQSSZi0ESXRVszT3eNAax2njkPYRWUjLcs9CTVPABsPHo0/Jrq55h41NL98z7I1NQ666Qc2t4AtBHeObwInYVajUls6qxmXV9KTF7FgG/GX67mz5ircs20GtZ44oLwMPD4ysuZEbbeTmpYcvFxCrstlJEXTP70Aa5cL2E0ds7K1WnKtsg6z3ExfNIfHsODl0xome9SY2CBKTiY4zZ3phbY1zbq2etAmGvHYxsYoc53+/wg4DHYtDESV8JJesaCeg1qLlRvqP1IwtZxFKks/FILxMqhR+AbFQqkwkY02H2QpabIrP7PAso/CWrn4uSOUa22xovOHvHIsQipnmePS4OMFdI4rzDEuFcAaIXKb/9QPgP/Q2VRnuYR/+1QdSqXBUw0LDBhOJVR7DEo/ShPr9PBAuUoeuJnUU9ZWuoF5r7Ik+4fgI6IMae+sBj4lsl+1ojAA8FFe4aTPgqZgI+Mov+fy9hk7OnM+cxALEuC8CRiNzuouYspzsDg9ht4v7CewgsUBYbKmHvaYIM0jM6jxGHgscMryq3pt5dAx9j5GjPEYQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VyD1MkNxFEOqFi02cAyUNYqS5s33y4DfHVGOf/8nEejPAGcCINEmRslOOGQ3+M4F5Esq6FFnBA7dMRVdq6lB7kK0/pkjI23ksbKWfULExc7k+F6/eKmGOqkAsitHRkU9uPOkcqSG3mU6zoDet/v+vVgtgeAptLlotFfZuWURFVODU2aw5svL+5m+5sQMMiPIinlVgJCE2Qr8oxzSZ9CawCRCcqgdAmNHPxo7SDad5cM+eUT8Yqs5txrPWL9+O8mb+pmhKUtymXyfjtb7ACWmJTq+s1E3XCRmQYtInMH8H2tSftjcYlF2/33PFYGan0dU1Odxr+hgr1cN0FAcNYK+YoSuHqKzH3YKanBiwUtnEBw4+suY/mLHqdvEJ43QWa8WcVfRW+oXJejm41VXMyE5zy+sd3zeve8MrmocUIuSoWXRQan1DvGPSSahfPXCI8As
X-Exchange-RoutingPolicyChecked:
	hJDHeSaw2kmV/S7ullYrNjw9ezdYKLUvykQZ1h6rNIVmwWGfaAkHkrVTICByeslzsFcWrdSJGVnp38TQX1qUkEXc1T+jKisIJZ+dP1sUfm76Tl2z6KLBhTvF3b6jkWRWD1E9ui5MZCas2Ti416TiXQF2WdcQ+YWjR/0/2vTYgjr20pRHufZkXP0RSROK7HTTnwWaau7riwFG7qtcv3yVuAymrecclsnoZRnKBl15+KVyT5xvcD/ZFhTIkaqWDxTXd2KZtFqzvNMbvPzROoMvl1uWXSP7JqwlCUkb32oStjE5ZmCWKFrez6eymRIxtC/Lo5N0gBxl0oUfZ1opO/3fgg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:26.2529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc7b014f-5918-417c-68dd-08df130f9b7a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6491
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX7H1jZeWvnabN
 C1/2WvOwGnZ2xfByvjh9RRfPNUxSo/QYJqZeOf0WABocI89Ii/muz1zmRlkOEea/GZnFumVcU1l
 VIJ8cVb7IsOw4waqVoSp/qPPf/sUL7hJnNHNLTTSwCvrG/20o7CLAUUdHFoJ0ZqOTGBPtRc8VNK
 de0UbSqDrSKJOf235x5zlERtvGKOp8Agj7PcLITPoTNvO/Tse53loYfFfMyr3TNeYKgRdjt+aMV
 Q5lTdgWLvLw+YyEOtr7ciXYyf6zM8AZZR9TYiQUHMnd2xvnQYGfoB/5eUqF5HbP0yx5Hq4FDOYn
 3y+7LhioBFg9c0iQlch8ZXH9e5lC2oAMiAzrlqMs1Vud+/0eYhfpUUGX49mygSyiNk+Z9FImqIW
 nNOPVc4XzrPdHRqufEW9+2crjTdekJ7SDJRu3EDpz4FtGU2mI4OHK+rFxc473RPwLAyDq8vtHS5
 KIBIfqu3hjtbYW0xBcw==
X-Proofpoint-ORIG-GUID: 493BBxp55cmAUVLZBHoZWKA7sfR8YUnA
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91650 cx=c_pps
 a=6F5B6RZBoOcbxKr4+OQwLg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=rz5iBERWMEUT3MW84tAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 493BBxp55cmAUVLZBHoZWKA7sfR8YUnA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX7NnNMJfh+ZiF
 FzBo8/YS/MoruKtl1Mq7MnpYTaOwOt0+bTbcP8JfyLYp1E+AW+N2steJbkiVDU2W9TmLKmaA7Te
 M1UYY+e0+5Qy7sy+ouIcAunuQCz7WW4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Add crypto_free_shash() call before returning the error to properly
clean up the resource allocated in the previous call.

Fixes: 2dc53d004745 ("crypto: sa2ul - add sha1/sha256/sha512 support")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index cd80a2dabc99..9379d1271698 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1465,6 +1465,7 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		if (IS_ERR(ctx->fallback.ahash)) {
 			dev_err(ctx->dev_data->dev,
 				"Could not load fallback driver\n");
+			crypto_free_shash(ctx->shash);
 			return PTR_ERR(ctx->fallback.ahash);
 		}
 	}

-- 
2.43.0

