Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792594830;
	b=teqCbLJbse6Q0AsRH2UvilOew1vSLszXscDtMz1KztYT/cizj1imTNjL2hIOkryh/5wm
	 Y85M1FFy8jbcLC7SCPEHxZruiZ+8QEo+aG0FptVuIJkAFKwbRY/etQmbxe5SpDvyhLrHF
	 ZlN7NQ6ajYfovLOPXFs3/m+KLcwz2uGnTC9Hcb5clvdmE8nyWS9/Hgh21CQ+BMJ5rqR71
	 vYNmVEJwGEIwL66C7fqM0puyPJfB0Z0lahMTwn51tG+AGftaApdDlSz2HUlqVVQqrpeEu
	 zNHS6xJhMF3LJRLJr1/vLXpDtJ62vo7E7w0QHBweuW9tzUGpb+XFTei0ttcbhio6ovw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594830;
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
	bh=fpAqTM3Eucc59gleKIWHboAnjRGQ2De2aadBglyyNW8=;
	b=X/FwwEZ9lA4eZzuypM/hd/E5QJZTl47rCTtsc1SlVdoHjM90EkkUpIH6Qf2GN+iW2uBV
	 TwcuYa3V+fc5lH44FLBwhjUfGOLWAmKYrjg5bUZJxmKiArdCgX3AhZnjYDdY8gSt9TSV0
	 1FDZ8buHL8tUp/QHRfDkSfsfxzMgSwazfKKBbAeUKoDs2PXbWPMFD7V5gdhgVg1Wrt+bu
	 2L1aFAIddY/nV7F9v4ngYgBwq0Tj5htsvhpuzV8bhqfDJk5/f1qVJmttlLTA9Irrgft36
	 jJgcItNKlDuvc/036mFxy7CkChQRUm1TQwVZo07T3DHpSuMiv/VGxhegrFf8uc2s8/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=sP8DSzZZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.51
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011051.outbound.protection.outlook.com [52.101.57.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4779606A319
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 15:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4779606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=sP8DSzZZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJKuS7xExxvrWaYx6FXoent/9bD1+My7wLlGFue9vbbnhs1g7Z7gGYxK4vfADiyOSYMKKkMsiC/Z9wX542yRObKBKxNdU3X5uulYpj3Pn6PBVoc5F3WGjZAL4paB3kbC/t741UiT6oIHErey+ZLoskYaKZP9c91nPiQwYALSti9kw7gLnfyJH9H7sopvANzk12qPzKSKLJ4f9P/QSCm1wkJ+qvF4H50nxlgLPrDqx9WhLoJAsXYKT7TQXwsjfm+7GuZsItkh6BlblUhBbw/20kH1JwDEAErkMSvUHr9HCAIhpAp2UpGy0I5IwwpzlINGzU7eOd/TZ8j0UTRV7S4jdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpAqTM3Eucc59gleKIWHboAnjRGQ2De2aadBglyyNW8=;
 b=qSKPoRJMvYVoHofHV0kU2nBW4nwjOpSoQa//aCx5omwQT5ZKGvPAcvm1DwffBDz1JX4PMQFp55IxaC3amItYDOZUJODzYGPt/45smEq5Z3UXxzExPUYRywh/UYZ18EG45YORTc4ZYYftCsuBdXJ7/X6irME3W6OYGdcJ8bTUdRIYRQBlcYQ0Mw4qdCi9WPsK7L0EWU6t6w+uwn0pHFh/DdtjRyY7HU9Bh+ZZsrwGFlN2N27TtpW+BCXoAJ6J5hS8fCV+ztMwVegKkd53YvNmoRdKzFcNT3ULDcvEnHQhGmihAKD1ddLJkR7BIKfMmWP4fn3nmko5b3XyFEDt9w9GQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpAqTM3Eucc59gleKIWHboAnjRGQ2De2aadBglyyNW8=;
 b=sP8DSzZZIL0Eo9oqa2nUF04sUyPWBGptuuFpOSdEGTdUM8uIDwAkvJjtt5eiuFKpYBWOITNbrvI1p1RdoHjipkEpeQVXx+KngRz3K7cEZyTGyVAlLmzHfAo6u3aqVd9wqvAmiDWtBs9BdIP6eaapo81OmoklFxLDc2X7BPaKyJY=
Received: from CH0PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:b0::12)
 by IA3PR12MB923065.namprd12.prod.outlook.com (2603:10b6:208:627::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 15:00:27 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:610:b0:cafe::56) by CH0PR03CA0007.outlook.office365.com
 (2603:10b6:610:b0::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 21
 Oct 2026 15:00:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 15:00:27 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 10:00:27 -0500
Date: Wed, 21 Oct 2026 10:00:07 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <ackerleytng@google.com>, <thomas.lendacky@amd.com>,
	<ashish.kalra@amd.com>, <aik@amd.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/9] crypto: ccp - Make sev_cmd_mutex more granular
Message-ID: <hz7e5ueulkzuw7ss3pgzla6p2qq3pdp7z7ustsqsfyiholjlu3@m5qhstcyzhnv>
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <4snves2iefswr3cnswjllztvjwmm5mw72ns4krsbslioq6buaz@j3zovm5cmewd>
 <athNHhrMegveNJBU@gondor.apana.org.au>
 <atjOjlPKWuSjFFXx@google.com>
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
In-Reply-To: <atjOjlPKWuSjFFXx@google.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|IA3PR12MB923065:EE_
X-MS-Office365-Filtering-Correlation-Id: d8098d2b-66bd-44af-931f-08df2f840ae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|4143699003|11063799006|18002099003|10067099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oijV6huo7uW/DIFGs3e7iN6hm4Aaf/QuRN620y1DgE7dUrTJOvPeTqFh1oLC3ErSXlXg94eFMaNe2+Hi8l+Crr7Xs5q3mmqjVWlOS7+oKPbGllNwZunnaZtlrGdDccbcSICTWNd0U/ASTPj0ZULvO7a0UE7bj7zGLLMFlovbdcIIyh8yP2cta3CulF04Y+YfJpvcF7V8+269mVZyYjso90ztLgzbKAXo0781TzjobnrD1Myr0fQYJrsSeTbnpYzeKaZE7P+t3zlnWhIJEetswd3mmBRmvsWYah1V5iOSPp+Q/zEUuJQtigqVZDc+nSHwD9Pat9wvOMeAFZjWqIckrGonkKFWGwWD3a/ulHymB7MbZgQD2ksoXCfUg47LuKKzYjo9XcseO0m8Rpdx+k9g0T0Inrd8f7tICporDQpy4MsrelC2Y7w9Re9+K3/3ZcpyyUnYUpVv6gaqFEBRnxsu08QQcLNkMw8puw+tg+pR6P3G26KUQ1dNIuxJxgOJMKSRALh33mXr/4dDbpolbo1jhD+lSi/Y1wDGoFNh+xnw6zHLVvkd/1VNFOeI4Gt/Y4DXfjPPeSREScbEBibZd1OPxUKPyiHpryy9VfRA549xl5sgmvnRJxx9HKfK6j/ZajjHYvdKHs5zqVcAOAeRGgMRkTBY1/tg4pHNgiizfM/6ty9ilDDtqT4xdyqgWtPSbt5M+7bs11yAj4hI3VdKjqFvzQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(4143699003)(11063799006)(18002099003)(10067099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9WlPBCU9Jvn/D0OVn2SFBBMIJJKif4cdGmKhDpm5sy2BCMnL0qFuEet7mTxo4TpKVy6S6h3OrZ5n1RlOftxJtxOzawhjUXu5MVn1+Kml2uSLNVhSq5AMvBKIeqnZzwtMA/DOSc0kSKcGnsTtq6+WFkpjC0L1KBJIM6JIBbwuKP9hj1/UzgNNrs43DJMEAwDo/eiUDCneymFHDPB4hCwSfqZFFHTFtOl+9Rnl++evNi2S7mWp6jNqYzyJYOAz/ohTLQz6jv4FTjU0Ra8q5kTcxLVaNLVMMtwlEmzsvo2LGIuG5YpA4wXRIFG52tE8KFc/trxvz1D0ShNluc3EcJ0dPlIH+szqAPyTCkgPhirO0qL26pNGn3ZQAvwLDWRmz0qXkI4MpZ5IPGddgZJK51bO1jLbzDoBZjGB38clqJTSUnrfO0ejhOvdn5tNNeNctIM6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 15:00:27.4722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8098d2b-66bd-44af-931f-08df2f840ae9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR12MB923065

On Wed, Oct 21, 2026 at 07:39:10AM -0700, Sean Christopherson wrote:
> +Paolo
> 
> On Wed, Oct 21, 2026, Herbert Xu wrote:
> > On Tue, Oct 20, 2026 at 04:42:19PM -0500, Michael Roth wrote:
> > >
> > > Hi Herbert,
> > > 
> > > It looks like the above-mentioned KVM patches are queued for 7.4, so these
> > > CCP fixes would be needed to avoid the above-mentioned deadlock scenario
> > > with KVM.
> > > 
> > > Would it be possible to get these CCP fixups in for 7.4?
> > 
> > Sorry, these patches are too big and too late for 7.4.
> > 
> > If there is a specific bug that must be fixed in 7.4, please
> > post a minimal fix for it without including the refactoring.
> 
> I'm with Herbert on this one, the "Use __free() handlers" refactorings in particular
> strike me as unnecessary for the "fix", especially since __free() can have some
> nasty gotchas with respect to ordering.  It seems like it should be doable to go
> with a smaller (though still non-trivial) set of changes for 7.4, and then do the
> fancy cleanups on top for 7.5.

Thanks Herbert, Sean. I'm planning to send a simplified v3 soon that does
just that.

The reason these patches ballooned up is that cleanup.h highly advises
against mixing guard()'s with goto's, and Sashiko tries to enforce that,
so that's why there's now 4 prep patches dedicated to just removing gotos.

So for v3 I'm planning to just stick with mutex_lock()/mutex_unlock() so
we can get a clean minimal fix in without too much Sashiko noise, and
then save the refactoring and switch to guard()'s for 7.5.

> 
> If making sev_cmd_mutex usage more granular is itself too much for 7.4, the
> the alternative is to disable/disallow SNP if guest_memfd in-place conversion is
> enabled.  I personally don't care terribly if SNP and in-place conversion are
> mutually exclusive for one kernel release, but I also don't have a vested interest
> in any particular upstream kernel.  Well, unless 7.4 ends up being the next LTS
> (but I don't think it will be?), in which case I would push very hard for landing
> the mutex changes.

Makes sense. I'll post the simplified v3 today to ensure the both options are
available to decide between for 7.4.

Thanks!

-Mike
