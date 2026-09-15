Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C224648425A;
	Tue, 15 Sep 2026 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466195; cv=fail; b=YIoTKtvKO2kU6yqrkBBxTtST60S4tUDT0e9lUtg7u25181yrfwP+ZIewLbDQVIhE2nQUKhNxZOb+RfhOqwiTuXwSQ7UGN4xjaKBwDPOOMa/Q1h1Auur6tTeNHfJtkcwwYvilWY1cM/wQbIeg3BcgeGwRPnAGdC1avzMr60ynXFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466195; c=relaxed/simple;
	bh=9kZE5JB3CRPQtGL/5itWrkNLkVpynYj2w5s82Snn4Ms=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=D+XDF89xTi6nIv9KjqCAeIlFg/n01gn9RuGUCEXw1aRX5YKJRNWX8pl3teWgcZpslEzokU1BZtda4JBV4/JYwo/+sayV0uR3A+YTLvEI6wv1kbRLT3cufz7cU+U88mScDob3SpzxDNI2SqGcwaO6SwnTmL65NT46FYcUpHog83g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hKmbTdTK; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=fPnlE9BH; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hKmbTdTK";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="fPnlE9BH"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fL394098131;
	Tue, 15 Sep 2026 04:56:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=+Xv5smcd/JID4OrzNuw+OTuRIpg8xnF82b4frNjBJ
	Fk=; b=hKmbTdTKTifW7KKBNmXX/btWE4sTWfz1k5M28DgJAgUwlLTDsetnh7WGy
	+LXfGQOXUQRabULNLbZaw1LM3lMnHBcmiHqAMoXpM7ZB0OcH3OUVIj+4/hTudFvz
	N2MAaHo7CrVmxLoUafXUuDHTVN4G/XZmTaeNip+AZWVx20hE73L/44/wx8AoKW98
	SJaBTldq94evAiUvw7BrXYVu86m7z7c6ZQKpCSe2BXaLf57ytqeS/F9NgkXVNHKZ
	t68I0iId7fLL2MPXT2oQ9ofCh+ljiPo0OCEC4briGZeC7F/K/JhfDcNWLE2kt7Zp
	6DuSFvju0so+0mV8bh/EpPwDA5efQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011054.outbound.protection.outlook.com [52.101.52.54])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakh9-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:26 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ygMUHJoAcqonMHRZPuwG9eA2NPgNpHePdLPT8/WsP52xfH0r1CruY/siYUEj+2q6zT0IjMEyxpVKxnhZbM0dXIA0nV6B7WbKMDtrrJVxDYwBQMCzAHLVlQQOVv96p+lvdr67GRGdfbHXrdUemR9p8MHcMU3G1MSInvXBgGRjpJSIyi/fQt0q8Af11x2pDDnKdOKZO+Bxbt3/9Ya4tpeHOuTNwzvv3u72ij94VolEbbXdegT6QWQpRcR2fBWc5oCPMIwPoQxbq7/4HxndQgHkB6OCXLVbPWVQUYjOqUv08El4d2n7Jp/cGGHzNRkqCGq5UlxlmDEMieaxSHbo9GacqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Xv5smcd/JID4OrzNuw+OTuRIpg8xnF82b4frNjBJFk=;
 b=rbABmb5y4cWj+6HBJdDCLG5whIs4DqYnuJx/HFYSL5VFFu1nJkcKnVcwQjhlu8jt/DlEtvXlmIs654nq8nsF551XsGEaw1iwb6ShXijXJ4B7/RtKv2tUUPRn2LkWdZ4OY/SvVJuR+ZoDILytBM18wj2Q9i6IDyTkGnLRQRHV0oJLMnPyakU6GmJD0IfyXljV47JW2UvjCqZ/P5AOcAVe2gUjvPRV9/hQp9IefSolf6XK8GRK70Lc1JhC8n/B8qaX4IuIYcoW99J7fmtiSgaQo/B2xIYCUPf8YdCNTLIrS6vrWK+dgL8IpDfiGfurPdyeoho6YqHaf0dcjRa7jOkPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Xv5smcd/JID4OrzNuw+OTuRIpg8xnF82b4frNjBJFk=;
 b=fPnlE9BH85sE3XUTPbc5znZlVqj6e8E7gqpDHLwEMIfJErEeWGQ7uUQHL1x/adq2PkwDtDEBxE/pMzk6ml5xXVYMbmeTC8WRsOqpBWHCmjTRpPWgSQYbpHm0VU6BliEQDPw5tc/6m+BMXVEgMC6D7si7LqsMu5uCXdKWFcv8Z5Y=
Received: from SJ2P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:a03:5db::13)
 by CO6PR10MB5553.namprd10.prod.outlook.com (2603:10b6:303:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.8; Tue, 15 Sep
 2026 09:56:24 +0000
Received: from MWH0EPF000C6186.namprd02.prod.outlook.com
 (2603:10b6:a03:5db:cafe::2) by SJ2P221CA0009.outlook.office365.com
 (2603:10b6:a03:5db::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6186.mail.protection.outlook.com (10.167.249.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:22 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:45 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:45 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:45 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7x3000901;
	Tue, 15 Sep 2026 04:55:42 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:15 +0530
Subject: [PATCH 09/30] crypto: sa2ul - remove unused base register pointer
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-9-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1463;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=9kZE5JB3CRPQtGL/5itWrkNLkVpynYj2w5s82Snn4Ms=;
 b=9aHuKLzmH2GBaw4DqRcjayIN+lkG9jqE70SzWgY/RX/iOuPazY5pliDTpdsdYXwTUWM+FW5GK
 gqTBGJDqmL6DAgIfU8zF6tir9QdmVKWfJzBrBZ/7sVtDDJB+2TkgdNz
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6186:EE_|CO6PR10MB5553:EE_
X-MS-Office365-Filtering-Correlation-Id: 1634bec4-f3bd-4d67-e3ce-08df130f990a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|1800799024|23010399003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/RfkWLb3Mc93KWd2FprZPEdVJ440NbPCkDVpplMkcDckbyl0Uz/nklIUIj+0bcSIEqn/qvEvm7t/05kDi2Xg2SzVo9Kb58flBuAGHqZLKqU2Mjx5QFiExKIGA5MdTqc1XVeZ41pxq4E2FutLeztrSzj3BVNyfI4weiAGiZoK2bwaryX/Gs0uud55V7iYj0yG73gMQdOOXG0It+bCA7SeAGMNdQdO/qA4CjDTVu3bZbPYDuDRY73MbxrD4sH/VVrrb1og9ydyqThQBPMNEhH7MEIPo2K2U/SE50m2oVlunvbEnu2K4baihK9o6c5suiBOTQ9Zuf4/E5qbOirnrJbvOVF9zwb93ZSeSM9docsNgaWJzX0i8J1inP7Rosc1/r44Iy1/mgfaNBY8panZwtlr9asykpKZRwLf3Ie96HkY8EmUor0v04NZp/2dtS9X4qjwxtgOE/4dAGGsQG6qJ6Fcv5llpvgUGp5FE9oxqQJkNv/M+RGaEfeLG/2ZxZr+Q4TXpFRwTf8xwT9pDga41lmXdQIgX+y5gKfXB2f+Ze4sOBrQ3fhLA/vFCnuSCd1gDtDMO4xipzavGOsJ3MnUDLYDcD7iKtPu1EIGwx4PhjmPwZTPOZAj7hiNPc6UjfHUuBsNOH1O0cFGtw8UCkNsAKVg/klSLDz9xEmK0U4T4UNL7bZxQEbj4075fRHyLM54zzWwa9+OdMtPRCEYBToRUNf6wA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(1800799024)(23010399003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MEPhUwZMstnxsYKloyIn5y1Km6HKvFX1fgQiyI4mgf2JvlS4KPSW7dEFdbupPylJxW/0K+Q9TI6mFdQORbCDmU0siNl2QXXMvncMtsD4w1tTMxezlaQiPGba1+izMcXb8duHyQn/3a62wN6PjrlZXt4+wokMAOqSAqe1DTQtnKKPBi6M1BHp/9qTgNE+hUwpCs4KnaADWS3VcFHFP6tANa/s8s2bT0lGjpKX8PnO5Nqd7gW7YuunkUT+fffFNOecxquOxvJGTLt6NBL3WHSM/4emwQksnQUkLAx2YRVMvrWFKvjwjR3ySTnXeqtO2yIxMF3tl692+kDRmFhIO3JHrExJEKOurTo5ixoZUMb2QWh5SbRsgX4wdQf9ADLD8OEM95TFMlzC84YZIUy2Xn9hLOlOGWCSI4MV63LEnq6JAI/74PxpVvwpWMuCAzw57BAq
X-Exchange-RoutingPolicyChecked:
	bIcgVyE37dOSQhndT7NTlb8s9ifu65Uom9QJ9EnGGkGKh2bA9e3jk55xJ3TuGpfXgOj2SDO19vjWTBg5Yte/fpEXa3vv7pl1/ENNH8mGHe4olmiGaGxpNkdejrZobO3Ijl179qJntqWgv098CroLJH+EVMaRb1lg2s73cPMN2NMnN+4Ygy4kiA2U9R3bTtr4+yAP70LgXKxcsf+Au8+AfDHm0mFT/sR4WByGNP74MxOWcrL0WySq5K32/RhrJKhkmlUd00k4B9wq8HInO3MMN5+rq5+1dDLaHp9sPtjj8GYKR2Dl9ti6Or5FPUGaP0MhNlare/A2fEOFDZL/CJwVXQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:22.1703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1634bec4-f3bd-4d67-e3ce-08df130f990a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6186.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5553
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXxYzz85UOunp+
 Z17zJSYxxk/8/f+djvS0jjSrjm1hEQapeEpRKPbXTlviJveesXL3lpBYrxTsNj9HCM16NCfgUCd
 geTAvauCT7+PCd59izzFJs5jG+Rix/8=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa9164a cx=c_pps
 a=i69ZgmgbQZPDBD2C4G6j1A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=BT56tlt6Ecdp_ngW-zEA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: KihycopRBZEwwu4j7T9Ji5zbApGc4tjZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX2pJwO0Y1ZY/r
 K03JHpwj817Ek8CyTZPmgevZKn0MdLGwdnBLmiVtuBncWP1HmV7VPuw11W3PozuZ49MjV2iOgY2
 38Rr+h9CNhJ/XnBk+uNjmeIidGTpWJKHzSArzbUip7Qh3vx7ZpAByymwz676GFbJGyb5yjHnSAc
 Kp6UVuCOcZgWPASD94bttEIPb5x5Bz5x84int1bDXG2mc6SSQb+3dhepiZWsHZn2ZoUejnAqTaY
 zpDww77ng3yPZrpeGhGa74MO2LDC8Kl7PUKXQbOIC444EqkivpF8k21Nomx8qAZuNZJTAwPjSpg
 aiZJT6imZ1O6N0ROSvBexsSnGWwtJe1t40ZVWOWRA7xUW/lWFcZdlrNo1bk/oWSog9gwohnHaPR
 JtDTUkI5eB64nG4YBUiqPi3LPE7H8vjfeG2PvXwJ8elc1yyOPOWcz/QwVVu060yIbsi3pLTQC3Q
 sI/h5t2hSJTpK3oAO6w==
X-Proofpoint-GUID: KihycopRBZEwwu4j7T9Ji5zbApGc4tjZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Remove unused base register pointer from sa_dev_data structure.
The driver uses the psilss_base pointer instead for all register
accesses.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 drivers/crypto/sa2ul.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 72be29820859..13e941f58c4b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2342,7 +2342,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 	sa_k3_dev = dev;
 	dev_data->dev = dev;
 	dev_data->pdev = pdev;
-	dev_data->base = saul_base;
 	platform_set_drvdata(pdev, dev_data);
 	dev_set_drvdata(sa_k3_dev, dev_data);
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index c41c688687f5..48ed1933ecae 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -162,7 +162,6 @@ struct sa_match_data;
 
 /**
  * struct sa_crypto_data - Crypto driver instance data
- * @base: Base address of the register space
  * @soc_data: Pointer to SoC specific data
  * @pdev: Platform device pointer
  * @sc_pool: security context pool
@@ -176,7 +175,6 @@ struct sa_match_data;
  * @dma_tx: Pointer to DMA TX channel
  */
 struct sa_crypto_data {
-	void __iomem *base;
 	const struct sa_match_data *match_data;
 	struct platform_device	*pdev;
 	struct dma_pool		*sc_pool;

-- 
2.43.0

