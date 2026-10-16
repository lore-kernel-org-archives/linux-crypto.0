Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7E938F935
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 04:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124032; cv=fail; b=Ich2BtpooOAThQFieWO0g9ZNsdrRQwpMrQlXHU6YBki50eUw+4OZRw354/Yk/bmtBX6tYe3Rib4FXoW8z5c7RgtiGq/XINj/+vqRSiEc59peJv7eLwTfLuHzixM8W+yLKMWK8QtMZvEktFucVJKdof1FSZ8RKaD6X3EB2IavE/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124032; c=relaxed/simple;
	bh=SRbGBkzakDbOYAiZ1Axg/NKT7DYiMs61ESoi4IqQEFs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=f49tWPllf/sggKneXg3gD37wFku5najW7VjX38bHl0V6YWI6pWBn4RvI9kP3PH+Hy9MSDRIyYM/6s/cGYrE/8Gv4SrULjYZtcMSOBQpe4qXWbMLg8HZBRIu0yjpMIy1irozvexPqZMC4asVxlLuqwoIDjqXphQe+AeyCCa/o86s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RlPuvKTP; arc=fail smtp.client-ip=52.101.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RlPuvKTP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jX06QJ6vp9xUziTqY6HsgrcwY1xu3/ZfqAwqXPZS89SmFu6g3b3EgyPWmZusxS+A3l0rI/R7Rdfc4cWMrYtrq/2Lr17mvKssauTzcCMCQzw8+R/Bd2F11+XXVhMkKlKYfdqWtwyyw0K5ylHf0s3INlMf3hM6Ek4dBjHc21BFb35K4X4HHWlElAMsc5zLqMyBs5UcE+oWtAe9/UQgmVrzHjDcwrbVJp5nKg/gihIEOqvUGtstBNJr9wPuUfyTJPsASdM52sZeRyIoPRiCancaCzTtXggI+PpYhnFki2x82aLep1Un58SC7MqhI+Z2MFugLv9mKeO5m7KiMPUERgN4vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ITjyW5LiOnDLqymm2paTBcfN3v/TS7v0yPClBH73Vo=;
 b=Q7W2JIpfkg0yU2RBS6wV1TEwf85RMtRai0Nioi1SxHJ+e7SU6qPEBp+q4RfAnZc2tSf2CqhCVUOt+q8CZV8H+hBii/1Gzq373iybTWNN/GtLhwMfB+/zwtWUOq3FzxOczzI9Z1jrJxxRgyemrG9gozzU5q+HyLJcUAcTptlEd7Vo79u9xxl/zUjL1P/0MudS5Tby3Ij/yW7c/bBv1y8U4HHpghVgsgZzKtAybxGmPYcHuqgouBMFN99NjBtzpolW6GXw+SPnc+Ni6jD7avAPp+yKrsK86XdSzm0C+1DnLGgyBck/ZGBKHk7wSNY0p95b/4fqfj41sudyvAk+kIMiHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ITjyW5LiOnDLqymm2paTBcfN3v/TS7v0yPClBH73Vo=;
 b=RlPuvKTPYSMCqU/mWB+p/DswmY1RHTFc3rjsw8TYnw7SwgkpOrXGT5gGSPsUlI6giFLDic3K9GW3CG7g6i3UjtTPwyoSPgd4yDKuqzrTY3xKf59XdAUlglBBlvcfSr2y3qJwYgicolSJwKGcFvTP4P9U4V6ZqGLg1bemv/N5MgU=
Received: from PH8P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::27)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 04:13:48 +0000
Received: from CY7PEPF000000F6.namprd05.prod.outlook.com
 (2603:10b6:510:2d7:cafe::28) by PH8P222CA0017.outlook.office365.com
 (2603:10b6:510:2d7::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 04:13:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000F6.mail.protection.outlook.com (10.167.247.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 04:13:47 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 15 Oct
 2026 23:13:40 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH v2 0/9] crypto: ccp - Make sev_cmd_mutex more granular
Date: Thu, 15 Oct 2026 23:09:28 -0500
Message-ID: <20261016041109.1778673-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F6:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: ab35c313-6450-40df-8995-08df2b3be04c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|36860700016|82310400026|56012099006|11063799006|5023799004|261009223027099003|10067099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	XlDnXDG36TEUkLSHgTW4RdRgG014UU7bYYfGn/Sv9csx9fcPFLLrtxJxlyX+890WylszwVQSez/+O4u3HxUTI8SxIaWejh/Ag1hXhPRUqP1YOyYUYcO3Akr9375xAMOG5G1N5Nw0WbBUWOr7GjRYdTbOGLb5VyyBKYy05KgBoywICutFemelTCY8f89jD3rTL1k4KNR1dSiyiTQCFHsCjU7DMPP9l9thT83cMSgJ8dsoB8ggrD2nDiKYJCBvcueJzgVdmcQQfTgezmUyL6MEpyOEOxpsbwRXU+Zk3nq4skVIm/wlvrLsy347Jq2ujTF2fJVqaMQzKEKZOul6DqZZT/TLGqMcsIpRCmZk+gbTBohZWzfGa5GnxG0qp3yhPOv/6ZDwkovkFeTxuFXBmxv4rG5OSvxQC2/R88j7TIv5v02Mke6wQtcsrS1v0BZn2syCaMl0DCLV70ABNIaQjRlRIUnlCvK1ACTwJ/hZOT7B9hr22f90KUbdlQaRt/Mv0bFufRCb6rTDkl54V0Eu3T/jzvGBL0Sgc5t/1H6BdcDJzZd1mzHafB+s1i65NwSso93v4bA18oYizY9yOyUUIVhghwlmaXOuCP/Ytn9NrNAaohFhmCSXw1vWZLULtbblUpnt/b6R4SdOz1ePc4LGzreXuyD2TabVbGNC0V0YzLxqA+E=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(36860700016)(82310400026)(56012099006)(11063799006)(5023799004)(261009223027099003)(10067099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Rf0Gycpo5XNYtmDvwbyFyU/CmNI6gjZqLnGHgM0Vi1HCiOVKDjjcKjahsxMHD5sWNJwIcZD2JZjha9G+pW2gYSR7auJxEBsFrLvHe+fsVuLRw/je5G6uAxUIvt1XVWYkIH+0gAQJcNFsxcJBUbYyfenYfs/SUxlal7U097j2oXAUk/vIlIJTV7nfUs9qGO1aT67wD/b+iQJtaVgTHUkwTnM3TOrlhobSKxhh4HbGhqhEWv2JONvm8pXF7EaM9AmVR3fFp8MYgWElo3i9jB4c+v3BJsA+IGEH/7nH/0WIwSFC68gon1q+57WX2YM3HW/MleF63QOHmPPnArJoyY/Z3aNYSOgXte2teZPsK0i8ecnFcyHojRXiqzxStpOOK3/aRv7n9tQbrBmfHkpbQYkgQ03ltpE7P49zBN+NNpdYXJlTdbrKm1hk3hxoILQKot6I
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 04:13:47.5197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab35c313-6450-40df-8995-08df2b3be04c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

This patchset is also available at:

  https://github.com/amdese/linux/commits/ccp-mutex-rework-v2

and is based on cryptodev-2.6 master (a29888556578).

v1: https://lore.kernel.org/linux-crypto/20261014132145.1726322-1-michael.roth@amd.com/
v2:
 - rework to address cleanup.h guidelines about not mixing goto
   with guard()'s (Sashiko)
 - invert boolean logic for better readability (Tom)
 - simplify by avoiding uncessary helper for sev_do_snp_platform_status() (Tom)


OVERVIEW
--------

The current code makes very coarse usage of the sev_cmd_mutex; for SEV
firmware ioctls, it is essentially taken upon entry, and ends up wrapping
a lot of potentially time-consuming prep/cleanup work that may need to be
done before/after issuing the actual firmware call, which is the main
thing the mutex is meant to protect.

Additionally, some of that prep work involves
copy_from_user()/copy_to_user() calls which can generate page faults and
unecessarily lead to potential deadlock scenarios. No known case exists
in current upstream, but with the upcoming KVM/guest_memfd support for
in-place conversion of the same PFN between shared/private state (which
is currently targeted for kernel 7.4), a special fault handler is added
that could theoretically deadlock if a malicious user tries to use
guest_memfd pages as the source/target of target of said
copy_from_user()/copy_to_user() scenarios[1].

So this series is a prereq to enabling the above-mentioned KVM/guest_memfd
in-place conversion support on SNP-enabled hosts, as well as a cleanup
for SEV ioctls in general.

Patches #7 and #9 are where the mutexes are actually made more granular,
the other patches are just prep for them.

Thank you to Sean for suggesting this approach and Ackerley for wrangling
the changes into a presentable patchset.


REFERENCES
----------

[1] https://lore.kernel.org/kvm/asz8GKNO9aQANr5E@google.com/


Thanks!

-Mike


----------------------------------------------------------------
Ackerley Tng (3):
      crypto: ccp - Shut down SEV firmware before copying to user
      crypto: ccp - Check SNP initialization state after copying user inputs
      crypto: ccp - Make usage of sev_cmd_mutex more granular

Michael Roth (6):
      crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_csr() allocations
      crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_import() allocations
      crypto: ccp - Use __free() handlers for sev_ioctl_do_pdh_export() allocations
      crypto: ccp: - Rework sev_ioctl_do_pdh_export() to avoid goto usage
      crypto: ccp - Use __free() handlers for __sev_do_snp_platform_status() allocations
      crypto: ccp - Allocate status page outside sev_cmd_mutex in SNP_PLATFORM_STATUS

 drivers/crypto/ccp/sev-dev.c | 277 ++++++++++++++++++++-----------------------
 1 file changed, 130 insertions(+), 147 deletions(-)

