Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB442F691E;
	Tue,  2 Dec 2025 22:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764715201; cv=fail; b=Td6KE4hkD37ZA8Mg58/ksmoQoyOz2PUHEgAxPy5wvV2RL2uOTchiSXhWsRtwuNeSfZRODCP3CUFFN0XQarM6dKPE5t+jlKEmCEtl4jFT4mypqks9pV8uQ35Dqvc/6xcniP6nMJ0QdJD+ygde2vojEkgra/AZlpUJK5kgcLnRIGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764715201; c=relaxed/simple;
	bh=1oHsA+846kXfAyFBCb3PCU0qqaH0cIHmO92llbdGkIU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PqsMS5z5tNtCFMqOVo8AdO3MHG+eY7tbx5efCJE8cOlbo5TOWqj0tW6d72N7ECSxqCG2PcLCRxxtKuSwK13+vd6bvgS1PzGr+0vwaNmHtE7HrFZZvvY7ICPYpYODQnCIbUC8O/5QxXJPoezIkdSRvVd4koRD0SesYZjApNQvMT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S/BwuIHN; arc=fail smtp.client-ip=52.101.62.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S/BwuIHN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hD6v/opEifOD2VkwR05hDX7/yqa8p14a3jQNCZOG6IQDzeyFup9oUYkErkKo1JZ3RnNm+T2LnczgMdUQBaEFXBzhTahyZHV8n3O0EX+ymTTMvpdeyG79UvT83sFlISn1yamCZA4BUJwh0qxRV/x1K3O6TcVmfPUkgjhWOvYkRoMI+bINCHBvx7IWSCAgsK5/c/V7ksgXhUfF+DtviB7QuX8BhosIfCDuMQjyLEC6HeRidKn0yCRiHIUZuMsblHMrNtIxl0pULBL3J5GQd9AQg093DQrCLCYaz6V/FvGk6LrtyDYteFmAZp2Mwze/t5K6mAo71Vgo1XkZuX82FuhIfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47TLtDslAH0tYyEXYKOCgBiIEjKTcRdffhOXSAjLc50=;
 b=qUbXXOvG43TKmTwPdA19Z2EN9wAeerdSXDGsE2DuZ8yZ6shrkkCymIDmrgfiPmIC5CyKOcPOMvRZ8FeE5b7h+upfUENZZ9/NIsgUmTgr/BQpNGNQVy3b4ZjSBW87oh95WZooux5OmFBIJ7gQVCYwtqYka671N/cL/w2ttnpjDjAV8wOaJXtJnk4gyeXvN4qLkYBGNIhgsfq3blKPcCiwMKMXjKsQE2m8ooxTfKRJAfUeNOFDRxaR2wP9VPFnUbV3ryFwqQkcmw918eYfAFwWXnIJce0L/vdIgfAqvsm8y4/0y/H8VGhkgfdM5oNWvIayWMfuH5dr9OFWESLKUJuosA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47TLtDslAH0tYyEXYKOCgBiIEjKTcRdffhOXSAjLc50=;
 b=S/BwuIHNbio49XslJYDR94emAaY1UMarypnjRM06r3pVjs5hKrU4aoPBZei45FVFhMRyTXIyJuF/v7PVSDgD1fwxT0H/ZslY6TKNDRjdV6krMpO3s39d4+8V5X5Gl6n1lWGykly0mGb75MXYDqSYGYuGYYzrg8cfSg+rpRE7Y3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB7656.namprd12.prod.outlook.com (2603:10b6:8:11f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 22:39:56 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 22:39:56 +0000
Message-ID: <e98582db-39d6-4a09-8f9c-88b0aa0c4676@amd.com>
Date: Tue, 2 Dec 2025 16:39:50 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel v3 4/4] crypto/ccp: Implement SEV-TIO PCIe IDE
 (phase1)
To: Alexey Kardashevskiy <aik@amd.com>, Tom Lendacky
 <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Borislav Petkov <bp@suse.de>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jerry Snitselaar <jsnitsel@redhat.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Gao Shiyuan <gaoshiyuan@baidu.com>, Sean Christopherson <seanjc@google.com>,
 Kim Phillips <kim.phillips@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 iommu@lists.linux.dev, x86@kernel.org, linux-coco@lists.linux.dev
References: <20251202024449.542361-1-aik@amd.com>
 <20251202024449.542361-5-aik@amd.com>
 <b6d45b8e-3eeb-4b96-b781-e0ad28861a2c@amd.com>
 <36929d3e-b56c-4e65-9ec1-42fc52fdd962@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <36929d3e-b56c-4e65-9ec1-42fc52fdd962@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:805:ca::47) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: 13c3ebfe-7b66-4420-b503-08de31f3b778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTVmZFREd0paTFFGWG1VWWFnRGpPVldqUHZhd0VsU0lIV1l5SHVRbktRSExL?=
 =?utf-8?B?QUxSNTJKSjFIRnU5QzRsUGxGVHNmMkNyV01kQjkvTjRIRlJFVGpkRmNUbkZh?=
 =?utf-8?B?ZzByKzhUVlk3VCs5SjZvR2V3TDM5akRnSXlIYzE2WDZ0bjJQQ0VPc0Y5TjQ1?=
 =?utf-8?B?Ry8zWHMyV1BzVW9tbXRPY2FzQXZEUHpwWnRuMHc1bm8rdFJXWUFqNUswanB0?=
 =?utf-8?B?R2xzOWN3ZmpValE2NFNhUE9oMC9yTkFBY3l2L0FZV2hmRDdZdk5wZzFSSHJk?=
 =?utf-8?B?TlZJMVpKQ3p1a0FMbUtsdGhzYXIza3hDWVVmUWJaZzhiVHNJbGpnUUFKcTZW?=
 =?utf-8?B?aHBEWWRoYVkvTS93SkwrMlh3SFQ4TUYwczMvMjZkRGRiUjVCcGoxRVlFdkhn?=
 =?utf-8?B?VFZveUNWSGZnd0IzOHo4alJCZTBsQktLVnZSdXBTVFdWb2piaGJzd1lQeTBp?=
 =?utf-8?B?cEpwYjFzYWF4dDNDemRncFhpSHdFLzMyTVVMSksyUWo3Y3Q0SVVpcUsrYU5P?=
 =?utf-8?B?NVRaUWc5bTI0dXgwOFNDTmNRcnBIU2NCamdQazg4UmNhaHptbHJybUFFYmpt?=
 =?utf-8?B?UmdXSmIzV2ltNzltRXBsdkhWckh0djZSSU1LR3FGNmdnVzl5SFFoNVZYb1g3?=
 =?utf-8?B?WVpxZGtyQ1E2MGZWWWVlNWJlc3FOSUFhaVRoYm8vTk9uVkFCUUFpaVJNNHNa?=
 =?utf-8?B?bVNGcXZBMDN5ckRkeUt5ZGhzVUdrM09YS2RPVmNxMFl5aWJ1amxBZ0I3OXNw?=
 =?utf-8?B?aENjVmRyTGNGaURMUEE1My9UR0dOZ3VCelNyNFhPekRHWHhwSVdzUCs3TCtD?=
 =?utf-8?B?WWZCRWhLbVFNdHZtais4aXFYell4RnBVUkt3QkNiZ1h5QWN6ZEpOdlVBNWY3?=
 =?utf-8?B?aGt4elVDWXVIcm9wQ084NWxXSHBjWkd6UzdJUzNaUENjM1Q2QTEwWElEZFFk?=
 =?utf-8?B?TjFYcFF1YkhYREd6cTZMM21nS0pCVVloTk9RRmVpN3c3OHdJd1YxMHVrK1BX?=
 =?utf-8?B?Tm9vZWk4SnRGM0FhWFFsaDhoQXhiTHhmNUcxMlg2RWZWVERNaW1zOFZYSkVZ?=
 =?utf-8?B?b1dZWjlQZGNqRjZ5M2U1Znk1TW9meGRNblh1RURGekRPNm4vN2F5VGVjRktI?=
 =?utf-8?B?ZFVLQ1VSVnBsVC9yK1cvTWYxN2pib2xmQ1ZWTHBpOWEySWZYdlNOODVJaUlJ?=
 =?utf-8?B?OUZqY2pYUXF3VGtHZDlsMkR6bysvTWI3ZjZ4b1JydC9KTzRRdkVmZ1FCNjRE?=
 =?utf-8?B?Y3lBaXoyV1M2c3RKUDViY1E1VzIyYnVHSSs5bDFFSlgrY1o4SS9MWCtQcW4x?=
 =?utf-8?B?Ym9XaGlFK0dDdnlETGR2dzIvMnNvSHk2Rk1zNnNrUndDM01VeFJ5eGdPMkhV?=
 =?utf-8?B?emdIUW1qOGRRUmpuM1g3OGNINndZL1VFbWJRVDVSQ0wvcXFIbnVmTmlGNkM3?=
 =?utf-8?B?eHZWL1N5QXR5ODRnK0ZWbFJsbE9QTVZNWTVzaWJ4eFhJMkhHNHdTYXFoRHVU?=
 =?utf-8?B?NmhiVWdEL25GS3BUcHROVld3cTh4ODdENzM3SW15REJ3U3duc0hIV201d29P?=
 =?utf-8?B?NzVNSkhQQmcwVjdKeGlvUGlxZHlZNVB0TW1ZZ0Y5aTBVL1pRL21yK3NUeUY1?=
 =?utf-8?B?NVBCMk9KMVd1US9GWDBYbHYvUzZEbmdPWVdScExvMUsrSkoyVHUvSklWRUg2?=
 =?utf-8?B?S0RFZjl3VzNWNVZUNU1sb3BHYUU1djFKZkdaTnNFa0RVZnlyS2hTb1VhV0tI?=
 =?utf-8?B?VmhienhnaitpNGV3emUzbHR3cm1LcTMyZGlDV1h2cGZGQzFXTG1JdGV3VTJH?=
 =?utf-8?B?VE5Uc2pmaUo3MFBBMDRVZnQ0L3RYbWdhazFiT3hvcFgvSm5kS2I3WnBmOWxS?=
 =?utf-8?B?Mjd2aU5wbXAwb2VlN3FOTzkrN2RScC9rMTFlYzZxU0tEeEhNRjIxYVRNZkl0?=
 =?utf-8?Q?aigRPpuPolV/NimcWYUX5ItvOfZVZLpQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1ZBaDJ6Z3poQ0ZrYmpkTS9NbU1PQ1dkRnRlNTlYaWNuNStMZlBpamplUklq?=
 =?utf-8?B?ZnliWUM4dUx5bmYxNklMcksxU0h6S1VoS2tHMisxZVhaRGg4R1lHM3Z0N1FI?=
 =?utf-8?B?NnQ1MVNSTTU1eXJEeFFjODVST2NaUHBTM09ybmVJZG42SVhmQ1p6U1NFNkRn?=
 =?utf-8?B?bExiZ2czZk9vQ1dDVjc3YXZUTnVIQmlrbWMxeEh3aVI4dnlBM3h3MlRtVDB3?=
 =?utf-8?B?Mmh5WFFHeFpvajdkREhpMWJ6QnIyeHdxbk9NRS9tOUJsd1pCL1lwTXRFcmI5?=
 =?utf-8?B?c2c1TlZWcFJTRWRHaEFOL0Z3ZUVPRnJsWlV3WkZYMFJCejJ5MkhRUDYvZWpI?=
 =?utf-8?B?MHdmT3BhSmhpRUMrZWg3UC82MHlrdEMxak5oVHMxSjVQbTNOZlZnTE5hTHli?=
 =?utf-8?B?ZWE5bjBuellnVy9UMFpyMndkdWZFT3VyV0ltZjlVSUJSNTN3TXRORUhzc0Vo?=
 =?utf-8?B?T0l0TWlnZWRiTHIveG9EZWxxb0h3aGFyc0RxalhLejhHV0FiNWd3Mk51SllO?=
 =?utf-8?B?SC9lTFlERVlvZWlBUTlvWFB1RlpWZ1E2Y0dsMUVUZGsxUWNvelVqN2Z3cnNC?=
 =?utf-8?B?ckZLNXkwbnI4RXBESDREZHNiWnQrU1pVNFhYcHpFam9DR296cDBmSVJXNlVT?=
 =?utf-8?B?LzQ5ZFUvTHFsSmcwcXA2RXdaVUxBaytpdjVBWXFZOFBaNXpNUFZ1djNBYzZ5?=
 =?utf-8?B?RDV5eEF3dGJyb09qakV4cW9CVjRnY2twV3VDZHU1RkVIWi9LR09ZTHB4VTU3?=
 =?utf-8?B?YUZsL215WlZLMnlDQW9BNUZ2RWpFdG1mMzBXVWxVOE5NY2lkOTdiSGI1UGRD?=
 =?utf-8?B?ZVpJdFVYYStiVXhVU0JHK3orVWNYellFdm0xRHhnN1J0cTQ2RnlrTzg4Slc5?=
 =?utf-8?B?VkJ2Vmt5YVhYZTNOMzY0c3hIQXFvTkgrdmw2NHhFeXFleWR2QnBaN1ZzblFr?=
 =?utf-8?B?Y2x0Z2w4NG1vSGthZmgyMm1hT1RmTnRxYXpvUm1SY3dOdXRlZjh3RGg3Uk9s?=
 =?utf-8?B?em5tbE9nSjltR08vVHBFU0t2K2x3NUI0NjF2R0pxbytBOHFTTzNpTm1KeEJI?=
 =?utf-8?B?ZlN3eUlPVEY4L3ova29HL3Nocjh2TG9GY3Z3N3RSa1R3TUNqZWpKTTkwZE5l?=
 =?utf-8?B?TDZZR29IZ0tzdUkyOE5xanlnbk5WaG5CK2RDZG9DQmNkYnMzYUhxUU5xTmxL?=
 =?utf-8?B?VGJyT25jODNxeml2QXBhbW5Od0FabzA0U3NXSFFOQ2Y5cGJEMFFZbUFEcklG?=
 =?utf-8?B?S1loZ1RJVGRsamk1SjcrejlBTFhHMDMvZXp4Yk5LTC9VaVV4clFpckVhTG5K?=
 =?utf-8?B?SHlLOHBDK0FLRXhZUm9sL1FkaUhtQVl4MU5ORlJCUS9IVkFjZ3IzK2ZnWVpk?=
 =?utf-8?B?QStwMWRrdU04SWNDbG8yanVqYXlIbDVGY1BoMHF4WTBhK2MxZ0RMNVA3TmUr?=
 =?utf-8?B?OU95eWIxZzFhZDlNUTA2a09kb2trV24yajN4Mk5BZnFxR1V1THlBT0RXZzFO?=
 =?utf-8?B?Wms4Q3JyRmUyU0sweTlrZzN6bUo1aURMRThoM3BVUEIvVFM4YnJxNkZjSXhu?=
 =?utf-8?B?VUVtMU00UWxsem5MYjJBMkdya0xBVGNKbEwwV1RaNUFTWUZWc0krY1R1OWpT?=
 =?utf-8?B?aXp1ejF4UVVCdVVpU0kvVHc5T1VaaU1TZVNyTjZ0a1VhL3ZRZi9nWEU0cmNF?=
 =?utf-8?B?QklBOFBkNW9uL3hMUVpubFNYUU43dzVFMWMzemh6cFE4ZGFKV1B4eFlUTXNV?=
 =?utf-8?B?N2Jqc21jWm5WT3pDV05iNDJUWXBhb2xnakgzQUhpdEs5V3ZaLzRRLzFUd1BM?=
 =?utf-8?B?RXQ5UDZUd0lDWG1lamNQUDhxOUJJQXYzV0pMcFFEQ0t5RUs4NW4vS01SOG9W?=
 =?utf-8?B?ME53MEIvVU9TTk8xNU9XOUxsallJSTU3OFQvUXczWEtjSXYwZkYzdUVFTTEv?=
 =?utf-8?B?WjNJZW10THVQV3QzTlg1bGRNc3pYeVo4K3B4UXVCRkE4dDNTalB5WTJGN2Zl?=
 =?utf-8?B?RTRTRzRjU3QrZ3FKeDAvOTNYTDlYWU5NSWRPeW1WNUxzcjJkSlA5ZHVTT3FC?=
 =?utf-8?B?bnFWblZwdkxyclJjb2ZTUElUeWttMldJOGZBalU1ZTZTeFV0aEVmbm80YlRu?=
 =?utf-8?Q?DQY6zLCg8ueT6FS5Xuc3GAhDv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13c3ebfe-7b66-4420-b503-08de31f3b778
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 22:39:56.0904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DWstLvI0WEX89BQmo6ZgkdZ2YJKLaAPzq7H0iNGrtK/r/bhM6T4Xb7nL8G14oI8x3KogRtiVSQx1GO+dQthnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7656



On 12/2/2025 4:30 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 3/12/25 01:52, Tom Lendacky wrote:
>> On 12/1/25 20:44, Alexey Kardashevskiy wrote:
>>> Implement the SEV-TIO (Trusted I/O) firmware interface for PCIe TDISP
>>> (Trust Domain In-Socket Protocol). This enables secure communication
>>> between trusted domains and PCIe devices through the PSP (Platform
>>> Security Processor).
>>>
>>> The implementation includes:
>>> - Device Security Manager (DSM) operations for establishing secure links
>>> - SPDM (Security Protocol and Data Model) over DOE (Data Object Exchange)
>>> - IDE (Integrity Data Encryption) stream management for secure PCIe
>>>
>>> This module bridges the SEV firmware stack with the generic PCIe TSM
>>> framework.
>>>
>>> This is phase1 as described in Documentation/driver-api/pci/tsm.rst.
>>>
>>> On AMD SEV, the AMD PSP firmware acts as TSM (manages the security/trust).
>>> The CCP driver provides the interface to it and registers in the TSM
>>> subsystem.
>>>
>>> Detect the PSP support (reported via FEATURE_INFO + SNP_PLATFORM_STATUS)
>>> and enable SEV-TIO in the SNP_INIT_EX call if the hardware supports TIO.
>>>
>>> Implement SEV TIO PSP command wrappers in sev-dev-tio.c and store
>>> the data in the SEV-TIO-specific structs.
>>>
>>> Implement TSM hooks and IDE setup in sev-dev-tsm.c.
>>>
>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>
>> Just some minor comments below. After those are addressed:
>>
>> For the ccp related changes in the whole series:
>>
>> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Dan did it right (thanks Dan!).
> 
> 
>>
>>> ---
>>> Changes:
>>> v2:
>>> * moved declarations from sev-dev-tio.h to sev-dev.h
>>> * removed include "sev-dev-tio.h" from sev-dev.c to fight errors when TSM is disabled
>>> * converted /** to /* as these are part of any external API and trigger unwanted kerneldoc warnings
>>> * got rid of ifdefs
>>> * "select PCI_TSM" moved under CRYPTO_DEV_SP_PSP
>>> * open coded SNP_SEV_TIO_SUPPORTED
>>> * renamed tio_present to tio_supp to match the flag name
>>> * merged "crypto: ccp: Enable SEV-TIO feature in the PSP when supported" to this one
>>> ---
>>>   drivers/crypto/ccp/Kconfig       |   1 +
>>>   drivers/crypto/ccp/Makefile      |   4 +
>>>   drivers/crypto/ccp/sev-dev-tio.h | 123 +++
>>>   drivers/crypto/ccp/sev-dev.h     |   9 +
>>>   include/linux/psp-sev.h          |  11 +-
>>>   drivers/crypto/ccp/sev-dev-tio.c | 864 ++++++++++++++++++++
>>>   drivers/crypto/ccp/sev-dev-tsm.c | 405 +++++++++
>>>   drivers/crypto/ccp/sev-dev.c     |  51 +-
>>>   8 files changed, 1465 insertions(+), 3 deletions(-)
>>>
>>
>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>> index 9e0c16b36f9c..d6095d1467b3 100644
>>> --- a/drivers/crypto/ccp/sev-dev.c
>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>> @@ -75,6 +75,10 @@ static bool psp_init_on_probe = true;
>>>   module_param(psp_init_on_probe, bool, 0444);
>>>   MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>>>   +static bool sev_tio_enabled = IS_ENABLED(CONFIG_PCI_TSM);
>>> +module_param_named(tio, sev_tio_enabled, bool, 0444);
>>> +MODULE_PARM_DESC(tio, "Enables TIO in SNP_INIT_EX");
>>
>> Hmmm... I thought you said you wanted to hide the module parameter if
>> CONFIG_PCI_TSM isn't enabled. Either way, it's fine.
> 
> I did but you did not and I do not care that much :)
> 
>>
>>> +
>>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>>>   MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>>>   MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>>> @@ -251,7 +255,7 @@ static int sev_cmd_buffer_len(int cmd)
>>>       case SEV_CMD_SNP_COMMIT:        return sizeof(struct sev_data_snp_commit);
>>>       case SEV_CMD_SNP_FEATURE_INFO:        return sizeof(struct sev_data_snp_feature_info);
>>>       case SEV_CMD_SNP_VLEK_LOAD:        return sizeof(struct sev_user_data_snp_vlek_load);
>>> -    default:                return 0;
>>> +    default:                return sev_tio_cmd_buffer_len(cmd);
>>>       }
>>>         return 0;
>>> @@ -1434,6 +1438,19 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>>           data.init_rmp = 1;
>>>           data.list_paddr_en = 1;
>>>           data.list_paddr = __psp_pa(snp_range_list);
>>> +
>>> +        bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
>>
>> Please put the variable definition at the top of the "if" block instead
>> of in the middle of the code.
>>> +
>>> +        data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
>>
>> Don't you still want to take CONFIG_PCI_TSM into account?
>>
>>     data.tio_en = IS_ENABLED(CONFIG_PCI_TSM) && tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
>>
>> or
>>     if (IS_ENABLED(CONFIG_PCI_TSM)
>>         data.tio_en = tio_supp && sev_tio_enabled && amd_iommu_sev_tio_supported();
>>
>> But if you change back to #ifdef the module parameter, then you won't
>> need the IS_ENABLED() check here because sev_tio_enabled will be set
>> based on CONFIG_PCI_TSM and will be false and not changeable if
>> CONFIG_PCI_TSM is not y.
> 
> 
> Ah true. I thought sev_tio_enabled=IS_ENABLED(CONFIG_PCI_TSM) does it but missed that sev_tio_enabled is exported as a parameter so not a constant at compile time.
> 
> 
>>> +
>>> +        /*
>>> +         * When psp_init_on_probe is disabled, the userspace calling
>>> +         * SEV ioctl can inadvertently shut down SNP and SEV-TIO causing
>>> +         * unexpected state loss.
>>> +         */
>>
>> After this is merged, lets see if sev_move_to_init_state() can be
>> cleaned up to avoid this situation.
> 
> Do we want to keep psp_init_on_probe, why? Thanks,
> 

I think we still need to support "psp_init_on_probe" to support deferred SEV initialization and continue supporting SEV INIT_EX.

Thanks,
Ashish

> 
>>
>> Thanks,
>> Tom
>>
>>> +        if (data.tio_en && !psp_init_on_probe)
>>> +            dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
>>> +
>>>           cmd = SEV_CMD_SNP_INIT_EX;
>>>       } else {
>>>           cmd = SEV_CMD_SNP_INIT;
>>> @@ -1471,7 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>>         snp_hv_fixed_pages_state_update(sev, HV_FIXED);
>>>       sev->snp_initialized = true;
>>> -    dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>>> +    dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
>>> +        data.tio_en ? "enabled" : "disabled");
>>>         dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>>>            sev->api_minor, sev->build);
>>> @@ -1479,6 +1497,23 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>>>       atomic_notifier_chain_register(&panic_notifier_list,
>>>                          &snp_panic_notifier);
>>>   +    if (data.tio_en) {
>>> +        /*
>>> +         * This executes with the sev_cmd_mutex held so down the stack
>>> +         * snp_reclaim_pages(locked=false) might be needed (which is extremely
>>> +         * unlikely) but will cause a deadlock.
>>> +         * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
>>> +         * for this one call here.
>>> +         */
>>> +        void *tio_status = page_address(__snp_alloc_firmware_pages(
>>> +            GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
>>> +
>>> +        if (tio_status) {
>>> +            sev_tsm_init_locked(sev, tio_status);
>>> +            __snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
>>> +        }
>>> +    }
>>> +
>>>       sev_es_tmr_size = SNP_TMR_SIZE;
>>>         return 0;
>>> @@ -2758,8 +2793,20 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>>>     static void sev_firmware_shutdown(struct sev_device *sev)
>>>   {
>>> +    /*
>>> +     * Calling without sev_cmd_mutex held as TSM will likely try disconnecting
>>> +     * IDE and this ends up calling sev_do_cmd() which locks sev_cmd_mutex.
>>> +     */
>>> +    if (sev->tio_status)
>>> +        sev_tsm_uninit(sev);
>>> +
>>>       mutex_lock(&sev_cmd_mutex);
>>> +
>>>       __sev_firmware_shutdown(sev, false);
>>> +
>>> +    kfree(sev->tio_status);
>>> +    sev->tio_status = NULL;
>>> +
>>>       mutex_unlock(&sev_cmd_mutex);
>>>   }
>>>   
>>
> 
