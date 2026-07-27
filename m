Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010034.outbound.protection.outlook.com [52.101.61.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E09A3CB8FD;
	Mon, 27 Jul 2026 19:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785179381; cv=fail; b=GVpEHZpXrurJlnH7CX0O6OH8kjbW4fldwJ7yCPzMoqd95Imp/K52b7WtYARQCs3DCD+hpjLJNLJi/74CLkY+hLuO7cTY4w5G2W3dbfq6tntChMDQdZxcQaESgp+MUPIwcf4iAGd5yR1gzUI8QP5GtA1cGpz6Z0gJWXBCXIqLzOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785179381; c=relaxed/simple;
	bh=yGpgRR2Tp1OQ1UtzsGaGLUrgTKbn8zXl7yXwFjrtmBY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AeJsvWFI6EvdIjU77JzXXOJD7DcU1xM8ZDHt9AG7d5dqshrY9rtSkyRRUKhWO+QT+I27wzhffcUB6wgxhgwqbS/P9tVpMLS461vV4gjSWjKJbJzD10atcQJKzCYgUlPn7UuCL5vWYaU15WhAS08+tapdQp6LVeUwqr4sCSAYtjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DBcwlfWL; arc=fail smtp.client-ip=52.101.61.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DBcwlfWL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ix5wmdGBvaXLWZMmFfWjuJqHwfCw1kx9KGHiH5H+o34BvCMbTdTZBL/z2LOgOZ4pisO2OiBhaHt9gS/Dxo/WMN3N6/eEJpIJloMb7t4nBK2ifWh9N4Sc0o4dUg5Neu3h+yNAwOAuFHhOWPmn0mrwuPjXOjBoafgJch6PUuyBsZNubUVCxZpYR6cFtXJr/aRJbkOnThH+KbjZtx4BJUpKoNKf7mACc93RXV2WRGFX8c9mU6polqF//HcAqvfacH65efWq1BSWZPmBEVVlQdV040wTjiBU7ICNmABxTT+CSUE0MfPImGrSZpMAjU50FmzS6O+v7AVKbydnO9DyBC4l6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2ertTdtfu36UW6USeWyfuB+Qj9Pn1AcI7wGnonMZs8=;
 b=GpTgBSyNedtZdQLbxyza78nqTXTuw8npXSviHxU8w//K5DE4RSQSsiv2gS294/Ddb1BYTE+nt4WB1+cnz1/6gzkNOt7EGjzKQT4g0q0oWJezlFGNVIcEb0+RhyIFMOzs1OofgKEgSD/vVnOacq9JJu4IF4eDBYy0q1d+fonXslVe2tbmWEk+M9G3J2S6YnVEuW6gzB1+lqPmLHT+ZLQ/TS6+uyM5P7cxktp7Mf1Ilqoyl0JHuiuMoDFcAldg5ujUpBqs3bcvZ0uBT1S7q98mzvWUqFB6iqU4GxwNW5AjgisfjHXRoC6X7HDn0En7G+YVcCL8qGi4gGvCwhdmi5rHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2ertTdtfu36UW6USeWyfuB+Qj9Pn1AcI7wGnonMZs8=;
 b=DBcwlfWLOSUrSBMxFY81Hcc5g0FrHBd42joXfzqiQs8IWBqAHjJAg12Z/SAFSYZ47xaN0YBDsniOc37eb2s3uta49VXj5J80hFuttBcTTrf1GX8RTGRil+hOmek32MfriHWV2a+Tt6igTM8scgYa6jVexCzpDEwqhFAEeCM9iHA=
Received: from CYXP220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:930:ee::10)
 by CH2PR12MB4247.namprd12.prod.outlook.com (2603:10b6:610:7c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 19:09:33 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:930:ee:cafe::6) by CYXP220CA0006.outlook.office365.com
 (2603:10b6:930:ee::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 19:09:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Mon, 27 Jul 2026 19:09:32 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 14:07:57 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 27 Jul
 2026 12:06:35 -0700
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
Subject: [PATCH v11 6/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 27 Jul 2026 19:06:22 +0000
Message-ID: <5ee307f82cc9c30c32616e184f912451e6c61d75.1784844080.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784844080.git.ashish.kalra@amd.com>
References: <cover.1784844080.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|CH2PR12MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: 83a67380-200c-4a9d-1e2a-08deec129751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|23010399003|376014|82310400026|7416014|10067099003|11063799006|56012099006|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wM2SPkIq5XbviPMX/NYVxo1+WPaspOd8SKBl/PLDCdUVtg/qgEcDQJcbeReOu2TOX3lzSrt8ABlXFlfRk7jdkFcBNviAoeKfRk+5BkgfexQylkI+RwhAeBa8DQy+m8e4ZYlfte/5pcRnVtPzJArrgpL6CDwi+B5e69MGX9w34XRh46UzIfnGrWNRyHqnqwmofcYFvKUEGFchNBPBheXhtYhiXAqd2kr8rNcWBFrom7pzRvCOunO+lJjGLXAzhfc6uAOcFRLyJ10Douo0wNM0PrirA7OmvD0UGR1Pu8UqiqEPIzq7DThNIrbmv/X6ve14QFQ9Ag5AvSwvvdOZIBMrBb5+FkMwcWhJ4Xse0JhJisbTvPtYJ21wDNSz5Do3C5bwiMc3PWMR5cBLu8Udzspt4SRm3IGMBFJ08UTp7Rs+En2X11E2rXjbO4TJP7bTp6q6mfc/5SpKd+Opb8Bt/QwHHamiyCRWnWG4OW38ZswRaDHd/1FXhqys5MWwIhXiBEzqLkLq+ySOGHyvZwdrFE96RmE0RABSzVBAhqMQQy0q4vGk9uwrKFIjodqfrJS7K0mUzmS/b9RIXBYLfT0NjYURPuJ33CCAoaY7JnHwgkDtJJQRbsXTpxehSIoneokrSorJHu6Ia0ziyiiJSbiV1yTIJby7u1FjX1D1m2a4OZN9r1xkIA3pV/3EPKwOVslPA0oOg1UqLANjPCQqWgpDRozcHSdDMa0RJz/P1sTytvhl6MVi82FzhvcYcwaOxyl26o2W
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(23010399003)(376014)(82310400026)(7416014)(10067099003)(11063799006)(56012099006)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nFclOw7coi7hGyMuN9/k0l4eeUFN1qvjaEIVuw9oUBjRXIKLbIKLMia2dKXucGvKg5J819JYT163sp1DFcxpBInT3OInYBuMgRM5Z9uV7us2biiW95lqxiNpmQytJWtm1sPa/MV3+OKywxltC6D54bysJ1w7y74QbZEOtxT42D2N4w034t89K02ViVJLIaVOnci0hjhQXOeKkqgjI8pVcALICFnGl2n3hENA9Eo3yWZeH8dl5jSkZGJlWYIc4AwOGoOy8OA81Rs9U1POw3vSPZYu680zgzWbN/HEIFqWngFlH7ZESYNoI5rbwrxDvgumxk5Hg+va1XVloeQvhWgvofbyTUfxtjdYMi9Rnuq/bpPILnZygnUHaMlaHvqObLn6P7urNICsWHUbfdXNWyTrEbpwIKz/WVmTnhrcK8s/riBluEmbRTLXJU66Hxs4octC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 19:09:32.4928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a67380-200c-4a9d-1e2a-08deec129751
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4247

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
index 427229347876..c574849b1587 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2992,6 +2992,16 @@ void sev_vm_destroy(struct kvm *kvm)
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

