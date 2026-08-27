Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E37081E;
	Thu, 27 Aug 2026 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837790; cv=fail; b=mVK75TC3g4CGUhcWuTeWzxkmFKlrFyLpBZANOkV1O1LPwwcbhaciT9bpyBFImUtHWLNIki6PQq/RJdmKub7Fsy30mBFUAXWBBzneK5k5RHNwwMVZIghmCf7wLy/PvKdGVSeRkw/8iPK9wtqUfm6fMlPixzlHx2baVY3YSvr4qTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837790; c=relaxed/simple;
	bh=7cBzX4w+xGA1RkVv25XS6s/PDwytijnEqoLJc6O/LjI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaR9TJD5ioXIQpPjanUu2xSx7oP4jgUmYxuB/SgwNXTtinEgrJVJGubwAmIkBrsQpCUvL09r4lcvYR+q1YzWu5MX2LAgjOYR587t2U+Bsae7sIWxqGZ3R3lOnuh9IDtTyTDzOwcUs8s1aDGbYoia3WT72jsgXuhH76u7CUapvHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=dtQHoCiV; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=RgXOajyy; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="dtQHoCiV";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="RgXOajyy"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCAM0A3085375;
	Thu, 27 Aug 2026 08:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=PpUSD65hw94EWdovq86/ho3WLfTt2ICIksO+29aPJ
	vg=; b=dtQHoCiVJmgcqnJ7Rdr+fdHhjUe4XC94ycbD/tO63jpH7RYZS1KAy6oPe
	J/kXuNI8OTNorjhzcVoDaLqDR0tDKdj43xEcvtlWRnCt5dWspodmb24r8yFCmTZt
	Wsydra3OY0JmSPnKhjVanZCaJ3WXDGLQWssyMw+Af9l1sLmuer/7X3R2iJCSV0Rj
	Js/q7ASlJ2kLiNu3e8GLJ/JZlN3XL/ixi/os5MkID7S38hIWp9hN+dh3Ew991Qww
	a42D0nsXJ2C9BjE/wJMfBkt3E5vlB/Ame9ifYpr9JSOisMuhCt1xD/RKtDkDc4b3
	NZqstyQj3DEglCHqzbx6Im66pFygg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gajhhs63t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:36:19 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D0Xo8J61NaCZYtuPOoBNEIqnZ3Zy/0GyXuVs6VNfHOPKGz9GewqXuQ+/luWzhsKHlPKd9kJaOoOwxSFaU/z+5qFP2IzsUkE1jfqnn9HKaDquCTT5Pq6BBNRSGRfZGsAM7waIuk8CgRzqVvcZfKWqWlrRYxHTwh+YVA5khQ8eeVP3oQ7MFp1XujF+PFQdmWP5LmJLI2F9y20VDl1cUSdGH07DoxpLE8yebrWeae6/5usp3JA40lfiXFU56kpmjfZlgcgBOgYMw2DRJXn7jBLshY/anVO/lfI3BHO2hd/+QkbY2jApdT3TifhOpqWQrZjHcYVpQras4cnOMYITJ891xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpUSD65hw94EWdovq86/ho3WLfTt2ICIksO+29aPJvg=;
 b=FBakStSc6jbUquIkJQNlijyKcjKwiUtp1f7Jm5diOeyEBVpjpSRzI5bJQKIBzVjRsn2ExC/3JGGZUJn1KUkCIC3IRse5fmYEtG89X+2Y5lUdJL+6ORjy9lnXDvU0XqM8dX9hHs+Os5sIU1FdATesimEo0QvF8g+RvLRfvBu57yMUcNAi4/OhN70+uRb1ybZE64Q8hpo48lMeqZmYlVc7mOkUrfPiGZfp6yluvihsbkH1Pn8HrofH3/aJn31UYQRaxbd1yeZBESR2xm+y9gzRVo7G71crCEfRzVpStkxzYumHk6BOLdWV3hhoASrHmRJLbiutgaKf6NeoiRF97NKPbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpUSD65hw94EWdovq86/ho3WLfTt2ICIksO+29aPJvg=;
 b=RgXOajyyjrK5zo+dPMNzMcPFY+hk5p3puqlIHzUV4ezyoJOsZCB+r2xwCDT8xf+TXj+I8QL/DbAp+Dyg/uLoXLKUNseMbroSNGlT+vhYiEadztTVrtkDG0nc5MWkCc3AhizVS4tyr4oER6bv8uOPHa58agS+vSpGmGa5bMFek4g=
Received: from CH0PR03CA0369.namprd03.prod.outlook.com (2603:10b6:610:119::22)
 by SA1PR10MB6566.namprd10.prod.outlook.com (2603:10b6:806:2bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 13:36:11 +0000
Received: from CH3PEPF00000014.namprd21.prod.outlook.com
 (2603:10b6:610:119:cafe::63) by CH0PR03CA0369.outlook.office365.com
 (2603:10b6:610:119::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:36:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH3PEPF00000014.mail.protection.outlook.com (10.167.244.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Thu, 27 Aug 2026 13:36:11 +0000
Received: from DLEE214.ent.ti.com (157.170.170.117) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:35:55 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:35:54 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:35:54 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDZrfT1947941;
	Thu, 27 Aug 2026 08:35:54 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 2/2] crypto: ti - Add support for HMAC in DTHEv2 driver
Date: Thu, 27 Aug 2026 19:05:42 +0530
Message-ID: <20260827133542.619717-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827133542.619717-1-t-pratham@ti.com>
References: <20260827133542.619717-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000014:EE_|SA1PR10MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: f6af7b41-f7eb-49d7-1927-08df04402863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|36860700016|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Jhy1dFqq71tjS8HVRJXQZrar+bBF1tezhjMhFdVnG/fx6yEsyMrBi1fCmDN/aKdIaiZnPfHVp6KO3INRhH6j5Wp+V3YeG7ZP10scJuS+9Me4ZFpI80lW8lgsXNEJYKS2gVu3+YHLLp2ksWctIZBVsAcvS2wNVFNBLj94CRzYFxwDnEQETXQK3kbH3Cm6vGpeCQrAsS1PGNV8pbVAVtHDSuRj1FzV5H66bEQprJBLFrKPOKwpcfqhFSQi8DyJYLNLO7Turn6EV/GNLNk0BVYYk5YoW/LfOP+peN53f3khJ0rosPCjbzj4zux5LZElmkjo3i/Xo1OdWwvOtjvmCST5bfZCIXUY20UDkuRddElUL3E4x73OtOSVqYILCoNiXKARQBxTPJceBmUz0JBXyK4Y1f4uKqr1m9Vnn0xsB+JvgwnK3W7KqXv2yKTQ5ItJDM2kTOgVvJPG4J4I9KIL/zIq8TFkco2RTc5rNASzNQdPvgjzJme88TKrqi73LHqcA/SbeMqRyczcuqSBq+4hp0dm+d84vt9fwC5hAcKUVTX1n6UvDBrOT23svr5DFhjk+1TrDnqcxTPmMsS7iCGcZ4tkS5BtCMfZJmKCKh/jbUl/n4a1jAA69aTx3yAj1pl4ONSGOmINTTMkR2S7kQ3Cbrw+UNK9cnjIpckRaTI/33qxIYwlSchsE+LHrGyX9oL18yYzvRs6BfdOoH8+6WSaRSqEKQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(36860700016)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UMj+jnO58ffJNmxoDQuvcBa1ADcupuRc1o7WdAs/ANRpBD91v+mN0ELq/S22NF7l/efJ3a+H8DrBfLzlPr3wASexwEQEv3nACLsknBu5+agzx8ZyLxnpdPp8TJvpdSQWeMGTY2qpVSzMBYbpMYYSbunSZgmbnyb2IvGgY9mu+/f4RtyLSyLICnyx/PGwR7hr3SCATZUtIfSi8kYIJHfUxn29gPd+9RRHPwADbWRUmn6WuuBdGoGkBqwA+YFLnFtG1nzir+DnMEuSh8DZtoS+9Jy+pyxV60ykWbHf6DXm9ozIy4h5jqAbDTC5XFJ7s1NLYJcs7r9qf4an9RVCX1XI2OjFhkHw0KzMH/2X+fsZmRQVpO5LvRk8VGTM01wG9lS0/KH+Znu4Xx0DZiIN7amvAHtIqCOeFu6CbcU0ZtTIp19pp5xsicrY81l93CNxKpjh
X-Exchange-RoutingPolicyChecked:
	NYzF7oqtjHJCKQWO5Cms199SGsjNPNFKOinym7sPb2PQnGC/Wek2zWx/gdRr9ksP3pVXlKK1/UYF/C6x3nid2GUi5HYKix/yhNPNCf+fEzDm9tIER+DrXVqWOsXOhSa9tfHLeBH3kiMHAs/KTvjt7reUwmadi+Q8o+Hax1mKg7dnsdBHBu8MjUggReJGRy3LZJ03e1QEV0jfnFH7W2eOA9m37+nYbjwGNmagdNL+3dlyX6uucGGHyK+vM05glRXHJpWXplgOux5lcreaT+xv7Pr8JQCTj9IL5Ghwz2CzBquWRrgKkmCFYI/uEMosC28eknYqLjAlUpAucEikRsL7jA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:36:11.0964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6af7b41-f7eb-49d7-1927-08df04402863
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000014.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6566
X-Authority-Analysis: v=2.4 cv=Fu01OWrq c=1 sm=1 tr=0 ts=6a903d53 cx=c_pps
 a=Zi+2/POLpdgQ9anv5Nu4tw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=o1aAZExnmDak7Ir64ZkA:9
X-Proofpoint-ORIG-GUID: fCXJCD_NM068Zl-Mshi4KFnqaGuOT3ub
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExNCBTYWx0ZWRfX8CLcyr1sdcmh
 1WmfzyR/K40iT+XNVMh0jjnmF6S7wc8b4z+8s7SaVUACjOJbNjVbl34FXqCMK8XdE1WRk+S606Z
 zsK8m7O4FHJ6XW8lLt8isYOTD5EXKY+hq+oeX6is3dpBMNIgYhprHhyJVF2rbv1Dqkv52wDMDIr
 yyWZkwYg9OLC4VdByys/T+4Sd4R7DiZ60YTNJTSIddp2KL7Mxxr5omd5oEhKPoDjo7Sjl4O4tkY
 5bG57Y5BW1zCCrvIOLTgF5qVNxZZvRb6ZRFro19idSSwj4V/BXZyk5gSxyPgPJzc8bkA4G+ipyA
 chKg9V4GjOFxv/I8a07rEci+cUQBUXN9ZSLeYlJ0ftH7mLmBJAkeSnleFtRNal9rS/BJolBJt2f
 onBJa3YlUEJOhKYINvS2EMVBjB7119cD1ve5owAm39+dy5S6AFyR1iZza7+ukou67NzeTLYwG9t
 i0zGnHcZONS48QkvHNA==
X-Proofpoint-GUID: fCXJCD_NM068Zl-Mshi4KFnqaGuOT3ub
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExNCBTYWx0ZWRfX2bMdrIJJGSRq
 tknAg6RV9vvGz5BRP5DDN6OkCc5zYEWUs/8u8OQMK4IO2YLlr6fNceZpHejrwyEAVVu3MyxoeU7
 gLu+2Z01CIxqSO2ligYoTrT2gSvdt0o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270114

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
index 276c2e7d2c70a..7276fce642e6b 100644
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
index cb911a459c724..0131e56d4c4b4 100644
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
 
@@ -439,6 +501,7 @@ static int dthe_hash_init(struct ahash_request *req)
 	rctx->digestcnt[0] = 0;
 	rctx->digestcnt[1] = 0;
 	memzero_explicit(rctx->data, sizeof(rctx->data));
+	memzero_explicit(rctx->odigest, sizeof(rctx->odigest));
 
 	return 0;
 }
@@ -479,6 +542,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return crypto_transfer_hash_request_to_engine(engine, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -532,6 +599,53 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
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
@@ -542,9 +656,12 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
 
@@ -553,11 +670,16 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
@@ -577,6 +699,11 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -584,6 +711,53 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -713,6 +887,138 @@ static struct ahash_engine_alg hash_algs[] = {
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

