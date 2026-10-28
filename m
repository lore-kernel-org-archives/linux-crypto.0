Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793224840;
	b=x3ZFD1aF4eWQ6QNWkPkr0kRZOFKYDB/SQ928wCD77W/hCQkf8NPtFs4g5ON762Myq6SP
	 R/VQTb2yMZPXiIphhWlp2U7AS6Ukl/o4AEU1oGuPYM2jFtdGnYnjc8vrMDawC1Ki0gOym
	 rnQHpOVlNp4378m0EhhS20SAn9pdSXspXltlgWwxqu5dH9Rdm1LYpwMg0RHavChRYuGdy
	 n7JX5Zt0hPDr+gasa103dnLFbAdNrBo2YFIKckCLbmhgqdDAZIrLs2Wp7wVVTqjQKzfdj
	 ffnpzZcj/OFL2UqJESFtqm+zoOsKEl50tt1uD+fUeCP2t9DDOpF5Gnnc+wey/5kzVAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224840;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
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
	bh=ayLxb5ATDsQi+PFLsDuE2REZstAMumexA1ei+Dnz30I=;
	b=Rt+0XBiw8Ujv1hkizg6lJ3OGw3mZabMZLjqyWvpJjc8EQK7HcENC1CSa6+y7AlKBzqPm
	 hXkyR0S3s9aayR8trYo2Lbr/EoSKqfoLDecBfkViEs+g21WcQZGwmCM3WGn3VAwxw0d4z
	 rX4cAqxVMi7zV/LZ571YYxPxffUpU5PDdJKSc7mEzRtkFZZng9m8f0NzoiquYt+yKBlGQ
	 rV56P8xXDR8cORDMJylbUm3Kzck2wHQPupLCPK6ls5FGten1U/4F6b166ivQjkdEaXrC6
	 Sw/d9D1YGljMuvEDRu7j0U8fQsRkFgmWtorPP7cxmVluqJh8grcAR35lJqj5N4Callw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dOh7LeeV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.60
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010060.outbound.protection.outlook.com [52.101.46.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA1606A323;
	Wed, 28 Oct 2026 22:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69FA1606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=dOh7LeeV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eFqg9gfG8jvKMpNVFu5V/Av5sIodvzxXYBCLYGrlL12pCISm+afnTGQ/Go5HbSfR5XacpQNGiLm8zdRFZzyEpUhDWqGStI7tCm4Rm4PETTkqCgmX2AjI+uBdWSL1L1tbke4my9u0mSaJTphQJgvKapDHIpvAANfhc371qfP726PdIWyh7ZTIA4FpnNxcyWAe4QROOpjpQdC4iyg9G9Nd2TT7rlBFu7akX9FSI81WOQv7mQzPkCPZVNrmuxmqVKNJ0n9iAvgIFV28Q0RpuDW4ksrvMWfvhnkoKocsoOcT+XrRd2IhmQDdOhu0Tw3Zv4afYXvRpE7cDBPrbi4LUDUJ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayLxb5ATDsQi+PFLsDuE2REZstAMumexA1ei+Dnz30I=;
 b=V4SdNp70qCU24GShxcUnpKNruMxsGMPo38zVYIh+grJpdkD6jvH3NgxcwUfOr6ZMCvSufX+sb2fHQ+7pNfNyy/da61WKUdjqO+naGKO7OUjj3caUD6IkjJPQNGC3gpEW0fdeklM5O7I5Jd81dGs9fnqb5KJgmNSB3uFCxXPk26fafpLJLjcABHnwdgLw8IkTYi0f7LZBpYICtWDPdDOm+ayF4bnXousUMnqFscpfz8I1g/qJa3kNcV1ShjkMHHso497iMBB0z3298DyKuOlUWtjNyuAgvrdhCfUg/T87Eb8vG+ym8HmviFvAKhjKh2frT0RZ8mUx6F7y7c8amBMQOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayLxb5ATDsQi+PFLsDuE2REZstAMumexA1ei+Dnz30I=;
 b=dOh7LeeVrxyJxz98pQrT7b+dfx+nQh8i00/5Sn3sYCA6ljhvnNNgUpik71SOAUOeedO7OkXO5NYGxfcU1LUFE8sw3gA0iNIJ5DPq8Pg5TSwN/+phWixSIw0l68MjuotfoQb9yJ3gDWVD7wzjXmvDvovaj3Q3XSV5FrTTQ7i5I/U=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) by
 DS4PR12MB508551.namprd12.prod.outlook.com (2603:10b6:8:50e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Wed, 28 Oct
 2026 22:00:35 +0000
Received: from DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c]) by DS0PR12MB7771.namprd12.prod.outlook.com
 ([fe80::9a3e:791f:33b6:3d8c%4]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 22:00:35 +0000
Message-ID: <cf750bcd-1ae7-4aae-aa8f-593d8248fea4@amd.com>
Date: Wed, 28 Oct 2026 23:00:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] x86/sev: Set up RMPOPT only on an active SNP host
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <331aeb2f29710865ec064bacf9edacaadde2b094.1793216372.git.ashish.kalra@amd.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <331aeb2f29710865ec064bacf9edacaadde2b094.1793216372.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0281.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:373::18) To DS0PR12MB7771.namprd12.prod.outlook.com
 (2603:10b6:8:138::6)
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
X-MS-TrafficTypeDiagnostic: DS0PR12MB7771:EE_|DS4PR12MB508551:EE_
X-MS-Office365-Filtering-Correlation-Id: fd9012b8-a72a-4d0d-b4a0-08df353ee4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|921020|261028144727099003|11063799006|4143699003|56012099006|261009223027099003|261026121527099003|261022105027099003|261026140227099003|10067099003|261021121427099003|261021123027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	pfH6cM2jMtzDDsNqBXFfHSQnoEp3IzaPfIniQX2smjpQMYosar7iZmWtGRSrMsi804DBXf3quyX3a3wAfD4B7w0yILO1u+7c4JoC6abh5TGiGMRheh1bQ3RmvTSvv1J2aTtIM4R/+ZnEMQzjo/ZRPENPyPhQfq/wSYMoGg5bSrjei0ItjJBCQ7Ut13h9qoxTS3QIrcxpk4nKZ85bmZLKEyh1tSGOC/CHQ1VMqwIxIa9w2fmssZAzgjUcuK7G96IOFZMDBFAUXsq9MBXPgXKG3lp6JnE5OxV2XCDxhOklWXYs2v7KeDTlwytSnEyCc+eQ625UVFhpxRnYHaxKbcDdgW1V/grtHnjuY7Y8N3niSn+4IAUwlfqLiNuRV9M9mPzqF/60gVrsaR+tJrjjhubXuMLmOfvVDdLPh5L5OdNGJ6gdBdXYxvzh+hJRrtbhxqcpbwn7XVokwL1om/KqNDGGLxHFIxmAUvf3Il7R9DYFz9nsfTT6jCTNNdd3xny0U1BSc/pfpdmnSMoBsD69mX3F2+FPjnZKNjGsqg5JU+ItApb3HdpkSz9trIO1Wr87SKsPcrlrszSLKXpQdhXZIEShTj6K0GDJs7mEguA9bac4bZUDwIdXFWNuDUGIx+CAnWej8VTD7auokhhtGaxjVvA+GtpAUkiPB1aQ4G9xEVsl3eKhHWXZH0ziVo/W89cd9syD3fe2PC+gFHv7DBD7l0wsVA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7771.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(921020)(261028144727099003)(11063799006)(4143699003)(56012099006)(261009223027099003)(261026121527099003)(261022105027099003)(261026140227099003)(10067099003)(261021121427099003)(261021123027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkpJWDN4aUN6OWJTanRQSnpGZC9UUFBFL1JrOVI3bDhqVm1lcjlCU0VGRTc0?=
 =?utf-8?B?NHBWK1JBREdqd2lXci8zUW8xQWlndEFIaWc3QjBRZ0gxMWxhWldPS1NtbEVo?=
 =?utf-8?B?dEY2ay9md0xhTTVENU8xSXpnQU5mWEVwZlROM2ZreG91WllML0UwZzBHZ0s5?=
 =?utf-8?B?NzBBNDRiRDVFL2RFeER2SWsrbURuM0RaVTYybzM1T3VHaG9xaHdsSlJaQ3Nu?=
 =?utf-8?B?dlJSVG9STzlkRUlYRWRidFVqUVJYRHljWTJWWHp3QXE3RW5NWFlaOXVIaU1O?=
 =?utf-8?B?Y3VhWWVYZGhnR2ZCSVFXa1RHNStZZksyKzZiWjRuTlhINzJIdjJTMy9YenNQ?=
 =?utf-8?B?VFNrL1dLb2xjMzdrK3pWM2pVRDhqaGFXMGZmV3NaQVNVQTR5UkdTTnJ1bmp6?=
 =?utf-8?B?bTlJSmhtVUZKQmhBZnlhMVlOYVdDSXRDL3puOFlGeTBFcm9mczZhVkdGT0JU?=
 =?utf-8?B?UWlHL0IySVlUb0lhYWVtQ3c3QTU0YjNXeWtDNXJZUUlDTnhYdUZFSjBmSWhj?=
 =?utf-8?B?aWhjOGNQeGpJejlaeW9YZXhMNEtqTVd2cjZ6dkk0OEc4a1dDWEtqNXR6TzM1?=
 =?utf-8?B?OWVscTRMZzUzSXFoNjZLaURwT3FjeHcyeUtIM01jUm9EZndYdUpaY2ZrLzdk?=
 =?utf-8?B?MkEvL1NiK0VDcituQTNpbUFrVmZSNmFUS1lLMEY0YVBxZ3JySG1uYk5wdDJ2?=
 =?utf-8?B?ZjNpdHNrbmlOYkFLMXVIYzJmYzBDWE1qaTUwSTFoR1NnZ0lTU0w2aE5OZ2hC?=
 =?utf-8?B?QUh1b2lHR0J5bHBTNkVBV244TjJybmphVHgyb2poOGZHTE50UFVhRjYwdFp2?=
 =?utf-8?B?ZFdJREI0dlU4bkZTQmRpZHlsT0h1UEkzZXRwbjZkRCtneDgweE5wNEZnbHFG?=
 =?utf-8?B?YjB1NWFJUnR0N0w4cUxvRDF1YkwzSDBUM1lHQ0ZZZDhLY21kcktTSkZoS3Fx?=
 =?utf-8?B?TGdIcFRPZ1RVRTJleHZpa0srRDM2Q2pBSDlZeU14S0hJR0JsTUZNemM1ZUZp?=
 =?utf-8?B?aGlOQS9kK0RZSFdmcWhPdW9uaURtWVpzVVkvS05PRG11aHI3bExTajZJODJ3?=
 =?utf-8?B?MlVXYTBYalc2SUxVaE1qK21vQlNXYXd3ckNPSUFiY1J4ZmdOeC9PRllvMUNJ?=
 =?utf-8?B?eFc3OXNiaVFjY2w2Y0xYaEJGOXZPSUQzSkUyeUdlQTlscU04MTVhdkVoSzg1?=
 =?utf-8?B?WFFuc2Z1cDlaOEpUVG9LMENpQmJ5OFllY0hVNVY3U0lJZGtPVEZjWE9NVXBv?=
 =?utf-8?B?a0NTa3VzaThQWittV2svZU9pcTVRVDl6MzM2a0dubVdXNFc0b0pGdVJSRXZB?=
 =?utf-8?B?eEoycFFFbklOU1FNdFl1VlhtRTJpblVOdytNK2hSODBCY2NjRzhmRUZjclRW?=
 =?utf-8?B?NTJjM2lVNnlVWWVBV1V6bXA0QlhrSVF1KzNieGRYVXNMcTZLVkc4MTNYNHd6?=
 =?utf-8?B?K2R4alpUWVdkUG9maVBmODBuZUdFSHY0aW5FUVlQNC9aZ3NTSG16Qzl3MWMz?=
 =?utf-8?B?RDlSV0dSUDZUeWtKZ05JRjUraVY4dURqRUo4OHdma2V1RHhQYVBDdDVTdFRq?=
 =?utf-8?B?ZlVLdEdqSlpjaHlTbzJnTlB4QmQ5TFdxNVVoaFpwNEh5T29IRjhoVGNTWW1P?=
 =?utf-8?B?bHdoQTdNTFNUaExaRFZ5WEsrVWI2ZjFucG14ZURxWFFlbFhHMTdlcWR2WW9s?=
 =?utf-8?B?Tm9YakU1OU14ZWJiS1EzSklyaDUzak56cHJFTzg2NzV5Umpkb1hHT3J6V0lI?=
 =?utf-8?B?QTFRd3JycnFwMlJheUhPMXZKbm1PbHBpTFpSeS95WDdQTEljTTRCeWNiTWFJ?=
 =?utf-8?B?TlRCSXNRc2dibnZYK0VabmJOZ3YxczBDdWVBZG5uaGZYcHMyY29Ya2FPOUFw?=
 =?utf-8?B?WUdzMEJPaTRrd0NaK0xZakdEQk1wNHhnYVBFa0hrZUJsT05JMGkxL2pnb1R3?=
 =?utf-8?B?a1g5V28vQ2JDenU3UVdIdW42bkE3WmdnWXRrajVwV2hNTzhiRjhESWtkb1BO?=
 =?utf-8?B?SUZ5UmhtZ1pmQ2I1dXB4cjhrZUpVTEdtVW5LTUNRQTdXQ2RrQUJtcDVMNS9N?=
 =?utf-8?B?RmhjampMSWhjWHFncmFjWmVEWVRGaHZBa2hTcW40dU5PQ2hrRkMyTlNCakdr?=
 =?utf-8?B?SE1UNXR6eDF1cnFxK3JPOFhiM2ZnSm94WmlCZWhuRDZCdkV4cUp1S25mM29u?=
 =?utf-8?B?QjRoUm44VHdwcTE0OGNiUFZUQlhBZ0RPTVNmNWRYeUo4end3eW5LaWd0dGx0?=
 =?utf-8?B?dlBDNFRTWnZxM1lSNjJtSERTZDJ6ME1YaUhuOHFhOTQwRHFvZUMydHl3SGNh?=
 =?utf-8?B?Ylp5VThEOTFsYmo3dWp5czFiSndDNHBISjZSVTBRNjdnSTZkdWcvQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9012b8-a72a-4d0d-b4a0-08df353ee4c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7771.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 22:00:35.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vl2MzD2idvsEeO592xQW6+UjEr8p5xoqiaVwQ+G9x+AhL8nSBBLJ1lMvMFcOuOumsyAfDH6noP9tZiyiylNmJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB508551


> From: Ashish Kalra <ashish.kalra@amd.com>
>
> rmpopt_init() allocates the RMPOPT workqueue and prints "RMPOPT
> optimizations enabled", gated only on X86_FEATURE_RMPOPT - a CPUID bit
> advertised independently of whether SNP is active.  As a device_initcall
> it runs on every system with that bit, so on a host where SNP is not
> enabled (disabled in the BIOS, or AMD IOMMU initialization fails to bring
> it up) the workqueue is allocated and the message is printed at boot even
> though RMPOPT is never used: snp_enable_rmpopt() bails out on a non-SNP
> host.
>
> Rather than add an explicit SNP-host gate to the initcall, set RMPOPT up
> where the host SNP state is established.  Call rmpopt_init() from the tail
> of snp_rmptable_init(), which runs only once the host RMP table has been
> set up and CC_ATTR_HOST_SEV_SNP is guaranteed (it WARN_ON_ONCE()s
> otherwise), and drop the device_initcall.  rmpopt_init() keeps its
> original X86_FEATURE_RMPOPT-only gate and no longer needs a separate
> SNP-host check.
>
> This is soft initialization only - the workqueue and the announcement; the
> actual RMPOPT_BASE programming is still done later by snp_enable_rmpopt(),
> which re-checks X86_FEATURE_RMPOPT, CC_ATTR_HOST_SEV_SNP and
> rmpopt_soft_init.  An rmpopt_init() failure is non-fatal to SNP and is
> intentionally ignored by snp_rmptable_init().
>
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Fixes: c6c6f156d192 ("x86/sev: Perform RMP optimizations asynchronously")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/virt/svm/sev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index cd0412b9d251..39d3943cdc49 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -662,7 +662,6 @@ static int __init rmpopt_init(void)
>   
>   	return 0;
>   }
> -device_initcall(rmpopt_init);
>   
>   void snp_enable_rmpopt(void)
>   {
> @@ -726,6 +725,8 @@ int __init snp_rmptable_init(void)
>   	 */
>   	crash_kexec_post_notifiers = true;
>   
> +	rmpopt_init();
> +
>   	return 0;
>   }
>   
