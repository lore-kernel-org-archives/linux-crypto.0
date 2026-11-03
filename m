Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793716853;
	b=b75zWDsjUfnSLr4MjJIOGtFrLZc/+lmqtVGpqC6A2SVGe9fgXiVdgl2ttTzu6b/eKFR0
	 IqMRrGtYU5wIB/BFhyH07jxDnrEaoT/qHY+gj+GCPytCtNO3KbmN10CEHXafj1fh10F/a
	 ecU0uvbriTNKmb1Do7KJqizAqynIwfkbYuMzVM6YhcVkJ+wigimVV6aOs125hd6Cc+2tm
	 9Tblg2jTkW9y2pIGt7X+1eeiCqoEI3wSj+TSC9Q4rCQNW8AkYBidehHcuOCnVjn6IztDP
	 IpJqjc9PLkOCxA5nqtMwPtgfuMUkvMj+m6PyK0n1ijTaImxKZ64HmGkJw1jFIPTnSxg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716853;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=FmRNBeRA+//56eJGGkRrV2/wrR1iKYeXKTR4XcSkew4=;
	b=Sdb+zNzmRSJ76zEvNefcrfufzN748A0WiiBMkGy+0Ua+HtSrT6k+UYZjbAUmA+lio176
	 Q1HXX3cZGxCQnnGGSpKtZ/Iml/AABUyqX2dkjaAI37JRD7zlS7P/NayEiwe3QDljGcRkJ
	 sPQ4Xlh9pnvsY3yyOa6Vn8Pq+fc/4nbR0soVDxBxljUwMSBd/0SxlcENeSHmxA84vpMCx
	 +YI5NKSPfPY68+yeeLevuR0mv2PtHIvV84grYmcKoBsz9pfCZMRSocC1+VXg8c0S1cQsO
	 sGpAb9vd+Yw8kcbarTIQb9euZCVmeJAoKOUPvkKUeEjnZm8sqvMbuROlnjm4H6eKbog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=AQHLnfea;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.71
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013071.outbound.protection.outlook.com [40.107.201.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1853F606D810;
	Tue,  3 Nov 2026 14:40:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1853F606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=AQHLnfea
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=StvcTvXckx+W+2o14fijSSBK/LwpGFqljTGgDlgagS3mzix/4UImgOCJ5NYuWZphBUs72E42X691GVdiLTyV/t+1FGlXNVwuTh0JEbk45PA8BVt6E3Vm3hD0R5KduMJGOpxIR6ly86pS6dmYQc4vPZtG6iiP01CHUiJj4nT41/S8KQR8+kUI7HuKwsWU1CP80hHLn6LIfN12plHgJTorx1rR74LsCQAf4jfM/cfdwD7lRt60kb2Rp88Z15dkPgiCalksqxf47OGgTfseMFmuo1x8t3fdeyFTRP7rKQ4INjhS7wEjBrLGgHhQa1O5STWSjEnuy1eWuFKsg4bVK98G3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmRNBeRA+//56eJGGkRrV2/wrR1iKYeXKTR4XcSkew4=;
 b=VqCcqTq8a17h4LegQQO8nBo2zM2zKGjOkfagcCKQTscEozUJXVMCgBIe5wmnaNbufdcccT0Yb/p0sZQ4ewy7kHB1h0wHd4MyReGGzDw3rQHeb+8K4JohoE1q6M/KRubl1LI2Rpiizg0bI5RV3fukUyuvfpzXiUz2ZcblUJ1I7HNqQlfnyYTPliBudgwq9PU/R1lgSozemZmh0EFZFhg05mnLhS/FLcH7kdWupk9N8tusj+4lFI2AK2kKUghgR5SfmPAzJiqsujmYo8SMcHytVfPDoupzxCDSa3XafUilGvWkSgBYogzhNpKZN0wP1CG74AMrySQe0cUZoBM0YfsQYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmRNBeRA+//56eJGGkRrV2/wrR1iKYeXKTR4XcSkew4=;
 b=AQHLnfeah6VFKYTQm8L7mTtVmp/q3sH1drJ3+bYVFESlZI9rgPETSjCm9c043qXSxY7Sw4CO4WXvnsMVORrdm53qgggdD2TMGs/qOIg9WY3tke2ZzCRheCBSivSJ9A9hXr2QCrr9h8bywQdkGQMhb3xFtBbOxHn9Es5GB5AR03I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN2PR12MB4487.namprd12.prod.outlook.com (2603:10b6:208:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 14:40:49 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 14:40:48 +0000
Message-ID: <be98c0de-e104-4c4c-8346-12f8b9e847f6@amd.com>
Date: Tue, 3 Nov 2026 08:40:42 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, tglx@kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
 pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
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
 <4543f87c-cd29-4d5c-be8f-eb6b5477f4a1@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <4543f87c-cd29-4d5c-be8f-eb6b5477f4a1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::24) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN2PR12MB4487:EE_
X-MS-Office365-Filtering-Correlation-Id: c63d556a-6d9e-4671-d205-08df39b8739c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|261026121527099003|261026140227099003|261028144727099003|261009223027099003|261022105027099003|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IOY/FPmjzttL1E0rJI9Is/SygaqNwfnpOJ4iKf6wJ1oGHZT2ftS/r542dpce/VnGiyVrbdN3tdfGa4hoEKaYAhMHDuCSwsMzem9spxzO5gzmqJbGHAsxy+4m4NLhyeFZ7B8KtVeaaAyGF5jT8gEqBUji/reZyByIsPcuwDuS4Z4dKr6d9U0blHMh7Wc40DP19x4kEQ7R81FQgTlrkr4LbbaJMk+Wmi2lMYl0GcqoguuX4kpGdH+X5xowmtX79dCIwFlpx61Q0INDlsFgQenh+fICe74eTv7zGuokyVgeLVRcge9zIA3qsoFhgYA4ttR+0HETFQQVqFb5QGAh4n+MRGKj689nIkbVOkrEHpdjMUQwuHQT25ExzCVYkbAHIhy15F18URQf5AqDEK1Zx6hftB6LjRzIzqNAU48Njeeqy1yUnO2SgFtvg66nzQRT0RaMTGW2/gnVd/DnC0igSzGd0ZNpIDjO1M9jeT0Q9/abncuCt7sLzCjYp8zPf5dotPlfnGTXAJTvjMMFiU9aEdz1IuMe4TLDcSUW/O1CSqx93rrLaVKxjlm+ATuvKveYJSQyH5GB5XzLzhEL6JKVWi4SBBT9sGB1rcClyg3dDbwEg7LO84G4pR4mNi5dwl1lkkpD+1qFHyU9A5c8iuhCUU5T+HKE3g7ZNmsC7xWO2qX/oS4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(261026121527099003)(261026140227099003)(261028144727099003)(261009223027099003)(261022105027099003)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0V3Q0V0dnZiTGc1MVhRWU5ORGhabkNxU0pmeEhXMkVUU3l5cEdJNURXR3h3?=
 =?utf-8?B?aXp4cDNFS3lxUUtLKzNCOEEzUzlYYmJ3YTNNT2xQWXk2ZTFkTjd4ek5VR2dn?=
 =?utf-8?B?VEhBTERUZHE4KzQ3TTJQdlRIeTNMdGUxOC91a2NJdmJ2dGJmNjlLWnlUWFk5?=
 =?utf-8?B?cFp4bTNvbko5YnZXdTJSZi9zdkJnT2RBRHhrMU5WOWx2MmRERGFhZHFqOFdh?=
 =?utf-8?B?TXlrdWEwYk13RzNIL0o2c3JPenk1UmZpUXZ6bC8xOFJ2dzBMTlEzY01JR2tV?=
 =?utf-8?B?V3VpWnRCbjNUSGw4SHVPZmJYOWJvMVo4UFJtWG9OcE1JcGNCYkJlNDlaRGRw?=
 =?utf-8?B?WGgzOUJNNXF6OFlicG8wc3l4SjJCOUZJMTJ2QVFDamJsdjNNNmcrSkFta2N3?=
 =?utf-8?B?VFE3Zm5YZ1RNdTFscWRHUG1Qd25XTlpiWUdXUHQ1Wll0WWFrK1VFRS9WS25a?=
 =?utf-8?B?WHd0cDNreVBaLzJjRGFPRThPQTNJR3VpTUxOOTl3dHZPYWVjdUN1NXV3ZnFl?=
 =?utf-8?B?aHo5TnJVdXkzOGpoalEzNEYwWkZtd002WGxKVDdUSEUzRkE4dThWUWZmQzcz?=
 =?utf-8?B?YTFlY0ZJL1gxYUlsWFlDdmZTNm5Rc1BCRzdJTzlCdFg0QWQ4eDJRelZWN0VZ?=
 =?utf-8?B?NGxhWVhrZm55aGg3Y2JnRXEyUHF2UWUwQjA3QWRrSFk1UUpGSnhScjJnTktj?=
 =?utf-8?B?cWdrYTJQSUhXSWhkaDBnTmtuWnpYblMxZE1PbVQ0TXdjcVRlT25pcmtnMCt6?=
 =?utf-8?B?aEVidkpzU0JYM2xlTExpMU5DelpsN2g1ZWZ1TlpoT3dQbzJsTzVVZ2ttVjQ2?=
 =?utf-8?B?MjJTWXlFSExmaTRTU1FUdkRCL29XeU5uUEV2SFpvbFpaU1lqakFIQ1JMZ01s?=
 =?utf-8?B?RjlieGpxYlhIZkg1VXpmdGU3UkN2U2ZZWnlsbUh1WUszdlg3SzRzUVZXbmN6?=
 =?utf-8?B?WXVFcUxvRklmRTlSNTlyV01wbkhhRFpoMHYxNXRYZk9UeStUbk5jdkxyaEw1?=
 =?utf-8?B?b2YwVitYMk5DM3F4NDdsSzNiTElqdk5uakYzZG9zN3hsRUthaU40WXZsZmFr?=
 =?utf-8?B?UHJSeG55UFN0YTFtWVhhVW9JUGFiOXVSdlpJa2lubWZ2UHY0Y2Y2bncrajRw?=
 =?utf-8?B?NHAwbUdUWDFqREdGRVI3a01xcVcybVBnZnlaUGxUV1dIOHJxQk1DNEV2RnJV?=
 =?utf-8?B?UHliNk54dUpSMGNud29GWHJ6V2tQR0YzOENzbERWQ1FFWEtKTEY3YldVaGZp?=
 =?utf-8?B?MUg5dG5XYjhWWTE2Y1Z4Qzh5SlF1WjdIeU0zUWZDN0JrYlg1V1JDVFp2Mnlo?=
 =?utf-8?B?aGpkOHYzUjZwM29YQXNZQmtldm9OWDU0YjVyY1JYd2xEek1OaTdXa2ZJZWRo?=
 =?utf-8?B?UXhCZkFtOGxDcEY0TUJsNXJjaDZUcDN2dFJHN0pYbmlxaXBiazB5UEx6dUdQ?=
 =?utf-8?B?REl0Y3ZubDRJdkpTU0VQL0R2TWFmOVM5a0NycmJSNGgwSmsyVUtNbmo5akdR?=
 =?utf-8?B?aXlCOE14clVXMWYvNzR4ODJRNTJKVWNzaUdGRHlSZ2lPa2d3TndOMk9kNGgx?=
 =?utf-8?B?U3ZVcjd5QU1md25VbnFuczhmU21BMlBWNktFdjB6cmNJUlliN1NEVUFhb0Nz?=
 =?utf-8?B?MXNrbkFHd1d2dHh0Q1NrbWMxV1JESjQvMUdsY0l3eXI3WGs3UkhMUDZKVzdy?=
 =?utf-8?B?WmNXNzVKdWZjOUQ5ZDRiZ3U3YmhKOWo5TGFneGd6MUFxZDFZTlhvOGI3Rnhm?=
 =?utf-8?B?VU42YVd1MVlVdHh3b0oyQlViaGFHRnJQaXNWc0VTRDJkUmE0bDg4OEVNeXhq?=
 =?utf-8?B?N211NUhZdUp0aXF6alkvM3lMTUptTUszNU53dTQ4RjMzdXRXMlZQUHl6UDdC?=
 =?utf-8?B?Z051eFpHVEwwVFZFeU45d05vbHNqMWhQRGVITXFESGhoN2lVNm1aaEltN3E1?=
 =?utf-8?B?RHYvZGFKSUlJZEdDQkZYRERRdGhEYm9JSGlla2FxaFUrS2NFYlZvWkRPSVRw?=
 =?utf-8?B?WHY0bjlpYU9OZTNHQ1lFTVZaZytIZXhBM2t0RnRYWEFlcVQyL2pvMjhRVTZh?=
 =?utf-8?B?MnZWY0ZLRzZtTXJxNTE2MVlsNTB6ZEtUNmdnS1FCZGJoVElSZCtUc005bHR2?=
 =?utf-8?B?UnVMRC9rSUNlUmJSSTg5dDlpRFNXcVJiY3prbjQ5VW1SSG8zVFgwc2d0QnhN?=
 =?utf-8?B?czhIQ3cvTTdOUTNXRytvNmVNWmZBR1dLb3BkLzA2Qk1SKytHamJ6NTYxWjE3?=
 =?utf-8?B?M1lmajhLTkxFRDdrbGJmWlgzUGRxelYxWHhDVEMrRU1LRFB4a0FEUXVNalo3?=
 =?utf-8?B?TjZINUI2SFN2TDBJQ1JORXFHZ1dQTGt0bjBjT2grdFd3RW1aeG45Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c63d556a-6d9e-4671-d205-08df39b8739c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 14:40:48.7825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wh3n/+gL8UPaimxxhNyGlIHDfx50XV6AS3dwjw8FCH2CW/EiuvGYHPN0gVsbWOfmlWWTfb4lMJPL6AHLXMiJ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4487


On 11/2/2026 8:58 PM, K Prateek Nayak wrote:
> On 11/3/2026 6:15 AM, Borislav Petkov wrote:
>> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
>> index bd70c4d0b774..417e6a41ac60 100644
>> --- a/arch/x86/virt/svm/sev.c
>> +++ b/arch/x86/virt/svm/sev.c
>> @@ -669,10 +669,10 @@ void snp_enable_rmpopt(void)
>>  	u64 base;
>>  	int cpu;
>>  
>> -	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>>  		return;
> 
> nit. We should check CC_ATTR_HOST_SEV_SNP in rmpopt_init() too
> now to prevent an unnecessary workqueue allocation if
> probe_segmented_rmptable_info() failed early.

As rmpopt_init() is now called from snp_rmptable_init() (in patch 2/2), and there is 
already a CC_ATTR_HOST_SEV_SNP check in snp_rmptable_init(), there should be no need
to check this in rmpopt_init().

Thanks,
Ashish

> 
> Since it doesn't change anything functionally, maybe Ashish
> can do it as a part of his mutil-node optimization series.
> 
>>  
>> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>>  		return;
>>  
>>  	if (!rmpopt_soft_init)
> 
