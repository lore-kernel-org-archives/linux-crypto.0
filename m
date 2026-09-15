Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB6F485949;
	Tue, 15 Sep 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466199; cv=fail; b=DsLVxsAZyPnG5hPxFYQsaXqFuJW0P1mY9UrXHucSxa9SGhdLnmIIsfLgUA8MjZcSeDGxLceyxlaBijXY6HDWHpm68jEOiAGMHhlAZAgJQPY0BI8/01SCChu7kP+aoxh9JPAAlnVepcHhzxQw5JiU1Gb50Rko38atfIGHbCsqI2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466199; c=relaxed/simple;
	bh=7hKzUduRIbIpCnCdraHXnKtxd2wsf7ynx5yjrGbLHfs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ENHvEG22WokS+9cRIbvLihB7sv6WGll5Fjuf3X2q3HY2w1hTEivHiAsRayeqM1TFXrfQVr1jOW2rruL/ET8G/KlzNbZcmcxZyjXqTpvuFY3NaUY+AaypEzMiEJTwnHigiJrzK1tGTTun5aZRadoO6wSUGTcf4VI17AZfUUsFl+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Oj5Szlcx; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZHV4ku/5; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Oj5Szlcx";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZHV4ku/5"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fCEP3811021;
	Tue, 15 Sep 2026 04:56:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=paNOlWd1sNIi3ld9FPKkhqvOmIqIdVEdv2oI6YYts
	gM=; b=Oj5Szlcx01nfIgPi35lokzK7wxf/XsYeTl62Pq7ksH/o/AuNhfweWcn/6
	2dUIxRgIZi9r+h67v6EMLsxZm4XCJSOJrhZM3AiFHMXRUqIwjGj71Wfzu59b2EPh
	P+up+6T5qAqMPZIHdaKU42fVh9DKGJQ2jALFdZHOJuBG7oBYIJleKenn50fyXaVc
	Br5Q/gpjtpMZnzrjUfHn1Fj6pI2JTTmVPH4Xdq+w2oF6TrFl/Gz0j3YS6vGcuvmn
	ge/PkBCzBHlBLKqU9g3KUe1TkFfSPyOzxP1SzMc5/AO0jP2vUb3MXhAHoww5bj4Q
	bDVfkGaS8+/0+3bSrMPGZtqkU8YRA==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012027.outbound.protection.outlook.com [40.107.200.27])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9xa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:31 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6kQ75jZAOptobdemU9OymHpOWenmZQVBSfZP+9zJqDMtBR4Ll6NSk/G6gFR+bxnwMywIfvUZrARJiKsjXgbZYRZCIRSYPtAN/GOSXF7P0nXHXR650wr/8F9TwCT3zJ/Oo+5oj9c0Pz8z4TIb6sg8TpCAPVuD7yme3eyLB00o+T1Ac3fW2Re6ouCObGrCgR9hlrT3mZ5Td0r97hAbZaATV6MDyOEd6w+wyHK4KbXKPvnZ7A8DN4u464MODpWlk79Daja2w/GvdavYC5BURo0lVyl0tXkba1Gkjws/WALs+i4Xq4MSijfzChALQHus5y3hMdXSc5oA0h6jJ69Q/F8OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paNOlWd1sNIi3ld9FPKkhqvOmIqIdVEdv2oI6YYtsgM=;
 b=M4iAcfMRxUonWFzcx2KgMJsQfzu3dUsQxnmlY8yeUR3x3zx1EzfGZHY4tmXFauxTAjoZhOljzu+/sINGXNVQDu7pRZmlPnU7QC5MSnx6glJoYZwDxSk1N9TT28bMcRWEj5O3xSX1L7fVi8oiH4ZC7LEm4OAHF5wQyBQp6ZorSvQfyG6yxe3IrV92Kx3a+aHlAdWTKA/Cg7CXyRoB76HldOgfV23yGT323kJsi4sLuqikB2ysU3FNyjnGpS8UXs6mSHPqUqpF5WBfUX7uQs6CkGDGbHtnhTNQt6bCP2474byqWOtwLw5ioJSo5PRNDK+3Up3JSiMSH1LcyLW2nBw44Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=paNOlWd1sNIi3ld9FPKkhqvOmIqIdVEdv2oI6YYtsgM=;
 b=ZHV4ku/5cY9nH0BJuq92ZzW9NqTYUVIrP/S+6cBgVMmoMI+dOCFGOkDTUtbh7HpVSXdL8+pQQPa3SSzk86qTivQprnBGmwtGooeDKtCQruaL2WZksjP2qOROa9XAdn+A7gzwqyugGDBhdPJdFZ2Hl11GTixecBmuOTJnKjk06nQ=
Received: from BN9PR03CA0290.namprd03.prod.outlook.com (2603:10b6:408:f5::25)
 by SJ1PR10MB5906.namprd10.prod.outlook.com (2603:10b6:a03:48b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:25 +0000
Received: from LV8PEPF00000066.namprd03.prod.outlook.com
 (2603:10b6:408:f5:cafe::72) by BN9PR03CA0290.outlook.office365.com
 (2603:10b6:408:f5::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000066.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:24 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:11 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:11 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB873000901;
	Tue, 15 Sep 2026 04:56:08 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:23 +0530
Subject: [PATCH 17/30] crypto: sa2ul - fix resource leak of AEAD in
 init_alg() error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-17-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=833;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=7hKzUduRIbIpCnCdraHXnKtxd2wsf7ynx5yjrGbLHfs=;
 b=M2fmpnzsZOOLzmPCmBgSN5JDOWym0BIefJsX1lXwZTlyXE3tlA/UjDytU1ahvKRotU8iSEKwH
 48k+PzmPK36ABBohbon+0VQv9PzewJxl5n1evLeCnzvZdpuTpQLr0f8
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000066:EE_|SJ1PR10MB5906:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ca37aa-9703-481e-d402-08df130f9ab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|23010399003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tCmSIv4Cjvs+j/9T0YzA5smsD5wQTz7VkmGkemtjsCInybnnENw//yvTs1NcZJFmyF/m9a0xRrYK8iwc9dB7dkEqL/srL92reiyHpxMSG356hxTvU3tq8NoA8dxbx37+OQGj35F0jfrbAgh+U6Bs/tM9/L5toaBuqRqrlRZScS37XgfaLzhayjSIa97++h0VFe2ATDPE2xGizNrcImmeJ0cAU0Rf2O6cV+9SKvac8JnYA72Czj5w8HCmLFzWPGObmvDSf21TJVieCnPLSZjfzGEDQFcLxA9QchVF1p5njH60tQe884lr8akDAIvd3rY0PK3je2kgjhUAsCmW0bTc20O0bt+f8ZYCafQ1LKHz9ORvMiFCAfnR8Uux12FpCcy/PV2C1wQfo1KxW9IgxHQ+SNwO0OWs1I7DSjKMyKJqT3A2uY5poVaFzjXtnOw5prqVd21Cl+TTTF8xepPmSaM5MZ5/OJl6pxPguboYH7hIjYDchbkmrhv7h2iWcjtdzzD312weEPI/I7YS5nqLSskwDbYf0uvmwYPawKZ900DDJJNicWIOlv77ZzP2i6/H75Ub2KbmwbN+zn9KrWXe5DtXyY+mwCh4PRmTMxuKx+udxKQ/s6puNzNBx6LjILOggA3hN1LrndSAK4NoRELs2Iacx0tgrKxiPlWVdtks0q3nqrXgLAdYAVkD0zp2IXdLRRetwpMWfSI/es2SVcwAE2ZSmg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(23010399003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ljkf1mu/ZsQSNw7xiKjswC7OgufEqu+BCNEA5wyNlnh+arj9XTDHLFwnMeioEGLJK9QNirxiDz1qzJVzodFUNF05rrNtPhyziHMMn2BCXExOhDu+3TSieXQkAy9mXULyM8wozbo0oVffjh0p/hIJoyT4WrfLoK7ZZazlK8CNDjRJkoYceUuu+6zPWXAOaMJmhsiOA2t1U1DFq3Gil4GgXsTIxrK6mjSMs3ZJXx3SdE3DsrOV0l55F1hSDSh0a/b+BTfI5EUTNto5H3hS0TKU0viXOoyeVK3N9qX7fNIy99ma5DEpfafmGWu3AoZwxKLK5CLhRMswykOTN3Y8QbbHbNK6sJIadzzRsey0VzDHODN2Xr9bB2Xjju3krMaAe+vFfar48swf7DRuUczBrrRkzxKh3bJfSIUh9VeW/bR2Zof0q101OIAVQ8LgMu+YAZSh
X-Exchange-RoutingPolicyChecked:
	wVfy+GytWV/X8OUAAfYEFq05kH0tUK8DlgTHET+qQbOKujIYu8UAqtYQsZlz2xxswHhJlkLQ1hSqbGc1hqVgpypoFy1T8Y2bJO/mgmhySlzyl91/rCi3TPQQJkILkT3wqYs4ftg0ZkR9qfACsxL9bRDWp17T+cDZfLbPVSyKwth90t4WN+TI4CmGry8L8aa0GjcwFrnvkG7PtgfqvgEPwnrFwjcWK9jJKaqUOce0nu9Bye7PysmXFJcHF9fHbqwOaWbbnUDkRyYgmU+9S3GHNR4hLDzCzdLCmcHeIdh3CRDPh80iRXpN7geC4akB74gY/eLOcs/efPaPDHMpf+xWTA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:24.9673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ca37aa-9703-481e-d402-08df130f9ab5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000066.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5906
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa9164f cx=c_pps
 a=ScYCyfYCeG8NXYeL6jRcjA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=RRP3fSzFpKSzbr2H2cAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5fvQAiL07mBJsVkzv3RHATfKD3IiGM2H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXwXgwtSyIERwW
 BwyKFW8nTkL7Erz+4Fpdu+LpcR34rvdTfyPh6yYl9KrhXfqYq3bOebdgAz6GSz8UsFptIeS5vKk
 vsWHKX2NViMPk8rD36jihq4YqDsJJJ5SD/Q+2YBcgRTCy0y35qOGH0baATu03fnvMjnenXzMwHo
 2ccUYsXV6TfsWjkb7sAVjJVWhEVQRYglF81Xx+iq+//+yNsD3nNeTiURsqFEHcvEc2hxKyt8htq
 Yr3cESq1Hs/0BKCt2NjFy0osip17UriD8Jz6kha5ZQyOp22AU5YYhGUAEish8s/i/hJ0ixTa5uC
 3PnO3iyblyDzjACOWvdd6xSz1tXUOPYbZiZVMZqmlO0sGKXNratgSbnC4h+CtX2IwBB/MST0xHR
 XM3lBCfZliqcBxGY3lZvbDkX7wvIABqNtcfya/Mu7Giu27HN4YB0zWjCNKXMEGeHuIb4q9RDIC4
 HqK1a4pvq051qoQlcTw==
X-Proofpoint-ORIG-GUID: 5fvQAiL07mBJsVkzv3RHATfKD3IiGM2H
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX9vfS8GZrqxJ5
 EHxk3+a9aZ1pCm0Z/M75ditdylzx3HcwhFdatVTCLTp5V5DyTQham+I1f5LkBcpE6cCPc5/jk+1
 ucI+AD8mFa67V0HAm8vmiO/iF3rFy1Y=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

Add crypto_free_shash() call before returning the error to properly
clean up the resource allocated in the previous call.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9379d1271698..dcddb81dc842 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -1671,6 +1671,7 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *hash,
 	if (IS_ERR(ctx->fallback.aead)) {
 		dev_err(sa_k3_dev, "fallback driver %s couldn't be loaded\n",
 			fallback);
+		crypto_free_shash(ctx->shash);
 		return PTR_ERR(ctx->fallback.aead);
 	}
 

-- 
2.43.0

