Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F611BCA05;
	Mon, 11 Nov 2024 22:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731365213; cv=fail; b=nCwoPp5O7cQdvNBlxMP+uWsWH3dCYIZuwBNLKwcmUWFh29adrVmOCFSnRnTh4jqHlnmu00/ypzJZliDWtZFRgtC3Vtg58Z/jH2vHJFnBsvKE3uzPxGkvlhkA2Z+T0CRSlUGVKWZkSK28JjKnvxq/1sOMF2Kitn9mqNuRu48s+RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731365213; c=relaxed/simple;
	bh=mbum4J5jYUQ+xYuhSKRjVGv4AKZRO/1MDgd3oDdP+/4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t/M3ZH7o4kq+FlM5cmQhStcFX4juiH9ix1s0NpQO4GQDymRalCK5HkOM/QBIYmO3gAt1Swn1dIn+jebpV5mC9wNsNGQHZU/3A8d+4PgmR72EeFwR1fURndz4xJD2kUOJAHv4J8T4wvHKpI3F/gtfesuQYCX8shI9GzQqP436qZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HrdTjIQz; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HrdTjIQz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6cxJRd5A2gl/LwCdKr2hcG5mrq7IMbxTm59y0ItDr2Sp77QmTGgJBZEqG3WvZaZCX5raOnouehYCWvgwGwuYK4CRBFruXQwoRLlZ/zK8sOOf+UginUgjHDozD9MCzjEO47IkBDumGF1t5tL0EoTWpCdKxJCdgwPZ8J8zSAHbtwTR7pkpZJ2s3AG+VTGF8moQRhohrQ5erbYujzoWMF6Kku0wGHF/XZ+dNXvvYKgxWnOz8DUUnEZ7sH+0yqVHlrQfQxndbsOPTofpcWAyVm1/Ih9AyqAFnHzOmFNLIHfeas4I+sjPVx7fNqHMygOcMLUt5IW/dHPkdN7g+UeGdgOWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EwYUsYlQgfwfsaCm5IERb1H9C0kgLDOg5to57y55n4=;
 b=v0v86Z0DHJP+TpYHsGM0XcaC12/dxHkFBsFS46fsnZO7L7zIRbBB/OJNuOqdt06V7Rgkdj72IqCnKUvxUGlcKbb0bOFJfOm041oxenJdsI6H9yHAGyYjoZhziB6+OkPdDf9Vc66s/pYsW/oLLHMnc1XvxQ56FJdXhVKWdKKAIm66xUubhTRM1s1hNdYk5I9lFFuNg7KiCstyMcqyRXIaXP9aDLY4Ow40yfXB5DzKbIpndUnd8k8YymeTt3S+i/GFSe/vwYAzmoQLx1MLtMtNK9sK8IrTC3f9q7SESzQalPH/NgbDXdBm1jQz78OVEv82V9sTQ+6P98G8T4Ma8T9TBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EwYUsYlQgfwfsaCm5IERb1H9C0kgLDOg5to57y55n4=;
 b=HrdTjIQzYDg4/GqXjMqHL5jrOvFbb3vKHwTgLDeSrUvWYlQfIoC0dgxAQIPXd9Gu1a2HMAUzfuyXwcEvALY5YbfecHuS/mfj5HPSJXqHzw+pE1ragnqGHzWqFMkr+3Yo9whBWpKc+KhxAmUFhCzklmAuK+DmirSuSjIAizZZ7WQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.26; Mon, 11 Nov
 2024 22:46:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 22:46:47 +0000
Message-ID: <4ec6b73f-4707-c93a-f046-213ac4d4549d@amd.com>
Date: Mon, 11 Nov 2024 16:46:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 07/10] crypto: ccp: Add preferred access checking
 method
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
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
 <20241107232457.4059785-8-dionnaglaze@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241107232457.4059785-8-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e1a01d9-6f6f-4687-3c19-08dd02a2b91f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHM0eUtDRExRNE0xMElsUk9WSlloZUtlM2cxajRNWGNZQlN1ZEpBbVY1UENs?=
 =?utf-8?B?UXo0ZGRiUUFGcE9PczFvSENPNXpqaE1vNVJqZFFQUmpFNHE1RE9vaHozVlcv?=
 =?utf-8?B?Wm1RZXRVTzdPR25uTUozNVdnRXROa2xhOXBJb2VFWlpnQXY1a1BxQzhCUThZ?=
 =?utf-8?B?NCtrSklnczlZUzFMeUhleHhVRG9JTENwY0ZiL0srSndTS1cyK0hqTkl3dnRK?=
 =?utf-8?B?ZURwc0pnTTc2UlpOUzgzcUhIMGRhVnRjWVY1ekNOQVdTam15Z1o1cWo0MEtB?=
 =?utf-8?B?NEl0TlQ4Zi83cnZnT0JvM28wbmM5aGtJYTNzWTdLd3Iwb28vdmtlSnpKa0xm?=
 =?utf-8?B?MlNBNEJRUjhvMkVjS2w5eFd1QTI4U3NlZHBwRU55b2JyTHZkL2ttR2J6aWNJ?=
 =?utf-8?B?a29HRVo4L2hjL011SEN6Q2NtWUpCb3FpZExUeHpOTUM1ZGQ4TVBMeHcrOXgz?=
 =?utf-8?B?QXZZcHM4QW53TDd1OVRTNGJNdFd3ZC9kY2JUSUFSQ2g1ekYzOUp4RG9UMHRS?=
 =?utf-8?B?Zks1WkZCNnBHVHV1OXg1OTA3aHY1WWNHd1NYTEVsd0xDaU1rUnd1WHlPSDhD?=
 =?utf-8?B?am5NNDRUcnNRZlpKTnZyNTdUajJycEVDQ3EzQTJyRDM1U2hOWFpJTkg1NDB4?=
 =?utf-8?B?dUNEZVpCRW9PcWt5TW5JMHFNcmRnRGtTcmdad0pCOURYRDNYZlJYM0FtZ1RE?=
 =?utf-8?B?WHV0NGdwcEQyWm5HZ2ZWYVZFS1JjdUpTNFNGMm9qOXRyYlBzbUJTSnZ0ZUdF?=
 =?utf-8?B?WGg1djNRaDlGSGcyOFpoK1IrM2VWQmUwMFVocVpNOEhPVmxmVTg3WHFyWVph?=
 =?utf-8?B?a2ZTeTBUUTdNK2FRMEpNTWZaWE05cE80Q1BnRXAySng4V3F4cEp5SmtNVHpV?=
 =?utf-8?B?d2R3cFRJbTlFazMvaERkbzF1Z0MwUVo1dkVWRmdpRkVtQ0xWV2dDZ2ZwQ3VG?=
 =?utf-8?B?K24vYmVQRDllL0UxWmpCUDJoKzRlWFJBbW9haUROYVZaWXJ6Z0V0YTduMDhl?=
 =?utf-8?B?c3Y2WWZ6U21GdGkyNDdFUEdTMGx2THNmbTBTc2dDZ3gycFFKNEJMdzd1L2dC?=
 =?utf-8?B?dlQwMlBMczIrb1NlQ3RXcXVjdkY2UkVJbnpCL3I2WWFLS202djdpZ0lRUjFm?=
 =?utf-8?B?UkNzRldjWWIrVUw1Yjg2bVIyZ2grOEdId1Q4ckNFM1RtL2lhcVJpdnN1WFV2?=
 =?utf-8?B?TEVEcE1qM1dIc1FzZ1dENGtsMkVyMHBaTnpZdTdDMW9LVWVrRHhRbkVVRUpJ?=
 =?utf-8?B?Q3lLZHF5SG5mbGh0RG1WYWdIZjZic2RCK3ZBYXZsdHREcDZDaEFuRUxBNGJF?=
 =?utf-8?B?ZnRpNW9xVkNqZWdrUG8wUmYvMDdLRThLSWdEeDhMbTJZV21uZEJ3d0VlSTZq?=
 =?utf-8?B?Zmt5c1pnd0NRYXVCdHpqT3ZUTTFMNkplVExwK2YxNkw4TDhPbzJnN3BlT1B6?=
 =?utf-8?B?MVpqeDkySk15dnN0QXRGVDNYd1pNNlc1R3d2VmkxbU1VOHhRSUNLYVJ6RXRi?=
 =?utf-8?B?NmFJZzhYc2gvcTZ3eDhOVjRDbFlJNzQ1ZUdScHd0dWxVQzM1clpwSGpVNW96?=
 =?utf-8?B?WGFGaERtbmM3K0JhRGdmcjgveC9ING1MRFh5MkhXMmlrcFRoamVzdjg5VnBP?=
 =?utf-8?B?QVc2UzZVaG5xOG5qMWs5V25mWjAxdzZTQjVPUEpQc0MyZDcwaVdJdzM1WUMr?=
 =?utf-8?B?ZnVYZTNDK1RwK2J4WnF3ZnZUek9RV3BTWlNYaEc0aW8zRUY3dHprS1lTMmFl?=
 =?utf-8?Q?IrmCehICW3rP5MEyzdu1eYwD7srer5uGnCiD6+f?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkVIUkMxam5uby9kQ0pCWE1VZEhzUFdESFVaUGxhT0hEWlNndVc0bzVrYUFx?=
 =?utf-8?B?NzlQUjFwMEMzR05BRCtOMEtJUERVZnlMMUc0WmFlR1hFUXphZXhBZmVWdE5p?=
 =?utf-8?B?ZUtubkFwUHNHdnp3cmc4aVRlcm1oWU90d2pBaS9XQjFPeHlpZlRYc1dEcVF1?=
 =?utf-8?B?cGZjbjRsNVZoeWloWE9FbHNGWU5TSXJhYTk0WFJQRkxjdGE2aVV4RmJCd1p6?=
 =?utf-8?B?VlF1VE1MSUZLTkE5RTZ5bU5yemVEcFMzbUZXZ1ZsNCs5SlB4Rzd5L2dvVXJo?=
 =?utf-8?B?S3R0T1lTM2ErclpsTWpjdlpkNURXR1pOcG5FR3Q3d1dDYThKZFh6b09kcjdr?=
 =?utf-8?B?WXdJVlNRdzd6UkxRNEdYaWJXUWdDaW9NcVA0Mmp5KzBMQXFiQXZXZ2UrWUpv?=
 =?utf-8?B?SXMxQTlybVltWXZZZUVpNkRzNTZES0Q3RnkwZ01SYzMwQSt5bFpiQmowN25N?=
 =?utf-8?B?RkNadmVQUlFTNjBGWm55SmlrV1JtcFZOd0djc045UUc1b1NoamUwSy9yUXZZ?=
 =?utf-8?B?QTV2Y2ZUT3VrU0xtRS9KOWR2MFF6RnY4MExRUm96QURFNmJTRmplUXE3dGpI?=
 =?utf-8?B?ajBiZStueWNSYXhqQ0lrb3pQQk9qRWJGYzgwUlJ2NVU5RlZCVFAzUmRoNG5R?=
 =?utf-8?B?TEVLcC9TOXdRaTZRbjN3dlV1NDBxMjVmNEdOaDdWTnM3dUJWcGxqWnRNMjFz?=
 =?utf-8?B?L1Rydnp5bXlXVUU2TnA2dm1LRWtaRDJRKzl0L2FrZzQ3dmF2MnhuNGlaRThu?=
 =?utf-8?B?T1NNYTc4TnlPWXpWSDN4eHE0L3RUY1lpWUQ5ZklDQ2VaaytWc0c5MDVPU3NQ?=
 =?utf-8?B?MnMzTTBoblp1MzJFRk84dHltQU5EanV4MEUycHNaeDEyQ3c3Sy9mbXBmc01l?=
 =?utf-8?B?RGZXek5OaUhXYjNyUWR5ZnRqK2FZY0kyL1lkUmZIczdGTUtwUUpJRm4rK0xU?=
 =?utf-8?B?VjM0bE5xZmxMRURZSm0ydlhBK3E1blRmdlVhb3VBU0Q0Vkc0ZWFjWWxzbXdI?=
 =?utf-8?B?eVB3QWtjUk9DTFMybXNXMkJZTmJqTHVNZkRpMFBMWWJYeklvYktRZVpSSTFs?=
 =?utf-8?B?RzNiVzBKSlBiZnl0dUNjbGc0V3pjZWJnTUZHMTh3TGU5SCtMSTFCQmZ4T2V5?=
 =?utf-8?B?a25PQ3hYSXRITUNDajFCdGMzS0xVdm1PbmtiRUpsM1NqeS9wQmE2bEgyalFN?=
 =?utf-8?B?a01qeEpIOUNXeVdML3A1SmptRG5QemUzd1Z4U0MrcFFvUlJHYmZFdzN4eDFT?=
 =?utf-8?B?NG5ZZnJRcTZIY29ZYTllWU5waVBQUUhrSmxNVlpKcTdjaHVNRzN4RFJ6Umto?=
 =?utf-8?B?amNaVmduVkVqWmNFQlJxOHZwc0x4TTY1eTBod015bnpmUXRNUjJHUFArYmE5?=
 =?utf-8?B?aHEzK09iQ0JOQmhLMndMNFBmMzRaeXgyUEVhUzF3enQ5UlJ5Q3VVTElNOU01?=
 =?utf-8?B?RkIrdlBTeldJVnZNWE9wWUpQSUE4Q0VvK3ptVmlCTURRVFZBa1duTCs3NzNI?=
 =?utf-8?B?TmRSbjFwbHlrZW9VRG16MGRvN0ZxVkQxU2p1VVpvaFNCRGt3Nk1yZUxWR3l5?=
 =?utf-8?B?dG55by9wSGZxWm04OUc2TnV0QUhGcSs0WExWOUZuQWpnNzA3RzRLWlRsOXFQ?=
 =?utf-8?B?RUQ3WVBDdHd6YzNuKzZYcERBNTF4WEVLbHczQ21FYWxmcVlCK1M0ODlLSmFj?=
 =?utf-8?B?VFFnSmJpR2psMDAxYUVKaUFiOWlwUHZjczdsazZNYVozY2xBOGU4ZzRSREpY?=
 =?utf-8?B?QXlYRW5kRTIrT0VLdGJoTjNaL2krazRTbGtDd3FXdHZZNzhtRUgwRG9jMHRP?=
 =?utf-8?B?ZDFUMkxEMmNISStjVWFJaXNieWRUemg0aXM4RkUrL08rZEhocHhRaW5ZWUZZ?=
 =?utf-8?B?WUVzRVRWejdHMlhpMXM3a3RrQVdUazM0UUJlYm5wa000Y3dBcDN4UE5ITGt3?=
 =?utf-8?B?UlBPRHl3K3pRYktjNmdoaGliZS9YZkJJckR3OUx4T3loMThkLzVrTm9tZXd4?=
 =?utf-8?B?ZGRGQzVwUWNVQmk2MWl4aUt0c1duUWVIM3dDWWx3a1BJSjlOL3A2THpHbEpC?=
 =?utf-8?B?MFhlSVZpejF0YnRPT0lremkrei9zdkQ5MGkyQmpxMVE3TjRUbWYxakxkWkRa?=
 =?utf-8?Q?XRmTce8dWY19FnlnOBNN1Vupf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1a01d9-6f6f-4687-3c19-08dd02a2b91f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 22:46:47.2380
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bLIrzeVS98/+xbN+fRDXw1TptJfx0eSfuTdD02UvesY7l4nKNGGCuIzwMsGHD5JJuX2I5iPp6FDdqhaGkuSVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644

On 11/7/24 17:24, Dionna Glaze wrote:
> sev_issue_cmd_external_user is the only function that checks permissions
> before performing its task. With the new GCTX API, it's important to
> establish permission once and have that determination dominate later API
> uses. This is implicitly how ccp has been used by dominating uses of
> sev_do_cmd by a successful sev_issue_cmd_external_user call.
> 
> Consider sev_issue_cmd_external_user deprecated by
> checking if a held file descriptor passes file_is_sev, similar to the
> file_is_kvm function.
> 
> This also fixes the header comment that the bad file error code is
> -%EINVAL when in fact it is -%EBADF.

Same comment as before. This commit merely creates a helper function, so
this commit message is not appropriate.

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
>  drivers/crypto/ccp/sev-dev.c | 13 +++++++++++--
>  include/linux/psp-sev.h      | 11 ++++++++++-
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 498ec8a0deeca..f92e6a222da8a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/bitfield.h>
> +#include <linux/file.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/kthread.h>
> @@ -2486,11 +2487,19 @@ static struct notifier_block snp_panic_notifier = {
>  	.notifier_call = snp_shutdown_on_panic,
>  };
>  
> +bool file_is_sev(struct file *p)
> +{
> +	return p && p->f_op == &sev_fops;
> +}
> +EXPORT_SYMBOL_GPL(file_is_sev);
> +
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>  				void *data, int *error)
>  {
> -	if (!filep || filep->f_op != &sev_fops)
> -		return -EBADF;
> +	int rc = file_is_sev(filep) ? 0 : -EBADF;
> +
> +	if (rc)
> +		return rc;

Get rid of rc and just do:

	if (!file_is_sev(filep))
		return -EBADF;

Thanks,
Tom

>  
>  	return sev_do_cmd(cmd, data, error);
>  }
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index b91cbdc208f49..ed85c0cfcfcbe 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -879,11 +879,18 @@ int sev_platform_status(struct sev_user_data_status *status, int *error);
>   * -%ENOTSUPP  if the SEV does not support SEV
>   * -%ETIMEDOUT if the SEV command timed out
>   * -%EIO       if the SEV returned a non-zero return code
> - * -%EINVAL    if the SEV file descriptor is not valid
> + * -%EBADF     if the file pointer is bad or does not grant access
>   */
>  int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
>  				void *data, int *error);
>  
> +/**
> + * file_is_sev - returns whether a file pointer is for the SEV device
> + *
> + * @filep - SEV device file pointer
> + */
> +bool file_is_sev(struct file *filep);
> +
>  /**
>   * sev_guest_deactivate - perform SEV DEACTIVATE command
>   *
> @@ -1039,6 +1046,8 @@ static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
>  static inline int
>  sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int *error) { return -ENODEV; }
>  
> +static inline bool file_is_sev(struct file *filep) { return false; }
> +
>  static inline void *psp_copy_user_blob(u64 __user uaddr, u32 len) { return ERR_PTR(-EINVAL); }
>  
>  static inline void *snp_alloc_firmware_page(gfp_t mask)
