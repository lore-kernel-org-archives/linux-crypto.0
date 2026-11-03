Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793674754;
	b=1XaidG+5D4vwoLx/kJ+cvhzYWFx2TIToUZWJ7iYoZVyUNalWF+YmZa64XQoHeULHWm10
	 R26tMKri4HExmHclOpzQwaqjrJdqQRAFuvFjKiaJ/QBXgmahrmBzxFAFVq4UWNmMcCOes
	 isuNQcsRarCwEYDC2HPa9KZ6vv5vAtLkQu8oVvflcHoKeW91YnXzU5iGLw2twKPfBOqQ1
	 piuNKz272Ls6FLvENqTMi4HEwPLONANd/jDvzFcjdYyOTw0prF+FlyqTp7065cj27Ju7a
	 haTmMyZgGVFrc8pLDHllLLtweWgV63AZJaEpNXaIEW1rV65NPfRxZRx0+5AVB/Wx6ZQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674754;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=wh0TOOlj7BCH1MWtrTapAXDBNhhWkpyV5zJBOnW/Hq8=;
	b=GBch2qMKLqxRJwYBVSTZbEXjci+KlO4GFdiZpmotEQEOcVsVnf8/0XxPeQJ8ZMwVQ7Pv
	 6TMBHTOYKkshKIYLEy+cQnqIYkHiWzU3mZsHcoWlzSuMUimP/4vsFBJ2I+nzhlXiFY3ny
	 x7RVD2vETjfg5Rm+iFosNMeLUk+dJmPN7FXd0c5PuWFrUXvAojdyhCf1bzcWj79j3wHtx
	 gMR7fuPEZZjvkHOaLjs0ksQ+hq9a6BsCKjrCgK6uWMqoRH91V2zIcJKw50JZSIwyQ1xT3
	 TYG0SNvxhNWIYOJCn+6xs7uKKk/Js8bWDLzxBFIijOzZ930+uE3TUtvhrs7Xp2PwhEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yvZWa3Yb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.47
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D353606A327;
	Tue,  3 Nov 2026 02:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D353606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=yvZWa3Yb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lRU98A4d47/HxaxPizYunWQw/i8v0StuHZLjN7kPfcsCRLEuB6YFABlFP4JP2WjzMxPLhIIO3gANvTQQl84AwMM3REpcTyDYy2JApLTp99hTYfAFofdcZ5Xy7IzY4vdzx45Zo0UY2CxFxNnKasghhLmuJ17lBY6GthKyWKsL5MSRXyLj9VBIuU8iwwc7+7lsgoGkbZtuXgnhiGi9imaDKB1e50u8RGYtZCkep8HjlEyIPyEiuL381RVv/ilWlbKhTcifKeWO0dsCMBDxLOjOFDBPw+425Bp+FPP/j1J1ZtSL/5I4riGpdxDH+y4FCgdamJmU6bgTlGzDUJod8YAE6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wh0TOOlj7BCH1MWtrTapAXDBNhhWkpyV5zJBOnW/Hq8=;
 b=Gy9v3ilM1n2DIuUhi42lH9H82+8ctFBzXrXWJNSEWYzFLzPAVuLLek81z3m3EdJldD5kruRdPKzf3/qm8/A13qKxPbBxMrjp2/0IL6JZ5YAPEYTfQLxvtIiBAXKyK5q+Vde1IXovWPzgNl3n2Z2MVtbJsE2w1BOiIy+nFeIcFpPhtrCiekZcXJnGA6KNZqO+mKtdvoDe4V4+hq/9EkwJ1jbL7XsE0LfGEBARyq24ezA4bAOWVIbM5dZAOhEjZXVlR4WxcP1vp7FAsdaFJUVh48w+m3FJ+3sOTPUns8rjIA2BAlL/qphJYQTrLbWnC435c2R9G4FC9MjjLPLUS4a8kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh0TOOlj7BCH1MWtrTapAXDBNhhWkpyV5zJBOnW/Hq8=;
 b=yvZWa3Yb+iGaNydfOktv7nxS2VDJiU5g8iRsf3auJkRdrGGr4knUmHRCo6IHyGqfccpMxTTutgAjoza0kI1YAI/E4WdBBLMpw1WbBSAW6DtIQuEvXR7M6lF7dcgqF6azUs6+jm+ODdqAbNf0It1uoO89PrsDrKfyhYEi3Q0pp+I=
Received: from DM6PR02CA0144.namprd02.prod.outlook.com (2603:10b6:5:332::11)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 02:58:22 +0000
Received: from DS1PEPF00053451.namprd04.prod.outlook.com
 (2603:10b6:5:332:cafe::e) by DM6PR02CA0144.outlook.office365.com
 (2603:10b6:5:332::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Tue, 3
 Nov 2026 02:58:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS1PEPF00053451.mail.protection.outlook.com (10.167.23.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 02:58:21 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 20:58:21 -0600
Received: from [10.136.33.166] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 2 Nov 2026 20:58:13 -0600
Message-ID: <4543f87c-cd29-4d5c-be8f-eb6b5477f4a1@amd.com>
Date: Tue, 3 Nov 2026 08:28:07 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: Borislav Petkov <bp@alien8.de>, "Kalra, Ashish" <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <seanjc@google.com>, <peterz@infradead.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <darwi@linutronix.de>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>
References: <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
 <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
 <d81f6807-26ac-49b9-a205-c89c394ec1d4@amd.com>
 <20261102193116.GDaujlBJc3XjG3xzLj@fat_crate.local>
 <9ebcb83a-1c0e-423a-8730-eff6b710634b@amd.com>
 <20261102214343.GFaukED8ep3EMmQxfx@fat_crate.local>
 <30947e17-bffc-4c70-b19c-56504771c9fa@amd.com>
 <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <20261103004531.GEaukuq9sXbCs_PjfL@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00053451:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3099a8-4989-4ca2-0033-08df39565246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|36860700016|82310400026|4143699003|56012099006|11063799006|261009223027099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dnIjbRsmioEMJuirqS31ilEh4m7QYK/9Khyqi2VZZT8D4XByk94VhadUfaQSvweeaKNhDk+seJf5hOMGlLOE7EzpZMCLmw2KY94QcZFSwnztF1dsnCahJOLeAML4pvyc3+Kub4nGIkj1cyB7XY5L3gLn2rOhR7wR+EPcvQxa1PZ979odqjnSQJ7GH9m3fRujZblMsZu1QzDKDJ/Qg47sqkf1DTSQBl4Csm4fTizGXugMtkoW/iXNdgaSJEdDWxaTq1PrNb7iJ3rTguoM1B88wM4wMMDQX20DrSdjmjxZe7lXa1YJulLy5zPGRkQ5lBYuVhLERWnwKo/p1WaZ2DgESdqfLK4NuJdEbaFG3l04vao5kedv9Xkv+VFvRHofPjZEsty6WganxBHmT/aJqtJZdNDG4a0nsKytxWavSDz81Fdend32Uii1vZWXv8tlc63EJ+syeXcGT7vOssyjM46OOyZMx+JIyMXZe1yPVSORExdB6/hZxSZNfHafSIQDG03IhpU4KDT2r53qF0j3Q/Le994IZp3CAzHIz7bgNrG+W8i2NC4CKqq3yafqf1CtHdGvcY4H8gXkqazZtF18RgPhMEnHgL42cOF1bkaUNQjVuoT698Hbxo3yS9tQO1GEZMdHOVkYieyjQ4JJRjTAV1KR/cV+/vgF6zC2J0ydxoQn3K2gZ6z20RbYCShdNtfJy9kKYxsUj/9HA/A2Hwf+2W++bQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(4143699003)(56012099006)(11063799006)(261009223027099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nq8XO2BurgM+RunyL6aYQT2nppXosX1lTC3chrNz6plvRBIC0P9JFw2+akySjRAOlSGCdcfZVtlKM5/cRTcSael0mbTBCK2IquiGbIG2V9gKCeDs4lXpY5pWkACj3nnl9ax+PGWQeQ20d5h18EvQKeYvxH2eCR+PjRAArDDuaAXTysJ6wmwimWQrR3OfYjNyVOI8hcxGuDTTYADOENbHEOhTbGTjNm3OAW2/kXBFVyGvyfXUjt5bGOgHSJluczXsuezrVvjje4F3tldQe9Eul+2Yp98nWXEw6FRRWmF92qAuRubyv/DOCfwlxJ5irRj/D4X7Ja41vuwgX+0u6lxDNHV37mG/y7EGAy2TQbgUmxNU3lV0DtnOn1skvfRADoqGjBCBYYp1DYW6QZcZZ50/ANO7IPXL0SA8GUcoWNt9kgQI41Oxi8MwvVxEzdDx42sV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 02:58:21.9400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3099a8-4989-4ca2-0033-08df39565246
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00053451.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818

On 11/3/2026 6:15 AM, Borislav Petkov wrote:
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index bd70c4d0b774..417e6a41ac60 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
>  	u64 base;
>  	int cpu;
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>  		return;

nit. We should check CC_ATTR_HOST_SEV_SNP in rmpopt_init() too
now to prevent an unnecessary workqueue allocation if
probe_segmented_rmptable_info() failed early.

Since it doesn't change anything functionally, maybe Ashish
can do it as a part of his mutil-node optimization series.

>  
> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>  		return;
>  
>  	if (!rmpopt_soft_init)

-- 
Thanks and Regards,
Prateek

