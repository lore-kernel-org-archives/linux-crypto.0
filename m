Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012001.outbound.protection.outlook.com [52.101.48.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A854433E8C;
	Mon,  3 Aug 2026 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785785892; cv=fail; b=Nk1akV0k7eM9bBzPe6HiOfwPPOpJ723VPLqvcXXOAEh5EPU5foA+zVGgya9BhGJ6LgjKxy3S3hbibG2QmHaX/zv/SgM7jsul5Uf+27i9PippPVPlxxdTCye/YOGTDhIOYtpZMuM/HQWhP0ew9qi/xbHvmPsHySA1rN+0b6q8NJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785785892; c=relaxed/simple;
	bh=9GsE6KwPMxdrchkt2sLcJrKl0muQ9phmRphmnCJ72QE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DoOiSjlcXtASOFzOvW1TE3ZskWrRd1vtMgTvKiODmKWY3KhPs6EwcBpgi8d46LKHZoMbyVZhQmVb8SOJSSlURG0HiLfI/w4rQFvDCK9oIX8/d+N0bttFrUH1DxfJmIyAFshdE+NtPy2S5s5JieaQSguyvI7baKicM6q38w/AxPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dtLEsNeY; arc=fail smtp.client-ip=52.101.48.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dtLEsNeY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjobAEJ3FKlY0SD+FEoq+ajN6WHe31HVEAcDvMD4homCHQgqNhzpbLdEpHvHqvUmtFl2fe/NAacgrPUHpRxcLH/ODTOnVGO1TaIRn64v1dzk2QwSedionLHOxQgQJvJ9EmsHODZrdAygYS0JZtTpKAmUs4leIu9hsiV30eMnnlWDRdHMAoAD6btMmgO8zbbjR7UNPJWcqjx4tteOiZjYNwN9zzKK0r/F05awSdOq8Wyzd0g65nNS5z22XB/NMSbSmmg9jcOkfaJR/p4rxKXpqNABtwcsBcqfAgbkfAfAbpNyyxT4IHzE3SXDOfgifOE5I9civaK5fzPUXKyk/SI6eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45Fp3/fLniY6I1Mj5gQ/5rQrMcmECfBmtjkJ65bQk8o=;
 b=aVTZx78blyQ5zp8jQYGHboAKQ1RH3cdL7J/EgAnDDdDnNZUfPKgoM/yju0+SsYSJfYFKuCpwsRdgej+fW5KosB7OnsqQT3GfclZCe1jT5NS8iiIfy60DI7QsIE0c63z31i4W1csFpCJyVdaX5XSmLNZZpzMVihNkAKft/JoarzPp2Etr0HEqBtoY+j6LYANx8AU/wF+dGEXIUuUQZf3wFL1m9l+MDm0rGBdbbDwoqbV1mGib/MzX5h1940YGu7LmcYGVkqYSCca/iDP+cv7USO36FcOA1hb0krOxKM++RWE1YL+d/17vf2nl9XpzmUBelOrlgCAtOJaRzM+VbaqFEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45Fp3/fLniY6I1Mj5gQ/5rQrMcmECfBmtjkJ65bQk8o=;
 b=dtLEsNeYaz3tQEmCAeAZCLszFoxZhd4yCV6uYfatPbh54lMY1jbr2dMmBA6ARWpc/V2Yx3ajWLGFbLZlo0U4f39Wqy8f/crcA0UmiKhgnQ7FURLIC6/zIJVq5dr3IvgFqdcqeV68gLwfCL4u3G+qBVmhmpDDXagndm9ZyVN0lhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CY1PR12MB9650.namprd12.prod.outlook.com (2603:10b6:930:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 19:38:04 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 19:38:04 +0000
Message-ID: <df5f5f6f-7278-42e7-bc7d-8e56187d1438@amd.com>
Date: Mon, 3 Aug 2026 14:37:59 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
 <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <178578506318.2377606.14791252769672870038@Ubuntu-2204-jammy-amd64-base>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:610:54::12) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CY1PR12MB9650:EE_
X-MS-Office365-Filtering-Correlation-Id: 405a4049-adc1-42f9-334a-08def196bc6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nPm+LNEx0SKDUwl0u0NKU7mL09hNUVdRnAX4ZKHw3H2fuPZluTCLpdv7slRKHSK2dvALQ9/0iDZRAC18tsSRQHe4qwI4sD4JbsGAzEHwlyNnHMQTsK04zYeWtXzYG1RZEzbyQ1Gj2EsRem8kEfGd6zoUAl6K0kZM9FwBKv3yCcxLVZptyODkZpDj1XaceKFais70aoo2BHAsVkkShQzT0r7lNOxd8H1UM8/7sI/sW0q17QiLu3lGwvmBJLzeYgYWOagjZx3AnsMjTfnwrCdIA4e0zV2+kfuVAmyORyoxxK9wF6kHl99QWdNqsFLHtFAgkZWtHLcvcTmc7zqWzpOA8WTLLwfK6itcIMyciH0Ez9DJQ5LSye96Q6ltbSIsaNRBwylXy7kjQPo9Vjof1FPhxFVO5xxK0S4yH5Z/fbohpqM1uYo1sJ925nDO7yltKU/cIfYSJ9XEzCRZjCYCfNdZvko7h4tsB5qyxe8BVwLSAFOIcBi24YO1ohWpBX3rqdYAo0WYRSCLtBBa9HvBHchGpAnnQvSTWbOOMzfhnRtoUsUj74vElhJha1DUfqW/K2NSNHIIeOj+bPbyDx6mRtW0AtEb55UWOUnAfnt1rxhiHVWPxgqbmQuJaNvri52i39mzlIavjr7zTkrxgbvX/vW2opeCBEMcP3K4TAAgL1sogLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkFWMkI2Y29iejlCeE4wdWJuNWk3R3Q3RDdYWTFkYUhib1pUMDR5U1RTdEdT?=
 =?utf-8?B?d3N3bTVqc2pTV3N3SiswbUVLbG13OWUvUTVXSHpITVBuTExvQldlOFVMOHg5?=
 =?utf-8?B?b3ArMkNlZkRlUU1kVExrbDRJMXNpMXRHME5LMEMwK0MzcnkweFBQZXdITTdF?=
 =?utf-8?B?aVZSZFJZd2F4MTJDb0w1Y3l0THBGN1c2WU8xeXl4ZXgvdEU4RkV6K25iZnl3?=
 =?utf-8?B?NnZZVmxrWUN2UjNpZUJReU5ISUlTa0lHQ3RPby9IalB6bHVocDlNcC9SenhY?=
 =?utf-8?B?eG4ydmZHdThkQmIrT0tLYWVGZ0NqaG1BVnBqUkFlT1BjSmRnajFUN0ZROVZj?=
 =?utf-8?B?NUhHRWNjZFZPb29sVmlOZFNCVnpOeGRWc3lpbm1qVXl5RDBUc2FMcFNEMEhy?=
 =?utf-8?B?cFdyVWZzL256ZHczbWhpU1FobFVycCtlK3hHRnBkem1NeE1LSXZDT1NoaEVV?=
 =?utf-8?B?T0V5TFhRa3NqSlVsR2d5RVpqM2NFTVBBS3VzOWV2aVZHeW9QWVR0S3BkcUNP?=
 =?utf-8?B?OVFhbW1idXhNOWc2TFRaYXEySHBMMEFpTTZUZTFLOGJLeHpHMUVjaHU0SHF2?=
 =?utf-8?B?L20yUHlDR1J1MTNseTB1MlM0RExuSUhaMmJQLzNkMm0rcHU3bDl0dXl6TE9K?=
 =?utf-8?B?anhLMHIyL1RhUVJWaHBXSmZUSU5ISGtrRzhNcEd1VzZxcnVJRDZubU5VWllO?=
 =?utf-8?B?clpsRXNSdnhxK3dpNkc2aTBmTkFoODFHRDZra044VUd0dTh2dy9SWEJBNU9L?=
 =?utf-8?B?YzdZUjFsY1BQOGwvcWdMYTB4Y29uL1UvdTVBWG5STG1ObSsySVRHdEZ4emRu?=
 =?utf-8?B?UW0xZndWbHJxWkdnYzFHNFFFNGcxTzZ3UW8rdnBDZ1F4REFLSzhoeGNDUGxK?=
 =?utf-8?B?MHFsL3ZvdEY3dGNvUkZhdjhkSFFHbUNsRENQMEg4SXBFNnYxYVpKNVdsTFpF?=
 =?utf-8?B?MHIzbytvVFNMZFlKR21VNjk4UTFHOWprbHd4em13M3dLQTVoNGxCMUpMTHNI?=
 =?utf-8?B?eDNlc0tQaDlZNmx4UEh1VDZrR2NDR0ZaSUZmb2lac0xYZFZzUE52a0UyL21o?=
 =?utf-8?B?RXRkUXNzNmRlUHdHcWR2Rmc0Y3ZkZyt2emVFNUZmRlF1aGNCSGhYSFBGZmps?=
 =?utf-8?B?RmRiMUxXNzJLQmJWcHQwd1J2N0Jac1Q4WUtLejNXVFBmSFdZQmNnRHNiRkQv?=
 =?utf-8?B?YlBzTmNBK1B0S21BMzVneWF6aUxtUmZwd3M2SFdmT29YMkZWeTE3ejN1dWND?=
 =?utf-8?B?MGFJcTZCWVV5WkdmQTAxbkFGWVFoc2Rhc25uOE9ybnp6dkVFNDM4VTRjV2xZ?=
 =?utf-8?B?ajZycjVKdk1Dd0ZMRzc4NXFjbjNEcDBaOEFldUhDVDJoeFBQK1M5eWdBZzF2?=
 =?utf-8?B?bTRhM1pvc25VVG01T05EU2FqTXF1blVNM0lhQS9BVFdrYmFGWEdYa1cvKzhG?=
 =?utf-8?B?TTJTcFd2SFM5V29QamRrcEF1N21CaXZjOC91ckp3LysvUjdWWTZiMlZaYTFk?=
 =?utf-8?B?UHdTZFEwT1JpcXdMTFNWUWpjbG1CMjdHRWNGVUpPdG5UMUFtc1pIUUR2bHFE?=
 =?utf-8?B?UmFrNU5nYUJVYWQ1WjB0Y2RibkwrQWtOb1NzNjB2NWwxZ29aZjBtTkEzTzFN?=
 =?utf-8?B?T1J3QmJTVzZ4ZDN3QnFZekYvS2Y4NE93dS9OZXhJQWU5c2xES3lZa3FaSDdS?=
 =?utf-8?B?UVlKbmViU0dMcmJCaWI1REJHREdWeG5qOUowcEVTY2xlZ1c4ekVwY0xSY1B2?=
 =?utf-8?B?YUNFNmwyZ0ZyNXpYaWxRLzdtY2kyaVpYUlFtRk9ZQ3dLYVBhaCtrQ041Z0Jp?=
 =?utf-8?B?YWFLSW94TmFmd1FDQm5jZE1WdE9vcVVVWE81ZjNRNVFadzVmaXkrNkVHNjYx?=
 =?utf-8?B?cWprWkdmSVJUVGFiVzBOYjlzaTgxTVZLS3hIbHJaTDZITW1QOWlGdEJ2cXIw?=
 =?utf-8?B?cXFyeXdtYUtSd3NET2JOWU9yaDExK240K1dETEU3b211akhhVWhLUXVJcEl4?=
 =?utf-8?B?L0h5YUNzQXlSWHI2eld3c2xUY0V2ZTBLa00vd2srNC9zbll4M2VqNmw4UnBw?=
 =?utf-8?B?VGtraFIrY3V4QUk1LzF0UWMydDB3ekgzeFJoMFlBeXMrRWMyS2FYYnlyUTNR?=
 =?utf-8?B?cUlBT3JWN1cybW1WWlhiUVdkblEybkc2NDh3WSs2MkMwRWxSUmNySFM2WHZs?=
 =?utf-8?B?NVBySVh0K2lWZkVPdTZkZWtoQ3lXZnM3dmlBblFLOWxsdVROT3E4Yyt5dFdK?=
 =?utf-8?B?Vk53NFdlR0FUZEViR1BLWHg4QVJ3U3lhT2o0aE1hYUhOdFJ4Q3FVNDd5Y2pw?=
 =?utf-8?Q?nRVrXTTW9g3IY8kdDi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405a4049-adc1-42f9-334a-08def196bc6c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 19:38:04.4738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2EnnU3h8zDhlGr/j31dFbZwNq+EnqltOGNvhzbfvHETNNM1cP78DgOJl6Wg/yDxqxJ0XQ3irUuhsV0ksnKJ3IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9650


On 8/3/2026 2:24 PM, Borislav Petkov wrote:
> Kalra, Ashish <ashish.kalra@amd.com> wrote:
>> Followers are RMP-scan cache hits (cheap) and this only runs at setup/teardown
> 
> How?
> 
> I see the workqueue running periodically. And in talking about periodically, RMPOPT_WORK_TIMEOUT is not used anywhere.
> 
> What's up?

RMPOPT_WORK_TIMEOUT is used by snp_rmpopt_all_physmem() (mod_delayed_work()), which is added in the next patch — I'll
move the define there so each patch is self-contained. 

It isn't periodic either: the handler doesn't re-arm itself. The work runs at setup and re-init with queue_delayed_work(), 
and then per SNP-guest teardown via mod_delayed_work() (batched by the timeout) once the later patches wire that up.

Thanks,
Ashish
