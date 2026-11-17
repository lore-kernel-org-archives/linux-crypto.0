Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794953967;
	b=S9LyxnJMoyYVHHdpon6IMdSDHLU5VfK+IuP0akiQ+EsGLz2cMvExJljIz6RDBS9nNX7r
	 +gbyC1bZTiDJD/lJCQDejVnwkTThgit02EgD9UHIRFGHOGnGA1CcOVx3T563Xqn3cwBk1
	 alU3W5PunI+SVsIFXn8vmt4gBanibDnzTNm+3g4diUbFFnqCjici8bGswA1Q/nEqaGlOH
	 lmZy0AQ1ygtnYxeR1KzJkCPOcggOXDotD3wvKEbzlJl9CR/zej2vJxG04hwWhgFRPn9WA
	 XsQyPUJ8jKsgj0fSvIo2IvGT5J0cPcerWjgs5arAWvAtsb0CC2kzUF2xVBUc0/yj6IA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953967;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
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
	bh=kMunXqOZlqj2J99zyh2dv28Szts+tDTzeK24PCQTKRw=;
	b=UtQRlUndpiTmkftITr/O8hckohCvhhvhAFrJb0e9pWBWmAoBRmaTHE4/exfdlFMp7SrZ
	 NTiua6EoKB9BIt8VLEVsDGGTDSrNEb/U/yUPrq7SeY+X4+DbY50jgjS2TZG0H+BNTqXVj
	 ezOk4VVKxnoerruy9whIP+hFXsDq95JHMy6NOhw5P964rDTLcZn5e5fRzKE7xoEbXjGcb
	 rTmIvD+HpqM1XKsPKOYoBJVtIFEAp8e1/Q5OsR73IAOTgN4fHFnzKs4AhL9t8md5boz5Y
	 9Mo30idi7gdFz2q0zexa78WstxjS17nWnv/69fwmfESyoISw/UtoavhRjnLbz4omWDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=1xlpTxOw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.3
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011003.outbound.protection.outlook.com [52.101.52.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09AF606A31C;
	Tue, 17 Nov 2026 22:19:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F09AF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=1xlpTxOw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C98GKXUjFHW+iSMOoA4trdOzGlCnpDtA/4pHB03DkXHd2BWA70lckHeDHtqRdD8G/lYWue5HgFsor1liL+oA7AReZVD5hW+vuIho/1dO+M7H2l0QI/7SQz4rxZvi3b7eW0ebmjJQaXVwGE7k8329XQgEcbJmT3p7MTC6qT+iApg9dt9BF/xLRPMfnmZDKOhwJ2iJ0VRZmD7D/xFcKUXrWw3rLm4hyUmrs6fxtkKwZtFNeIO67iOxbGsT9L/fFe8VudAzpenmlxcENsU0okIVLrsw7yTrpUM2dCHMxCAkjtkePg/568kbpCg4WKEjZ9rN7wJ3WGAJVGk/GaW8Cady9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMunXqOZlqj2J99zyh2dv28Szts+tDTzeK24PCQTKRw=;
 b=nIneSFquMPc1MhDyrQVi8+woqS0zQdZ76CczIgW0S0fmZ1bSSO3Y49aVCymdYTW10JjBOf5BPL0AFE/wmvCDSyPh4eWLGcQ8eqas+Uwu9y/ds0mz8JWxcxvtH813nOMSCqHmGILxyTOTb9K0yl+KeNUANkhPrH2GBd4ElyU2ncPz5rCtaVKgSw4CrHtrnG4xlULJPTSFKk/zqEjLXTJGEgOo6cwHZxPH7mxqFVjgXAvmPMwtPmXKUCNh1K1EWf9k9z7xWkhhsxFDoBXjKQfTKgj/dOVw+Mj1oaOt0HPYqCrX/VVA0nlODUr8MY0Ojs1fxs2ToPRurnk/j7Y1AjkhDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMunXqOZlqj2J99zyh2dv28Szts+tDTzeK24PCQTKRw=;
 b=1xlpTxOwxcZe04R0FZ+2UOAcWAB+SThrSRuTpG++eU5j2IzTpcEH2BL0UXzdwf/mDPs3WBJkmja6+7X7QwWtDsfpoJT1fXgApIfjZjQCYmOoZOJX3YWPh68Xz52vUYM5E7mHZEH7GYyFAZlWkzxdQ3u0Qn3zRm1UhBGisAzdXRg=
Received: from DSSP221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:3d5::10) by
 DS5PPF5A66AFD1C.namprd12.prod.outlook.com (2603:10b6:f:fc00::64d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 22:19:19 +0000
Received: from DS2PEPF00006E21.namprd05.prod.outlook.com
 (2603:10b6:8:3d5:cafe::ae) by DSSP221CA0005.outlook.office365.com
 (2603:10b6:8:3d5::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Tue,
 17 Nov 2026 22:19:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF00006E21.mail.protection.outlook.com (10.167.23.214) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 22:19:18 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 16:19:18 -0600
From: Kim Phillips <kim.phillips@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Ashish Kalra <ashish.kalra@amd.com>, Rijo Thomas
	<Rijo-john.Thomas@amd.com>, Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 0/2] crypto: ccp - fix misc_register() failure paths in SEV and SFS
Date: Tue, 17 Nov 2026 16:18:59 -0600
Message-ID: <20261117221901.746427-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00006E21:EE_|DS5PPF5A66AFD1C:EE_
X-MS-Office365-Filtering-Correlation-Id: a0d2f792-c8f5-4d5f-da16-08df44f8d2e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|13003099007|11063799006|56012099006|261026140227099003|261028144727099003|261009223027099003|10067099003|261021123027099003|261102123227099003|261021121427099003|261026121527099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	Y/Q6zkUE04cih2Fp2EkfLg+VVTwYPPilxJuA1WdYXNOF9UYkWlJRT7x3xpXNxh4jjzISdRUDV9pfPkM7MXOVlT4JNTrTIhRJg8x1+7I6mHNxUAvABhymPdRtMaIs+yl99xWv6RVq1Nxrnvr8NBpyPc+OAR4Z6LoSIbETgXyWdc91ecQ+pMYrVEf1D0OV8PcA+S0pf2P+o+ovc6hluE7MwmtjKVG+lgPY1rSlwN5Px1FqQRqpzaDyEy8SIILJ6mE3meLVFyHzyLmI9RLiSd1W/2Gme2qWcoD0hrrbk93XRNYBnPk8A/OTD4RRnyCp7Xbg/Q//fhvDSLbUH0bxuGR6Fkr3bHbRhA3Pl7nSbMUP/LQcUIwz91X1ZL0X5lDNzLuoVCSOywOi/kZ88q1bqYYvdJreqNcDUvVMWC9/3KPHNdV3nxQQdJ6Zvw+9T4Q2hr+PWqmRFlvPYAc5NupuluvWQ2d/uWfHfISLIfgnZuND7ArbjwR+LyA3ehqvF0cx7oLCOjEGaFjV4/hdyECPpYmVw1c3IbUu3SO6HzGOqzJYiTjwJLkycFYkQSHjMm2FTYECFME91htflfl2TIVlveeUE/XxfgHyr46gqy3IhT0/d41jdbgHv/KGDy8CFfdw084Dlo8HcjOHYZ7L6KF7+pR2WjvLFlXUROMcbJqnLp4FZ4g=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(13003099007)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261009223027099003)(10067099003)(261021123027099003)(261102123227099003)(261021121427099003)(261026121527099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NsVcohK5GrLYQzB3B6+ySXjze4WSVtXwm8H+gvwkk9iBsc1Ab0AZxegOEM4c+0yIKGZBmY8T5laE2hKtEhJyFY13850fCzOsW5mg+xvFLpGyb8lzHexQSY9bUw2hylHtfj7HpM/rephCkXAWCcwWDFKKl+pWNURkvbesvrOCn9Fig2u932P6RxvPLReF7if9aTL/4xL12wGJJa9SyC2dE6M3aXpGzw+0iiD5ZJruaeV62pIooebe5QSV42YvHLA7U/ZlaOgrqAOLfvfDeHQwr6cw7LRrXdnqp7KCpp4Tmv9KtPzxxlNChXpwptbQ4ue+E6O11yQcSUgkIXLzEWzrbfM8KVlbnHXyougegyvSJeCaWcrjiaK1/5jFWOVnlbfZXkwjZhJzX51jG6rVqgfxwqoWrKiDaEqM6bQVns96ZKmF8xmKFF9d7bKpa15ux+KV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 22:19:18.9518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0d2f792-c8f5-4d5f-da16-08df44f8d2e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00006E21.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5A66AFD1C

sev_misc_init() and sfs_misc_init() both publish their newly allocated
sev_misc_dev/sfs_misc_dev to a file-global pointer before registering
the misc device, then return early if misc_register() fails.  Neither
frees the allocation nor clears the global, and the early return is
ahead of the kref_init(), so the embedded refcount is left at the zero
from kzalloc_obj().

Both features can be detected on more than one device, and a failure
here only aborts the probe of the device that hit it.  The next device
to probe therefore sees a stale non-NULL global, takes the else branch,
and calls kref_get() on a zeroed refcount:

  refcount_t: addition on 0; use-after-free.

The count stays at zero, so the matching kref_put() on teardown warns in
the same way and never reaches sev_exit()/sfs_exit().  What is left is a
leaked allocation plus a device whose ->misc points at a miscdevice that
was never registered, while the driver still reports the feature as
available and no /dev/sev or /dev/sfs node exists.

Both patches free the allocation and reset the global on the
misc_register() error path.

Note the differing Fixes: tags.  The SEV stale-pointer half goes back to
the original SEV support commit, but the allocation was devm_kzalloc()
then, so backporting the kfree() that far would turn the leak into a
double free; the tag points at the commit from which the fix is safe.

Found by review of the equivalent bug reports; no hardware failure was
observed, as misc_register() only fails here on minor exhaustion or an
OOM.  Compile-tested on x86_64 with CONFIG_CRYPTO_DEV_SP_PSP=y.

The two patches are independent of each other, and of the pending

  https://lore.kernel.org/linux-crypto/20261116203622.615371-1-kim.phillips@amd.com/

which touches psp-dev.c only.  This series applies on top of it, but
also applies cleanly to cryptodev master without it.

Kim Phillips (2):
  crypto: ccp - fix leak and stale misc_dev on SFS misc_register()
    failure
  crypto: ccp - fix leak and stale misc_dev on SEV misc_register()
    failure

 drivers/crypto/ccp/sev-dev.c | 5 ++++-
 drivers/crypto/ccp/sfs.c     | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
-- 
2.43.0

