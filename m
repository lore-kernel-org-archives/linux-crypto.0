Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DAC47F3C8;
	Tue, 15 Sep 2026 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466175; cv=fail; b=Yr37oypmRQ/dwBVZ5Bv764CnUjzm83jT+ZrEiuZVrZfpDB9Ug2FS2H78ujC4Q0eAlp8k9Y/0pnwfTef7D8kO1qmWG+LJg5UqeAD+h1FV+DyRiGLj7XWwy+IS2VjpiSR6G4kSS9VQf4kH3FaBpQhtnIi3QALJ95FoVx0up7oSI90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466175; c=relaxed/simple;
	bh=JbDOFfCx/9J1eG2894Q98RVIKK5wZoZYzMTcOlINDcg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=GEgbk5Jn0tdAU0klToBrRxHdEXeO9WeVk+Sl8KG7dythXD+2oxmNgpNIterPIyzRNrGIxYjQcOuQ7iZTGcpA6VmW8fse+vxBDD2YAz/Su4/poSn0IFAMxMYn/teE/bGGdHLDnTr1Q/C1ZfSNPcxq7PIZsOV6eAeH1qHbHdgnIPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hkXiFl2k; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ii5xGbZK; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hkXiFl2k";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ii5xGbZK"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9ejRQ1480545;
	Tue, 15 Sep 2026 04:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=G8bfsZEiry1Yq7cwt7N0Gs7S8uGMDmazhrxnv7ORb
	Mk=; b=hkXiFl2k3VPOx5pVdwUaAGlbUvf4uvCUB8NluzCX7p7IMR1VjtHfjErrE
	aSoi3jvWztP1jD+KYuCar6QCYIj7YFItXf46tMdlH1BS2iKQYyc9q5MxmXJ3X2Ay
	ACkbzj9to6iiHaqkrb/TO5b97iqo2ihSCPJWe0VtO47qLuGtfsxA3l7PnnWCOG/0
	RIHep/aNYjGdkVzSKOvA/w8X5fjC9FlMi1iGC00Jp9KnkZRbaofl8DE74sDreMnq
	nJjSG7KZ0apwCW/GN3eTpSrD4jYZXxJxLCTp8TL5pkkUMouK3BjwU4vuIL+5iKvS
	Df+CdLAQWLIWwiqip9KFW/u2rA74Q==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2hyp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:08 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZsMxtVRmnUBJR2lnvNa42TihxdagLhG3Uw5enMR57zzdkqlxVRtJqV4DsaNGHVIhGpZIRU9jWlryTUi9NlZ0wikV01e/TbkPxKBPbpiJ7jSK2RZCS7AAhdIA7hclWYN9lSRkv5mf2Y2yPRifOGMU1Wm7ujSMXiXSs4rWf2cyrxa3XVVITnanpS5QYtoisth9qdS44wu3S2yeoJDRDUfde1ORY512S74oeHwin4yMAsILufIKRjzqNUdVdmu9OBxMODSj6SKCZyu+p4DQEH69K4nQj3W4Y2wFNXbuoJ3YPLdgoF6K1oKNcxJi/Pmuz8voZE901WAyjDQF7UGhUTXQdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8bfsZEiry1Yq7cwt7N0Gs7S8uGMDmazhrxnv7ORbMk=;
 b=GdRlAGHPReOw2XlWt8Gcr0vMcMPK5u1gvkatoyDepr4kML9u5f4R2bryJY5lhRbmAwh0Jy4pmaOcQN9cFKNScC6FqLKNIy0ZFjhM+D+I9FszBgu/nbIolyQmWVVfdAtp0b31mFW4O0cMkdsMTkhhaHEEYPNJ+QYHL2XgUwD5vlfxDuauw5sXFZKxsqkJmfnQE9/aEjX/B4zIv3t3nulZg4YFI5q4V0+Y9e8UjKZxYwhINGOYUqZy9YJDQ9k4/fSmR2RRMdcTUMr3H+x/kbD/cDqC8M3Zss+0t11UxC8MKTQQcxCw5lZ+IYuMnSvheOBsgv2GvL68rqaEFdCoRsOiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8bfsZEiry1Yq7cwt7N0Gs7S8uGMDmazhrxnv7ORbMk=;
 b=Ii5xGbZKReaOORlav26M9WUmtBrcpkgUl7lJ1fOjMWRVxeKW42zQ6i195LioQIIVmFbRyn4AjL7ys1YuIzAv9ZQylzqH/6H4Ag5qTGslqhjUfa4TaEvC7wZYA5YtSfFoMAxKNmm5NiVAgG6EYf0M2cEliQ/++GsOpqSDki/GXgI=
Received: from SJ2P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::16)
 by DM3PPF424CCE606.namprd10.prod.outlook.com (2603:10b6:f:fc00::c23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:06 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:5db:cafe::2b) by SJ2P221CA0012.outlook.office365.com
 (2603:10b6:a03:5db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:03 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:22 -0500
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:22 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:22 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7q3000901;
	Tue, 15 Sep 2026 04:55:19 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:08 +0530
Subject: [PATCH 02/30] crypto: sa2ul - remove totally unused structure
 fields
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-2-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=2917;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=JbDOFfCx/9J1eG2894Q98RVIKK5wZoZYzMTcOlINDcg=;
 b=0f9Wn9q8DEvFGNXiiDw1yXBci2UWXE5k1h1EWtHRrOfV+g6SjZWhFuvnVB4HnsGCsAVCGy5Wf
 js+tqkCVFSADlR/sLIptrgY6VZrhB7kBfvGi4jS8H5oH+R9RYhMxIsG
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|DM3PPF424CCE606:EE_
X-MS-Office365-Filtering-Correlation-Id: 01b5cd53-23df-452c-9660-08df130f8e33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|23010399003|36860700016|10067099003|6133799003|3023799007|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	k/zbF6o1yh2mJKZFb3SyZW6eTApKBWdfMG4jIetbrYEHxRD4X6WL/kkzc0MGfBPRM6BSgLzYXqMp4ihrEwG/yp5SBqAb+7sIVtk308tXSxqE7ztV0ThRAZc43ksgHMQme72XgqlpNCIy4ShM1MKrh2Vgifpiyu4zcKIWJwNXMc3l7OkzICnjF5eN5l2xCIqspf2GyY6qmdwateCv0XLMacBIer4dbTfA6veb/xofIKQAZTuSWutK8C7HqzCVtRdXVuols4ChLhEoqyMTfwspQpnPWcBwHGHtktfOwQlzU9C6scDNCAaJftBK9gY1Xn2aaeyQUsrQw0dmi+7FaG4xKJZ+OmgRsLn1zAgVbnTIxMyT4ICNVXZXeqvyhkYQQgAp9GuD+B8IYwrjZ3/qkhBXh9FiXgh3PEc9qS55LLpjNoKPzvYQVVSj3T1+CuXGoAgSrMmJAJ8DoTimcXtb9mN8DgDjcO/ckJmjwBDPpr/ZLLC9useIhaYKDx4PeNcJB4VZGcnQ07aPDBjER1uT8fzrEHbpsXr4ksIO6YK9mZ06raOB7owzJclHemlJ2a/RmiO5emUnpb6s7QfUtdzpXFN/1Oc2W501V1YqjSvdPq5XFF05Qvl7vF/Bp4ArCIc985/L7PIZQ4VyGiM2IQLebH15e68IaOjf/8vIXCi04rQMPtLQduXIhNFKQsnLULIa8qzY87QxBdbMa/4BpFM65cOC3Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(23010399003)(36860700016)(10067099003)(6133799003)(3023799007)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6caq8Nlqwr3Ycm3XZFqDNrJzg2/TIiJsgkt31QybimQXIRLGjFBJbj6bNC54Fa/XMENptN7l1z8QXdnpdTN59JH2N5fdCfkWckbNKe6DlmzfPiBxLh3h2x8eoEi1bjVczX2hV6dlc+66krOog/6wXxVivvCYg7F/wImRvTT1Tt1ME8jXvFgVxZw9nlZqNeIqMIHDfyPXo+ZdVl0oaGUTYHC0jguDE/jO+lqomQGW5FIFA2kKQMBK92QL+dQbu2ZI2uiO6k3ZRNPhumCHbqGKHDs6agyemVmc7ThjsCH3QSDP+tGszZOgx39LtH+eWGyBqqbyhGM8dSJswZD4MGPLXU2xIFLLVcNzd6fNDHSzVhtvLuimqhOg7qT8vhL1KLiZSLAp/8ZOJbQc+LcKLmucrNLTlih8SfrC8cO4fwxJn0QXkMFH7LG5jEacmSiDpLJY
X-Exchange-RoutingPolicyChecked:
	MN/Kuv96/EUDqM2gdxUWJh3wa8OFfU6F/lWAfzbMkzeAMKgXBv8ClBaKkY8H5KD1q8haCh6O7Dft1RgXfRBQVH/2I2maU7xQzCOY3J2W7ycmjrV4jzO06Wrca9AsIv9lZi5VqLIT3qm9+cghO/tGV0PxHVcIyKUNRSvaZ9gPWHalIKSwSavNyS48yuU3Bm/7wd4eysoWe7qwf9gmyi6uG+h7v4l+xREldqHU3IsuvEKHKhDHwQhr+ijj5kSnibN1rZTXF8yy12781rzExZOsQ2IUeKy0REhXRgjZOFJRDsumoKe9DFFzY1wVTT40R+3cGDEIp5huBV+vnqnk6K3KrQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:03.9826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01b5cd53-23df-452c-9660-08df130f8e33
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF424CCE606
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX2fkrE+I1fe3J
 b7ADdFLomBAaYOeKG/a8u/lLcKn7jLGpMviIIInKvHP227wQQuRyBR4GK1ZNZ6ogbt8dqe7jQT7
 t5KAGzbT52auN/IRCrtyamb9y5VmK4PmJFXyKJiGb9qOvP9AOUUT8dftEo7c+eap28b9K4YuMne
 Ezg7kZzxWJksXBrcL1UcfezTpzQ0lD/OaQnTr0ujR2JONxpnhJLj18Z9HrcLxswKCTPquC6y7pk
 rvoGecpuGltvsOWZfY1qd4qCMCcjmmRNdvMSMUA3Wv/CKgxQF3ABp7t1HUZQl9gk5ZWQt60plK2
 g/hJHWWV1NJ89UfaDDcoIeUv3qtseCKLrp4n0mwYfi7JZLqJ5o30tBKtSCLLNr4kG4Dj7Isi5U6
 DN+CRt+4irQyTsQNPvh+izCxAseib4ZzXSDbrThMboJVqG1KDLUZXNMSxLWzv6Ik1NS3zqqzmyJ
 tcCMcZjKXhzSUlhUFJw==
X-Proofpoint-ORIG-GUID: 4zjTpnslM6IToHxH4oBBaeRAyiGsCBE_
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91638 cx=c_pps
 a=7whtcbPCeBOLW6TxF+pv5A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=eUW96QGmFViiXR4GRiQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4zjTpnslM6IToHxH4oBBaeRAyiGsCBE_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX40n65z8/M2On
 IU00uyaPWg9JlShXCMbh42GQ/i3VSPtX6NLOfW0UQz6HJ3p2GkAJKiQJyir4/Yd8yL601wc8kFr
 wqhZReYJJNwTNl0T2ZXbD/0VLYHEj8Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The following have never been used in code. Remove them.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.h | 44 --------------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 12c17a68d350..847d6586c036 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -230,35 +230,19 @@ struct sa_cmdl_param_info {
  * @flags: flags in command label
  * @submode: Encryption submodes
  * @enc_size: Size of first pass encryption size
- * @enc_size2: Size of second pass encryption size
  * @enc_offset: Encryption payload offset in the packet
  * @enc_iv: Encryption initialization vector for pass2
- * @enc_iv2: Encryption initialization vector for pass2
- * @aad: Associated data
- * @payload: Payload info
  * @auth_size: Authentication size for pass 1
- * @auth_size2: Authentication size for pass 2
  * @auth_offset: Authentication payload offset
- * @auth_iv: Authentication initialization vector
- * @aux_key_info: Authentication aux key information
- * @aux_key: Aux key for authentication
  */
 struct sa_cmdl_upd_info {
 	u16	flags;
 	u16	submode;
 	struct sa_cmdl_param_info	enc_size;
-	struct sa_cmdl_param_info	enc_size2;
 	struct sa_cmdl_param_info	enc_offset;
 	struct sa_cmdl_param_info	enc_iv;
-	struct sa_cmdl_param_info	enc_iv2;
-	struct sa_cmdl_param_info	aad;
-	struct sa_cmdl_param_info	payload;
 	struct sa_cmdl_param_info	auth_size;
-	struct sa_cmdl_param_info	auth_size2;
 	struct sa_cmdl_param_info	auth_offset;
-	struct sa_cmdl_param_info	auth_iv;
-	struct sa_cmdl_param_info	aux_key_info;
-	u32				aux_key[SA_MAX_AUX_DATA_WORDS];
 };
 
 /*
@@ -307,7 +291,6 @@ struct sa_tfm_ctx {
 	struct sa_crypto_data *dev_data;
 	struct sa_ctx_info enc;
 	struct sa_ctx_info dec;
-	struct sa_ctx_info auth;
 	int keylen;
 	int iv_idx;
 	u32 key[AES_KEYSIZE_256 / sizeof(u32)];
@@ -333,13 +316,6 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
-enum sa_submode {
-	SA_MODE_GEN = 0,
-	SA_MODE_CCM,
-	SA_MODE_GCM,
-	SA_MODE_GMAC
-};
-
 /* Encryption algorithms */
 enum sa_ealg_id {
 	SA_EALG_ID_NONE = 0,        /* No encryption */
@@ -374,26 +350,6 @@ enum sa_aalg_id {
 	SA_AALG_ID_AES_XCBC       /* AES Extended Cipher Block Chaining */
 };
 
-/*
- * Mode control engine algorithms used to index the
- * mode control instruction tables
- */
-enum sa_eng_algo_id {
-	SA_ENG_ALGO_ECB = 0,
-	SA_ENG_ALGO_CBC,
-	SA_ENG_ALGO_CFB,
-	SA_ENG_ALGO_OFB,
-	SA_ENG_ALGO_CTR,
-	SA_ENG_ALGO_F8,
-	SA_ENG_ALGO_F8F9,
-	SA_ENG_ALGO_GCM,
-	SA_ENG_ALGO_GMAC,
-	SA_ENG_ALGO_CCM,
-	SA_ENG_ALGO_CMAC,
-	SA_ENG_ALGO_CBCMAC,
-	SA_NUM_ENG_ALGOS
-};
-
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

