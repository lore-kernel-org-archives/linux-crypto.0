Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54B3F5BE6;
	Tue, 15 Sep 2026 09:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466156; cv=fail; b=gFfHSDVbRsp6a/3m6GJ3oRkVpKo/K+3vMTgSJGXEtBfV4bmx0U0qHbTqkc0XBXB5qjPI+U2xIEdKYvB0Ryf8bhZ1wqGC2BWaMNortBb8xWEM2/D3ywqEJxXPgrg1yeqsxodOj8zcc2q5lhYfv33111E0VDpesHts1cWmPecvO/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466156; c=relaxed/simple;
	bh=f776/xSGZNmFlHqNFJsC4rS5WI7Ha0k5aagWwm4uup4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=JITX0V15nF2HPfiMj4yMCiPDq+gGhBWmY7Z0o60cQhI7JcHkgKbRm5RG0HpxVmqQdfuWv2lejR4PJDX+P934+t6CZb334izVZ5wcUdMsTGww6bfqwZAV7bwEwoDfnB/Na5fkvOm98WhdlfxbDWEtMaHcOGwIL825rliiI2Hhrlw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Mricg0Go; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=KZ7nv/kw; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Mricg0Go";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="KZ7nv/kw"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9eiA51480537;
	Tue, 15 Sep 2026 04:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Yn4dkRkqN0VzEoTnsOy6XnQbkaduRmXMVTPgZoRpd
	yE=; b=Mricg0GoPBit/8rMhvmwFfjg+v+DCWodv5ZFuA0HSEBgjnQ1KlAm82JGc
	DFRzzIwgp9lmJYQXGrTHKDP6Eesr+w9MGfG9kR12LOJgTUMxsXiIoncAJrLorOF4
	BtRsXa+iJn9HCyKNo9ku/o/X07bIs66SuC+lUUHqJHtTEL71/YBSW/jOcL3Nygo6
	Ie9KprZXb0lBY4/Otftrz/nRJkKRL4l9DLl/FH/UmByvWFCjZRqMOZyGu3hJc0DV
	h1wp3IvEAVGbnsYV+DkauWGHD99GGIRvTqM6PYbV2oLukIh1rjL7PM20+bJWumBW
	XdlpWSXiCa9lOFAlof6zxmhWDSpNw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2hwu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:55:43 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLpR5XAuqiX2xq7mUS/ac1Y9kkto008IAAYZvPqJpp7J0LhCX8v9XcVSGqmP5hD44w3uTWnSDmXQvN3aRdayp6C3bVdjv7LGos9C/2hKe+peYLAgeqoWCf9SmJ7G9k3pwx6RGyepIM/pSIKsbhLskjT0QB3H3lKTbZNL90E02xqDNCx0/pFFfps066HvwKMAuSmq+7AsCmqbDvzJ0n6S88bLaxahlJQ7m6yeWPEKecl93l6+pO+5ex0gH8YwzRMC3J2T+mp0UF14U4AD0m9Aq8fI9LMuWRmu9+e+pU+HW1a2Ivs5NYisgSMw5DvDd/Bck+2qXet1JmUALfYIkdfhkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yn4dkRkqN0VzEoTnsOy6XnQbkaduRmXMVTPgZoRpdyE=;
 b=pb9dt+kMZyrmF+7FcNiujlZBcypVe1TwVNCKU5r7rIi77cWXJuitG8YQRAS/ALT305StjClal9dr/lK9r6ogQJ7f/+8XaDamV5FXqLDni7Dc4pOkcvV0F991HbSHq//fvJz62PG3tzqQQZ5VDLLs5xcuzDISEmndoym5j6sDX5imFCbXVc61MS6TrbeSYAKB3QvN5IHmzSmPSNakf2mbPuzVd0RX41GOwcopf3pyvxB7n7Zl+Rgl7lqZT8pFddLuaktuVJnz0nZD3lfkkfhPqPpacmQp4EOlNu1L1bIZFcUzd/qEo3r0VEy3XUF4tqS8M3cqOgmC9bspxlVVe1OggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn4dkRkqN0VzEoTnsOy6XnQbkaduRmXMVTPgZoRpdyE=;
 b=KZ7nv/kwyVa3Hf+g1nFKKkfKAvq3tgeXtMZOgTOGMx4ClK5kHVG2Hk//g/E3RptykXjMsK/COP6/QnilId9as1Cu4HUiR6FW/CuPSOAtAYLUIW5BN2xN9EB/pH6ERjSGNIJjtJnqSdBfiHhAewYL8p9o9EEWntO+aIRwjrDUcOQ=
Received: from BY1P220CA0047.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59e::9)
 by IA1PR10MB7261.namprd10.prod.outlook.com (2603:10b6:208:3f6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:55:40 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:59e:cafe::2a) by BY1P220CA0047.outlook.office365.com
 (2603:10b6:a03:59e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:55:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:55:40 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:32 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:32 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:32 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7t3000901;
	Tue, 15 Sep 2026 04:55:29 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:11 +0530
Subject: [PATCH 05/30] crypto: sa2ul - remove unused fields from sa_tfm_ctx
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-5-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1389;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=f776/xSGZNmFlHqNFJsC4rS5WI7Ha0k5aagWwm4uup4=;
 b=gKqeTyk24k8wEMMBXIJlr6+zY7ayyFc2WNtq2hyGO+ti6bap2RLFCeJKp/o3LYS8vjlsuVYtP
 y537Ic0//+RALQaqLFKDAQRtpJ623k9PERwasXEc0DfkjFgugwXU7oF
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|IA1PR10MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: af2bdf00-7fd3-4f45-0902-08df130f801f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZOwJp2pQY3fjQKh/FU9HSfvx2+nMXE0/tizZK2mEl+Jsj7Ib92SzN5gW4FLgHJ/VZYM9g/PMOh3A9kDBvnDjrf5idNLk+EMqPT6JNSaYJeK6mKNUndIgXA/G6h2cNvOhZ/O8X3ZPAun/Sa7hWXhV0W3JHkQ2ZmMmXgAzGq15WLV+ACQA/IhBR/6HjyKd4FOAjiwsWoRUNVT1Pyzkc8+/O+j3lrMPiLR+GbWTdR1o5d2IVujm/cm45EC0KIDfiCyXYjxM6/GrEpfsrs8E0R8BZY2/T3RoRREyNgKIjbKI9XrYw9bDmosQHYpA1hzRhBhjfUGnna7yNitE+PjdSpSyXBKjO5oab41OWKl2xNN69GsUToeagI5L5TGjbrIW6dKdiByz0ezmYb4PvmCOM8/ku2FJ2TJGVrsoOZw0h/Qiu8dntntZZKb3YLW8LVMYAO6WA7JEzsd3yHoY84O+dWC5IGJBRclo0RMmJd6I+YmTG+UrkLUhMWxXINENX3Ajw6qDiTUS1tnftSnG3lD5iuxcXxPc2n2y8ZK6YRW7SvahVvKbjn5PvqFXai5vH5A/MPuzb+t81Zkm0TRC7rdxtNTcWymn8slL0ZqIO7Yj6wR3g8FPMEWS0h4ZrhtBeQXgsGnoFYHAJ3eNHvZWlL7PW3iBrlfFzvv3TK8aC+VQrEN8OCbkoW28dBghQBnpk3PJog3uIUfuwRRPsM0OE3dzd+skOA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	n46UngNE+MF7zD4yX71v/x0pC992eN87i5WK2qEMGEa2dkeDcu6zN+O7LceV3jJ18+ZbFQH7NrpdQ3ff/D7iwDlE+vvAHRomwsiw7anr5wx9zYXTZwVnxQE6IjYOZqz53C3h/msVxmw6GbRKRpj/jFYogS1+xFqqCnuWVSf33aEYUvtWu1BPOVZdhIcnWwCQhiWxxvbOI6ouc7Out47s35G5oneeaYyvFGjCctbI5epCJ4gkCpdiiagFwdvgA6UOqZRgdtRVAdTbX98pLzLSDGLekYMdBw0t8tw7QQi/Lp3rQKSn5tGO+iOlmujzRfFSp0WgT3rvpSlB1Gi31iWDYzQsx8+hn+POB/WX65O+NmwwztxU05U2V3S/ZbmCoihJABoktHICJ/8gi0iN7vqJ1jPOw+hPaIiBqFSWP3qZi/eW2sEd+ktc3AGWN4niPyAt
X-Exchange-RoutingPolicyChecked:
	n5CbPlMfuzXVeu8Ntx58uf/UWw82vZ1SB4RJHUYWoYijXQN03ef6CuI3K7p7pAm5A/dNhaAPXAa013yZ16PUFRu7s4uOomD9HEObW/nqO2cSdCjTRpmTsDn1/ci7hzQZZu9cXMWzZyhhUta2wfH/nj3Tr9xCFhWT3809ZbXD1slqf5Rzz/pUt+GFfdcTc2SVhf5gcrgsdiTHnGd8PnryYINa8mXG0RRvJYZb10m4/zzFFD8t8CUAZmGucOH6t3npR1wizwANr/6FpgGFDGDvDDA+LKiZDofMojWyXqxkd+ajergA4T+EGaBrO0NcteW4Zruuv7psax0iEF8H3KoH2g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:55:40.3539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af2bdf00-7fd3-4f45-0902-08df130f801f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX4mB2ayhdp6Cb
 ltT3EshApBLGBtHNlry+Y3n0xoNrt93SmaCXqIrvd3L1wbHYGTFOhNzW/cYnXWnZekYWNS6h2+R
 nXx5qKH/Bu10dBxI1N2XncE/yzqCEknnVUNIMlj3Cakty/2Fmn7O4uNKp5u+dDmipsc3+DBJJd3
 LSdr5RsGWSSVar6SkfkLh+Z2ANXbvXgaIz+Ag+iJlqz4lZ7NlzEKfInN1+9mS8OuHYelK+QdHC7
 r4YRcb3aaTjSB4Q7iw2iLxehTreH/XqqA3yloAl140PQL3Vg4zist6PgAmjzQ2/6eLG+NkfvZqE
 edHU+vMEiJrS15U7YmoEwcukTxCEabaQEhhFn3/N8m9F/7yuagsVeMs4BT9yhi1Uqs+3vURT4xS
 VBja+maG1TqitJ8e9MXbA5QUFbfEpwa723D4mZcv2ZSOEZ7lgIx8DqSjVbukkDaRwHPjM6fUSve
 CJK5mhNDsfvk19iDqXA==
X-Proofpoint-ORIG-GUID: W0XCx7ou0ZMNEgd1sepiKNEwadyVR1pg
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa9161f cx=c_pps
 a=SMA1khf41ao6nOkIv5XeTA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=Tr8g2v-ZAkrEVrEOxdQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: W0XCx7ou0ZMNEgd1sepiKNEwadyVR1pg
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXxSZeSXUzWKlm
 ns3kdwleFa9b/teTHiyHIMFV+Xig32ILa20ej2ma81EV9CUSUxKsDQVXWIdzyWoHXrY3xhs64YQ
 BZMa1vApok0NGRevx86TkbMA6ocPUcY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1011 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Dead assignment. Remove it.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 2 --
 drivers/crypto/sa2ul.h | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index e49cb741074f..b36437d76891 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1406,7 +1406,6 @@ static int sa_sha_run(struct ahash_request *req)
 
 static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 {
-	int bs = crypto_shash_blocksize(ctx->shash);
 	int cmdl_len;
 	struct sa_cmdl_cfg cfg;
 
@@ -1414,7 +1413,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
 	ad->auth_eng.sc_size = SA_CTX_AUTH_TYPE2_SZ;
 
-	memset(ctx->authkey, 0, bs);
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 097a496067e1..f29e0b9ac82f 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -293,8 +293,6 @@ struct sa_tfm_ctx {
 	struct sa_ctx_info dec;
 	int keylen;
 	int iv_idx;
-	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
-	u8 authkey[SHA512_BLOCK_SIZE];
 	struct crypto_shash	*shash;
 	/* for fallback */
 	union {

-- 
2.43.0

