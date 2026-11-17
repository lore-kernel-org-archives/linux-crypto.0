Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794953978;
	b=tPdfDgUauqYLgKW700TwMnsFE2BsgnHwP4EtkdcpZzBZx6qxclgpzuabaqhfqN4DoETP
	 42M6QJUGYDIseHrUsGboBUPcpGbGCejyV1uGxEw+zNWtFTeEtwOnC3wnKfFTMBJF5Pkqf
	 el73dQ/eJHXZXBObmGpMZvMWvdB9pG0tohI+NB216JWp9CONpyRJANtTiOFZfjl/1Hy1W
	 uePW0PVzGNA6M1SKKNRTXILKpynu8IlB+E3wQPwxmMDOATzVoN7mVU1rKelUXlsy2AmNk
	 xLp4HkQ0QW4/jJSqpq5h+5Db6JSXaANNOxX4QlF8tiMZ3fNZwctZdpf6fvn1MTSvlyw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953978;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=fDmdrhRKf9vYMJ5WxJ6HGQKxXda/1AWdnOSXuaSEtBk=;
	b=xF6dDZrDJ4/eUGlinvD/Kec4En4lIt/Cyyj9Rts3DYWxqevmOuKsu+90RCamiwF5aHUk
	 hn8mBhSNI5xKtNt+v5n9j2gCMofMCGdgQoe7s4pRzxykoCjWWESP2GRWYT7ZcVbrQnULH
	 kz3aYlwnfIDZddXOjkw9gFNoume7TGbRjVUYbJYOhW0NbVKrI7dTzouWcz4CIhvRBr8zu
	 u2OXAMLZuFNsSm5pgU3akd6vL/2KKpLlMYbsCh+rwXrJru01NhKAde+VmSha4QFvzHcVk
	 gFV611/sELJRM2ksYfwWTna1RGc+u8ap1O+k/1jBO/SQ2FzDJhEPvcrPb125081K08g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JYjmY1Fq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.19
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3331F606A32F;
	Tue, 17 Nov 2026 22:19:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3331F606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=JYjmY1Fq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSix8uIt66HxCfNwWrPgGvm9OulmI7abpnVq/VEKEtmqdwuRubxx8B/wW60YvLqryhkYecJSXNVvEwL8PVcSUSYGjYqUh+dnyTnqAaM2P2bmKumQ/U8V8MeR1tF7WTP9nDF0NxMO5dRrr2SA0q74IV6RdAZZz6uDMxihZHW5qrXTAJMSSwXjudJsUJNqsye0SFD1lTU4yT+ysshRx356vG8omvcdHXjGrtqwt70M13Xtbir5hvX5wBWG+qIivKcOg21zVUy44r78lGD0wgaJxT0I+GN8TBS4Py58UwDMzirujR8w4C8iqBJpubL4d/GbhmvNhVyaQ+3aDgglf1D9ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDmdrhRKf9vYMJ5WxJ6HGQKxXda/1AWdnOSXuaSEtBk=;
 b=PtyA1KrRRj0LtNUQhTAljTXWVt0y4JGd9hn4RMi9gG450lZAOFTp+cjvCCI4LhiCzvQxSIk0Q/kkGmK5IhOWb7gDvWfp0JfgAr9miDD5WxlUy/djbwBUMkh3YWZizSPh7FESzWJonJsFlVSLesTjhQ6+8ScpsCfdrVvtSb4cN4Rulx3DNdvcdTQ+731kdJAE9XulBqb7EEoj0VTrxS96irbHjqRBeUUkCk6kqCozO3sAFOT9kjbBbqvUkuLXCHuZ1+1l3dn+vX0MAP7M98YGzPNB9r1axfvRnUbZdPBAMbInY8EmOttdGqIMbNnomrWz5OvLWtGLhZ3QN+ydZoGYOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDmdrhRKf9vYMJ5WxJ6HGQKxXda/1AWdnOSXuaSEtBk=;
 b=JYjmY1Fq7Nnv912IJa2/qpWvgHJQTHrZWpOOObwAyTGVcXgSuGDTzlTpANB0JCRgxnbHkPE9DGQca5dRLNhQ7ib0v4Fdorv1qae9d/6J5bxagWCEu/m4A+7CWcwcmaRfz9YLSCRh9/uEMRshtGqY63jV5FsFu/07bttIKp+1blE=
Received: from DS1PR02CA0026.namprd02.prod.outlook.com (2603:10b6:8:44a::8) by
 DS0PR12MB9397.namprd12.prod.outlook.com (2603:10b6:8:1bd::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.14; Tue, 17 Nov 2026 22:19:33 +0000
Received: from DS2PEPF00006E23.namprd05.prod.outlook.com
 (2603:10b6:8:44a:cafe::1f) by DS1PR02CA0026.outlook.office365.com
 (2603:10b6:8:44a::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 17
 Nov 2026 22:19:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00006E23.mail.protection.outlook.com (10.167.23.216) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 22:19:30 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 16:19:29 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Ashish Kalra <ashish.kalra@amd.com>, Rijo Thomas
	<Rijo-john.Thomas@amd.com>, Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>, Sashiko
	<sashiko-bot@kernel.org>
Subject: [PATCH 1/2] crypto: ccp - fix leak and stale misc_dev on SFS misc_register() failure
Date: Tue, 17 Nov 2026 16:19:00 -0600
Message-ID: <20261117221901.746427-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117221901.746427-1-kim.phillips@amd.com>
References: <20261117221901.746427-1-kim.phillips@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00006E23:EE_|DS0PR12MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: 373fc0d3-86d5-4933-88bd-08df44f8d98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|22082099003|18002099003|6133799003|261009223027099003|13003099007|11063799006|56012099006|10067099003|261021123027099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	p967oYSiKYQAxTZjrcMPSndvOcU8AxdWmWnptc0npVS1f/Mnum9vcpVg/kE1LZc3wQZCA/bc3/E2tNjfk3rULd3T0iYcAVTl5saJ7f6Q7iPDBA2LKWmfzS/MkIgd263CKizW91rKC7rx43WXkVuIwP/SzEswjIH65zBZelpQOt3BMhu/4Gkn2DUhwPmqL4aSlHDMO5WQwI1R5FG6VGxnzRZtPgwwLQHdI8nQDxb4l+vcuCvTIt3YkSFZ65BvzWO94ieW4NJeIpBAXAmAGqZOeni3O0quSzvGfBYRWlx5DvouxCEjGsOhUyW8Uec3QRl57GxNPbdZQ83pmpIiI/xR969g7FkrdTAFO3KWRXKcalgla9sfCyv9NKmMEl9DWqeRvL2WD+xR7dXNQ+CZaISy8fBwtsD4w+XymBGz9CTiuFvqtbtOigQLq6FroHnJWJvC/kf0uzJBi5MI1pEbezB74IMUE1Pf/Xjh70msO0dK3CqTUX/V+MTjW2/S1yY3PJB5kkZihTLP3cTrd9lJUC5uTeINh19KF5pDvV1J/soc0SUW+yG+m0Gu1ewRumSDCsKX4VoXPXLBY4GTurlXPuv4FJYTPIqgRE5mDqkKj8DU47tY7MTWEZ/BMf4Wea+jGwUQKRD80a0ODgf7dpmShWmr9g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(6133799003)(261009223027099003)(13003099007)(11063799006)(56012099006)(10067099003)(261021123027099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	30VDxaWiTjlIM9494R5qzS+UUIdlXb8nAjvH2yMr+qcSklawig79DdFbmbwMhmKwX9YVDfRrbPzWeqrjgajR2oJDYq2p51jDUokD8cjv3c4wxfXL/htoaHEAdoCNTtJ8XozKpLpX2zb5umnBIt2TKL8KzLGDufmpQeF+0zdNx5mbDi06DC/yMybeqZvCqUAVmI3LBc7y1dYRgD3oGYu51fiaXTfDX8Zk4V31KST8smL7IUITw4B/SuHw4xCGBMP4L/2RsrvNeMCjLbYxBz2bdLcXfAJNNn3wFhQgrsr0eRyArgEWHymHwMQX0lAl7R9ANM3Nyu+qSwXJ3AJGXBSfjheuaiLn5IacXm+myeJMWRaYGYt1/mRlr+bwnw8UyADwws5RqD/L3Wg+OnQvJiHkZan3WZTla6fsu8HrW7x4Y6DBzRv+XW/JY0Aw5ZbotzNb
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 22:19:30.1422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 373fc0d3-86d5-4933-88bd-08df44f8d98b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00006E23.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9397

sfs_misc_init() assigns the newly allocated structure to the global
misc_dev before registering the misc device, but returns early when
misc_register() fails, without freeing the allocation or clearing the
global pointer.  The early return also skips kref_init(), so the
embedded refcount stays at the zero left by kzalloc_obj().

SFS support can be detected on multiple PSP devices, and the failure
only aborts the probe of the device that hit it.  When a subsequent
device probes, sfs_misc_init() observes the stale non-NULL misc_dev and
takes the else branch, calling kref_get() on the zeroed refcount.  That
triggers a "refcount_t: addition on 0; use-after-free" warning and
leaves the count at zero, so the matching kref_put() in
sfs_dev_destroy() warns too and never reaches sfs_exit().  The device
goes on to report that SFS support is available even though /dev/sfs was
never created, and the original allocation is leaked.

Free the allocation and reset misc_dev to NULL on the misc_register()
error path.

Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-126662e0-70a1-4086-a5d1-2f1e15a14f20
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 drivers/crypto/ccp/sfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
index 530141f8bc74..01b16e318fc7 100644
--- a/drivers/crypto/ccp/sfs.c
+++ b/drivers/crypto/ccp/sfs.c
@@ -237,8 +237,11 @@ static int sfs_misc_init(struct sfs_device *sfs)
 		misc->mode = 0600;
 
 		ret = misc_register(misc);
-		if (ret)
+		if (ret) {
+			kfree(misc_dev);
+			misc_dev = NULL;
 			return ret;
+		}
 
 		kref_init(&misc_dev->refcount);
 	} else {
-- 
2.43.0

