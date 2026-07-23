Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB4C28506C;
	Thu, 23 Jul 2026 06:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789460; cv=fail; b=J9c+AwfdiuTwy4xsP6f2ft5Ocn193DXtMlQF0euF25Cq2jg85HgEBCcF9krRIsIafcWwYzPaY0TNR+vvP2XDBCW0YwnxYWtLV/fLj+gbs7VB/oUkiD2w5KcYhI9tTpwvV3JTOsCLkDvpd4KAbMfmch4j6Vy2RzN6YTsx3nSTrEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789460; c=relaxed/simple;
	bh=WpfLSOKM/HU5KzX4uKcvL/fLjx5GX3W1Rm27TLNNzkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bqFgBMdGHgaadszDE3THV1LLiMYik1PN4GORD5mywxCQyM96aZNgjdgJcOLPHPBjBZM5nge436IiKXg4840y8iZdYKEKh+4fIdHntq25nkoP58Pfi2bPY1E+qDH9YedNSRyaIrI4CxIotysjOPEZCaCsoRL/RWSDpgDABL6Usf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o7UiANVt; arc=fail smtp.client-ip=52.101.52.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o7UiANVt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oeckgQbkRIXdVKIKzMErM2jM8THxvGW1gpIrAAJc3FuTlL2RiJqVz22/DXkCDbL3e1UhViX3wBTdqZPN3nT5v6fRwedcitnQTTQqPfGMkjZpd1IfnYp7XOBVGnlSUTVsRyO2YHd5NigNnOhYuhXy6XDb3D/JNY1p1SNLx41CCo/jLIO+0ygZkJLLElSJQQxk2hqwYvsLYgEfZ9VeJL+Oqt9qSU/iq8ZI57SjuyUy85s2f4Z2AVS73mAswzNNfn1xkRsGtyBNkHCTjIKCefNFrxomuMDjposQucGJ+ATPlel3dAn76VnbhO75edfE9DZ4txMRDZc+3TIxE0p2z92PGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3O7pf+VU31V2n4M76O6WxPojbTPogmfACFhdt8heao=;
 b=aqEVJdFKzrLH4S1reptyJw5No0VehThQb1kg/47uh585qKsqK05KgXbDRnQwQNxc1CMx4KY4rOrRnQWyDDR5K0qlGz2dBSWeJF8MiJnM+fU0DJEpnLLtFi4ocLCEImk7s8zkP3FJtxrIJZiGYwnpVOeFoDCxkYEEJst8iLmTLxXuwhL6DG5l++8FpAVQTqONIxYF1icOgZqx2V36d5/N6eSM2JX8rKphPn3oESnpruX2dhCQUJLtq4EZx0FgHaoaTT1VoFw34X90Gszv5ac2Stfw+jVZrkrGX6gGgygyWqOf1ftJTxbIlc+iT498vCOYxD2oyXuGkWGX5AoYsKClYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3O7pf+VU31V2n4M76O6WxPojbTPogmfACFhdt8heao=;
 b=o7UiANVtA1VaCoQPMQ2ymfZIxuHbBE9dMlNRkaUklztQ7yxxz76TW/XR75ftaa2t6zE06XhPSZbIL+VNxjoh7p0U8Z661chsPjeKTjWEW4fXJ1fY5ZpvijBcM9YqvioQIEhJd5OtcCictlKqrEhn5k3uPcy/+4lNlN9WPloyE0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB8727.namprd12.prod.outlook.com (2603:10b6:610:173::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 06:50:53 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 06:50:52 +0000
Message-ID: <5460b946-b511-4060-8951-264d17a2b21b@amd.com>
Date: Thu, 23 Jul 2026 01:50:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: Borislav Petkov <bp@alien8.de>, K Prateek Nayak <kprateek.nayak@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
 <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0086.namprd11.prod.outlook.com
 (2603:10b6:806:d2::31) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB8727:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e6876c7-8a7d-45fa-0be9-08dee886bcc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|56012099006|10067099003|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	vPh76ChjO+Q5iP37XoR08uNjKRnUHkr2+LGEiIvQNZC2VDqNU7305VdOJ7UnAOJntw1xSZ/0ESDS/tz9IpHVqNrAISLb/Xoxoq4h25d4ZENTcDXaVV/kVhLTtHQFGBiHQWjK0eFvA3MxhFWikDElbxLrA7HMzb5JcpJ5TqZGvSt9PN1IcnNZlxIKTvytlMFRIudLJTj2iA7HRJbyyles5n5Dy0ChPokoEY7GPApK3kUGQQcticmXupoZxyQUKngD2Nw+XMM0LSWtdCSj36vc9DJxXRGXhjVA7PObuP6BRAnZLCtubWu1TTVh+k2+L99q9pT8PPiWYet3i6Y4AZysV0rrsKURU4mTK7mB2PuOt3/0rWq9WQpFk6xQy1TQ+dUtF7BF66yANigW84zYVUK+DNVSOwdzzHdA02Xl8XwS87gCvK1tmfbROssHfMRy8RSP8jW4tmR0i3A5lH5rFeTSgzWtlVlghZakpK3WDRtNdWqkGEQ7ALlS3dhq5ogUPFrqnIJdkpT3eQDk08Tx3CxV3eiMTdwK+aqXZqtWAf2ioAlF+B1lwEEaXzkH8k+mg0LQxvqTCfAt/pfP7fO7IMIkc4zSFCZxf12ePeO1Ezhuo5r9A5kRb9Ko8p9/7ow/yY2YuQnLJ9hfGU5rbUkAYRomEtS3sFeXRsQ17h/YmqmFcto=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGZwc0NEV3hEMG9DcDJXUnBldURDZ25KQjRJOS9tYngzMzQwdGdnUWNRSEN2?=
 =?utf-8?B?eU96b2lLY2JQSHNKZ2dSMVlKR1J2TzlzZnVsUFJ2SFZIVlFBUExvOFc3ZlFz?=
 =?utf-8?B?QnNIVURMWUtkR1dOQ2VSWXp0Tk9uV1BtRjVlaXdlamRaWkI3cG12NWJzaW1B?=
 =?utf-8?B?TXZPMGVzekNwMUREQUVLdlZLb29YNjZ6cG5ERThEbEw1WklIWGUrazRFZ09Q?=
 =?utf-8?B?UlNJaWtONHRTN2grbUNrMEZqRHAyUSt2VE9aeUZ3RmozUmR6NDdnYzV1OTF4?=
 =?utf-8?B?MUZuVVVUVzBWQ3htaXpnV3FPcTVndTF0WGRmYTVQbVo1TnJwSUpnTWlJOTV1?=
 =?utf-8?B?SFlCcjEvT3JpcU83cXZCcjNwdFBCMGQzMDF4S2Nsa0NVeG1RTkwzaW1RaTM3?=
 =?utf-8?B?R1BGQld3ZW0xczBQZHJIWmJtUHdReldqMDQ5cDBQQkxrOXJ2Mm1KaGFCZW1h?=
 =?utf-8?B?STlTamFjZ3hrWXNFbjNadW5vV1NyV2MvTlZDT3RaVmM5djNEa0luVmI1QnQ0?=
 =?utf-8?B?QjlrNnIrek9VaXMwNnlrSXVWZTZFQVZUK2xjcGRZVVgzQ3loQVE4N3E5b2ls?=
 =?utf-8?B?R3FaaDZHRlVWeDZ4V0xaR2hGa3NiUVFBOHpVUElBdkFzTVN0WloxU1RYcWRK?=
 =?utf-8?B?Q2M0dCs4TCtTT0VURUx4SldvTVB0NWhyS1JzUmJTWEl6NG5VZjBLcGtlRklo?=
 =?utf-8?B?SkJLUGdxck5JcS9zT01BZ2FSdENvUVR4S0d4RzNhZ0lvZWNKWFpTZHlNQ2Mr?=
 =?utf-8?B?bGJEMUJxejI5VS81NmZQTWcrb0FDL1VGb0ovaUhoaHByTjZWcXNjTzROeDdx?=
 =?utf-8?B?cUluaDl0MUN2eFZndzM5MWxPVFJkMWI1U0kvdS84bngyd1BXSXdKT040cXEr?=
 =?utf-8?B?R0tNRUsyQTNPYWw5bWFYZnIrT3I5SGhFV0ZxSUQ1TEJkSzczQnV1MXB0Qmo3?=
 =?utf-8?B?RE0zZWU5UEVJN01uME1XTjFFWHhGZjArRXRpQW1CcEwyY01IcUhNbFE1aCty?=
 =?utf-8?B?Nk53a2locUdzYnJuMnIvWHVkdGJpSlljaHpyNFo4cFNOUUxmS0hlWDN2OEtN?=
 =?utf-8?B?dzNET2JVTWQramlwRExneEdubUVhRUY3azdYSHk3bDNvMG5LQWhJU3c4K00r?=
 =?utf-8?B?VmlGZDNweCtRemtJc3hESnRRV3VTY3hPZjdObFNyVituVmczMlExMTZKYktw?=
 =?utf-8?B?TTJLQ3JWZUlxak1aVkdDcDAvNDRFdzJGeTFQOEVtenhIR0czSitkS05ReHJT?=
 =?utf-8?B?QmtLc2w1SlFxLzJOUUF5S3g2WGUrU25DcWdDdHN1MHZiaU9IaS9oVDR1WFE5?=
 =?utf-8?B?T0E0N0lBNmlmNmFta2lsVHBKV1lEMWNYbUhZemd0cDVQcUQ0ZkpyemswNmU2?=
 =?utf-8?B?czNYZC9ITDQwMTFoc0hKRzJ2YXVhOXNIMUtIWGp4bEoyd091cHppQ0Y4TXNh?=
 =?utf-8?B?RHF5cHZoV09Semk1R2VKcTZURXE1VklFU3ZqMWFHVXp2blYzM2hnbGN6aVNX?=
 =?utf-8?B?d2lhZFVOaFAyYUZIdCtKMTUyeGlCMXk0TCtmVER5bHpCUVEzZWtkZFh3bnpB?=
 =?utf-8?B?dzNpOWxuZFRTTE5YdzNNMjhRZ0t2NWpqMk1YSW8xc3JWbmJWSGk0RWVYMFNC?=
 =?utf-8?B?YmV1OUtKMWNDUzlYS2JCRGxNRkpNMmtmSWRlQ29xZlE3aUlJeEtoWERLMUdv?=
 =?utf-8?B?SEwxc2hpblZXZHI0YThxeXMyYkVGL3BMM251dng2M1kwSU1hSyszMVhLUGRP?=
 =?utf-8?B?d1ZyN3dEMS95NlIxelI0Y0crQ00yc0h5R2hkNUNUUG5qZ3VCbGhnbTZnZG1X?=
 =?utf-8?B?WURrVm10QkVFTXE4ZFdWRHhlNGdYbVQ1dzkyYjVicVg1c1BuamJadDMxTytM?=
 =?utf-8?B?cHV6RXdkclJSa3pmdDlmQjBnQ1NZK3NJR3J4dnhDR1V5U1crREFTODZkaVJM?=
 =?utf-8?B?VzEyMTlzN0R5UDFLMEhKNWg3TkJ5LzRoMVNINU1hR3dGdHZRbExualVId1dr?=
 =?utf-8?B?bTRsZE5XdUl5V3JUNlh0RzAwUnFzZDF2VkgrVlkzczU2R1lvTGVMR0VtSjUw?=
 =?utf-8?B?V0NpeFNWNDJlMDBzc2F5aGR0WlhXbktxenNzU3dGa3hUb1BVbmpYVGpyUzlp?=
 =?utf-8?B?alZteFc1YlFZeDFUc2x6cm5YZGhXSUd5T3JJUmFnVGpOSndpSk1CSVcweEVB?=
 =?utf-8?B?Tm5JcmR0YmZ4MGNiSXloN0s5QkxOTElmRjI4VFlMQ1JFMGJoZ2t2KzA2WXNx?=
 =?utf-8?B?NElmcG92dXg4eFRJTEVXRGt3UXRqL0Y3dWlxVDVIbXQ3N0t3cTJBMHRmQ2xl?=
 =?utf-8?Q?VMe5XeoXGouaP5+LSu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6876c7-8a7d-45fa-0be9-08dee886bcc5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 06:50:52.5310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AAnClcp/NMX1etG1MUxAWydNu9DHmu4ucB7FuLvkM1ZPK0wxfaLK8dvHlAo3/hMbAGi+++wA0lGuSwweCkdQ1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8727

Hello Boris,

On 7/23/2026 12:14 AM, Borislav Petkov wrote:
> On Thu, Jul 23, 2026 at 10:23:56AM +0530, K Prateek Nayak wrote:
>> The offline cores will remain offline since hotplug is disabled. RMPOPT
>> is simply a performance optimization for RMP checks and leaving the
>> offline cores (that will never exit idle) unoptimized should be
>> acceptable.
> 
> What happens if you boot with a subset of cores, the boot flow enables RMPOPT
> and then you online the rest?
> 
> Have we tried that?
> 

 It can't happen here. snp_prepare() does the following, in order:

  1. cpu_hotplug_disable() — freeze the CPU set.
  2. fail SNP init (-EOPNOTSUPP) unless every present CPU is online (cpumask_equal(cpu_online_mask, cpu_present_mask).
  3. enable SNP.

  snp_setup_rmpopt() runs only after snp_prepare() succeeds, so all present CPUs are online and stay online (hotplug is
  disabled). No core's primary thread can be offline at this point.

  (The kexec path is the one exception — snp_prepare() returns early there — which I'm handling in the other thread.)

  Thanks,
  Ashish
