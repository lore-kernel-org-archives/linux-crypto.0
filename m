Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013030.outbound.protection.outlook.com [40.93.201.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28232F692E
	for <linux-crypto@vger.kernel.org>; Wed, 29 Oct 2025 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761721756; cv=fail; b=A21Cdv68kkrFFMJaa3f3SmI6GKUdbPmSTl+7TjBLQhpTiZ2XvGaERItiBcHnuE9B/HOJPfRZqXd3e0CyDPasxih6FjaSoC9VcCGWciv8A0RIBRVoJoV/YOE/Tg9fPzJHI4hfYPwAvzb00rJfHza01J9Fz12smguCPz6D7CZI5Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761721756; c=relaxed/simple;
	bh=3dASgalbtPhJ95h+l62UZyO9cvHZ3lBUSfF2dMA87KE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GbAopWMhawg9LN47LCLjWcnBXk/wsO/hXGgiZlQQQxW+t5+uAdUVRY2N2hAG/rXYRpCVGM7i0fivvMTDqyAA0w5rdomU0qp+ZpL/3drdBY+iPXW0psLLd3RM5p4wgHI8vK9/wlUqGNvpG7fw/Srh7qcALTDg/+fsv03HCoHJC1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bXXI2X7o; arc=fail smtp.client-ip=40.93.201.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bXXI2X7o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KFOHdyKqDiT6NOmDEnG7zII7lS9EqL/jmuxbM8wQHkFgZpCGrcj/NUVjJ3E8jnKL0PFcST6KtpGoDOJ2kXEZgZWaddc5nOnMq1kJzNwqvTbYYUjxR87+ecdxkh+b4MiA9qAXchym70B1npdtrvvYW9x8G1Etbe5etd5eTPJXLpmlUm6ntZCJiJIMlC5rTPWR4PNiqBbjhzH0lnxcz0HVTd6UB6+13WUFU3uyzebCqRWzG8RJnlr+RI/HWWF5QgyP/Oh8a/V/e920E0nqdfS2xLJPM2aTsuNaY4mEotPyqPyfhYPBzLNR7HopnpormSPtIk88OetkQK4IdvhTuhk0hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kE1kEJjzD+TN1oAOPV/in9N5yfK7HQf3f96Vmtuq4as=;
 b=JsSUVT6EhyXnrclYVPW7eMDrS19AzGNtT7Y8oAei/yRIsD/uH7UHDCwMlsiHLtNMf6BNMCBTbkbiFzc+dlVYpBklWMxcc0NbhUV51OuOy0yQxx7piPszxhCnCOfAhPl2fRe3307WYdygfLK8l6ZLhoTlYii9O9utYcNOn04EwKZrk9KGJ+aE4c5fqOhqQ1rNTHJQ1HS1F+ZW29Yk8pcqdh26hypvB+3mUNojHN1rnZkKOO3X/AAk+tqepE8H4wvKASKZVFNIiYFbsx6NPp0V0m6YsONytdCSNRJ6/BD3k4h88VgmiD1cTJIYBzI1s149H+/AfGvRyOT46eMpvu06fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kE1kEJjzD+TN1oAOPV/in9N5yfK7HQf3f96Vmtuq4as=;
 b=bXXI2X7oIePgf3ej3NN6fsp6R+erYTgMFiItQCFDZdvLQBw82hDMbW/Er/T5SnxJOUUduPRWGMoKR33FfAYvm2XHYhFgzo3LReByPrOtp3QkG3GvdyJVia8PuWnCBp/eXn1oTwWgIkgQWUK6bSr4EPon7qw7iPv6UuH9uzSLfhU=
Received: from SN7P222CA0020.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::10)
 by IA1PR12MB6092.namprd12.prod.outlook.com (2603:10b6:208:3ec::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 07:09:11 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:124:cafe::e) by SN7P222CA0020.outlook.office365.com
 (2603:10b6:806:124::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Wed,
 29 Oct 2025 07:09:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 07:09:10 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 29 Oct
 2025 00:09:09 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 29 Oct
 2025 02:09:09 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 00:09:07 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>, kernel test robot <lkp@intel.com>, "Julia
 Lawall" <julia.lawall@inria.fr>
Subject: [PATCH] crypto: xilinx - Use %pe to print PTR_ERR
Date: Wed, 29 Oct 2025 12:38:38 +0530
Message-ID: <20251029070838.3133358-1-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|IA1PR12MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: e6e03dd3-1cca-4d86-92d6-08de16ba0ec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GUy6VpUhW5bzVX5Kvcv9Uw1uxkp8Pso5kq31y5SpJA6sxTDjwJYLaa1BSTj+?=
 =?us-ascii?Q?fPOdYsQqkoiBMkM6qkwkNobYXgZje8Kv75Vw/0cNIRi8grRx9VSqZG4Ndv/C?=
 =?us-ascii?Q?8EEKN476oEby2RSo13nRuou64/lBhmuFM5PztACqcXvE8AO9r/4KYTfqAU8z?=
 =?us-ascii?Q?+CFGxHo5YTq6HjZVhnV5Ht1Wv4LUOq21elkXtFbaoRSkFgOPsLx7x7ES3heR?=
 =?us-ascii?Q?UKerp7OlXSyu3C0HXDtnXeuJFMeOumfI6bQGzVVkZmLU/y9wsktEW1Bfl1mH?=
 =?us-ascii?Q?gpeDpoa7zy+wmAJS03m/Ahsw2/Ry9s3OfyEptHfrAgjeyj/nt2FD7YP6mFqK?=
 =?us-ascii?Q?bB8ILvEGQYW9qh7K7t5qSg3nq1K4sRrN1pvG0jUX3VpTvEgZsV7lKVz7Q0ss?=
 =?us-ascii?Q?ToGNxwMV07weRMD4Em5gUkxuqA6C6ml/5mKVmL/iDAwuPXYLcILIiD9+Wxjl?=
 =?us-ascii?Q?6P3TEVaP/zRSAzDK43Sz3Vg9UZcFf4WnQU0xITB+0Ibe81sVF6RjZcgwAQKB?=
 =?us-ascii?Q?lGnjlLUWhgNqAzG3PyVF04CcmZuovdFBNPJeTbxdaluLYaJFZTU3LVDSMhdL?=
 =?us-ascii?Q?tLpVijXuQDV/3mzy7KIu4UmJNwgc/EmHDzyM2n10z8FBVnGWuTCU30LHApaf?=
 =?us-ascii?Q?+bJnfi268Hzg7QzynwQzUoqdExKgpLX9NDEKF+NyEH9hDaH1VKcrW8rrB0ZN?=
 =?us-ascii?Q?t5KESM4E98rV8I2baX5Bw7MHSoZMMtUaOfg5aKxXbFGTvF/kZYBhDKuOib8i?=
 =?us-ascii?Q?yGJkXaJU9qoNsztX76ULW47CrOrKpbrqzzzCMBUiReyO5KCxp3/ceIyCdW9G?=
 =?us-ascii?Q?Il5Ac9/fw7DKUPkzkuHLvXIwYWGmoPVLshfNHzFlRHoBTLkx5n5j5STr6JY+?=
 =?us-ascii?Q?3hkJLUsIJfRxG9bA7mIv/maRan6n1NoXDnyll8kwD3Ks2H80Bg84HECJPVuh?=
 =?us-ascii?Q?gd+eljn0w97Yfy7zOU4WTpcSOCvWO/ch6Lj+FUN+Gc0bbznSPOi3KDCRhIVB?=
 =?us-ascii?Q?Ox1PfKEiMF3HRCA4b2z2meK+PRLkhOIkpdh4Aw3S5bTTdATaapyoRS1sKLGS?=
 =?us-ascii?Q?G35uDQ75skXG7kwpA/UYVq0Obhi9ORHS/0q5hKBVkXJeFyE4tiitnkYytyNM?=
 =?us-ascii?Q?lG0YLpmoiLDkJxieClLIanedQ+f2BMFCQFGn39g/gXR+xrVaLkOJm6bwdj2y?=
 =?us-ascii?Q?pWfcrJvQic7mj8KAJfCiEHVQz6iJVla5aVDoy6Pv3IMhJq94L78s7Ju/AMVg?=
 =?us-ascii?Q?NIUocvISVyZanpCkvXW/tQN4dsqlZmFVN4tRq5rwwe7+ToGD/vFo060FKV0n?=
 =?us-ascii?Q?NvOU4ukufOb6SVOBIR1Jcp6lsYpFvx2pQrFUmxHsKJaZcelzfcqxmdaxqvvD?=
 =?us-ascii?Q?cjKnd7MBqGU2Ekl3SVUlI+yFChaFl8gk9YnT4N456WBuqfem0vYT3ImUtyY8?=
 =?us-ascii?Q?aLoFZOWxuvJMMRJAkA4qOBi4uz3/uSY24KqB5pOudAeZXMJcc9kprf72TLO8?=
 =?us-ascii?Q?ZXhR7jY/+mgAB71IgLITQbkcqQJaT4E+wUry?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 07:09:10.0011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e03dd3-1cca-4d86-92d6-08de16ba0ec3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6092

Fix cocci warnings to use %pe to print PTR_ERR().

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202510231229.Z6TduqZy-lkp@intel.com/
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/xilinx-trng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/xilinx-trng.c b/drivers/crypto/xilinx/xilinx-trng.c
index b89a2f70bf82..db0fbb28ff32 100644
--- a/drivers/crypto/xilinx/xilinx-trng.c
+++ b/drivers/crypto/xilinx/xilinx-trng.c
@@ -345,7 +345,7 @@ static int xtrng_probe(struct platform_device *pdev)
 	rng->dev = &pdev->dev;
 	rng->rng_base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(rng->rng_base)) {
-		dev_err(&pdev->dev, "Failed to map resource %ld\n", PTR_ERR(rng->rng_base));
+		dev_err(&pdev->dev, "Failed to map resource %pe\n", rng->rng_base);
 		return PTR_ERR(rng->rng_base);
 	}
 
-- 
2.49.1

