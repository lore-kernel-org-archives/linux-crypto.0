Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1EA224FA;
	Wed,  1 Jul 2026 16:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782923991; cv=fail; b=CUXJom9aA9C9oH6+cMgpc8OD4HZcNG+ohyBlEMNduX424xjb8gmZFPF+WnNeEgyOqOm1aTtV98RvYpDpsPFkAMQ75XikeZtXkuwBUzqYfbbcoNQgnb2N5/7HJ6YyshfSM5KyEd3m9QPJI0oCYnncELb/AJZUTKAbiHy5rZ5Hddk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782923991; c=relaxed/simple;
	bh=tgdNAoVZg7mplGsWra5QTHD8JRendvbnojlpPuxPFcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uhbNbUSJKka35p0GAeNWuLAZmnT0iRFoDctg16JX1Qps56VH5QT1rGyZXZmqEx3RI4b2zrX0DBfCQs8oFF1T0xmNDVjO7IRU6+76NZGgTcXUCacCAVB0vU6+B36zHULFZkFwF0riS8eGV2rV1KBjvnKr1CGMDJOyEY4l2skou9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HykhPurz; arc=fail smtp.client-ip=40.107.208.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HykhPurz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WeWuAfcnUh5EW5tNRPIKTtvg7kqk9WXozrCdzF/K3KM802hIMzQKolupZWvZ3NMQs7MVlIM3MNQaVNGuFHC294oXxoFEZ9KPYuYnHKOY2K22qYt6QclT2plcymRj+kenVD/Y8NdxAEeN2jkQeF+PL/fD4n7KF4p4uMG4En1P7MQNrNqv0i8qiFPJZmAYULYRaKBQsvklz8jeMHniMdS33w47/fxtjYRSw0hWwc45sTwNeCarwmA+Ak1oQ2RiEwy/TQbcqb2NToGPeU2r4woFKytFod2b9DKvCk2aJyMRKBCzHtRS3ILO3daNo6OF+fIr1FdL5+WK9RMtuYInrxz/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YP7lBkCMNTZySMbtLV6SGEVf0BZgXUulJBWXg0Bh9w=;
 b=oCcBzPwrzQv63YAw0a1XY9Ou1eaA5gN3jnMvz+QvlYOMNxRwn1Rmdxb/oJf7PfKcC+Tp0TfOXT4rzXNhmb4K/YgOMbBDMdwBGoPtz89h7QalM34tniE5qyBfyHKvYXO0F9myiKISQn2TBi40twxT3mBRCPzd3CGq3xLyxgUagWmaVqnkJbXY/ICDtzQjMv99XrpBk3UAkLWRogMfzQS8PBA114DlY24AdmjQxzEIWSZVMcOcJtCvNmlZcltlnkY2aCQ0JwMcZjYgzxkUYT6PUerJZSn4JKz0eHoq+nLWQf3JWdF6HAem4dpZsv7mF1Ra9icxJ48EMk8pChNLqg4UMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=fortanix.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YP7lBkCMNTZySMbtLV6SGEVf0BZgXUulJBWXg0Bh9w=;
 b=HykhPurzecS+njchQvFD1L6G17Sa5N1GYZ6WkCV/rKxJ8LA7lz6djWnmlo8plFTv/MseeVhSiMKbA6gS7NaEZlAHNXsP65A9R5dZvDBTTWNgpxjkIfmKpfPJXlV1Iq35loVTJcZYoHHPjqs9jd471WXvjdXVgLnMtTY6bIot2cE=
Received: from BN9PR03CA0430.namprd03.prod.outlook.com (2603:10b6:408:113::15)
 by IA1PR12MB6387.namprd12.prod.outlook.com (2603:10b6:208:389::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 16:39:41 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:408:113:cafe::8a) by BN9PR03CA0430.outlook.office365.com
 (2603:10b6:408:113::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 16:39:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 16:39:40 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 11:39:40 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 11:39:40 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Wed, 1 Jul 2026 11:39:29 -0500
Message-ID: <8477525d-55ad-4fc4-b7c6-05bab3d7a861@amd.com>
Date: Wed, 1 Jul 2026 22:09:28 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
To: Jethro Beekman <jethro@fortanix.com>, Ashish Kalra <Ashish.Kalra@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
 <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <80f3f279-d70e-44d7-a179-c52068115e46@fortanix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|IA1PR12MB6387:EE_
X-MS-Office365-Filtering-Correlation-Id: befb62dd-f114-427e-2abe-08ded78f591a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|7416014|4143699003|11063799006|56012099006|6133799003|22082099003|921020|18002099003;
X-Microsoft-Antispam-Message-Info:
	p1IR1kwbCwjJ8H5UaRlfSXVrNfPJiuViZxpdm786t726gbg6d8u8PxSl7BEIfKp6P4Ov24vfwp33Zkox22ix27BibUC8J7tLPr/gzynIQeCTwrS2Z8xo1qVrbz/VPXGnNiwyfIvt1ouZm6ESMu6SKetwsCH73SUSGT4S/Z51QSkmo8LqF81S1Bb083n4syBJuYhucXMcUSxU9nbBKkuEcAxV7ymRJM6XL23vltonYOqGcqY5ZOOt4Ufh17g/TqA/z7m1jmyIaTHmLxb+aEF9jNpWwAWhnlhtmZuximQARHcmXaOIp8Sz3FsFP8nb/N4WigOS9IdAtY5j05gfs9fdOQ8AWx6DgkNVeEJOyFHTTH7cRM8YOYLlpG1JhYSjV0bblQGS2LTCryR8pTXbwCF4USehefRdGKshzNXyNk+5DkccroRpaibhmq+rTMa5FJnCr5a2krgkeYfkfAxjD9Rc5qXSH6VleWCUKq2aYJxYvNrXZdwPkVGkK57KaFFeIyJtS7urTObd1BMHpXwKgkUzMXzVgN3Y3oW395/BGvPLcd6Bc7gYFYrpcFq6sjw04jaAWAYkl8hybEwLtdbwI+j7RxD+Hy25VDc7Y3eEExy0IzvzKDdLdZqkiE2HnaP4QFVDlwrlDzDUy3xQMU/2tczD/7r7mNJmY7OMbXSawMBzkrysKdRhN7k6C9h79FHZZvbqVuNc24adURkMKm2EBtPB3QBvSIVJpbJ9NWEGYi/lAel4eMgTnxw8uIhKnkyeIwW+
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(7416014)(4143699003)(11063799006)(56012099006)(6133799003)(22082099003)(921020)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uD9BHyKly7gaZ4fFClXwFgLBsEcUPLMvK65o5akj8p+wMyTDhMDLs7cXJrup+yt/dC1XCC2YgzK9w2pMqAy67CoCLh3khFV1v3woFE2S8LlF/gN+xbmELP3WKhj1tv3hXuhHOw/QmC8Bf2Wcakz8bugXQySrC7R2/F0OXl2IMLtICzefz1RmaAF/9A/xeyQKL0xuACitQx7rkwgA6boeC/uiwZpENrJVfjO58h31wvghORwTEk4wSaDhGrY7bmIRMUOY8g5+yfVQfJlDqKcX4vCNzSMsQrcFwGVdnm21QJhAUtgB5zx0JV+f+75yJ911UeKVYVxLhNwVOVRVaX/DHgL29D5JWdWk65fYbzPqzCJLcI4YwavzjhgL3t1g5H0VdEsOzp+XzdItxe5akzFSjRb87xXMgfSBYswOuZLbF4rEs3hYnHQ7Fnt+3l7QofxI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 16:39:40.8085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: befb62dd-f114-427e-2abe-08ded78f591a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6387

Hello Jethro,

On 7/1/2026 3:10 PM, Jethro Beekman wrote:
> I don't believe my concern has been addressed
> 
> https://lore.kernel.org/lkml/0df3b665-3a9c-4c46-a7aa-14388e8e1577@fortanix.com/

Quoting your question:

> I think this is too broad. If I have a hypervisor that supports SNP
> virtualization, a (non-confidential) L1 guest running Linux should
> still support CPU hotplug while also running confidential L2 guests.

Ashish, Tom, correct me if I'm wrong, but I don't think KVM exposes SNP
support to L1, at least as per
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kvm/cpuid.c?h=v7.2-rc1#n1221
and only SNP initialization disables hotplug - not the other variants.

L1, running a confidential guest (SEV/SEV-ES) should still be able to
support hotplug since it doesn't go through SNP init. Only the base
hypervisor can setup the RMP tables and go through snp_prepare().

Also bsp_determine_snp() should clear CC_ATTR_HOST_SEV_SNP if it
detects X86_FEATURE_HYPERVISOR so I don't see how this can be a
problem for hotplug in L1.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/cpu/amd.c?h=v7.2-rc1#n368

-- 
Thanks and Regards,
Prateek

