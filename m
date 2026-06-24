Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80262882BE;
	Wed, 24 Jun 2026 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782338371; cv=fail; b=KUgmJcQ42Y+FeWtvPUqEvKTPE7MssS497CdbNKGj2Xd/AtOTfSPZrQkXYwQw0eLRMwxhzbxgajS0DvdE261137MNRMSSQnim5tyeG44EL+9lD/PCU+cVP4R+gfwzaxsLTtcB2nXfYIiqfrCzhT8r262aYp+GmAb+A61TIEib0YY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782338371; c=relaxed/simple;
	bh=9aeeVgINA8fs1sHlIJJlRvorlBLS/TmWQmWmQr7mL8A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZX+aEXB4HrSxehDNjDnhwHGGeTv19M0wR3N7cnEGXtJ821luCRFJulZKJ6rfQFoe+nqxJ+7g9OKbjx4ginjax74LbqNzE90rkvcZUOVBOUa/oqaE6eOW+grY5UhdASH69KvRZVRJnq4/7/VD0Tir+xSDZ3VU9egHzba+5TJ9RB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jmhKRJ4p; arc=fail smtp.client-ip=52.101.53.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jmhKRJ4p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ISuks+myRAkaIL9TXsifxIbRwQh824pdxFpB2H/UqeLhhY7kcm0n15VrQxenKugRfs+HA7nfbZMcf9tiFnI7/wurl3VxPPjPKAapQ2lenop5+djeQZZ6UGMRt9XBp57xvUvsWRAFnVG9h84DH4m0hvSy8DGNPcUjOvYK3K9gOFnRZis9xFrQbC4sGRSK2/gXa9uVz34/hDqeAtEQe49UZxHT91KksambSBehFqJUh3jxS7vEQJwUSjlp09X1nvmmSUUgGrzxr77sXrsZOdle7KNwKUUrZ9bTF/nOBITIT2oq6/6uGRsaaGgRfrcAHC0KhRqCFxehOQCYMoWah5mosw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+bVTvWbDmLjm832j/kV+GkLHw0aNiUZ3r64Lre/sDw=;
 b=kDywIkgyNs126HBEtXaOtqduqBGf/kTjZAO84JjILuVn3j1AYzqwk2+faMbC3Ze8Vglm1b37aauCbSWpLI21hr2Ix6zM1EIiEFRRtVVu7iALFo5lWmS9DxhfjtsqiHTrw8iOgRXTvXu6Y9v9OSKiqph59ZcLYsOmbyf3UyjlFTjluyIOb3BOmREY2vDUL+3WDqqMHSRmIZb1+zowIbDzqcpBPqm0rYnCpaTjBDzp+R4fIgtgws9HJh5X6Nl/4FWaJ+PyKGeIIS6S/UyxZkBNDayc2Auw7hKr3GSLc0f/TVFRn7N8wK1jLH4OC0YxYCBDI7UQkJs9Y+ak7Husa9uyiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+bVTvWbDmLjm832j/kV+GkLHw0aNiUZ3r64Lre/sDw=;
 b=jmhKRJ4pnK+EviKRnHzlsXPV91m4g0Xk1UhVsjEVPr7S6eAdcNQzjkL5MX8f9UYiPVrJDdzQ5J8NZ7OSAby5/HxH030YM0UgPRoUcF/kkYqUMdZUHXDjYeo4jCBTqZQ8QOnjPITVuoRmH054Q0X5ve5eNWyUS6s25+8jEnzHfgs=
Received: from BN9PR03CA0126.namprd03.prod.outlook.com (2603:10b6:408:fe::11)
 by DS7PR12MB6358.namprd12.prod.outlook.com (2603:10b6:8:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 21:59:25 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:fe:cafe::5f) by BN9PR03CA0126.outlook.office365.com
 (2603:10b6:408:fe::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.13 via Frontend Transport; Wed,
 24 Jun 2026 21:59:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.159.10 via Frontend Transport; Wed, 24 Jun 2026 21:59:25 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 24 Jun
 2026 16:59:23 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v9 6/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Wed, 24 Jun 2026 21:59:12 +0000
Message-ID: <df21c9e39f42aba758bb6c0100b2f5c17f019cc9.1782336473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782336473.git.ashish.kalra@amd.com>
References: <cover.1782336473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b3948b8-43e7-45e4-ceff-08ded23bdb0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|7416014|376014|23010399003|11063799006|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	owGyRm1EeaVSADWu+qx66lT2903jLGrnJJOYun5eIuBKQ5dGvPHtZ2V44klBfmAHR6cNBPJZ31FYKScnplQy6jgulynlGg2mQmGDTVNyRCq2epKrVSngRs0ulRclNJmP4hPX9rmvZKko35kN3Si1GmFpndCPLDDcV6/+v8/a9Q284/iVrCDlzCqyeUvQVDwPmvaayXEmafztfQOqqKeFGW8UUfzQURsWhBfvnphA9MyRpCHPuUCbYaPmU2Ox5XY12YdswSsbUlVwYBqFy1af2949D3EPYRX3D67W69f3hu0xwWtuLAZAJ62rqhw1Vmo/TKCzdSU4u3XAMTl7K15gSZOPOJcf4mBh8YGUtpTRPJEHn0kJ9AZm269aowqkwaqYv8advi0NOii/1+Um2B824ySZFoZ3lgtw3WMexj5/G/9UonEj98ByvmMZncQMaiZQ8kJWcP2a7GcMs+CqnSGtBM3M/Ehx8EvTtUYYnlRzhCujLGE6Graxy/Vst+0fRLPOyWH51mGGBjvVwap+Ou2lpp54vUstr8yeZexooiP7jqoBgHy8S/xm5SM6/rtSPTjXbx/EaQHyYdz5bzDaTemtOZxYfDC1tp1KXZpSJwH4RbW4tzLBL69gIq+zykxPeecy8EneHIZ6Tp3heiLBv/SYhWOVgql4VhFHc7hqTRQPTw0SpGw1YgPumDDOBxdGo1oltz4fYroKeM4838+4FJ+LWLzD9QNawdqvcDKtYPf4Xt0oJ6MSSGTPtWk/BC5C+sxo
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(7416014)(376014)(23010399003)(11063799006)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1nqkMn/Lj/z53Mgj7H3tL2Fh+Li0sv5MLeTUFP6QJiF/mEHzfoYo2JzD8HD592LHvMdvMwi0swyYYakYwzDCXXeVoJs0rrR1OcFJzXCOk9zmPzrDYC1EE6zauGlbcqwCQlkS718RKs2+06QgjZohhMfrfq1WDPI3vXP9DfjKEQ6emxdxiUR6+djEgDD8VxMxHDnqlzccGWDKu5eAWD81GtweSxbJoNCgoP74WSkkyyUt5r5dMDme7fNh04MlW11Abyzm4zHnAb/vMpFtR7OLAefFcebgfvMdYvFeQiKSfxvH95lcoq3FMFh5G9tirWk1e781iekke6dUBsC84Wgkuzyp6QTsShATzXd3thaQkynr3ccNjdU9hbl3QFlUhlzCxeTzlVMfh9c4NU8c8r8xyqKqJ65q4Cq5m8Z7IJbTc13DKtMS0yU1ZbBrcMT6A0z5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 21:59:25.2999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3948b8-43e7-45e4-ceff-08ded23bdb0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are converted from shared to private as SNP guests are launched.
This destroys exisiting RMPOPT optimizations in the regions where
pages are converted.

Conversely, guest pages are converted back to shared during SNP guest
termination and their region may become eligible for RMPOPT
optimization.

To take advantage of this, perform RMPOPT after guest termination.
Do it after a delay so that a single RMPOPT pass can be done if
multiple guests terminate in a short period of time.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e107f368ed2d..23e236b13ccd 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3005,6 +3005,16 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		/*
+		 * Perform RMP optimizations on memory freed by terminating
+		 * guests.  The scan is deferred, so it normally runs after
+		 * sev_gmem_invalidate() has converted this guest's pages back to
+		 * shared, and picks them up then.  A very large guest whose
+		 * conversion has not finished by then is picked up by a later
+		 * teardown's scan.
+		 */
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
-- 
2.43.0

