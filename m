Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB171E22F3;
	Fri,  8 Nov 2024 17:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731087902; cv=fail; b=RLpyQJiuJeFfx2Cux9WDtOd6sllInmLz1V13JDmKeWHB6+xnso+IISx7Iy/PbdvvxQmpSHZEL5Pwbk545oYqbxsNn1ltQz8UcUuL/D0YgMaqzBIMUtqAiHnDQVx46Pyj8fBCGU9S40li6h/Jrvrd8KJCvT/9QxH+Q5veT0qm/hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731087902; c=relaxed/simple;
	bh=9/lrr0VnOvDyRuFXN66bWjeNmUb07hcy4Na1tUKb1+Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lDesxJJFKMp4RF4kjuk+cXaFdjnI7wO1GMgP+LLLBFv1gCKZEOeeHr8MRmRqg2ByEqJVwEhK8C9V/wouyXxkWg0AD0L3MalRB649njv3NyIUIpNDAygSXnNsmy2+kS81kBsfwAyDRns4mt34rgMUJ/fFC6M0d91lfXX6eOxvqag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wf50k063; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wf50k063"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=taNDMLNbh1xTUpudN6gaBY7z72yL0YvhQhW1Sav15ohF5F2sp0WACaWQ85ycgx3hdSYa6+TC6mKrvzTwqUjhowSupTKbpMhcBjuSW0IMuYDcGb49+iG2bx1pxtfN2Slov105GHW7EB+v8TIBAqjk0I/XRe4KGtR6OohzhxKEKyybQX3AEFon8iCeWgMUUbeTGX1hkhUn9uk6GtD5Mvryshn5dCWjJkn40PYBhydA1k1lq6EgrBhLXReEyYyYPXUYwW0EueZcQevYHRtyulQjludQdyMP/GVxCozVsiiDdYx8GLuSv1yOs/EMcO9KXRGD72127h/7fw2ZIeEPs5BrTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W64DYr3OaidM5hZZcjkwkAZBOhaEHO+VZsW/2AKJ9ZI=;
 b=dkW7O919jGfWq1R2MJxMGjbfgn+QMFocjVsxQT802+xHc5NDWsa1gaQzNmldtZmLFh5ntG6bCxAqYi5QfSC/DZyUNYaMK9axmoBRg0eM44IO3hTkHStkiB3UGlEF3EMDrSYOFpLJZKhKaeNisUgnXQchlB+CS+hfjBfVGSmdxbH6DKrhEWdwQoNei2TaUN4km+tS7K0bOFAu0YF99cPetvG6LchVp8062RM3ycZEWfc+buvtza8xcjl+CIBaDlZYpR9FLA2d5/9Z4o8rR7XYPIpFSoVSGdhBlrXNIWU551gqWoSMR9jvtlgDvSYSPFY/hZYkW+deWvxoX+30uRAM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W64DYr3OaidM5hZZcjkwkAZBOhaEHO+VZsW/2AKJ9ZI=;
 b=wf50k063zcaSRZ9xd45FP+LlcxLQTouCDtSgfr9I+GJLc+QrpnhE7kpr6BFfGH39fvQ10XRgA9Oene08kAkkTlkX4HRcbLlPNQmzfycCWvdSIXmG9rw23eYfi/a1cjQst2fyAuS1NkPMfv+N64FhwdfKY75bz1MTsfDwuITugLE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB6957.namprd12.prod.outlook.com (2603:10b6:806:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Fri, 8 Nov
 2024 17:44:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 17:44:55 +0000
Message-ID: <b726e3ba-7218-de96-f986-207fd749955e@amd.com>
Date: Fri, 8 Nov 2024 11:44:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 06/10] crypto: ccp: Add DOWNLOAD_FIRMWARE_EX support
Content-Language: en-US
To: Dionna Glaze <dionnaglaze@google.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
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
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241107232457.4059785-7-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0150.namprd11.prod.outlook.com
 (2603:10b6:806:131::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: 84155287-4891-425c-4657-08dd001d0e62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0QxOGxyT1RrK2dCZUFvenA1dFNML0Fub2NMNjZ2RGdtWUcyaUdSYy94cEww?=
 =?utf-8?B?NkovM0FieDFaL3RvbEY0YUh6YnV3ZzNZa0h5WVl4MzJ6Ync1Q2Mrd0h1R29p?=
 =?utf-8?B?WnJnelBhZVg3RkR1QzVaY1EyL2RiQXFvc2hLQzRkY2gvTFVJV0FhWGt2RkZB?=
 =?utf-8?B?UlJVSEF3YzZHcTZRYVV2NzFuczd4YlRtVFp4bWZldm1GMnhVVVBtWFhLTisv?=
 =?utf-8?B?VUlpWS9ibzM4VzU4cTVQSEhYMGtxejdycm82TUNIQk5GMnJLN1pMWm1xSTcx?=
 =?utf-8?B?SnZQQlFtd0J6b2VwWlVkNmNoUzVzbWQzazBnS1J5MzZhc0xpdXd3OUgzQmJ2?=
 =?utf-8?B?VnZEVnFXTkdXSGhqaDlBYUhqL1M5RGVwQ2dNSCtaMWpoVEpEdnNjQXZNQ2cz?=
 =?utf-8?B?cnQ3SHgwWkxIRVVsMWZWWkJaRkhsTmNCZDlsckx0MTdLbUUrRGYwVlFpaHhx?=
 =?utf-8?B?WWM1NjNzRkYwODFCN3ZIWHMrQjdlY0ZiVXJwZkpPeEQyenNvUFpWZG81ZkFr?=
 =?utf-8?B?endzQUhrNDZtUW8wYlZPSEJRcUJyRzM1ZVptdFA4WFZqem1oVFJaSk5pcnFS?=
 =?utf-8?B?WEhNOElSUFQybXJqZFhzK2FXZ1VDcWRPY2RIS2hLd0NsenFnem5JN0Zzb0VX?=
 =?utf-8?B?M0hQTzgvaXczK3JHMlhJTTRPaXluRHAxbjRYR2QwMVdCcmpuckhVOEM2NndE?=
 =?utf-8?B?aFpmTHV6Z21VOUg4dDAwU1lRQXIrVXZYVU9Wcy9nSFpMaEVHQmNSSjliMm9D?=
 =?utf-8?B?bHA3a3FzWFdHOENJbit1STJrRTVYd0dkclRRbUF6VW9iMWltMVc3Mml4NmlV?=
 =?utf-8?B?c1puMHlDbEhEVmhkYVc3azdyUWRuSVFJa0p1Q2ZCbVJteDBJaGpQWGNQdEZF?=
 =?utf-8?B?VXFaV0tqRk1uT2ZJblA4TXRRNTZMQXJyUS9YdXkvTnM3cUF5WC9PNXhtcEFu?=
 =?utf-8?B?am5MMmR6TlM3SEVteDRxbmxnZ3RXMUVTWUtwN2ZvallJZEtVMGIybEtQOE0y?=
 =?utf-8?B?bUQ0UEhNUzdVTEFpVXJEMGpOSUZqUllSbDVGeEc5UG1tMjN1V0tDTmE0RFhN?=
 =?utf-8?B?TE1HSHFjVlBtZURDckllNUJGVHpjTndubWp5aS9wa29YMXErSmd1bG9NWmw2?=
 =?utf-8?B?NitSYWxVNDRoQkZCLzlWdk5jcnliWlZhVmNGLzlSNm1QV1VtdnlWeVMxNU9B?=
 =?utf-8?B?MUVvVGJBaGNVc0tnRmwydlVxQnBJZzBIem10K2hVdE1HTjUrcTBhR2s0aW9v?=
 =?utf-8?B?MjhJbzI4eXlLTjJ0Y2p0MWh5a0J0RG1DMCtSbXVGK2NGZkRPUkp1Q1E5Q3hF?=
 =?utf-8?B?dUVselVEeDRBS0IvMjFmc2t6MlVyMWhnNWtDWWJrN0dwUWJ5akxaR1FheHB5?=
 =?utf-8?B?Und0blNvNUJhY05GRVJkQ1Qxb3lnYUoxZThEc2VaQnk3VnFvTVNQQzlnTzJX?=
 =?utf-8?B?RmwyYW9mcDNqalRlTENEczRqcE1MQzlMWlg3TGNnOVVjc0FCWGlMZzF5bWhF?=
 =?utf-8?B?c1NURUkwK2Q3cG5KdTgzQWVSSG9ZZ05FY0hScEIrRnhrQzREQWFJbnNRSGFv?=
 =?utf-8?B?ZUNEZ1Q4RWd5T2ZqU3Vpa3BWQnhuMEJJeW1UZmlMbEc5K0lXNXk0NkdNR2Yv?=
 =?utf-8?B?dmVPSTlwRUZMUUZwMUxaUlE0bGkxOTc5NXVacWJ6ZTZkaFR6bFV6QzdPeUYy?=
 =?utf-8?B?MWQxWVA5enBZR1Q2M2gvdEdMZndabkdmdkRvOGpUdFBSZDBSYTRwU0dRQkFJ?=
 =?utf-8?Q?c8GzBRccSm51HIcYqCTOO7d2GPHVWVrMh5Dusie?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUg0WEVpQkNqM0VkQStuVlVwZXFIejgzRHcvT3pmMzZ5YmhxSklHNUVqSnZK?=
 =?utf-8?B?ZGhNYzlrQUJiTzFqY1hmZkk1dENjN0hpLzhCOHQ4Y2VaaHBIY21ZaE40VUsx?=
 =?utf-8?B?dXp4STlUNUFScjh3d1FMMk5QWGtjUXEyQ0VpZXFIT2ROUkllMmtXdHJ1TUxr?=
 =?utf-8?B?WEwwYXl0Q0VrV1hHVGdiNDJlNFo2dVk1RUIvdkpjZlM5N2pBNGVJeU5yNGNK?=
 =?utf-8?B?Q3FxcHI1VnBCTzlvWDNidjBiUjAvMC8xTWkrbHNEQ1J0Qythdk9BU251d1Bs?=
 =?utf-8?B?WVJ6SGU1VnRCTFJRc0NBSHA1M2hFVnNSR0c3eWFBMjFqU0VZR05FZEdWQThh?=
 =?utf-8?B?ZDhSMXlDK0NWS0FvclFZWGEvcFdQeUFNMkxQam9tdHNZOHRjN2tvNnVjVVRT?=
 =?utf-8?B?ZGNrVS9mSjJxY2hzd0NLMEkwUkhUUEpNUE9kVGh5TURMbGM1T3RMUmxad05N?=
 =?utf-8?B?MUllLzBHSkNna0NvNC9YK0lDZTQ1T3JubTQzUnhEUG90b29HcUJTcms0dFh0?=
 =?utf-8?B?dFRPVkUyQnpUc1dJVXc0UDlSYXlyeU54L1BGSTFLdys4ZDA3OGFjMG5BMU5a?=
 =?utf-8?B?UFM2N1JleWppa2hUUlJjbnlMa09WY2luT2Iwd1hLMnprUStwZlRiaGg5VXov?=
 =?utf-8?B?Zkk0azU1WDF0bU96MWRlcEZ4TlYwcG16M2xVRUxPTVkydDZMVGYyRFM4czFp?=
 =?utf-8?B?U3JHS2VpTXZHRmhLSm9ncVZsOWkyc2ROOHFVQ0wrV2t2bnZxb2t6NkgrYXhi?=
 =?utf-8?B?MU1Pc1N6MkgzbENwZklJWnF0ZnNpdklqUktJSnQrV2FINmFHOXRRMjRrb29Y?=
 =?utf-8?B?MVdwbElVU1hrcUdua2RkQm1rMUNCVDFvUm9yV0JsTWdBc20zRTVYZXhKN0V1?=
 =?utf-8?B?NGJJai9lalJDK1ovemNwM0lkSDRxdzZuRUF2SGNnNEIzeFlJb0Y5TlgvZk5W?=
 =?utf-8?B?Nlgvb0g4c2VOaWJzakxLUlFsMnBiQzdtNHJmNXJPK3JaQzhjZ0EyMXN2RVdJ?=
 =?utf-8?B?UG53S0dNa056Vm5Gb1R3VUV4UklLSjlLM2ZkcXJGa0IyTS9NYXJxZWlEb1BF?=
 =?utf-8?B?VHV6ekx1cnRCRUt2bVZJQTZrUWxVTXdyeTJQTmhjNXdMNzB4T1dHZVFFUHBP?=
 =?utf-8?B?UFNsZU81S29mVVY3bWZjcjluc0doSElMc3BGbzRJbGpPYnlidEpHRFdqejZi?=
 =?utf-8?B?NklMMktFUDdSYjI0REJ4cERiakMwZ1pGUHN1TW5zdnllMVJ2S1JKNEVTOXBG?=
 =?utf-8?B?bmdNcTlYV1VhU1lGWVAyemhQb3NqckFUNFJQTzdhNXBHWk1sWnUzNTRPQlYv?=
 =?utf-8?B?eGgrK3pUSTFqeFRlZDN3a0thZ2ZKTUphdUhjZ1B6Q0czakdZK0x2QWE2eU1C?=
 =?utf-8?B?a2lRZ1VHOHBTRWl4TG9XRGMrKzBJWXJNckJmQzdtZHFvc01EY3J4SjhZRlBn?=
 =?utf-8?B?WG9CWTNxckZGOGlVWDc3NVdpZWRyRElEZWlOOWlMNFBtT0dIZ0h1WUhTK3Jn?=
 =?utf-8?B?aGNCZk9iMXROdTkrNjNnWkZDN0RkMzl6Q2ZLdXNkcGx0ZGF3NXFMaHRjc0Iz?=
 =?utf-8?B?T0dUN1d1OUhXeGxkUXJzNkpCbWdRZk9KOTNUVFF1am1UNmxQeVdhN0pUNlFX?=
 =?utf-8?B?NnNtd1h3endldUF6RFZ3WFhEUVJUcGZ4RytLTjN2UEtoS1g1NXVSUlNZT2xI?=
 =?utf-8?B?VmV5aXhrdkJuR0JLbUZWSjhEQ0xOWE5TMTVjbDNOcFFEWWdha0xuemo1RzlO?=
 =?utf-8?B?cWpST3NYTDRjZjFiSHF6OUdoY3RQUE9BR1EzSUdscjNOQUdmZVF5Wm1LR1Fa?=
 =?utf-8?B?RnRwSlc4TWI3YXhSc280ODkzTHlxMmc5YkljR29sOTNzcGJBd2c0NUFYMjlI?=
 =?utf-8?B?eG1iWnVUa1d5MDZITEdYbVFpQkp5RmhmK2xVdHU2OVgxaWhPN2lVTjBndWkw?=
 =?utf-8?B?bFh4NkN0eWo4Q2kyS0ZnVWpGOUcvWE1GT2gvZEJoSHo3T1loWW02Mk1nZThG?=
 =?utf-8?B?RDFTZVk0SHg4QjdiOS8vWURoL1ErcDljTHVqR0lEMG54Y2FHazJSUW5qVWNl?=
 =?utf-8?B?L0t0UTNUK3hWOFE2b1h2RU4zdWJ2WWZRaFNWeWJlNkpLbVVLaG43bkIvSUlW?=
 =?utf-8?Q?3Fm6ZL1nOEPZy3LxLz9klY1jo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84155287-4891-425c-4657-08dd001d0e62
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 17:44:55.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZNgAPPksXTChUJ6gat+20G0P4CMfzdApaC9jdYS3UiiDheRTorCoCuzsqGPA3XLcmB1bHiOwLm6ZYG+2yPpXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6957

On 11/7/24 17:24, Dionna Glaze wrote:
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

Please put a comment here on the reason for this call being here.

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

sev_snp_init_firmware_upload

Hmmm... I made these comments before but they haven't been incorporated.
Please go back and check all the previous series comments and say whether
you agree or disagree so that I can expect the review changes to be
present or not.

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

destroy not init, as commented previously.

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

CRYPTO_DEV_SP_PSP_FW_UPLOAD

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

Add a blank line.

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

Move this above the start of the data_ex assignments.

> +
> +	ret = sev_do_cmd(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, data_ex, error);
> +

Remove blank line.

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

How does this ever get set back to false?

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

This comment seems stale.

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

Add a blank line here.

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

Remove blank line.

> +	if (IS_ERR(fwl))
> +		dev_err(sev->dev, "SEV firmware upload initialization error %ld\n", PTR_ERR(fwl));
> +	else
> +		sev->fwl = fwl;
> +}
> +
> +void sev_snp_destroy_firmware_upload(struct sev_device *sev)
> +{
> +	if (!sev || !sev->fwl)

!sev was previously checked before calling this, so you only really need
the !sev-fwl check.

Thanks,
Tom

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
