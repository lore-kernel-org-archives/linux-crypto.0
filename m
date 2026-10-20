Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792532567;
	b=fAMU+3VBRaIKvEjdhFMsRcKGl78fsHKpWLQENsileqlFpL2nmT+JP2a+dZRQIKdivrZi
	 /Ov3rklvnmgBN0igA29tSJdM+ur1UViNNARJWHBNTA5kCpncZorITCzCwxdG0lD8ybDy9
	 hgJBSR2x91xZRDFCa+2nNPT0H/IvzRC9NUm7BEOBoFTfPgBK8aemolG1TWhs8a1yZ26X1
	 XiWzyUdf0raAbxOrkpaZ+Fkh4M2ovz0GvV9CgKrMKEDvKwn37euFSXeYQDTmRfxMjsIhZ
	 51aGgHTI9O9tPGwtzfABLKT3kTIqsRat/7DBQ+ZC5UOVudmcBruVNo1Hp+InOGZqyyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792532567;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=ukYDc8YLzrVh8xLKaBh8/F0WDZwt/JgHzSVYQcX/T3o=;
	b=jL3m7cO7s/J5uIEB2wR845dunwSCHI5ueEux2mp2neru2eP+S3InYW1m2FjjMeZKYqnH
	 OjvupPJzChM4fS/qiR8AnabsBIxLzsg54hau5yXBty0Pa8oyUy3tpFOQTLqFAjOea+Tr7
	 Eb4En+ClgLmQKVxzIq75HISutCvHsRrxRIBRlEmICiczau5z3UUsargwCLg9/97oM2Sim
	 ni1MAVADW0yCEb8n6bvrWU+wtqXbOjmJLFJbfE0MTibrytZ+M3p7E5NqMmmG1Q4Re9ok/
	 Jerldtc/UeCxAEmdF12q2kGJTa+yFmOG1O7kYqG8QUGAGaF5jztmqzdWC07cgkvVwKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xsA8XJhz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.14
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2E606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 20 Oct 2026 21:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FC2E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=xsA8XJhz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLeIKwmoDjdhKkKYb3Sh1Ll0+7Yy0O+Ckw+NsTqAxkThy4E5LvNVXV1icQUduphDAvafY12gnsbzdLBnygPh7w5Hnv9PHAvtTPIJcoqmMxm7d0pfXyxvzMZQNkcCJ0+hUNTM1kZW4+9YjnXv9/Qs4Z8T38Xrkv++DlNpo1FE6OISd6TgEVikGeChXzZ4dbkClx7eY9SACPMqJ4zlUf6a2Eb1IQLRxEPzJE1QQFEcdkDIlJtcVoLmvwnwpi7Iw+6a2Uy/q/ZJ8Gc6YwJQ1HAejgpwYYQD/X1ECLJtqn9g2SOj9k315QOTYP3tn1C1sufxJqmK7Ijl3E10HPuI50iJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukYDc8YLzrVh8xLKaBh8/F0WDZwt/JgHzSVYQcX/T3o=;
 b=v6xjwsUOCOYMCbJbt+gtD45KdNU0wtufXGa/C/JGqOEYu0sZliZrsSl5ZSGiYj0tPOBbubNLlfGdHJHb31abMrE8SPmOfbm5CJLRhdQStPMzTzz8epnWadVHFWLv5Cbn/A5BBWiyD2xqY2WUACt17H/dpw2EYrAQ0o4QBVjLlg5rVnSaU0cl4PNVfDhXnocHeNYdPazYNpS2/CAJ926JqZHgaZOMP6EpwwKGYCTmbcVWx0OP3HTTKP48tRRiHPxMp+X9s6KCXy102H9QYbOTN9yAeR4iBsHvh7v7ucsHfyRclYeZAPDyctxG+Ur7P/P7ER+9uE6njuw3/x7QqCfmfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukYDc8YLzrVh8xLKaBh8/F0WDZwt/JgHzSVYQcX/T3o=;
 b=xsA8XJhz0YoLCdQfMlovrvQs/tUqalscJSVqqRDmXTBL+4tPdJI3zoX/b56R1/X6KmxCukLOR9muIg3CpzEc6/WQ9xSICc0DJHgrQNB/gWpYhxRA4P4pAARwCXZln6LBZKeAN9p1rB4VxTC8c3W9aIJ8Lkuu4LTsa0EsPQkoRG0=
Received: from CY5PR15CA0119.namprd15.prod.outlook.com (2603:10b6:930:68::27)
 by SA1PR12MB8986.namprd12.prod.outlook.com (2603:10b6:806:375::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 21:42:41 +0000
Received: from CY7PEPF000000EB.namprd04.prod.outlook.com
 (2603:10b6:930:68:cafe::12) by CY5PR15CA0119.outlook.office365.com
 (2603:10b6:930:68::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.20 via Frontend Transport; Tue,
 20 Oct 2026 21:42:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY7PEPF000000EB.mail.protection.outlook.com (10.167.247.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Tue, 20 Oct 2026 21:42:40 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 20 Oct
 2026 16:42:40 -0500
Date: Tue, 20 Oct 2026 16:42:19 -0500
From: Michael Roth <michael.roth@amd.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<ackerleytng@google.com>, <thomas.lendacky@amd.com>, <ashish.kalra@amd.com>,
	<aik@amd.com>, <seanjc@google.com>
Subject: Re: [PATCH v2 0/9] crypto: ccp - Make sev_cmd_mutex more granular
Message-ID: <4snves2iefswr3cnswjllztvjwmm5mw72ns4krsbslioq6buaz@j3zovm5cmewd>
References: <20261016041109.1778673-1-michael.roth@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261016041109.1778673-1-michael.roth@amd.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY7PEPF000000EB:EE_|SA1PR12MB8986:EE_
X-MS-Office365-Filtering-Correlation-Id: 070b4b5d-d5d3-42e7-f500-08df2ef31123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|23010399003|36860700016|6133799003|10067099003|18002099003|22082099003|13003099007|11063799006|5023799004|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1WI8KFT24f73Oe3AFDbxTvVVD8U1WcoBpuMLIinfudS+Erb8MXLkVxx6gSTtyWGoQZjI9PDvjxB43hbb2yWNVNhdqOM85xySd46Ehu4rPnWKRVBYHtCfeyA6PlWnOgQwB1d/++V2gLcF2gAO0q+KQ6LP/8igCstY17UMeed5id9993x5JxLMs79Fm8T9t5uRQjudmwPE9G4vce2vh/pEGe7Z5EOODlO+Q6eICdbEkH6Ez23h5/IG/J6wBqGNLoYXreFHpge/+3KLnKzXWA8BAFfc3FB+3jeVt/nLhS6IbinX16WutbLnD6T3nrPZdcSmIRg/uGbk2vSaujYeyrpaPV4ApSVBtBaZn/OvWuhb11tzWceWeW8yJaBxTZs2r6MCrJrJKWbd37C0VLTIvMRbRxZ+INGSZr7cXf00PonymYEOPYvdkVkbA46M+iNbN1AknwPfHG16k3s4P9d8NRmM/93JKXPxtWJs52A0Ejtw5BsFbxpmkrdpl1OAY3QvAHVbpU4ocphcYDpmqcfR9MjHYAZbNCyNpic4rfMr6cE0RioR3x2ZQaIt28uexPhZzbBaQfg6Tn/ezgsl+Pes05wFgoJPkAiPV53Gtk7notqZNT/uJQWnNYrA+3vdPEjqn0LYIrNBCptOUN5QnQlaXaBT5g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(6133799003)(10067099003)(18002099003)(22082099003)(13003099007)(11063799006)(5023799004)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6eZ4Uy7wfWj2a2ehbT/LsYUuHTv9VyMzerLEZpwMi/lNUtuGaKQprVf7Yz9gnS/KYMMmk0Vlwx4YPG7G41hv6e/kI99mPjuvyuaU/Kq4TgovdZ+1QPzyqLV3AbEbZIcf7MjPi6CvgH/GXiIqON9pRr+Ba3Yg1xVPG1u3hToJwL6IIckMeYH6tuOpOfzTXnTjN/P3Ij3mIEIYnDO6d0toR8gGpNhxSmKn59QcPo3KQWkmhHUW31oyQPHEbx/QhkHnA0LD+YwF/jYidnWiuid7rz2JaeIa/W3VTD5r0/WkANzyaTnSqRMKwZ8N9b5rztoMXuX5lmEUzsGU5R5ZZAiUZTbjXAQhntY0Gw0tehZljH6g4YfUMrGQK9JbbwmZf+Gy991FQ0URdZtoFxGybIn3KHI0jTnygdSeqwSky3o+gxtO4aKkNK8PwooGcF6HkHpT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 21:42:40.8741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 070b4b5d-d5d3-42e7-f500-08df2ef31123
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000EB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8986

On Thu, Oct 15, 2026 at 11:09:28PM -0500, Michael Roth wrote:
> This patchset is also available at:
> 
>   https://github.com/amdese/linux/commits/ccp-mutex-rework-v2
> 
> and is based on cryptodev-2.6 master (a29888556578).
> 
> v1: https://lore.kernel.org/linux-crypto/20261014132145.1726322-1-michael.roth@amd.com/
> v2:
>  - rework to address cleanup.h guidelines about not mixing goto
>    with guard()'s (Sashiko)
>  - invert boolean logic for better readability (Tom)
>  - simplify by avoiding uncessary helper for sev_do_snp_platform_status() (Tom)
> 
> 
> OVERVIEW
> --------
> 
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taken upon entry, and ends up wrapping
> a lot of potentially time-consuming prep/cleanup work that may need to be
> done before/after issuing the actual firmware call, which is the main
> thing the mutex is meant to protect.
> 
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state (which
> is currently targeted for kernel 7.4), a special fault handler is added
> that could theoretically deadlock if a malicious user tries to use
> guest_memfd pages as the source/target of target of said
> copy_from_user()/copy_to_user() scenarios[1].
> 
> So this series is a prereq to enabling the above-mentioned KVM/guest_memfd
> in-place conversion support on SNP-enabled hosts, as well as a cleanup
> for SEV ioctls in general.

Hi Herbert,

It looks like the above-mentioned KVM patches are queued for 7.4, so these
CCP fixes would be needed to avoid the above-mentioned deadlock scenario
with KVM.

Would it be possible to get these CCP fixups in for 7.4?

Regarding the single remaining Sashiko comment:

  https://sashiko.dev/#/patchset/20261016041109.1778673-1-michael.roth%40amd.com

that is for a pre-existing issue relating to firmware accessing pages
after a timeout, but the timeout in this case is 100 seconds and is
mainly intended to keep the system somewhat alive in the case of a
buggy/unusable firmware rather than a path that would be hit on a
normally-functioning system. When a timeout like this is hit, the entire
CCP module is marked dead/unusable. It's highly unlikely firmware would
ever recover after such a long period and touch a freed page.

It might still be worth leaking the page, but that would be separate
from this series.

Thanks!

-Mike

> 
> Patches #7 and #9 are where the mutexes are actually made more granular,
> the other patches are just prep for them.
> 
> Thank you to Sean for suggesting this approach and Ackerley for wrangling
> the changes into a presentable patchset.
> 
> 
> REFERENCES
> ----------
> 
> [1] https://lore.kernel.org/kvm/asz8GKNO9aQANr5E@google.com/
> 
> 
> Thanks!
> 
> -Mike
> 
> 
> ----------------------------------------------------------------
> Ackerley Tng (3):
>       crypto: ccp - Shut down SEV firmware before copying to user
>       crypto: ccp - Check SNP initialization state after copying user inputs
>       crypto: ccp - Make usage of sev_cmd_mutex more granular
> 
> Michael Roth (6):
>       crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_csr() allocations
>       crypto: ccp - Use __free() handlers for sev_ioctl_do_pek_import() allocations
>       crypto: ccp - Use __free() handlers for sev_ioctl_do_pdh_export() allocations
>       crypto: ccp: - Rework sev_ioctl_do_pdh_export() to avoid goto usage
>       crypto: ccp - Use __free() handlers for __sev_do_snp_platform_status() allocations
>       crypto: ccp - Allocate status page outside sev_cmd_mutex in SNP_PLATFORM_STATUS
> 
>  drivers/crypto/ccp/sev-dev.c | 277 ++++++++++++++++++++-----------------------
>  1 file changed, 130 insertions(+), 147 deletions(-)
> 
