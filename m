Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011029.outbound.protection.outlook.com [52.101.52.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED51511E99
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984166; cv=fail; b=BMPC/gtAWQwdhM1NcAq96JA9BHCbbo5kWrwS1Fe1EIyZfOMWKgrv0S0Bz1O0ZCml0koYDYH5BCzrPPI5jWPY1Wh9QPXI+MxZ5d0Qi9OD6BM5D0gl/0aQkVEATAvKY2pwrQgT2M3Ry9r27wMCTgk2Z7vVKIiW2BcrM71bZ6cPJ8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984166; c=relaxed/simple;
	bh=QTQRNDX+eDqjBLaO0xJSX8YQ0FY/61z9dfg6m0VssLo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QqHTu2YVZJkATNWXDCybzg0/a9FagzGbPOOWicx3504rQAobi1ns/qnZx7N61g/GeFwo/YX633f63jYk/IAQfFd46elB+cxGhz8AdzcifcN/7JnrJcPDad6EJ9E7cxqWPnV7WRh5/AymJGCdPR1GD5N+/1b5Em2TKPSXzIrvkxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k0ebMxk4; arc=fail smtp.client-ip=52.101.52.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k0ebMxk4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AoAbL3A5FW9YnbzvOa37/h0KbTJy3fksXJGAr6fYKE2BKwnz2CGjqZXbRiKUNS3NPczrSb1Hriqs+cqbQ5uKvssNcyBY6R5V+oC6Rvs0xXg9ZBIPy9+lfa/88NR5XfHIY5Ol82lVn5syNHGdo68T7mDjXdxDdyKu2qwtrlObP+FKrkh4BTNMCsLBM97wBZNXmj4EnJFRWKkMd7migi2/1DwsLpRAsmmrI0ca0u7wBotwN8NfmfUsViWSD8OMa2czye/Dgjy4akuHR6RcdczAJkKQeNXilMHpfGid0tB6Ru3uxsP1w6V2dlhTjpHJCEw3JPnAcn3E9r4gn2pynYeBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxqKUeq6LY3osBZMNGETZuxpyVrzcN3b+rSFeWiVawI=;
 b=Ty9jICpbgaNWc/bSGte36cvWJrTp5xh55m1LSB10JOARR9+rBxs9LplH0dzU9Cmn7GYe/+CCwK/ZTsfHPpB4aocDbJrs8hAhKYdNNPwTmAdsHBcnlKjqehn0cCb8xVhgZdP3j1PHfSv1oCrxUA475Rf4gHqnIWOswMf1VUqcEGQDO5SveTQftIU2G1CncnQ6UOh6L9kxCAMMQjwuiBt3WVaYVuCJjjwm3D/V9cPexHHelh3hrwM1XpUf5uDV40D+6RI12A30BU8DXvf31KFhCmhWvYL7c0weTF+wfl3odtUraIjTT8hU15qcZtyatHqqeITjzbQMBk7Gi7j/i8Y0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxqKUeq6LY3osBZMNGETZuxpyVrzcN3b+rSFeWiVawI=;
 b=k0ebMxk4r5URaehnMx/TmiN6yic8UOkOyynjzNSklAhohCyFLylPMA53nQQOjrePiQ5Ll2koIQ22HoYMgpzVYWepbo1aeRQRfbLIx6jn67HRHZOPop4+7e35XAsUnvKwSTLLg4/vt6EPbEc0gIG+HUTRIXvMRFOEgZgCL1Nern8=
Received: from MW4P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::10)
 by DS0PR12MB9059.namprd12.prod.outlook.com (2603:10b6:8:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 13:22:41 +0000
Received: from SJ1PEPF00002320.namprd03.prod.outlook.com
 (2603:10b6:303:115:cafe::63) by MW4P220CA0005.outlook.office365.com
 (2603:10b6:303:115::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Wed, 14
 Oct 2026 13:22:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002320.mail.protection.outlook.com (10.167.242.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 13:22:40 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 08:22:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: [PATCH 0/4] crypto: ccp - Make sev_cmd_mutex more granular
Date: Wed, 14 Oct 2026 08:20:29 -0500
Message-ID: <20261014132145.1726322-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002320:EE_|DS0PR12MB9059:EE_
X-MS-Office365-Filtering-Correlation-Id: 117bebf6-5204-44e4-9f88-08df29f63921
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|1800799024|376014|6133799003|18002099003|10067099003|13003099007|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	8+YY7dCvL4gxqoRsekxzqhKFHBs+3reUMmaRxzpWi/O+cXoQN/i7XmTO+ifotVh0y2drw8kMb+OkUSicC9+r1F5lCpnL0zo/7KLVOFD2DJKk9JyHASWevYA53+GqXn8qOnGIh3i1BfN358ak5lgTfi8WygE9rTUWDlLCSLiS1EaOVvt0Mfto7+rluupCHbSw1oGzItxJuHM5cB5lV+Wmm4RtPASIWPSlwjjBcQaA8eMoZlWsgDaeWHsC93XVdfcGjQWzkLnAiqXLZngIeDiGdK/84s4ROWjLGrENLhs4FyD9DvevVmDbdufFQWKg/spd9Wvz8e4cWlXjgWr7nXZqe80VHL2qyvUbkQnn9wZJaRTBZeE1Q2PENniHcZ3qxib354751JcmP6/JNg+1KrECjVlRyifwHW7RKTWL9U7cSdgamSi+61OxdL+CxdaYAkADeFMH914OXs+ZGrS0VZRFharpkS85uFHjufPs4x27b277cWeXWTSDrRBmhk9aOLrYfakM/95GNGm48Tfxn7o2AQWx1r6SWZiBCAToCytBAy72MOnJi84v3uBU8ulHwlfg1/d64aU7SQIw2Iypbq0eWHVwS7Q+fH95qW2u2UQuJuK3yPh2KQHYQajDydbh71cPfalIZKo0s2CeM4J9ZoGF0b+LtDUI18dxGvazx7i/8lo=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(1800799024)(376014)(6133799003)(18002099003)(10067099003)(13003099007)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	H8/5CzmbLqXlXRj2TwuW1Awhw5ijBoIsbEx/Ul+wLz28Zas1c7aG54he10BPq0t8VqaSgiG7TpRdXkUSxWwKQT9hU+npf3gHDvLbSyZb2sU/aY5qnmL98ax4i9kXjfMm2sIq5YmtJLc/T989sLI+fsNPOo8AcXGJXgVpyRhkGfbUC09C+PqwDzStFlYnjFHvBGZnKwKVhI1/tO3CIPIZI+8yRayWKWemAWo1N+yU8HTCQT/aL7EhyCr8Tcqn/zAxbrtlxyu4mD9Uq7Z+lzrDa9fGfXHJ4BD0Peu1C0ZQBAEAya0pXuJH5zO5u2oOkI0A9tNBugWe1fYy2IUTyXkgFs4w2G8ghGOpxqLCIIYUcDzwxmalm3Igp1npBKzHrQG3NXVg91CoE/onrDUK6MLWx6b25UZmg/43Aehd+pi0rPHoLekbnoxGTEi3Ac5fe2oC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:22:40.6459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 117bebf6-5204-44e4-9f88-08df29f63921
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002320.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9059

This patchset is also available at:

  https://github.com/amdese/linux/commits/ccp-mutex-rework-v1

and is based on cryptodev-2.6 master.


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

Thank you to Sean for suggesting this approach and Ackerley for wrangling
the changes into a (hopefully) presentable patchset.


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

Michael Roth (1):
      crypto: ccp - Allocate status page outside sev_cmd_mutex in SNP_PLATFORM_STATUS

 drivers/crypto/ccp/sev-dev.c | 165 ++++++++++++++++++++++++-------------------
 1 file changed, 94 insertions(+), 71 deletions(-)

