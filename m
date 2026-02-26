Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012038.outbound.protection.outlook.com [40.107.209.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797B32D8DAF;
	Thu, 26 Feb 2026 12:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110566; cv=fail; b=CfqK0/rHN5ooDR/sfzPVVWxAK9brt4P7rm+Uc+r19aTDybnBF573Wngqgot5rHp7Q8poTl7FNGUS5I5t9cSsPZ98Kknnr3pkmvxImhShD8rv99nmRfjl7RT0ziT53HKAw9QiiU1M1jdgngZGSu4uy+CldWeHbPHrXqP7s7fQlkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110566; c=relaxed/simple;
	bh=c8STIqpQDgltsj+7woYAqGD1ynF5B/8AJvHKSNeDS0Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ui8MaFdL9O1j4A2UEkFPbLf+lIFy7zfPCWUIivzawP1AhXsiXue64qs/ggfTBqKezZ4W+AgwJecnua+xk88/KRNqsisRKnp40feKbHIdFVcflcByFVUsg02x4GcTrBZ332nFFY4nBpTFuZ5cC1MHbFLHiB62o3FejadY99WBh/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=XZJ6bb4c; arc=fail smtp.client-ip=40.107.209.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="XZJ6bb4c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pRnBRkn9cK5cH6AdrHsb0Nim/KyyjZW36EOTGJsTeoXB+MwyHEOOFkXA2nM/clYFHADHQ8qI6mbeho9t9/0C23ceUZ3k9XRVbdMn9UDn/Yap/7i4ZHT8fTEXIcutt24Me5w/iOiCw8X5jxD7FBeGlpMGRg514jlpM5UtfLi3iE9JlDrZLlbJOjZgNGy4AA6ODou3QTCyDgaPAI2Lw34CaOQ4WM/vh2MYpggIxX2qKJJIEVj1c6aU6CQUYeB2XHn74jjdKsgIDoKlyijWoc9V21ifnXqPpJ/A0v83qSXUN/AyKM8DkoVnKCB/1lM0PdoeWhrXfviu6gtciIBWAg/Vlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MurC1VPFsj2nPFWV47ABUD4PXbBus+vIAXGnSoecDGU=;
 b=bQGrGjR/Uc50euvA6lx9KMDJuMmgSShoDjtfDRU94aenna+EbtgD7BRRuFKu2s1+hNB5WtL6KtlXOJM9M5Hm5+hMB1a/O7czyz/vEtMbGRi4a9dTTi+xrx8Ft2Qt4uASstvm+pccRVj+0fRVBnx2y+iQOPmXJgDIT6Tse2mZm2jX3WL1wEXYhHIL94YUeXNHgTr0SxRQbG7ULQlkfK9x4F5s6F3KE6fxybRy6mehI8Oa3si2i4R2uOcqKBmKXRh6ddbkvOXBntI3GMUPNqQFwtzZuur8oXHDI2G1BohUOObiSH8E+FCOLx/4iYKT8hgAVjJBHr8kASTvWZzOEaq6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MurC1VPFsj2nPFWV47ABUD4PXbBus+vIAXGnSoecDGU=;
 b=XZJ6bb4cmtIz4DWQGClpokTc+PxvANA3IvLjCtH8nncr0QdJH7tWtN9oZqy8iPBCjfS39Lk4oHqiHk7NUe/CNjJdU7AWfPOa1l5PEdFQUXS9KLYhlGRtdJEdkam6aDknTJ7xEgaQToCY+/94BQr4akgMBxnQVeD26xniEvedz58=
Received: from BLAPR03CA0029.namprd03.prod.outlook.com (2603:10b6:208:32b::34)
 by PH7PR10MB5879.namprd10.prod.outlook.com (2603:10b6:510:130::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 12:56:01 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:208:32b:cafe::9) by BLAPR03CA0029.outlook.office365.com
 (2603:10b6:208:32b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 12:55:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 12:55:58 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:55:57 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 06:55:57 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 06:55:57 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QCtu5D1898052;
	Thu, 26 Feb 2026 06:55:56 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v10 0/3] Add support for more AES modes in TI DTHEv2
Date: Thu, 26 Feb 2026 18:24:38 +0530
Message-ID: <20260226125441.3559664-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|PH7PR10MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: 38e7ced7-f529-4fbe-b102-08de75366314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|34020700016|1800799024;
X-Microsoft-Antispam-Message-Info:
	TnLmUHig3RkmgzwGVAvcSTJKmPl0Dh9ptQYXUZMl3KE1DFJbmpe8RgXBXn5E9pIJlO4Ktcgv9DEARaaVslP0P6UVXrMhPqFmIVmg5gwNU+FpXb65yIdbw4bkrxOQxBSgzL1vCpGfdN4L1jcsvPVqA8st5pLrYaD3Z/6OUFBTZap9+DVU/tKwBs3w8y9nDIakzInih+WVqQkQvs1O7p1gqONwloNvZMojbUmrlQGgXXR4TZ/dKKntknTV08XXNUDZ6Q+qXEyyu2CxgL4EsV+dJDnBw2WbwLVwG6ZIFvY6nBzKtqCkqOFLYBIjDGc2OAPSjqowNDHvbwzz4N8qOES1SuwgPFo8GrZyWknLufN5HjGQOmUCPKLEdeV992Hm1MHvfK0Z9JWyHRGg3bjO/d719xc0RmZmV+ty7DK922qeIfpW1KR55q6e/EuiyRAVSfc+OIK+va/++AayKjE4NZkvcjv2gyLVYf9E/f+8Yp8Mvg3wfLJmIV9W5YyIRnz47sMTo4q1I7WnS9p+f/tD2Az6FKR55mQ+eto1zuHBqYITNNy+HIG69Nn0Avctfp0XgTGgeXLPxN9xbdVU7R6bPWzUcfW/h93BJLF631wCDroqwmLBLSQUaZfxVWskWHBmmpl7puhQiqbwuIj18BCTIOCV8LrmFS6ZKlSbrSRVI/bC4uBmtxVWIk6gaEE6emI5i0YTHuJEtX4pyTDn4rLmynunmVH7Zub0bGDOr9r1UBztr8FdzbNRfC9ZuWsOxTd/jHC7h3Sd1UfzRddxdO7Ta5OfJm+3sFs64HGDQm/lMVTws2k=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(34020700016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BZfsCyqG/804wlFCW2ygabr2Zj40F8OefaPwXMHRYwbOX6/94tsPSgYS8mhV3bCfe32r2COO6YsGTgwiMqyME6PS1JDgvL4mZNfBuNws5Axcc2Zl6IweXvg1fvljrioW8h2VwAGWo/8MeAStPsDUcu0XjiaTUk3xT5Hda1p6f0H6TKbwh883DvlB4342A45ZCatenJ30HEm+KPzv/C4uxgKuVi7Xb59MMUK/z4LpDjhB4yL9rI1Ch4xFDPgry/jaW+MnzwJfTrIjMjCU7Q8vl9stmBe/caWz1xMA63yhtBPWNlw9YK/e8A9To4KJ/12p1jGL7lEhfKeSeJPMgMwehc6xGhvjONb/jfpxxi6ecn+dEfCapEKPudE/IDNpE7Koh4R1+olLCVkgyi3J9iOsn7/btIXgzaduJKbxGs3hcloH2xKDmrKVm1BIR/04onik
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 12:55:58.2987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e7ced7-f529-4fbe-b102-08de75366314
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5879

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 and details of AES modes supported were detailed in
[1]. Additional hardware details available in SoC TRM [2].

This patch series adds support for the following AES modes:
 - AES-CTR
 - AES-GCM
 - AES-CCM

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 AES Engine kernel self-tests logs
Link: https://gist.github.com/Pratham-T/aaa499cf50d20310cb27266a645bfd60

Change log:
v10:
 - Moved dthe_copy_sg() into AES-CTR patch as it is the first user. Thus
   maintaining bisectability.
 - Corrected padding array size in req_ctx to avoid buffer overflow bug.
 - Check for error in registration individually for AES and AEAD algos.
 - Fixed return value being overridden in AEAD tag
   calculation/verification.
 - Changed memcmp to crypto_memneq to enhance security.
 - Moved verifying AEAD keylen to before copying it in ctx to avoid any
   buffer overflow bug.
v9:
 - Removed modifying scatterlist in AES-CTR. Replaced with allocating
   our own scatterlist for the same purpose to handle padding.
v8:
 - Removed scatterlist chaining from AES-CTR, along with accompanying
   helper functions added in v6. Replaced with sending only complete
   blocks to hardware and handling the last partial block in software.
v7:
 - Moved padding buffer to inside request ctx.
 - Removed already merged AES-XTS patch.
 - Moved dthe_copy_sg() helper from CTR patch to GCM patch, where it is
   being used for first time.
v6:
 - Removed memory alloc calls on the data path (CTR padding in aes_run),
   replaced with scatterlist chaining for added a pad buffer. Added two
   accompanying helpers dthe_chain_pad_sg() and
   dthe_unchain_padded_sg(). 
 - Replaced GFP_KERNEL to GFP_ATOMIC in AEAD src and dst scatterlist
   prep functions to avoid deadlock in data path.
 - Added fallback to software in AEADs on failure.
v5:
 - Simplified AES-XTS fallback allocation, directly using xts(aes) for
   alg_name
 - Changed fallback to sync and allocated on stack
v4:
 - Return -EINVAL in AES-XTS when cryptlen = 0
 - Added software fallback for AES-XTS when ciphertext stealing is
   required (cryptlen is not multiple of AES_BLOCK_SIZE)
 - Changed DTHE_MAX_KEYSIZE definition to use AES_MAX_KEY_SIZE instead
   of AES_KEYSIZE_256
 - In AES-CTR, also pad dst scatterlist when padding src scatterlist
 - Changed polling for TAG ready to use readl_relaxed_poll_timeout()
 - Used crypto API functions to access struct members instead of
   directly accessing them (crypto_aead_tfm and aead_request_flags)
 - Allocated padding buffers in AEAD algos on the stack.
 - Changed helper functions dthe_aead_prep_* to return ERR_PTR on error
 - Changed some error labels in dthe_aead_run to improve clarity
 - Moved iv_in[] declaration from middle of the function to the top
 - Corrected setting CCM M value in the hardware register
 - Added checks for CCM L value input in the algorithm from IV.
 - Added more fallback cases for CCM where hardware has limitations
v3:
 - Added header files to remove implicit declaration error.
 - Corrected assignment of src_nents and dst_nents in dthe_aead_run
 (Ran the lkp kernel test bot script locally to ensure no more such
 errors are present)
v2:
 - Corrected assignment of variable unpadded_cryptlen in dthe_aead_run.
 - Removed some if conditions which are always false, and documented the
   cases in comments.
 - Moved polling of TAG ready register to a separate function and
   returning -ETIMEDOUT on poll timeout.
 - Corrected comments to adhere to kernel coding guidelines.

Link to previous version:

v9: https://lore.kernel.org/all/20260213130207.209336-1-t-pratham@ti.com/
v8: https://lore.kernel.org/all/20260120144408.606911-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20251126112207.4033971-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20251111112137.976121-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20251022180302.729728-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20251009111727.911738-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20250910100742.3747614-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20250908140928.2801062-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250905133504.2348972-4-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for AES-CTR in DTHEv2 driver
  crypto: ti - Add support for AES-GCM in DTHEv2 driver
  crypto: ti - Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   4 +
 drivers/crypto/ti/dthev2-aes.c    | 883 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  27 +-
 4 files changed, 901 insertions(+), 32 deletions(-)

-- 
2.34.1

