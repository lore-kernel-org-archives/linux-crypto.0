Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795093104;
	b=Zmf82V17o6Iv08RkmPE3IDmt1clRG3MPhh8/erFVAXD2lD7ipF/yAS26Zrt1LjWMWr/B
	 gF+XiMbO9O3n+xzks4KQusbQ26rGqA9N1bbL4/h06MT7NkGBkKWeEGlBDiNggb48dqn0w
	 2NhPYJcm+c0VkzmrBSzIUw8bBDBHMAqSyIftyIf3Lmh7cfWnAn0YuRoWlpInA5X6hofVL
	 z9hAjXkViSKBS4xx2aX/U5iXqJhlZUPmdo/3vfKw1fX1fGZr76qyozWXVJfbOeJPDdDE8
	 6iOOXJbajs7WnZa+MLkfA0nOmZFfjLhee6am/YXS35IMKgMTEhpcONXCqpbsHopjEng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093104;
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
	bh=82Z0vpXPAcwhKcR7Dq10+eCGylrPVpV4Ttia0A+rNz0=;
	b=JnNKpAVKW/5AMFtMxQo/kmDdwWzy03r7u91EV30rPjlcTimafznKI5R72pN1/vi2HUNd
	 DsU7yux9mm/ZT5EnAQb82/7WU1KtkqM9DgrkHDF0kNzhbuifVdeyFTRGJqoczan7Y9xo4
	 5tPtTkSuac1PYNFZ1Oeo4gaKBRbXI09x8FM1ruIKGsKzGbYW0HhjzrSAfBz8vQ9IhUesC
	 Xgg776eEy9+eyIvkX2YY6Yy27PkJ2eqcBdsL592ptY5C1oi+nmPpyInQU9sbs4tLem7z7
	 INkO/TZOHHWBdY7AyJxdgr6KTcH93A7ICeXmNpAgLlSKn5tIKvGu00uU+r7wNGP+ZbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=USi0Ilz8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.21
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013021.outbound.protection.outlook.com [40.93.196.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7657E606A320;
	Thu, 19 Nov 2026 12:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7657E606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=USi0Ilz8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnAIL8YiF7um7FKPUPjmzldEIKkB6YyxRD4B9HdCFzMdNelsr9yoEDG1B77B0PMbk0KSPTF3ixzmXC401GjmwOkIbxgsPjQIN1YPsrYw9bqwwbbE0Lv+8iDWTtnRP+hY2NgVz5C2sJM9Aqj+kBFiAWwqYAxTJAl6VdRlQO/hXbFs/jGo293vsidkt5Ap8DANy+1H5Swi2fq2rHQevxSW4TXBBPkSHfwbwQPb9ZWWWwWINo3zH3Vqhfa5P4wgZFRN+tA9TydXRkW3doXJPQiOhrcsMnRX5HE/YrgUnee8hpZYYk0L+sZd9g718F0CCzP1wqOuDM+lr99NX7nMOpdcYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=82Z0vpXPAcwhKcR7Dq10+eCGylrPVpV4Ttia0A+rNz0=;
 b=jXuCRLNUe2GyjbP1zuhrAExcGOEdryRYYdxcMPsjMXmpQaPzOOO7L2/IPTIH10bZ5KtCWxvhFIrX4jypKp4ppj55h4RHYlN3cVyEYaVjAzRK+wKgeRWgS3pLLB7cgkv6hx+/YX88IeltDkuyp0+xx+Kfi4i2eOxbE5XjYEjjN2VcRAh+88BUvKB8j5VzkGLRh9PzBzDw0BWJqncSgyjWSbPMGm2obsafGYkKO+NgB7OCteR+XCwGgC63rrQjrw8aU0YbcJvv+UPdC7cd+jdhVxuULdMIA474SXkpdcV78KaZnwA9Q1Lj+n0rg7kek/KizZSgoT4mochsmqUdyLiSdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=82Z0vpXPAcwhKcR7Dq10+eCGylrPVpV4Ttia0A+rNz0=;
 b=USi0Ilz8gs+OF6pwW/wtdTagI0eOXl0a6HPg6HrfrL4BjZKaRGfvQ4p3NAinaMRqC93Xi6yJeACLtQY2WupbDnYlupVnTPnUD2IXxw3sa40gEZDcIpTfLlDur6exCD8i8r9MAEG2Mzns0LsELJEy/F0F17W8duc+I5LWHuDMtzY=
Received: from BN9PR03CA0148.namprd03.prod.outlook.com (2603:10b6:408:fe::33)
 by DS5PR12MB093474.namprd12.prod.outlook.com (2603:10b6:8:47e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 12:58:20 +0000
Received: from BN3PEPF00022BC0.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::af) by BN9PR03CA0148.outlook.office365.com
 (2603:10b6:408:fe::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 12:58:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BC0.mail.protection.outlook.com (10.167.248.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:58:20 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 06:58:12 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Lukas Wunner" <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Jonathan Cameron
	<jonathan.cameron@oss.qualcomm.com>, <linux-coco@lists.linux.dev>, "Santosh
 Shukla" <santosh.shukla@amd.com>, "Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, Fuad Tabba
	<tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, Alexey Kardashevskiy
	<aik@amd.com>, <aik@ozlabs.ru>, Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH kernel 1/4] MAINTAINERS: Update TSM file coverage and repository
Date: Thu, 19 Nov 2026 23:57:30 +1100
Message-ID: <20261119125733.1860288-2-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119125733.1860288-1-aik@amd.com>
References: <20261119125733.1860288-1-aik@amd.com>
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
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC0:EE_|DS5PR12MB093474:EE_
X-MS-Office365-Filtering-Correlation-Id: 01aaf1f1-c838-4585-9e23-08df463cc96b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|10067099003|11063799006|56012099006|261022105027099003|261028144727099003|261026140227099003|261021121427099003|261026121527099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BH7pkABMuPgcjTA5FOvcjcU+slmTpOU/vPhAsDNAqjzzuAvTsV0KeDMLtS5HQqBvLgZDn4FNaAR9jq+FD4xVHt5l9wd7YYFXKosfjg7jFQLtzhlySSLnwkbMBfHRq2UbiAVNVqpHRw3Jg32cxQV+iJedlNlEB8V8+VvboKWgJXlkQ29ZcBflWy2YL/7ByHLhUWL9AD73f9bOa7IC8tQz/sLmBSLv9lt31XjK6KGA/hg17+/uftS7K0K9hz2ErlrX8+12NEu1y3HhXqTBMJUjSBLYMfS3I+CzUUUnxe31oIYlnOqIDQvfknF+zF0M8NM5v5Lwzs8BAzQ1Sh2ny6F0+7zWouSkpNBk7K3llQTw5g5/BKuaLUphFWTTiXKIpJYYKqEH0F70xYz9ZpXbCpSHcmZTm0IpRyKs9xUGbe7XUIPMU4iin1/QTaCJDzCDKUsOAzfFulKraUD6tHGewwu2u0iyfRYhYly6cFQwXRfeeIonpe+uX1A7fVCfLuwYq8frx0lPdhWSDngMHtgiyPBwKF/+4V49WI3X+5KI9AMgAr6z1xL8AlF9qNpRTMDGr/E1OyRVEnbmZJOvSheLcsolqdBM1R65jSpckQTPAwnwHC0s2W65ppa8GznE5El1joUbcCiAtH0nwJcwiQFKtPpmRCXvNFk3eVMutPuTJ0BRY1VPxW7lTt5NjRAXiO+G+NBjYeJzIH1ttwD1y2D4zx/eEA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(10067099003)(11063799006)(56012099006)(261022105027099003)(261028144727099003)(261026140227099003)(261021121427099003)(261026121527099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LiUCNsuZ8a5wF8FrYi11vByJVPHy43B8iJOZOz1UgKd0SR3SOHNeU9Sx+ZJzFeIa1xduqLUCZrLiATB28q6QxjmSuBlOao326cOeLkH5pksE8oqsTK58ODhJOcZPPrUrpdgVncLkhdkzRzgvXebHCeQLqPbk9Yk977LNx6m0l0CZ25L7I3EObp/5OAMK8U6kLbQ2kJ1USpcffKoFxygv1O6GD1i/KeUCHVnM5xfTP9lLPNBCrWF/mAgACWpZpSps8d2wb3DtKVFvpDMg3hwWPdaUI9uVI4unHPxrOW2/m9h0fiBPTVfnNR1UAVzGXZErz5/sGz+lgPuAxDuoVYb/QXUYp+bE4xVC6Srmu6ZYK/kzwfi0kTRxNMLp3v4/1xKk/spWIXmW5C3250mxTMwl0yNTN0Be2j89MvVMPP4iFnXUDoNgN7TcaGyLR5mao4Cc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:58:20.0656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01aaf1f1-c838-4585-9e23-08df463cc96b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR12MB093474

From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>

Add drivers/virt/coco/tsm-core.c and git repository to the TSM entry.

Add the AMD TIO backend of TSM. Other arches are going to be added
next. Eventually these backends will move under drivers/attestation.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
[aik: added drivers/crypto/ccp/sev-dev-*]
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aab..e8059b3d7e6ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28541,11 +28541,15 @@ M:	Jason Gunthorpe <jgg@nvidia.com>
 R:	Lukas Wunner <lukas@wunner.de>
 L:	linux-coco@lists.linux.dev
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tsm/linux.git
 F:	Documentation/ABI/testing/configfs-tsm-report
 F:	Documentation/driver-api/coco/
 F:	Documentation/driver-api/pci/tsm.rst
+F:	drivers/crypto/ccp/sev-dev-tio.*
+F:	drivers/crypto/ccp/sev-dev-tsm.c
 F:	drivers/pci/tsm.c
 F:	drivers/virt/coco/guest/
+F:	drivers/virt/coco/tsm-core.c
 F:	include/linux/*tsm*.h
 F:	samples/tsm-mr/
 
-- 
2.55.0

