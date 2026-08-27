Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B9432E6F;
	Thu, 27 Aug 2026 10:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828339; cv=fail; b=YaOsoj0/9iGB2ihPv/Et/bR0t4qbww3BBVLPwCo3uw83ioo/M7s0cfrvwaSplVF4wYB1o747PVJHIp8GGZF+oEhMQyOCh84szPCrv6W7mV2+rY86Y1QtlzZCPI36wvRkdZ+RoLp0NbrbtRRSTEXD5hz1sxipzGxq1iWUolbWAgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828339; c=relaxed/simple;
	bh=BJd1UKQVUQyAFyHjMko4RSESHox0ep8uJUrTPSDo1Gg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1t86MfsceLDvxTcrDGl6wod+YRRZf4cogweakMrz+d5BmQr3bAGfzvLiYH9zRa5mM2sdvdGxRTDqJVKWY4Byv0k6yl4OLok2XtzennLRi3hUVQqsyCxcZTtgrBKHTEOE8m0DBTyy6jqoVe1fehOLFMdbq8Qg4MUzn0TCUgEJ+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=oSgt8Jlg; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=OrBm4g5t; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="oSgt8Jlg";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="OrBm4g5t"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RAEVPt2504023;
	Thu, 27 Aug 2026 05:58:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0rkRx0/+BXB2oTh6N+o4VcHMlCgA1T1oW+9PORgkZ
	fM=; b=oSgt8JlgM/S4SHqW3DRkCM5J8vayalJH7oAu60/+MxZxNNApy0zndQD/T
	d7y2tmHCblfxpaiigqbU2vOfVR11vz2On5wqMB7gMAUL5Pq9JSPRvwFwRVqq0Uto
	rs8+znSZd0sFZYulODCgQ/QAvS1RSX0OjUt3dqWSql/kRKQlzhRdiPJEeN/Pf+bY
	CfLDSaTARcEOOlCMAiPHxxis7SsSzJ5LoasoeLY7Ua0kRLzws8P22R+IMhXJcOeJ
	wIcpyfLUVL8jwIMk0/weTNjlEKorlWcM1+3vwWx/LiDPba9IcvcGzzPIEbTZC3of
	iN4d7+gFE83DOWjcg6KKJ1JgRKDmg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012022.outbound.protection.outlook.com [40.107.200.22])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gakag04th-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 05:58:54 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tcbaDG3Ynpz4eMKHHswh6XeiRc3YZTY/SGZ0DAuZv6sHEK1jlxawAAWVrdCuOKKZvvAtDKzmQawqG2EYMqQ8XYoFuLo1172PSGn+mmOSx0B92Ms+LpH6V7NcnFbp3dxERS0wr9tXbrj/xpRbnnaZaO4m6KSGcKFrS5zvVxvuekqRgXloGpcz1bZObw6obarZdr5qMoIefV2hgWeB/LJ4nsqt0zllMZf0J8Z0ZeCeMzVEaIYfR7K4wWDtmvGQZRwoLq6DiDRgiBt+1UASmnxumVfzimxjjH7vpGFYV0Cy4dbGxnGjVqs0SprTas20p9v7rkL3OjUEMxlb7IUeHuvMCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rkRx0/+BXB2oTh6N+o4VcHMlCgA1T1oW+9PORgkZfM=;
 b=EGJ5Umu7FIpSTB4VsVPQAL1H2LXmlSAzjUyq7Fg9S615oR09p+wil+LhLV2dFPFR7J/zCNWLi5rAh2iL4HG3xBnsb8bsywjZgKZw+iz/VB487C+PJQkUEYYJGiY6hoDiLmcl0lAodSp34kyBlbK5hBxoM7dJXlmijwHpXwtOmwc4zVPXS8XyJNc4akJdtpgpKDIrC2lhqGN/AFyT9O0fKET+uXtMi5ndqq8Sv8ENUMz6U4QC8EMtHjTPRLN7CPk5gcDwRXWK9Uv6gQzoQa4a/wIBie1VrJP0NDHZIONvGYqdEBd7cMV3zHyPefiGbCkcJ8XbNisPY7TNY+uYTPVnKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rkRx0/+BXB2oTh6N+o4VcHMlCgA1T1oW+9PORgkZfM=;
 b=OrBm4g5tdRbrxXj8ZBn7c12maeTr0Z8gzaMDHXaGs/Md2dBytLybuxUJ08tcAlM9+E7R2tq5XMZkZDZROXxGsRzeiwOAPTu1CB+5b1KT4qyhBoCVaWYNQLfkPbiZf+2wYXQRzjmMVbnz98GyU0TDQcuDOQinJbOhIVo/0bB2c9A=
Received: from IA1P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:464::9)
 by BLAPR10MB5025.namprd10.prod.outlook.com (2603:10b6:208:30d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.8; Thu, 27 Aug
 2026 10:58:50 +0000
Received: from BN1PEPF0001806F.namprd04.prod.outlook.com
 (2603:10b6:208:464:cafe::7e) by IA1P220CA0018.outlook.office365.com
 (2603:10b6:208:464::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 10:58:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF0001806F.mail.protection.outlook.com (10.167.245.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 10:58:49 +0000
Received: from DLEE206.ent.ti.com (157.170.170.90) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:38 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE206.ent.ti.com
 (157.170.170.90) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:37 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 05:58:37 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RAwawO694741;
	Thu, 27 Aug 2026 05:58:37 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Thu, 27 Aug 2026 16:27:11 +0530
Message-ID: <20260827105711.527182-6-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827105711.527182-1-t-pratham@ti.com>
References: <20260827105711.527182-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001806F:EE_|BLAPR10MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a41358a-84bc-4b62-263c-08df042a2cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|1800799024|36860700016|30052699003|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	qXgIrNyPkL7LEA3HwkRNUqzBRLTO4/HHT0Keze+wg05+jmfzeaeCX7331OIF6AgUBd6q6YyQ34dCekgguNwN5xHTMdJpxcRI2trj7qO7JL6nu1qc/BJolIK/lwDWm6SRs7PgbkJ4w4baGtnbFDxJZj91UARh0d95Z1g9W5KOQyPS15wUfm+LWD5VbxYOTswH7P+p8SKQE8RyPEwcCYTOIewFpItEOwkv5c1KVoCPcBnk4tXDNupoz5uXMam4s7/2v7X1B/zMCigos6YweEWoGEN015EYCsa5ULTJdZPTPBaAgoZ2dlCbnGtXAUf+rPJ74rJ4/MIBSEL/Ml37TMRDOt0EyOUokPkxf7f/RVzgmn+Hl8341aGgyG4ozyQLMoALX8sxD+F5YXW5FGzhKYIKGqd+NSyD72MxViM4aIdvJqb5cTbVGS3NC47bMy9DQOUrqpOhp9/iOmrj5fPBkWe7RuV2JS1DN+gZOYwDF2/Mx/y3fV43brPXuArimqfCQsVkx+8KgwWCAdoP8+C+O8uUUK9rS7Zu1atzd3D+8yBYlwcpNJVF8ZJsBUiYg4jpSUnqHfOnzJUB1f8rSlbyo3V4hvvXIYAkGgg55WAQ7tcjKMFsW4BGW9xdnWJH6pTA4UzwBuywd/4bR3j1lYBADjUMVsPo/B8Upt804MdBuf1hZxWli662LzniT88MyCky/BNppEecQ8oZxpJ+umRlk4dQuw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(1800799024)(36860700016)(30052699003)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JNd/lVh9X7vZRBXzBeiHMGn4wAP1IkKN6e/DD4p5RYETdmNiEBEUzadMtMnRJw/gjVZMJmNYUdoR7W8pI91LsDIRJOHKmP2APtXpbiW+Csq6hcZHPWlFqRBp/0HNg2mFKodB8VD6m3JPtZoT4akgt49OYEyr5IylfsH/HIXicgLjSe+ILPTuDJTmdNfhpN73u32SB1ky4LL9edjEWUfvrW8HrCXEa+DQsKQD7ni/F5z3BmZM2ZC68sOoE6VMbag5hpBNE4jFj0dzd+37z+dGmRNQwXvi5Ztc7JR8YrQjxEA0Y7E31gWx82+RUke/Q4QeiVhGShMtYy1gpNEDnDx1Kb4ZdzeHMEclJ1hc+P7juE/9YuCuzN4q9q61M0FqRCov78eEOy6mTUdjqyy9l37//70Ay2zsWDGnivp54UBOpSbdpKsyNH/Fc+aGm0PzXk+O
X-Exchange-RoutingPolicyChecked:
	xHhub4amA2+iWOARrPUZZDw71VXh9O0eDz9KS9Rdi6XRPm8ULIBACFRAmZQCS4zbYI1IqiHczVKAgOz42NUMjzfOFE4eP4XB3Lq/8BXtFRkYK1UJGC6cuPKJ86aJenuWNeXxZwROoykBZaEggCWggOVQptwJEWFcrm4Cuz72rla/7mnJVDn+uU6+cBQPB6O+goZVKNm0foE/Hh1JV35MBo4sWQ/jVgrmwaKD/jLxGxYmDq5h0hBI4QiZOlGyK3gm1vtyFeI/MM8DfV2jtAIlGC3xk12uIsePN75MPm9NlD1fsbbEpLW38XaVxpTKL2ARYBEBwoG6zEwyQpH1ACS/4A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:58:49.8744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a41358a-84bc-4b62-263c-08df042a2cfe
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001806F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5025
X-Proofpoint-ORIG-GUID: qq2LtQN3IjlbH8KXsZ0xZL0541BZ8uH3
X-Proofpoint-GUID: qq2LtQN3IjlbH8KXsZ0xZL0541BZ8uH3
X-Authority-Analysis: v=2.4 cv=VrMTxe2n c=1 sm=1 tr=0 ts=6a90186e cx=c_pps
 a=cqrExuG+o96ZXwTaJI9uFg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=2APMjrMfoq02II8ecpEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX6CSOxgUl+MFc
 RKioGcmLbezyFs/vKi1QS0/TyamW1xcYD7wt1Edv7b10PJLeg9rmAYwrrY4Upzwnedj7guZh0Xs
 SML+usCOpBcUk/moqPP0uRnXUOmWfHhFJkPObDbjbkshF5O5lXeJDa7+kzZr8W0AaT75AbpwDWq
 kFFyNo2NsO6bfz+uLW7FXSDWs+dmuWnoO/ENpASG7XuiZV7N1UC8YRZ33FCaZp5+TiInZdsjg9z
 e5wMvt5KuPxIkQXssXBWjwL6noCzf+J/PMtcGwICZvWJ6K/RsQ9f9m5oqzT889L1f47SmjLjs2R
 FlvTeQte8KSNB1zYpI6ubMyQ+nZwmY5EHnuBvSWEmC1ERJBlNv15ww72rCGgRDPdQeyF1my1FVE
 iQ4a4asBVUgPnOx/9ouAwktlPAdppVOTwsCUgXnzdXRBpVJY9nuLtBVInf58d+8JYBI48Xn/hmL
 H4gBltVueiYg6Htl9xQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX/IO91CiOOzaO
 qNJD8fLCgKMv2hcWD73dZUurldd91JygZ8jV21gqPNt/mMlrOu1ArdZEWsmamk2avQSAbtIGVkG
 bF97qy4Hb9vmiR+95ixNE7TWASTbaL4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270090

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Add a refcnt to struct dthe_data, incrementing it atomically in
*_init_tfm() and decrementing atomically in *_exit_tfm().

dthe_remove() now polls this count, with a bounded timeout, so tfms
allocated before removal have a chance to be freed first. If the timeout
expires, it warns and proceeds anyway rather than blocking removal
indefinitely.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    |  4 ++++
 drivers/crypto/ti/dthev2-common.c | 22 +++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.h |  5 +++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 8899b53f032b1..3769fd7da8d0f 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -122,6 +122,7 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
+		dthe_put_dev(ctx);
 		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
 		return PTR_ERR(ctx->skcipher_fb);
@@ -135,6 +136,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -576,6 +578,7 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
+		dthe_put_dev(ctx);
 		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
 		return PTR_ERR(ctx->aead_fb);
@@ -589,6 +592,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx);
 }
 
 /**
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 5ca1576664133..3844faf5fec1f 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -27,6 +27,10 @@
 
 #define DRIVER_NAME	"dthev2"
 
+/* Interval and timeout for polling dthe_data::refcnt on removal */
+#define DTHE_REFCNT_POLL_INTERVAL_US	20000
+#define DTHE_REFCNT_POLL_TIMEOUT_US	1000000
+
 static struct dthe_list dthe_dev_list = {
 	.dev_list = LIST_HEAD_INIT(dthe_dev_list.dev_list),
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
@@ -41,13 +45,21 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		atomic_inc(&dev_data->refcnt);
+	}
 	spin_unlock(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+void dthe_put_dev(struct dthe_tfm_ctx *ctx)
+{
+	atomic_dec(&ctx->dev_data->refcnt);
+	ctx->dev_data = NULL;
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 int buflen)
@@ -200,9 +212,17 @@ static int dthe_probe(struct platform_device *pdev)
 static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
+	int refcnt, ret;
 
 	dthe_unregister_algs();
 
+	ret = readx_poll_timeout(atomic_read, &dev_data->refcnt, refcnt, !refcnt,
+				 DTHE_REFCNT_POLL_INTERVAL_US, DTHE_REFCNT_POLL_TIMEOUT_US);
+	if (ret)
+		dev_warn(dev_data->dev,
+			 "removing with %d transform context(s) still active\n",
+			 refcnt);
+
 	spin_lock(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
 	spin_unlock(&dthe_dev_list.lock);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..8eb27812b8cdf 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +54,7 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @refcnt: Count of transform contexts currently holding a reference to this instance
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +66,8 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	atomic_t refcnt;
 };
 
 /**
@@ -113,6 +117,7 @@ struct dthe_aes_req_ctx {
 /* Struct definitions end */
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+void dthe_put_dev(struct dthe_tfm_ctx *ctx);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

