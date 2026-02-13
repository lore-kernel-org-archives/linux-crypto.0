Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676AC3563ED;
	Fri, 13 Feb 2026 13:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770987759; cv=fail; b=OHJQ8g6eWQpjIzvWp0lKSKaEhK+16rUWWWkDeFm9m7Fx162aVXNF0yXIj8CG504VP9ZrGcb0I8VpwaREzBOPBbZp5sb7CHOQry9VJo3lIqcyuQIsnSZO4Ml6INTZYxMQhamD5oaH+sSeQch5Wob+RfVok1O4jtDDCyOT5cFhP3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770987759; c=relaxed/simple;
	bh=zXRP2nraWZ4Xj9RI67YDWoow7t27qcU1WATSLBTN1J4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eIEzdHdqHgptPdwE44B+fepUkF61hJip4gaJB5krRKif5JKil87SGwKPALefTC8+YXnL6jJ3nCVPtKzaiYsI1dJ2W45GnaZdV3ASNv3ebQ7wG7dArjIT/AYAKtycOLQPBSQRsurnemMlqCathoXx1iYDsV2R1wrw/4dI8VrIhz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ET05n82e; arc=fail smtp.client-ip=40.107.209.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ET05n82e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cNqWpmNtKogR2kFnqAJqM0Aba1GmCMjloerEQHVs5Z7y+45dFeVh3CRB/GDsnhqBYJwhnvQreibrL0Urbfkft59IecgykOHocJ9OE9m7CHewzNVyRzl7jr/MPQxEwrvCMbLRxQPNqYvocH0fb8WT8NTn70PjVOb6uo9S4JLrpCkAR8KzQA4H9G/nNQAYI+E3noa/1cHTOP922/JRvI+NXWpYsOfgn6mpN2oSW0pY/5p6OBbdHP4+/STOY6v3oo1rD21mlacAJPLESpZvU3b5T3unOYVGYW6/ws243jyez1K6WvvTpy5wOmFa5DjVbWmJ7wJHZbJYY0YnDKTCnuaaiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEvI+R5mNM5B/mVuNkNBM0IaZ3i0AnSbZjf1IOKE9Ig=;
 b=lSntsQN6G2OHFgda09mMUIiEcUZ4bBvF7WRfZ24PeDch3hglKVl8nNGhT1mvSmeHTJru8EFCjqUatH9wE37hiFvKJjR6gTXlYVhrRZ2RQ0AzJe4O7aiiy7/tdS7JL4/FVi0i0Gl5mCkow2M9GOKUoC3mBKU3AMrqbDTsx00e09uaBvFfpR8G9XFM9+XHyIm2duOZpMPng7NAUMQ6MsliPdb96OP0Xu1c1/3YqbnuJ7T/Z2sNJtX9DImOZqahnXz3FafJnFbO68wMhFd1DXEECPAA2xPhzn72+jxuNwsn2hdkSCN1M1Cn9Plgp8n4vBIcWRABOKSQEUuUNKejzTaBEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEvI+R5mNM5B/mVuNkNBM0IaZ3i0AnSbZjf1IOKE9Ig=;
 b=ET05n82ekbkW2CeM+sD1XFfDuai9NkTUdFwKis8tEAcTpiDBFHpG2pTAfCvK5JHNQdMo5Rp+K2cQwCLzZosp6UcNwTT5zgwqf0aVhoL3/i53Z0gW8Dy6YliVOo5pDiMRqP8WvlkItocHlZAJ/31okdzwvVYEbNHa3VxS52k3r8E=
Received: from DSZP220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:5:280::15) by
 PH8PR10MB6528.namprd10.prod.outlook.com (2603:10b6:510:228::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 13:02:34 +0000
Received: from DS1PEPF0001709C.namprd05.prod.outlook.com
 (2603:10b6:5:280:cafe::f3) by DSZP220CA0001.outlook.office365.com
 (2603:10b6:5:280::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.14 via Frontend Transport; Fri,
 13 Feb 2026 13:02:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 DS1PEPF0001709C.mail.protection.outlook.com (10.167.18.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Fri, 13 Feb 2026 13:02:33 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:33 -0600
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Feb
 2026 07:02:32 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Feb 2026 07:02:32 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61DD2Vxj1230021;
	Fri, 13 Feb 2026 07:02:32 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v9 0/3] Add support for more AES modes in TI DTHEv2
Date: Fri, 13 Feb 2026 18:32:04 +0530
Message-ID: <20260213130207.209336-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709C:EE_|PH8PR10MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1ca304-5dad-4452-9e32-08de6b00272e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ox6e32FmdddZIpIl++5JB9rAwpeTV4o0TxtTNapIVE5YTlMVO172V4ddE0lr?=
 =?us-ascii?Q?5umoGmkI3jnIryGgmEw+t/e548nwXAi13zQ9MbwFmKbVeUm6jnEtMHmHUm1H?=
 =?us-ascii?Q?aGHvNAPLnrSxh1e/fHGZFd3zNYgIaGeQpW1TGq4oZ2ProgFI6vVu5pMUDtS3?=
 =?us-ascii?Q?BmJjYNkMimNA3rfosm9ZpQOuRol3bBriLb9QfURDAcP4bXywRi69hmWDX/o8?=
 =?us-ascii?Q?n9gTzT4fEV0tCPhm/yPrzdyVwSDDPq5Sq9+3O4tzgs0IFku0E8Ml8xcU2b20?=
 =?us-ascii?Q?g24W5Z8hKI0EHEYJRGl8XYeXWPKlK9aYEzVCwmCW9XgnnPLZm49UJMrdsy7M?=
 =?us-ascii?Q?6jy20uSEXyGBrNrIC43Ug8QOg+thb6kHbn2eaC2BSFgbY5a6g0o3wtgQat6Q?=
 =?us-ascii?Q?i+ItDJ5sGDSNKtkYsTDq8DFfYhFrjmPaOwbJy0ZrbKur2TQ0LengPYJZK9K9?=
 =?us-ascii?Q?6IH6AKMXoiTATMksKNT2T5m7kTi6psghnHg3S87waR4sALFeQXYVmA+QmM7D?=
 =?us-ascii?Q?3Q5Xw2dzkZCG6+t6fwHUrOum4RgPLgOZF/xulCzXYdasHh3XxyzzMA8oaLN6?=
 =?us-ascii?Q?osDjKTQ23/+tiLMo6pTGXLEMmWNu1Cq+jfVjznVbLYjqSmQSfKZ28lxOFeHp?=
 =?us-ascii?Q?waK+GGWMAI6QGqXiDQiE5+uMZoU3cKr5eG+ht3xM01VAvVe/0ZKLy3bM3s0h?=
 =?us-ascii?Q?vKbMA02NIa/lh/N2FRBZzETp09DwJuFEKGBG32fR+hg9Az2GBN2IlC+XwD7O?=
 =?us-ascii?Q?KdF21kbUdvK1kiAbu3MS6nKrCwLEaRtr1BgOY9cTPtKZ6iRYMIaf7HczOB8x?=
 =?us-ascii?Q?sYZLm3frDzb4rN1pmzqo2QPzllLjn1ZLUlco8NywAAZm0S2aONlpehUMzfam?=
 =?us-ascii?Q?/0n87kWMGpYE00CRKC9k9AwbxLKe632ocvs4Xm2ZWD3aj9T1uieqQkje+y1V?=
 =?us-ascii?Q?Wz1TV9MlS8kLDQwlJbszA6ZHGVdEJfBj122L5KGX7KIyiQdfd8gYfv2H0yPV?=
 =?us-ascii?Q?uZHnK9dfT1jsnNh0wsjXWj6IrBOI7Xysh9bQ3q1l2nJX+74H8hj4tQzNwOQR?=
 =?us-ascii?Q?aGMaurkg1NR0KusgbDmujaw/LjQYvPypPpoSqU2+vAhgVaDS0Qsf15Hag36U?=
 =?us-ascii?Q?2LU90sMbTNt91+tiyk97K4OGkOBVzUmLo5WZxAWu0l2UB+GeMA8FdpcXOoUg?=
 =?us-ascii?Q?Nm7qA9qpdnpB9CTwYaBzW4g13uIf3DmiMsMImh+n7WeTCFDpeOgUYRjnzvRP?=
 =?us-ascii?Q?nV1xM4ak9WPBFoUMv4N2C7VHzEZuqLWaVn3xMOyIbBQQH+dr8vdGdbsq9YZD?=
 =?us-ascii?Q?9hl7+/e4BuEsiR1AeBpvEl3uI+NVxb+bRV1rgmYfZpB0+r4h/Q3cU1NjrDI1?=
 =?us-ascii?Q?vyorNt/aQ9GXj2Hip7ewR1wFlXOOUelO9svZc8aCBKOVBLSsTC9Tailb9Ze9?=
 =?us-ascii?Q?hElR/P+mOfFLMBsE/Q79c+Y3ltVuR0MVLHhc+oMp1XxOSHDyf9OtnEMvsPn2?=
 =?us-ascii?Q?f8g6KZpX53aXvlHRBwobtYSKvBykJ2xR5RJyXqfDzi1sL5+A3klsIPVxcGwC?=
 =?us-ascii?Q?LRu8mpPtfEkdrlvx7+8TCxLddfZ8NW7UHNrJTEc49VVCVGDbCJkmZQYo5b7x?=
 =?us-ascii?Q?U4sgLpfUS/yvutLFU+AFf2I=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LqVWVvXQ10wBGeOl17+Oghrb+rpT6Xxkidqp2NgmAB/8yQDUroAlDEgYGhFRiitHr/ltmw22uZODoEN/NmwxQpRb7k8lgZ04RSlmp5Zj/GyEYYfcV7V0TSuiydi+3sSxjxut20UnZurSIxpxBUczJ8i+QBXpgQ6xdU8LYv2e7TpWe5OXgV7V+McrzildMka1vi9KTenIqk6bDBqKcszR+VgsDyUM/fsj8hpzyz/2uWoqGjBk+SGTsX0bplTcv4abAGWoMVK71W1a/juaA4/xTo5S3SmAOrOyPBcTgN2J65RqtIK7WkeETCXtfnN8vGIcP7mglclU6PxdnXvNS50SH/pGDxWbMTG1cj6Me9vBU3WQIqNMoxn5xxOgkkw2YdmSzOuMmAbgedN2znd0tCw5Fdpe71xjuo5hEZRifrsj0QJAJIQDqSr2yRg0CZl0WPoj
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 13:02:33.3717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1ca304-5dad-4452-9e32-08de6b00272e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6528

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
 drivers/crypto/ti/dthev2-aes.c    | 865 ++++++++++++++++++++++++++++--
 drivers/crypto/ti/dthev2-common.c |  19 +
 drivers/crypto/ti/dthev2-common.h |  27 +-
 4 files changed, 883 insertions(+), 32 deletions(-)

-- 
2.34.1

