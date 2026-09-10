Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28CC3D6CB7;
	Thu, 10 Sep 2026 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037492; cv=fail; b=EbCpTkCg/oG65fEoS9yb03TWTSkUZ5tKRXUOepZvn9qk/X/nHVbqOxY49sOn/1BrZNfJqULaGG3qwjkCEYr05aLdC2heyaKk3cBrMtZ+9HQOLMU1tTxMLw2GzxNnQwNei9Oiz63xL3/wyFDrKhBgmhKJPqd624WnovxPljopPvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037492; c=relaxed/simple;
	bh=q9MAuYSuN1kffDCZyNaLAwVYaqgyIuMuwkDX/U95FAo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mkywz/nF5IJ6kQGYQi1X4shn0HLHpD9p/0VOpIFu7MuXt37eBqs4vuQnburkLOp4AK28hYSuTAM7LpoHN07SNFGNSvTNDZqNfo4nCGuYJMbHjUXgEJsLQUZj64f3WsxphLa8a1DY7Qc6FuolLGcREf0YA7kU/gtV2OM2TB235EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Awjd0LWa; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=jrl9Cc3K; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Awjd0LWa";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="jrl9Cc3K"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8p6OT2670764;
	Thu, 10 Sep 2026 05:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=RHxUPnshjPsza7iZ+qVDbeSwA1fOpVsX+CNr5+3lN
	aE=; b=Awjd0LWaopDr41K82f5KqYB+KGmUIxVpoBo6DLMTB2bIqknFHsGw4dsak
	FyXmFiWvD17ynQsxQUJuRTBM2U7kcpSGGlKKkZKZFc2tLSA/zJTjesSNA5qw/5+a
	SMZnuZIFH56YEUk6TMJbkNaKDGwwtiS8B22ym3SGRZjaaIPmJ+vcIumHJ3cVr6Lp
	rigtn85iIFRPefGNfr0S8ek6e8hhiBCWWjLlvuzqmWRrk2eWeSS4F2OibtR8ka8E
	9o/ihkJ0Mc70OoXNmsz/PEjmymrRvuFXHpJU95I7Pv5B0Ol5amoNcKUAiTA3loNi
	Q2JmWEhVH4hh/WpWbK31atYkkJ1Ng==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkcxfvy4f-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:51:23 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rgDjxHJc37XcZkuPe1cweIPDX2AMr3Rxs6mvmNJYrb4RCII35l41U0X2AE2rCWpbqQtAnOfQMKF6gv8D+WIiIUQlqLCdS5cC6ZSmtvJy/TU2tD/N6i+QDJLojB8PhGzNp89Zf/30pLma3JXhx28cZnzRIB5ZRjycJO+QYhnIGLswVp94pNRviXpYhSCAKacXASElezSH5nLiR+MYwXe1rOf2qGV1PlRgvgGruA1znkc34XpsK1kXSrJLcb6DMZ29gaAs7dKdx097/PVF0U9QXq/NcS4f5bH+iAnCBN7eIVp3+77mK7Y4ihCpxywxCEHNgR0s099wn7N5P1FHEKydFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RHxUPnshjPsza7iZ+qVDbeSwA1fOpVsX+CNr5+3lNaE=;
 b=PciQWt6PUdksK5X1h5asQsLfl8cRyBdaPX6sZ3idb9yoiKDMUq56tV0J6pdI5Ak6bquUuUCPHHWaE6oLiX1ct2J4Cn7KlfzMSghz9B6Hk6Zzilx3vbbXuQSzvLWMutWnN6Q2QvJIwRY2BdJ5Zq2G2zWGI7EYtARV7RUC1KJ8hLtNdWc78WeG04GuJ7/TR3/TBLxCCHNnDJJUHYKKaMLK9rlrCw+OHXv/FIZVTYoxCFxzk5/DqXX9oQ3oFqL4I0E4TnaUE7wy4OdiVgFpyOSic/jm8YOQLqY/4CHVzHQ5sH3X8Or8QKA/xQ99uM3INJQt6IZSU7BbFWwjWrGw/IrEow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RHxUPnshjPsza7iZ+qVDbeSwA1fOpVsX+CNr5+3lNaE=;
 b=jrl9Cc3KR77HTz6jRpPAIolboeKB0ZctczuBpjf0k9+F4wboPFEZ5JkhV9q8YI/YJcLhgc60DjqUfm8GmtG/Y8VlFVGDn9VfD3g16lldNqgErQgYI6nhNotFux9ENsIXLrbMh48TIwRgCqk4uChRzmSMsvZXarZ/Hg3Xx8WsIdI=
Received: from CH2PR18CA0026.namprd18.prod.outlook.com (2603:10b6:610:4f::36)
 by BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 10:51:18 +0000
Received: from BN5PEPF0004698E.namprd02.prod.outlook.com
 (2603:10b6:610:4f:cafe::2b) by CH2PR18CA0026.outlook.office365.com
 (2603:10b6:610:4f::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:51:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN5PEPF0004698E.mail.protection.outlook.com (10.167.245.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:51:15 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:50:27 -0500
Received: from DFLE208.ent.ti.com (10.64.6.66) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:50:27 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:50:27 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAoPkr3161578;
	Thu, 10 Sep 2026 05:50:26 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 2/2] crypto: ti - Add support for HMAC in DTHEv2 driver
Date: Thu, 10 Sep 2026 16:20:14 +0530
Message-ID: <20260910105014.1552521-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910105014.1552521-1-t-pratham@ti.com>
References: <20260910105014.1552521-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN5PEPF0004698E:EE_|BY5PR10MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: 40730764-4b2b-4be7-c4a8-08df0f297025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	l/6etI/oSboo0icd1uHVdmYDTEvgHJPm7IQ7l1aGiDAL6XEY3GsR8tpPIYeQkuwXAMsRKQM3BIPkoaBtk4UcskrrrtTzHCFpGbVx5JQ6pGgHl3emN875UPVbpL4lGBU1b4xNFAnospqBr89RCxyMNhzWh3vpLR52GOo63H3UqjppMHeBZa4ojmfqb/7GFCXTAE/FEjEY3RaDpkl2ANQceHkLx1wk1CYTTVpmg7IpHAhlULq5+5uDcsMkfvF19pXK/5i5q8QfCJJMgs1NFvypt0V3EN1lTTgZYnO7P8ooCb6Xj56aNeCSCEP026sYsssOp9/yxvuweyFVKREF9/LOLkmPiRN6Vx7quW3TgOL8Fh3pTJtDgVzWJtkBKfnE1xlj5w2DrBGkXxJ5zTVlqiMQZMiycCYsoxWCXrnvCt4EZeyvnq2FtnuetTtaN8jRkbV7IP5Vgxu3KnXoEb+0nYS/qFwluHh8YKuDfNJOR80CUt1Q+AiOBa91XpxS+4PAQBjy1rUo6Q7n7J6wAm53rB2liC7wHSs0iCDDICQy3yzAeE8s7rEwy67i4C/UNAQXUNoGOVxRF8pukcqA/jcWM0L8bqRowcRRghN6mKAmJmN6dREZZkoeZpVhPBFuFdasAXaskcdgPcqhPnUOyVQD/MzLa0ZjvUJf3nG9ynfQvuAmrgkMicfcVZmFDWrIZP7Q7YXqYRmvGx6SnP6WYpIuSs6ByQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FZhzCae/Uwt22jFBBP9fYw15rJBz7leQtMGVdQ5bFNa/OQ7Cypn3kh2hSIidkhguoKUl+BHYt4nHSt/2LrZdkjJaHMdxWOOa+6+34CLeqfDmuQZ56gL5NylLGaiQo+rIpGHNxLrJAWu4NS7CTtLmbWedAYzPlhqkaMbcQjymVzMPYqqzs6DT4HjQRuRshKAtyOGYyBMjrhWrpPbG+HJg5lLzmdnjFI+zRiY1DH5Pej1SBXXHIJ2q8VW5ioi2FkRglpJ0SEY2hQ8SC8tEr9V7lO9dGWOnu+KqkWAcUjF3f6Pn1e1D3N1N2DgbidOFqdWEvLFz5CMAbv5rCwkTVwjbCLn1EooVaePWqDr7y+h6Eetb1qlc2jGP+E/srHRlrykmLJsHrPsAVfjo9Ybkx/pWv4SGEExuL5nsJ4NNoRLjev/CHl4grshAU0V/6rQA85de
X-Exchange-RoutingPolicyChecked:
	ibBU7diflurThOCWrE4uPjB8w6y9DXc6UnmLQYBiNT2bZuOzI1NJcldt2JWExVK96XJt+ysodffdhW3fr60wLphMy8yS8ceRQmkiJDCbZLQa7v5Uas6OWHMhZ2zqrP3MxpCJ0AqI9LCGG13xqK9H9PRpNkjw2nkUd2gB2fp0bwbUyI6qV0X5Ea9itTJg966OTuS2WWhSS9z4rp+rek8/VIHJrq1tdSUBxJYSWs88WrCJm0amMWV72ePBkCqJuhlqgFYB13QNK56aeEY6YO1UjJdPDChJZKYh0YgZe1mR749CAZ0ncvcnWWVqN/4stl+5mhB1FlAI6487feI5bWQl4Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:51:15.8354
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40730764-4b2b-4be7-c4a8-08df0f297025
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN5PEPF0004698E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4257
X-Proofpoint-ORIG-GUID: 83L9YOGnW1-CL3gKzWhs52ODZh2wIopb
X-Authority-Analysis: v=2.4 cv=SoAFe/O0 c=1 sm=1 tr=0 ts=6aa28bab cx=c_pps
 a=NPM8+NhlmoQiEOpqaaNCjw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=o1aAZExnmDak7Ir64ZkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNiBTYWx0ZWRfXzJt/57B+tUF3
 kvMv3NkH/Pey0vMxrySLGXTH2+j986rK1TOHanFRqn04Vtwb6W6Oe9NvY3b7l3XeJBSuCA25f6g
 HXA3at3zwUmwUCXgqUDf7IA4AucAUTQguRsRcQLeNx6MiHDOeTWfTlY4SNMAO6D7CKmrdHT7U2J
 rrqOQYsGY8KYdYObN9+DRVIKUCHIlR2ifougtzjHYU8TJd6pnaNz4ntSwiItnkvg4NPCJn3QSg2
 jaCmF45O0tq1Z02jEeYh9rr0h00SMZl19Qmxn6fgDbHaMLPq0y/Ykw+hHt9T/kX/l3KeSbuSI3u
 YZbPEuFcROmID4559USz/siqwnhK6BXlDLvFo4I7N5fYspZcgLVRlITlbC3HWFBwDQ/vDftl5wX
 w+gcQeYmQzaAp/oiALMxGj44NxoLs3k5gf7A0chyepz+WvPX0T97sLglHHrWG3CMN0SLa5JCoQO
 b/LbXG+BruGCN0qtywg==
X-Proofpoint-GUID: 83L9YOGnW1-CL3gKzWhs52ODZh2wIopb
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNiBTYWx0ZWRfX/+SBWDWZYECj
 esj3wxc0+CbANhcIRPOk4dyXrnGaypHL7FdioJjcUsPF9L4EA9ka6X1QKRnVOXtG7tnoNTM0kvo
 lVTCSNK+qJNhXm+XHHP1yf6oaNlYcEI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100126

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
index 57a6cfb8ab587..94c5064004db2 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -34,9 +34,9 @@
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
@@ -101,9 +101,9 @@ struct dthe_list {
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev: Device this transform is bound to.
- * @keylen: AES key length
+ * @keylen: Key length for algorithms that use a key
  * @authsize: Authentication size for modes with authentication
- * @key: AES key
+ * @key: Buffer storing the key
  * @aes_mode: AES mode
  * @hash_mode: Hashing Engine mode
  * @phash_size: partial hash size of the hash algorithm selected
@@ -147,6 +147,7 @@ struct dthe_aes_req_ctx {
  * @phash: buffer to store a partial hash from a previous operation
  * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
  *             a single 32-bit value even for SHA384/512
+ * @odigest: buffer to store the outer digest from a previous operation
  * @padding: padding buffer for handling unaligned data
  * @data: buffer to store one block of data to defer operations for non-zero final.
  * @flags: bitfield of flags for internal use.
@@ -159,6 +160,7 @@ struct dthe_aes_req_ctx {
 struct dthe_hash_req_ctx {
 	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u64 digestcnt[2];
+	u32 odigest[SHA512_DIGEST_SIZE / sizeof(u32)];
 
 	__dma_from_device_group_begin();
 	u8 padding[SHA512_BLOCK_SIZE];
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index 6e41aeb429141..003c5733ed945 100644
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
@@ -213,6 +245,7 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 	enum dma_data_direction src_dir = DMA_TO_DEVICE;
 	u32 hash_mode;
 	int ds = crypto_ahash_digestsize(tfm);
+	bool is_hmac = (ctx->keylen > 0);
 	int ret = 0;
 	u32 *dst;
 	u32 dst_len;
@@ -259,8 +292,11 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 
 	hash_mode = ctx->hash_mode;
 
-	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP))
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP)) {
 		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+		if (is_hmac)
+			hash_mode |= DTHE_HASH_MODE_HMAC_OUTER_HASH;
+	}
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL)) {
 		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
@@ -268,9 +304,28 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
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
@@ -318,6 +373,13 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
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
@@ -494,6 +557,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return dthe_hash_transfer_to_engine(ctx, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -547,6 +614,53 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
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
@@ -557,9 +671,12 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
 
@@ -568,11 +685,16 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
@@ -592,6 +714,11 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -599,6 +726,53 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -728,6 +902,138 @@ static struct ahash_engine_alg hash_algs[] = {
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

