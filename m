Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECC93E49D1;
	Thu, 27 Aug 2026 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787830110; cv=fail; b=BTn07ItnAS8KFtZxScohyC4Ev7swP4182cm8ovZLpd6Kenu0KCtzvT6W1v2pzFd984x5siQELhYfqvWlKMr8nMjXOYwHpHHLEkPSb8wgpQEigiAr6T2Nrau9Lj/ziETED3VVE+wEVk5Lm2KrDg0rhQBkE4duZnT423sri/14kg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787830110; c=relaxed/simple;
	bh=MIaQYDFGx25aI5Vibzi/lg93Rtp8cWYi6nNQvbYeFgs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwbgglMagEnj5paDatgO5bLJsrfRLbIVj/D3VfhEu9udTOUq9QIVG2pm+sNb9DwV5kRI+D8KNpoUDR6SbvtvQizbCO6GaU36h/IEjNl16mrrLAwoLOzDyHhXZyQzSHG4xG279vyC0C2Stv0un5rDV9CmFE+8J6uX6wjEFH2+N+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=DoULSmoP; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=XE6TClTI; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="DoULSmoP";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="XE6TClTI"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67R9GvPe1734791;
	Thu, 27 Aug 2026 06:28:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=x95Nrcb2E2qCj6J4TM0JCgCyFXek8wDLdhZED4g8F
	LI=; b=DoULSmoP7q+/07pCRHPLuXoLSVg5sfZJU5hKWy+gHizvmgPGcbuO53WQW
	I5Osn3kxY0eoMK3rPhAsghVH9wE9svfcPhiNUXL3qKHEl2IwWkDt6CVm025xk/lU
	FmtoZE268lEPJvY90Fd+UXLyPjKMVeiYLh1CjMrQrfUFndPFnO13ipqmM7Zexv+x
	Lmhk6EFpJ6Of0sVa4/eFhtwIGcfmXAG1ONHXOMrEwjAb0EQsAhFZOUEoLz9Omhr1
	lQ/tvfBFHtl1jt1rAvlAbQMUhnlJQrhkXPIutxXud1z0JIVH3TsqdtPxA1jYjjUF
	lWHtKniW/bBswb35obCx07KUI8oyA==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gad8sa5bf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 06:28:24 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYPVgzEiCVYhAEVgC3g1ga4kwlKAGSkFRRKNzQ4YsBPLjZpfGUmqzzJndSuM+tNlaTkBh7F3APCyXlHUYnPnoDLzSMbG43tfX7oH++tRZDdwv7AKum4nUSMVdTL02aPdsw4VcgUBfle6dY4iGfm9qjPWjTDbPnjjRaiSt9HNCITabTU4RDsvSp5nXOQpFjnOZ60R2HRMoQk8Py5DWxh6Bs6IW/QTaDJfWDJaRZyiOz58JrZZ7NQ7Huv0hG9FdtfeV0dUM7mxCmkQBQxa9J/18HZ25TNqdewAUy6e7wvglxWOU5tglPlUwnY2iuLGx2SFxCO59vFpT0JlyceZSYC3sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x95Nrcb2E2qCj6J4TM0JCgCyFXek8wDLdhZED4g8FLI=;
 b=xYX9FvxaBB9JfrHJJo0nR21Op2G/XmBdtqVk+l9qdMnRzABjiadbfSJlqYXUpuLHZYZi0tGhQIcuoUvDi9dgOrr/43gzrQRQSPM2rEF1849WGRJ/2ePBoHUHiuSONhF1kZsoDngGKICXFLBVnrMoFdJ1FCEs3xwdk1xugUZvGtRiplWbCBu1tpva8BBE1xsNsMm/FmuB/cNu0obUob9oXmwVo0oavrbvQ+nDCrx9C0pcr8cjj7PyaANhcmo6KwQqghkWM0Z5WAiWIXICtVXte5fvsJqwTbmklSNvb970RRaaZOoUbHv+Z+A2i9lhQOe67s40vhrW0AmOog0d+UlcHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x95Nrcb2E2qCj6J4TM0JCgCyFXek8wDLdhZED4g8FLI=;
 b=XE6TClTIJiQ2ja7chqOZ/Hw55Gb0g/nVSXFsNCZHch6weenZ9kq74kxG5Mqat9Vd3Z+fPedsMNJ1N9uDP+75XmhTAh3cInWxIQbhAJ1ajoznhAkV+ceiF0HiWYDhUm2Tk7qMxAsJdRnmISWEzhmsx5Xz0UlAGMtaoys1bMoHcns=
Received: from PH8P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::25)
 by IA0PR10MB7274.namprd10.prod.outlook.com (2603:10b6:208:40f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 11:28:17 +0000
Received: from MW1PEPF0001615F.namprd21.prod.outlook.com
 (2603:10b6:510:2d7:cafe::ac) by PH8P222CA0012.outlook.office365.com
 (2603:10b6:510:2d7::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 11:28:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MW1PEPF0001615F.mail.protection.outlook.com (10.167.249.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Thu, 27 Aug 2026 11:28:14 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:38 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:37 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 06:27:37 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RBRaT01767937;
	Thu, 27 Aug 2026 06:27:37 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 2/2] crypto: ti - Add support for HMAC in DTHEv2 driver
Date: Thu, 27 Aug 2026 16:56:52 +0530
Message-ID: <20260827112653.530273-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827112653.530273-1-t-pratham@ti.com>
References: <20260827112653.530273-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615F:EE_|IA0PR10MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: a701a0a7-9033-42b1-4dce-08df042e48f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|1800799024|23010399003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	h3xujOjoY6mCWoZJWcywR6ian7Herkzd2ZpXwUFit8KwYaGuMi0RkABkJbM0VDoitksduVKP1fhamOgbqlxhokBbxiY/nKVXniqs05XoGKB848oSDXSSAuHqyh/4bHLCHb5CCe4JioXmFhQU5utuf5ra/5MOEtezTd7+4juZzIqZILQ8gmBCVF+8LtM29ss8z+Geaubu6cyA3dBILMuHPIenE5E/kv8z80HRL/c6zeiWg3tUYst2WT3JxjFTPkZZELXMgpI9CZOf5CQE5HFFVpjpIaIpa60zWcQFYCk0/yqKD/P9qYtWOAQz5PRMgVuQFBOcZFiCTwhwlJCoopAvpWmg4HwPbo4hA/RXEWxZM16aYs38BuYbEg5kpm4qL63p4MzgCO6kXXW+1ui18FWoNQZWYNJeuHAW7u8iPCzMZ0An7IDkYnZ3t6e5wSdPhHO0zHfAvYHx51491ZBC/LMk8jEXsLI30labVlyoVJrm/TWEsZYCPwEBYdReErlrPlbCKPVL8+VmyZci2PGGMZ1lLDR+vq5XGIPhEp1YK9GD66Kku5skXArCpFPUpmtqgD3MLnf01t5TgwYbf6c+M73cMlmH0Gn8urEXwFpqzQM4Rr73jNhXxcph6ZHp9burgvEU/8dkevTQ/MFRwAJUrK8I1drgoSuhRZd7/r5HYf4Vr4duY7FCK99xvJkAQVy0g6rjdpxR04jYTknqblZwlBOsWA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DGKf3xCw+FHeNf/2kS9iAaczy3idRp2kuE1Qtdo6hMGTIiEdx++HwqqTquhej2428Eg24H/NAt2tl9GBHjMWOATzq5/3xqoatxC3qK1+/sKVNlHntC/OMCB1vMh/euNjn1l5UELJnyKWqsPzEld+nrYSbgSit2iIGNKcuXDqkQd8l6M2eyiTMd2GohmHC0oi+ucSottOcLvxMgzw7tPeQxMpg+tzWwHi9AbWt1rSc8NzPb3jOlxAZJ5kJ3vvhOdQJs5CDT36vc/3heN4IzPQnPqAes4/g9PJjGXoTTF7oggGiHtq6uTVQ0pL3Zk8SpOy30BFCogJSi3eSbQjV4cBZEJCJmopj3p7wRAR7PdBaNkyL/3Pk4n+HxC7SrLIFnVrKetxXKOgTsru3polPS7DgSjvXAN93uC54gc0Hkt/dBuQO24Jp+5p4i5OX2h1BxhO
X-Exchange-RoutingPolicyChecked:
	VgWnay7gO+5ZaPs9c29qHXtP8lgON1Jz6Ac7ufARhAjtWkGpWUTxno1nvI60i7H3uMU3yZ6DNinILxIc5j9J/AsKls+K2eXrxPKLP9AGyhdH1TP4hjBx8XIMC/pr1yhZyZz1SRvp8wDPjqJ8nrk2lODNCVjIyX6jEu7jPvIz5gIz+5fRCpY9ze5y/phoIBQQqUmV/qk+Qc+GIO+Ole3H49Kgmnfn7ZRIgR4MvkYhReS0IpFnSJAORTBM8N1LLBNLH2k/KTacNF/hM9//TDsdRqO5ZoO0CvGrNPYVPd4RWwkIEt5wIxjFMvB5GTpTmRsC5CEfKy4k3YYRJBlBptJvfA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 11:28:14.7266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a701a0a7-9033-42b1-4dce-08df042e48f0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615F.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7274
X-Proofpoint-ORIG-GUID: M0mPNy7sydhGDskjEZlLdBae71ai7tyB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfX/y/WKqv1rAu5
 phZuKNrS/vbGntkNLECdPGvbs4OBe9u62uu5Tf+C6ttAWPJWRHU5fZQHrzIdHUzIDJfHpz50WKO
 nkLaGsDXHbQHX31sHg9j6FRkO3IgwCbN4ldX6tQARSYP2EpY0c2r9B7tePyqSQAflbvUf7TEVjW
 mdeuVnU/CDV8XJu7ln0mXWPP9unJNmXUH8xfqPHtNnMulPLZUcEiThf15b8tQDzZa5+3sGuyyHJ
 USJXd9IhNhlkHEoulNR7W/KKlWAg/Dq23EYBFbDnEcQlnR1mceFCKmhFs2uAr2xvkT3lfJ/xUFa
 5UvRJgD4OwSEY4vJ/bonJbJ9JjysR7Jq0PAJ7w5/2aHDpzZsJqQ2lz9ZMaYtiiHWJnRnpHVf1Pd
 0A9kdGW/wHWFDpSfaSzetOyMIA+eHr9W+jQ50oxD/ftK9qDoDIhLQN1qy/Tl5pRlgZnKivrKdzB
 Gp8LlvZkcJTC7qABfdA==
X-Authority-Analysis: v=2.4 cv=TJ11jVla c=1 sm=1 tr=0 ts=6a901f59 cx=c_pps
 a=UA+Ybm6NSixuq697YtHT5A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=o1aAZExnmDak7Ir64ZkA:9
X-Proofpoint-GUID: M0mPNy7sydhGDskjEZlLdBae71ai7tyB
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfX6iSd09tnjUz+
 xxgA+/eVmnHNhdmjVlCj2akkq6jmNqOWS8M/tAV59uFeUCjOlG+vhcIvZjLsCI/b+/P4EE0M6ND
 WdVJq/7cSyWPMLnLGKX53FeI58v3bsg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270095

Add support for HMAC-SHA512/384/256/224 algorithms in the hashing engine
driver of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-common.h |  10 +-
 drivers/crypto/ti/dthev2-hash.c   | 310 +++++++++++++++++++++++++++++-
 3 files changed, 315 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 90af2c7cb1c55..200728b919fca 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -12,6 +12,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_CCM
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_HMAC
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 97ba76340ffad..bfd7c158a30bf 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -33,9 +33,9 @@
 #define DTHE_POLL_TIMEOUT_INTERVAL	HZ
 /*
  * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
- * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
+ * This is currently the keysize of HMAC-SHA512 which is 1024 bits (128 bytes)
  */
-#define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
+#define DTHE_MAX_KEYSIZE	(SHA512_BLOCK_SIZE)
 
 enum dthe_hash_alg_sel {
 	DTHE_HASH_MD5		= 0,
@@ -98,9 +98,9 @@ struct dthe_list {
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev_data: Device data struct pointer
- * @keylen: AES key length
+ * @keylen: Key length for algorithms that use a key
  * @authsize: Authentication size for modes with authentication
- * @key: AES key
+ * @key: Buffer storing the key
  * @aes_mode: AES mode
  * @hash_mode: Hashing Engine mode
  * @phash_size: partial hash size of the hash algorithm selected
@@ -140,6 +140,7 @@ struct dthe_aes_req_ctx {
  * @phash: buffer to store a partial hash from a previous operation
  * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
  *             a single 32-bit value even for SHA384/512
+ * @odigest: buffer to store the outer digest from a previous operation
  * @padding: padding buffer for handling unaligned data
  * @data: buffer to store one block of data to defer operations for non-zero final.
  * @flags: bitfield of flags for internal use.
@@ -151,6 +152,7 @@ struct dthe_aes_req_ctx {
 struct dthe_hash_req_ctx {
 	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u64 digestcnt[2];
+	u32 odigest[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u8 padding[SHA512_BLOCK_SIZE];
 	u8 data[SHA512_BLOCK_SIZE];
 	u8 flags;
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index ca0c04d40c769..a1d3b6b17626d 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -8,6 +8,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha2.h>
@@ -24,6 +25,7 @@
 /* Registers */
 
 #define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_ODIGEST_A	0x0200
 #define DTHE_P_HASH512_IDIGEST_A	0x0240
 #define DTHE_P_HASH512_DIGEST_COUNT	0x0280
 #define DTHE_P_HASH512_MODE		0x0284
@@ -46,6 +48,12 @@
 
 #define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
 #define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+#define DTHE_HASH_MODE_HMAC_KEY_PROCESSING	BIT(5)
+#define DTHE_HASH_MODE_HMAC_OUTER_HASH		BIT(7)
+
+/* Misc */
+#define DTHE_HMAC_SHA512_MAX_KEYSIZE		(SHA512_BLOCK_SIZE)
+#define DTHE_HMAC_SHA256_MAX_KEYSIZE		(SHA256_BLOCK_SIZE)
 
 /* rctx flag bitfields */
 #define DTHE_HASH_FLAG_OP		BIT(0)
@@ -102,6 +110,19 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
 	}
 }
 
+static int dthe_hmac_write_zero_message(struct ahash_request *req)
+{
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ahash_request_set_crypt(fbreq, req->src, req->result,
+				req->nbytes);
+
+	ret = crypto_ahash_digest(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
 {
 	unsigned int ds = crypto_ahash_digestsize(tfm);
@@ -153,6 +174,17 @@ static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
 	return phash_size;
 }
 
+static const char *dthe_hash_get_alg_name(struct dthe_tfm_ctx *ctx)
+{
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA224:	return "sha224";
+	case DTHE_HASH_SHA256:	return "sha256";
+	case DTHE_HASH_SHA384:	return "sha384";
+	case DTHE_HASH_SHA512:	return "sha512";
+	default:		return NULL;
+	}
+}
+
 static int dthe_hash_init_tfm(struct crypto_ahash *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -215,6 +247,7 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 	enum dma_data_direction src_dir = DMA_TO_DEVICE;
 	u32 hash_mode;
 	int ds = crypto_ahash_digestsize(tfm);
+	bool is_hmac = (ctx->keylen > 0);
 	int ret = 0;
 	u32 *dst;
 	u32 dst_len;
@@ -261,8 +294,11 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 
 	hash_mode = ctx->hash_mode;
 
-	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP))
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP)) {
 		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+		if (is_hmac)
+			hash_mode |= DTHE_HASH_MODE_HMAC_OUTER_HASH;
+	}
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL)) {
 		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
@@ -270,9 +306,28 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 				       sha_base_reg +
 				       DTHE_P_HASH512_IDIGEST_A +
 				       (DTHE_REG_SIZE * i));
+		if (is_hmac) {
+			for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
+				writel_relaxed(rctx->odigest[i],
+					       sha_base_reg +
+					       DTHE_P_HASH512_ODIGEST_A +
+					       (DTHE_REG_SIZE * i));
+		}
 
 		writel_relaxed(rctx->digestcnt[0],
 			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else if (is_hmac) {
+		hash_mode |= DTHE_HASH_MODE_HMAC_KEY_PROCESSING;
+
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i], sha_base_reg +
+				       DTHE_P_HASH512_ODIGEST_A +
+				       (DTHE_REG_SIZE * i));
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i + (ctx->keylen / 2) / sizeof(u32)],
+				       sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
 	} else {
 		hash_mode |= DTHE_HASH_MODE_USE_ALG_CONST;
 	}
@@ -320,6 +375,13 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 					    (DTHE_REG_SIZE * i)),
 			      &dst[i]);
 
+	if (is_hmac) {
+		for (int i = 0; i < dst_len; ++i)
+			rctx->odigest[i] = readl_relaxed(sha_base_reg +
+							 DTHE_P_HASH512_ODIGEST_A +
+							 (DTHE_REG_SIZE * i));
+	}
+
 	rctx->digestcnt[0] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
 	dthe_hash_flag_set(rctx, DTHE_HASH_FLAG_PHASH_AVAIL);
 
@@ -435,6 +497,7 @@ static int dthe_hash_init(struct ahash_request *req)
 	rctx->digestcnt[0] = 0;
 	rctx->digestcnt[1] = 0;
 	memzero_explicit(rctx->data, sizeof(rctx->data));
+	memzero_explicit(rctx->odigest, sizeof(rctx->odigest));
 
 	return 0;
 }
@@ -475,6 +538,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return crypto_transfer_hash_request_to_engine(engine, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -528,6 +595,53 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 	}
 }
 
+/*
+ * Compute the HMAC inner or outer pad state (the intermediate hash state after
+ * processing one block of key XOR pad_byte) and write it to @out. Only the
+ * first ctx->phash_size bytes are written, which is always the raw hash state
+ * at the start of the shash export struct.
+ */
+static int dthe_hmac_compute_pad_state(struct dthe_tfm_ctx *ctx, u8 pad_byte,
+				       void *out)
+{
+	const char *alg_name = dthe_hash_get_alg_name(ctx);
+	struct crypto_shash *ktfm;
+	u8 data[SHA512_BLOCK_SIZE];
+	unsigned int ss;
+	u8 *state;
+	int ret;
+
+	ktfm = crypto_alloc_shash(alg_name, 0, 0);
+	if (IS_ERR(ktfm))
+		return PTR_ERR(ktfm);
+
+	ss = crypto_shash_statesize(ktfm);
+	state = kmalloc(ss, GFP_ATOMIC);
+	if (!state) {
+		crypto_free_shash(ktfm);
+		return -ENOMEM;
+	}
+
+	SHASH_DESC_ON_STACK(desc, ktfm);
+
+	desc->tfm = ktfm;
+	for (int i = 0; i < ctx->keylen; i++)
+		data[i] = ((u8 *)ctx->key)[i] ^ pad_byte;
+
+	ret = crypto_shash_init(desc) ?:
+	      crypto_shash_update(desc, data, ctx->keylen) ?:
+	      crypto_shash_export(desc, state);
+
+	if (!ret)
+		memcpy(out, state, ctx->phash_size);
+
+	memzero_explicit(state, ss);
+	kfree(state);
+	crypto_free_shash(ktfm);
+	memzero_explicit(data, sizeof(data));
+	return ret;
+}
+
 static int dthe_hash_export(struct ahash_request *req, void *out)
 {
 	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
@@ -538,9 +652,12 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
 		u8 *u8;
 		u64 *u64;
 	} p = { .u8 = out };
+	int ret = 0;
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL))
 		memcpy(out, rctx->phash, ctx->phash_size);
+	else if (ctx->keylen > 0)
+		ret = dthe_hmac_compute_pad_state(ctx, HMAC_IPAD_VALUE, out);
 	else
 		memcpy(out, dthe_hash_get_init_state(ctx), ctx->phash_size);
 
@@ -549,11 +666,16 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
 	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
 		put_unaligned(rctx->digestcnt[1], p.u64++);
 
+	if (ctx->keylen > 0) {
+		memcpy(p.u8, rctx->odigest, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	memcpy(p.u8, rctx->data, bs);
 	p.u8 += bs;
 	put_unaligned(rctx->flags, p.u8++);
 
-	return 0;
+	return ret;
 }
 
 static int dthe_hash_import(struct ahash_request *req, const void *in)
@@ -573,6 +695,11 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
 	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
 		rctx->digestcnt[1] = get_unaligned(p.u64++);
 
+	if (ctx->keylen > 0) {
+		memcpy(rctx->odigest, p.u8, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	memcpy(rctx->data, p.u8, bs);
 	p.u8 += bs;
 	rctx->flags = get_unaligned(p.u8++);
@@ -580,6 +707,53 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
 	return 0;
 }
 
+static int dthe_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *fb = crypto_ahash_fb(tfm);
+	const char *hash_alg_name = dthe_hash_get_alg_name(ctx);
+	unsigned int max_keysize;
+
+	memzero_explicit(ctx->key, sizeof(ctx->key));
+
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA512:
+	case DTHE_HASH_SHA384:
+		max_keysize = DTHE_HMAC_SHA512_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_SHA256:
+	case DTHE_HASH_SHA224:
+		max_keysize = DTHE_HMAC_SHA256_MAX_KEYSIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (keylen > max_keysize) {
+		struct crypto_shash *ktfm;
+		int err;
+
+		ktfm = crypto_alloc_shash(hash_alg_name, 0, 0);
+		if (IS_ERR(ktfm))
+			return PTR_ERR(ktfm);
+
+		SHASH_DESC_ON_STACK(desc, ktfm);
+
+		desc->tfm = ktfm;
+		err = crypto_shash_digest(desc, key, keylen, (u8 *)ctx->key);
+		crypto_free_shash(ktfm);
+		if (err)
+			return err;
+	} else {
+		memcpy(ctx->key, key, keylen);
+	}
+
+	ctx->keylen = max_keysize;
+
+	return crypto_ahash_setkey(fb, key, keylen);
+}
+
 static struct ahash_engine_alg hash_algs[] = {
 	{
 		.base.init_tfm	= dthe_hash_init_tfm,
@@ -709,6 +883,138 @@ static struct ahash_engine_alg hash_algs[] = {
 		},
 		.op.do_one_request = dthe_hash_run,
 	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha512)",
+				.cra_driver_name = "hmac-sha512-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha384)",
+				.cra_driver_name = "hmac-sha384-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.exit_tfm	= dthe_hash_exit_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha224)",
+				.cra_driver_name = "hmac-sha224-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
 };
 
 int dthe_register_hash_algs(void)
-- 
2.34.1

