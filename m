Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D98845D927;
	Thu, 10 Sep 2026 10:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037005; cv=fail; b=EqkvwhwKJ/kw2YEKeoxU/vRPzNAJfKxQYRHnDtM/8M+pkM7QY3KWLTH823SF6YphZYnPYFQlfOmmw340m9houY4H2w1P4Pl0sAk7A2py5ohjbwOvpS5+QlWFBhaielohZhsN5m0WMc494dfY9aH0whhVquN2QUrqiMxPuiRegYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037005; c=relaxed/simple;
	bh=qDm9YMpatm3c2GeOSqBVtYYx+wjpO01nOH9SWgJq3SQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0auOSiWxwJbmLGTG1AWSi5/car+PXZYBcTVNGYCavTGStSWGDL03OYF0GWMyio0Q1RSgwduUO8IiyMZ7l5swKYZlLAlYjfajXpSYKASF7OtH5AxKuk2z8uQ3Ep+G7S/TMnCCSBOwaQcOfghkqEE+4mEqfBEpnSPfs8Znkyx4eQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=JkGXZjoE; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=VRChaBoJ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="JkGXZjoE";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="VRChaBoJ"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oJLu712686;
	Thu, 10 Sep 2026 05:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Juwpi7NMHqBhbVSei/QV3uz+jT/nxHXTax9Iy/G0i
	o4=; b=JkGXZjoExI4AhbVKv0t/hVq7qgB9EmW32c0WSCjN3a9Ml3nCjEqzuB0Xl
	PqdXirUYlIhP+6r7ZdEA0Jp6CaLjcMRTm+67pj/ZqxwvX+4gQ6r9klwc2BV7Lun1
	78U1x9hBDvY3vRJMPMiPYlOhZRFHQTvQoI78poZNhRXM3LuWXWiRg2Zdwb53IGnG
	j2E8TqXcAxb9ZKgvtQhfl5s67zTzWXe3stUBSHJFifzLtFh+KlL6CDCCgq+l7ISg
	naHpFh+1huup6v2dwysZ0K3EBStJ/OkcFBhRwNs6l7timCs6oQcx7SGcJ+NL7+4F
	OXWOtaz4xWhRhWa48y+P9RcOW/Jxg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcny8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3RjMZlgyvsOZRu9EuMuN988BVZI/0lavmNlz35PJRQ9KwHpd2lfzZv1yHDZxvqwAQh/UfQvcmo/TEVibXT/q/X2d2Vvdd3oCCL7WKXeOzkS4owj9kPnpuzolrRD2YXOarubbNyyxkJcLaUjAZa4ERgD4hAtXlL/+6NET3vo/hJxu34qp9OQ0mrbJgt+ddPyDOh/zf7VAMnZS5ToPqBuKcT/5V+zzE6tPXGLuR3bdcwuUbs51t4OA1tNSQ8so2FagEZLW1kJKfmr4JctTTvvYuNeNwj5cinvxQO5WKUaft+WdTXeBITjhLTFbEL1aZvpv4aEoFxJ68PCDSHXYq+gcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Juwpi7NMHqBhbVSei/QV3uz+jT/nxHXTax9Iy/G0io4=;
 b=SLYtv4Ennnf8EIQVE+/It9EgBdngOflqXf77NfCumSZ94I9jLXnACKZfi+qMCr7vea1NVpz/NPSXpiWEuQ7SCPibk3LobQOZK+HeaziCC76uwug/WloXdwmxn427NGcZczlCcp2Umk2l+mnlSfu5jVEwOxZP61kAcg+rq+bD7Nn/1cp8g5t168m/pcXGe7Dn+Ib6IN0aWbcbMxqd3WA788C0X5M0srocgihx7Z9qUstBrJFWdrkjN6N06vqzJt2/rV+dlc6FA3XqlQTYGrlVWGiViUf8sNQ9AeBaJdVIiDfJrJjy6ZTGV279OxVSxjETjf939uQYYO80+9XP8/gGtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Juwpi7NMHqBhbVSei/QV3uz+jT/nxHXTax9Iy/G0io4=;
 b=VRChaBoJcbb+J2l04KUQSWp8RqTPS981ol4D8nCfy0qquIaW4aun/KBiQt8poNekXAO9Z2/mRT/VWmmy1tUMxCoVeEigAe1ExhyTkzuQG5ApiNcclZhBnnlvE8uSzn+g6+byAa00Esp1DY21uI4L+XAz/65ONbcpttSGyXfkgOM=
Received: from DM6PR07CA0086.namprd07.prod.outlook.com (2603:10b6:5:337::19)
 by SJ5PPFCBE2A5DAD.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7cd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:43:14 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:5:337:cafe::1e) by DM6PR07CA0086.outlook.office365.com
 (2603:10b6:5:337::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 10:43:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:12 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:39 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:38 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:38 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgbEW3150195;
	Thu, 10 Sep 2026 05:42:38 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 04/12] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Thu, 10 Sep 2026 16:11:54 +0530
Message-ID: <20260910104202.1537226-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910104202.1537226-1-t-pratham@ti.com>
References: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|SJ5PPFCBE2A5DAD:EE_
X-MS-Office365-Filtering-Correlation-Id: 9651f42d-062d-4d51-750d-08df0f284fec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GlKu0/ykC4/hOr2KrLW6VFg5df13xiaGL9ZtyPT7oMJMH4hfV+ymyPP7Zbul0p/JZPpDE8eH9FZ2ecIF+Ok/xTlA4PdKdV+AnNBUoiTeteICsVFQZh1sbVtN6zuE6hFi52xVIbkIaOllBVZb+T9v98WJHBt291cSBDwXyChwPsLdrQAQ+aSWISx9eQ0AcWJuLpmc5bUfwQcSmNULOznVNOeqCo2Hqq11om00+z9ttpqpLtYV9Z/brra3t1kOMiRm54mj/ROPiYKml0sdfz9VATncfmR/1rGO6uSIONZKDAdL0I5Uh3jtiag/XCjreckmgg2cMpOuwkZ3ie8fWu4H731w5vINGGIIsC2Ew7i5YaN870OzwZquCk7gXW9bcZ0Dp9jc/bHVmYA+pQlK7nHJ9NXF1g24xbMQXoUiDGFtd/PM69ZZ/MEy+CxvbM6YBz2iYBjDxpYVbf9N6gEH8gDHhw9rxTc6MwhyRsCag+4xXOv0/i2pYxvyBqL5ytrnfxZzxPm//fNSu/7tD13LL/BXf/NTVycMioZgyxmBUQV+v56kHTOkGA/aNm0atcoan1UW7vHqY1IWUhvZIoQ6gcYRZs1N2Ku2n6i27vaQvgGf6Gk7hj+dV6etA719k1nNpXNuwBYP6a2VwUUW6e5nfxQfubUta0V+C25EkPXpEUUkRw6DYjzJy/m/NIO+Q/BU9D+97zcSXH6O2hg8vhCy6JM1uw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SkJwbcsQWup0VHClnsCUEenLI8a/Y68wu52/XrD+C8Fzwg7sKc9GIDzgjO28eQdMO1fKLoHfXxAFfCiAYztM4BPkJm/USNGqsn3CHyW/qOMIrcLxDQAz8QkUp4Q9ZeJdAFCA8Sk13oz0Y0axnPn5qXCVl0D7uOgxlG6SQlJHlbzRu5FujEnHgXAXuuGl3IrBrgXuW5F5mSAmSAKehIPiD5fQu3tBXU5n5Dc21o3NJ5ZQ7L5suyQ4M1y4M2jrw57/Oo0v81Muwb1sBKgGMP5d3FuPKVLWs3/GPO7eqEKQ8aBmjQpfxKvpkpWca5z7/96IKos287mrnIQ1IcBKxCHONWPda2HdBDVRqQmqHh8bM7f+mwMp+VTM2/OP+wf9e/3WWAOoGsddwTWLNl4m6PpgMahnr0MAP7KlkXIt94SmNBjQI3GR99hrKdpJS9YW/GFf
X-Exchange-RoutingPolicyChecked:
	t2g69eGkxYFax6de3Mlh1wFec6aF6itPST4ZjHCn8j5JYiHa3DKd2SFResnB2urppTLieCVSNVLvkcPeA1l6XOct7Y/7VO4i+FY6ucTR5DgHulaK7LtwtQNqsuiYmxDHqhK1QIW4v9CTMukfJuRZT/m3pBEfTUZqr3uNbwS7oSAFEmnA6f/rKHUMs2nnenC8J6c4U/mxm2cCHzuci5JeTj5iN0yUc0PccEF+k6Ori62dYy7TPLvpc4/K/NR1hwWfbLZYpVnVSLFiEZDDH54bjdkcqSIVOgLt5ktBWN51NRqdBjfflukxY1suUD7lUqMs+qp61hLbgJdiWcW2GQ3R+Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:12.3108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9651f42d-062d-4d51-750d-08df0f284fec
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCBE2A5DAD
X-Proofpoint-ORIG-GUID: s-U5H07RS9FGdO76TG7UO_qWa-RbGESe
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXwWeYBvGdSr2g
 r1KmqNhBNRs4JDPwW9KrcJzKBjpv7tOewR0xXz64to8+OY4yLDxSFTkXQeYA1w37J0teWK8drsH
 BtZZQ0O4lkCcOIyYW8MWd6B2czXvgOE=
X-Proofpoint-GUID: s-U5H07RS9FGdO76TG7UO_qWa-RbGESe
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289c6 cx=c_pps
 a=8LlSNZ/L86USH+wcAhsXzg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=b_Sv9-5cbYMGkstBTwQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXzxhuTTn+sVtW
 /WJUmD7lhLKnTSWYabwwrUWNpipK3Fkn/Gkl8LKcYutdkA6+VBHgGgWniXb8VKAof1V1hH1yTG9
 3t/GvG07mjrV3MO3xElaAiy+gy9DkFTwn9SEhlODgmIxsA+2+hj4B19jx9wl2Q2lmEWC1Js1bRP
 GcKLgBcDtSVPCpAzyksnlanrp1hpPgDIjlOHE4EL1ibhNsiueCnDtgtJ7Sy/UfT/nQPEOWrGI48
 dvZGNoDhcjibB5wtG2cbhs/fFfPxj+7uNYH8O6Hj65AyJRp4oEE+DSkeoP5NgOG9YDmEa4Hx0Ej
 QAaWXbm6xljL6Lfq8C5rjLm2rKgXyE0cxMCMa0x9e7IfbXbii9g8Qbgkmdu9MIijfGBi4OTZndr
 S+B9bxw/ewVHWHWQGfIOhOEzuafwlm0ptIve2/v+HVx3ukaTaWJ3Xq0Ha0Oa0i42PxOEHrPsTBA
 wDh5Sbjl07QFv2X+kWw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a refcnt to struct dthe_data, which atomically
counts the number of requests enqueued in the crypto engine queue which
reference the dthe_data object.

A waitqueue waits on this atomic counter to get back to zero in
dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 39 +++++++++++++---
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++++--
 3 files changed, 133 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 4fdd24ee91637..6a8fbe67ef6cd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,12 +110,11 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
 	return 0;
@@ -124,20 +123,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -149,6 +147,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +224,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +336,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +519,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +555,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +588,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +611,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +723,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +746,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +766,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +873,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1144,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1152,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1207,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 8628187a32e18..6b88ad72c48d9 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -32,22 +32,44 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
 	spin_unlock(&dthe_dev_list.lock);
 
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		atomic_inc(&dev_data->req_refcnt);
+
 	return dev_data;
 }
 
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	if (atomic_dec_and_test(&dev_data->req_refcnt))
+		wake_up(&dev_data->drain_wq);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -153,6 +175,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
+	atomic_set(&dev_data->req_refcnt, 0);
+	init_waitqueue_head(&dev_data->drain_wq);
+
 	platform_set_drvdata(pdev, dev_data);
 
 	spin_lock(&dthe_dev_list.lock);
@@ -207,6 +232,10 @@ static void dthe_remove(struct platform_device *pdev)
 
 	dthe_unregister_algs();
 
+	wait_event(dev_data->drain_wq, !atomic_read(&dev_data->req_refcnt));
+
+	platform_set_drvdata(pdev, NULL);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..a827817e8119a 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,12 +18,14 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/atomic.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/scatterlist.h>
+#include <linux/wait.h>
 
 #define DTHE_REG_SIZE		4
 #define DTHE_DMA_TIMEOUT_MS	2000
@@ -53,6 +55,8 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @req_refcnt: Count of requests currently using this instance.
+ * @drain_wq: Waited on by dthe_remove() until @req_refcnt reaches zero.
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +68,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	atomic_t req_refcnt;
+	wait_queue_head_t drain_wq;
 };
 
 /**
@@ -78,7 +85,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +94,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +110,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

