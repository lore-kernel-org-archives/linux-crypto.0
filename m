Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C221E226D14;
	Mon, 30 Jun 2025 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751315011; cv=fail; b=PfZGcZn5r9ozPj3FoU/G7qfy7d2nZWKcAyCSPI+WjifojzuRqbB0eDaQHtE93VoP+/51lYLaLs84nMybAFDfukl+Vn4fqdq+H+/a+M7IKEpDaa5Bfd3diIDUKbZ2yGjOF/Q89XU9mgzLakb6NxJ7k/zpHm2RyYyRlm6j7ApKZqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751315011; c=relaxed/simple;
	bh=uyww7Y34k8iYcu7r+nmJ79AG0PRlqMk0iU1nLzMdVGM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q6YExFvbDP19Ar+ffKp4PjqHAg3oLr3bzi05RnUO+Nw6aXSx6mRI28W4M4K/7c9rZZrHdasbDoU+B/GKgw85jZrnr9x9Xz1Swg3bXj8b+m3LwpxxKpiR9Pv2jqq59X/YkCFEjjBhShQxBO4a3h2SjVcnczdVu0ys0iCC3abR6M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vWlAPiKL; arc=fail smtp.client-ip=40.107.101.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vWlAPiKL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLEm7cRMD/4BdqahkD6XEX9DVf5ef2qJNIZEW2WueAI88RDzCt+zxItJTT4azZI5dw2vsbAE6rWuIZ06p3PHvRYwzvfw2WE2zWeR9YD8Jcu9/f0N2RazTtD9L4mZEgXGHXYkAm3JhJtJAUiqfYoxTwep4a+9bueXsyL2V/4WxKJ6abTQc/KMcwNqCQgmgZTy0/i02h9axCHh+ExYXXpC0QpvPi0iL44tEk6NPJi6+2YuhZfhPIByZiPmWzY7pjzvgml6SJw2NgPecjtuBRZUuNs4otzNS8z5968SmiSFK7ze1ldASuIJ5w8aqz+sPl2l9YmHO9G1kzpbFS/i8wYT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sMWAdnVZCSNwqO1d55EA3SUAGOkswJ23kq0gnBRNmqo=;
 b=KgFPr+Cuenqb6Hrvp81r0HDgxGWz643FAw7bip6yR0YMTSfsP8ztz+KQz0HvxWnVaeAwTAv1TzGIyWMF4KTY88lZ5Apn41xrDOp5ryiI/gfvU/bS8r44EfbJlMorBsVZzsl/woUoB/X9EpeWqjLdTULLvbX55LLB9m3vxWaaX4izS1OUtbdqWIwxJ6GBJJAtkG8t6PMHnVlSsKnJdyIoaDsSSQPkWL0MVz08e4JlkhduIRZK3hwhNv5cDQVGNe6v+s4oB6JUl9itGvEc1WHpnNn/VRgWYhqYacmyxIoYC2xTV6yY2PwyZ1mCofPR1e2SH6496GdrM5D6MbxXsvMSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMWAdnVZCSNwqO1d55EA3SUAGOkswJ23kq0gnBRNmqo=;
 b=vWlAPiKL9ekSAyt5lfkC9epc0EauoqYEXWXJtqeIVqGf1x/R+5Vir9CENfhyqIBTcyZr1d9bgRLbpZQ39taR66t/sgNK6B5aKR6fb3wHaKts+mZxMbv5lL2umjUm9Kbvqqi848IqbSV8u0Nph13I/iHoCMsN3BcEkjmojOnM+eI=
Received: from MW4PR04CA0122.namprd04.prod.outlook.com (2603:10b6:303:84::7)
 by IA0PR12MB7675.namprd12.prod.outlook.com (2603:10b6:208:433::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Mon, 30 Jun
 2025 20:23:27 +0000
Received: from SJ1PEPF0000231E.namprd03.prod.outlook.com
 (2603:10b6:303:84:cafe::ee) by MW4PR04CA0122.outlook.office365.com
 (2603:10b6:303:84::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.31 via Frontend Transport; Mon,
 30 Jun 2025 20:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231E.mail.protection.outlook.com (10.167.242.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 30 Jun 2025 20:23:26 +0000
Received: from ellora.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Jun
 2025 15:23:25 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <ashish.kalra@amd.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <bp@alien8.de>, <michael.roth@amd.com>,
	<aik@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>, <prsampat@amd.com>
Subject: [PATCH 0/1] Support for SNP_VERIFY_MITIGATION command
Date: Mon, 30 Jun 2025 15:23:18 -0500
Message-ID: <20250630202319.56331-1-prsampat@amd.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231E:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac57652-c1fe-4c8d-e0ee-08ddb813f856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3ORz9ahZp8x1wYHMT+v4Sfv16mikzYBMG9EGEz3zXgTywxBGUPF6yAK6FoVk?=
 =?us-ascii?Q?WW4Mdyi9eG2R/K4JVvDE+s6uucLYN9VKUuSTCWU4+MxilSEjfiuh5TFaXeMl?=
 =?us-ascii?Q?1TAksc+HVh0xsM4mcujmiA4StYIvCYc9H8CKC0vjfBiWu5+ly0CpUChTez96?=
 =?us-ascii?Q?ojlBIHJY4odBMUZSNNwHMV+13pqxW+gXP05LkOb+fPa3JzJy2A1ALqFoQz6c?=
 =?us-ascii?Q?WKH12EGYOaMpc5mkxHd82lm50v/Da4677KSZOkATIM2FldL+5w7ONcq7ElZb?=
 =?us-ascii?Q?B0EOCWsl+wlRjOFo9iqWOdSNfW/RUN1ci+UbwfM0QC81RxjnOfOIn12Tt3E6?=
 =?us-ascii?Q?+NKBY8xMO10s8cSRfrhKX8h234q7gO8zdwGFRTR6QBvjxuSPbECJiNyGKi7G?=
 =?us-ascii?Q?uqQUiJ8K5tEem+ZriSBYBdAb23eK5S+5eB+XquNzWxMRbShJ2IoMSiQVLW9y?=
 =?us-ascii?Q?pcdS5Itc/Ynk6B4XdFZMbTE/fYgWx4WXgEr5vC737NcsYcjPTbi4brsm8tdM?=
 =?us-ascii?Q?mvkrHbE7Yurzc0/hFRaUq8TH8BzRPw1B+qufP4G7BwvzLRK4bO6BBvx/A4t0?=
 =?us-ascii?Q?EZII5ekrfXLGClXRByZyxc42H5n4xOA2GfbJ4xZdSBnhBRYjr2VqUOua9Nbr?=
 =?us-ascii?Q?WAPjBYvDCDpsBT7xD827+DprmQjorWUMkOq2xDzHy6GyDOiKe7OcKZQpUyrM?=
 =?us-ascii?Q?vuRaktGuPbvIwiA3dQXQ7fY1lXbGOZJ8bR7cAwuzm1IWYmU9Fu/di8IUBJin?=
 =?us-ascii?Q?W1QuaHk7Fb6f1Wqp3iAOXGco25NxLUgm7wa69NKPrEF+w4KEKQsLzuoJA9h+?=
 =?us-ascii?Q?l/sT7xQE8qPVV0hmSg5P0UyEry9cjEwlcI2oZid+ekhjk4fQnF7G/jPG/PEL?=
 =?us-ascii?Q?dCGVzqPkfAbUd3kbz+TpIedQcn6WKAMKKfvx86t1o+a5yMjryhpMRLPtUl0y?=
 =?us-ascii?Q?Ejcd/0ZFtZZ4WzlB+bC0y4him03+Yhb9tTQEU5SLYS4vV1wgYJEXjwhRkJZs?=
 =?us-ascii?Q?SGakEmSxlty7ck6YFVwjb0QspzmOu+O35pDA0KdLAA+HH5fatJ+1+1DKxIa6?=
 =?us-ascii?Q?SD2Ci/wlqMKvZ1NG1hkgTemGbhpe8Etuj45/l2JWXI9p7R7CFj6ljy9Ky8nC?=
 =?us-ascii?Q?vCFimuw72bcLh+uzGgx6GUfuzBq4JWGeSKUcuApL62pjUDsf8XzW0hGxROH9?=
 =?us-ascii?Q?hc3GEdy/YGSpxHvqT1FEdLVRC8dYwD50EeK3ctQ3Qk7/nIhUu9DA9ZughyFT?=
 =?us-ascii?Q?hzjUHXjIsUqP8sL+GkCVntdFPIeAf0QFMxkaNFbA9sTxTzdTKkkp3QMzeLU0?=
 =?us-ascii?Q?EyattulN4EG26+Wv3NUbJPVTSAvpTkb2TI9OlWjNe7HAiLWAkTmHoTSRXoLe?=
 =?us-ascii?Q?mxxU3D4Puo6vAyzVh4Y0O3WB+VsK9hS5bbp0Wd8mtQGqZsPGC3kzQsXOoyoO?=
 =?us-ascii?Q?a9DZhLxWiFPakOU6E1EaH+WksAagbwCyaWKX7KyI4gYXQzZ8UZ6kobcVHZCQ?=
 =?us-ascii?Q?ZIBaBz8qei5om4L9aeKQmq6DJ8Ww8p2R0nEyDdDnS2VXE8sQs+JldFsElg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 20:23:26.5453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac57652-c1fe-4c8d-e0ee-08ddb813f856
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

The SNP_VERIFY_MITIGATION command can be used to query the status of
currently supported vulnerability mitigations and to initiate
mitigations within the firmware.

The command supports two subcommands - STATUS and VERIFY.
The STATUS subcommand is used to query the supported and verified
mitigation bits. The VERIFY subcommand initiates the mitigation process
within the FW for the specified vulnerability.

Information about supported mitigations is planned to be published as
part of AMD Security Bulletins/Notices.

The patch is based on kvm/next and on "crypto/ccp: Fix locking on alloc
failure handling"[1]. The latter is required as we invoke this command
within sev_ioctl(), which already holds the mutex and does not need to
do so again if it has to reclaim snp pages.

Comments and feedback appreciated!

[1]: https://lore.kernel.org/all/20250617094354.1357771-1-aik@amd.com/

Pratik R. Sampat (1):
  crypto: ccp - Add the SNP_VERIFY_MITIGATION command

 Documentation/virt/coco/sev-guest.rst | 13 +++++++
 drivers/crypto/ccp/sev-dev.c          | 55 +++++++++++++++++++++++++++
 include/linux/psp-sev.h               | 30 +++++++++++++++
 include/uapi/linux/psp-sev.h          | 34 +++++++++++++++++
 4 files changed, 132 insertions(+)


base-commit: cf931c83bfc9a33f0b0a91f6fb63a685ffeeb011
-- 
2.49.0

