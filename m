Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CA919340B;
	Mon,  4 Nov 2024 20:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730753150; cv=fail; b=LhsEctB/2CBLoqKFNhcZzfxyn+eNqEwXA5hEM2z6fdveY18CppKZqSPZYcEKt2GkGzk54TTdYi+nAHS7fh6iQO4em8s6LCiREVnoZgFD/mWC0Rehpqqn6A3os0atI6o+uFKNYajIVrnJxeAWdSStA1VZHlMHz8cBI2KMd8FWk6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730753150; c=relaxed/simple;
	bh=BThzhC0zy2FID3YeSQT0WQp3ONeJpq8d5mP98zMFUEg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=uZgm4kdaoSoZYR3TpW3i3LbQzkZtTBT8/IhkWjfbwB2354C4l2G7/3pI1CpmnbAtOZgyqR2wDW1zjU8GzUV2Nz7dhdZyOcOwYcUZc9rQxcDfslDRwJhZqoykeKEIJ1ALveIL1xzJ+AoY9QHjkCr2O+7c0o1kl5WLjR0EAJLk0RU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KDOEIO3z; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KDOEIO3z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dVrC7usL/3gQqc0+sqtu7c+5VoI3kQu+WSdta75DNBRpYzWOpnF+V0m6DCCAUjE3aKqzLq1jyB20VuJz80Zwq78FQzH0mxjd0nRnqyR2go3cT96MElSRijc8UQR7feWpCRYBI9shtgnbduO6gaGx0zcaw47IgU3ykskNGwGrpsRFio/gkl2uqVJHfaotTIfoT8QJ8OXGtpCGqd+qNJ8NiikmGQBr1XqFGhNfYSAE9AiiHN/JFTIuETHJbW3MVJe1spxpOW5gbBtzl5AntSAKz/XVzScBx8Bjg93hpOddiiz9zLvrUfmUDW8IP7B1mTW9qMmUa7dsfaZLReVveubYCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtNAiP/Ef8naVyFEWCO9eo+a3G/Q7GAASWIdF1bEnvA=;
 b=kHrVuwL77t39ZOXzPDFOq6TjD3hU9bwSM/Y7tert3ry57rVeEhyxt4KE5AJV7mo8lkYwzzXFNTwgPsVZwWhAPLehT3gO/XEz2P5qZ2Zzwxq/oqdaowgOVoVTMrOpGIiEikLAFMRuxlxk/7Rx/jEL7ZEHMeBKZKEC36/sa1x+qqtCxVFQzoU/oU/FWVa3v3SVzOa4SsqcVbHxxDwmkElIdqEZZvz3L+DTZCb3zCZwqk6W8ECpESDGDYPKfCDJCKezkvobSpSswBKivxz/6bCDRnQp1xlsdp/yY1IWm/aTXBHv2s+u9PsBGkd7ze6CI7GjD786rXYt+4H5nCMkBbj6wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KtNAiP/Ef8naVyFEWCO9eo+a3G/Q7GAASWIdF1bEnvA=;
 b=KDOEIO3zcic3e2i6RjcbopM8kWdDHqJcZmUEHRM041NnLT2xhZ16YVEWuvOyzlhDEVrYp/xSerwlOAIl8Lj1YDbI104vaO/1rleDTm2Ipk/8vv7AFkE+LJG+FuhXtUsHFnwPyzK6+aFPuF4bYqri1T6WI+1+HXDEPo+PnG1HWjM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB5720.namprd12.prod.outlook.com (2603:10b6:8:73::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Mon, 4 Nov
 2024 20:45:46 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 20:45:46 +0000
Message-ID: <b0a5d1a6-39ef-2637-ece0-387582b09fcc@amd.com>
Date: Mon, 4 Nov 2024 14:45:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra
 <ashish.kalra@amd.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241102000818.2512612-1-dionnaglaze@google.com>
 <20241102000818.2512612-4-dionnaglaze@google.com>
 <91984541-504a-f029-47ca-bde538e07436@amd.com>
 <CAAH4kHYqQAkUO8phdQaE=R0qHZjKBB1uXsKR3Nq5yJxeZS-o=A@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 3/4] crypto: ccp: Add SNP firmware hotload support
In-Reply-To: <CAAH4kHYqQAkUO8phdQaE=R0qHZjKBB1uXsKR3Nq5yJxeZS-o=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0184.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB5720:EE_
X-MS-Office365-Filtering-Correlation-Id: 970c443f-6b35-4dfa-8372-08dcfd11a84a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2h3ZXFQNEVMK2NpZll5ZGhERU5CRG05dUJxWmdKWlI0d3pLdzBKWEl3UDIx?=
 =?utf-8?B?OUJSSm1pSzhYdzFhZnFLWWtLTllRWVpCb2RZOHpqSzUrWExBMmtzV3JCS3d5?=
 =?utf-8?B?N1pUZG9FaXg2Z1J1a25LbS9aR1UwTkI1WWthVUUxZGlieTFOYVhKY1ViV20r?=
 =?utf-8?B?czMxWVpmRnBMdDNiK2l3SVJQZDMwWFNWN0Rpc0RXWktsc3cyZzRoVmhhVXJP?=
 =?utf-8?B?VkRURVZ4b1hzYnZKbTg2MjB3eXFESThhQU0rNzh4dXdTb2YwQW0xUzBiMHh3?=
 =?utf-8?B?ak1KczQyK3dnNHRVSUg3WFUwV2puU3NnUEJWRXdHY2d2WWo0OXExd3REWlRu?=
 =?utf-8?B?MWd6bDVJTmtGNlFVNVQ4RXdyRGRFanJQOHJVWnJpaVNtRitwdnZ4cVNlbzRi?=
 =?utf-8?B?bFBwL1hJK0YwdUpoVjVnWnpDN0dTVis1RGZ4K1FOQWFmdWg1WjlUMkVBUnho?=
 =?utf-8?B?MUY1V2dTMURvMmtZcWVKU1BSWUVkSDNpTEo0SmZzZ1ExdzVvRS9NQUxFQUNT?=
 =?utf-8?B?bkJvYjhQaFhyb0lKanQ5VnUxY3U1ZURURUlmeEVXNWFRTkJOWmdWRlVoeElr?=
 =?utf-8?B?M1RRc0RRWHhHTkZnVzFUSEhYYnZ4T1FLV2E4RFplQnd2U2JQakxWL1BHU2hK?=
 =?utf-8?B?THhBZzZLdzhuYURJcmRtWDZJU0VmQU1PUGJnMUdDWm1kS2MvRUdlMFg4ZE5W?=
 =?utf-8?B?WWptNC96ZDRDYnRYL2oxSFZuVGdiaTZwaGcvZ2QvR29UVTcwNzhhNmtxdDl0?=
 =?utf-8?B?cHQwWEJCVGhlL0NNMjF4eEdjc1V4aytTOVlocFNONFl5QWRBYWJrcEg2d3pl?=
 =?utf-8?B?U3BNRzZSUWFseFNSUGNqeTdwR2RBV216T1dsRTJ3MEtoREl5U3pVQUV6N2tU?=
 =?utf-8?B?cTdsem82RG83ZzBmdEk5YUF2aVlTbjBJMFdnL2d0a1dzZjBrb09qZkI1N3JC?=
 =?utf-8?B?SlIxR3JxRjBaVmxzanlEKzlTcWFhNndSTHpEMHR4UWFKUVNTb0YyTVdMdDQr?=
 =?utf-8?B?a1R0SkJRNkk0Nk1hU1ZKeGN5aWJMQjQwazJsbTlQYjFjSk0rbTQzZW1pd1Ar?=
 =?utf-8?B?YURSbFhDclFlb0tVNHJCRU54WHRiTXBGTml4WWdXSEFZNHZHYUh4cFpZdHBs?=
 =?utf-8?B?d1FMVG9nTnNpS09EaStVV2Y2dktYMy9BZ1QwRElGK1lwZzJ2d2lYb1l5a0l0?=
 =?utf-8?B?Z0FGTFdNRkl5OFMwQTNYNUpaQVM2OU1CdmdmekdnR21BYnVjMXIwYmMwQkFH?=
 =?utf-8?B?cWhyeUZxUDQvbWFnMUc3QTlqbXQxd01RY29FWmlhUHhKZVByQkUvM0k3aTB6?=
 =?utf-8?B?Y0FkbzZDM0xPN0x5T21HZE9DNWM5RGhoK250YUdtNnNHR3VaOUZsVHluc3pC?=
 =?utf-8?B?RGdrWS9ORmg0WDBvREJUb2FmQ3RjMEg5R3Rla3dQZlpscStacFZZMXhucmpJ?=
 =?utf-8?B?N3A1OXRzU1Z4YUpxQjZKSHgydzBCUGxibEdsWEFUcVlsSUppd3FNeU9oaEFw?=
 =?utf-8?B?eGN2bkY0L0NlR0IvOG1uYVVURm50WlcvcVp6WVgxQ1RFai9UK0tuRlJxdFQ5?=
 =?utf-8?B?RWlzUnJVd3RQcUpvYkRtS2RLcTRCbWQ0VlVpNVh1N2xHZjhXN1BsbDMvUWFo?=
 =?utf-8?B?ME1RclZoeDB3SStZVmJuVWtIek40MDFLVjcydUlmYngrNFhCZzRJNHFTWnF3?=
 =?utf-8?B?ZUUrYU53MVZDdHlyTXNwelZoRDV5WkptVmppRzdLek4vN3MyR0gzVlk2ektK?=
 =?utf-8?Q?X8yq6ACg5uhVsz244JmYtSR3+UEA1yBOTlUmLLq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elB4Vm9UM3JFOTF6UlQ5K2NQQTlZRElpZW4weml6bC91eFhnbVRLV3NCaHpo?=
 =?utf-8?B?c2QwbEYrU3FNU204MWZySXBZQlhrcUJSQUVKLzJ5dmhpdlU2YkZnL0oyYkZp?=
 =?utf-8?B?ZXEvaEZDR1g2L3VBQTh5ZGR4ZkpsWWNrZi84QjVYdzBoQlZHSDJ6QnlUOVV2?=
 =?utf-8?B?bTU1UnlXSmlBY2pNQWxpZTR2VVFEYzF6TXlPK0pzUWFVWlJYODl1aS9DMGJB?=
 =?utf-8?B?Ykgvd3Y1N21XZUxUWEV4bTh6WmhWUFJPT3E0dGd1Vytwdll2WElvcTN1c01Y?=
 =?utf-8?B?eHR4d2U4aW1hL2R6akxGSjJiTFB2clROQlNhZmliYlROVTBHZTc2TzlyRzA5?=
 =?utf-8?B?YlpHbTNmRW5kREkrTXBsaFBvaUVvYUFzakxlc3RGYTlFZkZVb01LUmE4ZXJN?=
 =?utf-8?B?VEFsTEJMOVkwV2V5VmpmenBxdksrUEVmZjcrakI5UkZONUI2ZHd4cTl6V3Jr?=
 =?utf-8?B?Ym1hTGdjSDBNRHBIWEgwZkptb3RQRG5QRmV2NkRKbVJhT3ZZVmRpczd2UEhW?=
 =?utf-8?B?V0hCSWZrNG94Q0JGOER0aS9PT0Yrck1nYWhqYnlpQk9jSndXbGNMRzlJVXRH?=
 =?utf-8?B?L1l3b3Y3bUlZK0FJdjl6QzlSeUVudGZwd3FkV2g2dWUrWW1STEpIRGtLWWhD?=
 =?utf-8?B?eWxnODg1QXlaNmZpN0JMNnpwSG42RXBrZ0NoV3AzQ0RuVHhoU0psQWJ4dFky?=
 =?utf-8?B?OS9pbzA2V3dhcHpUZWxXQnBOS0R4SnR3Y3hHT1hSRDNHVVlpeGZ1dERSRC8y?=
 =?utf-8?B?eHhhYnErODBSUm5aQUVoYllJTFBMeVoyMHRpSGtFazhERitNSXZTM0RvcGRY?=
 =?utf-8?B?bXdQWE9ZYVNBOE9SZTdvZ2k4bzJIWVZtby9yUTZMQ0lMY1gvZ3RZeE1GbzRL?=
 =?utf-8?B?TktGUFZ6TnlpVmlUd2Y1UW04S2lBcFB2Sys2V2I0aHNCWFd6N09wazdHQ3F6?=
 =?utf-8?B?Yi92RDVRekhiUjJLeFdKbE15WDREMGE2QWZKc0NKOWlwdFY3Vy91VEgzQ1NY?=
 =?utf-8?B?UTdLOTA4aEdhcXdmS09WSUxNOEM1emJreG1EdUdKMHBtRDErZWpkQkJDZy9C?=
 =?utf-8?B?SHZFNit1YnltWjA2cEdETVczVFVuYlB0V3o2bUg3QW9uV2VscTh5M25Hejd0?=
 =?utf-8?B?SXR3aEhNRWc2RVZXUzI2VlZIc2VmZ0srTCtpMVNheEEzUU5yN09paUlaK010?=
 =?utf-8?B?ZThrcEh0eDZXdUZGVDVvSDlnVHI5SC9nRW55U0R0S1BCT01RZnhwcUpxZ1VM?=
 =?utf-8?B?VWZWRlJiN1R0LzUvUlBEU3RiU3NVMllTM0dkQm5GM0N2Z3M4MEI2Z1JlaXBm?=
 =?utf-8?B?eUNZblBXYUlnT3Qrb0N1VXFuTzh1WEl5akxWbGh0L09ZZzZodGdvR1ltYjA3?=
 =?utf-8?B?Z3lYV2dPR2RkZklNRkN0anFYOHRFK3NRSlNqUXF1UHBUbGhENkRCdlYvY1ps?=
 =?utf-8?B?eHlhWGlhbUJ1SDJzZStwaVVqNUJpMU45dGZjMFowelRVT3h0OFZqdS9EbVZF?=
 =?utf-8?B?YUdHK21lOTQrY2h0bXJTSjdzTmY2L3hEK1YvK0hVaFZZRG91ckJrQ0hmMFhC?=
 =?utf-8?B?V1haTTV6VHRWNzVHbXBQWGdlSW9DSk8zWTR6RXpaaW4xU2Vpcll2ZTBHWW0v?=
 =?utf-8?B?RVppWFc0UENYMXFibWNLK0UrZmVWOHRiZlRpc3d0RFBwbll1cUIwZGNLL1hk?=
 =?utf-8?B?YkswZjBvenZGY3FLTEIybGtQTW12d09DSDcxcXdtVU5wZ1UwZndHam84QWE4?=
 =?utf-8?B?OTdVNldhZ1A1MERsU2FDRUt1Qyt0VkJQQ3JHOEEzTzIyMjZPNDI4NjVybmRN?=
 =?utf-8?B?WDJyaGF1eGhVeGlEa2FFdUtJQnI2VVhFTWFwWjd2Z29MV2gyeWFRMldteFRp?=
 =?utf-8?B?dXF1RG9RWGE3a25qaDBrZVVwTUhwbzdSZ0FSWlJ1aW1ldDkzaWxvZWtobit1?=
 =?utf-8?B?NXYzd2MvcW0zTzlKK2dmeGFjODBYL0hTSUJBODhRODd2aW9Yc0dkRWlMVm9Z?=
 =?utf-8?B?VStnK3Q5M0hoSUY0ckY2ay9EU2g0VjI5RTBjNEJSZU9ScE5rc0JxY1hUT3RZ?=
 =?utf-8?B?N1ZmKzRCRXg4ck1MV1NxS2pEdmgxeXZlUkx5SWRQVFg1aGRrZUdiQmlwVXFU?=
 =?utf-8?Q?j7QmErsoRe0/nJotU1Bx1VB4Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 970c443f-6b35-4dfa-8372-08dcfd11a84a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 20:45:46.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVG5s9HhV6p1dbuRzVbiBGffdxQGIflbtcNdGq7Xk8erWmXGN030EklnRjjmv3Y6EB1rqKJfA2B4jNP5P73S6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5720

On 11/4/24 13:30, Dionna Amalie Glaze wrote:
> On Mon, Nov 4, 2024 at 9:06 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 11/1/24 19:08, Dionna Glaze wrote:
>>

>> This is a big patch. Can you split this up into smaller patches? At a
>> minimum, one patch that adds the context tracking and one that adds the
>> firmware support.
>>
> 
> Can do. Would it be appropriate to also add a sysfs attribute group
> for sev that makes the firmware version more easily readable? Or
> should I put that in a follow-up chain?

That would be best as a separate patch series. But doesn't the
SEV_PLATFORM_STATUS or SNP_PLATFORM_STATUS ioctl() give you all the
information you need?

Thanks,
Tom

> The dmesg log about the firmware version isn't the best for writing
> automation for managing firmware hotloading at scale, and we're better
> set up for working with sysfs generally.
> 
>> Also, can the guest context page tracking and new firmware related
>> functions be placed in a new file, sev-fw.c or similar, that is
>> conditionally built based on CONFIG_FW_UPLOAD. Then a header file can be
>> used to provide the different implementations of the new functions
>> removing the #ifdefs from the code.
>>
>> Thanks,
>> Tom
>>
