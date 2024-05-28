Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C52A224D1;
	Tue, 28 May 2024 21:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930458; cv=fail; b=hPzD+XXXTSBZTtOaCCitEjDlMIJSdcr1YTp8wm5rbMuEZ+8vBIu2DcRNDgv1gLfRuO971o2G7bCl8ogu5oHi5peLgRCmELFGd2WjqH/76r6qMP2p886RqG0X5OczOT8Pf9dwDAalpqUFFoGASIfzA1NjDKYlyssKbn6uiIKhA5g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930458; c=relaxed/simple;
	bh=YQZeNSOn4GidMieOucyxDHFFucwkUtwmwg8suyiQ6oA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A1oTZm2WtXYXnxfItNqOkO0YsQA/BULq8WJlVPIVOquPLzGC2u9fPpXKdHxZ8Kvkg8Ab54vy3ixskDXw4FqmQ2fDCNuVrj3S9TVrtLWgA+RuDDReMe5nZv4hnUrSgll6hT5faHAZO1Hqy0yIPbdgdET3US4vt986sRPsOaYnCWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s4d5rluh; arc=fail smtp.client-ip=40.107.102.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s4d5rluh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YunG64dVusMNfRa3q+DC4BsF/8iS0qPT9sl7R+XaQwvOsRWd0EMtQmhXznQvI5RDVuzC58Ng11p6foRoOlIHBbKP9pQBuGBmpO3wA0s4wKsUyeAtBZZ25QDhibI/H9xOX0rz2PxdsTrywyAPJp8U0CKp0xlGTe0OICE7VvI+MaMbD476kBpVWpkR2K0V2W7epp2FjlAJq7f/NoDGccad0I1TeXThZhBNz8rTdQrQ+fOX6ID1U61FLxR/g8Vpnj0cOGJg+RBFv/MsBuHYQgdIdP4Xn494O8A+RItAssYZnjM3SjEZka42GTkVqHMkVzTt+On5eAA97P6SiyNlRN3qbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKP0G58vYxMX9IawFin6dvQYGsRyOuKMsjQBbYDRkuE=;
 b=N7ZMm5HHbsXZQoowR4ztqkIa13qbdT9hE3q4V79k2VJD7wzGVkT5MGWaKGm5jTyN6G663AZ6P8YJLlqJLCVruA6M2qa+HnYpgpTpdl4PMDFl8l2Z4CsYuO/WGpPeuEvP2a0k4zxlDmeVPVPbS/U/mS6MG6pw3bvw4UJHQdwsRLaCI6HIb2TYsV/TlD1Fmd3cEtKZ1KWWgESJ8/tvaeZFMS6ReZsFg2gxSvPNbbm9npE3iDQ7P8fqSlWXynJduSylegEwq457UhtFgM/SZ3QaXfDk6P1C4zG3pUbXRwxSb2wm4f+o/0cky7HzDT7ZiEhoNUOfWnvw4KReppwIktMcyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKP0G58vYxMX9IawFin6dvQYGsRyOuKMsjQBbYDRkuE=;
 b=s4d5rluhUx7lOphYd8Kji1ZOZfToAsZM4VG1K+egvhbEq6UFsAUfidEO/yShrrvyzmCtccakfUYKr1GHmoGLGlQueB8n7YkNNmSUvTV9U2Ju0Uppw7e0bxAo07UKWJmKoSrgOGbb8ucpFqdLhu/s1nJwdyyfyvlgKMzeEmr64m4=
Received: from MN2PR16CA0001.namprd16.prod.outlook.com (2603:10b6:208:134::14)
 by PH7PR12MB5618.namprd12.prod.outlook.com (2603:10b6:510:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 21:07:34 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::1b) by MN2PR16CA0001.outlook.office365.com
 (2603:10b6:208:134::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29 via Frontend
 Transport; Tue, 28 May 2024 21:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:33 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:32 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] Enable PSP security attributes on more SoCs
Date: Tue, 28 May 2024 16:07:07 -0500
Message-ID: <20240528210712.1268-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|PH7PR12MB5618:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a7e3680-2c75-43b5-5792-08dc7f5a3176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cn4PeCyciwIqXzXxp6Fw58qBDTNKzc+zxwKFsqAdASknNxTqYQ/CVktSTg0k?=
 =?us-ascii?Q?lMy+NkGftmijDX/BxVabJnBjq6V1x6hbj8beBRMGZLWdUmU7MFjmn0G6KcXO?=
 =?us-ascii?Q?8gSH6pef7qwtDRmx5q9mXTy8iuqA1M3aII0lQlLbc0vQin802TFe5f3ODosV?=
 =?us-ascii?Q?bBBN+/xWcdClf4/DKLj1PUq5EZwp6h2DVRGxioYdUkRxcYFcy9qwOJw3M5Hq?=
 =?us-ascii?Q?QPjtzUe2qRQ8E35QLkfs/DmV1/CjOIDBt4Pq48qXcdr89k8uAiYMHxj5fqkN?=
 =?us-ascii?Q?8Yl29fYBWn/r35ZT4ek9wioxDUo0Ai8ONehjOLsd/FMeiY91j/YGY6YzvXWN?=
 =?us-ascii?Q?PbGn94pTnscKdf9JlGkglAyJr7nXjNsgg7nEC/TVX180DIna992bpvv0Tmhx?=
 =?us-ascii?Q?dhasyFJztwMg4e2wopEFeYkLSvk+ZBdqOT3DBYJfEdTFu/Pe4UXKNCNBwLuj?=
 =?us-ascii?Q?d6ZZQ82ZSfhyAizDLfSSvSjhBb9wzqDAeajUamXD00lWMiEJe/Hwxnp+9IO9?=
 =?us-ascii?Q?DILExPmF/GFZY95TeaTj04YzNuY5ZsqdvfaZjTo4cpjQ6jscta2nJZ3HbGZb?=
 =?us-ascii?Q?M2BFFMDywJP0Hh6PTSPnVqTEa+CMIacrVc9prQNEzF2MgZCCL97oHiZZw3HF?=
 =?us-ascii?Q?Zeesffgm3LaAiAHopTQjMbFXdrvxdybhRZpvEHIl5c39lhbhWqYjyU+9Duq3?=
 =?us-ascii?Q?yei1E1OxsXPkOpn+NeEw6w8+MO71ImwCrYpfwCcKtjP4T80HeUagbT6LulMY?=
 =?us-ascii?Q?fKa2GAlojYRAyzY5j+lo1tyB47DuHXJ1dFrN0tNkGFmjyqnUEV601xZbOyaO?=
 =?us-ascii?Q?PRmnlegHWFLblWMcJY/tFkGFuu625S12GIf+Vb8myTNqCkrx8clObyfxBKBK?=
 =?us-ascii?Q?k9odxdZFt6WmILWXsnwJhaFFJI6Ra0BV8sHk5EObJB52ZfKDA8w6/bfhMkim?=
 =?us-ascii?Q?kROwgGD0wGPpmDnQk+F3geM0IfRRa8aAU3xrHhUpiTMGgTgVWoaXb5zpehyk?=
 =?us-ascii?Q?CssxNjowiBoytu2STjm+NLetji1wWePLeoz/idFiqBMpoPOgpdxzHdN53zpm?=
 =?us-ascii?Q?rBqWpJCgsZnXllLsqs5AaJvywM4Nb+z7bRPTZ9IGkZAVGm890ol5ZUjvuZNO?=
 =?us-ascii?Q?uQat6DcwG+U2/239SvzkeOeiST1X2cVG+l8QpytW2Hr8oDAd7IBrQfAqPhwx?=
 =?us-ascii?Q?t4mcXxm2zatzrE8NKFgVfkryCfWMi/pxt3FXS3Aafb031AhNdMrjK47cb2p5?=
 =?us-ascii?Q?/9akk/S7i2+WTYvYWAwHlJOfhdDvp7ULD7EaazC+MjPvxilfVfCa4AotXFzp?=
 =?us-ascii?Q?aNZXKN/ZbpS7MfS9t8rUl8ydMGXAeXhY2MUXSCY/PvszUfV0vLjbVKMKTdmB?=
 =?us-ascii?Q?fkFWZNsC8+aRKk/3knzCzOqZbKk7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:33.2922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7e3680-2c75-43b5-5792-08dc7f5a3176
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5618

On some older SoCs the PSP doesn't export security attributes in the
capabilities register.  On these SoCs it is however possible to get
the information by a platform access command.

Restructure the driver to move all security attribute handling to
a central location and then add support for calling the platform
access command on those processors.

v1->v2:
 * Add tags (except patch 2)
 * Fix kernel robot reported issue
 * Move a check from patch 4 to patch 5
Mario Limonciello (5):
  crypto: ccp: Represent capabilities register as a union
  crypto: ccp: Move security attributes to their own file
  crypto: ccp: align psp_platform_access_msg
  crypto: ccp: Add support for getting security attributes on some older
    systems
  crypto: ccp: Move message about TSME being enabled later in init

 MAINTAINERS                         |   6 ++
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/dbc.c            |   2 +-
 drivers/crypto/ccp/hsti.c           | 138 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h           |  17 ++++
 drivers/crypto/ccp/psp-dev.c        |  23 ++---
 drivers/crypto/ccp/psp-dev.h        |  46 +++++-----
 drivers/crypto/ccp/sp-dev.h         |   2 +-
 drivers/crypto/ccp/sp-pci.c         |  67 ++------------
 include/linux/psp-platform-access.h |   5 +-
 10 files changed, 210 insertions(+), 99 deletions(-)
 create mode 100644 drivers/crypto/ccp/hsti.c
 create mode 100644 drivers/crypto/ccp/hsti.h

-- 
2.43.0

