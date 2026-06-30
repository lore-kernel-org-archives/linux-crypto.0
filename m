Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985293E0749;
	Tue, 30 Jun 2026 18:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782843187; cv=fail; b=ngh6Zvq91SFXTA8fvLPIwKr4Et+hi6kWnxlSOLkbVUKtvcQHcrVVe/e8F1uzTgpBNhJaXJtnWMqK2iD6Mu1oq0vZq+nCfyb6tl+qHvR8ucdQlxX/w8M5m9XWi0+qG/cD4DRlbgE9vIBCJYbf6VMe3aWFuQDUolRGga6qWH6NizM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782843187; c=relaxed/simple;
	bh=yGpgRR2Tp1OQ1UtzsGaGLUrgTKbn8zXl7yXwFjrtmBY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PSvJKf/Z8LKvGr5AiWlRsCi6JrUyUfQE75fGxF9OS1IftpU2utHnxGCZNM27jscey1XhHezCfOSFYMEw9UHczyAHL/ErqUweVBeQBNocyKT4b0gLUIndIcmU0Clog0flJ5vDXfE1DJF81jD3CeKDPKHY4/oAlNlY3xUx3aFClpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=smSHbZQT; arc=fail smtp.client-ip=40.93.194.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="smSHbZQT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kcg125nfYEls3gDl7cDAg2bSaKbblglf9HATGKcm/M0IqI8T2/iSea212Ru1cEDTz2J6BF9FJLyTcV5VknE0fnbsMIU906kQIinZxbBoX/AS6LoCgEaMRjyq9RGxtIrzhn+YlEJ+18+T2DZoPZcANSkSjxIrjazBeE7arO56Xm6YQwa1DIVaWE2jtaPA4RBJwUfrxg7h/xdLaJME65rtUT54r/ZmEcGQqyfepr4ATRbEbXAGy5qAs5U4JOxSdAwvQseIqIkVJ2CtodNXxRmfJNMn5wC+6rXnacu2aEYHCe9hTAczj3couw8e314a2+txb8iq4aAI7ygzFfpk7IyB1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2ertTdtfu36UW6USeWyfuB+Qj9Pn1AcI7wGnonMZs8=;
 b=k7Xi/K8fY1k5jyhPyl0w280o+JTDtB9tTyrXdyz1OIxuUaBIIv/x4zUzGiFmnWnZRceO6jiQ9VtN+KP3epS4HReJQUmTs1cobObEStDrRvWum9X5HHBsYxWq1jeTDKRrlYBdLbl/n9PJsr/2cQUS/G5jEQJTVmgrTctUcZ35BYOU8e8sAUreRdPX3knyOj42KcAuu05y7rAO6db1NKTKm4ymH0Br0+71YrBu60jnhyNl8wXP6yilJ7unWZ5DYaKb/ngOyoiIRKBAoTwur/Mh5DIh8vPzF/BTH8gx1dH1hSJ5zTzCCotoFFWSFf7A3Whwjp2Ds8s5e5M0SMFOn1/paQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2ertTdtfu36UW6USeWyfuB+Qj9Pn1AcI7wGnonMZs8=;
 b=smSHbZQT5HTjrxy7lg/dclALedB78y0hhjEGLqP5Wd0fM1N2P7AZbRFEdW4qqFXvS+MfJmWpRr9i5od7q5JR1M9cwJKL3T3BjxyIA1itMeAA90LetpNGElYyF4mhTrjG9ExUoEQEeVBhI6q4dPjkKYoSraFPcBHaaJVG0Nfo5hA=
Received: from MN0PR04CA0014.namprd04.prod.outlook.com (2603:10b6:208:52d::20)
 by DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 30 Jun
 2026 18:13:02 +0000
Received: from MN1PEPF0000F0E0.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::21) by MN0PR04CA0014.outlook.office365.com
 (2603:10b6:208:52d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Tue, 30
 Jun 2026 18:13:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E0.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 30 Jun 2026 18:13:01 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 13:13:01 -0500
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 30 Jun
 2026 11:12:59 -0700
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
Subject: [PATCH v10 6/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Tue, 30 Jun 2026 18:12:42 +0000
Message-ID: <3a5df8dec32da5c31998bcfa775ca92c80cbc1eb.1782841284.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
References: <cover.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E0:EE_|DM6PR12MB4434:EE_
X-MS-Office365-Filtering-Correlation-Id: dab610bf-2917-4c3c-7218-08ded6d338f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|7416014|376014|1800799024|921020|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	esBmqA4QdQ3BJeu/kx4frhFrGsgNLx0J5clmZe90lGsNMVNeAP/xMIUjaTUOclrrbgkE57YxZpc7furYmcddAgp0SdfYStKehEtT2tDXTPbJS0uXFpSLvUw27uJH9FdX4heXMcy+KwvzVDXFNsd1/4bmw913VV0p9FHSMn1qKH3dgrgXbJqMgbKKsAWxUxw4nQA+iVXgKGfuXwd/xVDIfL6kPafRUYFLqkt5g+bjyA1gIZxVBCKpgRziV7PgapBNSx7kEX1lFkeV/Bcp379SbuwEY/19fFPi8ko44l0LNzWHE/Tf8wmGcL5AqvcwL+6wjPEOZHIJmi5DLslWexHRhudydhF7Gh0faJsMPjPsM2X3GtLAfgR6u191klR9wMXdnZoOgyj3yi3dgHGSW9vUSs9BGBtW0WVfXdqZXjR5TlLpjuqpYM6BY1GneLdhIV8kNPmaEupD0J/LI4U8DHpSyQqaUUjW2WO9it97o1HyVlUgoKXZ4VBhGE/L4UijUaJim605GyTHvwXFjN1jurTk7DRA++vdtKhitpFeR2YwKiiyO5zwMkpKRweaXZstkW4v+1KlB+ES08H47D0EC4Y6SehWO7qYnRz16V4hYX1mgo9jsVq0ofYSezvky9AXF85PynDocyf5trBEbTa6Veo86/uDbmbRWAhE52m0IpFR9Gwr+JduJrfBgsoS+i17jvFEcdxuFSBkgnIS8yHRYj/WL0gbXBzY6SccGPSDQZVUoD7mJCp/etpUVrgR9Sl2i+t/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(7416014)(376014)(1800799024)(921020)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lumISmRii7wBmXI+zHG5fi3ZzSD3iOhsXkJtgPm7Xvq5dRZF7CKL2nh0XAvrD3mBUaV3+we22TjJ9VPmGJds0Eyn7pC574owwYIQyaWEX6VKbWHWkG9eJBauCngeH9B5oHBP5olL+rrrJ4/k3ekv6IOV2a+zHntVFzAz1ceBK5X1YH4ppQ4elluDRt7dUASZkxklEcaSaRCiFY8SFmZYyghZPiGXdoX7OVozbmq6PbomC4rAKs6lOwEfoWOv9NF71R154eucUdBHehWwY5caqglR1NndiyH3mLR08Aw1qsFFguVJ05BskQwBGHWDvd9kgouCTqYD94/gsixpNV/IjYqZI4t5exLoG1s6gO8CIsou5Axy5NcY0lJ0+0jJGi8bAxYs16kIZbCHEcRsly0xI+MaIMZG7YYPSLLjHR3/QnmZahTGkc6C5WEIelp5JZBj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 18:13:01.4556
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dab610bf-2917-4c3c-7218-08ded6d338f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434

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

