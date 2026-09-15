Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853CF49B1E6;
	Tue, 15 Sep 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466211; cv=fail; b=PEcHkqoHgjVgTmNkUoB95+lghcjv7ErM/jL5r7oSkQZeYjoYzwhiRpnSgDGDXvTySmSAMQKryh9UcW4J6IhxDQE/C7Zynvr0Bls8rpfnK893r5r4mVzpz1r8q7D0wilSAPmZFhCMXW5b10E6SLIa9HwS+Yp45Hl2BtrYDLryBz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466211; c=relaxed/simple;
	bh=YT2fgHyhAYvApSca0aCLhNDXmLOXy6lMivaejSvuoLQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ndKdxj4On5WlfrhcyZNkDex1KUPd6o7ze27b+kfm3eSpvRUXYYDCqBh/o+qmG2Oo5Rbwpaa5EME0qvzd2p8XuS2RZELN2SUBPtyc1zB92SoMP1YKvU4E/1WIKLh0Eo7zfXWaBhchps/IGmwb6lTYtSwBze7KX6itoDQ98hbB+ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=p5vsSAQn; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Y+xGR+u4; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="p5vsSAQn";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Y+xGR+u4"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9eiAD1480537;
	Tue, 15 Sep 2026 04:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=49rv22ZPc0LzP/W53xcpAe9Gayw3cNJ/ZcZ807dGk
	6g=; b=p5vsSAQnve2vCZpnKgaiDzAUxn/qeF3nqN6SvM3u7pz0q3CryYd4NzX/n
	zD+joEpp6RDhAVYS/i1/LlYs3xd+uhiFYU724N0jdF3GbY4KE13MRpe+dWp0By/O
	M1QF+qUnOP7qCloj7ZDBi2xhZzGp4W/ej51/R9T0rONDB9+MNYCwZKuyeiY/cgl7
	tbZ6pL9CTlDTOUrAY3cZLhLYkaZkVuGC2vQWbn8+ooOvT2Chqje2pdAw4k9jWNgO
	Jr3OPDKkBhfYefgjedvi3vSGlQG9ZOvuYbdNl0VjoKzAjgV4/fay8hhhXZsASMFq
	V8VpPTYni5lAQ1hFQlr8kmN9PNHrw==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013030.outbound.protection.outlook.com [40.93.201.30])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j2r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:46 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HT3G0vQIh2usyIFtt8/ioR8nyG4lZvPkSqrPdClGcO0gLWjv4Fexm2Esl0Im+8zv6ILPhntlg87hBJIt40N1Ka9EuUQezDDqL4a7AdTSXrrJItMsMgFIIDEMgX/WhI12vwLXn03a4wS4Ukk0oKqclCDiB9JOaX81oxyiasQwRu9mcvRnswwfCM77/QgcoccISE1FRTk1cODhoc69zYRgxg2c+RpzqE8SjbssdjxBOk/npV7j9tmUdoEcEkWRgUOxs51wmRaK/mD6jiSSSriJfa7Dctv0ZuPOfnLblKVbhk0VE97DIhIjwVRVIAwEFXu9Up0zmrpIhTE5WrC+smH2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49rv22ZPc0LzP/W53xcpAe9Gayw3cNJ/ZcZ807dGk6g=;
 b=ogYEYtHaC9JdeUlHCpc4AcF0tCDEq0OPCqf9UILYYt9xsHwUI5NoxEjiEj1fU6sqf/yVTvIqevcUlMf58zQFLofVn8FzeY2USf+CG3vafwboHJ4d+BpE7IZE8jD2JsTUIHDfdjLgiOS+woUdDtPLilyZbkurteSUIJJncbnrmiSDBofZBWQP0HJb2emGvwteEwJYbeQ1lxph4ICrc+g4R4nDHGjsRZKQ1SWfhFGpLpUArY6ksB1xViSXI8s5yHNqJ+6zCdTU49VHXISsgLwjDyvZ8k+BoFH2GAuzeMe+p/pPC/rJE0hnSclAzFHjybzkW4+02Cz6MSOCwgtEey4UGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49rv22ZPc0LzP/W53xcpAe9Gayw3cNJ/ZcZ807dGk6g=;
 b=Y+xGR+u40aoHHoYhEGXRo5jE/8gbeI5ImJZIViS+h9oPvWkQlCDIZQN7K6oow9KFsQBWLrJfFXEc6yBdz16p+Mrg8tRoCY8Ggr3awkDiqIkq3jQeox0FoTUmjRZkknT07MpxcZiKG3wR/ZjOEFGpmHM3LPSN8xF30IjJnUMUy6Y=
Received: from SJ2P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::16)
 by DS4PPF80E5E852F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d2e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:43 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:5db:cafe::34) by SJ2P221CA0012.outlook.office365.com
 (2603:10b6:a03:5db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:41 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:01 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:01 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:01 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB843000901;
	Tue, 15 Sep 2026 04:55:58 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:20 +0530
Subject: [PATCH 14/30] crypto: sa2ul - zero out security context on free
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-14-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=731;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=YT2fgHyhAYvApSca0aCLhNDXmLOXy6lMivaejSvuoLQ=;
 b=U5AL0656GHv92pQOCBFLgZ5Iq4BStdZVkn5iz5XLHtShCEnkfcGWIL9BiFJ0PYdcAqxaZdUbC
 t6aXsWfjZAbC+29qaHsFwy0XYMdBUgnznbZANq4NqGMQrSSgJLS0Hk4
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|DS4PPF80E5E852F:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ebcce93-f4ac-4086-a6c7-08df130fa476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700016|23010399003|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	OrW10sr+jRthpIrsxX+0QXrTO58cLgdGOj+nBhCUUeFtcYqw2mscomgesRfdr4OBmlvWbXS7oC63UxF06izl9k3d2ShVqKDvwKyZ8aHA7R0cSye8n46Oa8+kNp+wsHOzomo4gtQ4mg6b/B6wzYPyOZesQaA0LlX6WO6/ixpjcfZHcAQ8eevs6MDh7YjN76hOhBFUdV6ouKTNQ1YyhdPd9EvMeahsxSO8qFHARDsw8O2FaaeVAwLzcholY4MqfFpwNM2ikVh3ui9rBbfnMikvh/Zl6N709Dd5wjeS9TnmelD4vzqbLz3Oa0s/blR7D/955geNLpiHwSgb6DNjW8gDSxGt3xjazOQaPkXhhuPIMe61lqA5vC2Wt6P18i6lf/9X0N9I59v6gMfAvjFxw1yhuUhfsFGt9MlQwBKHvXq8Rf/BDuyAEeNxXOh7CfH5UVrlLcezlz02L7iT6Bs9ekO8cnbbdugYdYut9PZhHvGdL8244JbMu2jUwTdzNnPQS3OpS6xPwgNJOQlnTQNABEAvSm27rigFsgIBL0D5IE+ExKjcpyS5Z5Pa85OVFkOPbaQ2cRpJs9qp3DChKfZvB2MNc4owmqXyLA7suL0JQyWLhtegqk+VrOB0ILxdws7w8+xuIEjeBfKsYKwpsHeoJyTl3qy6ayL2eMn3nrAStgZpduwWGmB3DjksNkVDfG92iW9eb8liOOQMNy3YlQrquBbd3g==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700016)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GY6UVv8175K6j3Pp9sYI39YJPxic1S5wCsONWbbP8RV8Ih57jTMooDQlZ/R8gCky3NSpPPMkgcvG4GyXJOJMeQA+9YzE/UmOr4ktP99fW19pGCg/bAkCeO0dRxlB+ad872czbQ9yAE5RblI4GqUhjc+k+X7ggm2swCX9mSUyqftxrDBIykmuoU0b/PYyjJF/ZzS2b6EEPJi0/gVeY9e3tvdAKRaEwWWnwYgJXo70oZUlbefgtT+HgnTTw+dRYCvxSgqs+B5aAcSGxuWseWhccaQztzv1ldJdCJevrY5uDzpVdBfGRoZD9zOQwFqfqyMHXwNfB/y3/fSEe8ovDy9qFOnY4jKxQenPg22dSBYPFkLf15Wxa+MnL5aCDdNtqVUxSCdKRwvpi1PUObMStF9zqM6WFkcUUkKgWNAYpaWpukhzr6jlKHcTYgxAYMD80T13
X-Exchange-RoutingPolicyChecked:
	eJN3fksgK9Js5Zb9muTizl+6q6qV6l9a3CokwdtOx4iE0jjENBmHed5VR1m4nUFRO3e2yJ+76AeR8fuQMaVb0ICMGC1jG/PG0oOcdNiinhnqvEdZLtDa7SIzKm/lbEsm/2Hq/m06bI5aH5weEszYDcRNN7VjnDlnRGcJvFX+41yspXVW37Npt39VjbWSG1Pm8UrcUTXQ3omo972ItqUxGnhNj3TECRH8uVIDsPmW80QHhSl3//Jyft2PWeuzPMoypF74nuUskxTZzfk3cD7W32+LVYbrNljCLvzh8Z+FYjw8qVeUju6KRCh9rf6WccQV95O9Dmg+RUdQDz3NN6RtYg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:41.3314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebcce93-f4ac-4086-a6c7-08df130fa476
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF80E5E852F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX1jDeyVhBocy/
 /s0zVJpVP6ZcPO/21JJPj77WNCRVhPrVDLnhrt0ncVbHre/zoguR4yhkry6BGWNBv+b8Og2Nzjn
 I+iZp7nyAdsruInGeYj+GHy3Q/zM7DCXCIHvRe0hwcWgxfQ5Cu3uD14/D3J/QWDrCh3S9fssv2+
 EEEH+Q06zRh50emlP0i0F995NxPeXxEJyOKB32j6L7rhqSO3E0mlHFEFVNpbtGGAVM/g4i+pSyh
 cfn1Axdw7JPpRNREI4yhPFgZrtUAXRiDTu/KrrHg/1DE9Nz6hbNL9chLq71EZ5BViZ6rtGByP3J
 ZjGUtZRPuHaqSrV1MDcJC79KfRFCtssxOjWk8eGs+WopVBtr+wiBuKvs5ijsUG3ACYmcIqHW7Lo
 CfNdUkqqqiRol4IeGt53uuBSv56eAaLthHfqkCRK4XwM5gVC4pVU2r0SlMSCfiq5m/sD9YcvuNM
 5J2PXjQMJiFimKCwYiw==
X-Proofpoint-ORIG-GUID: xTCPvN1qX7iomdpspYYR6HC2LWbQMWMs
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa9165e cx=c_pps
 a=9fOKxQ6q+1oHddUNM5AUXA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=QMk6ud2451SdQzNupOYA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: xTCPvN1qX7iomdpspYYR6HC2LWbQMWMs
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX6u2GzSMuOTIF
 li3F/zgruDmjdgesIQ2ErQ8UgV501DEN9LdhsQayDhzZqNw7PyuUCZccs2K0Pd3maYe6cM6Dmae
 cj9/dnP4pD0AGcrGZNRfzE5OqIPy0uQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Zero out the security context memory before freeing to prevent
potential information leakage of cryptographic keys and state.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 673cd1458948..7ec048136114 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -758,6 +758,7 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 	spin_unlock(&data->scid_lock);
 
 	if (ctx->sc) {
+		memzero_explicit(ctx->sc, SA_CTX_MAX_SZ);
 		dma_pool_free(data->sc_pool, ctx->sc, ctx->sc_phys);
 		ctx->sc = NULL;
 	}

-- 
2.43.0

