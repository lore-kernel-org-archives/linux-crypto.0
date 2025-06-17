Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDF123B63A;
	Tue, 17 Jun 2025 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750153466; cv=fail; b=jEu22Et7O8aEHbMhhJBHRXxQEDl/I07GfexFLOs4ULkK/6YJRjlKcCpqzCcAYBaDqPfHmsRZyyFACpWNA3H9K30hOnCVVg9Y2pxNXtIr5GNuwrZhRV4SaIQwt+JghD0R/reIYpJgTWbnUQJP8Fh7lkqAOkcRN5xCJlf5iLA/vuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750153466; c=relaxed/simple;
	bh=Nbn06lIygKAMUtIDcw5T0d8EhNVb6Ok87tQBgPhSDSE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qASp6QkoxSI1lgtSsX5CsS08pJ6jB9vX4mT87XkLJU6A25urAlOu1Ltf6+Lim4r6O6b4BSaNGaJtgBnZ0UnCaXawLox6ImsMsVylHd85NRD9wqwW+X/LVlCtjavIbcYx+yKFw0CylrF+fantx41IpVhFbO27J2lTva3bRsIVznM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iHoKQP9Y; arc=fail smtp.client-ip=40.107.102.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iHoKQP9Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xr6Kaltip2+JRhP08eofebCwQqg4SU8UKUByUdo5H70plFTPJr7RMLQlD4rxk7vTtpr0lPHhzhWBovl8AoRXckbYEvmBa2uD2/Hixfm5JC3kAoIuRdOBn7Q3ohToD2obv6xrMk1DCROfYaq/500gRSrMaVkm8vSTYP1uki1sgPP6SRyItdfWK9L71nuQEWvfUJa8ki+ghQ3hXWqCRqyavXfqxywY2l3SRMbOCxaVHYoRN8hPNgsiXTBqQ1ea2CTqokN1YDJ54K5IKAbc4KfwJdIqkhiovZrZuM8lQDW2xZcXEKLbckosj9nv0+na3SMIzQCB6TQ+EoV4z/uybZurzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdW6DWMiCuNONuiXEsfrR/l1nLXvzhVvNT9iNVF2GAY=;
 b=ngZK8Iz9W/v9BwFWuKCos7BgBSSH2i+t8m0KINyPgLNzbfESeRXii2fz+uLxerkP3Yl+I7tXTwtUiMpqTdouS9VhxXuEDvoCNb4KaFwCArqgthxtCmOURiE2j6DAYDASFNkNT6eatMU6n6MQC4RnToY8JRgsmIf/ixfAZt/nyABddogMuHvDRWSKzNgpaFjjS74YylEza9RfPJujmu/koIDe9+q+fSvJp85vGQ9icHN85vDHCmaeN0bGbzsVntB+h8gf6ogh0/ambwOlOdyqdmczYpbMmDixEoy+jW/KjU5ek3MhQALNjLzT6APZt+JuZDdzU2kMrHd8Pu78/mJrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdW6DWMiCuNONuiXEsfrR/l1nLXvzhVvNT9iNVF2GAY=;
 b=iHoKQP9Y3GnZJKT5FVY6hAXD3OgjEp4vllIprNLjeNbe0VWQU3FdeVDaRewihV3Eok2EyxhHf6rJNhPvFNC5zsvjiR1XOQMl5gFJi/GhUIwOE2mrGHPawUSUpS8lk3/qeUDvbU027M6Lxxytn1S/XK0wnObyDVl9XwmmKcr8hug=
Received: from BL1PR13CA0243.namprd13.prod.outlook.com (2603:10b6:208:2ba::8)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 09:44:20 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::89) by BL1PR13CA0243.outlook.office365.com
 (2603:10b6:208:2ba::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Tue,
 17 Jun 2025 09:44:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 17 Jun 2025 09:44:20 +0000
Received: from aiemdee.l.aik.id.au (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 17 Jun
 2025 04:44:17 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [PATCH] crypto/ccp: Fix locking on alloc failure handling
Date: Tue, 17 Jun 2025 19:43:54 +1000
Message-ID: <20250617094354.1357771-1-aik@amd.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: 69a50ba5-9f70-47f0-4201-08ddad8388c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cxUxYcmrb7TZnt+8IWpYppRfIn3bGdd4fZ6Wy1VFMsQw4Spyhv50lNVg5dNu?=
 =?us-ascii?Q?wzoqSk4/2HJJEsTU566Q+i7iZDzJp8tXz7GzPbdk/Qr1UuSJxkL8sxLP5hqw?=
 =?us-ascii?Q?l272s3o6v+SiH5sFpF0jV2bs11FNF6xgLCN9DeZQUTG8xuiYokgvcq5h7NN9?=
 =?us-ascii?Q?GawwJ1I05NSP1dkVH2Fkt5OJEgFLxbr/MOYAba8kn4L+d4uZzXua6qQMpv6G?=
 =?us-ascii?Q?ssOV41ivkjO9WQRt8AmNWDBXGnGIWxAFTELFBDKqtLs7s4z7qLUcA9QmeyBX?=
 =?us-ascii?Q?nFULMuoYQwQG1o53QAHKATgqxHOW7D77e366KUvpKnmy8LnjpKbCgwU4jiny?=
 =?us-ascii?Q?BGKiOqVksRka+UNZULe2xz9qdoe2D6/kKvTJgsMYtPgv0X8vkPMUdP/QmCPR?=
 =?us-ascii?Q?/Of9i+NsGBBNOk2sJtHurND0xecyU9CkkJncPiVZp8YqTbTQSHVMCAK6SivL?=
 =?us-ascii?Q?Lhd7NQoSmiOqACEJXIWP9YNPR1arI24iQ2dXg59yYsZLkVbw3J2bE4Chf+0T?=
 =?us-ascii?Q?t+E8tCiA4FfR5dXeW9YZ4q+fvEGgr4E82QUL3cseGolmiDl98CJ63azRY9Ci?=
 =?us-ascii?Q?AxFSbw1jNoqv8XHthBv43YFM5vXpVxsER2jVVGQBxfsuaYZFi9XMFIUzzo0f?=
 =?us-ascii?Q?+BS4dSuPjL+8pFaFxQImXOv+jctruiS6EbXSN5jbLpEhWNeFL4y8j0IOGL4D?=
 =?us-ascii?Q?8v5CPBbQ1PgFpi8jhARWQubxrVCawrOIi7Fqia3LtHNaGoOic9GVFNaWzQRw?=
 =?us-ascii?Q?ofgl67pOKmBs5wNPsR6mjnUyywMGHrSyZVqvqeVvuEXAJq2Dsp9KrAI8b6YY?=
 =?us-ascii?Q?0MJpB7Z6TTYNV7JwFrT04BKN6Nc3wbZ9pHyEIqEAb6QzZC4LNs42eWBj2sDn?=
 =?us-ascii?Q?+Eqw0NuXYGR296P6jQhBqQWPnLhTuu+0vXNoPfE3HVt5MqEYs2R0trqmcmkl?=
 =?us-ascii?Q?Y1+0eDM73k4tPt9DcEH0dNuB37rgLHvdV5mq4SLYPftZhm/a076A7YDlYQBX?=
 =?us-ascii?Q?gQyzmsifgDNMzkns7JveQRxd2vh+1Dg2/gwRpeaaoJew4tbH/kQ6woK5M4f1?=
 =?us-ascii?Q?ZiXRHZAEqLHz/9rgm9nylsNn/Ch3YK/nX3Q6+1TTVWTjYqs7737r8u3UdIs/?=
 =?us-ascii?Q?N+GlG/Kcn6y/heZxVPS5MyP7YA1dfxDxnOBiujzeMDCPN0cKMzXFguSvWcuy?=
 =?us-ascii?Q?dEM59m3BWm79uGIbDvIu5Rhuhin2AUr4EgNxEjTPeF3Lx2h2s3XdARmq4K2Z?=
 =?us-ascii?Q?SX4PWaVWcTF3LAIdRcfh+u2SDz0sTwGnVWT0nHAb0qF0zKRdEvjVqbvvYpKX?=
 =?us-ascii?Q?I+k5s2SHuUXyxzZlwhbi3tC5oHrs9oiGZaWL7374Ag/oZW1M1R6aDuPOociS?=
 =?us-ascii?Q?zf+NJ6+jCJQSJLLzZHzEYaRcD7BDi2F1omGhOXd6hp/P7D+RfmKGQCsUQRMA?=
 =?us-ascii?Q?CoeBwNiASdQbRVI6cf6th1BQhwM9zv2kE+s9nqdsqqEG/pA3HWYMs/pO6MN6?=
 =?us-ascii?Q?exGE7qdCAXt1+0UYeKQKF3RtdTkuXoQjJ0Ct?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 09:44:20.3147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a50ba5-9f70-47f0-4201-08ddad8388c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291

The __snp_alloc_firmware_pages() helper allocates pages in the firmware
state (alloc + rmpupdate). In case of failed rmpupdate, it tries
reclaiming pages with already changed state. This requires calling
the PSP firmware and since there is sev_cmd_mutex to guard such calls,
the helper takes a "locked" parameter so specify if the lock needs to
be held.

Most calls happen from snp_alloc_firmware_page() which executes without
the lock. However

commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")

switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
__snp_alloc_firmware_pages() (which does) but did not account for the fact
that sev_fw_alloc() is called from __sev_platform_init_locked()
(via __sev_platform_init_handle_tmr()) and executes with the lock held.

Add a "locked" parameter to __snp_alloc_firmware_pages().
Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
rmp_mark_pages_firmware() if rmpupdate() failed.

Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3451bada884e..16a11d5efe46 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
 	return rc;
 }
 
-static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
 {
 	unsigned long npages = 1ul << order, paddr;
 	struct sev_device *sev;
@@ -453,7 +453,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
 		return page;
 
 	paddr = __pa((unsigned long)page_address(page));
-	if (rmp_mark_pages_firmware(paddr, npages, false))
+	if (rmp_mark_pages_firmware(paddr, npages, locked))
 		return NULL;
 
 	return page;
@@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(gfp_mask, 0);
+	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
 
 	return page ? page_address(page) : NULL;
 }
@@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
 	if (!page)
 		return NULL;
 
-- 
2.49.0

