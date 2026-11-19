Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795093146;
	b=CO+3hxJBlxEDXi2osZ9M9kqIN1IPHGD6p2/4a0nuCQLdqx/76yHY828GjMpX2oclB0nm
	 VhGeNaa2Qf58NKeDU+vmHuvkzjpGVoNu85AHJl92Hi2rREl2hF/JIf7OeBTGP1MdNdhmU
	 uDlnjGZPhV0SynQ/dWAV3x2/ns2eq1IVgF5m6e1ncJuWrUYOjULm8b6Ujlse/8Es197Kh
	 e2/r588x7zwh0YwlXM9NFsaWQPZEiihKdgeSgiId9BWI9IqJ8gTcV2ATi0GCTx4iMU5oy
	 e38LxJT5ed5DSEn8FxMQEJgX/TCmdVSOqA1sCra6W3Y0OOigYX4mQSyLwrRoJQcIpwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093146;
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
	bh=xY8B6rbvMf9iw5TDM89lHX5zDMW0t5L4TM29SvJYeAs=;
	b=awpASoCUTcuMW5t0thdf2aLbvtu/hp4FZfAVtS5QEobK/Fd3ssSJq7xxH5xFqNjlkc+6
	 OaLxj6bC/P7WbXKXLEjKT8EBDwTG4UUy/HzAdnYrK2Y7WCxSbskrbSNBwECsCtkpsEuWi
	 lgJv5Yc5ljdYmwhC3AraBc1npUCvx1GEhMaeCD4lwX0w2f4cCmsZZhl1JoLUrU5iONadT
	 UExe170tAqFJzQg/OcszkLyKsICajUVtL3+ki26ynO4ZZJkUFmQLrSuLd4D2Ve4qiP1Xs
	 7hb1wRRes5WHyWcgTjLUrghlEahY2OoqcnFf2/yuZvXdIpOxOW0XgQqABoZxSwQnRwQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=rpHd8ZLr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.65
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CBC606A320;
	Thu, 19 Nov 2026 12:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96CBC606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=rpHd8ZLr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IE3Qoqa546DnbmW0ZvoOLLW+TjmvIWBqqrTi1DNoOWvBlQ2MCvXBXRd3rpi/APMkyd0mq7OmYGOS3MiFyHo7fWf+rdqzFwKzeId2L+TJq/pKyM0eENHmPJHmVrmhmNZPU0Jl2eaT6g6W+BcbZC0ukF049ATxfDcsHiaw+khAHMHwlMp636N6A85vQnox2huBFju4yNnPRd3gk3z5UM7Ux+wjPf5KeO8KGboBL3LfCN8/+AvDF9MvUW7v8UKKNxRiATpjdNQ4pNcoOI0O27X7LNR4Oo+g8ORJ49nvzQ8NukWVvzjpINKivuFwod+kgDFgSvG1coqeVKAse+t78/e0Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xY8B6rbvMf9iw5TDM89lHX5zDMW0t5L4TM29SvJYeAs=;
 b=dYBxuNP2mLW8sdC+Hriw2UqRvHXoeVxME819RFbLPjFmUpB2yW8Hc9j37K0KRBtSkBTT8SbDp9NLYdSJzfr3d7vle/SedhP5VT+0SsVPrjcUDpfmrdZJtgL81Ah/fCYfs+dXaWaxZPGhbZEt0mUq7L2YDKsNViyJKztXej/BcoCZtPGgNljLq69f2H/kYU7/hKPxa338ZWBByvDm0NWsxsgR006KW42N7P48yBzKmHJj7mRHkHhZh4g8XtfJ78XAbGlJrqv33Lx7rvFJBO9zK80xEIo9EHfJgZgVKK57wvBLCbA6rc1UV7QcjaIApbqmRvkCcI5EnDutqebwHq4l0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY8B6rbvMf9iw5TDM89lHX5zDMW0t5L4TM29SvJYeAs=;
 b=rpHd8ZLrfj2JzGrsW10hcgUHI/Xet3paCyH8XSvxEeaoRJNN/xcwwij852BLcYh03zIb111GDf38i4BT6qeGoTUEZvUvnyF1M9DoHnNrvQtuTqVwTel4vMOb1Ve0sld0ZQ4LcHnZmu6E22+kCWwCn6kdGFYh/ZRDYU/pfJgG2eA=
Received: from BN9PR03CA0221.namprd03.prod.outlook.com (2603:10b6:408:f8::16)
 by DS0PR12MB7583.namprd12.prod.outlook.com (2603:10b6:8:13f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:59:00 +0000
Received: from BN3PEPF00022BBC.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::57) by BN9PR03CA0221.outlook.office365.com
 (2603:10b6:408:f8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 19
 Nov 2026 12:59:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BBC.mail.protection.outlook.com (10.167.248.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:59:00 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 06:58:53 -0600
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
	<aik@amd.com>, <aik@ozlabs.ru>
Subject: [PATCH kernel 3/4] crypto/ccp/tsm: Remove unused header
Date: Thu, 19 Nov 2026 23:57:32 +1100
Message-ID: <20261119125733.1860288-4-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBC:EE_|DS0PR12MB7583:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a2395c-6f0f-4fd5-1970-08df463ce194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|23010399003|82310400026|261022105027099003|261026121527099003|261026140227099003|261028144727099003|261021123027099003|11063799006|56012099006|10067099003|261009223027099003|261022075727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vDGJa0C0p6BmtayxtmPQNNzHOtE2Q7IR45jZQ4JgotaXdmpCEYtgiU2DJlr9rqZZ/qKXZ7fHVKwdsX7ExG5VFik+ls9flk/MTAyF16m/81kQrhEE4YheI/35Dq0xLZC/2bCNMRLFsnrROAqvls1JpxToTYRdxPpB/tKSOjk7FiT0s0TMeEtMr31d+9OFaiYGUCK8vcyjBxfMwzqGwWq0uGvb17jMDp5gR/8omd570Esk6tykA5XUntAARn20HVBPRADkHYIKtthKI8O7ZmfL9tQpkeKEIehIDrYd2YztxaPTWvkKOv+eukoGBLpy1FDai4CO6a3scuVVy84Oy3vhGVJUAeXSjKDRoPyxS/6iU2lqU3J0OlnJKO4BmLIq4WUSkfvlKHt7oW0vdhhEH2hRz7CPWVtjHRjVnayRGs5EfdlOAVvK5DF3zY4rD+EaFlwHvM04R7LkMZDpqqqOoQIxxdP4Pfir0F4XoUTdXUyHqDzqx5/DGZJtJaR0ZZbt1u4Qr5CRCQPGjY7CztA6vYua8RagSauaFYeJxKqFUwgIhaCrg7u8CAxbyVrdEUTJRQ3AJiBiZtkxrBrbWmvHbVynKbVIqYNGuDtK1ZVe0t8GgSgu2LTXUWJ7LLzp9Okvxo7YIDi0GwPykPrWoLXq6Zi30PmaOTiKfXuPw44P4vTJdsJbt6CS+FrKv6TON7xU+2UhLoY8gyYU48fgKqirI0YGjQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(23010399003)(82310400026)(261022105027099003)(261026121527099003)(261026140227099003)(261028144727099003)(261021123027099003)(11063799006)(56012099006)(10067099003)(261009223027099003)(261022075727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5CC7rZJuEl0iQA7tAcm2TG2Ir3JliMHNSDlLE+yW3Dq2O+atnZhFjPAEUdHE/K7bt9+wIe3eOMIbImsTAy7hzxeTyzlmbnw/JMYgGWitTiKTaZEvfmZWN/VJRsvq5lvEEmq9LZrdxlKCuevUtukR66rKxooBfLFHtZYFiMmmaQyXN2erU/RR+cxU11kUnlNegtxulyrc3e/Z3SUi2TOryP+p8FW+IeRfLK5+qj+JLKEoInINk/2X4V8zEf+mV0FWECdkFPp1TILgla9cKT1srdXHjz+zYPPfG2+UpGf1mYG+PvIQIOsnr3GTs13Tykb1IXQgW9PU2AcizgF1qGY2Z6zkPm3knpgfjrP9zeuXCFiiIlV4i9jg6C36D3+PXyZRtx9f9gFg65sFSSEyOOdKC/B9EJoDAjCjTBnPAT/a65ALPB2F2pqwtMLH+GTbFH+3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:59:00.5993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a2395c-6f0f-4fd5-1970-08df463ce194
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7583

No use of IOMMU here, remove the header to avoid confusion.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5ab..eb16948e1561b 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -5,7 +5,6 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/tsm.h>
-#include <linux/iommu.h>
 #include <linux/pci-doe.h>
 #include <linux/bitfield.h>
 #include <linux/module.h>
-- 
2.55.0

