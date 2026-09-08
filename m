Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010054.outbound.protection.outlook.com [52.101.85.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AE83AD506;
	Tue,  8 Sep 2026 20:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898904; cv=fail; b=QsX3uK+uN8d1VES3Rg/spzAGA+0mlzTBB7sxGvgfQdvvh5ub87uBR8Rv66YhwDboxTYOoqSa+fxv9lvPXk9w3k2RprrgkHJm6eAyxHMNLLV2NOsjzI73VFecyT9kkTP39c0cEl80fE0Qw+PQJKN8+qaT9kysBlbletTVeKCFvTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898904; c=relaxed/simple;
	bh=7pD6pARJdIJRZ00pL/L2SyWQaomwFg6znBtY5rXtcm0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cq1WBqOidQnC0x/S6FRnf1Nkt2b5wCkpHG2qqe48Vf9x/X7A3K85lQrdQaycUc7WX7GL5nWzjDYMNTbO6hxRb+CACYFawT4I4Py2JQr1utKfyKzHfthgBncOJP7Fae5//fPyTLhPwOlkv5VcDRLux3CMBEzgeqdt54RXhYdeWv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Wy0Xh/aj; arc=fail smtp.client-ip=52.101.85.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Wy0Xh/aj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nlSCTG2UuxYbJGGnIpc38Mpbtx/7p30Itt4CQqq6Qc0s3mbOHhsLipNYp7fxGQuknbByLf8FHdOq9rnmzfJxLtajwqchgNMDjatI1AQIrNHTN//e413ZWT+EURMzmfLZbULKjZeZvJsfc9ihvYqB9OomCXU5Rm+YEKSlIqdYvMuknSsj4nK3oG8jGsx3bk3RQt0KM24e9zR0C/qucguVEjfawwQkYtQB2FPFX8i+is6yyQyFKEy/PRAmEeVANp+a6YkUfVzr7slkb+bqhGWIFD7779JWk1fPhasvGlIhOAljqNgzTUXqMvl3Tqq5I+iPcUgl09qhL3Ua/ui/kg5sxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sR0EvDNjwTTfEJKUyvoPK03o+jSk5eldygJpyXob21U=;
 b=cCQO56iPsPR4F8EtKh2Ih1+2/isGII3oq8ZUXW+Z49J0TYc6uk2us820udKNzmDrqbZHiMaXLqnEg7MkeBL9QuCipUikxfwJ2iwp0CJXJW9jdLmJBxK9Mojjl1y+Vfh6D+MAxJ2DyGKhOoJuiNoJUvYt0DULptBAHBySrZnsr0i/Goeq5vrfwA9m5aG0z/75sRW32pyGZ75fwVaMgIc5cYS6Rpi4CF1k7lPIq8fDnQNP/gA7sj0lDqdkokflKI+g+rBS3u5tGj4Ibvu9+Gn3cXhPuI7bVXfo3UJeH7Uyz6mRWx3lVHtGNeSbNY+9INxXOTkHvPfnT/ArP3uwl8F52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sR0EvDNjwTTfEJKUyvoPK03o+jSk5eldygJpyXob21U=;
 b=Wy0Xh/ajal8bsQqHy/RV4YGzjDMN7EBDdNPTwssKe7YURi11FPQsLz03Bq1boFCR2X+RHuoT4vd4kG8sQSEwiuicRaq+XayJpudzfpWPXOFaWld1giVTPXvE9qEtd1pJIP8rd8a3bAHBZA6eMMXKCZq6cUv1GriYZlP/dh2e+oU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 20:21:35 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 20:21:35 +0000
Message-ID: <4b940989-1c27-49a5-8112-d9f991ad1d48@amd.com>
Date: Tue, 8 Sep 2026 15:21:31 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP optimizations
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
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1788296083.git.ashish.kalra@amd.com>
 <a31fc8c6d3f6c6bbe50dc4542c7091b0899d3e1b.1788296083.git.ashish.kalra@amd.com>
 <20260905012945.GPaptwicVjJ-SwXYzl@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260905012945.GPaptwicVjJ-SwXYzl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:610:e7::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DM6PR12MB4283:EE_
X-MS-Office365-Filtering-Correlation-Id: c9f573d8-7b8c-40f2-aafa-08df0de6c78c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|3023799007|10067099003|4143699003|56012099006|11063799006|5023799004|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Q2FfnsftOyWoIPgu7CulPRE9uzRDA/lgPQX7cBOiJO1O1et3Qq6BIO6xvZzIPwtMvOBprqsDjRIvdNfn6xG1cEMZrSADbbhM5jcbTKszUx/7iuTQe/T8GzKE2ZPNf7gy/mxm8JnsiOH6wL+xkE27tteM2se+rGvWKlirFsxkaYI3tOZ+7f12MRfpW1WfU+fGOTSApkDTXoOmJOrN1VCpjXXgKe/59oMtYE4EX5chmCQYh1i+8Po93qmKMWGQGqIQGyq2KsNbGO3bT3HAnETYzFmSnWV6X4+wdzFxI6Kr1ae8QzZs2NMlL7KB72tdNs6/TL1fDlhyVb+e0RzUMki/bsre6KVZ8TrDlJfr5X8AIAOsucutGKEWiQSmBoftale6eEeelDqIJyYZCKzeYKTiv17Mp2qvF7Mz60RmFzeUITPPmI59NGOlKnBTbWtOcDSL+UIZ7zQXnyY4xNMjXSf4hEeyw61v9vZb8MI6sPzMyhZ0IRqci4JWegYYs7jHFcrrl9ydwdm9QkzsEU+gtS44UQWYDALpnk6jgJPt+eyPrMyqIHiWoJCIWnSAQvX0+3odnLvtNU8GutTbDLxJbgJFc0HaV5mXwakFhG83PyzCA93FlM/FAqGbYrjdd2lQH8cJ2ho6XDmORhpDi+nvRVt/Yi9l6beWYrrAu1mImK7R4ms=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(3023799007)(10067099003)(4143699003)(56012099006)(11063799006)(5023799004)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MlkvQ1VaVWhBWUJDM0dLcXlNdHFWQkFYVzN6dE1vSVBwdUtqV3ZFaUowZHRj?=
 =?utf-8?B?QWdXcTRoY1VSYlk3ODNDRno1ZktvR3BDM0xueU1PaU1mTjFvRE56QU90OGxo?=
 =?utf-8?B?cmczajljOFlpUmM1MXllMlJQbFExUFA4RWpmQUY5bU96U2p3SFhhV1hHNGQ2?=
 =?utf-8?B?b3R5VytUblpQMG1MdE9SbW4veEZ4L3k0YVRLU1I5dTZnNXlXWlpuWTlYY0pw?=
 =?utf-8?B?YVlKUWh4b3FXWlhhVytneEtsSEYvUUpNaEJBWFNvZlMzamwveDl0b0N6Y2Fa?=
 =?utf-8?B?czN5TVVBNE9NMU1qVlE2SndicTZ6Z1VCSVU0V2JRRFRHRHFHZWNYd1hLOTNn?=
 =?utf-8?B?Nkg5NHBiSmhEWXgwSnZaSkMrY0txdHZJREtvQklGQTdSOFNJLy94RmYvVWFn?=
 =?utf-8?B?WXFLSjBOZ1U2cXdFM3dWN25POEZaUGNTOFVxQkd1V0RaZ045Y2Mxa016a014?=
 =?utf-8?B?TEFYb2hITXFvajhQcnpLOFRvKzBjaTMxMW1yOEdjMlFqR0wwSzdBUVlRU0pt?=
 =?utf-8?B?cTk1VWdjS2R5Vmk3MXozUGloNVY3M3k3M1V3ZDFsZmZybGlEV3JsMVlKbG1h?=
 =?utf-8?B?UlJqQkdBdEN5WERTRDlXbkF2bC9Pa2kxeFpwUkN5VVVIc1pGZ1Vsb1ZReXZ4?=
 =?utf-8?B?allTWVRRdUwwcjlydjlSUEZ2Ykc5RmN4UWlQckZYdWdia3JYMks5RnFwT0g1?=
 =?utf-8?B?QUhFTDRIc1o5R3hJandHSUFCUHBXUmh2UUVibE5mWWRBRnYvUGp0UjVGR2lt?=
 =?utf-8?B?VkFBQUtTY2hXUXpOck4rVXQ2MW82OFV1emxYT1V5K3o3R2hoTEFSaXo3dmx3?=
 =?utf-8?B?amJ2Z0llNXBKek1Ob1E4Q2lWeHQ4VlpkbnFBeHUrajNEQzRnN3JZRkQ4MnUw?=
 =?utf-8?B?YlhFVjFuK3ArYlprUVg0Mi9aMFBtWXZlVHhFVUpZN2UrUnA0U3JaNVFGNHlK?=
 =?utf-8?B?QTVpa2daU3czLzBmSG1oTDNlZ0c0d2pPa0ZOK3lvMXQwT3hvaU1JMk1TY0c2?=
 =?utf-8?B?NVZzVjBmbUNZODdBVmRuU1dUQXFERmsrbUJtMThtVHQwUUYydk9HZFFNYUJV?=
 =?utf-8?B?WVhQeldMQjlLK0VSRnN6M21DZEZ2dnBDYnZlR0ZabG9JTWdtMS81VElqcWRV?=
 =?utf-8?B?LzlzMzZNRk0zMjl4Q251OTZxdWFaVVEyVVVHYm5oSm9VTUhOTGcwT0FkVDY2?=
 =?utf-8?B?d2g1NzZBejNWUmlnc1hYWWlGMm0zS3hOaWZtUmo2R0VOb2tacmNwOU9QOE10?=
 =?utf-8?B?YlVUZUlmbjNQa1l3M3RYRG5WYWRYaFYwZ2NUZzNud0xBTE9HL3JtaSsvbTBO?=
 =?utf-8?B?STJtb0dhcjRON1F3ZUhobndrUk0vQW1lcThLSDhkV2Nmb0NnaWJqL2N1ZVlJ?=
 =?utf-8?B?QVBKZ0ZZZUFsYzFHMGNuOWc4dFlYL3ZBS3Z1dE9kUENNYlRCZ1JvSzVod3Uy?=
 =?utf-8?B?Z2lwcVcvWU1qdXd3Mm1zTWIrZXVQRXNhREJLWE5Pb041dFJNcGJlRkpJQlZy?=
 =?utf-8?B?VkNwMnZzZjFUMGhZZjRDY1MvV3piUkEzMDc0cEN2OUsrYUVHNjE5M0VMWGNZ?=
 =?utf-8?B?dUdWVHJrSnI1QUhEV1hPTjRpcmRDc2tRbzlUOWpwVXZlbkh1Sk9VZ1l0RWtF?=
 =?utf-8?B?WlNpcnFvdEJ2eGdpTm8vaUVWUnNrOWVBdEZOcHljbXNmNjFDYTRvKzYxWU41?=
 =?utf-8?B?ck4yYk00WlNzSEJyQUp3QU0zVktUUDYrTTJtNnNPaHo3S3lLL2tDS0pqRVZq?=
 =?utf-8?B?eklwNXhWYnBBMFdPS1VBcUhmUXVBSWpIZ3lPc0RycUYxb2NnbHJHMnNoTXZO?=
 =?utf-8?B?aU1ZMzdiQXJlVTdFelYveFFIb2Zta3E4NmRWT3lVejh1akRhbWZyOTRnU1Vh?=
 =?utf-8?B?cVhRbTUvbnl4aXVwaktLbU0yRVp4SUc3WTR2dUZXWmxYTXRJMzBIblIrbUNp?=
 =?utf-8?B?QkZZODc5L0V0RFdaTFByMk8xMnZPeDEzZW8rdytGWFgvMDBlekFhSGkwMFBC?=
 =?utf-8?B?cVVWWWtJNUsyWmw1YkZmRVViM2NOVW9xTW84eERkdWhVNDJVaytzdmI5NEpJ?=
 =?utf-8?B?YUgvZjRReS82SjlMUzVlRHJyUGZIelRhcFc3bnNjb2xRSjZWRGhyNytBY1NR?=
 =?utf-8?B?QkxDTXBNUC9qckNJT3hoNWZVakdhNU12YndHZzl3MmpvVEhuNkpoVUI0TEVQ?=
 =?utf-8?B?Q0ovSUduUlRON1o0dWcvTWVyUWJhdWl2a2RSUTY1cG92clBxUCtNWHQ4NDNQ?=
 =?utf-8?B?MXdGZTlaTldqMU1uUXRGUy9PM3k4Ly9JSVA2MUFobG9LWmhYV1kxQitZaG1y?=
 =?utf-8?Q?efPk05Kc5CE30GmYc6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f573d8-7b8c-40f2-aafa-08df0de6c78c
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 20:21:35.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hREltv1bIz4/USJqgncg8L4+YHayY6SBoTBXaBWLPoXb5PoZOU+lIrQ2jopP2w2eWTfCryQsZ+LTrMwBmNqi8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283

Hello Boris,

On 9/4/2026 8:29 PM, Borislav Petkov wrote:
> On Wed, Sep 02, 2026 at 09:28:57PM +0000, Ashish Kalra wrote:
>> Subject: Re: [PATCH v13 4/5] x86/sev: Add support to perform RMP optimizations asynchronously
> 
> s/Add support to perform/Perform/
> 
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> When SNP is enabled, all writes to memory are checked to ensure memory
>> integrity. This imposes performance overhead on the whole system.
>>
>> RMPOPT is a new instruction that minimizes the performance overhead of
>> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
>> checks to be skipped for 1GB regions of memory that are known not to
>> contain any SNP guest memory.
>>
>> Add support for performing RMP optimizations asynchronously using a
>> dedicated workqueue.
>>
>> At RMP initialization time, run an optimization pass over all physical
>> memory (up to 2TB of system RAM, starting from the lowest physical
>> memory address aligned down to a 1GB boundary), skipping RMP checks for
>> 1GB regions that do not contain SNP guest memory (excluding preassigned
>> pages such as the RMP table and firmware pages).
>>
>> As SNP guests are launched, RMPUPDATE assigns their private pages to
>> guest-owned state; when such a page falls within an optimized 1GB
>> region, the hardware clears that region's RMPOPT optimization and RMP
>> checks resume there to protect the guest memory.
>>
>> Since launching SNP guests clears these optimizations, perform them
>> again asynchronously using the dedicated workqueue.
>>
>> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
>> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> R-by's need to get dropped when a patch changes in more or less significant
> way.

Tom and Dave gave their R-by's on v12/v13 series, so probably i will keep their
R-b's.

> 
>> @@ -561,10 +571,26 @@ static void rmpopt_disable(void)
>>  {
>>  	int cpu;
>>  
>> +	guard(mutex)(&rmpopt_wq_mutex);
>> +
>> +	/*
>> +	 * rmpopt_wq is non-NULL only after RMPOPT has been fully set up: the
>> +	 * workqueue is allocated and the RMPOPT_BASE MSRs are programmed.
>> +	 * snp_setup_rmpopt() resets it to NULL if any of those steps fail, so a
>> +	 * NULL rmpopt_wq means nothing was set up and there is nothing to tear
>> +	 * down.
>> +	 */
>> +	if (!rmpopt_wq)
> 
> Now take your patch and rip all that gunk which destroys the setup work done
> by snp_setup_rmpopt(). Instead, you init things once and do not touch them
> even if RMP optimizations are disabled.
> 
> In case they get enabled again later, you simply reactivate them instead of
> doing useless setup work all over again.
> 

So, you want me to set up once, never tear down, on re-enable just reactivate. 

So rmpopt_disable() should stop destroying the workqueue, clearing the RMPOPT_BASE MSRs, and resetting pa_start/pa_end.

One thing i need to handle here: The current rmpopt_disable() clears the MSRs for a reason: it runs only on a full SNP
shutdown (SnpEn cleared), right before cpu_hotplug_enable(). Once hotplug is back on, a primary thread can offline -> online
and lose its RMPOPT_BASE (reset to 0, no cpuhp callback - which is only safe because hotplug is disabled while SNP is active).
If we simply stop clearing MSRs but keep the current re-init fast-path that skips MSR programming, a re-init after such a cycle 
could run rmpopt() on a core with RMPOPT_BASE=0.

So the fix is: keep the setup allocated once, but make setup always (re)program RMPOPT_BASE — then we never need to clear it on
disable, and the cycle case is covered on re-init. Proposed fix: 

  /* full shutdown: just stop a pending pass; leave the setup intact */
  static void rmpopt_disable(void)
  {
        guard(mutex)(&rmpopt_wq_mutex);
        cancel_delayed_work_sync(&rmpopt_delayed_work);
  }

  void snp_setup_rmpopt(void)
  {
        ...
        if (!rmpopt_capable())
                return;
        guard(mutex)(&rmpopt_wq_mutex);

        /* allocate the workqueue exactly once, keep it for the kernel's life */
        if (!rmpopt_wq) {
                rmpopt_wq = alloc_workqueue(...);   /* or use system_unbound_wq, see below */
                if (!rmpopt_wq) { pr_err(...); return; }
                INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
        }

        /* always (re)program MSRs + range, so a hotplug cycle across a full
           shutdown can't leave a core with a stale RMPOPT_BASE */
        rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
        rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
        for_each_cpu(cpu, cpu_primary_thread_mask)
                wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
        rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
        if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
                rmpopt_pa_end = rmpopt_pa_start + SZ_2T;

        queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
        pr_info("RMPOPT optimizations enabled\n");
  }


>> +		return;
>> +
>> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
>> +	destroy_workqueue(rmpopt_wq);
>> +
>>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>>  
>> -	rmpopt_pa_start = 0;
>> +	rmpopt_pa_start = rmpopt_pa_end = 0;
>> +	rmpopt_wq = NULL;
>>  }
>>  
>>  void snp_shutdown(void)
>> @@ -595,6 +621,44 @@ static bool rmpopt_capable(void)
>>  	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>>  }
>>  
>> +/*
>> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this range of
>> + * memory does not contain any SNP guest memory.
>> + *
>> + * @pa is a system physical address; RMPOPT operates on the containing 1GB.
>> + */
>> +static void rmpopt(u64 pa)
>> +{
>> +	enum rmpopt_op_type op = RMPOPT_OP_VERIFY_AND_REPORT_STATUS;
>> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
>> +
> 
> 	/* Supported by binutils 2.48+ */
> 
>> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
>> +		     :: "a" (pa_start), "c" (op)
>> +		     : "memory", "cc");
>> +}
> 
> 
> 
>> +
>> +/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
>> +static void rmpopt_scan_range(void *arg)
>> +{
>> +	u64 pa;
>> +
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt(pa);
>> +}
>> +
>> +static void do_rmpopt_work(struct work_struct *work)
>> +{
>> +	/*
>> +	 * RMPOPT caches the results of a RMP table scan in reserved processor
>> +	 * memory, allowing future invocations to skip such costly operations.
>> +	 */
> 
> We know already. Drop this comment.
> 
>> +	migrate_disable();
>> +	rmpopt_scan_range(NULL);
>> +	migrate_enable();
>> +
>> +	on_each_cpu_mask(cpu_primary_thread_mask, rmpopt_scan_range, NULL, true);
>> +}
>> +
>>  void snp_setup_rmpopt(void)
>>  {
>>  	u64 rmpopt_base;
>> @@ -603,6 +667,34 @@ void snp_setup_rmpopt(void)
>>  	if (!rmpopt_capable())
>>  		return;
>>  
>> +	guard(mutex)(&rmpopt_wq_mutex);
>> +
>> +	/*
>> +	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
>> +	 * with x86_snp_shutdown=0), snp_shutdown() and thus rmpopt_disable() are
>> +	 * skipped, so the workqueue, delayed work and per-CPU RMPOPT_BASE MSRs
>> +	 * are still set up and valid (SnpEn stayed set and CPU hotplug stayed
>> +	 * disabled).  Rather than re-doing the setup, which would leak the
>> +	 * existing state, just re-queue the optimization pass to re-optimize any
>> +	 * memory the previous SNP session de-optimized.
>> +	 */
>> +	if (rmpopt_wq) {
>> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
>> +	 * RMPOPT workitem on the global system workqueue.
>> +	 */
> 
> Why?
> 

A full‑physmem RMPOPT pass is a warm‑up scan plus an IPI fan‑out over up to 2TB. The default system_wq is per‑CPU and concurrency‑managed,
a long‑running item there runs on the queueing CPU's worker pool and can stall (or be stalled by) other work on that pool. So we wanted it
off system_wq and use a dedicated RMPOPT specific workqueue.

Another thing i looked at is for long-running unbound work, probably the standard shared queue is system_unbound_wq, which is probably built
for this use case and won't clog the per-CPU system_wq.

If we switch to it, there's no workqueue to allocate or free — the setup/teardown "gunk" disappears entirely (static
DECLARE_DELAYED_WORK, queue/mod_delayed_work(system_unbound_wq, …)), which satisfies your "init once, don't touch." 

Additionally, with system_unbound_wq and a static delayed_work there's no pointer to guard, and queue/mod/cancel are already
synchronized by the workqueue core, so rmpopt_wq_mutex can also be dropped.

Thanks,
Ashish

>> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
>> +	if (!rmpopt_wq) {
>> +		pr_err("Failed to allocate RMPOPT workqueue\n");
>> +		return;
>> +	}
>> +
>> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
>> +
>>  	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>>  	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
>>  
>> @@ -612,6 +704,23 @@ void snp_setup_rmpopt(void)
>>  	 */
>>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +
>> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
>> +
>> +	/* Limit memory scanning to 2TB of RAM */
> 
> No need for that comment - we know.
> 
>> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T) {
>> +		pr_info("RMPOPT coverage limited to 2TB; memory above 0x%llx not optimized\n",
> 
> No need for that print - nothing we can do about it anyway.
> 
>> +			rmpopt_pa_start + SZ_2T);
>> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
>> +	}
>> +
>> +	/*
>> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
>> +	 * optimizations on all physical memory.
>> +	 */
> 
> Drop this comment too.
> 
>> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>> +
>> +	pr_info("RMPOPT optimizations enabled\n");
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
>>  
>> -- 
>> 2.43.0
>>
> 
