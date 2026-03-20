Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790353806A2;
	Fri, 20 Mar 2026 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774003873; cv=fail; b=eJE9sfVUj1ajTM0mx7/dH4fo62i0LCSjeN33C2eIHgHzwky4TlMe9gwwnCHR6diYDjbhkNs+czUXpStHCc2R8C/Ol2roEeng+ntKblmnZAdglJsCow8Wt9rEI/8/TV3Xo3ij6y7FMqk8rwZsTZyIcfej4H6CiJw7z6KD4QY0MHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774003873; c=relaxed/simple;
	bh=t03m9nrt5AYWZt4pr1deHmd8nmB0GKsxAsdwbwCqeFc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=azcYikfLxTPMnYVHOE1Wigec3r5I++hw4J0RHBpMyZyMCnziJ0gLLgT1KAadNDxcgRtwWbzx7dAT17c38/UxPeMlZV3uAQ3lzlV++opFUfb90EOhqb1FwBD4KZTEnHu68RfqURBkeaib1l7qoHb+TE/clEfHx5ZKl1+PzfK1skw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=nXJTCWjS; arc=fail smtp.client-ip=52.101.53.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="nXJTCWjS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pwj+CKhEcgIwBqcnyPluZXogxuyALPVtIXXkirUNreGxATw9K/qlEfOdmvkaHhymoTmo3AY0Sb8TD9Qkpb8Bl4zNcQ1VhEEyS+AD1MAHaQp3MrGiEr/JLsLG7x6pHo1//ygy0+zQQhi43L0PiwcWlI0A1x5jz3DrfArbOfY8hRdV7NBqyXTngnyJoGH3XrJGRcF69nPXrNlEX+rt43t1X3XFKT5ttrUBFjz+23n0LGqa0Z7EhcQuqZB9IBW6U7qJd510zcc1/c1kWwwJ2U9tesSTK+r4YnxB7U5j7t9xRDHmSC1QUvnfnceB7OkAPDeOt4KfA8feS8NQ6qfLZdOJ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUZlfvJpgmEUG7sza5eDz4IjSAN/MIfRtTpMabQjpI8=;
 b=iL30bEFesAprQfDWf8c1QVBvnRxtpUBPuR/al/StoaDigkTxwFZ8KpGOUQMB1HCN62bmnQsagkjuO0ZCdtvJw/s0AwG7/UW5kqSQDVs1OSzrHXdLJ2oDAEjCrWeIw8kXaiR1VnnKHJHgjexZQGEC/lDn0iuaEdaqFe1heFrIYLf86nAxXWQ9wuC2woMyzAyJENdX65LSe4GRHbbTn3qCIJ1IXfb5sywqFHx31D4mnxLhVvK1L+ugHI/vW0sn5n3TG4iekvgUQn3XDXVg135YyBVwegMgkooqLRdyu+2X+4e1VzumyD3MG31styOn+CXYdVACKqMYNmEotOOo257GMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUZlfvJpgmEUG7sza5eDz4IjSAN/MIfRtTpMabQjpI8=;
 b=nXJTCWjSYG4uLPwuUdc9mMeig26cFQ/GNYXAIyghTt19kzF895a2mouIEjwjEg5YQT1zLqOn8+RRY7K+FoL0EhFgdgX5AIz7ff4ijT/+KzKm5HjJ4tM1WhOtkiPNg8YBoUZ3zUVu4HJA4zdARruqEpGbC0Z3N5t8lfUG2L/VhvQ=
Received: from SJ0PR03CA0371.namprd03.prod.outlook.com (2603:10b6:a03:3a1::16)
 by BLAPR10MB5092.namprd10.prod.outlook.com (2603:10b6:208:326::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 10:51:08 +0000
Received: from MWH0EPF000C6185.namprd02.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::70) by SJ0PR03CA0371.outlook.office365.com
 (2603:10b6:a03:3a1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Fri,
 20 Mar 2026 10:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 MWH0EPF000C6185.mail.protection.outlook.com (10.167.249.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9723.19 via Frontend Transport; Fri, 20 Mar 2026 10:51:07 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:06 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 20 Mar
 2026 05:51:06 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 20 Mar 2026 05:51:06 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 62KAp4DC4190906;
	Fri, 20 Mar 2026 05:51:05 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller "
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v11 0/2] Add support for more AES modes in TI DTHEv2
Date: Fri, 20 Mar 2026 16:20:50 +0530
Message-ID: <20260320105052.3931552-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6185:EE_|BLAPR10MB5092:EE_
X-MS-Office365-Filtering-Correlation-Id: 77231940-7868-4e3a-ddc6-08de866e9712
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ijlZdDfDJWVbdE9uz9b8PIXp/BA0Cq01lSGa1++/qzn+e5E2cBxShMFc/EpRZbhuMerZiSFZBT+TO1YstBmvM2zX6w28wrfi483X0yw4nzpGW4df+diKi7M3Ra1l2iIrlFZAwvVKOpWMaM1Y3jXlv2fyNCYUXTpB5kptgp2aI9hCl7+IME/6I+HAm8+8NPvrGCWvNEdNHMkE8WyI6FsCb+orghHdhuCpp3DB/EYCZEJUFyAu9TqEjdb3tSXXUYg/GMStTjBnMJ1W41uGBn4eeJyxYElwqSYmMle0CC7l36z3FO8L0yviDO3eeFgTPQ/uyNtjxuapsCthsXVZ0kfxKhu9HTzla4PHc9CzrX/d/JV2XygiWHj24eM7w9sa1/uLCNvwxp4CC7iymdz2rkYxsDhe0vVJWndM2g6TmnlNOEqXQJbNPHAzxTvtQlesM2DWyEfki23LmsWlkVAJCIgAyCTJkn2xG70DRCldATezf8RIKFGhI6mZUq2WjlcMjOlLv/nfqniP0w51Geox6CzB+hAx/iHfLGKInW8XX4f9tfPhoEwFNWulRiAqx12Vm6st8iP6SHq9BC9FJ9jdWFUXbqkAEb+PGF7BxNDn2llzxT8YJ2UahOnXVHfMYvCVAwkj6VeH+8qtBNAC7v7cB81jXRnPsFnN30KP+x3mwSqk4GFKcJZ6v8nZnhTxt0EMQQgk74bKpt1zerdrHcWXb+ODwp85dw5AYRIwDfNSAPmHyk0=
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HvwmdN95lstbsS/jPIu6w/qqKZDFRMRCVwcIh0z0KK8zY9TxCfhZ8W+zMQ45kdDkR6TRNRwPpQubQgzXmoG48i8YzvB3v+QwF1GP8/1zC7KD5JCcnsICXqWPOkQBKwJ6rkK9j/N+oZO+nZU9/KSwOV4NTTr43fsp9V5B/GZ6qQXM/rBvBUaP78Kl1ZIE9qiSVPMACXeP/aj1Nu2pnFVkm+uIJXkWtCAFejBRQ4xboesxKsxOvuTLuPkEzwsH5eLyqH0qegbjfZlIAXsFQh7KshbqCJ1svmXTOYXcyyVjkF0q0RhxMgzfj7yhxeoOd49QvrhD1TkqE6WPkIeRrLNnGXqMwlW/8/z1RNcAWg37CJRMPRG7bsk8bO3keFC2CeDeasCwfZk2bu+Fk/f6CCdoI/a0QXP6Kvx0PeqAC2xlU0WCFwAkK2nZQts3xL65WSH8
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 10:51:07.0894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77231940-7868-4e3a-ddc6-08de866e9712
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6185.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5092

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 and details of AES modes supported were detailed in
[1]. Additional hardware details available in SoC TRM [2].

This patch series adds support for the following AES modes:
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
v11: 
 - Removed AES-CTR patch merged in v10
 - Split scatterlists into AAD and crypt scatterlists to be sent in
   separate DMA transactions. In-place operations now have the modified
   crypt scatterlist same for src and dst.
 - Added correct handling of in-place operations which require
   scatterlists to be mapped with DMA_BIDIRECTIONAL dma direction.
 - Moved DMA callback registration to the last DMA transcriptor based on
   conditions (cryptlen = 0 or not).
 - Minor cleanup and added dev_err messages.
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

v10: https://lore.kernel.org/all/20260226125441.3559664-1-t-pratham@ti.com/ 
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

T Pratham (2):
  crypto: ti - Add support for AES-GCM in DTHEv2 driver
  crypto: ti - Add support for AES-CCM in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |   3 +
 drivers/crypto/ti/dthev2-aes.c    | 726 +++++++++++++++++++++++++++++-
 drivers/crypto/ti/dthev2-common.h |  12 +-
 3 files changed, 738 insertions(+), 3 deletions(-)

-- 
2.34.1

