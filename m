Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A5238758A;
	Wed, 21 Jan 2026 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769001893; cv=fail; b=kgwFd+H0zFo5SpPc0cAftSa9ftW6PDCODTVUUUW/zAhMlVwqGZwWqHQy5pPbx9S+ZFYcJj+iviPtrcwmDlV9p4MU2n4GjUxZqNJzulogvNRBs9LnB51W91bbRCc81QtcQVsQGpBllFJH/pKgp9vyyskiTraFv1+4wcN/nsNyjU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769001893; c=relaxed/simple;
	bh=fFjs54mKKTCjGQsI2l4PLW3LGocHF9CbCV790s0N1T8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ICYe3bYYXV5koBcM4cGcQMki1FdBZIha2NQ8V3L3dwhxjD4WG5CTgga2wB5r++txiDi6XiqOP/IoEbAvz9PDB0cv9suV+5dEG29UOYB87ApomYNrrGZOVbDgow5tGJyThwRYuaGi8w0TnfjDF4HyEk+PgMfLK13YH11//NQGEKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ncl5hK+R; arc=fail smtp.client-ip=40.93.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ncl5hK+R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=myVt77jMmEDSAhBixGI+jt210kYsFue3omIdSI952WO9whDCvWQE1pZetSfZACD92NJo6HHqKerxW3qVkKXatY1wEmD16JfGZcWTij5rri+7GAwQl+BFSTi73jRPxr9hoaAIFq95jzTIRyMuJs6IT4+xGoi23ilqngUsRbbIV4iQUXYtv5WlM4kOH9k/vzxk+19b0AYE8BFs9cgi2fyfiTqDblT1cH4StkGz2AqA8r7kzxKEE/yrql5Za2Vn05w9fTFBnbj6fngrXKTmyi2sf8IjXoxWq7527ziBnAYLETt6vKindlGPwuDrHuDvIA+1973zTlkS1TKphcHMZs1fNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Szx3x8QzFdrnTlS01zrZbj/qgG8XB0RWy0GEykmQpk=;
 b=uIjzC24ek7sOcH507Qh24HhdO1qAKDSQlVFXcsQW6O1p37kMz7LQa0zw4JzVowM7b+8vJ0GxCAE+l0TibT+oze9MOB9KrQpioKU+kLUZj5hIy3MVqYe5lwhfbCHO9KwL6aQs8HaJQazDKL4IDKBgsbkRObnJgzEz/T0xNVdRZsMe81rT/wNwaMnRPfEbVUiJVwEQ4BVJw8oKo47+jYeivkAKYHcCvflQ8uhxlalYt0gEgvhSTFxIr61824s2O+pdegqF199trCVYQsBXS/4q9RtfsWqOvGNBkhf8fhoCu79bOVaU0I7gqwoUvBJJgqEHF2JmwbcwTkeW/8IX8J+cBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Szx3x8QzFdrnTlS01zrZbj/qgG8XB0RWy0GEykmQpk=;
 b=Ncl5hK+R2Cs82pZJYWv3be3cpHM3N4+rl74Ag0VVR5K6K1EG2eslxPwYeymKUDXD8HDq+dIRE8vBH3frNM+ni1rGfJKziZTFVHpnGzbEOqJmVBhrAvQCLpyqzJCjRwcN8p+pz44cpj6IDEME1arHV8DahzD28r/0HeLhcO9b5/M=
Received: from DM6PR05CA0066.namprd05.prod.outlook.com (2603:10b6:5:335::35)
 by IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 13:24:46 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:335:cafe::c7) by DM6PR05CA0066.outlook.office365.com
 (2603:10b6:5:335::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via Frontend Transport; Wed,
 21 Jan 2026 13:24:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 13:24:45 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 07:24:33 -0600
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 07:24:32 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 07:24:32 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 60LDOVPC3065661;
	Wed, 21 Jan 2026 07:24:32 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Manorit Chawdhry <m-chawdhry@ti.com>,
	"Kamlesh Gurudasani" <kamlesh@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
	"Kavitha Malarvizhi" <k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
	"Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v2 0/3] Add support for hashing algorithms in TI DTHE V2
Date: Wed, 21 Jan 2026 18:54:04 +0530
Message-ID: <20260121132408.743777-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|IA0PR10MB7370:EE_
X-MS-Office365-Filtering-Correlation-Id: d649cb8c-dc55-476c-100c-08de58f07188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pn42VZCe4AvHbahyN6atyf/dnxDiKcgKpbBAe1hxSrYvSrzOGjMDE/xJWnrl?=
 =?us-ascii?Q?+mbmviwjhXBhUGoWkc0LDlIx/XPXgAYB9jQcIJfSZdaSnBtIrhP+o30NI9Qw?=
 =?us-ascii?Q?+GEmiZLWUu0p0FVP+Zotl+kyCSJygQkx8DT9SRi1McFHEnjNclgFxCPEXWrE?=
 =?us-ascii?Q?sgoCtKhIwWkkHT84Rywl2Ftx09Th767Qp38ovkDTmanFgswibEHl6z+GxS8y?=
 =?us-ascii?Q?4wDIcdrSZVI9EwkW62rZRkKYjGg01MioiMD/Jx1fBWX7B8hww6APkyNpN1Vd?=
 =?us-ascii?Q?psFRZuvtV4gGiRqr22jtvx1FzBkDYCmP7qDSAu33IwKRGTLjKDtLe74G/7sD?=
 =?us-ascii?Q?JX93eyUfIzu1OLBydkKhDaez5hSYYVAF+ht5SOvebY6ssQLBfDZSLjh+n9l9?=
 =?us-ascii?Q?HqZ7P6bEPrVCXaeLLmvS1ZIyYyv6vyix0jLZ7bxn1/ale3C2py7EXrtw9LOq?=
 =?us-ascii?Q?DD7E15+/FER6BO6nMu3rJX2k4vtFkRCi8yo/XVkmAq/GVanF56ItslGk0MvZ?=
 =?us-ascii?Q?neBcgzCrCaVnaneSY2DP+AmafSTAfXVWlLz1A119oPFxHTTpx076BTNmKCX4?=
 =?us-ascii?Q?C+8ZZQUImXPISftA/nPK6AMvaPyUIpKZMA3QQPF3uDa4Bh/vpptx8P+Jz8MZ?=
 =?us-ascii?Q?TKpuEaUWpDLfYoPC1YeajY5w8b7Gd+r+Q6FATCugfwSkQs1OY6QOKDGOjY6b?=
 =?us-ascii?Q?Tp9UD7Eg6igFXaWkZQoqiivHGxRbg51NszNspxoFwdVX+J2rHFb5Ah0fUWgM?=
 =?us-ascii?Q?ZaDlyuP9dxjdkn0zqdlVQj8LgepHjaNPmh6/VVPjoWD2kmqAGglEy3qvh4LF?=
 =?us-ascii?Q?MC1Yxgsg5XW8jjEkieFD+n0mho7cXrioUBmbes37gJfMabPhZMFqyn3aBavl?=
 =?us-ascii?Q?ZA7DevLDYqwAhVrCLZT/6/c9E+6+kd70H7dkCHGZD80OgHyxUQT8+mOIQAIv?=
 =?us-ascii?Q?VIRHJJIZ01foOy+Vk7w5QAuh2PoTgLEfKZgxRIthIRTpkp/uMSbhY49jE/WR?=
 =?us-ascii?Q?/WQf7gTqYG+A4j1TQqvUdxhFnRD55htRDn92rE8xfJTs+8AqQlGZg7HG/uYF?=
 =?us-ascii?Q?bts3lcQN9MgO918S8IoCwy86RE2QgkWouwC/MYq85H7H77GFKilPUCwwS99o?=
 =?us-ascii?Q?22B7iL5Rt1fVuogz3r2O2MybOM/bz2UpopxUf4STXZVtRKTnG0CF20SQ1Dw/?=
 =?us-ascii?Q?25XhLAeVvkCxNpWy0DqcA8Q0o4l69/aI6Xfc4FB5DiBozFuhx5O6WmJvc70R?=
 =?us-ascii?Q?YHpKT02FwrvaqKwd3DF0NNdAVDIdOi+ey1FbwZMsVx1frQKDB8PSCYXjwmGl?=
 =?us-ascii?Q?tQJxiPO18aeVsjiykQZq6oSCmVvTOf9xDStc1PbOrkKG5iZrCE5VQQTSeVBe?=
 =?us-ascii?Q?ptkkwLIyO7OaP2LlDUbBkw+k97qDryCTxpfbZtPESN252R0+g3nUkqxz8WOZ?=
 =?us-ascii?Q?J5ffrVEJC4Jx1fvUivBMZW78s0jBILDirabGUw+M3G6NS2Cc3O1q0VeEnaeq?=
 =?us-ascii?Q?woMLus9KhNixUce27h7KNajtvT5rtfDwY/FmniF37vO/Unvwey52OT42v5oi?=
 =?us-ascii?Q?Va/nH+wwk8gJE0ga6uYOladYPdAG0ldORuYedYDOEEBZ2cgWHb44GfM6p5xS?=
 =?us-ascii?Q?WK4ltQSFmRCYoy4WIGsyn8aYCeGpFC4wJZ6RzzIDvh9xIlMca41AqEQC0BWu?=
 =?us-ascii?Q?pnYf2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(7142099003);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 13:24:45.2338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d649cb8c-dc55-476c-100c-08de58f07188
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 and MD5 as well as their HMAC counnterparts for the
hashing engine of Texas Instruments DTHE V2 crypto driver.

This patch series depends on the following previous series [3]:
[PATCH v8 0/3] Add support for more AES modes in TI DTHEv2

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [4].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: [PATCH v8 0/3] Add support for more AES modes in TI DTHEv2
Link: https://lore.kernel.org/linux-crypto/20260120144408.606911-1-t-pratham@ti.com/

[4]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

Changelog:
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (3):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for MD5 in DTHEv2 Hashing Engine driver
  crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver

 drivers/crypto/ti/Kconfig         |   4 +
 drivers/crypto/ti/Makefile        |   2 +-
 drivers/crypto/ti/dthev2-aes.c    |   6 +-
 drivers/crypto/ti/dthev2-common.c |  37 +-
 drivers/crypto/ti/dthev2-common.h |  58 +-
 drivers/crypto/ti/dthev2-hash.c   | 922 ++++++++++++++++++++++++++++++
 6 files changed, 1011 insertions(+), 18 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

