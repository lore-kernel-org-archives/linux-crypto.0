Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850871B6D08;
	Mon,  8 Jun 2026 18:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780945086; cv=fail; b=AqvQHwvH7LJwDuOY+4zjH2vvbn5/2xlltPbaeSA/xLuwu1anTjXE6ONVxp6jvC6L4AAuJ0oQ/3/ZtrBIbL4l4XpDjRgiRcyCKTR1YUu+cfSy8FT3H6/U8eqVIliZWhGjeq2uqzU2rbfJ9ELPpwNSps9uJGz4cy3UFdiilhdnVOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780945086; c=relaxed/simple;
	bh=vuGdLL/e7nbmHBQa3VVs/TpNpujz2G3aM+7E5CDFFTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrCm8A23qjpknX6eL+SFMEBkksM4tzKL/7KqXD4bgeMkZUfkMotGgAfCbul6Ob1CEJWRjl4wqaymCKTLT+QqWZbnmnUqMzTnvUJSniFoHYDb518Pp47EAtW9vy53hsJn0FJmKfaTgeQQqWhc7ukEA5muJBq7wiwABLfM5D0lsto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rmcXRIJO; arc=fail smtp.client-ip=40.107.200.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rmcXRIJO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7VvKWHPM7NrR5yk0dZZFJAQ9QzCv2Xj/Qsw6gkhOLYi4dRuahkSzUaX9YkYH83z2sFQ0ZzgDS4pv3tjNIo6LbRVzZFRuAg3ynHBsa5FFbb8YYIzdbMzyBnQ5tK1ZBMhs3oWVwqrb4AbhWuGqKc5zrEkAH4HU32ctsqiAQBeZMED2vbqYOvb6j2A5GK0rcDtBKLapVVjjudA7WoF78GDzlaKwtz89Iv5ZXPPG9bC+iRYoo9HP1OEpd8LkbTGDIAgZyoXwbCwM5LFhNlij6WU5/rJv3+K8yhIg1h7DdNMl5qVGxFXf9a6S+2MAzkj7Dg1IQbxVjgx0hv7q6T4rxhHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=t42jnKZFg//Ydp5DumS569RKpqvzWeoQ7YG6TKI+drfS9oANesVnWDQb2FsCQmR5GSLmF+Y7D8v3++y+1DQOUt2adOuC6n1T+z717Db2hB3I0m0N8fXLIHqJQqGeLcoXkcupr8pvBT27nBwG877EblTnGYDEIkK+T6hUT6l0RCmm1kP2vJNBSPqim1TUldOiyrLqEytmaTyPlJKH74Hvm0bhsKchhij+COn0/7Wf0AEk3sLihNoF/v6ePrB5iI2pmPxCJ9SrVjj8gZuECjep4pdJzYtExqKZRxYt0WkjlNuYV/fhr5VNFvK6nrubLVobm4f+3hWz9m64H5oHPJNreg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=rmcXRIJOyrQpCgtCSx/0DJp8cNDU+nYIIwu4oKcOazN5tHDKNZABXmRRAh94szTxIJJFM7Xygd43DGCz3KsGk5jCSOA/cumIG4d3Ro9yWrc8hrjGQGMizEJPSqT+Rk4D5h3v0iCFbiscnIILkaf1k6dqXMS+uWvArydZNuirhiw=
Received: from SN7PR04CA0045.namprd04.prod.outlook.com (2603:10b6:806:120::20)
 by IA0PR12MB8931.namprd12.prod.outlook.com (2603:10b6:208:48a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Mon, 8 Jun 2026
 18:57:59 +0000
Received: from SA2PEPF00003AE6.namprd02.prod.outlook.com
 (2603:10b6:806:120:cafe::8) by SN7PR04CA0045.outlook.office365.com
 (2603:10b6:806:120::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.13 via Frontend Transport; Mon, 8
 Jun 2026 18:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE6.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Mon, 8 Jun 2026 18:57:58 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 8 Jun
 2026 13:57:44 -0500
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
Subject: [PATCH v7 5/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 8 Jun 2026 18:57:35 +0000
Message-ID: <bfefc8564ae28a05be565d60e8857173d9c1ae7c.1780903370.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780903370.git.ashish.kalra@amd.com>
References: <cover.1780903370.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE6:EE_|IA0PR12MB8931:EE_
X-MS-Office365-Filtering-Correlation-Id: 60fb7e3d-aa0f-493e-7deb-08dec58fdba3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|82310400026|7416014|376014|921020|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	s5JkUOPMtFke8KANQn9EulPCa2LvDQoz8l0qBYw1cpN9GgKifluf8g3t6puDu/rqx5VS7pyy9edyxgeNh6/YWSIuQBqJSJN91h5g8B0vjNxoDh8HqblLfiDoyeqK1A7Vk30mYfwgdeiSFTUVfGNbmlbpXS1T15naKhHoynE8o0PWBLnohEnjce/oxfyRAlVuvpOPE5Vm6zby/06LrSu90U75/MyL1nglwRKV/LuAqMJgu089ToSA7m+hIri0YTZ9okcxm1UL1rMKF/BQaqO/7r2jCn04YS26QGG+9f7TT7UnxK8Nau1adyr68Mf910ypbejep9Rei1Rf8KVhXMTI90orRN8H159Xh/4Ml6RTB50x2bFOGYwcJK/vKFs6PFuaPsV9EKJoY6tleYj7DvSrBc91jjCRxxabem/eDBo/QQ9iNvNpHLJp9cJlrbtY5uUa41l4w12HkDpoOTirsUsmfvHhXFuQa7xd0sL13vcHnEu+S20uIIBdiKs1wit+kYzhglGLY4gRfF+DYDnKpMP6/GRkojenO2kCb/pnVEw7Jxq+JqYZL9Da4V9/GaP/VGykYu33XvXrqMJOH7HEMte6QG0BF/16boc6A6+PyRYUJ2GzsK0GaY9aVzqeIQVUwhUKNQLALnIVrwu06mQjItLMTaW7aIvjalsVutOyUMTidHdcMFdi5XdW0R2H7b7bIZXvioB7sfYe+cUXiNcyRR+TM3I1BiaMqpK9XvDmcjw7m9oL71vyjr+e+4Wr2D3u2MIn2FgxqGAmbEtuWPNa1966ww==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(82310400026)(7416014)(376014)(921020)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/0SpVZ53OZ6pq+K8/kSc0mlihm5XxSn6LxFrQeQhX07kk1nW+QelNYRMSF2o72HDzEbTpoCZHbsBSMWSQOM/afVe4m33XDgv003Y4y3RJsuoUUmY0mOQHsZxe1VGVspNFgaj3iDVrgD9zpMDXx7D60Do+0r3zIb/5tjvJU5ElynmliPaFy4lATncsWj+8A/uldIUx8EDiHzF3ry5ZOVAzm7wujajLcrWmOsD+acxLmHGSh8Nk7nOYivPIIkPdvBJZWgckAXG7GxHMsyRbaZnIpygFinl+U61bEx2KMBydLxhPxkp3UWksjiBgDV5YmSTPR66lvVtZmr8v+Yq/5wEEuafB3ddJaDg5JbXD4ephOAob0TxjZorcOaKxZqFvakXGFYv211UslQ9T/1ZrgNv9oFPPA692DhtD60jCPCDJpGjC8aQD0ZXKM+DvEGWCjff
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 18:57:58.8483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fb7e3d-aa0f-493e-7deb-08dec58fdba3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8931

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
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e107f368ed2d..29af6f6e603c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3005,6 +3005,8 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
-- 
2.43.0

