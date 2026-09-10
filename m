Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9433655FC;
	Thu, 10 Sep 2026 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063540; cv=fail; b=mjLasVi0V5Cvf75ZmY2tI+wP5rUuYfkZa4tp47DPcWbhn1bLzFVS6zpdJ80PxY6wPEI0EowzIlE1VNQEjkGPSWY5tKKMRQ3bvOTU7Fiu1TDW8EUfsj05O16oMLk7Ho4bUDNU+BlVzo5Z/bCH+enDWidDeoFbmrmEWHWRr/yLQpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063540; c=relaxed/simple;
	bh=SlpECxFfdm9UrHSWbkGzssUTibMM4E1BA2ThtBIoTeM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XjB1Cyl6o1LjIkqeM7CTetToFa9M1RFfV+UrHKHwFJJ5SYBGM3CkWWCfzQpHY5afpE9YTaQMquwHKIqFx8AOCy9SVSAXOsHQgp52p+FNjSlI7LfyqWPiOLlEQrLkCQ8ErH9C4T0Hr3it9NMCHHwFBBLsYnsoZMEb2kJwLXOu78Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=jAPgtino; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ileo1249; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="jAPgtino";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ileo1249"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF64GW1431161;
	Thu, 10 Sep 2026 13:05:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=+R6TyrpnMMdhj3EEyDDFh3CCvSH2h7kQalobZRoUy
	Ug=; b=jAPgtinoLXAGBidCahWSQw/QL2oLxJ7R8V3woP3HGnZrIRwu2KM01H5fU
	rd3CYS+3sx2j0BRquzaZ7fruRkb9e2yqnjo4tnHg4qcj0Etag7UKW0lLuOPXrZhO
	/421FO0bSI7TDXdjkIAJFZRJ1w5Vel4NO/kGbox0CbXV2nbevWQ27obL9nWUoQr1
	BYeIb71pSS8pAMPXhgoocZId/boM7ZbcXGy100QwuMtZdeei7ve2joZX0h7OXnLy
	m/+GSwzrepljRpbkFSRuxyOmS3QFZ3YdZO67eCgXigQScf8CkGbIRs6zHmdQmngW
	6qQZ5jS8HZ7B4asuCUs1hA0UIXFPg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012041.outbound.protection.outlook.com [52.101.43.41])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgfdfu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 13:05:35 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wrxr+/3w9utLywOGN5T3yEbcd0tPTs45iTnm90AxAnJuZnrAI0lURrcqBbS/e4eUv+WmOh18c9osdZiaxnhFeWT+x6qwZAQz5f1Qz/PO+q1TXIrCjOnGToiqWP1VtnZYE+vt39Wkvk5mKqTTzr/w7X8EXUqFYmbDBC58D6EXJiXAmpTocx2H/5TFTGatyqxUN+j2LViUa/EPAJRWLNJDiEBzuWFPr0opodf1JaxQFVIzaIjbYJGfUAHSYxptpjSVQEROnDLIuNWgHIyiCU4rR2Mu3JE0vyMPyLmqO3TFwgmTHNeXmoXCx27Yf2tTxNIn36idegYbz7nP/u9BLspNYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+R6TyrpnMMdhj3EEyDDFh3CCvSH2h7kQalobZRoUyUg=;
 b=FpA6iagZG5DfereggciuBMkreyLNAf/mgwPmBE5hxD899uVhi80jbnnyWC7PJrUKbm42ojWy1tb+f6yv5056OhCc/FS+Z/JF9KJ6Sr8Wmc2zDhz8lWsuLITSLtvx7elHkWL7nUliykSDb+/M+Aw2sh9VTudA/PIfnlMwvyd3MkIY46kmrx368Ub84x3OecYK6wXbK4uz3KaVj9U1qxgcZjHrKT1sS8PmYWwUeO+H49YwkEknauOgi45FH9zh7CQbkjNKsFjMAOKoGcQdI8ys5m0X5KKVQFkMqq4K0DMM9U80kVxeFgLAipdnYO853zF8n7iU5L3gU5wH4iUHdcN7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+R6TyrpnMMdhj3EEyDDFh3CCvSH2h7kQalobZRoUyUg=;
 b=Ileo1249mZQg/RiD2yMfIsheKYe5Z3kLlCaumi5Aa5SgfObesaX8owR8IZl4ClMYwijeESgy1fqLZ9vL1R+F41U8pXOrircrPWkElfXp1L+tzDz4E3my1rhsnwGAujQLum81O8Mx2CnJ8nfPibKi2k0ISJV5jructFTpMPSf4+M=
Received: from MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21) by
 PH0PR10MB997641.namprd10.prod.outlook.com (2603:10b6:510:386::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 18:05:33 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::5d) by MN2PR01CA0052.outlook.office365.com
 (2603:10b6:208:23f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 18:05:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 18:05:31 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 13:04:33 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 13:04:33 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 13:04:33 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AI4WGs2807814;
	Thu, 10 Sep 2026 13:04:33 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 2/2] crypto: ti - Add support for HMAC in DTHEv2 driver
Date: Thu, 10 Sep 2026 23:34:23 +0530
Message-ID: <20260910180424.2131193-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910180424.2131193-1-t-pratham@ti.com>
References: <20260910180424.2131193-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|PH0PR10MB997641:EE_
X-MS-Office365-Filtering-Correlation-Id: 394d5ef3-d163-4353-9386-08df0f661ad8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|23010399003|376014|36860700016|10067099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	M0kiDeQY4GlEsk/aeaeic2Ywf7edkei/UwndbGWOXGyi6YlKt0v7FOOy1q+41dRYCvqkkTHW8n4MzGXAcIkylWre4rHJ8gJsQOfttGgMxkFlOr8mfjuaZ0kiJ/CT7M/X4xNmDr/Rg2L9dg/uI23M1NYqX0gDjcYWgT5hgSNb2cppKuztrDfT64qTMHCKwEFAuX0mfq3EUa3us4JuwJhvxEVWBMsO8VJrF0iR5OiaEftL7mgDszfN5WqAsOl8QV/Z70Qj+0FtU48CIUGj7C1/l7nST+HZJMz4h7BrF74YlnhZt7aUbH8rJwia4X1reCCKAeFkY5Xm4kZEcyk28mZ3+3Aa+R1UdUXwx3SRyOVbhUorxNi2gRL8ZSzYvxS3zq+ljitYqZBZtXZGFRipmHOMEzmx/WXoYm2X6Z1WvOXtjedme8H182ivbtghUQy11NDnSJUidR6V9DHqU8kcz4CS6sWnU6KhlSBlghL2puI02LIoEjfLUiGS0kw0zslZB7+YU29e8luwr5RXj3yTkrc3A4GiUzWFfKhV4AScV6SwbK5g/zQsMJm4qOO5rqbc6STqR6JjI6R11DgqXdtldLEgH9skE8Y4frtSeGmqbdlhpwpvB97QsUZ5Xk53vljC6GM0ffNiWTbZ7xt+5It9Fvdjgpl8+7NfUXKJbgNv4EtGdGTF0TUtGgcxjst3qi/OyrUdSVTC/FXfcKgUxOCQ7+sPuQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(23010399003)(376014)(36860700016)(10067099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tWjgq8Ydwx16DxQleeLTv0lAYX0siTRwxClpQhV1Vzp+D2VPbmIuIp9AJ+kYrvd6Mv7phDtzhd+kXqDMkCfbM3YsDCgiNatNjr1vSXoEPX72SxEyWy+S7JAibAsYwTwsMNhW0DYlUvJZtr05JTC+eprBF7SwfUlrUa2nh4afBUanZts7D95dsTr2ex6Hk9fMcB39kvKELfAdp84co4RwWAEm4iSa1g6ManW6tBd+H7hxBueOByJdHyO11+bvj9K/ziLe6BUxplUMSjB8vE+OndB6/8DRdrxVkhOwY34OZC7rukCbtPQ29BPNCdeJaKTD3zJOBqbfwCSEo8tTYnEWf7faowPWyPM78RvmB0JlI43kFm0Uaeg7jKgb1uTar8D08g1I2DYnc89L1IVn3vvVs1L3yT/rT/ntvq+aQjco2QYifS32xpVx6V8DvJaJlVkc
X-Exchange-RoutingPolicyChecked:
	Xzhsl+NpCi61T1okNytg1jFfS1QT6ZtaLqWpwO1XFRe1g3zkViS81elcfh2WA1Kwt9ADxyUJDsrDLozs6AQB9QECqtYTsdSj8nLlfZe86x/Y+9EYmu31kBxHTS0k8/eBTbDfvhks6wqbsgDhcpH0r8aE/ZqcqAxcilIaUO2KeyYNwNO8R2C6V5673jPSggA6ph6z+NWkJXmwcJdg7gFI5trF55iqgsZ3EkPe6y3aTnJ2XU1f1TLxm3wnKXskEMA7rrgXdyygAEJQKf+L84xdLLisxDkOX1Nves6qKUxg6rnt4+ruoIgG3hndud+2XXT5N8gfT+XTDcoTPLabM8bCSQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 18:05:31.9899
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 394d5ef3-d163-4353-9386-08df0f661ad8
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB997641
X-Proofpoint-ORIG-GUID: FLX-lK7uAfS-3Imu8Te-v0pLFrh17lOL
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMiBTYWx0ZWRfX3biLS0Cyba5Y
 kIEHjxDB0F/qDq1ADe6PGEEWyKplkXxBOfmw0P1UC/VXxBKrurhFVO6b8Hp7i91QqOojeyQ0nCH
 ZXqYx/ZLOFdBXfYnnzp1yiu8Ot6RaT0=
X-Proofpoint-GUID: FLX-lK7uAfS-3Imu8Te-v0pLFrh17lOL
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa2f16f cx=c_pps
 a=zZ5onIKbzmoLkk/LR1Usmw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=o1aAZExnmDak7Ir64ZkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMiBTYWx0ZWRfX7yMuqMhZnGdI
 HZGaOc0ZqDKDPQ0CwTDaDBwhV2gBLP2DMgj3Mzp1AVU7JfwWa4bKTkF+CnQjnF78YGoRZMwcNSo
 BNpR5dd9Ay1ShTosQxEkC/ZnAHpCa8QgsFfbmYnPp0kP7Cg20SL2bHchtb1XCrVd513xhN0jddy
 vd+n1/kDJ2O+7HQE3AFVNVSH1EekqI4t0duHuvXfp3A8vQA/P/9G5IZl+f/RKg6hYOeCzSjdqz/
 RCuVd8xGUu3hKjg/xAqRAThkRMoV+WFiF4ajZU/7d3Wd7gsPL4mR+ZgVBnNVpPPRl+FFVOyGDgb
 1w/pWCJdsy78uBIZP8UFok7mVOEkaO1KTD9EqQw5IYZbYBSYQMjLMDpTVC6VuhHLdlexG7jg72R
 VsIHFGbsEQ1YBL/MMlK126ZpCMh0wP8NMA3O9fS1LrqrMtjOtPJE8KkcvaihN5u/GlG/HXDCFCH
 x6gZvlKRUMRB0gsw5Ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100222

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
index 075515087fc1e..ad2dcb13de62a 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -8,6 +8,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha2.h>
@@ -25,6 +26,7 @@
 /* Registers */
 
 #define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_ODIGEST_A	0x0200
 #define DTHE_P_HASH512_IDIGEST_A	0x0240
 #define DTHE_P_HASH512_DIGEST_COUNT	0x0280
 #define DTHE_P_HASH512_MODE		0x0284
@@ -47,6 +49,12 @@
 
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
@@ -103,6 +111,19 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
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
@@ -154,6 +175,17 @@ static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
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
@@ -214,6 +246,7 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 	enum dma_data_direction src_dir = DMA_TO_DEVICE;
 	u32 hash_mode;
 	int ds = crypto_ahash_digestsize(tfm);
+	bool is_hmac = (ctx->keylen > 0);
 	int ret = 0;
 	u32 *dst;
 	u32 dst_len;
@@ -260,8 +293,11 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 
 	hash_mode = ctx->hash_mode;
 
-	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP))
+	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP)) {
 		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+		if (is_hmac)
+			hash_mode |= DTHE_HASH_MODE_HMAC_OUTER_HASH;
+	}
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL)) {
 		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
@@ -269,9 +305,28 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
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
@@ -319,6 +374,13 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
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
 
@@ -443,6 +505,7 @@ static int dthe_hash_init(struct ahash_request *req)
 	rctx->digestcnt[0] = 0;
 	rctx->digestcnt[1] = 0;
 	memzero_explicit(rctx->data, sizeof(rctx->data));
+	memzero_explicit(rctx->odigest, sizeof(rctx->odigest));
 
 	return 0;
 }
@@ -498,6 +561,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return dthe_hash_transfer_to_engine(ctx, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -551,6 +618,53 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
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
@@ -561,9 +675,12 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
 
@@ -572,11 +689,16 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
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
@@ -596,6 +718,11 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -603,6 +730,53 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
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
@@ -732,6 +906,138 @@ static struct ahash_engine_alg hash_algs[] = {
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

