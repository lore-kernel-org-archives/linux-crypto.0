Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48257150990;
	Mon, 11 Nov 2024 22:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731363044; cv=fail; b=t2/xHUQ9KKyOx7X0VPZTgNdBxU6CayqURJXIJacBmFicE3gBYR20LlacPy0l0M5C+4lYCvNEoTHDuxktUbg4Ek4N0aAmQwpQZfiKcGaORMe6y+PvvbjBdmQvSRCi5enxMRg1lAybsJBiN+75vCvrL2ogzVIy79p+UgCXR30utN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731363044; c=relaxed/simple;
	bh=mnnDJcTqjzk9alxxiL3LZepfjDc/IUDJsAROa9CDwPI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GxKmL4Y90nCx/9nQ/9+UTkRk022pu6amGPmwvhrobpYya9cbN2U8obUD3oA0ihxs5/42dI71PHM0Qq5wgGH2fOG43M/JyExFoBfm4UiCgAON1xtPSUEqjo92m/nNNCivfMEBQGgM0F7qn7ZuXzaJ3T3DWLKX1v9vkL8q0OSExgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dHaCNN4P; arc=fail smtp.client-ip=40.107.102.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dHaCNN4P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TS5ldFmZBj+5EkUOqzTwXiDPmIjaNVm+3ypqd2NFWMGguzo62Jj1JKhMMGENFbjeyaEl9RSPQOlnRbem/l0IPBZyK2h95rR/DpbjFYFokpW0h0jXzFb/4+XhjuyD/+uZTt/zj+jwb9Qnv5TVuCC2tQ2Xlh80KOHGi1s61g908kPLlb+2a/8ru48fzIGe+we/TbDLB0V6xuM0K09P0KlqxagAJhn7D8J1dKTZBAysMsPpr6A9BRukDOSFWTiBF0T5HuArYQAW3bcfGwJ+LlJuC/blPxaI4hn27OdcZKiNnn63YdX+PZ6fXhfa6wydRwlZaLJXBzkTnB6wlfdD0587Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuC4UC6bO5bUzWKm29LTCe+G6bBdjKHjeaLxuaBH7P8=;
 b=fb3ySCg/xzCSjUJPvSQWp538z+4lgMwdMhwgkDqV3Hde2Kv4SVPfGAmPIMiwE1yFNmVAjfTGRXj07ypQzM1RU5xnw/X1qYswi65R9tgtv+qTX+Q1hLFFVD/Tq/s4LlAXNlzW2/nXMD76ncaM0RMOtsRUpXeOPEo/+PbX1BtNNrrfRQS1V4lM4Ww4lkXXSBdThvJGroPRiNqnII8x47nnMPubis1jpKgzHRmfgOLY9EpQ7BJY4qm3XhI+OriWkPeOYfZsgl53Nj/QDAoL004aS7MLTbr1LDEkdpV7tpsj6852672lD0Yln3mV8AipcsFmN9MYHlBKHSV1xXnplG6uuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuC4UC6bO5bUzWKm29LTCe+G6bBdjKHjeaLxuaBH7P8=;
 b=dHaCNN4Pqv0fWtcDmZMwQNeDPytsjG4fAgRRm3b5TCf4cT80zfVoSXs5hFdiWUzk3+bObarp95JzOCu9vmOaHLC7TgVV6zqRJFng7Ga4e4SE/h7dv2FShtvP0lehMgP9zYuRDIhaY/CYh922f2RmYrNmJawtWMX0tzUwkScewOE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 22:10:36 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 22:10:36 +0000
Message-ID: <bafcd3ea-fdb9-4996-b696-03b4c912b1a9@amd.com>
Date: Mon, 11 Nov 2024 16:10:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] crypto: ccp: Add DOWNLOAD_FIRMWARE_EX support
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-7-dionnaglaze@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20241107232457.4059785-7-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2P287CA0002.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:21b::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f71afca-986f-4fc9-c45d-08dd029dab32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVRnYXdkcU5vVzMzQXZXbU80NjBrYi9Sb25aTVdrK0R6Y3dVak1zV3VyREda?=
 =?utf-8?B?SDZYd2dENndTenRzUW9CUnpDV1RySlA5RmZRQXQ4WnMxVUZWSUtYYjNtaEpS?=
 =?utf-8?B?UnI0RnJmM2lKc3J3QVozdkRoTFNZakp4RGhuSytuV3JUOW1LaEFOR2E2VitB?=
 =?utf-8?B?dnZ3aEpUV0R5emF3OXkvL3R1bnpPajNWS2svalliVWlZRjk2MmZncmwrYzVX?=
 =?utf-8?B?RnAxRnFqM0FhWnNqeVBFcGVLVE85cDRKRGMxVTlncVRFUjM3TVl6bkZ5K3R4?=
 =?utf-8?B?cXlaUzlZbkFwUVUrNzZtb1ZuWTZyczR0VHgyVFR3cFVjbVFVbDFjYXc1N3ho?=
 =?utf-8?B?Y3BuOXRIZHRWZTQ3Uy9kak85bHo4WG1rSTJIS2ZzRXpLQkswVDRmUlU1Mkww?=
 =?utf-8?B?N3RLNGRCcEY0TW91eUlLY0U4MHpLWUNsUmljdGN0aTA2c0hyN1JkZi9HZXE0?=
 =?utf-8?B?d2lNVUx0YkhsRU9ySUFaclZHTHova1lPWVFZYlpSQkpGdVdPcnpjeGxJQUVl?=
 =?utf-8?B?WVJPcnFycWxXQmN1aUk0T1RDMzNzcDdOQU03TUFZWTBYRzhqSEZJNkxxTUh2?=
 =?utf-8?B?OW9kcGpsK1BrZ1VhSC9aREtSMDFJVGh5OUVVNUxCVXpWS2xHUHNvNGhtR0x4?=
 =?utf-8?B?TVdCdVo4VEJ0WDA5M3pwRk5HRllXTWp4cTJ6RHBUa2JkQkN2a0J0TUlYQ0xD?=
 =?utf-8?B?SFBTYlhWWThqUWZmd0ZMc3R3TnNTY0dRVkMxVmsrcDFnbi9pQnp1U1IxeGpN?=
 =?utf-8?B?aUUvOWUrMUkrbU12VUZLSDF3d0ptMitrQ0VWemF2T3hZajl6R2svbXI3ZTRh?=
 =?utf-8?B?RFVUQi9IUzBFcENUVE5WNks5S2xDdUE1ZGZ6Z2g4dFBTK0kxT0RuZzJrWDFw?=
 =?utf-8?B?MUp2ZGdZaVcvSEJ6ZklWOUdmRmd0NVJyV05wcWlyeGQ5L1VlNmFoeU4vSVFQ?=
 =?utf-8?B?YUdvaXlkUW9MU1BFaUxxakVycGFvbjlLb1dLRzJYOTI5V1hzYXQrc00zUkN3?=
 =?utf-8?B?bmhncU9SazJaRFlSL3YyZk00RXBmb3l2MHJYaWt5RDRYWWdUaFBLZ09ldCtX?=
 =?utf-8?B?MURvL00vY2JVZmxUYTNwcDU2ZFp4cmlHcXU0b1dlS1pPNlZhR3JJKzQ2U0dT?=
 =?utf-8?B?Rzh5N2g2NGJuVzQxa202MzlpdUVPMmtMNTloV3MxWmY5ZWtKK1dNMW1lUnhv?=
 =?utf-8?B?dnZVMkpPdWlXR1pYK29FR0F6c0lOL3B5NWZrbEF6WHFxSFBMNWdydG54NFA0?=
 =?utf-8?B?a2tWY2c2RWRDcTRTSHNUSS9rRXZYUzdFQTdJbjlQdE02d29FRVpOeWRxWDRT?=
 =?utf-8?B?anJpOGpudXp3R2JqOVRXdENwV3l6QVNoOEdRS0VVY2NQVTFsU0FNRGJhSzNx?=
 =?utf-8?B?eXpNSzFMUmNaUDNKdzl3MWFZY0t0TW11YVFwOEliQmdQRjVyc1N5TThzaHQ3?=
 =?utf-8?B?aDhBODUra1dUV2w3UFdiamQvSlQrUHZ5N0FpSUVVd25jd2JXMDN5dGxobTNy?=
 =?utf-8?B?akk4Tzh3NHhKd1VQSSs4bGJzM3c1MmpqRzlBUy9XSVl0WTBkVnVlWVFCRlRs?=
 =?utf-8?B?VGxIYUNnbzN1QUgwclR2V0dtNk4zQkUrSTRGcVVPVE5nS1ZLNk5qMC85NExU?=
 =?utf-8?B?ZUFrLzR0M2h5ZndtOTUvaXoxOEJmYmIvWDZQS1JYMWNYY0pBczJiU1lWTFNh?=
 =?utf-8?B?bGFEd053QkxSdWZ0d3RyeVg3L015SER3RTdvS0lBTkE3RkFhTzhGcHk0QzM1?=
 =?utf-8?Q?RARzyM/GLeMMWLKgbssA6PareLlIeqjuAY/wK1S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dC9RaG1kM1JxNHlhUzVKOGZSUUREUUxhNTczbzZQYURkeGdpZUZPOGJtK3dl?=
 =?utf-8?B?cWF3cEJnYnFYeEtGTXAyaG1IaThVTjdPalhPbjFrYjVqdG9CVTVvcHhVcXMr?=
 =?utf-8?B?VXpLNXptbzNCYmV4cU5lbEFrYks5UldDa2JjOWNoeTdNZzQ4MkVZTDdVbE9h?=
 =?utf-8?B?TDNzVitkRXVLK3QzeFdqZTRwcitWUlBOU0dleE8reVRMRlNnL3ZrYmJNVGU4?=
 =?utf-8?B?STYvcklQNTFQUmJWeHhaZnlKU2tvckkrMWVNaVJUNEtrTGJKWlpxRnFTUUJJ?=
 =?utf-8?B?cFFHa3p5b2JlUWNOdG1aTDlkZ25TU0xLTlFlUjZ2UGxKL1RxUFVOUEVpRVdv?=
 =?utf-8?B?SURJTUtIaXB3WTJtNGpSME1JOHNmNUNSYTFsWDNUZDBXWmNJSkZEZEJydnVE?=
 =?utf-8?B?aVhlczZ4T1BVU1dkcUVOeldjQVdWNkRlWEkzRVNMMEdjZm10NUJ0OTNVTEpi?=
 =?utf-8?B?WmtJVFpLcEc2WnZRajlWQngzd29OT3NKY2VRSHV0SXRMd1hiRkppa2dRMGNs?=
 =?utf-8?B?UWdZc0EvQ3BTRWJQRzk5SVNOaWY1SGo5WktiUmRGUkFaWklJd3NTa3plcVhj?=
 =?utf-8?B?bjIzY2IrVEx1WHJuM1J5dXlwU2diL0xEQTN1RWtWaDdLdnR2Y2llQUpUdGho?=
 =?utf-8?B?M1NWcXhBOXZFNjV2Y09hSU93Z3hvdXFsazFXR0hxcmhPU1QxaU9hVVRYYnJt?=
 =?utf-8?B?VUp3d21sUmxoeUNncnRUN01XMlhwY1FzTi8wMzhiLy9mSVZYTDBiYUVkMGJE?=
 =?utf-8?B?UVRmVnpCVGJqT25MdVNoNkJNUCt5ZWtNdXFRQWFTUjlhbm11NDZQR1NCSjJT?=
 =?utf-8?B?ZE9pNnF4WWVqcnM4VUxRMngzSlYvZlZNRmFCSFg4Zlc4bXc0SWovaDBkbWtI?=
 =?utf-8?B?amJoVzJkQjVpUEpENTlpT2hBbU9IaGZkRy9Rbm1tNHFXUG9Xa04yN3J4YWYv?=
 =?utf-8?B?RzNveFdRVUVaODdsbXYvTk9nR25mSjYvRXJVb01rOVBDL21HN0lKNFJZR0pk?=
 =?utf-8?B?eDAvQlRGVW1BQ056cWEyT3JycUlXM2MxMFVOV0tOOVFCZVJQQWpya05QVStm?=
 =?utf-8?B?Rjc5a1B2R2JuczN4SmZEazFjTVUzbERIcXhCL2s1dFFkeXNDWkVDVDBTMlJy?=
 =?utf-8?B?TEgyUTlpdEgxVjlMUGxuTlAyRDAweCt2ZTlidktzdTd4RjdkbGpZZkRYcHlw?=
 =?utf-8?B?SCtLcUYvMFVQMUdYcFRQOFEwYWpmUXpQOVdjbDVKTTU5Mm9jbjRoWDZoWjNt?=
 =?utf-8?B?V01vTkFNYi8vY1V1Y0c1YkpwYVB5aDR6bXlkUFNxam83WUJEZzZIVTRtZERq?=
 =?utf-8?B?SllOQ3d0d2JSdkdCejZWMzBoakhSOGVUVTFjYXh6anhIUStKeFJxUEdIaGNL?=
 =?utf-8?B?ajZpUE0wYWRKVGZOU0cyUEtUakpkc3lEZHdGcEZVV2JVLzZCUi9IK2sxTk9l?=
 =?utf-8?B?ci9UeUorY1VyYzB3UVdldWpiK3EyL0t5akpvRlEwOTFrb3U4MUxWMVRTRnNs?=
 =?utf-8?B?eGlTb0wzQjdQaWxXa21Wbk8yb3NJTjRQM2x6MTUxL2R0bkJ0QVdFcGZkbGlk?=
 =?utf-8?B?N2FPdFdTTXpTY3Z2QWlPYkg0NDJqaGMzTVpPR0tKWFFtdjd3NW9MTlhaWWpX?=
 =?utf-8?B?alZ6SHkzVzNEMUFSM1dMdTY5d21icmJpakVWcVhHYnJCWEhxcGp6eUZmWGRH?=
 =?utf-8?B?STdOUkRzTm8xajJmUWZ4SW9Ud21hdU1FMFZQcUxFSmhSNXplajg3cFByWDlL?=
 =?utf-8?B?dDZhcGhRN2ZhU2E0VVo2dHFtN0lFdGdnUFpZUDd6VUdaNkVvYUowMDF5bFQr?=
 =?utf-8?B?N3FsaGplb3dJVXFRam1Hd1I0Q2xHTHVlVGFVSjBBWTkxV2ovdkt1eDE0Rmp3?=
 =?utf-8?B?akJPRkx3a1V4aHB1SDZHMjhOVkhDZ24zUHhvSnNXSFBUYSs2c2ZpVzJpWVhZ?=
 =?utf-8?B?YnBwMXErRlR1aTNsYzVYWGlVL3lJNXNPSXg0d1FOY295L2NZcXRwRFhYZkZG?=
 =?utf-8?B?R2hPMlUvYUhCRUhPbXNrVU1iMDY1QmNUQ2VUUnU2YnNlNUdIV3hjQkRwQWpE?=
 =?utf-8?B?eWl4NTNiS3NIOXpZSW0zSmVXbmNLZDNyWmNPbjdQSWIyNjd0MFluOEw2TGtG?=
 =?utf-8?Q?KTs3PlcNlPU3fc8TnY/4YmsxL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f71afca-986f-4fc9-c45d-08dd029dab32
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 22:10:36.3874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i5ZeAkbF5y5VPtndjl6SrFl+usUqSi0wI8Lav7z9LQdbwM1AEwoUBY1Rb73Q2DNEDRJhZC4dKh6Zw30SoynXnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226



On 11/7/2024 5:24 PM, Dionna Glaze wrote:
> In order to support firmware hotloading, the DOWNLOAD_FIRMWARE_EX
> command must be available.
> 
> The DOWNLOAD_FIRMWARE_EX command requires cache flushing and introduces
> new error codes that could be returned to user space.
> 
> Access to the command is through the firmware_upload API rather than
> through the ioctl interface to prefer a common interface.
> 
> On init, the ccp device will make /sys/class/firmware/amd/loading etc
> firmware upload API attributes available to late-load a SEV-SNP firmware
> binary.
> 
> The firmware_upload API errors reported are actionable in the following
> ways:
> * FW_UPLOAD_ERR_HW_ERROR: the machine is in an unstable state and must
>   be reset.
> * FW_UPLOAD_ERR_RW_ERROR: the firmware update went bad but can be
>   recovered by hotloading the previous firmware version.
>   Also used in the case that the kernel used the API wrong (bug).
> * FW_UPLOAD_ERR_FW_INVALID: user error with the data provided, but no
>   instability is expected and no recovery actions are needed.
> * FW_UPLOAD_ERR_BUSY: upload attempted at a bad time either due to
>   overload or the machine is in the wrong platform state.
> 
> synthetic_restore_required:
> Instead of tracking the status of whether an individual GCTX is safe for
> use in a firmware command, force all following commands to fail with an
> error that is indicative of needing a firmware rollback.
> 
> To test:
> 1. Build the kernel enabling SEV-SNP as normal and add CONFIG_FW_UPLOAD=y.
> 2. Add the following to your kernel_cmdline: ccp.psp_init_on_probe=0.
> 3.Get an AMD SEV-SNP firmware sbin appropriate to your Epyc chip model at
> https://www.amd.com/en/developer/sev.html and extract to get a .sbin
> file.
> 4. Run the following with your sbinfile in FW:
> 
> echo 1 > /sys/class/firmware/snp_dlfw_ex/loading
> cat "${FW?}" > /sys/class/firmware/snp_dlfw_ex/data
> echo 0 > /sys/class/firmware/snp_dlfw_ex/loading
> 
> 5. Verify the firmware update message in dmesg.
> 
> CC: Sean Christopherson <seanjc@google.com>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: Dave Hansen <dave.hansen@linux.intel.com>
> CC: Ashish Kalra <ashish.kalra@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: John Allen <john.allen@amd.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Luis Chamberlain <mcgrof@kernel.org>
> CC: Russ Weight <russ.weight@linux.dev>
> CC: Danilo Krummrich <dakr@redhat.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: "Rafael J. Wysocki" <rafael@kernel.org>
> CC: Tianfei zhang <tianfei.zhang@intel.com>
> CC: Alexey Kardashevskiy <aik@amd.com>
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/Kconfig   |  10 ++
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/sev-dev.c |  22 +--
>  drivers/crypto/ccp/sev-dev.h |  27 ++++
>  drivers/crypto/ccp/sev-fw.c  | 267 +++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  17 +++
>  6 files changed, 334 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/crypto/ccp/sev-fw.c
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index f394e45e11ab4..40be991f15d28 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -46,6 +46,16 @@ config CRYPTO_DEV_SP_PSP
>  	 along with software-based Trusted Execution Environment (TEE) to
>  	 enable third-party trusted applications.
>  
> +config CRYPTO_DEV_SP_PSP_FW_UPLOAD
> +	bool "Platform Security Processor (PSP) device with firmware hotloading"
> +	default y
> +	depends on CRYPTO_DEV_SP_PSP && FW_LOADER && FW_UPLOAD
> +	help
> +	 Provide support for AMD Platform Security Processor firmware.
> +	 The PSP firmware can be updated while no SEV or SEV-ES VMs are active.
> +	 Users of this feature should be aware of the error modes that indicate
> +	 required manual rollback or reset due to instablity.
> +
>  config CRYPTO_DEV_CCP_DEBUGFS
>  	bool "Enable CCP Internals in DebugFS"
>  	default n
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 394484929dae3..5ce69134ec48b 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -14,6 +14,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                     platform-access.o \
>                                     dbc.o \
>                                     hsti.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD) += sev-fw.o
>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 036e8d5054fcc..498ec8a0deeca 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -227,6 +227,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
>  	default:				return 0;
>  	}
>  
> @@ -488,7 +489,7 @@ void snp_free_firmware_page(void *addr)
>  }
>  EXPORT_SYMBOL_GPL(snp_free_firmware_page);
>  
> -static void *sev_fw_alloc(unsigned long len)
> +void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> @@ -856,6 +857,10 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	if (WARN_ON_ONCE(!data != !buf_len))
>  		return -EINVAL;
>  
> +	ret = sev_snp_synthetic_error(sev, psp_ret);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * Copy the incoming data to driver's scratch buffer as __pa() will not
>  	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
> @@ -1632,7 +1637,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len)
>  }
>  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>  
> -static int sev_get_api_version(void)
> +int sev_get_api_version(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_status status;
> @@ -1707,14 +1712,7 @@ static int sev_update_firmware(struct device *dev)
>  		return -1;
>  	}
>  
> -	/*
> -	 * SEV FW expects the physical address given to it to be 32
> -	 * byte aligned. Memory allocated has structure placed at the
> -	 * beginning followed by the firmware being passed to the SEV
> -	 * FW. Allocate enough memory for data structure + alignment
> -	 * padding + SEV FW.
> -	 */
> -	data_size = ALIGN(sizeof(struct sev_data_download_firmware), 32);
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware), SEV_FW_ALIGNMENT);
>  
>  	order = get_order(firmware->size + data_size);
>  	p = alloc_pages(GFP_KERNEL, order);
> @@ -2378,6 +2376,8 @@ int sev_dev_init(struct psp_device *psp)
>  	if (ret)
>  		goto e_irq;
>  
> +	sev_snp_dev_init_firmware_upload(sev);
> +
>  	dev_notice(dev, "sev enabled\n");
>  
>  	return 0;
> @@ -2459,6 +2459,8 @@ void sev_dev_destroy(struct psp_device *psp)
>  		kref_put(&misc_dev->refcount, sev_exit);
>  
>  	psp_clear_sev_irq_handler(psp);
> +
> +	sev_snp_dev_init_firmware_upload(sev);
>  }
>  
>  static int snp_shutdown_on_panic(struct notifier_block *nb,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 7d0fdfdda30b6..db65d2c7afe9b 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -29,6 +29,15 @@
>  #define SEV_CMD_COMPLETE		BIT(1)
>  #define SEV_CMDRESP_IOC			BIT(0)
>  
> +/*
> + * SEV FW expects the physical address given to it to be 32
> + * byte aligned. Memory allocated has structure placed at the
> + * beginning followed by the firmware being passed to the SEV
> + * FW. Allocate enough memory for data structure + alignment
> + * padding + SEV FW.
> + */
> +#define SEV_FW_ALIGNMENT       32
> +
>  struct sev_misc_dev {
>  	struct kref refcount;
>  	struct miscdevice misc;
> @@ -57,6 +66,11 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +#ifdef CONFIG_FW_UPLOAD
> +	struct fw_upload *fwl;
> +	bool fw_cancel;
> +#endif /* CONFIG_FW_UPLOAD */
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> @@ -73,4 +87,17 @@ struct sev_asid_data {
>  extern struct sev_asid_data *sev_asid_data;
>  extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
>  
> +void *sev_fw_alloc(unsigned long len);
> +int sev_get_api_version(void);
> +
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD
> +void sev_snp_dev_init_firmware_upload(struct sev_device *sev);
> +void sev_snp_destroy_firmware_upload(struct sev_device *sev);
> +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret);
> +#else
> +static inline void sev_snp_dev_init_firmware_upload(struct sev_device *sev) { }
> +static inline void sev_snp_destroy_firmware_upload(struct sev_device *sev) { }
> +static inline int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret) { return 0; }
> +#endif /* CONFIG_CRYPTO_DEV_SP_PSP_FW_UPLOAD */
> +
>  #endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
> new file mode 100644
> index 0000000000000..6a87872174ee5
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-fw.c
> @@ -0,0 +1,267 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) firmware upload API
> + */
> +
> +#include <linux/firmware.h>
> +#include <linux/psp.h>
> +#include <linux/psp-sev.h>
> +
> +#include <asm/sev.h>
> +
> +#include "sev-dev.h"
> +
> +static bool synthetic_restore_required;
> +
> +int sev_snp_synthetic_error(struct sev_device *sev, int *psp_ret)
> +{
> +	if (synthetic_restore_required) {
> +		*psp_ret = SEV_RET_RESTORE_REQUIRED;
> +		return -EIO;
> +	}
> +	return 0;
> +}
> +
> +static int sev_snp_download_firmware_ex(struct sev_device *sev, const u8 *data, u32 size,
> +					int *error)
> +{
> +	struct sev_data_download_firmware_ex *data_ex;
> +	int ret, order;
> +	struct page *p;
> +	u64 data_size;
> +	void *fw_dest;
> +
> +	data_size = ALIGN(sizeof(struct sev_data_download_firmware_ex), SEV_FW_ALIGNMENT);
> +
> +	order = get_order(size + data_size);
> +	p = alloc_pages(GFP_KERNEL, order);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Copy firmware data to a kernel allocated contiguous
> +	 * memory region.
> +	 */
> +	data_ex = page_address(p);
> +	fw_dest = page_address(p) + data_size;
> +	memset(data_ex, 0, data_size);
> +	memcpy(fw_dest, data, size);
> +
> +	data_ex->fw_paddr = __psp_pa(fw_dest);
> +	data_ex->fw_len = size;
> +	data_ex->length = sizeof(struct sev_data_download_firmware_ex);
> +	/* commit is purposefully unset for GCTX update failure to advise rollback */
> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, error);
> +
> +	if (ret)
> +		goto free_err;
> +
> +	/* Need to do a DF_FLUSH after live firmware update */
> +	wbinvd_on_all_cpus();
> +	ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error);
> +	if (ret)
> +		dev_dbg(sev->dev, "DF_FLUSH error %d\n", *error);
> +
> +free_err:
> +	__free_pages(p, order);
> +	return ret;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_prepare(struct fw_upload *fw_upload,
> +					      const u8 *data, u32 size)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_poll_complete(struct fw_upload *fw_upload)
> +{
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +/* Cancel can be called asynchronously, but DOWNLOAD_FIRMWARE_EX is atomic and cannot
> + * be canceled. There is no need to synchronize updates to fw_cancel.
> + */
> +static void snp_dlfw_ex_cancel(struct fw_upload *fw_upload)
> +{
> +	/* fw_upload not-NULL guaranteed by firmware_upload API */
> +	struct sev_device *sev = fw_upload->dd_handle;
> +
> +	sev->fw_cancel = true;

fw_cancel is still not being reset to false anywhere, so once set will always cancel
all firmware update requests.

Probably the prepare() callback can set fw_cancel to false at the start of all firmware
update operations.

Thanks,
Ashish

> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_err_translate(struct sev_device *sev, int psp_ret)
> +{
> +	dev_dbg(sev->dev, "Failed to update SEV firmware: %#x\n", psp_ret);
> +	/*
> +	 * Operation error:
> +	 *   HW_ERROR: Critical error. Machine needs repairs now.
> +	 *   RW_ERROR: Severe error. Roll back to the prior version to recover.
> +	 * User error:
> +	 *   FW_INVALID: Bad input for this interface.
> +	 *   BUSY: Wrong machine state to run download_firmware_ex.
> +	 */
> +	switch (psp_ret) {
> +	case SEV_RET_RESTORE_REQUIRED:
> +		dev_warn(sev->dev, "Firmware updated but unusable\n");
> +		dev_warn(sev->dev, "Need to do manual firmware rollback!!!\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_SHUTDOWN_REQUIRED:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image cannot be live updated\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_BAD_VERSION:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image is not well formed\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +		/* SEV-specific errors that can still happen. */
> +	case SEV_RET_BAD_SIGNATURE:
> +		/* No state changes made. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware image signature is bad\n");
> +		return FW_UPLOAD_ERR_FW_INVALID;
> +	case SEV_RET_INVALID_PLATFORM_STATE:
> +		/* Calling at the wrong time. Not a hardware error. */
> +		dev_warn(sev->dev, "Firmware not updated as SEV in INIT state\n");
> +		return FW_UPLOAD_ERR_BUSY;
> +	case SEV_RET_HWSEV_RET_UNSAFE:
> +		dev_err(sev->dev, "Firmware is unstable. Reset your machine!!!\n");
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +		/* Kernel bug cases. */
> +	case SEV_RET_INVALID_PARAM:
> +		dev_err(sev->dev, "Download-firmware-EX invalid parameter\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	case SEV_RET_INVALID_ADDRESS:
> +		dev_err(sev->dev, "Download-firmware-EX invalid address\n");
> +		return FW_UPLOAD_ERR_RW_ERROR;
> +	default:
> +		dev_err(sev->dev, "Unhandled download_firmware_ex err %d\n", psp_ret);
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +	}
> +}
> +
> +static enum fw_upload_err snp_update_guest_statuses(struct sev_device *sev)
> +{
> +	struct sev_data_snp_guest_status status_data;
> +	void *snp_guest_status;
> +	enum fw_upload_err ret;
> +	int error;
> +
> +	/*
> +	 * Force an update of guest context pages after SEV firmware
> +	 * live update by issuing SNP_GUEST_STATUS on all guest
> +	 * context pages.
> +	 */
> +	snp_guest_status = sev_fw_alloc(PAGE_SIZE);
> +	if (!snp_guest_status)
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +
> +	/*
> +	 * After the last bound asid-to-gctx page is snp_unbound_gctx_end-many
> +	 * unbound gctx pages that also need updating.
> +	 */
> +	for (int i = 1; i <= sev_es_max_asid; i++) {
> +		if (!sev_asid_data[i].snp_context)
> +			continue;
> +
> +		status_data.gctx_paddr = __psp_pa(sev_asid_data[i].snp_context);
> +		status_data.address = __psp_pa(snp_guest_status);
> +		ret = sev_do_cmd(SEV_CMD_SNP_GUEST_STATUS, &status_data, &error);
> +		if (ret) {
> +			/*
> +			 * Handle race with SNP VM being destroyed/decommissoned,
> +			 * if guest context page invalid error is returned,
> +			 * assume guest has been destroyed.
> +			 */
> +			if (error == SEV_RET_INVALID_GUEST)
> +				continue;
> +			synthetic_restore_required = true;
> +			dev_err(sev->dev, "SNP GCTX update error requires rollback: %#x\n",
> +				error);
> +			ret = FW_UPLOAD_ERR_RW_ERROR;
> +			goto fw_err;
> +		}
> +	}
> +fw_err:
> +	snp_free_firmware_page(snp_guest_status);
> +	return ret;
> +}
> +
> +static enum fw_upload_err snp_dlfw_ex_write(struct fw_upload *fwl, const u8 *data,
> +					    u32 offset, u32 size, u32 *written)
> +{
> +	/* fwl not-NULL guaranteed by firmware_upload API */
> +	struct sev_device *sev = fwl->dd_handle;
> +	u8 api_major, api_minor, build;
> +	int ret, error;
> +
> +	if (!sev)
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	if (sev->fw_cancel)
> +		return FW_UPLOAD_ERR_CANCELED;
> +
> +	/*
> +	 * SEV firmware update is a one-shot update operation, the write()
> +	 * callback to be invoked multiple times for the same update is
> +	 * unexpected.
> +	 */
> +	if (offset)
> +		return FW_UPLOAD_ERR_INVALID_SIZE;
> +
> +	if (sev_get_api_version())
> +		return FW_UPLOAD_ERR_HW_ERROR;
> +
> +	api_major = sev->api_major;
> +	api_minor = sev->api_minor;
> +	build     = sev->build;
> +
> +	ret = sev_snp_download_firmware_ex(sev, data, size, &error);
> +	if (ret)
> +		return snp_dlfw_ex_err_translate(sev, error);
> +
> +	ret = snp_update_guest_statuses(sev);
> +	if (ret)
> +		return ret;
> +
> +	sev_get_api_version();
> +	if (api_major != sev->api_major || api_minor != sev->api_minor ||
> +	    build != sev->build) {
> +		dev_info(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
> +			 api_major, api_minor, build,
> +			 sev->api_major, sev->api_minor, sev->build);
> +	} else {
> +		dev_info(sev->dev, "SEV firmware same as old %d.%d.%d\n",
> +			 api_major, api_minor, build);
> +	}
> +
> +	*written = size;
> +	return FW_UPLOAD_ERR_NONE;
> +}
> +
> +static const struct fw_upload_ops snp_dlfw_ex_ops = {
> +	.prepare = snp_dlfw_ex_prepare,
> +	.write = snp_dlfw_ex_write,
> +	.poll_complete = snp_dlfw_ex_poll_complete,
> +	.cancel = snp_dlfw_ex_cancel,
> +};
> +
> +void sev_snp_dev_init_firmware_upload(struct sev_device *sev)
> +{
> +	struct fw_upload *fwl;
> +
> +	fwl = firmware_upload_register(THIS_MODULE, sev->dev, "snp_dlfw_ex", &snp_dlfw_ex_ops, sev);
> +
> +	if (IS_ERR(fwl))
> +		dev_err(sev->dev, "SEV firmware upload initialization error %ld\n", PTR_ERR(fwl));
> +	else
> +		sev->fwl = fwl;
> +}
> +
> +void sev_snp_destroy_firmware_upload(struct sev_device *sev)
> +{
> +	if (!sev || !sev->fwl)
> +		return;
> +
> +	firmware_upload_unregister(sev->fwl);
> +}
> +
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index ac36b5ddf717d..b91cbdc208f49 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -185,6 +185,23 @@ struct sev_data_download_firmware {
>  	u32 len;				/* In */
>  } __packed;
>  
> +/**
> + * struct sev_data_download_firmware_ex - DOWNLOAD_FIRMWARE_EX command parameters
> + *
> + * @length: length of this command buffer
> + * @fw_paddr: physical address of firmware image
> + * @fw_len: len of the firmware image
> + * @commit: automatically commit the newly installed image
> + */
> +struct sev_data_download_firmware_ex {
> +	u32 length;				/* In */
> +	u32 reserved;				/* In */
> +	u64 fw_paddr;				/* In */
> +	u32 fw_len;				/* In */
> +	u32 commit:1;				/* In */
> +	u32 reserved2:31;			/* In */
> +} __packed;
> +
>  /**
>   * struct sev_data_get_id - GET_ID command parameters
>   *
