Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845151A070E;
	Mon, 11 Nov 2024 21:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731359797; cv=fail; b=K5v2y3L0myGa+lmaCtBP+osP4AYHb9x7isa2/i+v9zE7tnfHTiveJjkMTpV9VXA9IGaqclM9p/5kAMPtyuJvc5o91qjgA2cdilAk18eWoyN1zanCu3Q8R4OkimepV4EiWLUvojW5De1b0VeMRLksCWFNd+UGGCk94nmRSthiHoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731359797; c=relaxed/simple;
	bh=h7od/5C1Wl7G95+8GT7d0lVNn6A0OFGjhJaJhzr7E5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GM9Vl9zAuM9WPsfpW/fAKNCUu7/BoLUx2ekz2PRNevK0baisbq6YHbOCYIxP9TI8JGgeK30DPfcYxQkdBjYBOPUSgJ8lSlMwR61K0lZHVX0aLUrgNONcdExGnjWPAMFDT0vwX9AjvFJREnxZH+n7YnAqK5KAtrJXUoy9Z/23b0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RxnbPnR1; arc=fail smtp.client-ip=40.107.212.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RxnbPnR1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VuNhmnaaJhQrkCe30DRLq9f3ckbXWwMzg2/Z0hzawKpQH2kVwcfYdWt33O98qy5ggDIJEpGVUqlGgPKbCpZhWGoEihZU91GjTsH/kmHjTLck/7tm3e4rOO4R6U+UywdfBkxkvOt28MMj9o9ocv+OVNoNM3Wr+n3ITVZIGKVF2qj3YrfLb4iLW+74KecZ5zYqPM05LIG+1QmpVrOHz6bcKEZVdJREl5BFynRxqJGalVKCmpfCJUK1jkbw9hCLdFVwWaHweAM3h9nBunp3bHhQRH1c2kLVXBTKD310OppP9I0yw72KARL8IFJc+cExLFf7jQcPTQ6hvD53G1ZgjGXfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89i/9z5Q0zhhxI8idYm0YFW1XNOePa9XK1iY9d1dUiM=;
 b=yR95irClvcLAZOG24jTS+d+VG8kKIWpYLySQRk8UDEBtfj50F9/H4xXw+fKLqLN820ivGHilEIExl2+STnut3IS6tjKpuPJFHjTIPpD7Tvhncbd5sFDN0s3QzOtqHMKCQESnyFMLh09pt2rClmlmyy+sMtTbhJsTzUdRJRULaQ7dD3bt96GpJcxwyl38bk2NB5NZcxBWCVdmqVBkKZd6ouT45KHoh4RQpuK/x7FNIsuC5Lx3rYxoSyji5qPCRPeg5urMFHQMq9XtQmGCq1BjC5GWCosvVAuuaZvggWidyXe5khy2JurkjrdS8P9nQWrnY2GrSirJVvdqbHEsiaQYdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89i/9z5Q0zhhxI8idYm0YFW1XNOePa9XK1iY9d1dUiM=;
 b=RxnbPnR195vaADx8qVIbhUoAYOc6rD5MgyO3jxc4T5WxLqLUyCETdVdfOJQiAmoWSCLuZ0L4ZZBLViHZ5gLppt7zPktsDlvZdQ1lMStLg1n6q2l9CJSuk3nT2LP98o20QOXMYyr/EMsbCr6nLspzCndjA/iQu9ofJKE340BumDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SA1PR12MB8700.namprd12.prod.outlook.com (2603:10b6:806:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 21:16:32 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 21:16:31 +0000
Message-ID: <1719bdda-d901-4ff1-858d-f4ec0efddd90@amd.com>
Date: Mon, 11 Nov 2024 15:16:18 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/10] crypto: ccp: Add GCTX API to track ASID
 assignment
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
 <20241107232457.4059785-6-dionnaglaze@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20241107232457.4059785-6-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0068.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::9) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SA1PR12MB8700:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b455bf0-c278-4c2e-a37a-08dd02961d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ckdZa0o5WWczTDR3VlhaKzZYT3piVit1aFJXeTVERlhyNFQzZUptNHFVdTg2?=
 =?utf-8?B?RlRuNEF3MGZtNkxTQWhVMHFLZXZTekkzcnFGbEwybTJsNHE3aGhLbTZMblBh?=
 =?utf-8?B?cUt0SG8wbnB1WVpVMUtzMkFjU2JJS3h6RGIrYjNuaS8zRHNvWUwxUGhqTEFI?=
 =?utf-8?B?ZC9jOHdzWW5BNm1JOUpycVNVSEswTzNrSW5Tb2NkUm1aSkZya0wzSkFKZkdX?=
 =?utf-8?B?VGpYb29hT25FUThzeUQ5a2xoWllEUUJ3ZnhydEkrd1dybFRMWHp2NU1KTkI1?=
 =?utf-8?B?OU5UUDBISCttcXBwTlZQQ25rL3l2OHJmTDhINHYvYXcrekVQcTlLbm1BOVdm?=
 =?utf-8?B?U3c3WkR1c2IwOUtHYkpJenhEakFYQitwczFRYkNsKzI2UWRPdHlqcUhhempj?=
 =?utf-8?B?VUxLTllrNy8xM01Lc3pLbXVyRVUvbWMraHhZK2xKVmFoNEZBd1lUZmhyVm8r?=
 =?utf-8?B?UzhucXJtK1lpNXRuWDZ0YlpkeldtQTZFMEh1MHRUUkJOTG1sb3VqR1NRWHdO?=
 =?utf-8?B?NWtHTEdJZnU4TTFuVTJPdDBKQnU3VWszd2M3MDZyRmxQR0xnQ0pwSGNoenlU?=
 =?utf-8?B?bFV2NklxLzFTMjBacVhYZ2dZK3pkMnRQa1laVlI0cDhXRGE4ckVjUDhVRWJL?=
 =?utf-8?B?b1dYYmJXWXhTR2RxZ1h5S3VxQ1l2Mm5JQzZIeEQ0d2ljdkRTVktwN0RueXJR?=
 =?utf-8?B?V05FQUc3OW11M2s3QnZKaGRCOGhDcm1wdTVNbFpxTzA5b2FpdHF4WTVCRHpI?=
 =?utf-8?B?a1lzakJSNjEzMUNHSVRhZTg3S1hmSCtOWllBd3RDRHZNcVVISWc0d1ZnMXhD?=
 =?utf-8?B?enVpVUNDMWZwLzlvNzZWSUFlUWVMaS9GUFEzQjNpQ0R6bDBhUjNuMUZrdjl1?=
 =?utf-8?B?bXkyTFJzSnJFRlNHYm1Bclp1Zm43Y1NTeUxaZEIyUXJuSVNvVXYzUXRnUjZS?=
 =?utf-8?B?Y2xuWndXeTd4VzIxaEYwTW53c0VzTlpBUDlCVG1aajdiTFIwdDdIUDhZWlIr?=
 =?utf-8?B?aGlmODUyZkdIaTBZa3dGcldiZmNBblh3WVVTUC81d0VzdG9LVVNmc1lFSEJH?=
 =?utf-8?B?N1YwS1FBdWVnUHJJOXg3NUpaUzRNdHZZVnFWTXJ4Zk1TYjFGQWdMSlVOT0RK?=
 =?utf-8?B?K29KamlLK2QwTTMydEpMN3ZIOHNUZzl6Vi8rQktGTUpINFg3VHZsTXFONDJH?=
 =?utf-8?B?S1duRm9BcnY0RVp1MG4zdXJTZnF2YTNLczVYYVMya3dhRXhuY3R6cnNWMGh0?=
 =?utf-8?B?NWdpemVCajE0ejZoblJJcGtuVnRXMW5QM1F3a0RZOUZKZmJzY2hDZ1JtQ2M3?=
 =?utf-8?B?QTdlNG4zbDJKK3BVZ3dpcC9FWEc4TnZrV241RnVGUlo2ZFFuVWRSaWZsSU05?=
 =?utf-8?B?eVd6MmNDdkl4dkRReWRMbUJIdGs2aHB1L3c1cVhuOTFSY2pmTXZjUjFudzdB?=
 =?utf-8?B?dWN4ZFB4SUhVTnd5cHYvUXN2OHkyWTlsK1JoaHFLWTF5SHFPc1pVU3B6dlBa?=
 =?utf-8?B?eGZwV3g5L3hCdjI1elphMG5lSlFRTHlxYllqN3JQN25Mb3dRTklRbUVtMXI3?=
 =?utf-8?B?NWk4Q3NLSERQMk5VeHMrOFMycE5abGd3RVhsRFU1QU5tTFRkaFpVQ09oSWxq?=
 =?utf-8?B?MlFsWm1aaEVseEZUZk15Z3ZiU0E0aU14N3pXN0l0eE5sYm1KQTJtZHZOZzB4?=
 =?utf-8?B?TXpBaDZFTks2NmpzZjJEbi80anNQdTc3aHVFTU9pNnh5d1ZDMTZoVFdQYWRq?=
 =?utf-8?Q?nCi9wmgDANYIt99lIuonHe6Td2l4zmcJfDy4+3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVdZaTdNbUtmZ0IvUWF3T0tLOGY5Tm91WW5ja0RuZlV5VHBxUkNrTlB1dUh5?=
 =?utf-8?B?OFNuMDFQdzJrbzE1aWEwM0pQTS9GMzNJTWlyZEtOaElhR2wxZHE4OVl4alJ1?=
 =?utf-8?B?VHFrRjl1OGpPNE5BdDNlcGNBYzBZVTcrNVVWVXluczhJdGpjYWRJL05GczZP?=
 =?utf-8?B?WjFvMHE0aGppcFphY2lseFUyS1V4WmErUmxGZHNLRTFoUUp1VC9XM005cUs2?=
 =?utf-8?B?bGptRzg1TU5HMHZqU2Y1Qm5MVWJEeHdTY3BUZDVlQnorYm5vbWxMVGZlN0tB?=
 =?utf-8?B?VFlQc2tWbEJHS3RnOXJUa05lUGZsTi8zS0VQS1hzSmx6Tm91Qk1mQnpqTi9K?=
 =?utf-8?B?RDF4YzVOZ3Q4K0MzSXg5elFnaElpc1Q5NUpyVmhONXRaTlZ3c0xMKzl4d0hj?=
 =?utf-8?B?Sk0wRjdsMDUzQ2VXMCtmN0VyUCtjUkVxS1dKWmJIZmZkbGxtR3pTaG05aFdD?=
 =?utf-8?B?cVNpeURTa0NoTlZLTlZ3ajREVERUWHR6Z2dmQ3NqMWVDck5QUzBjY2J5MU8v?=
 =?utf-8?B?WjJUTEg0d3BRQ0tyK0IrZTN4MmVLa2lpajl5WXQ0UU52R01DSE1BUHNER0U5?=
 =?utf-8?B?RlZQQkZrTlpHQ25LU21HV0ZmYnF0TUJaYjJYQ1ZvdUEvUU4xS2ZyNFljTnpt?=
 =?utf-8?B?YStIWVBCUjl3bzVwRUJpNnVnVE5PN29TSlJsajJ0Q1dCaXQ5ZnBWSjRQdVoz?=
 =?utf-8?B?c3lDTE5FUWtneHQ2elRHOWVPWXZmbTdLWmsrS0xnWXI1V0VaVU1zK3dkdzlT?=
 =?utf-8?B?RHVCbUR3WDVMV0NKWVhOWDl2alhtZUlqQ2hPbFRUVytaUUw5T0tiWW9nclBa?=
 =?utf-8?B?cys3dUdOYURLaHcvQWRQUDdoaGFzOWlHSlEwdGVJR0tyN2t4MXJUalN6cWlm?=
 =?utf-8?B?OGhXVmJzSUkwSHZWeGlzUVdYRWI2eWJXdlJ2QU5KZ3JOTTdQLzExNFUvSHdq?=
 =?utf-8?B?c2YyWXJBQjM2anpab0VvZFp2OVFHQUFETzJOMVZrUGs2dys4enZyM09jYzdu?=
 =?utf-8?B?eEl5cnhValNiWFl2OEltdWZzdmxMWGtxL1V1bk5xcFVxQmc1MGhESTNhcDR6?=
 =?utf-8?B?WnY5OEEzWVE2SzNsVmNEY05VYmhLRlBPdEo3RXlqVnRCMWFhRFhXWlB1ZENj?=
 =?utf-8?B?dHpza3U3STVtWndPODJNck1TZTEvMHVqZjFPU20rMFlGbnJKVnhwVk9hdlNr?=
 =?utf-8?B?UXBVR015RTdzSTlqVEM0cFVvVFUvL0ZNS1FhUENBNUd4R1dBYXd5SjB4Sm1O?=
 =?utf-8?B?dUtqcnlsL1hLdXp0NEV5WHQ0Vlg5UjRBNGplc2p1clR0VFQwdGVpNi9ZT0FC?=
 =?utf-8?B?YzROdXVQRTdnTXYwNWJsWTVTekVtWndiV0JMUWRhdEpVL3VFYkJkUzVUUVcr?=
 =?utf-8?B?QTUwZ2FheWQwb0RYd1FYQUNTTUY5WjF1VDhlVUVWNG5vVXpRY1RyTXdZZmlJ?=
 =?utf-8?B?R0RiZ0NrTzd3b1JuTTlndzJtUVJHZmhsTFNsVmg3TjdicDRoMUEzU3E4MkV0?=
 =?utf-8?B?MmNtM2hUbjhsWEwwYXVOam5jOUtCUVlOeTU3NCtIOWJjZVdOS293SHFBT2dP?=
 =?utf-8?B?MElMcVhRangvVWg3bDNoRnM3Tk80VTZWU29saTRJMjdMNm4zRlBFRWxOR3hw?=
 =?utf-8?B?Vkp5UnBSN1JDNUFLR0JreFE2Z3lvS1hrSjlLdnJHOUJHbURYK3UxVFI4RFZG?=
 =?utf-8?B?dXFiRUU3b1NxcVlXVGRsWUsxSjFMN1lnS29ZTXdvQW1mc1NFOXBINzNSN09Q?=
 =?utf-8?B?dDh0MjJVbE5iVDZxbHpQVVg2bEw4M1NySGVtT3Fyc0tKUkE1VFZIMXVHTTFs?=
 =?utf-8?B?Wk1Kc0JKNUE4M3ByeVQ2M0RmRDhrWjVYWHFQYU9tbUpwVUpXaUJ4dHZxTDRQ?=
 =?utf-8?B?VTcrRk9URnBORVFNbjdia29XMWliQmI3Mkh1RExjZUQ4bEkvN3RCZEIxbndt?=
 =?utf-8?B?dVZNZHc1ZTBxRUErOC9Zb0NvczNhdi9QWGVTYnJLczM2d2NMYVJnOE1xM1JL?=
 =?utf-8?B?OVFQcnNYU0FsWkQvby9ZQTUvWUN1ZWJWVHlVeFhwTDgzWFM4djQvNHVmdTBk?=
 =?utf-8?B?R05leDZNdks3Sm5rT1V1RFRac29wenZDM2NqQ0tYMm9HYnVSOWFXaHlHM0hD?=
 =?utf-8?Q?qW+29YNZf2bwV90ldLCeXfIFB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b455bf0-c278-4c2e-a37a-08dd02961d26
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 21:16:31.7475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRNP3VRoGeWQmVz9qGeCrlT4CMSeKyXLPloVnhLjhOkIo++H2HT0ng8y+N7B4KzAqJyYLygNFcNXJ9xgFFIAVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8700



On 11/7/2024 5:24 PM, Dionna Glaze wrote:
> In preparation for SEV firmware hotloading support, introduce a new way
> to create, activate, and decommission GCTX pages such that ccp is has
> all GCTX pages available to update as needed.
> 
> Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
> Live Update: before a firmware is committed, all active GCTX pages
> should be updated with SNP_GUEST_STATUS to ensure their data structure
> remains consistent for the new firmware version.
> There can only be CPUID 0x8000001f_EDX-1 many SEV-SNP asids in use at
> one time, so this map associates asid to gctx in order to track which
> addresses are active gctx pages that need updating. When an asid and
> gctx page are decommissioned, the page is removed from tracking for
> update-purposes.
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
>  drivers/crypto/ccp/sev-dev.c | 107 +++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   8 +++
>  include/linux/psp-sev.h      |  52 +++++++++++++++++
>  3 files changed, 167 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index af018afd9cd7f..036e8d5054fcc 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,10 @@ static void *sev_init_ex_buffer;
>   */
>  static struct sev_data_range_list *snp_range_list;
>  
> +/* SEV ASID data tracks resources associated with an ASID to safely manage operations. */
> +struct sev_asid_data *sev_asid_data;
> +u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;

This looks to be duplication of ASID management variables and support in KVM.

Probably this stuff needs to be merged with the ASID refactoring work being done to
move all SEV/SNP ASID allocation/management stuff to CCP from KVM.

> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -1093,6 +1097,81 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> +void *sev_snp_create_context(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_addr data = {};
> +	void *context;
> +	int rc;
> +
> +	if (!sev_asid_data)
> +		return ERR_PTR(-ENODEV);
> +
> +	/* Can't create a context for a used ASID. */
> +	if (sev_asid_data[asid].snp_context)
> +		return ERR_PTR(-EBUSY);
> +
> +	/* Allocate memory for context page */
> +	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
> +	if (!context)
> +		return ERR_PTR(-ENOMEM);
> +
> +	data.address = __psp_pa(context);
> +	rc = sev_do_cmd(SEV_CMD_SNP_GCTX_CREATE, &data, psp_ret);
> +	if (rc) {
> +		pr_warn("Failed to create SEV-SNP context, rc %d fw_error %d",
> +			rc, *psp_ret);
> +		snp_free_firmware_page(context);
> +		return ERR_PTR(-EIO);
> +	}
> +
> +	sev_asid_data[asid].snp_context = context;
> +
> +	return context;
> +}
> +
> +int sev_snp_activate_asid(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_activate data = {0};
> +	void *context;
> +
> +	if (!sev_asid_data)
> +		return -ENODEV;
> +
> +	context = sev_asid_data[asid].snp_context;
> +	if (!context)
> +		return -EINVAL;
> +
> +	data.gctx_paddr = __psp_pa(context);
> +	data.asid = asid;
> +	return sev_do_cmd(SEV_CMD_SNP_ACTIVATE, &data, psp_ret);
> +}
> +
> +int sev_snp_guest_decommission(int asid, int *psp_ret)
> +{
> +	struct sev_data_snp_addr addr = {};
> +	struct sev_asid_data *data = &sev_asid_data[asid];
> +	int ret;
> +
> +	if (!sev_asid_data)
> +		return -ENODEV;
> +
> +	/* If context is not created then do nothing */
> +	if (!data->snp_context)
> +		return 0;
> +
> +	/* Do the decommision, which will unbind the ASID from the SNP context */
> +	addr.address = __sme_pa(data->snp_context);
> +	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &addr, NULL);
> +
> +	if (WARN_ONCE(ret, "Failed to release guest context, ret %d", ret))
> +		return ret;
> +
> +	snp_free_firmware_page(data->snp_context);
> +	data->snp_context = NULL;
> +
> +	return 0;
> +}
> +
>  static int __sev_snp_init_locked(int *error)
>  {
>  	struct psp_device *psp = psp_master;
> @@ -1306,6 +1385,27 @@ static int __sev_platform_init_locked(int *error)
>  	return 0;
>  }
>  
> +static int __sev_asid_data_init(void)
> +{
> +	u32 eax, ebx;
> +
> +	if (sev_asid_data)
> +		return 0;
> +
> +	cpuid(0x8000001f, &eax, &ebx, &sev_max_asid, &sev_min_asid);
> +	if (!sev_max_asid)
> +		return -ENODEV;
> +
> +	nr_asids = sev_max_asid + 1;
> +	sev_es_max_asid = sev_min_asid - 1;
> +
> +	sev_asid_data = kcalloc(nr_asids, sizeof(*sev_asid_data), GFP_KERNEL);
> +	if (!sev_asid_data)
> +		return -ENOMEM;
> +
> +	return 0;
> +}

Again, looks to be duplicating ASID setup code in sev_hardware_setup() (in KVM),
maybe all this should be part of the ASID refactoring work to move all SEV/SNP
ASID code to CCP from KVM module, that should then really streamline all ASID/GCTX
tracking.

Thanks,
Ashish

> +
>  static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  {
>  	struct sev_device *sev;
> @@ -1319,6 +1419,10 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	rc = __sev_asid_data_init();
> +	if (rc)
> +		return rc;
> +
>  	/*
>  	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>  	 * so perform SEV-SNP initialization at probe time.
> @@ -2329,6 +2433,9 @@ static void __sev_firmware_shutdown(struct sev_device *sev, bool panic)
>  		snp_range_list = NULL;
>  	}
>  
> +	kfree(sev_asid_data);
> +	sev_asid_data = NULL;
> +
>  	__sev_snp_shutdown_locked(&error, panic);
>  }
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a3..7d0fdfdda30b6 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -65,4 +65,12 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +struct sev_asid_data {
> +	void *snp_context;
> +};
> +
> +/* Extern to be shared with firmware_upload API implementation if configured. */
> +extern struct sev_asid_data *sev_asid_data;
> +extern u32 nr_asids, sev_min_asid, sev_max_asid, sev_es_max_asid;
> +
>  #endif /* __SEV_DEV_H */
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea85850..ac36b5ddf717d 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -942,6 +942,58 @@ int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>   */
>  int sev_do_cmd(int cmd, void *data, int *psp_ret);
>  
> +/**
> + * sev_snp_create_context - allocates an SNP context firmware page
> + *
> + * Associates the created context with the ASID that an activation
> + * call after SNP_LAUNCH_START will commit. The association is needed
> + * to track active guest context pages to refresh during firmware hotload.
> + *
> + * @asid:    The ASID allocated to the caller that will be used in a subsequent SNP_ACTIVATE.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * A pointer to the SNP context page, or an ERR_PTR of
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +void *sev_snp_create_context(int asid, int *psp_ret);
> +
> +/**
> + * sev_snp_activate_asid - issues SNP_ACTIVATE for the ASID and associated guest context page.
> + *
> + * @asid:    The ASID to activate.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * 0 if the SEV device successfully processed the command
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +int sev_snp_activate_asid(int asid, int *psp_ret);
> +
> +/**
> + * sev_snp_guest_decommission - issues SNP_DECOMMISSION for an ASID's guest context page, and frees
> + * it.
> + *
> + * The caller must ensure mutual exclusion with any process that may deactivate ASIDs.
> + *
> + * @asid:    The ASID to activate.
> + * @psp_ret: sev command return code.
> + *
> + * Returns:
> + * 0 if the SEV device successfully processed the command
> + * -%ENODEV    if the PSP device is not available
> + * -%ENOTSUPP  if PSP device does not support SEV
> + * -%ETIMEDOUT if the SEV command timed out
> + * -%EIO       if PSP device returned a non-zero return code
> + */
> +int sev_snp_guest_decommission(int asid, int *psp_ret);
> +
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
