Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EC549C4A7;
	Tue, 15 Sep 2026 09:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466216; cv=fail; b=rD57LE4fayWa6DitxVBWfn8dUHd55SJRtExT38AJb73YEt/DAluoCf7QjZy+GVCXyqecI2cWxApn4bHct8Kk7DqIH7mnAVcYpi7tA8ctiv6s07DTTsdDkJoHbfV0VCk2iKFY+nyYq1GFr2n5sC0IJsZMT/sz0K2Q4L9H4EqigLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466216; c=relaxed/simple;
	bh=yqCnj295rHUFvyLN8h/SkHu6C4x53WmqJry9YsUx5XA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=TE2HHa9ZACAJ0T44eF08cDBHR3vs2PVM+0u4W3/O3VVawhu79eEWpb6RhhY7Gm+NZjfyTQYUr7F1gV2u6KZicc/RaqS50Qh+E/mHazME5YdUcqPeoexp4PGgdYwtPUAu5v5yt5tHVcUo+eqJeHBYky9RINDVsJ5FT6RuseWT4h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QFiRcwq1; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=EL/e3TSR; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QFiRcwq1";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="EL/e3TSR"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fKs24098103;
	Tue, 15 Sep 2026 04:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nJjECqSuOeQXjtQq5t5cfv+U6pzrkLIQ9nBhlUIgF
	EA=; b=QFiRcwq1KPvE1yzCajC4SjJo7I4RUXuJhw0h7+BkMOoWOTj8Ff4uZmwAh
	XmJoC52r620U7Zt7pdgBoCNikNWT4hq5z2cz4UYroCh0UCNbHk0omJEtE2nvz+Ax
	Bo0P+7HvMRACOvkK8wJLcnzRUYfJ94Af413AYKrcKTLTC1M9r2W2MhgJ0TswLGBI
	asp5iyd2zhADEQRqrBNeYLA8nKeT0pPkuH/sWzqyvbaQGzzDd7kQINezMFjTJwU7
	c4v0RoLkqh1TD6o0eYFezvlxmbKRzTlv153KJjOONuq7Ad1BhuNqIpsooXgJMQAJ
	yR1uSaV8o6RZ+or5Gsqubp6drv34Q==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakjx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:49 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uEDcjc3Uy6XB14Q212obZagsRswVutDrYGdVYkZnannCeRq3vc45f5usdn2ay/XKPEGuNsFatUmHCX3RKujXELxVBj1xK/XuBhXIXQcso2nkRvQ2t2zDWlq4BY2ETatOXV8k8NC8Td8oVEAfkJA8bKBb04gZj06Ml63ElS/uP1df8iZngBpVrmDBEqlJewo1dQ8c6wKpA4T6JUZsH73MjRbxEgrgiKBTZMFJhQqulP5H7fmjfIY51T/pwW3RWcTy3tF4qxJJJx1lTB16/GPjvETzY0OsE3piBTcAYhFuDSjSj6UUWiW6UjAoisuni0u5yMj6JgqilgRg7Z+B2BbcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJjECqSuOeQXjtQq5t5cfv+U6pzrkLIQ9nBhlUIgFEA=;
 b=Fwtg+/E0JyBT8IHLryEvwUJuO/3vWPP4wWoMuQO5uscpsbKP0SSde+gAqoLQma4KrnXhlfLBuv+Vr8X5UR8786mnOyx87qQXVGqHZuIaeOMnJMsP+ths0FR3PVEdneVygki2oVjyoZm6IH3Gl0t6G/KAQLx4DWPSqBYpg+JFpTYgPxJnlNXOGH2wzfqV7gEZjkvWjOObpfYW6txiMMnac5oFMtdjDI8prTQx1u3HbvFPLOVdKaMO9zeBa+fLHuAoIsr5qSqlP3lJbDtoj74s08SJTUK76hlWuPKoHdX0WzeYdYdLoFnZfa4SwpGDQvD0cxPdYDUfY7ZJdXFnE1Vifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nJjECqSuOeQXjtQq5t5cfv+U6pzrkLIQ9nBhlUIgFEA=;
 b=EL/e3TSRWg1gpPmY/JdtVbmhqjpWSg/pQJI8qiGNk7cdRmhxo61dBuM6L0XHtcdDPdU5z5p2JAgJ1XL0D80sYf6mqzkrMT8QNIR8Ls89X3oQ2dZCDUNgGJZt72hX3wM1JYdZDkC065BWjz8a0/QcVbsZ74CyN1CbZtebfR0vILA=
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by PH8PR10MB6388.namprd10.prod.outlook.com (2603:10b6:510:1c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:45 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::25) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:44 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:27 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:27 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:27 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8C3000901;
	Tue, 15 Sep 2026 04:56:24 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:28 +0530
Subject: [PATCH 22/30] crypto: sa2ul - move export to appropriate location.
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-22-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1368;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=yqCnj295rHUFvyLN8h/SkHu6C4x53WmqJry9YsUx5XA=;
 b=M1w4bAkTaYp0V8z+jO7DMIR085c8f1RpZ3Ddi+mn76xu02QDcUuWnHFMMcYLMJ+cRIhQm/nh5
 fdTwp1q7gCVBtkdkDzanrCBO2/4CkdvVPSeqjYjWjrZsovBrtD6oP4F
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|PH8PR10MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: 581a88fe-b696-43bf-e467-08df130fa69f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	831IYc0mRQjtUzHtNY7UtlUWp7kzIo5Y7S3yyYsGDCAxyw923bizZJqS5BeCAL+wJP9GabbB2+rfCn7BLDimyIoVAhiHsZ6LPGDDap0mdpvUHTmEaJ8EQ4YgDZsawjTIrkve86eELGra5eQO3wKgvocukEs8R2yUSvYcev+OJZkTzSuWxA89J2WFlI+acmNRCUCN8sLasUJEfuh/5iLDbRDzbuFL7MPoWbIWJIvBXUXLqbxsyj6tL0LeyTGsbMgfNXoQorx9hFTCoqCMhp2cvo2aQz3CmK8Vya0CXm82baeXgvWTTkHPLcgr04TV+iFjTHeD2NNQgpSvqeSL3jxz+BtN/v8hGrWcgqZP0BCKGLydM9U2gH4Ftcj0mPk0nRSkofjXqUcHWHp5pGpV/vA4FoIZKa+dmoKTAcsXHL7kCac7zXseMaA0qDQ1eYI3MbGpvSebYeT36XA1UxLw4/5D7vPe5XelAPlLOBQWOntf6b+p+Q1yPn63eoZp3nqZZ1DSXRoSu0XHFES38DE3upeezNsrtspPM6vtxBoUimKjISivc6yKXV5q5mOw4PSQ2fQKwSzIKP5nvpatfDHkcV1Jf3uEALnibyL62XkuLQ7C0a8OSKqJNaYZmvNJRVuFJRteC6veV4RkZcDigTNdWEjQR0xXBA3hLRZZfuwNxiQ9Oh0EhKbjXyp/+BjPgv4V3hiXBrmGuqPWxfNcOfjJrCxxJw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LmXx9HhXgPtGgpyfRYBsb958PwcF407sz4eWf7SUsvFXkjKBvJQt6N1uGjYYsC93da/baJA5ZvqyhaJtLKtBcFfVqsazG4ul0bkGyOQabHXDItrkhCFkqRWJ/LPjiVLw/cF0xihQcziOh9+oA76CjDQ2eNnvwM86IWYwlD6UP5RE4WqleHtz4FNNfDvl2HwfPbtSpNz2cxE+BPLxVPJs2cEwU2sGAZx/VlCJrr9EvUjVN12Z48yKpHGR6nZF6mR/jBGj3oR7UFIfIMunyjctV3Ytja7CQQ5ARZHcAs/ftnJf2r4O4h4Dax3f1CtWIjeeKyXZCLCw2CRc8wJOw+1i3MMXi1AVQ56n6S6HWARyEbmHGu7Mc7E//bO3if4E25BHLrUzMUrdRVeFH00VxgA38wyN27mJenMc3DEASLdGfCLE/Q6eAFveoM4IR9iGAlP3
X-Exchange-RoutingPolicyChecked:
	k6B6WpwmG49QmevLfn6tBWI9cXgE9olsChEC3I2kZtuU0r03ObeHUMNuJ8reP37al7CF4oN352nixwSPT44svMztqjPul3Z7bSGjM0hoL3ECWim17fWV5x9sCFzgqQdPW7V0n7uZfeCSYZWFZbgibithGuNZhXPc0H6hm4SAz1TQ70BifPY/AZjDO6UtSk3WRn+IqliXq2rrEeusnaxk5A83Vc9fXfcG7RVyillidSQ45rS1cB+UpciCZR/N2OcDp9PJa33oVyYhsZoWj24Xh4s1XzVyyXLPRr2g/16YT69cOgKke/TxdwaFg3+a9q+npXJ2s9o3xW7o91ZsXxPaBg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:44.9573
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 581a88fe-b696-43bf-e467-08df130fa69f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6388
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXyuugHSQ3c0h0
 CFLjSte90GP7EM1HE8NJnZDBDXNCMyPKuyWOlHynhJ7tnbxFuYy1K0+z65Eku8fh9L+YzseQokH
 7s7t9BSK+r8RAy5AIKemMUm7qomJRmQ=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa91661 cx=c_pps
 a=DKBbczBT0NfZzOMt9NccUg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8
 a=tAoYmFjvGA8ZcGrWVaQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IysCiCcs2UoqGCvZ9DnP7wCutp9GVta-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX13tZC/VkfDOG
 t/4bjxJcaYteDxNbUwfj5swtjKwV/f37G9z6mIHSVWL3vmp8lRJ/r5c8cn+QDZNGfqPrWwDReYu
 by6O4/QbQYpyoi/woiLn9AffLLmECF7u0zg+t/nslR4LLF8Y8qQi6xXB8FCaTQ13SQHbvcB6Jbv
 JRQKgwRXkp3es+vBOHkdHLo3Go8ZXQDGPvhHWvnF5QkbFiwKakYOoBDQGgiPWfjfVYaBXfPlATg
 Q0ikOj1UifSiJwRVAc2J3HIInAptNl6IMwnCEwjGGtRWVr+Is40Y/N9VQFKBgbHBhM+1Qwagrh/
 /PaGfNpjQyvJ0i70ec6jzLEJxp5zBRs8FoLts7SlupHEyVziKn1TQbkfQshMq9ciUxgQXQK9Cd7
 quglEWyyMtdKm6kA9He0fTGkx+gOl7hhRfPaiWtEB//+aqnNCNkptxoeLQ5Ts7JaJuJ+hJuSSk/
 SIypgydXRiZ31CHZN3A==
X-Proofpoint-GUID: IysCiCcs2UoqGCvZ9DnP7wCutp9GVta-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

The current code just writes ipad/opad into the sa2ul context but SA2UL
requires the intermediate digest to be programmed into it.

Export the intermediate hash state before big endian processing to
program the correct state in SA2UL.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f89e84c5529b..36c8403b5713 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -400,6 +400,14 @@ static int sa_export_shash(void *state, struct shash_desc *hash,
 	u32 *result;
 	int ret = 0;
 
+	/* Export the intermediate digest to program into SA2UL */
+	ret = crypto_shash_export(hash, state);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: crypto_shash_export failed\n",
+			__func__);
+		return ret;
+	}
+
 	switch (digest_size) {
 	case SHA1_DIGEST_SIZE:
 		sha1 = state;
@@ -415,13 +423,6 @@ static int sa_export_shash(void *state, struct shash_desc *hash,
 		return -EINVAL;
 	}
 
-	ret = crypto_shash_export(hash, state);
-	if (ret) {
-		dev_err(sa_k3_dev, "%s: crypto_shash_export failed\n",
-			__func__);
-		return ret;
-	}
-
 	cpu_to_be32_array(out, result, digest_size / 4);
 
 	return ret;

-- 
2.43.0

