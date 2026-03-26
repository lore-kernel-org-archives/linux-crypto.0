Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2107224466C;
	Thu, 26 Mar 2026 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774485709; cv=fail; b=FbXFrnKE8n3y10RXJ1PEyMx9hkI8LlNTynKBILC6YMiQXzTfKsxiWAJcuEwPeVEavOyipwe6FNq9cMy3PQ1QM9sHclYBvr2TxohrExYLMdViDyBY1jYuySIuMvmlkYySOSv3NHZC/f8TQVgyOdO/TNX7JOBBhAJ4XLs5e1flGjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774485709; c=relaxed/simple;
	bh=Vlaa4LHgK27wE6EwdU+VlrDqnWPC9QzVW02wWT4jU3w=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WMwc2dI8VoYfJkZBIOo/uCvcLLEf64px7mjMS/NvlkytnVr3yPRCFxBGDbm8+iDHSsk78S1MuET57FoZ2XD7S2D02UThK3gBN0xsTNzEsgRa6fMNSe+pxW3pkjh6oPTzIoOsV04Amq4RL8B+dENO3UM8y316rF1zzyCuaYaeBlU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=MB1A1WWg; arc=fail smtp.client-ip=52.101.53.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="MB1A1WWg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dAwmkLL6HiJn3J3pqVFB7Z0ukl67BwArqoShucm95a4+JPTo9KDM9sGgD38aGMcP6pm3x6RhBdb8VIZ4SDP5AcwXfrPCATWUJV9JwVCB0vJVgpIBPnkXJss1ppRAmxpDi3c+sChQIg9lipbn3/Vpj+2REZTsCaQMxortd/owaCL6+ETQaCIhOqh+ZU10fDFoQu+HSNclGuFpu94ScbVvv4dP+e3bsh59yAEJFKuIRcqo8o3x51smBFuLWI6D7aJkUkgLfh/wOt24Umbph/NiQ7hNlLIv0OfYkC8h83imRS+9VAb05YyEcd3eWIrwG5RTNKZUFenx+Vtd0eg0i5sxcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vlaa4LHgK27wE6EwdU+VlrDqnWPC9QzVW02wWT4jU3w=;
 b=miGtAzL+Jl2rmsdng7Iu6oUYYNKOo/pwCsTTVWcwCy6GB1SDXzsG3mhWiWxX+ce4MStjJtK86vmOZ3MnsRiasUA0ub6hLMYbGIr+lvZ99PokqXsHnbdw0t3k17vT8k/YdLzWbiQDJANJ82M/yKvmMy9tUZuo1hYd+8SEsQ9GzZyNtDG4uiCMf+lao0abW9vXkrYq9ldldmz+t9da2mQyYjBeiG88tS81B52tAU4QoJkUvTemxJzbOtY6XqP3O91RfBFQCmq8sx3nQ2VPhFd4dxmvLJvRzrUtCI343j/Xxjz3EcmHMftopnhrkGiST6qBgRrThx59dNMOFcHxqkQiJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vlaa4LHgK27wE6EwdU+VlrDqnWPC9QzVW02wWT4jU3w=;
 b=MB1A1WWgjZh4KJuDbY/pwwnrlclmtehP3yPKZZkQ0Ek8i54bvvHp6+1GOk1g0Cvys8gkIqXSWS3xUb5ZG7wDK0F05OWHTlDXki6ped4wA+NfRbj2Adw2U2/+C+47fBqqZqSAHZqDa79ZFWFzOZaPhtlXfh1qtU5YtzkuzzwUt/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by MW5PR03MB6878.namprd03.prod.outlook.com (2603:10b6:303:1c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 00:40:32 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 00:40:31 +0000
Message-ID: <dc8d4117-3089-48bb-8911-b4d64481fc44@citrix.com>
Date: Thu, 26 Mar 2026 00:40:24 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, KPrateek.Nayak@amd.com,
 Michael.Roth@amd.com, Nathan.Fontenot@amd.com, Tycho.Andersen@amd.com,
 aik@amd.com, ardb@kernel.org, babu.moger@amd.com, bp@alien8.de,
 darwi@linutronix.de, dave.hansen@linux.intel.com, davem@davemloft.net,
 dyoung@redhat.com, herbert@gondor.apana.org.au, hpa@zytor.com,
 jackyli@google.com, jacobhxu@google.com, john.allen@amd.com,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 mingo@redhat.com, nikunj@amd.com, pawan.kumar.gupta@linux.intel.com,
 pbonzini@redhat.com, peterz@infradead.org, pgonda@google.com,
 rientjes@google.com, seanjc@google.com, tglx@kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, xin@zytor.com
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
To: "Kalra, Ashish" <ashish.kalra@amd.com>, dave.hansen@intel.com
References: <a1701ab4-d80f-496c-bdb3-5d94d2d2f673@intel.com>
 <4ec520a1-68c7-4833-9e8f-edc610e5fdfa@citrix.com>
 <48f11469-6435-4f3c-ab67-705ad730b042@amd.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <48f11469-6435-4f3c-ab67-705ad730b042@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0121.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::9) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|MW5PR03MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: 0343cb96-a289-41ac-0d2f-08de8ad04918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	v1byWSP2kWlmE5vtt/60Qzc2u9xYWVx/YFz6nsb+/zDxurCCIOyAhxC3emmoIBpURoXZzFuX4T+r2oqltsj3vYRkg1/iKbXebsmQ8DxsX0p3L2bUWJsHWF61cQm1oyiHWmRIboPfSEOZYWakHgzBJNSvrVjjfZf09f0EFmUh2ad7X5dthee8vXrCq5e/Y0pLO29teOYo2HlgsEKw4SJ+t4lzBSm/xOJBCn97ECeZ1NFF7jb/AkgRTI8iTrPr9U+u7VfjyZ+20oFx97i8Xe1cTc2cq5jk6vZvRxjmas4H5bJ+0NdzhQAiUK7LUXPu0pBXFriKneZsQB5SEtz/lJB/671gqQL2/KK8YcV6y1VnhNqDabpSHXmD2umLp0mfr0SMayNY+iOKGzm8jwvq4RISvJwaErw8hxKecPuObSAOV1+QykMUaPPAvaAEH6ZCAd++glXxVGGPgMlH3w19cWupRK+svAy96kINnXnlN4Av4t9MwSXw5K0J2Fp9b+UZZppAar3YbSmbEEoejoVtOIgq6c5gggWX+b/BL4qfn7IOPcuMwILBoGMf/paQIPe/9kElx8h/KFoGHMHJXSTTZb8+up7qeFVNr3ZkLjaN9NaqJ3zLRQutZpSvVrHR3pZmX1oP2wUNCCrJ/sPqK/QQykkz9BaMHXzGcbO2JRsAIcQt+t0+DMkWysfVZ6QwbCW0bNo7h78l3VaT8427BaMB1zmWlnGuEarQLDr9bDNKGokV9U0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1RaSi9wNVN0Yi9Gcm9kRzl0UFcwejRIYUVCZ2F5b0R6b05mWmxBWTRqRlRk?=
 =?utf-8?B?eDArc3JCQk5XaStyeUVyaFp1Z2YvTXdxV1p2Mkg1NFNTMHlVdTBUQjcwME1k?=
 =?utf-8?B?R3R6N1lFVkFtdDViaFhIK1JidlhnQWMvWTY0YmVsY3c0T25teFNuK1o0bldP?=
 =?utf-8?B?c0FpK0dsYXZZT2lqdTZEbCtvRVZIZG15SE52cTd2Z3FhNmJTZ3FPZFVTUkZP?=
 =?utf-8?B?REYxQllKME1YZVJOWElwWFU2SXBreE5kYUFsMTJyaENxTEc1N1NGcC8wRUpW?=
 =?utf-8?B?bFYvU2pvUU1uUVREaDZ3TlBHcmMrb1gxWUdCeU5pT0crc1hncyt5L3hJOTU4?=
 =?utf-8?B?SDVrc2hFY1V5VEljaE5FK1hReThRMkRnSDVrZ01lT01teEpnWUFlM0FYOXEw?=
 =?utf-8?B?cThMUXZrV1hLTVV5SU9PY3RTQzVxdVpNSG5iYlFLOFNrcUxzb25tWWJqUkNG?=
 =?utf-8?B?T1FINksxczV3alRaQXlBV3lrRUJPYUwyT3FrdnloVThuci9FaFpDTU9QTnFm?=
 =?utf-8?B?djR6R3hrUXliS3lsa29pSnN1RVgyMGZ0enI2Zy84YnpQQVd3TGlEdmlKb1Zj?=
 =?utf-8?B?NnNTUVEyKzd5MXlwdUdlM2FITi83NWU2SVNZeHNiNDdZMmNFaDliWFhxbHRV?=
 =?utf-8?B?ZkdSYm5MZEUwY3B3YzJnRW95QytLcWRuNVd2QkNoKzMzeFEzZnk2ekQrdjE2?=
 =?utf-8?B?d2NGMzJVWndySVBRQUl5eFRBeUJsV0Jvb3gzZ09GNUVjckRzYnZPbmZHZmdC?=
 =?utf-8?B?K3NmaEE3YUt0eit5a3l3d1BCRjBHRk53S3VubTRPYmFLeExBZk5IZ0ZvY0xr?=
 =?utf-8?B?Q2NGcGU5WDdUaXprYkM0dG1pMldKaDVZTHFlbXdYWjJHalJlVlBBOExGeXBr?=
 =?utf-8?B?Z29UQU4vaDUyVkpTZzk1bEdFaWxRNkVJbklTZDk1SUNOZktOTmIyaFZmZG9o?=
 =?utf-8?B?eWR1eDd1NHhUTWo2VWJXK3c5N0JyamdINGJ4TDg1ZlpaN21wMXN5V1NUQWZj?=
 =?utf-8?B?eXJWdnBJSEdrTWdWWjhzQW83V2pOaDVmNThBa0FHS24vVEcwSmoyMHVpNnRZ?=
 =?utf-8?B?WXJNdlJrOE1aNTBkeVd6U3pEbmc1a1dOMlVIRjJKdzI4WFZxckhkQXRRc1ZN?=
 =?utf-8?B?M3h5Y1VrblI2QlRoeG9LMDVKT1lLY3g2dytQRnJRb1V5b21kbWE2Z0I4SExU?=
 =?utf-8?B?RnJhSGtTRjM0cXZKN3FBZStVQXV3S2VaZjVsNTdUR3lpTjN5elhxSXJScUdi?=
 =?utf-8?B?aDJJTDBqZHQ5dEJ0M0F0RS8xcXdDODB6aXpRSjBNVXF0U20vNUI0NVlQRVBt?=
 =?utf-8?B?OXhyOE1RdDRYWkt4ZlMzMURHcCtxWGNEbXdOWDdsSDc5RWFlWVdPRUNoU3V3?=
 =?utf-8?B?RVkrRzVWRkRVNEhtVkJXTTAvaGdOcnlWZnI3NVFNeXRsb2xjUHZJWEpjY01J?=
 =?utf-8?B?bjdTcFpmRkhLYUZJYUhlckxhMXR0TWc2NlJuN1JFSFJodzY2dFoybHpleHVo?=
 =?utf-8?B?dHVSUVhrNHUzQXpQZFJKaFBTdlIyS0sybGhXQlh6Z3BGMVQ0WFlFMGFVUURn?=
 =?utf-8?B?RHVYdG5VQWljS0p2b3NicU5GWEhYL3RFYkVZMlR4U25NZ3pyN20vQXJqZ1Ba?=
 =?utf-8?B?NXVaK1lxVUZnRWJzY2Z0MGpNTFlzZHBOcU5Lb2cwampJdFh0OFZDMzBZWElV?=
 =?utf-8?B?eUN3Rm5LWlJ0ZWFUU2RBT1B4YWJaYklBN3RkcVRZQ25jWEdaS01xTFgzWTFz?=
 =?utf-8?B?WWFjckdWdmdlL0hZdmlYOXdrSUU5SjR3RTVWRVA4dmI0RXl5T2NEa1VXNExY?=
 =?utf-8?B?bWYrOGVQQXhpcUYyb2dOZS95bjhnOUx2Ly9hZWZvTElGL3Q4Ymo4ZlorSFp4?=
 =?utf-8?B?b3lHNXZ2VXQxWjBCVEI0TWxxR0RGNGwxeXVTZDhXSUs3RmhTRHBwaUtpTFJl?=
 =?utf-8?B?U1AvMmdENmtLTDQ3NUg3Y2Z2WXR3N0tYSzN6Nm5LajJ5YWVpNWp2TklsVjFJ?=
 =?utf-8?B?b1VQUDF3bzFNZWNBcUFmUWphNnNUdjBMZGZnOElkM2tKV1ZwZGxRS3I1SXla?=
 =?utf-8?B?RW0yUkxLRFBhR2tIWDNRaVJFYmxVRTZpTUV5T0FzTHV5MXRJZE8yYys5ck50?=
 =?utf-8?B?QzRiZEwvTFBKbi9yU0NuanhjaTVtR3VwaTJBUW1PK1czRTFyL0NOdDJVWmZR?=
 =?utf-8?B?OWRQd0tZbTllaC9tazE3aDVGRlF5akt6SGd4c2lTbENUUi9yZ0tMRzFld3FS?=
 =?utf-8?B?SkVBYXp6a05zSGM4SDVYSjQrSlJ4ZXlPbzlsQ1A2bW5TQytNV254VzJsRU40?=
 =?utf-8?B?OHlya2VjdkpHL3BCZVg0bE93WkZSY2p1QTVtZzJzMGNRZ2gxMWdITjRsU2Rh?=
 =?utf-8?Q?si6NPsiYLv+3yQ/o=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0343cb96-a289-41ac-0d2f-08de8ad04918
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 00:40:31.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpGYn6E+J0VytbXs3zkJSy5mUilZqiG4u2czYRwugyg/hmbm4l+R0eDpBSpEsfnCJd14Fho0JV8xsjpVY4seAex9Sh99G68TG3R8kzYmaqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR03MB6878

On 25/03/2026 9:53 pm, Kalra, Ashish wrote:
> On 3/4/2026 9:56 AM, Andrew Cooper wrote:
>> It should be:
>>
>> static inline bool __rmpopt(unsigned long addr, unsigned int fn)
>> {
>>     bool res;
>>
>>     asm volatile (".byte 0xf2, 0x0f, 0x01, 0xfc"
>>                  : "=ccc" (res)
>>                  : "a" (addr), "c" (fn));
>>
>>     return res;
>> }
>>
> The above constraints to use on_each_cpu_mask() is forcing the use of:
>
> void rmpopt(void *val)

No.  You don't break your thin wrapper in order to force it into a
wrong-shaped hole.

You need something like this:

void do_rmpopt_optimise(void *val)
{
    unsigned long addr = *(unsigned long *)val;

    WARN_ON_ONCE(__rmpopt(addr, OPTIMISE));
}

to invoke the wrapper safely from the IPI.  That will at obvious when
something wrong occurs.

~Andrew
