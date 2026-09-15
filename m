Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D532E47A86D;
	Tue, 15 Sep 2026 09:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466237; cv=fail; b=TRp+I8DzHOAJtNg/v7ORKZGvSic1REZ9EpPNOoOG4tdURgfdTdIgWD5X+LnIqeN3vB64PAWBL8A2OapKXFipmKNNw4BwoTI/8P3/xiRjN7Rm753RuAGLNiBCDrNa1OqtFYoUiwo6R2DZV8dAkEwUcv+8pMHsDY03b5iuuHhvvkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466237; c=relaxed/simple;
	bh=sL4XRV9D1NA0Br4IlhtT/3KNoJwSVL9wHsuj5r2AEoM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=nKgBhjLhhPpTMTX/xnRSPy/TPC5eP2HqH2yJf05nBjr6fFv1jxrF54oKHIm9zQOoWntG9p4FNVXSaXSjNU6icuTn739LdOnYW+zRt+q9P+xcfHLD16FAuJUO9RtsfnaBOELzi2BZ+zjT+bvVwCeQy6PgP/P47SgJs6kgTR30pX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=VuGc7KBo; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=QAt4C4nU; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="VuGc7KBo";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="QAt4C4nU"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9esNX3889302;
	Tue, 15 Sep 2026 04:57:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=TFbCitKYv9i3kJUkCLaJHMG/vBIF0b2me+WXqh6Eu
	NE=; b=VuGc7KBoYO/pqra6I3osKVwxl4KGy3bh4eJvqgMU0cQuiX1adyY4eAEAS
	jtYRhE0Ny0q57+llrWLU12XC3fxHxigN4hv4wc8a61uR4FovgOzLWQPMUAPbkT5p
	uu0jzUsD5MXrFtHBX7pxx+HbZHgpKlaYINMoYsCzEAMjPMg3qXN3zXOsQtIxheIW
	d9+8FH006MNvNznPUqWERLkcdVWKBMEX7QrobePRQnqLu2uCJDPeUIq17ZN4axdN
	+MIIpYbFmuEdqKwDgqrHTJp7Byorhk+sqiaGd0A9OUrafVKqcSJ5vsvJXw+j+vX+
	ZEPyAUbkZOjrAXOyPLV7Q0slszsVQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011023.outbound.protection.outlook.com [52.101.52.23])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gppxsm9ka-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:57:10 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZRIZE7X/pXWjiV4R8yGiju8vmV/q/2+2Z9IhGunzInFDxOVYxaPkSKB7fopxtbr1GtwwVAr0bbVGs76pOcx3ZGcspVcBYkO3KJeIhzM6vzbvUhsy4hlMW+MvpwbYeeK7u1uX7UHhUaxJvFbyLX5WZQbaO1DwGG6c+HdfcxoGdGPWKqQiSZ+BcpI5SG6Br/vFeO8ryVHPvAcowST5fLBh0SpGB9kK/M2zOAkom3QmPmDGof9DEY13Q7CzHVPVWpulPkHSO2d9ZBpH4tS6keir7NqTkkYdEQfARN7jjHWC/qWnHGd72HsidjO7cajIsLQvF08yReCmJzKn56C3x/MXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFbCitKYv9i3kJUkCLaJHMG/vBIF0b2me+WXqh6EuNE=;
 b=egbDpmm3HYg4YT6vAClsWL7eHyVVmc5rQhacdOrYPNqVmH+kBXkhNrn4Q5Umy0b9ue7FUl39MjPrgAcNcJ7wQc391v/e1/isNIeVZa/5L6eudo4zo609K6D1r4Lp1ZFOhTQ0hQeMKxWSksCgIKTe8nbD86CuHf9WoJ28Bj/tn5zpg/of6UOsjc7Y+XROzx+kwAKQDLqdRZWCsrT3z67W2WUQSJ4WG+pasp1vxtXOZJs1SMEdZOzfLgQqi7/BAAfhvhcF3QwMepmL9xd4uHQBtoxM4K2+Y8U1P6NH5yYCmG3fEgHiptl5hHMFIiEDe30WfWlJfN05rmT0UXAjXuUY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFbCitKYv9i3kJUkCLaJHMG/vBIF0b2me+WXqh6EuNE=;
 b=QAt4C4nUGPP1ty+1AB62hlcCFgU6PdyK7WV5HuiUUoc4LQJiBs3ilFXdcfjOw5yE1lZm4VuTC8DO+s2aAbNgRMSjMbBlDwYhXQc7b6duOz/YW0zbgZmb894/G0PKXk1pzt+AOFUL+DGJAsy4rFwdYCgS9NzkQG3Pb9er+Df1JMM=
Received: from MW4PR04CA0033.namprd04.prod.outlook.com (2603:10b6:303:6a::8)
 by BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:57:07 +0000
Received: from MWH0EPF000C6188.namprd02.prod.outlook.com
 (2603:10b6:303:6a:cafe::1d) by MW4PR04CA0033.outlook.office365.com
 (2603:10b6:303:6a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:57:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6188.mail.protection.outlook.com (10.167.249.120) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:57:05 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:21 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:21 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:21 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8A3000901;
	Tue, 15 Sep 2026 04:56:18 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:26 +0530
Subject: [PATCH 20/30] crypto: sa2ul - fix command label stack corruption
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-20-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=2525;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=sL4XRV9D1NA0Br4IlhtT/3KNoJwSVL9wHsuj5r2AEoM=;
 b=/knuG+xlKmy18u9vGOqfTfS04tRUs6niwEeXh4x/YLOstSTREw6P3Wbmjm2kh8NM17u4sAEjn
 g3fX39MrTsLDOOjlMqSEnpjO0kVq3Ik5+2oM2pBwMgNjcjSuANv6+Ad
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6188:EE_|BY5PR10MB4369:EE_
X-MS-Office365-Filtering-Correlation-Id: f3a1e240-d060-46a7-df0c-08df130fb2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|23010399003|1800799024|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	nrbJ4lYN3oM1sjd43ooBfc0Wa7ARJaPRiktcKRMvbmxJN+TeGf/2eKzY8wnK13KV3eNSrP0ADM8tq7QAI0aNWZigVkbOwOCb9xPHYKoUkhUnLFClcx+5H3Bw0QqNparqHduYlok3p6SDzj8DBFhnSMfzd76RwwzO0z1igIveFlTavxix6zLe4lKZVHMphqZC+8VOZ/0KTkCf+huV/asV6CKGj20RomAMrcWnXgvrUjohqqi5yXp1/arHDDo8n7q8TLSaHyR9NlDBF5eYiOdYbeBUxhgGX7bHmnHJmotWouIwZDFqhFZlw3E2zyycCsH6+bXqje+jxF2wp22fOx8RzdBqsY5eAwEo80NDwVAm7UiC9Yj0ukeAjJK5+7OoHk4n5vs5BvSUogW9dISQvmRxIoWh4r+nKg10zzSFER7iuXs1fLriUXcjOZhEtluykr9Sh4+MKBRUnXh8fSe0NwtezmTBRWuzsSkbo/cvC01v2Fw6z360aTUV0YOVb10ytI/6vkJvfdxPzbNypom0ROt4ztRTMsMTZHJ6RQnHpwG3KshvMt+/UaUgYuohfo0slKpD/APW8MNtrlO3UP31wP1NsJKB5JwBpg2jDRfay3xQCGSizRxpyk1ejCF3v/NNfkw/WDxrMsoG80WUKHMcndJ7FfHTErnr0zyGoj1Qm+sjWBI3Aibnk/lQEl4vSoMPeh4LR9LrEzcSkQFI/UH6n19SzA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7ETLETtXD3aoTdGZ68LVuIBz/uNySiENgNczEriHW5rAGi4ApOhjlRjT1BlAkxHTjQckA5oz5f469Hg4Tgt17HepJJJtcSs2j0qGojZpICD8UejbEVFi8SjL0yV6BJpchS7uPI6EN+YR/mpEDzNmOeZDu7i91u+wRHo4ySABxWCJ5X7qT1ldRZPaThzx31TvOhQqn6X235x10C4sdfjcj1tNPlgeYPc69oLy8dFnWkVGVuPrXvpqbx3XJxSx9T2AZwboZ1isTTo+ZiJx7z/LjFV/Nbsj/KymEBKp1WNku7AQCes4PRLPR2Gj8QYMGkYWETeyCbBcnvvKyP+vUmYc8D0L0f0FBaIl9pz+USfV+7W8z1qbs3nUiQvjKg1j+i/qwn9Kstc/L7aq8E5fnDOG9DjS+0v9SCkO/bUTkfvOOzjYQKxmvL42zgCyevAObvdw
X-Exchange-RoutingPolicyChecked:
	gch8KFMCdRNYMmJNnr+B7lVN4iueFOEHF13fVrQdfIBoJVLwNbp0lOOnLIwMo8C63shcMeeneV3an31EGWSpaZPwvw5gfnTKmd+3CcUsoRzOxzFI1Eoq96znH6KZJkaGMg3lZ8URVdnnxGTNB20lO0MZu02Lz3G44uv3fN2HhM9gDCG1JJwDFBez4NNSQem4IDUyGYyypyqDE74CGUj/I4DeM29GR8HpFdZAn032GAnKqiEWYWbAhI4uCkr7oIHnu8q0toh1ENi7K/vcmkk7L15oPGO3nve+W29XSoMjTR4g7lbe9ACWZC9BILk8fKNkjysiJtuCeWlvfIS7/Lbdng==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:57:05.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3a1e240-d060-46a7-df0c-08df130fb2a6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6188.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-GUID: RnjF6zVvkzC_IgkCSbH3NBVIAMSvYggq
X-Proofpoint-ORIG-GUID: RnjF6zVvkzC_IgkCSbH3NBVIAMSvYggq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX//2ZEGtEAdrU
 NsmcDbXiFyVPS18zOkkmsPJwTc4xgTxzENdWGLepW6HnS/JOQK7SBeeKjBSHnRNJHGyQYz+DcXh
 u+oaULiC/hH3mS9g4UjWGViIQX+zvssyZaKHBMigmjHP6qsbkf3cJV73rTKaWYxgC6dKTtla6Wy
 rChbRGEGgEdpZr6YHSmaYJeDN+IH5Q6LBt/elAc5JXjEpA31HYsunQUG7W22dj9QcHBFaJg7cNn
 u2/xHStgNTZZj+ZFQ77eiMZR9teh7kXhj4QYxqNw1vCKxZ+5+EWc5jZOlLeKTwPBJlc2P7RMVQN
 d9H0Suw9qjf/GivajxfjBCCYbOpHIOVeETJiuRMz/u8HjcBSYaYdDbcROYQuulnnI+7azpQpl+G
 uF6gGOEnHd+Tqd27DKWTcOR6H3MVX7JKeqTcS2iiN9wxaxCWlEGImjJwlnS8Bw1IeWviqBHkTn4
 yzd7DMkp8MRHjcQOgHg==
X-Authority-Analysis: v=2.4 cv=bYP+w+PB c=1 sm=1 tr=0 ts=6aa91676 cx=c_pps
 a=g4Zu/129bcKSj1q/f/8ScQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=v72KZYpWpeSd1KIG7lMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXzZE9S7VFF0HG
 o6yn7Cy8rprlTRIKFOWYHbOkfHcYKzCR1VFjz2SmQJgoU+53zkQZ/XwT3DMKd1/FwW2uPmlor9q
 A5AYT1MN2VHG1PDgIoDI0f6+DcsXQzc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Fix a race between sa_run() reading sa_ctx->cmdl_size and
sa_ctx->cmdl_upd_info and a concurrent setkey() call reallocating or
replacing sa_ctx. sa_run() already copies the command label template
into a per-request stack buffer, but it read the shared context's
size and update-info fields directly while building that copy, so a
concurrent setkey() replacing sa_ctx underneath an in-flight request
could corrupt the per-request command label.

Snapshot sa_ctx->cmdl_size and sa_ctx->cmdl_upd_info into local
variables before using them, isolating the in-flight request from a
concurrent setkey().

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index a60b968c21f3..9e86b9531366 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1050,6 +1050,8 @@ static int sa_run(struct sa_req *req)
 	struct sa_rx_data *rxd;
 	gfp_t gfp_flags;
 	u32 cmdl[SA_MAX_CMDL_WORDS];
+	u16 cmdl_size;
+	struct sa_cmdl_upd_info cmdl_upd_info;
 	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct device *ddev;
 	struct dma_chan *dma_rx;
@@ -1095,9 +1097,12 @@ static int sa_run(struct sa_req *req)
 	ddev = dmaengine_get_dma_device(pdata->dma_tx);
 	rxd->ddev = ddev;
 
-	memcpy(cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
+	/* Snapshot TFM context to local copies for isolation from setkey() */
+	cmdl_size = sa_ctx->cmdl_size;
+	cmdl_upd_info = sa_ctx->cmdl_upd_info;
+	memcpy(cmdl, sa_ctx->cmdl, cmdl_size);
 
-	sa_update_cmdl(req, cmdl, &sa_ctx->cmdl_upd_info);
+	sa_update_cmdl(req, cmdl, &cmdl_upd_info);
 
 
 	/*
@@ -1211,7 +1216,7 @@ static int sa_run(struct sa_req *req)
 	rxd->req = (void *)req->base;
 	rxd->enc = req->enc;
 	rxd->iv_idx = req->ctx->iv_idx;
-	rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
+	rxd->enc_iv_size = cmdl_upd_info.enc_iv.size;
 	rxd->tx_in->callback = req->callback;
 	rxd->tx_in->callback_param = rxd;
 
@@ -1231,7 +1236,7 @@ static int sa_run(struct sa_req *req)
 	 */
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
 
-	req->mdata_size = sa_prepare_tx_desc(mdptr, sa_ctx->cmdl_size,
+	req->mdata_size = sa_prepare_tx_desc(mdptr, cmdl_size,
 					     cmdl, sizeof(sa_ctx->epib),
 					     sa_ctx->epib);
 

-- 
2.43.0

